local SkinedLegion = Class(function(self, inst)
	self.inst = inst
	LS_C_Set(self)
end)

------以下均为【服务器、客户端】环境

function SkinedLegion:GetSkin()
	return self.skin
end

function SkinedLegion:GetSkinData(skinname)
	
end
function SkinedLegion:GetSkinedData()
	return self._skindata
end
function SkinedLegion:GetLinkedSkins()
	if self._skindata ~= nil then
		return self._skindata.linkedskins
	else
		return nil
	end
end

------以下均为【服务器】环境

function SkinedLegion:SetLinkedSkin(newinst, linkedkey, doer)
	local linkdata = self:GetLinkedSkins() or nil
	if linkdata ~= nil and linkdata[linkedkey] ~= nil then
		newinst.components.skinedlegion:SetSkin(linkdata[linkedkey], self.userid or (doer and doer.userid or nil))
	end
end
function SkinedLegion:SpawnLinkedSkinLoot(prefabname, dropper, linkedkey, doer)
	local linkdata = self:GetLinkedSkins() or nil
	if linkdata ~= nil and linkdata[linkedkey] ~= nil then
		dropper.components.lootdropper:SpawnLootPrefab(prefabname, nil,
			linkdata[linkedkey], nil, self.userid or (doer and doer.userid or nil))
	else
		dropper.components.lootdropper:SpawnLootPrefab(prefabname)
	end
end

SkinedLegion.SetSkin = LS_C_SetSkin

function SkinedLegion:OnSave()
	if self.skin ~= nil then
		return { skin = self.skin, userid = self.userid }
	end
end
SkinedLegion.OnLoad = LS_C_OnLoad

function SkinedLegion:SpawnSkinExchangeFx(skinname, tool)
	local skindata = skinname == nil and self._skindata or C_GetSkinData(skinname)
	if skindata ~= nil then
		if skindata.fn_spawnSkinExchangeFx ~= nil then
			skindata.fn_spawnSkinExchangeFx(self.inst)
		elseif skindata.exchangefx ~= nil then
			local fx = nil
			if skindata.exchangefx.prefab ~= nil then
				fx = SpawnPrefab(skindata.exchangefx.prefab)
			elseif tool ~= nil then
				fx = "explode_reskin"
				local skin_fx = SKIN_FX_PREFAB[tool:GetSkinName()]
				if skin_fx ~= nil and skin_fx[1] ~= nil then
					fx = skin_fx[1]
				end
				fx = SpawnPrefab(fx)
			end

			if fx ~= nil then
				if skindata.exchangefx.scale ~= nil then
					fx.Transform:SetScale(skindata.exchangefx.scale, skindata.exchangefx.scale, skindata.exchangefx.scale)
				end
				if skindata.exchangefx.offset_y ~= nil then
					local fx_pos_x, fx_pos_y, fx_pos_z = self.inst.Transform:GetWorldPosition()
					fx_pos_y = fx_pos_y + skindata.exchangefx.offset_y
					fx.Transform:SetPosition(fx_pos_x, fx_pos_y, fx_pos_z)
				else
					fx.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
				end
			end
		end
	end
end

return SkinedLegion
