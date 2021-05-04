local prefabFiles = {
    "siving_rocks_legion",
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
}

for k,v in pairs(assets) do
    table.insert(Assets, v)
end
if not CONFIGS_LEGION.ENABLEDMODS.MythWords then
    table.insert(Assets, Asset("ATLAS", "images/inventoryimages/siving_rocks.xml"))
    table.insert(Assets, Asset("IMAGE", "images/inventoryimages/siving_rocks.tex"))
end

-----

local _G = GLOBAL
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()

--------------------------------------------------------------------------
--[[ 基础 ]]
--------------------------------------------------------------------------

AddIngredientValues({"pineananas"}, {veggie=1, fruit=1}, true, false)

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
--[[ 新增作物-松萝 ]]
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