local prefs = {}

--------------------------------------------------------------------------
--[[ 通用 ]]
--------------------------------------------------------------------------

local function MakeBoss(data)
    table.insert(prefs, Prefab(
        data.name,
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddSoundEmitter()
            inst.entity:AddDynamicShadow()
            inst.entity:AddNetwork()

            inst.DynamicShadow:SetSize(2.5, 1.5)
            inst.Transform:SetScale(1.5, 1.5, 1.5)
            inst.Transform:SetFourFaced()

            MakeGiantCharacterPhysics(inst, 500, 0.5)

            inst:AddTag("epic")
            inst:AddTag("hostile")
            inst:AddTag("largecreature")
            inst:AddTag("siving")

            inst.AnimState:SetBank("buzzard")

            if data.fn_common ~= nil then
                data.fn_common(inst)
            end

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            -- inst:AddComponent("inspectable")

            -- inst:AddComponent("explosiveresist")

            -- inst:AddComponent("sleeper")

            -- inst:AddComponent("knownlocations")

            inst:AddComponent("timer")

            inst:AddComponent("lootdropper")

            -- inst:AddComponent("health")
            -- inst.components.health:SetMaxHealth(9000)

            -- inst:AddComponent("combat")
            -- inst.components.combat:SetDefaultDamage(60)
            -- inst.components.combat.playerdamagepercent = 0.5
            -- inst.components.combat.hiteffectsymbol = "buzzard_body"
            -- inst.components.combat:SetRange(4)
            -- inst.components.combat:SetAttackPeriod(3.5)
            -- inst.components.combat:SetRetargetFunction(1, RetargetFn)
            -- inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
            -- inst.components.combat:SetHurtSound("dontstarve_DLC001/creatures/moose/hurt") --undo

            -- inst:ListenForEvent("attacked", OnAttacked)
            -- inst:ListenForEvent("timerdone", ontimerdone)

            -- inst.OnSave = OnSave
            -- inst.OnLoad = OnLoad

            if data.fn_server ~= nil then
                data.fn_server(inst)
            end

            return inst
        end,
        data.assets,
        data.prefabs
    ))
end

------
------

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", inst.prefab, "swap")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end
local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function OnDropped(inst)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.Default)
    inst.AnimState:PlayAnimation("item", false)
    inst.components.inventoryitem.pushlandedevents = true
    inst:PushEvent("on_landed")
end
local function OnThrown(inst, owner, target, attacker)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:PlayAnimation("shoot", false)
    inst.components.inventoryitem.pushlandedevents = false
    --undo 声音
end
local function OnHit(inst, owner, target)
    OnDropped(inst)
end
local function OnMiss(inst, owner, target)
    OnDropped(inst)
end

local function MakeWeapon(data)
    table.insert(prefs, Prefab(
        data.name,
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddSoundEmitter()
            inst.entity:AddNetwork()

            MakeInventoryPhysics(inst)
            RemovePhysicsColliders(inst)

            inst:AddTag("thrown")

            --weapon (from weapon component) added to pristine state for optimization
            inst:AddTag("weapon")

            --projectile (from projectile component) added to pristine state for optimization
            inst:AddTag("projectile")

            inst.AnimState:SetBank(data.name)
            inst.AnimState:SetBuild(data.name)
            inst.AnimState:PlayAnimation("item", false)
            -- inst.Transform:SetEightFaced()
            -- inst.AnimState:SetRayTestOnBB(true)

            if data.fn_common ~= nil then
                data.fn_common(inst)
            end

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst:AddComponent("inspectable")

            inst:AddComponent("inventoryitem")
            inst.components.inventoryitem.imagename = data.name
            inst.components.inventoryitem.atlasname = "images/inventoryimages/"..data.name..".xml"
            inst.components.inventoryitem:SetOnDroppedFn(OnDropped)

            inst:AddComponent("equippable")
            inst.components.equippable:SetOnEquip(OnEquip)
            inst.components.equippable:SetOnUnequip(OnUnequip)

            inst:AddComponent("weapon")
            inst.components.weapon:SetRange(12, 14)

            inst:AddComponent("projectilelegion")
            inst.components.projectile:SetSpeed(45)
            inst.components.projectile:SetOnThrownFn(OnThrown)
            inst.components.projectile:SetOnHitFn(OnHit)
            inst.components.projectile:SetOnMissFn(OnMiss)

            MakeHauntableLaunch(inst)

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
--[[ 子圭玄鸟（雌） ]]
--------------------------------------------------------------------------

SetSharedLootTable('siving_foenix', {
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_derivant_item',    1.00},
    {'siving_derivant_item',    0.20},
    --undo 还差子圭面具和子圭羽毛
    -- {'chesspiece_moosegoose_sketch', 1.00},
})

MakeBoss({
    name = "siving_foenix",
    assets = {
        Asset("ANIM", "anim/buzzard_basic.zip"), --官方秃鹫动画模板
        Asset("ANIM", "anim/siving_foenix.zip"),
    },
    prefabs = {  },
    fn_common = function(inst)
        inst.AnimState:SetBuild("siving_foenix")
        inst.AnimState:PlayAnimation("atk", true)
    end,
    fn_server = function(inst)
        inst.components.lootdropper:SetChanceLootTable('siving_foenix')
    end
})

--------------------------------------------------------------------------
--[[ 子圭玄鸟（雄） ]]
--------------------------------------------------------------------------

SetSharedLootTable('siving_moenix', {
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_derivant_item',    1.00},
    {'siving_derivant_item',    0.20},
    --undo 还差子圭面具和子圭羽毛
    -- {'chesspiece_moosegoose_sketch', 1.00},
})

MakeBoss({
    name = "siving_moenix",
    assets = {
        Asset("ANIM", "anim/buzzard_basic.zip"), --官方秃鹫动画模板
        Asset("ANIM", "anim/siving_moenix.zip"),
    },
    prefabs = {  },
    fn_common = function(inst)
        inst.AnimState:SetBuild("siving_moenix")
        inst.AnimState:PlayAnimation("frozen_loop_pst", true)
    end,
    fn_server = function(inst)
        inst.components.lootdropper:SetChanceLootTable('siving_moenix')
    end
})

--------------------------------------------------------------------------
--[[ 子圭玄鸟正羽 ]]
--------------------------------------------------------------------------

--玩家武器
MakeWeapon({
    name = "siving_feather_real",
    assets = {
        Asset("ANIM", "anim/siving_feather_real.zip"),
        Asset("ATLAS", "images/inventoryimages/siving_feather_real.xml"),
        Asset("IMAGE", "images/inventoryimages/siving_feather_real.tex"),
    },
    prefabs = nil,
    fn_common = function(inst)
        
    end,
    fn_server = function(inst)
        inst.components.weapon:SetDamage(61.2) --34*1.8

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
    end
})

--BOSS产物

--------------------------------------------------------------------------
--[[ 子圭玄鸟绒羽 ]]
--------------------------------------------------------------------------

--玩家武器
--BOSS产物

--------------------
--------------------

return unpack(prefs)
