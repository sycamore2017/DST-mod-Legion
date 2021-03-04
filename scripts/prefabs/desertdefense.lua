local assets =
{
    Asset("ANIM", "anim/desertdefense.zip"),--这个是放在地上的动画文件
    Asset("ANIM", "anim/swap_desertdefense.zip"), --这个是手上动画
    --Asset("ANIM", "anim/swap_desertdefense_combat.zip"), --这个是攻击时的动画
    Asset("ATLAS", "images/inventoryimages/desertdefense.xml"),
    Asset("IMAGE", "images/inventoryimages/desertdefense.tex"),
}

local prefabs =
{
    "sandspike_legion",    --对玩家友好的沙之咬
}

local damage_sandstorms = 42.5  --34*1.25
local damage_normal = 30.6      --34*0.9
local damage_raining = 17       --34*0.5

local absorb_sandstorms = 0.8
local absorb_normal = 0.6
local absorb_raining = 0.4

local function removespike(sspike)   --删除生成的沙咬
    if sspike ~= nil and sspike.components.health ~= nil then
        sspike.components.health:DoDelta(-200)
    end
end

local function OnBlocked(owner, data)
    -- owner.SoundEmitter:PlaySound("dontstarve/common/together/teleport_sand/out")    --被攻击时播放像沙的声音
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_scalemail")

    if not TheWorld.state.israining then    --没下雨时被攻击就释放法术
        if data.attacker ~= nil and
            data.attacker.components.combat ~= nil and --攻击者有战斗组件
            data.attacker.components.health ~= nil and --攻击者有生命组件
            not data.attacker.components.health:IsDead() and --攻击者没死亡
            (data.weapon == nil or ((data.weapon.components.weapon == nil or data.weapon.components.weapon.projectile == nil) and data.weapon.components.projectile == nil)) and --不是远程武器
            not data.redirected and
            not data.attacker:HasTag("thorny") then --不是因采集而受伤

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
                        sspike.Transform:SetPosition(xxx, 0, zzz)
                        sspike:ListenForEvent("animover", removespike, sspike)
                    end
                end
            end
        end
    end
end

local function onsandstorm(owner)    --沙尘暴中属性上升
    local shield = owner ~= nil and owner.components.inventory ~= nil and owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) or nil

    if shield == nil or (shield ~= nil and shield.prefab ~= "desertdefense") then
        return
    end

    --if TheWorld.components.sandstorms ~= nil and TheWorld.components.sandstorms:IsSandstormActive() then
    if not TheWorld:HasTag("cave") and TheWorld.state.issummer then
        if owner ~= nil and owner.components.areaaware ~= nil and owner.components.areaaware:CurrentlyInTag("sandstorm") then   --处于沙暴之中时
            if shield.components.weapon ~= nil then shield.components.weapon:SetDamage(damage_sandstorms) end

            if shield.components.armor ~= nil then shield.components.armor:SetAbsorption(absorb_sandstorms) end

            return  --赶紧退出，继续运行会导致恢复默认属性
        end
    end

    if shield.components.weapon ~= nil then shield.components.weapon:SetDamage(damage_normal) end

    if shield.components.armor ~= nil then shield.components.armor:SetAbsorption(absorb_normal) end
end

local function onisraining(inst)    --下雨时属性降低
    local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner

    if TheWorld.state.israining then
        if owner ~= nil then owner:RemoveEventCallback("changearea", onsandstorm) end

        if inst.components.weapon ~= nil then inst.components.weapon:SetDamage(damage_raining) end

        if inst.components.armor ~= nil then inst.components.armor:SetAbsorption(absorb_raining) end
    else
        onsandstorm(owner)   --不下雨时就刷新一次
        if not TheWorld:HasTag("cave") and TheWorld.state.issummer then --不是在洞穴里，并且夏天时才会开始沙尘暴的监听         
            if owner ~= nil then
                owner:ListenForEvent("changearea", onsandstorm) --因为这个消息由玩家发出，所以只好由玩家来监听了
            end
        end 
    end
end

local function OnEquip(inst, owner) --装备武器时
    owner.AnimState:OverrideSymbol("swap_object", "swap_desertdefense", "swap_desertdefense")

    --本来是想让这个和书本的攻击一样来低频率高伤害的方式攻击，但是由于会导致读书时也用本武器来显示动画，所以干脆去除了
    --owner.AnimState:OverrideSymbol("book_open", "swap_book_elemental", "book_open")
    --owner.AnimState:OverrideSymbol("book_closed", "swap_desertdefense_combat", "book_closed")    --替换book_closed就能正确显示特殊攻击动画
    --owner.AnimState:OverrideSymbol("book_open_pages", "swap_book_elemental", "book_open_pages")

    owner.AnimState:Show("ARM_carry") --显示持物手
    owner.AnimState:Hide("ARM_normal") --隐藏普通的手
 
    onisraining(inst)   --装备时先更新一次

    inst:ListenForEvent("blocked", OnBlocked, owner)
    inst:ListenForEvent("attacked", OnBlocked, owner)
    
    inst:WatchWorldState("israining", onisraining)
    inst:WatchWorldState("issummer", onisraining)

    --初始化
    if owner.redirect_table == nil then
        owner.redirect_table = {}
    end
    RebuildRedirectDamageFn(owner) --全局函数：重新构造combat的redirectdamagefn函数
    --登记远程保护的函数
    if owner.redirect_table[inst.prefab] == nil then
        owner.redirect_table[inst.prefab] = function(victim, attacker, damage, weapon, stimuli)
            --远程武器分为两类，一类是有projectile组件、一类是weapon组件中有projectile属性
            if weapon ~= nil and (weapon.components.projectile ~= nil 
                or (weapon.components.weapon ~= nil and weapon.components.weapon.projectile ~= nil)) then
                    if inst.components.armor ~= nil then inst.components.armor:TakeDamage(damage) end
                    return inst     --只要这里不为nil，就能吸收所有远程伤害，反正武器没有health组件，所以在伤害计算时会直接被判断给取消掉
            end
            return nil
        end
    end
end

local function OnUnequip(inst, owner)   --放下武器时
    --owner.AnimState:ClearOverrideSymbol("book_closed")

    owner.AnimState:Hide("ARM_carry") --隐藏持物手
    owner.AnimState:Show("ARM_normal") --显示普通的手

    inst:RemoveEventCallback("blocked", OnBlocked, owner)
    inst:RemoveEventCallback("attacked", OnBlocked, owner)

    owner:RemoveEventCallback("changearea", onsandstorm)
    inst:StopWatchingWorldState("israining", onisraining)
    inst:StopWatchingWorldState("issummer", onisraining)

    --清除自己的redirectdamagefn函数
    if owner.redirect_table ~= nil then
        owner.redirect_table[inst.prefab] = nil
    end
end

------------------------------------------

local function fn()
    local inst = CreateEntity()--创建一个实体，常见的各种inst，根源就是在这里。

    inst.entity:AddTransform()--给实体添加转换组件，这主要涉及的是空间位置的转换和获取
    inst.entity:AddAnimState()--给实体添加动画组件，从而实体能在游戏上显示出来。
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("desertdefense")--设置实体的bank，此处是指放在地上的时候，下同
    inst.AnimState:SetBuild("desertdefense")--设置实体的build
    inst.AnimState:PlayAnimation("idle")--设置实体播放的动画

    inst:AddTag("combatredirect")   --代表这个武器会给予伤害对象重定义函数

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    -- MakeInventoryFloatable(inst, "med", 0.1, {1.1, 0.5, 1.1}, true, -9, {
    --     sym_build = "swap_desertdefense",
    --     sym_name = "swap_desertdefense",
    --     bank = "desertdefense",
    --     anim = "idle"
    -- })

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then 
        return inst
    end

    inst:AddComponent("inventoryitem")  --添加物品栏物品组件，只有有了这个组件，你才能把这个物品捡起放到物品栏里。
    inst.components.inventoryitem.imagename = "desertdefense"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/desertdefense.xml"
    inst.components.inventoryitem:SetSinks(true) --它是石头做的，应该要沉入水底

    inst:AddComponent("inspectable") --可检查组件

    inst:AddComponent("equippable")--添加可装备组件，有了这个组件，你才能装备物品
    inst.components.equippable.equipslot = EQUIPSLOTS.HANDS
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable.insulated = true --设为true，就能防电

    inst:AddComponent("weapon") --增加武器组件
    inst.components.weapon:SetDamage(damage_normal)

    inst:AddComponent("armor")  --增加防具组件
    inst.components.armor:InitCondition(TUNING.ARMORMARBLE, absorb_normal)    --150*7*0.7= 735防具耐久

    MakeHauntableLaunch(inst)  --作祟相关函数

    return inst
end

return Prefab("desertdefense", fn, assets, prefabs)