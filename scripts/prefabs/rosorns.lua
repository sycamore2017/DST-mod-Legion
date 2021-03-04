local assets =
{
    Asset("ANIM", "anim/rosorns.zip"),--这个是放在地上的动画文件
    Asset("ANIM", "anim/swap_rosorns.zip"), --这个是手上动画
    Asset("ATLAS", "images/inventoryimages/rosorns.xml"),
    Asset("IMAGE", "images/inventoryimages/rosorns.tex"),
}

local function OnEquip(inst, owner) --装备武器时
    --这句话的含义是，用swap_myitem_build这个文件里的swap_myitem这个symbol，
    --覆盖人物的swap_object这个symbol。swap_object，是人物身上的一个symbol，
    --swap_myitem_build，则是我们之前准备好的，用于手持武器的build，
    --swap_myitem就是存放手持武器的图片的文件夹的名字，mod tools自动把它输出为一个symbol。
    owner.AnimState:OverrideSymbol("swap_object", "swap_rosorns", "swap_rosorns")
    owner.AnimState:Show("ARM_carry") --显示持物手
    owner.AnimState:Hide("ARM_normal") --隐藏普通的手
end

local function OnUnequip(inst, owner)   --放下武器时
    owner.AnimState:Hide("ARM_carry") --隐藏持物手
    owner.AnimState:Show("ARM_normal") --显示普通的手
end

local function onattack(inst, owner, target)    --攻击直接扣血，而不考虑防御系数
    if
        target ~= nil and target:IsValid()
        and not target:HasTag("alwaysblock")    --有了这个标签，什么天神都伤害不了
        and target.prefab ~= "laozi"        --无法伤害神话书说里的太上老君
        and target.components.health ~= nil and not target.components.health:IsDead() --已经死亡则不再攻击
    then
        --获取电击buff攻击加成
        local multiplier =
            owner.components.electricattacks ~= nil
            and not (
                    target:HasTag("electricdamageimmune") or
                    (target.components.inventory ~= nil and target.components.inventory:IsInsulated())
                )
            and TUNING.ELECTRIC_DAMAGE_MULT + TUNING.ELECTRIC_WET_DAMAGE_MULT * (target.components.moisture ~= nil and target.components.moisture:GetMoisturePercent() or (target:GetIsWet() and 1 or 0))
            or 1

        ------------------------------------

        --计算最终数值
        local self = owner.components.combat
        local pvpmultiplier = target:HasTag("player") and self.inst:HasTag("player") and self.pvp_damagemod or 1

        local resultDamage = 51
            * (self.damagemultiplier or 1)
            * self.externaldamagemultipliers:Get()
            * multiplier
            * pvpmultiplier
            * (self.customdamagemultfn ~= nil and self.customdamagemultfn(self.inst, target, inst, multiplier) or 1) --温蒂的加成
            + (self.damagebonus or 0)

        ------------------------------------

        local damageNum = resultDamage > 0 and resultDamage or 0 --保证伤害值不为负数

        --最后的参数为无视防御，倒数第二个参数为攻击者
        target.components.health:DoDelta(-damageNum, nil, (inst.nameoverride or inst.prefab), true, owner, true)

        --推出事件，让被攻击者能播放被攻击动画，并标记仇恨，武器攻击力为0时才需要这句话，后面代码也是如此
        target:PushEvent("attacked", { attacker = owner, damage = damageNum, damageresolved = damageNum, weapon = inst })
        if target.components.combat ~= nil and target.components.combat.onhitfn ~= nil then
            target.components.combat.onhitfn(target, owner, damageNum)
        end

        owner:PushEvent("onhitother", { target = target, damage = damageNum, damageresolved = damageNum, weapon = inst })
        if self ~= nil and self.onhitotherfn ~= nil then
            self.onhitotherfn(owner, target, damageNum, nil)
        end

        if target.components.health:IsDead() then
            owner:PushEvent("killed", { victim = target })

            if target.components.combat ~= nil and target.components.combat.onkilledbyother ~= nil then
                target.components.combat.onkilledbyother(target, owner)
            end
        end
    end
end

--这个函数就是实际创建物体的函数，上面所有定义到的函数，变量，都需要直接或者间接地在这个函数中使用，才能起作用
local function fn()
    local inst = CreateEntity()--创建一个实体，常见的各种inst，根源就是在这里。

    inst.entity:AddTransform()--给实体添加转换组件，这主要涉及的是空间位置的转换和获取
    inst.entity:AddAnimState()--给实体添加动画组件，从而实体能在游戏上显示出来。
    inst.entity:AddNetwork()

    --给实体设定为"物品"的物理属性，这是一个写在data\scripts\standardcomponents里的标准函数，
    --类似的还有MakeCharacterPhysics，就是设定"人物"的物理属性，基本上所有会动的生物，都会有MakeCharacterPhysics
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("rosorns")--设置实体的bank，此处是指放在地上的时候，下同
    inst.AnimState:SetBuild("rosorns")--设置实体的build
    inst.AnimState:PlayAnimation("idle")--设置实体播放的动画

    inst:AddTag("sharp") --武器的标签跟攻击方式跟攻击音效有关 没有特殊的话就用这两个
    inst:AddTag("pointy")
    inst:AddTag("show_spoilage")    --显示新鲜度
    inst:AddTag("icebox_valid")     --能装进冰箱

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "small", 0.4, 0.5)
    local OnLandedClient_old = inst.components.floater.OnLandedClient
    inst.components.floater.OnLandedClient = function(self)
        OnLandedClient_old(self)
        self.inst.AnimState:SetFloatParams(0.15, 1, 0.1)
    end

    inst.entity:SetPristine()

    --如果不是主机，直接返回(也就是后面的代码客机不需要加载，只需要主机执行)，让大部分的代码快只需要主机运行，减少客机的负担
    if not TheWorld.ismastersim then 
        return inst
    end

    inst:AddComponent("inventoryitem")--添加物品栏物品组件，只有有了这个组件，你才能把这个物品捡起放到物品栏里。
    inst.components.inventoryitem.imagename = "rosorns"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/rosorns.xml"

    inst:AddComponent("inspectable") --可检查组件

    inst:AddComponent("equippable")--添加可装备组件，有了这个组件，你才能装备物品  
    --设定物品在装备和卸下时执行的函数。在前面定义的两个函数是OnEquip，OnUnequip里，
    --我们主要是围绕着改变人物外形设定了一些基本代码。 在装上的时候，会让人物的持物手显示出来，普通手隐藏，卸下时则反过来。
    --需要注意的是，OnEquip，OnUnequip都是本地函数，要想让它们发挥作用，就必须要通过这里的组件接口来实现。
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    inst:AddComponent("weapon") --增加武器组件 有了这个才可以打人
    inst.components.weapon:SetDamage(0) --设置伤害，如果为0会吸引不了仇恨、不触发被攻击动画，击杀影怪也不加精神
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("perishable") --会腐烂
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FASTISH)   --8*total_day_time*perish_warp,
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)  --作祟相关函数

    return inst
end

return Prefab("rosorns", fn, assets)