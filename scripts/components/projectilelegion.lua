local ProjectileLegion = Class(function(self, inst)
    self.inst = inst
	self.shootrange = nil --最远抛射距离
	self.isgoback = nil --是否为返回玩家
	self.bulletradius = 1.2 --子弹半径(影响击中的最小距离)
	self.speed = 20 --抛射速度
	self.stimuli = nil
	self.hittargets = {} --把已经被攻击过的对象记下来，防止重复攻击
	self.exclude_tags = { "INLIMBO", "wall" }
	if not TheNet:GetPVPEnabled() then
		table.insert(self.exclude_tags, "player")
	end

	self.onthrown = nil
	self.onprehit = nil
    self.onhit = nil
    self.onmiss = nil
end)

function ProjectileLegion:RotateToTarget(dest, angle)
	if angle == nil then
		local direction = (dest - self.inst:GetPosition()):GetNormalized()
    	angle = math.acos(direction:Dot(Vector3(1, 0, 0))) / DEGREES
	end
    self.inst.Transform:SetRotation(angle)
    self.inst:FacePoint(dest)
end

function ProjectileLegion:Throw(owner, targetpos, attacker, angle)
	self.owner = owner --由武器产生的投射物，或者本身就是个远程投射物
	self.attacker = attacker --真正发起攻击的对象
	self.start = owner:GetPosition()
	self.dest = targetpos

	if self.isgoback then --StartUpdatingComponent会在下一帧执行，但是很可能在这一帧就飞远了
		if distsq(self.dest, self.start) <= self.bulletradius*self.bulletradius then
			self:Miss()
			return
		end
	end

	if attacker ~= nil and self.launchoffset ~= nil then
		local x, y, z = self.inst.Transform:GetWorldPosition()
		local facing_angle = attacker.Transform:GetRotation() * DEGREES
		self.inst.Transform:SetPosition(x + self.launchoffset.x * math.cos(facing_angle), y + self.launchoffset.y, z - self.launchoffset.x * math.sin(facing_angle))
	end

	self.inst.Physics:ClearCollidesWith(COLLISION.LIMITS)
	self:RotateToTarget(self.dest, angle)
	self.inst.Physics:SetMotorVel(self.speed, 0, 0)
	self.inst:StartUpdatingComponent(self)
	self.inst:PushEvent("onthrown", { thrower = attacker, dest = targetpos })
	if self.onthrown ~= nil then
		self.onthrown(self.inst, owner, targetpos, attacker)
	end
end

function ProjectileLegion:Stop()
	self.inst.Physics:Stop()
	self.inst.Physics:CollidesWith(COLLISION.LIMITS)
    self.inst:StopUpdatingComponent(self)
	self.attacker = nil
    self.owner = nil
	self.dest = nil
	self.start = nil
	self.hittargets = {}
end

function ProjectileLegion:Miss()
    if self.onmiss ~= nil then
        self.onmiss(self.inst, self.dest, self.attacker)
    end
	self:Stop()
end

function ProjectileLegion:Hit(target)
	-- self.inst.Physics:Stop()

	if self.onprehit ~= nil then
        self.onprehit(self.inst, self.dest, self.attacker, target)
    end
    if self.attacker ~= nil and self.attacker.components.combat ~= nil then
		local weapon = self.inst.components.weapon ~= nil and self.inst or nil
		if self.attacker.components.combat.ignorehitrange then
	        self.attacker.components.combat:DoAttack(target, weapon, self.inst, self.stimuli)
		else
			self.attacker.components.combat.ignorehitrange = true
			self.attacker.components.combat:DoAttack(target, weapon, self.inst, self.stimuli)
			self.attacker.components.combat.ignorehitrange = false
		end
    end
    if self.onhit ~= nil then
        self.onhit(self.inst, self.dest, self.attacker, target)
    end

	-- self:Stop()
end

local function DozeOff(inst, self)
    self.dozeOffTask = nil
    self:Miss() --官方这里用的Stop，那怎么实现的回复地面动画呢
end
function ProjectileLegion:OnEntitySleep()
    if self.dozeOffTask == nil then
   	    self.dozeOffTask = self.inst:DoTaskInTime(2, DozeOff, self)
    end
end
function ProjectileLegion:OnEntityWake()
    if self.dozeOffTask ~= nil then
        self.dozeOffTask:Cancel()
        self.dozeOffTask = nil
    end
end

function ProjectileLegion:OnUpdate(dt)
	local current = self.inst:GetPosition()

	local x, y, z = current:Get()
	local ents = TheSim:FindEntities(x, y, z, 7, { "_combat" }, self.exclude_tags)
	for _,ent in ipairs(ents) do
		if
			ent ~= self.attacker and not self.hittargets[ent] and ent.entity:IsVisible() and --有效
			ent.components.health ~= nil and not ent.components.health:IsDead() and --还活着
			( --sg非无敌状态
				ent.sg == nil or
				not (ent.sg:HasStateTag("flight") or ent.sg:HasStateTag("invisible"))
			) and
			(self.bulletradius+ent:GetPhysicsRadius(0))^2 >= distsq(current, ent:GetPosition()) and --范围内
			(
				(ent.components.combat ~= nil and ent.components.combat.target == self.attacker) or
				(
					(ent.components.domesticatable == nil or not ent.components.domesticatable:IsDomesticated()) and
					(self.attacker.components.leader == nil or not self.attacker.components.leader:IsFollower(ent))
				)
			)
		then
			self:Hit(ent)
			self.hittargets[ent] = true
		end
	end

	if self.isgoback then
		if distsq(self.dest, current) <= self.bulletradius*self.bulletradius then
			self:Miss()
		end
	elseif self.shootrange ~= nil and distsq(self.start, current) >= self.shootrange*self.shootrange then
		self:Miss()
	end
end

local function OnShow(inst, self)
    self.delaytask = nil
    inst:Show()
end
function ProjectileLegion:DelayVisibility(duration)
    if self.delaytask ~= nil then
        self.delaytask:Cancel()
    end
    self.inst:Hide()
    self.delaytask = self.inst:DoTaskInTime(duration or FRAMES, OnShow, self)
end

return ProjectileLegion
