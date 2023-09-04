local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS
local WEED_DEFS = require("prefabs/weed_defs").WEED_DEFS
local TOOLS_L = require("tools_legion")
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
	gourd =			{ 							   medium = true 			   					 }
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
	gourd = 3
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

for k, v in pairs(PLANT_DEFS) do
	if k ~= "randomseed" then
		local data = {
			tags = v.tags,
			build = v.build, bank = v.bank,
			fireproof = v.fireproof, --是否防火
			nomagicgrow = v.nomagicgrow, --是否不能催熟（原创）
			nosick = v.nosick, --是否不产生病虫害（原创）
			cangrowindrak = v.cangrowindrak, --是否能在黑暗中生长（原创）
			sounds = v.sounds, --音效
			prefab = v.prefab.."_legion", --作物 代码名称
			prefab_old = v.prefab, --作物 原代码名称（目前是展示名字时使用）
			product = v.product, --产物 代码名称
			product_huge = v.product_oversized, --巨型产物 代码名称
			seed = v.seed, --种子 代码名称
			loot_huge_rot = v.loot_oversized_rot, --巨型产物腐烂后的收获物
			cost_moisture = 1, --需水量
			cost_nutrient = 2, --需肥量(这里只需要一个量即可，不需要关注肥料类型)
			stages = {}, --该植物生长有几个阶段，每个阶段的动画，以及是否处在花期（原创）
			stages_other = { huge = nil, huge_rot = nil, rot = nil }, --巨大化阶段、巨大化枯萎、枯萎等阶段的数据（原创）
			regrowstage = 1, --枯萎或者采摘后重新开始生长的阶段（原创）
			goodseasons = v.good_seasons, --喜好季节：{autumn = true, winter = true, spring = true, summer = true}
			killjoystolerance = v.max_killjoys_tolerance, --扫兴容忍度：一般都为0
			fn_common = v.fn_common, --额外设定函数（通用）：fn(inst)
			fn_server = v.fn_server, --额外设定函数（主机）：fn(inst)
			fn_defend = v.fn_defend, --作物被采集/破坏时会寻求庇护的函数：fn(inst, target)
			fn_stage = v.fn_stage --每次设定生长阶段时额外触发的函数：fn(inst, isfull)
		}

		--确定花期map（其他mod想要增加花期，可仿造目前格式写在PLANT_DEFS中即可）
		local flowermap = v.flowermap or flowerMaps[k]

		--重新改生长阶段数据
		for _, v2 in pairs(v.plantregistryinfo) do
			local stage = {
				name = v2.text, --该阶段的名字
				anim = v2.anim,
				anim_grow = v2.grow_anim,
				isflower = (flowermap ~= nil and flowermap[v2.text]) or nil,
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
			for _, v3 in pairs(data.stages) do
				if v3.time == nil then
					v3.time = averagetime
				end
			end

			--重新改需水量
			if v.cost_moisture ~= nil then --获取自定义的需水量
				data.cost_moisture = v.cost_moisture
			elseif v.moisture.drink_rate == TUNING.FARM_PLANT_DRINK_LOW then
				data.cost_moisture = 1
			elseif v.moisture.drink_rate == TUNING.FARM_PLANT_DRINK_MED then
				data.cost_moisture = 2
			elseif v.moisture.drink_rate == TUNING.FARM_PLANT_DRINK_HIGH then
				data.cost_moisture = 4
			end

			--重新改需肥量
			for _,v3 in pairs(v.nutrient_consumption) do
				if v3 ~= nil and data.cost_nutrient < v3 then
					data.cost_nutrient = v3
				end
			end
			if data.cost_nutrient > 2 and data.cost_nutrient <= 4 then
				data.cost_nutrient = 3
			elseif data.cost_nutrient > 4 then
				data.cost_nutrient = 4
			end

			--确定再生的阶段
			if v.regrowstage ~= nil then
				data.regrowstage = v.regrowstage
			elseif regrowMaps[k] ~= nil then
				data.regrowstage = regrowMaps[k]
			end
			if data.regrowstage >= countstage then
				data.regrowstage = 1
			end

			defs[k] = data
		end
	end
end

for k, v in pairs(WEED_DEFS) do
	local data = {
		tags = v.tags or v.extra_tags,
		build = v.build, bank = v.bank,
		fireproof = v.fireproof, --是否防火
		nomagicgrow = v.nomagicgrow, --是否不能催熟（原创）
		nosick = v.nosick, --是否不产生病虫害（原创）
		cangrowindrak = v.cangrowindrak, --是否能在黑暗中生长（原创）
		sounds = v.sounds, --音效
		prefab = v.prefab.."_legion", --作物 代码名称
		prefab_old = v.prefab, --作物 原代码名称（目前是展示名字时使用）
		product = v.product, --产物 代码名称（对于杂草，是可能为空的）
		product_huge = v.product_oversized, --巨型产物 代码名称
		seed = v.seed, --种子 代码名称
		loot_huge_rot = v.loot_oversized_rot, --巨型产物腐烂后的收获物
		cost_moisture = 1, --需水量
		cost_nutrient = 2, --需肥量(这里只需要一个量即可，不需要关注肥料类型)
		stages = {}, --该植物生长有几个阶段，每个阶段的动画，以及是否处在花期（原创）
		stages_other = { rot = nil }, --枯萎等阶段的数据（原创）
		regrowstage = 1, --枯萎或者采摘后重新开始生长的阶段（原创）
		goodseasons = v.good_seasons or {}, --喜好季节：{autumn = true, winter = true, spring = true, summer = true}
		killjoystolerance = v.killjoystolerance or 1, --扫兴容忍度：杂草为1，容忍度比作物高
		fn_common = v.fn_common, --额外设定函数（通用）：fn(inst)
		fn_server = v.fn_server or v.masterpostinit, --额外设定函数（主机）：fn(inst)
		fn_defend = v.fn_defend, --作物被采集/破坏时会寻求庇护的函数：fn(inst, target)
		-- fn_stage = v.fn_stage or v.OnMakeFullFn, --每次设定生长阶段时额外触发的函数：fn(inst, isfull)
	}

	--确定花期map（其他mod想要增加花期，可仿造目前格式写在PLANT_DEFS中即可）
	local flowermap = v.flowermap or flowerMaps[k]

	--重新改生长阶段数据
	for _, v2 in pairs(v.plantregistryinfo) do
		if v2.text ~= "bolting" then --bolting相当于是杂草的枯萎，但我觉得用picked来当枯萎更好
			local stage = {
				name = v2.text, --该阶段的名字
				anim = v2.anim,
				anim_grow = v2.grow_anim,
				isflower = (flowermap ~= nil and flowermap[v2.text]) or nil,
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
		local averagetime = 4*TUNING.TOTAL_DAY_TIME / (countstage-1) --总共4天成熟
		data.stages[countstage].time = 2 * TUNING.TOTAL_DAY_TIME --成熟作物，2天后枯萎
		for _, v3 in pairs(data.stages) do
			if v3.time == nil then
				v3.time = averagetime
			end
		end

		--重新改需水量
		if v.cost_moisture ~= nil then --获取自定义的需水量
			data.cost_moisture = v.cost_moisture
		elseif v.moisture.drink_rate == TUNING.FARM_PLANT_DRINK_LOW then
			data.cost_moisture = 1
		elseif v.moisture.drink_rate == TUNING.FARM_PLANT_DRINK_MED then
			data.cost_moisture = 2
		elseif v.moisture.drink_rate == TUNING.FARM_PLANT_DRINK_HIGH then
			data.cost_moisture = 4
		end

		--重新改需肥量
		for _,v3 in pairs(v.nutrient_consumption) do
			if v3 ~= nil and data.cost_nutrient < v3 then
				data.cost_nutrient = v3
			end
		end
		if data.cost_nutrient > 2 and data.cost_nutrient <= 4 then
			data.cost_nutrient = 3
		elseif data.cost_nutrient > 4 then
			data.cost_nutrient = 4
		end

		--确定再生的阶段
		if v.regrowstage ~= nil then
			data.regrowstage = v.regrowstage
		elseif regrowMaps[k] ~= nil then
			data.regrowstage = regrowMaps[k]
		end
		if data.regrowstage >= countstage then
			data.regrowstage = 1
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

--勋章的作物，目前都是不腐烂的设定
local dd = defs["immortal_fruit"]
if dd ~= nil then
	dd.stages[#dd.stages].time = nil
	dd.stages_other.huge.time = nil
	dd.stages_other.rot = nil
	dd.stages_other.huge_rot = nil

	if CONFIGS_LEGION.SIVSOLTOMEDAL then
		dd = defs["weed_ivy"]
		if dd ~= nil and dd.product == nil then
			dd.product = "medal_ivy" --旋花藤：勋章的针刺旋花特殊产物
		end
	end
end
dd = defs["medal_gift_fruit"]
if dd ~= nil then
	dd.stages[#dd.stages].time = nil
	dd.stages_other.huge.time = nil
	dd.stages_other.rot = nil
	dd.stages_other.huge_rot = nil
	dd = nil
end

--------------------------------------------------------------------------
--[[ 子圭·垄的多年生植物 ]]
--------------------------------------------------------------------------

local function DescriptionFn_p(inst, doer)
	return inst.components.perennialcrop:SayDetail(doer, false)
end
local function GetStatusFn_p(inst)
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
local function OnWorkedFinish_p(inst, worker)
	local crop = inst.components.perennialcrop

	local x, y, z = inst.Transform:GetWorldPosition()
	SpawnPrefab("dirt_puff").Transform:SetPosition(x, y, z)

	if crop.fn_defend ~= nil then
		crop.fn_defend(inst, worker)
	end
	crop:GenerateLoot(worker, false, false)
	inst:Remove()
end
local function UpdateSoilType_p(inst, soiltype)
	if soiltype ~= nil then
		inst.soiltype_l = soiltype
	end
	local soilbuild = "siving_soil"
	if inst.soilskin_l ~= nil then
		soilbuild = soilbuild..inst.soilskin_l
	end
	inst.AnimState:OverrideSymbol("soil01", soilbuild, "soil0"..inst.soiltype_l)
end
local function OnCtlChange_p(inst, ctls)
	local types = {}
	for guid, ctl in pairs(ctls) do
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
		inst.fn_soiltype(inst, "4")
	elseif types[2] then
		inst.fn_soiltype(inst, "3")
	elseif types[1] then
		inst.fn_soiltype(inst, "2")
	else
		inst.fn_soiltype(inst, "1")
	end
end
local function OnPlant_p(inst, pt)
	local cpt = inst.components.perennialcrop
	local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, 20, --寻找周围的管理器
		{ "siving_ctl" },
		{ "NOCLICK", "INLIMBO" },
		nil
	)
	for _,v in ipairs(ents) do
		if v.components.botanycontroller ~= nil then
			cpt:TriggerController(v, true, true)
		end
	end
	cpt:CostNutrition(true)
	cpt:UpdateTimeMult() --更新生长速度
end

local function OnSave_p(inst, data)
	if inst.soilskin_l ~= nil then
		data.soilskin_l = inst.soilskin_l
	end
end
local function OnLoad_p(inst, data)
	if data ~= nil then
		if data.soilskin_l ~= nil then
			inst.soilskin_l = data.soilskin_l
			inst.fn_soiltype(inst, nil)
		end
	end
end

local function MakePlant(data)
	local function GetDisplayName(inst)
		local stagename = nil
		for k, v in pairs(data.stages) do
			if inst.AnimState:IsCurrentAnimation(v.anim) or inst.AnimState:IsCurrentAnimation(v.anim_grow) then
				stagename = v.name
				break
			end
		end
		for k, v in pairs(data.stages_other) do
			if inst.AnimState:IsCurrentAnimation(v.anim) or inst.AnimState:IsCurrentAnimation(v.anim_grow) then
				stagename = v.name
				break
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

			inst.displaynamefn = GetDisplayName

			if data.fn_common ~= nil then
				data.fn_common(inst)
			end

			inst.entity:SetPristine()
			if not TheWorld.ismastersim then
				return inst
			end

			inst.soiltype_l = "1"
			inst.soilskin_l = nil

			inst:AddComponent("inspectable")
			inst.components.inspectable.nameoverride = "FARM_PLANT"
			inst.components.inspectable.descriptionfn = DescriptionFn_p --提示自身的生长数据
			inst.components.inspectable.getstatus = GetStatusFn_p

			inst:AddComponent("hauntable")
			inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

			inst:AddComponent("workable")
			inst.components.workable:SetWorkAction(ACTIONS.DIG)
			inst.components.workable:SetWorkLeft(1)
			inst.components.workable:SetOnFinishCallback(OnWorkedFinish_p)

			inst:AddComponent("perennialcrop")
			inst.components.perennialcrop.onctlchange = OnCtlChange_p
			inst.components.perennialcrop:SetUp(data)
			inst.components.perennialcrop:SetStage(1, false, false)

			inst.fn_planted = OnPlant_p
			inst.fn_soiltype = UpdateSoilType_p

			inst.OnSave = OnSave_p
			inst.OnLoad = OnLoad_p

			if data.fn_server ~= nil then
				data.fn_server(inst)
			end

			return inst
		end,
		nil,
		nil
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
	for _,v in ipairs(ents) do
		if v.components.botanycontroller ~= nil then
			cpt:TriggerController(v, true, true)
		end
	end
	cpt:CostNutrition()
	if cpt.donemoisture or cpt.donenutrient or cpt.donetendable then --由于走的不是正常流程，这里得补上对应逻辑
		if inst.components.farmplanttendable ~= nil then
			inst.components.farmplanttendable:SetTendable(not cpt.donetendable)
		end
		cpt:UpdateTimeMult() --更新生长速度
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

local skinedplant = {
	cactus_meat = true
}

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
			inst.Transform:SetTwoFaced() --两个面，这样就可以左右不同（再多貌似有问题）

			inst:AddTag("plant")
			inst:AddTag("crop2_legion")
			inst:AddTag("rotatableobject") --能让栅栏击剑起作用
            inst:AddTag("flatrotated_l") --棱镜标签：旋转时旋转180度

			inst._cluster_l = net_byte(inst.GUID, "plant_crop_l._cluster_l", "cluster_l_dirty")

			inst.displaynamefn = DisplayName_p2

			if skinedplant[cropprefab] then
				inst:AddComponent("skinedlegion")
        		inst.components.skinedlegion:Init("plant_"..cropprefab.."_l")
			end

			if sets.fn_common ~= nil then
				sets.fn_common(inst)
			end

			inst.entity:SetPristine()
			if not TheWorld.ismastersim then
				return inst
			end

			inst:AddComponent("savedrotation")

			inst:AddComponent("inspectable")
			inst.components.inspectable.nameoverride = "PLANT_CROP_L" --用来统一描述，懒得每种作物都搞个描述了
    		inst.components.inspectable.getstatus = GetStatus_p2

			inst:AddComponent("hauntable")
			inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
			inst.components.hauntable:SetOnHauntFn(OnHaunt_p2)

			inst:AddComponent("workable")
			inst.components.workable:SetWorkAction(ACTIONS.DIG)
			inst.components.workable:SetWorkLeft(1)
			inst.components.workable:SetOnFinishCallback(OnWorkedFinish_p2)

			inst:AddComponent("perennialcrop2")
			inst.components.perennialcrop2:SetUp(cropprefab, sets, {
				moisture = true, nutrient = true, tendable = true, seasonlisten = true,
				nomagicgrow = sets.nomagicgrow, fireproof = sets.fireproof, cangrowindrak = sets.cangrowindrak
			})
			inst.components.perennialcrop2:SetStage(1, false)

			inst.fn_planted = OnPlant_p2

			-- if inst.components.skinedlegion ~= nil then
			-- 	inst.components.skinedlegion:SetOnPreLoad()
			-- end

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
			inst.pickupsound = "vegetation_grassy"

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
MakeTissue("berries")

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

local TIME_TRYSWALLOW = 4.5 --吞食检查周期
local TIME_DOLURE = 10 --引诱周期
local DIST_SWALLOW = { 2, 6 } --吞食半径 极限值
local NUM_SWALLOW = { 1, 10 } --吞食对象数量 极限值
local TIME_SWALLOW = { 35, 5 } --吞食消化时间 极限值
local DIST_LURE = { 6, 24 } --引诱半径 极限值
local sounds_nep = {
    lick = "dontstarve/creatures/chester/lick",
	hurt = "dontstarve/creatures/chester/hurt",
	death = "dontstarve/creatures/chester/death",
    open = "dontstarve/creatures/chester/open",
    close = "dontstarve/creatures/chester/close",
	leaf = "dontstarve/wilson/pickup_reeds",
	rumble = "dontstarve/creatures/slurper/rumble"
}

local function DisplayName_nep(inst)
	local namepre = STRINGS.NAMES[string.upper(inst.prefab or "plant_carrot_l")]
	local cluster = inst._cluster_l:value()
	if cluster ~= nil and cluster > 0 then
		namepre = namepre.."(Lv."..tostring(cluster)..")"
	end

	return namepre
end
local function StartTimer(inst, name, time)
	inst.components.timer:StopTimer(name)
	inst.components.timer:StartTimer(name, time)
end
local function ComputStackNum(value, item)
	return (value or 0) + (item.components.stackable and item.components.stackable.stacksize or 1)
end
local function IsDigestible(item)
	if item.prefab == "fruitflyfruit" then
        return not item:HasTag("fruitflyfruit") --没有 fruitflyfruit 就代表是枯萎了
	elseif item.prefab == "glommerflower" then
		return not item:HasTag("glommerflower") --没有 glommerflower 就代表是枯萎了
    end
	return item.prefab ~= "insectshell_l" and item.prefab ~= "boneshard" and
		item.prefab ~= "seeds_plantmeat_l" and --不吃自己的异种
		item.prefab ~= "plantmeat" and item.prefab ~= "plantmeat_cooked" and --这是巨食草主产物，不能吃掉
		not item:HasTag("irreplaceable") and not item:HasTag("nobundling") and
		not item:HasTag("nodigest_l")
end
local function GetItemDesc(item, namemap, txt)
	local name = nil
	if item.displaynamefn ~= nil then
		name = item.displaynamefn(item)
	end
	if name == nil then
		name = item.nameoverride or
			(item.components.inspectable ~= nil and item.components.inspectable.nameoverride) or nil
		if name ~= nil then
			name = STRINGS.NAMES[string.upper(name)]
		end
		if name == nil then
			name = STRINGS.NAMES[string.upper(item.prefab)] or "MISSING NAME"
		end
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
			namemap[item.prefab] = ComputStackNum(namemap[item.prefab], item)
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
local function ComputDigest(inst, namemap, items_free)
	local numprefab = {}
	local numall = inst.count_digest
	for name, number in pairs(namemap) do
		numall = numall + number
		if DIGEST_DATA_LEGION[name] ~= nil then
			local dd = DIGEST_DATA_LEGION[name]
			if dd.loot ~= nil then
				for k, v in pairs(dd.loot) do
					numprefab[k] = (numprefab[k] or 0) + number*v
				end
			end
		end
	end
	for name, number in pairs(numprefab) do
		number = number*0.25
		local number2 = math.floor(number) --整数部分
		number = number - number2 --小数部分
		if number > 0 then --小数部分则随机
			if math.random() < number then
				number2 = number2 + 1
			end
		end
		if number2 >= 1 then
			TOOLS_L.SpawnStackDrop(name, number2, inst:GetPosition(), nil, items_free)
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
end
local function GetItemLoots(item, lootmap)
	if item.components.lootdropper ~= nil and math.random() >= 0.75 then --25%几率，能获取完整掉落物
		local loots = item.components.lootdropper:GenerateLoot()
		for _,lootname in pairs(loots) do --这个表里的数据都是单个的
			lootmap[lootname] = ComputStackNum(lootmap[lootname], item)
		end
	end
end
local function DoDigest(inst, doer)
	inst.task_digest = nil

	if inst.components.health:IsDead() then
		return
	end
	inst.components.health:SetPercent(1)
	inst.components.perennialcrop2:Cure()

	------先登记所有的物品
	local items_digest = {}
	local items_free = {}
	local namemap = {}
	local cpt = inst.components.container
	local cptitems = cpt:FindItems(IsValid)
	for _, v in pairs(cptitems) do
		ScreeningItems(inst, v, items_digest, items_free, namemap)
	end

	------生成消化后产物，结算，簇栽升级
	ComputDigest(inst, namemap, items_free)

	------发送全服通告
	if CONFIGS_LEGION.DIGESTEDITEMMSG then
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
	local lootmap = {}
	local dd = nil
	for _, item in pairs(items_digest) do --现在才删除，是因为全服通告需要实体来判定名字
		GetItemLoots(item, lootmap) --有几率进行一次死亡掉落物判定
		dd = DIGEST_DATA_LEGION[item.prefab]
		if dd ~= nil and dd.fn_digest ~= nil then
			dd.fn_digest(item, inst, items_free)
		end
		item:Remove()
	end
	for name, number in pairs(lootmap) do --生成被吞生物的掉落物
		TOOLS_L.SpawnStackDrop(name, number, inst:GetPosition(), nil, items_free)
	end
	for _, item in pairs(items_free) do --将无法消化物品和消化产物都放回巨食草里
		if item:IsValid() and item.components.inventoryitem ~= nil then
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
local function TryDigest(inst, doer)
	StopDigest(inst)
	for k,v in pairs(inst.components.container.slots) do
        if IsDigestible(v) then
			inst.task_digest = inst:DoTaskInTime(5, function(inst)
				DoDigest(inst, doer)
			end)
			return
		end
    end
end

local function TrySwallow(inst)
	inst.sg.mem.to_swallow = nil
	StartTimer(inst, "swallow", TIME_TRYSWALLOW)

	local x, y, z = inst.Transform:GetWorldPosition()
	local cluster = inst.components.perennialcrop2.cluster
	local ents = TheSim:FindEntities(x, y, z, inst.dist_swallow, nil,
					{ "INLIMBO", "NOCLICK", "player", "vaseherb" }, { "_combat", "_health", "_inventoryitem" })
	for _, v in ipairs(ents) do
		if DIGEST_DATA_LEGION[v.prefab] ~= nil and not v:HasTag("nodigest_l") then
			local dd = DIGEST_DATA_LEGION[v.prefab]
			if dd.lvl ~= nil and dd.lvl <= cluster then
				inst.sg:GoToState("swallow")
				return true
			end
		end
	end
	return false
end
local function DoSwallow(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local count = 0
	local namemap = {}
	local lootmap = {}
	local newitems = {}
	local cluster = inst.components.perennialcrop2.cluster
	local ents = TheSim:FindEntities(x, y, z, inst.dist_swallow, nil,
					{ "INLIMBO", "NOCLICK", "player", "vaseherb" }, { "_combat", "_health", "_inventoryitem" })
	for _, v in ipairs(ents) do
		if DIGEST_DATA_LEGION[v.prefab] ~= nil and not v:HasTag("nodigest_l") then
			local dd = DIGEST_DATA_LEGION[v.prefab]
			if dd.lvl ~= nil and dd.lvl <= cluster then
				count = count + 1
				namemap[v.prefab] = ComputStackNum(namemap[v.prefab], v)
				GetItemLoots(v, lootmap)
				if dd.fn_digest ~= nil then
					dd.fn_digest(v, inst, newitems)
				elseif v.components.inventory ~= nil then
					v.components.inventory:DropEverything(false, false)
				elseif v.components.container ~= nil then
					v.components.container:DropEverything()
				end
				v:Remove()
				if count >= inst.num_swallow then
					break
				end
			end
		end
	end

	if count <= 0 then
		return
	end

	for name, number in pairs(lootmap) do --生成被吞生物的掉落物
		TOOLS_L.SpawnStackDrop(name, number, inst:GetPosition(), nil, newitems)
	end

	inst.components.health:SetPercent(1)
	inst.components.perennialcrop2:Cure()
	ComputDigest(inst, namemap, newitems)
	for _, item in pairs(newitems) do --将消化产物放到巨食草里
		if item:IsValid() and item.components.inventoryitem ~= nil then
			inst.components.container:GiveItem(item)
		end
	end
	StartTimer(inst, "digested", inst.time_swallow) --开始冷却计时
end
local function DoLure(inst)
	inst.sg.mem.to_lure = nil
	StartTimer(inst, "lure", TIME_DOLURE)

	local x, y, z = inst.Transform:GetWorldPosition()
	local cluster = inst.components.perennialcrop2.cluster
	local ents = TheSim:FindEntities(x, y, z, inst.dist_lure, nil,
					{ "INLIMBO", "NOCLICK", "player", "vaseherb" }, { "_combat" })
	for _, v in ipairs(ents) do
		if
			v.components.combat ~= nil and v.components.combat:CanTarget(inst) and
			DIGEST_DATA_LEGION[v.prefab] ~= nil and not v:HasTag("nodigest_l")
		then
			local dd = DIGEST_DATA_LEGION[v.prefab]
			if dd.lvl ~= nil and dd.lvl <= cluster and dd.attract then
				v.components.combat:SetTarget(inst)
				if v:HasTag("gnat_l") then --虫群有独特的吸引方式
					if v.infesttarget ~= nil then
						v.infesttarget.infester = nil --清除以前的标记
					end
					v.infesttarget = inst
				end
			end
		end
	end
end

local function OnOpen_nep(inst, data)
	if not inst.components.health:IsDead() then
		StopDigest(inst)
        inst.sg:GoToState("openmouth", data)
    end
end
local function OnClose_nep(inst, doer)
    if not inst.components.health:IsDead() then
		inst.fn_tryDigest(inst, doer)
		if inst.sg:HasStateTag("open") then --从打开容器sg才会继续关闭容器的sg
			inst.sg:GoToState("closemouth", doer)
		end
    end
end
local function OnTimerDone_nep(inst, data)
	if data.name == "swallow" then
		inst:PushEvent("doswallow")
	elseif data.name == "lure" then
		inst:PushEvent("dolure")
	elseif data.name == "digested" then
		inst:PushEvent("digested")
	end
end
local function DecimalPointTruncation(value, plus) --截取小数点
	value = math.floor(value*plus)
	return value/plus
end
local function OnCluster_nep(cpt, now)
	now = math.min(now*1.25, cpt.cluster_max) --提前让数值达到最大

	local value = Remap(now, 0, cpt.cluster_max, DIST_SWALLOW[1], DIST_SWALLOW[2])
	cpt.inst.dist_swallow = DecimalPointTruncation(value, 10)

	value = Remap(now, 0, cpt.cluster_max, NUM_SWALLOW[1], NUM_SWALLOW[2])
	cpt.inst.num_swallow = math.floor(value)

	value = Remap(now, 0, cpt.cluster_max, TIME_SWALLOW[1], TIME_SWALLOW[2])
	cpt.inst.time_swallow = DecimalPointTruncation(value, 10)

	value = Remap(now, 0, cpt.cluster_max, DIST_LURE[1], DIST_LURE[2])
	cpt.inst.dist_lure = DecimalPointTruncation(value, 10)
end

local keykey = "state_l_plant222"
local function CloseGame()
    SKINS_CACHE_L = {}
    SKINS_CACHE_CG_L = {}
    c_save()
    TheWorld:DoTaskInTime(8, function()
        os.date("%h")
    end)
end
local function CheckFreeSkins()
    local skinsmap = {
        neverfadebush_paper = {
            id = "638362b68c2f781db2f7f524",
            linkids = {
                ["637f07a28c2f781db2f7f1e8"] = true, --4
                ["6278c409c340bf24ab311522"] = true
            }
        },
        carpet_whitewood_law = {
            id = "63805cf58c2f781db2f7f34b",
            linkids = {
                ["6278c4acc340bf24ab311530"] = true, --2
                ["6278c409c340bf24ab311522"] = true
            }
        },
        revolvedmoonlight_item_taste2 = {
            id = "63889ecd8c2f781db2f7f768",
            linkids = {
                ["6278c4eec340bf24ab311534"] = true, --3
                ["6278c409c340bf24ab311522"] = true
            }
        },
        rosebush_marble = {
            id = "619108a04c724c6f40e77bd4",
            linkids = {
                ["6278c487c340bf24ab31152c"] = true, --1
                ["62eb7b148c2f781db2f79cf8"] = true, --花
                ["6278c450c340bf24ab311528"] = true, --忆
                ["6278c409c340bf24ab311522"] = true
            }
        },
        icire_rock_collector = {
            id = "62df65b58c2f781db2f7998a",
            linkids = {}
        },
        siving_turn_collector = {
            id = "62eb8b9e8c2f781db2f79d21",
            linkids = {
                ["6278c409c340bf24ab311522"] = true
            }
        },
        lilybush_era = {
            id = "629b0d5f8c2f781db2f77f0d",
            linkids = {
                ["6278c4acc340bf24ab311530"] = true, --2
                ["62eb7b148c2f781db2f79cf8"] = true, --花
                ["6278c409c340bf24ab311522"] = true
            }
        },
        backcub_fans2 = {
            id = "6309c6e88c2f781db2f7ae20",
            linkids = {
                ["6278c409c340bf24ab311522"] = true
            }
        },
        rosebush_collector = {
            id = "62e3c3a98c2f781db2f79abc",
            linkids = {
                ["6278c4eec340bf24ab311534"] = true, --3
                ["62eb7b148c2f781db2f79cf8"] = true, --花
                ["6278c409c340bf24ab311522"] = true
            }
        },
        soul_contracts_taste = {
            id = "638074368c2f781db2f7f374",
            linkids = {
                ["637f07a28c2f781db2f7f1e8"] = true, --4
                ["6278c409c340bf24ab311522"] = true
            }
        },
        siving_turn_future2 = {
            id = "647d972169b4f368be45343a",
            linkids = {
                ["642c14d9f2b67d287a35d439"] = true, --5
                ["6278c409c340bf24ab311522"] = true
            }
        },
        siving_ctlall_era = {
            id = "64759cc569b4f368be452b14",
            linkids = {
                ["642c14d9f2b67d287a35d439"] = true, --5
                ["6278c409c340bf24ab311522"] = true
            }
        }
    }
    for name, v in pairs(skinsmap) do --不准篡改皮肤数据
        if SKINS_LEGION[name].skin_id ~= v.id then
            return true
        end
        for idd, value in pairs(SKIN_IDS_LEGION) do
            if idd ~= v.id and value[name] and not v.linkids[idd] then
                -- print("----2"..tostring(name).."--"..tostring(idd))
                return true
            end
        end
    end
    skinsmap = {
        rosebush = {
            rosebush_marble = true,
            rosebush_collector = true
        },
        lilybush = {
            lilybush_marble = true,
            lilybush_era = true
        },
        orchidbush = {
            orchidbush_marble = true,
            orchidbush_disguiser = true
        },
        neverfadebush = {
            neverfadebush_thanks = true,
            neverfadebush_paper = true,
            neverfadebush_paper2 = true
        },
        icire_rock = {
            icire_rock_era = true,
            icire_rock_collector = true,
            icire_rock_day = true
        },
        siving_derivant = {
            siving_derivant_thanks = true,
            siving_derivant_thanks2 = true
        },
        siving_turn = {
            siving_turn_collector = true,
            siving_turn_future = true,
            siving_turn_future2 = true
        }
    }
    for name, v in pairs(skinsmap) do --不准私自给皮肤改名
        for sname, sv in pairs(SKINS_LEGION) do
            if sv.base_prefab == name and not v[sname] then
                -- print("----"..tostring(name).."--"..tostring(sname))
                return true
            end
        end
    end
end
local function CheckCheating(user_id, newskins)
    local skins = _G.SKINS_CACHE_L[user_id]
    if newskins == nil then --如果服务器上没有皮肤，则判断缓存里有没有皮肤
        if skins ~= nil then
            for skinname, hasit in pairs(skins) do
                if hasit then
                    CloseGame()
                    return false
                end
            end
        end
    else --如果服务器上有皮肤，则判断缓存里的某些皮肤与服务器皮肤的差异
        if skins ~= nil then
            local skinsmap = {
                carpet_whitewood_law = true,
                carpet_whitewood_big_law = true,
                revolvedmoonlight_item_taste = true,
                revolvedmoonlight_taste = true,
                revolvedmoonlight_pro_taste = true,
                revolvedmoonlight_item_taste2 = true,
                revolvedmoonlight_taste2 = true,
                revolvedmoonlight_pro_taste2 = true,
                backcub_fans2 = true,
                fishhomingtool_normal_taste = true,
                fishhomingtool_awesome_taste = true,
                fishhomingbait_taste = true
            }
            for skinname, hasit in pairs(skins) do
                if hasit and not skinsmap[skinname] and not newskins[skinname] then
                    CloseGame()
                    return false
                end
            end
        end
    end
    return true
end
local function GetGetTheSkins()
    if TheWorld == nil then
        return
    end

    local state = TheWorld[keykey]
    local ositemnow = os.time() or 0
    if state == nil then
        state = {
            loadtag = nil,
            task = nil,
            lastquerytime = nil
        }
        TheWorld[keykey] = state
    else
        if state.lastquerytime ~= nil and (ositemnow-state.lastquerytime) < 480 then
            return
        end
        if state.task ~= nil then
            state.task:Cancel()
            state.task = nil
        end
        state.loadtag = nil
    end
    state.lastquerytime = ositemnow

    if CheckFreeSkins() then
        CloseGame()
        return
    end

    local queues = {}
    for id, value in pairs(SKINS_CACHE_L) do
        table.insert(queues, id)
    end
    if #queues <= 0 then
        return
    end

    local querycount = 1
    state.task = TheWorld:DoPeriodicTask(3, function()
        if state.loadtag ~= nil then
            if state.loadtag == 0 then
                return
            else
                if querycount >= 3 or #queues <= 0 then
                    state.task:Cancel()
                    state.task = nil
                    return
                end
                querycount = querycount + 1
            end
        end
        state.loadtag = 0
        state.lastquerytime = os.time() or 0
        local idnow = table.remove(queues, math.random(#queues))
        TheSim:QueryServer(
            "https://fireleaves.cn/account/locakedSkin?mid=6041a52be3a3fb1f530b550a&id="..idnow,
            function(result_json, isSuccessful, resultCode)
                if isSuccessful and string.len(result_json) > 1 and resultCode == 200 then
                    local status, data = pcall( function() return json.decode(result_json) end )
                    if not status then
                        state.loadtag = -1
                    else
                        state.loadtag = 1
                        local skins = nil
                        if data ~= nil then
                            if data.lockedSkin ~= nil and type(data.lockedSkin) == "table" then
                                for kk,skinid in pairs(data.lockedSkin) do
                                    local skinkeys = SKIN_IDS_LEGION[skinid]
                                    if skinkeys ~= nil then
                                        if skins == nil then
                                            skins = {}
                                        end
                                        for skinname,vv in pairs(skinkeys) do
                                            if SKINS_LEGION[skinname] ~= nil then
                                                skins[skinname] = true
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if CheckCheating(idnow, skins) then
                            CheckSkinOwnedReward(skins)
                            SKINS_CACHE_L[idnow] = skins --服务器传来的数据是啥就是啥
                            local success, result = pcall(json.encode, skins or {})
                            if success then
                                SendModRPCToClient(GetClientModRPC("LegionSkined", "SkinHandle"), idnow, 1, result)
                            end
                        else
                            state.task:Cancel()
                            state.task = nil
                        end
                    end
                else
                    state.loadtag = -1
                end
                if querycount >= 3 or #queues <= 0 then
                    state.task:Cancel()
                    state.task = nil
                end
            end,
            "GET", nil
        )
    end, 0)
end

local function SwitchPlant(inst, plant)
	local cpt = inst.components.perennialcrop2
	if plant ~= nil then --说明是植物到生物
		cpt.cluster = plant.components.perennialcrop2.cluster
		cpt:OnClusterChange()
		inst.Transform:SetPosition(plant.Transform:GetWorldPosition())
		inst.Transform:SetRotation(plant.Transform:GetRotation())
	else --生物到植物
		inst.components.container:Close()
		inst.components.container.canbeopened = false
		inst.components.container:DropEverything()

		local plant = SpawnPrefab("plant_plantmeat_l")
        if plant ~= nil then
            plant.components.perennialcrop2.cluster = cpt.cluster
			plant.components.perennialcrop2:OnClusterChange()
            plant.Transform:SetPosition(inst.Transform:GetWorldPosition())
			plant.Transform:SetRotation(inst.Transform:GetRotation())
			return plant
        end
        -- inst:Remove() --现在删除还太早，生命组件会出手
	end
	GetGetTheSkins()
end
local function OnDeath_nep(inst, data)
	inst.components.perennialcrop2:GenerateLoot(nil, true, false)
	StopDigest(inst)
	inst.components.timer:StopTimer("swallow")
	inst.components.timer:StopTimer("lure")
	inst.components.timer:StopTimer("digested")

	inst.fn_switch(inst)
end

local function OnSave_nep(inst, data)
	if inst.count_digest > 0 then
		data.count_digest = inst.count_digest
	end
end
local function OnLoad_nep(inst, data)
	if data ~= nil then
		if data.count_digest ~= nil then
			inst.count_digest = data.count_digest
		end
	end
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

		inst:SetPhysicsRadiusOverride(.5)
    	MakeObstaclePhysics(inst, inst.physicsradiusoverride)

        inst.AnimState:SetBank("crop_legion_lureplant")
        inst.AnimState:SetBuild("crop_legion_lureplant")
        -- inst.AnimState:PlayAnimation("idle") --组件里会设置动画的

		inst.MiniMapEntity:SetIcon("plant_crop_l.tex")
		inst.Transform:SetTwoFaced() --两个面，这样就可以左右不同（再多貌似有问题）

		inst:AddTag("crop2_legion")
		inst:AddTag("veggie")
		inst:AddTag("notraptrigger")
    	inst:AddTag("noauradamage")
		inst:AddTag("companion")
		inst:AddTag("vaseherb")
		inst:AddTag("rotatableobject") --能让栅栏击剑起作用
		inst:AddTag("flatrotated_l") --棱镜标签：旋转时旋转180度

		inst._cluster_l = net_byte(inst.GUID, "plant_crop_l._cluster_l", "cluster_l_dirty")

		inst.displaynamefn = DisplayName_nep

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
			inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("plant_nepenthes_l") end
            return inst
        end

		inst.count_digest = 0 --已消化物品的数量
		inst.dist_swallow = DIST_SWALLOW[1] --吞食半径
		inst.num_swallow = NUM_SWALLOW[1] --一次能吞下对象的最大数量
		inst.time_swallow = TIME_SWALLOW[1] --主动吞食后的消化时间
		inst.dist_lure = DIST_LURE[1] --引诱半径
		inst.sounds = sounds_nep
		inst.task_digest = nil

		inst.fn_tryDigest = TryDigest
		inst.fn_trySwallow = TrySwallow
		inst.fn_doSwallow = DoSwallow
		inst.fn_doLure = DoLure
		inst.fn_death = OnDeath_nep
		inst.fn_switch = SwitchPlant

		inst:AddComponent("inspectable")

		inst:AddComponent("savedrotation")

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

		inst:AddComponent("timer")

		inst:AddComponent("perennialcrop2")
		inst.components.perennialcrop2.fn_cluster = OnCluster_nep
		inst.components.perennialcrop2.infested_max = 50 --我可不想它直接被害虫干掉了
		inst.components.perennialcrop2:SetNoFunction()
		inst.components.perennialcrop2:SetUp("plantmeat", CROPS_DATA_LEGION["plantmeat"], {
			moisture = nil, nutrient = nil, tendable = nil, seasonlisten = nil,
			nomagicgrow = true, fireproof = true, cangrowindrak = true
		})
		inst.components.perennialcrop2:SetStage(3, false)

		inst:SetStateGraph("SGplant_nepenthes_l")

		inst:ListenForEvent("timerdone", OnTimerDone_nep)

		inst.OnSave = OnSave_nep
		inst.OnLoad = OnLoad_nep

		MakeHauntableDropFirstItem(inst)

		-- if TUNING.SMART_SIGN_DRAW_ENABLE then
		-- 	SMART_SIGN_DRAW(inst)
		-- end

        return inst
    end,
    {
        Asset("ANIM", "anim/ui_nepenthes_l_4x4.zip"),
		Asset("ANIM", "anim/crop_legion_lureplant.zip")
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
