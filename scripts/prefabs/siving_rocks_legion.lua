local prefs = {}
local wortox_soul_common = require("prefabs/wortox_soul_common")

--------------------------------------------------------------------------
--[[ 子圭石 ]]
--------------------------------------------------------------------------

if not CONFIGS_LEGION.ENABLEDMODS.MythWords then --未开启神话书说时才注册这个prefab
    table.insert(prefs, Prefab(
        "siving_rocks",
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddNetwork()

            MakeInventoryPhysics(inst)

            inst.AnimState:SetBank("myth_siving")
            inst.AnimState:SetBuild("myth_siving")
            inst.AnimState:PlayAnimation("siving_rocks")

            inst:AddTag("molebait")

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst:AddComponent("stackable")
            inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

            inst:AddComponent("inspectable")

            inst:AddComponent("tradable")
            inst.components.tradable.rocktribute = 6 --延缓 0.33x6 天地震
            inst.components.tradable.goldvalue = 4 --换1个砂之石或4金块

            inst:AddComponent("bait")

            inst:AddComponent("inventoryitem")
            inst.components.inventoryitem.imagename = "siving_rocks"
            inst.components.inventoryitem.atlasname = "images/inventoryimages/siving_rocks.xml"
            inst.components.inventoryitem:SetSinks(true)

            MakeHauntableLaunchAndIgnite(inst)

            return inst
        end,
        {
            Asset("ANIM", "anim/myth_siving.zip"),
            Asset("ATLAS", "images/inventoryimages/siving_rocks.xml"),
            Asset("IMAGE", "images/inventoryimages/siving_rocks.tex"),
        },
        nil
    ))
end

--------------------------------------------------------------------------
--[[ 子圭x型岩 ]]
--------------------------------------------------------------------------

local function MakeDerivant(data)
    local function UpdateGrowing(inst)
        if IsTooDarkToGrow_legion(inst) then
            inst.components.timer:PauseTimer("growup")
        else
            inst.components.timer:ResumeTimer("growup")
        end
    end

    local function OnIsDark(inst)
        UpdateGrowing(inst)
        if TheWorld.state.isnight then
            if inst.nighttask == nil then
                inst.nighttask = inst:DoPeriodicTask(5, UpdateGrowing, math.random() * 5)
            end
        else
            if inst.nighttask ~= nil then
                inst.nighttask:Cancel()
                inst.nighttask = nil
            end
        end
    end

    table.insert(prefs, Prefab(
        "siving_derivant_"..data.name,
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddSoundEmitter()
            inst.entity:AddAnimState()
            inst.entity:AddNetwork()
            inst.entity:AddMiniMapEntity()
            inst.entity:AddLight()

            MakeObstaclePhysics(inst, 0.2)

            inst.AnimState:SetBank("siving_derivants")
            inst.AnimState:SetBuild("siving_derivants")
            inst.AnimState:PlayAnimation(data.name)
            inst.AnimState:SetScale(1.3, 1.3)
            MakeSnowCovered_comm_legion(inst)

            inst.MiniMapEntity:SetIcon("siving_derivant.tex")

            inst.Light:Enable(false)
            inst.Light:SetRadius(1.5)
            inst.Light:SetFalloff(1)
            inst.Light:SetIntensity(.6)
            inst.Light:SetColour(15/255, 180/255, 132/255)

            inst:AddTag("siving_derivant")
            inst:AddTag("silviculture") --这个标签能让《造林学》发挥作用

            inst:AddComponent("skinedlegion")
            inst.components.skinedlegion:Init("siving_derivant_"..data.name)

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst.nighttask = nil

            inst:AddComponent("inspectable")

            inst:AddComponent("lootdropper")

            inst:AddComponent("workable")

            inst:AddComponent("timer")

            inst:AddComponent("growable")
            inst.components.growable.stages = {}
            inst.components.growable:StopGrowing()
            inst.components.growable.magicgrowable = true --非常规造林学有效标志（其他会由组件来施行）
            inst.components.growable.domagicgrowthfn = function(inst, doer)
                if inst.components.timer:TimerExists("growup") then
                    inst.components.timer:StopTimer("growup")
                    inst:PushEvent("timerdone", { name = "growup" })
                end
            end

            if data.fn_server ~= nil then
                data.fn_server(inst)
            end

            inst:WatchWorldState("isnight", OnIsDark)
            MakeSnowCovered_serv_legion(inst, 0, OnIsDark)

            inst:AddComponent("bloomer")

            inst.treeState = 0
            inst.OnTreeLive = function(inst, state)
                inst.treeState = state
                if state == 2 then
                    inst.AnimState:PlayAnimation(data.name.."_live")
                    inst.components.bloomer:PushBloom("activetree", "shaders/anim.ksh", 1)
                    inst.Light:SetRadius(1.5)
                    inst.Light:Enable(true)
                elseif state == 1 then
                    inst.AnimState:PlayAnimation(data.name)
                    inst.components.bloomer:PushBloom("activetree", "shaders/anim.ksh", 1)
                    inst.Light:SetRadius(0.8)
                    inst.Light:Enable(true)
                else
                    inst.AnimState:PlayAnimation(data.name)
                    inst.components.bloomer:PopBloom("activetree")
                    inst.Light:Enable(false)
                end
            end

            MakeHauntableWork(inst)

            inst.components.skinedlegion:SetOnPreLoad()

            return inst
        end,
        {
            Asset("ANIM", "anim/hiddenmoonlight.zip"),  --提供积雪贴图
            Asset("ANIM", "anim/siving_derivants.zip"),
        },
        data.prefabs
    ))
end

local function DropRock(inst, chance)
    if math.random() <= chance then
        inst.components.lootdropper:SpawnLootPrefab("siving_rocks")
    end
end
local function SetTimer_derivant(inst, time, nextname)
    inst.components.timer:StartTimer("growup", time)
    inst:ListenForEvent("timerdone", function(inst, data)
        if data.name == "growup" then
            inst.SoundEmitter:PlaySound("dontstarve/common/together/marble_shrub/grow")
            local tree = nil
            local skindata = inst.components.skinedlegion:GetSkinedData()
            if skindata and skindata.linkedskins and skindata.linkedskins.up then
                tree = SpawnPrefab(nextname, skindata.linkedskins.up)
            else
                tree = SpawnPrefab(nextname)
            end
            if tree ~= nil then
                if inst.treeState ~= 0 then
                    tree.OnTreeLive(tree, inst.treeState)
                end
                tree.Transform:SetPosition(inst.Transform:GetWorldPosition())
            end
            inst:Remove()
        end
    end)
end
local function SpawnSkinedPrefab(inst, itemname)
    local x, y, z = inst.Transform:GetWorldPosition()
    SpawnPrefab("rock_break_fx").Transform:SetPosition(x, y, z)
    SpawnPrefab("collapse_small").Transform:SetPosition(x, y, z)

    local tree = nil
    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata and skindata.linkedskins and skindata.linkedskins.down then
        tree = SpawnPrefab(itemname, skindata.linkedskins.down)
    else
        tree = SpawnPrefab(itemname)
    end
    if tree ~= nil then
        if inst.treeState ~= 0 then
            tree.OnTreeLive(tree, inst.treeState)
        end
        tree.Transform:SetPosition(x, y, z)
    end
end

MakeDerivant({  --子圭一型岩
    name = "lvl0",
    prefabs = { "siving_derivant_item", "siving_derivant_lvl1" },
    fn_server = function(inst)
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetWorkLeft(3)
        inst.components.workable:SetOnFinishCallback(function(inst, worker)
            inst.components.lootdropper:SpawnLootPrefab("siving_derivant_item")
            inst:Remove()
        end)
        SetTimer_derivant(inst, TUNING.TOTAL_DAY_TIME * 6, "siving_derivant_lvl1")
    end,
})
MakeDerivant({  --子圭木型岩
    name = "lvl1",
    prefabs = { "siving_rocks", "siving_derivant_lvl0", "siving_derivant_lvl2" },
    fn_server = function(inst)
        inst.components.workable:SetWorkAction(ACTIONS.MINE)
        inst.components.workable:SetWorkLeft(6)
        inst.components.workable:SetOnWorkCallback(function(inst, worker, workleft)
            if workleft > 0 then
                DropRock(inst, 0.02)
            end
        end)
        inst.components.workable:SetOnFinishCallback(function(inst, worker)
            SpawnSkinedPrefab(inst, "siving_derivant_lvl0")
            DropRock(inst, 0.5)
            inst:Remove()
        end)
        SetTimer_derivant(inst, TUNING.TOTAL_DAY_TIME * 7.5, "siving_derivant_lvl2")
    end,
})
MakeDerivant({  --子圭林型岩
    name = "lvl2",
    prefabs = { "siving_rocks", "siving_derivant_lvl1", "siving_derivant_lvl3" },
    fn_server = function(inst)
        inst.components.workable:SetWorkAction(ACTIONS.MINE)
        inst.components.workable:SetWorkLeft(9)
        inst.components.workable:SetOnWorkCallback(function(inst, worker, workleft)
            if workleft > 0 then
                DropRock(inst, 0.03)
            end
        end)
        inst.components.workable:SetOnFinishCallback(function(inst, worker)
            SpawnSkinedPrefab(inst, "siving_derivant_lvl1")
            inst.components.lootdropper:SpawnLootPrefab("siving_rocks")
            DropRock(inst, 0.5)
            inst:Remove()
        end)
        SetTimer_derivant(inst, TUNING.TOTAL_DAY_TIME * 8, "siving_derivant_lvl3")
    end,
})
MakeDerivant({  --子圭森型岩
    name = "lvl3",
    prefabs = { "siving_rocks", "siving_derivant_lvl2" },
    fn_server = function(inst)
        inst.components.workable:SetWorkAction(ACTIONS.MINE)
        inst.components.workable:SetWorkLeft(12)
        inst.components.workable:SetOnWorkCallback(function(inst, worker, workleft)
            if workleft > 0 then
                DropRock(inst, 0.04)
            end
        end)
        inst.components.workable:SetOnFinishCallback(function(inst, worker)
            SpawnSkinedPrefab(inst, "siving_derivant_lvl2")
            inst.components.lootdropper:SpawnLootPrefab("siving_rocks")
            inst.components.lootdropper:SpawnLootPrefab("siving_rocks")
            DropRock(inst, 0.5)
            inst:Remove()
        end)

        inst.components.timer:StartTimer("growup", TUNING.TOTAL_DAY_TIME * 6)
        inst:ListenForEvent("timerdone", function(inst, data)
            if data.name == "growup" then
                inst.components.timer:StartTimer("growup", TUNING.TOTAL_DAY_TIME * 6)
                local x,y,z = inst.Transform:GetWorldPosition()
                local ents = TheSim:FindEntities(x,y,z, 6,
                    nil,
                    {"NOCLICK", "FX", "INLIMBO"},
                    nil
                )
                local numloot = 0
                for i,ent in ipairs(ents) do
                    if ent.prefab == "siving_rocks" then
                        numloot = numloot + 1
                        if numloot >= 2 then
                            return
                        end
                    end
                end
                inst.components.lootdropper:SpawnLootPrefab("siving_rocks")
            end
        end)
    end,
})

--------------------------------------------------------------------------
--[[ 子圭神木 ]]
--------------------------------------------------------------------------

local function DropRock(inst)
    local xx, yy, zz = inst.Transform:GetWorldPosition()
    local x, y, z = GetCalculatedPos_legion(xx, yy, zz, 2.6+math.random()*3, nil)
    DropItem_legion("siving_rocks", x, y+13, z, 1.5, 18, 15*FRAMES, nil, nil, nil)
end
local function OnStealLife(inst, value)
    inst.countHealth = inst.countHealth + value

    if inst.bossBirds ~= nil then --子圭玄鸟在场上时，吸收的生命用来恢复它们
        if inst.countHealth >= 6 then
            if
                inst.bossBirds.female ~= nil and inst.bossBirds.female:IsValid() and
                not inst.bossBirds.female.components.health:IsDead() and
                inst.bossBirds.female.components.health:IsHurt()
            then
                inst.bossBirds.female.components.health:DoDelta(3)
                inst.countHealth = inst.countHealth - 3
            end
            if
                inst.bossBirds.male ~= nil and inst.bossBirds.male:IsValid() and
                not inst.bossBirds.male.components.health:IsDead() and
                inst.bossBirds.male.components.health:IsHurt()
            then
                inst.bossBirds.male.components.health:DoDelta(3)
                inst.countHealth = inst.countHealth - 3
            end
        end
    else --如果没有玄鸟，每500生命必定掉落子圭石
        if inst.countHealth >= 500 then
            DropRock(inst)
            inst.countHealth = inst.countHealth - 500
        end
    end
end
local function TriggerLifeExtractTask(inst, doit)
    if doit then
        if inst.taskLifeExtract == nil then
            local x, y, z = inst.Transform:GetWorldPosition()
            local ents = nil
            local _taskcounter = 0

            ----每2秒吸取所有生物生命；每0.5秒产生吸取特效
            inst.taskLifeExtract = inst:DoPeriodicTask(0.5, function(inst)
                ----计数器管理
                _taskcounter = _taskcounter + 1
                local doit2 = false
                if _taskcounter % 4 == 0 then --每过两秒
                    doit2 = true
                    _taskcounter = 0
                end

                ----吸收对象的更新
                if doit2 or ents == nil then
                    ents = TheSim:FindEntities(x, y, z, 20,
                        nil,
                        {"NOCLICK", "shadow", "playerghost", "ghost",
                            "INLIMBO", "wall", "structure", "balloon", "siving"},
                        {"siving_derivant", "_health"}
                    )
                end

                local cost = inst.treeState == 2 and 4 or 2
                local costall = 0

                for _,v in ipairs(ents) do
                    if v and v:IsValid() and v.entity:IsVisible() then
                        if v:HasTag("siving_derivant") then
                            if v.treeState ~= nil and inst.treeState ~= v.treeState then
                                v.OnTreeLive(v, inst.treeState)
                            end
                        elseif
                            v.components.health ~= nil and not v.components.health:IsDead() and
                            v:GetDistanceSqToPoint(x, y, z) <= 400
                        then
                            ----特效生成
                            if v.components.inventory == nil or not v.components.inventory:EquipHasTag("siv_BFF") then
                                local life = SpawnPrefab("siving_lifesteal_fx")
                                if life ~= nil then
                                    life.movingTarget = inst
                                    life.Transform:SetPosition(v.Transform:GetWorldPosition())
                                end
                            end
                            ----吸血
                            if doit2 then
                                local costnow = cost
                                if v.components.inventory ~= nil then
                                    if v.components.inventory:EquipHasTag("siv_BFF") then
                                        costnow = 0
                                    elseif v.components.inventory:EquipHasTag("siv_BF") then
                                        costnow = costnow / 2
                                    end
                                end
                                if costnow > 0 then
                                    v.components.health:DoDelta(-costnow, true, inst.prefab, false, inst, true)
                                    costall = costall + costnow
                                end
                            end
                        end
                    end
                end

                if doit2 then
                    if costall > 0 then
                        OnStealLife(inst, costall)
                    else
                        ents = nil
                        if inst.bossBirds ~= nil then --为了能稳定给玄鸟恢复血量，即使这次没有吸血也试探一下
                            OnStealLife(inst, 0)
                        end
                    end

                    if inst.bossBirds ~= nil then
                        ------检查BOSS所在地

                        ------检查BOSS站位是否需要轮换
                    end
                end

            end, 0)
        end
    else
        if inst.taskLifeExtract ~= nil then
            inst.taskLifeExtract:Cancel()
            inst.taskLifeExtract = nil
        end
    end
end

local function OnRestoreSoul(victim)
    victim.nosoultask = nil
end
local function IsValidVictim(victim)
    return wortox_soul_common.HasSoul(victim) and victim.components.health:IsDead()
end
local function LetLifeWalkToTree(inst, victim, healthvalue)
    local x, y, z = victim.Transform:GetWorldPosition()
    local count = 0
    local countMax = healthvalue <= 600 and 3 or 6
    local taskStealLife = nil
    taskStealLife = inst:DoPeriodicTask(0.5, function()
        if inst == nil or not inst:IsValid() then
            if taskStealLife ~= nil then
                taskStealLife:Cancel()
                taskStealLife = nil
            end
            return
        end

        count = count + 1

        local life = SpawnPrefab("siving_lifesteal_fx")
        if life ~= nil then
            life.movingTarget = inst
            if count >= countMax then
                life.OnReachTarget = function()
                    OnStealLife(inst, healthvalue)
                end
            end
            life.Transform:SetPosition(x, y, z)
        end

        if count >= countMax then
            if taskStealLife ~= nil then
                taskStealLife:Cancel()
                taskStealLife = nil
            end
        end
    end, 0)
end

local function OnEntityDropLoot(inst, data)
    local victim = data.inst
    if
        victim ~= nil and
        victim.nosoultask == nil and
        victim:IsValid() and
        (
            victim == inst or
            (
                IsValidVictim(victim) and
                inst:IsNear(victim, TUNING.WORTOX_SOULEXTRACT_RANGE)
            )
        )
    then
        --V2C: prevents multiple Wortoxes in range from spawning multiple souls per corpse
        victim.nosoultask = victim:DoTaskInTime(5, OnRestoreSoul)

        local health = victim.components.health ~= nil and victim.components.health.maxhealth or 100
        LetLifeWalkToTree(inst, victim, health)
    end
end
local function OnEntityDeath(inst, data)
    if data.inst ~= nil and data.inst.components.lootdropper == nil then
        OnEntityDropLoot(inst, data)
    end
end
local function OnStarvedTrapSouls(inst, data)
    local trap = data.trap
    if
        trap ~= nil and
        trap.nosoultask == nil and
        (data.numsouls or 0) > 0 and
        trap:IsValid() and
        inst:IsNear(trap, TUNING.WORTOX_SOULEXTRACT_RANGE)
    then
        --V2C: prevents multiple Wortoxes in range from spawning multiple souls per trap
        trap.nosoultask = trap:DoTaskInTime(5, OnRestoreSoul)
        LetLifeWalkToTree(inst, trap, data.numsouls*50)
    end
end

local function AddLivesListen(inst)
    if inst._onentitydroplootfn == nil then
        inst._onentitydroplootfn = function(src, data) OnEntityDropLoot(inst, data) end
        inst:ListenForEvent("entity_droploot", inst._onentitydroplootfn, TheWorld)
    end
    if inst._onentitydeathfn == nil then
        inst._onentitydeathfn = function(src, data) OnEntityDeath(inst, data) end
        inst:ListenForEvent("entity_death", inst._onentitydeathfn, TheWorld)
    end
    if inst._onstarvedtrapsoulsfn == nil then
        inst._onstarvedtrapsoulsfn = function(src, data) OnStarvedTrapSouls(inst, data) end
        inst:ListenForEvent("starvedtrapsouls", inst._onstarvedtrapsoulsfn, TheWorld)
    end
    TriggerLifeExtractTask(inst, true)
end
local function RemoveLivesListen(inst)
    if inst._onentitydroplootfn ~= nil then
        inst:RemoveEventCallback("entity_droploot", inst._onentitydroplootfn, TheWorld)
        inst._onentitydroplootfn = nil
    end
    if inst._onentitydeathfn ~= nil then
        inst:RemoveEventCallback("entity_death", inst._onentitydeathfn, TheWorld)
        inst._onentitydeathfn = nil
    end
    if inst._onstarvedtrapsoulsfn ~= nil then
        inst:RemoveEventCallback("starvedtrapsouls", inst._onstarvedtrapsoulsfn, TheWorld)
        inst._onstarvedtrapsoulsfn = nil
    end
    TriggerLifeExtractTask(inst, false)
end

-----

local function StateChange(inst) --0休眠状态(玄鸟死亡)、1正常状态(玄鸟活着，非春季)、2活力状态(玄鸟活着，春季)
    if inst.components.timer:TimerExists("birdrebirth") then --玄鸟死亡
        inst.treeState = 0
        inst.bossBirds = nil
        inst.AnimState:SetBuild("siving_thetree")
        inst.components.bloomer:PopBloom("activetree")
        inst.Light:Enable(false)
        inst.components.trader:Disable()
    else
        if TheWorld.state.isspring then --春季
            inst.treeState = 2
            inst.AnimState:SetBuild("siving_thetree_live")
            inst.Light:SetRadius(8)
        else
            inst.treeState = 1
            inst.AnimState:SetBuild("siving_thetree")
            inst.Light:SetRadius(5)
        end
        inst.components.bloomer:PushBloom("activetree", "shaders/anim.ksh", 1)
        inst.Light:Enable(true)
        inst.components.trader:Enable()
    end
end

table.insert(prefs, Prefab(
    "siving_thetree",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddSoundEmitter()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddLight()

        inst.MiniMapEntity:SetIcon("siving_thetree.tex")

        MakeObstaclePhysics(inst, 2.6)

        inst.AnimState:SetBank("siving_thetree")
        inst.AnimState:SetBuild("siving_thetree")
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:SetScale(1.3, 1.3)

        inst.Light:Enable(false)
        inst.Light:SetRadius(6)
        inst.Light:SetFalloff(1)
        inst.Light:SetIntensity(.6)
        inst.Light:SetColour(15/255, 180/255, 132/255)

        inst:AddTag("siving_thetree")

        --trader (from trader component) added to pristine state for optimization
        inst:AddTag("trader")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst.countWorked = 0
        inst.countHealth = 0
        inst.treeState = 1
        inst.taskLifeExtract = nil
        inst.bossBirds = nil
        inst.tradeditems = nil --已给予的物品

        inst:AddComponent("inspectable")

        inst:AddComponent("lootdropper")

        inst:AddComponent("bloomer")

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.MINE)
        inst.components.workable:SetWorkLeft(20)
        inst.components.workable:SetOnWorkCallback(function(inst, worker, workleft, numworks)
            inst.components.workable:SetWorkLeft(20) --恢复工作量，永远都破坏不了
            if inst.treeState > 0 then
                if numworks == nil then
                    numworks = 1
                elseif numworks >= 8 then --这里是为了防止直接破坏型（比如熊大、战车的撞击）
                    numworks = 2
                end

                inst.countWorked = inst.countWorked + numworks

                local numall = inst.treeState == 1 and 30 or 20
                if inst.countWorked >= numall then
                    inst.countWorked = inst.countWorked - numall
                    DropRock(inst)
                end
            end
        end)

        inst:AddComponent("trader")
        inst.components.trader.acceptnontradable = true
        inst.components.trader:SetAcceptTest(function(inst, item, giver)
            if inst.treeState == 0 then
                return false
            end
            local treeitems = {
                reviver = true,
                yellowamulet = true,
                yellowstaff = true,
                yellowmooneye = true
            }
            if treeitems[item.prefab] then
                return true
            else
                return false
            end
        end)
        inst.components.trader.onaccept = function(inst, giver, item)
            if inst.tradeditems == nil then
                inst.tradeditems = { light = 0, health = 0 }
            end
            if item.prefab == "reviver" then
                OnStealLife(inst, 40)
                inst.tradeditems.health = inst.tradeditems.health + 1
            else
                OnStealLife(inst, 320)
                inst.tradeditems.light = inst.tradeditems.light + 1
            end

            if giver.components.talker ~= nil then
                local wordkey
                if inst.tradeditems.light < 2 then
                    if inst.tradeditems.health < 8 then
                        wordkey = "NEEDALL"
                    else
                        wordkey = "NEEDLIGHT"
                    end
                else
                    if inst.tradeditems.health < 8 then
                        wordkey = "NEEDHEALTH"
                    else
                        wordkey = "NONEED"
                    end
                end
                giver.components.talker:Say(GetString(giver, "DESCRIBE", { "SIVING_THETREE", wordkey }))
            end

            if inst.tradeditems.light >= 2 and inst.tradeditems.health >= 8 then --达成条件，该召唤BOSS了
                if
                    inst.bossBirds == nil and
                    not inst.components.timer:TimerExists("birdstart") and
                    not inst.components.timer:TimerExists("birdstart2")
                then
                    inst.components.timer:StartTimer("birdstart", 5)
                    inst.tradeditems.light = inst.tradeditems.light - 2
                    inst.tradeditems.health = inst.tradeditems.health - 8
                end
            end
        end
        inst.components.trader.onrefuse = function(inst, giver, item)
            if giver.components.talker ~= nil then
                giver.components.talker:Say(GetString(giver, "DESCRIBE", { "SIVING_THETREE", "NOTTHIS" }))
            end
        end

        MakeHauntableWork(inst)

        inst:AddComponent("timer")
        inst:ListenForEvent("timerdone", function(inst, data)
            if data.name == "birdrebirth" then
                StateChange(inst)
            elseif data.name == "birdstart" or data.name == "birdstart2" then
                local pos = inst:GetPosition()
                local offset1 = FindWalkableOffset(pos, 2*PI*math.random(), 3+math.random()*3, 8, false, true)
                local offset2 = FindWalkableOffset(pos, 2*PI*math.random(), 3+math.random()*3, 8, false, true)

                if offset1 ~= nil or offset2 ~= nil then
                    local offsetfinal = offset1 or offset2
                    inst.bossBirds = {}

                    local boss1 = SpawnPrefab("siving_moenix")
                    inst.bossBirds.male = boss1
                    boss1.fn_onBorn(boss1, inst)
                    boss1.Transform:SetPosition(pos.x + offsetfinal.x, pos.y, pos.z + offsetfinal.z)
                    -- boss1.sg:GoToState("glide") --undo

                    if offset2 ~= nil then
                        offsetfinal = offset2
                    end
                    local boss2 = SpawnPrefab("siving_foenix")
                    inst.bossBirds.female = boss2
                    boss2.fn_onBorn(boss2, inst)
                    boss2.Transform:SetPosition(pos.x + offsetfinal.x, pos.y, pos.z + offsetfinal.z)
                    -- boss2.sg:GoToState("glide") --undo

                    boss1.mate = boss2
                    boss2.mate = boss1
                elseif data.name == "birdstart" then --一次没成功，再试一次
                    inst.components.timer:StartTimer("birdstart2", 10)
                else --两次都没找到合适的位置下落，就不来了
                    if inst.tradeditems == nil then
                        inst.tradeditems = { light = 0, health = 0 }
                    end
                    inst.tradeditems.light = inst.tradeditems.light + 2
                    inst.tradeditems.health = inst.tradeditems.health + 8
                end
            end
        end)

        inst:WatchWorldState("isspring", StateChange)
        inst.taskState = inst:DoTaskInTime(0.1, function(inst)
            StateChange(inst)
            inst.taskState = nil
        end)

        inst.OnSave = function(inst, data)
            if inst.countWorked > 0 then
                data.countWorked = inst.countWorked
            end
            if inst.countHealth > 0 then
                data.countHealth = inst.countHealth
            end
            if inst.tradeditems ~= nil then
                if inst.tradeditems.health > 0 then
                    data.traded_health = inst.tradeditems.health
                end
                if inst.tradeditems.light > 0 then
                    data.traded_light = inst.tradeditems.light
                end
            end
        end
        inst.OnLoad = function(inst, data)
            if data ~= nil then
                if data.countWorked ~= nil then
                    inst.countWorked = data.countWorked
                end
                if data.countHealth ~= nil then
                    inst.countHealth = data.countHealth
                end
                if data.traded_health ~= nil or data.traded_light ~= nil then
                    inst.tradeditems = { light = 0, health = 0 }
                    if data.traded_health ~= nil then
                        inst.tradeditems.health = data.traded_health
                    end
                    if data.traded_light ~= nil then
                        inst.tradeditems.light = data.traded_light
                    end
                end
            end

            if inst.taskState ~= nil then
                inst.taskState:Cancel()
                inst.taskState = nil
            end
            StateChange(inst)
        end
        inst.OnEntityWake = AddLivesListen --实体产生时，在玩家范围内就会执行
        inst.OnEntitySleep = RemoveLivesListen

        return inst
    end,
    {
        Asset("SCRIPT", "scripts/prefabs/wortox_soul_common.lua"),
        Asset("ANIM", "anim/siving_thetree.zip"),
        Asset("ANIM", "anim/siving_thetree_live.zip"),
    },
    {
        "siving_rocks",
        "siving_lifesteal_fx",
        "siving_foenix",
        "siving_moenix"
    }
))

--------------------------------------------------------------------------
--[[ 生命吸收的特效 ]]
--------------------------------------------------------------------------

table.insert(prefs, Prefab(
    "siving_lifesteal_fx",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeGhostPhysics(inst, 1, 0.15)
        RemovePhysicsColliders(inst)

        inst.AnimState:SetBank("lifeplant_fx")
        inst.AnimState:SetBuild("lifeplant_fx")
        inst.AnimState:PlayAnimation("single"..math.random(1,3), true)
        inst.AnimState:SetMultColour(15/255, 180/255, 132/255, 1)
        inst.AnimState:SetScale(0.6, 0.6)

        inst:AddTag("flying")
        inst:AddTag("NOCLICK")
        inst:AddTag("FX")
        inst:AddTag("NOBLOCK")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false
        inst.taskMove = nil
        inst.movingTarget = nil
        inst.OnReachTarget = nil
        inst.minDistanceSq = 3.3 --1.8*1.8+0.06
        inst._count = 0

        inst:AddComponent("locomotor")
        inst.components.locomotor.walkspeed = 2
        inst.components.locomotor.runspeed = 2
        inst.components.locomotor:SetTriggersCreep(false)
        inst.components.locomotor:EnableGroundSpeedMultiplier(false)
        inst.components.locomotor.pathcaps = { ignorewalls = true, allowocean = true }

        inst:AddComponent("bloomer")
        inst.components.bloomer:PushBloom("lifesteal", "shaders/anim.ksh", 1)

        inst:DoTaskInTime(0, function()
            if inst.movingTarget == nil or not inst.movingTarget:IsValid() then
                inst:Remove()
            else
                inst:ForceFacePoint(inst.movingTarget.Transform:GetWorldPosition())
                inst.components.locomotor:WalkForward()
                inst.taskMove = inst:DoPeriodicTask(0.1, function()
                    if inst.movingTarget == nil or not inst.movingTarget:IsValid() then
                        if inst.taskMove ~= nil then
                            inst.taskMove:Cancel()
                            inst.taskMove = nil
                        end
                        inst:Remove()
                    elseif inst._count >= 129 or inst:GetDistanceSqToInst(inst.movingTarget) <= inst.minDistanceSq then
                        if inst.OnReachTarget ~= nil then
                            inst.OnReachTarget()
                        end
                        if inst.taskMove ~= nil then
                            inst.taskMove:Cancel()
                            inst.taskMove = nil
                        end
                        inst:Remove()
                    else --更新目标地点
                        inst:ForceFacePoint(inst.movingTarget.Transform:GetWorldPosition())
                        inst._count = inst._count + 1
                    end
                end, 0)
            end
        end)
        inst.OnEntitySleep = function(inst)
            if inst.OnReachTarget ~= nil then
                inst.OnReachTarget()
            end
            if inst.taskMove ~= nil then
                inst.taskMove:Cancel()
                inst.taskMove = nil
            end
            inst:Remove()
        end

        return inst
    end,
    {
        Asset("ANIM", "anim/lifeplant_fx.zip"),
    },
    nil
))

--------------------------------------------------------------------------
--[[ 子圭·垄(物品) ]]
--------------------------------------------------------------------------

table.insert(prefs, Prefab(
    "siving_soil_item",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("siving_soil")
        inst.AnimState:SetBuild("siving_soil")
        inst.AnimState:PlayAnimation("item")

        inst:AddTag("molebait")
        inst:AddTag("eyeturret") --眼球塔的专属标签，但为了deployable组件的摆放名字而使用（显示为“放置”）

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

        inst:AddComponent("inspectable")

        inst:AddComponent("tradable")
        inst.components.tradable.rocktribute = 18 --延缓 0.33x18 天地震
        inst.components.tradable.goldvalue = 15 --换1个砂之石或15金块

        inst:AddComponent("bait")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = "siving_soil_item"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/siving_soil_item.xml"
        inst.components.inventoryitem:SetSinks(true)

        inst:AddComponent("deployable")
        inst.components.deployable.ondeploy = function(inst, pt, deployer)
            local tree = SpawnPrefab("siving_soil")
            if tree ~= nil then
                tree.Transform:SetPosition(pt:Get())
                inst.components.stackable:Get():Remove()

                if deployer ~= nil and deployer.SoundEmitter ~= nil then
                    deployer.SoundEmitter:PlaySound("dontstarve/wilson/plant_seeds")
                end
            end
        end
        inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM) --和草根一样的放置范围限制

        MakeHauntableLaunchAndIgnite(inst)

        return inst
    end,
    {
        Asset("ANIM", "anim/farm_soil.zip"), --官方栽培土动画模板（为了placer加载的）
        Asset("ANIM", "anim/siving_soil.zip"),
        Asset("ATLAS", "images/inventoryimages/siving_soil_item.xml"),
        Asset("IMAGE", "images/inventoryimages/siving_soil_item.tex"),
    },
    { "siving_soil" }
))

--子圭·垄(placer)
table.insert(prefs, MakePlacer("siving_soil_item_placer", "farm_soil", "siving_soil", "till_idle"))

--------------------------------------------------------------------------
--[[ 子圭·垄 ]]
--------------------------------------------------------------------------

table.insert(prefs, Prefab(
    "siving_soil",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("farm_soil")
        inst.AnimState:SetBuild("siving_soil")
        -- inst.AnimState:PlayAnimation("till_idle")

        inst:AddTag("soil_legion")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst:DoTaskInTime(0, function()
            inst.AnimState:PlayAnimation("till_rise")
            inst.AnimState:PushAnimation("till_idle", false)
        end)

        inst:AddComponent("inspectable")

        inst:AddComponent("lootdropper")

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnFinishCallback(function(inst, worker)
            inst.components.lootdropper:SpawnLootPrefab("siving_soil_item")
            inst:Remove()
        end)

        MakeHauntableWork(inst)

        return inst
    end,
    {
        Asset("ANIM", "anim/farm_soil.zip"), --官方栽培土动画模板
        Asset("ANIM", "anim/siving_soil.zip"),
    },
    { "siving_soil_item" }
))

--------------------
--------------------

return unpack(prefs)
