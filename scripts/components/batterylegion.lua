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
local function DoCharge_task(inst, self)
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

local function SpawnFx(doer, target, inst)
	local owner
	if target and target:IsValid() then --某些对象可能在充能过程中被删除了，比如奔雷矛
		owner = target
		if target.components.inventoryitem ~= nil then
			local owner2 = target.components.inventoryitem:GetGrandOwner()
			if owner2 ~= nil then
				owner = owner2
			end
		end
	end
	if owner == nil then
		owner = doer or inst
	end
	local x, y, z = owner.Transform:GetWorldPosition()
	if inst.battery_fx_l ~= nil then
		local fx = SpawnPrefab(inst.battery_fx_l.name)
		if fx ~= nil then
			if inst.battery_fx_l.y ~= nil then
				y = y + inst.battery_fx_l.y
			end
			if inst.battery_fx_l.y_rand ~= nil then
				y = y + math.random()*inst.battery_fx_l.y_rand
			end
			fx.Transform:SetPosition(x, y, z)
		end
	else
		local fx = SpawnPrefab("eleccore_spark_fx")
		if fx ~= nil then
			fx.Transform:SetPosition(x, y+0.7 + math.random()*1.3, z)
		end
	end
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

	if cpt ~= nil then
		if target:HasTag("lightningrod") and target.components.battery ~= nil then
			if target.chargeleft ~= nil then
				cpt:DoDelta(target.chargeleft*10, doer)
				target.components.battery:OnUsed(self.inst)
				SpawnFx(doer, target, self.inst)
				return true
			else
				return false, "NOUSE"
			end
		end
		if cpt.currentfuel <= 0 then
			return false, "NOENERGY"
		end
	end

	if
		target.prefab == "fimbul_axe" or --芬布尔斧
		target.prefab == "spear_wathgrithr_lightning_charged" --充能奔雷矛
	then
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
		if target.components.genetrans:GetFastTimePercent() <= 0.99 then
			cost = 50
			if not TryCostEnergy(cpt, cost, doer) then
				return false, "NOENERGY"
			end
			target.components.genetrans:AddFastTime(TUNING.TOTAL_DAY_TIME*10)
		else
			return false, "NONEED"
		end
	elseif
		target.prefab == "firesuppressor" or --雪球发射器
		target.prefab == "winona_battery_low" or --薇诺娜的发电机
		target.prefab == "nightstick" --晨星锤
	then
		if target.components.fueled ~= nil and target.components.fueled:GetPercent() < 0.99 then
			if target.prefab ~= "nightstick" and not target.components.fueled.accepting then
				return false, "REFUSE"
			end
			if target.prefab == "firesuppressor" then
				cost = 20
			elseif target.prefab == "winona_battery_low" then
				cost = 10
			else
				cost = 15
			end
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
			-- if not target.components.fueled.accepting then
			-- 	return false, "REFUSE"
			-- end
			cost = 20
			if not TryCostEnergy(cpt, cost, doer) then
				return false, "NOENERGY"
			end
			local gem = SpawnPrefab("redgem")
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
	elseif target.prefab == "spear_wathgrithr_lightning" then --奔雷矛
		if target.components.upgradeable ~= nil then
			local upgradeable = target.components.upgradeable
			local can_upgrade, reason = upgradeable:CanUpgrade()
			if can_upgrade and upgradeable.onupgradefn ~= nil then
				cost = 200
				if not TryCostEnergy(cpt, cost, doer) then
					return false, "NOENERGY"
				end
				upgradeable.onupgradefn(target, doer, self.inst)
			end
		end
	elseif target:HasTag("lightninggoat") then --伏特羊
		if target:HasTag("charged") then
			return false, "NONEED"
		elseif target.components.health ~= nil and not target.components.health:IsDead() then
			cost = 5
			if not TryCostEnergy(cpt, cost, doer) then
				return false, "NOENERGY"
			end
			target:PushEvent("attacked", { attacker = doer or self.inst, damage = 0,
				damageresolved = 0, original_damage = 0, stimuli = "electric" })
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
		SpawnFx(doer, target, self.inst)
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
