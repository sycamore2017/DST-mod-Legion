local TOOLS_L = require("tools_legion")

--------------------------------------------------------------------------
--[[ 苔衣发卡 ]]
--------------------------------------------------------------------------

local assets_lichen = {
    Asset("ANIM", "anim/hat_lichen.zip"),
	Asset("ATLAS", "images/inventoryimages/hat_lichen.xml"),
    Asset("IMAGE", "images/inventoryimages/hat_lichen.tex")
}
local prefabs_lichen = {
    "lichenhatlight"
}

local function OnEquip_lichen(inst, owner)
    if inst._light == nil or not inst._light:IsValid() then
        inst._light = SpawnPrefab("lichenhatlight") --生成光源
        inst._light.entity:SetParent(owner.entity)  --给光源设置父节点
    end

    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.equip ~= nil then
        if skindata.equip.isopenhat then
            TOOLS_L.hat_on_opentop(inst, owner, skindata.equip.build, skindata.equip.file)
        else
            TOOLS_L.hat_on(inst, owner, skindata.equip.build, skindata.equip.file)
        end
        if skindata.equip.lightcolor ~= nil then
            local rgb = skindata.equip.lightcolor
            inst._light.Light:SetColour(rgb.r, rgb.g, rgb.b)
        end
    else
        TOOLS_L.hat_on_opentop(inst, owner, "hat_lichen", "swap_hat")
    end

    TOOLS_L.AddTag(owner, "ignoreMeat", inst.prefab) --添加忽略带着肉的标签

    local soundemitter = owner ~= nil and owner.SoundEmitter or inst.SoundEmitter
    soundemitter:PlaySound("dontstarve/common/minerhatAddFuel") --装备时的音效
end
local function OnUnequip_lichen(inst, owner)
    TOOLS_L.hat_off(inst, owner)

    TOOLS_L.RemoveTag(owner, "ignoreMeat", inst.prefab)
    if inst._light ~= nil then
        if inst._light:IsValid() then
            inst._light:Remove() --把光源移除
        end
        inst._light = nil
    end

    local soundemitter = owner ~= nil and owner.SoundEmitter or inst.SoundEmitter
    soundemitter:PlaySound("dontstarve/common/minerhatOut") --卸下时的音效
end

local function Fn_lichen()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hat_lichen")
    inst.AnimState:SetBuild("hat_lichen")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("hat")
    inst:AddTag("show_spoilage")
    inst:AddTag("icebox_valid")
    inst:AddTag("open_top_hat") --虽然这个标签作用于植物人的贴图切换，但我没看出来到底哪里变了

    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:InitWithFloater("hat_lichen")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst._light = nil

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_ONE_DAY*5)
    inst.components.perishable:StartPerishing()
    inst.components.perishable:SetOnPerishFn(inst.Remove)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "hat_lichen"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hat_lichen.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED
    inst.components.equippable:SetOnEquip(OnEquip_lichen)
    inst.components.equippable:SetOnUnequip(OnUnequip_lichen)

    inst:AddComponent("tradable")

    MakeHauntableLaunchAndPerish(inst)

    inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

local function Fn_lichenlight() --苔衣发卡的光源实体
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:SetFalloff(0.4)  --衰减
    inst.Light:SetIntensity(.7) --亮度
    inst.Light:SetRadius(2)     --半径
    inst.Light:SetColour(237/255, 237/255, 209/255) --颜色，和灯泡花一样

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

-------------------------

local prefs = {
    Prefab("hat_lichen", Fn_lichen, assets_lichen, prefabs_lichen),
    Prefab("lichenhatlight", Fn_lichenlight)
}

return unpack(prefs)
