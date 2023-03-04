local assets_wing = {
    Asset("ANIM", "anim/insectthings_l.zip"),
    Asset("ATLAS", "images/inventoryimages/ahandfulofwings.xml"),
    Asset("IMAGE", "images/inventoryimages/ahandfulofwings.tex")
}
local assets_shell = {
    Asset("ANIM", "anim/insectthings_l.zip"),
    Asset("ATLAS", "images/inventoryimages/insectshell_l.xml"),
    Asset("IMAGE", "images/inventoryimages/insectshell_l.tex")
}

local function Fn_server(inst)
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("tradable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunchAndIgnite(inst)
end

------

local function Fn_wing()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("insectthings_l")
    inst.AnimState:SetBuild("insectthings_l")
    inst.AnimState:PlayAnimation("wing", false)

    MakeInventoryFloatable(inst, "small", 0.1, 1.2)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    Fn_server(inst)

    inst.components.inventoryitem.imagename = "ahandfulofwings"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/ahandfulofwings.xml"

    return inst
end

local function Fn_shell()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("insectthings_l")
    inst.AnimState:SetBuild("insectthings_l")
    inst.AnimState:PlayAnimation("shell", false)

    MakeInventoryFloatable(inst, "small", 0.1, 1.1)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    Fn_server(inst)

    inst.components.inventoryitem.imagename = "insectshell_l"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/insectshell_l.xml"

    inst:AddComponent("repairerlegion")

    return inst
end

return Prefab("ahandfulofwings", Fn_wing, assets_wing),
    Prefab("insectshell_l", Fn_shell, assets_shell)
