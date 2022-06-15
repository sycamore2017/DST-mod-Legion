local prefabFiles = {
    "siving_rocks_legion",
    "farm_plants_legion",
    "cropgnat",
    "ahandfulofwings",
    "boltwingout",
    "siving_related",
    "fishhomingtools",
    "boss_siving_phoenix"
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
    Asset("ATLAS", "images/inventoryimages/fishhomingtool_normal.xml"),
    Asset("IMAGE", "images/inventoryimages/fishhomingtool_normal.tex"),
    Asset("ATLAS", "images/inventoryimages/fishhomingtool_awesome.xml"),
    Asset("IMAGE", "images/inventoryimages/fishhomingtool_awesome.tex"),
    Asset("ATLAS", "images/inventoryimages/siving_turn.xml"),
    Asset("IMAGE", "images/inventoryimages/siving_turn.tex"),
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
AddIngredientValues({"mint_l"}, {veggie=.5}, false, false)

_G.RegistMiniMapImage_legion("siving_derivant")
_G.RegistMiniMapImage_legion("siving_thetree")
_G.RegistMiniMapImage_legion("siving_ctlwater")
_G.RegistMiniMapImage_legion("siving_ctldirt")
_G.RegistMiniMapImage_legion("siving_turn")

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
        Ingredient("siving_rocks", 20, "images/inventoryimages/siving_rocks.xml"),
        Ingredient("greengem", 1),
        Ingredient("moonglass", 10),
    }, TECH.MAGIC_THREE, {
        atlas = "images/inventoryimages/siving_ctlwater_item.xml", image = "siving_ctlwater_item.tex"
    }, { "MAGIC", "GARDENING", "STRUCTURES" }
)
AddRecipe2(
    "siving_ctldirt_item", {
        Ingredient("siving_rocks", 20, "images/inventoryimages/siving_rocks.xml"),
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
AddRecipe2(
    "fishhomingtool_normal", {
        Ingredient("cutreeds", 1),
        Ingredient("stinger", 1),
    }, TECH.FISHING_ONE, {
        atlas = "images/inventoryimages/fishhomingtool_normal.xml", image = "fishhomingtool_normal.tex"
    }, { "FISHING" }
)
AddRecipe2(
    "siving_turn", {
        Ingredient("siving_rocks", 40, "images/inventoryimages/siving_rocks.xml"),
        Ingredient("siving_derivant_item", 1, "images/inventoryimages/siving_derivant_item.xml"),
        Ingredient("seeds", 40),
    }, TECH.MAGIC_THREE, {
        placer="siving_turn_placer",
        atlas = "images/inventoryimages/siving_turn.xml", image = "siving_turn.tex"
    }, { "MAGIC", "GARDENING", "STRUCTURES" }
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
--[[ 添加新动作：让种子能种在 子圭·垄 和 旧版作物 里 ]]
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

            if plant.fn_planted then
                plant.fn_planted(plant, pt)
            end

            return true
        end
    end
    return false
end
local function OnPlant2(seed, doer, crop)
    if seed.components.plantablelegion ~= nil and seed.components.plantablelegion.plant ~= nil then
        local plant = SpawnPrefab(seed.components.plantablelegion.plant)
        if plant ~= nil then
            local pt = crop:GetPosition()
            plant.Transform:SetPosition(pt:Get())
            -- plant:PushEvent("on_planted", { doer = doer, seed = seed, in_soil = true })
            if plant.SoundEmitter ~= nil then
				plant.SoundEmitter:PlaySound("dontstarve/common/plant")
			end
            TheWorld:PushEvent("itemplanted", { doer = doer, pos = pt })

            --替换原本的作物
            plant.components.perennialcrop2:DisplayCrop(crop, doer)

            crop:Remove()
            seed:Remove()

            if plant.fn_planted then
                plant.fn_planted(plant, pt)
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
        if act.target:HasTag("crop_legion") or act.target:HasTag("crop2_legion") then
            return "DISPLAY"
        end
    end
    return "GENERIC"
end
PLANTSOIL_LEGION.fn = function(act)
    if
        act.invobject ~= nil and
        act.doer.components.inventory ~= nil and
        act.target ~= nil and act.target:IsValid() and
        (
            act.target:HasTag("soil_legion") or
            act.target.components.perennialcrop ~= nil or act.target.components.perennialcrop2 ~= nil
        )
    then
        local seed = act.doer.components.inventory:RemoveItem(act.invobject)
        if seed ~= nil then
            if act.target.components.perennialcrop2 ~= nil then
                if OnPlant2(seed, act.doer, act.target) then
                    return true
                end
            else
                if OnPlant(seed, act.doer, act.target) then
                    return true
                end
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
AddComponentAction("USEITEM", "plantablelegion", function(inst, doer, target, actions, right)
    if target:HasTag("crop2_legion") and not target:HasTag("NOCLICK") then
        table.insert(actions, ACTIONS.PLANTSOIL_LEGION)
    end
end)

local function FnSgPlantLegion(inst, action)
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
end
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.PLANTSOIL_LEGION, FnSgPlantLegion))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.PLANTSOIL_LEGION, FnSgPlantLegion))

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
        and act.target ~= nil
    then
        if act.target.components.perennialcrop ~= nil then
            if act.target.components.perennialcrop:Fertilize(act.invobject, act.doer) then
                act.invobject.components.fertilizer:OnApplied(act.doer, act.target)
                act.target.components.perennialcrop:SayDetail(act.doer, true)
                return true
            else
                return false
            end
        elseif act.target.components.perennialcrop2 ~= nil then
            if act.target.components.perennialcrop2:Fertilize(act.invobject, act.doer) then
                act.invobject.components.fertilizer:OnApplied(act.doer, act.target)
                return true
            else
                return false
            end
        end
    end
    return false
end
AddAction(FERTILIZE_LEGION)

AddComponentAction("USEITEM", "fertilizer", function(inst, doer, target, actions, right)
    if
        target:HasTag("fertableall") or
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

--修正照顾作物的动作名字
local strfn_INTERACT_WITH = ACTIONS.INTERACT_WITH.strfn
ACTIONS.INTERACT_WITH.strfn = function(act)
    if act.target ~= nil and act.target:HasTag("tendable_farmplant") then
        return "FARM_PLANT"
    end
    return strfn_INTERACT_WITH(act)
end

------让果蝇能取消多年生作物照顾
local ATTACKPLANT_old = ACTIONS.ATTACKPLANT.fn
ACTIONS.ATTACKPLANT.fn = function(act)
    if act.target ~= nil then
        if act.target.components.perennialcrop ~= nil then
            return act.target.components.perennialcrop:TendTo(act.doer, false)
        elseif act.target.components.perennialcrop2 ~= nil then
            return act.target.components.perennialcrop2:TendTo(act.doer, false)
        end
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
                    ( (
                        plant.components.perennialcrop ~= nil and
                        plant.components.perennialcrop:Tendable(self.inst, self.wantsstressed)
                    ) or (
                        plant.components.perennialcrop2 ~= nil and
                        plant.components.perennialcrop2:Tendable(self.inst, self.wantsstressed)
                    ) ) and
                    IsNearFollowPos(self, plant) and
                    (self.validplantfn == nil or self.validplantfn(self.inst, plant))
                then
                    return true
                end
            end, nil, nil, { "crop_legion", "crop2_legion" })

            if self.inst.planttarget then
                local action = BufferedAction(self.inst, self.inst.planttarget, self.action, nil, nil, nil, 0.1)
                self.inst.components.locomotor:PushAction(action, self.shouldrun)
                self.status = RUNNING
            end
        end
        if
            self.inst.planttarget and (
                self.inst.planttarget.components.perennialcrop ~= nil or
                self.inst.planttarget.components.perennialcrop2 ~= nil
            )
        then
            if self.status == RUNNING then
                local plant = self.inst.planttarget
                local cropcpt = plant.components.perennialcrop or plant.components.perennialcrop2
                if
                    not plant or not plant:IsValid() or not IsNearFollowPos(self, plant) or
                    (plant.components.perennialcrop ~= nil and not cropcpt.tendable) or
                    not (self.validplantfn == nil or self.validplantfn(self.inst, plant))
                then
                    self.inst.planttarget = nil
                    self.status = FAILED
                end

                if not cropcpt:Tendable(self.inst, self.wantsstressed) then
                    self.inst.planttarget = nil
                    self.status = SUCCESS
                end
            end
            return
        end
        Visit_old(self, ...)
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
    batbat =            { hardy = 6, pasty = 6, hot = 6, frozen = 6, monster = 1 },
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
    monstermeat_dried = { hardy = 1, meat = 1, monster = 2, wrinkled = 1 },
    cutted_rosebush =   { hardy = 1, pasty = 1, fragrant = 1, wrinkled = 1, grassy = 1 },
    cutted_lilybush =   { hardy = 1, pasty = 1, fragrant = 1, wrinkled = 1, grassy = 1 },
    cutted_orchidbush = { hardy = 1, pasty = 1, fragrant = 1, wrinkled = 1, grassy = 1 },
    lightbulb =         { dusty = 1, shiny = 1 }, --鱿鱼
    lightflier =        { dusty = 1, pasty = 1, shiny = 1, shaking = 1 },
    spore_small =       { dusty = 1, shiny = 1 },
    spore_medium =      { dusty = 1, shiny = 1 },
    spore_tall =        { dusty = 1, shiny = 1 },
    meat =              { pasty = 1, meat = 1, bloody = 1 }, --岩石大白鲨
    monstermeat =       { pasty = 1, meat = 1, monster = 2, bloody = 1 },
    dish_duriantartare ={ pasty = 1, meat = 2, monster = 4, bloody = 2 },
    monstertartare =    { pasty = 1, meat = 2, monster = 4, bloody = 2 },
    houndstooth =       { hardy = 1, dusty = 1, bloody = 1 },
    spiderhat =         { pasty = 6, dusty = 6, bloody = 6, monster = 6 },
    compost =           { pasty = 1, veggie = 1, rotten = 1 }, --龙虾
    fertilizer =        { pasty = 6, hardy = 6, rotten = 6 },
    slingshotammo_poop ={ hardy = 1, rotten = 1 },
    compostwrap =       { pasty = 1, dusty = 1, hardy = 1, rotten = 1 },
    spoiled_fish =      { pasty = 6, hardy = 6, rotten = 6 },
    spoiled_fish_small ={ pasty = 5, hardy = 5, rotten = 5 },
    poop =              { pasty = 1, dusty = 1, veggie = 1, rotten = 1 },
    guano =             { pasty = 1, rotten = 1 },
    rottenegg =         { pasty = 1, hardy = 1, rotten = 1, slippery = 1 },
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
    silk =              { pasty = 1, dusty = 1 },
    spidergland =       { pasty = 1, monster = 1 },
    beefalowool =       { pasty = 1, dusty = 1, meat = 1 },
    flint =             { hardy = 1, dusty = 1 },
    twigs =             { pasty = 1, dusty = 1, hardy = 1, veggie = 1 },
    cutgrass =          { pasty = 1, dusty = 1, hardy = 1, veggie = 1 },
    cutreeds =          { pasty = 1, hardy = 1, veggie = 1 },
    hambat =            { hardy = 6, pasty = 6, meat = 2 },
    feather_crow =      { hardy = 1, pasty = 1, dusty = 1 },
    feather_robin =     { hardy = 1, pasty = 1, dusty = 1, hot = 1 },
    feather_robin_winter={hardy = 1, pasty = 1, dusty = 1, frozen = 1 },
    feather_canary =    { hardy = 1, pasty = 1, dusty = 1, shiny = 1 },
    furtuft =           { pasty = 1, dusty = 1 },
    phlegm =            { pasty = 1, slippery = 1, sticky = 1 },
    slurtleslime =      { pasty = 1, slippery = 1, sticky = 1 },
    twiggy_nut =        { hardy = 1, dusty = 1, veggie = 1 },
    acorn =             { hardy = 1, pasty = 1, dusty = 1, veggie = 1 },
    pinecone =          { hardy = 1, dusty = 1, veggie = 1 },
    log =               { hardy = 1, dusty = 1, veggie = 1 },
    petals_evil =       { pasty = 1, veggie = 1, monster = 2 },
    siving_rocks =      { hardy = 1, pasty = 1, dusty = 1 },
    goose_feather =     { hardy = 1, pasty = 1, dusty = 1, evil = 1 },
    --圣诞小玩意：全部可加入，不过没有任何属性
}
for name,data in pairs(fishhoming_ingredients) do
    _G.FISHHOMING_INGREDIENTS_L[name] = data
end
fishhoming_ingredients = nil

--冬季盛宴小食物
for k = 1, _G.NUM_WINTERFOOD do
    _G.FISHHOMING_INGREDIENTS_L["winter_food"..tostring(k)] = { hardy = 1, pasty = 1, dusty = 1 }
end

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
    local function DropItem(inst, item)
        if item.components.inventoryitem ~= nil then
            item.components.inventoryitem:DoDropPhysics(inst.Transform:GetWorldPosition())
        elseif item.Physics ~= nil then
            item.Physics:Teleport(inst.Transform:GetWorldPosition())
        else
            item.Transform:SetPosition(inst.Transform:GetWorldPosition())
        end
    end
    AddComponentPostInit("bundler", function(self)
        local OnFinishBundling_old = self.OnFinishBundling
        self.OnFinishBundling = function(self, ...)
            if
                self.wrappedprefab == "fishhomingbait" and
                self.bundlinginst ~= nil and
                self.bundlinginst.components.container ~= nil and
                not self.bundlinginst.components.container:IsEmpty()
            then
                if self.itemprefab == "fishhomingtool_awesome" then --专业制作器是无限使用的
                    local item = SpawnPrefab(self.itemprefab, self.itemskinname)
                    if item ~= nil then
                        if self.inst.components.inventory ~= nil then
                            self.inst.components.inventory:GiveItem(item, nil, self.inst:GetPosition())
                        else
                            DropItem(self.inst, item)
                        end
                    end
                end

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
                            DropItem(self.inst, wrapped)
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

--------------------------------------------------------------------------
--[[ 旧版多年生作物 ]]
--------------------------------------------------------------------------

--[[ hey, Tosh! See here! ]]--
if not _G.rawget(_G, "CROPS_DATA_LEGION") then --对于global来说，不能直接检测是否有某个元素，需要用rawget才行
    _G.CROPS_DATA_LEGION = {}
end

local time_annual = 20*TUNING.TOTAL_DAY_TIME
local time_years = 25 * TUNING.TOTAL_DAY_TIME
local time_day = TUNING.TOTAL_DAY_TIME*(_G.CONFIGS_LEGION.X_OVERRIPETIME or 1)

_G.CROPS_DATA_LEGION.carrot = {
    growthmults = { [1] = 0.8, [2] = 1.2, [3] = 0.8, [4] = 1.5 }, --秋冬春。小于1为加速生长，大于1为延缓生长，为0停止生长
    regrowstage = 3, --重新生长的阶段
    bank = "plant_normal_legion",
    build = "plant_normal_legion",
    leveldata = {
        [1] = { anim = "level1_carrot", time = time_annual * 0.05, deadanim = "dead123_carrot", witheredprefab = nil, },
        [2] = { anim = "level2_carrot", time = time_annual * 0.15, deadanim = "dead123_carrot", witheredprefab = {"cutgrass"}, },
        [3] = { anim = "level3_carrot", time = time_annual * 0.20, deadanim = "dead123_carrot", witheredprefab = {"cutgrass"}, },
        [4] = { anim = "level4_carrot", time = time_annual * 0.20, deadanim = "dead456_carrot", witheredprefab = {"cutgrass"} },
        [5] = { anim = "level5_carrot", time = time_annual * 0.40, deadanim = "dead456_carrot", witheredprefab = {"cutgrass"}, bloom = true, },
        [6] = { anim = "level6_carrot", time = time_day    * 6.00, deadanim = "dead456_carrot", witheredprefab = {"cutgrass"}, },
    },
    maturedanim = {
        [1] = "level6_carrot_1",
        [2] = "level6_carrot_2",
        [3] = "level6_carrot_3",
    },
}
_G.CROPS_DATA_LEGION.corn = {
    growthmults = { [1] = 0.8, [2] = 0.8, [3] = 0.8, [4] = 0 }, --秋春夏
    regrowstage = 3,
    bank = "plant_normal_legion",
    build = "plant_normal_legion",
    leveldata = {
        [1] = { anim = "level1_corn", time = time_annual * 0.05, deadanim = "dead123_corn", witheredprefab = nil, },
        [2] = { anim = "level2_corn", time = time_annual * 0.15, deadanim = "dead123_corn", witheredprefab = {"twigs"}, },
        [3] = { anim = "level3_corn", time = time_annual * 0.20, deadanim = "dead123_corn", witheredprefab = {"twigs"}, },
        [4] = { anim = "level4_corn", time = time_annual * 0.20, deadanim = "dead456_corn", witheredprefab = {"twigs"}, },
        [5] = { anim = "level5_corn", time = time_annual * 0.40, deadanim = "dead456_corn", witheredprefab = {"twigs"}, bloom = true, },
        [6] = { anim = "level6_corn", time = time_day    * 6.00, deadanim = "dead456_corn", witheredprefab = {"twigs", "twigs"}, },
    },
    maturedanim = {
        [1] = "level6_corn_1",
        [2] = "level6_corn_2",
        [3] = "level6_corn_3",
    },
}
_G.CROPS_DATA_LEGION.pumpkin = {
    growthmults = { [1] = 1.2, [2] = 1.2, [3] = 0.8, [4] = 1.5 }, --秋冬
    regrowstage = 4,
    bank = "plant_normal_legion",
    build = "plant_normal_legion",
    leveldata = {
        [1] = { anim = "level1_pumpkin", time = time_years * 0.05, deadanim = "dead123_pumpkin", witheredprefab = nil, },
        [2] = { anim = "level2_pumpkin", time = time_years * 0.15, deadanim = "dead123_pumpkin", witheredprefab = {"cutgrass"}, },
        [3] = { anim = "level3_pumpkin", time = time_years * 0.20, deadanim = "dead123_pumpkin", witheredprefab = {"cutgrass"}, },
        [4] = { anim = "level4_pumpkin", time = time_years * 0.20, deadanim = "dead456_pumpkin", witheredprefab = {"cutgrass"}, },
        [5] = { anim = "level5_pumpkin", time = time_years * 0.40, deadanim = "dead456_pumpkin", witheredprefab = {"cutgrass", "cutgrass"}, bloom = true, },
        [6] = { anim = "level6_pumpkin", time = time_day   * 6.00, deadanim = "dead456_pumpkin", witheredprefab = {"cutgrass", "rope"}, },
    },
    maturedanim = {
        [1] = "level6_pumpkin_1",
        [2] = "level6_pumpkin_2",
        [3] = "level6_pumpkin_3",
    },
}
_G.CROPS_DATA_LEGION.eggplant = {
    growthmults = { [1] = 0.8, [2] = 1.2, [3] = 0.8, [4] = 0 }, --春秋
    regrowstage = 4,
    bank = "crop_legion_eggplant",
    build = "crop_legion_eggplant",
    leveldata = {
        [1] = { anim = "level1", time = time_years * 0.05, deadanim = "dead1", witheredprefab = nil, },
        [2] = { anim = "level2", time = time_years * 0.15, deadanim = "dead1", witheredprefab = {"cutgrass"}, },
        [3] = { anim = "level3", time = time_years * 0.20, deadanim = "dead1", witheredprefab = {"cutgrass"}, },
        [4] = { anim = "level4", time = time_years * 0.20, deadanim = "dead2", witheredprefab = {"cutgrass"}, },
        [5] = { anim = "level5", time = time_years * 0.40, deadanim = "dead2", witheredprefab = {"rope"}, bloom = true, },
        [6] = { anim = "level6", time = time_day   * 6.00, deadanim = "dead2", witheredprefab = {"rope", "bird_egg"}, },
    },
    maturedanim = {
        [1] = "level6_1",
        [2] = "level6_2",
        [3] = "level6_3",
    },
    fn_loot = function(inst, loots)
        local crop = inst.components.perennialcrop2
        if crop.stage == crop.stage_max then
            if crop.numfruit ~= nil and crop.numfruit > 0 then
                if crop.isrotten then
                    for i = 1, crop.numfruit, 1 do
                        table.insert(loots, "spoiled_food")
                    end
                    if math.random() < 0.4 then
                        table.insert(loots, "rottenegg")
                    end
                else
                    for i = 1, crop.numfruit, 1 do
                        table.insert(loots, crop.cropprefab)
                    end
                    if math.random() < 0.4 then
                        table.insert(loots, "bird_egg")
                    end
                end
            end
        end
    end
}
_G.CROPS_DATA_LEGION.durian = {
    growthmults = { [1] = 0.8, [2] = 1.2, [3] = 1.2, [4] = 0 }, --春
    regrowstage = 4,
    bank = "plant_normal_legion",
    build = "plant_normal_legion",
    leveldata = {
        [1] = { anim = "level1_durian", time = time_years * 0.05, deadanim = "dead123_durian", witheredprefab = nil, },
        [2] = { anim = "level2_durian", time = time_years * 0.15, deadanim = "dead123_durian", witheredprefab = {"twigs"}, },
        [3] = { anim = "level3_durian", time = time_years * 0.20, deadanim = "dead123_durian", witheredprefab = {"twigs"}, },
        [4] = { anim = "level4_durian", time = time_years * 0.20, deadanim = "dead456_durian", witheredprefab = {"log"}, },
        [5] = { anim = "level5_durian", time = time_years * 0.40, deadanim = "dead456_durian", witheredprefab = {"livinglog"}, bloom = true, },
        [6] = { anim = "level6_durian", time = time_day   * 6.00, deadanim = "dead456_durian", witheredprefab = {"livinglog", "log"}, },
    },
    maturedanim = {
        [1] = "level6_durian_1",
        [2] = "level6_durian_2",
        [3] = "level6_durian_3",
    },
    fn_loot = function(inst, loots)
        local crop = inst.components.perennialcrop2
        if crop.stage == crop.stage_max then
            if crop.numfruit ~= nil and crop.numfruit > 0 then
                if crop.isrotten then
                    for i = 1, crop.numfruit, 1 do
                        table.insert(loots, "spoiled_food")
                    end
                else
                    for i = 1, crop.numfruit, 1 do
                        table.insert(loots, crop.cropprefab)
                    end
                end
                if math.random() < 0.05 then
                    table.insert(loots, "livinglog")
                end
            end
        end
    end
}
_G.CROPS_DATA_LEGION.pomegranate = {
    growthmults = { [1] = 0.8, [2] = 0.8, [3] = 1.2, [4] = 0 }, --春夏
    regrowstage = 4,
    bank = "plant_normal_legion",
    build = "plant_normal_legion",
    leveldata = {
        [1] = { anim = "level1_pomegranate", time = time_years * 0.05, deadanim = "dead123_pomegranate", witheredprefab = nil, },
        [2] = { anim = "level2_pomegranate", time = time_years * 0.15, deadanim = "dead123_pomegranate", witheredprefab = {"twigs"}, },
        [3] = { anim = "level3_pomegranate", time = time_years * 0.20, deadanim = "dead123_pomegranate", witheredprefab = {"twigs"}, },
        [4] = { anim = "level4_pomegranate", time = time_years * 0.20, deadanim = "dead456_pomegranate", witheredprefab = {"log"}, },
        [5] = { anim = "level5_pomegranate", time = time_years * 0.40, deadanim = "dead456_pomegranate", witheredprefab = {"log"}, bloom = true, },
        [6] = { anim = "level6_pomegranate", time = time_day   * 6.00, deadanim = "dead456_pomegranate", witheredprefab = {"log", "log"}, },
    },
    maturedanim = {
        [1] = "level6_pomegranate_1",
        [2] = "level6_pomegranate_2",
        [3] = "level6_pomegranate_3",
    },
}
_G.CROPS_DATA_LEGION.dragonfruit = {
    growthmults = { [1] = 0.8, [2] = 0.8, [3] = 1.2, [4] = 0 }, --春夏
    regrowstage = 4,
    bank = "plant_normal_legion",
    build = "plant_normal_legion",
    leveldata = {
        [1] = { anim = "level1_dragonfruit", time = time_years * 0.05, deadanim = "dead123_dragonfruit", witheredprefab = nil, },
        [2] = { anim = "level2_dragonfruit", time = time_years * 0.15, deadanim = "dead123_dragonfruit", witheredprefab = {"twigs"}, },
        [3] = { anim = "level3_dragonfruit", time = time_years * 0.20, deadanim = "dead123_dragonfruit", witheredprefab = {"twigs"}, },
        [4] = { anim = "level4_dragonfruit", time = time_years * 0.20, deadanim = "dead456_dragonfruit", witheredprefab = {"log"}, },
        [5] = { anim = "level5_dragonfruit", time = time_years * 0.40, deadanim = "dead456_dragonfruit", witheredprefab = {"log", "twigs"}, bloom = true, },
        [6] = { anim = "level6_dragonfruit", time = time_day   * 6.00, deadanim = "dead456_dragonfruit", witheredprefab = {"log", "twigs"}, },
    },
    maturedanim = {
        [1] = "level6_dragonfruit_1",
        [2] = "level6_dragonfruit_2",
        [3] = "level6_dragonfruit_3",
    },
}
_G.CROPS_DATA_LEGION.watermelon = {
    growthmults = { [1] = 0.8, [2] = 0.8, [3] = 1.2, [4] = 0 }, --春夏
    regrowstage = 3,
    bank = "plant_normal_legion",
    build = "plant_normal_legion",
    leveldata = {
        [1] = { anim = "level1_watermelon", time = time_annual * 0.05, deadanim = "dead123_watermelon", witheredprefab = nil, },
        [2] = { anim = "level2_watermelon", time = time_annual * 0.15, deadanim = "dead123_watermelon", witheredprefab = {"cutgrass"}, },
        [3] = { anim = "level3_watermelon", time = time_annual * 0.20, deadanim = "dead123_watermelon", witheredprefab = {"cutgrass"}, },
        [4] = { anim = "level4_watermelon", time = time_annual * 0.20, deadanim = "dead456_watermelon", witheredprefab = {"cutgrass"}, },
        [5] = { anim = "level5_watermelon", time = time_annual * 0.40, deadanim = "dead456_watermelon", witheredprefab = {"cutgrass"}, bloom = true, },
        [6] = { anim = "level6_watermelon", time = time_day    * 6.00, deadanim = "dead456_watermelon", witheredprefab = {"cutgrass", "cutgrass"}, },
    },
    maturedanim = {
        [1] = "level6_watermelon_1",
        [2] = "level6_watermelon_2",
        [3] = "level6_watermelon_3",
    },
}
_G.CROPS_DATA_LEGION.pineananas = {
    growthmults = { [1] = 1.2, [2] = 0.8, [3] = 0.8, [4] = 0 }, --秋夏
    regrowstage = 4,
    bank = "crop_legion_pineananas",
    build = "crop_legion_pineananas",
    leveldata = {
        [1] = { anim = "level1", time = time_years * 0.05, deadanim = "dead1", witheredprefab = nil, },
        [2] = { anim = "level2", time = time_years * 0.15, deadanim = "dead1", witheredprefab = {"twigs"}, },
        [3] = { anim = "level3", time = time_years * 0.20, deadanim = "dead1", witheredprefab = {"log"}, },
        [4] = { anim = "level4", time = time_years * 0.20, deadanim = "dead2", witheredprefab = {"log"}, },
        [5] = { anim = "level5", time = time_years * 0.40, deadanim = "dead2", witheredprefab = {"log", "cutgrass"}, bloom = true, },
        [6] = { anim = "level6", time = time_day   * 6.00, deadanim = "dead2", witheredprefab = {"log", "cutgrass", "pinecone"}, },
    },
    maturedanim = {
        [1] = "level6_1",
        [2] = "level6_2",
        [3] = "level6_3",
    },
    fn_loot = function(inst, loots)
        local crop = inst.components.perennialcrop2
        if crop.stage == crop.stage_max then
            if crop.numfruit ~= nil and crop.numfruit > 0 then
                if crop.isrotten then
                    for i = 1, crop.numfruit, 1 do
                        table.insert(loots, "spoiled_food")
                    end
                else
                    for i = 1, crop.numfruit, 1 do
                        table.insert(loots, crop.cropprefab)
                    end
                end
                if math.random() < 0.05 then
                    table.insert(loots, "pinecone")
                end
            end
        end
    end
}
_G.CROPS_DATA_LEGION.onion = {
    growthmults = { [1] = 0.8, [2] = 0.8, [3] = 0.8, [4] = 0 }, --春秋夏
    regrowstage = 2,
    bank = "crop_legion_onion",
    build = "crop_legion_onion",
    leveldata = {
        [1] = { anim = "level1", time = time_annual * 0.20, deadanim = "dead1", witheredprefab = nil, },
        [2] = { anim = "level2", time = time_annual * 0.15, deadanim = "dead1", witheredprefab = {"cutgrass"}, },
        [3] = { anim = "level3", time = time_annual * 0.20, deadanim = "dead2", witheredprefab = {"cutgrass"}, },
        [4] = { anim = "level4", time = time_annual * 0.45, deadanim = "dead2", witheredprefab = {"cutgrass"}, bloom = true, },
        [5] = { anim = "level5", time = time_day    * 6.00, deadanim = "dead2", witheredprefab = {"cutgrass", "cutgrass"}, },
    },
    maturedanim = {
        [1] = "level5_1",
        [2] = "level5_2",
        [3] = "level5_3",
    },
}
_G.CROPS_DATA_LEGION.pepper = {
    growthmults = { [1] = 1.2, [2] = 0.8, [3] = 0.8, [4] = 0 }, --秋夏
    regrowstage = 3,
    bank = "crop_legion_pepper",
    build = "crop_legion_pepper",
    leveldata = {
        [1] = { anim = "level1", time = time_years * 0.15, deadanim = "dead1", witheredprefab = nil, },
        [2] = { anim = "level2", time = time_years * 0.20, deadanim = "dead1", witheredprefab = {"cutgrass"}, },
        [3] = { anim = "level3", time = time_years * 0.25, deadanim = "dead2", witheredprefab = {"cutgrass"}, },
        [4] = { anim = "level4", time = time_years * 0.40, deadanim = "dead2", witheredprefab = {"cutgrass"}, bloom = true, },
        [5] = { anim = "level5", time = time_day   * 6.00, deadanim = "dead2", witheredprefab = {"cutgrass", "cutgrass"}, },
    },
    maturedanim = {
        [1] = "level5_1",
        [2] = "level5_2",
        [3] = "level5_3",
    },
    fn_loot = function(inst, loots)
        local crop = inst.components.perennialcrop2
        if crop.stage == crop.stage_max then
            if crop.numfruit ~= nil and crop.numfruit > 0 then
                if crop.isrotten then
                    for i = 1, crop.numfruit, 1 do
                        table.insert(loots, "spoiled_food")
                    end
                    if math.random() < 0.4 then
                        table.insert(loots, "spoiled_food")
                    end
                else
                    for i = 1, crop.numfruit, 1 do
                        table.insert(loots, crop.cropprefab)
                    end
                    if math.random() < 0.4 then
                        table.insert(loots, "mint_l")
                    end
                end
            end
        end
    end
}
_G.CROPS_DATA_LEGION.potato = {
    growthmults = { [1] = 0.8, [2] = 1.2, [3] = 0.8, [4] = 1.5 }, --春秋冬
    regrowstage = 2,
    bank = "crop_legion_potato",
    build = "crop_legion_potato",
    leveldata = {
        [1] = { anim = "level1", time = time_annual * 0.20, deadanim = "dead1", witheredprefab = nil, },
        [2] = { anim = "level2", time = time_annual * 0.15, deadanim = "dead1", witheredprefab = {"cutgrass"}, },
        [3] = { anim = "level3", time = time_annual * 0.20, deadanim = "dead2", witheredprefab = {"cutgrass", "potato"}, },
        [4] = { anim = "level4", time = time_annual * 0.45, deadanim = "dead2", witheredprefab = {"cutgrass", "potato"}, bloom = true, },
        [5] = { anim = "level5", time = time_day    * 6.00, deadanim = "dead2", witheredprefab = {"cutgrass", "potato"}, },
    },
    maturedanim = {
        [1] = "level5_1",
        [2] = "level5_2",
        [3] = "level5_3",
    },
}
_G.CROPS_DATA_LEGION.garlic = {
    growthmults = { [1] = 0.8, [2] = 0.8, [3] = 0.8, [4] = 1.5 }, --春夏秋冬
    regrowstage = 2,
    bank = "crop_legion_garlic",
    build = "crop_legion_garlic",
    leveldata = {
        [1] = { anim = "level1", time = time_annual * 0.20, deadanim = "dead1", witheredprefab = nil, },
        [2] = { anim = "level2", time = time_annual * 0.15, deadanim = "dead1", witheredprefab = {"cutgrass"}, },
        [3] = { anim = "level3", time = time_annual * 0.20, deadanim = "dead2", witheredprefab = {"cutgrass"}, },
        [4] = { anim = "level4", time = time_annual * 0.45, deadanim = "dead2", witheredprefab = {"cutgrass"}, bloom = true, },
        [5] = { anim = "level5", time = time_day    * 6.00, deadanim = "dead2", witheredprefab = {"feather_crow", "feather_robin"}, },
    },
    maturedanim = {
        [1] = "level5_1",
        [2] = "level5_2",
        [3] = "level5_3",
    },
    fn_loot = function(inst, loots)
        local crop = inst.components.perennialcrop2
        if crop.stage == crop.stage_max then
            if crop.numfruit ~= nil and crop.numfruit > 0 then
                if crop.isrotten then
                    for i = 1, crop.numfruit, 1 do
                        table.insert(loots, "spoiled_food")
                    end
                else
                    for i = 1, crop.numfruit, 1 do
                        table.insert(loots, crop.cropprefab)
                    end
                end
                local rand = math.random()
                if rand < 0.03 then
                    table.insert(loots, "feather_crow")
                elseif rand < 0.05 then
                    table.insert(loots, "feather_robin")
                end
            end
        end
    end
}
_G.CROPS_DATA_LEGION.tomato = {
    growthmults = { [1] = 0.8, [2] = 0.8, [3] = 0.8, [4] = 0 }, --春夏秋
    regrowstage = 3,
    bank = "crop_legion_tomato",
    build = "crop_legion_tomato",
    leveldata = {
        [1] = { anim = "level1", time = time_years * 0.15, deadanim = "dead1", witheredprefab = nil, },
        [2] = { anim = "level2", time = time_years * 0.20, deadanim = "dead1", witheredprefab = {"twigs"}, },
        [3] = { anim = "level3", time = time_years * 0.25, deadanim = "dead2", witheredprefab = {"twigs"}, },
        [4] = { anim = "level4", time = time_years * 0.40, deadanim = "dead2", witheredprefab = {"twigs"}, bloom = true, },
        [5] = { anim = "level5", time = time_day   * 6.00, deadanim = "dead2", witheredprefab = {"twigs", "twigs"}, },
    },
    maturedanim = {
        [1] = "level5_1",
        [2] = "level5_2",
        [3] = "level5_3",
    }
}
_G.CROPS_DATA_LEGION.asparagus = {
    growthmults = { [1] = 0.8, [2] = 1.2, [3] = 1.2, [4] = 1.5 }, --春冬
    regrowstage = 3,
    bank = "crop_legion_asparagus",
    build = "crop_legion_asparagus",
    leveldata = {
        [1] = { anim = "level1", time = time_years * 0.15, deadanim = "dead1", witheredprefab = nil, },
        [2] = { anim = "level2", time = time_years * 0.20, deadanim = "dead1", witheredprefab = {"cutgrass"}, },
        [3] = { anim = "level3", time = time_years * 0.25, deadanim = "dead2", witheredprefab = {"cutgrass", "cutgrass"}, },
        [4] = { anim = "level4", time = time_years * 0.40, deadanim = "dead2", witheredprefab = {"cutgrass", "cutgrass"}, },
        [5] = { anim = "level5", time = time_day   * 6.00, deadanim = "dead2", witheredprefab = {"cutgrass", "cutgrass", "cutgrass"}, },
    },
    maturedanim = {
        [1] = "level5_1",
        [2] = "level5_2",
        [3] = "level5_3",
    },
}
_G.CROPS_DATA_LEGION.mandrake = {
    growthmults = { [1] = 1, [2] = 1, [3] = 1, [4] = 1.5 }, --冬
    regrowstage = 1,
    bank = "crop_legion_mandrake",
    build = "crop_legion_mandrake",
    getsickchance = 0,
    leveldata = {
        [1] = { anim = "level1", time = time_years * 0.16, deadanim = "dead1", witheredprefab = nil, },
        [2] = { anim = "level2", time = time_years * 0.24, deadanim = "dead1", witheredprefab = {"cutgrass"}, },
        [3] = { anim = "level3", time = time_years * 0.36, deadanim = "dead1", witheredprefab = {"cutgrass"}, },
        [4] = { anim = "level4", time = time_years * 0.24, deadanim = "dead1", witheredprefab = {"cutgrass"}, },
        [5] = { anim = "level5", time = nil,               deadanim = "dead1", witheredprefab = {"cutgrass"}, },
    },
    fn_loot = function(inst, loots)
        local crop = inst.components.perennialcrop2
        if crop.isrotten then
            table.insert(loots, "livinglog")
            table.insert(loots, "livinglog")
        elseif crop.stage == crop.stage_max then
            table.insert(loots, "mandrake")
        end
    end,
    fn_defend = function(inst, target)
        local doer = target or inst
        if doer.SoundEmitter then
            doer.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/death")
        else
            inst.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/death")
        end
        local x, y, z = doer.Transform:GetWorldPosition()
        doer:DoTaskInTime(0.5, function()
            local time = TUNING.MANDRAKE_SLEEP_TIME
            local ents = TheSim:FindEntities(x, y, z, TUNING.MANDRAKE_SLEEP_RANGE_COOKED, nil,
                { "playerghost", "FX", "DECOR", "INLIMBO" }, { "sleeper", "player" })
            for i, v in ipairs(ents) do
                if
                    not (v.components.freezable ~= nil and v.components.freezable:IsFrozen()) and
                    not (v.components.pinnable ~= nil and v.components.pinnable:IsStuck()) and
                    not (v.components.fossilizable ~= nil and v.components.fossilizable:IsFossilized())
                then
                    local mount = v.components.rider ~= nil and v.components.rider:GetMount() or nil
                    if mount ~= nil then
                        mount:PushEvent("ridersleep", { sleepiness = 7, sleeptime = time + math.random() })
                    end
                    if v:HasTag("player") then
                        v:PushEvent("yawn", { grogginess = 4, knockoutduration = time + math.random() })
                    elseif v.components.sleeper ~= nil then
                        v.components.sleeper:AddSleepiness(7, time + math.random())
                    elseif v.components.grogginess ~= nil then
                        v.components.grogginess:AddGrogginess(4, time + math.random())
                    else
                        v:PushEvent("knockedout")
                    end
                end
            end
        end)
    end
}
_G.CROPS_DATA_LEGION.gourd = {
    growthmults = { [1] = 1.2, [2] = 1.2, [3] = 0.8, [4] = 0 }, --秋
    regrowstage = 4,
    bank = "crop_mythword_gourd",
    build = "crop_mythword_gourd",
    leveldata = {
        [1] = { anim = "level1", time = time_years * 0.05, deadanim = "dead1", witheredprefab = nil, },
        [2] = { anim = "level2", time = time_years * 0.15, deadanim = "dead1", witheredprefab = {"cutgrass"}, },
        [3] = { anim = "level3", time = time_years * 0.20, deadanim = "dead2", witheredprefab = {"cutgrass"}, },
        [4] = { anim = "level4", time = time_years * 0.20, deadanim = "dead2", witheredprefab = {"cutgrass"}, },
        [5] = { anim = "level5", time = time_years * 0.40, deadanim = "dead2", witheredprefab = {"cutgrass", "cutgrass"}, bloom = true, },
        [6] = { anim = "level6", time = time_day   * 6.00, deadanim = "dead2", witheredprefab = {"cutgrass", "rope"}, },
    },
    maturedanim = {
        [1] = "level6_1",
        [2] = "level6_2",
        [3] = "level6_3",
    }
}

--------------------------------------------------------------------------
--[[ 修改浣猫，让猫薄荷对其产生特殊作用 ]]
--------------------------------------------------------------------------

if IsServer then
    AddPrefabPostInit("catcoon", function(inst)
        local onaccept_old = inst.components.trader.onaccept
        inst.components.trader.onaccept = function(cat, giver, item)
            if not item:HasTag("catmint") then
                onaccept_old(cat, giver, item)
                return
            end

            if cat.components.sleeper:IsAsleep() then
                cat.components.sleeper:WakeUp()
            end
            if cat.components.combat.target == giver then
                cat.components.combat:SetTarget(nil)
                cat.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/catcoon/pickup")

                -->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                cat.excitedaboutmint = nil --取消兴奋
                --<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            elseif giver.components.leader ~= nil then
                if giver.components.minigame_participator == nil then
                    giver:PushEvent("makefriend")
                    giver.components.leader:AddFollower(cat)
                end

                -->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                cat.last_hairball_time = GetTime()
                cat.hairball_friend_interval = math.random(2,4)
                cat.components.follower:AddLoyaltyTime(TUNING.CATCOON_LOYALTY_PER_ITEM * 5) --提升了跟随的时间
                cat.excitedaboutmint = true --兴奋时间到
                --<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

                if not cat.sg:HasStateTag("busy") then
                    cat:FacePoint(giver.Transform:GetWorldPosition())
                    cat.sg:GoToState("pawground")
                end
            end
            item:Remove()
        end

        local PickRandomGift_old = inst.PickRandomGift
        inst.PickRandomGift = function(cat, tier)
            if cat.excitedaboutmint then
                if --处于兴奋中，有跟随对象，并且，没有攻击目标，或者自己的攻击目标不是跟随对象
                    cat.components.follower and cat.components.follower.leader and
                    cat.components.combat.target ~= cat.components.follower.leader
                then
                    if math.random() < 0.1 then
                        --恭喜，得到猫线球，退出兴奋状态
                        cat.excitedaboutmint = nil
                        return "cattenball"
                    else
                        --如果没有吐出猫线球，则减少下一次呕吐的间隔。因为在brain中已经算好这次的间隔了，所以在这只需减少即可
                        if cat.hairball_friend_interval ~= nil then
                            cat.hairball_friend_interval = cat.hairball_friend_interval / 4
                        end
                    end
                else
                    cat.excitedaboutmint = nil
                end
            end

            return PickRandomGift_old(cat, tier)
        end
    end)
end

--------------------------------------------------------------------------
--[[ 子圭·育的相关 ]]
--------------------------------------------------------------------------

if not _G.rawget(_G, "TRANS_DATA_LEGION") then --对于global来说，不能直接检测是否有某个元素，需要用rawget才行
    _G.TRANS_DATA_LEGION = {}
end

local mapseeds = {
    carrot_oversized = {
        swap = { build = "farm_plant_carrot", file = "swap_body", symboltype = "3" },
        fruit = "seeds_carrot_l"
    },
    corn_oversized = {
        swap = { build = "farm_plant_corn_build", file = "swap_body", symboltype = "3" },
        fruit = "seeds_corn_l"
    },
    pumpkin_oversized = {
        swap = { build = "farm_plant_pumpkin", file = "swap_body", symboltype = "3" },
        fruit = "seeds_pumpkin_l"
    },
    eggplant_oversized = {
        swap = { build = "farm_plant_eggplant_build", file = "swap_body", symboltype = "3" },
        fruit = "seeds_eggplant_l"
    },
    durian_oversized = {
        swap = { build = "farm_plant_durian_build", file = "swap_body", symboltype = "3" },
        fruit = "seeds_durian_l"
    },
    pomegranate_oversized = {
        swap = { build = "farm_plant_pomegranate_build", file = "swap_body", symboltype = "3" },
        fruit = "seeds_pomegranate_l"
    },
    dragonfruit_oversized = {
        swap = { build = "farm_plant_dragonfruit_build", file = "swap_body", symboltype = "3" },
        fruit = "seeds_dragonfruit_l"
    },
    watermelon_oversized = {
        swap = { build = "farm_plant_watermelon_build", file = "swap_body", symboltype = "3" },
        fruit = "seeds_watermelon_l"
    },
    pineananas_oversized = {
        swap = { build = "farm_plant_pineananas", file = "swap_body", symboltype = "3" },
        fruit = "seeds_pineananas_l"
    },
    onion_oversized = {
        swap = { build = "farm_plant_onion_build", file = "swap_body", symboltype = "3" },
        fruit = "seeds_onion_l"
    },
    pepper_oversized = {
        swap = { build = "farm_plant_pepper", file = "swap_body", symboltype = "3" },
        fruit = "seeds_pepper_l"
    },
    potato_oversized = {
        swap = { build = "farm_plant_potato", file = "swap_body", symboltype = "3" },
        fruit = "seeds_potato_l"
    },
    garlic_oversized = {
        swap = { build = "farm_plant_garlic", file = "swap_body", symboltype = "3" },
        fruit = "seeds_garlic_l"
    },
    tomato_oversized = {
        swap = { build = "farm_plant_tomato", file = "swap_body", symboltype = "3" },
        fruit = "seeds_tomato_l"
    },
    asparagus_oversized = {
        swap = { build = "farm_plant_asparagus", file = "swap_body", symboltype = "3" },
        fruit = "seeds_asparagus_l"
    },
    mandrake = {
        swap = { build = "siving_turn", file = "swap_mandrake", symboltype = "1" },
        fruit = "seeds_mandrake_l", time = 10*TUNING.TOTAL_DAY_TIME
    },
    gourd_oversized = {
        swap = { build = "farm_plant_gourd", file = "swap_body", symboltype = "3" },
        fruit = "seeds_gourd_l"
    }
}
for k,v in pairs(mapseeds) do
    _G.TRANS_DATA_LEGION[k] = v
end
mapseeds = nil

------放入与充能的动作
local GENETRANS = Action({ mount_valid=false, encumbered_valid=true })
GENETRANS.id = "GENETRANS"
GENETRANS.str = STRINGS.ACTIONS.GENETRANS
GENETRANS.strfn = function(act)
    if act.invobject ~= nil then
        if act.invobject.prefab == "siving_rocks" then
            return "CHARGE"
        end
    end
    return "GENERIC"
end
GENETRANS.fn = function(act)
    if act.target ~= nil and act.target.components.genetrans ~= nil and act.doer ~= nil then
        local material
        if
            act.doer.components.inventory ~= nil and act.doer.components.inventory:IsHeavyLifting() and
            not (act.doer.components.rider ~= nil and act.doer.components.rider:IsRiding())
        then
            material = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
        else
            material = act.invobject
        end
        if material ~= nil then
            if material.prefab == "siving_rocks" then
                return act.target.components.genetrans:Charge(material, act.doer)
            else
                return act.target.components.genetrans:SetUp(material, act.doer, false)
            end
        end
    end
end
AddAction(GENETRANS)

AddComponentAction("SCENE", "genetrans", function(inst, doer, actions, right)
    if
        right and
        (doer.replica.inventory ~= nil and doer.replica.inventory:IsHeavyLifting()) and
        not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding())
    then
        local item = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
        if item ~= nil then
            if TRANS_DATA_LEGION[item.prefab] ~= nil then
                table.insert(actions, ACTIONS.GENETRANS)
            end
        end
    end
end)

if not _G.rawget(_G, "CA_U_INVENTORYITEM_L") then --ComponentAction_USEITEM_inventoryitem_legion
    _G.CA_U_INVENTORYITEM_L = {}
end
table.insert(_G.CA_U_INVENTORYITEM_L, function(inst, doer, target, actions, right)
    if
        right and
        (inst.prefab == "siving_rocks" or TRANS_DATA_LEGION[inst.prefab] ~= nil) and
        target:HasTag("genetrans") and
        not (doer.replica.inventory ~= nil and doer.replica.inventory:IsHeavyLifting()) and
        not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding())
    then
        table.insert(actions, ACTIONS.GENETRANS)
        return true
    end
    return false
end)

local function FnSgGeneTrans(inst, action)
    if inst.replica.inventory ~= nil and inst.replica.inventory:IsHeavyLifting() then
        return "domediumaction"
    else
        return "give"
    end
end
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.GENETRANS, FnSgGeneTrans))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.GENETRANS, FnSgGeneTrans))

------修改采集动作的名称
local pick_strfn_old = ACTIONS.PICK.strfn
ACTIONS.PICK.strfn = function(act)
    if act.target ~= nil and act.target:HasTag("genetrans") then
        return "GENETRANS"
    end
    return pick_strfn_old(act)
end