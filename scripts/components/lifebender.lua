local LifeBender = Class(function(self, inst)
    self.inst = inst
	self.fn_bend = nil
end)

function LifeBender:Do(doer, pos, options)
	if self.fn_bend ~= nil then
		return self.fn_bend(self.inst, doer, pos, options)
	end
	return true
end

return LifeBender
