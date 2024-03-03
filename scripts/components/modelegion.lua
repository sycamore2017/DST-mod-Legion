local ModeLegion = Class(function(self, inst)
	self.inst = inst

	self.now = 1
	self.max = 2
	-- self.fn_test = function(inst, newmode, doer)end
	-- self.fn_do = function(inst, newmode, doer)end
end)

function ModeLegion:Init(num, nummax, fn_test, fn_do)
    self.now = num
	self.max = nummax
	self.fn_test = fn_test
	self.fn_do = fn_do
end

function ModeLegion:SetMode(mode, doer)
    if mode ~= nil then
		mode = math.clamp(mode, 1, self.max)
	else --如果为空，则按顺序切换到下一个
		if self.now >= self.max then
			mode = 1
		else
			mode = self.now + 1
		end
	end
	if self.fn_test == nil or self.fn_test(self.inst, mode, doer) then
		self.now = mode
		self.fn_do(self.inst, mode, doer)
		return true
	end
	return false
end

return ModeLegion
