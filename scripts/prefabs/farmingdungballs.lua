--------------------------------------------------------------------------
--[[ 栽培肥料球 ]]
--------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/farmingdungball.zip"),
}

local prefabs =
{
    "farmingdungball_item",
    -- "plant_normal_legion",
}

local function OnDigUp(inst, worker)
    if inst.components.grower ~= nil then
        inst.components.grower:Reset()
    end
    -- if inst.components.lootdropper ~= nil then
    --     inst.components.lootdropper:DropLoot()
    -- end
    if not inst.hasplanted then
        local fx = SpawnPrefab("farmingdungball_item")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    end
    inst:Remove()
end

local function SetfertilityFn(inst, fert_percent)
    if inst.hasplanted then --如果种植过了，就判断是否还有作物，没有就删除自己
        if inst.components.grower:IsEmpty() then
            inst:Remove()
        end
        -- for k, v in pairs(inst.components.grower.crops) do
        --     k.AnimState:OverrideSymbol("dirt", "farmingdungball", "planted")
        --     return
        -- end
        -- inst:Remove()
    else                    --如果没有种植过，就判断是否有作物，有就设置为种植过
        if not inst.components.grower:IsEmpty() then
            inst.AnimState:PlayAnimation("planted")
            inst.hasplanted = true
        end
        for k, v in pairs(inst.components.grower.crops) do
            k.AnimState:OverrideSymbol("dirt", "farmingdungball", "planted")
            k.AnimState:OverrideSymbol("soil", "crop_soil_legion", "farmingdung")
        end
    end
end

local function fn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("farmingdungball.tex")

    -- inst:AddTag("structure")

    inst.AnimState:SetBank("farmingdungball")
    inst.AnimState:SetBuild("farmingdungball")
    inst.AnimState:PlayAnimation("ground")
        
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.hasplanted = false --是否已经种植过的标识
    
    inst:AddComponent("inspectable")

    inst:AddComponent("grower")
    inst.components.grower.level = 1
    inst.components.grower.onplantfn = function()
        inst.SoundEmitter:PlaySound("dontstarve/wilson/plant_seeds")
        for k, v in pairs(inst.components.grower.crops) do
            k.AnimState:OverrideSymbol("dirt", "farmingdungball", "planted")
            k.AnimState:OverrideSymbol("soil", "crop_soil_legion", "farmingdung")
        end
        inst.AnimState:PlayAnimation("planted")
        inst.hasplanted = true
    end
    inst.components.grower.croppoints = {Vector3(0, 0, 0)}
    inst.components.grower.growrate = 0.8 --还是添上生长加成好了，这样植物人的作物才是生长速度最慢的了
    inst.components.grower.max_cycles_left = 10
    inst.components.grower.cycles_left = inst.components.grower.max_cycles_left
    inst.components.grower.setfertility = SetfertilityFn

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(OnDigUp)
        
    MakeHauntableLaunch(inst)

    return inst
end

--------------------------------------------------------------------------
--[[ 栽培肥料球 item ]]
--------------------------------------------------------------------------

local assets_item =
{
    Asset("ANIM", "anim/farmingdungball.zip"),
    Asset("ATLAS", "images/inventoryimages/farmingdungball_item.xml"),   --物品栏图片
    Asset("IMAGE", "images/inventoryimages/farmingdungball_item.tex"),
}

local prefabs_item =
{
    "farmingdungball",
}

local function OnDeploy(inst, pt, deployer)
    local tree = SpawnPrefab("farmingdungball")
    if tree ~= nil then
        tree.Transform:SetPosition(pt:Get())
        inst.components.stackable:Get():Remove()

        if deployer ~= nil and deployer.SoundEmitter ~= nil then
            deployer.SoundEmitter:PlaySound("dontstarve/common/place_structure_stone")
        end
    end
end

local function fn_item()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("farmingdungball")
    inst.AnimState:SetBuild("farmingdungball")
    inst.AnimState:PlayAnimation("item")

    MakeInventoryFloatable(inst, "small", 0.1, 0.9)
        
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    
    inst:AddComponent("inspectable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
        
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "farmingdungball_item"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/farmingdungball_item.xml"

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = OnDeploy

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("farmingdungball", fn, assets, prefabs),
        Prefab("farmingdungball_item", fn_item, assets_item, prefabs_item),
        MakePlacer("farmingdungball_item_placer", "farmingdungball", "farmingdungball", "placer")
