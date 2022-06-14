local assets = {
    Asset("ANIM", "anim/myth_siving_boss.zip")
}

local prefabs = {
    -- "mooseegg"
}

local function Fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    inst.DynamicShadow:SetSize(2.5, 1.5)
    inst.Transform:SetScale(1.5, 1.5, 1.5)
    inst.Transform:SetFourFaced()

    MakeGiantCharacterPhysics(inst, 500, 0.5)

    inst.AnimState:SetBank("myth_siving_boss")
    inst.AnimState:SetBuild("myth_siving_boss")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("epic")
    inst:AddTag("hostile")
    inst:AddTag("largecreature")
    inst:AddTag("siving")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.BUZZARD_HEALTH)
end

return Prefab("siving_phoenix", Fn, assets, prefabs)
