local function oncanatk(self)
    if self.canatk then
        self.inst:AddTag("canshieldatk")
    else
        self.inst:RemoveTag("canshieldatk")
    end
end

local ShieldLegion = Class(function(self, inst)
    self.inst = inst
    self.canatk = true
    self.issuccess = false

    self.fxdata = {
        prefab = "shield_attack_l_fx",
        symbol = "lantern_overlay",
        offsetx = 10, offsety = 0
    }

    self.time = nil
    self.delta = 9 * FRAMES --FRAMES为0.033秒。并且盾击sg动画总时长为 13*FRAMES，最好小于这个值
    self.armormult_success = 1 --盾反成功时的损害系数
    self.armormult_ranged = 1 --抵挡远程攻击时的损害系数

    -- self.startfn = nil
    -- self.atkfn = nil
    -- self.atkstayingfn = nil
    -- self.atkfailfn = nil
    -- self.armortakedmgfn = nil
    -- self.resultfn = nil
end,
nil,
{
    canatk = oncanatk
})

function ShieldLegion:CanAttack(doer)
    return self.canatk and self.time == nil and not self.inst._brokenshield
end

function ShieldLegion:StartAttack(doer)
    self.issuccess = false
    self.time = GetTime()
    if self.startfn ~= nil then
        self.startfn(self.inst, doer)
    end
end

function ShieldLegion:SetFollowedFx(target, data)
    if data == nil then
        return
    end
    local fx = SpawnPrefab(data.prefab)
    fx.entity:SetParent(target.entity)
    fx.entity:AddFollower()
    fx.Follower:FollowSymbol(target.GUID, data.symbol, data.offsetx or 0, data.offsety or 0, 0)
    return fx
end
function ShieldLegion:Counterattack(doer, attacker, data, radius, dmgmult)
    if
        attacker == nil or not attacker:IsValid() or attacker.components.combat == nil or
        attacker.components.health == nil or attacker.components.health:IsDead() or
        doer:GetDistanceSqToPoint(attacker.Transform:GetWorldPosition()) > radius*radius
    then
        return false
    end

    local weapon = self.inst.components.weapon
    local stimuli = nil
    if doer.components.electricattacks ~= nil then
        stimuli = "electric"
    end

    doer:PushEvent("onattackother", { target = attacker, weapon = self.inst, projectile = nil, stimuli = stimuli })

    local mult =
        (
            stimuli == "electric" or
            (weapon ~= nil and weapon.stimuli == "electric")
        ) and not (
            attacker:HasTag("electricdamageimmune") or
            (attacker.components.inventory ~= nil and attacker.components.inventory:IsInsulated())
        ) and TUNING.ELECTRIC_DAMAGE_MULT + TUNING.ELECTRIC_WET_DAMAGE_MULT *
            (
                attacker.components.moisture ~= nil and attacker.components.moisture:GetMoisturePercent() or
                (attacker:GetIsWet() and 1 or 0)
            )
        or 1
    local dmg = (doer.components.combat:CalcDamage(attacker, self.inst, mult) + (data.damage or 0)) * (dmgmult or 1)
    attacker.components.combat:GetAttacked(doer, dmg, self.inst, stimuli)

    return true
end
function ShieldLegion:ArmorTakeDamage(doer, attacker, data)
    if self.armortakedmgfn ~= nil then
        self.armortakedmgfn(self.inst, doer, attacker, data)
    end
    if data.armordamage > 0 and self.inst.components.armor ~= nil then
        self.inst.components.armor:TakeDamage(data.armordamage)
    end
end
function ShieldLegion:GetAttacked(doer, attacker, damage, weapon, stimuli)
    local data = {
        damage = damage, --实际伤害
        armordamage = damage, --盾会承受的伤害
        weapon = weapon,
        stimuli = stimuli,
        israngedweapon = false
    }

    if self.issuccess then --一次sg的时间，盾反成功后完全无敌
        if self.atkstayingfn ~= nil then
            self.atkstayingfn(self.inst, doer, attacker, data)
        end
        self:SetFollowedFx(doer, self.fxdata) --盾保特效
        return self.inst
    end

    local restarget = nil

    if --远程武器分为两类，一类是有projectile组件、一类是weapon组件中有projectile属性
        weapon ~= nil and (
            weapon.components.projectile ~= nil or
            weapon:HasTag("rangedweapon") or
            (weapon.components.weapon ~= nil and weapon.components.weapon.projectile ~= nil)
        )
    then
        data.israngedweapon = true
        data.armordamage = data.armordamage*self.armormult_ranged
        restarget = self.inst
    end

    if self.time ~= nil then
        if GetTime()-self.time < self.delta then --达成盾反条件
            if doer.sg:HasStateTag("atk_shield") then --加入防打断标签，这样本次sg后续被攻击不会进入被攻击sg
                doer.sg:AddStateTag("nointerrupt")
            end
            if self.atkfn ~= nil then
                self.atkfn(self.inst, doer, attacker, data)
            end

            restarget = self.inst
            data.armordamage = data.armordamage*self.armormult_success
            self.issuccess = true
            self:SetFollowedFx(doer, self.fxdata) --盾保特效
        else
            if self.atkfailfn ~= nil then
                self.atkfailfn(self.inst, doer, attacker, data)
            end
            self:FinishAttack(doer)
        end
    end

    if restarget ~= nil then
        self:ArmorTakeDamage(doer, attacker, data)
    end

    return restarget
end

function ShieldLegion:FinishAttack(doer, issgend)
    if self.time ~= nil then
        self.time = nil
        if self.resultfn ~= nil then
            self.resultfn(self.inst, doer)
        end
    end
    self.issuccess = false

    -- if self.fx_protect ~= nil and self.fx_protect:IsValid() then
    --     self.fx_protect:Remove()
    --     self.fx_protect = nil
    -- end
end

return ShieldLegion