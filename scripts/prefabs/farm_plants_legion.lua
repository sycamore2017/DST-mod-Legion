local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS
local WEED_DEFS = require("prefabs/weed_defs").WEED_DEFS
local prefs = {}
local defs = {}

--------------------------------------------------------------------------
--[[ 合并所有作物数据，并加入个性化数据 ]]
--------------------------------------------------------------------------

local flowerMaps = {
	corn = 			{ sprout = true, small = true, medium = true 			   					 },
	dragonfruit = 	{ 				 small = true, medium = true, grown = true 					 },
	durian = 		{ 				 small = true, medium = true 			   					 },
	eggplant = 		{ 				 small = true, medium = true 			   					 },
	onion = 		{ 				 small = true 							   					 },
	pepper = 		{ 				 small = true, medium = true 			   					 },
	pomegranate = 	{ 				 small = true, medium = true, grown = true, oversized = true },
	potato = 		{ 				 small = true, medium = true 			   					 },
	pumpkin = 		{ 				 small = true, medium = true, grown = true, oversized = true },
	tomato = 		{ 							   medium = true 			   					 },
	watermelon = 	{ 							   medium = true 			   					 },

	weed_forgetmelots = { 			 small = true, medium = true, grown = true 					 },
	weed_ivy = 			{ 						   medium = true, grown = true 					 },
	weed_tillweed = 	{ 			 small = true, medium = true, grown = true 					 },

	pineananas = 	{ 							   medium = true 			   					 },
	gourd =			{ 							   medium = true 			   					 },
}
local regrowMaps = {
	asparagus = 2,
	garlic = 2,
	pumpkin = 3,
	corn = 3,
	onion = 3,
	potato = 3,
	dragonfruit = 3,
	pomegranate = 3,
	eggplant = 3,
	tomato = 3,
	watermelon = 3,
	pepper = 3,
	durian = 3,
	carrot = 2,

	weed_forgetmelots = 1,
	weed_tillweed = 1,
	weed_firenettle = 1,
	weed_ivy = 1,

	pineananas = 3,
	gourd = 3,
}

--mod里再次加载农场作物的动画会导致官方的作物动画不显示。因为官方作物动画有加载顺序限制，一旦mod里引用会导致顺序变化
-- local function InitAssets(data, assetspre, assetsbase)
-- 	if assetspre ~= nil then
-- 		for k, v in pairs(assetspre) do
-- 			table.insert(assetsbase, v)
-- 		end
-- 	end

-- 	if data.bank ~= data.build then
-- 		table.insert(assetsbase, Asset("ANIM", "anim/"..data.build..".zip"))
-- 	end

-- 	data.assets = assetsbase
-- end

--官方的prefabs注册不清楚有啥用，然后还会导致问题，那么，不写了
-- local function InitPrefabs(data, prefabspre, prefabsbase)
-- 	if prefabspre ~= nil then
-- 		for k, v in pairs(prefabspre) do
-- 			table.insert(prefabsbase, v)
-- 		end
-- 	end

-- 	if data.product ~= nil then
-- 		table.insert(prefabsbase, data.product)
-- 	end
-- 	if data.product_huge ~= nil then
-- 		table.insert(prefabsbase, data.product_huge)
-- 	end
-- 	if data.seed ~= nil then
-- 		table.insert(prefabsbase, data.seed)
-- 	end

-- 	data.prefabs = prefabsbase
-- end

for k,v in pairs(PLANT_DEFS) do
	if k ~= "randomseed" then
		local data = {
			assets = nil,
			prefabs = nil,
			tags = v.tags,
			build = v.build,	--贴图
			bank = v.bank,		--动画模板
			fireproof = v.fireproof == true, --是否防火
			weights	= v.weight_data, --重量范围
			sounds = v.sounds, --音效
			prefab = v.prefab.."_legion", --作物 代码名称
			prefab_old = v.prefab, --作物 原代码名称（目前是展示名字时使用）
			product = v.product, --产物 代码名称
			product_huge = v.product_oversized, --巨型产物 代码名称
			seed = v.seed, --种子 代码名称
			loot_huge_rot = v.loot_oversized_rot, --巨型产物腐烂后的收获物
			costMoisture = 1, --需水量
			costNutrient = 2, --需肥类型(这里只需要一个量即可，不需要关注肥料类型)
			canGetSick = v.canGetSick ~= false, --是否能产生病虫害（原创）
			stages = {}, --该植物生长有几个阶段，每个阶段的动画,以及是否处在花期（原创）
			stages_other = { huge = nil, huge_rot = nil, rot = nil }, --巨大化阶段、巨大化枯萎、枯萎等阶段的数据
			regrowStage = 1, --枯萎或者采摘后重新开始生长的阶段（原创）
			eternalStage = v.eternalStage, --长到这个阶段后，就不再往下生长（原创）
			goodSeasons = v.good_seasons, --喜好季节：{autumn = true, winter = true, spring = true, summer = true}
			killjoysTolerance = v.max_killjoys_tolerance, --扫兴容忍度：一般都为0

			fn_common = v.fn_common, --额外设定函数（通用）：fn(inst)
			fn_server = v.fn_server, --额外设定函数（主机）：fn(inst)
			fn_stage = v.fn_stage, --每次设定生长阶段时额外触发的函数：fn(inst, isfull)
		}

		--确定花期map（其他mod想要增加花期，可仿造目前格式写在PLANT_DEFS中即可）
		local flowermap = v.flowerMap or flowerMaps[k]

		--重新改生长阶段数据
		for k2,v2 in pairs(v.plantregistryinfo) do
			local stage = {
				name = v2.text, --该阶段的名字
				anim = v2.anim,
				anim_grow = v2.grow_anim,
				isflower = (flowermap ~= nil and flowermap[v2.text]) or false,
				time = nil --生长时间、或枯萎时间、或重生时间
			}

			if v2.text == "oversized" then
				stage.name = "huge"
				stage.time = 6 * TUNING.TOTAL_DAY_TIME --巨型作物，6天后枯萎
				data.stages_other.huge = stage
			elseif v2.text == "rotting" then
				stage.name = "rot"
				stage.time = 4 * TUNING.TOTAL_DAY_TIME --枯萎作物，4天后重新开始生长
				data.stages_other.rot = stage
			elseif v2.text == "oversized_rotting" then
				stage.name = "huge_rot"
				stage.time = 5 * TUNING.TOTAL_DAY_TIME --巨型枯萎作物，5天后重新开始生长
				data.stages_other.huge_rot = stage
			else
				table.insert(data.stages, stage)
			end
		end

		local countstage = #data.stages
		if countstage >= 3 then
			--确定生长时间
			local averagetime = 7*TUNING.TOTAL_DAY_TIME / (countstage-2) --不算发芽时间，总共7天成熟
			data.stages[1].time = 14 * TUNING.SEG_TIME --14/16天发芽
			data.stages[countstage].time = 4 * TUNING.TOTAL_DAY_TIME --成熟作物，4天后枯萎
			for k3,v3 in pairs(data.stages) do
				if v3.time == nil then
					v3.time = averagetime
				end
			end

			--重新改需水量
			if v.costMoisture ~= nil then --获取自定义的需水量
				data.costMoisture = v.costMoisture
			elseif v.moisture == TUNING.FARM_PLANT_DRINK_LOW then
				data.costMoisture = 1
			elseif v.moisture == TUNING.FARM_PLANT_DRINK_MED then
				data.costMoisture = 2
			elseif v.moisture == TUNING.FARM_PLANT_DRINK_HIGH then
				data.costMoisture = 4
			end

			--重新改需肥量
			for k3,v3 in pairs(v.nutrient_consumption) do
				if v3 ~= nil and data.costNutrient < v3 then
					data.costNutrient = v3
				end
			end
			if data.costNutrient > 2 and data.costNutrient <= 4 then
				data.costNutrient = 3
			elseif data.costNutrient > 4 then
				data.costNutrient = 4
			end

			--确定再生的阶段
			if v.regrowStage ~= nil then
				data.regrowStage = v.regrowStage
			elseif regrowMaps[k] ~= nil then
				data.regrowStage = regrowMaps[k]
			end
			if data.regrowStage >= countstage then
				data.regrowStage = 1
			end

			--勋章的作物，目前都是不腐烂的设定
			if k == "immortal_fruit" or k == "medal_gift_fruit" then
				if data.eternalStage == nil then
					data.eternalStage = countstage --默认就是最终阶段
				end
				data.stages_other.rot = nil
				data.stages_other.huge_rot = nil
			end

			--确定资源
			-- InitAssets(data, v.assets, {
			-- 	Asset("ANIM", "anim/"..data.bank..".zip"),
			-- 	Asset("ANIM", "anim/siving_soil.zip"),
			-- 	-- Asset("SCRIPT", "scripts/prefabs/farm_plant_defs.lua"),
			-- })
			-- InitPrefabs(data, v.prefabs, {
			-- 	"spoiled_food",
			-- 	"farm_plant_happy", "farm_plant_unhappy",
			-- 	"siving_soil",
			-- 	"dirt_puff",
			-- 	"cropgnat", "cropgnat_infester"
			-- })

			defs[k] = data
		end
	end
end

for k,v in pairs(WEED_DEFS) do
	local data = {
		assets = nil,
		prefabs = nil,
		tags = v.tags or v.extra_tags,
		build = v.build,	--贴图
		bank = v.bank,		--动画模板
		fireproof = v.fireproof == true, --是否防火
		-- weights	= nil, --重量范围
		sounds = v.sounds, --音效
		prefab = v.prefab.."_legion", --作物 代码名称
		prefab_old = v.prefab, --作物 原代码名称（目前是展示名字时使用）
		product = v.product, --产物 代码名称（对于杂草，是可能为空的）
		-- product_huge = nil, --巨型产物 代码名称
		-- seed = nil, --种子 代码名称
		-- loot_huge_rot = nil, --巨型产物腐烂后的收获物
		costMoisture = 1, --需水量
		costNutrient = 2, --需肥类型(这里只需要一个量即可，不需要关注肥料类型)
		canGetSick = v.canGetSick ~= false, --是否能产生病虫害（原创）
		stages = {}, --该植物生长有几个阶段，每个阶段的动画,以及是否处在花期（原创）
		stages_other = { rot = nil }, --枯萎等阶段的数据
		regrowStage = 1, --枯萎或者采摘后重新开始生长的阶段（原创）
		eternalStage = v.eternalStage, --长到这个阶段后，就不再往下生长（原创）
		goodSeasons = v.good_seasons or {}, --喜好季节：{autumn = true, winter = true, spring = true, summer = true}
		killjoysTolerance = v.killjoysTolerance or 1, --扫兴容忍度：杂草为1，容忍度比作物高

		fn_common = v.fn_common, --额外设定函数（通用）：fn(inst)
		fn_server = v.fn_server or v.masterpostinit, --额外设定函数（主机）：fn(inst)
		-- fn_stage = v.fn_stage or v.OnMakeFullFn, --每次设定生长阶段时额外触发的函数：fn(inst, isfull)
	}

	--确定花期map（其他mod想要增加花期，可仿造目前格式写在PLANT_DEFS中即可）
	local flowermap = v.flowerMap or flowerMaps[k]

	--重新改生长阶段数据
	for k2,v2 in pairs(v.plantregistryinfo) do
		if v2.text ~= "bolting" then --bolting相当于是杂草的枯萎，但我觉得用picked来当枯萎更好
			local stage = {
				name = v2.text, --该阶段的名字
				anim = v2.anim,
				anim_grow = v2.grow_anim,
				isflower = (flowermap ~= nil and flowermap[v2.text]) or false,
				time = nil --生长时间、或枯萎时间、或重生时间
			}

			if v2.text == "picked" then
				stage.name = "rot"
				stage.time = 4 * TUNING.TOTAL_DAY_TIME --枯萎作物，4天后重新开始生长
				data.stages_other.rot = stage
			else
				table.insert(data.stages, stage)
			end
		end
	end

	local countstage = #data.stages
	if countstage >= 2 then
		--确定生长时间
		local averagetime = 4*TUNING.TOTAL_DAY_TIME / (countstage-1) --不算发芽时间，总共4天成熟
		data.stages[countstage].time = 2 * TUNING.TOTAL_DAY_TIME --成熟作物，2天后枯萎
		for k3,v3 in pairs(data.stages) do
			if v3.time == nil then
				v3.time = averagetime
			end
		end

		--重新改需水量
		if v.costMoisture ~= nil then --获取自定义的需水量
			data.costMoisture = v.costMoisture
		elseif v.moisture == TUNING.FARM_PLANT_DRINK_LOW then
			data.costMoisture = 1
		elseif v.moisture == TUNING.FARM_PLANT_DRINK_MED then
			data.costMoisture = 2
		elseif v.moisture == TUNING.FARM_PLANT_DRINK_HIGH then
			data.costMoisture = 4
		end

		--重新改需肥量
		for k3,v3 in pairs(v.nutrient_consumption) do
			if v3 ~= nil and data.costNutrient < v3 then
				data.costNutrient = v3
			end
		end
		if data.costNutrient > 2 and data.costNutrient <= 4 then
			data.costNutrient = 3
		elseif data.costNutrient > 4 then
			data.costNutrient = 4
		end

		--确定再生的阶段
		if v.regrowStage ~= nil then
			data.regrowStage = v.regrowStage
		elseif regrowMaps[k] ~= nil then
			data.regrowStage = regrowMaps[k]
		end
		if data.regrowStage >= countstage then
			data.regrowStage = 1
		end

		--确定永恒生长阶段
		if data.eternalStage == nil then
			data.eternalStage = countstage --默认就是最终阶段
		end

		--确定资源
		-- InitAssets(data, v.assets, {
		-- 	Asset("ANIM", "anim/"..data.bank..".zip"),
		-- 	Asset("ANIM", "anim/siving_soil.zip"),
		-- 	Asset("SCRIPT", "scripts/prefabs/weed_defs.lua"),
		-- })
		-- InitPrefabs(data, v.prefabs or v.prefab_deps, {
		-- 	"spoiled_food",
		-- 	"farm_plant_happy", "farm_plant_unhappy",
		-- 	"siving_soil",
		-- 	"dirt_puff",
		-- 	"cropgnat", "cropgnat_infester"
		-- })

		if data.sounds == nil then
			data.sounds = {
				grow_rot = "farming/common/farm/rot",
			}
		end

		--设置其他
		if k == "weed_tillweed" then --不能设置犁地草的犁地效果
			data.fn_stage = v.fn_stage
		elseif k == "weed_ivy" then --针刺旋花：官方代码写错了，所以这里修正一下（Klei码师看我看我！！！）
			if v.fn_stage == nil then
				data.fn_stage = function(inst, isfull)
					local has_tag = inst:HasTag("farm_plant_defender")
					if isfull and not has_tag then
						inst:AddTag("farm_plant_defender")
					elseif not isfull and has_tag then
						inst:RemoveTag("farm_plant_defender") --修改：Remove()改为RemoveTag()！！！
					end
				end
			else
				data.fn_stage = v.fn_stage
			end
		else
			data.fn_stage = v.fn_stage or v.OnMakeFullFn
		end

		defs[k] = data
	end
end

--------------------------------------------------------------------------
--[[ 子圭·垄的多年生植物 ]]
--------------------------------------------------------------------------

local function RemovePlant(inst, lastprefab, lootprefab)
	local x, y, z = inst.Transform:GetWorldPosition()
	if lastprefab ~= nil then
		SpawnPrefab(lastprefab).Transform:SetPosition(x, y, z)
	end
	if lootprefab ~= nil then
		inst.components.lootdropper:SpawnLootPrefab(lootprefab)
	end
	inst.components.lootdropper:DropLoot()
	inst:Remove()
end

local function IsTooDarkToGrow(inst)
	if inst.components.perennialcrop then
		if inst.components.perennialcrop:CanGrowInDark() then
			return false
		end
	elseif inst.components.perennialcrop2 then
		if inst.components.perennialcrop2:CanGrowInDark() then
			return false
		end
	end
	return IsTooDarkToGrow_legion(inst)
end

local function UpdateGrowing(inst)
	if (inst.components.burnable == nil or not inst.components.burnable.burning) and not IsTooDarkToGrow(inst) then
		if inst.components.perennialcrop then
			inst.components.perennialcrop:Resume()
		elseif inst.components.perennialcrop2 then
			inst.components.perennialcrop2:Resume()
		end
	else
		if inst.components.perennialcrop then
			inst.components.perennialcrop:Pause()
		elseif inst.components.perennialcrop2 then
			inst.components.perennialcrop2:Pause()
		end
	end
end

local function OnIsDark(inst)
	UpdateGrowing(inst)
	if TheWorld.state.isnight then
		if inst.nighttask == nil then
			inst.nighttask = inst:DoPeriodicTask(5, UpdateGrowing, math.random() * 5)
		end
	else
		if inst.nighttask ~= nil then
			inst.nighttask:Cancel()
			inst.nighttask = nil
		end
	end
end

local function OnIsRaining(inst)
	if inst.components.perennialcrop then
		--不管雨始还是雨停，增加一半的蓄水量(反正一场雨结束，总共只加最大蓄水量的数值)
		inst.components.perennialcrop:PourWater(nil, nil, inst.components.perennialcrop.moisture_max/2)
	elseif inst.components.perennialcrop2 then
		inst.components.perennialcrop2:PourWater(nil, nil, 1)
	end
end

local function MakePlant(data)
	return Prefab(
		data.prefab,
		function()
			local inst = CreateEntity()

			inst.entity:AddTransform()
			inst.entity:AddAnimState()
			inst.entity:AddSoundEmitter()
			inst.entity:AddNetwork()

			MakeInventoryPhysics(inst)

			inst.AnimState:SetBank(data.bank)
			inst.AnimState:SetBuild(data.build)
			inst.AnimState:OverrideSymbol("soil01", "siving_soil", "soil01")

			inst:SetPhysicsRadiusOverride(TUNING.FARM_PLANT_PHYSICS_RADIUS)

			inst:AddTag("plant")
			inst:AddTag("crop_legion")
			inst:AddTag("tendable_farmplant") -- for farmplanttendable component
			if data.tags ~= nil then
				for k, v in pairs(data.tags) do
					inst:AddTag(v)
				end
			end

			inst.displaynamefn = function(inst)
				local stagename = nil
				for k, v in pairs(data.stages) do
					if v ~= nil then
						if inst.AnimState:IsCurrentAnimation(v.anim) or inst.AnimState:IsCurrentAnimation(v.anim_grow) then
							stagename = v.name
							break
						end
					end
				end
				for k, v in pairs(data.stages_other) do
					if v ~= nil then
						if inst.AnimState:IsCurrentAnimation(v.anim) or inst.AnimState:IsCurrentAnimation(v.anim_grow) then
							stagename = v.name
							break
						end
					end
				end

				local basename = STRINGS.NAMES[string.upper(data.prefab_old)]
				if stagename == nil then
					return basename
				elseif STRINGS.CROP_LEGION[string.upper(stagename)] ~= nil then
					return subfmt(STRINGS.CROP_LEGION[string.upper(stagename)], {crop = basename})
				else
					return subfmt(STRINGS.CROP_LEGION.GROWING, {crop = basename})
				end
			end

			if data.fn_common ~= nil then
				data.fn_common(inst)
			end

			inst.entity:SetPristine()
			if not TheWorld.ismastersim then
				return inst
			end

			inst:AddComponent("inspectable")
			inst.components.inspectable.nameoverride = "FARM_PLANT"
			inst.components.inspectable.descriptionfn = function(inst, doer) --提示自身的生长数据
				return inst.components.perennialcrop:SayDetail(doer, false)
			end
			inst.components.inspectable.getstatus = function(inst)
				if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
					return "BURNING"
				end

				local crop = inst.components.perennialcrop

				if crop.stagedata.name == "seed" then
					return "SEED"
				elseif crop.isrotten then
					return crop.ishuge and "ROTTEN_OVERSIZED" or "ROTTEN"
				elseif crop.stage == crop.stage_max then
					return crop.ishuge and "FULL_OVERSIZED" or "FULL"
				else
					return "GROWING"
				end
			end

			inst:AddComponent("hauntable")
			inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

			inst:AddComponent("lootdropper")
			inst.components.lootdropper:SetLootSetupFn(function(lootdropper)
				local crop = lootdropper.inst.components.perennialcrop
				local numfruitplus = crop.pollinated >= crop.pollinated_max

				if crop.ishuge then
					if crop.isrotten then
						lootdropper:SetLoot(data.loot_huge_rot)
					else
						lootdropper:SetLoot(numfruitplus and {data.product_huge, data.product} or {data.product_huge})
					end
				elseif crop.stage < crop.stage_max then
					if crop.isrotten then
						lootdropper:SetLoot({"spoiled_food"})
					else
						local loot = math.random() < 0.5 and {"cutgrass"} or {"twigs"}
						if crop.isflower then
							table.insert(loot, "petals")
						end
						lootdropper:SetLoot(loot)
					end
				else
					local numfruit = 1
					if crop.num_perfect ~= nil then
						if crop.num_perfect >= 5 then
							numfruit = 3
						elseif crop.num_perfect > 2 then
							numfruit = 2
						end
					end
					if numfruitplus then
						numfruit = numfruit + 1
					end

					local loot = {}
					local product = crop.isrotten and "spoiled_food" or (data.product or "cutgrass")
					for i = 1, numfruit, 1 do
						table.insert(loot, product)
					end
					lootdropper:SetLoot(loot)
				end
			end)

			inst:AddComponent("workable")
			inst.components.workable:SetWorkAction(ACTIONS.DIG)
			inst.components.workable:SetWorkLeft(1)
			inst.components.workable:SetOnFinishCallback(function(inst, worker)
				if inst.components.perennialcrop.fn_defend ~= nil then
					inst.components.perennialcrop.fn_defend(inst, worker)
				end
				RemovePlant(inst, "dirt_puff", "siving_soil_item") --被破坏，生成未放置的栽培土
			end)

			if not data.fireproof then
				MakeSmallBurnable(inst)
				MakeSmallPropagator(inst)
				inst.components.burnable:SetOnBurntFn(function(inst)
					RemovePlant(inst, "siving_soil", "ash") --被烧掉，生成被放置的栽培土
				end)
				inst.components.burnable:SetOnIgniteFn(function(inst, source, doer)
					UpdateGrowing(inst)
				end)
				inst.components.burnable:SetOnExtinguishFn(function(inst)
					UpdateGrowing(inst)
				end)
			end

			inst:AddComponent("growable")
			inst.components.growable.stages = {}
			inst.components.growable:StopGrowing()
			inst.components.growable.magicgrowable = true --非常规造林学生效标志（其他会由组件来施行）
			inst.components.growable.domagicgrowthfn = function(inst, doer)
				if inst:IsValid() then
					return inst.components.perennialcrop:DoMagicGrowth(doer, 2*TUNING.TOTAL_DAY_TIME)
				end
				return false
			end
			inst.components.growable.GetCurrentStageData = function(self) return { tendable = false } end

			inst:AddComponent("farmplanttendable")
			inst.components.farmplanttendable.ontendtofn = function(inst, doer)
				inst.components.perennialcrop:TendTo(doer, true)
				return true
			end

			inst:AddComponent("perennialcrop")
			inst.components.perennialcrop:SetUp(data)
			inst.components.perennialcrop.fn_defend = function(inst, target)
				if target ~= nil then
					inst:RemoveTag("farm_plant_defender")

					local x, y, z = inst.Transform:GetWorldPosition()
					local defenders = TheSim:FindEntities(x, y, z, TUNING.FARM_PLANT_DEFENDER_SEARCH_DIST, {"farm_plant_defender"})
					for _, defender in ipairs(defenders) do
						if defender.components.burnable == nil or not defender.components.burnable.burning then
							defender:PushEvent("defend_farm_plant", {source = inst, target = target})
							break
						end
					end
				end
			end
			inst.components.perennialcrop:SetStage(1, false, false, true, false)
			inst.components.perennialcrop:StartGrowing()
			inst.components.perennialcrop.onctlchange = function(inst, ctls)
				local types = {}
				for guid,ctl in pairs(ctls) do
					if ctl:IsValid() and ctl.components.botanycontroller ~= nil then
						local type = ctl.components.botanycontroller.type
						if type == 3 then
							types[3] = true
							break
						elseif type == 2 then
							types[2] = true
						elseif type == 1 then
							types[1] = true
						end

						if types[2] and types[1] then
							types[3] = true
							break
						end
					end
				end

				if types[3] or (types[2] and types[1]) then
					inst.AnimState:OverrideSymbol("soil01", "siving_soil", "soil04")
				elseif types[2] then
					inst.AnimState:OverrideSymbol("soil01", "siving_soil", "soil03")
				elseif types[1] then
					inst.AnimState:OverrideSymbol("soil01", "siving_soil", "soil02")
				else
					inst.AnimState:OverrideSymbol("soil01", "siving_soil", "soil01")
				end
			end

			inst:AddComponent("moisture") --浇水机制由潮湿度组件控制（能让水球、神话的玉净瓶等起作用）
			inst.components.moisture.OnUpdate = function(self, ...) end --取消下雨时的潮湿度增加
			inst.components.moisture.OnSave = function(self, ...) end
			inst.components.moisture.OnLoad = function(self, ...) end
			inst.components.moisture.DoDelta = function(self, num, ...)
				if num > 0 then
					self.inst.components.perennialcrop:PourWater(nil, nil, num)
				end
			end

			inst:WatchWorldState("israining", OnIsRaining) --下雨时补充水分
			inst:WatchWorldState("isnight", OnIsDark) --黑暗中无法继续生长
			inst:DoTaskInTime(0, function()
				OnIsDark(inst)
			end)

			inst.fn_planted = function(inst, pt)
				--寻找周围的管理器
				local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 20,
					{ "siving_ctl" },
					{ "NOCLICK", "INLIMBO" },
					nil
				)
				for _,v in pairs(ents) do
					if v:IsValid() and v.components.botanycontroller ~= nil then
						inst.components.perennialcrop:TriggerController(v, true, true)
					end
				end
				if TheWorld.state.israining or TheWorld.state.issnowing then
					inst.components.perennialcrop:PourWater(nil, nil, inst.components.perennialcrop.moisture_max/2)
				end
			end

			if data.fn_server ~= nil then
				data.fn_server(inst)
			end

			return inst
		end,
		data.assets,
		data.prefabs
	)
end

--------------------------------------------------------------------------
--[[ 旧版的多年生植物 ]]
--------------------------------------------------------------------------

local function MakePlant2(cropprefab, sets)
	local assets = sets.assets or {}
	table.insert(assets, Asset("ANIM", "anim/"..sets.bank..".zip"))
	if sets.bank ~= sets.build then
		table.insert(assets, Asset("ANIM", "anim/"..sets.build..".zip"))
	end
	table.insert(assets, Asset("ANIM", "anim/crop_soil_legion.zip"))

	return Prefab(
		"plant_"..cropprefab.."_l",
		function()
			local inst = CreateEntity()

			inst.entity:AddTransform()
			inst.entity:AddAnimState()
			inst.entity:AddMiniMapEntity()
			inst.entity:AddSoundEmitter()
			inst.entity:AddNetwork()

			inst.AnimState:SetBank(sets.bank)
			inst.AnimState:SetBuild(sets.build)
			inst.AnimState:PlayAnimation(sets.leveldata[1].anim)
			if sets.bank == "plant_normal_legion" then
				-- inst.AnimState:OverrideSymbol("dirt", "crop_soil_legion", "dirt")
			else
				inst.AnimState:OverrideSymbol("soil", "crop_soil_legion", "soil")
			end

			inst.MiniMapEntity:SetIcon("plant_crop_l.tex")

			inst:AddTag("plant")
			inst:AddTag("crop2_legion")
			inst:AddTag("tendable_farmplant") -- for farmplanttendable component

			inst.displaynamefn = function(inst) --名字，主要是特殊的阶段加点前缀
				local namepre = ""
				if inst:HasTag("nognatinfest") then
					namepre = STRINGS.PLANT_CROP_L["WITHERED"]
				else
					if inst:HasTag("tendable_farmplant") then --可以照顾
						namepre = namepre..STRINGS.PLANT_CROP_L["BLUE"]
					end
					if inst:HasTag("needwater") then --可以浇水
						namepre = namepre..STRINGS.PLANT_CROP_L["DRY"]
					end
					if inst:HasTag("fertableall") then --可以施肥
						namepre = namepre..STRINGS.PLANT_CROP_L["FEEBLE"]
					end
					if namepre ~= "" then
						namepre = namepre..STRINGS.PLANT_CROP_L["PREPOSITION"]
					end
					if inst:HasTag("flower") then --花期
						namepre = namepre..STRINGS.PLANT_CROP_L["FLORESCENCE"]
					end
				end
				return namepre..STRINGS.NAMES[string.upper("plant_"..cropprefab.."_l")]
			end

			if sets.fn_common ~= nil then
				sets.fn_common(inst)
			end

			inst.entity:SetPristine()
			if not TheWorld.ismastersim then
				return inst
			end

			inst:AddComponent("inspectable")
			inst.components.inspectable.nameoverride = "PLANT_CROP_L" --用来统一描述，懒得每种作物都搞个描述了
    		inst.components.inspectable.getstatus = function(inst)
				local crop = inst.components.perennialcrop2
				return (crop == nil and "GROWING")
					or (crop.isrotten and "WITHERED")
					or (crop.stage == crop.stage_max and "READY")
					or (crop.isflower and "FLORESCENCE")
					or (crop.stage <= 2 and "SPROUT")
					or "GROWING"
			end

			inst:AddComponent("lootdropper")
			inst.components.lootdropper:SetLootSetupFn(function(lootdropper)
				local crop = lootdropper.inst.components.perennialcrop2
				local loots = {}

				if crop.fn_loot ~= nil then
					crop.fn_loot(crop.inst, loots)
				elseif crop.stage == crop.stage_max then
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
					end
				end

				if lootdropper.inst.worked_l then --说明是被破坏的
					lootdropper.inst.worked_l = nil
					if crop.level and crop.level.witheredprefab then
						for _,prefab in ipairs(crop.level.witheredprefab) do
							table.insert(loots, prefab)
						end
					end
				end

				if crop.isflower and not crop.isrotten then
					for i = 1, 3, 1 do
						table.insert(loots, "petals")
					end
				elseif crop.stage > 1 and #loots <= 0 then
					table.insert(loots, crop.isrotten and "spoiled_food" or "cutgrass")
				end

				lootdropper:SetLoot(loots)
			end)

			inst:AddComponent("hauntable")
			inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
			inst.components.hauntable:SetOnHauntFn(function(inst, haunter)
				if inst.components.perennialcrop2 ~= nil and math.random() <= TUNING.HAUNT_CHANCE_OFTEN then
					local fert = SpawnPrefab("spoiled_food")
					inst.components.perennialcrop2:Fertilize(fert, haunter)
					fert:Remove()
					return true
				end
				return false
			end)

			inst:AddComponent("growable")
			inst.components.growable.stages = {}
			inst.components.growable:StopGrowing()
			inst.components.growable.magicgrowable = true --非常规造林学生效标志（其他会由组件来施行）
			inst.components.growable.domagicgrowthfn = function(inst, doer)
				if inst:IsValid() then
					return inst.components.perennialcrop2:DoMagicGrowth(doer, 8*TUNING.TOTAL_DAY_TIME)
				end
				return false
			end
			inst.components.growable.GetCurrentStageData = function(self) return { tendable = false } end

			inst:AddComponent("farmplanttendable")
			inst.components.farmplanttendable.ontendtofn = function(inst, doer)
				inst.components.perennialcrop2:TendTo(doer, true)
				return true
			end

			inst:AddComponent("moisture") --浇水机制由潮湿度组件控制（能让水球、神话的玉净瓶等起作用）
			inst.components.moisture.OnUpdate = function(self, ...) end --取消下雨时的潮湿度增加
			inst.components.moisture.OnSave = function(self, ...) end
			inst.components.moisture.OnLoad = function(self, ...) end
			inst.components.moisture.DoDelta = function(self, num, ...)
				if num > 0 then
					self.inst.components.perennialcrop2:PourWater(nil, nil, num)
				end
			end

			inst:AddComponent("workable")
			inst.components.workable:SetWorkAction(ACTIONS.DIG)
			inst.components.workable:SetWorkLeft(1)
			inst.components.workable:SetOnFinishCallback(function(inst, worker)
				local crop = inst.components.perennialcrop2
				if crop.fn_defend ~= nil then
					crop.fn_defend(inst, worker)
				end
				inst.worked_l = true
				RemovePlant(inst, "dirt_puff", "seeds_"..crop.cropprefab.."_l")
			end)

			if not sets.fireproof then
				MakeSmallBurnable(inst)
				MakeSmallPropagator(inst)
				inst.components.burnable:SetOnBurntFn(function(inst)
					inst.worked_l = true
					RemovePlant(inst, nil, "seeds_"..inst.components.perennialcrop2.cropprefab.."_l")
				end)
				inst.components.burnable:SetOnIgniteFn(function(inst, source, doer)
					UpdateGrowing(inst)
				end)
				inst.components.burnable:SetOnExtinguishFn(function(inst)
					UpdateGrowing(inst)
				end)
			end

			inst:AddComponent("perennialcrop2")
			inst.components.perennialcrop2:SetUp(cropprefab, sets)
			inst.components.perennialcrop2.fn_defend = function(inst, target)
				if target ~= nil then
					inst:RemoveTag("farm_plant_defender")

					local x, y, z = inst.Transform:GetWorldPosition()
					local defenders = TheSim:FindEntities(x, y, z, TUNING.FARM_PLANT_DEFENDER_SEARCH_DIST, {"farm_plant_defender"})
					for _, defender in ipairs(defenders) do
						if defender.components.burnable == nil or not defender.components.burnable.burning then
							defender:PushEvent("defend_farm_plant", {source = inst, target = target})
							break
						end
					end
				end

				if sets.fn_defend ~= nil then
					sets.fn_defend(inst, target)
				end
			end
			inst.components.perennialcrop2:SetStage(1, false, false)
			inst.components.perennialcrop2:StartGrowing()

			inst:WatchWorldState("israining", OnIsRaining) --下雨时补充水分
			inst:WatchWorldState("isnight", OnIsDark) --黑暗中无法继续生长
			inst:DoTaskInTime(0, function()
				OnIsDark(inst)
			end)

			--季节变换时更新生长速度，我觉得没必要了，因为OnEntityWake就已经更新得很勤了
			-- inst:WatchWorldState("iswinter", TogglePickable)

			inst.fn_planted = function(inst, pt)
				local cpt = inst.components.perennialcrop2
				local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 20, --寻找周围的管理器
					{ "siving_ctl" },
					{ "NOCLICK", "INLIMBO" },
					nil
				)
				for _,v in pairs(ents) do
					if v:IsValid() and v.components.botanycontroller ~= nil then
						cpt:TriggerController(v, true, true)
					end
				end
				cpt:CostNutrition()
				if cpt.donemoisture or cpt.donenutrient or cpt.donetendable then
					--由于走的不是正常流程，这里得补上对照料的纠正
					inst.components.farmplanttendable:SetTendable(not cpt.donetendable)
					cpt:StartGrowing() --由于 CostNutrition() 不会主动更新生长时间，这里手动更新
				end
			end

			if sets.fn_server ~= nil then
				sets.fn_server(inst)
			end

			return inst
		end,
		assets,
		sets.prefabs
	)
end

--------------------
--------------------

for k,v in pairs(defs) do
	table.insert(prefs, MakePlant(v))
end

for k,v in pairs(CROPS_DATA_LEGION) do
	table.insert(prefs, MakePlant2(k, v))
end

return unpack(prefs)
