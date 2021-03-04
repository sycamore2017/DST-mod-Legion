local UpgradeKit = Class(function(self, inst)
	self.inst = inst
	self.data = nil
end)

function UpgradeKit:SetData(newdata)
	if self.data ~= nil then
		for k,v in pairs(self.data) do
			self.inst:RemoveTag(k.."_upkit")
		end
	end
	self.data = newdata
	if newdata ~= nil then
		for k,v in pairs(newdata) do
			self.inst:AddTag(k.."_upkit")
		end
	end
end

function UpgradeKit:Upgrade(doer, target)
	if self.data ~= nil and self.data[target.prefab] ~= nil then
		local dat = self.data[target.prefab]
		local result = SpawnPrefab(dat.prefabresult)
		if result ~= nil then
			result.Transform:SetPosition(target.Transform:GetWorldPosition())
			if dat.onupgradefn ~= nil then
				dat.onupgradefn(self.inst, doer, target, result)
			end
			return true
		else
			return false
		end
	end
	return false
end

function UpgradeKit:OnSave()
	if self.data ~= nil then
		return self.data
	end
	return {}
end

function UpgradeKit:OnLoad(data)
	self:SetData(data)
end

return UpgradeKit