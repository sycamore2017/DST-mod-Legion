local assets =
{
    Asset("ANIM", "anim/wortox_soul_ball.zip"),
}

local SCALE = .8

local function MakeSoulFx(name, data)
    local TINT = data.color

    local function PushColour(inst, addval, multval)
        if inst.components.highlight == nil then
            inst.AnimState:SetHighlightColour(TINT.r * addval, TINT.g * addval, TINT.b * addval, 0)
            inst.AnimState:OverrideMultColour(multval, multval, multval, 1)
        else
            inst.AnimState:OverrideMultColour()
        end
    end
    local function PopColour(inst)
        if inst.components.highlight == nil then
            inst.AnimState:SetHighlightColour()
        end
        inst.AnimState:OverrideMultColour()
    end

    local function OnUpdateTargetTint(inst)--, dt)
        if inst._tinttarget:IsValid() then
            local curframe = inst.AnimState:GetCurrentAnimationTime() / FRAMES
            if curframe < 10 then
                local k = curframe / 10
                k = k * k
                PushColour(inst._tinttarget, (1 - k) * .7, k * .7 + .3)
            else
                inst.components.updatelooper:RemoveOnUpdateFn(OnUpdateTargetTint)
                inst.OnRemoveEntity = nil
                PopColour(inst._tinttarget)
            end
        else
            inst.components.updatelooper:RemoveOnUpdateFn(OnUpdateTargetTint)
            inst.OnRemoveEntity = nil
        end
    end

    local function OnRemoveEntity(inst)
        if inst._tinttarget:IsValid() then
            PopColour(inst._tinttarget)
        end
    end

    local function OnTargetDirty(inst)
        if inst._target:value() ~= nil and inst._tinttarget == nil then
            if inst.components.updatelooper == nil then
                inst:AddComponent("updatelooper")
            end
            inst.components.updatelooper:AddOnUpdateFn(OnUpdateTargetTint)
            inst._tinttarget = inst._target:value()
            inst.OnRemoveEntity = OnRemoveEntity
        end
    end

    local function Setup(inst, target)
        inst._target:set(target)
        if not TheNet:IsDedicated() then
            OnTargetDirty(inst)
        end
        if target.SoundEmitter ~= nil then
            target.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/spawn", nil, .5)
        end
    end

    local function Fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst.AnimState:SetBank("wortox_soul_ball")
        inst.AnimState:SetBuild("wortox_soul_ball")
        inst.AnimState:PlayAnimation("idle_pst")
        inst.AnimState:SetTime(6 * FRAMES)
        inst.AnimState:SetScale(SCALE, SCALE)
        inst.AnimState:SetFinalOffset(3)

        inst:AddTag("FX")

        inst._target = net_entity(inst.GUID, name.."._target", "targetdirty")

        if data.fn_common ~= nil then
            data.fn_common(inst)
        end

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            inst:ListenForEvent("targetdirty", OnTargetDirty)
            return inst
        end

        inst:ListenForEvent("animover", inst.Remove)
        inst.persists = false
        inst.Setup = Setup

        return inst
    end

    return Prefab(name, Fn, assets)
end

------
------

local data_base = {
    color = { r = 154/255, g = 23/255, b = 19/255 },
    fn_common = nil
}
local data_taste = {
    color = { r = 246/255, g = 207/255, b = 75/255 },
    fn_common = function(inst)
        inst.AnimState:SetHighlightColour(246/255, 207/255, 75/255, 0) --Tip: 该函数没法帧同步
    end
}

------

return MakeSoulFx("l_soul_fx", data_base),
    MakeSoulFx("l_soul_fx_taste", data_taste)
