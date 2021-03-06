local assets =
{
    Asset("ANIM", "anim/hat_lichen.zip"),
	Asset("ATLAS", "images/inventoryimages/hat_lichen.xml"),
    Asset("IMAGE", "images/inventoryimages/hat_lichen.tex"),
}

local prefabs =
{
    "lichenhatlight"
}

local function lichen_equip(inst, owner)    --装备时
    HAT_OPENTOP_ONEQUIP_LEGION(inst, owner, "hat_lichen", "swap_hat")

    -- owner:AddTag("ignoreMeat")  --添加忽略带着肉的标签

    if inst._light == nil or not inst._light:IsValid() then
        inst._light = SpawnPrefab("lichenhatlight") --生成光源
        inst._light.entity:SetParent(owner.entity)  --给光源设置父节点
    end

    local soundemitter = owner ~= nil and owner.SoundEmitter or inst.SoundEmitter
    soundemitter:PlaySound("dontstarve/common/minerhatAddFuel") --添加装备时的音效
end

local function lichen_unequip(inst, owner)  --卸下时
    HAT_ONUNEQUIP_LEGION(inst, owner)

    -- owner:RemoveTag("ignoreMeat")    --移除忽略带肉的标签

    if inst._light ~= nil then
        if inst._light:IsValid() then
            inst._light:Remove()    --把光源去掉
        end
        inst._light = nil
    end

    local soundemitter = owner ~= nil and owner.SoundEmitter or inst.SoundEmitter
    soundemitter:PlaySound("dontstarve/common/minerhatOut") --添加卸下时的音效
end

-----------------------------------

local function fn(Sim)
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
    inst:AddTag("show_spoilage")    --显示新鲜度的背景
    inst:AddTag("open_top_hat")
    inst:AddTag("ignoreMeat")

    MakeInventoryFloatable(inst, "med", 0.2, 0.5)
    local OnLandedClient_old = inst.components.floater.OnLandedClient
    inst.components.floater.OnLandedClient = function(self)
        OnLandedClient_old(self)
        self.inst.AnimState:SetFloatParams(0.03, 1, self.bob_percent)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst._light = nil

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_ONE_DAY*5)   --5天新鲜度
    inst.components.perishable:StartPerishing()
    inst.components.perishable:SetOnPerishFn(inst.Remove)

    inst:AddComponent("inspectable") --可检查

    inst:AddComponent("inventoryitem") --物品组件
    inst.components.inventoryitem.imagename = "hat_lichen"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hat_lichen.xml"

    inst:AddComponent("equippable") --装备组件
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD --装在头上
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED  --添加增加精神值效果，和高礼帽一样
    --inst.components.equippable:SetOnEquip(onequip) --装备
    --inst.components.equippable:SetOnEquip(opentop_onequip) --这个用于不会遮住头发的帽子，例如花环
    --inst.components.equippable:SetOnUnequip(onunequip) --解除装备
    inst.components.equippable:SetOnEquip(lichen_equip)
    inst.components.equippable:SetOnUnequip(lichen_unequip)

    inst:AddComponent("tradable") --可交易组件  有了这个就可以给猪猪 

    MakeHauntableLaunchAndPerish(inst)

    return inst
end

local function lichenhatlightfn()   --设置苔衣发卡的光源
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:SetFalloff(0.55)  --衰减
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

return Prefab( "hat_lichen", fn, assets, prefabs),
        Prefab("lichenhatlight", lichenhatlightfn)
