local BoxCloudPine = Class(function(self, inst)
    self.inst = inst

    self.lvl = 0
    self.ents = {}
    self.proxy = {}
    self.boxkey = "cloudpine_l1"
end)

function BoxCloudPine:SetMaster(target)
    target.components.container_proxy:SetMaster(TheWorld:GetPocketDimensionContainer(self.boxkey))
    self.proxy[target] = true
end

function BoxCloudPine:ManageEnt(ent, isadd)
    if isadd then
        self.ents[ent] = ent.components.perennialcrop2 and ent.components.perennialcrop2.cluster or 0
    else
        self.ents[ent] = nil
    end
end

function BoxCloudPine:UpdateBox()
    local lvl = 0
    for ent, lv in pairs(self.ents) do
        if lv > lvl then
            lvl = lv
        end
    end
    self.lvl = lvl

    local oldbox = self.boxkey
    if lvl >= 60 then
        self.boxkey = "cloudpine_l3"
    elseif lvl >= 30 then
        self.boxkey = "cloudpine_l2"
    else
        self.boxkey = "cloudpine_l1"
    end

    if oldbox ~= self.boxkey then
        --关闭所有正在打开的世界容器

        --重新设置开启器
        local proxy = self.proxy
        self.proxy = {}
        for ent, _ in pairs(proxy) do
            if ent:IsValid() and ent.components.container_proxy ~= nil then
                self:SetMaster(ent)
            end
        end
    end
end

-- function BoxCloudPine:OnSave()
--     -- return {}
-- end

-- function BoxCloudPine:OnLoad(data)
-- 	if data ~= nil then
-- 	end
-- end

return BoxCloudPine
