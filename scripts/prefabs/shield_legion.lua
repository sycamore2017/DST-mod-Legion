local prefs = {}

--------------------------------------------------------------------------
--[[ 通用函数 ]]
--------------------------------------------------------------------------

local function OnEquipFn(inst, owner)
    if inst.components.skinedlegion ~= nil then
        local skindata = inst.components.skinedlegion:GetSkinedData()
        if skindata ~= nil and skindata.equip ~= nil then
            owner.AnimState:OverrideSymbol("lantern_overlay", skindata.equip.build, skindata.equip.file)
        else
            owner.AnimState:OverrideSymbol("lantern_overlay", inst.prefab, "swap_shield")
        end
    else
        owner.AnimState:OverrideSymbol("lantern_overlay", inst.prefab, "swap_shield")
    end

    owner.AnimState:HideSymbol("swap_object")

    --本来是想让这个和书本的攻击一样来低频率高伤害的方式攻击，但是由于会导致读书时也用本武器来显示动画，所以干脆去除了
    --owner.AnimState:OverrideSymbol("book_open", "swap_book_elemental", "book_open")
    --owner.AnimState:OverrideSymbol("book_closed", "swap_desertdefense_combat", "book_closed")    --替换book_closed就能正确显示特殊攻击动画
    --owner.AnimState:OverrideSymbol("book_open_pages", "swap_book_elemental", "book_open_pages")

    owner.AnimState:Show("ARM_carry") --显示持物手
    owner.AnimState:Hide("ARM_normal") --隐藏普通的手
    owner.AnimState:Show("LANTERN_OVERLAY")

    --初始化
    if owner.redirect_table == nil then
        owner.redirect_table = {}
    end
    RebuildRedirectDamageFn(owner) --全局函数：重新构造combat的redirectdamagefn函数
    --登记远程保护的函数
    if owner.redirect_table[inst.prefab] == nil then
        owner.redirect_table[inst.prefab] = function(victim, attacker, damage, weapon, stimuli)
            --只要这里不为nil，就能吸收所有远程伤害，反正武器没有health组件，所以在伤害计算时会直接被判断给取消掉
            if not inst._brokenshield then
                return inst.components.shieldlegion:GetAttacked(victim, attacker, damage, weapon, stimuli)
            end
            return nil
        end
    end
end
local function OnUnequipFn(inst, owner)
    --owner.AnimState:ClearOverrideSymbol("book_closed")

    owner.AnimState:Hide("ARM_carry") --隐藏持物手
    owner.AnimState:Show("ARM_normal") --显示普通的手
    owner.AnimState:ClearOverrideSymbol("lantern_overlay")
    owner.AnimState:Hide("LANTERN_OVERLAY")
    owner.AnimState:ShowSymbol("swap_object")

    --清除自己的redirectdamagefn函数
    if owner.redirect_table ~= nil then
        owner.redirect_table[inst.prefab] = nil
    end

    if owner.components.locomotor ~= nil then
        owner._runinsandstorm = false
    end
end

local function SetNoBrokenArmor(inst, exfn)
    inst.components.armor.SetCondition = function(self, amount)
        if self.indestructible then
            return
        end

        local amountold = self.condition
        self.condition = math.min(amount, self.maxcondition)
        local _brokenshield = inst._brokenshield

        if self.condition <= 0 then
            self.condition = 0
            -- ProfileStatsSet("armor_broke_"..self.inst.prefab, true)
            -- ProfileStatsSet("armor", self.inst.prefab)
            -- if self.onfinished ~= nil then
            --     self.onfinished()
            -- end
            -- self.inst:Remove()
            inst._brokenshield = true
            inst.components.shieldlegion.canatk = false
        else
            inst._brokenshield = false
            inst.components.shieldlegion.canatk = true
        end

        if amountold ~= self.condition then
            self.inst:PushEvent("percentusedchange", { percent = self:GetPercent() })
            exfn(self, _brokenshield)
        end
    end
end

local function MakeShield(data)
	table.insert(prefs, Prefab(
		data.name,
		function()
            local inst = CreateEntity()--创建一个实体，常见的各种inst，根源就是在这里。
            inst.entity:AddTransform()--给实体添加转换组件，这主要涉及的是空间位置的转换和获取
            inst.entity:AddAnimState()--给实体添加动画组件，从而实体能在游戏上显示出来。
            inst.entity:AddNetwork()

            MakeInventoryPhysics(inst)

            inst.AnimState:SetBank(data.name)--设置实体的bank，动画模板，包含了动画的名称、运动轨迹、全部通道数据
            inst.AnimState:SetBuild(data.name)--设置实体的build，贴图模板，包含了贴图、中心点
            inst.AnimState:PlayAnimation("idle")--设置实体播放的动画

            inst:AddTag("combatredirect")   --代表这个武器会给予伤害对象重定义函数
            inst:AddTag("allow_action_on_impassable")
            -- inst:AddTag("toolpunch")

            --weapon (from weapon component) added to pristine state for optimization
            inst:AddTag("weapon")

            if data.fn_common ~= nil then
                data.fn_common(inst)
            end

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst:AddComponent("inspectable") --可检查组件

            inst:AddComponent("inventoryitem")  --添加物品栏物品组件，只有有了这个组件，你才能把这个物品捡起放到物品栏里。
            inst.components.inventoryitem.imagename = data.name
            inst.components.inventoryitem.atlasname = "images/inventoryimages/"..data.name..".xml"

            inst:AddComponent("shieldlegion")

            inst:AddComponent("equippable")--添加可装备组件，有了这个组件，你才能装备物品
            inst.components.equippable.equipslot = EQUIPSLOTS.HANDS

            inst:AddComponent("weapon") --增加武器组件

            inst:AddComponent("armor")  --增加防具组件

            MakeHauntableLaunch(inst)  --作祟相关函数

            if data.fn_server ~= nil then
                data.fn_server(inst)
            end

            return inst
		end,
		data.assets,
		data.prefabs
	))
end

--------------------------------------------------------------------------
--[[ 砂之抵御 ]]
--------------------------------------------------------------------------

if TUNING.LEGION_DESERTSECRET then
    local damage_sandstorms = 42.5  --34*1.25
    local damage_normal = 30.6      --34*0.9
    local damage_raining = 17       --34*0.5
    local damage_broken = 3.4       --34*0.1

    local absorb_sandstorms = 0.9
    local absorb_normal = 0.75
    local absorb_raining = 0.4
    local absorb_broken = 0.1

    local mult_success_sandstorms = 0
    local mult_success_normal = 0.15
    local mult_success_raining = 0.4

    local mult_ranged_sandstorms = 0
    local mult_ranged_normal = 0.5
    local mult_ranged_raining = 1

    local function OnBlocked(owner, data)
        -- owner.SoundEmitter:PlaySound("dontstarve/common/together/teleport_sand/out")    --被攻击时播放像沙的声音
        owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_scalemail")

        if not TheWorld.state.israining then    --没下雨时被攻击就释放法术
            if
                data.attacker ~= nil and
                data.attacker.components.combat ~= nil and --攻击者有战斗组件
                data.attacker.components.health ~= nil and --攻击者有生命组件
                not data.attacker.components.health:IsDead() and --攻击者没死亡
                (data.weapon == nil or ((data.weapon.components.weapon == nil or data.weapon.components.weapon.projectile == nil) and data.weapon.components.projectile == nil)) and --不是远程武器
                not data.redirected
            then
                local map = TheWorld.Map
                local x, y, z = data.attacker.Transform:GetWorldPosition()
                if not map:IsVisualGroundAtPoint(x, 0, z) then --攻击者在水中，被动无效
                    return
                end

                local num = 1
                local plus = 1.2
                if (owner.components.areaaware ~= nil and owner.components.areaaware:CurrentlyInTag("sandstorm"))
                    and (not TheWorld:HasTag("cave") and TheWorld.state.issummer)
                then
                    plus = 2.4
                    num = math.random(3, 6)
                else
                    num = math.random(1, 2)
                end

                for i = 1, num do
                    local rad = math.random() * plus
                    local angle = math.random() * 2 * PI
                    local xxx = x + rad * math.cos(angle)
                    local zzz = z - rad * math.sin(angle)

                    if map:IsVisualGroundAtPoint(xxx, 0, zzz) then --不在水中
                        local sspike = SpawnPrefab("sandspike_legion")
                        if sspike ~= nil then
                            sspike.iscounterattack = true
                            sspike.Transform:SetPosition(xxx, 0, zzz)
                        end
                    end
                end
            end
        end
    end
    local function onsandstorm(owner)    --沙尘暴中属性上升
        local shield = owner ~= nil and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil

        if shield == nil or shield.prefab ~= "shield_l_sand" then
            return
        end

        if shield._brokenshield then
            shield.components.weapon:SetDamage(damage_broken)
            shield.components.armor:SetAbsorption(absorb_broken)
            return
        end

        --if TheWorld.components.sandstorms ~= nil and TheWorld.components.sandstorms:IsSandstormActive() then
        if not TheWorld:HasTag("cave") and TheWorld.state.issummer then
            --处于沙暴之中时
            if owner ~= nil and owner.components.areaaware ~= nil and owner.components.areaaware:CurrentlyInTag("sandstorm") then
                shield.components.weapon:SetDamage(damage_sandstorms)
                shield.components.armor:SetAbsorption(absorb_sandstorms)
                shield.components.shieldlegion.armormult_success = mult_success_sandstorms
                shield.components.shieldlegion.armormult_ranged = mult_ranged_sandstorms
                return
            end
        end
        shield.components.weapon:SetDamage(damage_normal)
        shield.components.armor:SetAbsorption(absorb_normal)
        shield.components.shieldlegion.armormult_success = mult_success_normal
        shield.components.shieldlegion.armormult_ranged = mult_ranged_normal
    end
    local function onisraining(inst)    --下雨时属性降低
        local owner = inst.components.inventoryitem.owner

        if TheWorld.state.israining then
            if owner ~= nil then owner:RemoveEventCallback("changearea", onsandstorm) end
            if inst._brokenshield then
                inst.components.weapon:SetDamage(damage_broken)
                inst.components.armor:SetAbsorption(absorb_broken)
            else
                inst.components.weapon:SetDamage(damage_raining)
                inst.components.armor:SetAbsorption(absorb_raining)
                inst.components.shieldlegion.armormult_success = mult_success_raining
                inst.components.shieldlegion.armormult_ranged = mult_ranged_raining
            end
        else
            if inst._brokenshield then
                inst.components.weapon:SetDamage(damage_broken)
                inst.components.armor:SetAbsorption(absorb_broken)
            else
                onsandstorm(owner)   --不下雨时就刷新一次
            end
            if not TheWorld:HasTag("cave") and TheWorld.state.issummer then --不是在洞穴里，并且夏天时才会开始沙尘暴的监听
                if owner ~= nil then
                    owner:ListenForEvent("changearea", onsandstorm) --因为这个消息由玩家发出，所以只好由玩家来监听了
                end
            end
        end
    end

    MakeShield({
        name = "shield_l_sand",
        assets = {
            Asset("ANIM", "anim/shield_l_sand.zip"),
            Asset("ATLAS", "images/inventoryimages/shield_l_sand.xml"),
            Asset("IMAGE", "images/inventoryimages/shield_l_sand.tex"),
        },
        prefabs = {
            "sandspike_legion",    --对玩家友好的沙之咬
            "shield_attack_l_fx",
        },
        fn_common = function(inst)
            inst:AddComponent("skinedlegion")
            inst.components.skinedlegion:Init("shield_l_sand")
        end,
        fn_server = function(inst)
            inst.components.inventoryitem:SetSinks(true) --它是石头做的，应该要沉入水底

            inst.components.equippable:SetOnEquip(function(inst, owner)
                OnEquipFn(inst, owner)
                onisraining(inst)   --装备时先更新一次

                inst:ListenForEvent("blocked", OnBlocked, owner)
                inst:ListenForEvent("attacked", OnBlocked, owner)

                inst:WatchWorldState("israining", onisraining)
                inst:WatchWorldState("issummer", onisraining)

                --能在沙暴中不减速行走
                if owner.components.locomotor ~= nil then
                    if owner._runinsandstorm == nil then
                        local oldfn = owner.components.locomotor.SetExternalSpeedMultiplier
                        owner.components.locomotor.SetExternalSpeedMultiplier = function(self, source, key, m)
                            if self.inst._runinsandstorm and key == "sandstorm" then
                                self:RemoveExternalSpeedMultiplier(self.inst, "sandstorm")
                                return
                            end
                            oldfn(self, source, key, m)
                        end
                    end
                    -- owner.components.locomotor:RemoveExternalSpeedMultiplier(owner, "sandstorm") --切换装备时，下一帧会自动更新移速
                    owner._runinsandstorm = true
                end
            end)
            inst.components.equippable:SetOnUnequip(function(inst, owner)
                inst:RemoveEventCallback("blocked", OnBlocked, owner)
                inst:RemoveEventCallback("attacked", OnBlocked, owner)

                owner:RemoveEventCallback("changearea", onsandstorm)
                inst:StopWatchingWorldState("israining", onisraining)
                inst:StopWatchingWorldState("issummer", onisraining)

                OnUnequipFn(inst, owner)
            end)
            inst.components.equippable.insulated = true --设为true，就能防电

            inst.components.shieldlegion.armormult_success = mult_success_normal
            inst.components.shieldlegion.armormult_ranged = mult_ranged_normal
            inst.components.shieldlegion.atkfn = function(inst, doer, attacker, data)
                local snap = SpawnPrefab("impact")
                local x, y, z = doer.Transform:GetWorldPosition()
                snap.Transform:SetScale(2, 2, 2)
                snap.Transform:SetPosition(x, y, z)

                OnBlocked(doer, { attacker = attacker })

                if inst.components.shieldlegion:Counterattack(doer, attacker, data, 8, 4) then --此时敌人近
                    local x1, y1, z1 = attacker.Transform:GetWorldPosition()
                    local angle = -math.atan2(z1 - z, x1 - x)
                    snap.Transform:SetRotation(angle * RADIANS)
                    snap.Transform:SetPosition(x1, y1, z1)
                else
                    snap.Transform:SetPosition(x, y, z)
                end
            end
            inst.components.shieldlegion.atkstayingfn = function(inst, doer, attacker, data)
                inst.components.shieldlegion:Counterattack(doer, attacker, data, 8, 4)
            end
            inst.components.shieldlegion.atkfailfn = function(inst, doer, attacker, data)
                inst.components.shieldlegion:Counterattack(doer, attacker, data, 4, 0.4) --即使盾反失败也要攻击一下
            end

            inst.components.weapon:SetDamage(damage_normal)

            inst.components.armor:InitCondition(1050, absorb_normal) --150*10*0.7= 1050防具耐久
            SetNoBrokenArmor(inst, function(armorcpt, isbrokenbefore)
                if armorcpt.condition <= 0 then
                    inst:AddTag("repair_sand")
                    inst.components.equippable.insulated = false
                    inst.components.weapon:SetDamage(damage_broken)
                    inst.components.armor:SetAbsorption(absorb_broken)
                else
                    if armorcpt.condition >= armorcpt.maxcondition then
                        inst:RemoveTag("repair_sand")
                    else
                        inst:AddTag("repair_sand")
                    end
                    if isbrokenbefore then --说明是刚从损坏状态变成修复状态
                        inst.components.equippable.insulated = true
                        onisraining(inst)
                    end
                end
            end)

            inst.components.skinedlegion:SetOnPreLoad()
        end,
    })
end

--------------------------------------------------------------------------
--[[ 木盾 ]]
--------------------------------------------------------------------------

MakeShield({
    name = "shield_l_log",
    assets = {
        Asset("ANIM", "anim/shield_l_log.zip"),
        Asset("ATLAS", "images/inventoryimages/shield_l_log.xml"),
        Asset("IMAGE", "images/inventoryimages/shield_l_log.tex"),
    },
    prefabs = {
        "sandspike_legion",    --对玩家友好的沙之咬
        "shield_attack_l_fx",
    },
    fn_common = function(inst)
        MakeInventoryFloatable(inst, "small", 0.2, 0.9)
        -- local OnLandedClient_old = inst.components.floater.OnLandedClient
        -- inst.components.floater.OnLandedClient = function(self)
        --     OnLandedClient_old(self)
        --     self.inst.AnimState:SetFloatParams(0.15, 1, self.bob_percent)
        -- end

        -- inst:AddComponent("skinedlegion")
        -- inst.components.skinedlegion:Init("shield_l_log")
    end,
    fn_server = function(inst)
        inst.components.equippable:SetOnEquip(OnEquipFn)
        inst.components.equippable:SetOnUnequip(OnUnequipFn)

        inst.components.shieldlegion.armormult_success = 0.25
        inst.components.shieldlegion.armormult_ranged = 0.7
        inst.components.shieldlegion.atkfn = function(inst, doer, attacker, data)
            local snap = SpawnPrefab("impact")
            local x, y, z = doer.Transform:GetWorldPosition()
            snap.Transform:SetScale(2, 2, 2)
            snap.Transform:SetPosition(x, y, z)

            if inst.components.shieldlegion:Counterattack(doer, attacker, data, 6, 2.5) then --此时敌人近
                local x1, y1, z1 = attacker.Transform:GetWorldPosition()
                local angle = -math.atan2(z1 - z, x1 - x)
                snap.Transform:SetRotation(angle * RADIANS)
                snap.Transform:SetPosition(x1, y1, z1)
            else
                snap.Transform:SetPosition(x, y, z)
            end
        end
        inst.components.shieldlegion.atkstayingfn = function(inst, doer, attacker, data)
            inst.components.shieldlegion:Counterattack(doer, attacker, data, 6, 2.5)
        end
        inst.components.shieldlegion.atkfailfn = function(inst, doer, attacker, data)
            inst.components.shieldlegion:Counterattack(doer, attacker, data, 4, 0.1) --即使盾反失败也要攻击一下
        end

        inst.components.weapon:SetDamage(27.2) --34*0.8

        inst.components.armor:InitCondition(525, 0.6) --150*5*0.7= 525防具耐久
        inst.components.armor:AddWeakness("beaver", TUNING.BEAVER_WOOD_DAMAGE)

        inst:AddComponent("fuel")
        inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

        MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
        MakeSmallPropagator(inst)

        -- inst.components.skinedlegion:SetOnPreLoad()
    end,
})

--------------------
--------------------

return unpack(prefs)