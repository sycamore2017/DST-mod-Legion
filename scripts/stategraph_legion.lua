local _G = GLOBAL
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()
local TOOLS_L = require("tools_legion")

--监听函数修改工具，超强der大佬写滴！
-- local upvaluehelper = require "hua_upvaluehelper"

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
                if --盾反+厚重=防击退
                    inst.shield_l_success and inst.components.inventory ~= nil and
                    (inst.components.inventory:EquipHasTag("heavyarmor") or inst:HasTag("heavybody"))
                then
                    return
                end
                if inst:HasTag("firmbody_l") then --特殊标签防击退
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
--[[ 月折宝剑 ]]
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










--------------------------------------------------------------------------
--[[ 添加触电相关的sg ]]
--------------------------------------------------------------------------

local function ClearStatusAilments(inst)
    if inst.components.freezable ~= nil and inst.components.freezable:IsFrozen() then
        inst.components.freezable:Unfreeze()
    end
    if inst.components.pinnable ~= nil and inst.components.pinnable:IsStuck() then
        inst.components.pinnable:Unstick()
    end
end

------

local shocked_enter = State{
    name = "shocked_enter",
    tags = { "busy", "nopredict", "nodangle", "shocked_l" },

    onenter = function(inst)
        ClearStatusAilments(inst)
        TOOLS_L.ForceStopHeavyLifting(inst)
        inst.components.locomotor:Stop()
        inst:ClearBufferedAction()

        inst.components.inventory:Hide()    --物品栏与科技栏消失
        inst:PushEvent("ms_closepopups")    --关掉打开着的箱子、冰箱等
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:EnableMapControls(false)   --不能打开地图
            inst.components.playercontroller:Enable(false)  --玩家不能操控
            -- inst.components.playercontroller:RemotePausePrediction()
        end

        inst.AnimState:PlayAnimation("shock", true)
    end,

    events = {
        EventHandler("unshocked", function(inst)
            inst.sg:GoToState("shocked_exit")
        end),
        EventHandler("attacked", function(inst)
            inst.sg:GoToState("shocked_exit")
        end)
    },

    onexit = function(inst)
        inst.components.inventory:Show()
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:EnableMapControls(true)
            inst.components.playercontroller:Enable(true)
        end

        if inst.components.shockable ~= nil then
            inst.components.shockable:Unshock()
        end
    end
}
local shocked_exit = State{
    name = "shocked_exit",
    tags = { "idle", "canrotate", "nodangle" },

    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst:ClearBufferedAction()

        inst.AnimState:PlayAnimation("shock_pst")

        inst.sg:SetTimeout(6 * FRAMES)
    end,

    ontimeout = function(inst)
        inst.sg:GoToState("idle", true)
    end
}

AddStategraphState("wilson", shocked_enter)
--AddStategraphState("wilson_client", sanddefense_enter) --客户端与服务端的sg有区别，这里只需要服务端有就行了
AddStategraphState("wilson", shocked_exit)

--通过api添加触电响应函数
AddStategraphEvent("wilson", EventHandler("beshocked", function(inst)
    if inst.components.health ~= nil and not inst.components.health:IsDead() then
        if not inst.sg:HasStateTag("shocked_l") then --防止重复进入sg导致触发 onexit 中的 Unshock() 而导致连续麻痹时会失效
            inst.sg:GoToState("shocked_enter")
        end
    end
end))

--------------------------------------------------------------------------
--[[ 修改beefalo以适应新的牛鞍 ]]
--------------------------------------------------------------------------

local function onopen(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
    inst.SoundEmitter:PlaySound("dontstarve/common/together/packaged")

    if not inst.components.combat:HasTarget() then --防止打开箱子时牛乱跑，如果牛有攻击目标则不停止脑子
        if inst.brain ~= nil and not inst.brain.stopped then
            inst.brain:Stop()
        end

        if inst.components.locomotor ~= nil then
            inst.components.locomotor:Stop()
        end
    end
end
local function onclose(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
    inst.SoundEmitter:PlaySound("dontstarve/common/together/packaged")

    if inst.brain ~= nil and inst.brain.stopped then --关闭箱子时恢复牛的脑子
        inst.brain:Start()
    end
end

local function OnMySaddleChanged(inst, data)
    if inst.components.container ~= nil then
        if data.saddle ~= nil and data.saddle:HasTag("containersaddle") then
            inst.components.container.canbeopened = true
        else
            inst.components.container:Close()
            inst.components.container:DropEverything()
            inst.components.container.canbeopened = false
        end
    end
end
local function OnMyDeath(inst, data)
    if inst.components.container ~= nil then
        inst.components.container:Close()
        inst.components.container.canbeopened = false
    end
end
local function OnMyAttacked(inst, data)
    if inst.components.container ~= nil then
        inst.components.container:Close()
    end
end
local function OnMyRiderChanged(inst, data)
    if inst.components.container ~= nil then
        inst.components.container:Close()
    end
end

AddPrefabPostInit("beefalo", function(inst)
    inst:AddTag("fridge") --给予容器0.5保鲜效果
    inst:AddTag("nocool") --没有冷冻的效果

    if IsServer then
        if inst.components.container == nil then --由于官方的动作检测函数的问题，导致不能中途加入容器组件，所以只能默认每个牛都加个容器组件
            inst:AddComponent("container")
            inst.components.container:WidgetSetup("beefalo")
            inst.components.container.onopenfn = onopen
            inst.components.container.onclosefn = onclose
            inst.components.container.canbeopened = false
        end

        inst:ListenForEvent("saddlechanged", OnMySaddleChanged)
        inst:ListenForEvent("death", OnMyDeath)
        inst:ListenForEvent("attacked", OnMyAttacked)
        inst:ListenForEvent("riderchanged", OnMyRiderChanged)
    end
end)

--------------------------------------------------------------------------
--[[ 新增专属喂牛动作以适应新的牛鞍 ]]
--------------------------------------------------------------------------

------右键存放动作------

local STORE_BEEF_L = Action({ priority = 2, mount_valid = true })
STORE_BEEF_L.id = "STORE_BEEF_L" --这个操作的id
STORE_BEEF_L.str = STRINGS.ACTIONS_LEGION.STORE_BEEF_L --这个操作的名字，比如法杖是castspell，蜗牛壳甲是use
STORE_BEEF_L.fn = ACTIONS.STORE.fn --这个操作执行时进行的功能函数
AddAction(STORE_BEEF_L) --向游戏注册一个动作

-- STORE_BEEF_L 组件动作响应已移到 CA_U_INVENTORYITEM_L 中

--将一个动作与state绑定
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.STORE_BEEF_L, "give"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.STORE_BEEF_L, "give")) --在联机版中添加新动作需要对wilson和wilson_cient两个sg都进行state绑定

------左键喂食动作------

--喂食的优先级得小于存放的
local FEED_BEEF_L = Action({ priority = 1, mount_valid = true, canforce=true, rangecheckfn = ACTIONS.GIVE.rangecheckfn })
FEED_BEEF_L.id = "FEED_BEEF_L"
FEED_BEEF_L.str = STRINGS.ACTIONS_LEGION.FEED_BEEF_L
FEED_BEEF_L.fn = ACTIONS.GIVE.fn
AddAction(FEED_BEEF_L)

AddComponentAction("USEITEM", "tradable", function(inst, doer, target, actions, right)
    if
        target:HasTag("trader") and target:HasTag("saddleable") and
        target.replica.container ~= nil and target.replica.container:CanBeOpened() and --该动作只针对驮运鞍具的牛
        not (
            doer.replica.rider ~= nil and doer.replica.rider:IsRiding() and
            not (target.replica.inventoryitem ~= nil and target.replica.inventoryitem:IsGrandOwner(doer))
        )
    then
        table.insert(actions, ACTIONS.FEED_BEEF_L) --非要我重新写一个动作才让这个动作生效，无语
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.FEED_BEEF_L, "give"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.FEED_BEEF_L, "give"))

--------------------------------------------------------------------------
--[[ 素白蘑菇帽的打喷嚏释放其技能的sg ]]
--------------------------------------------------------------------------

local release_spores = State{
    name = "release_spores",
    tags = { "busy", "doing", "canrotate" },

    onenter = function(inst, hat)
        if hat == nil then
            inst.sg:GoToState("idle")
            return
        end
        inst.sg.statemem.hat = hat
        inst.sg.statemem.fxcolour = hat.fxcolour or { 1, 1, 1 }
        inst.sg.statemem.castsound = hat.castsound

        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(false)
        end
        inst.AnimState:PlayAnimation("cointoss_pre")
        inst.AnimState:PushAnimation("cointoss", false)
        inst.components.locomotor:Stop()
    end,

    events =
    {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    timeline =
    {
        TimeEvent(7 * FRAMES, function(inst)
            inst.sg.statemem.stafffx = SpawnPrefab((inst.components.rider ~= nil and inst.components.rider:IsRiding()) and "cointosscastfx_mount" or "cointosscastfx")
            inst.sg.statemem.stafffx.AnimState:OverrideSymbol("coin01", "albicansspore_fx", "coin01")
            inst.sg.statemem.stafffx.entity:SetParent(inst.entity)
            inst.sg.statemem.stafffx.Transform:SetRotation(inst.Transform:GetRotation())
            inst.sg.statemem.stafffx:SetUp(inst.sg.statemem.fxcolour)
        end),
        TimeEvent(15 * FRAMES, function(inst)
            inst.sg.statemem.stafflight = SpawnPrefab("staff_castinglight")
            inst.sg.statemem.stafflight.Transform:SetPosition(inst.Transform:GetWorldPosition())
            inst.sg.statemem.stafflight:SetUp(inst.sg.statemem.fxcolour, 1.2, .33)
        end),
        TimeEvent(13 * FRAMES, function(inst)
            if inst.sg.statemem.castsound then
                inst.SoundEmitter:PlaySound(inst.sg.statemem.castsound)
            end
        end),
        TimeEvent(43*FRAMES, function(inst)
            SpawnPrefab("albicanscloud_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
        end),
        TimeEvent(53 * FRAMES, function(inst)
            inst.sg.statemem.stafffx = nil --Can't be cancelled anymore
            inst.sg.statemem.stafflight = nil --Can't be cancelled anymore
            if inst.sg.statemem.hat.releasedfn ~= nil then
                inst.sg.statemem.hat:releasedfn(inst)
            end
        end),
    },

    onexit = function(inst)
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(true)
        end
        if inst.sg.statemem.stafffx ~= nil and inst.sg.statemem.stafffx:IsValid() then
            inst.sg.statemem.stafffx:Remove()
        end
        if inst.sg.statemem.stafflight ~= nil and inst.sg.statemem.stafflight:IsValid() then
            inst.sg.statemem.stafflight:Remove()
        end
        if inst.sg.statemem.hat.components.useableitem ~= nil then
            inst.sg.statemem.hat.components.useableitem:StopUsingItem()
        end
    end,
}

AddStategraphState("wilson", release_spores)

--------------------------------------------------------------------------
--[[ 灵魂契约书瞬移、加血相关 ]]
--------------------------------------------------------------------------

-- local function FindItemWithoutContainer(inst, fn)
--     local inventory = inst.components.inventory
--     for k,v in pairs(inventory.itemslots) do
--         if v and fn(v) then
--             return v
--         end
--     end
--     if inventory.activeitem and fn(inventory.activeitem) then
--         return inventory.activeitem
--     end
-- end

--[[
-- 辅助沃托克斯管理灵魂
local onsetonwer_f = false
local ondropitem_f = false
AddPrefabPostInit("wortox", function(inst)
    --携带契约书能够使用瞬移
    if not onsetonwer_f then
        onsetonwer_f = true
        ---------------------------
        --因为upvaluehelper机制是一次修改，影响全局，所以用onsetonwer_f等变量来控制只修改一次，防止函数越套越厚，
        --还要记得清除不再使用的变量
        ---------------------------
        local OnSetOwner = upvaluehelper.GetEventHandle(inst, "setowner", "prefabs/wortox")
        if OnSetOwner ~= nil then
            local GetPointSpecialActions_old = upvaluehelper.Get(OnSetOwner, "GetPointSpecialActions")
            if GetPointSpecialActions_old ~= nil then
                local function GetPointSpecialActions_new(inst, pos, useitem, right)
                    if
                        right and useitem == nil and
                        not TheWorld.Map:IsGroundTargetBlocked(pos) and
                        (inst.replica.rider == nil or not inst.replica.rider:IsRiding())
                    then
                        local items = inst.replica.inventory:GetItems()
                        for _,v in pairs(items) do
                            if v:HasTag("soulcontracts") and not v:HasTag("nosoulleft") then
                                return { ACTIONS.BLINK }
                            end
                        end
                    end
                    return GetPointSpecialActions_old(inst, pos, useitem, right)
                end
                upvaluehelper.Set(OnSetOwner, "GetPointSpecialActions", GetPointSpecialActions_new)
            end
        end
        OnSetOwner = nil
    end

    if IsServer then
        --使用灵魂后提示契约书中灵魂数量
        if not ondropitem_f then
            ondropitem_f = true
            local OnDropItem = upvaluehelper.GetEventHandle(inst, "dropitem", "prefabs/wortox")
            if OnDropItem ~= nil then
                local CheckSoulsRemoved_old = upvaluehelper.Get(OnDropItem, "CheckSoulsRemoved")
                if CheckSoulsRemoved_old ~= nil then
                    local function CheckSoulsRemoved_new(inst)
                        local book = FindItemWithoutContainer(inst, function(item)
                            return item:HasTag("soulcontracts")
                        end)
                        if book ~= nil and book.components.finiteuses ~= nil then
                            inst._checksoulstask = nil
                            if book.components.finiteuses:GetPercent() <= 0 then
                                inst:PushEvent("soulempty")
                            elseif book.components.finiteuses:GetPercent() < 0.2 then
                                inst:PushEvent("soultoofew")
                            end
                        else
                            CheckSoulsRemoved_old(inst)
                        end
                    end
                    upvaluehelper.Set(OnDropItem, "CheckSoulsRemoved", CheckSoulsRemoved_new)
                end
            end
            OnDropItem = nil
        end
    end
    
end)
]]--

if IsServer then
    local wortox_soul_c = require("prefabs/wortox_soul_common")
    local GiveSouls_old = wortox_soul_c.GiveSouls
    wortox_soul_c.GiveSouls = function(inst, num, pos, ...)
        if inst._contracts_l ~= nil then --受契约的保护
            wortox_soul_c.SpawnSoulsAt(inst, num) --让灵魂直接掉地上，重新进行一遍逻辑，这样就不用多写什么了
            return
        end
        if GiveSouls_old ~= nil then
            GiveSouls_old(inst, num, pos, ...)
        end
    end

    local function GetSouls(inst)
        local souls = inst.components.inventory:FindItems(function(item)
            return item.prefab == "wortox_soul"
        end)
        local soulscount = 0
        for i, v in ipairs(souls) do
            soulscount = soulscount +
                (v.components.stackable ~= nil and v.components.stackable:StackSize() or 1)
        end
        return souls, soulscount
    end
    local function SetSoulFx(book, doer)
        local fx = SpawnPrefab(book._dd and book._dd.fx or "wortox_soul_in_fx")
        fx.Transform:SetPosition(doer.Transform:GetWorldPosition())
        fx:Setup(doer)
    end
    local function ValidSoulTarget(v)
        if
            v.components.health ~= nil and not v.components.health:IsDead() and
            not v:HasTag("playerghost")
        then
            return true
        end
    end

    local function OnHit_soul(inst, attacker, target)
        inst:Remove()
    end
    local function OnPreHit_soul(inst, attacker, target)
        if target ~= nil then
            local owner = nil
            local book = nil
            if target:HasTag("soulcontracts") then
                book = target
                if book._contractsowner ~= nil and book._contractsowner:IsValid() then
                    owner = book._contractsowner
                end
            elseif target.components.inventory ~= nil then
                owner = target
                if owner._contracts_l ~= nil and owner._contracts_l:IsValid() then
                    book = owner._contracts_l
                end
            end
            if book ~= nil and book.components.finiteuses ~= nil then
                if book.components.finiteuses:GetPercent() < 1 then
                    book.components.finiteuses:Repair(1)
                    SetSoulFx(book, book)
                elseif
                    owner ~= nil and owner.components.inventory ~= nil and
                    owner.components.inventory.isopen --这里应该可以规避死亡状态的玩家，所以就不多判断了
                then
                    local souls, count = GetSouls(owner)
                    if count >= TUNING.WORTOX_MAX_SOULS then --灵魂达到上限，自动释放
                        if book._SoulHealing ~= nil  then
                            book._SoulHealing(owner)
                        end
                    else
                        owner.components.inventory:GiveItem(SpawnPrefab("wortox_soul"), nil, owner:GetPosition())
                    end
                    SetSoulFx(book, owner)
                elseif book._SoulHealing ~= nil then
                    book._SoulHealing(book)
                    SetSoulFx(book, book)
                end
                -- inst:Remove()
                inst.components.projectile.onhit = OnHit_soul --这里就是契约逻辑主导了，不能再执行原本的
                return
            end
        end
        if inst.onprehit_l_contract ~= nil then
            inst.onprehit_l_contract(inst, attacker, target)
        end
    end
    local function SeekSoulContracts(inst)
        if inst.components.projectile:IsThrown() then --有target了，就不执行逻辑了，防止和别的逻辑冲突
            if inst._seektask_l ~= nil then
                inst._seektask_l:Cancel()
                inst._seektask_l = nil
            end
            return
        end
        local toer = FindEntity(inst, TUNING.WORTOX_SOULSTEALER_RANGE+4, function(one, inst)
            if one.components.finiteuses ~= nil then
                if one.components.finiteuses:GetPercent() >= 1 then
                    if --契约耐久满了，应该把灵魂给主人，不然也装不下
                        one._contractsowner ~= nil and one._contractsowner:IsValid() and
                        ValidSoulTarget(one._contractsowner)
                    then
                        return true
                    end
                else
                    return true
                end
            elseif one._contracts_l ~= nil and ValidSoulTarget(one) then
                return true
            end
        end, nil, { "INLIMBO", "NOCLICK", "playerghost" }, { "soulcontracts", "player" })
        if toer ~= nil then
            if toer.components.finiteuses ~= nil and toer.components.finiteuses:GetPercent() >= 1 then
                if toer._contractsowner ~= nil then
                    toer = toer._contractsowner --如果耐久满了，则寻找其主人
                end
            end
            if inst._seektask ~= nil then --停止原有的逻辑
                inst._seektask:Cancel()
                inst._seektask = nil
            end
            if inst._seektask_l ~= nil then
                inst._seektask_l:Cancel()
                inst._seektask_l = nil
            end
            inst.components.projectile:Throw(inst, toer, inst)
        end
    end

    -- local seeksoulstealer_f = false
    AddPrefabPostInit("wortox_soul_spawn", function(inst)
        --灵魂优先寻找契约，或者契约的主人
        --为了兼容勋章，另外执行一个函数，比原有逻辑快一步触发就行
        inst._seektask_l = inst:DoPeriodicTask(0.5, SeekSoulContracts, 0.5)

        --[[
        if not seeksoulstealer_f then
            seeksoulstealer_f = true
            local SeekSoulStealer_old = upvaluehelper.Get(_G.Prefabs["wortox_soul_spawn"].fn, "SeekSoulStealer")
            if SeekSoulStealer_old ~= nil then
                local function SeekSoulStealer_new(inst)
                    local toer = FindEntity(inst, TUNING.WORTOX_SOULSTEALER_RANGE+4, function(one, inst)
                        if one.components.finiteuses ~= nil then
                            if one.components.finiteuses:GetPercent() >= 1 then
                                if
                                    one._contractsowner ~= nil and one._contractsowner:IsValid() and
                                    ValidSoulTarget(one._contractsowner)
                                then
                                    return true
                                end
                            else
                                return true
                            end
                        elseif one._contracts_l ~= nil and ValidSoulTarget(one) then
                            return true
                        end
                    end, nil, { "INLIMBO", "NOCLICK", "playerghost", "notarget" }, { "soulcontracts", "player" })
                    if toer ~= nil then
                        if toer.components.finiteuses ~= nil and toer.components.finiteuses:GetPercent() >= 1 then
                            if toer._contractsowner ~= nil then
                                toer = toer._contractsowner --如果耐久满了，则寻找其主人
                            end
                        end
                        inst.components.projectile:Throw(inst, toer, inst)
                    else
                        SeekSoulStealer_old(inst)
                    end
                end
                upvaluehelper.Set(_G.Prefabs["wortox_soul_spawn"].fn, "SeekSoulStealer", SeekSoulStealer_new)
            end
        end
        ]]--

        --优化灵魂进入契约或者玩家时的逻辑
        --为了兼容勋章，我改的 onprehit 而不是 onhit
        inst.onprehit_l_contract = inst.components.projectile.onprehit
        inst.components.projectile:SetOnPreHitFn(OnPreHit_soul)
    end)
end

--------------------------------------------------------------------------
--[[ 灵魂契约的索取动作 ]]
--------------------------------------------------------------------------

local RETURN_CONTRACTS = Action({ mount_valid=true })
RETURN_CONTRACTS.id = "RETURN_CONTRACTS"
RETURN_CONTRACTS.str = STRINGS.ACTIONS_LEGION.RETURN_CONTRACTS
RETURN_CONTRACTS.fn = function(act)
    local obj = act.target or act.invobject
    if obj ~= nil then
        if obj.components.soulcontracts ~= nil then
            return obj.components.soulcontracts:ReturnSouls(act.doer)
        end
    end
end
AddAction(RETURN_CONTRACTS)

AddComponentAction("INVENTORY", "soulcontracts", function(inst, doer, actions, right)
    --鼠标指向物品栏里的对象时，或者在鼠标上的对象指向玩家自己时，触发
    if not inst:HasTag("nosoulleft") then
        table.insert(actions, ACTIONS.RETURN_CONTRACTS)
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.RETURN_CONTRACTS, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.RETURN_CONTRACTS, "doshortaction"))

--------------------------------------------------------------------------
--[[ 灵魂契约的收回动作 ]]
--------------------------------------------------------------------------

local PICKUP_CONTRACTS = Action({ mount_valid=true })
PICKUP_CONTRACTS.id = "PICKUP_CONTRACTS"
PICKUP_CONTRACTS.str = STRINGS.ACTIONS_LEGION.PICKUP_CONTRACTS
PICKUP_CONTRACTS.fn = function(act)
    if
        act.doer.components.inventory ~= nil and
        act.target ~= nil and
        act.target.components.soulcontracts ~= nil and
        not act.target:IsInLimbo()
    then
        return act.target.components.soulcontracts:PickUp(act.doer)
    end
end
AddAction(PICKUP_CONTRACTS)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.PICKUP_CONTRACTS, function(inst, action)
    return (inst.components.rider ~= nil and inst.components.rider:IsRiding()) and "domediumaction" or "doshortaction"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.PICKUP_CONTRACTS, function(inst, action)
    return (inst.replica.rider ~= nil and inst.replica.rider:IsRiding()) and "domediumaction" or "doshortaction"
end))

--------------------------------------------------------------------------
--[[ 灵魂契约的跟随状态切换动作 ]]
--------------------------------------------------------------------------

local EXSTAY_CONTRACTS = Action({ mount_valid=true, distance=20 })
EXSTAY_CONTRACTS.id = "EXSTAY_CONTRACTS"
EXSTAY_CONTRACTS.str = STRINGS.ACTIONS.EXSTAY_CONTRACTS
EXSTAY_CONTRACTS.strfn = function(act)
    if act.target ~= nil then
        if act.target:HasTag("bookstaying") then
            return "GENERIC"
        end
    end
    return "STAY"
end
EXSTAY_CONTRACTS.fn = function(act)
    if
        act.target ~= nil and not act.target:IsInLimbo() and
        act.target.components.soulcontracts ~= nil
    then
        return act.target.components.soulcontracts:TriggerOwner(nil, act.doer)
    end
    return false, "NORIGHT"
end
AddAction(EXSTAY_CONTRACTS)

AddComponentAction("SCENE", "soulcontracts", function(inst, doer, actions, right)
    if right then
        table.insert(actions, ACTIONS.EXSTAY_CONTRACTS)
    elseif doer.replica.inventory ~= nil and doer.replica.inventory:GetNumSlots() > 0 then
        table.insert(actions, ACTIONS.PICKUP_CONTRACTS)
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.EXSTAY_CONTRACTS, "veryquickcastspell"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.EXSTAY_CONTRACTS, "veryquickcastspell"))

--------------------------------------------------------------------------
--[[ 灵魂契约的给予灵魂动作 ]]
--------------------------------------------------------------------------

local GIVE_CONTRACTS = Action({ priority=4, mount_valid=true })
GIVE_CONTRACTS.id = "GIVE_CONTRACTS"
GIVE_CONTRACTS.str = STRINGS.ACTIONS_LEGION.GIVE_CONTRACTS
GIVE_CONTRACTS.fn = function(act)
    if
        act.invobject ~= nil and
        act.target ~= nil and act.target.components.soulcontracts ~= nil
    then
        return act.target.components.soulcontracts:GiveSoul(act.doer, act.invobject)
    end
end
AddAction(GIVE_CONTRACTS)

AddComponentAction("USEITEM", "soul", function(inst, doer, target, actions, right)
    if target and target:HasTag("soulcontracts") then
        table.insert(actions, ACTIONS.GIVE_CONTRACTS)
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.GIVE_CONTRACTS, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.GIVE_CONTRACTS, "doshortaction"))
