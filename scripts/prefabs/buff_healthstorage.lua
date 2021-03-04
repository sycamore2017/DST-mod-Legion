local function OnTick(inst, target) --每次buff周期需要做的事
    if target.components.health ~= nil and not target.components.health:IsDead() and not target:HasTag("playerghost") then
        if target.components.health:IsHurt() then --需要加血
            target.components.health:DoDelta(2, nil, "shyerry")
            inst.times = inst.times - 1
            if inst.times <= 0 then
                inst.components.debuff:Stop()
            end
        end
    else
        inst.components.debuff:Stop()
    end
end

local function OnAttached(inst, target) --增
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) --in case of loading

    if target.buff_healthstorage_times ~= nil then
        inst.times = inst.times + target.buff_healthstorage_times
        target.buff_healthstorage_times = nil
    end
    if inst.times > 0 then
        inst.task = inst:DoPeriodicTask(TUNING.JELLYBEAN_TICK_RATE, OnTick, nil, target)
    end

    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnExtended(inst, target) --续
    if target.buff_healthstorage_times ~= nil then --buff次数可以无限叠加
        inst.times = inst.times + target.buff_healthstorage_times
        target.buff_healthstorage_times = nil
    end

    if inst.task ~= nil then
        inst.task:Cancel()
    end
    if inst.times > 0 then
        inst.task = inst:DoPeriodicTask(TUNING.JELLYBEAN_TICK_RATE, OnTick, nil, target)
    end
end

local function OnDetached(inst, target) --删
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end

    inst:Remove()
end

local function OnSave(inst, data)
    if inst.times ~= nil and inst.times > 0 then
        data.times = inst.times
    end
end

local function OnLoad(inst, data) --这个比OnAttached更早执行
    if data ~= nil and data.times ~= nil and data.times > 0 then
        inst.times = data.times
    end
end

local function Fn()
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

    inst.times = 0

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff:SetDetachedFn(OnDetached)
    inst.components.debuff:SetExtendedFn(OnExtended)
    inst.components.debuff.keepondespawn = true

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("buff_healthstorage", Fn)
