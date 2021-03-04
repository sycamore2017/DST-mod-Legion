-- local function OnEquip(player, data)
--     if data.eslot == EQUIPSLOTS.HANDS then
--         player.AnimState:OverrideSymbol("swap_object", "swap_spear", "swap_spear")
--         player.AnimState:OverrideSymbol("swap_hat", "hat_lichen", "swap_hat")
--         player.AnimState:Show("HAT")
--         player.AnimState:Hide("HAIR_HAT")
--         player.AnimState:Show("HAIR_NOHAT")
--         player.AnimState:Show("HAIR")

--         player.AnimState:Show("HEAD")
--         player.AnimState:Hide("HEAD_HAT")
--     end
-- end
-- local function OnUnequip(player, data)
--     if data.eslot == EQUIPSLOTS.HANDS then
--         player.AnimState:OverrideSymbol("swap_object", "swap_spear", "swap_spear")
--         player.AnimState:OverrideSymbol("swap_hat", "hat_lichen", "swap_hat")
--         player.AnimState:Show("HAT")
--         player.AnimState:Hide("HAIR_HAT")
--         player.AnimState:Show("HAIR_NOHAT")
--         player.AnimState:Show("HAIR")

--         player.AnimState:Show("HEAD")
--         player.AnimState:Hide("HEAD_HAT")
--     end
-- end

-- local function OnSkined(inst, target)
--     target:ListenForEvent("equip", OnEquip)
--     target:ListenForEvent("unequip", OnUnequip)
-- end

local function OnAttached(inst, target) --增
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) --in case of loading
    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
    target:PushEvent("foodbuffattached", { buff = "ANNOUNCE_ATTACH_"..string.upper(inst.prefab), priority = 1 })

    target:AddTag("bat") --添加蝙蝠标签，蝙蝠不会攻击有该标签的生物
    -- OnSkined(inst, target)
end

local function OnExtended(inst, target) --续
    inst.components.timer:StopTimer("batdisguise")
    inst.components.timer:StartTimer("batdisguise", TUNING.SEG_TIME * 8)
    target:PushEvent("foodbuffattached", { buff = "ANNOUNCE_ATTACH_"..string.upper(inst.prefab), priority = 1 })

    target:AddTag("bat") --添加蝙蝠标签，蝙蝠不会攻击有该标签的生物
end

local function OnDetached(inst, target) --删
    target:RemoveTag("bat") --移除蝙蝠标签

    target:PushEvent("foodbuffdetached", { buff = "ANNOUNCE_DETACH_"..string.upper(inst.prefab), priority = 1 })
    inst:Remove()
end

local function OnTimerDone(inst, data)
    if data.name == "batdisguise" then
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
    inst.components.timer:StartTimer("batdisguise", TUNING.SEG_TIME * 8) --SEG_TIME = 30秒 = 0.5分钟
    inst:ListenForEvent("timerdone", OnTimerDone)

    return inst
end

return Prefab("buff_batdisguise", fn)