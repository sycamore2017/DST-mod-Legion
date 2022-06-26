--这里的内容主要是兼容性修改，优化性修改，mod内容里的通用修改部分(比如都要修改某个组件时，我就会把改动内容单独移到这里来，不再单独修改)

local _G = GLOBAL
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

--[ 积雪监听(仅prefab定义时使用) ]--
_G.MakeSnowCovered_comm_legion = function(inst)
    inst.AnimState:OverrideSymbol("snow", "hiddenmoonlight", "emptysnow")

    --  1、为了注册积雪的贴图，需要提前在assets中添加：
    --      Asset("ANIM", "anim/hiddenmoonlight.zip")
    --  2、同时，动画制作中，需要添加“snow”的通道
end
_G.MakeSnowCovered_serv_legion = function(inst, delaytime, delayfn)
    local function OnSnowCoveredChagned(inst, covered)
        if TheWorld.state.issnowcovered then
            inst.AnimState:OverrideSymbol("snow", "hiddenmoonlight", "snow")
        else
            inst.AnimState:OverrideSymbol("snow", "hiddenmoonlight", "emptysnow")
        end
    end

    inst:WatchWorldState("issnowcovered", OnSnowCoveredChagned)
    inst:DoTaskInTime(delaytime, function()
		OnSnowCoveredChagned(inst)
        if delayfn ~= nil then delayfn(inst) end
	end)
end

--[ 光照监听(仅prefab定义时使用) ]--
_G.IsTooDarkToGrow_legion = function(inst)
	if TheWorld.state.isnight then
		local x, y, z = inst.Transform:GetWorldPosition()
		for i, v in ipairs(TheSim:FindEntities(x, 0, z, TUNING.DAYLIGHT_SEARCH_RANGE, { "daylight", "lightsource" })) do
			local lightrad = v.Light:GetCalculatedRadius() * .7
			if v:GetDistanceSqToPoint(x, y, z) < lightrad * lightrad then
				return false
			end
		end
		return true
	end
	return false
end

--[ 计算最终位置(仅prefab定义时使用) ]--
_G.GetCalculatedPos_legion = function(x, y, z, radius, theta)
    local rad = radius or math.random() * 3
    local the = theta or math.random() * 2 * PI
    return x + rad * math.cos(the), y, z - rad * math.sin(the)
end

--[ 垂直掉落一个物品(仅prefab定义时使用) ]--
local easing = require("easing")
_G.DropItem_legion = function(itemname, x, y, z, hitrange, hitdamage, fallingtime, fn_start, fn_doing, fn_end)
	local item = SpawnPrefab(itemname)
	if item ~= nil then
        if fallingtime == nil then fallingtime = 5 * FRAMES end

		item.Transform:SetPosition(x, y, z) --这里的y就得是下落前起始高度
		item.fallingpos = item:GetPosition()
		item.fallingpos.y = 0
		if item.components.inventoryitem ~= nil then
			item.components.inventoryitem.canbepickedup = false
		end

        if fn_start ~= nil then fn_start(item) end

		item.fallingtask = item:DoPeriodicTask(
            FRAMES,
            function(inst, startpos, starttime)
                local t = math.max(0, GetTime() - starttime)
                local pos = startpos + (inst.fallingpos - startpos) * easing.inOutQuad(t, 0, 1, fallingtime)
                if t < fallingtime and pos.y > 0 then
                    inst.Transform:SetPosition(pos:Get())
                    if fn_doing ~= nil then fn_doing(inst) end
                else
                    inst.Physics:Teleport(inst.fallingpos:Get())
                    inst.fallingtask:Cancel()
                    inst.fallingtask = nil
                    inst.fallingpos = nil
                    if inst.components.inventoryitem ~= nil then
                        inst.components.inventoryitem.canbepickedup = true
                    end

                    if hitrange ~= nil then
                        local someone = FindEntity(inst, hitrange,
                            function(target)
                                if target and target:IsValid() and
                                    target.components.combat ~= nil and
                                    target.components.health ~= nil and not target.components.health:IsDead()
                                then
                                    return true
                                end
                                return false
                            end,
                            {"_combat", "_health"}, {"NOCLICK", "FX", "shadow", "playerghost", "INLIMBO"}, nil
                        )
                        if someone ~= nil then
                            someone.components.combat:GetAttacked(inst, hitdamage, nil)
                        end
                    end

                    if fn_end ~= nil then fn_end(inst) end
                end
            end,
            0, item:GetPosition(), GetTime()
        )
    end
end

--[ sg：sg中卸下装备的重物 ]--
_G.ForceStopHeavyLifting_legion = function(inst)
    if inst.components.inventory:IsHeavyLifting() then
        inst.components.inventory:DropItem(
            inst.components.inventory:Unequip(EQUIPSLOTS.BODY),
            true,
            true
        )
    end
end

--------------------------------------------------------------------------
--[[ 清理机制：让腐烂物、牛粪、鸟粪自动消失 ]]
--------------------------------------------------------------------------

if TUNING.LEGION_CLEANINGUPSTENCH then
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
        if TheWorld.ismastersim then
            AutoDisappears(inst, TUNING.TOTAL_DAY_TIME)
        end
    end)

    AddPrefabPostInit("poop", function(inst)
        if TheWorld.ismastersim then
            AutoDisappears(inst, TUNING.TOTAL_DAY_TIME)
        end
    end)

    AddPrefabPostInit("guano", function(inst)
        if TheWorld.ismastersim then
            AutoDisappears(inst, TUNING.TOTAL_DAY_TIME * 3)
        end
    end)
end

--------------------------------------------------------------------------
--[[ 修改rider组件，重新构造combat的redirectdamagefn函数以适应更多元的机制 ]]
--------------------------------------------------------------------------

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

--------------------------------------------------------------------------
--[[ 修改playercontroller组件，防止既有手持装备组件和栽种组件的物品在栽种时会先自动装备在身上的问题 ]]
--------------------------------------------------------------------------

-- 666，官方居然把这里修复了，我就不用再改了，哈哈

-- if CONFIGS_LEGION.FLOWERSPOWER then --永不凋零需要
--     AddComponentPostInit("playercontroller", function(self)
--         local DoActionAutoEquip_old = self.DoActionAutoEquip
--         self.DoActionAutoEquip = function(self, buffaction)
--             if buffaction.invobject ~= nil and
--                 buffaction.invobject.replica.equippable ~= nil and
--                 buffaction.invobject.replica.equippable:EquipSlot() == EQUIPSLOTS.HANDS and
--                 buffaction.action == ACTIONS.DEPLOY then
--                 --do nothing
--             else
--                 DoActionAutoEquip_old(self, buffaction)
--             end
--         end
--     end)
-- end

--------------------------------------------------------------------------
--[[ 修改传粉组件，防止非花朵但是也具有flower标签的东西被非法生成出来 ]]
--------------------------------------------------------------------------

if CONFIGS_LEGION.FLOWERSPOWER or CONFIGS_LEGION.LEGENDOFFALL then --4种花丛、香包、丰饶传说需要
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
                    flower.planted = true   --这里需要改成true，不然会被世界当成一个生成点
                    flower.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
                    self.flowers = {}
                end
            end
        end

        if CONFIGS_LEGION.LEGENDOFFALL then --传粉者能给作物传粉
            local Pollinate_old = self.Pollinate
            self.Pollinate = function(self, flower)
                if self:CanPollinate(flower) then
                    if flower.components.perennialcrop ~= nil then
                        flower.components.perennialcrop:Pollinate(self.inst)
                    elseif flower.components.perennialcrop2 ~= nil then
                        flower.components.perennialcrop2:Pollinate(self.inst)
                    end
                end
                if Pollinate_old ~= nil then
                    Pollinate_old(self, flower)
                end
            end
        end
    end)
end

--------------------------------------------------------------------------
--[[ 重写小木牌(插在地上的)的绘图机制，让小木牌可以画上本mod里的物品 ]]
--------------------------------------------------------------------------

if IsServer then
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

    AddPrefabPostInit("minisign", function(inst)
        minisign_init(inst)
    end)
    AddPrefabPostInit("minisign_drawn", function(inst)
        minisign_init(inst)
    end)
end

--------------------------------------------------------------------------
--[[ 弹吉他相关 ]]
--------------------------------------------------------------------------

if TUNING.LEGION_FLASHANDCRUSH or TUNING.LEGION_DESERTSECRET then --米格尔吉他和白木吉他需要

    --------------------------------------------------------------------------
    --[[ 弹吉他sg与动作的触发 ]]
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
end

--------------------------------------------------------------------------
--[[ 统一化的修复组件 ]]
--------------------------------------------------------------------------

if TUNING.LEGION_FLASHANDCRUSH or TUNING.LEGION_DESERTSECRET then --素白蘑菇帽和白木吉他需要
    if not _G.rawget(_G, "REPAIRERS_L") then
        _G.REPAIRERS_L = {}
    end

    if TUNING.LEGION_FLASHANDCRUSH then
        local function Fn_try_fungus(inst, doer, target, actions, right)
            if doer.replica.rider ~= nil and doer.replica.rider:IsRiding() then --骑牛时只能修复自己的携带物品
                if not (target.replica.inventoryitem ~= nil and target.replica.inventoryitem:IsGrandOwner(doer)) then
                    return false
                end
            elseif doer.replica.inventory ~= nil and doer.replica.inventory:IsHeavyLifting() then --不能背重物
                return false
            end

            if target.repairable_l then
                return true
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
            shroom_skin = 1,
        }
        for k,v in pairs(fungus_needchange) do
            _G.REPAIRERS_L[k] = {
                fn_try = Fn_try_fungus,
                fn_sg = function(doer, action)
                    return "doshortaction"
                end,
                fn_do = function(act)
                    return Fn_do_fungus(act.doer, act.invobject, act.target, v)
                end,
            }
        end
        fungus_needchange = nil
    end

    if TUNING.LEGION_DESERTSECRET then
        _G.FUELTYPE.GUITAR = "GUITAR"
        _G.UPGRADETYPES.MAT_L = "mat_l"

        local function Fn_try_guitar(inst, doer, target, actions, right)
            if doer.replica.rider ~= nil and doer.replica.rider:IsRiding() then --骑牛时只能修复自己的携带物品
                if not (target.replica.inventoryitem ~= nil and target.replica.inventoryitem:IsGrandOwner(doer)) then
                    return false
                end
            elseif doer.replica.inventory ~= nil and doer.replica.inventory:IsHeavyLifting() then --不能背重物
                return false
            end

            if target:HasTag(FUELTYPE.GUITAR.."_fueled") then
                return true
            end

            return false
        end
        local function Fn_do_guitar(doer, item, target, value)
            if
                item ~= nil and target ~= nil and
                target.components.fueled ~= nil and target.components.fueled.accepting and
                target.components.fueled:GetPercent() < 1
            then
                local useditem = doer.components.inventory:RemoveItem(item) --不做说明的话，一次只取一个
                if useditem then
                    local fueled = target.components.fueled
                    fueled:DoDelta(value*fueled.bonusmult*(doer.mult_repairl or 1), doer)

                    if useditem.components.fuel ~= nil then
                        useditem.components.fuel:Taken(fueled.inst)
                    end
                    useditem:Remove()

                    if fueled.ontakefuelfn ~= nil then
                        fueled.ontakefuelfn(fueled.inst, value)
                    end
                    fueled.inst:PushEvent("takefuel", { fuelvalue = value })

                    return true
                end
            end
            return false, "GUITAR"
        end

        _G.REPAIRERS_L["silk"] = {
            fn_try = Fn_try_guitar, --【客户端】
            fn_sg = function(doer, action) --【服务端、客户端】
                return "dolongaction"
            end,
            fn_do = function(act) --【服务端】
                return Fn_do_guitar(act.doer, act.invobject, act.target, TUNING.TOTAL_DAY_TIME * 0.1)
            end,
        }
        _G.REPAIRERS_L["steelwool"] = {
            fn_try = Fn_try_guitar,
            fn_sg = function(doer, action)
                return "dolongaction"
            end,
            fn_do = function(act)
                return Fn_do_guitar(act.doer, act.invobject, act.target, TUNING.TOTAL_DAY_TIME * 0.9)
            end,
        }
        _G.REPAIRERS_L["mat_whitewood_item"] = {
            noapiset = true,
            fn_try = function(inst, doer, target, actions, right)
                if
                    (doer.replica.rider == nil or not doer.replica.rider:IsRiding()) and
                    (doer.replica.inventory == nil or not doer.replica.inventory:IsHeavyLifting()) and
                    target:HasTag(UPGRADETYPES.MAT_L.."_upgradeable")
                then
                    return true
                end
                return false
            end,
            fn_sg = function(doer, action) return "doshortaction" end,
            fn_do = function(act)
                if
                    act.invobject and act.target and
                    act.target.components.upgradeable and act.target.components.upgradeable:CanUpgrade()
                then
                    local upgradeable = act.target.components.upgradeable
                    upgradeable.numupgrades = upgradeable.numupgrades + 1

                    if act.invobject.components.stackable then
                        act.invobject.components.stackable:Get(1):Remove()
                    else
                        act.invobject:Remove()
                    end

                    if upgradeable.onupgradefn then
                        upgradeable.onupgradefn(upgradeable.inst, act.doer, act.invobject)
                    end
                    if upgradeable.numupgrades >= upgradeable.upgradesperstage then
                        upgradeable:AdvanceStage()
                    end
                    return true
                end
                return false, "MAT"
            end,
        }

        local function Fn_try_sand(inst, doer, target, actions, right)
            if not target:HasTag("repair_sand") then
                return false
            end

            if doer.replica.rider ~= nil and doer.replica.rider:IsRiding() then --骑牛时只能修复自己的携带物品
                if not (target.replica.inventoryitem ~= nil and target.replica.inventoryitem:IsGrandOwner(doer)) then
                    return false
                end
            elseif doer.replica.inventory ~= nil and doer.replica.inventory:IsHeavyLifting() then --不能背重物
                return false
            end

            return true
        end
        local function Fn_do_sand(doer, item, target, value)
            if
                target ~= nil and
                target.components.armor ~= nil and target.components.armor:GetPercent() < 1
            then
                value = value*(doer.mult_repairl or 1)
                local cpt = target.components.armor
                local need = math.ceil((cpt.maxcondition - cpt.condition) / value)
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
                cpt:Repair(value*need)
                return true
            end
            return false, "GUITAR"
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
                fn_sg = function(doer, action)
                    return "dolongaction"
                end,
                fn_do = function(act)
                    return Fn_do_sand(act.doer, act.invobject, act.target, v)
                end
            }
        end
        rock_needchange = nil
    end

    if IsServer then
        for k,v in pairs(REPAIRERS_L) do
            if not v.noapiset then
                AddPrefabPostInit(k, function(inst)
                    inst:AddComponent("repairerlegion")
                end)
            end
        end
    end

    ------

    local REPAIR_LEGION = Action({ priority = 1, mount_valid = true })
    REPAIR_LEGION.id = "REPAIR_LEGION"
    REPAIR_LEGION.str = STRINGS.ACTIONS.REPAIR_LEGION
    REPAIR_LEGION.strfn = function(act)
        if act.invobject ~= nil then
            if act.invobject.prefab == "mat_whitewood_item" then
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

    AddComponentAction("USEITEM", "repairerlegion", function(inst, doer, target, actions, right)
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
end

--------------------------------------------------------------------------
--[[ 补全terraformer.lua里的信息，铲起地皮就可以得到新地皮了 ]]
--------------------------------------------------------------------------

-- if TUNING.LEGION_DESERTSECRET then --砂砖地皮需要
--     AddComponentPostInit("terraformer", function(self, inst)
--         local Terraform_old = self.Terraform
--         self.Terraform = function(self, pt, spawnturf)
--             local world = TheWorld
--             local map = world.Map
--             if not world.Map:CanTerraformAtPoint(pt:Get()) then
--                 return false
--             end

--             local original_tile_type = map:GetTileAtPoint(pt:Get()) --这里记下地皮的种类，就不用担心调用原函数时会破坏地皮导致不能识别地皮种类了，因为这里记下来了

--             if Terraform_old ~= nil and Terraform_old(self, pt, spawnturf) then
--                 spawnturf = spawnturf and TUNING.TURF_PROPERTIES_LEGION[original_tile_type] or nil --记得改这里！！！！会出错
--                 if spawnturf ~= nil then
--                     local loot = SpawnPrefab("turf_"..spawnturf.name)
--                     if loot.components.inventoryitem ~= nil then
--                         loot.components.inventoryitem:InheritMoisture(world.state.wetness, world.state.iswet)
--                     end
--                     loot.Transform:SetPosition(pt:Get())
--                     if loot.Physics ~= nil then
--                         local angle = math.random() * 2 * PI
--                         loot.Physics:SetVel(2 * math.cos(angle), 10, 2 * math.sin(angle))
--                     end
--                 else
--                     SpawnPrefab("sinkhole_spawn_fx_"..tostring(math.random(3))).Transform:SetPosition(pt:Get())
--                 end
--             end

--             return true
--         end
--     end)
-- end

--------------------------------------------------------------------------
--[[ 全局：帽子相关贴图切换通用函数 ]]
--------------------------------------------------------------------------

_G.HAT_ONEQUIP_LEGION = function(inst, owner, buildname, foldername)
    owner.AnimState:OverrideSymbol("swap_hat", buildname, foldername)
    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAIR_HAT")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAT")
    end
end

_G.HAT_OPENTOP_ONEQUIP_LEGION = function(inst, owner, buildname, foldername)
    owner.AnimState:OverrideSymbol("swap_hat", buildname, foldername)
    owner.AnimState:Show("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    owner.AnimState:Show("HEAD")
    owner.AnimState:Hide("HEAD_HAT")
end

_G.HAT_ONUNEQUIP_LEGION = function(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_hat")
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAT")
    end
end

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

if TUNING.LEGION_SUPERBCUISINE then
    --------------------------------------------------------------------------
    --[[ 惊恐sg ]]
    --------------------------------------------------------------------------

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

    --------------------------------------------------------------------------
    --[[ 尴尬推进sg ]]
    --------------------------------------------------------------------------

    AddStategraphState("wilson", State{
        name = "awkwardpropeller",
        tags = { "pausepredict" },

        onenter = function(inst, data)
            _G.ForceStopHeavyLifting_legion(inst)
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

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if not inst.sg.statemem.speedfinish then
                inst.Physics:Stop()
            end
        end,
    })

    AddStategraphEvent("wilson", EventHandler("awkwardpropeller", function(inst, data)
        if not inst.sg:HasStateTag("busy") and inst.components.health ~= nil and not inst.components.health:IsDead() then
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
end

--------------------------------------------------------------------------
--[[ 人物实体统一修改 ]]
--------------------------------------------------------------------------

if CONFIGS_LEGION.FLOWERSPOWER or TUNING.LEGION_SUPERBCUISINE then --青锋剑、香蕉慕斯需要
    if IsServer then
        AddPlayerPostInit(function(inst)
            --人物携带青锋剑时回复精神
            if CONFIGS_LEGION.FLOWERSPOWER then
                if inst.components.itemaffinity == nil then
                    inst:AddComponent("itemaffinity")
                end
                inst.components.itemaffinity:AddAffinity(nil, "feelmylove", TUNING.DAPPERNESS_LARGE, 1)
            end

            --香蕉慕斯的好胃口buff兼容化
            local isPickyEater = function(player)
                local notpickylist = { --这些是肯定不需要发挥香蕉慕斯作用的人物，所以就不需要做更改
                    walter = true,
                    waxwell = true,
                    webber = true,
                    wendy = true,
                    wes = true,
                    wickerbottom = true,
                    willow = true,
                    wilson = true,
                    winona = true,
                    wolfgang = true,
                    woodie = true,
                    wormwood = true,
                    wortox = true,
                    wurt = true,
                    wx78 = true,
                    wanda = true,

                    monkey_king = true,
                    myth_yutu = true,
                    neza = true,
                    pigsy = true,
                    white_bone = true,
                    yangjian = true,
                    yama_commissioners = true,
                }
                if notpickylist[player.prefab] then
                    return false
                end
                return true
            end
            if TUNING.LEGION_SUPERBCUISINE and inst.components.debuffable ~= nil and isPickyEater(inst) then
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
                            return self:TestFood(food, self.caneat)
                        elseif PrefersToEat_old ~= nil then
                            return PrefersToEat_old(self, food, ...)
                        end
                    end
                end
            end
            isPickyEater = nil
        end)
    end
end

--------------------------------------------------------------------------
--[[ 组装升级的动作与定义 ]]
--------------------------------------------------------------------------

if CONFIGS_LEGION.PRAYFORRAIN then --月藏宝匣需要
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
end

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
        inst.sg:RemoveStateTag("atk_shield")
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
        inst.sg:RemoveStateTag("atk_shield")
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
        local angle = flingtargetpos ~= nil and GetRandomWithVariance(dropper:GetAngleToPoint(flingtargetpos), flingtargetvariance or 0) * DEGREES or math.random() * 2 * PI
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
    inst:AddTag("combatredirect")   --代表这个武器会给予伤害对象重定义函数
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
                        attacker.task_fire_l = nil
                    end
                    attacker.task_fire_l = inst:DoTaskInTime(8, function(inst)
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

        local onequip_old = inst.components.equippable.onequipfn
        local onunequip_old = inst.components.equippable.onunequipfn
        inst.components.equippable.onequipfn = function(inst, owner, ...)
            onequip_old(inst, owner, ...)
            RebuildRedirectDamageFn(owner) --全局函数：重新构造combat的redirectdamagefn函数
            --登记远程保护的函数
            if owner.redirect_table[inst.prefab] == nil then
                owner.redirect_table[inst.prefab] = function(victim, attacker, damage, weapon, stimuli)
                    --只要这里不为nil，就能吸收所有远程伤害，反正武器没有health组件，所以在伤害计算时会直接被判断给取消掉
                    return inst.components.shieldlegion:GetAttacked(victim, attacker, damage, weapon, stimuli)
                end
            end
        end
        inst.components.equippable.onunequipfn = function(inst, owner, ...)
            onunequip_old(inst, owner, ...)
            --清除自己的redirectdamagefn函数
            if owner.redirect_table ~= nil then
                owner.redirect_table[inst.prefab] = nil
            end
        end
    end
end)

--------------------------------------------------------------------------
--[[ 世界修改 ]]
--------------------------------------------------------------------------

if IsServer then
    if GetModConfigData("BackCubChance") > 0 or TUNING.LEGION_DESERTSECRET then
        AddPrefabPostInit("world", function(inst)
            if GetModConfigData("BackCubChance") > 0 and LootTables['bearger'] then
                table.insert(LootTables['bearger'], {'backcub', GetModConfigData("BackCubChance")})
            end
            if TUNING.LEGION_DESERTSECRET and LootTables['antlion'] then
                table.insert(LootTables['antlion'], {'shield_l_sand_blueprint', 1})
            end
        end)
    end
end

--------------------------------------------------------------------------
--[[ 给予动作的完善 ]]
--------------------------------------------------------------------------

if CONFIGS_LEGION.FLOWERSPOWER or CONFIGS_LEGION.LEGENDOFFALL then
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
end

--------------------------------------------------------------------------
--[[ 组件动作响应的全局化 ]]
--------------------------------------------------------------------------

if TUNING.LEGION_FLASHANDCRUSH or CONFIGS_LEGION.LEGENDOFFALL then
    AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right)
        for _,fn in ipairs(CA_U_INVENTORYITEM_L) do
            if fn(inst, doer, target, actions, right) then
                return
            end
        end
    end)
end

_G.CA_S_INSPECTABLE_L = { --ComponentAction_SCENE_INSPECTABLE_legion
    function(inst, doer, actions, right)
        if right then
            local item = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if item ~= nil and item:HasTag("canshieldatk") then
                table.insert(actions, ACTIONS.ATTACK_SHIELD_L)
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

if CONFIGS_LEGION.LEGENDOFFALL then
    local RC_SKILL_L = Action({ priority=1.5, rmb=true, mount_valid=true, distance=36 })
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
    table.insert(_G.CA_S_INSPECTABLE_L, function(inst, doer, actions, right)
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
    end)

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
            inst.AnimState:PlayAnimation("atk_pre")

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
                    inst.sg:RemoveStateTag("nointerrupt")
                    inst:PerformBufferedAction()
                end
            end
        end,

        timeline = {
            TimeEvent(7 * FRAMES, function(inst)
                if inst.sg.statemem.projectiledelay == nil then
                    inst.sg:RemoveStateTag("nointerrupt")
                    inst:PerformBufferedAction()
                end
            end),
            TimeEvent(18 * FRAMES, function(inst)
                inst.sg:GoToState("idle", true)
            end),
        },

        events = {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    if inst.AnimState:IsCurrentAnimation("atk_pre") then
                        inst.AnimState:PlayAnimation("throw")
                        inst.AnimState:SetTime(6 * FRAMES)
                    else
                        inst.sg:GoToState("idle")
                    end
                end
            end),
        },

        -- onexit = function(inst) end,
    })
    AddStategraphState("wilson_client", State{
        name = "s_l_throw",
        tags = { "doing", "busy", "nointerrupt" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("atk_pre")
            inst.AnimState:PushAnimation("atk_lag", false)

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
                inst.sg:RemoveStateTag("nointerrupt")
                inst:PerformBufferedAction()
            end),
            TimeEvent(6 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("busy")
            end),
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

        ontimeout = function(inst)
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle")
        end,
    })
end
