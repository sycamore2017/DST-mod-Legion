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

if CONFIGS_LEGION.FLOWERSPOWER or TUNING.LEGION_DESERTSECRET then --永不凋零、砂之抵御需要
    function GLOBAL.RebuildRedirectDamageFn(player) --重新构造combat的redirectdamagefn函数
        if player.components.combat ~= nil then
            --初始化
            if player.redirect_table == nil then
                player.redirect_table = {}
            end
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
            end
            --再重构combat的redirectdamagefn
            RebuildRedirectDamageFn(self.inst)
        end

        local ActualDismount_old = self.ActualDismount
        self.ActualDismount = function(self)
            local ex_mount = ActualDismount_old(self)
            if ex_mount ~= nil then
                --清除骑牛保护的旧函数
                if self.inst.components.combat ~= nil then
                    self.inst.redirect_table[ex_mount.prefab] = nil
                end
                --因为下牛时redirectdamagefn被还原，所以这里还要重新定义一遍
                RebuildRedirectDamageFn(self.inst)
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

if CONFIGS_LEGION.FLOWERSPOWER then --4种花丛、香包需要
    AddComponentPostInit("pollinator", function(self)
        --local CreateFlower_old = self.CreateFlower
        self.CreateFlower = function(self)
            if self:HasCollectedEnough() and self.inst:IsOnValidGround() then
                local parentFlower = GetRandomItem(self.flowers)
                local flower

                if parentFlower.prefab ~= "flower"
                    and parentFlower.prefab ~= "flower_rose"
                    and parentFlower.prefab ~= "planted_flower"
                    and parentFlower.prefab ~= "flower_evil" then
                    flower = SpawnPrefab("flower_rose") --非花朵的东西就改成玫瑰花
                else
                    flower = SpawnPrefab(parentFlower.prefab)
                end

                flower.planted = true   --这里需要改成true，不然会被世界当成一个生成点
                flower.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
                self.flowers = {}
            end
        end

        -- if CONFIGS_LEGION.LEGENDOFFALL then --传粉者能提高农作物的产量
        --     -- local Pollinate_old = self.Pollinate
        --     self.Pollinate = function(self, flower)
        --         if self:CanPollinate(flower) then
        --             table.insert(self.flowers, flower)
        --             self.target = nil

        --             if flower.components.crop ~= nil and flower.components.crop.numpollinated ~= nil then
        --                 flower.components.crop.numpollinated = flower.components.crop.numpollinated + 1
        --             end
        --         end
        --     end
        -- end
    end)
end

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
    if TheWorld.ismastersim then
        minisign_init(inst)
    end
end)
AddPrefabPostInit("minisign_drawn", function(inst)
    if TheWorld.ismastersim then
        minisign_init(inst)
    end
end)

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

    --------------------------------------------------------------------------
    --[[ 让蜘蛛丝和钢羊绒可以修复白木吉他 ]]
    --------------------------------------------------------------------------

    if TUNING.LEGION_DESERTSECRET then
        _G.FUELTYPE.GUITAR = "GUITAR"

        if IsServer then
            local guitar_needchange =
            {
                silk = TUNING.TOTAL_DAY_TIME * 0.1,
                steelwool = TUNING.TOTAL_DAY_TIME * 0.9, --由于钢羊绒已经有燃料组件，这个修改会导致它无法再作为燃料
            }

            for k,v in pairs(guitar_needchange) do
                AddPrefabPostInit(k, function(inst)
                    if inst.components.fuel == nil then
                        inst:AddComponent("fuel")
                    end
                    inst.components.fuel.fuelvalue = v
                    inst.components.fuel.fueltype = FUELTYPE.GUITAR
                end)
            end
        end
    end
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
--[[ 查找仅角色物品栏物品的通用函数，不包括其他容器 ]]
--------------------------------------------------------------------------

if TUNING.LEGION_FLASHANDCRUSH then --灵魂契约书需要
    _G.FINDITEMWITHOUTCONTAINER = function(inst, fn)
        local inventory = inst.components.inventory

        for k,v in pairs(inventory.itemslots) do
            if fn(v) then
                return v
            end
        end
        if inventory.activeitem and fn(inventory.activeitem) then
            return inventory.activeitem
        end
    end

    _G.FINDITEMSWITHOUTCONTAINER = function(inst, fn)
        local inventory = inst.components.inventory
        local items = {}

        for k,v in pairs(inventory.itemslots) do
            if fn(v) then
                table.insert(items, v)
            end
        end
        if inventory.activeitem and fn(inventory.activeitem) then
            table.insert(items, inventory.activeitem)
        end

        return items
    end
end

--------------------------------------------------------------------------
--[[ 增加惊恐sg ]]
--------------------------------------------------------------------------

if TUNING.LEGION_SUPERBCUISINE then
    local volcanopaniced = State{
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
    }

    AddStategraphState("wilson", volcanopaniced)

    AddStategraphEvent("wilson", EventHandler("bevolcanopaniced",
        function(inst)
            if inst.components.health ~= nil and not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
                if inst.sg:HasStateTag("bedroll") or inst.sg:HasStateTag("tent") or inst.sg:HasStateTag("waking") then
                    if inst.sleepingbag ~= nil and inst.sg:HasStateTag("sleeping") then
                        inst.sleepingbag.components.sleepingbag:DoWakeUp()
                        inst.sleepingbag = nil
                    end
                else
                    inst.sg:GoToState("volcanopaniced")
                end
            end
        end)
    )
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

                    monkey_king = true,
                    myth_yutu = true,
                    neza = true,
                    pigsy = true,
                    white_bone = true,
                    yangjian = true,
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
