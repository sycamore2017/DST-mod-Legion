local assets =
{
    Asset("ANIM", "anim/stalker_shield.zip"), --官方影织者护盾动画模板
    Asset("ANIM", "anim/neverfade_shield.zip"),
}

local function PlaySound(inst, sound)
    inst.SoundEmitter:PlaySound(sound)
end

local function PlayAnim(proxy)
    local inst = CreateEntity()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    --如果想让特效能设置父实体，则需要这一截代码
    local parent = proxy.entity:GetParent()
    if parent ~= nil then
        inst.entity:SetParent(parent.entity)
    end

    inst.Transform:SetFromProxy(proxy.GUID)

    inst.entity:AddSoundEmitter()
    inst:DoTaskInTime(0, PlaySound, "dontstarve/creatures/together/stalker/shield")

    inst.AnimState:SetBank("stalker_shield")
    inst.AnimState:SetBuild("neverfade_shield")
    -- inst.AnimState:PlayAnimation("idle"..tostring(math.random(1, 3)))
    inst.AnimState:PlayAnimation("idle1")   --原图太大了，所以我去除了多余的贴图，只用了这个动画里的贴图
    -- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    -- inst.AnimState:SetSortOrder(1)
    -- inst.AnimState:SetScale(1.5, 1.5)
    -- inst.AnimState:SetMultColour(140/255, 239/255, 255/255, 1)
    inst.AnimState:SetScale(Vector3(-1, 1, 1):Get())
    inst.AnimState:SetFinalOffset(2)
    
    inst:ListenForEvent("animover", inst.Remove)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    --Dedicated server does not need to spawn the local fx
    if not TheNet:IsDedicated() then
        --Delay one frame so that we are positioned properly before starting the effect
        --or in case we are about to be removed
        inst:DoTaskInTime(0, PlayAnim, inst)
    end

    inst:AddTag("FX")
    
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false
    inst:DoTaskInTime(1, inst.Remove)

    return inst
end

return Prefab("neverfade_shield", fn, assets)
