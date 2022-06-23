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
    inst.components.inventoryitem.canbepickedup = true
    inst:PushEvent("on_landed")
end
local function OnThrown(inst, owner, targetpos, attacker)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:PlayAnimation("shoot", false)
    inst.components.inventoryitem.pushlandedevents = false
    inst.components.inventoryitem.canbepickedup = false
    --undo 声音
end

local function CheckPulling(doer)
    if doer.task_checkpull == nil and doer.shootingmap_l ~= nil then
        local finished = true
        for _,v in ipairs(doer.shootingmap_l) do
            if v and v:IsValid() then
                if not v.shootingstate_l then
                    finished = false
                    break
                end
            end
        end
        if finished then
            print("---成功了")
            --undo 先检查物品栏是否有所需道具才能拉回
            doer:AddTag("skill_feather")
            doer.task_checkpull = doer:DoTaskInTime(3, function()
                doer.task_checkpull = nil
                doer:RemoveTag("skill_feather")
                doer.shootingmap_l = nil
                print("---结束了")
            end)
        else
            doer.task_checkpull = doer:DoTaskInTime(0, function()
                doer.task_checkpull = nil
                CheckPulling(doer)
            end)
        end
    end
end
local function OnMiss(inst, pos, attacker)
    if inst.components.projectilelegion.isgoback then
        inst.components.projectilelegion.isgoback = nil
        if attacker.components.inventory ~= nil then
            if not attacker.components.inventory:Equip(inst) then
                attacker.components.inventory:GiveItem(inst)
            end
        else
            OnDropped(inst)
        end
    else
        inst.shootingstate_l = true
        if attacker then
            CheckPulling(attacker)
        end
        OnDropped(inst)
    end
end

local function ReticuleTargetFn()
    return Vector3(ThePlayer.entity:LocalToWorldSpace(6.5, 0, 0))
end
local function ReticuleMouseTargetFn(inst, mousepos)
    if mousepos ~= nil then
        local x, y, z = inst.Transform:GetWorldPosition()
        local dx = mousepos.x - x
        local dz = mousepos.z - z
        local l = dx * dx + dz * dz
        if l <= 0 then
            return inst.components.reticule.targetpos
        end
        l = 6.5 / math.sqrt(l)
        return Vector3(x + dx * l, 0, z + dz * l)
    end
end
local function ReticuleUpdatePositionFn(inst, pos, reticule, ease, smoothing, dt)
    local x, y, z = inst.Transform:GetWorldPosition()
    reticule.Transform:SetPosition(x, 0, z)
    local rot = -math.atan2(pos.z - z, pos.x - x) / DEGREES
    if ease and dt ~= nil then
        local rot0 = reticule.Transform:GetRotation()
        local drot = rot - rot0
        rot = Lerp((drot > 180 and rot0 + 360) or (drot < -180 and rot0 - 360) or rot0, rot, dt * smoothing)
    end
    reticule.Transform:SetRotation(rot)
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

            inst:AddTag("sharp")
            inst:AddTag("skill_feather")

            --weapon (from weapon component) added to pristine state for optimization
            inst:AddTag("weapon")

            inst.AnimState:SetBank(data.name)
            inst.AnimState:SetBuild(data.name)
            inst.AnimState:PlayAnimation("item", false)
            -- inst.Transform:SetEightFaced()

            inst:AddComponent("aoetargeting")
            inst.components.aoetargeting:SetAlwaysValid(true)
            inst.components.aoetargeting.reticule.reticuleprefab = "reticulelongmulti"
            inst.components.aoetargeting.reticule.pingprefab = "reticulelongmultiping"
            inst.components.aoetargeting.reticule.targetfn = ReticuleTargetFn
            inst.components.aoetargeting.reticule.mousetargetfn = ReticuleMouseTargetFn
            inst.components.aoetargeting.reticule.updatepositionfn = ReticuleUpdatePositionFn
            inst.components.aoetargeting.reticule.validcolour = { 117/255, 1, 1, 1 }
            inst.components.aoetargeting.reticule.invalidcolour = { 0, 72/255, 72/255, 1 }
            inst.components.aoetargeting.reticule.ease = true
            inst.components.aoetargeting.reticule.mouseenabled = true

            inst.projectiledelay = 4 * FRAMES

            MakeInventoryFloatable(inst, "small", 0.2, 0.6)

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
            inst.components.weapon:SetRange(-1, -1) --人物默认攻击距离为3、3

            inst:AddComponent("projectilelegion")
            inst.components.projectilelegion.shootrange = 13
            inst.components.projectilelegion.speed = 45
            inst.components.projectilelegion.onthrown = OnThrown
            inst.components.projectilelegion.onmiss = OnMiss

            inst:AddComponent("skillspelllegion")

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
    prefabs = {
        "reticulelongmulti",
        "reticulelongmultiping"
    },
    -- fn_common = function(inst) end,
    fn_server = function(inst)
        inst.components.equippable.equipstack = true --装备时可以叠加装备

        inst.components.weapon:SetDamage(61.2) --34*1.8

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

        inst.components.skillspelllegion.fn_spell = function(inst, caster, pos, options)
            if caster.components.inventory then
                local doerpos = caster:GetPosition()
                local items = inst.components.stackable:Get(5)
                items = caster.components.inventory:DropItem(items, true)

                local angles = {}
                local poss = {}
                local num = items.components.stackable:StackSize() or 1
                local direction = (pos - doerpos):GetNormalized() --单位向量
    	        local angle = math.acos(direction:Dot(Vector3(1, 0, 0))) / DEGREES --这个角度是动画的，不能用来做物理的角度
                local ang_lag = 2.5

                if num == 1 then
                    angles = { 0 }
                    poss[1] = pos
                else
                    if num == 2 then
                        angles = { -ang_lag, ang_lag }
                    elseif num == 3 then
                        angles = { -2*ang_lag, 0, 2*ang_lag }
                    elseif num == 4 then
                        angles = { -3*ang_lag, -ang_lag, ang_lag, 3*ang_lag }
                    elseif num == 5 then
                        angles = { -4*ang_lag, -2*ang_lag, 0, 2*ang_lag, 4*ang_lag }
                    end

                    local ang = caster:GetAngleToPoint(pos.x, pos.y, pos.z) --原始角度，单位:度，比如33
                    for i,v in ipairs(angles) do
                        v = v + math.random()*2 - 1
                        angles[i] = v
                        local an = (ang+v)*DEGREES
                        poss[i] = Vector3(doerpos.x+math.cos(an), 0, doerpos.z-math.sin(an))
                    end
                end

                caster.shootingmap_l = {}
                for i,v in ipairs(angles) do
                    local item = items.components.stackable:Get()
                    item.Transform:SetPosition(doerpos:Get())
                    caster.shootingmap_l[i] = item
                    item.shootingstate_l = false
                    item.components.projectilelegion.isgoback = nil
                    item.components.projectilelegion:Throw(inst, poss[i], caster, angle+v)
                    item.components.projectilelegion:DelayVisibility(inst.projectiledelay)
                end

                if caster.components.health ~= nil and not caster.components.health:IsDead() then
                    caster.components.health:DoDelta(-3*num, true, "siving_feather_real", false, nil, true)
                end

                return true
            end
        end
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
