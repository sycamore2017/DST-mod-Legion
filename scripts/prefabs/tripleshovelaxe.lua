local assets =
{
    Asset("ANIM", "anim/tripleshovelaxe.zip"),
    Asset("ANIM", "anim/swap_tripleshovelaxe.zip"),
    Asset("ATLAS", "images/inventoryimages/tripleshovelaxe.xml"),
    Asset("IMAGE", "images/inventoryimages/tripleshovelaxe.tex"),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_tripleshovelaxe", "swap_tripleshovelaxe")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tripleshovelaxe")
    inst.AnimState:SetBuild("tripleshovelaxe")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")

    --tool (from tool component) added to pristine state for optimization
    inst:AddTag("tool")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", 0.1, {1, 0.5, 1}, true, -9, {
        sym_build = "swap_tripleshovelaxe",
        sym_name = "swap_tripleshovelaxe",
        bank = "tripleshovelaxe",
        anim = "idle"
    })

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.AXE_DAMAGE)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "tripleshovelaxe"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tripleshovelaxe.xml"

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 1)
    inst.components.tool:SetAction(ACTIONS.MINE, 1)
    inst.components.tool:SetAction(ACTIONS.DIG,  1)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(90)   --总共90次，可攻击90次
    inst.components.finiteuses:SetUses(90)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    --设置每种功能的消耗量
    inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 0.6)  --可以使用90/0.6=150次
    inst.components.finiteuses:SetConsumption(ACTIONS.MINE, 0.6)
    inst.components.finiteuses:SetConsumption(ACTIONS.DIG,  0.6)

    MakeHauntableLaunch(inst)

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    return inst
end

return Prefab("tripleshovelaxe", fn, assets)
