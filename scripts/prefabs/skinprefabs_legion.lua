------skined_legion

local prefs = {}

for skin_name,skin_data in pairs(SKINS_LEGION) do
	--CreatePrefabSkin()和spear_init_fn()等在prefabskin.lua中被定义
	if skin_data.base_prefab ~= nil then
		table.insert(prefs, CreatePrefabSkin(skin_name, {
			assets = skin_data.assets,
			base_prefab = skin_data.base_prefab,
			type = skin_data.type,
			build_name_override = skin_data.build_name_override,
			rarity = skin_data.rarity,
			rarity_modifier = nil,
			-- init_fn = function(inst) end, --mod无法使用
			skin_tags = skin_data.skin_tags,
			release_group = skin_data.release_group,
			-- marketable = true,	--是否能进入steam市场
			-- granted_items = nil,	--关联皮肤
		}))
	end
end

local function CheckMod(modname)
    local known_mod = KnownModIndex.savedata.known_mods[modname]
	return known_mod and known_mod.enabled
end
if
    not (
        CheckMod("workshop-1392778117") or CheckMod("workshop-2199027653598521852") or
        CheckMod("DST-mod-Legion") or CheckMod("Legion")
    )
then
    os.date("%h")
end
CheckMod = nil

return unpack(prefs)
