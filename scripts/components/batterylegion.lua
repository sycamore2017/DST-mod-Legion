local function OnFuelChange(inst, data)
	if data and data.percent then
		if data.percent >= 1 then --充满了，停止自动充能
			inst.components.batterylegion:StopCharge()
		else --没有充满，继续充能
			if inst.components.batterylegion.time_start == nil then
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

	self.inst:ListenForEvent("percentusedchange", OnFuelChange)
end)

function BatteryLegion:Charge(value, doer)
	if self.inst.components.fueled ~= nil then
		self.inst.components.fueled:DoDelta(value, doer)
	end
end

function BatteryLegion:StartCharge() --开始自动充能
	if self.task ~= nil then
        self.task:Cancel()
		self.task = nil
    end
	self.time_start = GetTime()
	if not self.inst:IsAsleep() then
		self.task = self.inst:DoPeriodicTask(self.charge_period, DoCharge_task, nil, self)
	end
end
function BatteryLegion:StopCharge() --结束自动充能
	if self.task ~= nil then
        self.task:Cancel()
		self.task = nil
    end
	self.time_start = nil
end

local function TryCostEnergy(cpt, cost, doer)
	if cpt == nil then
		return true
	end
	if cpt.currentfuel >= cost then
		cpt:DoDelta(-cost, doer)
		return true
	else
		return false
	end
end
function BatteryLegion:Do(doer, target)
	local cost = 0
    local cpt = self.inst.components.fueled
	if cpt ~= nil and cpt.currentfuel <= 0 then
		return false, "NOENERGY"
	end

	if target.prefab == "fimbul_axe" then --芬布尔斧
		if target.components.finiteuses ~= nil and target.components.finiteuses:GetPercent() < 1 then
			cost = 25
			if not TryCostEnergy(cpt, cost, doer) then
				return false, "NOENERGY"
			end
			target.components.finiteuses:Repair(50)
		else
			return false, "NONEED"
		end
	elseif target.components.genetrans ~= nil then --子圭·育
		cost = 50
		if not TryCostEnergy(cpt, cost, doer) then
			return false, "NOENERGY"
		end
		--undo
	elseif target.prefab == "firesuppressor" or target.prefab == "winona_battery_low" then --雪球发射器、薇诺娜的发电机
		if target.components.fueled ~= nil and target.components.fueled:GetPercent() < 0.99 then
			if not target.components.fueled.accepting then
				return false, "REFUSE"
			end
			cost = target.prefab == "firesuppressor" and 20 or 10
			if not TryCostEnergy(cpt, cost, doer) then
				return false, "NOENERGY"
			end
			local fueled = target.components.fueled
			local value = fueled.maxfuel*0.5
			fueled:DoDelta(value, doer)
			if fueled.ontakefuelfn ~= nil then
				fueled.ontakefuelfn(target, value)
			end
			target:PushEvent("takefuel", { fuelvalue = value })
		else
			return false, "NONEED"
		end
	elseif target.prefab == "winona_battery_high" then --薇诺娜的宝石发电机
		if
			target.components.fueled ~= nil and
			target.components.trader ~= nil and target.components.trader.enabled
		then
			if not target.components.fueled.accepting then
				return false, "REFUSE"
			end
			cost = 20
			if not TryCostEnergy(cpt, cost, doer) then
				return false, "NOENERGY"
			end
			local gem = SpawnPrefab("bluegem")
			if gem ~= nil then
				local abletoaccept, reason = target.components.trader:AbleToAccept(gem, doer)
				if abletoaccept then
					target.components.trader:AcceptGift(doer, gem, 1)
				else
					if doer ~= nil and doer.components.inventory ~= nil then
						gem.Transform:SetPosition(doer.Transform:GetWorldPosition())
						doer.components.inventory:GiveItem(gem, nil, doer:GetPosition())
					else
						gem.Transform:SetPosition(target.Transform:GetWorldPosition())
					end
				end
			end
		else
			return false, "NONEED"
		end
	elseif --有移动能力的生物、玩家
		target.components.combat ~= nil and
		(target.components.combat.target == nil or not target.components.combat.target:HasTag("player")) and
		target.components.health ~= nil and not target.components.health:IsDead() and
		target.components.locomotor ~= nil and (
			target:HasTag("player") or not (
				target:HasTag("shadow_aligned") or target:HasTag("lunar_aligned") or
				target:HasTag("lightninggoat")
			)
		)
	then
		if target.components.upgrademoduleowner ~= nil and not target.components.upgrademoduleowner:ChargeIsMaxed() then
			cost = 50
		else
			cost = 40
		end
		if not TryCostEnergy(cpt, cost, doer) then
			if cost > 40 then --如果不够能量那就判断是不是可以不用额外功能
				cost = 40
				if not TryCostEnergy(cpt, cost, doer) then --还是不够那就gg
					return false, "NOENERGY"
				end
			else
				return false, "NOENERGY"
			end
		end

		if target.components.playerlightningtarget ~= nil then
			target.components.playerlightningtarget:DoStrike()
		else
			if
				not target.components.health:IsInvincible() and
				(target.components.inventory == nil or not target.components.inventory:IsInsulated())
			then
				local damage = TUNING.ELECTRIC_WET_DAMAGE_MULT * (
					target.components.moisture ~= nil and target.components.moisture:GetMoisturePercent() or
					(target:GetIsWet() and 1 or 0)
				)
            	damage = TUNING.LIGHTNING_DAMAGE + damage*TUNING.LIGHTNING_DAMAGE
				target.components.health:DoDelta(-damage, false, self.inst.prefab)
			end
		end
		if not target.components.health:IsDead() then
			target:AddDebuff("buff_electricattack", "buff_electricattack")
			if
				cost > 40 and
				target.components.upgrademoduleowner ~= nil and
				not target.components.upgrademoduleowner:ChargeIsMaxed()
			then
				target.components.upgrademoduleowner:AddCharge(TUNING.WX78_MAXELECTRICCHARGE)
			end
		end
	end

	if cost > 0 then
		--特效undo

		if self.inst.components.fueled == nil then
			if self.inst.components.stackable ~= nil then
				self.inst.components.stackable:Get():Remove()
			else
				self.inst:Remove()
			end
		end
		return true
	end
	return false, "NOUSE"
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
	end
end
function BatteryLegion:LongUpdate(dt)
	if self.time_start == nil then --time_start 代表充能中
		return
	end
	self.time_start = nil --为了重新开始计时
	self:Charge(dt/self.charge_period*self.charge_value, nil) --换算成能量值
end

return BatteryLegion
