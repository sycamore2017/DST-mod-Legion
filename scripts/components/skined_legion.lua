local SkinedLegion = Class(function(self, inst)
	self.inst = inst

	self.skin = nil
	self._skin_idx = net_byte(inst.GUID, "skinedlegion._skin_idx", "skin_idx_l_dirty")

	if not TheNet:IsDedicated() then
		--【客户端】环境
        self.inst:ListenForEvent("skin_idx_l_dirty", function()
			local idx = self._skin_idx:value()
            if idx and SKIN_IDX_LEGION[idx] ~= nil then
                self.skin = SKIN_IDX_LEGION[idx]
			else
				self.skin = nil
            end
        end)
    end
end)

function SkinedLegion:GetSkin()
	
end

function SkinedLegion:SetSkin(skinname)
	local skin_last = self.skin
	if skinname == nil or skinname == self.inst.prefab then --代表恢复原皮肤
		
	end

	local skin_last = self.skin
	local sinkdata = nil
	if skinname == nil then --代表恢复原皮肤
		self._skin_idx:set(nil)
		self.skin = nil
		skinname = self.inst.prefab
	else
		sinkdata = SKINS_LEGION[skinname]
	end

	if sinkdata == nil then --新皮肤非法的、或者想恢复原皮
		self._skin_idx:set(nil)
		self.skin = nil
	end

	local fns_base = self.skin_fns[self.inst.prefab]
		if fns_base ~= nil then
			if fns_base.start ~= nil then
				fns_base.start(self)
			end
		end

	
end

return SkinedLegion
