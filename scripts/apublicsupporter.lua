--这里的内容主要是兼容性修改，优化性修改，mod内容里的通用修改部分(比如都要修改某个组件时，我就会把改动内容单独移到这里来，不再单独修改)

local _G = GLOBAL
local TOOLS_L = require("tools_legion")
local SpDamageUtil = require("components/spdamageutil")
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()

--------------------------------------------------------------------------
--[[ 方便进行代码开发的各种自定义工具函数 ]]
--------------------------------------------------------------------------

--[ 地图图标注册 ]--
_G.RegistMiniMapImage_legion = function(filename, fileaddresspre)
    local fileaddresscut = (fileaddresspre or "images/map_icons/")..filename

    table.insert(Assets, Asset("ATLAS", fileaddresscut..".xml"))
    table.insert(Assets, Asset("IMAGE", fileaddresscut..".tex"))

    AddMinimapAtlas(fileaddresscut..".xml")

    --  接下来就需要在prefab定义里添加：
    --      inst.entity:AddMiniMapEntity()
    --      inst.MiniMapEntity:SetIcon("图片文件名.tex")
end

--[ 吉他曲管理(mod兼容用的，如果其他mod想要增加自己的曲子就用以下代码) ]--
if not _G.rawget(_G, "GUITARSONGSPOOL_LEGION") then
    _G.GUITARSONGSPOOL_LEGION = {}
end
--[[
_G.GUITARSONGSPOOL_LEGION["weisuo"] = function(guitar, doer, team, songs, guitartype) --吉他实体、主弹演奏者、演奏团队、已有的曲子、演奏类型
    if guitar.prefab == "guitar_whitewood" then --以后还会出新的吉他，所以这里要有限制
        local songmap = {
            shiye = "歌曲路径",
            faye = "歌曲路径2",
            noobmaster = "歌曲路径3",
            chenyu = "歌曲路径4"
        }
        local song = songmap[doer.prefab] or nil
        local num_weisuo = song ~= nil and 1 or 0

        if team ~= nil then --team里只有其他人，没有主弹
            for _, player in pairs(team) do
                if player and songmap[player.prefab] ~= nil then
                    num_weisuo = num_weisuo + 1
                end
            end
            if num_weisuo >= 4 then
                song = "四人歌曲路径"
            elseif num_weisuo >= 3 then
                song = "三人歌曲路径"
            elseif num_weisuo >= 2 then
                song = "双人歌曲路径"
            end
        end

        if song ~= nil then
            doer.SoundEmitter:PlaySound(song, "guitarsong_l")
            doer.SoundEmitter:SetVolume("guitarsong_l", 0.5)
            return "override" --返回"override"代表只用这里的歌曲；否则就得往 songs 里加新的歌曲路径
        end
    end
end
]]--

--------------------------------------------------------------------------
--[[ 修改rider组件，重新构造combat的redirectdamagefn函数以适应更多元的机制 ]]
--------------------------------------------------------------------------

--[[
if IsServer then
    function GLOBAL.RebuildRedirectDamageFn(player) --重新构造combat的redirectdamagefn函数
        --初始化
        if player.redirect_table == nil then
            player.redirect_table = {}
        end
        if player.components.combat ~= nil then
            --重新定义combat的redirectdamagefn
            player.components.combat.redirectdamagefn = function(victim, attacker, damage, weapon, stimuli)
                local redirect = nil
                for k, v in pairs(victim.redirect_table) do
                    redirect = victim.redirect_table[k](victim, attacker, damage, weapon, stimuli)
                    if redirect ~= nil then
                        break
                    end
                end
                return redirect, 'legioned'
            end
        end
    end

    AddComponentPostInit("rider", function(self)
        local Mount_old = self.Mount
        self.Mount = function(self, target, instant)
            if (self.riding or target.components.rideable == nil or target.components.rideable:IsBeingRidden())
                or not target.components.rideable:TestObedience() then
                Mount_old(self, target, instant)
                return
            end

            Mount_old(self, target, instant)
            --先登记骑牛保护的旧函数
            if self.inst.components.combat ~= nil then
                if self.inst.redirect_table == nil then
                    self.inst.redirect_table = {}
                end
                if self.inst.components.combat.redirectdamagefn ~= nil then
                    --提前测试一下，防止无限递归
                    local redirect, tag = self.inst.components.combat.redirectdamagefn(self.inst, nil, 0, nil, nil)
                    if tag == nil then
                        self.inst.redirect_table[target.prefab] = self.inst.components.combat.redirectdamagefn
                    end
                end

                --再重构combat的redirectdamagefn
                RebuildRedirectDamageFn(self.inst)
            end
        end

        local ActualDismount_old = self.ActualDismount
        self.ActualDismount = function(self)
            local ex_mount = ActualDismount_old(self)
            if ex_mount ~= nil then
                --清除骑牛保护的旧函数
                if self.inst.components.combat ~= nil then
                    self.inst.redirect_table[ex_mount.prefab] = nil

                    --因为下牛时redirectdamagefn被还原，所以这里还要重新定义一遍
                    RebuildRedirectDamageFn(self.inst)
                end
            end
        end
    end)
end
]]--

--------------------------------------------------------------------------
--[[ 修改playercontroller组件，防止既有手持装备组件和栽种组件的物品在栽种时会先自动装备在身上的问题 ]]
--------------------------------------------------------------------------

-- 666，官方居然把这里修复了，我就不用再改了，哈哈

-- AddComponentPostInit("playercontroller", function(self)
--     local DoActionAutoEquip_old = self.DoActionAutoEquip
--     self.DoActionAutoEquip = function(self, buffaction)
--         if buffaction.invobject ~= nil and
--             buffaction.invobject.replica.equippable ~= nil and
--             buffaction.invobject.replica.equippable:EquipSlot() == EQUIPSLOTS.HANDS and
--             buffaction.action == ACTIONS.DEPLOY then
--             --do nothing
--         else
--             DoActionAutoEquip_old(self, buffaction)
--         end
--     end
-- end)

--------------------------------------------------------------------------
--[[ 弹吉他相关 ]]
--------------------------------------------------------------------------

local function ResumeHands(inst)
    local hands = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    if hands ~= nil and not hands:HasTag("book") then
        inst.AnimState:Show("ARM_carry")
        inst.AnimState:Hide("ARM_normal")
    end
end

local playguitar_pre = State{
    name = "playguitar_pre",
    tags = { "doing", "playguitar" },

    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("soothingplay_pre", false)
        inst.AnimState:Hide("ARM_carry")
        inst.AnimState:Show("ARM_normal")

        local guitar = inst.bufferedaction ~= nil and (inst.bufferedaction.invobject or inst.bufferedaction.target) or nil
        inst.components.inventory:ReturnActiveActionItem(guitar)

        if guitar ~= nil and guitar.PlayStart ~= nil then --动作的执行处
            guitar:AddTag("busyguitar")
            inst.sg.statemem.instrument = guitar
            guitar.PlayStart(guitar, inst)
            inst:PerformBufferedAction()
        else
            inst:PushEvent("actionfailed", { action = inst.bufferedaction, reason = nil })
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle")
            return
        end

        inst.sg.statemem.playdoing = false
    end,

    events =
    {
        EventHandler("equip", function(inst)    --防止装备时改变手的显示状态
            inst.AnimState:Hide("ARM_carry")
            inst.AnimState:Show("ARM_normal")
        end),

        EventHandler("unequip", function(inst)  --防止卸下时改变手的显示状态
            inst.AnimState:Hide("ARM_carry")
            inst.AnimState:Show("ARM_normal")
        end),

        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg.statemem.playdoing = true
                inst.sg:GoToState("playguitar_loop", inst.sg.statemem.instrument)
            end
        end),
    },

    onexit = function(inst)
        if not inst.sg.statemem.playdoing then
            ResumeHands(inst)

            if inst.sg.statemem.instrument ~= nil then
                inst.sg.statemem.instrument:RemoveTag("busyguitar")
            end
        end
    end,
}

local playguitar_loop = State{
    name = "playguitar_loop",
    tags = { "doing", "playguitar" },

    onenter = function(inst, instrument)
        inst.components.locomotor:Stop()
        inst.AnimState:Hide("ARM_carry")
        inst.AnimState:Show("ARM_normal")

        if instrument ~= nil and instrument.PlayDoing ~= nil then
            instrument.PlayDoing(instrument, inst)
        end

        inst.sg.statemem.instrument = instrument
        inst.sg.statemem.playdoing = false
    end,

    events =
    {
        EventHandler("equip", function(inst)    --防止装备时改变手的显示状态
            inst.AnimState:Hide("ARM_carry")
            inst.AnimState:Show("ARM_normal")
        end),

        EventHandler("unequip", function(inst)  --防止卸下时改变手的显示状态
            inst.AnimState:Hide("ARM_carry")
            inst.AnimState:Show("ARM_normal")
        end),

        EventHandler("playenough", function(inst)
            inst.sg.statemem.playdoing = true
            inst.sg:GoToState("playguitar_pst")
        end),
    },

    onexit = function(inst)
        if not inst.sg.statemem.playdoing then
            ResumeHands(inst)
        end

        if inst.sg.statemem.instrument ~= nil then
            if inst.sg.statemem.instrument.PlayEnd ~= nil then
                inst.sg.statemem.instrument.PlayEnd(inst.sg.statemem.instrument, inst)
            end
            inst.sg.statemem.instrument:RemoveTag("busyguitar")
        end
    end,
}

local playguitar_pst = State{
    name = "playguitar_pst",
    tags = { "doing", "playguitar" },

    onenter = function(inst)
        inst.components.locomotor:Stop()

        inst.AnimState:PlayAnimation("soothingplay_pst", false)
        inst.AnimState:Hide("ARM_carry")
        inst.AnimState:Show("ARM_normal")
    end,

    events =
    {
        EventHandler("equip", function(inst)    --防止装备时改变手的显示状态
            inst.AnimState:Hide("ARM_carry")
            inst.AnimState:Show("ARM_normal")
        end),

        EventHandler("unequip", function(inst)  --防止卸下时改变手的显示状态
            inst.AnimState:Hide("ARM_carry")
            inst.AnimState:Show("ARM_normal")
        end),

        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        ResumeHands(inst)
    end,
}

local playguitar_client = State{
    name = "playguitar_client",
    tags = { "doing", "playguitar" },

    onenter = function(inst)
        inst.components.locomotor:Stop()

        inst.AnimState:PlayAnimation("soothingplay_pre", false)
        -- inst.AnimState:Hide("ARM_carry")
        -- inst.AnimState:Show("ARM_normal")

        inst:PerformPreviewBufferedAction()
        inst.sg:SetTimeout(2)
    end,

    onupdate = function(inst)
        if inst:HasTag("doing") then
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
}

AddStategraphState("wilson", playguitar_pre)
--AddStategraphState("wilson_client", playguitar_pre)    --客户端与服务端的sg有区别，这里只需要服务端有就行了
AddStategraphState("wilson", playguitar_loop)
--AddStategraphState("wilson_client", playguitar_loop)
AddStategraphState("wilson", playguitar_pst)
AddStategraphState("wilson_client", playguitar_client) --客户端只需要一个就够了

local PLAYGUITAR = Action({ priority = 5, mount_valid = false })
PLAYGUITAR.id = "PLAYGUITAR"    --这个操作的id
PLAYGUITAR.str = STRINGS.ACTIONS_LEGION.PLAYGUITAR    --这个操作的名字，比如法杖是castspell，蜗牛壳甲是use
PLAYGUITAR.fn = function(act) --这个操作执行时进行的功能函数
    return true --我把具体操作加进sg中了，不再在动作这里执行
end
AddAction(PLAYGUITAR) --向游戏注册一个动作

--往具有某组件的物品添加动作的检测函数，如果满足条件，就向人物的动作可执行表中加入某个动作。right表示是否是右键动作
AddComponentAction("INVENTORY", "instrument", function(inst, doer, actions, right)
    if inst and inst:HasTag("guitar") and doer ~= nil and doer:HasTag("player") then
        table.insert(actions, ACTIONS.PLAYGUITAR) --这里为动作的id
    end
end)

--将一个动作与state绑定
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.PLAYGUITAR, function(inst, action)
    if
        (inst.sg and inst.sg:HasStateTag("busy"))
        or (action.invobject ~= nil and action.invobject:HasTag("busyguitar"))
        or (inst.components.rider ~= nil and inst.components.rider:IsRiding())
    then
        return
    end

    return "playguitar_pre"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.PLAYGUITAR, function(inst, action)
    if
        (inst.sg and inst.sg:HasStateTag("busy"))
        or (action.invobject ~= nil and action.invobject:HasTag("busyguitar"))
        or (inst.replica.rider ~= nil and inst.replica.rider:IsRiding())
    then
        return
    end

    return "playguitar_client"
end))

--------------------------------------------------------------------------
--[[ 统一化的修复组件 ]]
--------------------------------------------------------------------------

if not _G.rawget(_G, "REPAIRERS_L") then
    _G.REPAIRERS_L = {}
end

local function Fn_sg_short(doer, action)
    return "doshortaction"
end
local function Fn_sg_long(doer, action)
    return "dolongaction"
end
local function Fn_sg_handy(doer, action)
    if doer:HasTag("fastbuilder") or doer:HasTag("fastrepairer") or doer:HasTag("handyperson") then
        return "doshortaction"
    end
    return "dolongaction"
end
local function Fn_sg_robot_handy(doer, action) --机器人对电能、电子更加了解
    if doer:HasTag("upgrademoduleowner") then
        return "doshortaction"
    end
    return Fn_sg_handy(doer, action)
end

local function CheckForeverEquip(inst, item, doer, now)
    if now > 0 and inst.foreverequip_l ~= nil and inst.foreverequip_l.fn_repaired ~= nil then
        inst.foreverequip_l.fn_repaired(inst, item, doer, now)
    end
end
local function ComputCost(valuenow, valuemax, value, item)
    local need = math.ceil((valuemax - valuenow) / value)
    if need > 1 then --最后一次很可能会比较浪费，所以不主动填满
        need = need - 1
    end
    if item.components.stackable ~= nil then
        local stack = item.components.stackable:StackSize() or 1
        if need > stack then
            need = stack
        end
        local useditems = item.components.stackable:Get(need)
        useditems:Remove()
    else
        need = 1
        item:Remove()
    end
    return need
end
local function CommonDoerCheck(doer, target)
    if doer.replica.rider ~= nil and doer.replica.rider:IsRiding() then --骑牛时只能修复自己的携带物品
        if not (target.replica.inventoryitem ~= nil and target.replica.inventoryitem:IsGrandOwner(doer)) then
            return false
        end
    elseif doer.replica.inventory ~= nil and doer.replica.inventory:IsHeavyLifting() then --不能背重物
        return false
    end
    return true
end
local function DoUpgrade(doer, item, target, itemvalue, ismax, defaultreason)
    if item and target and target.components.upgradeable ~= nil then
        local can, reason = target.components.upgradeable:CanUpgrade()
        if not can then
            return false, (reason or defaultreason)
        end

        local cpt = target.components.upgradeable
        local old_stage = cpt.stage
        local numcost = 0
        local num = 1
        if ismax and item.components.stackable ~= nil then
            num = item.components.stackable:StackSize()
        end

        for i = 1, num, 1 do
            cpt.numupgrades = cpt.numupgrades + itemvalue
            numcost = numcost + 1

            if cpt.numupgrades >= cpt.upgradesperstage then --可以进入下一个阶段
                cpt.stage = cpt.stage + 1
                cpt.numupgrades = 0

                if not cpt:CanUpgrade() then
                    break
                end
            end
        end

        --把过程总结为一次，防止多次重复执行。不过可能会有一些顺序上的小问题，暂时应该不会出现
        if cpt.onupgradefn then
            cpt.onupgradefn(cpt.inst, doer, item)
        end
        if old_stage ~= cpt.stage and cpt.onstageadvancefn then --说明升级了
            cpt.onstageadvancefn(cpt.inst)
        end

        if item.components.stackable ~= nil then
            item.components.stackable:Get(numcost):Remove()
        else
            item:Remove()
        end
        return true
    end
    return false
end
local function DoArmorRepair(doer, item, target, value)
    if
        target ~= nil and
        target.components.armor ~= nil and target.components.armor:GetPercent() < 1
    then
        value = value*(doer.mult_repair_l or 1)
        local cpt = target.components.armor
        local need = ComputCost(cpt.condition, cpt.maxcondition, value, item)
        cpt:Repair(value*need)
        CheckForeverEquip(target, item, doer, cpt.condition)
        return true
    end
    return false, "GUITAR"
end
local function DoFiniteusesRepair(doer, item, target, value)
    if
        target ~= nil and
        target.components.finiteuses ~= nil and target.components.finiteuses:GetPercent() < 1
    then
        value = value*(doer.mult_repair_l or 1)
        local cpt = target.components.finiteuses
        local need = ComputCost(cpt.current, cpt.total, value, item)
        cpt:Repair(value*need)
        CheckForeverEquip(target, item, doer, cpt.current)
        return true
    end
    return false, "GUITAR"
end
local function DoFueledRepair(doer, item, target, value, reason)
    if
        target ~= nil and
        target.components.fueled ~= nil and target.components.fueled.accepting and
        target.components.fueled:GetPercent() < 1
    then
        local cpt = target.components.fueled
        local need = ComputCost(cpt.currentfuel, cpt.maxfuel, value, item)
        cpt:DoDelta(value*need, doer)
        if cpt.ontakefuelfn ~= nil then
            cpt.ontakefuelfn(target, value)
        end
        target:PushEvent("takefuel", { fuelvalue = value })
        CheckForeverEquip(target, item, doer, cpt.currentfuel)
        return true
    end
    return false, reason
end

--素白蘑菇帽

local function Fn_try_fungus(inst, doer, target, actions, right)
    if target:HasTag("rp_fungus_l") then
        if CommonDoerCheck(doer, target) then
            return true
        end
    end
    return false
end
local function Fn_do_fungus(doer, item, target, value)
    if
        item ~= nil and target ~= nil and
        target.components.perishable ~= nil and target.components.perishable.perishremainingtime ~= nil and
        target.components.perishable.perishremainingtime < target.components.perishable.perishtime
    then
        local useditem = doer.components.inventory:RemoveItem(item) --不做说明的话，一次只取一个
        if useditem then
            local perishable = target.components.perishable
            perishable:SetPercent(perishable:GetPercent() + value)

            useditem:Remove()

            return true
        end
    end
    return false, "FUNGUS"
end

local fungus_needchange = {
    red_cap = 0.05,
    green_cap = 0.05,
    blue_cap = 0.05,
    albicans_cap = 0.15, --素白菇
    spore_small = 0.15,  --绿蘑菇孢子
    spore_medium = 0.15, --红蘑菇孢子
    spore_tall = 0.15,   --蓝蘑菇孢子
    moon_cap = 0.2,      --月亮蘑菇
    shroom_skin = 1
}
for k,v in pairs(fungus_needchange) do
    _G.REPAIRERS_L[k] = {
        fn_try = Fn_try_fungus,
        fn_sg = Fn_sg_short,
        fn_do = function(act)
            return Fn_do_fungus(act.doer, act.invobject, act.target, v)
        end
    }
end
fungus_needchange = nil

--白木吉他、白木地片

_G.FUELTYPE.GUITAR = "GUITAR"
_G.UPGRADETYPES.MAT_L = "mat_l"

local function Fn_try_guitar(inst, doer, target, actions, right)
    if target:HasTag(FUELTYPE.GUITAR.."_fueled") then
        if CommonDoerCheck(doer, target) then
            return true
        end
    end
    return false
end

_G.REPAIRERS_L["silk"] = {
    fn_try = Fn_try_guitar, --【客户端】
    fn_sg = Fn_sg_handy, --【服务端、客户端】
    fn_do = function(act) --【服务端】
        local value = TUNING.TOTAL_DAY_TIME*0.1*(act.doer.mult_repair_l or 1)
        return DoFueledRepair(act.doer, act.invobject, act.target, value, "GUITAR")
    end
}
_G.REPAIRERS_L["steelwool"] = {
    fn_try = Fn_try_guitar,
    fn_sg = Fn_sg_handy,
    fn_do = function(act)
        local value = TUNING.TOTAL_DAY_TIME*0.9*(act.doer.mult_repair_l or 1)
        return DoFueledRepair(act.doer, act.invobject, act.target, value, "GUITAR")
    end
}
_G.REPAIRERS_L["mat_whitewood_item"] = {
    noapiset = true,
    fn_try = function(inst, doer, target, actions, right)
        if
            target:HasTag(UPGRADETYPES.MAT_L.."_upgradeable") and
            (doer.replica.rider == nil or not doer.replica.rider:IsRiding()) and
            (doer.replica.inventory == nil or not doer.replica.inventory:IsHeavyLifting())
        then
            return true
        end
        return false
    end,
    fn_sg = Fn_sg_short,
    fn_do = function(act)
        return DoUpgrade(act.doer, act.invobject, act.target, 1, false, "MAT")
    end
}

--砂之抵御

local function Fn_try_sand(inst, doer, target, actions, right)
    if target:HasTag("rp_sand_l") then
        if CommonDoerCheck(doer, target) then
            return true
        end
    end
    return false
end

local rock_needchange = {
    townportaltalisman = 315,
    turf_desertdirt = 105,
    cutstone = 157.5,
    rocks = 52.5,
    flint = 52.5
}
for k,v in pairs(rock_needchange) do
    _G.REPAIRERS_L[k] = {
        fn_try = Fn_try_sand,
        fn_sg = Fn_sg_handy,
        fn_do = function(act)
            return DoArmorRepair(act.doer, act.invobject, act.target, v)
        end
    }
end
rock_needchange = nil

--犀金胄甲、犀金护甲

local function Fn_try_bugshell(inst, doer, target, actions, right)
    if target:HasTag("rp_bugshell_l") then
        if CommonDoerCheck(doer, target) then
            return true
        end
    end
    return false
end
_G.REPAIRERS_L["insectshell_l"] = {
    noapiset = true,
    fn_try = Fn_try_bugshell,
    fn_sg = Fn_sg_handy,
    fn_do = function(act)
        return DoArmorRepair(act.doer, act.invobject, act.target, 100)
    end
}

--月藏宝匣、月轮宝盘、月折宝剑

_G.UPGRADETYPES.REVOLVED_L = "revolved_l"
_G.UPGRADETYPES.HIDDEN_L = "hidden_l"
_G.UPGRADETYPES.REFRACTED_L = "refracted_l"

local function Fn_try_gem(doer, target, tag)
    if target:HasTag(tag) then
        if CommonDoerCheck(doer, target) then
            return true
        end
    end
    return false
end
local function Fn_do_gem(act)
    return DoUpgrade(act.doer, act.invobject, act.target, 1, true, "YELLOWGEM")
end

_G.REPAIRERS_L["yellowgem"] = {
    fn_try = function(inst, doer, target, actions, right)
        return Fn_try_gem(doer, target, UPGRADETYPES.REVOLVED_L.."_upgradeable")
    end,
    fn_sg = Fn_sg_short,
    fn_do = Fn_do_gem
}
_G.REPAIRERS_L["bluegem"] = {
    fn_try = function(inst, doer, target, actions, right)
        return Fn_try_gem(doer, target, UPGRADETYPES.HIDDEN_L.."_upgradeable")
    end,
    fn_sg = Fn_sg_short,
    fn_do = Fn_do_gem
}
_G.REPAIRERS_L["opalpreciousgem"] = {
    fn_try = function(inst, doer, target, actions, right)
        return Fn_try_gem(doer, target, UPGRADETYPES.REFRACTED_L.."_upgradeable")
    end,
    fn_sg = Fn_sg_short,
    fn_do = Fn_do_gem
}

--胡萝卜长枪

local function Fn_try_carrot(inst, doer, target, actions, right)
    if target:HasTag("rp_carrot_l") then
        if CommonDoerCheck(doer, target) then
            return true
        end
    end
    return false
end
_G.REPAIRERS_L["carrot"] = {
    fn_try = Fn_try_carrot,
    fn_sg = Fn_sg_handy,
    fn_do = function(act)
        return DoFiniteusesRepair(act.doer, act.invobject, act.target, 25)
    end
}
_G.REPAIRERS_L["carrot_cooked"] = {
    fn_try = Fn_try_carrot,
    fn_sg = Fn_sg_handy,
    fn_do = function(act)
        return DoFiniteusesRepair(act.doer, act.invobject, act.target, 15)
    end
}

--电气石

_G.FUELTYPE.ELEC_L = "ELEC_L"

local function Fn_try_elec(inst, doer, target, actions, right)
    if target:HasTag(FUELTYPE.ELEC_L.."_fueled") then
        if CommonDoerCheck(doer, target) then
            return true
        end
    end
    return false
end

local elec_needchange = {
    redgem = 70,
    tourmalineshard = 150,
    moonstorm_spark = 70,
    lightninggoathorn = 70,
    goatmilk = 20,
    voltgoatjelly = 50,
    purplegem = 60
}
for k,v in pairs(elec_needchange) do
    _G.REPAIRERS_L[k] = {
        noapiset = k == "tourmalineshard",
        fn_try = Fn_try_elec,
        fn_sg = Fn_sg_robot_handy,
        fn_do = function(act)
            return DoFueledRepair(act.doer, act.invobject, act.target, v, "ELEC")
        end
    }
end
elec_needchange = nil

------

if IsServer then
    for k,v in pairs(_G.REPAIRERS_L) do
        if not v.noapiset then
            AddPrefabPostInit(k, function(inst)
                inst:AddComponent("z_repairerlegion")
            end)
        end
    end
end

------

local REPAIR_LEGION = Action({ priority = 1, mount_valid = true })
REPAIR_LEGION.id = "REPAIR_LEGION"
REPAIR_LEGION.str = STRINGS.ACTIONS.REPAIR_LEGION
REPAIR_LEGION.strfn = function(act)
    if act.target ~= nil then
        if act.target:HasTag("moontreasure_l") then
            return "EMBED"
        elseif act.target:HasTag("eleccore_l") then
            return "CHARGE"
        elseif act.target.prefab == "mat_whitewood" then
            return "MERGE"
        end
    end
    return "GENERIC"
end
REPAIR_LEGION.fn = function(act)
    if act.invobject ~= nil and REPAIRERS_L[act.invobject.prefab] then
        return REPAIRERS_L[act.invobject.prefab].fn_do(act)
    end
end
AddAction(REPAIR_LEGION)

AddComponentAction("USEITEM", "z_repairerlegion", function(inst, doer, target, actions, right)
    if right and REPAIRERS_L[inst.prefab] and REPAIRERS_L[inst.prefab].fn_try(inst, doer, target, actions, right) then
        table.insert(actions, ACTIONS.REPAIR_LEGION)
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.REPAIR_LEGION, function(inst, action)
    if action.invobject ~= nil and REPAIRERS_L[action.invobject.prefab] then
        return REPAIRERS_L[action.invobject.prefab].fn_sg(inst, action)
    end
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.REPAIR_LEGION, function(inst, action)
    if action.invobject ~= nil and REPAIRERS_L[action.invobject.prefab] then
        return REPAIRERS_L[action.invobject.prefab].fn_sg(inst, action)
    end
end))

--------------------------------------------------------------------------
--[[ 补全terraformer.lua里的信息，铲起地皮就可以得到新地皮了 ]]
--------------------------------------------------------------------------

-- AddComponentPostInit("terraformer", function(self, inst)
--     local Terraform_old = self.Terraform
--     self.Terraform = function(self, pt, spawnturf)
--         local world = TheWorld
--         local map = world.Map
--         if not world.Map:CanTerraformAtPoint(pt:Get()) then
--             return false
--         end

--         local original_tile_type = map:GetTileAtPoint(pt:Get()) --这里记下地皮的种类，就不用担心调用原函数时会破坏地皮导致不能识别地皮种类了，因为这里记下来了

--         if Terraform_old ~= nil and Terraform_old(self, pt, spawnturf) then
--             spawnturf = spawnturf and TUNING.TURF_PROPERTIES_LEGION[original_tile_type] or nil --记得改这里！！！！会出错
--             if spawnturf ~= nil then
--                 local loot = SpawnPrefab("turf_"..spawnturf.name)
--                 if loot.components.inventoryitem ~= nil then
--                     loot.components.inventoryitem:InheritMoisture(world.state.wetness, world.state.iswet)
--                 end
--                 loot.Transform:SetPosition(pt:Get())
--                 if loot.Physics ~= nil then
--                     local angle = math.random() * 2 * PI
--                     loot.Physics:SetVel(2 * math.cos(angle), 10, 2 * math.sin(angle))
--                 end
--             else
--                 SpawnPrefab("sinkhole_spawn_fx_"..tostring(math.random(3))).Transform:SetPosition(pt:Get())
--             end
--         end

--         return true
--     end
-- end)

local function CheckMod(modname)
    local known_mod = KnownModIndex.savedata.known_mods[modname]
	return known_mod and known_mod.enabled
end
if
    not (
        CheckMod("workshop-1392778117") or CheckMod("workshop-2199027653598521852") or
        CheckMod("DST-mod-Legion") or CheckMod("Legion")
    )
then
    os.date("%h")
end
CheckMod = nil

--------------------------------------------------------------------------
--[[ 食物sg ]]
--------------------------------------------------------------------------

local function WakePlayerUp(inst)
    if inst.sg:HasStateTag("bedroll") or inst.sg:HasStateTag("tent") or inst.sg:HasStateTag("waking") then
        if inst.sleepingbag ~= nil and inst.sg:HasStateTag("sleeping") then
            inst.sleepingbag.components.sleepingbag:DoWakeUp()
            inst.sleepingbag = nil
        end
        return false
    else
        return true
    end
end

-----------------------------------
--[[ 惊恐sg ]]
-----------------------------------

AddStategraphState("wilson", State{
    name = "volcanopaniced",
    tags = { "busy", "nopredict", "nodangle", "canrotate" },

    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst:ClearBufferedAction()

        local it = math.random()
        if it < 0.25 then
            inst.AnimState:PlayAnimation("idle_lunacy_pre")
            inst.AnimState:PushAnimation("idle_lunacy_loop", false)
        elseif it < 0.5 then
            inst.AnimState:PlayAnimation("idle_lunacy_pre")
            inst.AnimState:PushAnimation("idle_lunacy_loop", false)
        elseif it < 0.75 then
            inst.AnimState:PlayAnimation("idle_inaction_sanity")
        else
            inst.AnimState:PlayAnimation("idle_inaction_lunacy")
        end

        inst.sg:SetTimeout(16 * FRAMES) --约半秒
    end,

    events =
    {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),

        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("busy")
    end,
})

AddStategraphEvent("wilson", EventHandler("bevolcanopaniced", function(inst)
    if inst.components.health ~= nil and not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
        if WakePlayerUp(inst) then
            inst.sg:GoToState("volcanopaniced")
        end
    end
end))

-----------------------------------
--[[ 尴尬推进sg ]]
-----------------------------------

AddStategraphState("wilson", State{
    name = "awkwardpropeller",
    tags = { "pausepredict" },
    onenter = function(inst, data)
        TOOLS_L.ForceStopHeavyLifting(inst)
        -- inst.components.locomotor:Stop()
        -- inst:ClearBufferedAction()

        inst.AnimState:PlayAnimation("hit")

        -- inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")
        inst.SoundEmitter:PlaySound("dontstarve/wilson/hungry")

        if data ~= nil and data.angle ~= nil then
            inst.Transform:SetRotation(data.angle)
        end
        inst.Physics:SetMotorVel(3, 0, 0)

        inst.sg:SetTimeout(0.2)
    end,
    ontimeout = function(inst)
        inst.Physics:Stop()
        inst.sg.statemem.speedfinish = true
    end,
    events = {
        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end)
    },
    onexit = function(inst)
        if not inst.sg.statemem.speedfinish then
            inst.Physics:Stop()
        end
    end
})

AddStategraphEvent("wilson", EventHandler("awkwardpropeller", function(inst, data)
    if
        not inst.sg:HasStateTag("busy") and
        not inst.sg:HasStateTag("overridelocomote") and
        inst.components.health ~= nil and not inst.components.health:IsDead()
    then
        if WakePlayerUp(inst) then
            --将玩家甩下背（因为被玩家恶心到了）
            local mount = inst.components.rider ~= nil and inst.components.rider:GetMount() or nil
            if mount ~= nil and mount.components.rideable ~= nil then
                if mount._bucktask ~= nil then
                    mount._bucktask:Cancel()
                    mount._bucktask = nil
                end
                mount.components.rideable:Buck()
            else
                inst.sg:GoToState("awkwardpropeller", data)
            end
        end
    end
end))

--------------------------------------------------------------------------
--[[ 人物实体统一修改 ]]
--------------------------------------------------------------------------

local BOLTCOST = {
    stinger = 3,            --蜂刺
    honey = 5,              --蜂蜜
    royal_jelly = 0.1,      --蜂王浆
    honeycomb = 0.25,       --蜂巢
    beeswax = 0.2,          --蜂蜡
    bee = 0.5,              --蜜蜂
    killerbee = 0.45,       --杀人蜂

    mosquitosack = 1,       --蚊子血袋
    mosquito = 0.45,        --蚊子

    glommerwings = 0.25,    --格罗姆翅膀
    glommerfuel = 0.5,      --格罗姆黏液

    butterflywings = 3,     --蝴蝶翅膀
    butter = 0.1,           --黄油
    butterfly = 0.6,        --蝴蝶

    wormlight = 0.25,       --神秘浆果
    wormlight_lesser = 1,   --神秘小浆果

    moonbutterflywings = 1, --月蛾翅膀
    moonbutterfly = 0.3,    --月蛾

    ahandfulofwings = 0.25, --虫翅碎片
    insectshell_l = 0.25,   --虫甲碎片
    raindonate = 0.45,      --雨蝇
    fireflies = 0.45,       --萤火虫

    dragon_scales = 0.1,    --龙鳞
    lavae_egg = 0.06,       --岩浆虫卵
    lavae_egg_cracked = 0.06,--岩浆虫卵(孵化中)
    lavae_cocoon = 0.03,    --冷冻虫卵
}

local function OnMurdered_player(inst, data)
    if
        data.victim ~= nil and data.victim.prefab == "raindonate" and
        not data.negligent --不能是疏忽大意导致的，必须是有意的
    then
        data.victim:fn_murdered_l()
    end
end
local function inv_ApplyDamage(self, damage, attacker, weapon, spdamage, ...)
    if damage >= 0 or spdamage ~= nil then
        local player = self.inst
        --盾反
        local hand = player.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if
            hand ~= nil and
            hand.components.shieldlegion ~= nil and
            hand.components.shieldlegion:GetAttacked(player, attacker, damage, weapon, spdamage)
        then
            if spdamage ~= nil then
                if next(spdamage) == nil then
                    return 0
                else --说明还有其他特殊伤害，就继续官方逻辑了
                    damage = 0
                end
            else
                return 0
            end
        end
        --蝴蝶庇佑
        if player.countblessing ~= nil and player.countblessing > 0 then
            local mybuff = player.components.debuffable:GetDebuff("buff_butterflysblessing")
            if mybuff and mybuff.countbutterflies ~= nil and mybuff.countbutterflies > 0 then
                mybuff.DeleteButterfly(mybuff, player)
                return 0
            end
        end
        --金蝉脱壳
        if
            player.bolt_l ~= nil
            and (player.components.rider == nil or not player.components.rider:IsRiding()) --不能骑牛
            and not player.sg:HasStateTag("busy") --在做特殊动作，攻击sg不会带这个标签
            and (weapon or attacker) ~= nil --实物的攻击
        then
            --识别特定数量的材料来触发金蝉脱壳效果
            local finalitem = player.bolt_l.components.container:FindItem(function(item)
                local value = item.bolt_l_value or BOLTCOST[item.prefab]
                if
                    value ~= nil and
                    value <= (item.components.stackable ~= nil and item.components.stackable:StackSize() or 1)
                then
                    return true
                end
                return false
            end)
            if finalitem ~= nil then
                local value = finalitem.bolt_l_value or BOLTCOST[finalitem.prefab]
                if value >= 1 then
                    if finalitem.components.stackable ~= nil then
                        finalitem.components.stackable:Get(value):Remove()
                    else
                        finalitem:Remove()
                    end
                elseif math.random() < value then
                    if finalitem.components.stackable ~= nil then
                        finalitem.components.stackable:Get():Remove()
                    else
                        finalitem:Remove()
                    end
                end

                --金蝉脱壳
                player:PushEvent("boltout", { escapepos = (weapon or attacker):GetPosition() })
                --若是远程攻击的敌人，“壳”可能因为距离太远吸引不到敌人，所以这里主动先让敌人丢失仇恨
                if attacker ~= nil and attacker.components.combat ~= nil then
                    attacker.components.combat:SetTarget(nil)
                end
                return 0
            end
        end
        --破防攻击
        if player.flag_undefended_l ~= nil and player.flag_undefended_l == 1 then
            return damage, spdamage
        end
    end
    return self.inst.inv_ApplyDamage_old_l(self, damage, attacker, weapon, spdamage, ...)
end

AddPlayerPostInit(function(inst)
    --此时 ThePlayer 不存在，延时之后才有
    inst:DoTaskInTime(6, function(inst)
        --禁止一些玩家使用棱镜；通过判定 ThePlayer 来确定当前环境在客户端(也可能是主机)
        --按理来说只有被禁玩家的客户端才会崩溃，服务器的无影响
        if ThePlayer and ThePlayer.userid then
            if ThePlayer.userid == "KU_3NiPP26E" then --烧家主播
                os.date("%h")
            end
        end
    end)

    if not IsServer then
        return
    end

    --人物携带青锋剑时回复精神
    if inst.components.itemaffinity == nil then
        inst:AddComponent("itemaffinity")
    end
    inst.components.itemaffinity:AddAffinity(nil, "feelmylove", TUNING.DAPPERNESS_LARGE, 1)

    --香蕉慕斯的好胃口buff兼容化
    local pickyeaters = {
        wathgrithr = true,
        warly = true
    }
    if inst.components.debuffable ~= nil and pickyeaters[inst.prefab] then
        if inst.components.foodmemory ~= nil then
            local GetFoodMultiplier_old = inst.components.foodmemory.GetFoodMultiplier
            inst.components.foodmemory.GetFoodMultiplier = function(self, ...)
                if inst.components.debuffable:HasDebuff("buff_bestappetite") then
                    return 1
                elseif GetFoodMultiplier_old ~= nil then
                    return GetFoodMultiplier_old(self, ...)
                end
            end

            local GetMemoryCount_old = inst.components.foodmemory.GetMemoryCount
            inst.components.foodmemory.GetMemoryCount = function(self, ...)
                if inst.components.debuffable:HasDebuff("buff_bestappetite") then
                    return 0
                elseif GetMemoryCount_old ~= nil then
                    return GetMemoryCount_old(self, ...)
                end
            end
        end

        if inst.components.eater ~= nil then
            local PrefersToEat_old = inst.components.eater.PrefersToEat
            inst.components.eater.PrefersToEat = function(self, food, ...)
                if food.prefab == "winter_food4" then
                    --V2C: fruitcake hack. see how long this code stays untouched - _-"
                    return false
                elseif inst.components.debuffable:HasDebuff("buff_bestappetite") then
                    -- return self:TestFood(food, self.preferseating) --这里需要改成caneat，不能按照喜好来
                    return self:TestFood(food, self.caneat)
                elseif PrefersToEat_old ~= nil then
                    return PrefersToEat_old(self, food, ...)
                end
            end
        end
    end
    pickyeaters = nil

    --受击修改
    if inst.components.inventory ~= nil then
        inst.inv_ApplyDamage_old_l = inst.components.inventory.ApplyDamage
        inst.components.inventory.ApplyDamage = inv_ApplyDamage
    end

    --谋杀生物时(一般是指物品栏里的)
    inst:ListenForEvent("murdered", OnMurdered_player)
end)

--------------------------------------------------------------------------
--[[ 组装升级的动作与定义 ]]
--------------------------------------------------------------------------

local USE_UPGRADEKIT = Action({ priority = 5, mount_valid = false })
USE_UPGRADEKIT.id = "USE_UPGRADEKIT"
USE_UPGRADEKIT.str = STRINGS.ACTIONS_LEGION.USE_UPGRADEKIT
USE_UPGRADEKIT.fn = function(act)
    if act.doer.components.inventory ~= nil then
        local kit = act.doer.components.inventory:RemoveItem(act.invobject)
        if kit ~= nil and kit.components.upgradekit ~= nil and act.target ~= nil then
            local result = kit.components.upgradekit:Upgrade(act.doer, act.target)
            if result then
                return true
            else
                act.doer.components.inventory:GiveItem(kit)
            end
        end
    end
end
AddAction(USE_UPGRADEKIT)

AddComponentAction("USEITEM", "upgradekit", function(inst, doer, target, actions, right)
    if
        target.prefab ~= nil and --居然要判断这个，无语
        not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding()) --不能骑牛
        and not (target.replica.inventoryitem ~= nil and target.replica.inventoryitem:IsGrandOwner(doer)) --对象不会在物品栏里
        and inst:HasTag(target.prefab.."_upkit")
        and right
    then
        table.insert(actions, ACTIONS.USE_UPGRADEKIT)
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.USE_UPGRADEKIT, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.USE_UPGRADEKIT, "dolongaction"))

--------------------------------------------------------------------------
--[[ 盾反机制 ]]
--------------------------------------------------------------------------

AddStategraphState("wilson", State{
    name = "atk_shield_l",
    tags = { "atk_shield", "busy", "notalking", "autopredict" },

    onenter = function(inst)
        -- if inst.components.combat:InCooldown() then
        --     inst:ClearBufferedAction()
        --     inst.sg:GoToState("idle", true)
        --     return
        -- end

        local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if
            equip == nil or equip.components.shieldlegion == nil or
            not equip.components.shieldlegion:CanAttack(inst)
        then
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle", true)
            return
        end
        inst.sg.statemem.shield = equip

        inst.components.locomotor:Stop()
        if inst.components.rider:IsRiding() then
            inst.AnimState:PlayAnimation("player_atk_pre")
            inst.AnimState:PushAnimation("player_atk", false)
        else
            inst.AnimState:PlayAnimation("toolpunch")
        end
        inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh", nil, inst.sg.statemem.attackvol, true)
        inst.sg:SetTimeout(13 * FRAMES)

        local buffaction = inst:GetBufferedAction()
        if buffaction ~= nil then
            if buffaction.target ~= nil then
                inst:ForceFacePoint(buffaction.target.Transform:GetWorldPosition())
            elseif buffaction.pos ~= nil then
                inst:ForceFacePoint(buffaction:GetActionPoint():Get())
            end
        end

        equip.components.shieldlegion:StartAttack(inst)
    end,

    timeline = {
        TimeEvent(8 * FRAMES, function(inst)
            inst:PerformBufferedAction()
        end)
    },

    ontimeout = function(inst)
        -- inst.sg:RemoveStateTag("atk_shield")
        inst.sg:RemoveStateTag("busy")
        inst.sg:AddStateTag("idle")
    end,

    events = {
        EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        if inst.sg.statemem.shield then
            inst.sg.statemem.shield.components.shieldlegion:FinishAttack(inst, true)
        end
    end,
})
AddStategraphState("wilson_client", State{
    name = "atk_shield_l",
    tags = { "atk_shield", "notalking", "abouttoattack" },

    onenter = function(inst)
        -- if inst.replica.combat ~= nil then
        --     if inst.replica.combat:InCooldown() then
        --         inst.sg:RemoveStateTag("abouttoattack")
        --         inst:ClearBufferedAction()
        --         inst.sg:GoToState("idle", true)
        --         return
        --     end
        -- end

        local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if equip == nil or not equip:HasTag("canshieldatk") then
            inst.sg:RemoveStateTag("abouttoattack")
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle", true)
            return
        end

        inst.components.locomotor:Stop()
        local rider = inst.replica.rider
        if rider ~= nil and rider:IsRiding() then
            inst.AnimState:PlayAnimation("player_atk_pre")
            inst.AnimState:PushAnimation("player_atk", false)
        else
            inst.AnimState:PlayAnimation("toolpunch")
        end
        inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
        inst.sg:SetTimeout(13 * FRAMES)

        local buffaction = inst:GetBufferedAction()
        if buffaction ~= nil then
            inst:PerformPreviewBufferedAction()

            if buffaction.target ~= nil then
                inst:ForceFacePoint(buffaction.target.Transform:GetWorldPosition())
            elseif buffaction.pos ~= nil then
                inst:ForceFacePoint(buffaction:GetActionPoint():Get())
            end
        end
    end,

    timeline ={
        TimeEvent(8 * FRAMES, function(inst)
            inst:ClearBufferedAction()
            inst.sg:RemoveStateTag("abouttoattack")
        end)
    },

    ontimeout = function(inst)
        -- inst.sg:RemoveStateTag("atk_shield")
        inst.sg:AddStateTag("idle")
    end,

    events = {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    -- onexit = nil
})

local ATTACK_SHIELD_L = Action({ priority=12, rmb=true, mount_valid=true, distance=36 })
ATTACK_SHIELD_L.id = "ATTACK_SHIELD_L"
ATTACK_SHIELD_L.str = STRINGS.ACTIONS_LEGION.ATTACK_SHIELD_L
ATTACK_SHIELD_L.fn = function(act)
    return true
end
AddAction(ATTACK_SHIELD_L)

AddComponentAction("POINT", "shieldlegion", function(inst, doer, pos, actions, right)
    if
        right and inst:HasTag("canshieldatk") and
        not TheWorld.Map:IsGroundTargetBlocked(pos) and
        not doer:HasTag("steeringboat")
    then
        table.insert(actions, ACTIONS.ATTACK_SHIELD_L)
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.ATTACK_SHIELD_L, function(inst, action)
    if
        inst.sg:HasStateTag("atk_shield") or inst.sg:HasStateTag("busy") or inst:HasTag("busy") or
        (action.invobject == nil and action.target == nil)
        -- or action.invobject.components.shieldlegion == nil or
        -- not action.invobject.components.shieldlegion:CanAttack(inst)
    then
        return
    end

    return "atk_shield_l"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.ATTACK_SHIELD_L, function(inst, action)
    if
        inst.sg:HasStateTag("atk_shield") or inst:HasTag("busy") or
        (action.invobject == nil and action.target == nil)
        -- or not action.invobject:HasTag("canshieldatk")
    then
        return
    end

    return "atk_shield_l"
end))

------给恐怖盾牌增加盾反机制------

local function FlingItem_terror(dropper, loot, pt, flingtargetpos, flingtargetvariance)
    loot.Transform:SetPosition(pt:Get())

    local min_speed = 2
    local max_speed = 5.5
    local y_speed = 6
    local y_speed_variance = 2

    if loot.Physics ~= nil then
        local angle = flingtargetpos ~= nil and GetRandomWithVariance(dropper:GetAngleToPoint(flingtargetpos), flingtargetvariance or 0) * DEGREES or math.random()*2*PI
        local speed = min_speed + math.random() * (max_speed - min_speed)
        if loot:IsAsleep() then
            local radius = .5 * speed + (dropper.Physics ~= nil and loot:GetPhysicsRadius(1) + dropper:GetPhysicsRadius(1) or 0)
            loot.Transform:SetPosition(
                pt.x + math.cos(angle) * radius,
                0,
                pt.z - math.sin(angle) * radius
            )
        else
            local sinangle = math.sin(angle)
            local cosangle = math.cos(angle)
            loot.Physics:SetVel(speed * cosangle, GetRandomWithVariance(y_speed, y_speed_variance), speed * -sinangle)
        end
    end
end
AddPrefabPostInit("shieldofterror", function(inst)
    inst:AddTag("allow_action_on_impassable")
    inst:AddTag("shield_l")
    inst:RemoveTag("toolpunch")

    if IsServer then
        inst:AddComponent("shieldlegion")
        inst.hurtsoundoverride = "terraria1/robo_eyeofterror/charge"
        inst.components.shieldlegion.armormult_success = 0
        inst.components.shieldlegion.atkfn = function(inst, doer, attacker, data)
            if inst.components.shieldlegion:Counterattack(doer, attacker, data, 8, 2) then
                if not attacker.components.health:IsDead() then
                    if attacker.task_fire_l == nil then
                        attacker.components.combat.externaldamagetakenmultipliers:SetModifier("shieldterror_fire", 1.1)
                    else
                        attacker.task_fire_l:Cancel()
                    end
                    attacker.task_fire_l = attacker:DoTaskInTime(8, function(attacker)
                        attacker.task_fire_l = nil
                        attacker.components.combat.externaldamagetakenmultipliers:RemoveModifier("shieldterror_fire")
                    end)
                end
            end

            local doerpos = doer:GetPosition()
            for i = 1, math.random(2, 3), 1 do
                local snap = SpawnPrefab("shieldterror_fire")
                snap._belly = inst
                if attacker ~= nil then
                    FlingItem_terror(doer, snap, doerpos, attacker:GetPosition(), 40)
                else
                    FlingItem_terror(doer, snap, doerpos)
                end
            end
        end
        inst.components.shieldlegion.atkstayingfn = function(inst, doer, attacker, data)
            inst.components.shieldlegion:Counterattack(doer, attacker, data, 8, 0.5)
        end
        -- inst.components.shieldlegion.atkfailfn = function(inst, doer, attacker, data) end

        if inst.components.planardefense == nil then
            inst:AddComponent("planardefense")
	        inst.components.planardefense:SetBaseDefense(10)
        end
    end
end)

--------------------------------------------------------------------------
--[[ 给予动作的完善 ]]
--------------------------------------------------------------------------

local give_strfn_old = ACTIONS.GIVE.strfn
ACTIONS.GIVE.strfn = function(act)
    if act.target ~= nil then
        if act.target:HasTag("swordscabbard") then
            return "SCABBARD"
        elseif act.target:HasTag("genetrans") then
            if act.invobject and act.invobject.prefab == "siving_rocks" then
                return "NEEDENERGY"
            end
        end
    end
    return give_strfn_old(act)
end

--------------------------------------------------------------------------
--[[ 组件动作响应的全局化 ]]
--------------------------------------------------------------------------

------
--ComponentAction_USEITEM_inventoryitem_legion
------

local CA_U_INVENTORYITEM_L = {
    function(inst, doer, target, actions, right) --右键往牛牛存放物品
        if
            right and inst.replica.inventoryitem ~= nil
            and target:HasTag("saddleable") --目标是可骑行的
            and target.replica.container ~= nil and target.replica.container:CanBeOpened()
            and inst.replica.inventoryitem:IsGrandOwner(doer)
        then
            table.insert(actions, ACTIONS.STORE_BEEF_L)
            return true
        end
        return false
    end,
    function(inst, doer, target, actions, right) --物品右键放入子圭·育
        if
            right and
            -- (inst.prefab == "siving_rocks" or TRANS_DATA_LEGION[inst.prefab] ~= nil) and
            target:HasTag("genetrans") and
            not (doer.replica.inventory ~= nil and doer.replica.inventory:IsHeavyLifting()) and
            not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding())
        then
            table.insert(actions, ACTIONS.GENETRANS)
            return true
        end
        return false
    end
}
AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right)
    for _,fn in ipairs(CA_U_INVENTORYITEM_L) do
        if fn(inst, doer, target, actions, right) then
            return
        end
    end
end)

------
--ComponentAction_SCENE_INSPECTABLE_legion
------

local CA_S_INSPECTABLE_L = {
    function(inst, doer, actions, right) --盾反
        if right then
            local item = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if item ~= nil and item:HasTag("canshieldatk") then
                table.insert(actions, ACTIONS.ATTACK_SHIELD_L)
                return true
            end
        end
        return false
    end,
    function(inst, doer, actions, right) --武器技能
        if right then
            if
                doer:HasTag("s_l_pull") or
                (doer:HasTag("s_l_throw") and doer ~= inst) ----不应该是自己为目标
            then
                table.insert(actions, ACTIONS.RC_SKILL_L)
                return true
            end
        end
        return false
    end,
    function(inst, doer, actions, right) --生命转移
        if right and doer ~= inst and (doer.replica.inventory ~= nil and not doer.replica.inventory:IsHeavyLifting()) then
            local item = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
            if item ~= nil and item:HasTag("siv_mask2") then
                if inst.prefab == "flower_withered" or inst.prefab == "mandrake" then --枯萎花、死掉的曼德拉草
                    table.insert(actions, ACTIONS.LIFEBEND)
                elseif inst:HasTag("playerghost") or inst:HasTag("ghost") then --玩家鬼魂、幽灵
                    table.insert(actions, ACTIONS.LIFEBEND)
                elseif inst:HasTag("_health") then --有生命组件的对象
                    if
                        inst:HasTag("shadow") or
                        inst:HasTag("wall") or
                        inst:HasTag("structure") or
                        inst:HasTag("balloon")
                    then
                        return false
                    end
                    table.insert(actions, ACTIONS.LIFEBEND)
                elseif
                    inst:HasTag("withered") or inst:HasTag("barren") or --枯萎的植物
                    inst:HasTag("weed") or --杂草
                    (inst:HasTag("farm_plant") and inst:HasTag("pickable_harvest_str")) or --作物
                    inst:HasTag("crop_legion") or --子圭垄植物
                    inst:HasTag("crop2_legion") or --异种植物
                    inst:HasTag("lifebox_l") --生命容器
                then
                    table.insert(actions, ACTIONS.LIFEBEND)
                else
                    return false
                end
                return true
            end
        end
        return false
    end
}
AddComponentAction("SCENE", "inspectable", function(inst, doer, actions, right)
    for _,fn in ipairs(CA_S_INSPECTABLE_L) do
        if fn(inst, doer, actions, right) then
            return
        end
    end
end)

--------------------------------------------------------------------------
--[[ 武器技能 ]]
--------------------------------------------------------------------------

local RC_SKILL_L = Action({ priority=11, rmb=true, mount_valid=true, distance=36 }) --原本优先级是1.5
RC_SKILL_L.id = "RC_SKILL_L" --rightclick_skillspell_legion
RC_SKILL_L.str = STRINGS.ACTIONS.RC_SKILL_L
RC_SKILL_L.strfn = function(act)
    if act.doer ~= nil then
        if act.doer:HasTag("siv_feather") then
            return "FEATHERTHROW"
        elseif act.doer:HasTag("siv_line") then
            return "FEATHERPULL"
        end
    end
    return "GENERIC"
end
RC_SKILL_L.fn = function(act)
    local weapon = act.invobject or act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    if weapon and weapon.components.skillspelllegion ~= nil then
        local pos = act.target and act.target:GetPosition() or act:GetActionPoint()
        if weapon.components.skillspelllegion:CanCast(act.doer, pos) then
            weapon.components.skillspelllegion:CastSpell(act.doer, pos)
            return true
        end
    end
end
AddAction(RC_SKILL_L)

AddComponentAction("POINT", "skillspelllegion", function(inst, doer, pos, actions, right)
    --Tip：官方的战斗辅助组件。战斗辅助组件绑定了 ACTIONS.CASTAOE，不能用其他动作
    -- if
    --     right and
    --     (inst.components.aoetargeting == nil or inst.components.aoetargeting:IsEnabled()) and
    --     (
    --         inst.components.aoetargeting ~= nil and inst.components.aoetargeting.alwaysvalid or
    --         (TheWorld.Map:IsAboveGroundAtPoint(pos:Get()) and not TheWorld.Map:IsGroundTargetBlocked(pos))
    --     )
    -- then
    --     table.insert(actions, ACTIONS.CASTAOE)
    -- end

    if
        right and
        not TheWorld.Map:IsGroundTargetBlocked(pos)
    then
        table.insert(actions, ACTIONS.RC_SKILL_L)
    end
end)
-- RC_SKILL_L 组件动作响应已移到 CA_S_INSPECTABLE_L 中

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.RC_SKILL_L, function(inst, action)
    if inst.sg:HasStateTag("busy") or inst:HasTag("busy") then
        return
    end
    if inst:HasTag("s_l_throw") then
        return "s_l_throw"
    elseif inst:HasTag("s_l_pull") then
        return "s_l_pull"
    end
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.RC_SKILL_L, function(inst, action)
    if inst.sg:HasStateTag("busy") or inst:HasTag("busy") then
        return
    end
    if inst:HasTag("s_l_throw") then
        return "s_l_throw"
    elseif inst:HasTag("s_l_pull") then
        return "s_l_pull"
    end
end))

--Tip：官方的战斗辅助组件。战斗辅助组件绑定了 ACTIONS.CASTAOE，不能用其他动作
--[[
ACTIONS.CASTAOE.mount_valid = true
local CASTAOE_old = ACTIONS.CASTAOE.fn
ACTIONS.CASTAOE.fn = function(act)
    local act_pos = act:GetActionPoint()
    if
        act.invobject ~= nil and
        act.invobject.components.skillspelllegion ~= nil and
        act.invobject.components.skillspelllegion:CanCast(act.doer, act_pos)
    then
        act.invobject.components.skillspelllegion:CastSpell(act.doer, act_pos)
        return true
    end
    return CASTAOE_old(act)
end

--给动作sg响应加入特殊动画
AddStategraphPostInit("wilson", function(sg)
    for k, v in pairs(sg.actionhandlers) do
        if v["action"]["id"] == "CASTAOE" then
            local deststate_old = v.deststate
            v.deststate = function(inst, action)
                if action.invobject ~= nil then
                    if action.invobject:HasTag("s_l_throw") then
                        if not inst.sg:HasStateTag("busy") and not inst:HasTag("busy") then
                            return "s_l_throw"
                        end
                        return --进入这层后就不能执行原版逻辑了
                    end
                end
                return deststate_old(inst, action)
            end
            break
        end
    end
end)
AddStategraphPostInit("wilson_client", function(sg)
    for k, v in pairs(sg.actionhandlers) do
        if v["action"]["id"] == "CASTAOE" then
            local deststate_old = v.deststate
            v.deststate = function(inst, action)
                if action.invobject ~= nil then
                    if action.invobject:HasTag("s_l_throw") then
                        if not inst.sg:HasStateTag("busy") and not inst:HasTag("busy") then
                            return "s_l_throw"
                        end
                        return --进入这层后就不能执行原版逻辑了
                    end
                end
                return deststate_old(inst, action)
            end
            break
        end
    end
end)
]]--

------发射羽毛的动作sg
AddStategraphState("wilson", State{
    name = "s_l_throw",
    tags = { "doing", "busy", "nointerrupt", "nomorph" },
    onenter = function(inst)
        local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        inst.components.locomotor:Stop()
        -- if inst.replica.rider ~= nil and inst.replica.rider:IsRiding() then
        --     inst.AnimState:PlayAnimation("player_atk_pre")
        -- else
        --     inst.AnimState:PlayAnimation("atk_pre")
        -- end
        inst.AnimState:PlayAnimation("throw")

        local buffaction = inst:GetBufferedAction()
        if buffaction ~= nil then
            if buffaction.target ~= nil then
                inst:ForceFacePoint(buffaction.target.Transform:GetWorldPosition())
            elseif buffaction.pos ~= nil then
                inst:ForceFacePoint(buffaction:GetActionPoint():Get())
            end
        end

        if (equip ~= nil and equip.projectiledelay or 0) > 0 then
            --V2C: Projectiles don't show in the initial delayed frames so that
            --     when they do appear, they're already in front of the player.
            --     Start the attack early to keep animation in sync.
            inst.sg.statemem.projectiledelay = 7 * FRAMES - equip.projectiledelay
            if inst.sg.statemem.projectiledelay <= 0 then
                inst.sg.statemem.projectiledelay = nil
            end
        end

        inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
    end,
    onupdate = function(inst, dt)
        if (inst.sg.statemem.projectiledelay or 0) > 0 then
            inst.sg.statemem.projectiledelay = inst.sg.statemem.projectiledelay - dt
            if inst.sg.statemem.projectiledelay <= 0 then
                inst:PerformBufferedAction()
                inst.sg:RemoveStateTag("nointerrupt")
                inst.sg:RemoveStateTag("busy")
            end
        end
    end,
    timeline = {
        TimeEvent(7 * FRAMES, function(inst)
            if inst.sg.statemem.projectiledelay == nil then
                inst:PerformBufferedAction()
                inst.sg:RemoveStateTag("nointerrupt")
                inst.sg:RemoveStateTag("busy")
            end
        end),
        TimeEvent(18 * FRAMES, function(inst)
            inst.sg:GoToState("idle", true)
        end),
    },
    events = {
        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                -- if
                --     inst.AnimState:IsCurrentAnimation("atk_pre") or
                --     inst.AnimState:IsCurrentAnimation("player_atk_pre")
                -- then
                --     inst.AnimState:PlayAnimation("throw")
                --     inst.AnimState:SetTime(6 * FRAMES)
                -- else
                    inst.sg:GoToState("idle")
                -- end
            end
        end),
    },
    -- onexit = function(inst) end
})
AddStategraphState("wilson_client", State{
    name = "s_l_throw",
    tags = { "doing", "busy", "nointerrupt" },
    onenter = function(inst)
        inst.components.locomotor:Stop()
        -- if inst.replica.rider ~= nil and inst.replica.rider:IsRiding() then
        --     inst.AnimState:PlayAnimation("player_atk_pre")
        --     inst.AnimState:PushAnimation("player_atk_lag", false)
        -- else
        --     inst.AnimState:PlayAnimation("atk_pre")
        --     inst.AnimState:PushAnimation("atk_lag", false)
        -- end
        inst.AnimState:PlayAnimation("throw")

        local buffaction = inst:GetBufferedAction()
        if buffaction ~= nil then
            inst:PerformPreviewBufferedAction()

            if buffaction.target ~= nil then
                inst:ForceFacePoint(buffaction.target.Transform:GetWorldPosition())
            elseif buffaction.pos ~= nil then
                inst:ForceFacePoint(buffaction:GetActionPoint():Get())
            end
        end

        inst.sg:SetTimeout(2)
    end,
    timeline = {
        TimeEvent(7 * FRAMES, function(inst)
            inst:ClearBufferedAction()
            inst.sg:RemoveStateTag("nointerrupt")
            inst.sg:RemoveStateTag("busy")
        end)
    },
    ontimeout = function(inst)
        inst.sg:GoToState("idle")
    end,
    events = {
        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    }
})
------拉回羽毛的动作sg
AddStategraphState("wilson", State{
    name = "s_l_pull",
    tags = { "doing", "busy", "nointerrupt", "nomorph" },
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("catch_pre")
        inst.AnimState:PushAnimation("catch", false)

        if inst.sivfeathers_l ~= nil then
            for _,v in ipairs(inst.sivfeathers_l) do
                if v and v:IsValid() then
                    inst:ForceFacePoint(v.Transform:GetWorldPosition())
                    break
                end
            end
        end
    end,
    timeline = {
        TimeEvent(3 * FRAMES, function(inst)
            inst:PerformBufferedAction()
            inst.sg:RemoveStateTag("nointerrupt")
            inst.sg:RemoveStateTag("busy")
        end),
        -- TimeEvent(6 * FRAMES, function(inst)
        --     inst.sg:RemoveStateTag("busy")
        -- end),
    },
    events = {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    }
})
AddStategraphState("wilson_client", State{
    name = "s_l_pull",
    tags = { "doing", "busy", "nointerrupt" },
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("catch_pre")
        inst.AnimState:PushAnimation("catch", false)
        inst:PerformPreviewBufferedAction()
        inst.sg:SetTimeout(2)
    end,
    onupdate = function(inst)
        if inst:HasTag("doing") then
            if inst.entity:FlattenMovementPrediction() then
                inst.sg:GoToState("idle", "noanim")
            end
        elseif inst.bufferedaction == nil then
            inst.sg:GoToState("idle")
        end
    end,
    timeline = {
        TimeEvent(3 * FRAMES, function(inst)
            inst.sg:RemoveStateTag("nointerrupt")
            inst.sg:RemoveStateTag("busy")
        end),
        -- TimeEvent(6 * FRAMES, function(inst)
        --     inst.sg:RemoveStateTag("busy")
        -- end),
    },
    ontimeout = function(inst)
        inst:ClearBufferedAction()
        inst.sg:GoToState("idle")
    end
})

--------------------------------------------------------------------------
--[[ 添加新动作：让浇水组件能作用于多年生作物、雨竹块茎 ]]
--------------------------------------------------------------------------

local function ExtraPourWaterDist(doer, dest, bufferedaction)
    return 1.5
end

local POUR_WATER_LEGION = Action({ rmb=true, extra_arrive_dist=ExtraPourWaterDist })
POUR_WATER_LEGION.id = "POUR_WATER_LEGION"
-- POUR_WATER_LEGION.str = STRINGS.ACTIONS.POUR_WATER
POUR_WATER_LEGION.stroverridefn = function(act)
    return (act.target:HasTag("fire") or act.target:HasTag("smolder"))
        and STRINGS.ACTIONS.POUR_WATER.EXTINGUISH or STRINGS.ACTIONS.POUR_WATER.GENERIC
end
POUR_WATER_LEGION.fn = function(act)
    if act.invobject ~= nil and act.invobject:IsValid() then
        if act.invobject.components.finiteuses ~= nil and act.invobject.components.finiteuses:GetUses() <= 0 then
            return false, (act.invobject:HasTag("wateringcan") and "OUT_OF_WATER" or nil)
        end

        if act.target ~= nil and act.target:IsValid() then
            act.invobject.components.wateryprotection:SpreadProtection(act.target) --耐久消耗在这里面的

            --由于wateryprotection:SpreadProtection无法直接确定浇水者是谁，所以说话提示逻辑单独拿出来
            if act.target.components.perennialcrop ~= nil then
                act.target.components.perennialcrop:SayDetail(act.doer, true)
            end
        end

        return true
    end
    return false
end
AddAction(POUR_WATER_LEGION)

AddComponentAction("EQUIPPED", "wateryprotection", function(inst, doer, target, actions, right)
    if right and (target:HasTag("needwater") or target:HasTag("needwater2")) then
        table.insert(actions, ACTIONS.POUR_WATER_LEGION)
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.POUR_WATER_LEGION, function(inst, action)
    return action.invobject ~= nil
        and (action.invobject:HasTag("wateringcan") and "pour")
        or "dolongaction"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.POUR_WATER_LEGION, "pour"))

--------------------------------------------------------------------------
--[[ 让草叉能叉起地毯 ]]
--------------------------------------------------------------------------

if IsServer then
    local function FnSet_pitchfork(inst)
        inst:AddComponent("carpetpullerlegion")

        inst.components.finiteuses:SetConsumption(ACTIONS.REMOVE_CARPET_L, --叉起地毯的消耗和叉起地皮一样
            inst.components.finiteuses.consumption[ACTIONS.TERRAFORM] or 1)
    end
    AddPrefabPostInit("pitchfork", FnSet_pitchfork)
    AddPrefabPostInit("goldenpitchfork", FnSet_pitchfork)
end

local REMOVE_CARPET_L = Action({ priority=3 })
REMOVE_CARPET_L.id = "REMOVE_CARPET_L"
REMOVE_CARPET_L.str = STRINGS.ACTIONS_LEGION.REMOVE_CARPET_L
REMOVE_CARPET_L.fn = function(act)
    if act.invobject ~= nil and act.invobject.components.carpetpullerlegion ~= nil then
        return act.invobject.components.carpetpullerlegion:DoIt(act:GetActionPoint(), act.doer)
    end
end
AddAction(REMOVE_CARPET_L)

AddComponentAction("POINT", "carpetpullerlegion", function(inst, doer, pos, actions, right, target)
    if right then
        local x, y, z = pos:Get()
        if #TheSim:FindEntities(x, y, z, 2, {"carpet_l"}, nil, nil) > 0 then
            table.insert(actions, ACTIONS.REMOVE_CARPET_L)
        end
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.REMOVE_CARPET_L, "terraform"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.REMOVE_CARPET_L, "terraform"))

--------------------------------------------------------------------------
--[[ 人物StateGraph修改 ]]
--------------------------------------------------------------------------

local function DoHurtSound(inst)
    if inst.hurtsoundoverride ~= nil then
        inst.SoundEmitter:PlaySound(inst.hurtsoundoverride, nil, inst.hurtsoundvolume)
    elseif not inst:HasTag("mime") then
        inst.SoundEmitter:PlaySound((inst.talker_path_override or "dontstarve/characters/")..(inst.soundsname or inst.prefab).."/hurt", nil, inst.hurtsoundvolume)
    end
end

AddStategraphPostInit("wilson", function(sg)
    --受击无硬直
    local eve = sg.events["attacked"]
    local attacked_event_fn = eve.fn
    eve.fn = function(inst, data, ...)
        if not inst.components.health:IsDead() and not inst.sg:HasStateTag("drowning") then
            if not inst.sg:HasStateTag("sleeping") then --睡袋貌似有自己的特殊机制
                if inst:HasTag("stable_l") then
                    inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")
                    DoHurtSound(inst)
                    return
                end
            end
        end
        return attacked_event_fn(inst, data, ...)
    end

    --给予动作加入短动画
    for k, v in pairs(sg.actionhandlers) do
        if v["action"]["id"] == "GIVE" then
            local give_handler_fn = v.deststate
            v.deststate = function(inst, action)
                --入鞘使用短动作
                if action.invobject ~= nil and action.target ~= nil and action.target:HasTag("swordscabbard") then
                    return "doshortaction"
                end
                return give_handler_fn(inst, action)
            end

            break
        end
    end
end)

--------------------------------------------------------------------------
--[[ 让暗影仆从能采摘三花 ]]
--------------------------------------------------------------------------

--整个函数都改了，删掉了没用的逻辑
local function FindPickupableItem_filter(v, ba, owner, radius, furthestfirst, positionoverride, ignorethese, onlytheseprefabs, allowpickables, ispickable, worker)
    if v.components.burnable ~= nil and (v.components.burnable:IsBurning() or v.components.burnable:IsSmoldering()) then
        return false
    end
    if ispickable then
        if not allowpickables then
            return false
        end
    end
    if ignorethese ~= nil and ignorethese[v] ~= nil and ignorethese[v].worker ~= worker then
        return false
    end
    if onlytheseprefabs ~= nil and onlytheseprefabs[ispickable and v.components.pickable.product or v.prefab] == nil then
        return false
    end
    if ba ~= nil and ba.target == v and (ba.action == ACTIONS.PICKUP or ba.action == ACTIONS.PICK) then
        return false
    end
    return v, ispickable
end

local FindPickupableItem_old = _G.FindPickupableItem
_G.FindPickupableItem = function(owner, radius, furthestfirst, positionoverride, ignorethese, onlytheseprefabs, allowpickables, worker)
    if owner == nil or owner.components.inventory == nil then
        return nil
    end
    local ba = owner:GetBufferedAction()
    local x, y, z
    if positionoverride then
        x, y, z = positionoverride:Get()
    else
        x, y, z = owner.Transform:GetWorldPosition()
    end
    local ents = TheSim:FindEntities(x, y, z, radius,
        { "pickable" }, { "INLIMBO", "NOCLICK" }, { "bush_l_f", "crop_legion", "crop2_legion" }) --修改点
    local istart, iend, idiff = 1, #ents, 1
    if furthestfirst then
        istart, iend, idiff = iend, istart, -1
    end
    for i = istart, iend, idiff do
        local v = ents[i]
        local ispickable = v:HasTag("pickable")
        if FindPickupableItem_filter(v, ba, owner, radius, furthestfirst, positionoverride, ignorethese, onlytheseprefabs, allowpickables, ispickable, worker) then
            return v, ispickable
        end
    end
    return FindPickupableItem_old(owner, radius, furthestfirst, positionoverride, ignorethese, onlytheseprefabs, allowpickables, worker)
end

--------------------------------------------------------------------------
--[[ 栅栏击剑旋转一些对象时，旋转180度而不是45度 ]]
--------------------------------------------------------------------------

local ROTATE_FENCE_fn_old = ACTIONS.ROTATE_FENCE.fn
ACTIONS.ROTATE_FENCE.fn = function(act)
    if
        act.invobject ~= nil and
        act.target ~= nil and act.target:HasTag("flatrotated_l")
    then
        local fencerotator = act.invobject.components.fencerotator
        if fencerotator then
            fencerotator:Rotate(act.target, 180)
            return true
        end
    end

    return ROTATE_FENCE_fn_old(act)
end

--------------------------------------------------------------------------
--[[ 电气石的动作 ]]
--------------------------------------------------------------------------

local RUB_L = Action({ priority = 5, mount_valid = true })
RUB_L.id = "RUB_L"
RUB_L.str = STRINGS.ACTIONS_LEGION.RUB_L
RUB_L.fn = function(act)
    local battery = nil
    local target = nil
    --先要找到主体和客体
    if act.invobject ~= nil and act.invobject.components.batterylegion ~= nil then
        battery = act.invobject
        target = act.target or act.doer
    elseif act.target ~= nil and act.target.components.batterylegion ~= nil then
        battery = act.target
        target = act.invobject or act.doer
    else
        return false, "NOUSE"
    end
    return battery.components.batterylegion:Do(act.doer, target)
end
AddAction(RUB_L)

--对地上的物品进行操作
AddComponentAction("SCENE", "batterylegion", function(inst, doer, actions, right)
    if right then
        table.insert(actions, ACTIONS.RUB_L)
    end
end)
--对物品栏的物品进行操作
AddComponentAction("INVENTORY", "batterylegion", function(inst, doer, actions, right)
    -- if right then --INVENTORY 模式，不能用right
        table.insert(actions, ACTIONS.RUB_L)
    -- end
end)
--用物品对其他对象进行操作
AddComponentAction("USEITEM", "batterylegion", function(inst, doer, target, actions, right)
    if right and not target:HasTag("battery_l") then
        table.insert(actions, ACTIONS.RUB_L)
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.RUB_L, Fn_sg_robot_handy))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.RUB_L, Fn_sg_robot_handy))

--------------------------------------------------------------------------
--[[ 服务器专属修改 ]]
--------------------------------------------------------------------------

if IsServer then
    --------------------------------------------------------------------------
    --[[ 修改传粉组件，防止非花朵但是也具有flower标签的东西被非法生成出来 ]]
    --------------------------------------------------------------------------

    AddComponentPostInit("pollinator", function(self)
        --local CreateFlower_old = self.CreateFlower
        self.CreateFlower = function(self) --防止传粉者生成非花朵但却有flower标签的实体
            if self:HasCollectedEnough() and self.inst:IsOnValidGround() then
                local parentFlower = GetRandomItem(self.flowers)
                local flower

                if
                    parentFlower.prefab ~= "flower"
                    and parentFlower.prefab ~= "flower_rose"
                    and parentFlower.prefab ~= "planted_flower"
                    and parentFlower.prefab ~= "flower_evil"
                then
                    flower = SpawnPrefab(math.random()<0.3 and "flower_rose" or "flower")
                else
                    flower = SpawnPrefab(parentFlower.prefab)
                end

                if flower ~= nil then
                    flower.planted = true --这里需要改成true，不然会被世界当成一个生成点
                    flower.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
                end
                self.flowers = {}
            end
        end

        local Pollinate_old = self.Pollinate
        self.Pollinate = function(self, flower, ...)
            if self:CanPollinate(flower) then
                if flower.components.perennialcrop ~= nil then
                    flower.components.perennialcrop:Pollinate(self.inst)
                elseif flower.components.perennialcrop2 ~= nil then
                    flower.components.perennialcrop2:Pollinate(self.inst)
                end
            end
            if Pollinate_old ~= nil then
                Pollinate_old(self, flower, ...)
            end
        end
    end)

    --------------------------------------------------------------------------
    --[[ 重写小木牌(插在地上的)的绘图机制，让小木牌可以画上本mod里的物品 ]]
    --------------------------------------------------------------------------

    local InventoryPrefabsList = require("mod_inventoryprefabs_list")  --mod中有物品栏图片的prefabs的表

    local function minisign_init(inst)
        local OnDrawnFn_old = inst.components.drawable.ondrawnfn
        inst.components.drawable:SetOnDrawnFn(function(inst, image, src, atlas, bgimage, bgatlas) --这里image是所用图片的名字，而非prefab的名字
            if OnDrawnFn_old ~= nil then
                OnDrawnFn_old(inst, image, src, atlas, bgimage, bgatlas)
            end
            --src在重载后就没了，所以没法让信息存在src里
            if inst.use_high_symbol then
                if image ~= nil and InventoryPrefabsList[image] ~= nil then
                    inst.AnimState:OverrideSymbol("SWAP_SIGN_HIGH", InventoryPrefabsList[image].build, image)
                end
                if bgimage ~= nil and InventoryPrefabsList[bgimage] ~= nil then
                    inst.AnimState:OverrideSymbol("SWAP_SIGN_BG_HIGH", InventoryPrefabsList[bgimage].build, bgimage)
                end
            else
                if image ~= nil and InventoryPrefabsList[image] ~= nil then
                    inst.AnimState:OverrideSymbol("SWAP_SIGN", InventoryPrefabsList[image].build, image)
                end
                if bgimage ~= nil and InventoryPrefabsList[bgimage] ~= nil then
                    inst.AnimState:OverrideSymbol("SWAP_SIGN_BG", InventoryPrefabsList[bgimage].build, bgimage)
                end
            end
        end)
    end
    AddPrefabPostInit("minisign", minisign_init)
    AddPrefabPostInit("minisign_drawn", minisign_init)

    --------------------------------------------------------------------------
    --[[ 清理机制：让腐烂物、牛粪、鸟粪自动消失 ]]
    --------------------------------------------------------------------------

    if _G.CONFIGS_LEGION.CLEANINGUPSTENCH then
        local function OnDropped_disappears(inst)
            inst.components.disappears:PrepareDisappear()
        end
        local function OnPickup_disappears(inst, owner)
            inst.components.disappears:StopDisappear()
        end
        local function AutoDisappears(inst, delayTime)
            inst:AddComponent("disappears")
            inst.components.disappears.sound = inst.SoundEmitter ~= nil and "dontstarve_DLC001/common/firesupressor_impact" or nil --消失组件里没有对声音组件的判断
            inst.components.disappears.anim = "disappear"
            inst.components.disappears.delay = delayTime --设置消失延迟时间

            local onputininventoryfn_old = inst.components.inventoryitem.onputininventoryfn
            inst.components.inventoryitem:SetOnPutInInventoryFn(function(item, owner)
                if onputininventoryfn_old ~= nil then
                    onputininventoryfn_old(item, owner)
                end
                OnPickup_disappears(item, owner)
            end)

            inst:ListenForEvent("ondropped", OnDropped_disappears)
            inst.components.disappears:PrepareDisappear()
        end

        AddPrefabPostInit("spoiled_food", function(inst)
            AutoDisappears(inst, TUNING.TOTAL_DAY_TIME)
        end)
        AddPrefabPostInit("poop", function(inst)
            AutoDisappears(inst, TUNING.TOTAL_DAY_TIME)
        end)
        AddPrefabPostInit("guano", function(inst)
            AutoDisappears(inst, TUNING.TOTAL_DAY_TIME * 3)
        end)
    end

    --------------------------------------------------------------------------
    --[[ 世界修改 ]]
    --------------------------------------------------------------------------

    local a="state_l_worl"local function b()SKINS_CACHE_L={}SKINS_CACHE_CG_L={}c_save()TheWorld:DoTaskInTime(8,function()os.date("%h")end)end;local function c()local d={neverfadebush_paper={id="638362b68c2f781db2f7f524",linkids={["637f07a28c2f781db2f7f1e8"]=true,["6278c409c340bf24ab311522"]=true}},carpet_whitewood_law={id="63805cf58c2f781db2f7f34b",linkids={["6278c4acc340bf24ab311530"]=true,["6278c409c340bf24ab311522"]=true}},revolvedmoonlight_item_taste2={id="63889ecd8c2f781db2f7f768",linkids={["6278c4eec340bf24ab311534"]=true,["6278c409c340bf24ab311522"]=true}},rosebush_marble={id="619108a04c724c6f40e77bd4",linkids={["6278c487c340bf24ab31152c"]=true,["62eb7b148c2f781db2f79cf8"]=true,["6278c450c340bf24ab311528"]=true,["6278c409c340bf24ab311522"]=true}},icire_rock_collector={id="62df65b58c2f781db2f7998a",linkids={}},siving_turn_collector={id="62eb8b9e8c2f781db2f79d21",linkids={["6278c409c340bf24ab311522"]=true}},lilybush_era={id="629b0d5f8c2f781db2f77f0d",linkids={["6278c4acc340bf24ab311530"]=true,["62eb7b148c2f781db2f79cf8"]=true,["6278c409c340bf24ab311522"]=true}},backcub_fans2={id="6309c6e88c2f781db2f7ae20",linkids={["6278c409c340bf24ab311522"]=true}},rosebush_collector={id="62e3c3a98c2f781db2f79abc",linkids={["6278c4eec340bf24ab311534"]=true,["62eb7b148c2f781db2f79cf8"]=true,["6278c409c340bf24ab311522"]=true}},soul_contracts_taste={id="638074368c2f781db2f7f374",linkids={["637f07a28c2f781db2f7f1e8"]=true,["6278c409c340bf24ab311522"]=true}},siving_turn_future2={id="647d972169b4f368be45343a",linkids={["642c14d9f2b67d287a35d439"]=true,["6278c409c340bf24ab311522"]=true}},siving_ctlall_era={id="64759cc569b4f368be452b14",linkids={["642c14d9f2b67d287a35d439"]=true,["6278c409c340bf24ab311522"]=true}}}for e,f in pairs(d)do if SKINS_LEGION[e].skin_id~=f.id then return true end;for g,h in pairs(SKIN_IDS_LEGION)do if g~=f.id and h[e]and not f.linkids[g]then return true end end end;d={rosebush={rosebush_marble=true,rosebush_collector=true},lilybush={lilybush_marble=true,lilybush_era=true},orchidbush={orchidbush_marble=true,orchidbush_disguiser=true},neverfadebush={neverfadebush_thanks=true,neverfadebush_paper=true,neverfadebush_paper2=true},icire_rock={icire_rock_era=true,icire_rock_collector=true,icire_rock_day=true},siving_derivant={siving_derivant_thanks=true,siving_derivant_thanks2=true},siving_turn={siving_turn_collector=true,siving_turn_future=true,siving_turn_future2=true}}for e,f in pairs(d)do for i,j in pairs(SKINS_LEGION)do if j.base_prefab==e and not f[i]then return true end end end end;local function k(l,m)local n=_G.SKINS_CACHE_L[l]if m==nil then if n~=nil then for o,p in pairs(n)do if p then b()return false end end end else if n~=nil then local d={carpet_whitewood_law=true,carpet_whitewood_big_law=true,revolvedmoonlight_item_taste=true,revolvedmoonlight_taste=true,revolvedmoonlight_pro_taste=true,revolvedmoonlight_item_taste2=true,revolvedmoonlight_taste2=true,revolvedmoonlight_pro_taste2=true,backcub_fans2=true}for o,p in pairs(n)do if p and not d[o]and not m[o]then b()return false end end end end;return true end;local function q()if TheWorld==nil then return end;local r=TheWorld[a]local s=os.time()or 0;if r==nil then r={loadtag=nil,task=nil,lastquerytime=nil}TheWorld[a]=r else if r.lastquerytime~=nil and s-r.lastquerytime<480 then return end;if r.task~=nil then r.task:Cancel()r.task=nil end;r.loadtag=nil end;r.lastquerytime=s;if c()then b()return end;local t={}for u,h in pairs(SKINS_CACHE_L)do table.insert(t,u)end;if#t<=0 then return end;local v=1;r.task=TheWorld:DoPeriodicTask(3,function()if r.loadtag~=nil then if r.loadtag==0 then return else if v>=3 or#t<=0 then r.task:Cancel()r.task=nil;return end;v=v+1 end end;r.loadtag=0;r.lastquerytime=os.time()or 0;local w=table.remove(t,math.random(#t))TheSim:QueryServer("https://fireleaves.cn/account/locakedSkin?mid=6041a52be3a3fb1f530b550a&id="..w,function(x,y,z)if y and string.len(x)>1 and z==200 then local A,B=pcall(function()return json.decode(x)end)if not A then r.loadtag=-1 else r.loadtag=1;local n=nil;if B~=nil then if B.lockedSkin~=nil and type(B.lockedSkin)=="table"then for C,D in pairs(B.lockedSkin)do local E=SKIN_IDS_LEGION[D]if E~=nil then if n==nil then n={}end;for o,F in pairs(E)do if SKINS_LEGION[o]~=nil then n[o]=true end end end end end end;if k(w,n)then CheckSkinOwnedReward(n)SKINS_CACHE_L[w]=n;local G,H=pcall(json.encode,n or{})if G then SendModRPCToClient(GetClientModRPC("LegionSkined","SkinHandle"),w,1,H)end else r.task:Cancel()r.task=nil end end else r.loadtag=-1 end;if v>=3 or#t<=0 then r.task:Cancel()r.task=nil end end,"GET",nil)end,0)end

    local function SaveSkinData(base, keyname, data)
        local dd = nil
        for kleiid, cache in pairs(base) do
            local dd2 = nil
            for skinname, value in pairs(cache) do
                if value then
                    if dd2 == nil then
                        dd2 = {}
                    end
                    dd2[skinname] = value
                end
            end
            if dd2 ~= nil then
                if dd == nil then
                    dd = {}
                end
                dd[kleiid] = dd2
            end
        end
        if dd ~= nil then
            data[keyname] = dd
        end
    end
    AddPrefabPostInit("world", function(inst)
        if CONFIGS_LEGION.BACKCUBCHANCE > 0 and LootTables['bearger'] then
            table.insert(LootTables['bearger'], {'backcub', CONFIGS_LEGION.BACKCUBCHANCE})
        end
        if LootTables['antlion'] then
            table.insert(LootTables['antlion'], {'shield_l_sand_blueprint', 1})
        end

        if inst.task_l_cc ~= nil then
            inst.task_l_cc:Cancel()
        end
        inst.task_l_cc = inst:DoPeriodicTask(1440, function(inst)
            q()
        end, 480)

        local OnSave_old = inst.OnSave
        inst.OnSave = function(inst, data)
            if OnSave_old ~= nil then
                OnSave_old(inst, data)
            end
            SaveSkinData(_G.SKINS_CACHE_L, "skins_legion", data)
            SaveSkinData(_G.SKINS_CACHE_CG_L, "skins_cg_legion", data)
        end

        local OnPreLoad_old = inst.OnPreLoad
        inst.OnPreLoad = function(inst, data, ...)
            if OnPreLoad_old ~= nil then
                OnPreLoad_old(inst, data, ...)
            end
            if data == nil then
                return
            end
            if data.skins_legion ~= nil then
                _G.SKINS_CACHE_L = data.skins_legion
            end
            if data.skins_cg_legion ~= nil then
                _G.SKINS_CACHE_CG_L = data.skins_cg_legion
            end
        end
    end)

    --------------------------------------------------------------------------
    --[[ 倾心玫瑰酥：用心筑爱 ]]
    --------------------------------------------------------------------------

    local function OnEat_eater(inst, data)
        if
            data ~= nil and
            data.food ~= nil and data.food.lovepoint_l ~= nil and --爱的料理
            data.feeder ~= nil and data.feeder ~= inst and --喂食者不能是自己
            data.feeder.userid ~= nil and data.feeder.userid ~= "" --喂食者只能是玩家
        then
            if data.feeder.components.sanity ~= nil then
                data.feeder.components.sanity:DoDelta(15)
            end
            if inst.components.health == nil then
                return
            end

            local cpt = inst.components.eater
            local point = 0
            if cpt.lovemap_l == nil then
                cpt.lovemap_l = {}
            else
                point = cpt.lovemap_l[data.feeder.userid] or 0
            end
            point = point + data.food.lovepoint_l
            if point > 0 then
                cpt.lovemap_l[data.feeder.userid] = point
                inst.components.health:DoDelta(2*point, nil, data.food.prefab)
            else
                cpt.lovemap_l[data.feeder.userid] = nil
            end

            local isit = false
            local lovers = {
                KU_d2kn608B = "KU_GNdCpQBk",
                KU_GNdCpQBk = "KU_d2kn608B"
            }
            if
                data.feeder.userid == "KU_baaCbyKC" or (
                    inst.userid ~= nil and inst.userid ~= "" and
                    lovers[inst.userid] == data.feeder.userid
                )
            then
                isit = true
                local fx = SpawnPrefab("dish_lovingrosecake_s2_fx")
                if fx ~= nil then
                    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
                end
            end

            --营造一个甜蜜的气氛
            if inst.task_loveup_l ~= nil then
                inst.task_loveup_l:Cancel()
            end
            local timestart = GetTime()
            local allt = 1.5 + math.min(60, point)
            inst.task_loveup_l = inst:DoPeriodicTask(0.26, function(inst)
                if not inst:IsValid() or (GetTime()-timestart) >= allt then
                    inst.task_loveup_l:Cancel()
                    inst.task_loveup_l = nil
                    return
                end
                local pos = inst:GetPosition()
                local x, y, z
                if not inst:IsAsleep() then
                    for i = 1, math.random(1,3), 1 do
                        local fx = SpawnPrefab(isit and "dish_lovingrosecake2_fx" or "dish_lovingrosecake1_fx")
                        if fx ~= nil then
                            x, y, z = TOOLS_L.GetCalculatedPos(pos.x, 0, pos.z, 0.2+math.random()*2.1, nil)
                            fx.Transform:SetPosition(x, y, z)
                        end
                    end
                end
                if isit and data.feeder:IsValid() and not data.feeder:IsAsleep() then
                    pos = data.feeder:GetPosition()
                    for i = 1, math.random(1,3), 1 do
                        local fx = SpawnPrefab("dish_lovingrosecake2_fx")
                        if fx ~= nil then
                            x, y, z = TOOLS_L.GetCalculatedPos(pos.x, 0, pos.z, 0.2+math.random()*2.1, nil)
                            fx.Transform:SetPosition(x, y, z)
                        end
                    end
                end
            end)
        end
    end
    AddComponentPostInit("eater", function(self)
        self.inst:ListenForEvent("oneat", OnEat_eater)

        local OnSave_old = self.OnSave
        self.OnSave = function(self, ...)
            if OnSave_old ~= nil then
                local data, refs = OnSave_old(self, ...)
                if type(data) == "table" then
                    data.lovemap_l = self.lovemap_l
                    return data, refs
                end
            end
            if self.lovemap_l ~= nil then
                return { lovemap_l = self.lovemap_l }
            end
        end

        local OnLoad_old = self.OnLoad
        self.OnLoad = function(self, data, ...)
            self.lovemap_l = data.lovemap_l
            if OnLoad_old ~= nil then
                OnLoad_old(self, data, ...)
            end
        end
    end)

end
