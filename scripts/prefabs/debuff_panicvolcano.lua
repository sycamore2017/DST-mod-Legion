local assets =
{
    Asset("ANIM", "anim/debuff_panicvolcano.zip"),
}

local function AlignToTarget(inst, target)
    inst.Transform:SetRotation(target.Transform:GetRotation())
end

local function OnChangeFollowSymbol(inst, target, followsymbol, followoffset)
    inst.Follower:FollowSymbol(target.GUID, followsymbol, followoffset.x, followoffset.y, followoffset.z)
end

local function OnAttached(inst, target, followsymbol, followoffset)
    inst.entity:SetParent(target.entity)
    OnChangeFollowSymbol(inst, target, followsymbol, followoffset)
    if inst._followtask ~= nil then
        inst._followtask:Cancel()
    end
    inst._followtask = inst:DoPeriodicTask(0, AlignToTarget, nil, target)
    AlignToTarget(inst, target)

    target:PushEvent("bevolcanopaniced")
end

local function OnDetached(inst)
    local player = inst.entity ~= nil and inst.entity:GetParent()
    if player ~= nil and player.components.talker ~= nil then
        player.components.talker:Say(GetString(player, "DESCRIBE", { "DISH_SUGARLESSTRICKMAKERCUPCAKES", "TRICKED" }))
    end

    inst:Remove()
end

-- local function OnTimerDone(inst, data)
--     if data.name == "panicdone" then
--         inst.components.debuff:Stop()
--     end
-- end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddFollower()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("debuff_panicvolcano")
    inst.AnimState:SetBuild("debuff_panicvolcano")
    inst.AnimState:PlayAnimation("anim")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetFinalOffset(3)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff:SetDetachedFn(OnDetached)
    inst.components.debuff:SetChangeFollowSymbolFn(OnChangeFollowSymbol)

    -- inst:AddComponent("timer")
    -- inst.components.timer:StartTimer("panicdone", 5)
    -- inst:ListenForEvent("timerdone", OnTimerDone)

    inst:ListenForEvent("animover", function(fx)
        fx.components.debuff:Stop()
    end)

    return inst
end

return Prefab("debuff_panicvolcano", fn, assets, nil)
