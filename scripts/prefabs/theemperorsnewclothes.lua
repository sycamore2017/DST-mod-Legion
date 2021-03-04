local assets_crown =
{
    Asset("ANIM", "anim/theemperorsnewclothes.zip"),
    Asset("ATLAS", "images/inventoryimages/theemperorscrown.xml"),
    Asset("IMAGE", "images/inventoryimages/theemperorscrown.tex"),
}

local function opentop_onequip_crown(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_hat")
    owner.AnimState:Show("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    owner.AnimState:Show("HEAD")
    owner.AnimState:Hide("HEAD_HAT")
end

local function onunequip_crown(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_hat")
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAT")
    end
end

local function fn_crown()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("theemperorsnewclothes")
    inst.AnimState:SetBuild("theemperorsnewclothes")
    inst.AnimState:PlayAnimation("anim_crown")

    inst:AddTag("hat")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "theemperorscrown"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/theemperorscrown.xml"
    inst.components.inventoryitem:SetSinks(true)

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(opentop_onequip_crown)
    inst.components.equippable:SetOnUnequip(onunequip_crown)

    inst:AddComponent("tradable")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunch(inst)

    return inst
end

------------

local assets_mantle =
{
    Asset("ANIM", "anim/theemperorsnewclothes.zip"),
    Asset("ATLAS", "images/inventoryimages/theemperorsmantle.xml"),
    Asset("IMAGE", "images/inventoryimages/theemperorsmantle.tex"),
}

local function onequip_mantle(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
end

local function onunequip_mantle(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
end

local function fn_mantle()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("theemperorsnewclothes")
    inst.AnimState:SetBuild("theemperorsnewclothes")
    inst.AnimState:PlayAnimation("anim_mantle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "theemperorsmantle"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/theemperorsmantle.xml"
    inst.components.inventoryitem:SetSinks(true)

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip_mantle)
    inst.components.equippable:SetOnUnequip(onunequip_mantle)

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunch(inst)

    return inst
end

------------

local assets_scepter =
{
    Asset("ANIM", "anim/theemperorsnewclothes.zip"),
    Asset("ATLAS", "images/inventoryimages/theemperorsscepter.xml"),
    Asset("IMAGE", "images/inventoryimages/theemperorsscepter.tex"),
}

local function onequip_scepter(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip_scepter(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function fn_scepter()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("theemperorsnewclothes")
    inst.AnimState:SetBuild("theemperorsnewclothes")
    inst.AnimState:PlayAnimation("anim_scepter")

    inst:AddTag("nopunch")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "theemperorsscepter"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/theemperorsscepter.xml"
    inst.components.inventoryitem:SetSinks(true)

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip_scepter)
    inst.components.equippable:SetOnUnequip(onunequip_scepter)

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("theemperorscrown", fn_crown, assets_crown),
        Prefab("theemperorsmantle", fn_mantle, assets_mantle),
        Prefab("theemperorsscepter", fn_scepter, assets_scepter)
