------skined_legion

local prefs = {}

for skin_name,skin_data in pairs(SKINS_LEGION) do
	--CreatePrefabSkin()和spear_init_fn()等在prefabskin.lua中被定义

	table.insert(prefs, CreatePrefabSkin(skin_name,
	{
		assets = skin_data.assets,
		base_prefab = skin_data.base_prefab,
		type = skin_data.type,
		build_name_override = skin_data.build_name_override,
		rarity = skin_data.rarity,
		rarity_modifier = nil,
		init_fn = function(inst) --【客户端+服务端】
			print("真的初始化了吗")
			inst.skin_legion = skin_name

			inst.AnimState:SetBank(skin_data.anim.bank)
			inst.AnimState:SetBuild(skin_data.anim.build)
			inst.AnimState:PlayAnimation(skin_data.anim.anim)

			if not TheWorld.ismastersim then
				return
			end

			--改变物品栏贴图
			inst.components.inventoryitem.atlasname = skin_data.image.atlas
			inst.components.inventoryitem:ChangeImageName(skin_data.image.name)
		end,
		skin_tags = skin_data.skin_tags,
		release_group = skin_data.release_group,
		-- marketable = true,	--是否能进入steam市场
		-- granted_items = nil,	--关联皮肤
	}))
end

return unpack(prefs)
