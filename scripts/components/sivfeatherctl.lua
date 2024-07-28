local LineMap = {
    silk = 2,
    beardhair = 4,
    steelwool = 20,
    cattenball = 15
}
local throwednum = CONFIGS_LEGION.SIVFEATHROWEDNUM or 5

local SivFeatherCtl = Class(function(self, inst)
    self.inst = inst
	-- self.owner = nil --发射者
	-- self.pos = nil --发射时的初始坐标，拉回时则是代表拉动者的位置
    -- self.hittargets = {} --已击中的对象
    -- self.trytargets = {} --已尝试的对象
    -- self.tempfeas = nil --暂时的羽毛：飞行体和滞留体
    -- self.realfeas = nil --真正的羽毛实体
    -- self.hasline = nil --是否有丝线
    self.num = 0 --当前羽毛发射数量
    -- self.name_base = nil --羽毛本体代码名
    -- self.name_fly = nil --羽毛飞行体代码名
    -- self.name_blk = nil --羽毛滞留体代码名
    -- self.damage = nil --原本的羽毛攻击力

	self.shootrange = 20 --最远飞行距离
	-- self.isgoback = nil --是否为返回玩家
	self.bulletradius = 1.2 --子弹半径(影响击中的最小距离)
	self.speed = 20 --抛射速度
    self.exclude_tags = { "INLIMBO", "NOCLICK", "notarget", "noattack", "invisible", "playerghost" }
    -- self.fn_validhit = nil
    -- self.fn_hit = nil
end)

function SivFeatherCtl:Throw(feas, caster, pos, num, hasline, hidetime)
	local doerpos = caster:GetPosition()
    doerpos.y = 0 --必须为0，防止玩家是腾云状态而向量出错，导致无法收回之类的问题
    local angles = {}
    local poss = {}
    local direction = (pos - doerpos):GetNormalized() --单位向量
    local angle = math.acos(direction:Dot(Vector3(1, 0, 0))) / DEGREES --这个角度是动画的，不能用来做物理的角度

	if num == 1 then
        angles = { 0 }
        poss[1] = pos
    else
        local ang_lag = 2.5
        if num == 2 then
            angles = { -ang_lag, ang_lag }
        elseif num == 3 then
            angles = { -2*ang_lag, 0, 2*ang_lag }
        elseif num == 4 then
            angles = { -3*ang_lag, -ang_lag, ang_lag, 3*ang_lag }
        elseif num == 5 then
            angles = { -4*ang_lag, -2*ang_lag, 0, 2*ang_lag, 4*ang_lag }
        elseif num == 6 then
            angles = { -5*ang_lag, -3*ang_lag, -ang_lag, ang_lag, 3*ang_lag, 5*ang_lag }
        elseif num == 7 then
            angles = { -6*ang_lag, -4*ang_lag, -2*ang_lag, 0, 2*ang_lag, 4*ang_lag, 6*ang_lag }
        elseif num == 8 then
            angles = { -7*ang_lag, -5*ang_lag, -3*ang_lag, -ang_lag, ang_lag, 3*ang_lag, 5*ang_lag, 7*ang_lag }
        elseif num == 9 then
            angles = { -8*ang_lag, -6*ang_lag, -4*ang_lag, -2*ang_lag, 0, 2*ang_lag, 4*ang_lag, 6*ang_lag, 8*ang_lag }
        else
            angles = { -9*ang_lag, -7*ang_lag, -5*ang_lag, -3*ang_lag, -ang_lag, ang_lag, 3*ang_lag, 5*ang_lag, 7*ang_lag, 9*ang_lag }
        end

        local ang = caster:GetAngleToPoint(pos.x, pos.y, pos.z) --原始角度，单位:度，比如33
        for i,v in ipairs(angles) do
            v = v + math.random()*2 - 1
            angles[i] = v
            local an = (ang+v)*DEGREES
            poss[i] = Vector3(doerpos.x+math.cos(an), 0, doerpos.z-math.sin(an))
        end
    end

	local feathers = {}
	for i,v in ipairs(angles) do
		local fly = SpawnPrefab(self.name_fly)
		fly.feaidx = i
		fly.Transform:SetPosition(doerpos:Get())
        -- fly.Physics:ClearCollidesWith(COLLISION.LIMITS)
		fly.Transform:SetRotation(angle+v) --动画旋转
		fly:FacePoint(poss[i]) --实体朝向
        fly.Physics:SetMotorVel(self.speed, 0, 0) --朝向已确定，给一个正加速即可
        if fly.fn_onthrown ~= nil then
            fly.fn_onthrown(fly, caster, poss[i])
        end
        fly:Hide() --先隐藏飞行体，兼容动画，不然投射物会出现在角色坐标位置，可能会比较奇怪
		feathers[i] = fly
	end

    self.hittargets = {}
    self.trytargets = {}
	self.owner = caster
	self.pos = doerpos
    self.tempfeas = feathers
    self.hasline = hasline
    self.num = num

    if feas ~= nil then --妥善处理一下真实的羽毛
        if num > 1 and feas.components.weapon ~= nil then --伤害是按照发射总数量算的，就不用一个羽毛一个对象各自进行攻击逻辑了
            self.damage = feas.components.weapon.damage
            feas.components.weapon.damage = self.damage*num
        end
        self.inst:AddChild(feas)
        feas:RemoveFromScene()
        feas.Transform:SetPosition(0, 0, 0) --一旦有父实体了，再设置坐标就是相对于父实体的坐标了，应该是这样吧
        self.realfeas = feas
    end

    if self.hidetask ~= nil then
        self.hidetask:Cancel()
    end
    self.hidetask = self.inst:DoTaskInTime(hidetime, function() --显示出飞行体
        self.hidetask = nil
        if self.tempfeas ~= nil then
            for _, fe in pairs(self.tempfeas) do
                if fe:IsValid() and fe.isflyobj then
                    fe:Show()
                end
            end
        end
    end)

    --当前帧不会进行战斗检测，但等开始检测时可能羽毛已飞远，所以这里提前尝试攻击
    --虽然可以用 self:OnUpdate()，但是此时所有飞行体都在一个位置的，没必要都判定一遍
    self:TryFeatherAttack(self.tempfeas[num], doerpos)
    self.inst:StartUpdatingComponent(self)
end

function SivFeatherCtl:ThrowBack()
    
end

function SivFeatherCtl:TryFeatherAttack(flyobj, posnow)
    local weapon
    if self.realfeas ~= nil and self.realfeas.components.weapon ~= nil then
        weapon = self.realfeas
    elseif flyobj.components.weapon ~= nil then
        weapon = flyobj
    end
    local ents = TheSim:FindEntities(posnow.x, posnow.y, posnow.z, 7, { "_combat" }, self.exclude_tags)
	for _, ent in ipairs(ents) do
        if not self.trytargets[ent] then
            self.trytargets[ent] = true
            if
                ent ~= self.owner and not self.hittargets[ent] and ent.entity:IsVisible() and --有效
                ent.components.combat ~= nil and --有 _combat 标签不一定会有战斗组件，因为别的mod的生物可能不遵循这个规则
                (self.bulletradius+ent:GetPhysicsRadius(0))^2 >= distsq(posnow, ent:GetPosition()) and --范围内
                ent.components.combat:CanBeAttacked(self.owner) and --防止 owner 打到不该打到的对象
                (self.fn_validhit == nil or self.fn_validhit(self, ent))
            then
                self.hittargets[ent] = true
                if self.owner.components.combat ~= nil then
                    if self.owner.components.combat.ignorehitrange then
                        self.owner.components.combat:DoAttack(ent, weapon, flyobj)
                    else
                        self.owner.components.combat.ignorehitrange = true
                        self.owner.components.combat:DoAttack(ent, weapon, flyobj)
                        self.owner.components.combat.ignorehitrange = false
                    end
                end
                if self.fn_hit ~= nil then
                    self.fn_hit(self, ent, flyobj, weapon)
                end
                if not flyobj:IsValid() then
                    self.num = self.num - 1
                    return
                end
            end
        end
	end
end

local function IsOwnerValid(one)
    return one:IsValid() and
        one.components.health ~= nil and not one.components.health:IsDead()
end
local function RestoreWeaponAtk(self, fea)
    if self.damage ~= nil and fea.components.weapon ~= nil then
        fea.components.weapon.damage = self.damage
    end
end
function SivFeatherCtl:StopFlying(fe)
    if self.hasline and IsOwnerValid(self.owner) then --有线，那就先以滞留体形式存在
        local blk = SpawnPrefab(self.name_blk)
        blk.feaidx = fe.feaidx
        self.tempfeas[fe.feaidx] = blk
        blk.Transform:SetRotation(fe.Transform:GetRotation())
        blk.Transform:SetPosition(fe.Transform:GetWorldPosition())
        blk:PushEvent("on_landed")
    elseif self.num > 0 then --没有线，立即变回正常的羽毛
        local fea
        if self.realfeas == nil then --没有真实羽毛，生成一个别的
            if self.name_base ~= nil then
                fea = SpawnPrefab(self.name_base)
            end
            self.num = self.num - 1
        else
            if not self.realfeas:IsValid() then --羽毛因未知原因被删了，那就重新生成
                self.realfeas = SpawnPrefab(self.realfeas.prefab, self.realfeas.skinname, self.realfeas.skin_id)
                if self.num > 1 then --新的实体需要重新隐藏起来
                    self.inst:AddChild(self.realfeas)
                    self.realfeas:RemoveFromScene()
                    self.realfeas.Transform:SetPosition(0, 0, 0)
                end
            end
            if self.realfeas.components.stackable == nil then
                fea = self.realfeas
                self.inst:RemoveChild(fea)
                fea:ReturnToScene()
                self.num = 0
            else
                if self.realfeas.components.stackable:StackSize() ~= self.num then --修正叠加数
                    self.realfeas.components.stackable:SetStackSize(self.num)
                end
                if self.num == 1 then
                    fea = self.realfeas
                    self.inst:RemoveChild(fea)
                    fea:ReturnToScene()
                else
                    fea = self.realfeas.components.stackable:Get(1) --优先生成被叠加的实体，self.realfeas本身先不动
                end
                self.num = self.num - 1
            end
            RestoreWeaponAtk(self, fea) --stackable:Get 可能也会被别的模组改成继承已有的攻击加成之类的，所以这里都得恢复攻击
        end
        if fea ~= nil then
            fea.Transform:SetRotation(fe.Transform:GetRotation())
            fea.Transform:SetPosition(fe.Transform:GetWorldPosition())
        end
    end
    fe:Remove()
end

function SivFeatherCtl:Finish()
    if self.num > 0 and self.realfeas ~= nil then --还有真实羽毛因未知原因没有处理，这里就直接还给owner
        if not self.realfeas:IsValid() then --羽毛因未知原因被删了，那就重新生成
            self.realfeas = SpawnPrefab(self.realfeas.prefab, self.realfeas.skinname, self.realfeas.skin_id)
        else
            self.inst:RemoveChild(self.realfeas)
            self.realfeas:ReturnToScene()
        end
        if self.realfeas.components.stackable ~= nil then
            if self.realfeas.components.stackable:StackSize() ~= self.num then --修正叠加数
                self.realfeas.components.stackable:SetStackSize(self.num)
            end
        end
        RestoreWeaponAtk(self, self.realfeas)
        if self.owner:IsValid() then
            self.realfeas.Transform:SetPosition(self.owner.Transform:GetWorldPosition())
        else
            self.realfeas.Transform:SetPosition(self.pos:Get())
        end
        if IsOwnerValid(self.owner) and self.owner.components.inventory ~= nil then
            local inv = self.owner.components.inventory
            if inv:GetEquippedItem(EQUIPSLOTS.HANDS) == nil then --手里没别的装备
                if not inv:Equip(self.realfeas) then
                    inv:GiveItem(self.realfeas)
                end
            else
                inv:GiveItem(self.realfeas)
            end
        end
    end
    if self.tempfeas ~= nil then --清理掉剩余的实体
        for _, fe in pairs(self.tempfeas) do
            if fe:IsValid() then
                fe:Remove()
            end
        end
    end
end

function SivFeatherCtl:DoFeatherUpdate(dt, fe)
    local posnow = fe:GetPosition()
    --检测目前所在地皮，如果进入虚空领地，就直接停止
    if
        not self.isgoback and --防止飞回来时被卡住
        not TheWorld.Map:IsAboveGroundAtPoint(posnow.x, 0, posnow.z) and
        not TheWorld.Map:IsOceanTileAtPoint(posnow.x, 0, posnow.z)
    then
        self:StopFlying(fe)
        return
    end
    self:TryFeatherAttack(fe, posnow)
    if not fe:IsValid() then
        return
    end
    if self.isgoback then
		if distsq(self.pos, posnow) <= (self.bulletradius*self.bulletradius + 0.8) then
            fe:Remove() --拉回成功
		end
	elseif distsq(self.pos, posnow) >= self.shootrange*self.shootrange then
		self:StopFlying(fe) --发射成功
	end
end
function SivFeatherCtl:OnUpdate(dt)
    if self.tempfeas == nil or self.num <= 0 then
        self:Finish()
        self.inst:Remove()
        return
    end
    local hasvalid
    for _, fe in pairs(self.tempfeas) do
        if fe:IsValid() then
            if fe.isflyobj then --只有飞行体才进行检测
                self:DoFeatherUpdate(dt, fe)
            end
            if not hasvalid then --检测一下是否还需要继续执行逻辑
                local ff = self.tempfeas[fe.feaidx]
                if ff and ff:IsValid() then
                    hasvalid = true
                end
            end
        end
    end
    if not hasvalid then
        self:Finish()
        self.inst:Remove()
        return
    end
end

return SivFeatherCtl
