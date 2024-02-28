local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS
local prefs = {}

--------------------------------------------------------------------------
--[[ 通用 ]]
--------------------------------------------------------------------------

local function GetAssets(name, other)
    local sets = {
        Asset("ANIM", "anim/"..name..".zip"),
        Asset("ATLAS", "images/inventoryimages/"..name..".xml"),
        Asset("IMAGE", "images/inventoryimages/"..name..".tex"),
        Asset("ATLAS_BUILD", "images/inventoryimages/"..name..".xml", 256)
    }
    if other ~= nil then
        for _, v in pairs(other) do
            table.insert(sets, v)
        end
    end
    return sets
end
local function GetAssets_inv(name, other)
    local sets = {
        Asset("ATLAS", "images/inventoryimages/"..name..".xml"),
        Asset("IMAGE", "images/inventoryimages/"..name..".tex"),
        Asset("ATLAS_BUILD", "images/inventoryimages/"..name..".xml", 256)
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

--------------------------------------------------------------------------
--[[ 料理相关 ]]
--------------------------------------------------------------------------

------通用料理

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

for k, v in pairs(require("preparedfoods_legion")) do
    MakeDish(v)
end
for k, v in pairs(require("preparedfoods_legion_spiced")) do
    if not v.notinitprefab then --部分调料后料理不用通用机制
        MakeDish(v)
    end
end

--------------------------------------------------------------------------
--[[ 各种食物 ]]
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--[[ 作物种子、果实相关 ]]
--------------------------------------------------------------------------

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

----------
--松萝相关
----------

------松萝种子
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
end, GetAssets_inv("pineananas_seeds", {
    -- Asset("ANIM", "anim/farm_plant_seeds.zip"), --Tip：不要再注册动官方作物动画，会导致动画顺序混乱，因为作物动画有注册顺序要求
    Asset("ANIM", "anim/pineananas.zip"),
    Asset("ANIM", "anim/oceanfishing_lure_mis.zip")
}), { "farm_plant_pineananas" }))

------松萝
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
end, GetAssets("pineananas"), GetPrefabs_crop("pineananas", { "pineananas_cooked" })))

------烤松萝
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
end, GetAssets_inv("pineananas_cooked", { Asset("ANIM", "anim/pineananas.zip") }), nil))

------巨型松萝
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
end, GetAssets_inv("pineananas_oversized", { Asset("ANIM", "anim/farm_plant_pineananas.zip") }), nil))

------巨型松萝（打过蜡的）
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
end, GetAssets_inv("pineananas_oversized_waxed", { Asset("ANIM", "anim/farm_plant_pineananas.zip") }), nil))

------巨型腐烂松萝
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
end, GetAssets_inv("pineananas_oversized_rotten", { Asset("ANIM", "anim/farm_plant_pineananas.zip") }), nil))

-------------------------

return unpack(prefs)
