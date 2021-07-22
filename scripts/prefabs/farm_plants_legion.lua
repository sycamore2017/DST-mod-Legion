local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS
local WEED_DEFS = require("prefabs/weed_defs").WEED_DEFS
local prefs = {}
local defs = {}

local grow_sounds =
{
	grow_oversized = "farming/common/farm/grow_oversized",
	grow_full = "farming/common/farm/grow_full",
	grow_rot = "farming/common/farm/rot",
}

--------------------------------------------------------------------------
--[[ 合并所有作物数据，并加入个性化数据 ]]
--------------------------------------------------------------------------

for k,v in pairs(PLANT_DEFS) do
	if k ~= "randomseed" then
		local data = {
			build = v.build,	--贴图
			bank = v.bank,		--动画模板
			fireproof = v.fireproof, --是否防火
			weights	= v.weight_data, --重量范围
			sounds = v.sounds, --音效
			prefab = v.prefab, --作物 代码名称
			product = v.product, --产物 代码名称
			product_oversized = v.product_oversized, --巨型产物 代码名称
			seed = v.seed, --种子 代码名称
			loot_oversized_rot = v.loot_oversized_rot, --巨型产物腐烂后的收获物
			-- growTime = , --生长时间
			-- costMoisture = , --需水量
			costNutrient = v.nutrient_consumption, --需肥类型：{S, 0, S}
			canGrowInDark = v.canGrowInDark, --是否能在黑暗中生长（原创）
			-- stages --该植物生长有几个阶段，每个阶段的动画,以及是否处在花期（原创）
			goodSeasons = v.good_seasons, --喜好季节：{autumn = true, winter = true, spring = true, summer = true}
			maxKilljoysTolerance = v.max_killjoys_tolerance, --扫兴容忍度：一般都为0
		}
		--写错啦！！！！！！！
		--这个为本mod新增属性，其他mod的作物请在定义作物数据时加入


		table.insert(defs, data)
	end
end

for k,v in pairs(WEED_DEFS) do
	local data = {}
	table.insert(defs, data)
end

--------------------------------------------------------------------------
--[[ 作物实体代码 ]]
--------------------------------------------------------------------------

local function MakePlant(data)
	return Prefab(
		"siving_soil_item",
		function()
			local inst = CreateEntity()

			inst.entity:AddTransform()
			inst.entity:AddAnimState()
			inst.entity:AddNetwork()

			MakeInventoryPhysics(inst)

			inst.AnimState:SetBank("siving_soil")
			inst.AnimState:SetBuild("siving_soil")
			inst.AnimState:PlayAnimation("item")

			inst:AddTag("molebait")

			inst.entity:SetPristine()
			if not TheWorld.ismastersim then
				return inst
			end

			

			return inst
		end,
		{
			Asset("SCRIPT", "scripts/prefabs/farm_plant_defs.lua"),
			Asset("SCRIPT", "scripts/prefabs/weed_defs.lua"),
		},
		{ "siving_soil_item", "siving_soil" }
	)
end

--------------------
--------------------

for k,v in pairs(defs) do
	table.insert(prefs, MakePlant(v))
end

return unpack(prefs)
