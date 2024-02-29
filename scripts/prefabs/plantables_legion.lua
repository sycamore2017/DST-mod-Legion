local prefs = {}

local function MakePlantable(name, data)
    local imgname = data.overrideimage or name
    local assets = {
        Asset("ANIM", "anim/"..data.animstate.build..".zip"),
        Asset("ATLAS", "images/inventoryimages/"..imgname..".xml"),
        Asset("IMAGE", "images/inventoryimages/"..imgname..".tex")
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
        inst.AnimState:PlayAnimation(data.animstate.anim)

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

        inst.pickupsound = "vegetation_firm"

        if data.fn_common ~= nil then
            data.fn_common(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = imgname
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..imgname..".xml"
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
        inst.components.deployable.ondeploy = function(inst, pt, deployer, rot)
            
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

local plantables = {

}

----异种
for k,v in pairs(CROPS_DATA_LEGION) do
    local seedsprefab = "seeds_"..k.."_l"
    local cropprefab = "plant_"..k.."_l"
    plantables[seedsprefab] = {
        animstate = { bank = "seeds_crop_l", build = "seeds_crop_l", anim = "idle" },
        overrideimage = "seeds_crop_l2",
        floater = {nil, "small", 0.2, 1.2},
        stacksize = TUNING.STACK_SIZE_SMALLITEM,
        fuelvalue = TUNING.SMALL_FUEL,
        burnable = {
            time = TUNING.SMALL_BURNTIME,
            fxsize = "small",
            lightedsize = "small"
        },
        deployable = {
            prefab = cropprefab,
            mode = DEPLOYMODE.PLANT, spacing = DEPLOYSPACING.MEDIUM,
            sound = "dontstarve/wilson/plant_seeds"
        },
        fn_common = function(inst)
            inst:AddTag("deployedplant")
            inst:AddTag("treeseed") --能使其放入种子袋
            -- inst.overridedeployplacername = seedsprefab.."_placer" --这个可以让placer换成另一个

            if v.image ~= nil then
                inst.inv_image_bg = { image = v.image.name, atlas = v.image.atlas }
            else
                inst.inv_image_bg = {}
            end
            if inst.inv_image_bg.image == nil then
                inst.inv_image_bg.image = k..".tex"
            end
            if inst.inv_image_bg.atlas == nil then
                inst.inv_image_bg.atlas = GetInventoryItemAtlas(inst.inv_image_bg.image)
            end

            inst.displaynamefn = function(inst)
                return STRINGS.NAMES[string.upper(cropprefab)]..STRINGS.PLANT_CROP_L["SEEDS"]
            end
        end,
        fn_server = function(inst)
            inst.sivbird_l_food = 0.5 --能给予玄鸟换取子圭石

            inst.components.inspectable.nameoverride = "SEEDS_CROP_L"

            inst:AddComponent("plantablelegion")
            inst.components.plantablelegion.plant = cropprefab
            inst.components.plantablelegion.plant2 = v.plant2 --同一个异种种子可能能升级第二种对象
        end
    }
end

--------------------
--------------------

for i, v in pairs(plantables) do
    table.insert(prefs, MakePlantable(i, v))
end

return unpack(prefs)
