require "prefabutil"

local function MakePlantable(name, data)
    local assets =
    {
        Asset("ANIM", "anim/"..data.build..".zip"),
        Asset("ATLAS", "images/inventoryimages/"..name..".xml"),
        Asset("IMAGE", "images/inventoryimages/"..name..".tex"),
    }

    local function ondeploy(inst, pt, deployer) --这里是右键种植时的函数
        local tree = SpawnPrefab(data.deployedprefab)
        if tree ~= nil then
            tree.Transform:SetPosition(pt:Get())
            
            if inst.components.stackable ~= nil then
                inst.components.stackable:Get():Remove()
            else
                inst:Remove()
            end

            tree.components.pickable:OnTransplant()
            if deployer ~= nil and deployer.SoundEmitter ~= nil then
                --V2C: WHY?!! because many of the plantables don't
                --     have SoundEmitter, and we don't want to add
                --     one just for this sound!
                deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
            end
        end
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst:AddTag("deployedplant") --植株种植标签，植物人种下时能恢复精神等

        inst.AnimState:SetBank(data.bank)
        inst.AnimState:SetBuild(data.build)
        inst.AnimState:PlayAnimation(data.anim)

        if data.floater ~= nil then
            MakeInventoryFloatable(inst, data.floater[1], data.floater[2], data.floater[3])
            if data.floaterParams ~= nil then
                local OnLandedClient_old = inst.components.floater.OnLandedClient
                inst.components.floater.OnLandedClient = function(self) --取消掉进海里时生成的波纹特效
                    OnLandedClient_old(self)
                    self.inst.AnimState:SetFloatParams(data.floaterParams, 1, self.bob_percent)
                end
            end
        else
            MakeInventoryFloatable(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        if data.stacksize ~= nil then
            inst:AddComponent("stackable")
            inst.components.stackable.maxsize = data.stacksize
        end

        inst:AddComponent("inspectable")
        inst.components.inspectable.nameoverride = data.inspectoverride

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = name
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..name..".xml"

        if data.fuelvalue ~= nil then
            inst:AddComponent("fuel")
            inst.components.fuel.fuelvalue = data.fuelvalue
        end

        if data.burntime ~= nil then
            if data.burnablefxsize == "small" then
                MakeSmallBurnable(inst, data.burntime)
            elseif data.burnablefxsize == "medium" then
                MakeMediumBurnable(inst, data.burntime)
            else
                MakeLargeBurnable(inst, data.burntime)
            end

            if data.propagatorsize == "small" then
                MakeSmallPropagator(inst)
            elseif data.propagatorsize == "medium" then
                MakeMediumPropagator(inst)
            else
                MakeLargePropagator(inst)
            end
        end

        MakeHauntableLaunchAndIgnite(inst)

        inst:AddComponent("deployable")
        inst.components.deployable.ondeploy = ondeploy
        inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
        if data.deployspacing ~= nil then
            inst.components.deployable:SetDeploySpacing(data.deployspacing)
        end

        return inst
    end

    return Prefab(name, fn, assets)
end

local plantables = {}

if CONFIGS_LEGION.FLOWERSPOWER then
    plantables.dug_rosebush = 
    {
        bank = "berrybush2",
        build = "rosebush",
        anim = "dropped",
        anim_palcer = "dead",
        inspectoverride = nil,          --检查时prefab名的重载
        deployedprefab = "rosebush",    --种植出的prefab名
        deployspacing = nil,            --种植要求范围
        stacksize = TUNING.STACK_SIZE_LARGEITEM, --最大堆叠数 10
        fuelvalue = TUNING.LARGE_FUEL,           --燃料值 30*6秒
        burntime = TUNING.LARGE_BURNTIME,        --燃烧时间 30秒
        burnablefxsize = "medium",       --燃烧特效大小
        propagatorsize = "small",       --引燃范围大小
        floater = {"large", 0.2, {0.65, 0.5, 0.65}},
        floaterParams = 0.03,
    }

    plantables.dug_lilybush = 
    {
        bank = "berrybush2",
        build = "lilybush",
        anim = "dropped",
        anim_palcer = "dead",
        inspectoverride = nil,
        deployedprefab = "lilybush",
        deployspacing = nil,
        stacksize = TUNING.STACK_SIZE_LARGEITEM,
        fuelvalue = TUNING.LARGE_FUEL,
        burntime = TUNING.LARGE_BURNTIME,
        burnablefxsize = "medium",
        propagatorsize = "small",
        floater = {"large", 0.2, {0.65, 0.5, 0.65}},
        floaterParams = 0.03,
    }

    plantables.dug_orchidbush = 
    {
        bank = "berrybush2",
        build = "orchidbush",
        anim = "dropped",
        anim_palcer = "dead",
        inspectoverride = nil,
        deployedprefab = "orchidbush",
        deployspacing = DEPLOYSPACING.MEDIUM,
        stacksize = TUNING.STACK_SIZE_LARGEITEM,
        fuelvalue = TUNING.LARGE_FUEL,
        burntime = TUNING.LARGE_BURNTIME,
        burnablefxsize = "medium",
        propagatorsize = "small",
        floater = {"large", 0.1, {0.65, 0.5, 0.65}},
    }

    plantables.cutted_rosebush = 
    {
        bank = "rosebush",
        build = "rosebush",
        anim = "cutted",
        anim_palcer = "dead",
        inspectoverride = nil,
        deployedprefab = "rosebush",
        deployspacing = nil,
        stacksize = TUNING.STACK_SIZE_SMALLITEM,
        fuelvalue = TUNING.SMALL_FUEL,
        burntime = TUNING.SMALL_BURNTIME,
        burnablefxsize = "small",
        propagatorsize = "small",
        floater = {"large", 0.1, 0.55},
    }

    plantables.cutted_lilybush = 
    {
        bank = "lilybush",
        build = "lilybush",
        anim = "cutted",
        anim_palcer = "dead",
        inspectoverride = nil,
        deployedprefab = "lilybush",
        deployspacing = nil,
        stacksize = TUNING.STACK_SIZE_SMALLITEM,
        fuelvalue = TUNING.SMALL_FUEL,
        burntime = TUNING.SMALL_BURNTIME,
        burnablefxsize = "small",
        propagatorsize = "small",
        floater = {"large", 0.1, 0.55},
    }

    plantables.cutted_orchidbush =
    {
        bank = "orchidbush",
        build = "orchidbush",
        anim = "cutted",
        anim_palcer = "dead",
        inspectoverride = nil,
        deployedprefab = "orchidbush",
        deployspacing = DEPLOYSPACING.MEDIUM,
        stacksize = TUNING.STACK_SIZE_SMALLITEM,
        fuelvalue = TUNING.SMALL_FUEL,
        burntime = TUNING.SMALL_BURNTIME,
        burnablefxsize = "small",
        propagatorsize = "small",
        floater = {"large", 0.1, 0.55},
    }
end

-- if CONFIGS_LEGION.PRAYFORRAIN then
-- end

local prefabs = {}
for i, v in pairs(plantables) do
    table.insert(prefabs, MakePlantable(i, v))
    table.insert(prefabs, MakePlacer(i.."_placer", v.bank, v.build, v.anim_palcer))
end

return unpack(prefabs)
