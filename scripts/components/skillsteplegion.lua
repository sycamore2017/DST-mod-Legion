local skillStepLegion = Class(function(self, inst)
    self.inst = inst
	self.fn_spell = nil
end)

function skillStepLegion:CastSpell(caster, pos, options)
	if self.fn_spell ~= nil then
		self.fn_spell(self.inst, caster, pos, options)
	end
	-- self.inst:PushEvent("skillspelled", {caster = caster, pos = pos, options})
end

return skillStepLegion
