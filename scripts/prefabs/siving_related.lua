local prefs = {}
local TOOLS_L = require("tools_legion")

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
    cutted_rosebush = { moisture = nil, nutrients = { 5, 5, 8 } },
    cutted_lilybush = { moisture = nil, nutrients = { 5, 5, 8 } },
    cutted_orchidbush = { moisture = nil, nutrients = { 5, 5, 8 } },
    cutted_lumpyevergreen = { moisture = nil, nutrients = { 8, nil, nil } },
    sachet = { moisture = nil, nutrients = { 8, 8, 8 } },
    rosorns = { moisture = nil, nutrients = { 12, 12, 48 } },
    lileaves = { moisture = nil, nutrients = { 12, 48, 12 } },
    orchitwigs = { moisture = nil, nutrients = { 48, 12, 12 } },
    lance_carrot_l = { moisture = nil, nutrients = { 24, 24, 24 } },
    tissue_l_cactus = { moisture = nil, nutrients = { 8, nil, 8 } },
    tissue_l_lureplant = { moisture = nil, nutrients = { 8, nil, 8 } },
    tissue_l_berries = { moisture = nil, nutrients = { 8, nil, 8 } },
    tissue_l_lightbulb = { moisture = nil, nutrients = { 8, nil, 8 } },

    --【猥琐联盟】
    weisuo_coppery_kela = { moisture = nil, nutrients = { 2, 2, 2 } },
    weisuo_silvery_kela = { moisture = nil, nutrients = { 20, 20, 20 } },
    weisuo_golden_kela = { moisture = nil, nutrients = { 80, 80, 80 } },
}
local PLACER_SCALE_CTL = 1.79 --这个大小就是20半径的

local function OnEnableHelper_ctl(inst, enabled)
    if enabled then
        if inst.helper == nil then
            inst.helper = CreateEntity()

            --[[Non-networked entity]]
            inst.helper.entity:SetCanSleep(false)
            inst.helper.persists = false

            inst.helper.entity:AddTransform()
            inst.helper.entity:AddAnimState()

            inst.helper:AddTag("CLASSIFIED")
            inst.helper:AddTag("NOCLICK")
            inst.helper:AddTag("placer")

            inst.helper.Transform:SetScale(PLACER_SCALE_CTL, PLACER_SCALE_CTL, PLACER_SCALE_CTL)

            inst.helper.AnimState:SetBank("firefighter_placement")
            inst.helper.AnimState:SetBuild("firefighter_placement")
            inst.helper.AnimState:PlayAnimation("idle")
            inst.helper.AnimState:SetLightOverride(1)
            inst.helper.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
            inst.helper.AnimState:SetLayer(LAYER_BACKGROUND)
            inst.helper.AnimState:SetSortOrder(1)
            inst.helper.AnimState:SetAddColour(0, .5, .5, 0)

            inst.helper.entity:SetParent(inst.entity)
        end
    elseif inst.helper ~= nil then
        inst.helper:Remove()
        inst.helper = nil
    end
end
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
local function AcceptTest_ctl(inst, item, giver)
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
local function OnAccept_ctl(inst, giver, item, times)
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
                    and AcceptTest_ctl(inst, item, giver)
                then
                    OnAccept_ctl(inst, giver, item, times+1)
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
                if item.components.finiteuses:GetUses() > 0 and AcceptTest_ctl(inst, item, giver) then
                    OnAccept_ctl(inst, giver, item, times+1)
                else
                    GiveItemBack(inst, giver, item)
                end
                giver.siv_ctl_traded = nil
            end
            return
        end
    end

    if item.components.stackable ~= nil then
        if item.components.stackable:StackSize() > times and AcceptTest_ctl(inst, item, giver) then
            OnAccept_ctl(inst, giver, item, times+1)
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
local function OnRefuse_ctl(inst, giver, item)
    if giver ~= nil and giver.siv_ctl_traded ~= nil then
        if giver.components.talker ~= nil then
            giver.components.talker:Say(GetString(giver, "DESCRIBE", { string.upper(inst.prefab), giver.siv_ctl_traded }))
        end
        giver.siv_ctl_traded = nil
    end
end
local function DoFunction_ctl(inst, doit)
    if inst.task_function ~= nil then
        inst.task_function:Cancel()
        inst.task_function = nil
    end
    if not doit then
        return
    end

    local time = 210 + math.random()*10
    inst.task_function = inst:DoPeriodicTask(time, function()
        if TheWorld.state.israining or TheWorld.state.issnowing then --下雨时补充水分
            inst.components.botanycontroller:SetValue(800, nil, true)
        end
        inst.components.botanycontroller:DoAreaFunction()
    end, math.random()*3)
end

local function TryAddBar(inst)
    for barkey, data in pairs(inst._dd) do
        local fx = inst[barkey]
        if fx == nil then
            fx = SpawnPrefab("siving_ctl_bar")
            inst:AddChild(fx)
            inst[barkey] = fx
        end
        -- fx.Transform:SetNoFaced()
        fx.AnimState:SetBank(data.bank)
        fx.AnimState:SetBuild(data.build)
        -- fx.AnimState:PlayAnimation(data.anim)
        fx.AnimState:SetPercent(data.anim, 0)
        fx.Follower:FollowSymbol(inst.GUID, data.followedsymbol or "base", data.x, data.y, data.z)
        if data.scale ~= nil then
            fx.Transform:SetScale(data.scale, data.scale, data.scale)
        end
        fx.components.highlightchild:SetOwner(inst)
    end
end
local function SetBar(inst, barkey, value, valuemax)
    if inst[barkey] ~= nil then
        if value <= 0 then
            inst[barkey].AnimState:SetPercent(inst._dd[barkey].anim, 0)
        elseif value < valuemax then
            inst[barkey].AnimState:SetPercent(inst._dd[barkey].anim, value/valuemax)
        else
            inst[barkey].AnimState:SetPercent(inst._dd[barkey].anim, 1)
        end
    end
end
local function UpdateBars(inst)
    if inst.components.botanycontroller.onbarchange ~= nil then
        TryAddBar(inst)
        inst.components.botanycontroller:onbarchange()
    end
end
local function OnBarChange_ctlwater(ctl)
    SetBar(ctl.inst, "siv_bar", ctl.moisture, ctl.moisture_max)
end
local function OnBarChange_ctldirt(ctl)
    SetBar(ctl.inst, "siv_bar1", ctl.nutrients[1], ctl.nutrient_max)
    SetBar(ctl.inst, "siv_bar2", ctl.nutrients[2], ctl.nutrient_max)
    SetBar(ctl.inst, "siv_bar3", ctl.nutrients[3], ctl.nutrient_max)
end
local function OnBarChange_ctlall(ctl)
    SetBar(ctl.inst, "siv_bar1", ctl.nutrients[1], ctl.nutrient_max)
    SetBar(ctl.inst, "siv_bar2", ctl.nutrients[2], ctl.nutrient_max)
    SetBar(ctl.inst, "siv_bar3", ctl.nutrients[3], ctl.nutrient_max)
    SetBar(ctl.inst, "siv_bar4", ctl.moisture, ctl.moisture_max)
end

local function SetData_ctlitem(inst, moi, nut)
    if inst.ctltype_l ~= 2 then --含水量
        if moi ~= nil then
            inst.siv_moisture = moi
        end
    end
    if inst.ctltype_l ~= 1 then --肥料值
        if nut ~= nil then
            inst.siv_nutrients = nut
        end
    end
end
local function OnSave_ctlitem(inst, data)
    if inst.siv_moisture ~= nil then
        data.siv_moisture = inst.siv_moisture
    end
    if inst.siv_nutrients ~= nil then
        data.siv_nutrients = inst.siv_nutrients
    end
end
local function OnLoad_ctlitem(inst, data)
    if data ~= nil then
        SetData_ctlitem(inst, data.siv_moisture, data.siv_nutrients)
    end
end
local function Fn_dealdata_sivctl(inst, data)
    local dd = {}
    if inst.ctltype_l ~= 1 then
        dd.n1 = tostring(data.n1 or 0)
        dd.n2 = tostring(data.n2 or 0)
        dd.n3 = tostring(data.n3 or 0)
        dd.nmax = inst.ctltype_l == 3 and "2400" or "800"
    end
    if inst.ctltype_l ~= 2 then
        dd.mo = tostring(data.mo or 0)
        dd.momax = inst.ctltype_l == 3 and "6000" or "2000"
    end
    return subfmt(STRINGS.NAMEDETAIL_L.SIVCTL[inst.ctltype_l], dd)
end
local function Fn_getdata_sivctl(inst)
    local data = {}
    if inst.ctltype_l ~= 1 and inst.siv_nutrients ~= nil then
        if inst.siv_nutrients[1] ~= 0 then
            data.n1 = TOOLS_L.ODPoint(inst.siv_nutrients[1], 10)
        end
        if inst.siv_nutrients[2] ~= 0 then
            data.n2 = TOOLS_L.ODPoint(inst.siv_nutrients[2], 10)
        end
        if inst.siv_nutrients[3] ~= 0 then
            data.n3 = TOOLS_L.ODPoint(inst.siv_nutrients[3], 10)
        end
    end
    if inst.ctltype_l ~= 2 and inst.siv_moisture ~= 0 then
        data.mo = TOOLS_L.ODPoint(inst.siv_moisture, 10)
    end
    return data
end
local function Fn_getdata_sivctlcon(inst)
    local data = {}
    local bc = inst.components.botanycontroller
    if inst.ctltype_l ~= 1 and bc.nutrients ~= nil then
        if bc.nutrients[1] ~= 0 then
            data.n1 = TOOLS_L.ODPoint(bc.nutrients[1], 10)
        end
        if bc.nutrients[2] ~= 0 then
            data.n2 = TOOLS_L.ODPoint(bc.nutrients[2], 10)
        end
        if bc.nutrients[3] ~= 0 then
            data.n3 = TOOLS_L.ODPoint(bc.nutrients[3], 10)
        end
    end
    if inst.ctltype_l ~= 2 and bc.moisture ~= 0 then
        data.mo = TOOLS_L.ODPoint(bc.moisture, 10)
    end
    return data
end

local function MakeItem(data)
    local basename = "siving_ctl"..data.name
    table.insert(prefs, Prefab(basename.."_item", function()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank(basename)
        inst.AnimState:SetBuild(basename)
        inst.AnimState:PlayAnimation("item")

        inst:AddTag("eyeturret") --眼球塔的专属标签，但为了deployable组件的摆放名字而使用（显示为“放置”）

        LS_C_Init(inst, basename.."_item", false)

        inst.ctltype_l = data.ctltype
        TOOLS_L.InitMouseInfo(inst, Fn_dealdata_sivctl, Fn_getdata_sivctl, 3)

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        inst.siv_moisture = nil
        inst.siv_nutrients = nil

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = basename.."_item"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..basename.."_item.xml"
        inst.components.inventoryitem:SetSinks(true)

        inst:AddComponent("deployable")
        inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)
        inst.components.deployable.ondeploy = function(inst, pt, deployer, rot)
            local tree
            local skin = inst.components.skinedlegion:GetSkin()
            if skin == nil then
                tree = SpawnPrefab(basename)
            else
                tree = SpawnPrefab(basename, skin, nil, LS_C_UserID(inst, deployer))
            end
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

        inst.OnSave = OnSave_ctlitem
        inst.OnLoad = OnLoad_ctlitem

        return inst
    end, data.assets, data.prefabs))
end
local function MakeConstruct(data)
    local basename = "siving_ctl"..data.name
    table.insert(prefs, Prefab(basename, function()
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

        --Dedicated server does not need deployhelper
        if not TheNet:IsDedicated() then
            inst:AddComponent("deployhelper")
            inst.components.deployhelper.onenablehelper = OnEnableHelper_ctl
        end

        LS_C_Init(inst, basename.."_item", false, "data_build", basename)

        inst.ctltype_l = data.ctltype
        TOOLS_L.InitMouseInfo(inst, Fn_dealdata_sivctl, Fn_getdata_sivctlcon, 1)

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        inst.UpdateBars_l = UpdateBars

        inst:AddComponent("inspectable")

        inst:AddComponent("portablestructure")
        inst.components.portablestructure:SetOnDismantleFn(function(inst, doer)
            local item
            local skin = inst.components.skinedlegion:GetSkin()
            if skin == nil then
                item = SpawnPrefab(basename.."_item")
            else
                item = SpawnPrefab(basename.."_item", skin, nil, LS_C_UserID(inst, doer))
            end
            if item ~= nil then
                SetData_ctlitem(item,
                    inst.components.botanycontroller.moisture, inst.components.botanycontroller.nutrients)
                if doer ~= nil and doer.components.inventory ~= nil then
                    doer.components.inventory:GiveItem(item)
                    if doer.SoundEmitter ~= nil then
                        doer.SoundEmitter:PlaySound("dontstarve/common/together/succulent_craft")
                    end
                else
                    item.Transform:SetPosition(inst.Transform:GetWorldPosition())
                end
                inst.components.botanycontroller:TriggerPlant(false)
                DoFunction_ctl(inst, false)
                inst:Remove()
            end
        end)

        inst:AddComponent("hauntable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)

        inst:AddComponent("trader")
        inst.components.trader:SetAcceptTest(AcceptTest_ctl)
        inst.components.trader.onaccept = OnAccept_ctl
        inst.components.trader.onrefuse = OnRefuse_ctl
        inst.components.trader.deleteitemonaccept = false --收到物品不马上移除，根据具体物品决定
        inst.components.trader.acceptnontradable = true

        inst:AddComponent("botanycontroller")
        inst.components.botanycontroller.type = data.ctltype

        -- inst.task_function = nil
        inst:DoTaskInTime(0.2+math.random()*0.4, function(inst)
            if data.ctltype == 3 then
                inst.components.botanycontroller.onbarchange = OnBarChange_ctlall
            elseif data.ctltype == 2 then
                inst.components.botanycontroller.onbarchange = OnBarChange_ctldirt
            else
                inst.components.botanycontroller.onbarchange = OnBarChange_ctlwater
            end
            UpdateBars(inst)
            inst.components.botanycontroller:TriggerPlant(true)
            DoFunction_ctl(inst, true)
        end)

        if data.fn_server ~= nil then
            data.fn_server(inst)
        end

        return inst
    end, data.assets, data.prefabs))
end

--------------------------------------------------------------------------
--[[ 子圭·利川 ]]
--------------------------------------------------------------------------

local dd_siving_ctlwater = {
    siv_bar = {
        x = 0, y = -180, z = 0, scale = nil,
        bank = "siving_ctlwater", build = "siving_ctlwater", anim = "bar"
    }
}
local function OnRain_ctlwater(inst)
    inst.components.botanycontroller:SetValue(200, nil, true) --下雨/雪开始与结束时，直接恢复一定水分
end

MakeItem({
    name = "water",
    assets = {
        Asset("ANIM", "anim/siving_ctlwater.zip"),
        Asset("ATLAS", "images/inventoryimages/siving_ctlwater_item.xml"),
        Asset("IMAGE", "images/inventoryimages/siving_ctlwater_item.tex"),
        Asset("ATLAS_BUILD", "images/inventoryimages/siving_ctlwater_item.xml", 256),
        Asset("ANIM", "anim/firefighter_placement.zip") --灭火器的placer圈
    },
    prefabs = { "siving_ctlwater" },
    sound = "dontstarve/common/rain_meter_craft",
    ctltype = 1
})
MakeConstruct({
    name = "water",
    assets = {
        Asset("ANIM", "anim/siving_ctlwater.zip"),
        Asset("ANIM", "anim/firefighter_placement.zip") --灭火器的placer圈
    },
    prefabs = { "siving_ctlwater_item", "siving_ctl_bar" },
    ctltype = 1,
    fn_server = function(inst)
        inst._dd = dd_siving_ctlwater
        inst:WatchWorldState("israining", OnRain_ctlwater)
    end
})

--------------------------------------------------------------------------
--[[ 子圭·益矩 ]]
--------------------------------------------------------------------------

local dd_siving_ctldirt = {
    siv_bar1 = {
        x = -48, y = -140, z = 0, scale = nil,
        bank = "siving_ctldirt", build = "siving_ctldirt", anim = "bar1"
    },
    siv_bar2 = {
        x = -5, y = -140, z = 0, scale = nil,
        bank = "siving_ctldirt", build = "siving_ctldirt", anim = "bar2"
    },
    siv_bar3 = {
        x = 39, y = -140, z = 0, scale = nil,
        bank = "siving_ctldirt", build = "siving_ctldirt", anim = "bar3"
    }
}

MakeItem({
    name = "dirt",
    assets = {
        Asset("ANIM", "anim/siving_ctldirt.zip"),
        Asset("ATLAS", "images/inventoryimages/siving_ctldirt_item.xml"),
        Asset("IMAGE", "images/inventoryimages/siving_ctldirt_item.tex"),
        Asset("ATLAS_BUILD", "images/inventoryimages/siving_ctldirt_item.xml", 256),
        Asset("ANIM", "anim/firefighter_placement.zip") --灭火器的placer圈
    },
    prefabs = { "siving_ctldirt" },
    sound = "dontstarve/common/winter_meter_craft",
    ctltype = 2
})
MakeConstruct({
    name = "dirt",
    assets = {
        Asset("ANIM", "anim/siving_ctldirt.zip"),
        Asset("ANIM", "anim/firefighter_placement.zip") --灭火器的placer圈
    },
    prefabs = { "siving_ctldirt_item", "siving_ctl_bar" },
    ctltype = 2,
    fn_server = function(inst)
        inst._dd = dd_siving_ctldirt
    end
})

--------------------------------------------------------------------------
--[[ 子圭·崇溟 ]]
--------------------------------------------------------------------------

local dd_siving_ctlall = {
    siv_bar1 = {
        x = -53, y = -335, z = 0, scale = nil,
        bank = "siving_ctldirt", build = "siving_ctldirt", anim = "bar1"
    },
    siv_bar2 = {
        x = -10, y = -360, z = 0, scale = nil,
        bank = "siving_ctldirt", build = "siving_ctldirt", anim = "bar2"
    },
    siv_bar3 = {
        x = 34, y = -335, z = 0, scale = nil,
        bank = "siving_ctldirt", build = "siving_ctldirt", anim = "bar3"
    },
    siv_bar4 = {
        x = -10, y = -297, z = 0, scale = nil,
        bank = "siving_ctlwater", build = "siving_ctlwater", anim = "bar"
    }
}

MakeItem({
    name = "all",
    assets = {
        Asset("ANIM", "anim/siving_ctlall.zip"),
        Asset("ATLAS", "images/inventoryimages/siving_ctlall_item.xml"),
        Asset("IMAGE", "images/inventoryimages/siving_ctlall_item.tex"),
        Asset("ATLAS_BUILD", "images/inventoryimages/siving_ctlall_item.xml", 256),
        Asset("ANIM", "anim/firefighter_placement.zip") --灭火器的placer圈
    },
    prefabs = { "siving_ctlall" },
    sound = "dontstarve/halloween_2018/madscience_machine/place",
    ctltype = 3
})
MakeConstruct({
    name = "all",
    assets = {
        Asset("ANIM", "anim/siving_ctlall.zip"),
        Asset("ANIM", "anim/siving_ctlwater.zip"),
        Asset("ANIM", "anim/siving_ctldirt.zip"),
        Asset("ANIM", "anim/firefighter_placement.zip") --灭火器的placer圈
    },
    prefabs = { "siving_ctlall_item", "siving_ctl_bar" },
    ctltype = 3,
    fn_server = function(inst)
        inst.components.botanycontroller.moisture_max = 6000
        inst.components.botanycontroller.nutrient_max = 2400
        inst._dd = dd_siving_ctlall
        inst:WatchWorldState("israining", OnRain_ctlwater)
    end
})

--------------------------------------------------------------------------
--[[ 状态栏 ]]
--------------------------------------------------------------------------

table.insert(prefs, Prefab("siving_ctl_bar", function()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddFollower()

    -- inst.AnimState:SetBank("siving_ctldirt")
    -- inst.AnimState:SetBuild("siving_ctldirt")
    -- inst.AnimState:PlayAnimation("bar2")
    inst.AnimState:SetFinalOffset(3)

    inst:AddComponent("highlightchild")

    inst:AddTag("FX")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    inst.persists = false

    return inst
end, nil, nil))

--------------------------------------------------------------------------
--[[ 子圭·育 ]]
--------------------------------------------------------------------------

local function GetStatus_turn(inst)
    local cpt = inst.components.genetrans
    return (cpt == nil and "GENERIC")
        or (cpt.fruitnum > 0 and "DONE")
        or (cpt.energynum <= 0 and "NOENERGY")
        or (cpt.seed and "DOING")
        or "GENERIC"
end
local function OnWork_turn(inst, worker, workleft, numworks)
    local cpt = inst.components.genetrans
    if cpt.seed ~= nil then --还有东西在上面
        inst.components.workable:SetWorkLeft(5)
        if inst.worked_l then --说明已经敲过一次，这一次该掉落了
            inst.worked_l = nil
            cpt:ClearAll()
        else
            inst.worked_l = true
        end
    else
        inst.worked_l = nil
    end
    if cpt.energynum > 0 and cpt.seed ~= nil then
        inst.AnimState:PlayAnimation("hit_on")
        inst.AnimState:PushAnimation("on", true)
    else
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle", false)
    end
end
local function OnBroken_turn(inst, needrecipe)
    inst.components.genetrans:DropLoot(needrecipe)
    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("rock")
    inst:Remove()
end
local function OnFinished_turn(inst)
    OnBroken_turn(inst, true)
end
local function OnDeconstruct_turn(inst, worker)
    OnBroken_turn(inst, false) --拆解机制自带建造材料的还原，所以这里不再还原材料
end
local function Fn_dealdata_turn(inst, data)
    local dd = {
        e = tostring(data.e or 0), emax = tostring(data.emax or 500),
    }
    if data.ft == -1 then
        dd.ft = "∞"
    else
        dd.ft = tostring(data.ft or 0)
    end
    if data.s ~= nil then
        dd.s = STRINGS.NAMES[string.upper(data.s)] or data.s
        dd.n1 = tostring(data.n1 or 0)
        dd.n2 = tostring(data.n2 or 0)
        dd.mt = tostring(data.mt or 100)
        dd.gr = tostring(data.gr or 0)
        dd.grmax = tostring(data.grmax or 0)
        return subfmt(STRINGS.NAMEDETAIL_L.GENETRANS1, dd)
    else
        return subfmt(STRINGS.NAMEDETAIL_L.GENETRANS2, dd)
    end
end
local function Fn_getdata_turn(inst)
    local data = {}
    local cpt = inst.components.genetrans
    if cpt.energynum ~= 0 then
        data.e = TOOLS_L.ODPoint(cpt.energynum, 10)
    end
    if cpt.energynum_max ~= 500 then
        data.emax = cpt.energynum_max
    end
    if cpt.seed ~= nil then
        data.s = cpt.seed
        if cpt.seednum > 0 then
            data.n1 = cpt.seednum
        end
        if cpt.fruitnum > 0 then
            data.n2 = cpt.fruitnum
        end
        if cpt.pause_reason ~= nil or cpt.time_mult == nil or cpt.time_mult <= 0 then
            data.mt = 0
        elseif cpt.time_mult ~= 1 then
            data.mt = math.floor(cpt.time_mult*100)
        end
        if cpt.time_grow ~= nil and cpt.time_grow > 0 then
            data.gr = TOOLS_L.ODPoint(cpt.time_grow/TUNING.TOTAL_DAY_TIME, 100)
        end
        if cpt.time_all ~= nil and cpt.time_all > 0 then
            data.grmax = TOOLS_L.ODPoint(cpt.time_all/TUNING.TOTAL_DAY_TIME, 100)
        end
    end
    if cpt.fast_reason ~= nil then
        local ft = 0
        for k, v in pairs(cpt.fast_reason) do
            if v.mult ~= nil and v.mult > 0 then
                if v.time == nil then
                    ft = -1
                    break
                else
                    if v.time > ft then
                        ft = v.time
                    end
                end
            end
        end
        if ft ~= 0 then
            data.ft = ft
        end
    end
    return data
end

table.insert(prefs, Prefab("siving_turn", function()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .15)

    inst.MiniMapEntity:SetIcon("siving_turn.tex")

    inst.Light:Enable(false)
    inst.Light:SetRadius(2)
    inst.Light:SetFalloff(1.5)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(35/255, 167/255, 172/255)

    inst.AnimState:SetBank("siving_turn")
    inst.AnimState:SetBuild("siving_turn")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("structure")
    inst:AddTag("genetrans")

    LS_C_Init(inst, "siving_turn", false)

    TOOLS_L.InitMouseInfo(inst, Fn_dealdata_turn, Fn_getdata_turn, 3.5)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    -- inst.worked_l = nil

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus_turn

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    inst:AddComponent("lootdropper")

    inst:AddComponent("genetrans") --实在不想做无谓的代码优化了，所以该组件与该实体的耦合性特别特别高

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(5)
    inst.components.workable:SetOnWorkCallback(OnWork_turn)
    inst.components.workable:SetOnFinishCallback(OnFinished_turn)

    inst:ListenForEvent("ondeconstructstructure", OnDeconstruct_turn)

    return inst
end, { Asset("ANIM", "anim/siving_turn.zip") }, { "siving_turn_fruit" }))

--------------------------------------------------------------------------
--[[ 子圭·育之果 ]]
--------------------------------------------------------------------------

table.insert(prefs, Prefab("siving_turn_fruit", function()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddFollower()

    inst.AnimState:SetBank("siving_turn")
    inst.AnimState:SetBuild("siving_turn")
    inst.AnimState:SetPercent("fruit", 0)
    inst.AnimState:SetFinalOffset(3)

    inst:AddComponent("highlightchild")

    inst:AddTag("FX")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    inst.persists = false

    return inst
end, nil, nil))

--------------------------------------------------------------------------
--[[ 子圭护甲的反伤特效 ]]
--------------------------------------------------------------------------

local function DoFxCounterAtk(inst)
    inst.task_atk = nil
    if not inst.armor:IsValid() or inst.armor.components.armor == nil then
        inst.armor = nil
    end
    if not inst.owner:IsValid() or inst.owner.components.combat == nil then
        inst.owner = nil
    end
    if inst.attacker ~= nil and not inst.attacker:IsValid() then
        inst.attacker = nil
    end

    local tags_cant
    local validfn
    if TheNet:GetPVPEnabled() then
        tags_cant = TOOLS_L.TagsCombat3()
        validfn = inst.mode == 1 and TOOLS_L.MaybeEnemy_me or TOOLS_L.IsEnemy_me
    else
        tags_cant = TOOLS_L.TagsCombat3({ "player" })
        validfn = inst.mode == 1 and TOOLS_L.MaybeEnemy_player or TOOLS_L.IsEnemy_player
    end
    local data = {}
    local hasattacker = false
    local dmg, spdmg, stimuli
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, inst.range+3, { "_combat" }, tags_cant)
    for _, ent in ipairs(ents) do
        if ent ~= inst.owner and ent:IsValid() and ent.entity:IsVisible() then
            tags_cant = inst.range + ent:GetPhysicsRadius(0)
            if
                ent:GetDistanceSqToPoint(x, y, z) < tags_cant * tags_cant --这里的距离算上了生物的体积半径
                and validfn(inst.owner, ent, true)
            then
                if inst.owner ~= nil then
                    if inst.owner.components.combat:CanTarget(ent) then
                        dmg, spdmg, stimuli = TOOLS_L.CalcDamage(inst.owner, ent, nil, nil, nil, inst.damage, nil, false)
                        table.insert(data, { target = ent, dmg = dmg, spdmg = spdmg, stimuli = stimuli })
                        if not hasattacker and ent == inst.attacker then
                            hasattacker = true
                        end
                    end
                elseif ent.components.combat:CanBeAttacked() then
                    table.insert(data, { target = ent, dmg = inst.damage })
                    if not hasattacker and ent == inst.attacker then
                        hasattacker = true
                    end
                end
            end
        end
    end

    dmg = #data
    if hasattacker then --去掉攻击者
        dmg = dmg - 1
    end
    if dmg > 0 then --计算所受伤害系数
        stimuli = math.max(1 - dmg/10, 0.1)
    else
        stimuli = 1
    end
    --先进行攻击
    for _, v in ipairs(data) do
        if v.target ~= inst.attacker then
            v.dmg = v.dmg * stimuli
        end
        v.target.components.combat:GetAttacked(inst.armor, v.dmg, nil, v.stimuli, v.spdmg)
    end
    --后计算护甲消耗，因为怕有反伤怪
    if (hasattacker or dmg > 0) and inst.armor ~= nil then --有反伤对象，则扣除护甲耐久
        --由于有耐久损耗系数存在，护甲耐久就不会为0，所以设置一个最小消耗值来强制让护甲值变0
        stimuli = math.max(10, inst.damage*inst.armorcostmult)
        inst.armor.components.armor:SetCondition(inst.armor.components.armor.condition - stimuli)
    end

    if inst:IsAsleep() then
        inst:Remove()
    end
end
local function InitCounterAtk(inst, owner, armor, attacker)
    local poser = owner
    local health = 0
    local condition = armor.components.armor.condition

    inst.armor = armor
    inst.owner = owner
    inst.armorcostmult = armor.armorcostmult_l or 1
    if armor.prefab == "siving_suit_gold" then
        inst.range = 4
    end
    if armor.components.modelegion ~= nil then
        inst.mode = armor.components.modelegion.now
        if inst.mode == 3 then
            inst:Remove()
            return
        end
    end
    if attacker ~= nil and attacker:IsValid() then
        poser = attacker
        if attacker.components.health ~= nil and not attacker.components.health:IsDead() then
            health = attacker.components.health.currenthealth
            inst.attacker = attacker
        end
    end
    inst.damage = armor.counteratkmax_l or 80
    health = math.max(health, condition)
    if health < inst.damage and health > 0 then
        inst.damage = health
    end
    inst.Transform:SetPosition(poser.Transform:GetWorldPosition())
    inst.task_atk = inst:DoTaskInTime(0, DoFxCounterAtk)
end
local function MakeSuitAtkFx(data)
    table.insert(prefs, Prefab(data.name, function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst:AddTag("FX")

        if data.fn_common ~= nil then
            data.fn_common(inst)
        end

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        inst.persists = false

        inst.damage = 80
        inst.range = 3
        inst.armorcostmult = 1
        inst.mode = 1
        -- inst.armor = nil
        -- inst.owner = nil
        -- inst.attacker = nil
        -- inst.task_atk = nil
        inst.InitCounterAtk = InitCounterAtk

        inst:ListenForEvent("animover", inst.Remove)

        if data.fn_server ~= nil then
            data.fn_server(inst)
        end

        return inst
    end, data.assets, nil))
end

local function SetSuitAtkFxAnim_server(inst)
    if math.random() < 0.5 then
        inst.AnimState:PlayAnimation("idle")
    else
        inst.AnimState:PlayAnimation("trap")
        inst.AnimState:SetScale(1.3, 1.3)
    end
end

MakeSuitAtkFx({
    name = "sivsuitatk_fx",
    assets = {
        Asset("ANIM", "anim/bramblefx.zip"),
        Asset("ANIM", "anim/sivsuitatk_fx.zip")
    },
    fn_common = function(inst)
        inst.Transform:SetFourFaced()

        inst.AnimState:SetBank("bramblefx")
        inst.AnimState:SetBuild("sivsuitatk_fx")
        inst.AnimState:SetFinalOffset(3)
        inst.AnimState:SetSymbolBloom("needle01")
        inst.AnimState:SetSymbolLightOverride("needle01", .5)
        inst.AnimState:SetLightOverride(.1)
    end,
    fn_server = SetSuitAtkFxAnim_server
})
MakeSuitAtkFx({
    name = "sivsuitatk_fx_marble",
    assets = {
        Asset("ANIM", "anim/bramblefx.zip"),
        Asset("ANIM", "anim/skin/sivsuitatk_fx_marble.zip")
    },
    fn_common = function(inst)
        inst.Transform:SetFourFaced()

        inst.AnimState:SetBank("bramblefx")
        inst.AnimState:SetBuild("sivsuitatk_fx_marble")
        inst.AnimState:SetFinalOffset(3)
        inst.AnimState:SetMultColour(255/255, 255/255, 153/255, 1)
        inst.AnimState:SetSymbolBloom("needle01")
        inst.AnimState:SetSymbolLightOverride("needle01", .5)
        inst.AnimState:SetLightOverride(.1)
    end,
    fn_server = SetSuitAtkFxAnim_server
})

--------------------------------------------------------------------------
--[[ 子圭·垄 ]]
--------------------------------------------------------------------------

local function OnDeploy_soilitem(inst, pt, deployer, rot)
    local tree
    local skin = inst.components.skinedlegion:GetSkin()
    if skin == nil then
        tree = SpawnPrefab("siving_soil")
    else
        tree = SpawnPrefab("siving_soil", skin, nil, LS_C_UserID(inst, deployer))
    end
    if tree ~= nil then
        tree.Transform:SetPosition(pt:Get())
        inst.components.stackable:Get():Remove()
        if deployer ~= nil and deployer.SoundEmitter ~= nil then
            deployer.SoundEmitter:PlaySound("dontstarve/wilson/plant_seeds")
        end
    end
end
table.insert(prefs, Prefab("siving_soil_item", function() ------子圭垄(物品)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("siving_soil")
    inst.AnimState:SetBuild("siving_soil")
    inst.AnimState:PlayAnimation("item")

    inst:AddTag("molebait")
    inst:AddTag("eyeturret") --眼球塔的专属标签，但为了deployable组件的摆放名字而使用（显示为“放置”）

    LS_C_Init(inst, "siving_soil_item", false)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("tradable")
    inst.components.tradable.rocktribute = 18 --延缓 0.33x18 天地震
    inst.components.tradable.goldvalue = 15 --换1个砂之石或15金块

    inst:AddComponent("bait")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "siving_soil_item"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/siving_soil_item.xml"
    inst.components.inventoryitem:SetSinks(true)

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = OnDeploy_soilitem
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.LESS)

    MakeHauntableLaunchAndIgnite(inst)

    return inst
end, {
    Asset("ANIM", "anim/farm_soil.zip"), --官方栽培土动画模板（为了placer加载的）
    Asset("ANIM", "anim/siving_soil.zip"),
    Asset("ATLAS", "images/inventoryimages/siving_soil_item.xml"),
    Asset("IMAGE", "images/inventoryimages/siving_soil_item.tex"),
    Asset("ATLAS_BUILD", "images/inventoryimages/siving_soil_item.xml", 256)
}, { "siving_soil" }))

local function OnFinished_soil(inst, worker)
    local skin = inst.components.skinedlegion:GetSkin()
    if skin == nil then
        inst.components.lootdropper:SpawnLootPrefab("siving_soil_item")
    else
        inst.components.lootdropper:SpawnLootPrefab("siving_soil_item", nil, skin, nil, LS_C_UserID(inst, worker))
    end
    inst:Remove()
end
table.insert(prefs, Prefab("siving_soil", function() ------子圭垄
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("farm_soil")
    inst.AnimState:SetBuild("siving_soil")
    -- inst.AnimState:PlayAnimation("till_idle")

    inst:SetPhysicsRadiusOverride(TUNING.FARM_PLANT_PHYSICS_RADIUS)

    inst:AddTag("soil_legion")
    inst:AddTag("tornado_nosucky") --mod兼容：永不妥协。不会被龙卷风刮走

    LS_C_Init(inst, "siving_soil_item", false, "data_soil", "siving_soil")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    inst:DoTaskInTime(0, function()
        inst.AnimState:PlayAnimation("till_rise")
        inst.AnimState:PushAnimation("till_idle", false)
    end)

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(OnFinished_soil)

    MakeHauntableWork(inst)

    return inst
end, {
    Asset("ANIM", "anim/farm_soil.zip"), --官方栽培土动画模板
    Asset("ANIM", "anim/siving_soil.zip")
}, { "siving_soil_item" }))

--------------------------------------------------------------------------
--[[ 子圭·系 ]]
--------------------------------------------------------------------------

local dapperness_opener = 100/(TUNING.DAY_TIME_DEFAULT*2)
local function CP_Open_opener(self, doer, ...)
    self.Open_l(self, doer, ...)
    if
        doer ~= nil and doer.task_boxopener2_l == nil and
        self.master.components.container:IsOpenedBy(doer)
    then
        local openpos = doer:GetPosition()
        doer.task_boxopener2_l = doer:DoPeriodicTask(0.5, function(doer)
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
local function CP_OnClose_opener(self, doer, ...)
    self.OnClose_l(self, doer, ...)
    if doer ~= nil then
        if doer.task_boxopener2_l ~= nil then
            doer.task_boxopener2_l:Cancel()
            doer.task_boxopener2_l = nil
            if doer.SoundEmitter then
                doer.SoundEmitter:PlaySound("maxwell_rework/magician_chest/close", nil, 0.7)
            end
        end
    end
end
local function OnLoadPostPass_opener(inst) --世界启动时，向世界容器注册自己
	if TheWorld.components.boxcloudpine ~= nil then
		TheWorld.components.boxcloudpine.openers[inst] = true
	end
end
local function UpdateSanityHelper_opener(owner)
    if owner.components.sanity ~= nil then
        local bonus = dapperness_opener
        if owner.components.sanity:IsLunacyMode() then
            bonus = -bonus
        end
        owner.components.sanity.externalmodifiers:SetModifier("sanityhelper_l", bonus, "boxopener_l")
    end
end
local function SetFunction_opener(owner, isadd)
    if isadd then
        owner:ListenForEvent("sanitymodechanged", UpdateSanityHelper_opener)
        UpdateSanityHelper_opener(owner)
        TOOLS_L.AddEntValue(owner, "siv_blood_l_reducer", "siving_boxopener", 1, 0.25)
    else
        owner:RemoveEventCallback("sanitymodechanged", UpdateSanityHelper_opener)
        if owner.components.sanity ~= nil then
            owner.components.sanity.externalmodifiers:RemoveModifier("sanityhelper_l", "boxopener_l")
        end
        TOOLS_L.RemoveEntValue(owner, "siv_blood_l_reducer", "siving_boxopener", 1)
    end
end
local function OnOwnerChange_opener(inst, owner, newowners)
    if inst.owner_l == owner then --没变化
        return
    end

    --先取消以前的对象
    local ownerold = inst.owner_l
    if ownerold ~= nil and ownerold:IsValid() then
        if ownerold.legion_boxopener ~= nil then
            local newtbl
            ownerold.legion_boxopener[inst] = nil
            for k, _ in pairs(ownerold.legion_boxopener) do
                if k:IsValid() then
                    if newtbl == nil then
                        newtbl = {}
                    end
                    newtbl[k] = true
                end
            end
            if newtbl == nil then
                SetFunction_opener(ownerold, false)
            end
            ownerold.legion_boxopener = newtbl
        else
            SetFunction_opener(ownerold, false)
        end
    end

    --再尝试设置目前的对象
    inst.owner_l = owner
    if owner.legion_boxopener == nil then
        owner.legion_boxopener = {}
        SetFunction_opener(owner, true)
    end
    owner.legion_boxopener[inst] = true
end
local function OnRemove_opener(inst)
    OnOwnerChange_opener(inst, inst)
end

table.insert(prefs, Prefab("siving_boxopener", function()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("boxopener_l")
    inst.AnimState:SetBuild("boxopener_l")
    inst.AnimState:PlayAnimation("idle_siv")

    inst:AddTag("boxopener_l")

    inst:AddComponent("container_proxy")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "siving_boxopener"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/siving_boxopener.xml"
    inst.components.inventoryitem:SetSinks(true)

    local container_proxy = inst.components.container_proxy
    container_proxy.Open_l = container_proxy.Open
    container_proxy.OnClose_l = container_proxy.OnClose
    container_proxy.Open = CP_Open_opener
    container_proxy.OnClose = CP_OnClose_opener

    MakeHauntableLaunch(inst)

    -- inst.owner_l = nil
    TOOLS_L.ListenOwnerChange(inst, OnOwnerChange_opener, OnRemove_opener)

    inst.OnLoadPostPass = OnLoadPostPass_opener
	if not POPULATING then
		if TheWorld.components.boxcloudpine ~= nil then
            TheWorld.components.boxcloudpine:SetMaster(inst)
        end
	end

    return inst
end, {
    Asset("ANIM", "anim/boxopener_l.zip"),
    Asset("ATLAS", "images/inventoryimages/siving_boxopener.xml"),
    Asset("IMAGE", "images/inventoryimages/siving_boxopener.tex"),
    Asset("ATLAS_BUILD", "images/inventoryimages/siving_boxopener.xml", 256)
}, nil))

--------------------
--------------------

return unpack(prefs)
