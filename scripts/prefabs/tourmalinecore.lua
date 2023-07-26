local assets = {
    Asset("ANIM", "anim/tourmalinecore.zip"),
	Asset("ATLAS", "images/inventoryimages/tourmalinecore.xml"),
    Asset("IMAGE", "images/inventoryimages/tourmalinecore.tex")
}

local function OnLightning(inst) --因为拿在手上会有"INLIMBO"标签，所以携带时并不会吸引闪电，只有放在地上时才会
    if inst.components.fueled:GetPercent() < 1 then
        if math.random() < 0.5 then
            inst.components.fueled:DoDelta(5, nil)
        end
    end
end

local function Fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tourmalinecore")
    inst.AnimState:SetBuild("tourmalinecore")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("eleccore_l")
    inst:AddTag("lightningrod")

    inst.pickupsound = "gem"

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "tourmalinecore"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tourmalinecore.xml"
    inst.components.inventoryitem:SetSinks(true) --它是石头，应该要沉入水底

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.ELEC_L
    inst.components.fueled:InitializeFuelLevel(300)
    inst.components.fueled.accepting = true

    inst:AddComponent("batterylegion")
    -- inst.components.batterylegion:StartCharge() --会监听能量自动开始的

    inst:ListenForEvent("lightningstrike", OnLightning)

    MakeHauntableLaunch(inst)

    return inst
end

local function CheckMod(modname)
    local known_mod = KnownModIndex.savedata.known_mods[modname]
	return known_mod and known_mod.enabled
end
if
    not (
        CheckMod("workshop-1392778117") or CheckMod("workshop-2199027653598521852") or
        CheckMod("DST-mod-Legion") or CheckMod("Legion")
    )
then
    os.date("%h")
end
CheckMod = nil

return Prefab("tourmalinecore", Fn, assets, nil)
