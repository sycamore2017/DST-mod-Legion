local SoulContracts = Class(function(self, inst)
    self.inst = inst
end)

function SoulContracts:CanEat(eater)
    return self.inst.components.finiteuses ~= nil and
        self.inst.components.finiteuses:GetUses() > 0 and
        eater.components.souleater ~= nil
end

function SoulContracts:EatSoul(eater)
    -- if not self:CanEat(eater) then
    --     return false
    -- end

    -- self.inst:PushEvent("oneatsoul", { soul = self.inst })
    if eater.components.souleater.oneatsoulfn ~= nil then
        eater.components.souleater.oneatsoulfn(eater, self.inst)
    end
    self.inst.components.finiteuses:Use(1)

    return true
end

return SoulContracts
