local TIME_NAME = "sporeresistance"

local function SetTimer(inst, target)
    local timenow = (inst.components.timer:GetTimeLeft(TIME_NAME) or 0) + (target.buff_sporeresistance_time or 0)
    target.buff_sporeresistance_time = nil

    inst.components.timer:StopTimer(TIME_NAME)
    if timenow <= 0 then
        inst.components.debuff:Stop()
        return
    end
    inst.components.timer:StartTimer(TIME_NAME, math.min(timenow, TUNING.SEG_TIME * 30)) --最多15分钟

    if inst.sporetask == nil then
        inst.sporetask = inst:DoPeriodicTask(0.7, function()
            inst:DoTaskInTime(math.random() * 0.6, function()
                if not (target.sg:HasStateTag("nomorph") or
                    target.sg:HasStateTag("silentmorph") or
                    target.sg:HasStateTag("ghostbuild") or
                    target.components.health:IsDead()) and
                    target.entity:IsVisible()
                then
                    SpawnPrefab("residualspores_fx").Transform:SetPosition(target.Transform:GetWorldPosition())
                end
            end)
        end)
        if target.components.health ~= nil then
            target.components.health.externalabsorbmodifiers:SetModifier(inst, 0.25)
        end
    end
end

local function OnAttached(inst, target) --增
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) --in case of loading
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)

    SetTimer(inst, target)
end

local function OnExtended(inst, target) --续
    SetTimer(inst, target)
end

local function OnDetached(inst, target) --删
    if target.components.health ~= nil then
        target.components.health.externalabsorbmodifiers:RemoveModifier(inst)
    end
    if inst.sporetask ~= nil then
        inst.sporetask:Cancel()
        inst.sporetask = nil
    end

    inst:Remove()
end

local function OnTimerDone(inst, data)
    if data.name == TIME_NAME then
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
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("buff_sporeresistance", fn)