local function OnFuelChange(inst, data)
	if data and data.percent then
		if data.percent >= 1 then --充满了，停止自动充能
			inst.components.batterylegion:StopCharge()
		else --没有充满，继续充能
			if inst.components.batterylegion.task == nil then
				inst.components.batterylegion:StartCharge()
			end
		end
	end
end
local function DoCharge_task(self)
	self.time_start = GetTime()
	self:Charge(self.charge_value, nil)
end

local BatteryLegion = Class(function(self, inst)
	self.inst = inst

	self.time_start = nil
	self.task = nil

	self.charge_period = 240 --每隔这个时间，恢复能量
	self.charge_value = 5 --每次恢复的能量

	inst:ListenForEvent("percentusedchange", OnFuelChange)
end)

function BatteryLegion:Charge(value, doer)
    if self.inst.components.fueled == nil then
		self:StopCharge()
		return
	end
	self.inst.components.fueled:DoDelta(value, doer)
end

function BatteryLegion:StartCharge() --开始自动充能
	if self.task ~= nil then
        self.task:Cancel()
    end
	self.time_start = GetTime()
	self.task = self.inst:DoPeriodicTask(self.charge_period, DoCharge_task, nil, self)
end
function BatteryLegion:StopCharge() --结束自动充能
	if self.task ~= nil then
        self.task:Cancel()
		self.task = nil
    end
	self.time_start = nil
end

function BatteryLegion:CanDo(doer, target)
    if self.inst.components.fueled ~= nil then
		if self.inst.components.fueled:IsEmpty() then
			return false, "EMPTY"
		end
	end
	return true
end
function BatteryLegion:Do(doer, target)
    local cpt = self.inst.components.fueled

end

function BatteryLegion:OnEntitySleep()
    if self.task ~= nil then
        self.task:Cancel()
		self.task = nil
    end
end
function BatteryLegion:OnEntityWake()
	if self.time_start ~= nil then
		self:LongUpdate(GetTime()-self.time_start)
	else
		if self.task == nil and self.inst.components.fueled ~= nil then
			
		end
	end
end
function BatteryLegion:LongUpdate(dt)
    if self.time_start == nil or self.inst.components.fueled == nil then
		return
	end
	dt = math.max(GetTime()-self.time_start, dt) --最大经过时间
	self:Charge(dt/self.charge_period*self.charge_value, nil) --换算成能量值
end

return BatteryLegion
