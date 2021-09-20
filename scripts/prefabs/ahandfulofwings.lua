local assets =
{
    Asset("ANIM", "anim/ahandfulofwings.zip"),
    Asset("ATLAS", "images/inventoryimages/ahandfulofwings.xml"),
    Asset("IMAGE", "images/inventoryimages/ahandfulofwings.tex"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("ahandfulofwings")
    inst.AnimState:SetBuild("ahandfulofwings")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "small", 0.1, 0.9)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("tradable") --尘市蜃楼部分里的砂之女巫会想要这个的
    -- inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT * 2

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "ahandfulofwings"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/ahandfulofwings.xml"

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunchAndIgnite(inst)

    return inst
end

return Prefab("ahandfulofwings", fn, assets)
