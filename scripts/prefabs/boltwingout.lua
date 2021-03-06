local assets =
{
    Asset("ANIM", "anim/swap_boltwingout.zip"),
    Asset("ATLAS", "images/inventoryimages/boltwingout.xml"),
    Asset("IMAGE", "images/inventoryimages/boltwingout.tex"),
}

local prefabs =
{
    "boltwingout_fx",
    "boltwingout_shuck",
}

local BOLTCOST =
{
    stinger = 3,            --蜂刺
    honey = 5,              --蜂蜜
    royal_jelly = 0.1,      --蜂王浆
    honeycomb = 0.25,       --蜂巢
    beeswax = 0.2,          --蜂蜡
    bee = 0.5,              --蜜蜂
    killerbee = 0.45,       --杀人蜂

    mosquitosack = 1,       --蚊子血袋
    mosquito = 0.45,        --蚊子

    ahandfulofwings = 0.25, --一捧翅膀

    glommerwings = 0.25,    --格罗姆翅膀
    glommerfuel = 0.5,      --格罗姆黏液

    butterflywings = 3,     --蝴蝶翅膀
    butter = 0.1,           --黄油
    butterfly = 0.6,        --蝴蝶

    raindonate = 0.45,      --雨蝇

    wormlight = 0.25,       --神秘浆果
    wormlight_lesser = 1,   --神秘小浆果

    moonbutterflywings = 1, --月蛾翅膀
    moonbutterfly = 0.3,    --月蛾
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "swap_boltwingout", "swap_body")

    if inst.components.container ~= nil then
        inst.components.container:Open(owner)
    end

    if owner.components.combat ~= nil then
        inst.GetAttacked_old = owner.components.combat.GetAttacked
        owner.components.combat.GetAttacked = function(self, attacker, damage, weapon, stimuli)
            local attackerinfact = weapon or attacker

            if (self.inst.components.rider ~= nil and self.inst.components.rider:IsRiding()) --在骑牛
                or self.inst:HasTag("beaver") --变成了海狸
                or self.inst.sg:HasStateTag("busy") --在做特殊动作，攻击sg不会带这个标签
                or stimuli == "darkness" --黑暗攻击
                or attackerinfact == nil --无实物的攻击
                or damage <= 0 then
                inst.GetAttacked_old(self, attacker, damage, weapon, stimuli)
                return
            end

            --识别特定数量的材料来触发金蝉脱壳效果
            local finalitem = nil
            inst.components.container:FindItem(function(item)
                if BOLTCOST[item.prefab] ~= nil
                    and BOLTCOST[item.prefab] <= (item.components.stackable ~= nil and item.components.stackable:StackSize() or 1) then
                    finalitem = item
                    return true
                end
                return false
            end)

            if finalitem ~= nil then
                --删除对应数量的材料
                if BOLTCOST[finalitem.prefab] >= 1 then
                    if finalitem.components.stackable ~= nil then
                        finalitem.components.stackable:Get(BOLTCOST[finalitem.prefab]):Remove()
                    else
                        finalitem:Remove()
                    end
                elseif math.random() <= BOLTCOST[finalitem.prefab] then
                    if finalitem.components.stackable ~= nil then
                        finalitem.components.stackable:Get():Remove()
                    else
                        finalitem:Remove()
                    end
                end

                --金蝉脱壳
                self.inst:PushEvent("boltout", { escapepos = attackerinfact:GetPosition() })
                --若是远程攻击的敌人，“壳”可能因为距离太远吸引不到敌人，所以这里主动先让敌人丢失仇恨
                if attacker ~= nil and attacker.components.combat ~= nil then
                    attacker.components.combat:SetTarget(nil)
                end
            else
                inst.GetAttacked_old(self, attacker, damage, weapon, stimuli)
            end
        end
    end
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")

    if inst.components.container ~= nil then
        inst.components.container:Close(owner)
    end

    if owner.components.combat ~= nil then
        owner.components.combat.GetAttacked = inst.GetAttacked_old
    end
end

local function onburnt(inst)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
        inst.components.container:Close()
    end

    SpawnPrefab("ash").Transform:SetPosition(inst.Transform:GetWorldPosition())

    inst:Remove()
end

local function onignite(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = false
    end
end

local function onextinguish(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = true
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("swap_boltwingout")
    inst.AnimState:SetBuild("swap_boltwingout")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("backpack")

    -- inst.foleysound = "legion/foleysound/dragonfly_flap"
    inst.foleysound = "legion/foleysound/insect"

    MakeInventoryFloatable(inst, "small", 0.2, 0.45)
    local OnLandedClient_old = inst.components.floater.OnLandedClient
    inst.components.floater.OnLandedClient = function(self)
        OnLandedClient_old(self)
        self.inst.AnimState:SetFloatParams(0.09, 1, self.bob_percent)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("boltwingout") end
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "boltwingout"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/boltwingout.xml"
    inst.components.inventoryitem.cangoincontainer = false

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = 1.1

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("boltwingout")

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    inst.components.burnable:SetOnBurntFn(onburnt)
    inst.components.burnable:SetOnIgniteFn(onignite)
    inst.components.burnable:SetOnExtinguishFn(onextinguish)

    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

-------------------------------------------------------------

local assets_fx = {
  Asset("ANIM", "anim/lavaarena_heal_projectile.zip"),
  Asset("ANIM", "anim/boltwingout_fx.zip"),
}

-- local function PlaySound(inst, sound)
--     inst.SoundEmitter:PlaySound(sound)
-- end

local function PlayAnim(proxy)
    local inst = CreateEntity()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    --[[Non-networked entity]]
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    --如果想让特效能设置父实体，则需要这一截代码
    local parent = proxy.entity:GetParent()
    if parent ~= nil then
        inst.entity:SetParent(parent.entity)
    end

    inst.Transform:SetFromProxy(proxy.GUID)

    -- inst.entity:AddSoundEmitter()
    -- inst:DoTaskInTime(0, PlaySound, "dontstarve/creatures/together/stalker/shield")

    inst.AnimState:SetBank("lavaarena_heal_projectile")
    inst.AnimState:SetBuild("boltwingout_fx")
    inst.AnimState:SetFinalOffset(-1)
    inst.AnimState:PlayAnimation("hit")
    
    inst:ListenForEvent("animover", inst.Remove)
end

local function fn_fx()
  local inst = CreateEntity()

  inst.entity:AddTransform()
  inst.entity:AddNetwork()

  --Dedicated server does not need to spawn the local fx
  if not TheNet:IsDedicated() then
      --Delay one frame so that we are positioned properly before starting the effect
      --or in case we are about to be removed
      inst:DoTaskInTime(0, PlayAnim, inst)
  end

  inst:AddTag("FX")
  
  inst.entity:SetPristine()

  if not TheWorld.ismastersim then
      return inst
  end

  inst.persists = false
  inst:DoTaskInTime(1, inst.Remove)

  return inst
end

-------------------------------------------------------------

local assets_shuck = {
  -- Asset("ANIM", "anim/spider_cocoon.zip"),
  Asset("ANIM", "anim/boltwingout_shuck.zip"),
}

local function AttractEnemies(inst)
    local pos = inst:GetPosition()
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 8, { "_combat" }, { "DECOR", "NOCLICK", "FX", "shadow", "playerghost", "INLIMBO" })
    for k, v in pairs(ents) do
        if v ~= inst and v.components.combat ~= nil and v.components.combat:CanTarget(inst) then
            v.components.combat:SetTarget(inst)
        end
    end
end

local function OnInit(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spiderLair_grow")

    inst.AnimState:PlayAnimation("grow_sac_to_small")
    inst.AnimState:PushAnimation("cocoon_small", true)

    AttractEnemies(inst)
end

local function OnFreeze(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/freezecreature")
    inst.AnimState:PlayAnimation("frozen_small", true)
    inst.AnimState:OverrideSymbol("swap_frozen", "frozen", "frozen")
end

local function OnThaw(inst) --快要解冻时的抖动
    inst.AnimState:PlayAnimation("frozen_loop_pst_small", true)
    inst.SoundEmitter:PlaySound("dontstarve/common/freezethaw", "thawing")
    inst.AnimState:OverrideSymbol("swap_frozen", "frozen", "frozen")
end

local function OnUnFreeze(inst)
    inst.AnimState:PlayAnimation("cocoon_small", true)
    inst.SoundEmitter:KillSound("thawing")
    inst.AnimState:ClearOverrideSymbol("swap_frozen")
end

local function OnHit(inst, attacker)
    if not inst.components.health:IsDead() then
        inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spiderLair_hit")
        inst.AnimState:PlayAnimation("cocoon_small_hit")
        inst.AnimState:PushAnimation("cocoon_small", true)
    end
end

local function OnKilled(inst)
    inst.AnimState:PlayAnimation("cocoon_dead")

    -- RemovePhysicsColliders(inst)

    inst.SoundEmitter:KillSound("loop")
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spiderLair_destroy")
end

local function OnEntityWake(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spidernest_LP", "loop")
end

local function OnEntitySleep(inst)
    inst.SoundEmitter:KillSound("loop")
    inst:Remove()
end

local function OnHaunt(inst)
    if math.random() <= TUNING.HAUNT_CHANCE_ALWAYS then
        OnHit(inst)
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_COOLDOWN_MEDIUM

        if math.random() <= 0.33 then --有33%的几率再次吸引敌人，应该有特殊的作用吧
            AttractEnemies(inst)
        end

        return true
    end
    return false
end

local function fn_shuck()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    -- MakeObstaclePhysics(inst, .5) --为了防止用来卡海，设置为无物理体积

    inst.AnimState:SetBank("spider_cocoon")
    inst.AnimState:SetBuild("boltwingout_shuck")
    inst.AnimState:PlayAnimation("cocoon_small", true)

    inst:AddTag("chewable") -- by werebeaver
    inst:AddTag("companion") --加companion和character标签是为了让大多数怪物能主动攻击自己，并且玩家攻击时不会主动以自己为目标
    inst:AddTag("character")
    inst:AddTag("notraptrigger") --不会触发狗牙陷阱
    inst:AddTag("smashable") --为了不产生灵魂

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(20)

    MakeMediumBurnable(inst)
    MakeMediumPropagator(inst)

    MakeMediumFreezableCharacter(inst)
    inst:ListenForEvent("freeze", OnFreeze)
    inst:ListenForEvent("onthaw", OnThaw)
    inst:ListenForEvent("unfreeze", OnUnFreeze)

    inst:AddComponent("combat")
    inst.components.combat:SetOnHit(OnHit)
    inst:ListenForEvent("death", OnKilled)

    inst:AddComponent("inspectable")

    inst:AddComponent("hauntable")
    inst.components.hauntable.cooldown = TUNING.HAUNT_COOLDOWN_MEDIUM
    inst.components.hauntable:SetOnHauntFn(OnHaunt)

    MakeSnowCovered(inst)

    inst:DoTaskInTime(0, OnInit)

    inst.persists = false --保存时不会被记录下来

    inst.OnEntitySleep = OnEntitySleep
    inst.OnEntityWake = OnEntityWake

    return inst
end

return Prefab("boltwingout", fn, assets, prefabs),
        Prefab("boltwingout_fx", fn_fx, assets_fx),
        Prefab("boltwingout_shuck", fn_shuck, assets_shuck)
