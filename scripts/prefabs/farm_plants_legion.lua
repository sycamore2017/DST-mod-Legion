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

local function InitAssets(data, assetspre, assetsbase)
	if assetspre ~= nil then
		for k, v in pairs(assetspre) do
			table.insert(assetsbase, v)
		end
	end

	if data.bank ~= data.build then
		table.insert(assetsbase, Asset("ANIM", "anim/"..data.build..".zip"))
	end

	data.assets = assetsbase
end

local function InitPrefabs(data, prefabspre, prefabsbase)
	if prefabspre ~= nil then
		for k, v in pairs(prefabspre) do
			table.insert(prefabsbase, v)
		end
	end

	if data.product ~= nil then
		table.insert(prefabsbase, data.product)
	end
	if data.product_huge ~= nil then
		table.insert(prefabsbase, data.product_huge)
	end
	if data.seed ~= nil then
		table.insert(prefabsbase, data.seed)
	end

	data.prefabs = prefabsbase
end

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
			costMoisture = 2, --需水量
			costNutrient = 2, --需肥类型(这里只需要一个量即可，不需要关注肥料类型)
			canGetSick = v.canGetSick ~= false, --是否能产生病虫害（原创）
			stages = {}, --该植物生长有几个阶段，每个阶段的动画,以及是否处在花期（原创）
			stages_other = { huge = nil, huge_rot = nil, rot = nil }, --巨大化阶段、巨大化枯萎、枯萎等阶段的数据
			regrowStage = 1, --枯萎或者采摘后重新开始生长的阶段（原创）
			goodSeasons = v.good_seasons, --喜好季节：{autumn = true, winter = true, spring = true, summer = true}
			killjoysTolerance = v.max_killjoys_tolerance, --扫兴容忍度：一般都为0
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

			if v2.hidden then
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
				end
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
				data.costMoisture = 2
			elseif v.moisture == TUNING.FARM_PLANT_DRINK_MED then
				data.costMoisture = 4
			elseif v.moisture == TUNING.FARM_PLANT_DRINK_HIGH then
				data.costMoisture = 8
			end

			--重新改需肥量
			for k3,v3 in pairs(v.nutrient_consumption) do
				if v3 ~= nil and data.costNutrient < v3 then
					data.costNutrient = v3
				end
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

			--确定资源
			InitAssets(data, v.assets, {
				Asset("ANIM", "anim/"..data.bank..".zip"),
				Asset("ANIM", "anim/siving_soil.zip"),
				Asset("SCRIPT", "scripts/prefabs/farm_plant_defs.lua"),
			})
			InitPrefabs(data, v.prefabs, {
				"spoiled_food",
				"farm_plant_happy",
				"farm_plant_unhappy",
				"siving_soil",
				"dirt_puff",
			})

			defs[k] = data
		end
	end
end

for k,v in pairs(WEED_DEFS) do
	local data = {
		assets = nil,
		prefabs = nil,
		tags = v.tags, --undo：请关注extra_tags，可能会用到
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
		costMoisture = 2, --需水量
		costNutrient = 2, --需肥类型(这里只需要一个量即可，不需要关注肥料类型)
		canGetSick = v.canGetSick ~= false, --是否能产生病虫害（原创）
		stages = {}, --该植物生长有几个阶段，每个阶段的动画,以及是否处在花期（原创）
		stages_other = { rot = nil }, --枯萎等阶段的数据
		regrowStage = 1, --枯萎或者采摘后重新开始生长的阶段（原创）
		goodSeasons = v.good_seasons or {}, --喜好季节：{autumn = true, winter = true, spring = true, summer = true}
		killjoysTolerance = v.killjoysTolerance or 1, --扫兴容忍度：杂草为1，容忍度比作物高
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
			data.costMoisture = 2
		elseif v.moisture == TUNING.FARM_PLANT_DRINK_MED then
			data.costMoisture = 4
		elseif v.moisture == TUNING.FARM_PLANT_DRINK_HIGH then
			data.costMoisture = 8
		end

		--重新改需肥量
		for k3,v3 in pairs(v.nutrient_consumption) do
			if v3 ~= nil and data.costNutrient < v3 then
				data.costNutrient = v3
			end
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

		--确定资源
		InitAssets(data, v.assets, {
			Asset("ANIM", "anim/"..data.bank..".zip"),
			Asset("ANIM", "anim/siving_soil.zip"),
			Asset("SCRIPT", "scripts/prefabs/weed_defs.lua"),
		})
		InitPrefabs(data, v.prefabs, { --undo：请关注prefab_deps数据，可能用得到
			"spoiled_food",
			"farm_plant_happy",
			"farm_plant_unhappy",
			"siving_soil",
			"dirt_puff",
		})

		if data.sounds == nil then
			data.sounds = {
				grow_rot = "farming/common/farm/rot",
			}
		end

		defs[k] = data
	end
end

--------------------------------------------------------------------------
--[[ 作物实体代码 ]]
--------------------------------------------------------------------------

local function RemovePlant(inst, lastprefab)
	local x, y, z = inst.Transform:GetWorldPosition()
	if lastprefab ~= nil then
		SpawnPrefab(lastprefab).Transform:SetPosition(x, y, z)
	end
	SpawnPrefab("siving_soil").Transform:SetPosition(x, y, z)
	inst.components.lootdropper:DropLoot()
	inst:Remove()
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

			inst.entity:SetPristine()
			if not TheWorld.ismastersim then
				return inst
			end

			inst:AddComponent("inspectable")
			inst.components.inspectable.nameoverride = "FARM_PLANT"
			inst.components.inspectable.getstatus = function(inst)
				if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
					return "BURNING"
				end

				--undo：这里直接用官方的台词即可，根据不同阶段状态返回不同台词
			end

			inst:AddComponent("hauntable")
			inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

			inst:AddComponent("lootdropper")
			inst.components.lootdropper:SetLootSetupFn(function(lootdropper)
				--undo
			end)

			inst:AddComponent("workable")
			inst.components.workable:SetWorkAction(ACTIONS.DIG)
			inst.components.workable:SetWorkLeft(1)
			inst.components.workable:SetOnFinishCallback(function(inst, worker)
				-- call_for_reinforcements(inst, worker) --查看附近是否有旋针花
				RemovePlant(inst, "dirt_puff")
			end)

			if not data.fireproof then
				MakeSmallBurnable(inst)
				MakeSmallPropagator(inst)
				inst.components.burnable:SetOnBurntFn(function(inst)
					RemovePlant(inst, "ash")
				end)
				inst.components.burnable:SetOnIgniteFn(function(inst, source, doer)
					--undo：停止生长
				end)
				inst.components.burnable:SetOnExtinguishFn(function(inst)
					--undo：继续生长
				end)
			end

			inst:AddComponent("growable")
			inst.components.growable.stages = {}
			inst.components.growable:StopGrowing()
			inst.components.growable.domagicgrowthfn = function(inst, doer)
				-- if inst.canGrow then
				-- 	inst.components.timer:StopTimer("growup")
				-- 	inst:PushEvent("timerdone", { name = "growup" })
				-- end

				--undo：用魔法书时，加速成长，但不会加速腐烂
			end

			inst:AddComponent("farmplanttendable")
			inst.components.farmplanttendable.ontendtofn = function(inst, doer)
				if inst.components.perennialcrop ~= nil then
					inst.components.perennialcrop:TendTo(doer)
				end
				return true
			end

			inst:AddComponent("perennialcrop")
			inst.components.perennialcrop:SetUp(data)
			inst.components.perennialcrop:SetStage(1, false, false, true, false)
			inst.components.perennialcrop:StartGrowing()

			return inst
		end,
		data.assets,
		data.prefabs
	)
end

--------------------
--------------------

for k,v in pairs(defs) do
	table.insert(prefs, MakePlant(v))
end

return unpack(prefs)
