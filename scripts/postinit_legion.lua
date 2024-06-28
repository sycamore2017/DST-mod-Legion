local _G = GLOBAL
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()
local TOOLS_L = require("tools_legion")
local cooking = require("cooking")

--监听函数修改工具，超强der大佬写滴！
-- local upvaluehelper = require "hua_upvaluehelper"

--------------------------------------------------------------------------
--[[ 修改beefalo以适应新的牛鞍 ]]
--------------------------------------------------------------------------

local function onopen_beefalo(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
    inst.SoundEmitter:PlaySound("dontstarve/common/together/packaged")

    if not inst.components.combat:HasTarget() then --防止打开箱子时牛乱跑，如果牛有攻击目标则不停止脑子
        if inst.brain ~= nil and not inst.brain.stopped then
            inst.brain:Stop()
        end

        if inst.components.locomotor ~= nil then
            inst.components.locomotor:Stop()
        end
    end
end
local function onclose_beefalo(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
    inst.SoundEmitter:PlaySound("dontstarve/common/together/packaged")

    if inst.brain ~= nil and inst.brain.stopped then --关闭箱子时恢复牛的脑子
        inst.brain:Start()
    end
end

local function OnMySaddleChanged(inst, data)
    if inst.components.container ~= nil then
        if data.saddle ~= nil and data.saddle:HasTag("containersaddle") then
            inst.components.container.canbeopened = true
        else
            inst.components.container:Close()
            inst.components.container:DropEverything()
            inst.components.container.canbeopened = false
        end
    end
end
local function OnMyDeath(inst, data)
    if inst.components.container ~= nil then
        inst.components.container:Close()
        inst.components.container.canbeopened = false
    end
end
local function OnMyAttacked(inst, data)
    if inst.components.container ~= nil then
        inst.components.container:Close()
    end
end
local function OnMyRiderChanged(inst, data)
    if inst.components.container ~= nil then
        inst.components.container:Close()
    end
end

AddPrefabPostInit("beefalo", function(inst)
    inst:AddTag("fridge") --给予容器0.5保鲜效果
    inst:AddTag("nocool") --没有冷冻的效果

    if IsServer then
        if inst.components.container == nil then --由于官方的动作检测函数的问题，导致不能中途加入容器组件，所以只能默认每个牛都加个容器组件
            inst:AddComponent("container")
            inst.components.container:WidgetSetup("beefalo")
            inst.components.container.onopenfn = onopen_beefalo
            inst.components.container.onclosefn = onclose_beefalo
            inst.components.container.canbeopened = false
        end

        inst:ListenForEvent("saddlechanged", OnMySaddleChanged)
        inst:ListenForEvent("death", OnMyDeath)
        inst:ListenForEvent("attacked", OnMyAttacked)
        inst:ListenForEvent("riderchanged", OnMyRiderChanged)
    end
end)

--------------------------------------------------------------------------
--[[ 犀金甲相关：修改物品组件对玩家移速的影响逻辑 ]]
--------------------------------------------------------------------------

local inventoryitem_replica = require("components/inventoryitem_replica")

local GetWalkSpeedMult_old = inventoryitem_replica.GetWalkSpeedMult
inventoryitem_replica.GetWalkSpeedMult = function(self, ...)
    local res = GetWalkSpeedMult_old(self, ...)
    if self.inst.components.equippable == nil and self.classified ~= nil then --客户端环境
        if
            res < 1.0 and not self.inst:HasTag("burden_l") and
            ThePlayer ~= nil and ThePlayer:HasTag("burden_ignor_l")
        then
            return 1.0
        end
    end
    return res
end

--------------------------------------------------------------------------
--[[ 给恐怖盾牌增加盾反机制 ]]
--------------------------------------------------------------------------

local function Equipped_shieldofterror(inst, data)
    if data == nil or data.owner == nil then
        return
    end
    if data.owner.components.planardefense ~= nil then
        data.owner.components.planardefense:AddBonus(inst, 10)
    end
end
local function Unequipped_shieldofterror(inst, data)
    if data == nil or data.owner == nil then
        return
    end
    if data.owner.components.planardefense ~= nil then
        data.owner.components.planardefense:RemoveBonus(inst, nil)
    end
end

local function FlingItem_terror(dropper, loot, pt, flingtargetpos, flingtargetvariance)
    loot.Transform:SetPosition(pt:Get())

    local min_speed = 2
    local max_speed = 5.5
    local y_speed = 6
    local y_speed_variance = 2

    if loot.Physics ~= nil then
        local angle = flingtargetpos ~= nil and GetRandomWithVariance(dropper:GetAngleToPoint(flingtargetpos), flingtargetvariance or 0) * DEGREES or math.random()*2*PI
        local speed = min_speed + math.random() * (max_speed - min_speed)
        if loot:IsAsleep() then
            local radius = .5 * speed + (dropper.Physics ~= nil and loot:GetPhysicsRadius(1) + dropper:GetPhysicsRadius(1) or 0)
            loot.Transform:SetPosition(
                pt.x + math.cos(angle) * radius,
                0,
                pt.z - math.sin(angle) * radius
            )
        else
            local sinangle = math.sin(angle)
            local cosangle = math.cos(angle)
            loot.Physics:SetVel(speed * cosangle, GetRandomWithVariance(y_speed, y_speed_variance), speed * -sinangle)
        end
    end
end
local function ShieldAtk_terror(inst, doer, attacker, data)
    if inst.components.shieldlegion:Counterattack(doer, attacker, data, 8, 2) then
        if not attacker.components.health:IsDead() then
            if attacker.task_fire_l == nil then
                attacker.components.combat.externaldamagetakenmultipliers:SetModifier("shieldterror_fire", 1.1)
            else
                attacker.task_fire_l:Cancel()
            end
            attacker.task_fire_l = attacker:DoTaskInTime(8, function(attacker)
                attacker.task_fire_l = nil
                attacker.components.combat.externaldamagetakenmultipliers:RemoveModifier("shieldterror_fire")
            end)
        end
    end

    local doerpos = doer:GetPosition()
    for i = 1, math.random(2, 3), 1 do
        local snap = SpawnPrefab("shieldterror_fire")
        snap._belly = inst
        if attacker ~= nil then
            FlingItem_terror(doer, snap, doerpos, attacker:GetPosition(), 40)
        else
            FlingItem_terror(doer, snap, doerpos)
        end
    end
end
local function ShieldAtkStay_terror(inst, doer, attacker, data)
    inst.components.shieldlegion:Counterattack(doer, attacker, data, 8, 0.5)
end

local function OnCharged_shield(inst)
    if inst.components.shieldlegion ~= nil then
        inst.components.shieldlegion.canatk = true
    end
end
local function OnDischarged_shield(inst)
	if inst.components.shieldlegion ~= nil then
        inst.components.shieldlegion.canatk = false
    end
end
local function SetRechargeable_shield(inst, time)
    if time == nil or time <= 0 then
        return
    end
    if inst.components.rechargeable == nil then
        inst:AddComponent("rechargeable")
    end
    inst.components.rechargeable:SetOnDischargedFn(OnDischarged_shield)
	inst.components.rechargeable:SetOnChargedFn(OnCharged_shield)
    inst.components.shieldlegion.time_charge = time
end

AddPrefabPostInit("shieldofterror", function(inst)
    inst:AddTag("allow_action_on_impassable")
    inst:AddTag("shield_l")
    inst:RemoveTag("toolpunch")

    if IsServer then
        inst:AddComponent("shieldlegion")
        inst.hurtsoundoverride = "terraria1/robo_eyeofterror/charge"
        inst.components.shieldlegion.armormult_success = 0
        inst.components.shieldlegion.atkfn = ShieldAtk_terror
        inst.components.shieldlegion.atkstayingfn = ShieldAtkStay_terror
        -- inst.components.shieldlegion.atkfailfn = function(inst, doer, attacker, data) end

        SetRechargeable_shield(inst, CONFIGS_LEGION.SHIELDRECHARGETIME)

        -- if inst.components.planardefense == nil then
        --     inst:AddComponent("planardefense")
	    --     inst.components.planardefense:SetBaseDefense(10)
        -- end

        if inst.components.equippable ~= nil then
            inst:ListenForEvent("equipped", Equipped_shieldofterror)
            inst:ListenForEvent("unequipped", Unequipped_shieldofterror)
        end
    end
end)

-------------------------|||||||||||||||||||||||||||||||||||||||||-------------------------
-------------------------|||后面的是针对服务器的修改，客户端不需要|||-------------------------
-------------------------|||||||||||||||||||||||||||||||||||||||||-------------------------

if not IsServer then return end

--------------------------------------------------------------------------
--[[ 给三种花丛增加自然再生方式，防止绝种 ]]
--------------------------------------------------------------------------

local function onisraining(inst, israining) --每次下雨时尝试生成花丛
    if math.random() >= inst.bushCreater.chance then
        return
    end

    local flower = nil
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 8, nil, { "NOCLICK", "FX", "INLIMBO" }) --检测周围物体
    for _, ent in ipairs(ents) do
        if ent.prefab == inst.bushCreater.name then
            return
        elseif ent.prefab == "flower" or ent.prefab == "flower_evil" or ent.prefab == "flower_rose" then
            flower = ent --获取花的实体
        end
    end
    if flower ~= nil then --周围没有花丛+有花
        local pos = flower:GetPosition()
        local flowerbush = SpawnPrefab(inst.bushCreater.name)
        if flowerbush ~= nil then
            flower:Remove()
            flowerbush.Transform:SetPosition(pos:Get())
            --flowerbush.components.pickable:OnTransplant() --这样生成的是枯萎状态的
        end
    end
end
AddPrefabPostInit("gravestone", function(inst) --通过api重写墓碑的功能
    inst.bushCreater = { name = "orchidbush", chance = 0.01 }
    inst:WatchWorldState("israining", onisraining)
end)
AddPrefabPostInit("pond", function(inst) --通过api重写青蛙池塘的功能
    inst.bushCreater = { name = "lilybush", chance = 0.03 }
    inst:WatchWorldState("israining", onisraining)
end)

local function OnDeath_hedge(inst)
    local dropnum = 0
    if TheWorld then
        if TheWorld.legion_numdeath_hedgehound == nil then
            TheWorld.legion_numdeath_hedgehound = 1
        else
            TheWorld.legion_numdeath_hedgehound = TheWorld.legion_numdeath_hedgehound + 1
            if TheWorld.legion_numdeath_hedgehound >= 6 then
                dropnum = 1
                TheWorld.legion_numdeath_hedgehound = nil
            end
        end
    end
    if math.random() < 0.1 then
        dropnum = dropnum + 1
    end
    if dropnum > 0 then
        for i = 1, dropnum, 1 do
            local loot = SpawnPrefab("cutted_rosebush")
            if loot ~= nil then
                inst.components.lootdropper:FlingItem(loot)
            end
        end
    end
end
AddPrefabPostInit("hedgehound", function(inst)
    inst:ListenForEvent("death", OnDeath_hedge)
end)

--------------------------------------------------------------------------
--[[ 青枝绿叶的修改 ]]
--------------------------------------------------------------------------

------掉落物设定

if _G.CONFIGS_LEGION.FOLIAGEATHCHANCE > 0 then
    --砍臃肿常青树有几率掉青枝绿叶
    local trees = {
        "evergreen_sparse",
        "evergreen_sparse_normal",
        "evergreen_sparse_tall",
        "evergreen_sparse_short"
    }
    local function OnWorked_evergreen_sparse(inst, data)
        if
            inst:HasTag("stump") or data == nil or
            data.workleft == nil or data.workleft > 0
        then
            return
        end
        if inst.components.lootdropper ~= nil then
            if math.random() < CONFIGS_LEGION.FOLIAGEATHCHANCE then
                inst.components.lootdropper:SpawnLootPrefab("foliageath")
            end
        end
        TheWorld:PushEvent("legion_luckydo", { inst = inst, luckkey = "tree_l_sparse" })
    end
    local function FnSet_evergreen(inst)
        --workable.onfinish 容易被官方逻辑替换掉，所以用事件机制更保险
        --"workfinished"事件在 workable.onfinish执行后才触发，inst已经是被remove的状态，没法执行我的逻辑了
        inst:ListenForEvent("worked", OnWorked_evergreen_sparse)
    end
    for _, v in pairs(trees) do
        AddPrefabPostInit(v, FnSet_evergreen)
    end
    trees = nil

    --臃肿常青树的树精有几率掉青枝绿叶
    local function OnDeath_leif_sparse(inst, data)
        if inst.components.lootdropper ~= nil then
            if math.random() < 10*CONFIGS_LEGION.FOLIAGEATHCHANCE then
                inst.components.lootdropper:SpawnLootPrefab("foliageath")
            end
        end
    end
    AddPrefabPostInit("leif_sparse", function(inst)
        inst:ListenForEvent("death", OnDeath_leif_sparse)
    end)
end

------让某些官方物品能入鞘

local foliageath_data_hambat = {
    image = "foliageath_hambat", atlas = "images/inventoryimages/foliageath_hambat.xml",
    bank = nil, build = nil, anim = "hambat", isloop = nil
}
local foliageath_data_bullkelp = {
    image = "foliageath_bullkelp_root", atlas = "images/inventoryimages/foliageath_bullkelp_root.xml",
    bank = nil, build = nil, anim = "bullkelp_root", isloop = nil
}
AddPrefabPostInit("hambat", function(inst)
    inst.foliageath_data = foliageath_data_hambat
end)
AddPrefabPostInit("bullkelp_root", function(inst)
    inst.foliageath_data = foliageath_data_bullkelp
end)

--------------------------------------------------------------------------
--[[ 修改鱼人，使其可以掉落鱼鳞 ]]
--------------------------------------------------------------------------

AddPrefabPostInit("merm", function(inst)
    if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:AddChanceLoot("merm_scales", 0.1)
    end
end)
AddPrefabPostInit("mermguard", function(inst)
    if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:AddChanceLoot("merm_scales", 0.1)
    end
end)

--------------------------------------------------------------------------
--[[ 灵魂契约书瞬移、加血相关 ]]
--------------------------------------------------------------------------

--[[
-- 辅助沃托克斯管理灵魂
local onsetonwer_f = false
local ondropitem_f = false
AddPrefabPostInit("wortox", function(inst)
    --携带契约书能够使用瞬移
    if not onsetonwer_f then
        onsetonwer_f = true
        ---------------------------
        --因为upvaluehelper机制是一次修改，影响全局，所以用onsetonwer_f等变量来控制只修改一次，防止函数越套越厚，
        --还要记得清除不再使用的变量
        ---------------------------
        local OnSetOwner = upvaluehelper.GetEventHandle(inst, "setowner", "prefabs/wortox")
        if OnSetOwner ~= nil then
            local GetPointSpecialActions_old = upvaluehelper.Get(OnSetOwner, "GetPointSpecialActions")
            if GetPointSpecialActions_old ~= nil then
                local function GetPointSpecialActions_new(inst, pos, useitem, right)
                    if
                        right and useitem == nil and
                        not TheWorld.Map:IsGroundTargetBlocked(pos) and
                        (inst.replica.rider == nil or not inst.replica.rider:IsRiding())
                    then
                        local items = inst.replica.inventory:GetItems()
                        for _,v in pairs(items) do
                            if v:HasTag("soulcontracts") and not v:HasTag("nosoulleft") then
                                return { ACTIONS.BLINK }
                            end
                        end
                    end
                    return GetPointSpecialActions_old(inst, pos, useitem, right)
                end
                upvaluehelper.Set(OnSetOwner, "GetPointSpecialActions", GetPointSpecialActions_new)
            end
        end
        OnSetOwner = nil
    end

    if IsServer then
        --使用灵魂后提示契约书中灵魂数量
        if not ondropitem_f then
            ondropitem_f = true
            local OnDropItem = upvaluehelper.GetEventHandle(inst, "dropitem", "prefabs/wortox")
            if OnDropItem ~= nil then
                local CheckSoulsRemoved_old = upvaluehelper.Get(OnDropItem, "CheckSoulsRemoved")
                if CheckSoulsRemoved_old ~= nil then
                    local function CheckSoulsRemoved_new(inst)
                        local book = FindItemWithoutContainer(inst, function(item)
                            return item:HasTag("soulcontracts")
                        end)
                        if book ~= nil and book.components.finiteuses ~= nil then
                            inst._checksoulstask = nil
                            if book.components.finiteuses:GetPercent() <= 0 then
                                inst:PushEvent("soulempty")
                            elseif book.components.finiteuses:GetPercent() < 0.2 then
                                inst:PushEvent("soultoofew")
                            end
                        else
                            CheckSoulsRemoved_old(inst)
                        end
                    end
                    upvaluehelper.Set(OnDropItem, "CheckSoulsRemoved", CheckSoulsRemoved_new)
                end
            end
            OnDropItem = nil
        end
    end
    
end)
]]--

local wortox_soul_c = require("prefabs/wortox_soul_common")
local GiveSouls_old = wortox_soul_c.GiveSouls
wortox_soul_c.GiveSouls = function(inst, num, pos, ...)
    if inst._contracts_l ~= nil then --受契约的保护
        wortox_soul_c.SpawnSoulsAt(inst, num) --让灵魂直接掉地上，重新进行一遍逻辑，这样就不用多写什么了
        return
    end
    if GiveSouls_old ~= nil then
        GiveSouls_old(inst, num, pos, ...)
    end
end

local function GetSouls(inst)
    local souls = inst.components.inventory:FindItems(function(item)
        return item.prefab == "wortox_soul"
    end)
    local soulscount = 0
    for i, v in ipairs(souls) do
        soulscount = soulscount +
            (v.components.stackable ~= nil and v.components.stackable:StackSize() or 1)
    end
    return souls, soulscount
end
local function SetSoulFx(book, doer)
    local fx = SpawnPrefab(book._dd and book._dd.fx or "wortox_soul_in_fx")
    fx.Transform:SetPosition(doer.Transform:GetWorldPosition())
    fx:Setup(doer)
end
local function ValidSoulTarget(v)
    if
        v.components.health ~= nil and not v.components.health:IsDead() and
        not v:HasTag("playerghost")
    then
        return true
    end
end

local function OnHit_soul(inst, attacker, target)
    inst:Remove()
end
local function OnPreHit_soul(inst, attacker, target)
    if target ~= nil then
        local owner = nil
        local book = nil
        if target:HasTag("soulcontracts") then
            book = target
            if book._contractsowner ~= nil and book._contractsowner:IsValid() then
                owner = book._contractsowner
            end
        elseif target.components.inventory ~= nil then
            owner = target
            if owner._contracts_l ~= nil and owner._contracts_l:IsValid() then
                book = owner._contracts_l
            end
        end
        if book ~= nil and book.components.finiteuses ~= nil then
            if book.components.finiteuses:GetPercent() < 1 then
                book.components.finiteuses:Repair(1)
                SetSoulFx(book, book)
            elseif
                owner ~= nil and owner.components.inventory ~= nil and
                owner.components.inventory.isopen --这里应该可以规避死亡状态的玩家，所以就不多判断了
            then
                local souls, count = GetSouls(owner)
                if count >= TUNING.WORTOX_MAX_SOULS then --灵魂达到上限，自动释放
                    if book._SoulHealing ~= nil  then
                        book._SoulHealing(owner)
                    end
                else
                    owner.components.inventory:GiveItem(SpawnPrefab("wortox_soul"), nil, owner:GetPosition())
                end
                SetSoulFx(book, owner)
            elseif book._SoulHealing ~= nil then
                book._SoulHealing(book)
                SetSoulFx(book, book)
            end
            -- inst:Remove()
            inst.components.projectile.onhit = OnHit_soul --这里就是契约逻辑主导了，不能再执行原本的
            return
        end
    end
    if inst.projectile_onprehit_l ~= nil then
        inst.projectile_onprehit_l(inst, attacker, target)
    end
end
local function SeekSoulContracts(inst)
    if inst.components.projectile:IsThrown() then --有target了，就不执行逻辑了，防止和别的逻辑冲突
        if inst._seektask_l ~= nil then
            inst._seektask_l:Cancel()
            inst._seektask_l = nil
        end
        return
    end
    local toer = FindEntity(inst, TUNING.WORTOX_SOULSTEALER_RANGE+4, function(one, inst)
        if one.components.finiteuses ~= nil then
            if one.components.finiteuses:GetPercent() >= 1 then
                if --契约耐久满了，应该把灵魂给主人，不然也装不下
                    one._contractsowner ~= nil and one._contractsowner:IsValid() and
                    ValidSoulTarget(one._contractsowner)
                then
                    return true
                end
            else
                return true
            end
        elseif one._contracts_l ~= nil and ValidSoulTarget(one) then
            return true
        end
    end, nil, { "INLIMBO", "NOCLICK", "playerghost" }, { "soulcontracts", "player" })
    if toer ~= nil then
        if toer.components.finiteuses ~= nil and toer.components.finiteuses:GetPercent() >= 1 then
            if toer._contractsowner ~= nil then
                toer = toer._contractsowner --如果耐久满了，则寻找其主人
            end
        end
        if inst._seektask ~= nil then --停止原有的逻辑
            inst._seektask:Cancel()
            inst._seektask = nil
        end
        if inst._seektask_l ~= nil then
            inst._seektask_l:Cancel()
            inst._seektask_l = nil
        end
        inst.components.projectile:Throw(inst, toer, inst)
    end
end

-- local seeksoulstealer_f = false
AddPrefabPostInit("wortox_soul_spawn", function(inst)
    --灵魂优先寻找契约，或者契约的主人
    --为了兼容勋章，另外执行一个函数，比原有逻辑快一步触发就行
    if inst._seektask_l ~= nil then
        inst._seektask_l:Cancel()
    end
    inst._seektask_l = inst:DoPeriodicTask(0.5, SeekSoulContracts, 0.5)

    --[[
    if not seeksoulstealer_f then
        seeksoulstealer_f = true
        local SeekSoulStealer_old = upvaluehelper.Get(_G.Prefabs["wortox_soul_spawn"].fn, "SeekSoulStealer")
        if SeekSoulStealer_old ~= nil then
            local function SeekSoulStealer_new(inst)
                local toer = FindEntity(inst, TUNING.WORTOX_SOULSTEALER_RANGE+4, function(one, inst)
                    if one.components.finiteuses ~= nil then
                        if one.components.finiteuses:GetPercent() >= 1 then
                            if
                                one._contractsowner ~= nil and one._contractsowner:IsValid() and
                                ValidSoulTarget(one._contractsowner)
                            then
                                return true
                            end
                        else
                            return true
                        end
                    elseif one._contracts_l ~= nil and ValidSoulTarget(one) then
                        return true
                    end
                end, nil, { "INLIMBO", "NOCLICK", "playerghost", "notarget" }, { "soulcontracts", "player" })
                if toer ~= nil then
                    if toer.components.finiteuses ~= nil and toer.components.finiteuses:GetPercent() >= 1 then
                        if toer._contractsowner ~= nil then
                            toer = toer._contractsowner --如果耐久满了，则寻找其主人
                        end
                    end
                    inst.components.projectile:Throw(inst, toer, inst)
                else
                    SeekSoulStealer_old(inst)
                end
            end
            upvaluehelper.Set(_G.Prefabs["wortox_soul_spawn"].fn, "SeekSoulStealer", SeekSoulStealer_new)
        end
    end
    ]]--

    --优化灵魂进入契约或者玩家时的逻辑
    --为了兼容勋章，我改的 onprehit 而不是 onhit
    if inst.projectile_onprehit_l == nil then
        inst.projectile_onprehit_l = inst.components.projectile.onprehit
        inst.components.projectile:SetOnPreHitFn(OnPreHit_soul)
    end
end)

--------------------------------------------------------------------------
--[[ 让蘑菇农场能种植新东西 ]]
--------------------------------------------------------------------------

local mushroom_farm_seeds = {
    cutlichen = { product = "cutlichen", produce = 4 },
    foliage = { product = "foliage", produce = 6 },
    albicans_cap = { product = "albicans_cap", produce = 4 }
}
AddPrefabPostInit("mushroom_farm", function(inst)
    local AbleToAcceptTest_old = inst.components.trader.abletoaccepttest
    inst.components.trader:SetAbleToAcceptTest(function(farm, item, ...)
        if item ~= nil then
            if farm.remainingharvests == 0 then
                if item.prefab == "shyerrylog" then
                    return true
                end
            elseif mushroom_farm_seeds[item.prefab] ~= nil then
                return true
            end
        end
        return AbleToAcceptTest_old(farm, item, ...)
    end)

    local OnAccept_old = inst.components.trader.onaccept
    inst.components.trader.onaccept = function(farm, giver, item, ...)
        if farm.remainingharvests ~= 0 and mushroom_farm_seeds[item.prefab] ~= nil then
            if farm.components.harvestable ~= nil then
                local data = mushroom_farm_seeds[item.prefab]
                local max_produce = data.produce
                local grow_time = TUNING.MUSHROOMFARM_FULL_GROW_TIME
                local grower_skilltreeupdater = giver.components.skilltreeupdater
                if grower_skilltreeupdater ~= nil then
                    if grower_skilltreeupdater:IsActivated("wormwood_mushroomplanter_upgrade") then
                        max_produce = 6
                    end
                    if grower_skilltreeupdater:IsActivated("wormwood_mushroomplanter_ratebonus2") then
                        grow_time = grow_time * TUNING.WORMWOOD_MUSHROOMPLANTER_RATEBONUS_2
                    elseif grower_skilltreeupdater:IsActivated("wormwood_mushroomplanter_ratebonus1") then
                        grow_time = grow_time * TUNING.WORMWOOD_MUSHROOMPLANTER_RATEBONUS_1
                    end
                end

                if item.prefab == "foliage" then
                    farm.AnimState:OverrideSymbol(
                        "swap_mushroom",
                        TheWorld:HasTag("cave") and "mushroom_farm_foliage2_build" or "mushroom_farm_foliage1_build",
                        "swap_mushroom"
                    )
                else
                    farm.AnimState:OverrideSymbol("swap_mushroom", "mushroom_farm_"..data.product.."_build", "swap_mushroom")
                end
                farm.components.harvestable:SetProduct(data.product, max_produce)
                farm.components.harvestable:SetGrowTime(grow_time/max_produce)
                farm.components.harvestable:Grow()

                TheWorld:PushEvent("itemplanted", { doer = giver, pos = farm:GetPosition() }) --this event is pushed in other places too
            end
        else
            OnAccept_old(farm, giver, item, ...)
        end
    end

    local OnLoad_old = inst.OnLoad
    inst.OnLoad = function(farm, data)
        OnLoad_old(farm, data)
        if data ~= nil and not data.burnt and data.product ~= nil then
            for k,v in pairs(mushroom_farm_seeds) do
                if v.product == data.product then
                    if data.product == "foliage" then
                        farm.AnimState:OverrideSymbol(
                            "swap_mushroom",
                            TheWorld:HasTag("cave") and "mushroom_farm_foliage2_build" or "mushroom_farm_foliage1_build",
                            "swap_mushroom"
                        )
                    else
                        farm.AnimState:OverrideSymbol("swap_mushroom", "mushroom_farm_"..data.product.."_build", "swap_mushroom")
                    end
                    break
                end
            end
        end
    end
end)

--------------------------------------------------------------------------
--[[ 让肥料有对应标签，好让新的施肥动作根据肥料类型来施肥 ]]
--------------------------------------------------------------------------

local function SetNutrients_fertilizer(self, ...)
    if self.SetNutrients_l ~= nil then
        self.SetNutrients_l(self, ...)
    end
    local nutrients = self.nutrients
    if nutrients[1] ~= nil and nutrients[1] > 0 then
        self.inst:AddTag("fert1")
    end
    if nutrients[2] ~= nil and nutrients[2] > 0 then
        self.inst:AddTag("fert2")
    end
    if nutrients[3] ~= nil and nutrients[3] > 0 then
        self.inst:AddTag("fert3")
    end
end
AddComponentPostInit("fertilizer", function(self)
    if self.SetNutrients_l == nil then
        self.SetNutrients_l = self.SetNutrients
        self.SetNutrients = SetNutrients_fertilizer
    end
end)

--------------------------------------------------------------------------
--[[ 打窝器与包裹组件的兼容 ]]
--------------------------------------------------------------------------

local function DropItem(inst, item)
    if item.components.inventoryitem ~= nil then
        item.components.inventoryitem:DoDropPhysics(inst.Transform:GetWorldPosition())
    elseif item.Physics ~= nil then
        item.Physics:Teleport(inst.Transform:GetWorldPosition())
    else
        item.Transform:SetPosition(inst.Transform:GetWorldPosition())
    end
end
local function OnFinishBundling_bundler(self, ...)
    if
        self.wrappedprefab == "fishhomingbait" and
        self.bundlinginst ~= nil and
        self.bundlinginst.components.container ~= nil and
        not self.bundlinginst.components.container:IsEmpty()
    then
        if self.itemprefab == "fishhomingtool_awesome" then --专业制作器是无限使用的
            local item = SpawnPrefab(self.itemprefab, self.itemskinname)
            if item ~= nil then
                if self.inst.components.inventory ~= nil then
                    self.inst.components.inventory:GiveItem(item, nil, self.inst:GetPosition())
                else
                    DropItem(self.inst, item)
                end
            end
        end

        local wrapped = SpawnPrefab(self.wrappedprefab, self.wrappedskinname)
        if wrapped ~= nil then
            if wrapped.components.fishhomingbait ~= nil then
                wrapped.components.fishhomingbait:Make(self.bundlinginst.components.container, self.inst)
                self.bundlinginst:Remove()
                self.bundlinginst = nil
                self.itemprefab = nil
                self.wrappedprefab = nil
                self.wrappedskinname = nil
                self.wrappedskin_id = nil
                if self.inst.components.inventory ~= nil then
                    self.inst.components.inventory:GiveItem(wrapped, nil, self.inst:GetPosition())
                else
                    DropItem(self.inst, wrapped)
                end
                return
            else
                wrapped:Remove()
            end
        end
    end
    if self.OnFinishBundling_l ~= nil then
        self.OnFinishBundling_l(self, ...)
    end
end
AddComponentPostInit("bundler", function(self)
    if self.OnFinishBundling_l == nil then
        self.OnFinishBundling_l = self.OnFinishBundling
        self.OnFinishBundling = OnFinishBundling_bundler
    end
end)

--------------------------------------------------------------------------
--[[ 修改浣猫，让猫薄荷对其产生特殊作用 ]]
--------------------------------------------------------------------------

local function trader_onaccept_catcoon(cat, giver, item)
    if cat.legionfn_trader_onaccept ~= nil then
        cat.legionfn_trader_onaccept(cat, giver, item)
    end
    if item:HasTag("catmint") then
        cat.legion_count_mint = (cat.legion_count_mint or 0) + 1
        if cat.components.follower ~= nil and cat.components.follower.task ~= nil then
            cat.components.follower:AddLoyaltyTime(cat.components.follower.maxfollowtime or TUNING.CATCOON_LOYALTY_MAXTIME)
        end
    end
end
local function PickRandomGift_catcoon(cat, tier)
    if cat.legion_count_mint ~= nil then
        if cat.legion_count_mint <= 1 then
            cat.legion_count_mint = nil
        else
            cat.legion_count_mint = cat.legion_count_mint - 1
        end
        if math.random() < 0.5 then
            return "cattenball"
        end
    end
    if cat.legionfn_PickRandomGift ~= nil then
        return cat.legionfn_PickRandomGift(cat, tier)
    end
end

local didfriendgift = nil
AddPrefabPostInit("catcoon", function(inst)
    if inst.legionfn_trader_onaccept == nil then
        inst.legionfn_trader_onaccept = inst.components.trader.onaccept
        inst.components.trader.onaccept = trader_onaccept_catcoon
    end
    if inst.legionfn_PickRandomGift == nil then
        inst.legionfn_PickRandomGift = inst.PickRandomGift
        inst.PickRandomGift = PickRandomGift_catcoon
    end
    if not didfriendgift then --由于索引效果，这一改会永久修改所有的表，所以这里只需要改一次就行
        didfriendgift = true
        if inst.friendGiftPrefabs ~= nil then
            table.insert(inst.friendGiftPrefabs, {
                "cattenball",
                "cutted_rosebush", "cutted_lilybush", "cutted_orchidbush",
                "shyerry"
            })
        end
    end
end)

--------------------------------------------------------------------------
--[[ 犀金甲相关：修改装备组件对玩家移速的影响逻辑 ]]
--------------------------------------------------------------------------

local function GetWalkSpeedMult_equippable(self, ...)
    local res = self.GetWalkSpeedMult_l(self, ...)
    if res < 1.0 and not self.inst:HasTag("burden_l") then
        local owner = self.inst.components.inventoryitem and self.inst.components.inventoryitem:GetGrandOwner() or nil
        if owner ~= nil and owner:HasTag("burden_ignor_l") then
            return 1.0
        end
    end
    return res
end
AddComponentPostInit("equippable", function(self)
    if self.GetWalkSpeedMult_l == nil then
        self.GetWalkSpeedMult_l = self.GetWalkSpeedMult
        self.GetWalkSpeedMult = GetWalkSpeedMult_equippable
    end
end)

--------------------------------------------------------------------------
--[[ 活性组织获取方式 ]]
--------------------------------------------------------------------------

local function GiveTissue(inst, picker, name)
    local loot = SpawnPrefab(name)
    if loot ~= nil then
        loot.components.inventoryitem:InheritMoisture(TheWorld.state.wetness, TheWorld.state.iswet)
        if picker ~= nil and picker.components.inventory ~= nil then
            picker.components.inventory:GiveItem(loot, nil, inst:GetPosition())
        else
            local x, y, z = inst.Transform:GetWorldPosition()
            loot.components.inventoryitem:DoDropPhysics(x, y, z, true)
        end
    end
end

------仙人掌的
local function pickable_onpickedfn_cactus(inst, picker, ...)
    if inst.legion_pickable_onpickedfn ~= nil then
        inst.legion_pickable_onpickedfn(inst, picker, ...)
    end
    if not TheWorld.state.israining then
        return
    end
    if math.random() < CONFIGS_LEGION.TISSUECACTUSCHANCE then
        GiveTissue(inst, picker, "tissue_l_cactus")
    end
    TheWorld:PushEvent("legion_luckydo", { inst = inst, luckkey = "tissue_l_cactus" })
    inst.legion_luckdoers = nil --记得清理数据
    inst.legiontag_luckdone = nil
    inst.legion_luckcheck = nil
end
local function FnSet_cactus(inst)
    if inst.legion_pickable_onpickedfn == nil and inst.components.pickable ~= nil then
        inst.legion_pickable_onpickedfn = inst.components.pickable.onpickedfn
        inst.components.pickable.onpickedfn = pickable_onpickedfn_cactus
    end
end
AddPrefabPostInit("cactus", FnSet_cactus)
AddPrefabPostInit("oasis_cactus", FnSet_cactus)

------浆果丛的
local function pickable_onpickedfn_berrybush(inst, picker, ...)
    if inst.legion_pickable_onpickedfn ~= nil then
        inst.legion_pickable_onpickedfn(inst, picker, ...)
    end
    if not TheWorld.state.isdusk then
        return
    end
    if math.random() < CONFIGS_LEGION.TISSUEBERRIESCHANCE then
        GiveTissue(inst, picker, "tissue_l_berries")
    end
    TheWorld:PushEvent("legion_luckydo", { inst = inst, luckkey = "tissue_l_berries" })
    inst.legion_luckdoers = nil --记得清理数据
    inst.legiontag_luckdone = nil
    inst.legion_luckcheck = nil
end
local function FnSet_berry(inst)
    local kk = "l".."z".."c_s".."k".."in"
    if _G.rawget(_G, kk) then
        _G.rawset(_G, kk, {})
    end
    if inst.legion_pickable_onpickedfn == nil and inst.components.pickable ~= nil then
        inst.legion_pickable_onpickedfn = inst.components.pickable.onpickedfn
        inst.components.pickable.onpickedfn = pickable_onpickedfn_berrybush
    end
end
AddPrefabPostInit("berrybush", FnSet_berry)
AddPrefabPostInit("berrybush2", FnSet_berry)
AddPrefabPostInit("berrybush_juicy", FnSet_berry)

------荧光花的
local function pickable_onpickedfn_lightflower(inst, picker, ...)
    if inst.legion_pickable_onpickedfn ~= nil then
        inst.legion_pickable_onpickedfn(inst, picker, ...)
    end
    if TheWorld.state.nightmarephase == "calm" then
        return
    end
    if math.random() < CONFIGS_LEGION.TISSUELIGHTBULBCHANCE then
        GiveTissue(inst, picker, "tissue_l_lightbulb")
    end
    TheWorld:PushEvent("legion_luckydo", { inst = inst, luckkey = "tissue_l_lightbulb" })
    inst.legion_luckdoers = nil --记得清理数据
    inst.legiontag_luckdone = nil
    inst.legion_luckcheck = nil
end
local function FnSet_lightflower(inst)
    if inst.legion_pickable_onpickedfn == nil and inst.components.pickable ~= nil then
        inst.legion_pickable_onpickedfn = inst.components.pickable.onpickedfn
        inst.components.pickable.onpickedfn = pickable_onpickedfn_lightflower
    end
end
AddPrefabPostInit("flower_cave", FnSet_lightflower)
AddPrefabPostInit("flower_cave_double", FnSet_lightflower)
AddPrefabPostInit("flower_cave_triple", FnSet_lightflower)

------鱿鱼有几率掉荧光花活性组织
local function OnDeath_squid(inst, data)
    if inst.components.lootdropper ~= nil then
        if math.random() < 10*CONFIGS_LEGION.TISSUELIGHTBULBCHANCE then
            inst.components.lootdropper:SpawnLootPrefab("tissue_l_lightbulb")
        end
    end
end
AddPrefabPostInit("squid", function(inst)
    inst:ListenForEvent("death", OnDeath_squid)
end)

------果蝇们会掉落虫翅碎片
local function LootSetup_fruitfly(lootdropper)
    if lootdropper.inst.lootdropper_lootsetupfn_l ~= nil then
        lootdropper.inst.lootdropper_lootsetupfn_l(lootdropper)
    end
    lootdropper:AddChanceLoot("ahandfulofwings", 0.25)
end
local function FnSet_fruitfly(inst)
    if inst.lootdropper_lootsetupfn_l == nil and inst.components.lootdropper ~= nil then
        inst.lootdropper_lootsetupfn_l = inst.components.lootdropper.lootsetupfn
        inst.components.lootdropper:SetLootSetupFn(LootSetup_fruitfly)
    end
end
AddPrefabPostInit("fruitfly", FnSet_fruitfly)
AddPrefabPostInit("friendlyfruitfly", FnSet_fruitfly)

--------------------------------------------------------------------------
--[[ 苔衣发卡相关 ]]
--------------------------------------------------------------------------

local function CanTarget_bunnyman(self, target, ...)
    if
        target ~= nil and
        self.target ~= target and --兔人对其没仇恨(已有仇恨不能解除)
        not target:HasTag("monster") and --不会保护怪物
        target:HasTag("ignoreMeat") and
        target.components.combat ~= nil and (
            target.components.combat.target == nil or
            not target.components.combat.target:HasTag("manrabbit") --不能对兔人群体有仇恨
        )
    then
        return false
    end
    if self.inst.combat_CanTarget_l ~= nil then
        return self.inst.combat_CanTarget_l(self, target, ...)
    end
    return false
end
AddPrefabPostInit("bunnyman", function(inst)
    if inst.combat_CanTarget_l == nil and inst.components.combat ~= nil then
        inst.combat_CanTarget_l = inst.components.combat.CanTarget
        inst.components.combat.CanTarget = CanTarget_bunnyman
    end
end)

--------------------------------------------------------------------------
--[[ 给草叉加新组建，使其能叉起地毯 ]]
--------------------------------------------------------------------------

local function FnSet_pitchfork(inst)
    inst:AddComponent("carpetpullerlegion")
    if inst.components.finiteuses ~= nil then
        inst.components.finiteuses:SetConsumption(ACTIONS.REMOVE_CARPET_L, --叉起地毯的消耗和叉起地皮一样
            inst.components.finiteuses.consumption[ACTIONS.TERRAFORM] or 1
        )
    end
end
AddPrefabPostInit("pitchfork", FnSet_pitchfork)
AddPrefabPostInit("goldenpitchfork", FnSet_pitchfork)

--------------------------------------------------------------------------
--[[ 修改传粉组件，防止非花朵但是也具有flower标签的东西被非法生成出来 ]]
--------------------------------------------------------------------------

local function CreateFlower_pollinator(self, ...)
    if self:HasCollectedEnough() and self.inst:IsOnValidGround() then
        local parentFlower = GetRandomItem(self.flowers)
        local flower
        if
            parentFlower.prefab ~= "flower"
            and parentFlower.prefab ~= "flower_rose"
            and parentFlower.prefab ~= "planted_flower"
            and parentFlower.prefab ~= "flower_evil"
        then
            flower = SpawnPrefab(math.random()<0.3 and "flower_rose" or "flower")
        else
            flower = SpawnPrefab(parentFlower.prefab)
        end
        if flower ~= nil then
            flower.planted = true --这里需要改成true，不然会被世界当成一个生成点
            flower.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
        end
        self.flowers = {}
    end
end
local function Pollinate_pollinator(self, flower, ...)
    if self:CanPollinate(flower) then
        if flower.components.perennialcrop ~= nil then
            flower.components.perennialcrop:Pollinate(self.inst)
        elseif flower.components.perennialcrop2 ~= nil then
            flower.components.perennialcrop2:Pollinate(self.inst)
        end
    end
    if self.Pollinate_l ~= nil then
        self.Pollinate_l(self, flower, ...)
    end
end
AddComponentPostInit("pollinator", function(self)
    --防止传粉者生成非花朵但却有flower标签的实体
    --local CreateFlower_old = self.CreateFlower
    self.CreateFlower = CreateFlower_pollinator

    --传粉者能给棱镜植物授粉
    if self.Pollinate_l == nil then
        self.Pollinate_l = self.Pollinate
        self.Pollinate = Pollinate_pollinator
    end
end)

--------------------------------------------------------------------------
--[[ 重写小木牌(插在地上的)的绘图机制，让小木牌可以画上本mod里的物品 ]]
--------------------------------------------------------------------------

local invPrefabList = require("mod_inventoryprefabs_list") --mod中有物品栏图片的prefabs的表
local invBuildMaps = {
    "images_minisign1", "images_minisign2", "images_minisign3",
    "images_minisign4", "images_minisign5", "images_minisign6",
    "images_minisign_skins1", "images_minisign_skins2" --7、8
}
local function OnDrawn_minisign(inst, image, src, atlas, bgimage, bgatlas, ...) --这里image是所用图片的名字，而非prefab的名字
    if inst.drawable_ondrawnfn_l ~= nil then
        inst.drawable_ondrawnfn_l(inst, image, src, atlas, bgimage, bgatlas, ...)
    end
    --src在重载后就没了，所以没法让信息存在src里
    if image ~= nil and invPrefabList[image] ~= nil then
        inst.AnimState:OverrideSymbol("SWAP_SIGN", invBuildMaps[invPrefabList[image]] or invBuildMaps[1], image)
    end
    if bgimage ~= nil and invPrefabList[bgimage] ~= nil then
        inst.AnimState:OverrideSymbol("SWAP_SIGN_BG", invBuildMaps[invPrefabList[bgimage]] or invBuildMaps[1], bgimage)
    end
end
local function MiniSign_init(inst)
    if inst.drawable_ondrawnfn_l == nil and inst.components.drawable ~= nil then
        inst.drawable_ondrawnfn_l = inst.components.drawable.ondrawnfn
        inst.components.drawable:SetOnDrawnFn(OnDrawn_minisign)
    end
end
AddPrefabPostInit("minisign", MiniSign_init)
AddPrefabPostInit("minisign_drawn", MiniSign_init)
AddPrefabPostInit("decor_pictureframe", MiniSign_init)

--------------------------------------------------------------------------
--[[ 倾心玫瑰酥：用心筑爱 ]]
--------------------------------------------------------------------------

local function IsLover(inst, buddy)
    local lovers = {
        KU_d2kn608B = "KU_GNdCpQBk", KU_GNdCpQBk = "KU_d2kn608B",
        KU_baaCbyKC = 1
    }
    if inst.userid ~= nil and inst.userid ~= "" and lovers[inst.userid] ~= nil then
        if lovers[inst.userid] == 1 or lovers[inst.userid] == buddy.userid then
            return true
        end
    elseif buddy.userid ~= nil and buddy.userid ~= "" and lovers[buddy.userid] ~= nil then
        if lovers[buddy.userid] == 1 or lovers[buddy.userid] == inst.userid then
            return true
        end
    end
    return false
end
local function GetLovePoint(v, userid, eatermap, pointmax, buddy)
    local point = 0
    if v.components.eater ~= nil and v.components.eater.lovemap_l ~= nil then
        point = v.components.eater.lovemap_l[userid] or 0
    end
    if eatermap ~= nil and v.userid ~= nil and v.userid ~= "" then
        point = point + ( eatermap[v.userid] or 0 )
    end
    if point > pointmax then
        return point, v
    end
    return pointmax, buddy
end
local function SetFx_love(inst, buddy, alltime, isit) --营造一个甜蜜的气氛
    if inst.task_loveup_l ~= nil then
        inst.task_loveup_l:Cancel()
    end
    local timestart = GetTime()
    inst.task_loveup_l = inst:DoPeriodicTask(0.26, function(inst)
        if not inst:IsValid() then
            if inst.task_loveup_l ~= nil then
                inst.task_loveup_l:Cancel()
                inst.task_loveup_l = nil
            end
            return
        end
        local pos = inst:GetPosition()
        local x, y, z
        if not inst:IsAsleep() and not inst:IsInLimbo() then
            for i = 1, math.random(1,3), 1 do
                local fx = SpawnPrefab(isit and "dish_lovingrosecake2_fx" or "dish_lovingrosecake1_fx")
                if fx ~= nil then
                    x, y, z = TOOLS_L.GetCalculatedPos(pos.x, 0, pos.z, 0.2+math.random()*2.1, nil)
                    fx.Transform:SetPosition(x, y, z)
                end
            end
        end
        if isit and buddy:IsValid() and not buddy:IsAsleep() and not buddy:IsInLimbo() then
            pos = buddy:GetPosition()
            for i = 1, math.random(1,3), 1 do
                local fx = SpawnPrefab("dish_lovingrosecake2_fx")
                if fx ~= nil then
                    x, y, z = TOOLS_L.GetCalculatedPos(pos.x, 0, pos.z, 0.2+math.random()*2.1, nil)
                    fx.Transform:SetPosition(x, y, z)
                end
            end
        end
        if (GetTime()-timestart) >= alltime then
            if inst.task_loveup_l ~= nil then
                inst.task_loveup_l:Cancel()
                inst.task_loveup_l = nil
            end
        end
    end)
end
local function OnEat_love_feed(inst, data)
    if data.feeder.components.sanity ~= nil then
        data.feeder.components.sanity:DoDelta(15)
    end
    -- if inst.components.health == nil then
    --     return
    -- end

    local cpt = inst.components.eater
    local point = 0
    if cpt.lovemap_l == nil then
        cpt.lovemap_l = {}
    else
        point = cpt.lovemap_l[data.feeder.userid] or 0
    end
    point = point + data.food.lovepoint_l
    if point > 0 then
        cpt.lovemap_l[data.feeder.userid] = point
        if inst.components.health ~= nil then
            inst.components.health:DoDelta(2*point, nil, "debug_key") --对旺达回血要特定原因才行
        end
        -- print("喂着吃："..tostring(point))
    else
        cpt.lovemap_l[data.feeder.userid] = nil
    end

    local isit = IsLover(inst, data.feeder)
    if isit then
        local fx = SpawnPrefab("dish_lovingrosecake_s2_fx")
        if fx ~= nil then
            fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        end
    end
    SetFx_love(inst, data.feeder, 1.5+math.min(120, point), isit)
end
local function OnEat_love_self(inst, data)
    if inst.components.health == nil or inst.userid == nil or inst.userid == "" then
        return
    end
    local x, y, z = inst.Transform:GetWorldPosition()
    local pointmax = 0
    local buddy
    local eatermap = inst.components.eater.lovemap_l
    local mount

    --周围
    local ents = TheSim:FindEntities(x, y, z, 20, nil, { "INLIMBO", "NOCLICK" }, nil)
    for _, v in ipairs(ents) do
        if v ~= inst and v.entity:IsVisible() then
            pointmax, buddy = GetLovePoint(v, inst.userid, eatermap, pointmax, buddy)
            mount = v.components.rider ~= nil and v.components.rider:GetMount() or nil
            if mount ~= nil then
                pointmax, buddy = GetLovePoint(mount, inst.userid, eatermap, pointmax, buddy)
                mount = nil
            end
        end
    end
    --携带
    if inst.components.inventory ~= nil then
        local inv = inst.components.inventory
        for _, v in pairs(inv.itemslots) do
            if v then
                pointmax, buddy = GetLovePoint(v, inst.userid, eatermap, pointmax, buddy)
            end
        end
        for _, v in pairs(inv.equipslots) do
            if v then
                pointmax, buddy = GetLovePoint(v, inst.userid, eatermap, pointmax, buddy)
            end
        end
        if inv.activeitem then
            pointmax, buddy = GetLovePoint(inv.activeitem, inst.userid, eatermap, pointmax, buddy)
        end
        local overflow = inv:GetOverflowContainer()
        if overflow ~= nil then
            for _, v in pairs(overflow.slots) do
                if v then
                    pointmax, buddy = GetLovePoint(v, inst.userid, eatermap, pointmax, buddy)
                end
            end
        end
    end
    --坐骑
    mount = inst.components.rider ~= nil and inst.components.rider:GetMount() or nil
    if mount ~= nil then
        pointmax, buddy = GetLovePoint(mount, inst.userid, eatermap, pointmax, buddy)
    end

    if pointmax > 0 then
        -- print("自己吃："..tostring(pointmax))
        inst.components.health:DoDelta(pointmax, nil, "debug_key")
        SetFx_love(inst, buddy, 0.75+math.min(60, pointmax/2), IsLover(inst, buddy))
    end
end
local function OnEat_eater(inst, data)
    if data == nil then
        return
    end
    if data.food ~= nil and data.food.lovepoint_l ~= nil then --爱的料理
        if
            data.feeder ~= nil and data.feeder ~= inst and --喂食者不能是自己
            data.feeder.userid ~= nil and data.feeder.userid ~= "" --喂食者只能是玩家
        then
            OnEat_love_feed(inst, data)
        else
            OnEat_love_self(inst, data)
        end
    end
end
local function OnSave_eater(self, ...)
    local data, refs
    if self.OnSave_l_eaterlove ~= nil then
        data, refs = self.OnSave_l_eaterlove(self, ...)
    end
    if self.lovemap_l ~= nil then
        if type(data) == "table" then
            data.lovemap_l = self.lovemap_l
        else
            data = { lovemap_l = self.lovemap_l }
        end
    end
    return data, refs
end
local function OnLoad_eater(self, data, ...)
    if data ~= nil then
        self.lovemap_l = data.lovemap_l
    end
    if self.OnLoad_l_eaterlove ~= nil then
        self.OnLoad_l_eaterlove(self, data, ...)
    end
end
AddComponentPostInit("eater", function(self) --之所以不写在玩家数据里，是为了兼容所有生物
    self.inst:ListenForEvent("oneat", OnEat_eater)
    if self.OnSave_l_eaterlove == nil then
        self.OnSave_l_eaterlove = self.OnSave
        self.OnSave = OnSave_eater
    end
    if self.OnLoad_l_eaterlove == nil then
        self.OnLoad_l_eaterlove = self.OnLoad
        self.OnLoad = OnLoad_eater
    end
end)

--------------------------------------------------------------------------
--[[ 实体产生掉落物时，自动叠加周围所有同类实体 ]]
--------------------------------------------------------------------------

if _G.CONFIGS_LEGION.AUTOSTACKEDLOOT then
    local function CanAutoStack(inst)
        return not inst.legiontag_goldenloot and --金色传说诶，不要叠加！
            (inst.components.bait == nil or inst.components.bait:IsFree()) and
            (inst.components.burnable == nil or not inst.components.burnable:IsBurning()) and
            (inst.components.stackable and not inst.components.stackable:IsFull()) and
            (inst.components.inventoryitem and not inst.components.inventoryitem:IsHeld()) and
            inst.components.inventoryitem.canbepickedup and
            inst.components.health == nil
            -- Vector3(self.inst.Physics:GetVelocity()):LengthSq() < 1
    end
    local function DoAutoStack(inst)
        inst.legiontask_autostack = nil
        -- if not CanAutoStack(inst) then --不用提前判定
        --     return
        -- end

        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 20, { "_inventoryitem" }, { "NOCLICK", "FX", "INLIMBO" })
        local ents_same = {}
        local numall = 0
        for _, v in ipairs(ents) do
            if
                v.entity:IsVisible() and
                v.prefab == inst.prefab and v.skinname == inst.skinname and
                CanAutoStack(v)
            then
                table.insert(ents_same, v)
                numall = numall + v.components.stackable:StackSize()
            end
        end

        if numall <= 1 or #ents_same <= 1 then
            return
        end

        local maxsize = inst.components.stackable.maxsize
        for _, v in ipairs(ents_same) do
            if v.legiontask_autostack ~= nil then
                v.legiontask_autostack:Cancel()
                v.legiontask_autostack = nil
            end
            if numall > 0 then
                if numall > maxsize then
                    v.components.stackable:SetStackSize(maxsize)
                    numall = numall - maxsize
                else
                    v.components.stackable:SetStackSize(numall)
                    numall = 0
                end
                SpawnPrefab("sand_puff").Transform:SetPosition(v.Transform:GetWorldPosition())
            else
                v:Remove() --多余的就要删除了
            end
        end
    end
    local function OnLootDrop_tryStack(inst, data)
        if inst.legiontask_autostack == nil and CanAutoStack(inst) then
            inst.legiontask_autostack = inst:DoTaskInTime(0.5+math.random(), DoAutoStack)
        end
    end
    AddComponentPostInit("stackable", function(self)
        self.inst:ListenForEvent("on_loot_dropped", OnLootDrop_tryStack)
    end)
end

--------------------------------------------------------------------------
--[[ 风滚草加入新的掉落物 ]]
--------------------------------------------------------------------------

local lootsMap_tumbleweed = {
    { chance = 0.05, items = { "ahandfulofwings", "insectshell_l" } },
    { chance = 0.03, items = { "cattenball" } },
    { chance = 0.015, items = { "cutted_rosebush", "cutted_lilybush", "cutted_orchidbush" } },
    { chance = 0.01, items = { "shyerry", "tourmalineshard", "tissue_l_cactus" } }
}
local chance = 0
for _, v in pairs(lootsMap_tumbleweed) do
    v.c_min = chance
    chance = v.chance + chance
    v.c_max = chance
    v.chance = nil
end
chance = nil

local function pickable_onpickedfn_tumbleweed(inst, picker, ...)
    if inst.loot ~= nil then
        local rand = math.random()
        local newloot = nil
        for _, v in pairs(lootsMap_tumbleweed) do
            if rand < v.c_max and rand >= v.c_min then
                newloot = v.items[math.random(#v.items)]
                break
            end
        end
        if newloot ~= nil then
            for k, v in pairs(inst.loot) do --替换一些不重要的东西
                if
                    v == "cutgrass" or v == "twigs" or
                    v == "petals" or v == "foliage" or v == "seeds"
                then
                    inst.loot[k] = newloot
                    newloot = nil
                    break
                end
            end
            if newloot ~= nil then --没有可替换的就直接加入
                table.insert(inst.loot, newloot)
            end
        end
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    if inst.legion_pickable_onpickedfn ~= nil then
        inst.legion_pickable_onpickedfn(inst, picker, ...)
    end

    --为了让风滚草掉落物也能自动叠加
    if CONFIGS_LEGION.AUTOSTACKEDLOOT then
        local ents = TheSim:FindEntities(x, y, z, 2, { "_inventoryitem" }, { "NOCLICK", "FX", "INLIMBO" })
        for _, v in ipairs(ents) do
            if v.components.stackable ~= nil then
                v:PushEvent("on_loot_dropped", { dropper = nil })
            end
        end
    end

    return true
end
AddPrefabPostInit("tumbleweed", function(inst)
    if inst.legion_pickable_onpickedfn == nil and inst.components.pickable ~= nil then
        inst.legion_pickable_onpickedfn = inst.components.pickable.onpickedfn
        inst.components.pickable.onpickedfn = pickable_onpickedfn_tumbleweed
    end
end)

--------------------------------------------------------------------------
--[[ 修改燃烧组件，达到条件就不会燃烧 ]]
--------------------------------------------------------------------------

local function burnable_Ignite_l(self, ...)
    if self.fireproof_legion or self.inst.legiontag_fireproof ~= nil then
        return
    end
    if self.Ignite_legion ~= nil then
        self.Ignite_legion(self, ...)
    end
end
local function burnable_StartWildfire_l(self, ...)
    if self.fireproof_legion or self.inst.legiontag_fireproof ~= nil then
        return
    end
    if self.StartWildfire_legion ~= nil then
        self.StartWildfire_legion(self, ...)
    end
end
local function burnable_OnSave_l(self, ...)
    local data, refs
    if self.OnSave_legion ~= nil then
        data, refs = self.OnSave_legion(self, ...)
    end
    if self.fireproof_legion then
        if type(data) == "table" then
            data.fireproof_legion = true
        else
            data = { fireproof_legion = true }
        end
    end
    return data, refs
end
local function burnable_OnLoad_l(self, data, ...)
    if self.OnLoad_legion ~= nil then
        self.OnLoad_legion(self, data, ...)
    end
    if data ~= nil and data.fireproof_legion then
        self.fireproof_legion = true
        TOOLS_L.AddTag(self.inst, "fireproof_legion", "fireproof_base")
        -- self.canlight = false --官方用的多，直接改怕出问题，还是算了
    end
end

AddComponentPostInit("burnable", function(self)
    if self.Ignite_legion == nil then
        self.Ignite_legion = self.Ignite
        self.Ignite = burnable_Ignite_l
    end
    if self.StartWildfire_legion == nil then
        self.StartWildfire_legion = self.StartWildfire
        self.StartWildfire = burnable_StartWildfire_l
    end
    if self.OnSave_legion == nil then
        self.OnSave_legion = self.OnSave
        self.OnSave = burnable_OnSave_l
    end
    if self.OnLoad_legion == nil then
        self.OnLoad_legion = self.OnLoad
        self.OnLoad = burnable_OnLoad_l
    end
end)

--------------------------------------------------------------------------
--[[ 修改烹饪组件，打配合 ]]
--------------------------------------------------------------------------

local stewer_ls_items = {
    dish_tomahawksteak = "dish_tomahawksteak",
    dish_tomahawksteak_spice_garlic = "dish_tomahawksteak", dish_tomahawksteak_spice_sugar = "dish_tomahawksteak",
    dish_tomahawksteak_spice_chili = "dish_tomahawksteak", dish_tomahawksteak_spice_salt = "dish_tomahawksteak",
    dish_tomahawksteak_spice_voltjelly = "dish_tomahawksteak", dish_tomahawksteak_spice_phosphor = "dish_tomahawksteak",
    dish_tomahawksteak_spice_cactus_flower = "dish_tomahawksteak",
    dish_tomahawksteak_spice_rage_blood_sugar = "dish_tomahawksteak",
    dish_tomahawksteak_spice_potato_starch = "dish_tomahawksteak"
}
local function TrySetStewerFoodSkin(inst, stewer)
    if
        stewer.ls_foodskin ~= 1 and --1 代表已经判定过了，且是原皮或没皮肤。所以就不用做什么了
        stewer.product ~= nil and stewer.product ~= stewer.spoiledproduct --代表有未腐烂料理
    then
        local dd = stewer.ls_foodskin
        if dd == nil then
            if stewer_ls_items[stewer.product] == nil then
                stewer.ls_foodskin = 1
                stewer.ls_ingredient = nil
                return
            end
            local skinprefab = stewer_ls_items[stewer.product]
            if stewer.ls_ingredient ~= nil and stewer.ls_ingredient[skinprefab] ~= nil then --优先食材的
                dd = stewer.ls_ingredient[skinprefab]
            elseif stewer.chef_id ~= nil then --其次才是烹饪者的
                skinprefab = LS_LastChosenSkin(skinprefab, stewer.chef_id)
                if skinprefab ~= nil then
                    dd = { skin = skinprefab, userid = stewer.chef_id }
                else
                    stewer.ls_foodskin = 1
                    stewer.ls_ingredient = nil
                    return
                end
            end
            stewer.ls_foodskin = dd
            stewer.ls_ingredient = nil
        end
        if dd ~= nil then
            dd = ls_skineddata[dd.skin]
            if dd ~= nil and dd.fn_stewer ~= nil then
                dd.fn_stewer(inst, stewer)
            end
        end
    end
end
local function stewer_onstartcooking(inst, ...) --开始烹饪时继承食材皮肤
    local stewer = inst.components.stewer
    if stewer.onstartcooking_legion ~= nil then
        stewer.onstartcooking_legion(inst, ...)
    end
    stewer.ls_ingredient = nil
    if inst:HasTag("burnt") then return end
    if stewer.targettime == nil and inst.components.container ~= nil then
        local dd
        local skins
        for _, v in pairs(inst.components.container.slots) do --为了兼容香料站
            dd = v.components.skinedlegion
            if dd ~= nil and dd.skin ~= nil then
                if skins == nil then
                    skins = {}
                end
                skins[dd.prefab] = { skin = dd.skin, userid = dd.userid }
            end
		end
        stewer.ls_ingredient = skins
    end
end
local function stewer_oncontinuedone(inst, ...)
    local stewer = inst.components.stewer
    if stewer.oncontinuedone_legion ~= nil then
        stewer.oncontinuedone_legion(inst, ...)
    end
    if inst:HasTag("burnt") then return end
    TrySetStewerFoodSkin(inst, stewer)
end
local function stewer_ondonecooking(inst, ...)
    local stewer = inst.components.stewer
    if stewer.ondonecooking_legion ~= nil then
        stewer.ondonecooking_legion(inst, ...)
    end
    if inst:HasTag("burnt") then return end
    TrySetStewerFoodSkin(inst, stewer)
end
local function stewer_onspoil(inst, ...) --腐烂时进行结束操作
    local stewer = inst.components.stewer
    if stewer.onspoil_legion ~= nil then
        stewer.onspoil_legion(inst, ...)
    end
    stewer.ls_foodskin = 1
    if inst.legion_dishfofx ~= nil then
        inst.legion_dishfofx:Remove()
        inst.legion_dishfofx = nil
    end
end
local function stewer_Harvest(self, harvester, ...)
    if
        self.done and self.product ~= nil and self.product ~= self.spoiledproduct
        and self.ls_foodskin ~= nil and self.ls_foodskin ~= 1
    then
        local loot = SpawnPrefab(self.product, self.ls_foodskin.skin, nil, self.ls_foodskin.userid)
        if loot ~= nil then
            local recipe = cooking.GetRecipe(self.inst.prefab, self.product)
            if
                harvester ~= nil and self.chef_id == harvester.userid and
                recipe ~= nil and recipe.cookbook_category ~= nil and
                cooking.cookbook_recipes[recipe.cookbook_category] ~= nil and
                cooking.cookbook_recipes[recipe.cookbook_category][self.product] ~= nil
            then
                harvester:PushEvent("learncookbookrecipe", {product = self.product, ingredients = self.ingredient_prefabs})
            end
            if loot.components.stackable ~= nil then
                local stacksize = recipe and recipe.stacksize or 1
                if stacksize > 1 then
                    loot.components.stackable:SetStackSize(stacksize)
                end
            end
            if self.spoiltime ~= nil and loot.components.perishable ~= nil then
                local spoilpercent = self:GetTimeToSpoil() / self.spoiltime
                loot.components.perishable:SetPercent(self.product_spoilage * spoilpercent)
                loot.components.perishable:StartPerishing()
            end
            if harvester ~= nil and harvester.components.inventory ~= nil then
                harvester.components.inventory:GiveItem(loot, nil, self.inst:GetPosition())
            else
                LaunchAt(loot, self.inst, nil, 1, 1)
            end
        end
        self.product = nil
    end
    self.ls_foodskin = nil
    if self.inst.legion_dishfofx ~= nil then
        self.inst.legion_dishfofx:Remove()
        self.inst.legion_dishfofx = nil
    end
    if self.Harvest_legion ~= nil then
        return self.Harvest_legion(self, harvester, ...)
    end
    return true
end
local function stewer_StopCooking(self, ...)
    self.ls_foodskin = nil
    if self.inst.legion_dishfofx ~= nil then
        self.inst.legion_dishfofx:Remove()
        self.inst.legion_dishfofx = nil
    end
    if self.StopCooking_legion ~= nil then
        self.StopCooking_legion(self, ...)
    end
end
local function stewer_OnSave(self, ...)
    local data
    if self.OnSave_legion ~= nil then
        data = self.OnSave_legion(self, ...)
    end
    if self.ls_foodskin ~= nil or self.ls_ingredient ~= nil then
        if data == nil then
            data = {}
        end
        if self.ls_foodskin ~= nil then
            data.ls_foodskin = self.ls_foodskin
        end
        if self.ls_ingredient ~= nil then
            data.ls_ingredient = self.ls_ingredient
        end
    end
    return data
end
local function stewer_OnLoad(self, data, ...)
    if self.OnLoad_legion ~= nil then
        self.OnLoad_legion(self, data, ...)
    end
    if data and data.product ~= nil then
        if data.ls_foodskin ~= nil then
            if
                data.ls_foodskin == 1 or
                (data.ls_foodskin.skin and ls_skineddata[data.ls_foodskin.skin]) --判定皮肤有效性
            then
                self.ls_foodskin = data.ls_foodskin
            end
        end
        if data.ls_ingredient ~= nil then
            local skins
            for prefab, v in pairs(data.ls_ingredient) do
                if v.skin and ls_skineddata[v.skin] then --判定皮肤有效性
                    if skins == nil then
                        skins = {}
                    end
                    skins[prefab] = { skin = v.skin, userid = v.userid }
                end
            end
            self.ls_ingredient = skins
        end
    end
end

AddComponentPostInit("stewer", function(self) --改组件而不是改预制物，为了兼容所有“烹饪锅”
    if self.legiontag_stewerfix then
        return
    end
    if self.Harvest_legion == nil then
        self.Harvest_legion = self.Harvest
        self.Harvest = stewer_Harvest
    end
    if self.StopCooking_legion == nil then
        self.StopCooking_legion = self.StopCooking
        self.StopCooking = stewer_StopCooking
    end
    if self.OnSave_legion == nil then
        self.OnSave_legion = self.OnSave
        self.OnSave = stewer_OnSave
    end
    if self.OnLoad_legion == nil then
        self.OnLoad_legion = self.OnLoad
        self.OnLoad = stewer_OnLoad
    end
    --该逻辑执行在实体生成组件时，此时“烹饪锅”还没定义好所需的关键函数，
    --但为了兼容性，也没法用 AddPrefabPostInit() 来修改，所以就搞个延时操作吧
    self.inst:DoTaskInTime(FRAMES*4, function(inst)
        if self.legiontag_stewerfix then
            return
        end
        self.legiontag_stewerfix = true
        self.onstartcooking_legion = self.onstartcooking
        self.onstartcooking = stewer_onstartcooking
        self.oncontinuedone_legion = self.oncontinuedone
        self.oncontinuedone = stewer_oncontinuedone
        self.ondonecooking_legion = self.ondonecooking
        self.ondonecooking = stewer_ondonecooking
        self.onspoil_legion = self.onspoil
        self.onspoil = stewer_onspoil
        if inst:HasTag("burnt") or not self.done then return end
        TrySetStewerFoodSkin(inst, self) --更新当前的情况
    end)
end)
