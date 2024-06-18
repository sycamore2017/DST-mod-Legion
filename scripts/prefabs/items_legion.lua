local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS
local TOOLS_L = require("tools_legion")
local prefs = {}

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
local function GetAssets2(name, build, other)
    local sets = {
        Asset("ANIM", "anim/"..build..".zip"),
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
local function InitVeggie(inst)
    inst:AddComponent("bait")
    inst:AddComponent("tradable")

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    MakeHauntableLaunch(inst)
end
local function InitItem(inst, burntime)
    MakeSmallBurnable(inst, burntime)
    MakeSmallPropagator(inst)
    MakeHauntableLaunch(inst)
end

local function SetStackable(inst, maxsize) --叠加组件
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = maxsize or TUNING.STACK_SIZE_SMALLITEM
end
local function SetPerishable(inst, time, replacement, onperish) --新鲜度组件
    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(time)
    if replacement ~= nil then
        inst.components.perishable.onperishreplacement = replacement
    end
    if onperish ~= nil then
        inst.components.perishable:SetOnPerishFn(onperish)
    end
    inst.components.perishable:StartPerishing()
end
local function SetFuel(inst, value) --燃料组件
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = value or TUNING.TINY_FUEL
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
local function SetDeployable(inst, ondeploy, mode, spacing) --摆放组件
    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    if mode ~= nil then
        inst.components.deployable:SetDeployMode(mode)
    end
    if spacing ~= nil then
        inst.components.deployable:SetDeploySpacing(spacing)
    end
end
local function SetOintmentLegion(inst, fn_check, fn_smear) --涂抹组件
    inst:AddComponent("ointmentlegion")
    inst.components.ointmentlegion.fn_check = fn_check
    inst.components.ointmentlegion.fn_smear = fn_smear
end
local function SetTradable(inst, goldvalue, rocktribute) --交易组件
    inst:AddComponent("tradable")
    if goldvalue ~= nil then --大于0就能和猪王换等量金块，或者和蚁狮换1沙之石
        inst.components.tradable.goldvalue = goldvalue
    end
    if rocktribute ~= nil then --大于0就能给蚁狮，让蚁狮暂缓地震。延缓 0.33 x rocktribute 天地震
        inst.components.tradable.rocktribute = rocktribute
    end
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

table.insert(prefs, Prefab("petals_rose", function() ------蔷薇花瓣
    local inst = CreateEntity()
    Fn_common(inst, "petals_rose", nil, "idle", nil)
    SetFloatable(inst, { nil, "small", 0.08, 0.95 })

    inst.pickupsound = "vegetation_firm"

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "petals_rose")
    SetEdible(inst, { hunger = 9.375, sanity = 1, health = 8 })
    SetStackable(inst, nil)
    SetPerishable(inst, TUNING.PERISH_FAST, "spoiled_food", nil)
    SetFuel(inst, nil)
    InitVeggie(inst)

    return inst
end, GetAssets("petals_rose"), nil))

table.insert(prefs, Prefab("petals_lily", function() ------蹄莲花瓣
    local inst = CreateEntity()
    Fn_common(inst, "petals_lily", nil, "idle", nil)
    SetFloatable(inst, { nil, "small", 0.08, 0.95 })

    inst.pickupsound = "vegetation_firm"

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "petals_lily")
    SetEdible(inst, { hunger = 9.375, sanity = 10, health = -3 })
    SetStackable(inst, nil)
    SetPerishable(inst, TUNING.PERISH_FAST, "spoiled_food", nil)
    SetFuel(inst, nil)
    InitVeggie(inst)

    return inst
end, GetAssets("petals_lily"), nil))

table.insert(prefs, Prefab("petals_orchid", function() ------兰草花瓣
    local inst = CreateEntity()
    Fn_common(inst, "petals_orchid", nil, "idle", nil)
    SetFloatable(inst, { nil, "small", 0.08, 0.95 })

    inst.pickupsound = "vegetation_firm"

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "petals_orchid")
    SetEdible(inst, { hunger = 12.5, sanity = 5, health = 0 })
    SetStackable(inst, nil)
    SetPerishable(inst, TUNING.PERISH_FAST, "spoiled_food", nil)
    SetFuel(inst, nil)
    InitVeggie(inst)

    return inst
end, GetAssets("petals_orchid"), nil))

local function OnEat_shyerry(inst, eater)
    if eater.components.oldager == nil and eater.components.health ~= nil then
        eater:AddDebuff("buff_l_healthstorage", "buff_l_healthstorage", { value = 40 })
    end
end
local function OnDeploy_shyerry(inst, pt, deployer, rot)
    local names = { "shyerrytree1_planted", "shyerrytree3_planted" }
    local tree = SpawnPrefab(names[math.random(#names)])
    if tree ~= nil then
        tree.Transform:SetPosition(pt:Get())
        inst.components.stackable:Get():Remove()
        if deployer ~= nil and deployer.SoundEmitter ~= nil then
            deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
        end
    end
end
table.insert(prefs, Prefab("shyerry", function() ------颤栗果
    local inst = CreateEntity()
    Fn_common(inst, "shyerry", nil, "idle", nil)
    SetFloatable(inst, { 0.04, "small", 0.25, 0.9 })

    inst.pickupsound = "vegetation_firm"
    inst:AddTag("cookable")
    inst:AddTag("deployedplant")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "shyerry")
    SetEdible(inst, { hunger = 18.75, sanity = 0, health = 0, fn_eat = OnEat_shyerry })
    SetCookable(inst, "shyerry_cooked")
    SetStackable(inst, nil)
    SetPerishable(inst, TUNING.PERISH_MED, "spoiled_food", nil)
    SetDeployable(inst, OnDeploy_shyerry, DEPLOYMODE.PLANT, nil)
    InitVeggie(inst)

    return inst
end, GetAssets("shyerry"), { "buff_l_healthstorage", "shyerrytree1_planted", "shyerrytree3_planted", "shyerry_cooked" }))

table.insert(prefs, Prefab("shyerry_cooked", function() ------烤颤栗果
    local inst = CreateEntity()
    Fn_common(inst, "shyerry", nil, "cooked", nil)
    SetFloatable(inst, { 0.02, "small", 0.2, 0.9 })

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "shyerry_cooked")
    SetEdible(inst, { hunger = 12.5, sanity = 1, health = 0 })
    SetStackable(inst, nil)
    SetPerishable(inst, TUNING.PERISH_FAST, "spoiled_food", nil)
    SetFuel(inst, nil)
    InitVeggie(inst)

    return inst
end, GetAssets2("shyerry_cooked", "shyerry"), nil))

table.insert(prefs, Prefab("mint_l", function() ------猫薄荷
    local inst = CreateEntity()
    Fn_common(inst, "mint_l", nil, "idle", nil)
    SetFloatable(inst, { nil, "small", 0.08, 0.95 })

    inst.pickupsound = "vegetation_firm"
    inst:AddTag("catfood")
    inst:AddTag("cattoy")
    inst:AddTag("catmint")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "mint_l")
    SetEdible(inst, { hunger = 6, sanity = 8, health = 0 })
    SetStackable(inst, nil)
    SetPerishable(inst, TUNING.PERISH_MED, "spoiled_food", nil)
    SetFuel(inst, nil)
    InitVeggie(inst)

    return inst
end, GetAssets("mint_l"), nil))

table.insert(prefs, Prefab("albicans_cap", function() ------采摘的素白菇
    local inst = CreateEntity()
    Fn_common(inst, "albicans_cap", nil, "idle", nil)
    SetFloatable(inst, { 0.01, "small", 0.15, 1 })

    inst.pickupsound = "vegetation_firm"
    inst:AddTag("mushroom") --蘑菇农场用的

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "albicans_cap")
    SetEdible(inst, { hunger = 15, sanity = 15, health = 15 })
    SetStackable(inst, nil)
    SetPerishable(inst, TUNING.PERISH_FASTISH, "spoiled_food", nil)
    SetFuel(inst, nil)
    InitVeggie(inst)

    return inst
end, GetAssets("albicans_cap"), nil))

------熟素白菇 undo 应该有这个才对，之后补全吧

table.insert(prefs, Prefab("monstrain_leaf", function() ------雨竹叶
    local inst = CreateEntity()
    Fn_common(inst, "monstrain_leaf", nil, "idle", nil)
    SetFloatable(inst, { nil, "small", 0.05, 1.1 })

    inst.pickupsound = "vegetation_firm"

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "monstrain_leaf")
    SetEdible(inst, { hunger = 12.5, sanity = -15, health = -30, foodtype2 = FOODTYPE.MONSTER })
    SetStackable(inst, nil)
    SetPerishable(inst, TUNING.PERISH_MED, "spoiled_food", nil)
    SetFuel(inst, nil)
    InitVeggie(inst)

    return inst
end, GetAssets("monstrain_leaf"), nil))

local function OnEat_squamousfruit(inst, eater)
    if eater.components.moisture ~= nil then
        eater.components.moisture:DoDelta(-100)
    end
end
table.insert(prefs, Prefab("squamousfruit", function() ------鳞果
    local inst = CreateEntity()
    Fn_common(inst, "squamousfruit", nil, "idle", nil)
    SetFloatable(inst, { 0.05, "small", 0.2, 0.7 })

    inst.pickupsound = "vegetation_firm"

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "squamousfruit")
    SetEdible(inst, { hunger = 25, sanity = -5, health = -3, fn_eat = OnEat_squamousfruit })
    SetStackable(inst, nil)
    SetFuel(inst, nil)
    InitVeggie(inst)

    return inst
end, GetAssets("squamousfruit"), nil))

--------------------------------------------------------------------------
--[[ 各种道具 ]]
--------------------------------------------------------------------------

local function OnLightning_core(inst) --因为拿在手上会有"INLIMBO"标签，所以携带时并不会吸引闪电，只有放在地上时才会
    if inst.components.fueled:GetPercent() < 1 then
        if math.random() < 0.5 then
            inst.components.fueled:DoDelta(5, nil)
        end
    end
end
table.insert(prefs, Prefab("tourmalinecore", function() ------电气石
    local inst = CreateEntity()
    Fn_common(inst, "tourmalinecore", nil, "idle", nil)

    inst:AddTag("eleccore_l")
    inst:AddTag("lightningrod")
    inst:AddTag("battery_l")
    inst:AddTag("molebait")

    inst.pickupsound = "gem"

    LS_C_Init(inst, "tourmalinecore", false)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "tourmalinecore")
    inst.components.inventoryitem:SetSinks(true) --它是石头，应该要沉入水底

    inst:AddComponent("bait")

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.ELEC_L
    inst.components.fueled:InitializeFuelLevel(500)
    inst.components.fueled.accepting = true

    inst:AddComponent("batterylegion")
    inst.components.batterylegion:StartCharge()

    inst:ListenForEvent("lightningstrike", OnLightning_core)

    MakeHauntableLaunch(inst)

    return inst
end, GetAssets("tourmalinecore"), nil))

local function CP_Open_nut(self, doer, ...)
    self.Open_l(self, doer, ...)
    if
        doer ~= nil and doer.task_boxopener_l == nil and
        self.master.components.container:IsOpenedBy(doer)
    then
        local openpos = doer:GetPosition()
        doer.task_boxopener_l = doer:DoPeriodicTask(0.5, function(doer)
            if doer.components.health ~= nil and doer.components.health:IsDead() then
                self:Close(doer)
            elseif doer:GetDistanceSqToPoint(openpos) > 4 then
                self:Close(doer)
            end
        end, 0.5)
        if doer.SoundEmitter then
            doer.SoundEmitter:PlaySound("maxwell_rework/magician_chest/open", nil, 0.7)
        end
    end
end
local function CP_OnClose_nut(self, doer, ...)
    self.OnClose_l(self, doer, ...)
    if doer ~= nil then
        if doer.task_boxopener_l ~= nil then
            doer.task_boxopener_l:Cancel()
            doer.task_boxopener_l = nil
            if doer.SoundEmitter then
                doer.SoundEmitter:PlaySound("maxwell_rework/magician_chest/close", nil, 0.7)
            end
            if doer.components.health ~= nil and not doer.components.health:IsDead() then
                local cost = 2
                if doer.siv_blood_l_reducer_v ~= nil then
                    if doer.siv_blood_l_reducer_v >= 1 then
                        cost = 0
                    else
                        cost = cost * (1-doer.siv_blood_l_reducer_v)
                    end
                end
                if cost > 0 then
                    --有人反馈被云松子扣血扣死后，背包打不开了，所以这里延迟扣血
                    doer:DoTaskInTime(0.3, function()
                        if doer.components.health ~= nil and not doer.components.health:IsDead() then
                            doer.components.health:DoDelta(-cost, nil, self.inst.prefab, nil, nil, true)
                        end
                    end)
                end
            end
        end
    end
end
local function OnLoadPostPass_nut(inst) --世界启动时，向世界容器注册自己
	if TheWorld.components.boxcloudpine ~= nil then
		TheWorld.components.boxcloudpine.openers[inst] = true
	end
end
table.insert(prefs, Prefab("boxopener_l", function() ------云松子
    local inst = CreateEntity()
    Fn_common(inst, "boxopener_l", nil, "idle_nut", nil)
    SetFloatable(inst, { 0.03, "small", 0.25, 0.9 })

    inst:AddTag("boxopener_l")

    inst:AddComponent("container_proxy")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "boxopener_l")
    SetFuel(inst, nil)
    MakeHauntableLaunch(inst)

    local container_proxy = inst.components.container_proxy
    container_proxy.Open_l = container_proxy.Open
    container_proxy.OnClose_l = container_proxy.OnClose
    container_proxy.Open = CP_Open_nut
    container_proxy.OnClose = CP_OnClose_nut

    inst.OnLoadPostPass = OnLoadPostPass_nut
	if not POPULATING then
		if TheWorld.components.boxcloudpine ~= nil then
            TheWorld.components.boxcloudpine:SetMaster(inst)
        end
	end

    return inst
end, GetAssets("boxopener_l"), nil))

local foliageath_data_fol = {
    image = "foliageath_foliageath", atlas = "images/inventoryimages/foliageath_foliageath.xml",
    bank = nil, build = nil, anim = "foliageath", isloop = nil,
    togethered = "foliageath_mylove", --替换合并后的预制物名。默认不需要写，因为剑鞘本身特殊才写的
    --判断是否需要恢复耐久。第二个参数是为了识别是何种原因恢复耐久
    -- fn_recovercheck = function(inst, tag)end,
    --恢复耐久。根据 dt 这个时间参数来确定恢复的程度
    -- fn_recover = function(inst, dt, player, tag)end
}
local function Fn_test_fol(inst, doer, item, count)
    if item == nil then
        return false, "NOSWORD"
    elseif item.foliageath_data == nil then
        return false, "WRONGSWORD"
    end
    return true
end
local function Fn_do_fol(inst, doer, item, count)
    if item ~= nil then
        local togethered = SpawnPrefab(item.foliageath_data.togethered or "foliageath_together")
        if togethered ~= nil then
            togethered.components.swordscabbard:BeTogether(inst, item) --inst和item会在这里面被删除
        else
            item:Remove()
        end
    end
end
table.insert(prefs, Prefab("foliageath", function() ------青枝绿叶
    local inst = CreateEntity()
    Fn_common(inst, "foliageath", nil, "lonely", nil)
    SetFloatable(inst, { 0.15, "small", 0.4, 0.65 })

    inst:AddTag("swordscabbard")
    inst:AddTag("NORATCHECK") --mod兼容：永不妥协。该道具不算鼠潮分

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    inst.foliageath_data = foliageath_data_fol

    Fn_server(inst, "foliageath")
    SetFuel(inst, TUNING.LARGE_FUEL)

    inst:AddComponent("emptyscabbardlegion")
    inst.components.emptyscabbardlegion.fn_test = Fn_test_fol
    inst.components.emptyscabbardlegion.fn_do = Fn_do_fol

    MakeHauntableLaunch(inst)

    return inst
end, GetAssets("foliageath"), { "foliageath_together", "foliageath_mylove" }))

local function GetStatus_folto(inst)
    return "MERGED"
end
table.insert(prefs, Prefab("foliageath_together", function() ------入鞘后的青枝绿叶
    local inst = CreateEntity()
    inst.entity:AddSoundEmitter()
    Fn_common(inst, "foliageath", nil, "hambat", nil)
    SetFloatable(inst, { 0.15, "small", 0.4, 0.65 })
    inst:SetPrefabNameOverride("foliageath")

    inst:AddTag("NORATCHECK") --mod兼容：永不妥协。该道具不算鼠潮分

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "foliageath_hambat") --默认是火腿棒入鞘后的贴图
    inst.components.inspectable.getstatus = GetStatus_folto

    inst:AddComponent("swordscabbard")
    MakeHauntableLaunch(inst)

    return inst
end, {
    Asset("ANIM", "anim/foliageath.zip"),
    Asset("ATLAS", "images/inventoryimages/foliageath_rosorns.xml"),
    Asset("IMAGE", "images/inventoryimages/foliageath_rosorns.tex"),
    Asset("ATLAS_BUILD", "images/inventoryimages/foliageath_rosorns.xml", 256),
    Asset("ATLAS", "images/inventoryimages/foliageath_lileaves.xml"),
    Asset("IMAGE", "images/inventoryimages/foliageath_lileaves.tex"),
    Asset("ATLAS_BUILD", "images/inventoryimages/foliageath_lileaves.xml", 256),
    Asset("ATLAS", "images/inventoryimages/foliageath_orchitwigs.xml"),
    Asset("IMAGE", "images/inventoryimages/foliageath_orchitwigs.tex"),
    Asset("ATLAS_BUILD", "images/inventoryimages/foliageath_orchitwigs.xml", 256),
    Asset("ATLAS", "images/inventoryimages/foliageath_neverfade.xml"),
    Asset("IMAGE", "images/inventoryimages/foliageath_neverfade.tex"),
    Asset("ATLAS_BUILD", "images/inventoryimages/foliageath_neverfade.xml", 256),
    Asset("ATLAS", "images/inventoryimages/foliageath_hambat.xml"),
    Asset("IMAGE", "images/inventoryimages/foliageath_hambat.tex"),
    Asset("ATLAS_BUILD", "images/inventoryimages/foliageath_hambat.xml", 256),
    Asset("ATLAS", "images/inventoryimages/foliageath_bullkelp_root.xml"),
    Asset("IMAGE", "images/inventoryimages/foliageath_bullkelp_root.tex"),
    Asset("ATLAS_BUILD", "images/inventoryimages/foliageath_bullkelp_root.xml", 256),
    Asset("ATLAS", "images/inventoryimages/foliageath_foliageath.xml"),
    Asset("IMAGE", "images/inventoryimages/foliageath_foliageath.tex"),
    Asset("ATLAS_BUILD", "images/inventoryimages/foliageath_foliageath.xml", 256),
    Asset("ATLAS", "images/inventoryimages/foliageath_dish_tomahawksteak.xml"),
    Asset("IMAGE", "images/inventoryimages/foliageath_dish_tomahawksteak.tex"),
    Asset("ATLAS_BUILD", "images/inventoryimages/foliageath_dish_tomahawksteak.xml", 256)
}, { "foliageath" }))

local function OnOwnerChange_follv(inst, owner, newowners)
    if inst.owner_l == owner then --没变化
        return
    end

    --先取消以前的对象
    local ownerold = inst.owner_l
    if ownerold ~= nil and ownerold:IsValid() and ownerold:HasTag("player") then
        if ownerold._follv_l ~= nil then
            local newtbl
            ownerold._follv_l[inst] = nil
            for k, _ in pairs(ownerold._follv_l) do
                if k:IsValid() then
                    if newtbl == nil then
                        newtbl = {}
                    end
                    newtbl[k] = true
                end
            end
            if newtbl == nil then
                if ownerold.components.sanity ~= nil then
                    ownerold.components.sanity.externalmodifiers:RemoveModifier("sanityhelper_l", "foliageath")
                end
            end
            ownerold._follv_l = newtbl
        else
            if ownerold.components.sanity ~= nil then
                ownerold.components.sanity.externalmodifiers:RemoveModifier("sanityhelper_l", "foliageath")
            end
        end
    end

    --再尝试设置目前的对象
    inst.owner_l = owner
    if owner:HasTag("player") then
        if owner._follv_l == nil then
            owner._follv_l = {}
            if owner.components.sanity ~= nil then
                owner.components.sanity.externalmodifiers:SetModifier(
                    "sanityhelper_l", TUNING.DAPPERNESS_LARGE, "foliageath")
            end
        end
        owner._follv_l[inst] = true
    end
end
local function OnRemove_follv(inst)
    OnOwnerChange_follv(inst, inst)
end
table.insert(prefs, Prefab("foliageath_mylove", function() ------青锋剑
    local inst = CreateEntity()
    inst.entity:AddSoundEmitter()
    Fn_common(inst, "foliageath", nil, "foliageath", nil)
    SetFloatable(inst, { 0.15, "small", 0.4, 0.65 })

    inst:AddTag("feelmylove")
    inst:AddTag("NORATCHECK") --mod兼容：永不妥协。该道具不算鼠潮分

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "foliageath_foliageath")
    inst:AddComponent("swordscabbard")
    MakeHauntableLaunch(inst)

    -- inst.owner_l = nil
    TOOLS_L.ListenOwnerChange(inst, OnOwnerChange_follv, OnRemove_follv)

    return inst
end, GetAssets2("foliageath_foliageath", "foliageath"), { "foliageath" }))

------

local dd_smear_sivbloodreduce = { build = "ointment_l_sivbloodreduce" }
local dd_smear_fireproof = { build = "ointment_l_fireproof" }

local function FnCheck_sivbloodreduce(inst, doer, target)
    if target.prefab == "monstrain" then
        if target.lifeless_l then
            return false, "NONEED"
        else
            return true
        end
    end
    if target.components.combat == nil or target.components.health == nil or target.components.health:IsDead() then
        return false, "NOUSE"
    end
    if --具有以下标签的对象，根本不会被窃血，所以也不用加buff
        target:HasTag("wall") or target:HasTag("structure") or target:HasTag("balloon") or
        target:HasTag("shadowminion") or target:HasTag("ghost")
    then
        return false, "NOUSE"
    end
    return true
end
local function FnSmear_sivbloodreduce(inst, doer, target)
    if target.prefab == "monstrain" then
        target.lifeless_l = true
        target.net_lifeless_l:set(true)
        target.components.childspawner:StopSpawning()
    else
        target:AddDebuff("buff_l_sivbloodreduce", "buff_l_sivbloodreduce")
    end
end
table.insert(prefs, Prefab("ointment_l_sivbloodreduce", function() ------弱肤药膏
    local inst = CreateEntity()
    Fn_common(inst, "ointment_l_sivbloodreduce", nil, "idle", nil)
    SetFloatable(inst, { nil, "small", 0.25, 1 })

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    inst.dd_l_smear = dd_smear_sivbloodreduce
    Fn_server(inst, "ointment_l_sivbloodreduce")
    SetStackable(inst, nil)
    SetOintmentLegion(inst, FnCheck_sivbloodreduce, FnSmear_sivbloodreduce)
    SetFuel(inst, nil)
    InitItem(inst, nil)

    return inst
end, GetAssets("ointment_l_sivbloodreduce"), nil))

local function FnCheck_fireproof(inst, doer, target)
    if target.components.burnable == nil or target:HasTag("burnt") then
        return false, "NOUSE"
    end
    if target.components.burnable.fireproof_legion then
        return false, "NONEED"
    end
    if target.components.health ~= nil and target.components.health:IsDead() then
        return false, "NOUSE"
    end
    return true
end
local function FnSmear_fireproof(inst, doer, target)
    if --是可燃物
        target:HasTag("wall") or target:HasTag("structure") or target:HasTag("balloon") or
        target.components.childspawner ~= nil or
        target.components.health == nil or target.components.combat == nil
    then
        local burnable = target.components.burnable
        burnable.fireproof_legion = true
        TOOLS_L.AddTag(target, "fireproof_legion", "fireproof_base")
        if burnable:IsBurning() or burnable:IsSmoldering() then
            burnable:Extinguish(true, -4) --涂抹完成，顺便灭火
        end
    else --是生物
        target:AddDebuff("buff_l_fireproof", "buff_l_fireproof")
    end
end
table.insert(prefs, Prefab("ointment_l_fireproof", function() ------防火漆
    local inst = CreateEntity()
    Fn_common(inst, "ointment_l_fireproof", nil, "idle", nil)
    SetFloatable(inst, { nil, "small", 0.25, 1 })

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    inst.dd_l_smear = dd_smear_fireproof
    Fn_server(inst, "ointment_l_fireproof")
    SetStackable(inst, nil)
    SetOintmentLegion(inst, FnCheck_fireproof, FnSmear_fireproof)
    SetFuel(inst, nil)
    MakeHauntableLaunch(inst)

    return inst
end, GetAssets("ointment_l_fireproof"), nil))

--------------------------------------------------------------------------
--[[ 基础材料 ]]
--------------------------------------------------------------------------

table.insert(prefs, Prefab("ahandfulofwings", function() ------虫翅碎片
    local inst = CreateEntity()
    Fn_common(inst, "insectthings_l", nil, "wing", nil)
    SetFloatable(inst, { nil, "small", 0.1, 1.2 })

    inst.pickupsound = "vegetation_grassy"

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "ahandfulofwings")
    SetStackable(inst, nil)
    SetFuel(inst, TUNING.SMALL_FUEL)
    inst:AddComponent("tradable")
    InitItem(inst, TUNING.SMALL_BURNTIME)

    return inst
end, GetAssets2("ahandfulofwings", "insectthings_l"), nil))

table.insert(prefs, Prefab("insectshell_l", function() ------虫甲碎片
    local inst = CreateEntity()
    Fn_common(inst, "insectthings_l", nil, "shell", nil)
    SetFloatable(inst, { nil, "small", 0.1, 1.1 })

    inst.pickupsound = "vegetation_grassy"

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "insectshell_l")
    SetStackable(inst, nil)
    SetFuel(inst, TUNING.SMALL_FUEL)
    inst:AddComponent("z_repairerlegion")
    inst:AddComponent("tradable")
    InitItem(inst, TUNING.SMALL_BURNTIME)

    return inst
end, GetAssets2("insectshell_l", "insectthings_l"), nil))

table.insert(prefs, Prefab("shyerrylog", function() ------宽大的木墩
    local inst = CreateEntity()
    Fn_common(inst, "shyerrylog", nil, "idle", nil)
    SetFloatable(inst, { nil, "med", 0.2, 0.8 })

    inst.pickupsound = "wood"

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "shyerrylog")
    SetEdible(inst, { hunger = 0, sanity = 0, health = 0, foodtype = FOODTYPE.WOOD }) --目前貌似就饼干切割机会吃木头
    SetStackable(inst, TUNING.STACK_SIZE_LARGEITEM)
    SetFuel(inst, TUNING.LARGE_FUEL)

    inst:AddComponent("repairer")
    inst.components.repairer.repairmaterial = MATERIALS.WOOD
    inst.components.repairer.healthrepairvalue = TUNING.REPAIR_BOARDS_HEALTH
    inst.components.repairer.boatrepairsound = "turnoftides/common/together/boat/repair_with_wood"

    InitItem(inst, TUNING.LARGE_BURNTIME)

    return inst
end, GetAssets("shyerrylog"), nil))

table.insert(prefs, Prefab("merm_scales", function() ------鱼鳞
    local inst = CreateEntity()
    Fn_common(inst, "merm_scales", nil, "idle", nil)
    SetFloatable(inst, { nil, "med", 0.1, 0.77 })

    inst:AddTag("cattoy")
    inst.pickupsound = "cloth"

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "merm_scales")
    SetEdible(inst, { hunger = 0, sanity = 0, health = 0, foodtype = FOODTYPE.HORRIBLE })
    SetStackable(inst, nil)
    SetTradable(inst, TUNING.GOLD_VALUES.MEAT * 2, nil)
    MakeHauntableLaunch(inst) --偏潮湿的道具，所以不会着火

    return inst
end, GetAssets("merm_scales"), nil))

table.insert(prefs, Prefab("tourmalineshard", function() ------带电的晶石
    local inst = CreateEntity()
    Fn_common(inst, "tourmalinecore", nil, "idle_shard", nil)

    inst:AddTag("battery_l")
    inst:AddTag("molebait")

    inst.pickupsound = "metal"

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "tourmalineshard")
    inst.components.inventoryitem:SetSinks(true) --它是石头，应该要沉入水底

    SetStackable(inst, TUNING.STACK_SIZE_MEDITEM)
    SetTradable(inst, 4, 12)
    SetEdible(inst, { hunger = 5, sanity = 0, health = 0, foodtype = FOODTYPE.ELEMENTAL })
    inst:AddComponent("bait")
    inst:AddComponent("batterylegion")
    inst:AddComponent("z_repairerlegion")
    MakeHauntableLaunch(inst)

    return inst
end, GetAssets2("tourmalineshard", "tourmalinecore"), nil))

if not CONFIGS_LEGION.ENABLEDMODS.MythWords then ------子圭石。未开启神话书说时才注册这个prefab
    table.insert(prefs, Prefab("siving_rocks", function()
        local inst = CreateEntity()
        Fn_common(inst, "myth_siving", nil, "siving_rocks", nil)

        inst:AddTag("molebait")
        inst:AddTag("quakedebris") --部分装备和生物能防御它的伤害
        inst.pickupsound = "rock"

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        Fn_server(inst, "siving_rocks")
        inst.components.inventoryitem:SetSinks(true)

        SetStackable(inst, nil)
        SetTradable(inst, 4, 6)
        SetEdible(inst, { hunger = 5, sanity = 0, health = 0, foodtype = FOODTYPE.ELEMENTAL })
        inst:AddComponent("bait")
        MakeHauntableLaunch(inst)

        return inst
    end, GetAssets2("siving_rocks", "myth_siving"), nil))
end

--------------------------------------------------------------------------
--[[ 活性组织 ]]
--------------------------------------------------------------------------

local function MakeTissue(name)
	local myname = "tissue_l_"..name
	table.insert(prefs, Prefab(myname, function()
        local inst = CreateEntity()
        Fn_common(inst, "tissue_l", nil, "idle_"..name, nil)
        SetFloatable(inst, { nil, "small", 0.1, 1 })

        inst:AddTag("tissue_l") --这个标签没啥用，就想加上而已
        inst.pickupsound = "vegetation_grassy"

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        Fn_server(inst, myname)
        inst.components.inspectable.nameoverride = "TISSUE_L" --用来统一描述

        SetStackable(inst, nil)
        SetFuel(inst, nil)
        inst:AddComponent("tradable")
        InitItem(inst, nil)

        return inst
    end, GetAssets2(myname, "tissue_l"), nil))
end

MakeTissue("cactus")
MakeTissue("lureplant")
MakeTissue("berries")
MakeTissue("lightbulb")

--------------------------------------------------------------------------
--[[ 玩具 ]]
--------------------------------------------------------------------------

table.insert(prefs, Prefab("cattenball", function() ------猫线球
    local inst = CreateEntity()
    Fn_common(inst, "toy_legion", nil, "toy_cattenball", nil)
    SetFloatable(inst, { 0.08, "med", 0.25, 0.5 })

    inst:AddTag("cattoy")
    inst.pickupsound = "cloth"

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "cattenball")
    SetStackable(inst, TUNING.STACK_SIZE_MEDITEM)
    SetTradable(inst, 9, 3)
    SetFuel(inst, TUNING.SMALL_FUEL)
    InitItem(inst, TUNING.SMALL_BURNTIME)

    return inst
end, GetAssets2("cattenball", "toy_legion"), nil))

------玩具小海绵与玩具小海星：toy_spongebob，toy_patrickstar。隐藏废稿，不会做了

--------------------------------------------------------------------------
--[[ 可种植的物品 ]]
--------------------------------------------------------------------------

local function OnDeploy_base(inst, pt, deployer, rot, dd)
    local tree = nil
    if dd.skined then
        local skinname = nil
        if LS_IsValidPlayer(deployer) then
            skinname = LS_LastChosenSkin(dd.prefab, deployer.userid)
        end
        if skinname == nil then
            tree = SpawnPrefab(dd.prefab)
        else
            tree = SpawnPrefab(dd.prefab, skinname, nil, deployer.userid)
        end
    else
        tree = SpawnPrefab(dd.prefab)
    end
    if tree ~= nil then
        -- if rot ~= nil then
        --     tree.Transform:SetRotation(rot)
        -- end
        tree.Transform:SetPosition(pt:Get())

        if inst.components.stackable ~= nil then
            inst.components.stackable:Get():Remove()
        else
            inst:Remove()
        end

        if tree.components.pickable ~= nil then
            if dd.isempty then --直接进入生长状态
                tree.components.pickable:MakeEmpty()
            else
                tree.components.pickable:OnTransplant()
            end
        end

        if deployer ~= nil and deployer.SoundEmitter ~= nil then
            deployer.SoundEmitter:PlaySound(dd.sound or "dontstarve/common/plant")
        end

        if tree.fn_planted ~= nil then
            tree.fn_planted(tree, pt)
        end
    end
end

local function OnDeploy_rose(inst, pt, deployer, rot)
    OnDeploy_base(inst, pt, deployer, rot, { prefab = "rosebush", skined = true, isempty = nil, sound = nil })
end
table.insert(prefs, Prefab("dug_rosebush", function() ------蔷薇花丛(物品)
    local inst = CreateEntity()
    Fn_common(inst, "berrybush2", "rosebush", "dropped", nil)
    SetFloatable(inst, { 0.03, "large", 0.2, {0.65, 0.5, 0.65} })

    inst:AddTag("deployedplant") --植株种植标签，植物人种下时能恢复精神等
    inst.pickupsound = "vegetation_firm"

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "dug_rosebush")
    SetStackable(inst, TUNING.STACK_SIZE_LARGEITEM)
    SetFuel(inst, TUNING.LARGE_FUEL)
    SetDeployable(inst, OnDeploy_rose, DEPLOYMODE.PLANT, CONFIGS_LEGION.ROSEBUSHSPACING or DEPLOYSPACING.MEDIUM)
    MakeMediumBurnable(inst, TUNING.LARGE_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunch(inst)

    return inst
end, GetAssets2("dug_rosebush", "rosebush"), nil))

local function OnDeploy_lily(inst, pt, deployer, rot)
    OnDeploy_base(inst, pt, deployer, rot, { prefab = "lilybush", skined = true })
end
table.insert(prefs, Prefab("dug_lilybush", function() ------蹄莲花丛(物品)
    local inst = CreateEntity()
    Fn_common(inst, "berrybush2", "lilybush", "dropped", nil)
    SetFloatable(inst, { 0.03, "large", 0.2, {0.65, 0.5, 0.65} })

    inst:AddTag("deployedplant")
    inst.pickupsound = "vegetation_firm"

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "dug_lilybush")
    SetStackable(inst, TUNING.STACK_SIZE_LARGEITEM)
    SetFuel(inst, TUNING.LARGE_FUEL)
    SetDeployable(inst, OnDeploy_lily, DEPLOYMODE.PLANT, CONFIGS_LEGION.LILYBUSHSPACING or DEPLOYSPACING.MEDIUM)
    MakeMediumBurnable(inst, TUNING.LARGE_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunch(inst)

    return inst
end, GetAssets2("dug_lilybush", "lilybush"), nil))

local function OnDeploy_orchid(inst, pt, deployer, rot)
    OnDeploy_base(inst, pt, deployer, rot, { prefab = "orchidbush", skined = true })
end
table.insert(prefs, Prefab("dug_orchidbush", function() ------兰草花丛(物品)
    local inst = CreateEntity()
    Fn_common(inst, "berrybush2", "orchidbush", "dropped", nil)
    SetFloatable(inst, { nil, "large", 0.1, {0.65, 0.5, 0.65} })

    inst:AddTag("deployedplant")
    inst.pickupsound = "vegetation_firm"

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "dug_orchidbush")
    SetStackable(inst, TUNING.STACK_SIZE_LARGEITEM)
    SetFuel(inst, TUNING.LARGE_FUEL)
    SetDeployable(inst, OnDeploy_orchid, DEPLOYMODE.PLANT, CONFIGS_LEGION.ORCHIDBUSHSPACING or DEPLOYSPACING.LESS)
    MakeMediumBurnable(inst, TUNING.LARGE_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunch(inst)

    return inst
end, GetAssets2("dug_orchidbush", "orchidbush"), nil))

local function OnDeploy_rose2(inst, pt, deployer, rot)
    OnDeploy_base(inst, pt, deployer, rot, { prefab = "rosebush", skined = true, isempty = true })
end
table.insert(prefs, Prefab("cutted_rosebush", function() ------蔷薇折枝
    local inst = CreateEntity()
    Fn_common(inst, "rosebush", nil, "cutted", nil)
    SetFloatable(inst, { nil, "large", 0.1, 0.55 })

    inst:AddTag("deployedplant")
    inst:AddTag("treeseed") --能使其放入种子袋
    inst.pickupsound = "vegetation_firm"

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "cutted_rosebush")
    SetStackable(inst, nil)
    SetFuel(inst, TUNING.SMALL_FUEL)
    SetDeployable(inst, OnDeploy_rose2, DEPLOYMODE.PLANT, CONFIGS_LEGION.ROSEBUSHSPACING or DEPLOYSPACING.MEDIUM)
    InitItem(inst, TUNING.SMALL_BURNTIME)

    return inst
end, GetAssets2("cutted_rosebush", "rosebush"), nil))

local function OnDeploy_lily2(inst, pt, deployer, rot)
    OnDeploy_base(inst, pt, deployer, rot, { prefab = "lilybush", skined = true, isempty = true })
end
table.insert(prefs, Prefab("cutted_lilybush", function() ------蹄莲芽束
    local inst = CreateEntity()
    Fn_common(inst, "lilybush", nil, "cutted", nil)
    SetFloatable(inst, { nil, "large", 0.1, 0.55 })

    inst:AddTag("deployedplant")
    inst:AddTag("treeseed")
    inst.pickupsound = "vegetation_firm"

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "cutted_lilybush")
    SetStackable(inst, nil)
    SetFuel(inst, TUNING.SMALL_FUEL)
    SetDeployable(inst, OnDeploy_lily2, DEPLOYMODE.PLANT, CONFIGS_LEGION.LILYBUSHSPACING or DEPLOYSPACING.MEDIUM)
    InitItem(inst, TUNING.SMALL_BURNTIME)

    return inst
end, GetAssets2("cutted_lilybush", "lilybush"), nil))

local function OnDeploy_orchid2(inst, pt, deployer, rot)
    OnDeploy_base(inst, pt, deployer, rot, { prefab = "orchidbush", skined = true, isempty = true })
end
table.insert(prefs, Prefab("cutted_orchidbush", function() ------兰草种籽
    local inst = CreateEntity()
    Fn_common(inst, "orchidbush", nil, "cutted", nil)
    SetFloatable(inst, { nil, "large", 0.1, 0.55 })

    inst:AddTag("deployedplant")
    inst:AddTag("treeseed")
    inst.pickupsound = "vegetation_firm"

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "cutted_orchidbush")
    SetStackable(inst, nil)
    SetFuel(inst, TUNING.SMALL_FUEL)
    SetDeployable(inst, OnDeploy_orchid2, DEPLOYMODE.PLANT, CONFIGS_LEGION.ORCHIDBUSHSPACING or DEPLOYSPACING.LESS)
    InitItem(inst, TUNING.SMALL_BURNTIME)

    return inst
end, GetAssets2("cutted_orchidbush", "orchidbush"), nil))

local function OnDeploy_lumpy(inst, pt, deployer, rot)
    OnDeploy_base(inst, pt, deployer, rot, { prefab = "lumpy_sapling" })
end
table.insert(prefs, Prefab("cutted_lumpyevergreen", function() ------臃肿常青树嫩枝
    local inst = CreateEntity()
    Fn_common(inst, "cutted_lumpyevergreen", nil, "idle", nil)
    SetFloatable(inst, { nil, "small", 0.2, 1.35 })

    inst:AddTag("deployedplant")
    inst:AddTag("treeseed")
    inst.pickupsound = "vegetation_firm"

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "cutted_lumpyevergreen")
    SetStackable(inst, nil)
    SetFuel(inst, TUNING.SMALL_FUEL)
    SetDeployable(inst, OnDeploy_lumpy, DEPLOYMODE.PLANT, DEPLOYSPACING.LESS)
    InitItem(inst, TUNING.SMALL_BURNTIME)

    return inst
end, GetAssets("cutted_lumpyevergreen"), nil))

local function OnTreeLive_siv_derivant(inst, state)
    inst.treeState = state
    if state == 2 then
        inst.AnimState:PlayAnimation("item_live")
        inst.components.bloomer:PushBloom("activetree", "shaders/anim.ksh", 1)
        inst.Light:SetRadius(0.6)
        inst.Light:Enable(true)
    elseif state == 1 then
        inst.AnimState:PlayAnimation("item")
        inst.components.bloomer:PushBloom("activetree", "shaders/anim.ksh", 1)
        inst.Light:SetRadius(0.3)
        inst.Light:Enable(true)
    else
        inst.AnimState:PlayAnimation("item")
        inst.components.bloomer:PopBloom("activetree")
        inst.Light:Enable(false)
    end
end
local function OnDropped_siv_derivant(inst)
    inst.OnTreeLive(inst, 0) --不知道为啥捡起时已经关闭光源了，但还是发了光，所以这里丢弃时再次关闭光源
end
local function OnPickup_siv_derivant(inst)
    inst.OnTreeLive(inst, nil)
end
local function OnDeploy_siv_derivant(inst, pt, deployer, rot)
    OnDeploy_base(inst, pt, deployer, rot, { prefab = "siving_derivant", skined = true })
end
table.insert(prefs, Prefab("siving_derivant_item", function() ------子圭奇型岩(物品)
    local inst = CreateEntity()
    inst.entity:AddLight()
    Fn_common(inst, "siving_derivant", nil, "item", nil)

    inst.Light:Enable(false)
    inst.Light:SetRadius(0.3)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.6)
    inst.Light:SetColour(15/255, 180/255, 132/255)

    inst:AddTag("siving_derivant")
    inst.pickupsound = "metal"

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    inst.treeState = 0
    inst.OnTreeLive = OnTreeLive_siv_derivant

    Fn_server(inst, "siving_derivant_item")
    inst.components.inventoryitem:SetSinks(true)
    inst.components.inventoryitem:SetOnDroppedFn(OnDropped_siv_derivant)
    inst.components.inventoryitem:SetOnPickupFn(OnPickup_siv_derivant)

    SetStackable(inst, TUNING.STACK_SIZE_LARGEITEM)
    SetDeployable(inst, OnDeploy_siv_derivant, nil, nil)
    inst:AddComponent("bloomer")

    return inst
end, GetAssets2("siving_derivant_item", "siving_derivant"), nil))

local function OnDeploy_monstrain(inst, pt, deployer, rot)
    OnDeploy_base(inst, pt, deployer, rot, { prefab = "monstrain_wizen" })
end
table.insert(prefs, Prefab("dug_monstrain", function() ------雨竹块茎(物品)
    local inst = CreateEntity()
    Fn_common(inst, "monstrain", nil, "dropped", nil)
    SetFloatable(inst, { nil, "small", 0.2, 1.2 })

    inst:AddTag("deployedplant")
    inst.pickupsound = "vegetation_firm"

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "dug_monstrain")
    SetStackable(inst, TUNING.STACK_SIZE_LARGEITEM)
    SetFuel(inst, TUNING.SMALL_FUEL)
    SetDeployable(inst, OnDeploy_monstrain, DEPLOYMODE.PLANT, nil)
    InitItem(inst, TUNING.SMALL_BURNTIME)

    return inst
end, GetAssets2("dug_monstrain", "monstrain"), nil))

----------
--异种
----------

local assets_xeed = GetAssets2("seeds_crop_l2", "seeds_crop_l")
local function MakeXeed(k, dd)
    local cropprefab = "plant_"..k.."_l"
    local function DisplayName_xeed(inst)
        return STRINGS.NAMES[string.upper(cropprefab)]..STRINGS.NAMEDETAIL_L.XEEDS
    end
    local function OnDeploy_xeed(inst, pt, deployer, rot)
        OnDeploy_base(inst, pt, deployer, rot, {
            prefab = cropprefab, skined = true, sound = "dontstarve/wilson/plant_seeds"
        })
    end
    table.insert(prefs, Prefab("seeds_"..k.."_l", function()
        local inst = CreateEntity()
        Fn_common(inst, "seeds_crop_l", nil, "idle", nil)
        SetFloatable(inst, { nil, "small", 0.2, 1.2 })

        inst:AddTag("deployedplant")
        inst:AddTag("treeseed")
        inst.pickupsound = "vegetation_firm"
        -- inst.overridedeployplacername = seedsprefab.."_placer" --这个可以让placer换成另一个
        inst.displaynamefn = DisplayName_xeed

        if dd.image ~= nil then
            inst.inv_image_bg = { image = dd.image.name, atlas = dd.image.atlas }
        else
            inst.inv_image_bg = {}
        end
        if inst.inv_image_bg.image == nil then
            inst.inv_image_bg.image = k..".tex"
        end
        if inst.inv_image_bg.atlas == nil then
            inst.inv_image_bg.atlas = GetInventoryItemAtlas(inst.inv_image_bg.image)
        end

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        inst.sivbird_l_food = 0.5 --能给予玄鸟换取子圭石

        Fn_server(inst, "seeds_crop_l2")
        inst.components.inspectable.nameoverride = "SEEDS_CROP_L"

        SetStackable(inst, nil)
        SetFuel(inst, TUNING.SMALL_FUEL)
        SetDeployable(inst, OnDeploy_xeed, DEPLOYMODE.PLANT, DEPLOYSPACING.MEDIUM)

        inst:AddComponent("plantablelegion")
        inst.components.plantablelegion.plant = cropprefab
        inst.components.plantablelegion.plant2 = dd.plant2 --同一个异种种子可能能升级第二种对象

        InitItem(inst, TUNING.SMALL_BURNTIME)

        return inst
    end, assets_xeed, nil))
end

for k, v in pairs(CROPS_DATA_LEGION) do
    MakeXeed(k, v)
end

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

table.insert(prefs, Prefab("pineananas_seeds", function() ------松萝种子
    local inst = CreateEntity()
    Fn_common(inst, "pineananas", nil, "seeds", nil)
    SetCropSeeds_common(inst, "pineananas")
    SetFloatable(inst, { -0.1, "small", nil, nil })

    inst:AddTag("cookable") --烤制组件所需
    inst:AddTag("oceanfishing_lure") --海钓饵组件所需

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "pineananas_seeds")
    SetEdible(inst, { hunger = TUNING.CALORIES_TINY, sanity = nil, health = 0.5, foodtype = FOODTYPE.SEEDS })
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

table.insert(prefs, Prefab("pineananas", function() ------松萝
    local inst = CreateEntity()
    Fn_common(inst, "pineananas", nil, "idle", nil)
    SetFloatable(inst, { nil, "small", 0.2, 0.9 })

    inst:AddTag("cookable")
    inst:AddTag("weighable_OVERSIZEDVEGGIES") --称重组件所需

    inst.pickupsound = "vegetation_firm"

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "pineananas")
    SetEdible(inst, { hunger = 12, sanity = -10, health = 8 })
    SetStackable(inst, nil)
    SetPerishable(inst, TUNING.PERISH_MED, "spoiled_food", nil)
    SetCookable(inst, "pineananas_cooked")
    SetWeighable(inst, nil)
    InitVeggie(inst)

    return inst
end, GetAssets("pineananas"), GetPrefabs_crop("pineananas", { "pineananas_cooked" })))

table.insert(prefs, Prefab("pineananas_cooked", function() ------烤松萝
    local inst = CreateEntity()
    Fn_common(inst, "pineananas", nil, "cooked", nil)
    SetFloatable(inst, { nil, "small", 0.2, 1 })

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    Fn_server(inst, "pineananas_cooked")
    SetEdible(inst, { hunger = 18.5, sanity = 5, health = 16 })
    SetStackable(inst, nil)
    SetPerishable(inst, TUNING.PERISH_SUPERFAST, "spoiled_food", nil)
    SetFuel(inst, nil)
    InitVeggie(inst)

    return inst
end, GetAssets2("pineananas_cooked", "pineananas"), nil))

table.insert(prefs, Prefab("pineananas_oversized", function() ------巨型松萝
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
end, GetAssets2("pineananas_oversized", "farm_plant_pineananas"), nil))

table.insert(prefs, Prefab("pineananas_oversized_waxed", function() ------巨型松萝（打过蜡的）
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
end, GetAssets2("pineananas_oversized_waxed", "farm_plant_pineananas"), nil))

table.insert(prefs, Prefab("pineananas_oversized_rotten", function() ------巨型腐烂松萝
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
end, GetAssets2("pineananas_oversized_rotten", "farm_plant_pineananas"), nil))

--------------------
--------------------

return unpack(prefs)
