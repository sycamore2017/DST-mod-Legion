local prefabFiles = {
    "siving_rocks_legion",
    "farm_plants_legion",
    "cropgnat",
    "ahandfulofwings",
    "boltwingout",
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

_G.RegistMiniMapImage_legion("siving_derivant")
_G.RegistMiniMapImage_legion("siving_thetree")

AddRecipe(
    "siving_soil_item", {
        Ingredient("siving_rocks", 6, "images/inventoryimages/siving_rocks.xml"),
        Ingredient("pinecone", 20),
    }, RECIPETABS.FARM, TECH.MAGIC_TWO, nil, nil, nil, nil, nil,
    "images/inventoryimages/siving_soil_item.xml", "siving_soil_item.tex"
)

--这个配方用来便于绿宝石法杖分解
AddRecipe(
    "siving_soil", {
        Ingredient("siving_rocks", 6, "images/inventoryimages/siving_rocks.xml"),
        Ingredient("pinecone", 20),
    }, nil, TECH.LOST
)

AddRecipe(
    "boltwingout", {
        Ingredient("ahandfulofwings", 36, "images/inventoryimages/ahandfulofwings.xml"),
        Ingredient("glommerwings", 1),
        Ingredient("stinger", 36),
    }, RECIPETABS.SURVIVAL, TECH.SCIENCE_TWO, nil, nil, nil, nil, nil,
    "images/inventoryimages/boltwingout.xml", "boltwingout.tex"
)

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
--[[ 添加新动作：让种子能种在子圭栽培土里 ]]
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
local function OnPlant(seed, doer, soil)
    if seed.components.farmplantable ~= nil and seed.components.farmplantable.plant ~= nil then
        local pt = soil:GetPosition()

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

            soil:Remove()
            seed:Remove()

            return true
        end
    end
    return false
end

local PLANTSOIL_LEGION = Action({ theme_music = "farming" })
PLANTSOIL_LEGION.id = "PLANTSOIL_LEGION"
PLANTSOIL_LEGION.str = STRINGS.ACTIONS.PLANTSOIL
PLANTSOIL_LEGION.fn = function(act)
    if
        act.invobject ~= nil and
        act.doer.components.inventory ~= nil and
        act.target ~= nil and act.target:HasTag("soil_legion")
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
    if target:HasTag("soil_legion") and not target:HasTag("NOCLICK") then
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
--[[ 让施肥组件能作用于多年生作物 ]]
--------------------------------------------------------------------------

local FERTILIZE_old = ACTIONS.FERTILIZE.fn
ACTIONS.FERTILIZE.fn = function(act)
    if
        act.invobject ~= nil and act.invobject.components.fertilizer ~= nil
        and act.target ~= nil and act.target.components.perennialcrop ~= nil
        and act.doer ~= nil and not (act.doer.components.rider ~= nil and act.doer.components.rider:IsRiding())
    then
        if act.target.components.perennialcrop:Fertilize(act.invobject, act.doer) then
            act.invobject.components.fertilizer:OnApplied(act.doer, act.target)
            return true
        else
            return false
        end
    end
    return FERTILIZE_old(act)
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

            if act.target.components.perennialcrop ~= nil then
                act.target.components.perennialcrop:PourWater(act.invobject, act.doer, nil)
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

        SpawnPrefab("boltwingout_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
        SpawnPrefab("boltwingout_shuck").Transform:SetPosition(inst.Transform:GetWorldPosition())

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
