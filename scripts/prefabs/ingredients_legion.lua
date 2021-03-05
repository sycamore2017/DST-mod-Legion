--------------------------------------------------------------------------
--[[ 该文件只实现非农作物的prefab，包括肉类与菜类等，而农作物的prefab实现见new_crop_legion.lua ]]
--------------------------------------------------------------------------

require "prefabutil"

local ingredients_legion = {}
local prefs = {}

if CONFIGS_LEGION.FLOWERSPOWER then
    ingredients_legion.petals_rose = {
        base = {
            floatable = {nil, "small", 0.08, 0.95},
            edible = { hunger = 9.375, sanity = 1, health = 8, foodtype = nil, foodtype_secondary = nil },
            perishable = { product = nil, time = TUNING.PERISH_FAST },
            stackable = { size = nil },
            fuel = { value = nil },
            burnable = {},
        },
    }
    ingredients_legion.petals_lily = {
        base = {
            floatable = {nil, "small", 0.08, 0.95},
            edible = { hunger = 9.375, sanity = 10, health = -3, foodtype = nil, foodtype_secondary = nil },
            perishable = { product = nil, time = TUNING.PERISH_FAST },
            stackable = { size = nil },
            fuel = { value = nil },
            burnable = {},
        },
    }
    ingredients_legion.petals_orchid = {
        base = {
            floatable = {nil, "small", 0.08, 0.95},
            edible = { hunger = 12.5, sanity = 5, health = 0, foodtype = nil, foodtype_secondary = nil },
            perishable = { product = nil, time = TUNING.PERISH_FAST },
            stackable = { size = nil },
            fuel = { value = nil },
            burnable = {},
        },
    }
end

if CONFIGS_LEGION.PRAYFORRAIN then
    ingredients_legion.monstrain_leaf = {
        base = {
            floatable = {nil, "small", 0.05, 1.1},
            edible = { hunger = 12.5, sanity = -15, health = -30, foodtype = nil, foodtype_secondary = FOODTYPE.MONSTER },
            perishable = { product = nil, time = TUNING.PERISH_MED },
            stackable = { size = nil },
            fuel = { value = nil },
            burnable = {},
        },
    }
    ingredients_legion.squamousfruit = {
        base = {
            floatable = {0.05, "small", 0.2, 0.7},
            edible = { hunger = 25, sanity = -5, health = -3, foodtype = nil, foodtype_secondary = nil },
            stackable = { size = nil },
            burnable = {},
            fn_server = function(inst)
                inst.components.edible:SetOnEatenFn(function(food, eater)
                    if eater.components.moisture then
                        eater.components.moisture:DoDelta(-100)
                    end
                end)
            end,
        },
    }
end

if TUNING.LEGION_DESERTSECRET then
    ingredients_legion.shyerry = {
        base = {
            prefabs = {"buff_healthstorage", "shyerrytree1_planted", "shyerrytree3_planted"},
            cookable = { product = nil },
            floatable = {0.04, "small", 0.25, 0.9},
            edible = { hunger = 18.75, sanity = 0, health = 8, foodtype = nil, foodtype_secondary = nil },
            perishable = { product = nil, time = TUNING.PERISH_MED },
            stackable = { size = nil },
            burnable = {},
            fn_common = function(inst)
                inst:AddTag("deployedplant")
            end,
            fn_server = function(inst)
                inst.components.edible:SetOnEatenFn(function(food, eater)
                    if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                        not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                        not eater:HasTag("playerghost") then
                        eater.buff_healthstorage_times = 20 --因为buff相关组件不支持相同buff叠加时的数据传输，所以这里自己定义了一个传输方式
                        eater.components.debuffable:AddDebuff("buff_healthstorage", "buff_healthstorage")
                    end
                end)

                inst:AddComponent("deployable")
                inst.components.deployable.ondeploy = function(me, pt, deployer)
                    local names = {"shyerrytree1_planted", "shyerrytree3_planted"}
                    local tree = SpawnPrefab(names[math.random(#names)])
                    if tree ~= nil then
                        tree.Transform:SetPosition(pt:Get())
                        me.components.stackable:Get():Remove()
                        -- tree.components.pickable:OnTransplant()
                        if deployer ~= nil and deployer.SoundEmitter ~= nil then
                            --V2C: WHY?!! because many of the plantables don't
                            --     have SoundEmitter, and we don't want to add
                            --     one just for this sound!
                            deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
                        end
                    end
                end
                inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
            end,
        },
        cooked = {
            floatable = {0.02, "small", 0.2, 0.9},
            edible = { hunger = 12.5, sanity = 1, health = 0, foodtype = nil, foodtype_secondary = nil },
            perishable = { product = nil, time = TUNING.PERISH_FAST },
            stackable = { size = nil },
            fuel = { value = nil },
            burnable = {},
        },
    }
    table.insert(prefs, MakePlacer("shyerry_placer", "shyerrytree1", "shyerrytree1", "placer")) --name.."_placer", bank, build, anim
end

if TUNING.LEGION_FLASHANDCRUSH then
    ingredients_legion.albicans_cap = {
        base = {
            floatable = {0.01, "small", 0.15, 1},
            edible = { hunger = 15, sanity = 15, health = 15, foodtype = nil, foodtype_secondary = nil },
            perishable = { product = nil, time = TUNING.PERISH_FASTISH },
            stackable = { size = nil },
            fuel = { value = nil },
            burnable = {},
            fn_common = function(inst)
                inst:AddTag("mushroom")
            end,
        },
    }
end

if CONFIGS_LEGION.LEGENDOFFALL then
    ingredients_legion.pineananas = {
        base = {
            cookable = { product = nil },
            floatable = {nil, "small", 0.2, 0.9},
            edible = { hunger = 12, sanity = -10, health = 8, foodtype = nil, foodtype_secondary = nil },
            perishable = { product = nil, time = TUNING.PERISH_MED },
            stackable = { size = nil },
            burnable = {},
        },
        cooked = {
            floatable = {nil, "small", 0.2, 1},
            edible = { hunger = 18.5, sanity = 5, health = 16, foodtype = nil, foodtype_secondary = nil },
            perishable = { product = nil, time = TUNING.PERISH_SUPERFAST },
            stackable = { size = nil },
            fuel = { value = nil },
            burnable = {},
        },
    }
    -- ingredients_legion.catmint = {
    --     base = {
    --         floatable = {nil, "small", 0.08, 0.95},
    --         edible = { hunger = 6, sanity = 10, health = 1, foodtype = nil, foodtype_secondary = nil },
    --         perishable = { product = nil, time = TUNING.PERISH_SLOW },
    --         stackable = { size = nil },
    --         fuel = { value = nil },
    --         burnable = {},
    --         fn_common = function(inst)
    --             inst:AddTag("catfood")
    --             inst:AddTag("cattoy")
    --             inst:AddTag("catmint")
    --         end,
    --     },
    -- }
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

local function MakePrefab(name, info)
    -- 参数示例
    --[[
        {
            base = {
                animstate = { bank = nil, build = nil, anim = nil },
                assets = nil,
                prefabs = nil,
                cookable = { product = nil },
                dryable = { product = nil, time = nil, build = nil, build_dried = nil },
                floatable = {nil, "small", 0.2, 0.9},
                lure = {lure_data = TUNING.OCEANFISHING_LURE.BERRY, single_use = true, build = "oceanfishing_lure_mis", symbol = "hook_berries"},
                edible = { hunger = 0, sanity = 0, health = 0, foodtype = nil, foodtype_secondary = nil },
                perishable = { product = nil, time = nil },
                stackable = { size = nil },
                fuel = { value = nil },
                burnable = {},
                fn_common = nil,
                fn_server = nil,
            },
            cooked = {},
            dried = {},
            rotten = {},
        }
    ]]--

    local function Fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank(info.animstate.bank)
        inst.AnimState:SetBuild(info.animstate.build)
        inst.AnimState:PlayAnimation(info.animstate.anim)

        -- inst:AddTag("meat")

        if info.cookable ~= nil then
            inst:AddTag("cookable")
        end

        if info.dryable ~= nil then
            inst:AddTag("dryable")
            inst:AddTag("lureplant_bait")
        end

        if info.floatable ~= nil then
            MakeInventoryFloatable(inst, info.floatable[2], info.floatable[3], info.floatable[4])
            if info.floatable[1] ~= nil then
                local OnLandedClient_old = inst.components.floater.OnLandedClient
                inst.components.floater.OnLandedClient = function(self)
                    OnLandedClient_old(self)
                    self.inst.AnimState:SetFloatParams(info.floatable[1], 1, self.bob_percent)
                end
            end
        end

        if info.lure ~= nil then
            inst:AddTag("oceanfishing_lure")
        end

        if info.fn_common ~= nil then
            info.fn_common(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = name
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"

        inst:AddComponent("bait")

        inst:AddComponent("tradable")

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = info.edible.health or 0
        inst.components.edible.hungervalue = info.edible.hunger or 0
        inst.components.edible.sanityvalue = info.edible.sanity or 0
        inst.components.edible.foodtype = info.edible.foodtype or FOODTYPE.VEGGIE
        inst.components.edible.secondaryfoodtype = info.edible.foodtype_secondary

        if info.perishable ~= nil then
            inst:AddComponent("perishable")
            inst.components.perishable:SetPerishTime(info.perishable.time)
            inst.components.perishable:StartPerishing()
            inst.components.perishable.onperishreplacement = info.perishable.product
        end

        if info.stackable ~= nil then
            inst:AddComponent("stackable")
            inst.components.stackable.maxsize = info.stackable.size or TUNING.STACK_SIZE_SMALLITEM
        end

        if info.fuel ~= nil then
            inst:AddComponent("fuel")
            inst.components.fuel.fuelvalue = info.fuel.value or TUNING.TINY_FUEL
        end

        if info.dryable ~= nil then
            inst:AddComponent("dryable")
            inst.components.dryable:SetProduct(info.dryable.product)
            inst.components.dryable:SetDryTime(info.dryable.time)
            inst.components.dryable:SetBuildFile(info.dryable.build)
            inst.components.dryable:SetDriedBuildFile(info.dryable.build_dried)
        end

        if info.cookable ~= nil then
            inst:AddComponent("cookable")
            inst.components.cookable.product = info.cookable.product
        end

        if info.burnable ~= nil then
            MakeSmallBurnable(inst)
            MakeSmallPropagator(inst)
        end

        if info.lure ~= nil then
            inst:AddComponent("oceanfishingtackle")
            inst.components.oceanfishingtackle:SetupLure(info.lure)
        end

        MakeHauntableLaunchAndIgnite(inst)

        if info.fn_server ~= nil then
            info.fn_server(inst)
        end

        return inst
    end

    table.insert(prefs, Prefab(name, Fn, info.assets, info.prefabs))
end

local function MadePrefab(name, info)
    local assets = {
        Asset("ANIM", "anim/"..info.animstate.build..".zip"),
        Asset("ATLAS", "images/inventoryimages/"..name..".xml"),
        Asset("IMAGE", "images/inventoryimages/"..name..".tex"),
    }
    if info.assets ~= nil then
        for i,v in ipairs(assets) do
            table.insert(info.assets, v)
        end
    else
        info.assets = assets
    end

    local prefabs = {}
    if info.cookable ~= nil then
        table.insert(prefabs, info.cookable.product)
    end
    if info.dryable ~= nil then
        table.insert(prefabs, info.dryable.product)
    end
    if info.perishable ~= nil then
        local product = info.perishable.product or "spoiled_food"
        table.insert(prefabs, product)
        info.perishable.product = product
    end
    if info.prefabs ~= nil then
        for i,v in ipairs(prefabs) do
            if not table.contains(info.prefabs, v) then
                table.insert(info.prefabs, v)
            end
        end
    else
        info.prefabs = prefabs
    end

    MakePrefab(name, info)
end

local function MakeIngredient(name, data)
    if data.base ~= nil then
        local info = data.base
        if info.animstate == nil then
            info.animstate = {}
        end
        if info.animstate.bank == nil then
            info.animstate.bank = name
        end
        if info.animstate.build == nil then
            info.animstate.build = name
        end
        if info.animstate.anim == nil then
            info.animstate.anim = "idle"
        end

        local assets = {
            Asset("ANIM", "anim/"..info.animstate.build..".zip"),
            Asset("ATLAS", "images/inventoryimages/"..name..".xml"),
            Asset("IMAGE", "images/inventoryimages/"..name..".tex"),
        }
        if info.assets ~= nil then
            for i,v in ipairs(assets) do
                table.insert(info.assets, v)
            end
        else
            info.assets = assets
        end

        local prefabs = {}
        if info.cookable ~= nil then
            local product = data.cooked ~= nil and name.."_cooked" or info.cookable.product
            table.insert(prefabs, product)
            info.cookable.product = product
        end
        if info.dryable ~= nil then
            local product = data.dried ~= nil and name.."_dried" or info.dryable.product
            table.insert(prefabs, product)
            info.dryable.product = product
        end
        if info.perishable ~= nil then
            local product = data.rotten ~= nil and name.."_rotten" or (info.perishable.product or "spoiled_food")
            table.insert(prefabs, product)
            info.perishable.product = product
        end
        if info.prefabs ~= nil then
            for i,v in ipairs(prefabs) do
                if not table.contains(info.prefabs, v) then
                    table.insert(info.prefabs, v)
                end
            end
        else
            info.prefabs = prefabs
        end

        MakePrefab(name, info)
    end

    if data.cooked ~= nil then
        local info = data.cooked
        if info.animstate == nil then
            info.animstate = {}
        end
        if info.animstate.bank == nil then
            info.animstate.bank = name
        end
        if info.animstate.build == nil then
            info.animstate.build = name
        end
        if info.animstate.anim == nil then
            info.animstate.anim = "cooked"
        end

        MadePrefab(name.."_cooked", info)
    end

    if data.dried ~= nil then
        local info = data.dried
        if info.animstate == nil then
            info.animstate = {}
        end
        if info.animstate.bank == nil then
            info.animstate.bank = name
        end
        if info.animstate.build == nil then
            info.animstate.build = name
        end
        if info.animstate.anim == nil then
            info.animstate.anim = "dried"
        end

        MadePrefab(name.."_dried", info)
    end

    if data.rotten ~= nil then
        local info = data.rotten
        if info.animstate == nil then
            info.animstate = {}
        end
        if info.animstate.bank == nil then
            info.animstate.bank = name
        end
        if info.animstate.build == nil then
            info.animstate.build = name
        end
        if info.animstate.anim == nil then
            info.animstate.anim = "rotten"
        end

        MadePrefab(name.."_rotten", info)
    end
end

--------------------------------------------------------------------------
--------------------------------------------------------------------------

for name,data in pairs(ingredients_legion) do
    MakeIngredient(name, data)
end

return unpack(prefs)
