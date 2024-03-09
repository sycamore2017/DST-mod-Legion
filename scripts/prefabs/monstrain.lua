local TOOLS_L = require("tools_legion")
local assets = {
    Asset("ANIM", "anim/monstrain.zip")
}
local prefabs = {
    "raindonate",
    "squamousfruit",
    "monstrain_leaf",
    "dug_monstrain"
}

-------------------------

local function setfruit(inst, hasfruit) --设置果实的贴图
    if inst._setfruitonanimover then
        inst._setfruitonanimover = nil
        inst:RemoveEventCallback("animover", setfruit)
    end

    if hasfruit then
        inst.AnimState:Show("fruit") --这里参数为动画中贴图的设定名字，不是通道名
    else
        inst.AnimState:Hide("fruit")
    end
end
local function setfruitonanimover(inst) --在一个动画播放结束才隐藏果实贴图
    if inst._setfruitonanimover then
        setfruit(inst, false)
    else
        inst._setfruitonanimover = true
        inst:ListenForEvent("animover", setfruit)
    end
end
local function cancelsetfruitonanimover(inst) --取消在一个动画播放结束才隐藏果实贴图的设定
    if inst._setfruitonanimover then
        setfruit(inst, false)
    end
end

-------------------------

local function Shake(inst)
    if not inst.components.pickable:IsBarren() then
        inst.AnimState:PlayAnimation("shake")
        inst.AnimState:PushAnimation("idle", true)
        cancelsetfruitonanimover(inst)
    end
end
local function GetStatus(inst)
    return (inst.AnimState:IsCurrentAnimation("idle_summer") and "SUMMER")
        or (inst.AnimState:IsCurrentAnimation("idle_winter") and "WINTER")
        or (not inst.components.pickable:CanBePicked() and "PICKED")
        or "GENERIC"
end
local function OnWorked(inst, worker, workleft, numworks)
    Shake(inst)
end
local function OnFinished(inst, worker)
    local pos = inst:GetPosition()
    TOOLS_L.SpawnStackDrop("dug_monstrain", 1, pos, nil, nil, { dropper = inst })
    if inst.components.pickable:CanBePicked() then --成熟了
        TOOLS_L.SpawnStackDrop("squamousfruit", 1, pos, nil, nil, { dropper = inst })
        TOOLS_L.SpawnStackDrop("monstrain_leaf", math.random() < 0.5 and 2 or 1, pos, nil, nil, { dropper = inst })
    end
    inst:Remove()
end
local function CanBeFertilized_new(self)
    return false
end
local function OnHaunt(inst) --被作祟时
    if math.random() <= TUNING.HAUNT_CHANCE_ALWAYS then
        Shake(inst)
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_COOLDOWN_TINY
        return true
    end
    return false
end
local function Fn_needWater(inst, self) --枯萎后被利川等恢复
    if inst.components.pickable:IsBarren() and not TheWorld.state.iswinter then
        self.moisture = math.max(0, self.moisture-10)
        inst.components.pickable:Resume() --兼容以前的数据，以后记得删了
        inst.components.pickable:MakeEmpty()
        return true
    end
    return false
end

local function OnRegenFn(inst) --成熟时
    inst.AnimState:PlayAnimation("grow")
    inst.AnimState:PushAnimation("idle", true)
    setfruit(inst, true)
end
local function OnPickedFn(inst, picker, lootbase) --被采集时
    inst.AnimState:PlayAnimation("shake")
    inst.AnimState:PushAnimation("idle", true)
    setfruitonanimover(inst)

    local loot = {}
    local pos = inst:GetPosition()
    TOOLS_L.SpawnStackDrop("squamousfruit", 1, pos, nil, loot, { dropper = inst })
    TOOLS_L.SpawnStackDrop("monstrain_leaf", 1, pos, nil, loot, { dropper = inst })
    if picker ~= nil then
        picker:PushEvent("picksomething", { object = inst, loot = loot })
        if picker.components.inventory ~= nil then --给予采摘者
            for _, item in pairs(loot) do
                if item.components.inventoryitem ~= nil then
                    picker.components.inventory:GiveItem(item, nil, pos)
                end
            end
        end
    end
end
local function OnEmptyFn(inst) --重新开始生长时
    inst.Physics:SetActive(true) --开启体积
    if POPULATING then
        inst.AnimState:PlayAnimation("idle", true)
        inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
    elseif inst.AnimState:IsCurrentAnimation("idle_winter") then
        inst.AnimState:PlayAnimation("winter_to_idle")
        inst.AnimState:PushAnimation("idle", true)
    elseif inst.AnimState:IsCurrentAnimation("idle_summer") then
        inst.AnimState:PlayAnimation("summer_to_idle")
        inst.AnimState:PushAnimation("idle", true)
    else
        inst.AnimState:PlayAnimation("idle", true)
        inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
    end
    setfruit(inst, false)
    inst:RemoveTag("needwater2")
    inst.fn_l_needwater = nil
    inst.components.pickable.cycles_left = nil --Pickable:MakeEmpty() 并不会修改这个数据，所以只能这里手动改一下
end
local function OnBarrenFn(inst, wasempty) --枯萎时
    inst.Physics:SetActive(false) --取消体积
    local idlepst = TheWorld.state.iswinter and "idle_winter" or "idle_summer"
    if POPULATING then
        inst.AnimState:PlayAnimation(idlepst, true)
    else
        inst.AnimState:PlayAnimation("withering")
        inst.AnimState:PushAnimation(idlepst, true)
    end
    cancelsetfruitonanimover(inst)
    inst:RemoveTag("barren") --这个标签代表能被尝试施肥，但我不想它出现
    if idlepst == "idle_summer" then --冬天并不是缺水
        inst:AddTag("needwater2")
        inst.fn_l_needwater = Fn_needWater
    end
    inst.components.pickable.targettime = nil --Pickable:MakeBarren() 并不会修改这个数据，所以只能这里手动改一下
end

local function ReturnChildren(inst)
    for _,child in pairs(inst.components.childspawner.childrenoutside) do
        if child.components.homeseeker ~= nil then
            child.components.homeseeker:GoHome()
        end
        child:PushEvent("gohome")
    end
end
local function OnIsNight(inst)
    if inst.lifeless_l or TheWorld.state.isnight or inst.components.pickable:IsBarren() then
        inst.components.childspawner:StopSpawning()
        ReturnChildren(inst)
    else
        inst.components.childspawner:StartSpawning()
    end
end
local function OnSeasonChange(inst) --季节变化时
    if TheWorld.state.iswinter then
        inst.components.pickable:MakeBarren()
        return
    elseif TheWorld.state.issummer then
        local hasit = false
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 20, { "siving_ctl" }, { "INLIMBO", "NOCLICK" }, nil)
        for _,v in ipairs(ents) do
            if v.components.botanycontroller ~= nil then
                local cpt = v.components.botanycontroller
                if (cpt.type == 1 or cpt.type == 3) and cpt.moisture > 0 then
                    cpt.moisture = math.max(0, cpt.moisture-10)
                    cpt:SetBars()
                    hasit = true
                    break
                end
            end
        end
        if not hasit then
            inst.components.pickable:MakeBarren()
            return
        end
    end
    inst.components.pickable:Resume() --兼容以前的数据，以后记得删了
    if inst.components.pickable:IsBarren() or inst.istransed_l then --判定一下，防止重置了生长进度
        inst.components.pickable:MakeEmpty()
    end
end
local function InitSelf(inst)
    inst.task_init = nil
    inst:WatchWorldState("iswinter", OnSeasonChange)
    inst:WatchWorldState("issummer", OnSeasonChange)
    inst:WatchWorldState("isnight", OnIsNight)
    -- OnSeasonChange(inst) --pickable组件会维护状态的
    OnIsNight(inst)
end
local function OnSave(inst, data)
    if inst.lifeless_l then
        data.lifeless_l = true
    end
end
local function OnLoad(inst, data)
    if data ~= nil then
        if data.lifeless_l then
            inst.lifeless_l = true
            inst.net_lifeless_l:set(true)
        end
    end
end
local function Fn_nameDetail(inst)
    if inst.net_lifeless_l:value() then
        return STRINGS.NAMEDETAIL_L.WEAKMONSTRAIN
    end
end

local function MonstrainFn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeSmallObstaclePhysics(inst, .1)

    inst.MiniMapEntity:SetIcon("monstrain.tex") --设置在地图上的图标，需要像人物一样先在modmain中先声明xml才行

    inst.AnimState:SetBuild("monstrain")
    inst.AnimState:SetBank("monstrain")
    inst.AnimState:PlayAnimation("idle", true)
    inst.Transform:SetScale(1.4, 1.4, 1.4) --设置相对大小

    setfruit(inst, true)

    --inst:AddTag("watersource")
    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("birdblocker")
    inst:AddTag("plant")

    inst.no_wet_prefix = true
    inst.net_lifeless_l = net_bool(inst.GUID, "monstrain.lifeless_l", "lifeless_l_dirty")
    inst.net_lifeless_l:set_local(false)
    inst.fn_l_namedetail = Fn_nameDetail

    --inst:SetPrefabNameOverride("cactus") --因为官方的两种仙人掌在表面上都叫“cactus”，所以有一个需要覆盖原本名字

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    -- inst.lifeless_l = nil

    inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus

    inst:AddComponent("lootdropper")

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "raindonate"
    inst.components.childspawner:SetSpawnPeriod(TUNING.MOSQUITO_POND_SPAWN_TIME)
    inst.components.childspawner:SetRegenPeriod(TUNING.MOSQUITO_POND_REGEN_TIME)
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner:StartRegen()

    inst:AddComponent("pickable")
    inst.components.pickable.CanBeFertilized = CanBeFertilized_new --不能被施肥
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_sticks"
    inst.components.pickable:SetUp(nil, TUNING.TOTAL_DAY_TIME*6)
    inst.components.pickable.onregenfn = OnRegenFn
    inst.components.pickable.onpickedfn = OnPickedFn
    inst.components.pickable.makeemptyfn = OnEmptyFn
    inst.components.pickable.makebarrenfn = OnBarrenFn
    --inst.components.pickable.ontransplantfn = ontransplantfn

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(2)
    inst.components.workable:SetOnWorkCallback(OnWorked)
    inst.components.workable:SetOnFinishCallback(OnFinished)

    MakeHauntableIgnite(inst)
    AddHauntableCustomReaction(inst, OnHaunt, false, false, true)

    inst.task_init = inst:DoTaskInTime(0.3, InitSelf)
    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

-------------------------------------
-------------------------------------

local prefabs_tuber = {
    "monstrain",
    "dug_monstrain"
}

local function OnMoistureDelta_tuber(inst, data)
    --小于1是为了忽略干燥导致的损失(不然水壶得浇水5次)
    if inst:IsValid() and inst.components.moisture:GetMoisturePercent() >= 0.95 then
        local tree = SpawnPrefab("monstrain")
        if tree ~= nil then
            tree.AnimState:PlayAnimation("idle_summer", true)
            tree.Transform:SetPosition(inst.Transform:GetWorldPosition())
            tree.istransed_l = true
            OnSeasonChange(tree)
            tree.istransed_l = nil
            inst.SoundEmitter:PlaySound("farming/common/farm/rot")
            inst:Remove()
        end
    end
end
local function OnFinished_tuber(inst, worker)
    inst.components.lootdropper:SpawnLootPrefab("dug_monstrain")
    inst:Remove()
end
local function OnTimerDone_tuber(inst, data)
    if data.name == "dehydration" then
        inst.components.lootdropper:SpawnLootPrefab("spoiled_food")
        inst:Remove()
    end
end
local function Fn_planted_tuber(inst, pt)
    inst:DoTaskInTime(0, function(inst) --寻找周围的管理器
        local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 20, { "siving_ctl" }, { "INLIMBO", "NOCLICK" }, nil)
        for _,v in ipairs(ents) do
            if v.components.botanycontroller ~= nil then
                local cpt = v.components.botanycontroller
                if (cpt.type == 1 or cpt.type == 3) and cpt.moisture > 0 then
                    local moicpt = inst.components.moisture
                    local need = math.min(moicpt:GetMaxMoisture() - moicpt:GetMoisture(), cpt.moisture)
                    moicpt:DoDelta(need, true)
                    cpt.moisture = math.max(0, cpt.moisture-need)
                    cpt:SetBars()

                    if moicpt:GetMoisturePercent() >= 0.95 then
                        return
                    end
                end
            end
        end
    end)
end

local function TuberFn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("monstrain.tex")

    inst.AnimState:SetBuild("monstrain")
    inst.AnimState:SetBank("monstrain")
    inst.AnimState:PlayAnimation("idle_summer", true)
    inst.Transform:SetScale(1.4, 1.4, 1.4)

    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("birdblocker")
    inst:AddTag("plant")
    inst:AddTag("needwater2") --使其可被浇水，不过是我自己加的，官方没有

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(1)
    -- inst.components.workable:SetOnWorkCallback(function(inst, worker, workleft, numworks)end)
    inst.components.workable:SetOnFinishCallback(OnFinished_tuber)

    inst:AddComponent("timer")
    inst.components.timer:StartTimer("dehydration", 3*TUNING.TOTAL_DAY_TIME)
    inst:ListenForEvent("timerdone", OnTimerDone_tuber)

    inst:AddComponent("moisture")
    inst:ListenForEvent("moisturedelta", OnMoistureDelta_tuber)

    MakeHauntableIgnite(inst)

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    inst.fn_planted = Fn_planted_tuber

    return inst
end

return Prefab("monstrain", MonstrainFn, assets, prefabs),
        Prefab("monstrain_wizen", TuberFn, assets, prefabs_tuber)
