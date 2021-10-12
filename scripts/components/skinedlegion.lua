local SkinedLegion = Class(function(self, inst)
	self.inst = inst

	self.isServe = TheNet:GetIsMasterSimulation()
	self.skin = nil
	self._skin_idx = net_byte(inst.GUID, "skinedlegion._skin_idx", "skin_idx_l_dirty")

	if not TheNet:IsDedicated() then
		--【客户端】环境
        self.inst:ListenForEvent("skin_idx_l_dirty", function()
			local idx = self._skin_idx:value()
            if idx and SKIN_IDX_LEGION[idx] ~= nil then
                self.skin = SKIN_IDX_LEGION[idx]
				self.inst.skinname = self.skin --这个变量控制着“审视自我”、“审视他人”时的皮肤设置
			else
				self.skin = nil
				self.inst.skinname = nil
            end
        end)
    end
end)

function SkinedLegion:GetSkin() --【服务、客户端】环境
	return self.skin
end

function SkinedLegion:GetSkinData(skinname) --【服务、客户端】环境
	return skinname == nil and SKIN_PREFABS_LEGION[self.inst.prefab] or SKINS_LEGION[skinname]
end

function SkinedLegion:GetSkinedData() --【服务、客户端】环境
	if self.skin == nil then
		return
	else
		return SKINS_LEGION[self.skin]
	end
end

------以下均为【服务端】环境

function SkinedLegion:SetSkin(skinname)
	if not self.isServe or self.skin == skinname then
		return true
	end

	local skin_data_last = self:GetSkinData(self.skin)
	local skin_data = self:GetSkinData(skinname)

	if skin_data ~= nil then
		--取消前一个皮肤的效果
		if skin_data_last ~= nil then
			if skin_data_last.fn_end ~= nil then
				skin_data_last.fn_end(self.inst, skin_data_last)
			end
		end
		--应用新皮肤的效果
		if skin_data.fn_start ~= nil then
			skin_data.fn_start(self.inst, skin_data)
		end

		if skinname == nil then --代表恢复原皮肤
			self._skin_idx:set(nil)
			self.skin = nil
			self.inst.skinname = nil
		else
			self._skin_idx:set(skin_data.skin_idx)
			self.skin = skinname
			self.inst.skinname = skinname
		end

		return true
	end

	return false
end

function SkinedLegion:OnSave()
	if self.skin ~= nil then
		return { skin = self.skin }
	else
		return nil
	end
end

function SkinedLegion:OnLoad(data)
	if data == nil then
		return
	end

	if data.skin ~= nil then
		self.skin = nil --先还原为原皮肤，才能应用新皮肤
		self:SetSkin(data.skin)
	end
end

function SkinedLegion:SetOnPreLoad(onpreloadfn) --提前加载皮肤数据，好让其他组件应用
	self.inst.OnPreLoad = function(inst, data, ...)
		if data ~= nil then
			if data.skin ~= nil then
				self.skin = data.skin
				self.inst.skinname = data.skin
			end
		end
		if onpreloadfn ~= nil then
			onpreloadfn(inst, data, ...)
		end
	end
end

return SkinedLegion
