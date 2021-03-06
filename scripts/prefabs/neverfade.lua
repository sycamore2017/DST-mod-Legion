local assets =
{
    Asset("ANIM", "anim/neverfade.zip"),--这个是放在地上的动画文件

     --正常的动画
    Asset("ANIM", "anim/swap_neverfade.zip"),
    Asset("ATLAS", "images/inventoryimages/neverfade.xml"),
    Asset("IMAGE", "images/inventoryimages/neverfade.tex"),

    --破损的动画
    Asset("ANIM", "anim/swap_neverfade_broken.zip"),
    Asset("ATLAS", "images/inventoryimages/neverfade_broken.xml"),
    Asset("IMAGE", "images/inventoryimages/neverfade_broken.tex"),

    Asset("ANIM", "anim/neverfadebush.zip"),--花丛的动画
}

local prefabs =
{
    "neverfadebush",
    -- "neverfade_butterfly",
    "neverfade_shield",
    "buff_butterflysblessing",
}

local function onequip(inst, owner) --装备武器时
    if inst.hasSetBroken then
        owner.AnimState:OverrideSymbol("swap_object", "swap_neverfade_broken", "swap_neverfade_broken")
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_neverfade", "swap_neverfade")

        if owner.components.health ~= nil then
            inst.healthRedirect_old = owner.components.health.redirect --记下原有的函数，方便以后恢复

            owner.components.health.redirect = function(ow, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
                local self = ow.components.health

                if not ignore_invincible and (self.invincible or self.inst.is_teleporting) then --无敌
                    return true
                elseif amount < 0 then  --是伤害，不是恢复
                    if not ignore_absorb then   --不忽略对伤害的吸收，则进行吸收的计算
                        amount = amount - amount * (self.playerabsorb ~= 0 and afflicter ~= nil and afflicter:HasTag("player") and self.playerabsorb + self.absorb or self.absorb)
                    end

                    if self.currenthealth > 0 and self.currenthealth + amount <= 0 then --刚好死掉
                        inst.components.finiteuses:Use(250) --直接坏掉，以此来保住持有者生命

                        local fx = SpawnPrefab("neverfade_shield") --护盾特效
                        fx.entity:SetParent(ow.entity)

                        return true
                    end
                end

                --如果上面的条件都不满足，就直接返回原来的函数
                if inst.healthRedirect_old ~= nil then
                    return inst.healthRedirect_old(ow, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
                end
            end
        end
    end

    owner.AnimState:Show("ARM_carry") --显示持物手
    owner.AnimState:Hide("ARM_normal") --隐藏普通的手

    inst.components.deployable:SetDeployMode(DEPLOYMODE.NONE) --装备时去除可栽种功能
end

local function onunequip(inst, owner)   --放下武器时
    owner.AnimState:Hide("ARM_carry") --隐藏持物手
    owner.AnimState:Show("ARM_normal") --显示普通的手

    if not inst.hasSetBroken then
        if owner.components.health ~= nil then
            owner.components.health.redirect = inst.healthRedirect_old
        end
        inst.healthRedirect_old = nil
    end
    inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT) --卸下时恢复可摆栽种功能
end

local function IsValidVictim(victim)
    return victim ~= nil
        and not ((victim:HasTag("prey") and not victim:HasTag("hostile")) or
                victim:HasTag("veggie") or
                victim:HasTag("structure") or
                victim:HasTag("wall"))
        and victim.components.health ~= nil
        and victim.components.combat ~= nil
end

local function onattack(inst, owner, target)
    if owner.countblessing == nil then
        owner.countblessing = 0
    end
    if owner.countblessing < 3 then --最多3只庇佑蝴蝶
        if IsValidVictim(target) then
            inst.attackTrigger = inst.attackTrigger + 1

            if inst.attackTrigger >= 10 then   --如果达到10，添加buff
                if owner.components.debuffable ~= nil and owner.components.debuffable:IsEnabled() and
                    not (owner.components.health ~= nil and owner.components.health:IsDead()) and
                    not owner:HasTag("playerghost") then
                    owner.components.debuffable:AddDebuff("buff_butterflysblessing", "buff_butterflysblessing")
                end
                inst.attackTrigger = 0
            end
        end
    end
end

local function onfinished(inst)
    if not inst.hasSetBroken then
        inst.components.weapon:SetDamage(TUNING.TORCH_DAMAGE)   --17攻击力
        inst.components.weapon:SetOnAttack(nil)

        --改变物品栏图片，先改atlasname，再改贴图
        inst.components.inventoryitem.atlasname = "images/inventoryimages/neverfade_broken.xml"
        inst.components.inventoryitem:ChangeImageName("neverfade_broken")

        -- inst.components.equippable.dapperness = 0
        if inst.components.equippable:IsEquipped() then
            local owner = inst.components.inventoryitem.owner
            if owner ~= nil then
                owner.AnimState:OverrideSymbol("swap_object", "swap_neverfade_broken", "swap_neverfade_broken")

                if owner.components.health ~= nil then
                    owner.components.health.redirect = inst.healthRedirect_old
                end
                inst.healthRedirect_old = nil

                if owner.SoundEmitter ~= nil then   --发出破碎的声音
                    owner.SoundEmitter:PlaySound("dontstarve/common/together/moonbase/repair")
                end
            end
        end

        inst.hasSetBroken = true
        inst.attackTrigger = 0
    end
end

local function OnRecovered(inst) --每次被剑鞘恢复时执行的函数
    local newvalue = inst.components.finiteuses:GetUses() + 1
    if newvalue <= inst.components.finiteuses.total then
        inst.components.finiteuses:SetUses(newvalue)

        if inst.hasSetBroken then
            inst.components.weapon:SetDamage(55)
            inst.components.weapon:SetOnAttack(onattack)

            --改变物品栏图片，先改atlasname，再改贴图
            inst.components.inventoryitem.atlasname = "images/inventoryimages/neverfade.xml"
            inst.components.inventoryitem:ChangeImageName("neverfade")

            inst.hasSetBroken = false
        end
    end

    if newvalue >= inst.components.finiteuses.total and inst.task_recover ~= nil then
        inst.task_recover:Cancel()
        inst.task_recover = nil
    end
end

local function ondeploy(inst, pt, deployer) --这里是右键种植时的函数
    local tree = SpawnPrefab("neverfadebush")
    if tree ~= nil then
        tree.Transform:SetPosition(pt:Get())
        inst:Remove()
        tree.components.pickable:OnTransplant()
        if deployer ~= nil and deployer.SoundEmitter ~= nil then
            deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("neverfade")--设置实体的bank，此处是指放在地上的时候，下同
    inst.AnimState:SetBuild("neverfade")--设置实体的build
    inst.AnimState:PlayAnimation("idle")--设置实体播放的动画

    inst:AddTag("sharp") --武器的标签跟攻击方式跟攻击音效有关 没有特殊的话就用这两个
    inst:AddTag("pointy")
    -- inst:AddTag("hide_percentage")  --这个标签能让耐久比例不显示出来
    inst:AddTag("deployedplant")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", 0.4, 0.5)
    local OnLandedClient_old = inst.components.floater.OnLandedClient
    inst.components.floater.OnLandedClient = function(self)
        OnLandedClient_old(self)
        self.inst.AnimState:SetFloatParams(0.12, 1, 0.1)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.hasSetBroken = false
    inst.attackTrigger = 0
    inst.healthRedirect_old = nil
    inst.OnScabbardRecoveredFn = OnRecovered

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "neverfade"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/neverfade.xml"

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    -- inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED   --高礼帽般的回复精神效果

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(55)
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(250)
    inst.components.finiteuses:SetUses(250)
    inst.components.finiteuses:SetOnFinished(onfinished)

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)   --草根一样的种植所需范围

    MakeHauntableLaunch(inst)  --作祟相关函数

    return inst
end

return Prefab("neverfade", fn, assets, prefabs),
        MakePlacer("neverfade_placer", "berrybush2", "neverfadebush", "dead")