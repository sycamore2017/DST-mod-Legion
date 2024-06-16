
local fns

--[ 设置掉落散开型特效。借鉴于提灯的皮肤特效代码。但是因为提灯皮肤的特效动画没法做修改，所以整个逻辑都没用了，先留着吧 ]--
local function Fx1_remove(fx)
    fx._lantern._lit_fx_inst = nil
end
local function Fx1_enterlimbo(inst)
    --V2C: wow! superhacks!
    --     we want to drop the FX behind when the item is picked up, but the transform
    --     is cleared before lantern_off is reached, so we need to figure out where we
    --     were just before.
    if inst._lit_fx_inst ~= nil then
        inst._lit_fx_inst._lastpos = inst._lit_fx_inst:GetPosition()
        local parent = inst.entity:GetParent()
        if parent ~= nil then
            local x, y, z = parent.Transform:GetWorldPosition()
            local angle = (360 - parent.Transform:GetRotation()) * DEGREES
            local dx = inst._lit_fx_inst._lastpos.x - x
            local dz = inst._lit_fx_inst._lastpos.z - z
            local sinangle, cosangle = math.sin(angle), math.cos(angle)
            inst._lit_fx_inst._lastpos.x = dx * cosangle + dz * sinangle
            inst._lit_fx_inst._lastpos.y = inst._lit_fx_inst._lastpos.y - y
            inst._lit_fx_inst._lastpos.z = dz * cosangle - dx * sinangle
        end
    end
end
local function Fx1_off(inst)
    local fx = inst._lit_fx_inst
    if fx ~= nil then
        if fx.KillFX ~= nil then
            inst._lit_fx_inst = nil
            inst:RemoveEventCallback("onremove", Fx1_remove, fx)
            fx:RemoveEventCallback("enterlimbo", Fx1_enterlimbo, inst)
            fx._lastpos = fx._lastpos or fx:GetPosition()
            fx.entity:SetParent(nil)
            if fx.Follower ~= nil then
                fx.Follower:StopFollowing()
            end
            fx.Transform:SetPosition(fx._lastpos:Get())
            fx:KillFX()
        else
            fx:Remove()
        end
    end
end
local function Fx1_on(inst)
    local owner = inst.components.inventoryitem.owner
    if owner ~= nil then
        if inst._lit_fx_inst ~= nil and inst._lit_fx_inst.prefab ~= inst._heldfx then
            Fx1_off(inst)
        end
        if inst._heldfx ~= nil then
            if inst._lit_fx_inst == nil then
                inst._lit_fx_inst = SpawnPrefab(inst._heldfx)
                inst._lit_fx_inst._lantern = inst
                inst._lit_fx_inst.entity:AddFollower()
                inst:ListenForEvent("onremove", Fx1_remove, inst._lit_fx_inst)
            end
            inst._lit_fx_inst.entity:SetParent(owner.entity)

            local follow_dd = inst._sets_l.follow_dd
            if follow_dd ~= nil then
                inst._lit_fx_inst.Follower:FollowSymbol(owner.GUID, follow_dd.symbol or "swap_object",
                    follow_dd.x or 0, follow_dd.y or 0, follow_dd.z or 0)
            else
                inst._lit_fx_inst.Follower:FollowSymbol(owner.GUID, "swap_object", 0, 0, 0)
            end
        end
    else
        if inst._lit_fx_inst ~= nil and inst._lit_fx_inst.prefab ~= inst._groundfx then
            Fx1_off(inst)
        end
        if inst._groundfx ~= nil then
            if inst._lit_fx_inst == nil then
                inst._lit_fx_inst = SpawnPrefab(inst._groundfx)
                inst._lit_fx_inst._lantern = inst
                inst:ListenForEvent("onremove", Fx1_remove, inst._lit_fx_inst)
                if inst._lit_fx_inst.KillFX ~= nil then
                    inst._lit_fx_inst:ListenForEvent("enterlimbo", Fx1_enterlimbo, inst)
                end
            end
            inst._lit_fx_inst.entity:SetParent(inst.entity)
        end
    end
end
local function Fx1_init(inst, sets, nostart)
    if not TheWorld.ismastersim then
        return
    end
    inst._heldfx = sets.fx_held
    inst._groundfx = sets.fx_ground
    inst._sets_l = sets
    if sets.events ~= nil then
        for eventname, kind in pairs(sets.events) do
            if kind == 1 then
                inst:ListenForEvent(eventname, Fx1_on)
            else
                inst:ListenForEvent(eventname, Fx1_off)
            end
        end
    else
        inst:ListenForEvent("equipped", Fx1_on)
        inst:ListenForEvent("unequipped", Fx1_off)
        inst:ListenForEvent("onremove", Fx1_off)
    end
    if not nostart then
        Fx1_on(inst)
    end
end
local function Fx1_clear(inst)
    Fx1_off(inst)

    inst._heldfx = nil
    inst._groundfx = nil
    if inst._sets_l ~= nil then
        if inst._sets_l.events ~= nil then
            for eventname, kind in pairs(inst._sets_l.events) do
                if kind == 1 then
                    inst:RemoveEventCallback(eventname, Fx1_on)
                else
                    inst:RemoveEventCallback(eventname, Fx1_off)
                end
            end
        else
            inst:RemoveEventCallback("equipped", Fx1_on)
            inst:RemoveEventCallback("unequipped", Fx1_off)
            inst:RemoveEventCallback("onremove", Fx1_off)
        end
        inst._sets_l = nil
    end
end

-- local TOOLS2_L = require("tools2_legion")
fns = {
    Fx1_init = Fx1_init, Fx1_clear = Fx1_clear,
}

return fns
