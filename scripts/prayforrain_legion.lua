local prefabFiles = {
    "raindonate",               --雨蝇
    "monstrain",                --雨竹
    "hat_mermbreathing",        --鱼之息
    "merm_scales",              --鱼鳞
    "giantsfoot",               --巨脚背包
    "moonlight_legion",         --月之宝具
    "moon_dungeon",             --月的地下城
}

for k,v in pairs(prefabFiles) do
    table.insert(PrefabFiles, v)
end

-----

local assets = {
    Asset("ANIM", "anim/ui_hiddenmoonlight_4x4.zip"),
    Asset("ANIM", "anim/ui_revolvedmoonlight_4x3.zip"),

    Asset("ATLAS", "images/inventoryimages/squamousfruit.xml"), --预加载，给科技栏用的
    Asset("IMAGE", "images/inventoryimages/squamousfruit.tex"),
    Asset("ATLAS", "images/inventoryimages/raindonate.xml"),
    Asset("IMAGE", "images/inventoryimages/raindonate.tex"),
    Asset("ATLAS", "images/inventoryimages/book_weather.xml"),
    Asset("IMAGE", "images/inventoryimages/book_weather.tex"),
    Asset("ATLAS", "images/inventoryimages/merm_scales.xml"),
    Asset("IMAGE", "images/inventoryimages/merm_scales.tex"),
    Asset("ATLAS", "images/inventoryimages/hat_mermbreathing.xml"),
    Asset("IMAGE", "images/inventoryimages/hat_mermbreathing.tex"),
    Asset("ATLAS", "images/inventoryimages/giantsfoot.xml"),
    Asset("IMAGE", "images/inventoryimages/giantsfoot.tex"),
    Asset("ATLAS", "images/inventoryimages/hiddenmoonlight_item.xml"),
    Asset("IMAGE", "images/inventoryimages/hiddenmoonlight_item.tex"),
    Asset("ATLAS", "images/inventoryimages/revolvedmoonlight_item.xml"),
    Asset("IMAGE", "images/inventoryimages/revolvedmoonlight_item.tex"),
}

for k,v in pairs(assets) do
    table.insert(Assets, v)
end

-----

local _G = GLOBAL
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()

--------------------------------------------------------------------------
--[[ 基础 ]]
--------------------------------------------------------------------------

_G.RegistMiniMapImage_legion("monstrain")
_G.RegistMiniMapImage_legion("agronssword")
_G.RegistMiniMapImage_legion("giantsfoot")
_G.RegistMiniMapImage_legion("refractedmoonlight")
_G.RegistMiniMapImage_legion("moondungeon")
_G.RegistMiniMapImage_legion("hiddenmoonlight")

AddRecipe2(
    "book_weather", {
        Ingredient("papyrus", 8),
        Ingredient("squamousfruit", 3, "images/inventoryimages/squamousfruit.xml"),
        Ingredient("raindonate", 3, "images/inventoryimages/raindonate.xml")
    }, TECH.MAGIC_THREE, {
        atlas = "images/inventoryimages/book_weather.xml", image = "book_weather.tex"
    }, { "MAGIC", "WEAPONS", "RAIN" }
)
AddRecipe2(
    "hat_mermbreathing", {
        Ingredient("merm_scales", 3, "images/inventoryimages/merm_scales.xml"),
    }, TECH.SCIENCE_TWO, {
        atlas = "images/inventoryimages/hat_mermbreathing.xml", image = "hat_mermbreathing.tex"
    }, { "CLOTHING" }
)
AddRecipe2(
    "giantsfoot", {
        Ingredient("merm_scales", 3, "images/inventoryimages/merm_scales.xml"),
        Ingredient("pigskin", 3),
        Ingredient("manrabbit_tail", 3),
    }, TECH.SCIENCE_TWO, {
        atlas = "images/inventoryimages/giantsfoot.xml", image = "giantsfoot.tex"
    }, { "CLOTHING", "CONTAINERS" }
)
AddRecipe2(
    "hiddenmoonlight_item", {
        Ingredient("bluemooneye", 1),
        Ingredient("moonrocknugget", 2),
        Ingredient("slurtle_shellpieces", 1)
    }, TECH.LOST, {
        atlas = "images/inventoryimages/hiddenmoonlight_item.xml", image = "hiddenmoonlight_item.tex"
    }, { "STRUCTURES", "CONTAINERS", "COOKING" }
)
AddRecipe2(
    "revolvedmoonlight_item", {
        Ingredient("yellowmooneye", 1),
        Ingredient("moonrocknugget", 2),
        Ingredient("houndstooth", 1)
    }, TECH.LOST, {
        atlas = "images/inventoryimages/revolvedmoonlight_item.xml", image = "revolvedmoonlight_item.tex"
    }, { "LIGHT", "CONTAINERS" }
)

--------------------------------------------------------------------------
--[[ 修改鱼人，使其可以掉落鱼鳞 ]]
--------------------------------------------------------------------------

if IsServer then
    AddPrefabPostInit("merm", function(inst)
        if inst.components.lootdropper ~= nil then
            inst.components.lootdropper:AddChanceLoot("merm_scales", 0.1)
        end
    end)
    AddPrefabPostInit("mermguard", function(inst)
        if inst.components.lootdropper ~= nil then
            inst.components.lootdropper:AddChanceLoot("merm_scales", 0.1)
        end
    end)
end

--------------------------------------------------------------------------
--[[ 修改人物SG，行走与战斗时，需要切换道具时自动切换 ]]
--------------------------------------------------------------------------

local function EquipSpeedItem(inst)
    local backpack = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BACK or EQUIPSLOTS.BODY) or nil

    if backpack ~= nil and backpack.components.container ~= nil then
        local item1 = backpack.components.container:FindItem(function(item)
            return item.components.equippable ~= nil and item.components.equippable.walkspeedmult ~= nil and item.components.equippable.walkspeedmult > 1
        end)

        if item1 ~= nil then
            inst.components.inventory:Equip(item1)
        end
    end
end

local function EquipFightItem(inst)
    local backpack = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BACK or EQUIPSLOTS.BODY) or nil

    if backpack ~= nil and backpack.components.container ~= nil then
        local item1 = backpack.components.container:FindItem(function(item)
            if item.components.weapon ~= nil and not item:HasTag("projectile") then
                local dmg = item.components.weapon:GetDamage(inst, nil) or 0
                if dmg > 17 or dmg <= 0 then
                    return true
                end
            end
            return false
        end)

        if item1 ~= nil then
            inst.components.inventory:Equip(item1)
        end
    end
end

-- local SGWilson = require "stategraphs/SGwilson" --会使这个文件不再加载，后面新增的动作sg绑定也不会再更新到这里了
-- package.loaded["stategraphs/SGwilson"] = nil --恢复这个文件的加载状态，以便后面的更新

AddStategraphPostInit("wilson", function(sg)
    for k, v in pairs(sg.actionhandlers) do
        if v["action"]["id"] == "ATTACK" then
            local wilson_atk_handler_fn = v.deststate
            v.deststate = function(inst, action)
                if inst.needcombat then
                    inst.sg.mem.localchainattack = not action.forced or nil
                    if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or inst.components.health:IsDead()) then
                        EquipFightItem(inst) --攻击之前先换攻击装备
                    end
                end
                return wilson_atk_handler_fn(inst, action)
            end

            break
        end
    end

    for k, v in pairs(sg.events) do
        if v["name"] == "locomote" then
            local wilson_locomote_event_fn = v.fn
            v.fn = function(inst, data)
                if inst.needrun then
                    if inst.sg:HasStateTag("busy") then
                        return
                    end
                    local is_moving = inst.sg:HasStateTag("moving")
                    local should_move = inst.components.locomotor:WantsToMoveForward()

                    if not (inst.sg:HasStateTag("bedroll") or inst.sg:HasStateTag("tent") or inst.sg:HasStateTag("waking"))
                        and not (is_moving and not should_move) 
                        and (not is_moving and should_move) then
                        EquipSpeedItem(inst)    --行走之前先换加速装备
                    end
                end
                return wilson_locomote_event_fn(inst, data)
            end
        elseif v["name"] == "knockback" then
            local wilson_knockback_event_fn = v.fn
            v.fn = function(inst, data)
                if
                    inst.shield_l_success and inst.components.inventory ~= nil and
                    (inst.components.inventory:EquipHasTag("heavyarmor") or inst:HasTag("heavybody"))
                then
                    return
                end
                return wilson_knockback_event_fn(inst, data)
            end
        end
    end
end)

-- AddStategraphEvent("wilson", EventHandler("locomote",
--     function(inst, data)
--         if inst.sg:HasStateTag("busy") then
--             return
--         end
--         local is_moving = inst.sg:HasStateTag("moving")
--         local should_move = inst.components.locomotor:WantsToMoveForward()

--         if not (inst.sg:HasStateTag("bedroll") or inst.sg:HasStateTag("tent") or inst.sg:HasStateTag("waking")) 
--             and not (is_moving and not should_move) 
--             and (not is_moving and should_move) then
--             EquipSpeedItem(inst)    --行走之前先换加速装备
--         end

--         return SGWilson_loco_event_fn(inst, data)
--     end)
-- )

-- AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.ATTACK,
--     function(inst, action)
--         inst.sg.mem.localchainattack = not action.forced or nil
--         if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or inst.components.health:IsDead()) then
--             EquipFightItem(inst)    --攻击之前先换攻击装备
--             return SGWilson_atk_handler_fn(inst, action)
--         end
--     end)
-- )

-- AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.ATTACK,
--     function(inst, action)
--         if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or inst.replica.health:IsDead()) then
--             local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
--             if equip == nil then
--                 return "attack"
--             end
--             local inventoryitem = equip.replica.inventoryitem
--             return (not (inventoryitem ~= nil and inventoryitem:IsWeapon()) and "attack")
--                 or (equip:HasTag("blowdart") and "blowdart")
--                 or (equip:HasTag("thrown") and "throw")
--                 or (equip:HasTag("propweapon") and "attack_prop_pre")
--                 or "attack"
--         end
--     end)
-- )

--------------------------------------------------------------------------
--[[ 月折宝剑的动作 ]]
--------------------------------------------------------------------------

AddStategraphState("wilson", State{
    name = "moonsurge_l",
    tags = { "doing", "busy", "canrotate" },
    onenter = function(inst)
        local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if equip == nil or not (equip:HasTag("canmoonsurge_l") or equip:HasTag("cansurge_l")) then
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle", true)
            return
        end

        -- inst.AnimState:PlayAnimation("staff_pre")
        -- inst.AnimState:PushAnimation("staff", false)
        inst.AnimState:PlayAnimation("staff") --太拖沓了，直接不要staff_pre那部分的
        inst.components.locomotor:Stop()
        inst.SoundEmitter:PlaySound("moonstorm/creatures/boss/alterguardian3/atk_beam", "lightstart", 0.3)

        local fx_skylight = SpawnPrefab(equip:HasTag("canmoonsurge_l") and "refracted_l_skylight_fx" or "refracted_l_light_fx")
        if fx_skylight ~= nil then
            fx_skylight.Transform:SetPosition(inst.Transform:GetWorldPosition())
        end
    end,
    timeline = {
        TimeEvent(21 * FRAMES, function(inst)
            inst.AnimState:SetFrame(47) --施法动画太长了，直接跳过拖沓的部分
        end),
        TimeEvent(25 * FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/common/together/moonbase/beam_stop", nil, 0.4)
            inst.SoundEmitter:KillSound("lightstart")
        end),
        TimeEvent(29 * FRAMES, function(inst)
            inst:PerformBufferedAction()
            inst.sg:RemoveStateTag("busy")
            inst.sg:AddStateTag("idle")
            local fx = SpawnPrefab("refracted_l_wave_fx")
            if fx ~= nil then
                fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
            end
        end)
    },
    events = {
        EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end)
    },
    onexit = function(inst)
        inst.SoundEmitter:KillSound("lightstart")
    end
})
AddStategraphState("wilson_client", State{
    name = "moonsurge_l",
    tags = { "doing", "busy", "canrotate" },
    server_states = { "moonsurge_l" },
    onenter = function(inst)
        inst.components.locomotor:Stop()
        -- inst.AnimState:PlayAnimation("staff_pre")
        -- inst.AnimState:PushAnimation("staff_lag", false)
        inst.AnimState:PlayAnimation("staff") --太拖沓了，直接不要staff_pre那部分的

        inst:PerformPreviewBufferedAction()
        inst.sg:SetTimeout(2)
    end,
    onupdate = function(inst)
        if inst.sg:ServerStateMatches() then
            if inst.entity:FlattenMovementPrediction() then
                inst.sg:GoToState("idle", "noanim")
            end
        elseif inst.bufferedaction == nil then
            inst.sg:GoToState("idle")
        end
    end,
    ontimeout = function(inst)
        inst:ClearBufferedAction()
        inst.sg:GoToState("idle")
    end,
    timeline = {
        TimeEvent(21 * FRAMES, function(inst)
            inst.AnimState:SetFrame(47) --施法动画太长了，直接跳过拖沓的部分
        end),
        TimeEvent(29 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("busy")
            inst.sg:AddStateTag("idle")
        end)
    }
})

local MOONSURGE_L = Action({ priority = 5, mount_valid = true })
MOONSURGE_L.id = "MOONSURGE_L"
MOONSURGE_L.str = STRINGS.ACTIONS.MOONSURGE_L
MOONSURGE_L.strfn = function(act)
    if act.invobject ~= nil and act.invobject:HasTag("canmoonsurge_l") then
        return "GENERIC"
    end
    return "LACK"
end
MOONSURGE_L.fn = function(act)
    if act.invobject ~= nil and act.invobject.fn_tryRevolt ~= nil then
        act.invobject.fn_tryRevolt(act.invobject, act.doer)
    end
    return true
end
AddAction(MOONSURGE_L)

AddComponentAction("EQUIPPED", "z_refractedmoonlight", function(inst, doer, target, actions, right)
    if
        right and
        doer == target and --对自己使用
        (inst:HasTag("canmoonsurge_l") or inst:HasTag("cansurge_l"))
    then
        table.insert(actions, ACTIONS.MOONSURGE_L)
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.MOONSURGE_L, "moonsurge_l"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.MOONSURGE_L, "moonsurge_l"))
