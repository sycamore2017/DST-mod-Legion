local prefs = {}
local TOOLS_L = require("tools_legion")

--------------------------------------------------------------------------
--[[ 通用函数 ]]
--------------------------------------------------------------------------

local TIME_MAX = TUNING.SEG_TIME*30
local oppositeBuffs = {
    buff_hungerretarder = { buff_oilflow = true },
    buff_oilflow = { buff_hungerretarder = true }
}

local function BuffTalk_start(target, buff)
    if not target:HasTag("player") then
        return
    end
    target:PushEvent("foodbuffattached", { buff = "ANNOUNCE_ATTACH_"..string.upper(buff.prefab), priority = 1 })
end
local function BuffTalk_end(target, buff)
    if not target:HasTag("player") then
        return
    end
    target:PushEvent("foodbuffdetached", { buff = "ANNOUNCE_DETACH_"..string.upper(buff.prefab), priority = 1 })
end

local function IsAlive(inst)
    return inst.components.health ~= nil and not inst.components.health:IsDead() and not inst:HasTag("playerghost")
end
local function CheckOppositeBuff(buff, target) --去除相克的buff，不让某些buff同时存在
    local nobuffs = oppositeBuffs[buff.prefab]
    if nobuffs == nil then
        return
    end
    local abuff
    for k, _ in pairs(nobuffs) do
        abuff = target:GetDebuff(k)
        if abuff ~= nil then
            if abuff.oppositefn_l ~= nil then
                abuff.oppositefn_l(abuff, buff, target)
            end
            target:RemoveDebuff(k)
        end
    end
end
local function EndBuffSafely(buff)
    if buff.task_l_end ~= nil then
        return
    end
    buff.task_l_end = buff:DoTaskInTime(0, function(fx) --下一帧再执行，不然加buff的函数里移除buff可能会崩
        fx.components.debuff:Stop()
    end)
end

local function UpdateCount(buff, target, sets)
    if buff._count_load_l ~= nil then --onsave比这里先加载
        buff._count_l = buff._count_load_l
        buff._count_load_l = nil
        if buff._count_l <= 0 then
            EndBuffSafely(buff)
        end
        return
    end

    local now = buff._count_l or 0
    local setsbase = buff._dd.sets
    if sets == nil then
        sets = setsbase
    end
    if sets.add ~= nil then --增加型：在已有数值上增加，可设置最大数值限制
        local max = sets.max
        if setsbase.max ~= nil then
            if max == nil or max > setsbase.max then --临时设置的最大值不能大于原本的最大值
                max = setsbase.max
            end
        end
        now = now + sets.add
        if max ~= nil and now > max then
            now = max
        end
    elseif sets.replace ~= nil then --替换型：不管已有数值，直接覆盖
        now = sets.replace
    elseif sets.replace_min ~= nil then --最小替换型：若 已有数值<设定数值 时才设置新数值
        if now < sets.replace_min then
            now = sets.replace_min
        end
    end
    buff._count_l = now
    if now <= 0 then
        EndBuffSafely(buff)
    end
end
local function OnSave_count(buff, data)
    if buff._count_l ~= nil then
        data._count_l = buff._count_l
    end
end
local function OnLoad_count(buff, data, newents)
    if data ~= nil then
        if data._count_l ~= nil then
            buff._count_load_l = data._count_l
        end
    end
end

local function TimerAttach(buff, target, sets)
    if buff.components.timer:TimerExists("buffover") then --因为onsave比这里先加载，所以不能替换先加载的
        return
    end

    local now = 0
    local setsbase = buff._dd.sets
    if sets == nil then
        sets = setsbase
    end

    --因为是新加buff，不需要考虑buff时间问题
    if sets.add ~= nil then --增加型
        local max = sets.max
        if setsbase.max ~= nil then
            if max == nil or max > setsbase.max then --临时设置的最大值不能大于原本的最大值
                max = setsbase.max
            end
        end
        now = sets.add
        if max ~= nil and now > max then
            now = max
        end
    elseif sets.replace ~= nil then --替换型
        now = sets.replace
    elseif sets.replace_min ~= nil then --最小替换型
        now = sets.replace_min
    end

    if now <= 0 then
        EndBuffSafely(buff)
    else
        buff.components.timer:StartTimer("buffover", now)
    end
end
local function TimerExtend(buff, target, sets)
    local now = 0
    local setsbase = buff._dd.sets
    if sets == nil then
        sets = setsbase
    end

    --因为是续加buff，需要考虑buff时间的更新方式
    if sets.add ~= nil then --增加型：在已有时间上增加，可设置最大时间限制
        local max = sets.max
        if setsbase.max ~= nil then
            if max == nil or max > setsbase.max then --临时设置的最大值不能大于原本的最大值
                max = setsbase.max
            end
        end
        now = (buff.components.timer:GetTimeLeft("buffover") or 0) + sets.add
        if max ~= nil and now > max then
            now = max
        end
    elseif sets.replace ~= nil then --替换型：不管已有时间，直接覆盖
        now = sets.replace
    elseif sets.replace_min ~= nil then --最小替换型：若 已有时间<设定时间 时才设置新时间
        now = buff.components.timer:GetTimeLeft("buffover") or 0
        if now < sets.replace_min then
            now = sets.replace_min
        end
    end

    if now <= 0 then
        EndBuffSafely(buff)
    else
        buff.components.timer:StopTimer("buffover")
        buff.components.timer:StartTimer("buffover", now)
    end
end
local function Fn_attached(inst, target, followsymbol, followoffset, sets, ...)
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) --in case of loading
    inst:ListenForEvent("death", function(owner, data)
        inst.components.debuff:Stop()
    end, target)

    if not inst._dd.notimer then
        TimerAttach(inst, target, sets)
    end
    if inst._dd.fn_start ~= nil then
        inst._dd.fn_start(inst, target, followsymbol, followoffset, sets, ...)
    end
end
local function Fn_detached(inst, target, ...)
    if inst._dd.fn_end ~= nil then
        inst._dd.fn_end(inst, target, ...)
    end
    inst:Remove()
end
local function Fn_extended(inst, target, followsymbol, followoffset, sets, ...)
    if not inst._dd.notimer then
        TimerExtend(inst, target, sets)
    end
    if inst._dd.fn_again ~= nil then
        inst._dd.fn_again(inst, target, followsymbol, followoffset, sets, ...)
    end
end
local function OnTimerDone(inst, data)
    if data.name == "buffover" then
        inst.components.debuff:Stop()
        return
    end
    if inst._dd.fn_timerdone ~= nil then
        inst._dd.fn_timerdone(inst, data)
    end
end

local function MakeBuff(data)
	table.insert(prefs, Prefab(data.name, function()
        local inst = CreateEntity()

        if data.addnetwork then --带有网络组件
            inst.entity:AddTransform()
            inst.entity:AddNetwork()
            -- inst.entity:Hide()
            inst.persists = false

            -- inst:AddTag("CLASSIFIED")
            inst:AddTag("NOCLICK")
            inst:AddTag("NOBLOCK")

            if data.fn_common ~= nil then
                data.fn_common(inst)
            end

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then return inst end
        else --无网络组件
            if not TheWorld.ismastersim then
                --Not meant for client!
                inst:DoTaskInTime(0, inst.Remove)
                return inst
            end
            inst.entity:AddTransform()
            --Non-networked entity
            inst.entity:Hide()
            inst.persists = false
            inst:AddTag("CLASSIFIED")
        end

        inst._dd = data

        if not data.notimer then
            inst:AddComponent("timer")
            inst:ListenForEvent("timerdone", OnTimerDone)
        end

        inst:AddComponent("debuff")
        inst.components.debuff.keepondespawn = true
        inst.components.debuff:SetAttachedFn(Fn_attached)
        inst.components.debuff:SetDetachedFn(Fn_detached)
        inst.components.debuff:SetExtendedFn(Fn_extended)

        if data.fn_server ~= nil then
            data.fn_server(inst)
        end

        return inst
    end, data.assets, data.prefabs))
end

--------------------------------------------------------------------------
--[[ 蝙蝠伪装：不会被蝙蝠主动攻击 ]]
--------------------------------------------------------------------------

MakeBuff({
    name = "buff_l_batdisguise",
    -- assets = nil, prefabs = nil, notimer = nil,
    sets = { add = TUNING.SEG_TIME*8, max = TIME_MAX },
    fn_start = function(buff, target, followsymbol, followoffset, sets)
        BuffTalk_start(target, buff)
        if target.prefab ~= "bat" and target.prefab ~= "molebat" then
            target:AddTag("bat") --添加蝙蝠标签，蝙蝠不会攻击有该标签的生物
        end
    end,
    fn_again = function(buff, target, followsymbol, followoffset, sets)
        BuffTalk_start(target, buff)
        if target.prefab ~= "bat" and target.prefab ~= "molebat" then
            target:AddTag("bat")
        end
    end,
    fn_end = function(buff, target)
        BuffTalk_end(target, buff)
        if target.prefab ~= "bat" and target.prefab ~= "molebat" then
            target:RemoveTag("bat")
        end
    end
})

--------------------------------------------------------------------------
--[[ 好胃口：能够吃自己不喜欢的食物，但仍然无法吃生理上无法食用的食物 ]]
--------------------------------------------------------------------------

MakeBuff({
    name = "buff_l_bestappetite",
    -- assets = nil, prefabs = nil, notimer = nil,
    sets = { add = TUNING.SEG_TIME*2, max = TUNING.SEG_TIME*15 },
    fn_start = function(buff, target, followsymbol, followoffset, sets)
        BuffTalk_start(target, buff)
        target.legiontag_bestappetite = true --做标记。此处并没有别的操作，因为已经修改全局食性组件了，有这个buff就会启用
    end,
    fn_again = function(buff, target, followsymbol, followoffset, sets)
        BuffTalk_start(target, buff)
        target.legiontag_bestappetite = true
    end,
    fn_end = function(buff, target)
        BuffTalk_end(target, buff)
        target.legiontag_bestappetite = nil
    end
})

--------------------------------------------------------------------------
--[[ 蝴蝶庇佑：100%抵挡一次任何攻击 ]]
--------------------------------------------------------------------------

local function AddButterfly(buff, target, num)
    local nummax = buff._dd.sets.max
    for i = 1, nummax, 1 do
        local fly = buff.flies[i]
        if fly == nil or not fly:IsValid() then
            fly = SpawnPrefab("neverfade_butterfly")
            buff.flies[i] = fly
            if fly ~= nil then
                local skin = target.butterfly_skin_l or buff.flyskins[i]
                if skin ~= nil then
                    if skin.bank ~= nil then
                        fly.AnimState:SetBank(skin.bank)
                    end
                    if skin.build ~= nil then
                        fly.AnimState:SetBuild(skin.build)
                    end
                    fly.skin_l = skin
                end
                buff.flyskins[i] = skin

                local x, y, z = target.Transform:GetWorldPosition()
                local x2, y2, z2 = TOOLS_L.GetCalculatedPos(x, y, z, 1+math.random()*2, nil)
                fly.Transform:SetPosition(x2, y2, z2)

                if target.components.leader ~= nil then
                    target.components.leader:AddFollower(fly)
                end
            end
            num = num - 1
            if num <= 0 then
                return
            end
        end
    end
end
local function DeleteButterfly(buff, target, num, doit)
    local nummax = buff._dd.sets.max
    for i = 1, nummax, 1 do
        local fly = buff.flies[i]
        if fly ~= nil then
            buff.flies[i] = nil
            buff.flyskins[i] = nil
            if fly:IsValid() then
                if fly:IsAsleep() then
                    fly:Remove()
                else
                    fly.tag_l_dead = doit and 2 or 1
                end
            end
            if num ~= nil then
                num = num - 1
                if num <= 0 then
                    return
                end
            end
        end
    end
end
local function OnButterflyBlessed(doer)
    local buff = doer.components.debuffable:GetDebuff("buff_l_butterflybless")
    if buff ~= nil then
        if buff._count_l > 0 then
            buff._count_l = buff._count_l - 1
            DeleteButterfly(buff, doer, 1, true)
            if buff._count_l > 0 then
                doer.legion_numblessing = buff._count_l
                return
            end
        end
        buff.components.debuff:Stop()
    else
        doer.legion_numblessing = nil
        doer.legionfn_butterflyblessed = nil
    end
end
local function OnSave_butterflybless(buff, data)
    data.flyskins = buff.flyskins
    OnSave_count(buff, data)
end
local function OnLoad_butterflybless(buff, data, newents)
    if data ~= nil then
        if data.flyskins ~= nil then
            buff.flyskins = data.flyskins
        end
    end
    OnLoad_count(buff, data, newents)
end

MakeBuff({
    name = "buff_l_butterflybless",
    -- assets = nil, prefabs = nil,
    notimer = true,
    sets = { add = 1, max = 5 },
    fn_start = function(buff, target, followsymbol, followoffset, sets)
        UpdateCount(buff, target, sets)
        if buff._count_l <= 0 then
            return
        end
        target.legion_numblessing = buff._count_l
        target.legionfn_butterflyblessed = OnButterflyBlessed
        AddButterfly(buff, target, buff._count_l)
    end,
    fn_again = function(buff, target, followsymbol, followoffset, sets)
        local oldv = buff._count_l
        UpdateCount(buff, target, sets)
        if buff._count_l <= 0 then
            return
        end
        target.legion_numblessing = buff._count_l
        target.legionfn_butterflyblessed = OnButterflyBlessed
        oldv = buff._count_l - oldv
        if oldv < 0 then
            DeleteButterfly(buff, target, -oldv)
        elseif oldv > 0 then
            AddButterfly(buff, target, oldv)
        end
    end,
    fn_end = function(buff, target)
        buff._count_l = 0
        target.legion_numblessing = nil
        target.legionfn_butterflyblessed = nil
        DeleteButterfly(buff, target, nil)
    end,
    fn_server = function(buff)
        buff._count_l = 0
        buff.flies = {}
        buff.flyskins = {}
        buff.OnSave = OnSave_butterflybless
        buff.OnLoad = OnLoad_butterflybless
    end
})

--------------------------------------------------------------------------
--[[ 血库：按需提供生命值恢复 ]]
--------------------------------------------------------------------------

local function OnSave_healthstorage(inst, data)
	if inst.healthall ~= nil and inst.healthall > 0 then
        data.healthall = inst.healthall
    end
end
local function OnLoad_healthstorage(inst, data)
    if data == nil then
        return
    end
	if data.times ~= nil and data.times > 0 then --兼容旧版本数据
        inst.healthall = inst.healthall + data.times*2
    end
    if data.healthall ~= nil and data.healthall > 0 then
        inst.healthall = inst.healthall + data.healthall
    end
end
local function Heal_healthstorage(inst, target)
    inst.task_l_heal = nil
    if IsAlive(target) and inst.healthall > 0 then
        local need = target.components.health:GetMaxWithPenalty() - target.components.health.currenthealth
        if need >= 5 then
            if inst.healthall > need then
                inst.healthall = inst.healthall - need
            else
                need = inst.healthall
                inst.healthall = 0
            end
            target.components.health:DoDelta(need, true, "shyerry", true, nil, true)
            if inst.healthall <= 0 then
                inst.components.debuff:Stop()
            end
        end
    else
        inst.components.debuff:Stop()
    end
end
local function TryHeal_healthstorage(buff, target)
    if IsAlive(target) and buff.healthall > 0 then
        if
            buff.task_l_heal == nil and
            (target.components.health:GetMaxWithPenalty() - target.components.health.currenthealth) >= 5
        then
            buff.task_l_heal = buff:DoTaskInTime(0, Heal_healthstorage, target)
        end
    else
        EndBuffSafely(buff)
    end
end

MakeBuff({
    name = "buff_healthstorage",
    assets = nil,
    prefabs = nil,
    time_key = nil,
    time_default = nil,
    notimer = true,
    fn_start = function(buff, target)
        if target.components.oldager ~= nil then --物理回血效果，无法对旺达起作用
            target.buff_healthstorage_v = nil
            EndBuffSafely(buff)
            return
        end
        if target.buff_healthstorage_v ~= nil then --血库可以无限叠加
            buff.healthall = buff.healthall + target.buff_healthstorage_v
            target.buff_healthstorage_v = nil
        end
        TryHeal_healthstorage(buff, target)
        buff:ListenForEvent("healthdelta", buff.fn_l_healthdelta, target)
    end,
    fn_again = function(buff, target)
        if target.components.oldager ~= nil then
            target.buff_healthstorage_v = nil
            EndBuffSafely(buff)
            return
        end
        if target.buff_healthstorage_v ~= nil then
            buff.healthall = buff.healthall + target.buff_healthstorage_v
            target.buff_healthstorage_v = nil
        end
        TryHeal_healthstorage(buff, target)
    end,
    fn_end = function(buff, target)
        if buff.task_l_heal ~= nil then
            buff.task_l_heal:Cancel()
            buff.task_l_heal = nil
        end
        buff.healthall = 0
        buff:RemoveEventCallback("healthdelta", buff.fn_l_healthdelta, target)
    end,
    fn_server = function(buff)
        buff.healthall = 0
        buff.fn_l_healthdelta = function(target, data)
            TryHeal_healthstorage(buff, target)
        end
        buff.OnSave = OnSave_healthstorage
        buff.OnLoad = OnLoad_healthstorage --这个比OnAttached更早执行
    end
})

--------------------------------------------------------------------------
--[[ 孢子抵抗力：减少25%受到的伤害（进行防具抵扣之后的值） ]]
--------------------------------------------------------------------------

MakeBuff({
    name = "buff_sporeresistance",
    assets = nil,
    prefabs = nil,
    time_key = "time_l_sporeresistance",
    time_default = TUNING.SEG_TIME*6, --3分钟
    notimer = nil,
    fn_start = function(buff, target)
        if buff.task == nil then
            buff.task = buff:DoPeriodicTask(0.7, function()
                buff:DoTaskInTime(math.random()*0.6, function()
                    if
                        not (
                            target.components.health == nil or target.components.health:IsDead() or
                            target.sg:HasStateTag("nomorph") or
                            target.sg:HasStateTag("silentmorph") or
                            target.sg:HasStateTag("ghostbuild")
                        ) and target.entity:IsVisible()
                    then
                        SpawnPrefab("residualspores_fx").Transform:SetPosition(target.Transform:GetWorldPosition())
                    end
                end)
            end, 0.5+3*math.random())
            if target.components.health ~= nil then
                target.components.health.externalabsorbmodifiers:SetModifier(buff, 0.25)
            end
        end
    end,
    fn_again = nil,
    fn_end = function(buff, target)
        if target.components.health ~= nil then
            target.components.health.externalabsorbmodifiers:RemoveModifier(buff)
        end
        if buff.task ~= nil then
            buff.task:Cancel()
            buff.task = nil
        end
    end,
    fn_server = nil,
})

--------------------------------------------------------------------------
--[[ 蛮力：增加攻击力 ]]
--------------------------------------------------------------------------

MakeBuff({
    name = "buff_strengthenhancer",
    assets = nil,
    prefabs = nil,
    time_key = "time_l_strengthenhancer",
    time_default = TUNING.SEG_TIME*16, --8分钟
    notimer = nil,
    fn_start = function(buff, target)
        if target.components.combat ~= nil then
            target.components.combat.externaldamagemultipliers:SetModifier(buff, 1.5) --普通攻击系数x1.5倍
        end
    end,
    fn_again = nil,
    fn_end = function(buff, target)
        BuffTalk_end(target, buff)
        if target.components.combat ~= nil then
            target.components.combat.externaldamagemultipliers:RemoveModifier(buff)
        end
    end
})

--------------------------------------------------------------------------
--[[ 怜悯：降低攻击力 ]]
--------------------------------------------------------------------------

MakeBuff({
    name = "buff_attackreduce",
    assets = nil,
    prefabs = nil,
    time_key = "time_l_attackreduce",
    time_default = TUNING.SEG_TIME*2, --1分钟
    notimer = nil,
    fn_start = function(buff, target)
        -- if target.components.damagetypebonus == nil then --通过这个组件能使得弱化效果能同时应用给普攻和特攻
        --     target:AddComponent("damagetypebonus")
        -- end
        -- target.components.damagetypebonus:AddBonus("_health", target, 0.7, "buff_attackreduce")
        --"inspectable"标签覆盖范围比"_health"标签广
        -- target.components.damagetypebonus:AddBonus("inspectable", target, 0.7, "buff_attackreduce")
        TOOLS_L.AddBonusAll(target, "buff_attackreduce", 0.7)
        target.AnimState:SetMultColour(165/255, 188/255, 47/255, 1)
    end,
    fn_again = nil,
    fn_end = function(buff, target)
        -- if target.components.damagetypebonus ~= nil then
            -- target.components.damagetypebonus:RemoveBonus("_health", target, "buff_attackreduce")
            -- target.components.damagetypebonus:RemoveBonus("inspectable", target, "buff_attackreduce")
        -- end
        TOOLS_L.RemoveBonusAll(target, "buff_attackreduce")
        target.AnimState:SetMultColour(1, 1, 1, 1)
    end,
    fn_server = nil
})

--------------------------------------------------------------------------
--[[ 惊吓：进入被惊吓sg ]]
--------------------------------------------------------------------------

local function AlignToTarget(inst, target)
    inst.Transform:SetRotation(target.Transform:GetRotation())
end
local function OnChangeFollowSymbol(inst, target, followsymbol, followoffset)
    if followsymbol ~= nil and followoffset ~= nil then
        inst.Follower:FollowSymbol(target.GUID, followsymbol, followoffset.x, followoffset.y, followoffset.z)
    end
end

MakeBuff({
    name = "debuff_panicvolcano",
    assets = {
        Asset("ANIM", "anim/debuff_panicvolcano.zip"),
    },
    prefabs = nil,
    time_key = nil,
    time_default = nil,
    notimer = true,
    addnetwork = true,
    fn_start = function(buff, target, followsymbol, followoffset)
        buff.entity:SetParent(target.entity)
        OnChangeFollowSymbol(buff, target, followsymbol, followoffset)
        if buff._followtask ~= nil then
            buff._followtask:Cancel()
        end
        buff._followtask = buff:DoPeriodicTask(0, AlignToTarget, nil, target)
        AlignToTarget(buff, target)

        target:PushEvent("bevolcanopaniced")
    end,
    fn_again = nil,
    fn_end = function(buff, target)
        local player = buff.entity:GetParent()
        if player ~= nil and player.components.talker ~= nil then
            player.components.talker:Say(GetString(player, "DESCRIBE", { "DISH_SUGARLESSTRICKMAKERCUPCAKES", "TRICKED" }))
        end
        if buff._followtask ~= nil then
            buff._followtask:Cancel()
            buff._followtask = nil
        end
    end,
    fn_common = function(buff)
        buff.entity:AddFollower()
        buff.entity:AddAnimState()

        buff:AddTag("FX")

        buff.Transform:SetFourFaced()

        buff.AnimState:SetBank("debuff_panicvolcano")
        buff.AnimState:SetBuild("debuff_panicvolcano")
        buff.AnimState:PlayAnimation("anim")
        buff.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        buff.AnimState:SetFinalOffset(3)
    end,
    fn_server = function(buff)
        buff.components.debuff:SetChangeFollowSymbolFn(OnChangeFollowSymbol)

        buff:ListenForEvent("animover", function(fx)
            fx.components.debuff:Stop()
        end)
    end,
})

--------------------------------------------------------------------------
--[[ 腹得流油：不断拉粑粑（主要是鱼的油脂） ]]
--------------------------------------------------------------------------

local function StartOilFlowing(buff, inst)
    if buff.task ~= nil then
        buff.task:Cancel()
    end
    buff.task = inst:DoPeriodicTask(2, function(inst)
        if not IsAlive(inst) then
            buff.components.debuff:Stop()
            return
        end
        if math.random() < 0.6 then
            local poopname = "poop"
            if math.random() < 0.005 then
                poopname = "beeswax"
            elseif inst:HasTag("spider") then
                poopname = "silk"
            elseif inst:HasTag("bat") then
                poopname = "guano"
            end
            local poop = SpawnPrefab(poopname)
            if poop ~= nil then
                ------让粑粑飞
                local x1, y1, z1 = inst.Transform:GetWorldPosition()
                local angle = inst.Transform:GetRotation() + 20 - math.random()*40
                local theta = (angle+180)*DEGREES
                poop.Transform:SetPosition(x1, y1+0.5, z1)
                --Tip：SetMotorVel()会一直给加速度，SetVel()则会受到摩擦阻力和重力影响
                poop.Physics:SetVel(2.5*math.cos(theta), 2, -2.5*math.sin(theta))

                if inst:HasTag("player") then
                    ------说尴尬的话
                    if inst.components.talker ~= nil and not inst:HasTag("mime") and math.random() < 0.4 then
                        local words = STRINGS.CHARACTERS[string.upper(inst.prefab)]
                        if words ~= nil and words.BUFF_OILFLOW ~= nil then
                            words = words.BUFF_OILFLOW
                        else
                            words = STRINGS.CHARACTERS.GENERIC.BUFF_OILFLOW
                        end
                        inst.components.talker:Say(GetRandomItem(words))
                    end

                    ------让玩家向前推进
                    inst:PushEvent("awkwardpropeller", { angle = angle })
                else
                    ------让对象向前推进
                    if inst.sg == nil or not inst.sg:HasStateTag("busy") then
                        inst:PushEvent("attacked", { damage = 0 })
                        if inst.Physics ~= nil then
                            inst.Transform:SetRotation(angle)
                            inst.Physics:SetVel(5, 0, 0)
                        end
                    end
                end

                ------增加潮湿度
                if inst.components.moisture ~= nil then
                    inst.components.moisture:DoDelta(0.5)
                end

                ------饥饿值消耗
                if inst.components.hunger ~= nil and not inst.components.hunger:IsStarving() then
                    inst.components.hunger:DoDelta(-3.5)
                else
                    inst.components.health:DoDelta(-5, false, buff.prefab)
                end

                inst:PushEvent("on_poop", { doer = buff, hungerdelta = -3.5, item = poop })
            end
        end
    end, 3+5*math.random())
end

MakeBuff({
    name = "buff_oilflow",
    assets = nil,
    prefabs = { "poop", "beeswax" },
    time_key = "time_l_oilflow",
    time_default = TUNING.SEG_TIME*3, --1.5分钟
    notimer = nil,
    fn_start = function(buff, target)
        CheckOppositeBuff(buff, target)
        BuffTalk_start(target, buff)
        StartOilFlowing(buff, target)
    end,
    fn_again = function(buff, target)
        CheckOppositeBuff(buff, target)
        BuffTalk_start(target, buff)
        StartOilFlowing(buff, target)
    end,
    fn_end = function(buff, target)
        BuffTalk_end(target, buff)
        if buff.task ~= nil then
            buff.task:Cancel()
            buff.task = nil
        end
    end,
    fn_server = nil
})

--------------------------------------------------------------------------
--[[ 肠道堵塞：减少饱食度下降速度 ]]
--------------------------------------------------------------------------

local function OnSave_hungerretarder(inst, data)
    if inst.count_blocked_l > 0 then
        data.count_blocked_l = inst.count_blocked_l
    end
end
local function OnLoad_hungerretarder(inst, data)
    if data ~= nil then
        inst.count_blocked_l = data.count_blocked_l or 0
    end
end
local function Task_hungerretarder(buff)
    buff.count_blocked_l = buff.count_blocked_l + 1
end

MakeBuff({
    name = "buff_hungerretarder",
    assets = nil,
    prefabs = nil,
    time_key = "time_l_hungerretarder",
    time_default = TUNING.SEG_TIME*10, --5分钟
    notimer = nil,
    fn_start = function(buff, target)
        CheckOppositeBuff(buff, target)
        BuffTalk_start(target, buff)
        if target.components.hunger ~= nil then
            target.components.hunger.burnratemodifiers:SetModifier(buff, 0.1) --饥饿值消耗速度降为0.1倍
        end

        if buff.task_block ~= nil then
            buff.task_block:Cancel()
            buff.task_block = nil
        end
        if target.components.periodicspawner ~= nil then
            local cpt = target.components.periodicspawner
            local t = cpt.basetime + 0.5*cpt.randtime
            buff.task_block = buff:DoPeriodicTask(t, Task_hungerretarder, 1+9*math.random())
            cpt:Stop() --憋住！
        end
    end,
    fn_again = function(buff, target)
        CheckOppositeBuff(buff, target)
        BuffTalk_start(target, buff)
        if target.components.periodicspawner ~= nil then
            target.components.periodicspawner:Stop()
        end
    end,
    fn_end = function(buff, target)
        BuffTalk_end(target, buff)
        if target.components.hunger ~= nil then
            target.components.hunger.burnratemodifiers:RemoveModifier(buff)
        end

        if buff.task_block ~= nil then
            buff.task_block:Cancel()
            buff.task_block = nil
        end
        local poopname = "poop"
        if target.components.periodicspawner ~= nil then
            target.components.periodicspawner:Start()
            poopname = target.components.periodicspawner.prefab
            if type(poopname) == "function" then
                poopname = poopname(target)
            end
        end
        if buff.count_blocked_l > 0 then
            local pos = target:GetPosition()
            local rot = target.Transform:GetRotation()
            local poops = {}
            TOOLS_L.SpawnStackDrop(poopname or "poop", buff.count_blocked_l, pos, nil, poops, { dropper = target })
            for _, v in ipairs(poops) do
                local theta = (rot + 20 - math.random()*40 + 180)*DEGREES
                v.Transform:SetPosition(pos.x, pos.y+0.5, pos.z)
                v.Physics:SetVel(2.5*math.cos(theta), 2, -2.5*math.sin(theta))
            end
        end
    end,
    fn_server = function(buff)
        buff.count_blocked_l = 0
        buff.OnSave = OnSave_hungerretarder
        buff.OnLoad = OnLoad_hungerretarder
    end
})

--------------------------------------------------------------------------
--[[ 魔音绕耳：不断卸下装备 ]]
--------------------------------------------------------------------------

local function DropEquipment_magicwarble(v)
    if v.components.inventory ~= nil then
        if v.components.health == nil or not v.components.health:IsDead() then
            -- v.components.inventory:DropEquipped(false)
            local inv = v.components.inventory
            for slot, item in pairs(inv.equipslots) do
                if slot ~= EQUIPSLOTS.BEARD then --可不能把威尔逊的“胡子”给吼下来了
                    inv:DropItem(item, true, true)
                end
            end
        end
    end
end

MakeBuff({
    name = "debuff_magicwarble",
    assets = nil,
    prefabs = nil,
    time_key = "time_l_magicwarble",
    time_default = TUNING.SEG_TIME, --0.5分钟
    notimer = nil,
    fn_start = function(buff, target)
        if target.task_l_magicwarble ~= nil then
            target.task_l_magicwarble:Cancel()
            target.task_l_magicwarble = nil
        end
        if target.components.inventory ~= nil then
            target.task_l_magicwarble = target:DoPeriodicTask(0.9, DropEquipment_magicwarble, 1)
        end
    end,
    fn_again = nil,
    fn_end = function(buff, target)
        if target.task_l_magicwarble ~= nil then
            target.task_l_magicwarble:Cancel()
            target.task_l_magicwarble = nil
        end
    end
})

--------------------------------------------------------------------------
--[[ 神木光辉：增加防御力 ]]
--------------------------------------------------------------------------

local function OnChangeFollowSymbol_tree(inst, target, followsymbol, followoffset)
    if target:HasTag("siving_boss") then --这个buff特效我想让它的位置在玄鸟头部
        followsymbol = "buzzard_head"
        followoffset = { x = 0, y = -20, z = 0 }
    end
    if followsymbol ~= nil and followoffset ~= nil then
        inst.Follower:FollowSymbol(target.GUID, followsymbol, followoffset.x, followoffset.y, followoffset.z)
    end
end
local function SetStateSymbol(buff, state)
    if state == 1 then
        buff.AnimState:OverrideSymbol("insidetooth2", "siving_treehalo_fx", "insidetooth2")
    elseif state == 2 then
        buff.AnimState:OverrideSymbol("insidetooth2", "siving_treehalo_fx", "base2")
    else
        buff.AnimState:OverrideSymbol("insidetooth2", "siving_treehalo_fx", "base3")
    end
end
local function BuffSet_tree(buff, target)
    local state = target.sign_l_treehalo --不要清除这个变量，我还要管理呢
    if state == nil then --很可能是加载时
        state = buff.state_l
        buff.state_l = 0 --这样就可以把逻辑走完了
        target.sign_l_treehalo = state
    end

    if state == 0 then
        buff.state_l = 0
        if buff:IsAsleep() then
            EndBuffSafely(buff)
        else
            buff.AnimState:PlayAnimation("pst")
            buff:ListenForEvent("animover", function(fx)
                fx.components.debuff:Stop()
            end)
        end
        return
    end

    if buff.state_l ~= state then
        if buff.state_l > 0 then
            buff.AnimState:PlayAnimation("exchange")
            if buff.task_ex ~= nil then
                buff.task_ex:Cancel()
            end
            buff.task_ex = buff:DoTaskInTime(0.3, function(buff)
                buff.task_ex = nil
                SetStateSymbol(buff, buff.state_l)
            end)
        else
            SetStateSymbol(buff, state)
            buff.AnimState:PlayAnimation("pre")
        end
        buff.AnimState:PushAnimation("loop", true)
        buff.state_l = state

        -- if target.components.damagetyperesist == nil then --通过这个组件能使得防御效果能同时应用给普防和特防
        --     target:AddComponent("damagetyperesist")
        -- end
        --"inspectable"标签覆盖范围比"_health"标签广
        if state >= 3 then
            -- target.components.damagetyperesist:AddResist("inspectable", target, 0.01, "buff_treehalo")
            TOOLS_L.AddResistAll(target, "buff_treehalo", 0.01)
        elseif state >= 2 then
            -- target.components.damagetyperesist:AddResist("inspectable", target, 0.34, "buff_treehalo")
            TOOLS_L.AddResistAll(target, "buff_treehalo", 0.34)
        elseif state >= 1 then
            -- target.components.damagetyperesist:AddResist("inspectable", target, 0.67, "buff_treehalo")
            TOOLS_L.AddResistAll(target, "buff_treehalo", 0.67)
        end
        -- if target.components.combat ~= nil then --externaldamagetakenmultipliers机制只能影响普防
        --     if state == 3 then
        --         target.components.combat.externaldamagetakenmultipliers:SetModifier(buff, 0.01)
        --     elseif state == 2 then
        --         target.components.combat.externaldamagetakenmultipliers:SetModifier(buff, 0.34)
        --     elseif state == 1 then
        --         target.components.combat.externaldamagetakenmultipliers:SetModifier(buff, 0.67)
        --     end
        -- end
    end
end

MakeBuff({
    name = "buff_treehalo",
    assets = {
        Asset("ANIM", "anim/siving_treehalo_fx.zip"),
    },
    prefabs = nil,
    time_key = nil,
    time_default = nil,
    notimer = true,
    addnetwork = true,
    fn_start = function(buff, target, followsymbol, followoffset)
        buff.entity:SetParent(target.entity)
        OnChangeFollowSymbol_tree(buff, target, followsymbol, followoffset)
        BuffSet_tree(buff, target)
    end,
    fn_again = function(buff, target, followsymbol, followoffset)
        if buff.state_l > 0 then --结束动画有一阵子，期间再来就不算了
            BuffSet_tree(buff, target)
        end
    end,
    fn_end = function(buff, target)
        if buff.task_ex ~= nil then
            buff.task_ex:Cancel()
            buff.task_ex = nil
        end
        -- if target:IsValid() and target.components.damagetyperesist ~= nil then
            -- target.components.combat.externaldamagetakenmultipliers:RemoveModifier(buff)
            -- target.components.damagetyperesist:RemoveResist("inspectable", target, "buff_treehalo")
        -- end
        if target:IsValid() then
            TOOLS_L.RemoveResistAll(target, "buff_treehalo")
        end
    end,
    fn_common = function(buff)
        buff.entity:AddFollower()
        buff.entity:AddAnimState()

        buff:AddTag("FX")

        buff.AnimState:SetBank("siving_treehalo_fx")
        buff.AnimState:SetBuild("siving_treehalo_fx")
        buff.AnimState:PlayAnimation("loop", true)
        buff.AnimState:SetScale(0.35, 0.35)
        buff.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        buff.AnimState:SetFinalOffset(-3) --让这个动画位于父体层级底部
    end,
    fn_server = function(buff)
        buff.components.debuff:SetChangeFollowSymbolFn(OnChangeFollowSymbol_tree)

        buff.state_l = 0
        buff.OnSave = function(inst, data)
            if inst.state_l > 0 then
                data.state_l = inst.state_l
            end
        end
        buff.OnLoad = function(inst, data) --这个比OnAttached更早执行
            if data ~= nil and data.state_l ~= nil then
                inst.state_l = data.state_l
            end
        end
    end
})

--------------------------------------------------------------------------
--[[ 焕肤：身体发光 ]]
--------------------------------------------------------------------------

local time_radiant = 20
local step_radiant = FRAMES*2
local radius_radiant = 3
local steprad_radiant = radius_radiant/time_radiant
local function LightFading_radiant(buff)
    buff.time_fade = buff.time_fade - step_radiant
    if buff.time_fade > 0 then
        buff.Light:SetRadius(steprad_radiant*buff.time_fade)
    else
        buff.Light:Enable(false)
        if buff.task_fade ~= nil then
            buff.task_fade:Cancel()
            buff.task_fade = nil
        end
    end
end
local function BuffSet_radiant(buff, target)
    if buff.task_fade ~= nil then
        buff.task_fade:Cancel()
        buff.task_fade = nil
    end

    local timeleft = buff.components.timer:GetTimeLeft("buffover") or 0
    if timeleft <= 0 then --按理来说，这里不该发生
        EndBuffSafely(buff)
        return
    end
    if timeleft > time_radiant then
        buff.time_fade = time_radiant
        timeleft = timeleft - time_radiant
    else
        buff.time_fade = timeleft
        timeleft = 0
    end
    buff.Light:SetRadius(steprad_radiant*buff.time_fade)
    buff.Light:Enable(true)
    buff.task_fade = buff:DoPeriodicTask(step_radiant, LightFading_radiant, timeleft)
end

MakeBuff({
    name = "buff_l_radiantskin",
    assets = nil,
    prefabs = nil,
    time_key = "time_l_radiantskin",
    time_default = TUNING.SEG_TIME*16, --8分钟
    notimer = nil,
    addnetwork = true,
    fn_start = function(buff, target)
        BuffSet_radiant(buff, target)
        if target.components.bloomer ~= nil then
            target.components.bloomer:PushBloom(buff, "shaders/anim.ksh", 0.33)
        else
            target.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        end
    end,
    fn_again = BuffSet_radiant,
    fn_end = function(buff, target)
        if buff.task_fade ~= nil then
            buff.task_fade:Cancel()
            buff.task_fade = nil
        end
        if target.components.bloomer ~= nil then
            target.components.bloomer:PopBloom(buff)
        else
            target.AnimState:ClearBloomEffectHandle()
        end
    end,
    fn_common = function(buff)
        buff.entity:AddLight()
        buff.Light:SetRadius(radius_radiant)
        buff.Light:SetIntensity(0.8)
        buff.Light:SetFalloff(0.5)
        buff.Light:SetColour(169/255, 231/255, 245/255) --光源配置和发光浆果一致
        buff.Light:Enable(true)
        -- buff.Light:EnableClientModulation(true)
    end
})

--------------------------------------------------------------------------
--[[ 煊肤：完全防火 ]]
--------------------------------------------------------------------------

MakeBuff({
    name = "buff_l_fireproof",
    assets = nil,
    prefabs = nil,
    time_key = "time_l_fireproof",
    time_default = TUNING.SEG_TIME*12, --6分钟
    notimer = nil,
    fn_start = function(buff, target)
        BuffTalk_start(target, buff)
        if target.components.health ~= nil then --免疫火焰伤
            target.components.health.externalfiredamagemultipliers:SetModifier(buff, 0)
        end
        TOOLS_L.AddEntValue(target, "fireproof_l", buff.prefab, nil, 1)
        if not target:HasTag("player") then --为了方便玩家观察
            TOOLS_L.AddTag(target, "fireproof_l", "fireproof_base")
        end
        if
            target.components.burnable ~= nil and
            (target.components.burnable:IsBurning() or target.components.burnable:IsSmoldering())
        then
            target.components.burnable:Extinguish() --顺便灭火
        end
    end,
    fn_again = function(buff, target)
        BuffTalk_start(target, buff)
        if
            target.components.burnable ~= nil and
            (target.components.burnable:IsBurning() or target.components.burnable:IsSmoldering())
        then
            target.components.burnable:Extinguish() --顺便灭火
        end
    end,
    fn_end = function(buff, target)
        BuffTalk_end(target, buff)
        if target.components.health ~= nil then
            target.components.health.externalfiredamagemultipliers:RemoveModifier(buff)
        end
        TOOLS_L.RemoveEntValue(target, "fireproof_l", buff.prefab, nil)
        TOOLS_L.RemoveTag(target, "fireproof_l", "fireproof_base")
    end
})

--------------------------------------------------------------------------
--[[ 弱肤：50%窃血抵抗 ]]
--------------------------------------------------------------------------

MakeBuff({
    name = "buff_l_sivbloodreduce",
    assets = nil,
    prefabs = nil,
    time_key = "time_l_sivbloodreduce",
    time_default = TUNING.SEG_TIME*12, --6分钟
    notimer = nil,
    fn_start = function(buff, target)
        BuffTalk_start(target, buff)
        TOOLS_L.AddEntValue(target, "siv_blood_l_reducer", "buff_l_sivbloodreduce", 1, 0.5)
    end,
    fn_again = function(buff, target)
        BuffTalk_start(target, buff)
    end,
    fn_end = function(buff, target)
        BuffTalk_end(target, buff)
        TOOLS_L.RemoveEntValue(target, "siv_blood_l_reducer", "buff_l_sivbloodreduce", 1)
    end
})

--------------------------------------------------------------------------
--[[ 好事多蘑：增加稀有掉落物的掉落概率 ]]
--------------------------------------------------------------------------

MakeBuff({
    name = "buff_l_effortluck",
    -- assets = nil, prefabs = nil,
    notimer = true,
    sets = { add = 1, max = 3 },
    fn_start = function(buff, target, followsymbol, followoffset, sets)
        BuffTalk_start(target, buff)
        UpdateCount(buff, target, sets)
    end,
    fn_again = function(buff, target, followsymbol, followoffset, sets)
        BuffTalk_start(target, buff)
        UpdateCount(buff, target, sets)
    end,
    fn_end = function(buff, target)
        BuffTalk_end(target, buff)
    end,
    fn_server = function(buff)
        buff.OnSave = OnSave_count
        buff.OnLoad = OnLoad_count
    end
})

--------------------
--------------------

return unpack(prefs)
