local SkinedLegion = Class(function(self, inst)
	self.inst = inst
	LS_C_Set(self)
end)

------以下均为【服务器、客户端】环境

function SkinedLegion:GetSkin()
	return self.skin
end

function SkinedLegion:GetSkinedData()
	return self.skineddata
end

------以下均为【服务器】环境

function SkinedLegion:SetLinkedSkin(newinst, linkedkey, doer)
	local linkdata = self.skineddata and self.skineddata.linkedskins or nil
	if linkdata ~= nil and linkdata[linkedkey] ~= nil then
		newinst.components.skinedlegion:SetSkin(linkdata[linkedkey], self.userid or (doer and doer.userid or nil))
	end
end

SkinedLegion.SetSkin = LS_C_SetSkin

function SkinedLegion:OnSave()
	if self.skin ~= nil then
		return { skin = self.skin, userid = self.userid, pskin = self.problemskin }
	end
end
SkinedLegion.OnLoad = LS_C_OnLoad

return SkinedLegion
