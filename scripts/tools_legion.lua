
--[ 各种常用标签 ]--
local function CombineTags(tags1, tags2)
    if tags2 ~= nil then
        for _, v in pairs(tags2) do
            table.insert(tags1, v)
        end
    end
    return tags1
end
local function TagsCombat1(othertags) --普通的攻击标签
    return CombineTags({
        "INLIMBO", "NOCLICK", "notarget", "noattack", "playerghost" --"invisible"
    }, othertags)
end
local function TagsCombat2(othertags) --建筑友好的攻击标签
    return CombineTags({
        "INLIMBO", "NOCLICK", "notarget", "noattack", "playerghost", --"invisible"
        "wall", "structure", "balloon"
    }, othertags)
end
local function TagsCombat3(othertags) --建筑与伙伴都友好的攻击标签
    return CombineTags({
        "INLIMBO", "NOCLICK", "notarget", "noattack", "playerghost", --"invisible"
        "wall", "structure", "balloon",
        "companion", "glommer", "friendlyfruitfly", "abigail", "shadowminion"
    }, othertags)
end
local function TagsSiving(othertags) --子圭系列的窃血标签
    return CombineTags({
        "INLIMBO", "NOCLICK", "notarget", "noattack", "playerghost", --"invisible"
        "wall", "structure", "balloon",
        "shadowminion", "ghost" --"shadow"
    }, othertags)
end
local function TagsWorkable1(othertags) --常见的可砍、挖、砸、凿标签(不包含“捕捉”)
    return CombineTags({
        "CHOP_workable", "DIG_workable", "HAMMER_workable", "MINE_workable" --"NET_workable"
    }, othertags)
end
local function TagsWorkable2(othertags) --常见的可砍、挖、砸、凿标签，以及战斗标签
    return CombineTags({
        "_combat",
        "CHOP_workable", "DIG_workable", "HAMMER_workable", "MINE_workable" --"NET_workable"
    }, othertags)
end

--[ 判断是否能攻击 ]--
local function IsMyFollower(inst, ent)
    if ent.components.follower ~= nil then
        local leader = ent.components.follower:GetLeader()
        if leader ~= nil then
            if leader == inst then
                return true
            end
            if leader.components.inventoryitem ~= nil then --leader 是个物品
                leader = leader.components.inventoryitem:GetGrandOwner()
                return leader == inst
            end
        end
    -- elseif inst.components.leader ~= nil then --follower 和 leader 组件是配对的，所以不需要再判断这个组件
    --     if inst.components.leader:IsFollower(ent) then
    --         return true
    --     end
    end
    return false
end
local function IsPlayerFollower(ent)
    if ent.components.follower ~= nil then
        local leader = ent.components.follower:GetLeader()
        if leader ~= nil then
            if leader:HasTag("player") then
                return true
            end
            if leader.components.inventoryitem ~= nil then --leader 是个物品
                leader = leader.components.inventoryitem:GetGrandOwner()
                return leader ~= nil and leader:HasTag("player")
            end
        end
    end
    return false
end
local function IsEnemyPre(inst, ent)
    if
        ent.components.health == nil or ent.components.health:IsDead() or
        ent.components.combat == nil or ent.components.combat.target == nil
    then
        return true
    end
    if ent.sg ~= nil and (ent.sg:HasStateTag("flight") or ent.sg:HasStateTag("invisible")) then
        return true
    end
end
local function IsEnemy_me(inst, ent) --是否为 inst 的当前敌人
    if IsEnemyPre(inst, ent) then
        return false
    end
    if inst == nil then
        return true
    end
    if ent.components.combat.target == inst then --仇视自己的对象，肯定是敌人
        return true
    end
    if IsMyFollower(inst, ent) then --ent 跟随着我，就不要攻击了，防止后面逻辑引起跟随者内战
        return false
    end
    if IsMyFollower(inst, ent.components.combat.target) then --ent 想攻击我的跟随者，打它！
        return true
    end
    return false
end
local function IsEnemy_player(inst, ent) --是否为 全体玩家 的当前敌人
    if IsEnemyPre(inst, ent) then
        return false
    end
    if ent.components.combat.target:HasTag("player") then --仇视玩家的对象，肯定是敌人
        return true
    end
    if IsPlayerFollower(ent) then --ent 跟随着玩家，就不要攻击了，防止后面逻辑引起跟随者内战
        return false
    end
    if IsPlayerFollower(ent.components.combat.target) then --ent 想攻击玩家的跟随者，打它！
        return true
    end
    return false
end
local function MaybeEnemyPre(inst, ent)
    if
        ent.components.health == nil or ent.components.health:IsDead() or
        ent.components.combat == nil
    then
        return true
    end
    if ent.sg ~= nil and (ent.sg:HasStateTag("flight") or ent.sg:HasStateTag("invisible")) then
        return true
    end
end
local function MaybeEnemy_me(inst, ent, playerside) --是否为 inst 的潜在或当前敌人
    if MaybeEnemyPre(inst, ent) then
        return false
    end
    if inst == nil then
        return true
    end
    if ent.components.combat.target == nil then
        if IsMyFollower(inst, ent) then --ent 跟随着我，就不攻击
            return false
        end
        --玩家立场时，不攻击驯化的对象(毕竟对于非玩家inst来说，驯化与否关系不大，只有玩家才关心这个)
        if playerside and ent.components.domesticatable ~= nil and ent.components.domesticatable:IsDomesticated() then
            return false
        end
    else
        if ent.components.combat.target == inst then --仇视自己的对象，肯定是敌人
            return true
        end
        if IsMyFollower(inst, ent) then --ent 跟随着我，就不攻击
            return false
        end
        if playerside and ent.components.domesticatable ~= nil and ent.components.domesticatable:IsDomesticated() then
            return IsMyFollower(inst, ent.components.combat.target) --ent 想攻击我的跟随者，打它！
        end
    end
    return true
end
local function MaybeEnemy_player(inst, ent, playerside) --是否为 全体玩家 的潜在或当前敌人
    if MaybeEnemyPre(inst, ent) then
        return false
    end
    if ent.components.combat.target == nil then
        if IsPlayerFollower(ent) then --ent 跟随着玩家，就不攻击
            return false
        end
        --不攻击驯化的对象
        if ent.components.domesticatable ~= nil and ent.components.domesticatable:IsDomesticated() then
            return false
        end
    else
        if ent.components.combat.target:HasTag("player") then --仇视玩家的对象，肯定是敌人
            return true
        end
        if IsPlayerFollower(ent) then --ent 跟随着玩家，就不攻击
            return false
        end
        if ent.components.domesticatable ~= nil and ent.components.domesticatable:IsDomesticated() then
            return IsPlayerFollower(ent.components.combat.target) --ent 想攻击玩家的跟随者，打它！
        end
    end
    return true
end

--[ 判定 attacker 对于 target 的攻击力 ]--
local SpDamageUtil = require("components/spdamageutil")
local function CalcDamage(attacker, target, weapon, projectile, stimuli, damage, spdamage, pushevent)
    -- if weapon == nil then --这里不关注武器来源
    --     weapon = attacker.components.combat:GetWeapon()
    -- end
    if stimuli == nil then
        if weapon ~= nil and weapon.components.weapon ~= nil and weapon.components.weapon.overridestimulifn ~= nil then
            stimuli = weapon.components.weapon.overridestimulifn(weapon, attacker, target)
        end
        if stimuli == nil and attacker.components.electricattacks ~= nil then
            stimuli = "electric"
        end
    end

    if pushevent then
        attacker:PushEvent("onattackother", { target = target, weapon = weapon, projectile = projectile, stimuli = stimuli })
    end

    local multiplier =
        (
            stimuli == "electric" or
            (weapon ~= nil and weapon.components.weapon ~= nil and weapon.components.weapon.stimuli == "electric")
        ) and not (
            target:HasTag("electricdamageimmune") or
            (target.components.inventory ~= nil and target.components.inventory:IsInsulated())
        ) and TUNING.ELECTRIC_DAMAGE_MULT + TUNING.ELECTRIC_WET_DAMAGE_MULT *
            (
                target.components.moisture ~= nil and target.components.moisture:GetMoisturePercent() or
                (target:GetIsWet() and 1 or 0)
            )
        or 1

    local dmg, spdmg
    if damage == nil and spdamage == nil then --使用公用机制(获取 attacker 或 weapon 自己的数值)
        dmg, spdmg = attacker.components.combat:CalcDamage(target, weapon, multiplier)
        return dmg, spdmg, stimuli
    end

    --使用这次专门的数值
    if target:HasTag("alwaysblock") then
        return 0
    end
    dmg = damage or 0
    if spdamage ~= nil then --由于 spdamage 是个表，我不想改动传参数据，所以这里新产生一个表
        spdmg = SpDamageUtil.MergeSpDamage({}, spdamage)
    end
    local self = attacker.components.combat
    local basemultiplier = self.damagemultiplier
    local externaldamagemultipliers = self.externaldamagemultipliers
    local damagetypemult = 1
    local bonus = self.damagebonus
    local playermultiplier = target ~= nil and target:HasTag("player")
    local pvpmultiplier = playermultiplier and attacker:HasTag("player") and self.pvp_damagemod or 1
    local mount = nil

    if weapon ~= nil then
        playermultiplier = 1
		if attacker.components.damagetypebonus ~= nil then
			damagetypemult = attacker.components.damagetypebonus:GetBonus(target)
		end
        spdmg = SpDamageUtil.CollectSpDamage(attacker, spdmg)
    else
        playermultiplier = playermultiplier and self.playerdamagepercent or 1
        if attacker.components.rider ~= nil and attacker.components.rider:IsRiding() then
            mount = attacker.components.rider:GetMount()
            if mount ~= nil and mount.components.combat ~= nil then
                basemultiplier = mount.components.combat.damagemultiplier
                externaldamagemultipliers = mount.components.combat.externaldamagemultipliers
                bonus = mount.components.combat.damagebonus
				if mount.components.damagetypebonus ~= nil then
					damagetypemult = mount.components.damagetypebonus:GetBonus(target)
				end
				spdmg = SpDamageUtil.CollectSpDamage(mount, spdmg)
			else
				if attacker.components.damagetypebonus ~= nil then
					damagetypemult = attacker.components.damagetypebonus:GetBonus(target)
				end
				spdmg = SpDamageUtil.CollectSpDamage(attacker, spdmg)
            end

            local saddle = attacker.components.rider:GetSaddle()
            if saddle ~= nil and saddle.components.saddler ~= nil then
                dmg = dmg + saddle.components.saddler:GetBonusDamage()
				if saddle.components.damagetypebonus ~= nil then
					damagetypemult = damagetypemult * saddle.components.damagetypebonus:GetBonus(target)
				end
				spdmg = SpDamageUtil.CollectSpDamage(saddle, spdmg)
            end
		else
			if attacker.components.damagetypebonus ~= nil then
				damagetypemult = attacker.components.damagetypebonus:GetBonus(target)
			end
			spdmg = SpDamageUtil.CollectSpDamage(attacker, spdmg)
        end
    end

	dmg = dmg
        * (basemultiplier or 1)
        * externaldamagemultipliers:Get()
		* damagetypemult
        * (multiplier or 1)
        * playermultiplier
        * pvpmultiplier
		* (self.customdamagemultfn ~= nil and self.customdamagemultfn(attacker, target, weapon, multiplier, mount) or 1)
        + (bonus or 0)

    if spdmg ~= nil then
        multiplier = damagetypemult * pvpmultiplier
        if multiplier ~= 1 then
            spdmg = SpDamageUtil.ApplyMult(spdmg, multiplier)
        end
    end
    return dmg, spdmg, stimuli
end

--[ 催眠 ]--
local function DoSingleSleep(v, data)
    if
        (data.fn_valid == nil or data.fn_valid(v, data)) and
        not (v.components.freezable ~= nil and v.components.freezable:IsFrozen()) and
        not (v.components.pinnable ~= nil and v.components.pinnable:IsStuck()) and
        not (v.components.fossilizable ~= nil and v.components.fossilizable:IsFossilized())
    then
        local mount = v.components.rider ~= nil and v.components.rider:GetMount() or nil
        if mount ~= nil then
            mount:PushEvent("ridersleep", { sleepiness = data.lvl, sleeptime = data.time })
        end
        if data.fn_do ~= nil then
            data.fn_do(v, data)
        end
        if not data.noyawn and v:HasTag("player") then
            v:PushEvent("yawn", { grogginess = data.lvl, knockoutduration = data.time })
        elseif v.components.sleeper ~= nil then
            v.components.sleeper:AddSleepiness(data.lvl, data.time)
        elseif v.components.grogginess ~= nil then
            v.components.grogginess:AddGrogginess(data.lvl, data.time)
        else
            v:PushEvent("knockedout")
        end
        return true
    end
    return false
end
local function DoAreaSleep(data)
    if data.x == nil and data.doer ~= nil then
        data.x, data.y, data.z = data.doer.Transform:GetWorldPosition()
    end
    if data.tagscant == nil then
        data.tagscant = TagsCombat1() --"FX", "DECOR" 不是很懂为什么官方要加这两个
    end
    if data.tagsone == nil then
        data.tagsone = { "sleeper", "player" }
    end

    local countsleeper = 0
    local ents = TheSim:FindEntities(data.x, data.y, data.z, data.range, nil, data.tagscant, data.tagsone)
    for _, v in ipairs(ents) do
        if DoSingleSleep(v, data) then
            countsleeper = countsleeper + 1
        end
    end

    if countsleeper > 0 then
        return true
    else
        return false, "NOSLEEPTARGETS"
    end
end

--[ 积雪监听(仅prefab定义时使用) ]--
local function OnSnowCoveredChagned(inst, covered)
    if TheWorld.state.issnowcovered then
        inst.AnimState:OverrideSymbol("snow", "snow_legion", "snow")
    else
        inst.AnimState:OverrideSymbol("snow", "snow_legion", "emptysnow")
    end
end
local function MakeSnowCovered_comm(inst)
    inst.AnimState:OverrideSymbol("snow", "snow_legion", "emptysnow")
    --动画制作中，需要添加“snow”的通道
end
local function MakeSnowCovered_serv(inst, delaytime, delayfn)
    inst:WatchWorldState("issnowcovered", OnSnowCoveredChagned)
    inst:DoTaskInTime(delaytime, function(inst)
		OnSnowCoveredChagned(inst)
        if delayfn ~= nil then delayfn(inst) end
	end)
end

--[ 光照监听 ]--
local function IsTooDarkToGrow(inst)
	if TheWorld.state.isnight then
		local x, y, z = inst.Transform:GetWorldPosition()
		for i, v in ipairs(TheSim:FindEntities(x, 0, z, TUNING.DAYLIGHT_SEARCH_RANGE, { "daylight", "lightsource" })) do
			local lightrad = v.Light:GetCalculatedRadius() * .7
			if v:GetDistanceSqToPoint(x, y, z) < lightrad * lightrad then
				return false
			end
		end
		return true
	end
	return false
end

--[ 植株寻求保护 ]--
local function CallPlantDefender(inst, target, noone)
	if target ~= nil and (noone or not target:HasTag("plantkin")) then
        inst:RemoveTag("farm_plant_defender") --其实是杂草才需要去除这个标签
        local x, y, z = inst.Transform:GetWorldPosition()
        local defenders = TheSim:FindEntities(x, y, z, TUNING.FARM_PLANT_DEFENDER_SEARCH_DIST, { "farm_plant_defender" })
        for _, defender in ipairs(defenders) do
            if defender.components.burnable == nil or not defender.components.burnable.burning then
                defender:PushEvent("defend_farm_plant", {source = inst, target = target})
                break
            end
        end
    end
end

--[ 计算最终位置 ]--
local function GetCalculatedPos(x, y, z, radius, theta)
    local rad = radius or math.random() * 3
    local the = theta or math.random() * 2 * PI
    return x + rad * math.cos(the), y, z - rad * math.sin(the)
end

--[ 垂直掉落一个物品 ]--
local easing = require("easing")
local function FallingItem(itemname, x, y, z, hitrange, hitdamage, fallingtime, fn_start, fn_doing, fn_end)
	local item = SpawnPrefab(itemname)
	if item ~= nil then
        if fallingtime == nil then fallingtime = 5 * FRAMES end

		item.Transform:SetPosition(x, y, z) --这里的y就得是下落前起始高度
		item.fallingpos = item:GetPosition()
		item.fallingpos.y = 0
		if item.components.inventoryitem ~= nil then
			item.components.inventoryitem.canbepickedup = false
		end

        if fn_start ~= nil then fn_start(item) end

		item.fallingtask = item:DoPeriodicTask(
            FRAMES,
            function(inst, startpos, starttime)
                local t = math.max(0, GetTime() - starttime)
                local pos = startpos + (inst.fallingpos - startpos) * easing.inOutQuad(t, 0, 1, fallingtime)
                if t < fallingtime and pos.y > 0 then
                    inst.Transform:SetPosition(pos:Get())
                    if fn_doing ~= nil then fn_doing(inst) end
                else
                    inst.Physics:Teleport(inst.fallingpos:Get())
                    inst.fallingtask:Cancel()
                    inst.fallingtask = nil
                    inst.fallingpos = nil
                    if inst.components.inventoryitem ~= nil then
                        inst.components.inventoryitem.canbepickedup = true
                    end
                    if hitrange ~= nil then
                        local someone = FindEntity(inst, hitrange, function(target)
                            if
                                target.components.health ~= nil and not target.components.health:IsDead() and
                                target.components.combat ~= nil and target.components.combat:CanBeAttacked()
                            then
                                return true
                            end
                            return false
                        end, { "_combat", "_health" }, TagsCombat1(), nil)
                        if someone ~= nil then
                            someone.components.combat:GetAttacked(inst, hitdamage)
                        end
                    end
                    if fn_end ~= nil then fn_end(inst) end
                end
            end,
            0, item:GetPosition(), GetTime()
        )
    end
end

--[ sg：sg中卸下装备的重物 ]--
local function ForceStopHeavyLifting(inst)
    if inst.components.inventory:IsHeavyLifting() then
        inst.components.inventory:DropItem(
            inst.components.inventory:Unequip(EQUIPSLOTS.BODY),
            true,
            true
        )
    end
end

--[ 无视防御的攻击 ]--
local function RecalculateModifier_combat_l(inst)
    local m = inst._base
    for source, src_params in pairs(inst._modifiers) do
        for k, v in pairs(src_params.modifiers) do
            if v > 1 then --大于1 是代表增伤。这里需要忽略的是减伤
                m = inst._fn(m, v)
            end
        end
    end
    inst._modifier_l = m
end
local function UndefendedATK(inst, data)
    if data == nil or data.target == nil then
        return
    end
    local target = data.target

    if
        target.ban_l_undefended or --其他mod兼容：这个变量能防止被破防攻击
        target.prefab == "laozi" --无法伤害神话书说里的太上老君
    then
        return
    end

    local health = target.components.health

    if target.flag_undefended_l == nil then
        --修改物品栏护甲机制
        if target.components.inventory ~= nil and not target:HasTag("player") then --不改玩家的
            local ApplyDamage_old = target.components.inventory.ApplyDamage
            target.components.inventory.ApplyDamage = function(self, damage, attacker, weapon, spdamage, ...)
                if self.inst.flag_undefended_l == 1 then --虽然其中可能会有增伤机制，但太复杂了，不好改，直接原样返回吧
                    return damage, spdamage
                end
                return ApplyDamage_old(self, damage, attacker, weapon, spdamage, ...)
            end
        end

        --修改战斗机制
        if target.components.combat ~= nil then
            local combat = target.components.combat
            local mult = combat.externaldamagetakenmultipliers
            local mult_Get = mult.Get
            local mult_SetModifier = mult.SetModifier
            local mult_RemoveModifier = mult.RemoveModifier
            mult.Get = function(self, ...)
                if self.inst.flag_undefended_l == 1 then
                    return self._modifier_l or 1
                end
                return mult_Get(self, ...)
            end
            mult.SetModifier = function(self, ...)
                mult_SetModifier(self, ...)
                RecalculateModifier_combat_l(self)
            end
            mult.RemoveModifier = function(self, ...)
                mult_RemoveModifier(self, ...)
                RecalculateModifier_combat_l(self)
            end
            RecalculateModifier_combat_l(mult) --主动更新一次

            local GetAttacked_old = combat.GetAttacked
            combat.GetAttacked = function(self, ...)
                if self.inst.flag_undefended_l == 1 then
                    local notblocked = GetAttacked_old(self, ...)
                    self.inst.flag_undefended_l = 0
                    if --攻击完毕，恢复其防御力
                        self.inst.health_l_undefended ~= nil and
                        self.inst.components.health ~= nil --不要判断死亡(玩家)
                    then
                        local healthcpt = self.inst.components.health
                        local param = self.inst.health_l_undefended
                        if param.absorb ~= nil and healthcpt.absorb == 0 then --说明被打后没变化，所以可以直接恢复
                            healthcpt.absorb = param.absorb
                        end
                        if param.playerabsorb ~= nil and healthcpt.playerabsorb == 0 then
                            healthcpt.playerabsorb = param.playerabsorb
                        end
                    end
                    self.inst.health_l_undefended = nil
                    return notblocked
                else
                    return GetAttacked_old(self, ...)
                end
            end
        end

        --修改生命机制
        if health ~= nil then
            local mult2 = health.externalabsorbmodifiers
            local mult2_Get = mult2.Get
            mult2.Get = function(self, ...)
                if self.inst.flag_undefended_l == 1 then
                    return 0
                end
                return mult2_Get(self, ...)
            end

            if not target:HasTag("player") then --玩家无敌时，是不改的
                local IsInvincible_old = health.IsInvincible
                health.IsInvincible = function(self, ...)
                    if self.inst.flag_undefended_l == 1 then
                        return false
                    end
                    return IsInvincible_old(self, ...)
                end
            end
        end

        --修改位面实体机制
        if target.components.planarentity ~= nil then
            local AbsorbDamage_old = target.components.planarentity.AbsorbDamage
            target.components.planarentity.AbsorbDamage = function(self, damage, attacker, weapon, spdmg, ...)
                if self.inst.flag_undefended_l == 1 then
                    local damage2, spdamage2 = AbsorbDamage_old(self, damage, attacker, weapon, spdmg, ...)
                    if damage2 < damage then --如果最终值小于之前的值，说明有减免，那就不准减免
                        return damage, spdamage2
                    else --兼容别的mod的逻辑
                        return damage2, spdamage2
                    end
                end
                return AbsorbDamage_old(self, damage, attacker, weapon, spdmg, ...)
            end
        end

        --修改防御的标签系数机制
        if target.components.damagetyperesist ~= nil then
            local GetResist_old = target.components.damagetyperesist.GetResist
            target.components.damagetyperesist.GetResist = function(self, attacker, weapon, ...)
                if self.inst.flag_undefended_l == 1 then
                    local mult = 1
                    local tagmult
                    if attacker ~= nil then
                        for k, v in pairs(self.tags) do
                            if attacker:HasTag(k) or (weapon ~= nil and weapon:HasTag(k)) then
                                tagmult = v:Get()
                                if tagmult > 1 then --大于1 是代表增伤。这里需要忽略的是减伤
                                    mult = mult * tagmult
                                end
                            end
                        end
                    end
                    return mult
                end
                return GetResist_old(self, attacker, weapon, ...)
            end
        end
    end

    target.flag_undefended_l = 1
    if health ~= nil then
        local param = {}
        if health.absorb ~= 0 then
            param.absorb = health.absorb
            health.absorb = 0
        end
        if health.playerabsorb ~= 0 then
            param.playerabsorb = health.playerabsorb
            health.playerabsorb = 0
        end
        target.health_l_undefended = param
    end
end

--[ 兼容性标签管理 ]--
local function AddTag(inst, tagname, key)
    if inst.tags_l == nil then
        inst.tags_l = {}
    end
    if inst.tags_l[tagname] == nil then
        inst.tags_l[tagname] = {}
    end
    inst.tags_l[tagname][key] = true
    inst:AddTag(tagname)
end
local function RemoveTag(inst, tagname, key)
    if inst.tags_l ~= nil then
        if inst.tags_l[tagname] ~= nil then
            inst.tags_l[tagname][key] = nil
            for k, v in pairs(inst.tags_l[tagname]) do
                if v == true then --如果还有 key 为true，那就不能删除这个标签
                    return
                end
            end
            inst.tags_l[tagname] = nil --没有 key 是true了，直接做空
        end
    end
    inst:RemoveTag(tagname)
end

--[ 兼容性数值管理 ]--
local function AddEntValue(ent, key, key2, valuedeal, value)
    if ent[key] == nil then
        ent[key] = {}
    end
    ent[key][key2] = value
    if valuedeal ~= nil then
        local res = 0
        if valuedeal == 1 then --加法
            for _, v in pairs(ent[key]) do
                res = res + v
            end
        else --乘法
            for _, v in pairs(ent[key]) do
                res = res * v
            end
        end
        ent[key.."_v"] = res ~= 0 and res or nil
    end
end
local function RemoveEntValue(ent, key, key2, valuedeal)
    if ent[key] == nil then
        ent[key.."_v"] = nil
        return
    end
    ent[key][key2] = nil
    if valuedeal == nil then
        for _, v in pairs(ent[key]) do
            if v then
                return
            end
        end
        ent[key] = nil
    else
        local res = 0
        local hasit = false
        if valuedeal == 1 then --加法
            for _, v in pairs(ent[key]) do
                res = res + v
                hasit = true
            end
        else --乘法
            for _, v in pairs(ent[key]) do
                res = res * v
                hasit = true
            end
        end
        if hasit then
            ent[key.."_v"] = res ~= 0 and res or nil
        else
            ent[key.."_v"] = nil
            ent[key] = nil
        end
    end
end

--[ 生成堆叠的物品 ]--
local function SpawnStackDrop(name, num, pos, doer, items, overname)
    local item = SpawnPrefab(name)
	if item == nil then
		item = SpawnPrefab(overname or "siving_rocks")
	end
	if item ~= nil then
		if num > 1 and item.components.stackable ~= nil then
			local maxsize = item.components.stackable.maxsize
			if num <= maxsize then
				item.components.stackable:SetStackSize(num)
				num = 0
			else
				item.components.stackable:SetStackSize(maxsize)
				num = num - maxsize
			end
		else
			num = num - 1
        end

		if items ~= nil then
			table.insert(items, item)
		end
        item.Transform:SetPosition(pos:Get())
        if item.components.inventoryitem ~= nil then
			if doer ~= nil and doer.components.inventory ~= nil then
				doer.components.inventory:GiveItem(item, nil, pos)
			else
				if item:HasTag("heavy") then --巨大作物不知道为啥不能弹射，可能是和别的物体碰撞了，就失效了
					local x, y, z = GetCalculatedPos(pos.x, pos.y, pos.z, 0.5+1.8*math.random())
					item.Transform:SetPosition(x, y, z)
				else
					item.components.inventoryitem:OnDropped(true)
				end
			end
        end

		if num >= 1 then
			SpawnStackDrop(name, num, pos, doer, items, overname)
		end
	end
end

--[ 帽子装备通用函数 ]--

local function hat_on(inst, owner, buildname, foldername) --遮住头顶部的帽子样式
    if buildname == nil then
        owner.AnimState:ClearOverrideSymbol("swap_hat")
    else
        owner.AnimState:OverrideSymbol("swap_hat", buildname, foldername)
    end
    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAIR_HAT")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAT")
        owner.AnimState:Show("HEAD_HAT_NOHELM")
        owner.AnimState:Hide("HEAD_HAT_HELM")
    end
end
local function hat_on_opentop(inst, owner, buildname, foldername) --完全开放式的帽子样式
    if buildname == nil then
        owner.AnimState:ClearOverrideSymbol("swap_hat")
    else
        owner.AnimState:OverrideSymbol("swap_hat", buildname, foldername)
    end
    owner.AnimState:Show("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    owner.AnimState:Show("HEAD")
    owner.AnimState:Hide("HEAD_HAT")
    owner.AnimState:Hide("HEAD_HAT_NOHELM")
    owner.AnimState:Hide("HEAD_HAT_HELM")
end
local function hat_off(inst, owner)
    owner.AnimState:ClearOverrideSymbol("headbase_hat") --it might have been overriden by _onequip
    if owner.components.skinner ~= nil then
        owner.components.skinner.base_change_cb = owner.old_base_change_cb
    end

    owner.AnimState:ClearOverrideSymbol("swap_hat")
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAT")
        owner.AnimState:Hide("HEAD_HAT_NOHELM")
        owner.AnimState:Hide("HEAD_HAT_HELM")
    end
end
local function hat_on_fullhead(inst, owner, buildname, foldername) --遮住整个头部的帽子样式
    if owner:HasTag("player") then
        owner.AnimState:OverrideSymbol("headbase_hat", buildname, foldername)

        owner.AnimState:Hide("HAT")
        owner.AnimState:Hide("HAIR_HAT")
        owner.AnimState:Hide("HAIR_NOHAT")
        owner.AnimState:Hide("HAIR")

        owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAT")
        owner.AnimState:Hide("HEAD_HAT_NOHELM")
        owner.AnimState:Show("HEAD_HAT_HELM")

        owner.AnimState:HideSymbol("face")
        owner.AnimState:HideSymbol("swap_face")
        owner.AnimState:HideSymbol("beard")
        owner.AnimState:HideSymbol("cheeks")

        owner.AnimState:UseHeadHatExchange(true)
    else
        owner.AnimState:OverrideSymbol("swap_hat", buildname, foldername)

        owner.AnimState:Show("HAT")
        owner.AnimState:Hide("HAIR_HAT")
        owner.AnimState:Hide("HAIR_NOHAT")
        owner.AnimState:Hide("HAIR")
    end
end
local function hat_off_fullhead(inst, owner)
    hat_off(inst, owner)

    if owner:HasTag("player") then
        owner.AnimState:ShowSymbol("face")
        owner.AnimState:ShowSymbol("swap_face")
        owner.AnimState:ShowSymbol("beard")
        owner.AnimState:ShowSymbol("cheeks")

        owner.AnimState:UseHeadHatExchange(false)
    end
end

--[ 耐久为0不会消失的可修复装备 ]--
local function OnRepaired(inst, item, doer, now)
	if inst.components.equippable == nil then
        if inst.foreverequip_l.fn_setEquippable ~= nil then
            inst.foreverequip_l.fn_setEquippable(inst)
        end
        if inst.foreverequip_l.anim ~= nil then
            inst.AnimState:PlayAnimation(inst.foreverequip_l.anim, inst.foreverequip_l.isloop)
        end
		-- inst.components.floater:SetSwapData(SWAP_DATA)
		inst:RemoveTag("broken")
		inst.components.inspectable.nameoverride = nil
	end
end
local function OnBroken(inst) --损坏后会把装备卸下并丢进玩家物品栏
    if inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then
        local owner = inst.components.inventoryitem.owner
        if owner ~= nil and owner.components.inventory ~= nil then
            local item = owner.components.inventory:Unequip(inst.components.equippable.equipslot)
            if item ~= nil then
                owner.components.inventory:GiveItem(item, nil, owner:GetPosition())
            end
        end
    end
    if inst.foreverequip_l.fn_broken ~= nil then
        inst.foreverequip_l.fn_broken(inst)
    else
        if inst.components.equippable ~= nil then
            inst:RemoveComponent("equippable")
            if inst.foreverequip_l.anim_broken ~= nil then
                inst.AnimState:PlayAnimation(inst.foreverequip_l.anim_broken, inst.foreverequip_l.isloop_broken)
            end
            -- inst.components.floater:SetSwapData(SWAP_DATA_BROKEN)
            inst:AddTag("broken") --这个标签会让名称显示加入“损坏”前缀
            inst.components.inspectable.nameoverride = "BROKEN_FORGEDITEM" --改为统一的损坏描述
        end
    end
end
local function MakeNoLossRepairableEquipment(inst, data)
    inst.foreverequip_l = data
    if inst.foreverequip_l.fn_repaired == nil then
        inst.foreverequip_l.fn_repaired = OnRepaired
    end
	if inst.components.armor ~= nil then
        if inst.components.armor.SetKeepOnFinished == nil then --有的mod替换了这个组件，导致没兼容官方的新函数
            inst.components.armor.keeponfinished = true
        else
            inst.components.armor:SetKeepOnFinished(true)
        end
		inst.components.armor:SetOnFinished(OnBroken)
	elseif inst.components.finiteuses ~= nil then
		inst.components.finiteuses:SetOnFinished(OnBroken)
	elseif inst.components.fueled ~= nil then
		inst.components.fueled:SetDepletedFn(OnBroken)
	end
end

--[ 能力勋章兼容：不朽容器 ]--
local function GetDisplayName_immortal(inst)
    local name = nil
    if inst.displaynamefn_old_medal ~= nil then
        name = inst.displaynamefn_old_medal(inst)
    end
    if name == nil then
        name = inst.nameoverride
			-- (inst.components.inspectable ~= nil and inst.components.inspectable.nameoverride) or nil
		if name ~= nil then
			name = STRINGS.NAMES[string.upper(name)]
		end
		if name == nil then
			name = STRINGS.NAMES[string.upper(inst.prefab)] or "MISSING NAME"
		end
    end
    return subfmt(STRINGS.NAMES["IMMORTAL_BACKPACK"], { backpack = name })
end
local function ImmortalChangeNameDirty(inst)
    if inst:HasTag("keepfresh") then
        if inst.immortalchangename:value() then
            inst.displaynamefn_old_medal = inst.displaynamefn
            inst.displaynamefn = GetDisplayName_immortal
        end
    end
end
local function GetPerishRateMult_immortal(inst, item)
    if item ~= nil then
        if not item:HasTag("fish") and item.components.health == nil then
            return 0
        end
    end
    if inst.perishrate_old_medal ~= nil then
        return type(inst.perishrate_old_medal) == "number" and inst.perishrate_old_medal
                or inst.perishrate_old_medal(inst, item)
                or 1
    end
    return 1
end
local function Fn_setImmortal(inst)
    inst:AddTag("keepfresh")
    if inst.fn_immortal_over ~= nil then
        inst.fn_immortal_over(inst)
    else
        if inst.components.preserver == nil then
            inst:AddComponent("preserver")
        else
            inst.perishrate_old_medal = inst.components.preserver.perish_rate_multiplier
        end
        inst.components.preserver:SetPerishRateMultiplier(GetPerishRateMult_immortal)
    end
    inst.immortalchangename:set(true)
end
local function OnSave_immortal(inst, data)
    local refs = nil
    if inst.OnSave_old_medal ~= nil then
        refs = inst.OnSave_old_medal(inst, data)
    end
    if inst:HasTag("keepfresh") then
        data.immortal = true
    end
    return refs
end
local function OnLoad_immortal(inst, data)
    if inst.OnLoad_old_medal ~= nil then
        inst.OnLoad_old_medal(inst, data)
    end
    if data ~= nil and data.immortal then
        if inst.setImmortal ~= nil then
            inst.setImmortal(inst)
        end
    end
end
local function SetImmortalBox_common(inst, sets) --客户端
    if not TUNING.FUNCTIONAL_MEDAL_IS_OPEN then
        return
    end
    inst:AddTag("canbeimmortal")
    inst.immortalchangename = net_bool(inst.GUID, "immortalchangename", "immortalchangenamedirty")
    inst:ListenForEvent("immortalchangenamedirty", ImmortalChangeNameDirty) --加上不朽前缀
end
local function SetImmortalBox_server(inst, sets) --服务器
    if not TUNING.FUNCTIONAL_MEDAL_IS_OPEN then
        return
    end
    if sets then
        if sets.no_consume_essences then
            inst.no_consume_essences = true
        end
        if sets.fn_immortal_over then
            inst.fn_immortal_over = sets.fn_immortal_over
        end
    end
    inst.setImmortal = Fn_setImmortal
    inst.OnSave_old_medal = inst.OnSave
    inst.OnLoad_old_medal = inst.OnLoad
    inst.OnSave = OnSave_immortal
    inst.OnLoad = OnLoad_immortal
end

-- local TOOLS_L = require("tools_legion")
return {
	MakeSnowCovered_comm = MakeSnowCovered_comm,
	MakeSnowCovered_serv = MakeSnowCovered_serv,
	IsTooDarkToGrow = IsTooDarkToGrow,
    CallPlantDefender = CallPlantDefender,
	GetCalculatedPos = GetCalculatedPos,
	FallingItem = FallingItem,
	ForceStopHeavyLifting = ForceStopHeavyLifting,
	UndefendedATK = UndefendedATK,
	AddTag = AddTag,
	RemoveTag = RemoveTag,
    AddEntValue = AddEntValue,
    RemoveEntValue = RemoveEntValue,
	SpawnStackDrop = SpawnStackDrop,
	hat_on = hat_on,
	hat_on_opentop = hat_on_opentop,
	hat_off = hat_off,
	hat_on_fullhead = hat_on_fullhead,
	hat_off_fullhead = hat_off_fullhead,
    MakeNoLossRepairableEquipment = MakeNoLossRepairableEquipment,
    TagsCombat1 = TagsCombat1, TagsCombat2 = TagsCombat2, TagsCombat3 = TagsCombat3,
    TagsSiving = TagsSiving,
    TagsWorkable1 = TagsWorkable1, TagsWorkable2 = TagsWorkable2,
    IsMyFollower = IsMyFollower, IsPlayerFollower = IsPlayerFollower,
    IsEnemy_me = IsEnemy_me, IsEnemy_player = IsEnemy_player,
    MaybeEnemy_me = MaybeEnemy_me, MaybeEnemy_player = MaybeEnemy_player,
    CalcDamage = CalcDamage,
    DoSingleSleep = DoSingleSleep, DoAreaSleep = DoAreaSleep,

    SetImmortalBox_common = SetImmortalBox_common, SetImmortalBox_server = SetImmortalBox_server
}
