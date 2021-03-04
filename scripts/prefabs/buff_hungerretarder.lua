local function OnAttached(inst, target) --增
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) --in case of loading
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
    target:PushEvent("foodbuffattached", { buff = "ANNOUNCE_ATTACH_"..string.upper(inst.prefab), priority = 1 })

    if target.components.hunger ~= nil then
        target.components.hunger.burnratemodifiers:SetModifier(inst, 0.1) --饥饿值消耗速度降为0.1倍
    end
end

local function OnExtended(inst, target) --续
    inst.components.timer:StopTimer("hungerretarder")
    inst.components.timer:StartTimer("hungerretarder", TUNING.SEG_TIME * 6)
    target:PushEvent("foodbuffattached", { buff = "ANNOUNCE_ATTACH_"..string.upper(inst.prefab), priority = 1 })

    if target.components.hunger ~= nil then
        target.components.hunger.burnratemodifiers:SetModifier(inst, 0.1) --饥饿值消耗速度降为0.1倍
    end
end

local function OnDetached(inst, target) --删
    if target.components.hunger ~= nil then
        target.components.hunger.burnratemodifiers:RemoveModifier(inst)
    end

    target:PushEvent("foodbuffdetached", { buff = "ANNOUNCE_DETACH_"..string.upper(inst.prefab), priority = 1 })
    inst:Remove()
end

local function OnTimerDone(inst, data)
    if data.name == "hungerretarder" then
        inst.components.debuff:Stop()
    end
end

local function fn()
    local inst = CreateEntity()

    if not TheWorld.ismastersim then
        --Not meant for client!
        inst:DoTaskInTime(0, inst.Remove)

        return inst
    end

    inst.entity:AddTransform()

    --[[Non-networked entity]]
    --inst.entity:SetCanSleep(false)
    inst.entity:Hide()
    inst.persists = false

    inst:AddTag("CLASSIFIED")

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff:SetDetachedFn(OnDetached)
    inst.components.debuff:SetExtendedFn(OnExtended)
    inst.components.debuff.keepondespawn = true

    inst:AddComponent("timer")
    inst.components.timer:StartTimer("hungerretarder", TUNING.SEG_TIME * 6) --SEG_TIME = 30秒 = 0.5分钟
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("buff_hungerretarder", fn)