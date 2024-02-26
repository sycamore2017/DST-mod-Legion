local prefabFiles = {
    "siving_rocks_legion",
    "farm_plants_legion",
    "cropgnat",
    "insectthings_l",
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
    Asset("ANIM", "anim/crop_legion_cactus.zip"), --异种动画，让子圭育提前用的
    Asset("ANIM", "anim/crop_legion_lureplant.zip"),
    Asset("ANIM", "anim/crop_legion_berries.zip"),
    Asset("ANIM", "anim/crop_legion_pine.zip"),
    Asset("ATLAS", "images/slot_juice_l.xml"), --巨食草的格子背景
    Asset("IMAGE", "images/slot_juice_l.tex"),

    Asset("ATLAS", "images/inventoryimages/siving_soil_item.xml"), --预加载，给科技栏用的
    Asset("IMAGE", "images/inventoryimages/siving_soil_item.tex"),
    Asset("ATLAS", "images/inventoryimages/ahandfulofwings.xml"),
    Asset("IMAGE", "images/inventoryimages/ahandfulofwings.tex"),
    Asset("ATLAS", "images/inventoryimages/insectshell_l.xml"),
    Asset("IMAGE", "images/inventoryimages/insectshell_l.tex"),
    Asset("ATLAS", "images/inventoryimages/boltwingout.xml"),
    Asset("IMAGE", "images/inventoryimages/boltwingout.tex"),
    Asset("ATLAS", "images/inventoryimages/siving_rocks.xml"), --mod之间注册相同的文件是有效的
    Asset("IMAGE", "images/inventoryimages/siving_rocks.tex"),
    Asset("ATLAS", "images/inventoryimages/siving_ctlwater_item.xml"),
    Asset("IMAGE", "images/inventoryimages/siving_ctlwater_item.tex"),
    Asset("ATLAS", "images/inventoryimages/siving_ctldirt_item.xml"),
    Asset("IMAGE", "images/inventoryimages/siving_ctldirt_item.tex"),
    Asset("ATLAS", "images/inventoryimages/siving_ctlall_item.xml"),
    Asset("IMAGE", "images/inventoryimages/siving_ctlall_item.tex"),
    Asset("ATLAS", "images/inventoryimages/fishhomingtool_normal.xml"),
    Asset("IMAGE", "images/inventoryimages/fishhomingtool_normal.tex"),
    Asset("ATLAS", "images/inventoryimages/fishhomingtool_awesome.xml"),
    Asset("IMAGE", "images/inventoryimages/fishhomingtool_awesome.tex"),
    Asset("ATLAS", "images/inventoryimages/siving_turn.xml"),
    Asset("IMAGE", "images/inventoryimages/siving_turn.tex"),
    Asset("ATLAS", "images/inventoryimages/siving_mask.xml"),
    Asset("IMAGE", "images/inventoryimages/siving_mask.tex"),
    Asset("ATLAS", "images/inventoryimages/siving_mask_gold.xml"),
    Asset("IMAGE", "images/inventoryimages/siving_mask_gold.tex"),
    Asset("ATLAS", "images/inventoryimages/siving_feather_real.xml"),
    Asset("IMAGE", "images/inventoryimages/siving_feather_real.tex"),
    Asset("ATLAS", "images/inventoryimages/siving_feather_fake.xml"),
    Asset("IMAGE", "images/inventoryimages/siving_feather_fake.tex"),
    Asset("ATLAS", "images/inventoryimages/hat_elepheetle.xml"),
    Asset("IMAGE", "images/inventoryimages/hat_elepheetle.tex"),
    Asset("ATLAS", "images/inventoryimages/armor_elepheetle.xml"),
    Asset("IMAGE", "images/inventoryimages/armor_elepheetle.tex"),
    Asset("ATLAS", "images/inventoryimages/carpet_plush_big.xml"),
    Asset("IMAGE", "images/inventoryimages/carpet_plush_big.tex"),
    Asset("ATLAS", "images/inventoryimages/carpet_plush.xml"),
    Asset("IMAGE", "images/inventoryimages/carpet_plush.tex"),
    Asset("ATLAS", "images/inventoryimages/siving_suit.xml"),
    Asset("IMAGE", "images/inventoryimages/siving_suit.tex"),
    Asset("ATLAS", "images/inventoryimages/siving_suit_gold.xml"),
    Asset("IMAGE", "images/inventoryimages/siving_suit_gold.tex"),
    Asset("ATLAS", "images/inventoryimages/ointment_l_sivbloodreduce.xml"),
    Asset("IMAGE", "images/inventoryimages/ointment_l_sivbloodreduce.tex")
}

for k,v in pairs(assets) do
    table.insert(Assets, v)
end

-----

local _G = GLOBAL
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()
local TOOLS_L = require("tools_legion")

--------------------------------------------------------------------------
--[[ 基础 ]]
--------------------------------------------------------------------------

_G.EQUIPMENTSETNAMES.SIVING = "siving"
_G.EQUIPMENTSETNAMES.SIVING2 = "siving2"
_G.EQUIPMENTSETNAMES.ELEPHEETLE = "elepheetle"

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
        Ingredient("ahandfulofwings", 40, "images/inventoryimages/ahandfulofwings.xml"),
        Ingredient("glommerwings", 1),
        Ingredient("stinger", 40),
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
AddRecipe2(
    "siving_mask", {
        Ingredient("siving_rocks", 12, "images/inventoryimages/siving_rocks.xml"),
        Ingredient("reviver", 2)
    }, TECH.LOST, {
        atlas = "images/inventoryimages/siving_mask.xml", image = "siving_mask.tex"
    }, { "ARMOUR", "RESTORATION" }
)
AddRecipe2(
    "siving_suit", {
        Ingredient("siving_rocks", 16, "images/inventoryimages/siving_rocks.xml"),
        Ingredient("yellowgem", 1)
    }, TECH.LOST, {
        atlas = "images/inventoryimages/siving_suit.xml", image = "siving_suit.tex"
    }, { "ARMOUR" }
)
AddRecipe2(
    "siving_feather_real", {
        Ingredient("siving_derivant_item", 1, "images/inventoryimages/siving_derivant_item.xml"),
        Ingredient("siving_feather_fake", 6, "images/inventoryimages/siving_feather_fake.xml"),
        Ingredient(CHARACTER_INGREDIENT.HEALTH, 30)
    }, TECH.LOST, {
        atlas = "images/inventoryimages/siving_feather_real.xml", image = "siving_feather_real.tex"
    }, { "WEAPONS" }
)
AddRecipe2(
    "ointment_l_sivbloodreduce", {
        Ingredient("succulent_picked", 1),
        Ingredient("green_cap", 3),
        Ingredient("spoiled_fish_small", 1),
        Ingredient("rock_avocado_fruit", 3, nil, nil, "rock_avocado_fruit_rockhard.tex") --石果的贴图和名字不一样
    }, TECH.SCIENCE_TWO, {
        numtogive = 4,
        atlas = "images/inventoryimages/ointment_l_sivbloodreduce.xml", image = "ointment_l_sivbloodreduce.tex"
    }, { "TOOLS", "RESTORATION" }
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
        cutlichen = { product = "cutlichen", produce = 4 },
        foliage = { product = "foliage", produce = 6 },
        albicans_cap = { product = "albicans_cap", produce = 4 }
    }

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
                    local max_produce = data.produce
                    local grow_time = TUNING.MUSHROOMFARM_FULL_GROW_TIME
                    local grower_skilltreeupdater = giver.components.skilltreeupdater
                    if grower_skilltreeupdater ~= nil then
                        if grower_skilltreeupdater:IsActivated("wormwood_mushroomplanter_upgrade") then
                            max_produce = 6
                        end
                        if grower_skilltreeupdater:IsActivated("wormwood_mushroomplanter_ratebonus2") then
                            grow_time = grow_time * TUNING.WORMWOOD_MUSHROOMPLANTER_RATEBONUS_2
                        elseif grower_skilltreeupdater:IsActivated("wormwood_mushroomplanter_ratebonus1") then
                            grow_time = grow_time * TUNING.WORMWOOD_MUSHROOMPLANTER_RATEBONUS_1
                        end
                    end

                    if item.prefab == "foliage" then
                        farm.AnimState:OverrideSymbol(
                            "swap_mushroom",
                            TheWorld:HasTag("cave") and "mushroom_farm_foliage2_build" or "mushroom_farm_foliage1_build",
                            "swap_mushroom"
                        )
                    else
                        farm.AnimState:OverrideSymbol("swap_mushroom", "mushroom_farm_"..data.product.."_build", "swap_mushroom")
                    end
                    farm.components.harvestable:SetProduct(data.product, max_produce)
                    farm.components.harvestable:SetGrowTime(grow_time/max_produce)
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

--还有 VEGGIES 的种子设定，已经写在modmain里

--新增作物植株设定（会自动生成对应prefab）
local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS
PLANT_DEFS.pineananas = {
    --贴图与动画
    build = "farm_plant_pineananas", bank = "farm_plant_pineananas",
    --生长时间
    grow_time = PLANT_DEFS.dragonfruit.grow_time,
    --需水量：低
    moisture = PLANT_DEFS.carrot.moisture,
    --喜好季节
    good_seasons = { autumn = true, summer = true },
    --需肥类型
	nutrient_consumption = { TUNING.FARM_PLANT_CONSUME_NUTRIENT_LOW, 0, TUNING.FARM_PLANT_CONSUME_NUTRIENT_LOW },
	--会生成的肥料
	nutrient_restoration = { nil, true, nil },
    --扫兴容忍度：0
	max_killjoys_tolerance = TUNING.FARM_PLANT_KILLJOY_TOLERANCE,
    --是否随机种子
    is_randomseed = false,
    --是否防火
    fireproof = false,
    --重量范围
    weight_data	= { 422.22, 700.22, 0.93 },
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
	--家族标签
	plant_type_tag = "farm_plant_pineananas",
    --巨型产物腐烂后的收获物
    loot_oversized_rot = { "spoiled_food", "spoiled_food", "spoiled_food", "pineananas_seeds",
        "fruitfly", "fruitfly", "pinecone" },
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
    --生长状态(hidden 表示这个阶段不显示)
    plantregistryinfo = PLANT_DEFS.pepper.plantregistryinfo
}

--------------------------------------------------------------------------
--[[ 添加新动作：让种子能种在 子圭·垄 和 异种植物 里 ]]
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

        local plant_prefab = nil
        if seed.prefab == "medal_weed_seeds" then --【能力勋章】杂草种子
            local weedtable = { --勋章里的权重和官方设置不一样，不然我就直接用 weighted_seed_table 了
                weed_forgetmelots = 2, --必忘我
                weed_tillweed = 1, --犁地草
                weed_firenettle = 1, --火荨麻
                weed_ivy = 1 --刺针旋花
            }
            plant_prefab = weighted_random_choice(weedtable)
        else
            plant_prefab = FunctionOrValue(seed.components.farmplantable.plant, seed)
            if plant_prefab == "farm_plant_randomseed" then
                plant_prefab = PickFarmPlant()
            end
        end

        if --【能力勋章】能否种植其中作物
            not _G.CONFIGS_LEGION.SIVSOLTOMEDAL and (
                seed.prefab == "immortal_fruit_seed" or
                seed.prefab == "medal_gift_fruit_seed" or
                plant_prefab == "farm_plant_immortal_fruit" or
                plant_prefab == "farm_plant_medal_gift_fruit"
            )
        then
            return false
        end

        local plant = SpawnPrefab(plant_prefab.."_legion")
        if plant ~= nil then
            plant.Transform:SetPosition(pt:Get())
            -- plant:PushEvent("on_planted", { doer = doer, seed = seed, in_soil = true })
            if plant.SoundEmitter ~= nil then
				plant.SoundEmitter:PlaySound("dontstarve/common/plant")
			end
            TheWorld:PushEvent("itemplanted", { doer = doer, pos = pt })

            --继承皮肤
            if soilorcrop.components.skinedlegion ~= nil and soilorcrop.components.skinedlegion:GetSkin() ~= nil then
                plant.components.skinedlegion:SetSkin(soilorcrop.components.skinedlegion:GetSkin(),
                    soilorcrop.components.skinedlegion.userid or (doer and doer.userid or nil))
            end

            --替换原本的作物
            if soilorcrop.components.perennialcrop ~= nil then
                plant.components.perennialcrop:DisplayCrop(soilorcrop, doer)
            end

            soilorcrop:Remove()
            seed:Remove()

            if plant.fn_planted ~= nil then
                plant.fn_planted(plant, pt)
            end

            return true
        end
    end
    return false
end

local PLANTSOIL_LEGION = Action({ theme_music = "farming", priority = 3 })
PLANTSOIL_LEGION.id = "PLANTSOIL_LEGION"
PLANTSOIL_LEGION.str = STRINGS.ACTIONS.PLANTSOIL_LEGION
PLANTSOIL_LEGION.strfn = function(act)
    if act.target ~= nil then
        if act.target:HasTag("crop_legion") then
            return "DISPLAY"
        elseif act.target:HasTag("crop2_legion") then
            return "CLUSTERED"
        end
    end
    return "GENERIC"
end
PLANTSOIL_LEGION.fn = function(act)
    if
        act.invobject ~= nil and
        act.doer.components.inventory ~= nil and
        act.target ~= nil and act.target:IsValid()
    then
        if act.target:HasTag("soil_legion") or act.target.components.perennialcrop ~= nil then
            local seed = act.doer.components.inventory:RemoveItem(act.invobject)
            if seed ~= nil then
                if OnPlant(seed, act.doer, act.target) then
                    return true
                end
                act.doer.components.inventory:GiveItem(seed)
            end
        elseif act.target.components.perennialcrop2 ~= nil then
            return act.target.components.perennialcrop2:ClusteredPlant(act.invobject, act.doer)
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
    if right and target:HasTag("crop2_legion") and not target:HasTag("NOCLICK") then
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
            end, nil, { "INLIMBO", "NOCLICK" }, { "crop_legion", "crop2_legion" })

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
                    not (self.validplantfn == nil or self.validplantfn(self.inst, plant))
                then
                    self.inst.planttarget = nil
                    self.status = FAILED
                elseif not cropcpt:Tendable(self.inst, self.wantsstressed) then
                    self.inst.planttarget = nil
                    self.status = SUCCESS
                end
            else
                self.inst.planttarget = nil
                self.status = FAILED
            end
            return
        end
        Visit_old(self, ...)
    end

end

--------------------------------------------------------------------------
--[[ 脱壳之翅的sg ]]
--------------------------------------------------------------------------

AddStategraphState("wilson", State{
    name = "boltout",
    tags = { "busy", "doing", "nointerrupt", "canrotate", "boltout" },
    onenter = function(inst, data)
        if data == nil or data.escapepos == nil then
            inst.sg:GoToState("idle", true)
            return
        end

        TOOLS_L.ForceStopHeavyLifting(inst) --虽然目前的触发条件并不可能有背着重物的情况，因为本身就是背包的功能，但是为了兼容性...
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
    end
})
AddStategraphState("wilson", State{
    name = "boltout_pst",
    -- tags = {"evade","no_stun"},
    onenter = function(inst)
        inst.AnimState:PlayAnimation("slide_pst")
    end,
    events = {
        EventHandler("animover", function(inst)
            inst.sg:GoToState("idle")
        end )
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
    cutgrass =              { dusty=1, pasty=1, veggie=0.5 }, --采下的草
    twigs =                 { pasty=1, hardy=1, veggie=0.5 }, --树枝
    log =                   { hardy=1, veggie=0.5 }, --木头
    rocks =                 { hardy=1 }, --石头
    flint =                 { dusty=1, hardy=1 }, --燧石
    ice =                   { pasty=1, hardy=1 }, --冰
    ash =                   { dusty=1 }, --灰烬
    silk =                  { pasty=1 }, --蜘蛛丝
    beefalowool =           { dusty=1 }, --牛毛
    spoiled_food =          { pasty=1, rotten=0.5 }, --腐烂物(龙虾)
    poop =                  { pasty=1, rotten=1 }, --粪肥(龙虾)
    stinger =               { dusty=1, frizzy=0.5 }, --蜂刺(海鹦鹉)
    goldnugget =            { hardy=1, lucky=1, shiny=0.5 }, --金块(金锦鲤、花锦鲤、鱿鱼)
    lucky_goldnugget =      { hardy=1, lucky=1, shiny=0.5 }, --幸运黄金(金锦鲤、花锦鲤、鱿鱼)
    livinglog =             { pasty=1, hardy=1, veggie=1 }, --活木头
    cutreeds =              { pasty=1, hardy=1, veggie=0.5 }, --采下的芦苇
    redgem =                { hardy=1, hot=1 }, --红宝石(炽热太阳鱼)
    bluegem =               { hardy=1, frozen=1 }, --蓝宝石(冰鲷鱼)
    purplegem =             { hardy=1, hot=0.5, frozen=0.5 }, --紫宝石(炽热太阳鱼、冰鲷鱼)
    orangegem =             { hardy=1 }, --橙宝石
    yellowgem =             { hardy=1, shiny=1 }, --黄宝石(鱿鱼)
    greengem =              { hardy=1 }, --绿宝石
    opalpreciousgem =       { hardy=1, shiny=1, rusty=1 }, --彩虹宝石(鱿鱼、月光龙虾)
    moonglass =             { dusty=1, hardy=1, rusty=1 }, --月亮碎片(月光龙虾)
    moonglass_charged =     { hardy=1, rusty=1, shiny=0.5 }, --注能月亮碎片(月光龙虾、鱿鱼)
    moonrocknugget =        { hardy=1, rusty=1 }, --月岩(月光龙虾)
    moonstorm_spark =       { shiny=1, rusty=1 }, --月熠(鱿鱼、月光龙虾)
    marble =                { hardy=1 }, --大理石
    houndstooth =           { hardy=1, bloody=0.5 }, --犬牙
    nitre =                 { dusty=1, hardy=1, salty=0.5 }, --硝石(饼干切割机)
    saltrock =              { dusty=1, salty=1 }, --盐晶(饼干切割机)
    spidergland =           { pasty=1, monster=1 }, --蜘蛛腺
    siving_rocks =          { pasty=1, hardy=1 }, --子圭石
    feather_crow =          { dusty=1 }, --黑色羽毛
    feather_robin =         { dusty=1, hot=0.5 }, --红色羽毛(炽热太阳鱼)
    feather_robin_winter =  { pasty=1, frozen=0.5 }, --蓝色羽毛(冰鲷鱼)
    feather_canary =        { hardy=1, shiny=0.5 }, --黄色羽毛(鱿鱼)
    beardhair =             { dusty=1 }, --胡须
    charcoal =              { dusty=1, hardy=1, hot=0.5 }, --木炭(炽热太阳鱼)
    phlegm =                { pasty=1, slippery=1 }, --脓鼻涕(口水鱼)
    slurtleslime =          { pasty=1, slippery=1 }, --蛞蝓龟黏液(口水鱼)
    nightmarefuel =         { whispering=0.5 }, --噩梦燃料(一角鲸)
    horn =                  { hardy=1, whispering=1, lucky=0.5 }, --牛角(一角鲸、金锦鲤、花锦鲤)
    gnarwail_horn =         { hardy=1, whispering=1 }, --一角鲸的角(一角鲸)
    lightninggoathorn =     { hardy=1 }, --伏特羊角
    coontail =              { dusty=1, pasty=1, meat=0.5 }, --猫尾
    tentaclespots =         { pasty=1, meat=0.5, monster=1 }, --触手皮
    tentaclespike =         { pasty=2, hardy=2, meat=1, monster=2 }, --触手尖刺
    pigskin =               { pasty=1, meat=0.5 }, --猪皮
    manrabbit_tail =        { dusty=1, pasty=1, meat=0.5 }, --兔绒
    gears =                 { hardy=1 }, --齿轮
    purebrilliance =        { hardy=1, shiny=0.5, rusty=0.5 }, --纯粹辉煌(鱿鱼、月光龙虾)
    lunarplant_husk =       { pasty=1, hardy=1, veggie=0.5 }, --亮茄外壳
    voidcloth =             { dusty=1, pasty=1 }, --暗影碎布
    dreadstone =            { dusty=1, hardy=1, monster=1, whispering=0.5 }, --绝望石(一角鲸)
    horrorfuel =            { monster=1, whispering=1 }, --纯粹恐惧(一角鲸)
    cookiecuttershell =     { dusty=1, hardy=1, salty=1 }, --饼干切割机壳(饼干切割机)
    slurtle_shellpieces =   { hardy=1 }, --外壳碎片
    slurper_pelt =          { pasty=1, meat=0.5 }, --啜食者皮
    townportaltalisman =    { dusty=1, pasty=1, hardy=1 }, --沙之石
    driftwood_log =         { pasty=1, hardy=1, veggie=0.5 }, --浮木桩
    blackflag =             { hardy=1 }, --黑旗
    thulecite_pieces =      { hardy=1 }, --铥矿碎片
    messagebottleempty =    { dusty=1, hardy=1 }, --空瓶子
    messagebottle =         { dusty=1, pasty=1, hardy=1 }, --瓶中信
    carnival_prizeticket =  { dusty=1, pasty=1 }, --奖票
    wintersfeastfuel =      { rotten=0.5 }, --节日欢愉(龙虾)
    boneshard =             { hardy=1 }, --骨头碎片
    walrus_tusk =           { hardy=1 }, --海象牙
    walrushat =             { dusty=1, pasty=1 }, --贝雷帽
    waterplant_bomb =       { hardy=1, veggie=0.5 }, --种壳
    tourmalinecore =        { hardy=1, shiny=0.5 }, --电气石(鱿鱼)
    tourmalineshard =       { dusty=1, hardy=1 }, --带电的晶石
    fimbul_axe =            { hardy=1 }, --芬布尔斧
    scandata =              { pasty=1 }, --生物数据
    firepen =               { hardy=1, hot=1 }, --火焰笔(炽热太阳鱼)
    canary_poisoned =       { pasty=1, hardy=1, meat=1, shiny=0.5 }, --中毒金丝雀(鱿鱼)
    crow =                  { pasty=1, meat=1 }, --乌鸦
    puffin =                { pasty=1, meat=1 }, --海鹦鹉
    robin =                 { dusty=1, meat=1, hot=0.5 }, --红雀(炽热太阳鱼)
    robin_winter =          { pasty=1, meat=1, frozen=0.5 }, --雪雀(冰鲷鱼)
    canary =                { hardy=1, meat=1, shiny=1 }, --金丝雀(鱿鱼)
    bird_mutant =           { dusty=1, meat=1, rusty=0.5, rotten=0.5 }, --月盲乌鸦(月光龙虾、龙虾)
    bird_mutant_spitter =   { pasty=1, meat=1, rusty=0.5, rotten=0.5 }, --奇形鸟(月光龙虾、龙虾)
    rabbit =                { pasty=1, hardy=1, meat=1 }, --兔子
    lightbulb =             { dusty=1, pasty=1, veggie=0.5, shiny=1 }, --荧光果(鱿鱼)
    lightcrab =             { pasty=1, hardy=1, meat=1, shiny=1 }, --发光蟹(鱿鱼)
    fig =                   { pasty=1, veggie=1, sticky=1, grassy=0.5 }, --无花果(甜味鱼、草鳄鱼)
    fig_cooked =            { pasty=1, veggie=1, sticky=1 }, --烤无花果(甜味鱼)
    kelp =                  { pasty=1, veggie=1 }, --海带叶
    kelp_cooked =           { pasty=1, veggie=1 }, --熟海带叶
    kelp_dried =            { dusty=1, pasty=1, veggie=1, wrinkled=1 }, --干海带叶(落叶比目鱼)
    rock_avocado_fruit =    { hardy=1, veggie=1 }, --石果
    rock_avocado_fruit_ripe={ pasty=1, hardy=1, veggie=1, grassy=1 }, --成熟石果(草鳄鱼)
    rock_avocado_fruit_ripe_cooked={ pasty=1, veggie=1 }, --熟石果
    rock_avocado_fruit_sprout={ pasty=1, hardy=1, veggie=1, grassy=1 }, --发芽的石果(草鳄鱼)
    cactus_meat =           { pasty=1, veggie=1, grassy=1 }, --仙人掌肉(草鳄鱼)
    cactus_meat_cooked =    { pasty=1, veggie=1 }, --熟仙人掌肉
    petals_rose =           { pasty=1, veggie=1, fragrant=1 }, --蔷薇花瓣(花朵金枪鱼)
    petals_lily =           { pasty=1, veggie=1, fragrant=1 }, --蹄莲花瓣(花朵金枪鱼)
    petals_orchid =         { pasty=1, veggie=1, fragrant=1 }, --兰草花瓣(花朵金枪鱼)
    forgetmelots =          { veggie=0.5, fragrant=1 }, --必忘我(花朵金枪鱼)
    myth_lotus_flower =     { pasty=1, veggie=1, fragrant=1 }, --莲花(花朵金枪鱼)
    moon_tree_blossom =     { pasty=1, veggie=0.5, fragrant=1 }, --月树花(花朵金枪鱼)
    petals_evil =           { veggie=0.5, monster=1, evil=0.5 }, --深色花瓣(邪天翁)
    cutted_rosebush =       { pasty=1, hardy=1, veggie=0.5, grassy=0.5 }, --蔷薇折枝(草鳄鱼)
    cutted_lilybush =       { pasty=1, veggie=0.5, grassy=0.5 }, --蹄莲芽束(草鳄鱼)
    cutted_orchidbush =     { dusty=1, pasty=1, veggie=0.5, wrinkled=0.5, grassy=0.5 }, --兰草种籽(落叶比目鱼、草鳄鱼)
    dug_monstrain =         { pasty=1, hardy=1, veggie=0.5, monster=1 }, --雨竹块茎
    squamousfruit =         { pasty=1, hardy=1, veggie=0.5, monster=1 }, --鳞果
    monstrain_leaf =        { pasty=1, veggie=1, monster=2 }, --雨竹叶
    dragonfruit =           { pasty=1, veggie=1, hot=0.5 }, --火龙果(炽热太阳鱼)
    dragonfruit_cooked =    { pasty=1, veggie=1, hot=0.5 }, --熟火龙果(炽热太阳鱼)
    pepper =                { pasty=1, veggie=1, hot=0.5 }, --辣椒(炽热太阳鱼)
    pepper_cooked =         { dusty=1, pasty=1, veggie=1, hot=0.5 }, --烤辣椒(炽热太阳鱼)
    durian =                { pasty=1, hardy=1, veggie=1, monster=2, rotten=0.5 }, --榴莲(龙虾)
    durian_cooked =         { pasty=1, hardy=1, veggie=1, monster=2, rotten=0.5 }, --超臭榴莲(龙虾)
    pomegranate =           { pasty=1, hardy=1, veggie=1, bloody=0.5 }, --石榴(岩石大白鲨)
    pomegranate_cooked =    { pasty=1, hardy=1, veggie=1, bloody=0.5 }, --切片熟石榴(岩石大白鲨)
    watermelon =            { pasty=1, veggie=1, grassy=0.5 }, --西瓜(草鳄鱼)
    watermelon_cooked =     { pasty=1, veggie=1 }, --烤西瓜
    corn =                  { pasty=1, hardy=1, veggie=1 }, --玉米
    corn_cooked =           { pasty=1, hardy=1, veggie=1, comical=1 }, --爆米花(爆米花鱼、玉米鳕鱼)
    twiggy_nut =            { hardy=1, veggie=0.5 }, --多枝树种
    acorn =                 { hardy=1, veggie=0.5, grassy=0.5 }, --桦栗果(草鳄鱼)
    acorn_cooked =          { pasty=1, veggie=0.5 }, --烤桦栗果
    pinecone =              { dusty=1, hardy=1, veggie=0.5 }, --松果
    palmcone_seed =         { dusty=1, veggie=0.5 }, --棕榈松果树芽
    palmcone_scale =        { dusty=1, pasty=1, veggie=0.5 }, --棕榈松果树鳞片
    dug_rosebush =          { pasty=1, hardy=1, veggie=0.5 }, --蔷薇花丛
    dug_lilybush =          { pasty=1, veggie=0.5 }, --蹄莲花丛
    dug_orchidbush =        { dusty=1, pasty=1, veggie=0.5 }, --兰草花丛
    dug_berrybush =         { pasty=1, hardy=1, veggie=0.5 }, --浆果丛
    dug_berrybush2 =        { pasty=1, veggie=0.5 }, --特殊浆果丛
    dug_berrybush_juicy =   { pasty=1, veggie=0.5 }, --多汁浆果丛
    dug_grass =             { dusty=1, pasty=1, veggie=0.5 }, --草丛
    dug_marsh_bush =        { pasty=1, hardy=1, veggie=0.5 }, --尖刺灌木
    dug_monkeytail =        { pasty=1, hardy=1, veggie=0.5 }, --猴尾草
    dug_bananabush =        { pasty=1, veggie=0.5 }, --香蕉丛
    dug_rock_avocado_bush = { pasty=1, hardy=1, veggie=0.5 }, --石果灌木丛
    dug_sapling =           { pasty=1, hardy=1, veggie=0.5 }, --树苗
    dug_sapling_moon =      { pasty=1, hardy=1, veggie=0.5, rusty=0.5 }, --月岛树苗(月光龙虾)
    dug_trap_starfish =     { pasty=1, hardy=1, meat=0.5 }, --海星陷阱
    spore_small =           { shiny=1 }, --绿色孢子(鱿鱼)
    spore_medium =          { shiny=1 }, --红色孢子(鱿鱼)
    spore_tall =            { shiny=1 }, --蓝色孢子(鱿鱼)
    spore_moon =            { shiny=1, rusty=0.5 }, --月亮孢子(鱿鱼、月光龙虾)
    bird_egg =              { dusty=1, pasty=1, meat=0.5, slippery=1 }, --鸟蛋(口水鱼)
    bird_egg_cooked =       { dusty=1, pasty=1, meat=0.5 }, --熟鸟蛋
    egg =                   { dusty=1, pasty=1, meat=0.5, slippery=1 }, --蛋(口水鱼)
    egg_cooked =            { dusty=1, pasty=1, meat=0.5 }, --熟蛋
    tallbirdegg =           { pasty=1, hardy=1, meat=1, slippery=5 }, --高脚鸟蛋(口水鱼)
    tallbirdegg_cracked =   { pasty=1, hardy=1, meat=1, slippery=5 }, --孵化中的高脚鸟蛋(口水鱼)
    tallbirdegg_cooked =    { dusty=1, pasty=1, meat=1 }, --煎高脚鸟蛋
    batwing =               { pasty=1, meat=1, monster=1, whispering=0.5 }, --洞穴蝙蝠翅膀(一角鲸)
    batwing_cooked =        { pasty=1, meat=1, monster=1 }, --熟蝙蝠翅膀
    meat =                  { pasty=1, meat=1, bloody=1 }, --肉(岩石大白鲨)
    cookedmeat =            { pasty=1, meat=1 }, --熟肉
    meat_dried =            { hardy=1, meat=1, wrinkled=1 }, --肉干(落叶比目鱼)
    monstermeat =           { pasty=1, hardy=1, meat=1, monster=2, bloody=1 }, --怪物肉(岩石大白鲨)
    cookedmonstermeat =     { pasty=1, hardy=1, meat=1, monster=2 }, --熟怪物肉
    monstermeat_dried =     { hardy=1, meat=1, monster=2, wrinkled=1 }, --怪物肉干(落叶比目鱼)
    smallmeat =             { pasty=1, meat=1 }, --小肉
    cookedsmallmeat =       { pasty=1, meat=1 }, --熟小肉
    smallmeat_dried =       { hardy=1, meat=1, wrinkled=1 }, --小风干肉(落叶比目鱼)
    dish_duriantartare =    { pasty=2, meat=2, monster=4, bloody=2 }, --怪味鞑靼(岩石大白鲨)
    monstertartare =        { pasty=2, meat=2, monster=4, bloody=2 }, --怪物鞑靼(岩石大白鲨)
    shroom_skin =           { pasty=5, meat=2, monster=5, rotten=4, evil=5 }, --蘑菇皮(龙虾、邪天翁)
    compost =               { pasty=1, veggie=0.5, rotten=1 }, --堆肥(龙虾)
    spoiled_fish =          { pasty=1, hardy=1, meat=0.5, rotten=1 }, --变质的鱼(龙虾)
    spoiled_fish_small =    { pasty=1, hardy=1, meat=0.5, rotten=1 }, --变质的小鱼块(龙虾)
    guano =                 { dusty=1, rotten=1, salty=0.5 }, --鸟粪(龙虾、饼干切割机)
    rottenegg =             { pasty=1, hardy=1, rotten=1, slippery=1 }, --腐烂鸟蛋(龙虾、口水鱼)
    lightflier =            { dusty=1, pasty=1, meat=0.5, shiny=1, shaking=1 }, --球状光虫(鱿鱼、海黾)
    dragon_scales =         { hardy=5, hot=5, evil=5 }, --鳞片(炽热太阳鱼、邪天翁)
    lavae_egg =             { hardy=4, meat=4, hot=4, evil=4, frizzy=2 }, --岩浆虫卵(炽热太阳鱼、邪天翁、海鹦鹉)
    lavae_egg_cracked =     { hardy=4, meat=4, hot=5, evil=5, frizzy=2 }, --岩浆虫卵(炽热太阳鱼、邪天翁、海鹦鹉)
    lavae_cocoon =          { dusty=4, hardy=4, meat=2, evil=2, frizzy=2 }, --冷冻虫卵(邪天翁、海鹦鹉)
    honey =                 { pasty=1, sticky=1 }, --蜂蜜(甜味鱼)
    royal_jelly =           { pasty=1, sticky=5 }, --蜂王浆(甜味鱼)
    honeycomb =             { dusty=1, pasty=1, sticky=5 }, --蜂巢(甜味鱼)
    beeswax =               { dusty=1, hardy=1, sticky=5, wrinkled=0.5 }, --蜂蜡(甜味鱼、落叶比目鱼)
    butter =                { pasty=1, sticky=1 }, --黄油(甜味鱼)
    butterfly =             { dusty=1, meat=0.5, shaking=1 }, --蝴蝶(海黾)
    butterflywings =        { dusty=1, shaking=0.5 }, --蝴蝶翅膀(海黾)
    moonbutterfly =         { pasty=1, meat=0.5, shaking=1, frizzy=0.5, rusty=0.5 }, --月蛾(海黾、海鹦鹉、月光龙虾)
    moonbutterflywings =    { dusty=1, pasty=1, shaking=0.5, rusty=0.5 }, --月蛾翅膀(海黾、月光龙虾)
    wormlight =             { pasty=1, veggie=1, shiny=1, frizzy=0.5 }, --发光浆果(鱿鱼、海鹦鹉)
    wormlight_lesser =      { pasty=1, veggie=1, shiny=0.5, frizzy=0.5 }, --小发光浆果(鱿鱼、海鹦鹉)
    fireflies =             { dusty=1, meat=0.5, shaking=1, shiny=0.5 }, --萤火虫(海黾、鱿鱼)
    bee =                   { dusty=1, meat=0.5, shaking=1, frizzy=0.5 }, --蜜蜂(海黾、海鹦鹉)
    killerbee =             { dusty=1, pasty=1, meat=0.5, shaking=1 }, --杀人蜂(海黾)
    mosquitosack =          { pasty=1, bloody=1, frizzy=0.5 }, --蚊子血囊(岩石大白鲨、海鹦鹉)
    mosquito =              { pasty=1, meat=0.5, shaking=1, bloody=0.5 }, --蚊子(海黾、岩石大白鲨)
    raindonate =            { pasty=1, meat=0.5, shaking=1 }, --雨蝇(海黾)
    ahandfulofwings =       { dusty=1, pasty=1, shaking=0.5 }, --虫翅碎片(海黾)
    insectshell_l =         { dusty=1, hardy=1, frizzy=0.5 }, --虫甲碎片(海鹦鹉)
    glommerfuel =           { pasty=1, whispering=1, frizzy=0.5 }, --格罗姆的黏液(一角鲸、海鹦鹉)
    glommerwings =          { dusty=1, whispering=1, shaking=1 }, --格罗姆翅膀(一角鲸、海黾)
    glommerflower =         { pasty=5, whispering=5 }, --格罗姆花(一角鲸)
    fruitflyfruit =         { pasty=5, shaking=5, wrinkled=2 }, --友好果蝇果(海黾、落叶比目鱼)
    minotaurhorn =          { hardy=5, meat=2, evil=5 }, --守护者之角(邪天翁)
    malbatross_feather =    { pasty=2, hardy=2, evil=2 }, --邪天翁羽毛(邪天翁)
    malbatross_beak =       { hardy=5, evil=5 }, --邪天翁喙(邪天翁)
    deerclops_eyeball =     { pasty=5, meat=5, monster=6, evil=5, frozen=2 }, --独眼巨鹿眼球(邪天翁、冰鲷鱼)
    bearger_fur =           { pasty=5, monster=5, evil=5 }, --熊皮(邪天翁)
    furtuft =               { dusty=1, evil=0.5 }, --毛丛(邪天翁)
    goose_feather =         { dusty=2, evil=2 }, --麋鹿鹅羽毛(邪天翁)
    milkywhites =           { pasty=2, monster=2, evil=2, sticky=1 }, --乳白物(邪天翁、甜味鱼)
    -- xx =             { dusty=1, pasty=1, hardy=1 }, --
}
for name,data in pairs(fishhoming_ingredients) do
    _G.FISHHOMING_INGREDIENTS_L[name] = data
end
fishhoming_ingredients = nil

--冬季盛宴小食物
local basefactors = { hardy=1, pasty=1, dusty=1, veggie=1, meat=1, monster=1 }
for k = 1, _G.NUM_WINTERFOOD do
    _G.FISHHOMING_INGREDIENTS_L["winter_food"..tostring(k)] = basefactors
end
--爆米花鱼、玉米鳕鱼
basefactors = { hardy=1, pasty=1, dusty=1, comical=1 }
for k = 1, _G.NUM_TRINKETS do
    _G.FISHHOMING_INGREDIENTS_L["trinket_"..tostring(k)] = basefactors
end
basefactors = { hardy=1, pasty=1, dusty=1, monster=1, comical=1 }
for k = 1, _G.NUM_HALLOWEEN_ORNAMENTS do
    _G.FISHHOMING_INGREDIENTS_L["halloween_ornament_"..tostring(k)] = basefactors
end
basefactors = nil

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
--[[ 异种植物 ]]
--------------------------------------------------------------------------

--[[ hey, Tosh! See here! ]]--
if not _G.rawget(_G, "CROPS_DATA_LEGION") then --对于global来说，不能直接检测是否有某个元素，需要用rawget才行
    _G.CROPS_DATA_LEGION = {}
end

-- local time_annual = 20*TUNING.TOTAL_DAY_TIME
-- local time_years = 25 * TUNING.TOTAL_DAY_TIME
local xmult = _G.CONFIGS_LEGION.X_GROWTHTIME or 1
local time_grow = TUNING.TOTAL_DAY_TIME*xmult
local time_crop = 12*TUNING.TOTAL_DAY_TIME*xmult --普通作物一般是5天生长期
local time_day1 = TUNING.TOTAL_DAY_TIME*xmult
local time_day2 = TUNING.TOTAL_DAY_TIME*(_G.CONFIGS_LEGION.X_OVERRIPETIME or 1)
xmult = nil

_G.CROPS_DATA_LEGION.carrot = {
    growthmults = { 1.2, 0.8, 1.2, 0.5 }, --春x秋冬。大于1为快，小于1为慢
    regrowstage = 1, --重新生长的阶段
    -- cangrowindrak = true, --能否在黑暗中生长(默认不能)
    -- getsickchance = 0.007, --害虫产生率
    -- fireproof = false, --是否防火
    -- nomagicgrow = true, --是否禁止被魔法催熟
    -- dataonly = true, --是否不用通用预制物代码
    bank = "crop_legion_carrot", build = "crop_legion_carrot",
    leveldata = {
        { anim = "level1", time = time_crop*0.45, deadanim = "dead1", witheredprefab = nil },
        { anim = "level2", time = time_crop*0.55, deadanim = "dead1", witheredprefab = {"cutgrass"} },
        { anim = { "level3_1", "level3_2", "level3_3" }, time = time_day2*6, deadanim = "dead1", witheredprefab = {"cutgrass"} }
    },
    cluster_size = { 1, 1.5 },
    fn_loot = function(self, doer, ispicked, isburnt, loots)
        if self.stage == self.stage_max then
            self:GetBaseLoot(loots, {
                doer = doer, ispicked = ispicked, isburnt = isburnt,
                crop = self.cropprefab, crop_rot = "spoiled_food",
                lootothers = nil
            })
            if self.cluster >= 50 then
                self:AddLoot(loots, "lance_carrot_l", 1)
            end
        end
    end
}
_G.CROPS_DATA_LEGION.corn = {
    growthmults = { 1.2, 1.2, 1.2, 0 }, --春夏秋x
    regrowstage = 2,
    bank = "plant_normal_legion", build = "plant_normal_legion",
    leveldata = {
        { anim = "level3_corn", time = time_grow,      deadanim = "dead123_corn", witheredprefab = nil },
        { anim = "level4_corn", time = time_crop*0.45, deadanim = "dead456_corn", witheredprefab = {"twigs"} },
        { anim = "level5_corn", time = time_crop*0.55, deadanim = "dead456_corn", witheredprefab = {"twigs"}, bloom = true },
        { anim = { "level6_corn_1", "level6_corn_2", "level6_corn_3" }, time = time_day2*6, deadanim = "dead456_corn", witheredprefab = {"twigs", "twigs"} }
    }
}
_G.CROPS_DATA_LEGION.pumpkin = {
    growthmults = { 0.8, 0.8, 1.2, 0.5 }, --xx秋冬
    regrowstage = 2,
    bank = "plant_normal_legion", build = "plant_normal_legion",
    leveldata = {
        { anim = "level3_pumpkin", time = time_grow,      deadanim = "dead123_pumpkin", witheredprefab = nil },
        { anim = "level4_pumpkin", time = time_crop*0.45, deadanim = "dead456_pumpkin", witheredprefab = {"cutgrass"} },
        { anim = "level5_pumpkin", time = time_crop*0.55, deadanim = "dead456_pumpkin", witheredprefab = {"cutgrass", "cutgrass"}, bloom = true },
        { anim = { "level6_pumpkin_1", "level6_pumpkin_2", "level6_pumpkin_3" }, time = time_day2*6, deadanim = "dead456_pumpkin", witheredprefab = {"cutgrass", "rope"} }
    },
    cluster_size = { 1, 1.5 }
}
_G.CROPS_DATA_LEGION.eggplant = {
    growthmults = { 1.2, 0.8, 1.2, 0 }, --春x秋x
    regrowstage = 2,
    bank = "crop_legion_eggplant", build = "crop_legion_eggplant",
    leveldata = {
        { anim = "level3", time = time_grow,      deadanim = "dead1", witheredprefab = nil },
        { anim = "level4", time = time_crop*0.45, deadanim = "dead2", witheredprefab = {"cutgrass"} },
        { anim = "level5", time = time_crop*0.55, deadanim = "dead2", witheredprefab = {"rope"}, bloom = true },
        { anim = { "level6_1", "level6_2", "level6_3" }, time = time_day2*6, deadanim = "dead2", witheredprefab = {"rope", "bird_egg"} }
    },
    lootothers = {
        { israndom=true, factor=0.4, name="bird_egg", name_rot="rottenegg" },
        { israndom=false, factor=0.2, name="bird_egg", name_rot="rottenegg" }
    }
}
_G.CROPS_DATA_LEGION.durian = {
    growthmults = { 1.2, 0.8, 0.8, 0 }, --春xxx
    regrowstage = 2,
    bank = "plant_normal_legion", build = "plant_normal_legion",
    leveldata = {
        { anim = "level3_durian", time = time_grow,      deadanim = "dead123_durian", witheredprefab = nil },
        { anim = "level4_durian", time = time_crop*0.45, deadanim = "dead456_durian", witheredprefab = {"log"} },
        { anim = "level5_durian", time = time_crop*0.55, deadanim = "dead456_durian", witheredprefab = {"livinglog"}, bloom = true },
        { anim = { "level6_durian_1", "level6_durian_2", "level6_durian_3" }, time = time_day2*6, deadanim = "dead456_durian", witheredprefab = {"livinglog", "log"} }
    },
    lootothers = {
        { israndom=true, factor=0.05, name="livinglog", name_rot="livinglog" },
        { israndom=false, factor=0.0625, name="livinglog", name_rot="livinglog" }
    }
}
_G.CROPS_DATA_LEGION.pomegranate = {
    growthmults = { 1.2, 1.2, 0.8, 0 }, --春夏xx
    regrowstage = 2,
    bank = "plant_normal_legion", build = "plant_normal_legion",
    leveldata = {
        { anim = "level3_pomegranate", time = time_grow,      deadanim = "dead123_pomegranate", witheredprefab = nil },
        { anim = "level4_pomegranate", time = time_crop*0.45, deadanim = "dead456_pomegranate", witheredprefab = {"log"} },
        { anim = "level5_pomegranate", time = time_crop*0.55, deadanim = "dead456_pomegranate", witheredprefab = {"log"}, bloom = true },
        { anim = { "level6_pomegranate_1", "level6_pomegranate_2", "level6_pomegranate_3" }, time = time_day2*6, deadanim = "dead456_pomegranate", witheredprefab = {"log", "log"} }
    }
}
_G.CROPS_DATA_LEGION.dragonfruit = {
    growthmults = { 1.2, 1.2, 0.8, 0 }, --春夏xx
    regrowstage = 2,
    bank = "plant_normal_legion", build = "plant_normal_legion",
    leveldata = {
        { anim = "level3_dragonfruit", time = time_grow,      deadanim = "dead123_dragonfruit", witheredprefab = nil },
        { anim = "level4_dragonfruit", time = time_crop*0.45, deadanim = "dead456_dragonfruit", witheredprefab = {"log"} },
        { anim = "level5_dragonfruit", time = time_crop*0.55, deadanim = "dead456_dragonfruit", witheredprefab = {"log", "twigs"}, bloom = true },
        { anim = { "level6_dragonfruit_1", "level6_dragonfruit_2", "level6_dragonfruit_3" }, time = time_day2*6, deadanim = "dead456_dragonfruit", witheredprefab = {"log", "twigs"} }
    }
}
_G.CROPS_DATA_LEGION.watermelon = {
    growthmults = { 1.2, 1.2, 0.8, 0 }, --春夏xx
    regrowstage = 1,
    bank = "plant_normal_legion", build = "plant_normal_legion",
    leveldata = {
        { anim = "level3_watermelon", time = time_crop*0.25, deadanim = "dead123_watermelon", witheredprefab = nil },
        { anim = "level4_watermelon", time = time_crop*0.35, deadanim = "dead456_watermelon", witheredprefab = {"cutgrass"} },
        { anim = "level5_watermelon", time = time_crop*0.40, deadanim = "dead456_watermelon", witheredprefab = {"cutgrass"}, bloom = true },
        { anim = { "level6_watermelon_1", "level6_watermelon_2", "level6_watermelon_3" }, time = time_day2*6, deadanim = "dead456_watermelon", witheredprefab = {"cutgrass", "cutgrass"} }
    }
}
_G.CROPS_DATA_LEGION.pineananas = {
    growthmults = { 0.8, 1.2, 1.2, 0 }, --x夏秋x
    regrowstage = 2,
    bank = "crop_legion_pineananas", build = "crop_legion_pineananas",
    image = { name = "pineananas.tex", atlas = "images/inventoryimages/pineananas.xml" },
    leveldata = {
        { anim = "level3", time = time_grow,      deadanim = "dead1", witheredprefab = nil },
        { anim = "level4", time = time_crop*0.45, deadanim = "dead2", witheredprefab = {"log"} },
        { anim = "level5", time = time_crop*0.55, deadanim = "dead2", witheredprefab = {"log", "cutgrass"}, bloom = true },
        { anim = { "level6_1", "level6_2", "level6_3" }, time = time_day2*6, deadanim = "dead2", witheredprefab = {"log", "cutgrass"} }
    },
    cluster_size = { 1, 1.5 },
    lootothers = {
        { israndom=true, factor=0.05, name="pinecone", name_rot="pinecone" },
        { israndom=false, factor=0.0625, name="pinecone", name_rot="pinecone" }
    }
}
_G.CROPS_DATA_LEGION.onion = {
    growthmults = { 1.2, 1.2, 1.2, 0 }, --春夏秋x
    regrowstage = 1,
    bank = "crop_legion_onion", build = "crop_legion_onion",
    image = { name = "quagmire_onion.tex", atlas = nil },
    leveldata = {
        { anim = "level2", time = time_crop*0.25, deadanim = "dead1", witheredprefab = nil },
        { anim = "level3", time = time_crop*0.35, deadanim = "dead2", witheredprefab = {"cutgrass"} },
        { anim = "level4", time = time_crop*0.40, deadanim = "dead2", witheredprefab = {"cutgrass"}, bloom = true },
        { anim = { "level5_1", "level5_2", "level5_3" }, time = time_day2*6, deadanim = "dead2", witheredprefab = {"cutgrass", "cutgrass"} }
    },
    cluster_size = { 1, 1.5 }
}
_G.CROPS_DATA_LEGION.pepper = {
    growthmults = { 0.8, 1.2, 1.2, 0 }, --x夏秋x
    regrowstage = 2,
    bank = "crop_legion_pepper", build = "crop_legion_pepper",
    leveldata = {
        { anim = "level2", time = time_grow,      deadanim = "dead1", witheredprefab = nil },
        { anim = "level3", time = time_crop*0.45, deadanim = "dead2", witheredprefab = {"cutgrass"} },
        { anim = "level4", time = time_crop*0.55, deadanim = "dead2", witheredprefab = {"cutgrass"}, bloom = true },
        { anim = { "level5_1", "level5_2", "level5_3" }, time = time_day2*6, deadanim = "dead2", witheredprefab = {"cutgrass", "cutgrass"} }
    },
    lootothers = {
        { israndom=true, factor=0.4, name="mint_l", name_rot=nil },
        { israndom=false, factor=0.2, name="mint_l", name_rot=nil }
    }
}
_G.CROPS_DATA_LEGION.potato = {
    growthmults = { 1.2, 0.8, 1.2, 0.5 }, --春x秋冬
    regrowstage = 1,
    bank = "crop_legion_potato", build = "crop_legion_potato",
    leveldata = {
        { anim = "level2", time = time_crop*0.25, deadanim = "dead1", witheredprefab = nil },
        { anim = "level3", time = time_crop*0.35, deadanim = "dead2", witheredprefab = {"cutgrass"} },
        { anim = "level4", time = time_crop*0.40, deadanim = "dead2", witheredprefab = {"cutgrass", "potato"}, bloom = true },
        { anim = { "level5_1", "level5_2", "level5_3" }, time = time_day2*6, deadanim = "dead2", witheredprefab = {"cutgrass", "potato"} }
    }
}
_G.CROPS_DATA_LEGION.garlic = {
    growthmults = { 1.2, 1.2, 1.2, 0.5 }, --春夏秋冬
    regrowstage = 1,
    bank = "crop_legion_garlic", build = "crop_legion_garlic",
    leveldata = {
        { anim = "level2", time = time_crop*0.25, deadanim = "dead1", witheredprefab = nil },
        { anim = "level3", time = time_crop*0.35, deadanim = "dead2", witheredprefab = {"cutgrass"} },
        { anim = "level4", time = time_crop*0.40, deadanim = "dead2", witheredprefab = {"cutgrass"}, bloom = true },
        { anim = { "level5_1", "level5_2", "level5_3" }, time = time_day2*6, deadanim = "dead2", witheredprefab = {"feather_crow", "feather_robin"} }
    },
    lootothers = {
        { israndom=true, factor=0.03, name="feather_crow", name_rot="feather_crow" },
        { israndom=false, factor=0.0375, name="feather_crow", name_rot="feather_crow" },
        { israndom=true, factor=0.02, name="feather_robin", name_rot="feather_robin" },
        { israndom=false, factor=0.025, name="feather_robin", name_rot="feather_robin" }
    }
}
_G.CROPS_DATA_LEGION.tomato = {
    growthmults = { 1.2, 1.2, 1.2, 0 }, --春夏秋x
    regrowstage = 2,
    bank = "crop_legion_tomato", build = "crop_legion_tomato",
    image = { name = "quagmire_tomato.tex", atlas = nil },
    leveldata = {
        { anim = "level2", time = time_grow,      deadanim = "dead1", witheredprefab = nil },
        { anim = "level3", time = time_crop*0.45, deadanim = "dead2", witheredprefab = {"twigs"} },
        { anim = "level4", time = time_crop*0.55, deadanim = "dead2", witheredprefab = {"twigs"}, bloom = true },
        { anim = { "level5_1", "level5_2", "level5_3" }, time = time_day2*6, deadanim = "dead2", witheredprefab = {"twigs", "twigs"} }
    },
    cluster_size = { 1, 1.7 }
}
_G.CROPS_DATA_LEGION.asparagus = {
    growthmults = { 1.2, 0.8, 0.8, 0.5 }, --春xx冬
    regrowstage = 2,
    bank = "crop_legion_asparagus", build = "crop_legion_asparagus",
    leveldata = {
        { anim = "level2", time = time_grow,      deadanim = "dead1", witheredprefab = nil },
        { anim = "level3", time = time_crop*0.45, deadanim = "dead2", witheredprefab = {"cutgrass"} },
        { anim = "level4", time = time_crop*0.55, deadanim = "dead2", witheredprefab = {"cutgrass", "cutgrass"}, bloom = true },
        { anim = { "level5_1", "level5_2", "level5_3" }, time = time_day2*6, deadanim = "dead2", witheredprefab = {"cutgrass", "cutgrass", "cutgrass"} }
    },
    cluster_size = { 1, 1.7 }
}
_G.CROPS_DATA_LEGION.mandrake = {
    growthmults = { 1, 1, 1, 0.5 }, --xxx冬
    regrowstage = 1, nomagicgrow = true, getsickchance = 0,
    bank = "crop_legion_mandrake", build = "crop_legion_mandrake",
    leveldata = {
        { anim = "level2", time = time_crop*0.5, deadanim = "dead1", witheredprefab = nil },
        { anim = "level3", time = time_crop*0.7, deadanim = "dead1", witheredprefab = {"cutgrass"} },
        { anim = "level4", time = time_crop*0.8, deadanim = "dead1", witheredprefab = {"cutgrass"} },
        { anim = "level5", time = nil,           deadanim = "dead1", witheredprefab = {"cutgrass"} }
    },
    fn_loot = function(self, doer, ispicked, isburnt, loots)
        if self.stage == self.stage_max then
            local num = self.cluster + 1 --曼德拉产量固定1
            if self.isrotten then
                self:AddLoot(loots, "livinglog", num*2)
            else
                self:AddLoot(loots, "mandrake", num)
            end
        end
    end,
    fn_defend = function(inst, target)
        local doer = target or inst --只能尽量由 target 来执行操作，因为下一帧 inst 可能就没了
        if doer.SoundEmitter then
            doer.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/death")
        else
            inst.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/death")
        end
        local x, y, z = inst.Transform:GetWorldPosition()
        local timemult = inst.components.perennialcrop2.cluster*0.03 --99级大概会增加3倍时间
        doer:DoTaskInTime(0.4+0.2*math.random(), function()
            local time = 10
            if timemult > 0 then
                time = time + time*timemult
            end
            TOOLS_L.DoAreaSleep({
                doer = doer, x = x, y = y, z = z,
                range = 25, -- tagscant = nil, tagsone = nil,
                lvl = 5, time = time + math.random(), --noyawn = nil,
                -- fn_valid = nil, fn_do = nil
            })
        end)
    end
}
_G.CROPS_DATA_LEGION.gourd = {
    growthmults = { 0.8, 0.8, 1.2, 0 }, --xx秋x
    regrowstage = 2,
    bank = "crop_mythword_gourd", build = "crop_mythword_gourd",
    image = { name = "gourd.tex", atlas = "images/inventoryimages/gourd.xml" },
    leveldata = {
        { anim = "level3", time = time_grow,      deadanim = "dead1", witheredprefab = nil },
        { anim = "level4", time = time_crop*0.45, deadanim = "dead2", witheredprefab = {"cutgrass"} },
        { anim = "level5", time = time_crop*0.55, deadanim = "dead2", witheredprefab = {"cutgrass", "cutgrass"}, bloom = true },
        { anim = { "level6_1", "level6_2", "level6_3" }, time = time_day2*6, deadanim = "dead2", witheredprefab = {"cutgrass", "rope"} }
    }
}
_G.CROPS_DATA_LEGION.cactus_meat = {
    growthmults = { 0.8, 1.2, 0.8, 0 }, --x夏xx
    regrowstage = 1,
    bank = "crop_legion_cactus", build = "crop_legion_cactus",
    leveldata = {
        { anim = { "level1_1", "level1_2", "level1_3" }, time = time_day1*10*0.45, deadanim = "dead1", witheredprefab = nil },
        { anim = { "level2_1", "level2_2", "level2_3" }, time = time_day1*10*0.55, deadanim = "dead1", witheredprefab = {"cutgrass"} },
        { anim = { "level3_1", "level3_2", "level3_3" }, time = time_grow, deadanim = "dead1", witheredprefab = {"cutgrass"}, pickable = 1 },
        { anim = { "level4_1", "level4_2", "level4_3" }, time = time_day2*6, deadanim = "dead1", witheredprefab = {"cutgrass"}, bloom = true }
    },
    cluster_size = { 0.9, 1.3 },
    fn_loot = function(self, doer, ispicked, isburnt, loots)
        if self.stage == self.stage_max or self.level.pickable == 1 then
            self:GetBaseLoot(loots, {
                doer = doer, ispicked = ispicked, isburnt = isburnt,
                crop = self.cropprefab, crop_rot = "spoiled_food",
                lootothers = self.stage == self.stage_max and { --最终阶段才有仙人掌花
                    { israndom=true, factor=0.4, name="cactus_flower", name_rot=nil },
                    { israndom=false, factor= TheWorld.state.issummer and 0.7 or 0.2, name="cactus_flower", name_rot=nil }
                } or nil
            })
        end
    end,
    fn_pick = function(self, doer, loot) --采集时被刺伤
        if
            doer ~= nil and doer.components.combat ~= nil and
            not doer:HasTag("shadowminion") and
            not (
                doer.components.inventory ~= nil and
                (
                    doer.components.inventory:EquipHasTag("bramble_resistant") or
                    (CONFIGS_LEGION.ENABLEDMODS.MythWords and doer.components.inventory:Has("thorns_pill", 1))
                )
            )
        then
            doer.components.combat:GetAttacked(self.inst, 6 + 0.2*self.cluster)
            doer:PushEvent("thorns")
        end
    end,
    fn_common = function(inst)
        inst:AddTag("thorny")
    end,
    fn_season = function(self) --夏季时切换花朵贴图
        if TheWorld.state.season == "summer" then
            local skin = self.inst.components.skinedlegion:GetSkin()
            self.inst.AnimState:OverrideSymbol("flowerplus", skin or "crop_legion_cactus", "flomax")
        else
            self.inst.AnimState:ClearOverrideSymbol("flowerplus")
        end
    end
}
_G.CROPS_DATA_LEGION.plantmeat = {
    growthmults = { 1.2, 0.8, 1.2, 0 }, --春x秋x
    regrowstage = 1, cangrowindrak = true, getsickchance = 0,
    plant2 = "plant_nepenthes_l", --这个的三阶段是单独的实体，也需要升级
    bank = "crop_legion_lureplant", build = "crop_legion_lureplant",
    leveldata = {
        { anim = "level1", time = time_day1*7*0.45, deadanim = "dead1", witheredprefab = nil },
        { anim = "level2", time = time_day1*7*0.55, deadanim = "dead1", witheredprefab = {"cutgrass" ,"cutgrass"} },
        { anim = "idle", time = nil, deadanim = "dead1", witheredprefab = {"cutgrass" ,"cutgrass", "cutgrass"}, pickable = -1 }
    },
    cluster_size = { 0.9, 1.5 },
    fn_growth = function(self, data) --成熟阶段得换成生物实体
        if data.stage < self.stage_max then
            return
        end
        local bios = SpawnPrefab("plant_nepenthes_l")
        if bios ~= nil then
            bios.fn_switch(bios, self.inst)
        end
        self.inst:Remove()
    end,
    fn_stage = function(self) --成熟阶段枯萎，变回1阶段的枯萎植物实体
        if self.stage < self.stage_max or not self.isrotten then
            return
        end
        local plant = self.inst.fn_switch(self.inst)
        if plant ~= nil then
            plant.components.perennialcrop2:SetStage(1, true) --弄成枯萎的
        end
        self.inst:Remove()
    end
}
_G.CROPS_DATA_LEGION.berries = {
    growthmults = { 1.2, 0.8, 1.2, 0 }, --春x秋x
    regrowstage = 1,
    bank = "crop_legion_berries", build = "crop_legion_berries",
    leveldata = {
        { anim = "level1", time = time_day1*8*0.45, deadanim = "dead1", witheredprefab = nil },
        { anim = "level2", time = time_day1*8*0.55, deadanim = "dead1", witheredprefab = {"log"}, bloom = true },
        { anim = { "level3_1", "level3_2", "level3_3" }, time = time_grow, deadanim = "dead1", witheredprefab = {"log", "twigs"}, pickable = 1 },
        { anim = { "level3_1", "level3_2", "level3_3" }, time = time_day2*6, deadanim = "dead1", witheredprefab = {"log", "twigs"} }
    },
    cluster_size = { 0.9, 1.3 },
    fn_loot = function(self, doer, ispicked, isburnt, loots)
        if self.stage == self.stage_max then
            self:GetBaseLoot(loots, {
                doer = doer, ispicked = ispicked, isburnt = isburnt,
                crop = self.cropprefab, crop_rot = "spoiled_food",
                lootothers = {
                    { israndom=true, factor=0.4, name="berries_juicy", name_rot=nil },
                    { israndom=false, factor=0.2, name="berries_juicy", name_rot=nil }
                }
            })
        elseif self.level.pickable == 1 then
            self:GetBaseLoot(loots, {
                doer = doer, ispicked = ispicked, isburnt = isburnt,
                crop = "berries_juicy", crop_rot = "spoiled_food",
                lootothers = {
                    { israndom=true, factor=0.4, name=self.cropprefab, name_rot=nil },
                    { israndom=false, factor=0.2, name=self.cropprefab, name_rot=nil }
                }
            })
        end
    end,
    fn_stage = function(self)
        if self.stage >= self.stage_max then
            -- local skin = self.inst.components.skinedlegion:GetSkin()
            -- self.inst.AnimState:OverrideSymbol("fruit1", skin or "crop_legion_berries", "fruit2")
            self.inst.AnimState:OverrideSymbol("fruit1", "crop_legion_berries", "fruit2")
        else
            self.inst.AnimState:ClearOverrideSymbol("fruit1")
        end
    end
}
_G.CROPS_DATA_LEGION.log = {
    growthmults = { 1.2, 0.8, 1.2, 0.5 }, --春x秋冬
    regrowstage = 1, cangrowindrak = true, dataonly = true,
    bank = "crop_legion_pine", build = "crop_legion_pine",
    leveldata = {
        { anim = "idle", time = time_day1*8*0.34, deadanim = nil, witheredprefab = nil },
        { anim = "idle", time = time_day1*8*0.66, deadanim = nil, witheredprefab = nil },
        { anim = "idle", time = nil, deadanim = nil, witheredprefab = nil, pickable = -1 }
    },
    cluster_size = { 0.9, 1.5 },
    fn_placer = function(placer)
        placer.AnimState:Hide("base2") --Tip：动画中，对应贴图名需要复写为base2_00x，x为序号，否则就只会第一个生效
		placer.AnimState:Hide("base3")
    end
}

------巨食草消化结算清单
if not _G.rawget(_G, "DIGEST_DATA_LEGION") then
    _G.DIGEST_DATA_LEGION = {}
end

local function FnD_lordfruitfly(inst, eater, items_free)
    TheWorld:PushEvent("ms_lordfruitflykilled")
end

local lvls = { 0, 5, 10, 20, 30, 40, 50, 65, 80 }
local digest_data_l = {
    bee = {
        lvl = nil, --巨食草要达到这个簇栽等级后才能主动吞下该对象，如果为 nil 则代表无法主动吞下
        attract = nil, --为true的话，可以被巨食草主动吸引(是靠战斗组件来吸引)
        loot = { ahandfulofwings = 0.2, insectshell_l = 1, honey = 0.2 }, --key value 对应 产物prefab 数量比例
        -- fn_digest = function(inst, eater, items_free)end --被消化或吞食时的
    },
    butterfly = { lvl = nil, attract = nil, loot = { ahandfulofwings = 0.2, insectshell_l = 1 } }, --蝴蝶
    moonbutterfly = { lvl = nil, attract = nil, loot = { ahandfulofwings = 0.5, insectshell_l = 1 } }, --月蛾
    carrat = { lvl = nil, attract = nil, loot = { carrot_seeds = 1 } }, --胡萝卜鼠
    lightcrab = { lvl = nil, attract = nil, loot = { slurtle_shellpieces = 1 } }, --发光蟹
    oceanfish_small_1_inv = { lvl = nil, attract = nil, loot = { boneshard = 1 } }, --小孔雀鱼
    oceanfish_small_2_inv = { lvl = nil, attract = nil, loot = { boneshard = 1 } }, --针鼻喷墨鱼
    oceanfish_small_3_inv = { lvl = nil, attract = nil, loot = { boneshard = 1 } }, --小饵鱼
    oceanfish_small_4_inv = { lvl = nil, attract = nil, loot = { boneshard = 1 } }, --三文鱼苗
    oceanfish_small_5_inv = { lvl = nil, attract = nil, loot = { corn_seeds = 1 } }, --爆米花鱼
    oceanfish_small_6_inv = { lvl = nil, attract = nil, loot = { boneshard = 3 } }, --落叶比目鱼
    oceanfish_small_7_inv = { lvl = nil, attract = nil, loot = { boneshard = 3 } }, --花朵金枪鱼
    oceanfish_small_8_inv = { lvl = nil, attract = nil, loot = { boneshard = 3 } }, --炽热太阳鱼
    oceanfish_small_9_inv = { lvl = nil, attract = nil, loot = { boneshard = 1 } }, --口水鱼
    oceanfish_medium_1_inv = { lvl = nil, attract = nil, loot = { boneshard = 1 } }, --泥鱼
    oceanfish_medium_2_inv = { lvl = nil, attract = nil, loot = { boneshard = 1 } }, --斑鱼
    oceanfish_medium_3_inv = { lvl = nil, attract = nil, loot = { boneshard = 1 } }, --浮夸狮子鱼
    oceanfish_medium_4_inv = { lvl = nil, attract = nil, loot = { boneshard = 1 } }, --黑鲶鱼
    oceanfish_medium_5_inv = { lvl = nil, attract = nil, loot = { corn_seeds = 1 } }, --玉米鳕鱼
    oceanfish_medium_6_inv = { lvl = nil, attract = nil, loot = { boneshard = 3 } }, --花锦鲤
    oceanfish_medium_7_inv = { lvl = nil, attract = nil, loot = { boneshard = 3 } }, --金锦鲤
    oceanfish_medium_8_inv = { lvl = nil, attract = nil, loot = { boneshard = 3 } }, --冰鲷鱼
    oceanfish_medium_9_inv = { lvl = nil, attract = nil, loot = { boneshard = 1, honey = 0.2 } }, --甜味鱼
    pondfish = { lvl = nil, attract = nil, loot = { boneshard = 1 } }, --淡水鱼
    pondeel = { lvl = nil, attract = nil, loot = { boneshard = 4 } }, --活鳗鱼
    lightflier = { lvl = nil, attract = nil, loot = { ahandfulofwings = 0.5, insectshell_l = 1 } }, --球状光虫
    dragon_scales = { lvl = nil, attract = nil, loot = { insectshell_l = 28 } }, --鳞片(龙蝇)
    lavae_egg = { lvl = nil, attract = nil, loot = { insectshell_l = 20 } }, --岩浆虫卵
    lavae_egg_cracked = { lvl = nil, attract = nil, loot = { insectshell_l = 20 } }, --岩浆虫卵(孵化中)
    lavae_cocoon = { lvl = nil, attract = nil, loot = { insectshell_l = 28 } }, --冷冻虫卵
    butter = { lvl = nil, attract = nil, loot = { insectshell_l = 16 } }, --黄油
    royal_jelly = { lvl = nil, attract = nil, loot = { insectshell_l = 16 } }, --蜂王浆
    glommerflower = { lvl = nil, attract = nil, loot = { insectshell_l = 16 } }, --格罗姆花
    glommerwings = { lvl = nil, attract = nil, loot = { insectshell_l = 16 } }, --格罗姆翅膀
    glommerfuel = { lvl = nil, attract = nil, loot = { insectshell_l = 8 } }, --格罗姆的黏液
    honeycomb = { lvl = nil, attract = nil, loot = { insectshell_l = 16 } }, --蜂巢
    beeswax = { lvl = nil, attract = nil, loot = { insectshell_l = 18 } }, --蜂蜡
    wormlight = { lvl = nil, attract = nil, loot = { insectshell_l = 4 } }, --发光浆果
    wormlight_lesser = { lvl = nil, attract = nil, loot = { insectshell_l = 1 } }, --小发光浆果
    fruitflyfruit = { lvl = nil, attract = nil, loot = { insectshell_l = 20 } }, --友好果蝇果
    fireflies = { lvl = nil, attract = nil, loot = { ahandfulofwings = 0.5, insectshell_l = 1 } }, --萤火虫
    raindonate = { lvl = lvls[1], attract = true, loot = { ahandfulofwings = 1, insectshell_l = 1 } }, --雨蝇
    cropgnat = { lvl = lvls[1], attract = true, loot = { ahandfulofwings = 1, insectshell_l = 1 } }, --植害虫群
    cropgnat_infester = { lvl = lvls[1], attract = true, loot = { ahandfulofwings = 1, insectshell_l = 1 } }, --叮咬虫群
    killerbee = { lvl = lvls[1], attract = true, loot = { ahandfulofwings = 0.2, insectshell_l = 1, honey = 0.2 } }, --杀人蜂
    mosquito = { lvl = lvls[1], attract = true, loot = { ahandfulofwings = 0.2, insectshell_l = 1 } }, --蚊子
    fruitfly = { lvl = lvls[2], attract = true, loot = { ahandfulofwings = 0.5, insectshell_l = 1 } }, --果蝇
    crow = { lvl = lvls[2], attract = nil, loot = { boneshard = 1 } }, --乌鸦
    canary = { lvl = lvls[2], attract = nil, loot = { boneshard = 1 } }, --金丝雀
    canary_poisoned = { lvl = lvls[2], attract = nil, loot = { boneshard = 1 } }, --生病金丝雀
    robin = { lvl = lvls[2], attract = nil, loot = { boneshard = 1 } }, --红雀
    robin_winter = { lvl = lvls[2], attract = nil, loot = { boneshard = 1 } }, --雪雀
    puffin = { lvl = lvls[2], attract = nil, loot = { boneshard = 1 } }, --海鹦鹉
    rabbit = { lvl = lvls[2], attract = nil, loot = { boneshard = 1 } }, --兔子
    mole = { lvl = lvls[2], attract = nil, loot = { boneshard = 1, nitre = 2 } }, --鼹鼠
    gingerbreadpig = { lvl = lvls[2], attract = nil, loot = { wintersfeastfuel = 1 } }, --姜饼猪
    eyeplant = { lvl = lvls[2], attract = nil, loot = nil }, --眼球草
    wobster_sheller_land = { lvl = lvls[2], attract = nil, loot = { boneshard = 1 } }, --地上的龙虾
    wobster_moonglass_land = { lvl = lvls[3], attract = nil, loot = { moonglass = 1 } }, --地上的月光龙虾
    lavae = { lvl = lvls[3], attract = true, loot = { insectshell_l = 1 } }, --岩浆虫
    fruitdragon = { lvl = lvls[3], attract = nil, loot = { dragonfruit_seeds = 1 } }, --沙拉蝾螈
    grassgekko = { lvl = lvls[3], attract = nil, loot = { boneshard = 1 } }, --草壁虎
    frog = { lvl = lvls[3], attract = nil, loot = { boneshard = 1 } }, --青蛙
    cookiecutter = { lvl = lvls[3], attract = nil, loot = { cookiecuttershell = 1 } }, --饼干切割机
    bat = { lvl = lvls[3], attract = true, loot = { boneshard = 1 } }, --蝙蝠
    birchnutdrake = { lvl = lvls[3], attract = nil, loot = { acorn = 1 } }, --桦栗果精
    spider = { lvl = lvls[3], attract = nil, loot = { boneshard = 1 } }, --蜘蛛
    spider_warrior = { lvl = lvls[4], attract = nil, loot = { boneshard = 1 } }, --蜘蛛战士
    spider_hider = { lvl = lvls[4], attract = nil, loot = { boneshard = 1 } }, --洞穴蜘蛛
    spider_spitter = { lvl = lvls[4], attract = nil, loot = { boneshard = 1 } }, --喷射蜘蛛
    spider_dropper = { lvl = lvls[4], attract = nil, loot = { boneshard = 1 } }, --穴居悬蛛
    monkey = { lvl = lvls[4], attract = nil, loot = { boneshard = 1 } }, --穴居猴
    bird_mutant = { lvl = lvls[4], attract = nil, loot = { boneshard = 1 } }, --月盲乌鸦
    bird_mutant_spitter = { lvl = lvls[4], attract = nil, loot = { boneshard = 1 } }, --奇形鸟
    stalker_minion = { lvl = lvls[4], attract = nil, loot = { nightmarefuel = 1 } }, --编织暗影
    stalker_minion1 = { lvl = lvls[4], attract = nil, loot = { nightmarefuel = 1 } }, --编织暗影1
    stalker_minion2 = { lvl = lvls[4], attract = nil, loot = { nightmarefuel = 1 } }, --编织暗影2
    buzzard = { lvl = lvls[5], attract = nil, loot = { boneshard = 1 } }, --秃鹫
    spider_moon = { lvl = lvls[5], attract = nil, loot = { boneshard = 1 } }, --破碎蜘蛛
    spider_healer = { lvl = lvls[5], attract = nil, loot = { boneshard = 1 } }, --护士蜘蛛
    spider_water = { lvl = lvls[5], attract = nil, loot = { boneshard = 1 } }, --海黾
    beeguard = { lvl = lvls[5], attract = true, loot = { ahandfulofwings = 1, insectshell_l = 1, honey = 0.2 } }, --嗡嗡蜜蜂
    eyeofterror_mini_grounded = { lvl = lvls[5], attract = nil, loot = { boneshard = 1 } }, --可疑窥视者(孵化中)
    eyeofterror_mini = { lvl = lvls[5], attract = nil, loot = { boneshard = 1 } }, --可疑窥视者
    molebat = { lvl = lvls[5], attract = nil, loot = { boneshard = 1 } }, --裸鼹蝠
    squid = { lvl = lvls[5], attract = nil, loot = { boneshard = 1 } }, --鱿鱼
    worm = { lvl = lvls[6], attract = true, loot = { boneshard = 1, insectshell_l = 2 } }, --洞穴蠕虫
    perd = { lvl = lvls[6], attract = nil, loot = { boneshard = 1, dug_berrybush = 0.04 } }, --火鸡
    penguin = { lvl = lvls[6], attract = nil, loot = { boneshard = 1 } }, --企鸥
    catcoon = { lvl = lvls[6], attract = nil, loot = { boneshard = 1 } }, --浣猫
    snurtle = { lvl = lvls[6], attract = nil, loot = { slurtle_shellpieces = 1 } }, --蜗牛龟
    slurtle = { lvl = lvls[7], attract = true, loot = { slurtle_shellpieces = 1 } }, --蛞蝓龟
    mutated_penguin = { lvl = lvls[7], attract = nil, loot = { boneshard = 2 } }, --月岩企鸥
    smallbird = { lvl = lvls[7], attract = nil, loot = { boneshard = 1 } }, --小鸟(高脚鸟)
    slurper = { lvl = lvls[7], attract = nil, loot = { boneshard = 1 } }, --啜食者
    hound = { lvl = lvls[7], attract = nil, loot = { boneshard = 1 } }, --猎犬
    firehound = { lvl = lvls[8], attract = nil, loot = { boneshard = 1 } }, --红色猎犬
    icehound = { lvl = lvls[8], attract = nil, loot = { boneshard = 1 } }, --蓝色猎犬
    moonhound = { lvl = lvls[8], attract = nil, loot = { boneshard = 1 } }, --月杖转化仪式的猎犬
    mutatedhound = { lvl = lvls[8], attract = nil, loot = { boneshard = 2 } }, --恐怖猎犬
    teenbird = { lvl = lvls[8], attract = nil, loot = { boneshard = 2 } }, --小高脚鸟
    mossling = { lvl = lvls[8], attract = nil, loot = { boneshard = 1 } }, --麋鹿鹅幼崽
    babybeefalo = { lvl = lvls[8], attract = nil, loot = { boneshard = 1 } }, --小皮弗娄牛
    lightninggoat = { lvl = lvls[8], attract = nil, loot = { boneshard = 1, goatmilk = 0.2 } }, --伏特羊
    merm = { lvl = lvls[8], attract = nil, loot = { boneshard = 1, merm_scales = 0.2 } }, --鱼人
    pigman = { lvl = lvls[8], attract = nil, loot = { boneshard = 1 } }, --猪人、疯猪
    powder_monkey = { lvl = lvls[8], attract = nil, loot = { boneshard = 1 } }, --火药猴
    mushgnome = { lvl = lvls[8], attract = nil, loot = { spore_moon = 4, livinglog = 4 } }, --蘑菇地精
    little_walrus = { lvl = lvls[8], attract = nil, loot = { boneshard = 1, walrus_tusk = 0.2 } }, --小海象
    deer = { lvl = lvls[8], attract = nil, loot = { boneshard = 2, deer_antler1 = 0.1, deer_antler2 = 0.1, deer_antler3 = 0.1 } }, --无眼鹿
    deer_red = { lvl = lvls[9], attract = nil, loot = { boneshard = 4, deer_antler1 = 0.1, deer_antler2 = 0.1, deer_antler3 = 0.1 } }, --无眼鹿(红)
    deer_blue = { lvl = lvls[9], attract = nil, loot = { boneshard = 4, deer_antler1 = 0.1, deer_antler2 = 0.1, deer_antler3 = 0.1 } }, --无眼鹿(蓝)
    bunnyman = { lvl = lvls[9], attract = nil, loot = { boneshard = 1, beardhair = 0.2 } }, --兔人
    mermguard = { lvl = lvls[9], attract = nil, loot = { boneshard = 1, merm_scales = 0.5 } }, --忠诚鱼人守卫
    pigguard = { lvl = lvls[9], attract = nil, loot = { boneshard = 1, dug_berrybush2 = 0.1 } }, --猪人守卫
    moonpig = { lvl = lvls[9], attract = nil, loot = { boneshard = 1 } }, --月杖转化仪式的疯猪
    prime_mate = { lvl = lvls[9], attract = nil, loot = { boneshard = 2 } }, --大副(火药猴)
    walrus = { lvl = lvls[9], attract = nil, loot = { boneshard = 1, walrus_tusk = 1 } }, --海象
    clayhound = { lvl = lvls[9], attract = nil, loot = { redpouch = 4 } }, --黏土猎犬
    hedgehound = { lvl = lvls[9], attract = nil, loot = { boneshard = 1, cutted_rosebush = 1 } }, --蔷薇狼
    lordfruitfly = { lvl = lvls[9], attract = nil, loot = { ahandfulofwings = 8, insectshell_l = 12 }, fn_digest = FnD_lordfruitfly }, --果蝇王
    warglet = { lvl = lvls[9], attract = nil, loot = { boneshard = 4 } }, --青年座狼

    --mod兼容：永不妥协
    aphid = { lvl = lvls[2], attract = true, loot = { ahandfulofwings = 0.2, insectshell_l = 1 } }, --蚜虫
    uncompromising_caverat = { lvl = lvls[4], attract = true, loot = { boneshard = 1 } }, --老鼠(洞穴)
    uncompromising_rat = { lvl = lvls[4], attract = true, loot = { boneshard = 1 } }, --老鼠
    uncompromising_junkrat = { lvl = lvls[4], attract = true, loot = { boneshard = 1 } }, --老鼠(垃圾)
    uncompromising_packrat = { lvl = lvls[4], attract = true, loot = { boneshard = 1 } }, --老鼠(背包)
    pied_rat = { lvl = lvls[7], attract = true, loot = { boneshard = 1 } }, --吹笛魔鼠
}
for k,v in pairs(digest_data_l) do
    _G.DIGEST_DATA_LEGION[k] = v
end
digest_data_l = nil

--------------------------------------------------------------------------
--[[ 修改浣猫，让猫薄荷对其产生特殊作用 ]]
--------------------------------------------------------------------------

if IsServer then
    local function OnAccept_catcoon(cat, giver, item)
        if cat.onaccept_old_mint ~= nil then
            cat.onaccept_old_mint(cat, giver, item)
        end
        if item:HasTag("catmint") then
            cat.count_mint_l = (cat.count_mint_l or 0) + 1
            if cat.components.follower ~= nil and cat.components.follower.task ~= nil then
                cat.components.follower:AddLoyaltyTime(cat.components.follower.maxfollowtime or TUNING.CATCOON_LOYALTY_MAXTIME)
            end
        end
    end
    local function PickRandomGift_catcoon(cat, tier)
        if cat.count_mint_l ~= nil then
            if cat.count_mint_l <= 1 then
                cat.count_mint_l = nil
            else
                cat.count_mint_l = cat.count_mint_l - 1
            end
            if math.random() < 0.5 then
                return "cattenball"
            end
        end
        if cat.PickRandomGift_old_mint ~= nil then
            return cat.PickRandomGift_old_mint(cat, tier)
        end
    end

    local didfriendgift = nil
    AddPrefabPostInit("catcoon", function(inst)
        inst.onaccept_old_mint = inst.components.trader.onaccept
        inst.components.trader.onaccept = OnAccept_catcoon

        inst.PickRandomGift_old_mint = inst.PickRandomGift
        inst.PickRandomGift = PickRandomGift_catcoon

        if not didfriendgift then --由于索引效果，这一改会永久修改所有的表，所以这里只需要改一次就行
            didfriendgift = true
            if inst.friendGiftPrefabs ~= nil then
                table.insert(inst.friendGiftPrefabs, {
                    "cattenball",
                    "cutted_rosebush", "cutted_lilybush", "cutted_orchidbush",
                    "shyerry"
                })
            end
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
        fruit = "seeds_mandrake_l", time = 20*TUNING.TOTAL_DAY_TIME,
        fruitnum_min = 1, fruitnum_max = 1, genekey = "mandrakesoup"
    },
    gourd_oversized = {
        swap = { build = "farm_plant_gourd", file = "swap_body", symboltype = "3" },
        fruit = "seeds_gourd_l"
    },
    squamousfruit = {
        swap = { build = "squamousfruit", file = "swap_turn", symboltype = "1" },
        fruit = "dug_monstrain", time = 2*TUNING.TOTAL_DAY_TIME,
        fruitnum_min = 1, fruitnum_max = 1, genekey = "raindonate"
    },
    cactus_flower = {
        swap = { build = "crop_legion_cactus", file = "swap_turn", symboltype = "1" },
        fruit = "seeds_cactus_meat_l", time = 2*TUNING.TOTAL_DAY_TIME,
        fruitnum_min = 1, fruitnum_max = 1, genekey = "tissue_l_cactus"
    },
    lureplantbulb = {
        swap = { build = "crop_legion_lureplant", file = "swap_turn", symboltype = "1" },
        fruit = "seeds_plantmeat_l", time = 2*TUNING.TOTAL_DAY_TIME,
        fruitnum_min = 1, fruitnum_max = 1, genekey = "tissue_l_lureplant"
    },
    dug_berrybush = {
        swap = { build = "crop_legion_berries", file = "swap_turn1", symboltype = "1" },
        fruit = "seeds_berries_l", time = 2*TUNING.TOTAL_DAY_TIME,
        fruitnum_min = 1, fruitnum_max = 1, genekey = "tissue_l_berries"
    },
    dug_berrybush2 = {
        swap = { build = "crop_legion_berries", file = "swap_turn2", symboltype = "1" },
        fruit = "seeds_berries_l", time = 2*TUNING.TOTAL_DAY_TIME,
        fruitnum_min = 1, fruitnum_max = 2, genekey = "tissue_l_berries"
    },
    dug_berrybush_juicy = {
        swap = { build = "crop_legion_berries", file = "swap_turn3", symboltype = "1" },
        fruit = "seeds_berries_l", time = 5*TUNING.TOTAL_DAY_TIME,
        fruitnum_min = 2, fruitnum_max = 3, genekey = "tissue_l_berries"
    },
    pinecone = {
        swap = { build = "crop_legion_pine", file = "swap_turn", symboltype = "1" },
        fruit = "seeds_log_l",
        fruitnum_min = 1, fruitnum_max = 1, genekey = "foliageath"
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
        if act.invobject.prefab == "siving_rocks" or act.invobject.sivturnenergy ~= nil then
            return "CHARGE"
        end
    end
    return "GENERIC"
end
GENETRANS.fn = function(act)
    if act.target ~= nil and act.target.components.genetrans ~= nil and act.doer ~= nil then
        local material = act.invobject
        if
            material == nil and
            -- act.doer.components.inventory ~= nil and act.doer.components.inventory:IsHeavyLifting() and
            act.doer.components.inventory ~= nil and --inventory:IsHeavyLifting() 不能判定，因为神话书说里改了
            not (act.doer.components.rider ~= nil and act.doer.components.rider:IsRiding())
        then
            material = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
        end

        if material ~= nil then
            if material.prefab == "siving_rocks" or material.sivturnenergy ~= nil then
                return act.target.components.genetrans:Charge(material, act.doer)
            else
                local res, reason = act.target.components.genetrans:UnlockGene(material, act.doer)
                if not res then --说明基因池解锁失败了
                    if reason == "HASKEY" then --说明这是种活性组织
                        return false, reason
                    else
                        return act.target.components.genetrans:SetUp(material, act.doer)
                    end
                else
                    return true
                end
            end
        end
    end
end
AddAction(GENETRANS)

AddComponentAction("SCENE", "genetrans", function(inst, doer, actions, right)
    if
        right and
        -- (doer.replica.inventory ~= nil and doer.replica.inventory:IsHeavyLifting()) and
        doer.replica.inventory ~= nil and --inventory:IsHeavyLifting() 不能判定，因为神话书说里改了
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

-- GENETRANS 组件动作响应已移到 CA_U_INVENTORYITEM_L 中

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

--------------------------------------------------------------------------
--[[ 子圭面具的相关 ]]
--------------------------------------------------------------------------

------御血神通的动作
local LIFEBEND = Action({ mount_valid=true, priority=1.3 })
LIFEBEND.id = "LIFEBEND"
LIFEBEND.str = STRINGS.ACTIONS.LIFEBEND
LIFEBEND.strfn = function(act)
    local target = act.target
    if target.prefab == "flower_withered" or target.prefab == "mandrake" then --枯萎花、死掉的曼德拉草
        return "GENERIC"
    elseif target:HasTag("playerghost") or target:HasTag("ghost") then --玩家鬼魂、幽灵
        return "REVIVE"
    elseif target:HasTag("_health") then --有生命组件的对象
        return "CURE"
    elseif target:HasTag("lifebox_l") then --生命容器
        return "GIVE"
    end
    return "GENERIC"
end
LIFEBEND.fn = function(act)
    if act.doer ~= nil and act.doer.components.inventory ~= nil then
        local item = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
        if item ~= nil and item.components.lifebender ~= nil then
            return item.components.lifebender:Do(act.doer, act.target)
        end
    end
end
AddAction(LIFEBEND)

--Tip："EQUIPPED"类型只识别手持道具，其他装备栏位置的不识别
-- AddComponentAction("EQUIPPED", "lifebender", function(inst, doer, target, actions, right) end)
-- LIFEBEND 组件动作响应已移到 CA_S_INSPECTABLE_L 中

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.LIFEBEND, "give"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.LIFEBEND, "give"))

--------------------------------------------------------------------------
--[[ 犀金甲的相关 ]]
--------------------------------------------------------------------------

------不受装备的减速效果影响

local inventoryitem_replica = require("components/inventoryitem_replica")

local GetWalkSpeedMult_old = inventoryitem_replica.GetWalkSpeedMult
inventoryitem_replica.GetWalkSpeedMult = function(self, ...)
    local res = GetWalkSpeedMult_old(self, ...)
    if self.inst.components.equippable == nil and self.classified ~= nil then --客户端环境
        if
            res < 1.0 and not self.inst:HasTag("burden_l") and
            ThePlayer ~= nil and ThePlayer:HasTag("burden_ignor_l")
        then
            return 1.0
        end
    end
    return res
end

if IsServer then
    AddComponentPostInit("equippable", function(self)
        local GetWalkSpeedMult_old = self.GetWalkSpeedMult
        self.GetWalkSpeedMult = function(self, ...)
            local res = GetWalkSpeedMult_old(self, ...)
            if res < 1.0 and not self.inst:HasTag("burden_l") then
                local owner = self.inst.components.inventoryitem and self.inst.components.inventoryitem:GetGrandOwner() or nil
                if owner ~= nil and owner:HasTag("burden_ignor_l") then
                    return 1.0
                end
            end
            return res
        end
    end)
end

--------------------------------------------------------------------------
--[[ 活性组织获取方式 ]]
--------------------------------------------------------------------------

if IsServer then
    local function GiveTissue(inst, picker, name)
        local loot = SpawnPrefab(name)
        if loot ~= nil then
            loot.components.inventoryitem:InheritMoisture(TheWorld.state.wetness, TheWorld.state.iswet)
            if picker ~= nil and picker.components.inventory ~= nil then
                picker.components.inventory:GiveItem(loot, nil, inst:GetPosition())
            else
                local x, y, z = inst.Transform:GetWorldPosition()
                loot.components.inventoryitem:DoDropPhysics(x, y, z, true)
            end
        end
    end

    ------仙人掌的
    local function FnSet_cactus(inst)
        local onpickedfn_old = inst.components.pickable.onpickedfn
        inst.components.pickable.onpickedfn = function(inst, picker, ...)
            if onpickedfn_old ~= nil then
                onpickedfn_old(inst, picker, ...)
            end
            if not TheWorld.state.israining or math.random() >= (CONFIGS_LEGION.TISSUECACTUSCHANCE or 0.05) then
                return
            end
            GiveTissue(inst, picker, "tissue_l_cactus")
        end
    end
    AddPrefabPostInit("cactus", FnSet_cactus)
    AddPrefabPostInit("oasis_cactus", FnSet_cactus)

    ------浆果丛的
    local function FnSet_berry(inst)
        local onpickedfn_old = inst.components.pickable.onpickedfn
        inst.components.pickable.onpickedfn = function(inst, picker, ...)
            if onpickedfn_old ~= nil then
                onpickedfn_old(inst, picker, ...)
            end
            if not TheWorld.state.isdusk or math.random() >= (CONFIGS_LEGION.TISSUEBERRIESCHANCE or 0.01) then
                return
            end
            GiveTissue(inst, picker, "tissue_l_berries")
        end
    end
    AddPrefabPostInit("berrybush", FnSet_berry)
    AddPrefabPostInit("berrybush2", FnSet_berry)
    AddPrefabPostInit("berrybush_juicy", FnSet_berry)

    ------果蝇们会掉落虫翅碎片
    local function LootSetup_fruitfly(lootdropper)
        if lootdropper.inst.lootsetupfn_old_l ~= nil then
            lootdropper.inst.lootsetupfn_old_l(lootdropper)
        end
        lootdropper:AddChanceLoot("ahandfulofwings", 0.25)
    end
    local function FnSet_fruitfly(inst)
        if inst.components.lootdropper ~= nil then
            inst.lootsetupfn_old_l = inst.components.lootdropper.lootsetupfn
            inst.components.lootdropper:SetLootSetupFn(LootSetup_fruitfly)
        end
    end
    AddPrefabPostInit("fruitfly", FnSet_fruitfly)
    AddPrefabPostInit("friendlyfruitfly", FnSet_fruitfly)
end

--------------------------------------------------------------------------
--[[ 添加新的世界唯一型容器 ]]
--------------------------------------------------------------------------

local worldboxes = require("prefabs/pocketdimensioncontainer_defs")
table.insert(worldboxes.POCKETDIMENSIONCONTAINER_DEFS, {
    name = "cloudpine_l1", --世界容器id
    prefab = "cloudpine_box_l1", --预制物名
    -- ui = "anim/ui_portal_shadow_3x4.zip",
    widgetname = "cloudpine_box_l1", --容器名
    -- tags = { "spoiler" },
    data_only = true --只加数据，不用官方的预制物逻辑，因为我还需要加别的机制
})
table.insert(worldboxes.POCKETDIMENSIONCONTAINER_DEFS, {
    name = "cloudpine_l2",
    prefab = "cloudpine_box_l2",
    -- ui = "anim/ui_portal_shadow_3x4.zip",
    widgetname = "cloudpine_box_l2",
    -- tags = { "spoiler" },
    data_only = true
})
table.insert(worldboxes.POCKETDIMENSIONCONTAINER_DEFS, {
    name = "cloudpine_l3",
    prefab = "cloudpine_box_l3",
    -- ui = "anim/ui_portal_shadow_3x4.zip",
    widgetname = "cloudpine_box_l3",
    -- tags = { "spoiler" },
    data_only = true
})
