local prefabFiles = {
    "siving_rocks_legion",
    "farm_plants_legion",
    "cropgnat",
    "ahandfulofwings",
    "boltwingout",
    "siving_managers",
    "fishhomingtools",
}

for k,v in pairs(prefabFiles) do
    table.insert(PrefabFiles, v)
end

-----

local assets = {
    Asset("ANIM", "anim/mushroom_farm_cutlichen_build.zip"), --洞穴苔藓的蘑菇农场贴图
    Asset("ANIM", "anim/mushroom_farm_foliage1_build.zip"), --蕨叶(森林)的蘑菇农场贴图
    Asset("ANIM", "anim/mushroom_farm_foliage2_build.zip"), --蕨叶(洞穴)的蘑菇农场贴图
    Asset("ANIM", "anim/farm_plant_pineananas.zip"),
    Asset("ANIM", "anim/player_actions_roll.zip"), --脱壳之翅所需动作（来自单机版）

    Asset("ATLAS", "images/inventoryimages/siving_soil_item.xml"), --预加载，给科技栏用的
    Asset("IMAGE", "images/inventoryimages/siving_soil_item.tex"),
    Asset("ATLAS", "images/inventoryimages/ahandfulofwings.xml"),
    Asset("IMAGE", "images/inventoryimages/ahandfulofwings.tex"),
    Asset("ATLAS", "images/inventoryimages/boltwingout.xml"),
    Asset("IMAGE", "images/inventoryimages/boltwingout.tex"),
    Asset("ATLAS", "images/inventoryimages/siving_rocks.xml"), --mod之间注册相同的文件是有效的
    Asset("IMAGE", "images/inventoryimages/siving_rocks.tex"),
    Asset("ATLAS", "images/inventoryimages/siving_ctlwater_item.xml"),
    Asset("IMAGE", "images/inventoryimages/siving_ctlwater_item.tex"),
    Asset("ATLAS", "images/inventoryimages/siving_ctldirt_item.xml"),
    Asset("IMAGE", "images/inventoryimages/siving_ctldirt_item.tex"),
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

AddIngredientValues({"pineananas"}, {veggie=1, fruit=1}, true, false)

_G.RegistMiniMapImage_legion("siving_derivant")
_G.RegistMiniMapImage_legion("siving_thetree")
_G.RegistMiniMapImage_legion("siving_ctlwater")
_G.RegistMiniMapImage_legion("siving_ctldirt")

AddRecipe2(
    "siving_soil_item", {
        Ingredient("siving_rocks", 6, "images/inventoryimages/siving_rocks.xml"),
        Ingredient("pinecone", 10),
    }, TECH.MAGIC_TWO, {
        atlas = "images/inventoryimages/siving_soil_item.xml", image = "siving_soil_item.tex"
    }, { "MAGIC", "GARDENING" }
)
AddRecipe2(
    "siving_ctlwater_item", {
        Ingredient("siving_rocks", 30, "images/inventoryimages/siving_rocks.xml"),
        Ingredient("greengem", 1),
        Ingredient("moonglass", 10),
    }, TECH.MAGIC_THREE, {
        atlas = "images/inventoryimages/siving_ctlwater_item.xml", image = "siving_ctlwater_item.tex"
    }, { "MAGIC", "GARDENING", "STRUCTURES" }
)
AddRecipe2(
    "siving_ctldirt_item", {
        Ingredient("siving_rocks", 30, "images/inventoryimages/siving_rocks.xml"),
        Ingredient("greengem", 1),
        Ingredient("townportaltalisman", 10),
    }, TECH.MAGIC_THREE, {
        atlas = "images/inventoryimages/siving_ctldirt_item.xml", image = "siving_ctldirt_item.tex"
    }, { "MAGIC", "GARDENING", "STRUCTURES" }
)
AddRecipe2(
    "boltwingout", {
        Ingredient("ahandfulofwings", 36, "images/inventoryimages/ahandfulofwings.xml"),
        Ingredient("glommerwings", 1),
        Ingredient("stinger", 36),
    }, TECH.SCIENCE_TWO, {
        atlas = "images/inventoryimages/boltwingout.xml", image = "boltwingout.tex"
    }, { "ARMOUR", "CONTAINERS" }
)

--这个配方用来便于绿宝石法杖分解
AddDeconstructRecipe("siving_soil", {
    Ingredient("siving_rocks", 6, "images/inventoryimages/siving_rocks.xml"),
    Ingredient("pinecone", 10)
})
AddDeconstructRecipe("siving_ctlwater", {
    Ingredient("siving_rocks", 30, "images/inventoryimages/siving_rocks.xml"),
    Ingredient("greengem", 1),
    Ingredient("moonglass", 10)
})
AddDeconstructRecipe("siving_ctldirt", {
    Ingredient("siving_rocks", 30, "images/inventoryimages/siving_rocks.xml"),
    Ingredient("greengem", 1),
    Ingredient("townportaltalisman", 10)
})

--------------------------------------------------------------------------
--[[ 让蘑菇农场能种植新东西 ]]
--------------------------------------------------------------------------

if IsServer then
    local newproducts = {
        cutlichen = { product = "cutlichen", produce = 4, },
        foliage = { product = "foliage", produce = 6, },
    }
    if TUNING.LEGION_FLASHANDCRUSH then
        newproducts["albicans_cap"] = { product = "albicans_cap", produce = 4, }
    end

    AddPrefabPostInit("mushroom_farm", function(inst)
        local AbleToAcceptTest_old = inst.components.trader.abletoaccepttest
        inst.components.trader:SetAbleToAcceptTest(function(farm, item, ...)
            if item ~= nil then
                if farm.remainingharvests == 0 then
                    if item.prefab == "shyerrylog" then
                        return true
                    end
                elseif newproducts[item.prefab] ~= nil then
                    return true
                end
            end
            return AbleToAcceptTest_old(farm, item, ...)
        end)

        local OnAccept_old = inst.components.trader.onaccept
        inst.components.trader.onaccept = function(farm, giver, item, ...)
            if farm.remainingharvests ~= 0 and newproducts[item.prefab] ~= nil then
                if farm.components.harvestable ~= nil then
                    local data = newproducts[item.prefab]
                    if item.prefab == "foliage" then
                        farm.AnimState:OverrideSymbol(
                            "swap_mushroom",
                            TheWorld:HasTag("cave") and "mushroom_farm_foliage2_build" or "mushroom_farm_foliage1_build",
                            "swap_mushroom"
                        )
                    else
                        farm.AnimState:OverrideSymbol("swap_mushroom", "mushroom_farm_"..data.product.."_build", "swap_mushroom")
                    end
                    farm.components.harvestable:SetProduct(data.product, data.produce)
                    farm.components.harvestable:SetGrowTime(TUNING.MUSHROOMFARM_FULL_GROW_TIME / data.produce)
                    farm.components.harvestable:Grow()

                    TheWorld:PushEvent("itemplanted", { doer = giver, pos = farm:GetPosition() }) --this event is pushed in other places too
                end
            else
                OnAccept_old(farm, giver, item, ...)
            end
        end

        local OnLoad_old = inst.OnLoad
        inst.OnLoad = function(farm, data)
            OnLoad_old(farm, data)
            if data ~= nil and not data.burnt and data.product ~= nil then
                for k,v in pairs(newproducts) do
                    if v.product == data.product then
                        if data.product == "foliage" then
                            farm.AnimState:OverrideSymbol(
                                "swap_mushroom",
                                TheWorld:HasTag("cave") and "mushroom_farm_foliage2_build" or "mushroom_farm_foliage1_build",
                                "swap_mushroom"
                            )
                        else
                            farm.AnimState:OverrideSymbol("swap_mushroom", "mushroom_farm_"..data.product.."_build", "swap_mushroom")
                        end
                        break
                    end
                end
            end
        end

    end)
end

--------------------------------------------------------------------------
--[[ 新增作物：松萝 ]]
--------------------------------------------------------------------------

--新增作物收获物与种子设定（只是为了种子几率，并不会主动生成prefab）
AddSimPostInit(function()
	if _G.VEGGIES ~= nil then
		_G.VEGGIES.pineananas = {
            health = 8,
            hunger = 12,
            sanity = -10,
            perishtime = TUNING.PERISH_MED,
            float_settings = {"small", 0.2, 0.9},

            cooked_health = 16,
            cooked_hunger = 18.5,
            cooked_sanity = 5,
            cooked_perishtime = TUNING.PERISH_SUPERFAST,
            cooked_float_settings = {"small", 0.2, 1},

            seed_weight = TUNING.SEED_CHANCE_RARE, --大概只有这里起作用了
            dryable = nil,
            halloweenmoonmutable_settings = nil,
            secondary_foodtype = nil,
            lure_data = nil,
        }
	end
end)

--新增作物植株设定（会自动生成对应prefab）
local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS
PLANT_DEFS.pineananas = {
    --贴图与动画
    build = "farm_plant_pineananas",
    bank = "farm_plant_pineananas",
    build_rotten = "farm_plant_pineananas",
    --生长时间
    grow_time = PLANT_DEFS.dragonfruit.grow_time,
    --需水量：低
    moisture = PLANT_DEFS.carrot.moisture,
    --喜好季节：夏、秋
    good_seasons = PLANT_DEFS.pepper.good_seasons,
    --需肥类型：{S, 0, S}
	nutrient_consumption = {TUNING.FARM_PLANT_CONSUME_NUTRIENT_LOW, 0, TUNING.FARM_PLANT_CONSUME_NUTRIENT_LOW},
	--会生成的肥料
	nutrient_restoration = {nil, true, nil},
    --扫兴容忍度：0
	max_killjoys_tolerance = TUNING.FARM_PLANT_KILLJOY_TOLERANCE,
    --是否随机种子
    is_randomseed = false,
    --是否防火
    fireproof = false,
    --重量范围
    weight_data	= {422.22, 700.22, 0.93},
    --音效
    sounds = PLANT_DEFS.pepper.sounds,
    --作物 代码名称
	prefab = "farm_plant_pineananas",
    --产物 代码名称
	product = "pineananas",
	--巨型产物 代码名称
	product_oversized = "pineananas_oversized",
	--种子 代码名称
	seed = "pineananas_seeds",
	--标签
	plant_type_tag = "farm_plant_pineananas",
    --巨型产物腐烂后的收获物
    loot_oversized_rot = {"spoiled_food", "spoiled_food", "spoiled_food", "pineananas_seeds", "fruitfly", "fruitfly", "pinecone"},
    --家族化所需数量：4
	family_min_count = TUNING.FARM_PLANT_SAME_FAMILY_MIN,
	--家族化检索距离：5
	family_check_dist = TUNING.FARM_PLANT_SAME_FAMILY_RADIUS + 1,
    --状态的net(如果你的植物状态超过了7个阶段 换别的net)
	stage_netvar = PLANT_DEFS.pepper.stage_netvar,
    --界面相关(官方支持mod使用自己的界面)
    plantregistrywidget = PLANT_DEFS.pepper.plantregistrywidget,
	plantregistrysummarywidget = PLANT_DEFS.pepper.plantregistrysummarywidget,
    --图鉴里玩家的庆祝动作
    pictureframeanim = PLANT_DEFS.pepper.pictureframeanim,
    --图鉴信息(hidden 表示这个阶段不显示)
    plantregistryinfo = PLANT_DEFS.pepper.plantregistryinfo,
}

--------------------------------------------------------------------------
--[[ 添加新动作：让种子能种在 子圭·垄 里 ]]
--------------------------------------------------------------------------

local WEIGHTED_SEED_TABLE = require("prefabs/weed_defs").weighted_seed_table

local function PickFarmPlant()
	if math.random() < TUNING.FARM_PLANT_RANDOMSEED_WEED_CHANCE then
		return weighted_random_choice(WEIGHTED_SEED_TABLE)
	else
		local weights = {}
		for k, v in pairs(VEGGIES) do
			weights[k] = v.seed_weight * (
                (PLANT_DEFS[k] and PLANT_DEFS[k].good_seasons[TheWorld.state.season]) and TUNING.SEED_WEIGHT_SEASON_MOD or 1
            )
		end

		return "farm_plant_"..weighted_random_choice(weights)
	end
    return "weed_forgetmelots"
end
local function OnPlant(seed, doer, soilorcrop)
    if seed.components.farmplantable ~= nil and seed.components.farmplantable.plant ~= nil then
        local pt = soilorcrop:GetPosition()

        local plant_prefab = FunctionOrValue(seed.components.farmplantable.plant, seed)
        if plant_prefab == "farm_plant_randomseed" then
            plant_prefab = PickFarmPlant()
        end

        local plant = SpawnPrefab(plant_prefab.."_legion")
        if plant ~= nil then
            plant.Transform:SetPosition(pt:Get())
            -- plant:PushEvent("on_planted", { doer = doer, seed = seed, in_soil = true })
            if plant.SoundEmitter ~= nil then
				plant.SoundEmitter:PlaySound("dontstarve/common/plant")
			end
            TheWorld:PushEvent("itemplanted", { doer = doer, pos = pt })

            --替换原本的作物
            if soilorcrop.components.perennialcrop ~= nil then
                plant.components.perennialcrop:DisplayCrop(soilorcrop, doer)
            end

            soilorcrop:Remove()
            seed:Remove()

            --寻找周围的管理器
            local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 20,
                { "siving_ctl" },
                { "NOCLICK", "FX", "INLIMBO" },
                nil
            )
            for _,v in pairs(ents) do
                if v:IsValid() and v.components.botanycontroller ~= nil then
                    plant.components.perennialcrop:TriggerController(v, true, true)
                end
            end

            return true
        end
    end
    return false
end

local PLANTSOIL_LEGION = Action({ theme_music = "farming" })
PLANTSOIL_LEGION.id = "PLANTSOIL_LEGION"
PLANTSOIL_LEGION.str = STRINGS.ACTIONS.PLANTSOIL_LEGION
PLANTSOIL_LEGION.strfn = function(act)
    if act.target ~= nil then
        if act.target:HasTag("crop_legion") then
            return "DISPLAY"
        end
    end
    return "GENERIC"
end
PLANTSOIL_LEGION.fn = function(act)
    if
        act.invobject ~= nil and
        act.doer.components.inventory ~= nil and
        act.target ~= nil and
        (act.target:HasTag("soil_legion") or act.target.components.perennialcrop ~= nil)
    then
        local seed = act.doer.components.inventory:RemoveItem(act.invobject)
        if seed ~= nil then
            if OnPlant(seed, act.doer, act.target) then
                return true
            end

            act.doer.components.inventory:GiveItem(seed)
        end
    end
end
AddAction(PLANTSOIL_LEGION)

AddComponentAction("USEITEM", "farmplantable", function(inst, doer, target, actions, right)
    if (target:HasTag("soil_legion") or target:HasTag("crop_legion")) and not target:HasTag("NOCLICK") then
        table.insert(actions, ACTIONS.PLANTSOIL_LEGION)
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.PLANTSOIL_LEGION, function(inst, action)
    if
        inst:HasTag("fastbuilder") or inst:HasTag("fastpicker")
        or ( --八戒要不饥饿时空手采摘才会加快
            inst:HasTag("pigsy")
            and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) == nil
            and inst.replica.hunger:GetCurrent() >= 50
        )
    then
        return "domediumaction"
    else
        return "dolongaction"
    end
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.PLANTSOIL_LEGION, function(inst, action)
    if
        inst:HasTag("fastbuilder") or inst:HasTag("fastpicker")
        or ( --八戒要不饥饿时空手采摘才会加快
            inst:HasTag("pigsy")
            and inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) == nil
            and inst.replica.hunger:GetCurrent() >= 50
        )
    then
        return "domediumaction"
    else
        return "dolongaction"
    end
end))

--------------------------------------------------------------------------
--[[ 施肥相关的多年生作物兼容 ]]
--------------------------------------------------------------------------

------施肥新动作
local FERTILIZE_LEGION = Action({ priority = 1 })
FERTILIZE_LEGION.id = "FERTILIZE_LEGION"
FERTILIZE_LEGION.str = STRINGS.ACTIONS.FERTILIZE
FERTILIZE_LEGION.fn = function(act)
    if
        act.invobject ~= nil and act.invobject.components.fertilizer ~= nil
        and act.target ~= nil and act.target.components.perennialcrop ~= nil
    then
        if act.target.components.perennialcrop:Fertilize(act.invobject, act.doer) then
            act.invobject.components.fertilizer:OnApplied(act.doer, act.target)
            act.target.components.perennialcrop:SayDetail(act.doer, true)
            return true
        else
            return false
        end
    end
end
AddAction(FERTILIZE_LEGION)

AddComponentAction("USEITEM", "fertilizer", function(inst, doer, target, actions, right)
    if
        (inst:HasTag("fert1") and target:HasTag("fertable1")) or
        (inst:HasTag("fert2") and target:HasTag("fertable2")) or
        (inst:HasTag("fert3") and target:HasTag("fertable3"))
    then
        table.insert(actions, ACTIONS.FERTILIZE_LEGION)
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.FERTILIZE_LEGION, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.FERTILIZE_LEGION, "doshortaction"))

------肥料组件兼容
if IsServer then
    AddComponentPostInit("fertilizer", function(self)
        local SetNutrients_old = self.SetNutrients
        self.SetNutrients = function(self, ...)
            SetNutrients_old(self, ...)
            local nutrients = self.nutrients
            if nutrients[1] ~= nil and nutrients[1] > 0 then
                self.inst:AddTag("fert1")
            end
            if nutrients[2] ~= nil and nutrients[2] > 0 then
                self.inst:AddTag("fert2")
            end
            if nutrients[3] ~= nil and nutrients[3] > 0 then
                self.inst:AddTag("fert3")
            end
        end
    end)
end

--------------------------------------------------------------------------
--[[ 照顾相关的与多年生作物兼容 ]]
--------------------------------------------------------------------------

if IsServer then
    ------让果蝇能取消多年生作物照顾
    local ATTACKPLANT_old = ACTIONS.ATTACKPLANT.fn
    ACTIONS.ATTACKPLANT.fn = function(act)
        if act.target ~= nil and act.target.components.perennialcrop ~= nil then
            return act.target.components.perennialcrop:TendTo(act.doer, false)
        end
        return ATTACKPLANT_old(act)
    end

    ------让 寻找作物照顾机制 能兼容多年生作物（两种果蝇、土地爷用到了）
    require "behaviours/findfarmplant"
    if FindFarmPlant then
        local function IsNearFollowPos(self, plant)
            local followpos = self.getfollowposfn(self.inst)
            local plantpos = plant:GetPosition()
            return distsq(followpos.x, followpos.z, plantpos.x, plantpos.z) < 400
        end

        local Visit_old = FindFarmPlant.Visit
        FindFarmPlant.Visit = function(self, ...)
            if self.status == READY then
                --找可照顾的多年生作物
                self.inst.planttarget = FindEntity(self.inst, 20, function(plant)
                    if
                        plant.components.perennialcrop ~= nil and
                        plant.components.perennialcrop:Tendable(self.inst, self.wantsstressed) and
                        IsNearFollowPos(self, plant) and
                        (self.validplantfn == nil or self.validplantfn(self.inst, plant))
                    then
                        return true
                    end
                end, { "crop_legion" }, nil)

                if self.inst.planttarget then
                    local action = BufferedAction(self.inst, self.inst.planttarget, self.action, nil, nil, nil, 0.1)
                    self.inst.components.locomotor:PushAction(action, self.shouldrun)
                    self.status = RUNNING
                end
            end
            if self.inst.planttarget and self.inst.planttarget.components.perennialcrop ~= nil then
                if self.status == RUNNING then
                    local plant = self.inst.planttarget
                    if
                        not plant:IsValid() or not IsNearFollowPos(self, plant) or
                        not plant.components.perennialcrop.tendable or
                        not (self.validplantfn == nil or self.validplantfn(self.inst, plant))
                    then
                        self.inst.planttarget = nil
                        self.status = FAILED
                    end

                    if not plant.components.perennialcrop:Tendable(self.inst, self.wantsstressed) then
                        self.inst.planttarget = nil
                        self.status = SUCCESS
                    end
                end
                return
            end
            Visit_old(self, ...)
        end

    end
end

--------------------------------------------------------------------------
--[[ 添加新动作：让浇水组件能作用于多年生作物 ]]
--------------------------------------------------------------------------

local POUR_WATER_LEGION = Action({})
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
    if right and target:HasTag("needwater") then
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
--[[ 脱壳之翅的sg ]]
--------------------------------------------------------------------------

AddStategraphState("wilson", State{
    name = "boltout",
    tags = { "busy", "doing", "nointerrupt", "canrotate" },

    onenter = function(inst, data)
        if data == nil or data.escapepos == nil then
            inst.sg:GoToState("idle", true)
            return
        end

        _G.ForceStopHeavyLifting_legion(inst) --虽然目前的触发条件并不可能有背着重物的情况，因为本身就是背包的功能，但是为了兼容性...
        inst.components.locomotor:Stop()
        inst:ClearBufferedAction()

        -- inst.components.inventory:Hide()    --物品栏与科技栏消失
        -- inst:PushEvent("ms_closepopups")    --关掉打开着的箱子、冰箱等
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:EnableMapControls(false)   --不能打开地图
            inst.components.playercontroller:Enable(false)  --玩家不能操控
            inst.components.playercontroller:RemotePausePrediction()
        end

        inst.AnimState:PlayAnimation("slide_pre")
        inst.AnimState:PushAnimation("slide_loop")
        inst.SoundEmitter:PlaySound("legion/common/slide_boltout")

        local x,y,z = inst.Transform:GetWorldPosition()
        if inst.bolt_skin_l ~= nil then
            SpawnPrefab(inst.bolt_skin_l.fx or "boltwingout_fx").Transform:SetPosition(x, y, z)
            local shuck = SpawnPrefab("boltwingout_shuck")
            if shuck ~= nil then
                if inst.bolt_skin_l.build ~= nil then
                    shuck.AnimState:SetBuild(inst.bolt_skin_l.build)
                end
                shuck.Transform:SetPosition(x, y, z)
            end
        else
            SpawnPrefab("boltwingout_fx").Transform:SetPosition(x, y, z)
            SpawnPrefab("boltwingout_shuck").Transform:SetPosition(x, y, z)
        end

        local angle = inst:GetAngleToPoint(data.escapepos) + 180 + 45 * (1 - 2 * math.random())
        if angle > 360 then
            angle = angle - 360
        end
        inst.Transform:SetRotation(angle)
        inst.Physics:SetMotorVel(20, 0, 0)
        -- inst.components.locomotor:EnableGroundSpeedMultiplier(false) --为了神话书说的腾云

        inst.sg:SetTimeout(0.3)
    end,

    onupdate = function(inst, dt) --每帧刷新加速度，不这样写的话，若玩家在进入该sg前在左右横跳会导致加速度停止
        inst.Physics:SetMotorVel(21, 0, 0)
    end,

    ontimeout = function(inst)
        inst.sg:GoToState("boltout_pst")
    end,

    onexit = function(inst)
        inst.Physics:Stop()
        -- inst.components.locomotor:EnableGroundSpeedMultiplier(true)

        -- inst.components.inventory:Show()
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:EnableMapControls(true)
            inst.components.playercontroller:Enable(true)
        end
    end,
})
AddStategraphState("wilson", State{
    name = "boltout_pst",
    -- tags = {"evade","no_stun"},

    onenter = function(inst)
        inst.AnimState:PlayAnimation("slide_pst")
    end,

    events =
    {
        EventHandler("animover", function(inst)
            inst.sg:GoToState("idle")
        end ),
    }
})

AddStategraphEvent("wilson", EventHandler("boltout", function(inst, data)
    if not inst.sg:HasStateTag("busy") and inst.components.health ~= nil and not inst.components.health:IsDead() then
        inst.sg:GoToState("boltout", data)
    end
end))

--------------------------------------------------------------------------
--[[ 打窝器中能加入的材料 ]]
--------------------------------------------------------------------------

if not _G.rawget(_G, "FISHHOMING_INGREDIENTS_L") then
    _G.FISHHOMING_INGREDIENTS_L = {}
end

local fishhoming_ingredients = {
    goldnugget =        { hardy = 1, lucky = 1, shiny = 1 }, --金锦鲤、花锦鲤
    lucky_goldnugget =  { hardy = 1, lucky = 1 },
    goldenaxe =         { hardy = 6, lucky = 6 },
    goldenpickaxe =     { hardy = 6, lucky = 6 },
    goldenshovel =      { hardy = 6, lucky = 6 },
    compass =           { hardy = 6, dusty = 6, lucky = 6 },
    bluegem =           { hardy = 1, frozen = 1 }, --冰鲷鱼
    bluemooneye =       { hardy = 6, frozen = 6 },
    slingshotammo_freeze={hardy = 2, frozen = 1 },
    purplegem =         { hardy = 2, frozen = 1, hot = 1 },
    icestaff =          { hardy = 6, frozen = 6 },
    blueamulet =        { hardy = 6, frozen = 6 },
    wx78module_cold =   { hardy = 6, frozen = 6 },
    fireflies =         { dusty = 1, hot = 1, shiny = 1, frizzy = 1 }, --炽热太阳鱼
    dragon_scales =     { hardy = 1, dusty = 1, hot = 10, evil = 10 },
    lavae_egg =         { hardy = 6, pasty = 6, hot = 6, frizzy = 6 },
    lavae_egg_cracked = { hardy = 6, pasty = 6, hot = 8, frizzy = 6 },
    lavae_cocoon =      { hardy = 6, pasty = 6, hot = 3, frizzy = 5 },
    redgem =            { hardy = 1, hot = 1 },
    firestaff =         { hardy = 6, hot = 6 },
    amulet =            { hardy = 6, hot = 6 },
    wx78module_heat =   { hardy = 6, hot = 6 },
    redmooneye =        { hardy = 6, hot = 6 },
    honey =             { pasty = 1, sticky = 1 }, --甜味鱼
    royal_jelly =       { pasty = 1, sticky = 6, shiny = 1 },
    honeycomb =         { pasty = 1, dusty = 1, sticky = 6 },
    beeswax =           { pasty = 1, hardy = 1, sticky = 1 },
    butter =            { pasty = 1, sticky = 6 },
    treegrowthsolution ={ pasty = 1, veggie = 1, sticky = 3, whispering = 2, shaking = 1 },
    fig =               { pasty = 1, veggie = 1, grassy = 1, shaking = 1 },
    fig_cooked =        { pasty = 1, veggie = 1, sticky = 2, shaking = 1 },
    glommerfuel =       { pasty = 1, sticky = 2, whispering = 2 }, --一角鲸
    glommerwings =      { dusty = 1, whispering = 2, shaking = 2 },
    nightmarefuel =     {            whispering = 1 },
    pinkstaff =         { pasty = 5, hardy = 6, sticky = 6, whispering = 6 },
    horn =              { dusty = 6, hardy = 6, whispering = 6, lucky = 6 },
    rock_avocado_fruit ={ hardy = 1, veggie = 1, grassy = 1 }, --草鳄鱼
    rock_avocado_fruit_ripe = { hardy = 1, pasty = 1, veggie = 1, grassy = 1 },
    rock_avocado_fruit_ripe_cooked = { pasty = 1, veggie = 1 },
    cactus_meat =       { pasty = 1, veggie = 1, grassy = 1 },
    cactus_meat_cooked ={ pasty = 1, veggie = 1 },
    bird_egg =          { pasty = 1, dusty = 1, slippery = 1 }, --口水鱼
    bird_egg_cooked =   { pasty = 1, dusty = 1 },
    egg =               { pasty = 1, dusty = 1, slippery = 1 },
    egg_cooked =        { pasty = 1, dusty = 1 },
    tallbirdegg =       { pasty = 6, dusty = 6, slippery = 6 },
    tallbirdegg_cooked ={ pasty = 6, dusty = 6 },
    petals_rose =       { pasty = 1, veggie = 1, fragrant = 1 }, --花朵金枪鱼
    petals_lily =       { pasty = 1, veggie = 1, fragrant = 1 },
    petals_orchid =     { dusty = 1, veggie = 1, fragrant = 1 },
    forgetmelots =      { pasty = 1, fragrant = 1 },
    myth_lotus_flower = { pasty = 1, veggie = 1, fragrant = 1 },
    moon_tree_blossom = { dusty = 1, fragrant = 1 },
    bathbomb =          { dusty = 1, fragrant = 1 },
    meat_dried =        { hardy = 1, meat = 1, wrinkled = 1 }, --落叶比目鱼
    smallmeat_dried =   { hardy = 1, meat = 1, wrinkled = 1 },
    monstermeat_dried = { hardy = 1, meat = 1, monster = 1, wrinkled = 1 },
    cutted_rosebush =   { hardy = 1, pasty = 1, fragrant = 1, wrinkled = 1, grassy = 1 },
    cutted_lilybush =   { hardy = 1, pasty = 1, fragrant = 1, wrinkled = 1, grassy = 1 },
    cutted_orchidbush = { hardy = 1, pasty = 1, fragrant = 1, wrinkled = 1, grassy = 1 },
    lightbulb =         { dusty = 1, shiny = 1 }, --鱿鱼
    lightflier =        { dusty = 1, pasty = 1, shiny = 1, shaking = 1 },
    spore_small =       { dusty = 1, shiny = 1 },
    spore_medium =      { dusty = 1, shiny = 1 },
    spore_tall =        { dusty = 1, shiny = 1 },
    meat =              { pasty = 1, meat = 1, bloody = 1 }, --岩石大白鲨
    monstermeat =       { pasty = 1, meat = 1, monster = 1, bloody = 1 },
    dish_duriantartare ={ pasty = 1, meat = 2, monster = 2, bloody = 2 },
    monstertartare =    { pasty = 1, meat = 2, monster = 2, bloody = 2 },
    houndstooth =       { hardy = 1, dusty = 1, bloody = 1 },
    compost =           { pasty = 1, veggie = 1, rotten = 1 }, --龙虾
    fertilizer =        { pasty = 1, hardy = 1, rotten = 1 },
    slingshotammo_poop ={ hardy = 1, rotten = 1 },
    compostwrap =       { pasty = 1, dusty = 1, hardy = 1, rotten = 1 },
    spoiled_fish =      { pasty = 6, hardy = 6, rotten = 6 },
    spoiled_fish_small ={ pasty = 5, hardy = 5, rotten = 5 },
    poop =              { pasty = 1, dusty = 1, veggie = 1, rotten = 1 },
    guano =             { pasty = 1, rotten = 1 },
    razor =             { hardy = 6, rusty = 6 }, --月光龙虾
    moonglass =         { hardy = 1, dusty = 1, rusty = 1 },
    mutator_moon =      { pasty = 1, dusty = 1, rusty = 1 },
    moonglassaxe =      { hardy = 6, dusty = 5, rusty = 6 },
    glasscutter =       { hardy = 6, dusty = 5, rusty = 6 },
    turf_meteor =       { hardy = 2, pasty = 2, dusty = 2, rusty = 1 },
    moonstorm_goggleshat={hardy = 6, dusty = 6, veggie = 5, rusty = 6 },
    spear_wathgrithr =  { hardy = 6, rusty = 6 },
    axe =               { hardy = 6, rusty = 6 },
    pickaxe =           { hardy = 6, rusty = 6 },
    shovel =            { hardy = 6, rusty = 6 },
    pitchfork =         { hardy = 6, veggie = 1, rusty = 6 },
    spear =             { hardy = 6, rusty = 6 },
    bee =               { pasty = 1, dusty = 1, frizzy = 1, shaking = 1 }, --海黾
    killerbee =         { dusty = 1, frizzy = 1, shaking = 1 },
    stinger =           { dusty = 1, frizzy = 1, shaking = 1 },
    mosquitosack =      { pasty = 1, frizzy = 1, shaking = 1 },
    mosquito =          { pasty = 1, frizzy = 1, shaking = 1 },
    raindonate =        { pasty = 1, shaking = 1 },
    ahandfulofwings =   { pasty = 1, dusty = 1, shaking = 1 },
    wormlight =         { pasty = 1, veggie = 2, frizzy = 1 }, --海鹦鹉
    wormlight_lesser =  { pasty = 1, veggie = 1, frizzy = 1 },
    minotaurhorn =      { pasty = 1, dusty = 1, hardy = 1, evil = 10, meat = 1 }, --邪天翁
    malbatross_feather ={ dusty = 1, evil = 1 },
    malbatross_beak =   { dusty = 1, hardy = 1, evil = 10 },
    deerclops_eyeball = { pasty = 1, evil = 10, frozen = 10, meat = 1, monster = 1 },
    ice =               { pasty = 1 }, --其他
    ash =               { dusty = 1 },
    icehat =            { pasty = 6 },
    spoiled_food =      { pasty = 1, dusty = 1, hardy = 1 },
    silk =              { pasty = 1, dusty = 1, monster = 1 },
    beefalowool =       { pasty = 1, dusty = 1, meat = 1 },
    flint =             { hardy = 1, dusty = 1 },
    twigs =             { pasty = 1, dusty = 1, hardy = 1, veggie = 1 },
    cutgrass =          { pasty = 1, dusty = 1, hardy = 1, veggie = 1 },
    cutreeds =          { pasty = 1, hardy = 1, veggie = 1 },
}
for name,data in pairs(fishhoming_ingredients) do
    _G.FISHHOMING_INGREDIENTS_L[name] = data
end
fishhoming_ingredients = nil

--爆米花鱼、玉米鳕鱼
for k = 1, _G.NUM_TRINKETS do
    _G.FISHHOMING_INGREDIENTS_L["trinket_"..tostring(k)] = { comical = 1 }
end
for k = 1, _G.NUM_HALLOWEEN_ORNAMENTS do
    _G.FISHHOMING_INGREDIENTS_L["halloween_ornament_"..tostring(k)] = { comical = 1, monster = 1 }
end

--------------------------------------------------------------------------
--[[ 打窝器与包裹组件的兼容 ]]
--------------------------------------------------------------------------

if IsServer then
    AddComponentPostInit("bundler", function(self)
        local OnFinishBundling_old = self.OnFinishBundling
        self.OnFinishBundling = function(self, ...)
            if
                self.wrappedprefab == "fishhomingbait" and
                self.bundlinginst ~= nil and
                self.bundlinginst.components.container ~= nil and
                not self.bundlinginst.components.container:IsEmpty()
            then
                local wrapped = SpawnPrefab(self.wrappedprefab, self.wrappedskinname)
                if wrapped ~= nil then
                    if wrapped.components.fishhomingbait ~= nil then
                        wrapped.components.fishhomingbait:Make(self.bundlinginst.components.container, self.inst)
                        self.bundlinginst:Remove()
                        self.bundlinginst = nil
                        self.itemprefab = nil
                        self.wrappedprefab = nil
                        self.wrappedskinname = nil
                        self.wrappedskin_id = nil
                        if self.inst.components.inventory ~= nil then
                            self.inst.components.inventory:GiveItem(wrapped, nil, self.inst:GetPosition())
                        else
                            if wrapped.components.inventoryitem ~= nil then
                                wrapped.components.inventoryitem:DoDropPhysics(self.inst.Transform:GetWorldPosition())
                            elseif wrapped.Physics ~= nil then
                                wrapped.Physics:Teleport(self.inst.Transform:GetWorldPosition())
                            else
                                wrapped.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
                            end
                        end
                        return
                    else
                        wrapped:Remove()
                    end
                end
            end
            OnFinishBundling_old(self, ...)
        end
    end)
end
