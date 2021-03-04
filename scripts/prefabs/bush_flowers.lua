
local function setberries(inst, pct)    --设置果实的贴图
    if inst._setberriesonanimover then
        inst._setberriesonanimover = nil
        inst:RemoveEventCallback("animover", setberries)
    end

    local berries =
        (pct == nil and "") or
        (pct >= .9 and "berriesmost") or
        (pct >= .33 and "berriesmore") or
        "berries"

    for i, v in ipairs({ "berries", "berriesmore", "berriesmost" }) do
        if v == berries then
            inst.AnimState:Show(v)
        else
            inst.AnimState:Hide(v)
        end
    end
end

local function setberriesonanimover(inst)
    if inst._setberriesonanimover then
        setberries(inst, nil)
    else
        inst._setberriesonanimover = true
        inst:ListenForEvent("animover", setberries)
    end
end

local function cancelsetberriesonanimover(inst)
    if inst._setberriesonanimover then
        setberries(inst, nil)
    end
end

---------------------------------------------------------------------------------

local function makeemptyfn(inst)    --施肥、浇水时
    if POPULATING then
        inst.AnimState:PlayAnimation("idle", true)
        inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
    elseif inst:HasTag("withered") or inst.AnimState:IsCurrentAnimation("dead") then
        inst.AnimState:PlayAnimation("dead_to_idle")
        inst.AnimState:PushAnimation("idle")
    else
        inst.AnimState:PlayAnimation("idle", true)
    end

    inst:AddTag("flower")   --添加花的标签

    setberries(inst, nil)   --才“复活”时是没有果实的
end

local function makebarrenfn(inst)--, wasempty)  --枯萎函数
    if not POPULATING and (inst:HasTag("withered") or inst.AnimState:IsCurrentAnimation("idle")) then
        inst.AnimState:PlayAnimation("idle_to_dead")
        inst.AnimState:PushAnimation("dead", false)
    else
        inst.AnimState:PlayAnimation("dead")
    end
    cancelsetberriesonanimover(inst)

    inst:RemoveTag("flower")   --移除花的标签
end

local function shake(inst)
    if inst.components.pickable ~= nil and
        not inst.components.pickable:CanBePicked() and
        inst.components.pickable:IsBarren() then
        inst.AnimState:PlayAnimation("shake_dead")
        inst.AnimState:PushAnimation("dead", false)
    else
        inst.AnimState:PlayAnimation("shake")
        inst.AnimState:PushAnimation("idle")
    end
    cancelsetberriesonanimover(inst)
end

--[[
local function spawnperd(inst)  --产生火鸡的函数
    if inst:IsValid() then
        local perd = SpawnPrefab("perd")
        local x, y, z = inst.Transform:GetWorldPosition()
        local angle = math.random() * 2 * PI
        perd.Transform:SetPosition(x + math.cos(angle), 0, z + math.sin(angle))
        perd.sg:GoToState("appear")
        perd.components.homeseeker:SetHome(inst)
        shake(inst)
    end
end
]]--

---------------------------------------------------------------------------------

local function onpickedfn(inst, picker) --通用采集函数
    if inst.components.pickable ~= nil then
        --V2C: nil cycles_left means unlimited picks, so use max value for math
        --local old_percent = inst.components.pickable.cycles_left ~= nil and (inst.components.pickable.cycles_left + 1) / inst.components.pickable.max_cycles or 1
        --setberries(inst, old_percent)
        if inst.components.pickable:IsBarren() then --枯萎时就播放相应动画和对应设置
            inst.AnimState:PlayAnimation("idle_to_dead")    --播放动画，后面继续play会被后面的覆盖掉，不想被覆盖就用push
            inst.AnimState:PushAnimation("dead", false)     --等待上一个动画播放完才播放这个
            setberries(inst, nil)
        else
            inst.AnimState:PlayAnimation("picked")
            inst.AnimState:PushAnimation("idle")
            setberriesonanimover(inst)
        end
    end
    --[[
    if not picker:HasTag("berrythief") and  --不是火鸡的生物采集时会产生火鸡
        math.random() < (IsSpecialEventActive(SPECIAL_EVENTS.YOTG) and TUNING.YOTG_PERD_SPAWNCHANCE or TUNING.PERD_SPAWNCHANCE) then
        inst:DoTaskInTime(3 + math.random() * 3, spawnperd)
    end
    ]]--
end

local function SpawnMyLoot(bush, picker, itemname, itemnumber, mustdrop)
    if picker.components.inventory ~= nil and not mustdrop then
        for i = 1, itemnumber do
            local item = SpawnPrefab(itemname)
            if item ~= nil then
                picker.components.inventory:GiveItem(item)
            end
        end
    elseif bush.components.lootdropper ~= nil then
        for i = 1, itemnumber do
            bush.components.lootdropper:SpawnLootPrefab(itemname)
        end
    else
        for i = 1, itemnumber do
            local item = SpawnPrefab(itemname)
            if item ~= nil then
                if item.Physics ~= nil then
                    item.Physics:Teleport(bush.Transform:GetWorldPosition())
                else
                    item.Transform:SetPosition(bush.Transform:GetWorldPosition())
                end
            end
        end
    end
end

local function onpickedRosefn(inst, picker) --玫瑰花丛采集函数
    if inst.components.pickable ~= nil then
        if inst.components.pickable:IsBarren() then
            inst.AnimState:PlayAnimation("idle_to_dead")
            inst.AnimState:PushAnimation("dead", false)
            setberries(inst, nil)

            inst:RemoveTag("flower")   --移除花的标签
        else
            inst.AnimState:PlayAnimation("picked")
            inst.AnimState:PushAnimation("idle")
            setberriesonanimover(inst)
        end

        --采集时被刺伤
        if
            picker.components.combat ~= nil and
            not (
                picker.components.inventory ~= nil and
                (
                    picker.components.inventory:EquipHasTag("bramble_resistant") or
                    (CONFIGS_LEGION.ENABLEDMODS.MythWords and picker.components.inventory:Has("thorns_pill", 1))
                )
            )
        then
            picker.components.combat:GetAttacked(inst, TUNING.MARSHBUSH_DAMAGE) --荆棘的伤害值

            if math.random() <= 0.01 and picker.task_pick_rosebush == nil and picker.components.talker ~= nil then
                picker.task_pick_rosebush = picker:DoTaskInTime(0, function()
                    picker.components.talker:Say(GetString(picker, "ANNOUNCE_PICK_ROSEBUSH"))
                    picker.task_pick_rosebush = nil
                end)
            else
                picker:PushEvent("thorns")
            end
        end

        local loot = math.random()
        if loot <= 0.3 then    --30%几率掉落花瓣,60%几率掉落树枝，10%几率掉落玫瑰枝条
            SpawnMyLoot(inst, picker, "petals", 1, false)
        elseif loot <= 0.9 then
            SpawnMyLoot(inst, picker, "twigs", 1, false)
        else
            SpawnMyLoot(inst, picker, "cutted_rosebush", 1, true) --掉落玫瑰枝条
        end
        if math.random() <= CONFIGS_LEGION.FLOWERWEAPONSCHANCE then --3%几率掉落剑
            SpawnMyLoot(inst, picker, "rosorns", 1, true)
        end
    end
end

local function onpickedLilyfn(inst, picker) --蹄莲花丛采集函数
    if inst.components.pickable ~= nil then
        if inst.components.pickable:IsBarren() then
            inst.AnimState:PlayAnimation("idle_to_dead")
            inst.AnimState:PushAnimation("dead", false)
            setberries(inst, nil)

            inst:RemoveTag("flower")   --移除花的标签
        else
            inst.AnimState:PlayAnimation("picked")
            inst.AnimState:PushAnimation("idle")
            setberriesonanimover(inst)
        end

        local loot = math.random()
        if loot <= 0.6 then    --30%几率掉落2花瓣,60%几率掉落1花瓣，10%几率掉落蹄莲幼苗
            SpawnMyLoot(inst, picker, "petals", 1, false)
        elseif loot <= 0.9 then
            SpawnMyLoot(inst, picker, "petals", 2, false)
        else
            SpawnMyLoot(inst, picker, "cutted_lilybush", 1, true) --掉落蹄莲幼苗
        end
        if math.random() <= CONFIGS_LEGION.FLOWERWEAPONSCHANCE then --3%几率掉落剑
            SpawnMyLoot(inst, picker, "lileaves", 1, true)
        end
    end
end

local function onpickedOrchidfn(inst, picker) --兰草花丛采集函数
    if inst.components.pickable ~= nil then
        if inst.components.pickable:IsBarren() then
            inst.AnimState:PlayAnimation("idle_to_dead")
            inst.AnimState:PushAnimation("dead", false)
            setberries(inst, nil)

            inst:RemoveTag("flower")   --移除花的标签
        else
            inst.AnimState:PlayAnimation("picked")
            inst.AnimState:PushAnimation("idle")
            setberriesonanimover(inst)
        end

        local loot = math.random()
        if loot <= 0.6 then    --30%几率掉落花瓣,60%几率掉落干草，10%几率掉落兰花种子
            SpawnMyLoot(inst, picker, "cutgrass", 1, false)
        elseif loot <= 0.9 then
            SpawnMyLoot(inst, picker, "petals", 1, false)
        else
            SpawnMyLoot(inst, picker, "cutted_orchidbush", 1, true) --掉落兰花种子
        end
        if math.random() <= CONFIGS_LEGION.FLOWERWEAPONSCHANCE then --3%几率掉落剑
            SpawnMyLoot(inst, picker, "orchitwigs", 1, true)
        end
    end
end

local function onpickedNeverfadefn(inst, picker) --不零花丛采集函数
    if inst.components.pickable ~= nil then
        inst.AnimState:PlayAnimation("picked")
        setberries(inst, nil)
        inst:ListenForEvent("animover", inst.Remove)    --动画播放完毕时去除实体
    end
end

---------------------------------------------------------------------------------

local function getregentimefn_rose(inst)  --重新计算成熟时间，把以下的时间改成自己设定的时间
    if inst.components.pickable == nil then
        return TUNING.BERRY_REGROW_TIME * 2 --改成自己的时间
    end
    --V2C: nil cycles_left means unlimited picks, so use max value for math
    local max_cycles = inst.components.pickable.max_cycles
    local cycles_left = inst.components.pickable.cycles_left or max_cycles
    local num_cycles_passed = math.max(0, max_cycles - cycles_left)
    return TUNING.BERRY_REGROW_TIME * 2 --改成自己的时间
        + TUNING.BERRY_REGROW_INCREASE * num_cycles_passed
        + TUNING.BERRY_REGROW_VARIANCE * math.random()
end

local function getregentimefn_neverfade(inst)  --重新计算成熟时间，把以下的时间改成自己设定的时间
    if inst.components.pickable == nil then
        return TUNING.BERRY_REGROW_TIME / 2 --改成自己的时间
    end
    --V2C: nil cycles_left means unlimited picks, so use max value for math
    local max_cycles = inst.components.pickable.max_cycles
    local cycles_left = inst.components.pickable.cycles_left or max_cycles
    local num_cycles_passed = math.max(0, max_cycles - cycles_left)
    return TUNING.BERRY_REGROW_TIME / 2 --改成自己的时间
        + TUNING.BERRY_REGROW_INCREASE * num_cycles_passed
        + TUNING.BERRY_REGROW_VARIANCE * math.random()
end

--[[
local function getregentimefn_juicy(inst)
    if inst.components.pickable == nil then
        return TUNING.BERRY_JUICY_REGROW_TIME
    end
    --V2C: nil cycles_left means unlimited picks, so use max value for math
    local max_cycles = inst.components.pickable.max_cycles
    local cycles_left = inst.components.pickable.cycles_left or max_cycles
    local num_cycles_passed = math.max(0, max_cycles - cycles_left)
    return TUNING.BERRY_JUICY_REGROW_TIME
        + TUNING.BERRY_JUICY_REGROW_INCREASE * num_cycles_passed
        + TUNING.BERRY_JUICY_REGROW_VARIANCE * math.random()
end
]]--

local function makefullfn(inst) --果实成熟期
    local anim = "idle"
    local berries = nil
    if inst.components.pickable ~= nil then
        if inst.components.pickable:CanBePicked() then
            berries = inst.components.pickable.cycles_left ~= nil and inst.components.pickable.cycles_left / inst.components.pickable.max_cycles or 1
        elseif inst.components.pickable:IsBarren() then
            anim = "dead"
        end
    end
    if anim ~= "idle" then
        inst.AnimState:PlayAnimation(anim)
    elseif POPULATING then
        inst.AnimState:PlayAnimation("idle", true)
        inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
    else
        inst.AnimState:PlayAnimation("grow")
        inst.AnimState:PushAnimation("idle", true)
    end
    setberries(inst, berries)
end

---------------------------------------------------------------------------------

local function onworked_juicy(inst, worker, workleft)
    --This is possible when beaver is gnaw-digging the bush,
    --and the expected behaviour should be same as jostling.
    if workleft > 0 and
        inst.components.lootdropper ~= nil and
        inst.components.pickable ~= nil and
        inst.components.pickable.droppicked and
        inst.components.pickable:CanBePicked() then
        inst.components.pickable:Pick(worker)
    end
end

--[[
local function dig_up_common(inst, worker, numberries)  --被挖起来的通用函数
    if inst.components.pickable ~= nil and inst.components.lootdropper ~= nil then
        local withered = inst.components.witherable ~= nil and inst.components.witherable:IsWithered()

        if withered or inst.components.pickable:IsBarren() then --枯萎时被挖起
            inst.components.lootdropper:SpawnLootPrefab("twigs")
            inst.components.lootdropper:SpawnLootPrefab("twigs")
        else
            if inst.components.pickable:CanBePicked() then  --有果实的话
                local pt = inst:GetPosition()
                pt.y = pt.y + (inst.components.pickable.dropheight or 0)
                for i = 1, numberries do
                    inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product, pt)
                end
            end
            inst.components.lootdropper:SpawnLootPrefab("dug_"..inst.prefab)
        end
    end
    inst:Remove()
end
]]--

local function dig_up_rose(inst, worker)
    if inst.components.pickable ~= nil and inst.components.lootdropper ~= nil then
        local withered = inst.components.witherable ~= nil and inst.components.witherable:IsWithered()

        if withered or inst.components.pickable:IsBarren() then --枯萎时被挖起
            inst.components.lootdropper:SpawnLootPrefab("twigs")
            inst.components.lootdropper:SpawnLootPrefab("twigs")
        else
            if inst.components.pickable:CanBePicked() then  --有果实时被挖起
                inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
                if math.random(1,100) <= 3 then --3%几率掉落剑
                    inst.components.lootdropper:SpawnLootPrefab("rosorns")
                end
                local loot = math.random()
                if loot <= 0.3 then    --30%几率掉落花瓣,60%几率掉落树枝，10%几率掉落玫瑰枝条
                    inst.components.lootdropper:SpawnLootPrefab("petals")
                elseif loot <= 0.9 then
                    inst.components.lootdropper:SpawnLootPrefab("twigs")
                else 
                    inst.components.lootdropper:SpawnLootPrefab("cutted_rosebush")    --掉落玫瑰枝条
                end
            end
            inst.components.lootdropper:SpawnLootPrefab("dug_"..inst.prefab)
        end
    end
    inst:Remove()
end

local function dig_up_lily(inst, worker)
    if inst.components.pickable ~= nil and inst.components.lootdropper ~= nil then
        local withered = inst.components.witherable ~= nil and inst.components.witherable:IsWithered()

        if withered or inst.components.pickable:IsBarren() then --枯萎时被挖起
            inst.components.lootdropper:SpawnLootPrefab("twigs")
            inst.components.lootdropper:SpawnLootPrefab("twigs")
        else
            if inst.components.pickable:CanBePicked() then  --有果实时被挖起
                inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
                if math.random(1,100) <= 3 then --3%几率掉落剑
                    inst.components.lootdropper:SpawnLootPrefab("lileaves")
                end
                local loot = math.random()
                if loot <= 0.6 then    --30%几率掉落2花瓣,60%几率掉落1花瓣，10%几率掉落蹄莲幼苗
                    inst.components.lootdropper:SpawnLootPrefab("petals")
                elseif loot <= 0.9 then
                    inst.components.lootdropper:SpawnLootPrefab("petals")
                    inst.components.lootdropper:SpawnLootPrefab("petals")
                else 
                    inst.components.lootdropper:SpawnLootPrefab("cutted_lilybush")    --掉落蹄莲幼苗
                end
            end
            inst.components.lootdropper:SpawnLootPrefab("dug_"..inst.prefab)
        end
    end
    inst:Remove()
end

local function dig_up_orchid(inst, worker)
    if inst.components.pickable ~= nil and inst.components.lootdropper ~= nil then
        local withered = inst.components.witherable ~= nil and inst.components.witherable:IsWithered()

        if withered or inst.components.pickable:IsBarren() then --枯萎时被挖起
            inst.components.lootdropper:SpawnLootPrefab("cutgrass")
            inst.components.lootdropper:SpawnLootPrefab("cutgrass")
        else
            if inst.components.pickable:CanBePicked() then  --有果实时被挖起
                inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
                if math.random(1,100) <= 3 then --3%几率掉落剑
                    inst.components.lootdropper:SpawnLootPrefab("orchitwigs")
                end
                local loot = math.random()
                if loot <= 0.6 then    --30%几率掉落花瓣,60%几率掉落干草，10%几率掉落兰花种子
                    inst.components.lootdropper:SpawnLootPrefab("cutgrass")
                elseif loot <= 0.9 then
                    inst.components.lootdropper:SpawnLootPrefab("petals")
                else 
                    inst.components.lootdropper:SpawnLootPrefab("cutted_orchidbush")    --掉落兰花种子
                end
            end
            inst.components.lootdropper:SpawnLootPrefab("dug_"..inst.prefab)
        end
    end
    inst:Remove()
end

--[[
local function dig_up_juicy(inst, worker)
    dig_up_common(inst, worker, 3)
end
]]--

---------------------------------------------------------------------------------

local function ontransplantfn(inst) --才移植时，一般在植物种在地上时触发
    inst.AnimState:PlayAnimation("dead")
    setberries(inst, nil)
    inst.components.pickable:MakeBarren()   --置为枯萎状态
end

local function ontransplantNeverfadeFn(inst) --才移植时
    inst.components.pickable:MakeEmpty()    --直接进入生长状态
end

local function OnHaunt(inst)    --被作祟时
    if math.random() <= TUNING.HAUNT_CHANCE_ALWAYS then
        shake(inst)
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_COOLDOWN_TINY
        return true
    end
    return false
end

---------------------------------------------------------------------------------

local function createbush(name, inspectname, fruitname, master_postinit)
    local assets =
    {
        Asset("ANIM", "anim/berrybush2.zip"), --官方猪村浆果丛动画
        Asset("ANIM", "anim/"..name..".zip"),
    }

    local prefabs =
    {
        fruitname,  --收获物
        "dug_"..name,
        --"perd", --火鸡代码
    }

    if name == "rosebush" then  --插入prefabs语句需要写在fn外
        table.insert(prefabs, "rosorns")
        table.insert(prefabs, "twigs")
        table.insert(prefabs, "petals")
        table.insert(prefabs, "cutted_"..name)
    elseif name == "lilybush" then
        table.insert(prefabs, "lileaves")
        table.insert(prefabs, "twigs")
        table.insert(prefabs, "petals")
        table.insert(prefabs, "cutted_"..name)
    elseif name == "orchidbush" then
        table.insert(prefabs, "orchitwigs")
        table.insert(prefabs, "cutgrass")
        table.insert(prefabs, "petals")
        table.insert(prefabs, "cutted_"..name)
    elseif name == "neverfadebush" then
        prefabs = {
            fruitname,
        }
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()
        
        if name == "rosebush" then
            MakeSmallObstaclePhysics(inst, .1)
            inst:AddTag("flower")   --添加花的标签
            inst:AddTag("thorny") --添加多刺标签
        elseif name == "lilybush" then
            MakeSmallObstaclePhysics(inst, .1)
            inst:AddTag("flower")
        elseif name == "orchidbush" then
            --MakeSmallObstaclePhysics(inst, .1)    --不写就是没有遮挡体积
            inst:AddTag("flower")
        elseif name == "neverfadebush" then
            MakeSmallObstaclePhysics(inst, .1)
            inst:AddTag("flower")
        end

        inst:AddTag("bush")
        inst:AddTag("plant")

        --witherable (from witherable component) added to pristine state for optimization
        if name ~= "neverfadebush" then
            inst:AddTag("witherable")   --添加可枯萎标签
            inst:AddTag("renewable")
        end 

        inst.MiniMapEntity:SetIcon(name..".tex")   --设置在地图上的图标，需要像人物一样先在modmain中先声明xml才行

        inst.AnimState:SetBank("berrybush2")    --使用官方的动画模板，因为反编译出来的动画模板有很多问题
        inst.AnimState:SetBuild(name)
        inst.AnimState:PlayAnimation("idle", true)
        setberries(inst, 1) --这里指默认的果实状态

        if name ~= "orchidbush" and name ~= "neverfadebush" then    --兰草花丛、不零花丛不要积雪
            MakeSnowCoveredPristine(inst)   --冬季被雪覆盖(初始化)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        ------------------------

        inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())

        inst:AddComponent("pickable")   --可采集组件
        inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries"
        inst.components.pickable.onpickedfn = onpickedfn
        inst.components.pickable.makeemptyfn = makeemptyfn
        inst.components.pickable.makebarrenfn = makebarrenfn
        inst.components.pickable.makefullfn = makefullfn
        inst.components.pickable.ontransplantfn = ontransplantfn

        if name ~= "neverfadebush" then
            inst:AddComponent("witherable") --添加可枯萎组件
        end

        MakeHauntableIgnite(inst)
        AddHauntableCustomReaction(inst, OnHaunt, false, false, true)

        if name ~= "neverfadebush" then
            inst:AddComponent("lootdropper")
        end

        if name ~= "neverfadebush" then
            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(ACTIONS.DIG) --设置可挖掘
            inst.components.workable:SetWorkLeft(1)
        end

        inst:AddComponent("inspectable")    --可检查

        inst:ListenForEvent("onwenthome", shake)    --监听玩家在附近事件，进行抖动动画

        if name ~= "orchidbush" and name ~= "neverfadebush" then
            MakeSnowCovered(inst)   --冬季被雪覆盖
        end
        if name ~= "neverfadebush" then
            MakeNoGrowInWinter(inst)    --冬季停止生长
        end

        master_postinit(inst)   --之所以写在最后面是为了让特殊性质覆盖前面的通用性质

        --[[
        if IsSpecialEventActive(SPECIAL_EVENTS.YOTG) then   --如果是火鸡年节日，监听火鸡的产生
            inst:ListenForEvent("spawnperd", spawnperd)
        end
        ]]--

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

---------------------------------------------------------------------------------

local function rose_postinit(inst)    --玫瑰花丛的特殊性质函数
    inst.components.pickable:SetUp("petals_rose", TUNING.BERRY_REGROW_TIME * 2) --6天的成熟时间，并设置了采集收获物
    inst.components.pickable.getregentimefn = getregentimefn_rose   --成熟时间计算
    inst.components.pickable.max_cycles = TUNING.BERRYBUSH_CYCLES + math.random(2)
    inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
    inst.components.pickable.onpickedfn = onpickedRosefn    --因为玫瑰花丛带刺，所以单独写个采集的函数

    inst.components.workable:SetOnFinishCallback(dig_up_rose)

    MakeLargeBurnable(inst) --燃烧时使用大体积火的动画
    MakeMediumPropagator(inst)  --火焰中型体积
end

local function lily_postinit(inst)    --蹄莲花丛的特殊性质函数
    inst.components.pickable:SetUp("petals_lily", TUNING.BERRY_REGROW_TIME * 2) --6天的成熟时间，并设置了采集收获物
    inst.components.pickable.getregentimefn = getregentimefn_rose   --成熟时间计算，三种花丛都和玫瑰花丛一样
    inst.components.pickable.max_cycles = TUNING.BERRYBUSH_CYCLES + math.random(2)
    inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
    inst.components.pickable.onpickedfn = onpickedLilyfn    --每个花丛采集物都不一样，所以单独写个采集的函数

    inst.components.workable:SetOnFinishCallback(dig_up_lily)

    MakeLargeBurnable(inst) --燃烧时使用大体积火的动画
    MakeMediumPropagator(inst)  --火焰中型体积
end

local function orchid_postinit(inst)    --君兰花丛的特殊性质函数
    inst.components.pickable:SetUp("petals_orchid", TUNING.BERRY_REGROW_TIME * 2) --6天的成熟时间，并设置了采集收获物
    inst.components.pickable.getregentimefn = getregentimefn_rose   --成熟时间计算，三种花丛都和玫瑰花丛一样
    inst.components.pickable.max_cycles = TUNING.BERRYBUSH_CYCLES + math.random(2)
    inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
    inst.components.pickable.onpickedfn = onpickedOrchidfn    --每个花丛采集物都不一样，所以单独写个采集的函数

    inst.components.workable:SetOnFinishCallback(dig_up_orchid)

    MakeMediumBurnable(inst)    --中火
    MakeSmallPropagator(inst)   --火焰小体积
end

local function neverfade_postinit(inst)    --不零花丛的特殊性质函数
    inst.components.pickable.ontransplantfn = ontransplantNeverfadeFn   --不零花丛的独特移植时函数
    inst.components.pickable:SetUp("neverfade", TUNING.BERRY_REGROW_TIME) --3天的成熟时间，并设置了采集收获物
    inst.components.pickable.getregentimefn = getregentimefn_neverfade   --成熟时间计算
    inst.components.pickable.max_cycles = TUNING.BERRYBUSH_CYCLES + math.random(2)
    inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
    inst.components.pickable.onpickedfn = onpickedNeverfadefn    --每个花丛采集物都不一样，所以单独写个采集的函数

    --MakeMediumBurnable(inst)    --不零花丛不能着火
    --MakeSmallPropagator(inst)
end

--[[
local function juicy_postinit(inst)
    inst.components.pickable:SetUp("berries_juicy", TUNING.BERRY_JUICY_REGROW_TIME, 3)
    inst.components.pickable.getregentimefn = getregentimefn_juicy
    inst.components.pickable.max_cycles = TUNING.BERRYBUSH_JUICY_CYCLES + math.random(2)
    inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
    inst.components.pickable.jostlepick = true
    inst.components.pickable.droppicked = true
    inst.components.pickable.dropheight = 3.5

    inst.components.workable:SetOnWorkCallback(onworked_juicy)
    inst.components.workable:SetOnFinishCallback(dig_up_juicy)
end
]]--

return --createbush("berrybush", "berrybush", "berries", normal_postinit),
    createbush("rosebush", "rosebush", "petals_rose", rose_postinit),
    createbush("lilybush", "lilybush", "petals_lily", lily_postinit),
    createbush("orchidbush", "orchidbush", "petals_orchid", orchid_postinit),
    createbush("neverfadebush", "neverfadebush", "neverfade", neverfade_postinit)
