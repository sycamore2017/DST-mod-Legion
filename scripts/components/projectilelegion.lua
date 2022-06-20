local ProjectileLegion = Class(function(self, inst)
    self.inst = inst
	self.shootrange = nil --最远抛射距离
	self.bulletradius = 2.5 --子弹半径(影响击中的最小距离)
	self.speed = 20 --抛射速度
	self.stimuli = nil

	self.onthrown = nil
	self.onprehit = nil
    self.onhit = nil
    self.onmiss = nil
end)

function ProjectileLegion:RotateToTarget(dest)
	local direction = (dest - self.inst:GetPosition()):GetNormalized()
    local angle = math.acos(direction:Dot(Vector3(1, 0, 0))) / DEGREES
    self.inst.Transform:SetRotation(angle)
    self.inst:FacePoint(dest)
end

function ProjectileLegion:Throw(owner, targetpos, attacker)
	self.owner = owner --由武器产生的投射物，或者本身就是个远程投射物
	self.attacker = attacker --真正发起攻击的对象
	self.start = owner:GetPosition()
	self.dest = targetpos

	if attacker ~= nil and self.launchoffset ~= nil then
		local x, y, z = self.inst.Transform:GetWorldPosition()
		local facing_angle = attacker.Transform:GetRotation() * DEGREES
		self.inst.Transform:SetPosition(x + self.launchoffset.x * math.cos(facing_angle), y + self.launchoffset.y, z - self.launchoffset.x * math.sin(facing_angle))
	end

	self.inst.Physics:ClearCollidesWith(COLLISION.LIMITS)
	self:RotateToTarget(self.dest)
	self.inst.Physics:SetMotorVel(self.speed, 0, 0)
	self.inst:StartUpdatingComponent(self)
	self.inst:PushEvent("onthrown", { thrower = attacker or owner, dest = targetpos })
	if self.onthrown ~= nil then
		self.onthrown(self.inst, owner, targetpos, attacker)
	end
end

function ProjectileLegion:Stop()
	self.inst.Physics:CollidesWith(COLLISION.LIMITS)
    self.inst:StopUpdatingComponent(self)
	self.attacker = nil
    self.owner = nil
	self.dest = nil
	self.start = nil
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
	if self.shootrange ~= nil and distsq(self.start, current) > self.shootrange*self.shootrange then
		self:Miss()
	else
		local validtargets = {}
		local target = nil
		local x, y, z = current:Get()
		local ents = TheSim:FindEntities(x, y, z, 3, nil, COMMON_FNS.GetPlayerExcludeTags(self.attacker))
		for _,ent in ipairs(ents) do
			if ent.entity:IsValid() and ent.entity:IsVisible() and ent.components.health and not ent.components.health:IsDead() then
				local hitrange = ent:GetPhysicsRadius(0) + self.hitdist
				local currentrange = distsq(current, ent:GetPosition())
				if hitrange > currentrange then table.insert(validtargets, {target = ent, hitrange = hitrange, currentrange = currentrange}) end
			end
		end
		for _,data in pairs(validtargets) do
			if target == nil or data.currentrange - data.hitrange < target.range then
				target = {ent = data.target, range = data.currentrange - data.hitrange}
			end
		end
		if target ~= nil then
			self:Hit(target.ent)
		end
	end
end

local function OnShow(inst, self)
    self.delaytask = nil
    inst:Show()
end

function AimedProjectile:DelayVisibility(duration)
    if self.delaytask ~= nil then
        self.delaytask:Cancel()
    end
    self.inst:Hide()
    self.delaytask = self.inst:DoTaskInTime(duration, OnShow, self)
end

return AimedProjectile
