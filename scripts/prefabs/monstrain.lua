local assets =
{
    Asset("ANIM", "anim/monstrain.zip"),
}

local prefabs =
{
    "raindonate",
    "squamousfruit",
    "monstrain_leaf",
}

-------------------------

local function setfruit(inst, hasfruit)    --设置果实的贴图
    if inst._setfruitonanimover then
        inst._setfruitonanimover = nil
        inst:RemoveEventCallback("animover", setfruit)
    end

    if hasfruit then
        inst.AnimState:Show("fruit")    --这里参数为贴图所在文件夹的名字，因为一个文件夹为一个symbol
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

local function cancelsetfruitonanimover(inst)   --取消在一个动画播放结束才隐藏果实贴图的设定
    if inst._setfruitonanimover then
        setfruit(inst, false)
    end
end

-------------------------

--local function ontransplantfn(inst)
--    inst.components.pickable:MakeEmpty()
--end

local function onpickedfn(inst, picker) --被采集时
    inst.AnimState:PlayAnimation("shake")
    inst.AnimState:PushAnimation("idle", true)

    setfruitonanimover(inst, false)

    if inst.components.lootdropper ~= nil then
        if math.random() <= 0.7 then
            inst.components.lootdropper:SpawnLootPrefab("monstrain_leaf")
        end
    end
end

local function onregenfn(inst)  --成熟时
    inst.AnimState:PlayAnimation("grow") 
    inst.AnimState:PushAnimation("idle", true)

    setfruit(inst, true)
end

local function makeemptyfn(inst)    --重新开始生长时
    inst.Physics:SetActive(true)  --开启体积

    if inst.AnimState:IsCurrentAnimation("idle_winter") then
        inst.AnimState:PlayAnimation("winter_to_idle")
        inst.AnimState:PushAnimation("idle", true)
    elseif inst.AnimState:IsCurrentAnimation("idle_summer") then
        inst.AnimState:PlayAnimation("summer_to_idle")
        inst.AnimState:PushAnimation("idle", true)
    else
        if TheWorld.state.iswinter then
            inst.AnimState:PlayAnimation("idle_winter", true)
        elseif TheWorld.state.issummer then
            inst.AnimState:PlayAnimation("idle_summer", true)
        else
            inst.AnimState:PlayAnimation("idle", true)
        end
    end

    setfruit(inst, false)
end

local function makebarrenfn(inst)--, wasempty)  --枯萎时
    inst.Physics:SetActive(false) --取消体积

    if TheWorld.state.iswinter then
        inst.AnimState:PlayAnimation("withering")
        inst.AnimState:PushAnimation("idle_winter", true)
    elseif TheWorld.state.issummer then
        inst.AnimState:PlayAnimation("withering")
        inst.AnimState:PushAnimation("idle_summer", true)
    end

    cancelsetfruitonanimover(inst)

    if inst.components.pickable then
        inst.components.pickable:Pause()
        inst.components.pickable.canbepicked = false
    end
end

local function seasonchange(inst)   --季节变化时
    if TheWorld.state.iswinter then    --冬天时
        makebarrenfn(inst)
    elseif TheWorld.state.issummer then --夏季时
        makebarrenfn(inst)
    else
        if inst.components.pickable then
            inst.components.pickable:Resume()
            inst.components.pickable:MakeEmpty()
        end
    end
end

local function shake(inst)
    if not (inst.AnimState:IsCurrentAnimation("withering") or
        inst.AnimState:IsCurrentAnimation("idle_summer") or inst.AnimState:IsCurrentAnimation("idle_winter")) then
        inst.AnimState:PlayAnimation("shake")
        inst.AnimState:PushAnimation("idle")
    end
    cancelsetfruitonanimover(inst)
end

local function OnHaunt(inst)    --被作祟时
    if math.random() <= TUNING.HAUNT_CHANCE_ALWAYS then
        shake(inst)
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_COOLDOWN_TINY
        return true
    end
    return false
end

local function getstatus(inst)
    return (inst.AnimState:IsCurrentAnimation("idle_summer") and "SUMMER")
        or (inst.AnimState:IsCurrentAnimation("idle_winter") and "WINTER")
        or (inst.components.pickable and not inst.components.pickable:CanBePicked() and "PICKED")
        or "GENERIC"
end

local function childrenspawning(inst, isstart)
    if inst.components.childspawner then
        if isstart then
            inst.components.childspawner:StartSpawning()
        else
            inst.components.childspawner:StopSpawning()
        end
    end
end

local function ReturnChildren(inst)
    for k, child in pairs(inst.components.childspawner.childrenoutside) do
        if child.components.homeseeker ~= nil then
            child.components.homeseeker:GoHome()
        end
        child:PushEvent("gohome")
    end
end

local function OnIsNight(inst)
    if TheWorld.state.isnight then  --晚上就召回children
        childrenspawning(inst, false)
        ReturnChildren(inst)
    elseif not (TheWorld.state.iswinter or (TheWorld.state.issummer)) then
        childrenspawning(inst, true)
    end
end

local function OnInit(inst)
    inst.task = nil
    inst:WatchWorldState("iswinter", seasonchange)
    inst:WatchWorldState("issummer", seasonchange)
    inst:WatchWorldState("isnight", OnIsNight)
    OnIsNight(inst)
end

-------------------------------------

local function monstrainfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    --MakeObstaclePhysics(inst, .3)
    MakeSmallObstaclePhysics(inst, .1)

    inst.MiniMapEntity:SetIcon("monstrain.tex")   --设置在地图上的图标，需要像人物一样先在modmain中先声明xml才行

    inst.AnimState:SetBuild("monstrain")
    inst.AnimState:SetBank("monstrain")
    inst.AnimState:PlayAnimation("idle", true)

    inst.Transform:SetScale(1.4, 1.4, 1.4)  --设置相对大小

    setfruit(inst, true)

    --inst:AddTag("watersource")
    inst:AddTag("renewable")
    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("birdblocker")
    inst:AddTag("plant")

    --inst:SetPrefabNameOverride("cactus")  --因为官方的两种仙人掌在表面上都叫“cactus”，所以有一个需要覆盖原本名字

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "raindonate"
    inst.components.childspawner:SetRegenPeriod(TUNING.POND_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.POND_SPAWN_TIME)
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner:StartRegen()

    --inst.AnimState:SetTime(math.random() * 2)   --？？？
    inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_sticks"
    inst.components.pickable:SetUp("squamousfruit", TUNING.BERRY_JUICY_REGROW_TIME)  --9天的成熟时间，并设置了采集收获物
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn
    --inst.components.pickable.ontransplantfn = ontransplantfn    --不可移植

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

    inst:AddComponent("lootdropper")

    MakeHauntableIgnite(inst)
    AddHauntableCustomReaction(inst, OnHaunt, false, false, true)

    inst.task = inst:DoTaskInTime(0, OnInit)

    return inst
end

return Prefab("monstrain", monstrainfn, assets, prefabs)
