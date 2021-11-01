local prefs = {}

--------------------------------------------------------------------------
--[[ 通用 ]]
--------------------------------------------------------------------------

local ctlFuledItems = {
    ice = { moisture = 50, nutrients = nil },
    icehat = { moisture = 500, nutrients = { 8, nil, 8 } },
    wintercooking_mulleddrink = { moisture = 50, nutrients = { 2, 2, 8 } },
    waterballoon = { moisture = 100, nutrients = { nil, 2, nil } },
}

local function MakeItem(data)
    local basename = "siving_ctl"..data.name
    table.insert(prefs, Prefab(
        basename.."_item",
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddNetwork()

            MakeInventoryPhysics(inst)

            inst.AnimState:SetBank(basename)
            inst.AnimState:SetBuild(basename)
            inst.AnimState:PlayAnimation("item")

            inst:SetPrefabNameOverride(basename)

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst.siv_moisture = nil
            inst.siv_nutrients = nil

            inst:AddComponent("inspectable")

            inst:AddComponent("inventoryitem")
            inst.components.inventoryitem.imagename = basename.."_item"
            inst.components.inventoryitem.atlasname = "images/inventoryimages/"..basename.."_item.xml"
            inst.components.inventoryitem:SetSinks(true)

            inst:AddComponent("deployable")
            inst.components.deployable.ondeploy = function(inst, pt, deployer)
                local tree = SpawnPrefab(basename)
                if tree ~= nil then
                    tree.components.botanycontroller:SetValue(inst.siv_moisture, inst.siv_nutrients, false)
                    tree.Transform:SetPosition(pt:Get())
                    if deployer ~= nil and deployer.SoundEmitter ~= nil then
                        deployer.SoundEmitter:PlaySound(data.sound)
                    end
                    inst:Remove()
                end
            end

            MakeHauntableLaunchAndIgnite(inst)

            inst.OnSave = function(inst, data)
                if inst.siv_moisture ~= nil then
                    data.siv_moisture = inst.siv_moisture
                end
                if inst.siv_nutrients ~= nil then
                    data.siv_nutrients = inst.siv_nutrients
                end
            end
            inst.OnLoad = function(inst, data)
                if data ~= nil then
                    if data.siv_moisture ~= nil then
                        inst.siv_moisture = data.siv_moisture
                    end
                    if data.siv_nutrients ~= nil then
                        inst.siv_nutrients = data.siv_nutrients
                    end
                end
            end

            return inst
        end,
        data.assets,
        data.prefabs
    ))
    table.insert(prefs, MakePlacer(basename.."_item_placer", basename, basename, "palcer"))
end

local function MakeConstruct(data)
    local basename = "siving_ctl"..data.name

    local function CanAcceptMoisture(botanyctl, test)
        if test ~= nil and (botanyctl.ctltype == 1 or botanyctl.ctltype == 3) then
            return botanyctl.moisture < botanyctl.moisture_max
        end
        return nil
    end
    local function CanAcceptNutrients(botanyctl, test)
        if test ~= nil and (botanyctl.ctltype == 2 or botanyctl.ctltype == 3) then
            if test[1] ~= nil and test[1] ~= 0 and botanyctl.nutrients[1] < botanyctl.nutrient_max then
                return true
            elseif test[2] ~= nil and test[2] ~= 0 and botanyctl.nutrients[2] < botanyctl.nutrient_max then
                return true
            elseif test[3] ~= nil and test[3] ~= 0 and botanyctl.nutrients[3] < botanyctl.nutrient_max then
                return true
            else
                return false
            end
        end
        return nil
    end

    table.insert(prefs, Prefab(
        basename,
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddMiniMapEntity()
            inst.entity:AddNetwork()

            inst:SetPhysicsRadiusOverride(.5)
            MakeObstaclePhysics(inst, inst.physicsradiusoverride)

            inst.MiniMapEntity:SetIcon(basename..".tex")

            inst.AnimState:SetBank(basename)
            inst.AnimState:SetBuild(basename)
            inst.AnimState:PlayAnimation("idle")

            inst:AddTag("structure")

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst:AddComponent("inspectable")

            inst:AddComponent("portablestructure")
            inst.components.portablestructure:SetOnDismantleFn(function(inst, doer)
                local item = SpawnPrefab(basename.."_item")
                if item ~= nil then
                    item.siv_moisture = inst.components.botanycontroller.moisture
                    item.siv_nutrients = inst.components.botanycontroller.nutrients
                    if doer ~= nil and doer.components.inventory ~= nil then
                        doer.components.inventory:GiveItem(item)
                        if doer.SoundEmitter ~= nil then
                            doer.SoundEmitter:PlaySound("dontstarve/common/together/succulent_craft")
                        end
                    else
                        item.Transform:SetPosition(inst.Transform:GetWorldPosition())
                    end
                    inst.components.botanycontroller:TriggerPlant(false)
                    inst:Remove()
                end
            end)

            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
            inst.components.workable:SetWorkLeft(1)
            inst.components.workable:SetOnFinishCallback(function(inst, worker)
                local x, y, z = inst.Transform:GetWorldPosition()
                local item = SpawnPrefab(basename.."_item")
                if item ~= nil then
                    item.siv_moisture = inst.components.botanycontroller.moisture
                    item.siv_nutrients = inst.components.botanycontroller.nutrients
                    item.Transform:SetPosition(x, y, z)
                end
                local fx = SpawnPrefab("collapse_small")
                fx.Transform:SetPosition(x, y, z)
                fx:SetMaterial("rock")
                inst.components.botanycontroller:TriggerPlant(false)
                inst:Remove()
            end)

            inst:AddComponent("hauntable")
            inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)
            inst.components.hauntable.cooldown = TUNING.HAUNT_COOLDOWN_HUGE
            inst.components.hauntable:SetOnHauntFn(function(inst)
                --undo:作祟时直接触发一次施肥/浇水
            end)

            inst:AddComponent("trader")
            inst.components.trader:SetAcceptTest(function(inst, item, giver)
                local botanyctl = inst.components.botanycontroller
                local acpt_m = nil --true接受、false已经满了、nil无法接受
                local acpt_n = nil
                if ctlFuledItems[item.prefab] ~= nil then
                    acpt_m = CanAcceptMoisture(botanyctl, ctlFuledItems[item.prefab].moisture)
                    acpt_n = CanAcceptNutrients(botanyctl, ctlFuledItems[item.prefab].nutrients)
                elseif item.siv_ctl_fueled ~= nil then --兼容其他mod
                    acpt_m = CanAcceptMoisture(botanyctl, item.siv_ctl_fueled.moisture)
                    acpt_n = CanAcceptNutrients(botanyctl, item.siv_ctl_fueled.nutrients)
                else
                    acpt_m = CanAcceptMoisture(botanyctl, item.components.wateryprotection)
                    if item.components.fertilizer ~= nil then
                        acpt_n = CanAcceptNutrients(botanyctl, item.components.fertilizer.nutrients)
                    end
                end

                if acpt_m or acpt_n then
                    return true
                elseif giver ~= nil then
                    if acpt_m == false or acpt_n == false then
                        giver.siv_ctl_traded = "ISFULL"
                    else
                        giver.siv_ctl_traded = "REFUSE"
                    end
                end

                return false
            end)
            inst.components.trader.onaccept = function(inst, giver, item)
                local botanyctl = inst.components.botanycontroller
                if ctlFuledItems[item.prefab] ~= nil then
                    botanyctl:SetValue(ctlFuledItems[item.prefab].moisture, ctlFuledItems[item.prefab].nutrients, true)
                elseif item.siv_ctl_fueled ~= nil then
                    botanyctl:SetValue(item.siv_ctl_fueled.moisture, item.siv_ctl_fueled.nutrients, true)
                    if item.siv_ctl_fueled.fn_accept ~= nil then
                        item.siv_ctl_fueled.fn_accept(inst, giver, item)
                        return
                    end
                else
                    local waterypro = item.components.wateryprotection
                    local value_m = nil
                    if waterypro ~= nil then
                        if waterypro.addwetness == nil or waterypro.addwetness == 0 then
                            value_m = 10
                        else
                            value_m = waterypro.addwetness
                        end
                        if item.components.finiteuses ~= nil then
                            value_m = value_m * item.components.finiteuses:GetUses() /2 --普通水壶是+500
                        else
                            value_m = value_m * 10
                        end
                    end

                    botanyctl:SetValue(value_m,
                        item.components.fertilizer ~= nil and item.components.fertilizer.nutrients or nil,
                        true
                    )

                    if item.components.finiteuses ~= nil then
                        if item.prefab == "wateringcan" or item.prefab == "premiumwateringcan" then
                            item.components.finiteuses:Use(1000)
                        else
                            item.components.finiteuses:Use(1)
                        end
                        return
                    end
                end

                if item.components.stackable ~= nil then
                    item.components.stackable:Get():Remove()
                else
                    item:Remove()
                end
            end
            inst.components.trader.onrefuse = function(inst, giver, item)
                if giver ~= nil and giver.siv_ctl_traded ~= nil and giver.components.talker ~= nil then
                    giver.components.talker:Say(GetString(giver, "DESCRIBE", { "SIVING_CTLALL", giver.siv_ctl_traded }))
                    giver.siv_ctl_traded = nil
                end
            end
            inst.components.trader.deleteitemonaccept = false --收到物品不马上移除，根据具体物品决定
            inst.components.trader.acceptnontradable = true

            inst:AddComponent("botanycontroller")
            inst.components.botanycontroller.type = data.ctltype

            inst:DoTaskInTime(0.1+math.random()*0.4, function()
                inst.components.botanycontroller:TriggerPlant(true)
            end)
            --undo:下雨时，自动吸收水分

            return inst
        end,
        data.assets,
        data.prefabs
    ))
    table.insert(prefs, MakePlacer(basename.."_item_placer", basename, basename, "palcer"))
end

--------------------------------------------------------------------------
--[[ 子圭·利川 ]]
--------------------------------------------------------------------------

MakeItem({
    name = "water",
    assets = {
        Asset("ANIM", "anim/siving_ctlwater.zip"),
        Asset("ATLAS", "images/inventoryimages/siving_ctlwater_item.xml"),
        Asset("IMAGE", "images/inventoryimages/siving_ctlwater_item.tex"),
    },
    prefabs = { "siving_ctlwater" },
    sound = "dontstarve/common/rain_meter_craft",
})

MakeConstruct({
    name = "water",
    assets = {
        Asset("ANIM", "anim/siving_ctlwater.zip"),
    },
    prefabs = { "siving_ctlwater_item" },
    ctltype = 1,
})

--------------------------------------------------------------------------
--[[ 子圭·益矩 ]]
--------------------------------------------------------------------------

MakeItem({
    name = "dirt",
    assets = {
        Asset("ANIM", "anim/siving_ctldirt.zip"),
        Asset("ATLAS", "images/inventoryimages/siving_ctldirt_item.xml"),
        Asset("IMAGE", "images/inventoryimages/siving_ctldirt_item.tex"),
    },
    prefabs = { "siving_ctldirt" },
    sound = "dontstarve/common/winter_meter_craft",
})

MakeConstruct({
    name = "dirt",
    assets = {
        Asset("ANIM", "anim/siving_ctldirt.zip"),
    },
    prefabs = { "siving_ctldirt_item" },
    ctltype = 2,
})

--------------------------------------------------------------------------
--[[ 子圭·崇溟 ]]
--------------------------------------------------------------------------

--all

--------------------
--------------------

return unpack(prefs)
