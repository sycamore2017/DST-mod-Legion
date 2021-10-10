------skined_legion

local _G = GLOBAL
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()
-- local dataSkins = require("skin/skinsdata_legion")

--------------------------------------------------------------------------
--[[ 全局皮肤总数据，以及修改 ]]
--------------------------------------------------------------------------

local rarityRepay = "ProofOfPurchase"
local rarityFree = "Event"

function _G.rosorns_clear_fn(inst) --【服务端】
    inst.AnimState:SetBank("rosorns")
    inst.AnimState:SetBuild("rosorns")
    inst.AnimState:PlayAnimation("idle")

    inst.components.inventoryitem.atlasname = "images/inventoryimages/rosorns.xml"
    inst.components.inventoryitem:ChangeImageName("rosorns")
end

_G.SKINS_LEGION = {
	rosorns_spell = {
        base_prefab = "rosorns",
		type = "item", --item物品皮肤，base人物皮肤
		rarity = rarityRepay,
		skin_tags = {},
		release_group = 555,
		build_name_override = nil, --皮肤名称(居然是小写)

		assets = { --仅仅是用于初始化注册
			Asset("ANIM", "anim/skin/swap_spear_mirrorrose.zip"),
			Asset("ANIM", "anim/skin/spear_mirrorrose.zip"),
		},
		image = { name = nil, atlas = nil }, --提前注册，让客户端科技栏使用的皮肤图片
		anim = { bank = "spear_mirrorrose", build = "spear_mirrorrose", anim = nil },
        namestr = { chs = "施咒蔷薇", eng = "Rose Spell Staff" }, --皮肤名字
    },
}

local ischinese = TUNING.LEGION_MOD_LANGUAGES == "chinese"
for skinname,v in pairs(_G.SKINS_LEGION) do
	if v.image ~= nil then
		if v.image.name == nil then
			v.image.name = skinname..".tex"
		end
		if v.image.atlas == nil then
			v.image.atlas = "images/inventoryimages_skin/"..skinname..".xml"
		end

        table.insert(Assets, Asset("ATLAS", v.image.atlas))
        table.insert(Assets, Asset("IMAGE", "images/inventoryimages_skin/"..v.image.name))
        RegisterInventoryItemAtlas(v.image.atlas, v.image.name)
	end
	if v.anim ~= nil then
		if v.anim.bank == nil then
			v.anim.bank = skinname
		end
		if v.anim.build == nil then
			v.anim.build = skinname
		end
		if v.anim.anim == nil then
			v.anim.anim = "idle"
		end
	end
	if v.build_name_override == nil then
		v.build_name_override = skinname
	end
    if v.assets ~= nil then
        for kk,ast in pairs(v.assets) do
            table.insert(Assets, ast)
        end
    end

    table.insert(v.skin_tags, string.upper(skinname))
    table.insert(v.skin_tags, "CRAFTABLE")

    if ischinese then
        STRINGS.SKIN_NAMES[skinname] = v.namestr.chs
    else
        STRINGS.SKIN_NAMES[skinname] = v.namestr.eng
    end

    ------修改PREFAB_SKINS(在prefabskins.lua中被定义)
    if _G.PREFAB_SKINS[v.base_prefab] == nil then
        _G.PREFAB_SKINS[v.base_prefab] = { skinname }
    else
        table.insert(_G.PREFAB_SKINS[v.base_prefab], skinname)
    end
end
ischinese = nil

------重新生成一遍PREFAB_SKINS_IDS(在prefabskins.lua中被定义)
_G.PREFAB_SKINS_IDS = {}
for prefab,skins in pairs(_G.PREFAB_SKINS) do
	_G.PREFAB_SKINS_IDS[prefab] = {}
	for k,v in pairs(skins) do
		_G.PREFAB_SKINS_IDS[prefab][v] = k
	end
end

AddRecipe(
    "rosorns", {
        Ingredient("siving_rocks", 6, "images/inventoryimages/siving_rocks.xml"),
        Ingredient("pinecone", 20),
    }, RECIPETABS.FARM, TECH.MAGIC_TWO, nil, nil, nil, nil, nil,
    "images/inventoryimages/rosorns.xml", "rosorns.tex"
)
STRINGS.RECIPE_DESC.ROSORNS = "测试啊"

--------------------------------------------------------------------------
--[[ 资源注册 ]]
--------------------------------------------------------------------------

-- local prefabFiles = {
--     "fimbul_axe",
-- }

-- for k,v in pairs(prefabFiles) do
--     table.insert(PrefabFiles, v)
-- end

-----

-- local assets = {
--     Asset("ATLAS", "images/inventoryimages/dualwrench.xml"),
--     Asset("IMAGE", "images/inventoryimages/dualwrench.tex"),
-- }

-- for k,v in pairs(assets) do
--     table.insert(Assets, v)
-- end

--------------------------------------------------------------------------
--[[ 修改皮肤的网络判定函数 ]]
--------------------------------------------------------------------------

--ValidateRecipeSkinRequest()位于networking.lua中
local ValidateRecipeSkinRequest_old = _G.ValidateRecipeSkinRequest
_G.ValidateRecipeSkinRequest = function(user_id, prefab_name, skin, ...)
    --【服务端】环境
    local validated_skin = nil

    if skin ~= nil and skin ~= "" and SKINS_LEGION[skin] ~= nil then
        if table.contains( _G.PREFAB_SKINS[prefab_name], skin ) then
            validated_skin = skin
        end
    else
        validated_skin = ValidateRecipeSkinRequest_old(user_id, prefab_name, skin, ...)
    end

    return validated_skin
end

--------------------------------------------------------------------------
--[[ 修改ui以显示mod皮肤 ]]
--------------------------------------------------------------------------

AddClassPostConstruct("widgets/recipepopup", function(self)
    ------【客户端】获取玩家拥有的皮肤
    local GetSkinsList_old = self.GetSkinsList
    self.GetSkinsList = function(self, ...)
        self.skins_list = GetSkinsList_old(self, ...)

        --undo这里需要确定玩家是否拥有该皮肤
        if self.recipe and PREFAB_SKINS[self.recipe.product] then
            for _, item_type in pairs(PREFAB_SKINS[self.recipe.product]) do
                if SKINS_LEGION[item_type] then
                    local data  = {
                        type = type, --不知道是啥
                        item = item_type, --就是这个皮肤的名字
                        timestamp = -10000,
                        -- ismodskin = true, --多加的变量，用来标记mod皮肤
                    }
                    table.insert(self.skins_list, data)
                end
            end
        end

        return self.skins_list
    end

    ------【客户端】生成玩家的皮肤选项
    --local _GSO = self.GetSkinOptions
    -- self.GetSkinOptions = function(self)
    -- end
end)
