local SkillSpellLegion = Class(function(self, inst)
    self.inst = inst
	self.fn_spell = nil
end)

function SkillSpellLegion:CanCast(caster, pos)
	return self.inst.components.aoetargeting ~= nil and self.inst.components.aoetargeting.alwaysvalid or
		(
			TheWorld.Map:IsPassableAtPoint(pos:Get()) and
			not TheWorld.Map:IsGroundTargetBlocked(pos) and
			TheWorld.Map:IsAboveGroundAtPoint(pos:Get())
		)
end

function SkillSpellLegion:CastSpell(caster, pos, options)
	if self.fn_spell ~= nil then
		self.fn_spell(self.inst, caster, pos, options)
	end
	-- self.inst:PushEvent("skillspelled", {caster = caster, pos = pos, options})
end

return SkillSpellLegion
