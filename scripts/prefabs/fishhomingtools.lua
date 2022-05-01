--------------------------------------------------------------------------
--[[ 打开的容器也是个实体 ]]
--------------------------------------------------------------------------

local assets_cont = {
    Asset("ANIM", "anim/ui_bundle_2x2.zip"),
}

local function Fn_cont()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("bundle")

    --V2C: blank string for controller action prompt
    inst.name = " "

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("fishhomingtool") end
        return inst
    end

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("fishhomingtool")

    inst.persists = false

    return inst
end

--------------------------------------------------------------------------
--[[ 简易打窝饵制作器 ]]
--------------------------------------------------------------------------

local assets_normal = {
    -- Asset("ANIM", "anim/fishhomingtool_normal.zip"),
    -- Asset("ATLAS", "images/inventoryimages/fishhomingtool_normal.xml"),
    -- Asset("IMAGE", "images/inventoryimages/fishhomingtool_normal.tex"),

    Asset("ANIM", "anim/bundle.zip"),
}

local prefabs_normal = {
    "fishhomingtool_container",
    "fishhomingbait"
}

local function Fn_normal()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    -- inst.AnimState:SetBank("fishhomingtool_normal")
    -- inst.AnimState:SetBuild("fishhomingtool_normal")
    -- inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetBank("bundle")
    inst.AnimState:SetBuild("bundle")
    inst.AnimState:PlayAnimation("idle")

    -- inst:AddTag(tag)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem.imagename = "fishhomingtool_normal"
    -- inst.components.inventoryitem.atlasname = "images/inventoryimages/fishhomingtool_normal.xml"
    inst.components.inventoryitem.imagename = "bundlewrap"
    -- inst.components.inventoryitem.atlasname = "images/inventoryimages/bundlewrap.xml"
    inst.components.inventoryitem:SetSinks(true)

    inst:AddComponent("bundlemaker")
    inst.components.bundlemaker:SetBundlingPrefabs("fishhomingtool_container", "fishhomingbait")
    inst.components.bundlemaker:SetOnStartBundlingFn(function(inst, doer)
        inst.components.stackable:Get():Remove()
    end)

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
    -- inst.components.propagator.flashpoint = 10 + math.random() * 5

    MakeHauntableLaunchAndIgnite(inst)

    return inst
end

--------------------------------------------------------------------------
--[[ 打窝饵 ]]
--------------------------------------------------------------------------

local assets_bag = {
    -- Asset("ANIM", "anim/fishhomingbait.zip"),
    -- Asset("ATLAS", "images/inventoryimages/fishhomingbait.xml"),
    -- Asset("IMAGE", "images/inventoryimages/fishhomingbait.tex"),

    Asset("ANIM", "anim/swap_chum_pouch.zip"),
    Asset("ANIM", "anim/chum_pouch.zip"),
}

local prefabs_bag = {
    "fishhomingbaiting"
}

local function OnHit(inst, attacker, target)
    local x, y, z = inst.Transform:GetWorldPosition()

    if not TheWorld.Map:IsOceanAtPoint(x, y, z) then
        SpawnPrefab("fishhomingbait").Transform:SetPosition(x, y, z)
    else
        SpawnPrefab("splash_green").Transform:SetPosition(x, y, z)

        local baiting = SpawnPrefab("fishhomingbaiting")
        if baiting ~= nil then
            baiting.Transform:SetPosition(x, y, z)
            inst.components.fishhomingbait:Handover(baiting)
        end
    end

    inst:Remove()
end
local function OnThrown(inst)
    inst:AddTag("NOCLICK")
    inst.persists = false

    inst.AnimState:PlayAnimation("spin_loop")

    inst.Physics:SetMass(1)
    inst.Physics:SetFriction(0)
    inst.Physics:SetDamping(0)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:SetCollisionMask(COLLISION.GROUND)
    inst.Physics:SetCapsule(.2, .2)
end
local function OnAddProjectile(inst)
    inst.components.complexprojectile:SetHorizontalSpeed(15)
    inst.components.complexprojectile:SetGravity(-35)
    inst.components.complexprojectile:SetLaunchOffset(Vector3(.25, 1, 0))
    inst.components.complexprojectile:SetOnLaunch(OnThrown)
    inst.components.complexprojectile:SetOnHit(OnHit)
end

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_chum_pouch", "swap_chum_pouch")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end
local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function Fn_bag()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	inst.Transform:SetTwoFaced()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("chum_pouch")
    inst.AnimState:SetBuild("chum_pouch")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetDeltaTimeMultiplier(.75)

    inst:AddComponent("reticule")
    inst.components.reticule.targetfn = function()
        local pos = Vector3()
        for r = 6.5, 3.5, -.25 do
            pos.x, pos.y, pos.z = ThePlayer.entity:LocalToWorldSpace(r, 0, 0)
            if TheWorld.Map:IsOceanAtPoint(pos.x, pos.y, pos.z, false) then
                return pos
            end
        end
        return pos
    end
    inst.components.reticule.ease = true

    inst:AddTag("allow_action_on_impassable")

    MakeInventoryFloatable(inst, "small", 0.1, 0.8)

    inst.displaynamefn = function(inst)
        local namepre = ""

        for k,str in pairs(STRINGS.FISHHOMING2_LEGION) do
            if inst:HasTag("FH_"..k) then
                namepre = str
                break
            end
        end

        for k,str in pairs(STRINGS.FISHHOMING1_LEGION) do
            if inst:HasTag("FH_"..k) then
                namepre = str..namepre
                break
            end
        end

        local times = 0
        for k,str in pairs(STRINGS.FISHHOMING3_LEGION) do
            if inst:HasTag("FH_"..k) then
                namepre = str..namepre
                times = times + 1

                if times >= 2 then break end
            end
        end

		return namepre..STRINGS.NAMES.FISHHOMINGBAIT
    end

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.baitimgs_l = {
		dusty = { img = "icire_rock5", atlas = "images/inventoryimages/icire_rock5.xml" },
		pasty = { img = "icire_rock4", atlas = "images/inventoryimages/icire_rock4.xml" },
		hardy = { img = "icire_rock1", atlas = "images/inventoryimages/icire_rock1.xml" }
	}

    inst:AddComponent("locomotor")

    inst:AddComponent("oceanthrowable")
    inst.components.oceanthrowable:SetOnAddProjectileFn(OnAddProjectile)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = inst.baitimgs_l.dusty.img
    inst.components.inventoryitem.atlasname = inst.baitimgs_l.dusty.atlas

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.UNARMED_DAMAGE)

    inst:AddComponent("forcecompostable")
    inst.components.forcecompostable.green = true

    inst:AddComponent("fishhomingbait")
    inst.components.fishhomingbait.oninitfn = function(inst)
        local type_shape = inst.components.fishhomingbait.type_shape
        if inst.baitimgs_l[type_shape] ~= nil then
            inst.components.inventoryitem.atlasname = inst.baitimgs_l[type_shape].atlas
            inst.components.inventoryitem:ChangeImageName(inst.baitimgs_l[type_shape].img)
        end
    end

    MakeHauntableLaunch(inst)

    return inst
end

--------------------------------------------------------------------------
--[[ 使用中的打窝饵 ]]
--------------------------------------------------------------------------

local assets_baiting = {
    Asset("ANIM", "anim/fish_chum.zip"),
}

local prefabs_baiting = {
    "chumpiece",
}

local function Fn_baiting()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("fish_chum")
    inst.AnimState:SetBuild("fish_chum")
    inst.AnimState:PlayAnimation("fish_chum_base_pre")
    inst.AnimState:PushAnimation("fish_chum_base_idle", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BELOW_GROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetFinalOffset(3)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    -- inst:AddTag("chum")

    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/spore_cloud_LP", "spore_loop")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("fishhomingbait")
    inst.components.fishhomingbait.isbaiting = true

    inst:DoTaskInTime(3 + math.random()*3, function()
        inst.components.fishhomingbait:Baiting()
    end)

    return inst
end

------

return Prefab("fishhomingtool_container", Fn_cont, assets_cont),
    Prefab("fishhomingtool_normal", Fn_normal, assets_normal, prefabs_normal),
    Prefab("fishhomingbait", Fn_bag, assets_bag, prefabs_bag),
    Prefab("fishhomingbaiting", Fn_baiting, assets_baiting, prefabs_baiting)
