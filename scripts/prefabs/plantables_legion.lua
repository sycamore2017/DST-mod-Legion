-- require "prefabutil"

local function MakePlantable(name, data)
    local assets =
    {
        Asset("ANIM", "anim/"..data.animstate.build..".zip"),
        Asset("ATLAS", "images/inventoryimages/"..name..".xml"),
        Asset("IMAGE", "images/inventoryimages/"..name..".tex"),
    }
    if data.animstate.build ~= data.animstate.bank then
        table.insert(assets, Asset("ANIM", "anim/"..data.animstate.bank..".zip"))
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank(data.animstate.bank)
        inst.AnimState:SetBuild(data.animstate.build)
        inst.AnimState:PlayAnimation(data.anim)

        if data.floater ~= nil then
            MakeInventoryFloatable(inst, data.floater[2], data.floater[3], data.floater[4])
            if data.floater[1] ~= nil then
                local OnLandedClient_old = inst.components.floater.OnLandedClient
                inst.components.floater.OnLandedClient = function(self)
                    OnLandedClient_old(self)
                    self.inst.AnimState:SetFloatParams(data.floater[1], 1, self.bob_percent)
                end
            end
        end

        if data.fn_common ~= nil then
            data.fn_common(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = name
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"
        if data.floater == nil then
            inst.components.inventoryitem:SetSinks(true)
        end

        if data.stacksize ~= nil then
            inst:AddComponent("stackable")
            inst.components.stackable.maxsize = data.stacksize
        end

        if data.fuelvalue ~= nil then
            inst:AddComponent("fuel")
            inst.components.fuel.fuelvalue = data.fuelvalue
        end

        if data.burnable ~= nil then
            if data.burnable.fxsize == "small" then
                MakeSmallBurnable(inst, data.burnable.time)
            elseif data.burnable.fxsize == "medium" then
                MakeMediumBurnable(inst, data.burnable.time)
            else
                MakeLargeBurnable(inst, data.burnable.time)
            end

            if data.burnable.lightedsize == "small" then
                MakeSmallPropagator(inst)
            elseif data.burnable.lightedsize == "medium" then
                MakeMediumPropagator(inst)
            else
                MakeLargePropagator(inst)
            end
        end

        MakeHauntableLaunchAndIgnite(inst)

        inst:AddComponent("deployable")
        inst.components.deployable.ondeploy = function(inst, pt, deployer)
            local tree = SpawnPrefab(data.deployable.prefab)
            if tree ~= nil then
                tree.Transform:SetPosition(pt:Get())

                if inst.components.stackable ~= nil then
                    inst.components.stackable:Get():Remove()
                else
                    inst:Remove()
                end

                if tree.components.pickable ~= nil then
                    tree.components.pickable:OnTransplant()
                end

                if deployer ~= nil and deployer.SoundEmitter ~= nil then
                    deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
                end
            end
        end
        if data.deployable.mode ~= nil then
            inst.components.deployable:SetDeployMode(data.deployable.mode)
        end
        if data.deployable.spacing ~= nil then
            inst.components.deployable:SetDeploySpacing(data.deployable.spacing)
        end

        if data.fn_server ~= nil then
            data.fn_server(inst)
        end

        return inst
    end

    return Prefab(name, fn, assets)
end

--------------------
--------------------

local plantables = {}

if CONFIGS_LEGION.FLOWERSPOWER then
    plantables.dug_rosebush =
    {
        animstate = { bank = "berrybush2", build = "rosebush", anim = "dropped", anim_palcer = "dead", },
        floater = {0.03, "large", 0.2, {0.65, 0.5, 0.65}},  --漂浮参数（底部切割比例, 波纹动画, 波纹所处位置比例, 波纹大小）
        stacksize = TUNING.STACK_SIZE_LARGEITEM,            --最大堆叠数
        fuelvalue = TUNING.LARGE_FUEL,                      --燃料值
        burnable = {
            time = TUNING.LARGE_BURNTIME,   --燃烧时间
            fxsize = "medium",              --火焰特效大小
            lightedsize = "small",          --引燃范围大小
        },
        deployable = {
            prefab = "rosebush",        --种植出的prefab名
            mode = DEPLOYMODE.PLANT,    --种植类型
            spacing = nil,              --种植间隔
        },
        fn_common = function(inst)
            inst:AddTag("deployedplant") --植株种植标签，植物人种下时能恢复精神等
        end,
        fn_server = nil,
    }
    plantables.dug_lilybush =
    {
        animstate = { bank = "berrybush2", build = "lilybush", anim = "dropped", anim_palcer = "dead", },
        floater = {0.03, "large", 0.2, {0.65, 0.5, 0.65}},
        stacksize = TUNING.STACK_SIZE_LARGEITEM,
        fuelvalue = TUNING.LARGE_FUEL,
        burnable = {
            time = TUNING.LARGE_BURNTIME,
            fxsize = "medium",
            lightedsize = "small",
        },
        deployable = {
            prefab = "lilybush",
            mode = DEPLOYMODE.PLANT,
            spacing = nil,
        },
        fn_common = function(inst)
            inst:AddTag("deployedplant")
        end,
        fn_server = nil,
    }
    plantables.dug_orchidbush =
    {
        animstate = { bank = "berrybush2", build = "orchidbush", anim = "dropped", anim_palcer = "dead", },
        floater = {nil, "large", 0.1, {0.65, 0.5, 0.65}},
        stacksize = TUNING.STACK_SIZE_LARGEITEM,
        fuelvalue = TUNING.LARGE_FUEL,
        burnable = {
            time = TUNING.LARGE_BURNTIME,
            fxsize = "medium",
            lightedsize = "small",
        },
        deployable = {
            prefab = "orchidbush",
            mode = DEPLOYMODE.PLANT,
            spacing = DEPLOYSPACING.MEDIUM,
        },
        fn_common = function(inst)
            inst:AddTag("deployedplant")
        end,
        fn_server = nil,
    }
    plantables.cutted_rosebush =
    {
        animstate = { bank = "rosebush", build = "rosebush", anim = "cutted", anim_palcer = "dead", },
        floater = {nil, "large", 0.1, 0.55},
        stacksize = TUNING.STACK_SIZE_SMALLITEM,
        fuelvalue = TUNING.SMALL_FUEL,
        burnable = {
            time = TUNING.SMALL_BURNTIME,
            fxsize = "small",
            lightedsize = "small",
        },
        deployable = {
            prefab = "rosebush",
            mode = DEPLOYMODE.PLANT,
            spacing = nil,
        },
        fn_common = function(inst)
            inst:AddTag("deployedplant")
        end,
        fn_server = nil,
    }
    plantables.cutted_lilybush =
    {
        animstate = { bank = "lilybush", build = "lilybush", anim = "cutted", anim_palcer = "dead", },
        floater = {nil, "large", 0.1, 0.55},
        stacksize = TUNING.STACK_SIZE_SMALLITEM,
        fuelvalue = TUNING.SMALL_FUEL,
        burnable = {
            time = TUNING.SMALL_BURNTIME,
            fxsize = "small",
            lightedsize = "small",
        },
        deployable = {
            prefab = "lilybush",
            mode = DEPLOYMODE.PLANT,
            spacing = nil,
        },
        fn_common = function(inst)
            inst:AddTag("deployedplant")
        end,
        fn_server = nil,
    }
    plantables.cutted_orchidbush =
    {
        animstate = { bank = "orchidbush", build = "orchidbush", anim = "cutted", anim_palcer = "dead", },
        floater = {nil, "large", 0.1, 0.55},
        stacksize = TUNING.STACK_SIZE_SMALLITEM,
        fuelvalue = TUNING.SMALL_FUEL,
        burnable = {
            time = TUNING.SMALL_BURNTIME,
            fxsize = "small",
            lightedsize = "small",
        },
        deployable = {
            prefab = "orchidbush",
            mode = DEPLOYMODE.PLANT,
            spacing = DEPLOYSPACING.MEDIUM,
        },
        fn_common = function(inst)
            inst:AddTag("deployedplant")
        end,
        fn_server = nil,
    }
end

if CONFIGS_LEGION.LEGENDOFFALL then
    plantables.siving_derivant_item = --[[ 子圭一型岩(物品) ]]
    {
        animstate = { bank = "siving_derivants", build = "siving_derivants", anim = "item", anim_palcer = "lvl0", },
        floater = nil,
        stacksize = TUNING.STACK_SIZE_LARGEITEM,
        fuelvalue = nil,
        burnable = nil,
        deployable = {
            prefab = "siving_derivant_lvl0",
            mode = nil,
            spacing = nil,
        },
        fn_common = nil,
        fn_server = nil,
    }
end

--------------------
--------------------

local prefabs = {}
for i, v in pairs(plantables) do
    table.insert(prefabs, MakePlantable(i, v))
    table.insert(prefabs, MakePlacer(i.."_placer", v.animstate.bank, v.animstate.build, v.animstate.anim_palcer))
end

return unpack(prefabs)
