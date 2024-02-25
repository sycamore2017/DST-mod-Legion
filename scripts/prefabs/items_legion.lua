local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS
local prefs = {}

----------通用

local function GetAssets(name, other)
    local sets = {
        Asset("ANIM", "anim/"..name..".zip"),
        Asset("ATLAS", "images/inventoryimages/"..name..".xml"),
        Asset("IMAGE", "images/inventoryimages/"..name..".tex")
    }
    if other ~= nil then
        for _, v in pairs(other) do
            table.insert(sets, v)
        end
    end
    return sets
end
local function GetPrefabs_crop(name, other)
    local sets = {
        name.."_seeds", "splash_green",
        name.."_oversized", name.."_oversized_waxed", name.."_oversized_rotten"
    }
    if other ~= nil then
        for _, v in pairs(other) do
            table.insert(sets, v)
        end
    end
    return sets
end

local function Fn_common(inst, bank, build, anim, isloop)
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build or bank)
    inst.AnimState:PlayAnimation(anim or "idle", isloop)
end
local function Fn_server(inst, img)
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = img
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..img..".xml"
end

local function SetStackable(inst, maxsize) --叠加组件
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = maxsize or TUNING.STACK_SIZE_SMALLITEM
end
local function SetPerishable(inst, time, replacement, onperish) --新鲜度组件
    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(time)
    inst.components.perishable.onperishreplacement = replacement
    if onperish ~= nil then
        inst.components.perishable:SetOnPerishFn(onperish)
    end
    inst.components.perishable:StartPerishing()
end
local function SetFuel(inst, value) --燃料组件
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = value or TUNING.MED_FUEL
end
local function SetEdible(inst, dd) --食物组件
    inst:AddComponent("edible")
    inst.components.edible.foodtype = dd.foodtype or FOODTYPE.VEGGIE
    inst.components.edible.secondaryfoodtype = dd.foodtype2
    inst.components.edible.healthvalue = dd.health or 0
    inst.components.edible.hungervalue = dd.hunger or 0
    inst.components.edible.sanityvalue = dd.sanity or 0
    if dd.fn_eat ~= nil then
        inst.components.edible:SetOnEatenFn(dd.fn_eat)
    end
end
local function SetCookable(inst, product) --烤制组件
    inst:AddComponent("cookable")
    inst.components.cookable.product = product
end
local function SetLure(inst, dd) --海钓饵组件
    inst:AddComponent("oceanfishingtackle")
    inst.components.oceanfishingtackle:SetupLure(dd)
end
local function SetWeighable(inst, kind) --称重组件
    --Tip: 非巨型的普通果实要想能在作物秤上显示，需要自己的build里有个 果实build名..01 的通道
    inst:AddComponent("weighable")
    inst.components.weighable.type = kind or TROPHYSCALE_TYPES.OVERSIZEDVEGGIES
end
local function SetWaxable(inst, onwaxed) --打蜡组件
    inst:AddComponent("waxable")
    inst.components.waxable:SetWaxfn(onwaxed)
end

local function OnLandedClient(self, ...)
    if self.OnLandedClient_l_base ~= nil then
        self.OnLandedClient_l_base(self, ...)
    end
    if self.floatparam_l ~= nil then
        self.inst.AnimState:SetFloatParams(self.floatparam_l, 1, self.bob_percent)
    end
end
local function SetFloatable(inst, float) --漂浮组件
    MakeInventoryFloatable(inst, float[2], float[3], float[4])
    if float[1] ~= nil then
        local floater = inst.components.floater
        floater.OnLandedClient_l_base = floater.OnLandedClient
        floater.floatparam_l = float[1]
        floater.OnLandedClient = OnLandedClient
    end
end

----------作物

local function GetDisplayName_seeds(inst)
	local registry_key = inst.plant_def.product
	local plantregistryinfo = inst.plant_def.plantregistryinfo
	return (ThePlantRegistry:KnowsSeed(registry_key, plantregistryinfo)
            and ThePlantRegistry:KnowsPlantName(registry_key, plantregistryinfo)
            ) and STRINGS.NAMES["KNOWN_"..string.upper(inst.prefab)]
			or nil
end
local function CanDeploy_seeds(inst, pt, mouseover, deployer)
	local x, z = pt.x, pt.z
	return TheWorld.Map:CanTillSoilAtPoint(x, 0, z, true)
end
local function OnDeploy_seeds(inst, pt, deployer) --, rot)
    local plant = SpawnPrefab(inst.components.farmplantable.plant)
    plant.Transform:SetPosition(pt.x, 0, pt.z)
	plant:PushEvent("on_planted", {in_soil = false, doer = deployer, seed = inst})
    TheWorld.Map:CollapseSoilAtPoint(pt.x, 0, pt.z)
    --plant.SoundEmitter:PlaySound("dontstarve/wilson/plant_seeds")
    inst:Remove()
end
local function SetCropSeeds_common(inst, product)
    inst.AnimState:SetRayTestOnBB(true)

    inst:AddTag("deployedplant")
    inst:AddTag("deployedfarmplant")

    inst.pickupsound = "vegetation_firm"
    inst.overridedeployplacername = "seeds_placer"
    inst.plant_def = PLANT_DEFS[product]
    inst.displaynamefn = GetDisplayName_seeds
    inst._custom_candeploy_fn = CanDeploy_seeds -- for DEPLOYMODE.CUSTOM
end
local function SetCropSeeds_server(inst, product)
    inst:AddComponent("farmplantable")
    inst.components.farmplantable.plant = "farm_plant_"..product

    --已被舍弃的旧版农场的配合组件
    inst:AddComponent("plantable")
    inst.components.plantable.growtime = TUNING.SEEDS_GROW_TIME
    inst.components.plantable.product = product

    --已被舍弃的植物人直接种作物的机制
    inst:AddComponent("deployable")
    inst.components.deployable:SetDeployMode(DEPLOYMODE.CUSTOM) -- use inst._custom_candeploy_fn
    inst.components.deployable.restrictedtag = "plantkin"
    inst.components.deployable.ondeploy = OnDeploy_seeds
end
local function InitVeggie(inst)
    inst:AddComponent("bait")
    inst:AddComponent("tradable")

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndPerish(inst)
end

local OVERSIZED_PHYSICS_RADIUS = 0.1
local OVERSIZED_PERISHTIME_MULT = 4

local function OnEquip_oversized(inst, owner)
	local swap = inst.components.symbolswapdata
    owner.AnimState:OverrideSymbol("swap_body", swap.build, swap.symbol)
end
local function OnUnequip_oversized(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
end
local function OnWorkedFinish_oversized(inst, worker)
    inst.components.lootdropper:DropLoot()
    inst:Remove()
end
local function OnBurnt_oversized(inst)
    inst.components.lootdropper:DropLoot()
    inst:Remove()
end
local function Fn_common_crop_oversized(inst, bank, build, anim, isloop, product)
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build or bank)
    inst.AnimState:PlayAnimation(anim or "idle_oversized", isloop)

    inst:AddTag("heavy")
    inst:AddTag("oversized_veggie")

    inst.gymweight = 4
    inst._base_name = product

    MakeHeavyObstaclePhysics(inst, OVERSIZED_PHYSICS_RADIUS)
    inst:SetPhysicsRadiusOverride(OVERSIZED_PHYSICS_RADIUS)
end
local function Fn_server_crop_oversized(inst, build, swap, loot, fireproof)
    inst:AddComponent("heavyobstaclephysics")
    inst.components.heavyobstaclephysics:SetRadius(OVERSIZED_PHYSICS_RADIUS)

    inst.components.inventoryitem.cangoincontainer = false
    inst.components.inventoryitem:SetSinks(true)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(OnEquip_oversized)
    inst.components.equippable:SetOnUnequip(OnUnequip_oversized)
    inst.components.equippable.walkspeedmult = TUNING.HEAVY_SPEED_MULT

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(OnWorkedFinish_oversized)

    inst:AddComponent("submersible")
    inst:AddComponent("symbolswapdata")
    inst.components.symbolswapdata:SetData(build, swap)

    inst:AddComponent("lootdropper")
    if loot ~= nil then
        inst.components.lootdropper:SetLoot(loot)
    end

    if not fireproof then
        MakeMediumBurnable(inst)
        inst.components.burnable:SetOnBurntFn(OnBurnt_oversized)
        MakeMediumPropagator(inst)
    end

    MakeHauntableWork(inst)
end
local function Fn_common_crop_oversized_rotten(inst)
    inst:AddTag("farm_plant_killjoy")
    inst:AddTag("pickable_harvest_str")
    inst:AddTag("pickable")
    inst.gymweight = 3
end
local function Fn_server_crop_oversized_rotten(inst)
    inst.components.inspectable.nameoverride = "VEGGIE_OVERSIZED_ROTTEN"

    inst:AddComponent("pickable")
    inst.components.pickable.remove_when_picked = true
    inst.components.pickable:SetUp(nil)
    inst.components.pickable.use_lootdropper_for_product = true
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries"
end

local function OnPerish_oversized(inst)
    -- vars for rotting on a gym
    local gym = nil
    local rot = nil
    local slot = nil

    if inst.components.inventoryitem:GetGrandOwner() ~= nil and not inst.components.inventoryitem:GetGrandOwner():HasTag("gym") then
        local loots = {}
        for i=1, #inst.components.lootdropper.loot do
            table.insert(loots, "spoiled_food")
        end
        inst.components.lootdropper:SetLoot(loots)
        inst.components.lootdropper:DropLoot()
    else
        rot = SpawnPrefab(inst.prefab.."_rotten")
        rot.Transform:SetPosition(inst.Transform:GetWorldPosition())
        if inst.components.inventoryitem:GetGrandOwner() and inst.components.inventoryitem:GetGrandOwner():HasTag("gym") then
            gym = inst.components.inventoryitem:GetGrandOwner()
            slot = gym.components.inventory:GetItemSlot(inst)
        end
    end

    inst:Remove()

    if gym and rot then
        gym.components.mightygym:LoadWeight(rot, slot)
    end
end
local function OnWaxed_oversized(inst, doer, waxitem)
    local waxedveggie = SpawnPrefab(inst.prefab.."_waxed")
    if doer.components.inventory and doer.components.inventory:IsHeavyLifting() and doer.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) == inst then
        doer.components.inventory:Unequip(EQUIPSLOTS.BODY)
        doer.components.inventory:Equip(waxedveggie)
    else
        waxedveggie.Transform:SetPosition(inst.Transform:GetWorldPosition())
        waxedveggie.AnimState:PlayAnimation("wax_oversized", false)
        waxedveggie.AnimState:PushAnimation("idle_oversized")
    end
    inst:Remove()
    return true
end
local function CalcWeightCoefficient_oversized(weight_data)
    if weight_data[3] ~= nil and math.random() < weight_data[3] then
        return (math.random() + math.random()) / 2
    else
        return math.random()
    end
end
local function SetWeighable_oversized(inst, kind, weight_data)
    SetWeighable(inst, kind)
    inst.components.weighable:Initialize(weight_data[1], weight_data[2])
    local coefficient = CalcWeightCoefficient_oversized(weight_data)
    inst.components.weighable:SetWeight(Lerp(weight_data[1], weight_data[2], coefficient))
end
local function GetLoots_oversized(inst, name)
    local product = name
	local seeds = name.."_seeds"
    return { product, product, seeds, seeds, math.random() < 0.75 and product or seeds }
end
local function OnSave_oversized(inst, data)
	data.from_plant = inst.from_plant or false
    data.harvested_on_day = inst.harvested_on_day
end
local function OnPreLoad_oversized(inst, data)
	inst.from_plant = (data and data.from_plant) ~= false
	if data ~= nil then
        inst.harvested_on_day = data.harvested_on_day
	end
end
local function InitOversizedCrop(inst)
    inst.harvested_on_day = inst.harvested_on_day or (TheWorld.state.cycles + 1)
    inst.from_plant = false

    inst.OnSave = OnSave_oversized
    inst.OnPreLoad = OnPreLoad_oversized
end

local function DisplayAdjective_oversized_waxed(inst)
    return STRINGS.UI.HUD.WAXED
end
local function PlayWaxAnimation(inst)
	inst.AnimState:PlayAnimation("wax_oversized", false)
    inst.AnimState:PushAnimation("idle_oversized")
end
local function CancelWaxTask(inst)
	if inst._waxtask ~= nil then
		inst._waxtask:Cancel()
		inst._waxtask = nil
	end
end
local function StartWaxTask(inst)
	if not inst.inlimbo and inst._waxtask == nil then
		inst._waxtask = inst:DoTaskInTime(GetRandomMinMax(20, 40), PlayWaxAnimation)
	end
end
local function InitWaxedCrop(inst)
    inst:ListenForEvent("onputininventory", CancelWaxTask)
    inst:ListenForEvent("ondropped", StartWaxTask)

    inst.OnEntitySleep = CancelWaxTask
    inst.OnEntityWake = StartWaxTask

    StartWaxTask(inst)
end

local lure_seeds = {
    build = "oceanfishing_lure_mis", symbol = "hook_seeds",
    single_use = true, lure_data = TUNING.OCEANFISHING_LURE.SEED
}

local function MakeCropAbout(dd)
    if dd.seeds ~= nil then ----------种子
        local image = dd.seeds.image or dd.name.."_seeds"
        table.insert(prefs, Prefab(dd.name.."_seeds", function()
            local inst = CreateEntity()

            Fn_common(inst, dd.name, nil, "seeds", nil)
            SetCropSeeds_common(inst, dd.name)
            SetFloatable(inst, dd.seeds.floatable)

            inst:AddTag("cookable") --烤制组件所需
            inst:AddTag("oceanfishing_lure") --海钓饵组件所需

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then return inst end

            Fn_server(inst, image)
            SetEdible(inst, dd.seeds.edible)
            SetStackable(inst, dd.seeds.stackable)
            SetPerishable(inst, dd.seeds.perishable or TUNING.PERISH_SUPERSLOW, "spoiled_food", nil)
            SetCookable(inst, "seeds_cooked")
            SetLure(inst, lure_seeds)
            SetCropSeeds_server(inst, dd.name)
            InitVeggie(inst)

            return inst
        end, {
            Asset("ANIM", "anim/"..dd.name..".zip"),
            Asset("ATLAS", "images/inventoryimages/"..image..".xml"),
            Asset("IMAGE", "images/inventoryimages/"..image..".tex"),
            Asset("ATLAS_BUILD", "images/inventoryimages/"..image..".xml", 256),
            Asset("ANIM", "anim/oceanfishing_lure_mis.zip")
        }, { "farm_plant_"..dd.name }))
    end
    if dd.product ~= nil then ----------果实
        table.insert(prefs, Prefab(dd.name, function()
            local inst = CreateEntity()

            Fn_common(inst, dd.name, nil, "idle", nil)
            SetFloatable(inst, dd.product.floatable)

            inst:AddTag("cookable")
            inst:AddTag("weighable_OVERSIZEDVEGGIES") --称重组件所需

            inst.pickupsound = "vegetation_firm"

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then return inst end

            Fn_server(inst, dd.name)
            SetEdible(inst, dd.product.edible)
            SetStackable(inst, dd.product.stackable)
            SetPerishable(inst, dd.product.perishable, "spoiled_food", nil)
            SetCookable(inst, dd.name.."_cooked")
            SetWeighable(inst, nil)
            InitVeggie(inst)

            return inst
        end, GetAssets(dd.name, {
            Asset("ATLAS_BUILD", "images/inventoryimages/"..dd.name..".xml", 256)
        }), GetPrefabs_crop(dd.name, { dd.name.."_cooked" })))
    end
    if dd.cooked ~= nil then ----------果实（烤制）
        local image = dd.cooked.image or dd.name.."_cooked"
        table.insert(prefs, Prefab(dd.name.."_cooked", function()
            local inst = CreateEntity()

            Fn_common(inst, dd.name, nil, "cooked", nil)
            SetFloatable(inst, dd.cooked.floatable)

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then return inst end

            Fn_server(inst, image)
            SetEdible(inst, dd.cooked.edible)
            SetStackable(inst, dd.cooked.stackable)
            SetPerishable(inst, dd.cooked.perishable, "spoiled_food", nil)
            InitVeggie(inst)

            return inst
        end, {
            Asset("ANIM", "anim/"..dd.name..".zip"),
            Asset("ATLAS", "images/inventoryimages/"..image..".xml"),
            Asset("IMAGE", "images/inventoryimages/"..image..".tex"),
            Asset("ATLAS_BUILD", "images/inventoryimages/"..image..".xml", 256)
        }, nil))
    end
    if dd.oversized ~= nil then ----------巨型果实
        local image = dd.oversized.image or dd.name.."_oversized"
        table.insert(prefs, Prefab(dd.name.."_oversized", function()
            local inst = CreateEntity()

            local plant_def = PLANT_DEFS[dd.name]
            Fn_common_crop_oversized(inst, plant_def.bank, plant_def.build, nil, nil, dd.name)

            inst:AddTag("waxable") --打蜡组件所需
            inst:AddTag("show_spoilage")

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then return inst end

            local myloots
            if dd.oversized.fn_getloots == nil then
                myloots = GetLoots_oversized(inst, dd.name)
            else
                myloots = dd.oversized.fn_getloots(inst, dd.name)
            end

            local perishtime = dd.oversized.perishable
            if perishtime == nil then
                if dd.product and dd.product.perishable then
                    perishtime = dd.product.perishable * OVERSIZED_PERISHTIME_MULT
                else
                    perishtime = TUNING.PERISH_MED * OVERSIZED_PERISHTIME_MULT
                end
            end

            InitOversizedCrop(inst)
            Fn_server(inst, image)
            Fn_server_crop_oversized(inst, plant_def.build, "swap_body", myloots, dd.oversized.fireproof)
            SetWaxable(inst, OnWaxed_oversized)
            SetWeighable_oversized(inst, nil, plant_def.weight_data)
            SetPerishable(inst, perishtime, nil, OnPerish_oversized)

            return inst
        end, {
            Asset("ANIM", "anim/farm_plant_"..dd.name..".zip"),
            Asset("ATLAS", "images/inventoryimages/"..image..".xml"),
            Asset("IMAGE", "images/inventoryimages/"..image..".tex"),
            Asset("ATLAS_BUILD", "images/inventoryimages/"..image..".xml", 256)
        }, nil))
    end
    if dd.oversized_waxed ~= nil then ----------巨型果实（打过蜡的）
        local image = dd.oversized_waxed.image or dd.name.."_oversized_waxed"
        table.insert(prefs, Prefab(dd.name.."_oversized_waxed", function()
            local inst = CreateEntity()

            local plant_def = PLANT_DEFS[dd.name]
            Fn_common_crop_oversized(inst, plant_def.bank, plant_def.build, nil, nil, dd.name)

            inst.displayadjectivefn = DisplayAdjective_oversized_waxed
            inst:SetPrefabNameOverride(dd.name.."_oversized")

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then return inst end

            local myloots
            if dd.oversized_waxed.fn_getloots == nil then
                myloots = { "spoiled_food" }
            else
                myloots = dd.oversized_waxed.fn_getloots(inst, dd.name)
            end

            Fn_server(inst, image)
            Fn_server_crop_oversized(inst, plant_def.build, "swap_body", myloots, nil)
            InitWaxedCrop(inst)

            return inst
        end, {
            Asset("ANIM", "anim/farm_plant_"..dd.name..".zip"),
            Asset("ATLAS", "images/inventoryimages/"..image..".xml"),
            Asset("IMAGE", "images/inventoryimages/"..image..".tex"),
            Asset("ATLAS_BUILD", "images/inventoryimages/"..image..".xml", 256)
        }, nil))
    end
    if dd.oversized_rotten ~= nil then ----------巨型腐烂果实
        local image = dd.oversized_rotten.image or dd.name.."_oversized_rotten"
        table.insert(prefs, Prefab(dd.name.."_oversized_rotten", function()
            local inst = CreateEntity()

            local plant_def = PLANT_DEFS[dd.name]
            Fn_common_crop_oversized(inst, plant_def.bank, plant_def.build, "idle_rot_oversized", nil, dd.name)
            Fn_common_crop_oversized_rotten(inst)

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then return inst end

            local myloots
            if dd.oversized_rotten.fn_getloots == nil then
                myloots = plant_def.loot_oversized_rot
            else
                myloots = dd.oversized_rotten.fn_getloots(inst, dd.name)
            end

            Fn_server(inst, image)
            Fn_server_crop_oversized(inst, plant_def.build, "swap_body_rotten", myloots, nil)
            Fn_server_crop_oversized_rotten(inst)

            return inst
        end, {
            Asset("ANIM", "anim/farm_plant_"..dd.name..".zip"),
            Asset("ATLAS", "images/inventoryimages/"..image..".xml"),
            Asset("IMAGE", "images/inventoryimages/"..image..".tex"),
            Asset("ATLAS_BUILD", "images/inventoryimages/"..image..".xml", 256)
        }, nil))
    end
end

--------------------------------------------------------------------------
--[[ 料理 ]]
--------------------------------------------------------------------------

local prefabs_dish = {
    "spoiled_food"
}
local function MakeDish(dd)
    local realname = dd.basename or dd.name --当有调料时，basename 才是这个料理最初的代码名
    local food_symbol_build = dd.overridebuild or realname
    local foodassets = {
        Asset("ANIM", "anim/"..food_symbol_build..".zip"),
        Asset("ATLAS", "images/inventoryimages/"..realname..".xml"),
        Asset("IMAGE", "images/inventoryimages/"..realname..".tex"),
        Asset("ATLAS_BUILD", "images/inventoryimages/"..realname..".xml", 256)
    }
    local spicename = dd.spice ~= nil and string.lower(dd.spice) or nil
    if spicename ~= nil then
        table.insert(foodassets, Asset("ANIM", "anim/spices.zip"))
        table.insert(foodassets, Asset("ANIM", "anim/plate_food.zip"))
        table.insert(foodassets, Asset("INV_IMAGE", spicename.."_over"))
    end

    local foodprefabs = prefabs_dish
    if dd.prefabs ~= nil then
        foodprefabs = shallowcopy(prefabs_dish)
        for _, v in ipairs(dd.prefabs) do
            if not table.contains(foodprefabs, v) then
                table.insert(foodprefabs, v)
            end
        end
    end

    local function DisplayName_dish(inst)
        return subfmt(STRINGS.NAMES[dd.spice.."_FOOD"], { food = STRINGS.NAMES[string.upper(dd.basename)] })
    end

    table.insert(prefs, Prefab(dd.name, function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        if spicename ~= nil then
            inst.AnimState:SetBuild("plate_food")
            inst.AnimState:SetBank("plate_food")
            inst.AnimState:OverrideSymbol("swap_garnish", "spices", spicename)

            inst:AddTag("spicedfood")

            --有调料时，调料本身的贴图是inventoryitem所对应的，料理本身的贴图反而成了背景
            inst.inv_image_bg = { atlas = "images/inventoryimages/"..realname..".xml", image = realname..".tex" }
        else
            inst.AnimState:SetBuild(food_symbol_build)
            inst.AnimState:SetBank(food_symbol_build)
        end
        --Tip: 动画文件里的默认动画，比如idle，所用到的第一张图最好不要太小，比如1x1，以及中心点设置也不要为0.0
        --否则，会导致打包后，游戏鼠标移到对应动画贴图上去时，没有正常的鼠标反应；或者只有部分贴图区域能出现鼠标反应
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:OverrideSymbol("swap_food", food_symbol_build, realname)

        inst:AddTag("preparedfood")
        if dd.tags ~= nil then
            for _, v in ipairs(dd.tags) do
                inst:AddTag(v)
            end
        end
        if dd.basename ~= nil then
            inst:SetPrefabNameOverride(dd.basename)
            if dd.spice ~= nil then
                inst.displaynamefn = DisplayName_dish
            end
        end
        if dd.float ~= nil then
            SetFloatable(inst, dd.float)
        end
        if dd.fn_common ~= nil then
            dd.fn_common(inst)
        end

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        inst.food_symbol_build = food_symbol_build
        inst.food_basename = dd.basename

        inst:AddComponent("edible")
        inst.components.edible.foodtype = dd.foodtype or FOODTYPE.GENERIC
        inst.components.edible.secondaryfoodtype = dd.secondaryfoodtype or nil
        inst.components.edible.hungervalue = dd.hunger or 0
        inst.components.edible.sanityvalue = dd.sanity or 0
        inst.components.edible.healthvalue = dd.health or 0
        inst.components.edible.temperaturedelta = dd.temperature or 0
        inst.components.edible.temperatureduration = dd.temperatureduration or 0
        inst.components.edible.nochill = dd.nochill or nil
        inst.components.edible.spice = dd.spice
        inst.components.edible:SetOnEatenFn(dd.oneatenfn)

        inst:AddComponent("inspectable")
        inst.wet_prefix = dd.wet_prefix --潮湿前缀

        inst:AddComponent("inventoryitem")
        -- if dd.OnPutInInventory then
		-- 	inst:ListenForEvent("onputininventory", dd.OnPutInInventory)
		-- end
        inst.components.inventoryitem.imagename = realname
        if spicename ~= nil then --带调料的料理
            inst.components.inventoryitem:ChangeImageName(spicename.."_over")
        elseif dd.basename ~= nil then --特殊情况
            inst.components.inventoryitem:ChangeImageName(dd.basename)
        else --普通料理
            inst.components.inventoryitem.atlasname = "images/inventoryimages/"..realname..".xml"
        end
        if dd.float == nil then
            inst.components.inventoryitem:SetSinks(true)
        end

        inst:AddComponent("bait")
        inst:AddComponent("tradable")

        SetStackable(inst, nil)
        if dd.perishtime ~= nil and dd.perishtime > 0 then
            SetPerishable(inst, dd.perishtime, "spoiled_food", nil)
		end
        if not dd.fireproof then
            MakeSmallBurnable(inst)
            MakeSmallPropagator(inst)
        end
        MakeHauntableLaunch(inst)

        if dd.fn_server ~= nil then
            dd.fn_server(inst)
        end

        return inst
    end, foodassets, foodprefabs))
end

for k, v in pairs(require("preparedfoods_pastoral")) do
    if not v.data_only then
        MakeDish(v)
    end
end
for k, v in pairs(require("preparedfoods_pastoral_spiced")) do
    if not v.data_only then
        MakeDish(v)
    end
end

--------------------------------------------------------------------------
--[[ 本mod ]]
--------------------------------------------------------------------------

----------晗猪草相关
local function OnEat_piggymimosa(inst, eater)
    if eater.components.combat ~= nil then --这个buff需要攻击组件
        eater.buff_pl_piggycorolla_up = true
        eater.time_l_piggycorolla = { add = TUNING.SEG_TIME*2, max = TUNING.SEG_TIME*30 }
        eater:AddDebuff("buff_pl_piggycorolla", "buff_pl_piggycorolla")
    end
end
MakeCropAbout({
    name = "piggymimosa",
    seeds = {
        image = nil, stackable = nil, floatable = { nil, nil, nil, nil }, perishable = nil,
        edible = {
            foodtype = FOODTYPE.SEEDS, foodtype2 = nil, fn_eat = nil,
            hunger = 2, sanity = 1, health = 1
        }
    },
    product = {
        stackable = nil, floatable = { nil, "small", 0.05, 0.9 }, perishable = TUNING.PERISH_SLOW,
        edible = {
            foodtype = nil, foodtype2 = nil, fn_eat = OnEat_piggymimosa,
            hunger = 3, sanity = 5, health = 3
        }
    },
    cooked = {
        image = nil, stackable = nil, floatable = { nil, "med", nil, 0.75 }, perishable = TUNING.PERISH_FASTISH,
        edible = {
            -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
            hunger = 9, sanity = 8, health = 5
        }
    },
    oversized = {
        image = nil, perishable = nil, fireproof = nil,
        -- fn_getloots = function(inst, productname) end
    },
    oversized_waxed = { image = nil, fn_getloots = nil },
    oversized_rotten = { image = nil, fn_getloots = nil }
})

--------------------------------------------------------------------------
--[[ 棱镜 ]]
--------------------------------------------------------------------------

if not SETS_PASTORAL.ENABLEDMODS["legion"] then --棱镜的代码就单独写出来，不用统一函数，以作参考
    ----------松萝种子
    table.insert(prefs, Prefab("pineananas_seeds", function()
        local inst = CreateEntity()

        Fn_common(inst, "pineananas", nil, "seeds", nil)
        SetCropSeeds_common(inst, "pineananas")
        SetFloatable(inst, { -0.1, "small", nil, nil })

        inst:AddTag("cookable") --烤制组件所需
        inst:AddTag("oceanfishing_lure") --海钓饵组件所需

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        Fn_server(inst, "pineananas_seeds")
        SetEdible(inst, {
            foodtype = FOODTYPE.SEEDS, foodtype2 = nil, fn_eat = nil,
            hunger = TUNING.CALORIES_TINY, sanity = nil, health = 0.5
        })
        SetStackable(inst, nil)
        SetPerishable(inst, TUNING.PERISH_SUPERSLOW, "spoiled_food", nil)
        SetCookable(inst, "seeds_cooked")
        SetLure(inst, lure_seeds)
        SetCropSeeds_server(inst, "pineananas")
        InitVeggie(inst)

        return inst
    end, {
        -- Asset("ANIM", "anim/farm_plant_seeds.zip"), --不要再注册动官方作物动画，会导致动画顺序混乱，因为作物动画有注册顺序要求
        Asset("ANIM", "anim/pineananas.zip"),
        Asset("ATLAS", "images/inventoryimages/pineananas_seeds.xml"),
        Asset("IMAGE", "images/inventoryimages/pineananas_seeds.tex"),
        Asset("ATLAS_BUILD", "images/inventoryimages/pineananas_seeds.xml", 256),
        Asset("ANIM", "anim/oceanfishing_lure_mis.zip")
    }, { "farm_plant_pineananas" }))

    ----------松萝
    table.insert(prefs, Prefab("pineananas", function()
        local inst = CreateEntity()

        Fn_common(inst, "pineananas", nil, "idle", nil)
        SetFloatable(inst, { nil, "small", 0.2, 0.9 })

        inst:AddTag("cookable")
        inst:AddTag("weighable_OVERSIZEDVEGGIES") --称重组件所需

        inst.pickupsound = "vegetation_firm"

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        Fn_server(inst, "pineananas")
        SetEdible(inst, {
            -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
            hunger = 12, sanity = -10, health = 8
        })
        SetStackable(inst, nil)
        SetPerishable(inst, TUNING.PERISH_MED, "spoiled_food", nil)
        SetCookable(inst, "pineananas_cooked")
        SetWeighable(inst, nil)
        InitVeggie(inst)

        return inst
    end, GetAssets("pineananas", {
        Asset("ATLAS_BUILD", "images/inventoryimages/pineananas.xml", 256)
    }), GetPrefabs_crop("pineananas", { "pineananas_cooked" })))

    ----------烤松萝
    table.insert(prefs, Prefab("pineananas_cooked", function()
        local inst = CreateEntity()

        Fn_common(inst, "pineananas", nil, "cooked", nil)
        SetFloatable(inst, { nil, "small", 0.2, 1 })

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        Fn_server(inst, "pineananas_cooked")
        SetEdible(inst, {
            -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
            hunger = 18.5, sanity = 5, health = 16
        })
        SetStackable(inst, nil)
        SetPerishable(inst, TUNING.PERISH_SUPERFAST, "spoiled_food", nil)
        InitVeggie(inst)

        return inst
    end, {
        Asset("ANIM", "anim/pineananas.zip"),
        Asset("ATLAS", "images/inventoryimages/pineananas_cooked.xml"),
        Asset("IMAGE", "images/inventoryimages/pineananas_cooked.tex"),
        Asset("ATLAS_BUILD", "images/inventoryimages/pineananas_cooked.xml", 256)
    }, nil))

    ----------巨型松萝
    table.insert(prefs, Prefab("pineananas_oversized", function()
        local inst = CreateEntity()

        local plant_def = PLANT_DEFS["pineananas"]
        Fn_common_crop_oversized(inst, plant_def.bank, plant_def.build, nil, nil, "pineananas")

        inst:AddTag("waxable") --打蜡组件所需
	    inst:AddTag("show_spoilage")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        local myloot = GetLoots_oversized(inst, "pineananas")
        table.insert(myloot, "pinecone")

        InitOversizedCrop(inst)
        Fn_server(inst, "pineananas_oversized")
        Fn_server_crop_oversized(inst, plant_def.build, "swap_body", myloot, nil)
        SetWaxable(inst, OnWaxed_oversized)
        SetWeighable_oversized(inst, nil, plant_def.weight_data)
        SetPerishable(inst, TUNING.PERISH_MED*OVERSIZED_PERISHTIME_MULT, nil, OnPerish_oversized)

        return inst
    end, {
        Asset("ANIM", "anim/farm_plant_pineananas.zip"),
        Asset("ATLAS", "images/inventoryimages/pineananas_oversized.xml"),
        Asset("IMAGE", "images/inventoryimages/pineananas_oversized.tex"),
        Asset("ATLAS_BUILD", "images/inventoryimages/pineananas_oversized.xml", 256)
    }, nil))

    ----------巨型松萝（打过蜡的）
    table.insert(prefs, Prefab("pineananas_oversized_waxed", function()
        local inst = CreateEntity()

        local plant_def = PLANT_DEFS["pineananas"]
        Fn_common_crop_oversized(inst, plant_def.bank, plant_def.build, nil, nil, "pineananas")

        inst.displayadjectivefn = DisplayAdjective_oversized_waxed
        inst:SetPrefabNameOverride("pineananas_oversized")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        Fn_server(inst, "pineananas_oversized_waxed")
        Fn_server_crop_oversized(inst, plant_def.build, "swap_body", {"spoiled_food"}, nil)
        InitWaxedCrop(inst)

        return inst
    end, {
        Asset("ANIM", "anim/farm_plant_pineananas.zip"),
        Asset("ATLAS", "images/inventoryimages/pineananas_oversized_waxed.xml"),
        Asset("IMAGE", "images/inventoryimages/pineananas_oversized_waxed.tex"),
        Asset("ATLAS_BUILD", "images/inventoryimages/pineananas_oversized_waxed.xml", 256)
    }, nil))

    ----------巨型腐烂松萝
    table.insert(prefs, Prefab("pineananas_oversized_rotten", function()
        local inst = CreateEntity()

        local plant_def = PLANT_DEFS["pineananas"]
        Fn_common_crop_oversized(inst, plant_def.bank, plant_def.build, "idle_rot_oversized", nil, "pineananas")
        Fn_common_crop_oversized_rotten(inst)

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        Fn_server(inst, "pineananas_oversized_rotten")
        Fn_server_crop_oversized(inst, plant_def.build, "swap_body_rotten", plant_def.loot_oversized_rot, nil)
        Fn_server_crop_oversized_rotten(inst)

        return inst
    end, {
        Asset("ANIM", "anim/farm_plant_pineananas.zip"),
        Asset("ATLAS", "images/inventoryimages/pineananas_oversized_rotten.xml"),
        Asset("IMAGE", "images/inventoryimages/pineananas_oversized_rotten.tex"),
        Asset("ATLAS_BUILD", "images/inventoryimages/pineananas_oversized_rotten.xml", 256)
    }, nil))
end

--------------------------------------------------------------------------
--[[ 海洋传说 ]]
--------------------------------------------------------------------------

if not SETS_PASTORAL.ENABLEDMODS["legend_of_sea"] then
    ----------芒果相关
    MakeCropAbout({
        name = "lg_mangguo",
        seeds = {
            image = nil, stackable = nil, floatable = { nil, nil, nil, nil }, perishable = nil,
            edible = {
                foodtype = FOODTYPE.SEEDS, foodtype2 = nil, fn_eat = nil,
                hunger = 4, sanity = nil, health = nil
            }
        },
        product = {
            stackable = nil, floatable = { nil, "small", 0.05, 0.9 }, perishable = TUNING.PERISH_MED,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 20, sanity = 5, health = 5
            }
        },
        cooked = {
            image = nil, stackable = nil, floatable = { nil, "med", nil, 0.75 }, perishable = TUNING.PERISH_FAST,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 15, sanity = 2, health = 20
            }
        },
        oversized = {
            image = nil, perishable = nil, fireproof = nil,
            -- fn_getloots = function(inst, productname) end
        },
        oversized_waxed = { image = nil, fn_getloots = nil },
        oversized_rotten = { image = "lg_mangguo_oversized_rot", fn_getloots = nil }
    })
    ----------葡萄相关
    MakeCropAbout({
        name = "lg_putao",
        seeds = {
            image = nil, stackable = nil, floatable = { nil, nil, nil, nil }, perishable = nil,
            edible = {
                foodtype = FOODTYPE.SEEDS, foodtype2 = nil, fn_eat = nil,
                hunger = 4, sanity = nil, health = nil
            }
        },
        product = {
            stackable = nil, floatable = { nil, "small", 0.05, 0.9 }, perishable = TUNING.PERISH_MED,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 15, sanity = 3, health = 3
            }
        },
        cooked = {
            image = nil, stackable = nil, floatable = { nil, "med", nil, 0.75 }, perishable = TUNING.PERISH_FAST,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 10, sanity = 1, health = 1
            }
        },
        oversized = { image = nil, perishable = nil, fireproof = nil, fn_getloots = nil },
        oversized_waxed = { image = nil, fn_getloots = nil },
        oversized_rotten = { image = "lg_putao_oversized_rot", fn_getloots = nil }
    })
end

--------------------------------------------------------------------------
--[[ 农场补充包 ]]
--------------------------------------------------------------------------

if not SETS_PASTORAL.ENABLEDMODS["yq_farming_et"] then
    ----------白菜相关
    MakeCropAbout({
        name = "yq_baicai",
        seeds = {
            image = nil, stackable = nil, floatable = { nil, nil, nil, nil }, perishable = nil,
            edible = {
                foodtype = FOODTYPE.SEEDS, foodtype2 = nil, fn_eat = nil,
                hunger = 4, sanity = nil, health = nil
            }
        },
        product = {
            stackable = nil, floatable = { nil, "small", 0.05, 0.9 }, perishable = TUNING.PERISH_MED,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 22.5, sanity = nil, health = 1
            }
        },
        cooked = {
            image = nil, stackable = nil, floatable = { nil, "med", nil, 0.75 }, perishable = TUNING.PERISH_FAST,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 30.5, sanity = nil, health = 3
            }
        },
        oversized = { image = nil, perishable = nil, fireproof = nil, fn_getloots = nil },
        oversized_waxed = { image = nil, fn_getloots = nil },
        oversized_rotten = { image = "yq_baicai_oversized_rot", fn_getloots = nil }
    })
    ----------香菜相关
    MakeCropAbout({
        name = "yq_bocai",
        seeds = {
            image = nil, stackable = nil, floatable = { nil, nil, nil, nil }, perishable = nil,
            edible = {
                foodtype = FOODTYPE.SEEDS, foodtype2 = nil, fn_eat = nil,
                hunger = 4, sanity = nil, health = nil
            }
        },
        product = {
            stackable = nil, floatable = { nil, "small", 0.05, 0.9 }, perishable = TUNING.PERISH_MED,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 12.5, sanity = nil, health = 5
            }
        },
        cooked = {
            image = nil, stackable = nil, floatable = { nil, "med", nil, 0.75 }, perishable = TUNING.PERISH_FAST,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 22.5, sanity = nil, health = 3
            }
        },
        oversized = { image = nil, perishable = nil, fireproof = nil, fn_getloots = nil },
        oversized_waxed = { image = nil, fn_getloots = nil },
        oversized_rotten = { image = "yq_bocai_oversized_rot", fn_getloots = nil }
    })
    ----------大葱相关
    MakeCropAbout({
        name = "yq_dacong",
        seeds = {
            image = nil, stackable = nil, floatable = { nil, nil, nil, nil }, perishable = nil,
            edible = {
                foodtype = FOODTYPE.SEEDS, foodtype2 = nil, fn_eat = nil,
                hunger = 4, sanity = nil, health = nil
            }
        },
        product = {
            stackable = nil, floatable = { nil, "small", 0.05, 0.9 }, perishable = TUNING.PERISH_MED,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 12.5, sanity = 5, health = 1
            }
        },
        cooked = {
            image = nil, stackable = nil, floatable = { nil, "med", nil, 0.75 }, perishable = TUNING.PERISH_FAST,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 17.5, sanity = nil, health = 3
            }
        },
        oversized = { image = nil, perishable = nil, fireproof = nil, fn_getloots = nil },
        oversized_waxed = { image = nil, fn_getloots = nil },
        oversized_rotten = { image = "yq_dacong_oversized_rot", fn_getloots = nil }
    })
    ----------姜相关
    MakeCropAbout({
        name = "yq_jiang",
        seeds = {
            image = nil, stackable = nil, floatable = { nil, nil, nil, nil }, perishable = nil,
            edible = {
                foodtype = FOODTYPE.SEEDS, foodtype2 = nil, fn_eat = nil,
                hunger = 4, sanity = nil, health = nil
            }
        },
        product = {
            stackable = nil, floatable = { nil, "small", 0.05, 0.9 }, perishable = TUNING.PERISH_MED,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = nil, sanity = -15, health = nil
            }
        },
        cooked = {
            image = nil, stackable = nil, floatable = { nil, "med", nil, 0.75 }, perishable = TUNING.PERISH_FAST,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = nil, sanity = 15, health = -1
            }
        },
        oversized = { image = nil, perishable = nil, fireproof = nil, fn_getloots = nil },
        oversized_waxed = { image = nil, fn_getloots = nil },
        oversized_rotten = { image = "yq_jiang_oversized_rot", fn_getloots = nil }
    })
end

--------------------------------------------------------------------------
--[[ 龙蝇客栈 ]]
--------------------------------------------------------------------------

if not SETS_PASTORAL.ENABLEDMODS["lykz"] then
    ----------丹木种子
    table.insert(prefs, Prefab("danmu_seeds", function()
        local inst = CreateEntity()

        Fn_common(inst, "danmu", nil, "seeds", nil)
        SetCropSeeds_common(inst, "danmu")
        SetFloatable(inst, { nil, nil, nil, nil })

        inst:AddTag("cookable") --烤制组件所需
        inst:AddTag("oceanfishing_lure") --海钓饵组件所需

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        Fn_server(inst, "danmu_seeds")
        SetEdible(inst, {
            foodtype = FOODTYPE.SEEDS, foodtype2 = nil, fn_eat = nil,
            hunger = TUNING.CALORIES_TINY, sanity = nil, health = 0.5
        })
        SetStackable(inst, nil)
        SetPerishable(inst, 999*480, "spoiled_food", nil)
        SetCookable(inst, "seeds_cooked")
        SetLure(inst, lure_seeds)
        SetCropSeeds_server(inst, "danmu")
        -- InitVeggie(inst)

        inst:AddComponent("bait")
        inst:AddComponent("tradable")
        MakeHauntableLaunchAndPerish(inst)

        return inst
    end, {
        Asset("ANIM", "anim/danmu.zip"),
        Asset("ATLAS", "images/inventoryimages/danmu_seeds.xml"),
        Asset("IMAGE", "images/inventoryimages/danmu_seeds.tex"),
        Asset("ATLAS_BUILD", "images/inventoryimages/danmu_seeds.xml", 256),
        Asset("ANIM", "anim/oceanfishing_lure_mis.zip")
    }, { "farm_plant_danmu" }))

    ----------丹木果实
    table.insert(prefs, Prefab("danmu", function()
        local inst = CreateEntity()

        Fn_common(inst, "danmu", nil, "idle", nil)
        SetFloatable(inst, { nil, nil, nil, nil })

        -- inst:AddTag("cookable")
        -- inst:AddTag("weighable_OVERSIZEDVEGGIES") --称重组件所需

        inst.pickupsound = "vegetation_firm"

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        Fn_server(inst, "danmu")
        SetEdible(inst, {
            foodtype = FOODTYPE.GOODIES, foodtype2 = nil, fn_eat = nil,
            hunger = 999, sanity = nil, health = nil
        })
        SetStackable(inst, nil)
        SetPerishable(inst, 999*480, "spoiled_food", nil)
        -- SetCookable(inst, "danmu_cooked")
        -- SetWeighable(inst, nil) --原作者这里写错了，所以我这里不敢加这个组件
        -- InitVeggie(inst)

        inst:AddComponent("bait")
        inst:AddComponent("tradable")
        MakeHauntableLaunchAndPerish(inst)

        return inst
    end, GetAssets("danmu", {
        Asset("ATLAS_BUILD", "images/inventoryimages/danmu.xml", 256)
    }), { "splash_green", "danmu_seeds", "danmu_oversized" }))

    ----------巨型丹木果实
    local function AddBuffFx_danmu_oversized(inst)
        if inst.danmu_fx==nil then
            inst.danmu_fx = SpawnPrefab("danmufx")
            inst.danmu_fx.entity:SetParent(inst.entity)
        end
        if not inst:HasTag("danmufx") then
            inst:AddTag("danmufx")
        end
    end
    local function RemoveBuffFx_danmu_oversized(inst)
        if inst.danmu_fx  then
            inst.danmu_fx:Remove()
            inst.danmu_fx = nil
        end
        if inst:HasTag("danmufx") then
            inst:RemoveTag("danmufx")
        end
    end
    local function TryAddBuff_danmu_oversized(inst)
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 30,{ "player" })
        for i, v in ipairs(ents) do
            if v and v.components.health  and v.components.combat and v.components.locomotor and v.components.hunger then
                if inst.addbuff[v] == nil then
                    if not v.components.health:IsDead() then
                        inst.addbuff[v] = v
                        v.components.health.externalfiredamagemultipliers:SetModifier("danmu", 0)
                        v.components.hunger.burnratemodifiers:SetModifier("danmu", 0)
                        AddBuffFx_danmu_oversized(v)
                    end
                end
            end
        end
        for k, v in pairs(inst.addbuff) do
            if v and v:IsValid() and v.components.health  and v.components.combat and v.components.locomotor and v.components.hunger then

                if v.components.health and v.components.health:IsDead() or  v:GetDistanceSqToInst(inst) >  225  then
                    inst.addbuff[v] = nil
                    v.components.health.externalfiredamagemultipliers:RemoveModifier("danmu")
                    v.components.hunger.burnratemodifiers:RemoveModifier("danmu")
                    RemoveBuffFx_danmu_oversized(v)
                else
                    v.components.health.externalfiredamagemultipliers:SetModifier("danmu", 0)
                    v.components.hunger.burnratemodifiers:SetModifier("danmu", 0)
                    AddBuffFx_danmu_oversized(v)

                    if inst.components.perishable then
                    local perishtime=inst.components.perishable.perishtime
                    inst.components.perishable:SetPerishTime(perishtime-10)
                    end
                end
            end
        end
    end
    local function OnRemove_danmu_oversized(inst)
        for k, v in pairs(inst.addbuff) do
            if  v  and v.components.health  and v.components.combat and v.components.locomotor and v.components.hunger   then 
                    inst.addbuff[v] = nil
                    v.components.health.externalfiredamagemultipliers:RemoveModifier("danmu")
                    v.components.hunger.burnratemodifiers:RemoveModifier("danmu")
                    RemoveBuffFx_danmu_oversized(v)
            end
        end
    end
    table.insert(prefs, Prefab("danmu_oversized", function()
        local inst = CreateEntity()

        local plant_def = PLANT_DEFS["danmu"]
        Fn_common_crop_oversized(inst, plant_def.bank, plant_def.build, nil, nil, "danmu")

        -- inst:AddTag("waxable") --打蜡组件所需
	    inst:AddTag("show_spoilage")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        InitOversizedCrop(inst)
        Fn_server(inst, "danmu_oversized")
        Fn_server_crop_oversized(inst, plant_def.build, "swap_body", GetLoots_oversized(inst, "danmu"), true)
        -- SetWaxable(inst, OnWaxed_oversized)
        SetWeighable_oversized(inst, nil, plant_def.weight_data)
        SetPerishable(inst, 999*480, nil, inst.Remove)

        --特殊能力，给周围的玩家提供防火buff
        inst.addbuff = {}
		inst.buffs = inst:DoPeriodicTask(1, TryAddBuff_danmu_oversized, 1.5*math.random())
		inst:ListenForEvent("onremove", OnRemove_danmu_oversized)

        return inst
    end, {
        Asset("ANIM", "anim/farm_plant_danmu.zip"),
        Asset("ATLAS", "images/inventoryimages/danmu_oversized.xml"),
        Asset("IMAGE", "images/inventoryimages/danmu_oversized.tex"),
        Asset("ATLAS_BUILD", "images/inventoryimages/danmu_oversized.xml", 256)
    }, nil))

    ----------巨型丹木果实（打过蜡的）
    table.insert(prefs, Prefab("danmu_oversized_waxed", function()
        local inst = CreateEntity()

        local plant_def = PLANT_DEFS["danmu"]
        Fn_common_crop_oversized(inst, plant_def.bank, plant_def.build, nil, nil, "danmu")

        inst.displayadjectivefn = DisplayAdjective_oversized_waxed
        inst:SetPrefabNameOverride("danmu_oversized")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        Fn_server(inst, "danmu_oversized") --打蜡的贴图和没打蜡的一样
        Fn_server_crop_oversized(inst, plant_def.build, "swap_body", {"spoiled_food"}, true)
        -- InitWaxedCrop(inst)

        return inst
    end, {
        Asset("ANIM", "anim/farm_plant_danmu.zip"),
        Asset("ATLAS", "images/inventoryimages/danmu_oversized.xml"),
        Asset("IMAGE", "images/inventoryimages/danmu_oversized.tex"),
        Asset("ATLAS_BUILD", "images/inventoryimages/danmu_oversized.xml", 256)
    }, nil))

    ----------巨型丹木果实的防火特效
    table.insert(prefs, Prefab("danmufx", function()
        local inst = CreateEntity()
        inst.entity:AddTransform()
		inst.entity:AddAnimState()
		-- inst.entity:AddSoundEmitter() --不需要这个
		inst.entity:AddNetwork()

		inst.AnimState:SetBank("danmu")
		inst.AnimState:SetBuild("danmu")
		inst.AnimState:PlayAnimation("idle", false)
		inst.AnimState:SetScale(0.3, 0.3, 0.3)
		inst:AddTag("FX")
		inst:AddTag("NOCLICK")
		inst:AddTag("NOBlOCK")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        local FX = SpawnPrefab("farm_plant_happy")
		if FX then
			inst:AddChild(FX)
			FX.Transform:SetPosition(0, 0, 0)
			inst.FX = FX
		end
		inst:DoPeriodicTask(3, function(inst)
            FX = SpawnPrefab("farm_plant_happy")
            if FX then
                inst:AddChild(FX)
                FX.Transform:SetPosition(0, 0, 0)
                inst.FX = FX
            end
		end)

        return inst
    end, {
        Asset("ANIM", "anim/danmu.zip")
    }, nil))
end

--------------------------------------------------------------------------
--[[ 武林大会高难作物 ]]
--------------------------------------------------------------------------

if not SETS_PASTORAL.ENABLEDMODS["wulin"] then
    local function Fn_server_wulin(inst, img)
        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = img
        inst.components.inventoryitem.atlasname = "images/inventoryimages/hardimages.xml"
    end
    local function OnPerish_oversized_wulin(inst)
        if PLANT_DEFS[inst._base_name] and PLANT_DEFS[inst._base_name].loot_oversized_rot then
            inst.components.lootdropper:SetLoot(PLANT_DEFS[inst._base_name].loot_oversized_rot)
            inst.components.lootdropper:DropLoot()
        end
        inst:Remove()
    end
    local function MakeCropAbout_wulin(dd)
        if dd.seeds ~= nil then ----------种子
            local prefabname = dd.name.."_seeds"
            table.insert(prefs, Prefab(prefabname, function()
                local inst = CreateEntity()

                Fn_common(inst, "gzresource", nil, prefabname, nil)
                SetCropSeeds_common(inst, dd.name)
                SetFloatable(inst, dd.seeds.floatable)

                inst:AddTag("cookable") --烤制组件所需
                -- inst:AddTag("oceanfishing_lure") --海钓饵组件所需

                inst.entity:SetPristine()
                if not TheWorld.ismastersim then return inst end

                Fn_server_wulin(inst, prefabname)
                SetEdible(inst, dd.seeds.edible)
                SetStackable(inst, dd.seeds.stackable)
                SetPerishable(inst, dd.seeds.perishable or TUNING.PERISH_SUPERSLOW, "spoiled_food", nil)
                SetCookable(inst, "seeds_cooked")
                -- SetLure(inst, lure_seeds)
                SetCropSeeds_server(inst, dd.name)
                InitVeggie(inst)

                return inst
            end, {
                Asset("ANIM", "anim/gzresource.zip"),
                Asset("ATLAS", "images/inventoryimages/hardimages.xml"),
                Asset("IMAGE", "images/inventoryimages/hardimages.tex"),
                Asset("ATLAS_BUILD", "images/inventoryimages/hardimages.xml", 256),
                -- Asset("ANIM", "anim/oceanfishing_lure_mis.zip")
            }, { "farm_plant_"..dd.name }))
        end
        if dd.product ~= nil then ----------果实
            table.insert(prefs, Prefab(dd.name, function()
                local inst = CreateEntity()

                Fn_common(inst, "gzresource", nil, dd.name, nil)
                SetFloatable(inst, dd.product.floatable)

                inst:AddTag("cookable")
                -- inst:AddTag("weighable_OVERSIZEDVEGGIES") --称重组件所需

                inst.pickupsound = "vegetation_firm"

                inst.entity:SetPristine()
                if not TheWorld.ismastersim then return inst end

                Fn_server_wulin(inst, dd.name)
                SetEdible(inst, dd.product.edible)
                SetStackable(inst, dd.product.stackable)
                SetPerishable(inst, dd.product.perishable, "spoiled_food", nil)
                SetCookable(inst, dd.name.."_cooked")
                -- SetWeighable(inst, nil)
                InitVeggie(inst)

                return inst
            end, {
                Asset("ANIM", "anim/gzresource.zip"),
                Asset("ATLAS", "images/inventoryimages/hardimages.xml"),
                Asset("IMAGE", "images/inventoryimages/hardimages.tex"),
                Asset("ATLAS_BUILD", "images/inventoryimages/hardimages.xml", 256)
            }, GetPrefabs_crop(dd.name, { dd.name.."_cooked" })))
        end
        if dd.cooked ~= nil then ----------果实（烤制）
            local prefabname = dd.name.."_cooked"
            table.insert(prefs, Prefab(prefabname, function()
                local inst = CreateEntity()

                Fn_common(inst, "gzresource", nil, prefabname, nil)
                SetFloatable(inst, dd.cooked.floatable)

                inst.entity:SetPristine()
                if not TheWorld.ismastersim then return inst end

                Fn_server_wulin(inst, prefabname)
                SetEdible(inst, dd.cooked.edible)
                SetStackable(inst, dd.cooked.stackable)
                SetPerishable(inst, dd.cooked.perishable, "spoiled_food", nil)
                InitVeggie(inst)

                return inst
            end, {
                Asset("ANIM", "anim/gzresource.zip"),
                Asset("ATLAS", "images/inventoryimages/hardimages.xml"),
                Asset("IMAGE", "images/inventoryimages/hardimages.tex"),
                Asset("ATLAS_BUILD", "images/inventoryimages/hardimages.xml", 256)
            }, nil))
        end
        if dd.advanced ~= nil then ----------果实（果干）
            local prefabname = dd.name.."_advanced"
            table.insert(prefs, Prefab(prefabname, function()
                local inst = CreateEntity()

                Fn_common(inst, "gzresource", nil, prefabname, nil)
                SetFloatable(inst, dd.advanced.floatable)

                inst.Transform:SetScale(1.4, 1.4, 1.4)

                inst.entity:SetPristine()
                if not TheWorld.ismastersim then return inst end

                local perishtime = dd.advanced.perishable
                if perishtime == nil then
                    if dd.cooked and dd.cooked.perishable then
                        perishtime = dd.cooked.perishable * 4
                    else
                        perishtime = TUNING.PERISH_MED * 4
                    end
                end

                local edible = dd.advanced.edible
                if edible == nil then
                    if dd.cooked and dd.cooked.edible then
                        edible = {}
                        if dd.cooked.edible.hunger ~= nil then
                            edible.hunger = dd.cooked.edible.hunger * 4
                        end
                        if dd.cooked.edible.sanity ~= nil then
                            edible.sanity = dd.cooked.edible.sanity * 4
                        end
                        if dd.cooked.edible.health ~= nil then
                            edible.health = dd.cooked.edible.health * 4
                        end
                    else
                        edible = {
                            -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                            hunger = 25, sanity = 25, health = 25
                        }
                    end
                end

                Fn_server_wulin(inst, prefabname)
                SetEdible(inst, edible)
                SetStackable(inst, dd.advanced.stackable)
                SetPerishable(inst, perishtime, "spoiled_food", nil)
                InitVeggie(inst)

                return inst
            end, {
                Asset("ANIM", "anim/gzresource.zip"),
                Asset("ATLAS", "images/inventoryimages/hardimages.xml"),
                Asset("IMAGE", "images/inventoryimages/hardimages.tex"),
                Asset("ATLAS_BUILD", "images/inventoryimages/hardimages.xml", 256)
            }, nil))
        end
        if dd.oversized ~= nil then ----------巨型果实
            local prefabname = dd.name.."_oversized"
            table.insert(prefs, Prefab(prefabname, function()
                local inst = CreateEntity()

                local plant_def = PLANT_DEFS[dd.name]
                Fn_common_crop_oversized(inst, plant_def.bank, plant_def.build, nil, nil, dd.name)

                inst:AddTag("waxable") --打蜡组件所需
                inst:AddTag("show_spoilage")

                inst.entity:SetPristine()
                if not TheWorld.ismastersim then return inst end

                local myloots
                if dd.oversized.fn_getloots == nil then
                    myloots = GetLoots_oversized(inst, dd.name)
                else
                    myloots = dd.oversized.fn_getloots(inst, dd.name)
                end

                local perishtime = dd.oversized.perishable
                if perishtime == nil then
                    if dd.product and dd.product.perishable then
                        perishtime = dd.product.perishable * OVERSIZED_PERISHTIME_MULT
                    else
                        perishtime = TUNING.PERISH_MED * OVERSIZED_PERISHTIME_MULT
                    end
                end

                InitOversizedCrop(inst)
                Fn_server_wulin(inst, prefabname)
                Fn_server_crop_oversized(inst, plant_def.build, "swap_body", myloots, dd.oversized.fireproof)
                SetWaxable(inst, OnWaxed_oversized)
                SetWeighable_oversized(inst, nil, plant_def.weight_data)
                SetPerishable(inst, perishtime, nil, OnPerish_oversized_wulin)

                return inst
            end, {
                Asset("ANIM", "anim/farm_plant_"..dd.name..".zip"),
                Asset("ATLAS", "images/inventoryimages/hardimages.xml"),
                Asset("IMAGE", "images/inventoryimages/hardimages.tex"),
                Asset("ATLAS_BUILD", "images/inventoryimages/hardimages.xml", 256)
            }, nil))
        end
        if dd.oversized_waxed ~= nil then ----------巨型果实（打过蜡的）
            local prefabname = dd.name.."_oversized_waxed"
            table.insert(prefs, Prefab(prefabname, function()
                local inst = CreateEntity()

                local plant_def = PLANT_DEFS[dd.name]
                Fn_common_crop_oversized(inst, plant_def.bank, plant_def.build, nil, nil, dd.name)

                inst.displayadjectivefn = DisplayAdjective_oversized_waxed
                inst:SetPrefabNameOverride(dd.name.."_oversized")

                inst.entity:SetPristine()
                if not TheWorld.ismastersim then return inst end

                local myloots
                if dd.oversized_waxed.fn_getloots == nil then
                    myloots = { "spoiled_food" }
                else
                    myloots = dd.oversized_waxed.fn_getloots(inst, dd.name)
                end

                Fn_server_wulin(inst, prefabname)
                Fn_server_crop_oversized(inst, plant_def.build, "swap_body", myloots, nil)
                InitWaxedCrop(inst)

                return inst
            end, {
                Asset("ANIM", "anim/farm_plant_"..dd.name..".zip"),
                Asset("ATLAS", "images/inventoryimages/hardimages.xml"),
                Asset("IMAGE", "images/inventoryimages/hardimages.tex"),
                Asset("ATLAS_BUILD", "images/inventoryimages/hardimages.xml", 256)
            }, nil))
        end
        -- if dd.oversized_rotten ~= nil then ----------巨型腐烂果实。因为巨型腐烂果实没法显示动画，所以干脆不要这个了
        --     local prefabname = dd.name.."_oversized_rotten"
        --     table.insert(prefs, Prefab(prefabname, function()
        --         local inst = CreateEntity()

        --         local plant_def = PLANT_DEFS[dd.name]
        --         Fn_common_crop_oversized(inst, plant_def.bank, plant_def.build, "idle_rot_oversized", nil, dd.name)
        --         Fn_common_crop_oversized_rotten(inst)

        --         inst.entity:SetPristine()
        --         if not TheWorld.ismastersim then return inst end

        --         local myloots
        --         if dd.oversized_rotten.fn_getloots == nil then
        --             myloots = plant_def.loot_oversized_rot
        --         else
        --             myloots = dd.oversized_rotten.fn_getloots(inst, dd.name)
        --         end

        --         Fn_server_wulin(inst, dd.name.."_oversized") --该作物没有对应的巨型腐烂果实的贴图
        --         Fn_server_crop_oversized(inst, plant_def.build, "swap_body", myloots, nil) --该作物没有巨型枯萎果实装备图
        --         Fn_server_crop_oversized_rotten(inst)

        --         return inst
        --     end, {
        --         Asset("ANIM", "anim/farm_plant_"..dd.name..".zip"),
        --         Asset("ATLAS", "images/inventoryimages/hardimages.xml"),
        --         Asset("IMAGE", "images/inventoryimages/hardimages.tex"),
        --         Asset("ATLAS_BUILD", "images/inventoryimages/hardimages.xml", 256)
        --     }, nil))
        -- end
    end
    local function GetLoots_oversized_wulin(inst, name)
        local seeds = name.."_seeds"
        return { name.."_advanced", name, name, seeds, seeds, math.random() < 0.75 and name or seeds }
    end

    ----------苹果相关
    MakeCropAbout_wulin({
        name = "gzresource_apple",
        seeds = {
            stackable = nil, floatable = { nil, nil, nil, nil }, perishable = nil,
            edible = {
                foodtype = FOODTYPE.SEEDS, foodtype2 = nil, fn_eat = nil,
                hunger = TUNING.CALORIES_TINY, sanity = nil, health = 0.5
            }
        },
        product = {
            stackable = nil, floatable = { nil, "small", 0.2, 0.9 }, perishable = TUNING.PERISH_FASTISH,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 18, sanity = 5, health = 10
            }
        },
        cooked = {
            stackable = nil, floatable = { nil, "small", 0.2, 1 }, perishable = TUNING.PERISH_FAST,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 9, sanity = 5, health = 10
            }
        },
        advanced = { stackable = TUNING.STACK_SIZE_LARGEITEM, floatable = { nil, "small", 0.2, 1 } },
        oversized = { perishable = nil, fireproof = nil, fn_getloots = GetLoots_oversized_wulin },
        oversized_waxed = { fn_getloots = nil },
        oversized_rotten = { fn_getloots = nil }
    })
    ----------柠檬相关
    MakeCropAbout_wulin({
        name = "gzresource_lemon",
        seeds = {
            stackable = nil, floatable = { nil, nil, nil, nil }, perishable = nil,
            edible = {
                foodtype = FOODTYPE.SEEDS, foodtype2 = nil, fn_eat = nil,
                hunger = TUNING.CALORIES_TINY, sanity = nil, health = 0.5
            }
        },
        product = {
            stackable = nil, floatable = { nil, "small", 0.2, 0.9 }, perishable = TUNING.PERISH_FASTISH,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 9, sanity = -5, health = nil
            }
        },
        cooked = {
            stackable = nil, floatable = { nil, "small", 0.2, 1 }, perishable = TUNING.PERISH_FAST,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 6, sanity = -8, health = -5
            }
        },
        advanced = { stackable = TUNING.STACK_SIZE_LARGEITEM, floatable = { nil, "small", 0.2, 1 } },
        oversized = { perishable = nil, fireproof = nil, fn_getloots = GetLoots_oversized_wulin },
        oversized_waxed = { fn_getloots = nil },
        oversized_rotten = { fn_getloots = nil }
    })
    ----------金芒相关
    MakeCropAbout_wulin({
        name = "gzresource_mango",
        seeds = {
            stackable = nil, floatable = { nil, nil, nil, nil }, perishable = nil,
            edible = {
                foodtype = FOODTYPE.SEEDS, foodtype2 = nil, fn_eat = nil,
                hunger = TUNING.CALORIES_TINY, sanity = nil, health = 0.5
            }
        },
        product = {
            stackable = nil, floatable = { nil, "small", 0.2, 0.9 }, perishable = TUNING.PERISH_SUPERFAST,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 20, sanity = 5, health = 5
            }
        },
        cooked = {
            stackable = nil, floatable = { nil, "small", 0.2, 1 }, perishable = TUNING.PERISH_ONE_DAY,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 15, sanity = 5, health = 15
            }
        },
        advanced = { stackable = TUNING.STACK_SIZE_LARGEITEM, floatable = { nil, "small", 0.2, 1 } },
        oversized = { perishable = nil, fireproof = nil, fn_getloots = GetLoots_oversized_wulin },
        oversized_waxed = { fn_getloots = nil },
        oversized_rotten = { fn_getloots = nil }
    })
    ----------香橙相关
    MakeCropAbout_wulin({
        name = "gzresource_orange",
        seeds = {
            stackable = nil, floatable = { nil, nil, nil, nil }, perishable = nil,
            edible = {
                foodtype = FOODTYPE.SEEDS, foodtype2 = nil, fn_eat = nil,
                hunger = TUNING.CALORIES_TINY, sanity = nil, health = 0.5
            }
        },
        product = {
            stackable = nil, floatable = { nil, "small", 0.2, 0.9 }, perishable = TUNING.PERISH_SUPERFAST,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 12, sanity = 5, health = 10
            }
        },
        cooked = {
            stackable = nil, floatable = { nil, "small", 0.2, 1 }, perishable = TUNING.PERISH_ONE_DAY,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 3, sanity = 5, health = 25
            }
        },
        advanced = { stackable = TUNING.STACK_SIZE_LARGEITEM, floatable = { nil, "small", 0.2, 1 } },
        oversized = { perishable = nil, fireproof = nil, fn_getloots = GetLoots_oversized_wulin },
        oversized_waxed = { fn_getloots = nil },
        oversized_rotten = { fn_getloots = nil }
    })
    ----------草莓相关
    MakeCropAbout_wulin({
        name = "gzresource_strawberry",
        seeds = {
            stackable = nil, floatable = { nil, nil, nil, nil }, perishable = nil,
            edible = {
                foodtype = FOODTYPE.SEEDS, foodtype2 = nil, fn_eat = nil,
                hunger = TUNING.CALORIES_TINY, sanity = nil, health = 0.5
            }
        },
        product = {
            stackable = nil, floatable = { nil, "small", 0.2, 0.9 }, perishable = TUNING.PERISH_SUPERFAST,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 6, sanity = 5, health = 10
            }
        },
        cooked = {
            stackable = nil, floatable = { nil, "small", 0.2, 1 }, perishable = TUNING.PERISH_ONE_DAY,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 6, sanity = 5, health = 15
            }
        },
        advanced = { stackable = TUNING.STACK_SIZE_LARGEITEM, floatable = { nil, "small", 0.2, 1 } },
        oversized = { perishable = nil, fireproof = nil, fn_getloots = GetLoots_oversized_wulin },
        oversized_waxed = { fn_getloots = nil },
        oversized_rotten = { fn_getloots = nil }
    })
    ----------甜菜相关
    MakeCropAbout_wulin({
        name = "gzresource_sugarbeet",
        seeds = {
            stackable = nil, floatable = { nil, nil, nil, nil }, perishable = nil,
            edible = {
                foodtype = FOODTYPE.SEEDS, foodtype2 = nil, fn_eat = nil,
                hunger = TUNING.CALORIES_TINY, sanity = nil, health = 0.5
            }
        },
        product = {
            stackable = nil, floatable = { nil, "small", 0.2, 0.9 }, perishable = TUNING.PERISH_FASTISH,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 25, sanity = nil, health = nil
            }
        },
        cooked = {
            stackable = nil, floatable = { nil, "small", 0.2, 1 }, perishable = TUNING.PERISH_FAST,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 25, sanity = 5, health = 5
            }
        },
        advanced = { stackable = TUNING.STACK_SIZE_LARGEITEM, floatable = { nil, "small", 0.2, 1 } },
        oversized = { perishable = nil, fireproof = nil, fn_getloots = GetLoots_oversized_wulin },
        oversized_waxed = { fn_getloots = nil },
        oversized_rotten = { fn_getloots = nil }
    })
    ----------冬瓜相关
    MakeCropAbout_wulin({
        name = "gzresource_whitegourd",
        seeds = {
            stackable = nil, floatable = { nil, nil, nil, nil }, perishable = nil,
            edible = {
                foodtype = FOODTYPE.SEEDS, foodtype2 = nil, fn_eat = nil,
                hunger = TUNING.CALORIES_TINY, sanity = nil, health = 0.5
            }
        },
        product = {
            stackable = nil, floatable = { nil, "small", 0.2, 0.9 }, perishable = TUNING.PERISH_SUPERFAST,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 3, sanity = 5, health = 15
            }
        },
        cooked = {
            stackable = nil, floatable = { nil, "small", 0.2, 1 }, perishable = TUNING.PERISH_ONE_DAY,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 1, sanity = 10, health = 15
            }
        },
        advanced = { stackable = TUNING.STACK_SIZE_LARGEITEM, floatable = { nil, "small", 0.2, 1 } },
        oversized = { perishable = nil, fireproof = nil, fn_getloots = GetLoots_oversized_wulin },
        oversized_waxed = { fn_getloots = nil },
        oversized_rotten = { fn_getloots = nil }
    })
end

--------------------------------------------------------------------------
--[[ 傲来神仙境 ]]
--------------------------------------------------------------------------

if not SETS_PASTORAL.ENABLEDMODS["aolai"] then
    ----------小麦相关
    MakeCropAbout({
        name = "wheat_myth",
        seeds = {
            image = nil, stackable = nil, floatable = { -0.1, "small", nil, nil }, perishable = nil,
            edible = {
                foodtype = FOODTYPE.SEEDS, foodtype2 = nil, fn_eat = nil,
                hunger = 8, sanity = nil, health = 0.5
            }
        },
        product = {
            stackable = nil, floatable = { nil, "small", 0.2, 0.9 }, perishable = TUNING.PERISH_MED,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 10, sanity = 1, health = 5
            }
        },
        cooked = {
            image = nil, stackable = nil, floatable = { nil, "small", 0.2, 1 }, perishable = TUNING.PERISH_SUPERFAST,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 18.5, sanity = 5, health = 16
            }
        },
        oversized = {
            image = nil, perishable = nil, fireproof = nil,
            -- fn_getloots = function(inst, productname) end
        },
        oversized_waxed = { image = nil, fn_getloots = nil },
        oversized_rotten = { image = nil, fn_getloots = nil }
    })
    ----------大白菜相关
    MakeCropAbout({
        name = "cabbage_myth",
        seeds = {
            image = nil, stackable = nil, floatable = { -0.1, "small", nil, nil }, perishable = nil,
            edible = {
                foodtype = FOODTYPE.SEEDS, foodtype2 = nil, fn_eat = nil,
                hunger = 8, sanity = nil, health = 0.5
            }
        },
        product = {
            stackable = nil, floatable = { nil, "small", 0.2, 0.9 }, perishable = TUNING.PERISH_MED,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 10, sanity = 1, health = 5
            }
        },
        cooked = {
            image = nil, stackable = nil, floatable = { nil, "small", 0.2, 1 }, perishable = TUNING.PERISH_SUPERFAST,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 18.5, sanity = 5, health = 16
            }
        },
        oversized = {
            image = nil, perishable = nil, fireproof = nil,
            -- fn_getloots = function(inst, productname) end
        },
        oversized_waxed = { image = nil, fn_getloots = nil },
        oversized_rotten = { image = nil, fn_getloots = nil }
    })
    ----------茉莉豆相关
    MakeCropAbout({
        name = "jasminebean",
        seeds = {
            image = nil, stackable = nil, floatable = { -0.1, "small", nil, nil }, perishable = nil,
            edible = {
                foodtype = FOODTYPE.SEEDS, foodtype2 = nil, fn_eat = nil,
                hunger = 8, sanity = nil, health = 0.5
            }
        },
        product = {
            stackable = nil, floatable = { nil, "small", 0.2, 0.9 }, perishable = TUNING.PERISH_MED,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 10, sanity = 1, health = 5
            }
        },
        cooked = {
            image = nil, stackable = nil, floatable = { nil, "small", 0.2, 1 }, perishable = TUNING.PERISH_SUPERFAST,
            edible = {
                -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
                hunger = 18.5, sanity = 5, health = 16
            }
        },
        oversized = {
            image = nil, perishable = nil, fireproof = nil,
            -- fn_getloots = function(inst, productname) end
        },
        oversized_waxed = { image = nil, fn_getloots = nil },
        oversized_rotten = { image = nil, fn_getloots = nil }
    })
end

--------------------------------------------------------------------------
--[[ 皮服玫瑰 ]]
--------------------------------------------------------------------------

----------玫瑰种子
table.insert(prefs, Prefab("pm_rose_seeds", function()
    local inst = CreateEntity()

    Fn_common(inst, "pm_rose", nil, "seeds", nil)
    SetCropSeeds_common(inst, "pm_rose")
    SetFloatable(inst, { -0.1, "small", 0.1, nil })

    inst:AddTag("cookable") --烤制组件所需
    inst:AddTag("oceanfishing_lure") --海钓饵组件所需

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "pm_rose_seeds")
    SetEdible(inst, {
        foodtype = FOODTYPE.SEEDS, foodtype2 = nil, fn_eat = nil,
        hunger = TUNING.CALORIES_TINY, sanity = nil, health = 0.5
    })
    SetStackable(inst, nil)
    SetPerishable(inst, TUNING.PERISH_SUPERSLOW, "spoiled_food", nil)
    SetCookable(inst, "seeds_cooked")
    SetLure(inst, lure_seeds)
    SetCropSeeds_server(inst, "pm_rose")
    InitVeggie(inst)

    return inst
end, {
    Asset("ANIM", "anim/pm_rose.zip"),
    Asset("ATLAS", "images/inventoryimages/pm_rose_seeds.xml"),
    Asset("IMAGE", "images/inventoryimages/pm_rose_seeds.tex"),
    Asset("ATLAS_BUILD", "images/inventoryimages/pm_rose_seeds.xml", 256),
    Asset("ANIM", "anim/oceanfishing_lure_mis.zip")
}, { "farm_plant_pm_rose" }))

----------玫瑰
table.insert(prefs, Prefab("pm_rose", function()
    local inst = CreateEntity()

    Fn_common(inst, "pm_rose", nil, "idle", nil)
    SetFloatable(inst, { nil, "small", 0.2, 0.9 })

    -- inst:AddTag("cookable")
    inst:AddTag("weighable_OVERSIZEDVEGGIES") --称重组件所需

    inst.pickupsound = "vegetation_firm"

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "pm_rose")
    SetEdible(inst, {
        -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
        hunger = 3, sanity = 15, health = 15
    })
    SetStackable(inst, nil)
    SetPerishable(inst, TUNING.PERISH_MED, "spoiled_food", nil)
    -- SetCookable(inst, "pm_rose_cooked")
    SetWeighable(inst, nil)
    InitVeggie(inst)

    return inst
end, GetAssets("pm_rose", {
    Asset("ATLAS_BUILD", "images/inventoryimages/pm_rose.xml", 256)
}), GetPrefabs_crop("pm_rose", nil)))

----------巨型玫瑰
table.insert(prefs, Prefab("pm_rose_oversized", function()
    local inst = CreateEntity()

    local plant_def = PLANT_DEFS["pm_rose"]
    Fn_common_crop_oversized(inst, plant_def.bank, "farm_plant_pm_rose_fix", nil, nil, "pm_rose")

    inst:AddTag("waxable") --打蜡组件所需
    inst:AddTag("show_spoilage")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    InitOversizedCrop(inst)
    Fn_server(inst, "pm_rose_oversized")
    Fn_server_crop_oversized(inst, "farm_plant_pm_rose_fix", "swap_body", GetLoots_oversized(inst, "pm_rose"), nil)
    SetWaxable(inst, OnWaxed_oversized)
    SetWeighable_oversized(inst, nil, plant_def.weight_data)
    SetPerishable(inst, TUNING.PERISH_MED*OVERSIZED_PERISHTIME_MULT, nil, OnPerish_oversized)

    return inst
end, {
    Asset("ANIM", "anim/farm_plant_pm_rose_fix.zip"),
    Asset("ATLAS", "images/inventoryimages/pm_rose_oversized.xml"),
    Asset("IMAGE", "images/inventoryimages/pm_rose_oversized.tex"),
    Asset("ATLAS_BUILD", "images/inventoryimages/pm_rose_oversized.xml", 256)
}, nil))

----------巨型玫瑰（打过蜡的）
table.insert(prefs, Prefab("pm_rose_oversized_waxed", function()
    local inst = CreateEntity()

    local plant_def = PLANT_DEFS["pm_rose"]
    Fn_common_crop_oversized(inst, plant_def.bank, "farm_plant_pm_rose_fix", nil, nil, "pm_rose")

    inst.displayadjectivefn = DisplayAdjective_oversized_waxed
    inst:SetPrefabNameOverride("pm_rose_oversized")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "pm_rose_oversized_waxed")
    Fn_server_crop_oversized(inst, "farm_plant_pm_rose_fix", "swap_body", {"spoiled_food"}, nil)
    InitWaxedCrop(inst)

    return inst
end, {
    Asset("ANIM", "anim/farm_plant_pm_rose_fix.zip"),
    Asset("ATLAS", "images/inventoryimages/pm_rose_oversized_waxed.xml"),
    Asset("IMAGE", "images/inventoryimages/pm_rose_oversized_waxed.tex"),
    Asset("ATLAS_BUILD", "images/inventoryimages/pm_rose_oversized_waxed.xml", 256)
}, nil))

----------巨型腐烂玫瑰
table.insert(prefs, Prefab("pm_rose_oversized_rotten", function()
    local inst = CreateEntity()

    local plant_def = PLANT_DEFS["pm_rose"]
    Fn_common_crop_oversized(inst, plant_def.bank, "farm_plant_pm_rose_fix", "idle_rot_oversized", nil, "pm_rose")
    Fn_common_crop_oversized_rotten(inst)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "pm_rose_oversized_rotten")
    Fn_server_crop_oversized(inst, "farm_plant_pm_rose_fix", "swap_body_rotten", plant_def.loot_oversized_rot, nil)
    Fn_server_crop_oversized_rotten(inst)

    return inst
end, {
    Asset("ANIM", "anim/farm_plant_pm_rose_fix.zip"),
    Asset("ATLAS", "images/inventoryimages/pm_rose_oversized_rotten.xml"),
    Asset("IMAGE", "images/inventoryimages/pm_rose_oversized_rotten.tex"),
    Asset("ATLAS_BUILD", "images/inventoryimages/pm_rose_oversized_rotten.xml", 256)
}, nil))

--------------------------------------------------------------------------
--[[ 道诡异仙 ]]
--------------------------------------------------------------------------

if not SETS_PASTORAL.ENABLEDMODS["daogui"] then
    ----------哈密瓜种子
    table.insert(prefs, Prefab("daogui_hmg_seeds", function()
        local inst = CreateEntity()

        Fn_common(inst, "daogui_hmg_plant", nil, "seed_idle", nil)
        SetCropSeeds_common(inst, "daogui_hmg")
        SetFloatable(inst, { -0.1, "small", nil, nil })

        inst:AddTag("cookable") --烤制组件所需
        inst:AddTag("oceanfishing_lure") --海钓饵组件所需

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        Fn_server(inst, "daogui_hmg_seeds")
        SetEdible(inst, {
            foodtype = FOODTYPE.SEEDS, foodtype2 = nil, fn_eat = nil,
            hunger = TUNING.CALORIES_TINY, sanity = nil, health = 0.5
        })
        SetStackable(inst, nil)
        SetPerishable(inst, TUNING.PERISH_SUPERSLOW, "spoiled_food", nil)
        SetCookable(inst, "seeds_cooked")
        SetLure(inst, lure_seeds)
        SetCropSeeds_server(inst, "daogui_hmg")
        InitVeggie(inst)

        return inst
    end, {
        Asset("ANIM", "anim/daogui_hmg_plant.zip"),
        Asset("ATLAS", "images/inventoryimages/daogui_hmg_seeds.xml"),
        Asset("IMAGE", "images/inventoryimages/daogui_hmg_seeds.tex"),
        Asset("ATLAS_BUILD", "images/inventoryimages/daogui_hmg_seeds.xml", 256),
        Asset("ANIM", "anim/oceanfishing_lure_mis.zip")
    }, { "farm_plant_daogui_hmg" }))

    ----------哈密瓜
    table.insert(prefs, Prefab("daogui_hmg", function()
        local inst = CreateEntity()

        Fn_common(inst, "daogui_hmg_plant", nil, "idle", nil)
        SetFloatable(inst, { nil, "small", 0.2, 0.9 })

        inst:AddTag("cookable")
        -- inst:AddTag("weighable_OVERSIZEDVEGGIES") --称重组件所需

        inst.pickupsound = "vegetation_firm"

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        Fn_server(inst, "daogui_hmg")
        SetEdible(inst, {
            -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
            hunger = 4, sanity = 15, health = 3.5
        })
        SetStackable(inst, nil)
        SetPerishable(inst, TUNING.PERISH_MED, "spoiled_food", nil)
        SetCookable(inst, "daogui_hmg_cooked")
        -- SetWeighable(inst, nil) --动画没有对应贴图，所以不要上称，免得贴图是空的
        InitVeggie(inst)

        inst.components.edible.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP --食用后降温
        inst.components.edible.temperatureduration = TUNING.FOOD_TEMP_BRIEF

        return inst
    end, {
        Asset("ANIM", "anim/daogui_hmg_plant.zip"),
        Asset("ATLAS", "images/inventoryimages/daogui_hmg.xml"),
        Asset("IMAGE", "images/inventoryimages/daogui_hmg.tex"),
        Asset("ATLAS_BUILD", "images/inventoryimages/daogui_hmg.xml", 256)
    }, GetPrefabs_crop("daogui_hmg", { "daogui_hmg_cooked" })))

    ----------烤哈密瓜
    table.insert(prefs, Prefab("daogui_hmg_cooked", function()
        local inst = CreateEntity()

        Fn_common(inst, "daogui_hmg_plant", nil, "cooked_idle", nil)
        SetFloatable(inst, { nil, "small", 0.2, 1 })

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        Fn_server(inst, "daogui_hmg_cooked")
        SetEdible(inst, {
            -- foodtype = nil, foodtype2 = nil, fn_eat = nil,
            hunger = 6, sanity = 16, health = 7
        })
        SetStackable(inst, nil)
        SetPerishable(inst, TUNING.PERISH_SUPERFAST, "spoiled_food", nil)
        InitVeggie(inst)

        return inst
    end, {
        Asset("ANIM", "anim/daogui_hmg_plant.zip"),
        Asset("ATLAS", "images/inventoryimages/daogui_hmg_cooked.xml"),
        Asset("IMAGE", "images/inventoryimages/daogui_hmg_cooked.tex"),
        Asset("ATLAS_BUILD", "images/inventoryimages/daogui_hmg_cooked.xml", 256)
    }, nil))

    ----------巨型哈密瓜
    table.insert(prefs, Prefab("daogui_hmg_oversized", function()
        local inst = CreateEntity()

        local plant_def = PLANT_DEFS["daogui_hmg"]
        Fn_common_crop_oversized(inst, plant_def.bank, plant_def.build, nil, nil, "daogui_hmg")

        inst:AddTag("waxable") --打蜡组件所需
	    inst:AddTag("show_spoilage")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        InitOversizedCrop(inst)
        Fn_server(inst, "daogui_hmg")
        Fn_server_crop_oversized(inst, plant_def.build, "swap_body", GetLoots_oversized(inst, "daogui_hmg"), nil)
        SetWaxable(inst, OnWaxed_oversized)
        SetWeighable_oversized(inst, nil, plant_def.weight_data)
        SetPerishable(inst, TUNING.PERISH_MED*OVERSIZED_PERISHTIME_MULT, nil, OnPerish_oversized)

        return inst
    end, {
        Asset("ANIM", "anim/farm_plant_daogui_hmg.zip"),
        Asset("ATLAS", "images/inventoryimages/daogui_hmg.xml"),
        Asset("IMAGE", "images/inventoryimages/daogui_hmg.tex"),
        Asset("ATLAS_BUILD", "images/inventoryimages/daogui_hmg.xml", 256)
    }, nil))

    ----------巨型哈密瓜（打过蜡的）
    table.insert(prefs, Prefab("daogui_hmg_oversized_waxed", function()
        local inst = CreateEntity()

        local plant_def = PLANT_DEFS["daogui_hmg"]
        Fn_common_crop_oversized(inst, plant_def.bank, plant_def.build, nil, nil, "daogui_hmg")

        inst.displayadjectivefn = DisplayAdjective_oversized_waxed
        inst:SetPrefabNameOverride("daogui_hmg_oversized")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        Fn_server(inst, "daogui_hmg")
        Fn_server_crop_oversized(inst, plant_def.build, "swap_body", {"spoiled_food"}, nil)
        InitWaxedCrop(inst)

        return inst
    end, {
        Asset("ANIM", "anim/farm_plant_daogui_hmg.zip"),
        Asset("ATLAS", "images/inventoryimages/daogui_hmg.xml"),
        Asset("IMAGE", "images/inventoryimages/daogui_hmg.tex"),
        Asset("ATLAS_BUILD", "images/inventoryimages/daogui_hmg.xml", 256)
    }, nil))

    ----------巨型腐烂哈密瓜
    table.insert(prefs, Prefab("daogui_hmg_oversized_rotten", function()
        local inst = CreateEntity()

        local plant_def = PLANT_DEFS["daogui_hmg"]
        Fn_common_crop_oversized(inst, plant_def.bank, plant_def.build, "idle_rot_oversized", nil, "daogui_hmg")
        Fn_common_crop_oversized_rotten(inst)

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        Fn_server(inst, "daogui_hmg_rot_oversized")
        Fn_server_crop_oversized(inst, plant_def.build, "swap_body_rotten", plant_def.loot_oversized_rot, nil)
        Fn_server_crop_oversized_rotten(inst)

        return inst
    end, {
        Asset("ANIM", "anim/farm_plant_daogui_hmg.zip"),
        Asset("ATLAS", "images/inventoryimages/daogui_hmg_rot_oversized.xml"),
        Asset("IMAGE", "images/inventoryimages/daogui_hmg_rot_oversized.tex"),
        Asset("ATLAS_BUILD", "images/inventoryimages/daogui_hmg_rot_oversized.xml", 256)
    }, nil))
end

-------------------------

return unpack(prefs)
