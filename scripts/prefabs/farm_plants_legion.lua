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

local function EmptyCptFn(self, ...)
	--nothing
end

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
	if inst.components.perennialcrop:CanGrowInDark() then
		return false
	end
	return IsTooDarkToGrow_legion(inst)
end
local function UpdateGrowing(inst)
	if (inst.components.burnable == nil or not inst.components.burnable.burning) and not IsTooDarkToGrow(inst) then
		inst.components.perennialcrop:Resume()
	else
		inst.components.perennialcrop:Pause()
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
	end
end

local function CallDefender(inst, target)
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

local function MakePlant(data)
	return Prefab(
		data.prefab,
		function()
			local inst = CreateEntity()

			inst.entity:AddTransform()
			inst.entity:AddAnimState()
			inst.entity:AddSoundEmitter()
			inst.entity:AddNetwork()

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
			inst.components.farmplanttendable.OnSave = EmptyCptFn --照顾组件的数据不能保存下来，否则会影响 perennialcrop
			inst.components.farmplanttendable.OnLoad = EmptyCptFn

			inst:AddComponent("perennialcrop")
			inst.components.perennialcrop:SetUp(data)
			inst.components.perennialcrop.fn_defend = CallDefender
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
			inst.components.moisture.OnUpdate = EmptyCptFn --取消下雨时的潮湿度增加
			inst.components.moisture.OnSave = EmptyCptFn
			inst.components.moisture.OnLoad = EmptyCptFn
			inst.components.moisture.DoDelta = function(self, num, ...)
				if num > 0 then
					self.inst.components.perennialcrop:PourWater(nil, nil, num)
				end
			end

			inst:WatchWorldState("israining", OnIsRaining) --下雨时补充水分
			inst:WatchWorldState("isnight", OnIsDark) --黑暗中无法继续生长
			-- inst:ListenForEvent("seasontick", OnSeasonTick) --季节变换时更新生长速度（不用了，本来每天就会更新生长）
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
--[[ 异种植物 ]]
--------------------------------------------------------------------------

local function GetStatus_p2(inst)
	local crop = inst.components.perennialcrop2
	return (crop == nil and "GROWING")
		or (crop.isrotten and "WITHERED")
		or (crop.stage == crop.stage_max and "READY")
		or (crop.level.pickable == 1 and "READY")
		or (crop.isflower and "FLORESCENCE")
		-- or (crop.stage <= 2 and "SPROUT")
		or "GROWING"
end
local function DisplayName_p2(inst) --特殊的阶段加点前缀
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

	namepre = namepre..STRINGS.NAMES[string.upper(inst.prefab or "plant_carrot_l")]

	local cluster = inst._cluster_l:value()
	if cluster ~= nil and cluster > 0 then
		namepre = namepre.."(Lv."..tostring(cluster)..")"
	end

	return namepre
end
local function OnHaunt_p2(inst, haunter)
	if inst:HasTag("fertableall") and math.random() <= TUNING.HAUNT_CHANCE_OFTEN then
		local fert = SpawnPrefab("spoiled_food")
		inst.components.perennialcrop2:Fertilize(fert, haunter)
		fert:Remove()
		return true
	end
	return false
end
local function OnPlant_p2(inst, pt)
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
local function DoMagicGrowth_p2(inst, doer)
	if inst:IsValid() then
		return inst.components.perennialcrop2:DoMagicGrowth(doer, 6*TUNING.TOTAL_DAY_TIME, false)
	end
	return false
end
local function OnTendTo_p2(inst, doer)
	inst.components.perennialcrop2:TendTo(doer, true)
	return true
end
local function OnMoiWater_p2(self, num, ...)
	if num > 0 then
		self.inst.components.perennialcrop2:PourWater(nil, nil, num)
	end
end
local function OnWorkedFinish_p2(inst, worker)
	local crop = inst.components.perennialcrop2

	local x, y, z = inst.Transform:GetWorldPosition()
	SpawnPrefab("dirt_puff").Transform:SetPosition(x, y, z)

	if crop.fn_defend ~= nil then
		crop.fn_defend(inst, worker)
	end
	crop:GenerateLoot(worker, false, false)
	inst:Remove()
end

local function OnIsRaining_p2(inst)
	inst.components.perennialcrop2:PourWater(nil, nil, 1)
end
local function IsTooDarkToGrow_p2(inst)
	if inst.components.perennialcrop2:CanGrowInDark() then
		return false
	end
	return IsTooDarkToGrow_legion(inst)
end
local function UpdateGrowing_p2(inst)
	if (inst.components.burnable == nil or not inst.components.burnable.burning) and not IsTooDarkToGrow_p2(inst) then
		inst.components.perennialcrop2:Resume()
	else
		inst.components.perennialcrop2:Pause()
	end
end
local function OnIsDark_p2(inst)
	UpdateGrowing_p2(inst)
	if TheWorld.state.isnight then
		if inst.nighttask == nil then
			inst.nighttask = inst:DoPeriodicTask(5, UpdateGrowing_p2, math.random() * 5)
		end
	else
		if inst.nighttask ~= nil then
			inst.nighttask:Cancel()
			inst.nighttask = nil
		end
	end
end

local function OnIgnite_p2(inst, source, doer)
	UpdateGrowing_p2(inst)
end
local function OnExtinguish_p2(inst)
	UpdateGrowing_p2(inst)
end
local function OnBurnt_p2(inst)
	inst.components.perennialcrop2:GenerateLoot(nil, false, true)
	inst:Remove()
end

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
			-- inst.AnimState:PlayAnimation(sets.leveldata[1].anim, true) --组件里会设置动画的

			inst:SetPhysicsRadiusOverride(TUNING.FARM_PLANT_PHYSICS_RADIUS)

			if sets.bank == "plant_normal_legion" then
				-- inst.AnimState:OverrideSymbol("dirt", "crop_soil_legion", "dirt")
			else
				inst.AnimState:OverrideSymbol("soil", "crop_soil_legion", "soil")
			end

			inst.MiniMapEntity:SetIcon("plant_crop_l.tex")

			inst:AddTag("plant")
			inst:AddTag("crop2_legion")
			inst:AddTag("tendable_farmplant") -- for farmplanttendable component

			inst._cluster_l = net_byte(inst.GUID, "plant_crop_l._cluster_l", "cluster_l_dirty")

			inst.displaynamefn = DisplayName_p2

			if sets.fn_common ~= nil then
				sets.fn_common(inst)
			end

			inst.entity:SetPristine()
			if not TheWorld.ismastersim then
				return inst
			end

			inst:AddComponent("inspectable")
			inst.components.inspectable.nameoverride = "PLANT_CROP_L" --用来统一描述，懒得每种作物都搞个描述了
    		inst.components.inspectable.getstatus = GetStatus_p2

			-- inst:AddComponent("lootdropper")

			inst:AddComponent("hauntable")
			inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
			inst.components.hauntable:SetOnHauntFn(OnHaunt_p2)

			if not sets.nomagicgrow then --无法被魔法催熟，就不需要这个组件
				inst:AddComponent("growable")
				inst.components.growable.stages = {}
				inst.components.growable:StopGrowing()
				inst.components.growable.magicgrowable = true --非常规造林学生效标志（其他会由组件来施行）
				inst.components.growable.domagicgrowthfn = DoMagicGrowth_p2
				inst.components.growable.GetCurrentStageData = function(self) return { tendable = false } end
			end

			inst:AddComponent("farmplanttendable")
			inst.components.farmplanttendable.ontendtofn = OnTendTo_p2
			inst.components.farmplanttendable.OnSave = EmptyCptFn --照顾组件的数据不能保存下来，否则会影响 perennialcrop2
			inst.components.farmplanttendable.OnLoad = EmptyCptFn

			inst:AddComponent("moisture") --浇水机制由潮湿度组件控制（能让水球、神话的玉净瓶等起作用）
			inst.components.moisture.OnUpdate = EmptyCptFn --取消下雨时的潮湿度增加
			inst.components.moisture.OnSave = EmptyCptFn
			inst.components.moisture.OnLoad = EmptyCptFn
			inst.components.moisture.DoDelta = OnMoiWater_p2

			inst:AddComponent("workable")
			inst.components.workable:SetWorkAction(ACTIONS.DIG)
			inst.components.workable:SetWorkLeft(1)
			inst.components.workable:SetOnFinishCallback(OnWorkedFinish_p2)

			if not sets.fireproof then
				MakeSmallBurnable(inst)
				MakeSmallPropagator(inst)
				inst.components.burnable:SetOnIgniteFn(OnIgnite_p2)
				inst.components.burnable:SetOnExtinguishFn(OnExtinguish_p2)
				inst.components.burnable:SetOnBurntFn(OnBurnt_p2)
			end

			inst:AddComponent("perennialcrop2")
			inst.components.perennialcrop2:SetUp(cropprefab, sets)
			inst.components.perennialcrop2.fn_defend = function(inst, target)
				CallDefender(inst, target)
				if sets.fn_defend ~= nil then
					sets.fn_defend(inst, target)
				end
			end
			inst.components.perennialcrop2:SetStage(1, false, false)
			inst.components.perennialcrop2:StartGrowing()

			inst:WatchWorldState("israining", OnIsRaining_p2) --下雨时补充水分
			inst:WatchWorldState("isnight", OnIsDark_p2) --黑暗中无法继续生长
			-- inst:ListenForEvent("seasontick", OnSeasonTick_p2) --季节变换时更新生长速度（不用了，本来每天就会更新生长）
			inst:DoTaskInTime(0, function()
				OnIsDark_p2(inst)
			end)

			inst.fn_planted = OnPlant_p2

			if sets.fn_server ~= nil then
				sets.fn_server(inst)
			end

			return inst
		end,
		assets,
		sets.prefabs
	)
end

--------------------------------------------------------------------------
--[[ 活性组织 ]]
--------------------------------------------------------------------------

local function MakeTissue(name)
	local myname = "tissue_l_"..name
	local assets = {
		Asset("ANIM", "anim/tissue_l.zip"),
		Asset("ATLAS", "images/inventoryimages/"..myname..".xml"),
    	Asset("IMAGE", "images/inventoryimages/"..myname..".tex")
	}

	table.insert(prefs, Prefab(
		myname,
		function()
			local inst = CreateEntity()

			inst.entity:AddTransform()
			inst.entity:AddAnimState()
			inst.entity:AddNetwork()

			MakeInventoryPhysics(inst)

			inst.AnimState:SetBank("tissue_l")
			inst.AnimState:SetBuild("tissue_l")
			inst.AnimState:PlayAnimation("idle_"..name, false)

			inst:AddTag("tissue_l") --这个标签没啥用，就想加上而已

			MakeInventoryFloatable(inst, "small", 0.1, 1)
			-- local OnLandedClient_old = inst.components.floater.OnLandedClient
			-- inst.components.floater.OnLandedClient = function(self)
			-- 	OnLandedClient_old(self)
			-- 	self.inst.AnimState:SetFloatParams(0.02, 1, self.bob_percent)
			-- end

			inst.entity:SetPristine()
			if not TheWorld.ismastersim then
				return inst
			end

			inst:AddComponent("inspectable")
			inst.components.inspectable.nameoverride = "TISSUE_L" --用来统一描述

			inst:AddComponent("inventoryitem")
			inst.components.inventoryitem.imagename = myname
			inst.components.inventoryitem.atlasname = "images/inventoryimages/"..myname..".xml"

			inst:AddComponent("stackable")
            inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

			inst:AddComponent("tradable")

			inst:AddComponent("fuel")
            inst.components.fuel.fuelvalue = TUNING.TINY_FUEL

			MakeSmallBurnable(inst)
            MakeSmallPropagator(inst)

			MakeHauntableLaunchAndIgnite(inst)

			return inst
		end,
		assets, nil
	))
end

MakeTissue("cactus")
MakeTissue("lureplant")

--------------------------------------------------------------------------
--[[ 胡萝卜长枪 ]]
--------------------------------------------------------------------------

local atk_min_carl = 34
local atk_max_carl = 68
local rad_min_carl = 0
local rad_max_carl = 2.2
local num_max_carl = 60

local function UpdateCarrot(inst, force)
	local num = 0.0
	for k,v in pairs(inst.components.container.slots) do
		if v and (v.prefab == "carrot" or v.prefab == "carrot_cooked") then
			if v.components.stackable ~= nil then
				num = num + v.components.stackable:StackSize()
			else
				num = num + 1
			end
		end
	end

	if not force and inst.num_carrot_l == num then --防止一直计算
		return
	end

	inst.num_carrot_l = num
	if num > num_max_carl then
		num = num_max_carl
	end
	inst.components.weapon:SetDamage(math.floor( Remap(num, 0, num_max_carl, atk_min_carl, atk_max_carl) ))

	local va = Remap(num, 0, num_max_carl, rad_min_carl, rad_max_carl)
	va = (math.floor(va*10)) / 10 --这一些操作是为了仅保留小数点后1位
	inst.components.weapon:SetRange(va)
end
local function OnOwnerItemChange_carl(owner, data)
	local hands = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	if hands ~= nil and hands.prefab == "lance_carrot_l" then
		if hands.task_carrot_l ~= nil then
			hands.task_carrot_l:Cancel()
		end
		hands.task_carrot_l = hands:DoTaskInTime(0, function(hands)
			if hands.components.container ~= nil then
				UpdateCarrot(hands)
			end
			hands.task_carrot_l = nil
		end)
	end
end
local function OnEquip_carl(inst, owner)
    -- local skindata = inst.components.skinedlegion:GetSkinedData()
    -- if skindata ~= nil and skindata.equip ~= nil then
    --     owner.AnimState:OverrideSymbol("swap_object", skindata.equip.build, skindata.equip.file)
    -- else
        owner.AnimState:OverrideSymbol("swap_object", "lance_carrot_l", "swap_object")
    -- end

    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

	if owner:HasTag("equipmentmodel") then --假人！
        return
    end

	if inst.components.container ~= nil then
        inst.components.container:Open(owner)

		inst:ListenForEvent("gotnewitem", OnOwnerItemChange_carl, owner)
		inst:ListenForEvent("itemget", OnOwnerItemChange_carl, owner)
		inst:ListenForEvent("itemlose", OnOwnerItemChange_carl, owner)
		UpdateCarrot(inst, true)
    end
end
local function OnUnequip_carl(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

	if owner:HasTag("equipmentmodel") then --假人！
        return
    end

	if inst.components.container ~= nil then
        inst.components.container:Close()
    end
	inst:RemoveEventCallback("gotnewitem", OnOwnerItemChange_carl, owner)
	inst:RemoveEventCallback("itemget", OnOwnerItemChange_carl, owner)
	inst:RemoveEventCallback("itemlose", OnOwnerItemChange_carl, owner)
end
local function OnAttack_carl(inst, attacker, target)
	if inst.task_carrot_l ~= nil then
		inst.task_carrot_l:Cancel()
		inst.task_carrot_l = nil
	end
	if inst.components.container ~= nil then
		UpdateCarrot(inst)
	end
end
local function SetPerishRate_carl(inst, item)
    -- if item == nil then
    --     return 0.4
    -- end
    return 0.4
end
local function OnFinished_carl(inst)
	if inst.components.container ~= nil then
		inst.components.container:DropEverything()
	end
	inst:Remove()
end

table.insert(prefs, Prefab(
    "lance_carrot_l",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("lance_carrot_l")
        inst.AnimState:SetBuild("lance_carrot_l")
        inst.AnimState:PlayAnimation("idle")

		inst:AddTag("jab") --使用捅击的动作进行攻击
		inst:AddTag("rp_carrot_l")

        --weapon (from weapon component) added to pristine state for optimization
    	inst:AddTag("weapon")

		-- inst:AddComponent("skinedlegion")
    	-- inst.components.skinedlegion:InitWithFloater("lileaves")

		MakeInventoryFloatable(inst, "small", 0.4, 0.5)
		local OnLandedClient_old = inst.components.floater.OnLandedClient
		inst.components.floater.OnLandedClient = function(self)
			OnLandedClient_old(self)
			self.inst.AnimState:SetFloatParams(0.15, 1, self.bob_percent)
		end

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
			inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("lance_carrot_l") end
            return inst
        end

		inst.num_carrot_l = 0

		inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = "lance_carrot_l"
		inst.components.inventoryitem.atlasname = "images/inventoryimages/lance_carrot_l.xml"

		inst:AddComponent("equippable")
		inst.components.equippable:SetOnEquip(OnEquip_carl)
		inst.components.equippable:SetOnUnequip(OnUnequip_carl)

		inst:AddComponent("weapon")
		inst.components.weapon:SetDamage(atk_min_carl)
		-- inst.components.weapon:SetRange(-1, -1) --人物默认攻击距离为3、3
		-- inst.components.weapon:SetOnAttack(OnAttack_carl)

		inst:AddComponent("finiteuses")
		inst.components.finiteuses:SetMaxUses(200)
		inst.components.finiteuses:SetUses(200)
		inst.components.finiteuses:SetOnFinished(OnFinished_carl)

		inst:AddComponent("container")
		inst.components.container:WidgetSetup("lance_carrot_l")
		inst.components.container.canbeopened = false

		inst:AddComponent("preserver")
		inst.components.preserver:SetPerishRateMultiplier(SetPerishRate_carl)

		MakeHauntableLaunch(inst)

		-- inst.components.skinedlegion:SetOnPreLoad()

        return inst
    end,
    {
        Asset("ANIM", "anim/lance_carrot_l.zip"),
        Asset("ATLAS", "images/inventoryimages/lance_carrot_l.xml"),
        Asset("IMAGE", "images/inventoryimages/lance_carrot_l.tex")
    },
    nil
))

--------------------------------------------------------------------------
--[[ 巨食草 三阶段 ]]
--------------------------------------------------------------------------

local sounds_nep = {
    pant = "dontstarve/creatures/chester/pant",
    pop = "dontstarve/creatures/chester/pop",
    boing = "dontstarve/creatures/chester/boing",
    lick = "dontstarve/creatures/chester/lick",

	hurt = "dontstarve/creatures/chester/hurt",
	death = "dontstarve/creatures/chester/death",
    open = "dontstarve/creatures/chester/open",
    close = "dontstarve/creatures/chester/close",
	leaf = "dontstarve/wilson/pickup_reeds"
}
local 

local function DisplayName_nep(inst)
	local namepre = STRINGS.NAMES[string.upper(inst.prefab or "plant_carrot_l")]
	local cluster = inst._cluster_l:value()
	if cluster ~= nil and cluster > 0 then
		namepre = namepre.."(Lv."..tostring(cluster)..")"
	end

	return namepre
end

local function IsDigestible(item)
	return item.prefab ~= "insectshell_l" and item.prefab ~= "boneshard" and
		not item:HasTag("irreplaceable") and not item:HasTag("nodigest_l")
end
local function GetItemDesc(item, namemap, txt)
	local name = item.nameoverride or
		(item.components.inspectable ~= nil and item.components.inspectable.nameoverride) or
		item.prefab or nil
	if name ~= nil then
		name = STRINGS.NAMES[string.upper(name)] or "MISSING NAME"
	else
		name = "MISSING NAME"
	end
	txt = txt..", "..tostring(namemap[item.prefab]).." "..name
	namemap[item.prefab] = nil
	return txt
end
local function IsValid(inst)
	return inst ~= nil and inst:IsValid()
end
local function ScreeningItems(eater, item, items_digest, items_free, namemap)
	local owner = item.components.inventoryitem and item.components.inventoryitem.owner or nil
	if IsDigestible(item) then --可以消化的：需要从各自容器里拿出来，再统一删除
		if owner ~= nil then
			local cpt = owner.components.container or owner.components.inventory
			if cpt ~= nil then
				item = cpt:RemoveItem(item, true)
			end
		end
		if item ~= nil then
			table.insert(items_digest, item)
			namemap[item.prefab] = (namemap[item.prefab] or 0) +
									(item.components.stackable and item.components.stackable.stacksize or 1)
			--递归判定容器物品中的物品
			local cpt = item.components.container or item.components.inventory
			if cpt ~= nil then
				local cptitems = cpt:FindItems(IsValid)
				for _, v in pairs(cptitems) do
					ScreeningItems(eater, v, items_digest, items_free, namemap)
				end
			end
		end
	else --无法消化的：需要从非巨食草的容器里拿出来，再统一放进巨食草
		if owner ~= nil then
			if eater == owner then --如果本来就在巨食草里，就不用做什么操作啦
				return
			end
			local cpt = owner.components.container or owner.components.inventory
			if cpt ~= nil then
				item = cpt:RemoveItem(item, true)
			end
		end
		if item ~= nil then
			table.insert(items_free, item)
		end
	end
end
local function SpawnDigestedItems(loot, name, num, pos)
	local item = SpawnPrefab(name)
	if item ~= nil then
		if num > 1 and item.components.stackable ~= nil then
			local maxsize = item.components.stackable.maxsize
			if num <= maxsize then
				item.components.stackable:SetStackSize(num)
				num = 0
			else
				item.components.stackable:SetStackSize(maxsize)
				num = num - maxsize
			end
		else
			num = num - 1
        end

        item.Transform:SetPosition(pos:Get())
        -- if item.components.inventoryitem ~= nil then
        --     item.components.inventoryitem:OnDropped(true)
        -- end
		if loot ~= nil then
			table.insert(loot, item)
		end

		if num >= 1 then
			SpawnDigestedItems(loot, name, num, pos)
		end
	end
end
local function DoDigest(inst, doer)
	inst.task_digest = nil

	if inst.components.health:IsDead() then
		return
	end
	inst.components.health:SetPercent(1)

	inst.AnimState:PushAnimation("idle", true)
	-- inst.AnimState:PlayAnimation("idle", true)

	------先登记所有的物品
	local items_digest = {}
	local items_free = {}
	local namemap = {}
	local cpt = inst.components.container
	local cptitems = cpt:FindItems(IsValid)
	for _, v in pairs(cptitems) do
		ScreeningItems(inst, v, items_digest, items_free, namemap)
	end

	------生成消化后产物，结算
	local numprefab = {}
	local numall = inst.count_digest
	for name, number in pairs(namemap) do
		numall = numall + number
		if DIGEST_DATA_LEGION[name] ~= nil then
			for k, v in pairs(DIGEST_DATA_LEGION[name]) do
				numprefab[k] = (numprefab[k] or 0) + number*v
			end
		end
	end
	for name, number in pairs(numprefab) do
		number = number*0.25
		local number2 = math.floor(number) --整数部分
		number = number - number2 --小数部分
		if number > 0 then --小数部分也有几率产出
			if math.random() < number/2 then
				number2 = number2 + 1
			end
		end
		number = number2
		if number >= 1 then
			SpawnDigestedItems(items_free, name, number, inst:GetPosition())
		end
	end

	------簇栽升级
	local cpt2 = inst.components.perennialcrop2
	if cpt2.cluster < cpt2.cluster_max then
		if numall >= 80 then
			local timelevelup = math.floor(numall/80)
			if cpt2:DoCluster(timelevelup) then
				inst.count_digest = numall - timelevelup*80
			else --返回false就代表不再能升级了，就没必要记录了
				inst.count_digest = 0
			end
		else
			inst.count_digest = numall
		end
	else
		inst.count_digest = 0
	end

	------发送全服通告
	if true then
		local itemtxt = ""
		for _, item in pairs(items_digest) do
			if namemap[item.prefab] ~= nil then --不为空说明还没被记录进去
				itemtxt = GetItemDesc(item, namemap, itemtxt)
			end
		end
		if doer ~= nil then
			itemtxt = subfmt(STRINGS.PLANT_CROP_L.DIGEST,
				{ doer = tostring(doer.name), eater = STRINGS.NAMES[string.upper(inst.prefab)], items = itemtxt })
		else
			itemtxt = subfmt(STRINGS.PLANT_CROP_L.DIGESTSELF,
				{ eater = STRINGS.NAMES[string.upper(inst.prefab)], items = itemtxt })
		end
		TheNet:Announce(itemtxt)
	end

	------整理物品
	for _, item in pairs(items_digest) do --现在才删除，是因为全服通告需要实体来判定名字
		item:Remove()
	end
	for _, item in pairs(items_free) do --将无法消化的放回巨食草里
		if item:IsValid() then
			cpt:GiveItem(item)
		end
	end
end
local function StopDigest(inst)
	if inst.task_digest ~= nil then
		inst.task_digest:Cancel()
		inst.task_digest = nil
	end
end
local function TryDigest(inst, isclose, doer)
	StopDigest(inst)
	for k,v in pairs(inst.components.container.slots) do
        if IsDigestible(v) then
			if isclose then
				inst.AnimState:PlayAnimation("close")
    			inst.AnimState:PushAnimation("eat", true)
			else
				inst.AnimState:PlayAnimation("eat", true)
			end
			inst.task_digest = inst:DoTaskInTime(5, function(inst)
				DoDigest(inst, doer)
			end)
			return
		end
    end
end

local function OnOpen_nep(inst, data)
    inst.AnimState:PlayAnimation("open", false)
    -- inst.AnimState:PushAnimation("opened", true)

    inst.SoundEmitter:PlaySound(sounds_nep.leaf, nil, 0.6)
	inst.SoundEmitter:PlaySound(sounds_nep.open, nil, 0.3)

	StopDigest(inst)
end
local function OnClose_nep(inst, doer)
    inst.AnimState:PlayAnimation("close")
    inst.AnimState:PushAnimation("idle", true)

    inst.SoundEmitter:PlaySound(sounds_nep.leaf, nil, 0.6)
	inst.SoundEmitter:PlaySound(sounds_nep.close, nil, 0.3)

	TryDigest(inst, true, doer)
end

local function Attacked_nep(inst, data)
	if inst.components.health:IsDead() then
		return
	end

	if data.attacker and data.attacker:HasTag("player") then
		inst.components.health:DoDelta(-200)
		if inst.components.health:IsDead() then
			return
		end
	end

	inst.components.container:Close()

	inst.SoundEmitter:PlaySound(sounds_nep.leaf, nil, 0.6)
	inst.SoundEmitter:PlaySound(sounds_nep.hurt, nil, 0.3)

	inst.AnimState:PlayAnimation("hit")
	inst.AnimState:PushAnimation("idle", true)
end
local function OnDeath_nep(inst)
	inst.components.container:Close()
	inst.components.container.canbeopened = false
	inst.components.container:DropEverything()

	inst.components.perennialcrop2:GenerateLoot(nil, true, false)

	inst.SoundEmitter:PlaySound(sounds_nep.leaf, nil, 0.6)
	inst.SoundEmitter:PlaySound(sounds_nep.death, nil, 0.3)

	inst.AnimState:PlayAnimation("hit")
	RemovePhysicsColliders(inst)

	--转化到1阶段 undo
end

table.insert(prefs, Prefab(
    "plant_nepenthes_l",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddMiniMapEntity()
		inst.entity:AddNetwork()

		inst:SetPhysicsRadiusOverride(.8)
    	MakeObstaclePhysics(inst, inst.physicsradiusoverride)

        inst.AnimState:SetBank("crop_legion_lureplant")
        inst.AnimState:SetBuild("crop_legion_lureplant")
        -- inst.AnimState:PlayAnimation("idle") --组件里会设置动画的

		inst.MiniMapEntity:SetIcon("plant_crop_l.tex")

		inst:AddTag("crop2_legion")
		inst:AddTag("veggie")
		inst:AddTag("notraptrigger")
    	inst:AddTag("noauradamage")
		inst:AddTag("companion")

		inst._cluster_l = net_byte(inst.GUID, "plant_crop_l._cluster_l", "cluster_l_dirty")

		inst.displaynamefn = DisplayName_nep

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
			inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("plant_nepenthes_l") end
            return inst
        end

		inst.count_digest = 0 --已消化物品的数量

		inst:AddComponent("inspectable")

		inst:AddComponent("health")
    	inst.components.health:SetMaxHealth(1200)
		inst.components.health.destroytime = 0.7

		inst:AddComponent("combat")
		inst.components.combat.hiteffectsymbol = "base"

		inst:AddComponent("container")
		inst.components.container:WidgetSetup("plant_nepenthes_l")
        inst.components.container.onopenfn = OnOpen_nep
        inst.components.container.onclosefn = OnClose_nep
        inst.components.container.skipclosesnd = true
        inst.components.container.skipopensnd = true

		inst:AddComponent("perennialcrop2")
		inst.components.perennialcrop2.StartGrowing = EmptyCptFn
		inst.components.perennialcrop2.LongUpdate = EmptyCptFn
		inst.components.perennialcrop2.OnEntityWake = EmptyCptFn
		inst.components.perennialcrop2.OnEntitySleep = EmptyCptFn
		inst.components.perennialcrop2:SetUp("plantmeat", CROPS_DATA_LEGION["plantmeat"])
		inst.components.perennialcrop2.fn_defend = CallDefender
		inst.components.perennialcrop2:SetStage(3, false, false)

		inst:ListenForEvent("attacked", Attacked_nep)
		inst:ListenForEvent("death", OnDeath_nep)

		-- inst:DoTaskInTime(0, function()
		-- 	OnIsDark_p2(inst)
		-- end)

		MakeHauntableDropFirstItem(inst)

		if TUNING.SMART_SIGN_DRAW_ENABLE then
			SMART_SIGN_DRAW(inst)
		end

        return inst
    end,
    {
        Asset("ANIM", "anim/crop_legion_lureplant.zip"),
    },
    nil
))

--------------------
--------------------

for k,v in pairs(defs) do
	table.insert(prefs, MakePlant(v))
end
for k,v in pairs(CROPS_DATA_LEGION) do
	table.insert(prefs, MakePlant2(k, v))
end

return unpack(prefs)
