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
        Asset("ANIM", "anim/siving_moenix.zip"),
    },
    prefabs = {  },
    fn_common = function(inst)
        inst.AnimState:SetBuild("siving_moenix")
        inst.AnimState:PlayAnimation("death", true)
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

--------------------
--------------------

return unpack(prefs)
