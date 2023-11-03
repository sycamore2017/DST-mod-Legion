local CarpetPullerLegion = Class(function(self, inst)
    self.inst = inst
end)

function CarpetPullerLegion:DoIt(pos, doer)
    local res = false
    local x, y, z = pos:Get()
	local ents = TheSim:FindEntities(x, y, z, 2, { "carpet_l" }, { "INLIMBO" }, nil)
    for _, v in ipairs(ents) do
        if v.OnCarpetRemove ~= nil then
            v.OnCarpetRemove(v, doer)
        end
        v:Remove()
        res = true
    end
    return res
end

return CarpetPullerLegion
