local prefs = {}

--------------------------------------------------------------------------
--[[ 通用函数 ]]
--------------------------------------------------------------------------

local function MakeItem(sets)
    local basename = sets.name.."_item"
    table.insert(prefs, Prefab(basename, function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank(sets.name)
        inst.AnimState:SetBuild(sets.name)
        inst.AnimState:PlayAnimation("idle_item")

        if sets.floatable ~= nil then
            MakeInventoryFloatable(inst, sets.floatable[2], sets.floatable[3], sets.floatable[4])
            if sets.floatable[1] ~= nil then
                local OnLandedClient_old = inst.components.floater.OnLandedClient
                inst.components.floater.OnLandedClient = function(self)
                    OnLandedClient_old(self)
                    self.inst.AnimState:SetFloatParams(sets.floatable[1], 1, self.bob_percent)
                end
            end
        end

        if sets.fn_common ~= nil then
            sets.fn_common(inst)
        end

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = basename
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..basename..".xml"
        if sets.floatable == nil then
            inst.components.inventoryitem:SetSinks(true)
        end

        inst:AddComponent("upgradekit")

        MakeHauntableLaunch(inst)

        if sets.fn_server ~= nil then
            sets.fn_server(inst)
        end

        return inst
    end, sets.assets, sets.prefabs))
end

--------------------------------------------------------------------------
--[[ 月藏宝匣 ]]
--------------------------------------------------------------------------

local function SetTarget_hidden(inst, targetprefab)
    inst.upgradetarget = targetprefab
    if targetprefab == "saltbox" then
        inst.AnimState:OverrideSymbol("base", "hiddenmoonlight", "saltbase")
    end
end

local function DoBenefit(inst)
    local items = inst.components.container:GetAllItems()
    local items_valid = {}
    for _,v in pairs(items) do
        if v ~= nil and v.components.perishable ~= nil then
            table.insert(items_valid, v)
        end
    end

    local benifitnum = #items_valid
    if benifitnum == 0 then
        return
    end
    if benifitnum > 4 then
        for i = 1, 4 do
            local benifititem = table.remove(items_valid, math.random(#items_valid))
            benifititem.components.perishable:SetPercent(1)
        end
    else
        for _,v in ipairs(items_valid) do
            v.components.perishable:SetPercent(1)
        end
    end

    if inst:IsAsleep() then --未加载状态就不产生特效了
        return
    end

    local fx = SpawnPrefab("chesterlight")
    if fx ~= nil then
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        fx:TurnOn()
        inst.SoundEmitter:PlaySound("dontstarve/creatures/chester/raise")
        fx:DoTaskInTime(2, function(fx)
            if fx:IsAsleep() then
                fx:Remove()
            else
                fx:TurnOff()
            end
        end)
    end
end
local function OnFullMoon_hidden(inst)
    if not TheWorld.state.isfullmoon then --月圆时进行
        return
    end

    if inst:IsAsleep() then
        DoBenefit(inst)
    else
        inst:DoTaskInTime(math.random() + 0.4, DoBenefit)
    end
end

local function OnUpgrade_hidden(item, doer, target, result)
    if result.SoundEmitter ~= nil then
        result.SoundEmitter:PlaySound("dontstarve/common/place_structure_straw")
    end
    SetTarget_hidden(result, target.prefab)

    --将原箱子中的物品转移到新箱子中
    if target.components.container ~= nil and result.components.container ~= nil then
        target.components.container:Close() --强制关闭使用中的箱子
        target.components.container.canbeopened = false
        local allitems = target.components.container:RemoveAllItems()
        for _,v in ipairs(allitems) do
            result.components.container:GiveItem(v)
        end
    end

    item:Remove() --该道具是一次性的
    OnFullMoon_hidden(result)
end

MakeItem({
    name = "hiddenmoonlight",
    assets = {
        Asset("ANIM", "anim/hiddenmoonlight.zip"),
        Asset("ATLAS", "images/inventoryimages/hiddenmoonlight_item.xml"),
        Asset("IMAGE", "images/inventoryimages/hiddenmoonlight_item.tex"),
    },
    prefabs = { "hiddenmoonlight" },
    floatable = { 0.1, "med", 0.3, 0.7 },
    -- fn_common = function(inst)end,
    fn_server = function(inst)
        inst.components.upgradekit:SetData({
            icebox = {
                prefabresult = "hiddenmoonlight",
                onupgradefn = OnUpgrade_hidden,
            },
            saltbox = {
                prefabresult = "hiddenmoonlight",
                onupgradefn = OnUpgrade_hidden,
            }
        })
    end
})

----------
----------

local function OnOpen(inst)
    if inst.AnimState:IsCurrentAnimation("opened") or inst.AnimState:IsCurrentAnimation("open") then
        return
    end
    inst.AnimState:PlayAnimation("open")
    inst.AnimState:PushAnimation("opened", true)

    if not inst.SoundEmitter:PlayingSound("idlesound1") then
        inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/spore_cloud_LP", "idlesound1", 0.7)
    end
    if not inst.SoundEmitter:PlayingSound("idlesound2") then
        inst.SoundEmitter:PlaySound("dontstarve/bee/bee_hive_LP", "idlesound2", 0.7)
    end
    inst.SoundEmitter:PlaySound("dontstarve/cave/mushtree_tall_spore_land", nil, 0.6)
end
local function OnClose(inst)
    if inst.AnimState:IsCurrentAnimation("close") or inst.AnimState:IsCurrentAnimation("closed") then
        return
    end
    inst.AnimState:PlayAnimation("close")
    inst.AnimState:PushAnimation("closed", true)

    inst.SoundEmitter:KillSound("idlesound1")
    inst.SoundEmitter:KillSound("idlesound2")
    inst.SoundEmitter:PlaySound("dontstarve/cave/mushtree_tall_spore_land", nil, 0.6)
end

table.insert(prefs, Prefab("hiddenmoonlight", function()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("hiddenmoonlight.tex")

    inst:AddTag("structure")
    inst:AddTag("fridge") --加了该标签，就能给热能石降温啦

    inst.AnimState:SetBank("hiddenmoonlight")
    inst.AnimState:SetBuild("hiddenmoonlight")
    inst.AnimState:PlayAnimation("closed", true)
    MakeSnowCovered_comm_legion(inst)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("hiddenmoonlight") end
        return inst
    end

    inst.upgradetarget = "icebox"

    inst:AddComponent("inspectable")

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("hiddenmoonlight")
    inst.components.container.onopenfn = OnOpen
    inst.components.container.onclosefn = OnClose
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true

    inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(function(inst, item)
        if item == nil then
            return 0.3
        end
        if item:HasTag("frozen") then
            return 0
        elseif inst.upgradetarget ~= nil then --盐箱是0.25，冰箱0.5。给盐盒就是0.15，给冰箱就是0.3
            if inst.upgradetarget == "saltbox" then
                return 0.15
            end
        end
        return 0.3
    end)

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(5)
    inst.components.workable:SetOnWorkCallback(function(inst, worker, workleft, numworks)
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("closed", true)
        inst.components.container:Close()
        if worker == nil or not worker:HasTag("player") then
            inst.components.workable:SetWorkLeft(5) --不能被非玩家破坏
            return
        end
        inst.components.container:DropEverything()
    end)
    inst.components.workable:SetOnFinishCallback(function(inst, worker)
        inst.components.container:DropEverything()

        local x, y, z = inst.Transform:GetWorldPosition()
        if inst.upgradetarget ~= nil then
            local box = SpawnPrefab(inst.upgradetarget)
            if box ~= nil then
                box.Transform:SetPosition(x, y, z)
            end
        end

        inst.components.lootdropper:SpawnLootPrefab("hiddenmoonlight_item")

        local fx = SpawnPrefab("collapse_small")
        fx.Transform:SetPosition(x, y, z)
        fx:SetMaterial("stone")
        inst:Remove()
    end)

    inst:WatchWorldState("isfullmoon", OnFullMoon_hidden)

    MakeHauntableLaunchAndDropFirstItem(inst)

    MakeSnowCovered_serv_legion(inst, 0.1 + 0.3 * math.random(), function(inst)
        inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
    end)

    inst.OnSave = function(inst, data)
        if inst.upgradetarget ~= "icebox" then
            data.upgradetarget = inst.upgradetarget
        end
    end
    inst.OnLoad = function(inst, data)
        if data ~= nil then
            if data.upgradetarget ~= nil then
                SetTarget_hidden(inst, data.upgradetarget)
            end
        end
    end

    if TUNING.SMART_SIGN_DRAW_ENABLE then
		SMART_SIGN_DRAW(inst)
	end

    return inst
end, {
    Asset("ANIM", "anim/ui_chest_3x3.zip"), --官方的容器栏背景动画模板
    Asset("ANIM", "anim/ui_hiddenmoonlight_4x4.zip"),
    Asset("ANIM", "anim/hiddenmoonlight.zip")
}, {
    "collapse_small",
    "hiddenmoonlight_item",
    "chesterlight"
}))

--------------------------------------------------------------------------
--[[ 月轮宝盘 ]]
--------------------------------------------------------------------------

local function OnUpgrade_revolved(item, doer, target, result)
    if result.SoundEmitter ~= nil then
        result.SoundEmitter:PlaySound("dontstarve/common/place_structure_straw")
    end

    if target.components.container ~= nil then
        target.components.container:Close() --强制关闭使用中的箱子
        target.components.container.canbeopened = false
        target.components.container:DropEverything()
    end

    item:Remove() --该道具是一次性的
end

MakeItem({
    name = "revolvedmoonlight",
    assets = {
        Asset("ANIM", "anim/revolvedmoonlight.zip"),
        Asset("ATLAS", "images/inventoryimages/revolvedmoonlight_item.xml"),
        Asset("IMAGE", "images/inventoryimages/revolvedmoonlight_item.tex")
    },
    prefabs = { "revolvedmoonlight", "revolvedmoonlight_pro" },
    floatable = { 0.18, "small", 0.4, 0.55 },
    -- fn_common = function(inst)end,
    fn_server = function(inst)
        inst.components.upgradekit:SetData({
            piggyback = {
                prefabresult = "revolvedmoonlight",
                onupgradefn = OnUpgrade_revolved,
            },
            krampus_sack = {
                prefabresult = "revolvedmoonlight_pro",
                onupgradefn = OnUpgrade_revolved,
            }
        })
    end
})

----------
----------

local function OnOpen_revolved(inst)
    if inst.AnimState:IsCurrentAnimation("opened") or inst.AnimState:IsCurrentAnimation("open") then
        return
    end
    inst.AnimState:PlayAnimation("open")
    inst.AnimState:PushAnimation("opened", true)

    if not inst.SoundEmitter:PlayingSound("idlesound1") then
        inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/spore_cloud_LP", "idlesound1", 0.7)
    end
    if not inst.SoundEmitter:PlayingSound("idlesound2") then
        inst.SoundEmitter:PlaySound("dontstarve/bee/bee_hive_LP", "idlesound2", 0.7)
    end
    inst.SoundEmitter:PlaySound("dontstarve/cave/mushtree_tall_spore_land", nil, 0.6)
end
local function OnClose_revolved(inst)
    if inst.AnimState:IsCurrentAnimation("close") or inst.AnimState:IsCurrentAnimation("closed") then
        return
    end
    inst.AnimState:PlayAnimation("close")
    inst.AnimState:PushAnimation("closed")

    inst.SoundEmitter:KillSound("idlesound1")
    inst.SoundEmitter:KillSound("idlesound2")
    inst.SoundEmitter:PlaySound("dontstarve/cave/mushtree_tall_spore_land", nil, 0.6)
end

local function ResetRadius(inst)
    local stagenow = inst.components.upgradeable:GetStage()
    if stagenow > 1 then
        local rad = 0.25 + (stagenow-1)*0.25
        if inst.components.inventoryitem.owner ~= nil then --被携带时，发光范围减半
            rad = rad / 2
            inst._light.Light:SetFalloff(0.65)
        else
            inst._light.Light:SetFalloff(0.7)
        end
        inst._light.Light:SetRadius(rad) --最大约2.75和5.25半径
    end
end
local function IsValid(one)
    return one:IsValid() and
        one.components.health ~= nil and not one.components.health:IsDead()
end
local function CancelTask_heat(inst)
    if inst.task_heat ~= nil then
        inst.task_heat:Cancel()
        inst.task_heat = nil
    end
end
local function TemperatureProtect(inst, owner)
    if inst._owner_temp ~= nil then
        if inst._owner_temp == owner then --监听对象没有发生变化，就结束
            return
        end
        inst:RemoveEventCallback("startfreezing", inst.fn_onTempDelta, inst._owner_temp) --把以前的监听去除
        inst:RemoveEventCallback("death", inst.fn_onTempDelta, inst._owner_temp)
        CancelTask_heat(inst)
        inst._owner_temp = nil
    else
        CancelTask_heat(inst)
    end

    --监听新的
    if
        owner and IsValid(owner) and
        owner.components.temperature ~= nil
    then
        inst:ListenForEvent("startfreezing", inst.fn_onTempDelta, owner)
        inst:ListenForEvent("death", inst.fn_onTempDelta, owner)
        inst._owner_temp = owner
        if owner.components.temperature:IsFreezing() then
            inst.fn_onTempDelta(owner)
        end
    end
end
local function OnOwnerChange(inst)
    local newowners = {}
    local owner = inst
    while owner.components.inventoryitem ~= nil do
        newowners[owner] = true

        if inst._owners[owner] then
            inst._owners[owner] = nil
        else
            inst:ListenForEvent("onputininventory", inst._onownerchange, owner)
            inst:ListenForEvent("ondropped", inst._onownerchange, owner)
        end

        local nextowner = owner.components.inventoryitem.owner
        if nextowner == nil then
            break
        end

        owner = nextowner
    end

    ResetRadius(inst)
    inst._light.entity:SetParent(owner.entity)

    for k, v in pairs(inst._owners) do
        if k:IsValid() then
            inst:RemoveEventCallback("onputininventory", inst._onownerchange, k)
            inst:RemoveEventCallback("ondropped", inst._onownerchange, k)
        end
    end

    inst._owners = newowners
    TemperatureProtect(inst, owner)
end

local function MakeRevolved(sets)
    local widgetname = sets.ispro and "revolvedmoonlight_pro" or "revolvedmoonlight"
    table.insert(prefs, Prefab(sets.name, function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("revolvedmoonlight")
        inst.AnimState:SetBuild("revolvedmoonlight")
        inst.AnimState:PlayAnimation("closed")

        if sets.ispro then
            inst.AnimState:OverrideSymbol("decorate", "revolvedmoonlight", "decoratepro")
            inst:SetPrefabNameOverride("revolvedmoonlight")
        end

        inst:AddTag("meteor_protection") --防止被流星破坏
        --因为有容器组件，所以不会被猴子、食人花、坎普斯等拿走
        inst:AddTag("NORATCHECK") --mod兼容：永不妥协。该道具不算鼠潮分

        MakeInventoryFloatable(inst, sets.floatable[2], sets.floatable[3], sets.floatable[4])
        if sets.floatable[1] ~= nil then
            local OnLandedClient_old = inst.components.floater.OnLandedClient
            inst.components.floater.OnLandedClient = function(self)
                OnLandedClient_old(self)
                self.inst.AnimState:SetFloatParams(sets.floatable[1], 1, self.bob_percent)
            end
        end

        inst.repair_revolved_l = true

        -- if sets.fn_common ~= nil then
        --     sets.fn_common(inst)
        -- end

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup(widgetname) end
            return inst
        end

        inst._owner_temp = nil
        inst.task_heat = nil
        inst.fn_onTempDelta = function(owner)
            if not IsValid(owner) or owner.components.temperature == nil then
                TemperatureProtect(inst, nil)
                return
            end
            if not inst.components.rechargeable:IsCharged() then --冷却期内不触发
                return
            end

            local count = 1
            local stagenow = inst.components.upgradeable:GetStage()
            inst.components.rechargeable:Discharge(3+TUNING.TOTAL_DAY_TIME*(21-stagenow)/20)
            CancelTask_heat(inst)
            stagenow = 7+1.75*(stagenow-1) --7-42
            inst.task_heat = inst:DoPeriodicTask(0.5, function(inst)
                if
                    inst._owner_temp == nil or
                    not IsValid(inst._owner_temp) or
                    inst._owner_temp.components.temperature == nil
                then
                    TemperatureProtect(inst, nil)
                    return
                end

                local fx = SpawnPrefab("revolvedmoonlight_fx")
                if fx ~= nil then
                    fx.Transform:SetPosition(inst._owner_temp.Transform:GetWorldPosition())
                end

                if count < 1 then
                    count = 1
                    return
                else
                    count = 0
                end

                local temper = inst._owner_temp.components.temperature
                if (temper.current+3.5) < temper.overheattemp then --可不能让温度太高了
                    temper:SetTemperature(temper.current + 3.5)
                else
                    CancelTask_heat(inst)
                    return
                end

                stagenow = stagenow - 3.5
                if stagenow <= 0 then
                    CancelTask_heat(inst)
                end
            end, 0)
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = sets.name
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..sets.name..".xml"
        inst.components.inventoryitem:SetOnPutInInventoryFn(function(inst)
            inst.components.container:Close()
            inst.AnimState:PlayAnimation("closed")
        end)

        inst:AddComponent("container")
        inst.components.container:WidgetSetup(widgetname)
        inst.components.container.onopenfn = OnOpen_revolved
        inst.components.container.onclosefn = OnClose_revolved
        inst.components.container.skipclosesnd = true
        inst.components.container.skipopensnd = true
        -- inst.components.container.droponopen = true --去掉这个就能打开不掉落了

        inst:AddComponent("lootdropper")

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(5)
        inst.components.workable:SetOnWorkCallback(function(inst, worker, workleft, numworks)
            inst.AnimState:PlayAnimation("hit")
            inst.AnimState:PushAnimation("closed")
            inst.SoundEmitter:PlaySound("grotto/common/turf_crafting_station/hit")
            inst.components.container:Close()
            if worker == nil or not worker:HasTag("player") then
                inst.components.workable:SetWorkLeft(5) --不能被非玩家破坏
                return
            end
            inst.components.container:DropEverything()
        end)
        inst.components.workable:SetOnFinishCallback(function(inst, worker)
            inst.components.container:DropEverything()

            --归还背包
            local x, y, z = inst.Transform:GetWorldPosition()
            local back = SpawnPrefab(sets.ispro and "krampus_sack" or "piggyback")
            if back ~= nil then
                back.Transform:SetPosition(x, y, z)
                back = nil
            end

            --归还宝石
            local numgems = inst.components.upgradeable:GetStage() - 1
            if numgems > 0 then
                back = SpawnPrefab("yellowgem")
                if back ~= nil then
                    if numgems > 1 and back.components.stackable ~= nil then
                        back.components.stackable:SetStackSize(numgems)
                    end
                    back.Transform:SetPosition(x, y, z)
                    if back.components.inventoryitem ~= nil then
                        back.components.inventoryitem:OnDropped(true)
                    end
                end
            end
            --归还套件
            inst.components.lootdropper:SpawnLootPrefab("revolvedmoonlight_item")

            --特效
            local fx = SpawnPrefab("collapse_small")
            fx.Transform:SetPosition(x, y, z)
            fx:SetMaterial("stone")
            inst:Remove()
        end)

        inst:AddComponent("upgradeable")
        inst.components.upgradeable.upgradetype = UPGRADETYPES.REVOLVED_L
        inst.components.upgradeable.onupgradefn = function(inst, doer, item)
            inst.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
        end
        inst.components.upgradeable.onstageadvancefn = function(inst)
            ResetRadius(inst)
            inst.components.rechargeable:SetPercent(1) --每次升级，重置冷却时间
        end
        inst.components.upgradeable.numstages = sets.ispro and 21 or 11
        inst.components.upgradeable.upgradesperstage = 1

        inst:AddComponent("rechargeable")
        inst.components.rechargeable:SetOnChargedFn(function(inst)
            if
                inst._owner_temp ~= nil and
                inst._owner_temp.components.temperature ~= nil and
                inst._owner_temp.components.temperature:IsFreezing()
            then
                inst.fn_onTempDelta(inst._owner_temp)
            end
        end)

        inst.OnLoad = function(inst, data) --由于 upgradeable 组件不会自己重新初始化，只能这里再初始化
            ResetRadius(inst)
        end

        --Create light
        inst._light = SpawnPrefab("heatrocklight")
        inst._light.Light:SetRadius(0.25)
        inst._light.Light:SetFalloff(0.7) --Tip：削弱系数：相同半径时，值越小会让光照范围越大
        inst._light.Light:SetColour(255/255, 242/255, 169/255)
        inst._light.Light:SetIntensity(0.75)
        inst._light.Light:Enable(true)
        inst._owners = {}
        inst._onownerchange = function() OnOwnerChange(inst) end
        OnOwnerChange(inst)
        inst.OnRemoveEntity = function(inst)
            inst._light:Remove()
        end

        -- if TUNING.SMART_SIGN_DRAW_ENABLE then --由于这个容器是便携的，不适合兼容【智能小木牌】
        --     SMART_SIGN_DRAW(inst)
        -- end

        -- if sets.fn_server ~= nil then
        --     sets.fn_server(inst)
        -- end

        return inst
    end, {
        Asset("ANIM", "anim/ui_chest_3x3.zip"), --官方的容器栏背景动画模板
        Asset("ANIM", "anim/ui_revolvedmoonlight_4x3.zip"),
        Asset("ANIM", "anim/revolvedmoonlight.zip"),
        Asset("ATLAS", "images/inventoryimages/"..sets.name..".xml"),
        Asset("IMAGE", "images/inventoryimages/"..sets.name..".tex")
    }, {
        "revolvedmoonlight_item",
        "collapse_small",
        "yellowgem",
        "heatrocklight",
        "revolvedmoonlight_fx"
    }))
end

MakeRevolved({
    name = "revolvedmoonlight",
    floatable = { 0.1, "med", 0.3, 0.3 },
    ispro = nil,
    -- fn_common = function(inst)end,
    -- fn_server = function(inst)end
})
MakeRevolved({
    name = "revolvedmoonlight_pro",
    floatable = { 0.1, "med", 0.3, 0.45 },
    ispro = true,
    -- fn_common = function(inst)end,
    -- fn_server = function(inst)end
})

--------------------
--------------------

return unpack(prefs)
