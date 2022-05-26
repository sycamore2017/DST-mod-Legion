local prefs = {}

--------------------------------------------------------------------------
--[[ 通用 ]]
--------------------------------------------------------------------------

local ctlFuledItems = {
    ice = { moisture = 100, nutrients = nil },
    icehat = { moisture = 1000, nutrients = { 8, nil, 8 } },
    wintercooking_mulleddrink = { moisture = 100, nutrients = { 2, 2, 8 } },
    waterballoon = { moisture = 400, nutrients = { nil, 2, nil } },
    oceanfish_medium_8_inv = { moisture = 200, nutrients = { 16, nil, nil } }, --冰鲷鱼
    watermelonicle = { moisture = 200, nutrients = { 8, 8, 16 } },
    icecream = { moisture = 200, nutrients = { 24, 24, 24 } },
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

            inst:AddTag("eyeturret") --眼球塔的专属标签，但为了deployable组件的摆放名字而使用（显示为“放置”）

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
            inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)
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
    table.insert(prefs, MakePlacer(basename.."_item_placer", basename, basename, "idle"))
end

local function MakeConstruct(data)
    local basename = "siving_ctl"..data.name

    local function CanAcceptMoisture(botanyctl, test)
        if test ~= nil and (botanyctl.type == 1 or botanyctl.type == 3) then
            return botanyctl.moisture < botanyctl.moisture_max
        end
        return nil
    end
    local function CanAcceptNutrients(botanyctl, test)
        if test ~= nil and (botanyctl.type == 2 or botanyctl.type == 3) then
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
    local function GiveItemBack(inst, giver, item)
        if giver and giver.components.inventory ~= nil then
            -- item.prevslot = nil
            -- item.prevcontainer = nil
            giver.components.inventory:GiveItem(item, nil, giver:GetPosition() or nil)
        else
            item.Transform:SetPosition(inst.Transform:GetWorldPosition())
        end
    end
    local function GetAllActiveItems(giver, item, times)
        --需要限制获取时机，不可能每次循环都来合并一次
        if times == 1 and item.components.stackable ~= nil then --有叠加组件，说明鼠标上可能有物品
            if giver.components.inventory ~= nil then
                local activeitem = giver.components.inventory:GetActiveItem()
                if activeitem ~= nil and activeitem.prefab == item.prefab then
                    activeitem.components.inventoryitem:RemoveFromOwner(true)
                    item.components.stackable:Put(activeitem)
                end
            end
        end
    end

    local function AcceptTest(inst, item, giver)
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
    end
    local function OnAccept(inst, giver, item, times)
        if times == nil then
            times = 1
        end

        local botanyctl = inst.components.botanycontroller
        if ctlFuledItems[item.prefab] ~= nil then
            GetAllActiveItems(giver, item, times)
            botanyctl:SetValue(ctlFuledItems[item.prefab].moisture, ctlFuledItems[item.prefab].nutrients, true)
        elseif item.siv_ctl_fueled ~= nil then
            botanyctl:SetValue(item.siv_ctl_fueled.moisture, item.siv_ctl_fueled.nutrients, true)
            if item.siv_ctl_fueled.fn_accept ~= nil then
                item.siv_ctl_fueled.fn_accept(inst, giver, item)
                return
            end
            GetAllActiveItems(giver, item, times)
        else
            GetAllActiveItems(giver, item, times)
            local waterypro = item.components.wateryprotection
            local value_m = nil
            if waterypro ~= nil then
                if waterypro.addwetness == nil or waterypro.addwetness == 0 then
                    value_m = 20
                else
                    value_m = waterypro.addwetness
                end
                if item.components.finiteuses ~= nil then
                    value_m = value_m * item.components.finiteuses:GetUses() --普通水壶是+1000
                else
                    value_m = value_m * 10
                end
            end

            botanyctl:SetValue(value_m,
                item.components.fertilizer ~= nil and item.components.fertilizer.nutrients or nil,
                true
            )

            if item.components.fertilizer ~= nil then
                item.components.fertilizer:OnApplied(giver, inst) --删除以及特殊机制就在其中
                if item:IsValid() then
                    if
                        (
                            (item.components.finiteuses ~= nil and item.components.finiteuses:GetUses() > 0)
                            or (item.components.stackable ~= nil and item.components.stackable:StackSize() >= 1)
                        )
                        and AcceptTest(inst, item, giver)
                    then
                        OnAccept(inst, giver, item, times+1)
                    else
                        GiveItemBack(inst, giver, item)
                    end
                    giver.siv_ctl_traded = nil
                end
                return
            elseif item.components.finiteuses ~= nil then
                if item.prefab == "wateringcan" or item.prefab == "premiumwateringcan" then
                    item.components.finiteuses:Use(1000)
                else
                    item.components.finiteuses:Use(1)
                end
                if item:IsValid() then
                    if item.components.finiteuses:GetUses() > 0 and AcceptTest(inst, item, giver) then
                        OnAccept(inst, giver, item, times+1)
                    else
                        GiveItemBack(inst, giver, item)
                    end
                    giver.siv_ctl_traded = nil
                end
                return
            end
        end

        if item.components.stackable ~= nil then
            if item.components.stackable:StackSize() > times and AcceptTest(inst, item, giver) then
                OnAccept(inst, giver, item, times+1)
            else
                item.components.stackable:Get(times):Remove()
                if item:IsValid() then
                    GiveItemBack(inst, giver, item)
                end
            end
        else
            item:Remove()
        end
    end

    local function DoFunction(inst, doit)
        if inst.task_function ~= nil then
            inst.task_function:Cancel()
            inst.task_function = nil
        end
        if not doit then
            return
        end

        local time = 235 + math.random()*10
        inst.task_function = inst:DoPeriodicTask(time, function()
            if TheWorld.state.israining or TheWorld.state.issnowing then --下雨时补充水分
                inst.components.botanycontroller:SetValue(800, nil, true)
            end
            inst.components.botanycontroller:DoAreaFunction()
        end, math.random()*2)
    end

    table.insert(prefs, Prefab(
        basename,
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddMiniMapEntity()
            inst.entity:AddNetwork()

            inst:SetPhysicsRadiusOverride(.16)
            MakeObstaclePhysics(inst, inst.physicsradiusoverride)

            inst.MiniMapEntity:SetIcon(basename..".tex")

            inst.AnimState:SetBank(basename)
            inst.AnimState:SetBuild(basename)
            inst.AnimState:PlayAnimation("idle")

            inst:AddTag("structure")
            inst:AddTag("siving_ctl")

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
                    DoFunction(inst, false)
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
                DoFunction(inst, false)
                inst:Remove()
            end)

            inst:AddComponent("hauntable")
            inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)

            inst:AddComponent("trader")
            inst.components.trader:SetAcceptTest(AcceptTest)
            inst.components.trader.onaccept = OnAccept
            inst.components.trader.onrefuse = function(inst, giver, item)
                if giver ~= nil and giver.siv_ctl_traded ~= nil then
                    if giver.components.talker ~= nil then
                        giver.components.talker:Say(GetString(giver, "DESCRIBE", { string.upper(basename), giver.siv_ctl_traded }))
                    end
                    giver.siv_ctl_traded = nil
                end
            end
            inst.components.trader.deleteitemonaccept = false --收到物品不马上移除，根据具体物品决定
            inst.components.trader.acceptnontradable = true

            inst:AddComponent("botanycontroller")

            inst.task_function = nil
            inst:DoTaskInTime(0.1+math.random()*0.4, function()
                inst.components.botanycontroller:TriggerPlant(true)
                DoFunction(inst, true)
            end)

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
--[[ 子圭·利川 ]]
--------------------------------------------------------------------------

local function AddBar(inst, data)
    local fx = SpawnPrefab("siving_ctl_bar")
    if fx ~= nil then
        -- fx.Transform:SetNoFaced()

        fx.AnimState:SetBank(data.bank)
        fx.AnimState:SetBuild(data.build)
        -- fx.AnimState:PlayAnimation(data.anim)
        fx.AnimState:SetPercent(data.anim, 0)

        inst:AddChild(fx)
        fx.Follower:FollowSymbol(inst.GUID, "base", data.x, data.y, data.z)
        if data.scale ~= nil then
            fx.Transform:SetScale(data.scale, data.scale, data.scale)
        end

        inst[data.barkey] = fx
    end
end
local function SetBar(inst, barkey, anim, value, valuemax)
    if inst[barkey] ~= nil then
        if value <= 0 then
            inst[barkey].AnimState:SetPercent(anim, 0)
        elseif value < valuemax then
            inst[barkey].AnimState:SetPercent(anim, value/valuemax)
        else
            inst[barkey].AnimState:SetPercent(anim, 1)
        end
    end
end

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
    prefabs = { "siving_ctlwater_item", "siving_ctl_bar" },
    ctltype = 1,
    fn_server = function(inst)
        inst.components.botanycontroller.type = 1

        inst:WatchWorldState("israining", function(inst)
            inst.components.botanycontroller:SetValue(200, nil, true) --下雨/雪开始与结束时，直接恢复一定水分
        end)

        inst:DoTaskInTime(0, function()
            AddBar(inst, {
                barkey = "siv_bar",
                bank = "siving_ctlwater", build = "siving_ctlwater", anim = "bar",
                x = 0, y = -180, z = 0, scale = nil
            })
            inst.components.botanycontroller.onbarchange = function(botanyctl)
                SetBar(inst, "siv_bar", "bar", botanyctl.moisture, botanyctl.moisture_max)
            end

            inst:DoTaskInTime(0.5, function()
                inst.components.botanycontroller:onbarchange()
            end)
        end)
    end,
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
    prefabs = { "siving_ctldirt_item", "siving_ctl_bar" },
    ctltype = 2,
    fn_server = function(inst)
        inst.components.botanycontroller.type = 2

        inst:DoTaskInTime(0, function()
            AddBar(inst, {
                barkey = "siv_bar1",
                bank = "siving_ctldirt", build = "siving_ctldirt", anim = "bar1",
                x = -48, y = -140, z = 0, scale = nil
            })
            AddBar(inst, {
                barkey = "siv_bar2",
                bank = "siving_ctldirt", build = "siving_ctldirt", anim = "bar2",
                x = -5, y = -140, z = 0, scale = nil
            })
            AddBar(inst, {
                barkey = "siv_bar3",
                bank = "siving_ctldirt", build = "siving_ctldirt", anim = "bar3",
                x = 39, y = -140, z = 0, scale = nil
            })
            inst.components.botanycontroller.onbarchange = function(botanyctl)
                SetBar(inst, "siv_bar1", "bar1", botanyctl.nutrients[1], botanyctl.nutrient_max)
                SetBar(inst, "siv_bar2", "bar2", botanyctl.nutrients[2], botanyctl.nutrient_max)
                SetBar(inst, "siv_bar3", "bar3", botanyctl.nutrients[3], botanyctl.nutrient_max)
            end

            inst:DoTaskInTime(0.5, function()
                inst.components.botanycontroller:onbarchange()
            end)
        end)
    end,
})

--------------------------------------------------------------------------
--[[ 子圭·崇溟 ]]
--------------------------------------------------------------------------

--all

--------------------------------------------------------------------------
--[[ 状态栏 ]]
--------------------------------------------------------------------------

table.insert(prefs, Prefab(
    "siving_ctl_bar",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        inst.entity:AddFollower()

        -- inst.AnimState:SetBank("siving_ctldirt")
        -- inst.AnimState:SetBuild("siving_ctldirt")
        -- inst.AnimState:PlayAnimation("bar2")

        inst:AddTag("FX")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false

        return inst
    end,
    nil,
    nil
))

--------------------
--------------------

return unpack(prefs)
