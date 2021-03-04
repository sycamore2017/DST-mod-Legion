local assets =
{
    Asset("ANIM", "anim/agronssword.zip"),    --这个是放在地上的动画文件
    Asset("ANIM", "anim/swap_agronssword.zip"),   --手上的动画
    Asset("ATLAS", "images/inventoryimages/agronssword.xml"),
    Asset("IMAGE", "images/inventoryimages/agronssword.tex"),
}

local prefabs =
{
    "agronssword_fx",
}

local function deathcallsforrain(owner)
    TheWorld:PushEvent("ms_forceprecipitation", true)
end

local function drinkingblood(sword, owner)
    if sword.components.weapon ~= nil and owner.components.health ~= nil then
        local percent = owner.components.health:GetPercent()

        sword.components.weapon:SetDamage(93.5-76.5*percent) --攻击力在17~93.5之间变化
    end
end

local function radicalhealth(owner, data)
    local sword = owner.components.inventory ~= nil and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil

    if sword ~= nil and sword.prefab == "agronssword" then
        drinkingblood(sword, owner)
    end
end

local function onequip(inst, owner) --装备武器时
    owner.AnimState:OverrideSymbol("swap_object", "swap_agronssword", "swap_agronssword")
    owner.AnimState:Show("ARM_carry") --显示持物手
    owner.AnimState:Hide("ARM_normal") --隐藏普通的手

    owner:ListenForEvent("death", deathcallsforrain)
    owner:ListenForEvent("healthdelta", radicalhealth)

    drinkingblood(inst, owner)
end

local function onunequip(inst, owner)   --放下武器时
    owner.AnimState:Hide("ARM_carry") --隐藏持物手
    owner.AnimState:Show("ARM_normal") --显示普通的手

    owner:RemoveEventCallback("death", deathcallsforrain)
    owner:RemoveEventCallback("healthdelta", radicalhealth)

    inst.components.weapon:SetDamage(55.25) --卸下时，恢复武器默认攻击力，为了让巨人之脚识别到
end

local function onattack(inst, owner, target)
    if owner.components.health and owner.components.health:GetPercent() > 0.5 then
        local fx = SpawnPrefab("agronssword_fx")    --燃血特效
        fx.Transform:SetPosition(owner.Transform:GetWorldPosition())

        owner.components.health:DoDelta(-1.5, false, "agronssword")
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()  --要在小地图上显示的话，记得加这句
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("agronssword")
    inst.AnimState:SetBuild("agronssword")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp") --武器的标签跟攻击方式跟攻击音效有关 没有特殊的话就用这两个
    inst:AddTag("pointy")
    inst:AddTag("irreplaceable")    --这个标签会防止被猴子、食人花、坎普斯等拿走
    inst:AddTag("nonpotatable") --这个貌似是使其下线时会自动掉落
    inst:AddTag("hide_percentage")  --这个标签能让护甲耐久比例不显示出来

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    inst.MiniMapEntity:SetIcon("agronssword.tex")

    -- MakeInventoryFloatable(inst, "med", 0.1, {1.1, 0.5, 1.1}, true, -9, {
    --     sym_build = "swap_agronssword",
    --     sym_name = "swap_agronssword",
    --     bank = "agronssword",
    --     anim = "idle"
    -- })

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then 
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "agronssword"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/agronssword.xml"
    inst.components.inventoryitem:SetSinks(true) --落水时会下沉，但是因为标签的关系会回到绚丽大门

    inst:AddComponent("inspectable")

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(55.25)
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(100, TUNING.ARMORGRASS_ABSORPTION/3)    --20%防护系数
    inst.components.armor.indestructible = true     --无敌的护甲

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("agronssword", fn, assets, prefabs)