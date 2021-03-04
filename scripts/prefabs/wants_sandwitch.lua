--------------------------------------------------------------------------
--[[ 猫线球 ]]
--------------------------------------------------------------------------

local assets_cattenball =
{
    Asset("ANIM", "anim/toy_legion.zip"),
    Asset("ATLAS", "images/inventoryimages/cattenball.xml"),
    Asset("IMAGE", "images/inventoryimages/cattenball.tex"),
}

local function Fn_cattenball()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("toy_legion")
    inst.AnimState:SetBuild("toy_legion")
    inst.AnimState:PlayAnimation("toy_cattenball")

    inst:AddTag("cattoy") --能给浣猫

    MakeInventoryFloatable(inst, "med", 0.25, 0.5)
    local OnLandedClient_old = inst.components.floater.OnLandedClient
    inst.components.floater.OnLandedClient = function(self)
        OnLandedClient_old(self)
        self.inst.AnimState:SetFloatParams(0.08, 1, self.bob_percent)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "cattenball"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/cattenball.xml"

    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = 9

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndIgnite(inst)

    return inst
end

--------------------------------------------------------------------------
--[[ 玩具小海绵与玩具小海星 ]]
--------------------------------------------------------------------------

local function MakeToyWe(name)
    local assets_toywe =
    {
        Asset("ANIM", "anim/toy_legion.zip"),
        Asset("ATLAS", "images/inventoryimages/"..name..".xml"),
        Asset("IMAGE", "images/inventoryimages/"..name..".tex"),
    }

    local function Fn_toywe()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("toy_legion")
        inst.AnimState:SetBuild("toy_legion")
        inst.AnimState:PlayAnimation(name)

        inst:AddTag("cattoy") --能给浣猫

        MakeInventoryFloatable(inst, "med", 0.3, 0.6)
        local OnLandedClient_old = inst.components.floater.OnLandedClient
        inst.components.floater.OnLandedClient = function(self)
            OnLandedClient_old(self)
            self.inst.AnimState:SetFloatParams(0.06, 1, self.bob_percent)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")

        --独一无二！
        -- inst:AddComponent("stackable")
        -- inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = name
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"

        inst:AddComponent("tradable")
        inst.components.tradable.goldvalue = 1 --每四个月记得来加1

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

        MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
        MakeSmallPropagator(inst)
        MakeHauntableLaunchAndIgnite(inst)

        return inst
    end

    return Prefab(name, Fn_toywe, assets_toywe)
end

--------------------------------------------------------------------------

local prefabs = {}

-- if CONFIGS_LEGION.LEGENDOFFALL then
--     table.insert(prefabs, Prefab("cattenball", Fn_cattenball, assets_cattenball, nil))
-- end

--梧生最终也没有做到一吻长青
-- if TUNING.LEGION_DESERTSECRET then
--     table.insert(prefabs, MakeToyWe("toy_spongebob"))
--     table.insert(prefabs, MakeToyWe("toy_patrickstar"))
-- end

return unpack(prefabs)
