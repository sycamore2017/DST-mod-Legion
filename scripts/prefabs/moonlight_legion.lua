local prefs = {}
local TOOLS_L = require("tools_legion")

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

        LS_C_Init(inst, basename, true)

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = basename
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..basename..".xml"

        inst:AddComponent("upgradekit")
        inst.components.upgradekit:SetData(sets.kitdata)

        MakeHauntableLaunch(inst)

        return inst
    end, {
        Asset("ANIM", "anim/"..sets.name..".zip"),
        Asset("ATLAS", "images/inventoryimages/"..basename..".xml"),
        Asset("IMAGE", "images/inventoryimages/"..basename..".tex"),
        Asset("ATLAS_BUILD", "images/inventoryimages/"..basename..".xml", 256)
    }, sets.prefabs))
end

local function DropGems(inst, gemname)
    local numgems = inst.components.upgradeable:GetStage() - 1
    if numgems > 0 then
        TOOLS_L.SpawnStackDrop(gemname, numgems, inst:GetPosition(), nil, nil, nil)
    end
end
local function OnUpgradeFn(inst, doer, item)
    (inst.SoundEmitter or doer.SoundEmitter):PlaySound("dontstarve/common/telebase_gemplace")
end
local function Fn_nameDetail(inst, max)
    local lvl = inst._lvl_l:value()
    if lvl == nil or lvl < 0 then
        lvl = 0
    end
    return subfmt(STRINGS.NAMEDETAIL_L.MOONTREASURE, { lvl = tostring(lvl), lvlmax = max })
end
local function InitLevelNet(inst, fn_detail)
    inst._lvl_l = net_byte(inst.GUID, "moonlight_l._lvl_l", "lvl_l_dirty")
    inst._lvl_l:set_local(0)
    inst.fn_l_namedetail = fn_detail
end
local function SetLevel(inst)
    inst._lvl_l:set(inst.components.upgradeable:GetStage() - 1)
end
local function NoWorked(inst, worker)
    if worker ~= nil and (worker:HasTag("player") or worker.components.walkableplatform ~= nil) then
        return false
    end
    return true
end

--------------------------------------------------------------------------
--[[ 月藏宝匣 ]]
--------------------------------------------------------------------------

local times_hidden = CONFIGS_LEGION.HIDDENUPDATETIMES or 20

local function UpdatePerishRate_hidden(inst)
    local lvl = inst.components.upgradeable:GetStage() - 1
    if lvl > times_hidden then --在设置变换中，会出现当前等级大于最大等级的情况
        lvl = times_hidden
    elseif lvl < 0 then
        lvl = 0
    end
    if inst.upgradetarget == "icebox" then
        inst.perishrate_l = Remap(lvl, 0, times_hidden, 0.4, 0.1)
    else
        inst.perishrate_l = Remap(lvl, 0, times_hidden, 0.3, 0.0)
    end
end
local function SetTarget_hidden(inst, targetprefab)
    inst.upgradetarget = targetprefab
    if targetprefab ~= "icebox" then
        inst.AnimState:OverrideSymbol("base", inst.AnimState:GetBuild() or "hiddenmoonlight", "saltbase")
    end
end
local function DoBenefit(inst)
    local items = inst.components.container:GetAllItems()
    local items_valid = {}
    for _,v in pairs(items) do
        if
            v ~= nil and
            v.components.perishable ~= nil and v.components.perishable:GetPercent() < 0.995
        then
            table.insert(items_valid, v)
        end
    end

    local benifitnum = #items_valid
    if benifitnum == 0 then
        return
    end

    local value = 2.5
    local needs = 0.0
    while value > 0 and benifitnum > 0 do
        local benifititem = table.remove(items_valid, math.random(#items_valid))
        benifitnum = benifitnum - 1
        needs = 1 - benifititem.components.perishable:GetPercent()
        if value >= needs then
            benifititem.components.perishable:SetPercent(1)
            value = value - needs
        else
            benifititem.components.perishable:ReducePercent(-value)
            value = 0
        end
    end

    -- local stagenow = 4
    -- if benifitnum > stagenow then
    --     for i = 1, stagenow do
    --         local benifititem = table.remove(items_valid, math.random(#items_valid))
    --         benifititem.components.perishable:SetPercent(1)
    --     end
    -- else
    --     for _,v in ipairs(items_valid) do
    --         v.components.perishable:SetPercent(1)
    --     end
    -- end

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

    local skin = item.components.skinedlegion:GetSkin()
    if skin ~= nil then
        result.components.skinedlegion:SetSkin(skin, LS_C_UserID(item, doer))
    end

    SetTarget_hidden(result, target.prefab)
    UpdatePerishRate_hidden(result)

    --将原箱子中的物品转移到新箱子中
    if target.components.container ~= nil and result.components.container ~= nil then
        target.components.container:Close() --强制关闭使用中的箱子
        target.components.container.canbeopened = false
        local allitems = target.components.container:RemoveAllItems()
        for _, v in ipairs(allitems) do
            result.components.container:GiveItem(v)
        end
    end

    item:Remove() --该道具是一次性的
    OnFullMoon_hidden(result)
end

MakeItem({
    name = "hiddenmoonlight",
    prefabs = { "hiddenmoonlight" },
    kitdata = {
        icebox = {
            prefabresult = "hiddenmoonlight",
            onupgradefn = OnUpgrade_hidden
        },
        saltbox = {
            prefabresult = "hiddenmoonlight",
            onupgradefn = OnUpgrade_hidden
        }
    }
})

----------
----------

local function OnEntityReplicated_hidden(inst)
    if inst.replica.container ~= nil then
        inst.replica.container:WidgetSetup("hiddenmoonlight")
    end
end
local function OnOpen(inst)
    if inst.AnimState:IsCurrentAnimation("opened") or inst.AnimState:IsCurrentAnimation("open") then
        return
    end
    inst.AnimState:PlayAnimation("open")
    inst.AnimState:PushAnimation("opened", true)

    if inst._dd ~= nil and inst._dd.openfn ~= nil then
        inst._dd.openfn(inst)
    end

    if not inst.SoundEmitter:PlayingSound("idlesound1") then
        inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/spore_cloud_LP", "idlesound1", 0.7)
    end
    if not inst.SoundEmitter:PlayingSound("idlesound2") then
        inst.SoundEmitter:PlaySound("dontstarve/bee/bee_hive_LP", "idlesound2", 0.7)
    end
    inst.SoundEmitter:PlaySound("dontstarve/cave/mushtree_tall_spore_land")
end
local function OnClose(inst)
    if inst.AnimState:IsCurrentAnimation("close") or inst.AnimState:IsCurrentAnimation("closed") then
        return
    end
    inst.AnimState:PlayAnimation("close")
    inst.AnimState:PushAnimation("closed", true)

    inst.SoundEmitter:KillSound("idlesound1")
    inst.SoundEmitter:KillSound("idlesound2")
    inst.SoundEmitter:PlaySound("dontstarve/cave/mushtree_tall_spore_land")
end
local function SetPerishRate_hidden(inst, item)
    if item == nil then
        return inst.perishrate_l
    end
    if item:HasTag("frozen") then
        return 0
    end
    return inst.perishrate_l
end
local function SetLevel_hidden(inst)
    SetLevel(inst)
    UpdatePerishRate_hidden(inst)
end
local function OnSave_hidden(inst, data)
	if inst.upgradetarget ~= "icebox" then
        data.upgradetarget = inst.upgradetarget
    end
end
local function OnLoad_hidden(inst, data)
	if data ~= nil then
        if data.upgradetarget ~= nil then
            SetTarget_hidden(inst, data.upgradetarget)
        end
    end
    SetLevel_hidden(inst)
end
local function OnWork_hidden(inst, worker, workleft, numworks)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("closed", true)
    inst.components.container:Close()
    if NoWorked(inst, worker) then --只能被玩家或者船体破坏
        inst.components.workable:SetWorkLeft(5)
        return
    end
    inst.components.container:DropEverything()
end
local function OnFinished_hidden(inst, worker)
    inst.components.container:DropEverything()

    local x, y, z = inst.Transform:GetWorldPosition()
    if inst.upgradetarget ~= nil then
        local box = SpawnPrefab(inst.upgradetarget)
        if box ~= nil then
            box.Transform:SetPosition(x, y, z)
        end
    end

    --归还宝石
    DropGems(inst, "bluegem")

    local skin = inst.components.skinedlegion:GetSkin()
    if skin == nil then
        inst.components.lootdropper:SpawnLootPrefab("hiddenmoonlight_item")
    else
        inst.components.lootdropper:SpawnLootPrefab("hiddenmoonlight_item", nil, skin, nil, LS_C_UserID(inst, worker))
    end

    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(x, y, z)
    fx:SetMaterial("stone")
    inst:Remove()
end
local function Fn_nameDetail_hidden(inst)
    return Fn_nameDetail(inst, times_hidden)
end

local function OnWork_hidden_inf(inst, worker, workleft, numworks)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("closed", true)
    inst.components.container:Close()
    if worker == nil or not worker:HasTag("player") then --只能被玩家破坏。没必要弄烂箱子设定
        inst.components.workable:SetWorkLeft(5)
        return
    end
    inst.components.container:DropEverything(nil, true)
    if not inst.components.container:IsEmpty() then --如果箱子里还有物品，那就不能被破坏
        inst.components.workable:SetWorkLeft(5)
    end
end
local function OnFinished_hidden_inf(inst, worker)
    inst.components.lootdropper:SpawnLootPrefab("chestupgrade_stacksize")
    OnFinished_hidden(inst, worker)
end
local function OnUpgrade_hidden_inf(inst, item, doer)
    if item.components.stackable ~= nil then
		item.components.stackable:Get(1):Remove()
	else
		item:Remove()
	end

    local x, y, z = inst.Transform:GetWorldPosition()
    local fx = SpawnPrefab("chestupgrade_stacksize_fx")
    if fx ~= nil then
        fx.Transform:SetPosition(x, y, z)
    end

    local newbox = SpawnPrefab("hiddenmoonlight_inf")
    if newbox ~= nil then
        local skin = inst.components.skinedlegion:GetSkin()
        if skin ~= nil then
            newbox.components.skinedlegion:SetSkin(skin, LS_C_UserID(inst, doer))
        end

        SetTarget_hidden(newbox, inst.upgradetarget)

        --继承之前的等级
        newbox.components.upgradeable:SetStage(inst.components.upgradeable:GetStage())
        SetLevel_hidden(newbox)

        newbox.Transform:SetPosition(x, y, z)

        --将原箱子中的物品转移到新箱子中
        if inst.components.container ~= nil and newbox.components.container ~= nil then
            inst.components.container:Close() --强制关闭使用中的箱子
            inst.components.container.canbeopened = false
            local allitems = inst.components.container:RemoveAllItems()
            for _, v in ipairs(allitems) do
                newbox.components.container:GiveItem(v)
            end
        end
    end

    inst:Remove()
end

local function MakeHidden(dd)
    table.insert(prefs, Prefab(dd.name, function()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()

        inst.MiniMapEntity:SetIcon("hiddenmoonlight.tex")

        inst:AddTag("structure")
        inst:AddTag("fridge") --加了该标签，就能给热能石降温啦
        inst:AddTag("meteor_protection") --防止被流星破坏
        inst:AddTag("moontreasure_l")

        if dd.fn_common ~= nil then
            dd.fn_common(inst)
        end
        inst.AnimState:PlayAnimation("closed", true)

        InitLevelNet(inst, Fn_nameDetail_hidden)

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            inst.OnEntityReplicated = OnEntityReplicated_hidden
            return inst
        end

        inst.upgradetarget = "icebox"
        inst.perishrate_l = 0.5

        inst:AddComponent("inspectable")

        inst:AddComponent("container")
        inst.components.container:WidgetSetup("hiddenmoonlight")
        inst.components.container.onopenfn = OnOpen
        inst.components.container.onclosefn = OnClose
        inst.components.container.skipclosesnd = true
        inst.components.container.skipopensnd = true

        inst:AddComponent("preserver")
        inst.components.preserver:SetPerishRateMultiplier(SetPerishRate_hidden)

        inst:AddComponent("lootdropper")

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(5)

        inst:AddComponent("upgradeable")
        inst.components.upgradeable.upgradetype = UPGRADETYPES.HIDDEN_L
        inst.components.upgradeable.onupgradefn = OnUpgradeFn --升级前
        inst.components.upgradeable.onstageadvancefn = SetLevel_hidden --升级时
        inst.components.upgradeable.numstages = times_hidden + 1
        inst.components.upgradeable.upgradesperstage = 1

        inst:WatchWorldState("isfullmoon", OnFullMoon_hidden)

        MakeHauntableLaunchAndDropFirstItem(inst)

        TOOLS_L.MakeSnowCovered_serv(inst, 0.1 + 0.3*math.random(), function(inst)
            inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
        end)

        inst.OnSave = OnSave_hidden
        inst.OnLoad = OnLoad_hidden

        if TUNING.SMART_SIGN_DRAW_ENABLE then
            SMART_SIGN_DRAW(inst)
        end
        if TUNING.FUNCTIONAL_MEDAL_IS_OPEN then
            SetImmortalable(inst, 2, nil)
        end

        if dd.fn_server ~= nil then
            dd.fn_server(inst)
        end

        return inst
    end, dd.assets, dd.prefabs))
end

MakeHidden({
    name = "hiddenmoonlight",
    assets = {
        Asset("ANIM", "anim/ui_chest_3x3.zip"), --官方的容器栏背景动画模板
        Asset("ANIM", "anim/ui_hiddenmoonlight_4x4.zip"),
        Asset("ANIM", "anim/hiddenmoonlight.zip")
    },
    prefabs = {
        "hiddenmoonlight_item",
        "hiddenmoonlight_inf",
        "chesterlight",
        "chestupgrade_stacksize_fx"
    },
    fn_common = function(inst)
        inst:AddTag("chest_upgradeable") --能被 弹性空间制造器 升级
        inst.AnimState:SetBank("hiddenmoonlight")
        inst.AnimState:SetBuild("hiddenmoonlight")
        LS_C_Init(inst, "hiddenmoonlight_item", false, "data_up", "hiddenmoonlight")
    end,
    fn_server = function(inst)
        inst.components.workable:SetOnWorkCallback(OnWork_hidden)
        inst.components.workable:SetOnFinishCallback(OnFinished_hidden)

        inst.fn_upgrade_chest_l = OnUpgrade_hidden_inf
    end
})
MakeHidden({
    name = "hiddenmoonlight_inf",
    assets = {
        Asset("ANIM", "anim/ui_chest_3x3.zip"), --官方的容器栏背景动画模板
        Asset("ANIM", "anim/ui_hiddenmoonlight_inf_4x4.zip"),
        Asset("ANIM", "anim/hiddenmoonlight_inf.zip")
    },
    prefabs = {
        "hiddenmoonlight_item",
        "hiddenmoonlight",
        "chesterlight",
        "chestupgrade_stacksize"
    },
    fn_common = function(inst)
        inst.AnimState:SetBank("hiddenmoonlight")
        inst.AnimState:SetBuild("hiddenmoonlight_inf")
        LS_C_Init(inst, "hiddenmoonlight_item", false, "data_upinf", "hiddenmoonlight_inf")
    end,
    fn_server = function(inst)
        inst.components.container:EnableInfiniteStackSize(true)

        inst.components.workable:SetOnWorkCallback(OnWork_hidden_inf)
        inst.components.workable:SetOnFinishCallback(OnFinished_hidden_inf)
    end
})

--------------------------------------------------------------------------
--[[ 月轮宝盘 ]]
--------------------------------------------------------------------------

local function OnUpgrade_revolved(item, doer, target, result)
    if result.SoundEmitter ~= nil then
        result.SoundEmitter:PlaySound("dontstarve/common/place_structure_straw")
    end

    local skin = item.components.skinedlegion:GetSkin()
    if skin ~= nil then
        result.components.skinedlegion:SetSkin(skin, LS_C_UserID(item, doer))
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
    prefabs = { "revolvedmoonlight", "revolvedmoonlight_pro" },
    kitdata = {
        piggyback = {
            prefabresult = "revolvedmoonlight",
            onupgradefn = OnUpgrade_revolved
        },
        krampus_sack = {
            prefabresult = "revolvedmoonlight_pro",
            onupgradefn = OnUpgrade_revolved
        }
    }
})

----------
----------

local times_revolved_pro = CONFIGS_LEGION.REVOLVEDUPDATETIMES or 10
local value_revolved = 5/times_revolved_pro
local cool_revolved = TUNING.TOTAL_DAY_TIME/times_revolved_pro
local temp_revolved = 35/times_revolved_pro
local times_revolved = math.floor(times_revolved_pro/2) + 1
times_revolved_pro = times_revolved_pro + 1

local function EnableLight(light)
    if not light.Light:IsEnabled() then
        light.Light:Enable(true)
    end
end
local function DisableLight(light)
    if light.Light:IsEnabled() then
        light.Light:Enable(false)
    end
end
local function OnOpen_revolved(inst)
    if inst.AnimState:IsCurrentAnimation("opened") or inst.AnimState:IsCurrentAnimation("open") then
        return
    end
    inst.AnimState:PlayAnimation("open")
    inst.AnimState:PushAnimation("opened", true)

    inst.SoundEmitter:PlaySound("dontstarve/cave/mushtree_tall_spore_land", nil, 0.6)

    local gowner = inst.components.inventoryitem:GetGrandOwner()
    if gowner ~= nil then --说明自己在容器里，就不要发出循环声音
        return
    end
    if not inst.SoundEmitter:PlayingSound("idlesound1") then
        inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/spore_cloud_LP", "idlesound1", 0.7)
    end
    if not inst.SoundEmitter:PlayingSound("idlesound2") then
        inst.SoundEmitter:PlaySound("dontstarve/bee/bee_hive_LP", "idlesound2", 0.7)
    end
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
local function OnTempDelta_revolved(owner, data)
    if
        data == nil or data.new == nil or data.new >= 6 or --低温特效出现前就执行
        owner._revolves_l == nil or owner.components.temperature == nil or
        owner.components.health == nil or owner.components.health:IsDead()
    then
        return
    end
    local chosen = nil
    for k, _ in pairs(owner._revolves_l) do
        if k:IsValid() then
            if k.components.rechargeable:IsCharged() then --冷却完毕，可以用
                chosen = k
                break
            end
        end
    end
    if chosen == nil then
        return
    end

    local temper = owner.components.temperature
    local stagenow = chosen.components.upgradeable:GetStage()
    if stagenow > times_revolved_pro then --在设置变换中，会出现当前等级大于最大等级的情况
        stagenow = times_revolved_pro
    end
    chosen.components.rechargeable:Discharge(3 + cool_revolved*(times_revolved_pro-stagenow))
    stagenow = 7 + temp_revolved*(stagenow-1) --7-42
    stagenow = math.min(stagenow, temper.overheattemp-5-temper.current) --可不能让温度太高了
    if stagenow > 0 then
        temper:SetTemperature(temper.current + stagenow)
    end

    if owner.task_l_heatfx ~= nil then
        owner.task_l_heatfx:Cancel()
    end
    local count = 0
    owner.task_l_heatfx = owner:DoPeriodicTask(0.5, function(owner)
        local fx = SpawnPrefab("revolvedmoonlight_fx")
        if fx ~= nil then
            fx.Transform:SetPosition(owner.Transform:GetWorldPosition())
        end
        count = count + 1
        if count >= 5 then
            owner.task_l_heatfx:Cancel()
            owner.task_l_heatfx = nil
        end
    end, 0)
end
local function UpdateLight_revolved(inst, owner) --更新光照范围
    if owner == inst then
        owner = nil
    end
    local stagenow = inst.components.upgradeable:GetStage()
    if stagenow > 1 then
        if stagenow > times_revolved_pro then --在设置变换中，会出现当前等级大于最大等级的情况
            stagenow = times_revolved_pro
        end
        local rad = 0.25 + (stagenow-1)*value_revolved
        if owner ~= nil then --被携带时，发光范围减半
            rad = rad / 2
            inst._light.Light:SetFalloff(0.65)
        else
            inst._light.Light:SetFalloff(0.7)
        end
        inst._light.Light:SetRadius(rad) --最大约2.75和5.25半径
    end
end
local function UpdateOwnerLights_revolved(owner) --统一管理，只更新等级最高的那一个
    if owner._revolves_l == nil then
        return
    end
    local chosen = nil
    local lvl = 0
    for k, _ in pairs(owner._revolves_l) do
        if k:IsValid() then
            local stagenow = k.components.upgradeable:GetStage()
            if stagenow > lvl then
                lvl = stagenow
                chosen = k
            end
        end
    end
    if chosen ~= nil then
        UpdateLight_revolved(chosen, owner)
        for k, _ in pairs(owner._revolves_l) do
            if k:IsValid() then
                if k == chosen then
                    EnableLight(k._light)
                else
                    DisableLight(k._light)
                end
            end
        end
    end
end
local function ClearOwnerData_revolved(inst)
    local ownerold = inst.owner_l
    if ownerold ~= nil and ownerold ~= inst and ownerold:IsValid() then
        if ownerold._revolves_l ~= nil then
            local newtbl
            ownerold._revolves_l[inst] = nil
            for k, _ in pairs(ownerold._revolves_l) do
                if k:IsValid() then
                    if newtbl == nil then
                        newtbl = {}
                    end
                    newtbl[k] = true
                end
            end
            ownerold._revolves_l = newtbl
            if newtbl == nil then
                ownerold:RemoveEventCallback("temperaturedelta", OnTempDelta_revolved)
            else
                UpdateOwnerLights_revolved(ownerold)
            end
        else
            ownerold:RemoveEventCallback("temperaturedelta", OnTempDelta_revolved)
        end
    end
end
local function OnOwnerChange_revolved(inst, owner, newowners)
    if inst.owner_l == owner then --没变化
        return
    end

    --先取消以前的对象
    ClearOwnerData_revolved(inst)

    --再尝试设置目前的对象
    inst.owner_l = owner
    inst._light.entity:SetParent(owner.entity)
    if owner ~= inst then
        if owner:HasTag("pocketdimension_container") or owner:HasTag("buried") then
            inst.components.container.droponopen = true --世界容器里，打开时会自动掉地上，防止崩溃
            DisableLight(inst._light)
        else
            inst.components.container.droponopen = nil
            if owner._revolves_l == nil then
                owner._revolves_l = {}
                if owner:HasTag("player") then
                    owner:ListenForEvent("temperaturedelta", OnTempDelta_revolved)
                    --温度监听 触发非常频繁，所以应该不需要主动触发一次
                    -- OnTempDelta_revolved(owner, { last = 0, new = owner.components.temperature:GetCurrent() })
                end
            end
            owner._revolves_l[inst] = true
            UpdateOwnerLights_revolved(owner)
        end
    else
        UpdateLight_revolved(inst, nil)
        EnableLight(inst._light)
        inst.components.container.droponopen = nil
    end
end
local function OnRemove_revolved(inst)
    ClearOwnerData_revolved(inst)
    inst.owner_l = nil
    inst._light:Remove()
end

local function OnStageUp_revolved(inst)
    inst.components.rechargeable:SetPercent(1) --每次升级，重置冷却时间
    SetLevel(inst)

    local ownerold = inst.owner_l
    inst.owner_l = nil
    OnOwnerChange_revolved(inst, ownerold)
end
local function OnLoad_revolved(inst, data) --由于 upgradeable 组件不会自己重新初始化，只能这里再初始化
    UpdateLight_revolved(inst, nil)
    SetLevel(inst)
end
local function OnWork_revolved(inst, worker, workleft, numworks)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("closed")
    inst.SoundEmitter:PlaySound("grotto/common/turf_crafting_station/hit")
    inst.components.container:Close()
    if worker == nil or not worker:HasTag("player") then --不能被非玩家破坏
        inst.components.workable:SetWorkLeft(5)
        return
    end
    inst.components.container:DropEverything()
end
local function OnFinished_revolved(inst, worker)
    inst.components.container:DropEverything()

    --归还背包
    local x, y, z = inst.Transform:GetWorldPosition()
    local back = SpawnPrefab(inst.prefab == "revolvedmoonlight" and "piggyback" or "krampus_sack")
    if back ~= nil then
        back.Transform:SetPosition(x, y, z)
    end

    --归还宝石
    DropGems(inst, "yellowgem")

    --归还套件
    local skin = inst.components.skinedlegion:GetSkin()
    if skin == nil then
        inst.components.lootdropper:SpawnLootPrefab("revolvedmoonlight_item")
    else
        inst.components.lootdropper:SpawnLootPrefab("revolvedmoonlight_item", nil,
            skin, nil, LS_C_UserID(inst, worker))
    end

    --特效
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(x, y, z)
    fx:SetMaterial("stone")
    inst:Remove()
end
local function OnPutInInventory_revolved(inst)
    inst.components.container:Close()
    inst.AnimState:PlayAnimation("closed")
end

local function OnReplicated_revolved(inst)
    if inst.replica.container ~= nil then
        inst.replica.container:WidgetSetup("revolvedmoonlight")
    end
end
local function OnReplicated_revolved2(inst)
    if inst.replica.container ~= nil then
        inst.replica.container:WidgetSetup("revolvedmoonlight_pro")
    end
end
local function Fn_nameDetail_revolved(inst)
    return Fn_nameDetail(inst, times_revolved-1)
end
local function Fn_nameDetail_revolved2(inst)
    return Fn_nameDetail(inst, times_revolved_pro-1)
end

local function MakeRevolved(sets)
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
            LS_C_Init(inst, "revolvedmoonlight_item", true, "data_uppro", sets.name)
            InitLevelNet(inst, Fn_nameDetail_revolved2)
        else
            LS_C_Init(inst, "revolvedmoonlight_item", true, "data_up", sets.name)
            InitLevelNet(inst, Fn_nameDetail_revolved)
        end

        inst:AddTag("meteor_protection") --防止被流星破坏
        --因为有容器组件，所以不会被猴子、食人花、坎普斯等拿走
        inst:AddTag("nosteal") --防止被火药猴偷走
        inst:AddTag("NORATCHECK") --mod兼容：永不妥协。该道具不算鼠潮分
        inst:AddTag("moontreasure_l")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            inst.OnEntityReplicated = sets.ispro and OnReplicated_revolved2 or OnReplicated_revolved
            return inst
        end

        inst._owner_temp = nil
        inst._owner_light = nil

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = sets.name
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..sets.name..".xml"
        inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory_revolved)

        inst:AddComponent("container")
        inst.components.container:WidgetSetup(sets.name)
        inst.components.container.onopenfn = OnOpen_revolved
        inst.components.container.onclosefn = OnClose_revolved
        inst.components.container.skipclosesnd = true
        inst.components.container.skipopensnd = true

        inst:AddComponent("lootdropper")

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(5)
        inst.components.workable:SetOnWorkCallback(OnWork_revolved)
        inst.components.workable:SetOnFinishCallback(OnFinished_revolved)

        inst:AddComponent("upgradeable")
        inst.components.upgradeable.upgradetype = UPGRADETYPES.REVOLVED_L
        inst.components.upgradeable.onupgradefn = OnUpgradeFn
        inst.components.upgradeable.onstageadvancefn = OnStageUp_revolved
        inst.components.upgradeable.numstages = sets.ispro and times_revolved_pro or times_revolved
        inst.components.upgradeable.upgradesperstage = 1

        inst:AddComponent("rechargeable")
        -- inst.components.rechargeable:SetOnChargedFn(function(inst)end)

        inst.OnLoad = OnLoad_revolved

        --Create light
        inst._light = SpawnPrefab("heatrocklight")
        inst._light.Light:SetRadius(0.25)
        inst._light.Light:SetFalloff(0.7) --Tip：削弱系数：相同半径时，值越小会让光照范围越大
        inst._light.Light:SetColour(255/255, 242/255, 169/255)
        inst._light.Light:SetIntensity(0.75)
        inst._light.Light:Enable(true)
        TOOLS_L.ListenOwnerChange(inst, OnOwnerChange_revolved, OnRemove_revolved)

        if TUNING.FUNCTIONAL_MEDAL_IS_OPEN then
            SetImmortalable(inst, 2, nil)
        end

        return inst
    end, {
        Asset("ANIM", "anim/ui_chest_3x3.zip"), --官方的容器栏背景动画模板
        Asset("ANIM", "anim/ui_revolvedmoonlight_4x3.zip"),
        Asset("ANIM", "anim/revolvedmoonlight.zip"),
        Asset("ATLAS", "images/inventoryimages/"..sets.name..".xml"),
        Asset("IMAGE", "images/inventoryimages/"..sets.name..".tex"),
        Asset("ATLAS_BUILD", "images/inventoryimages/"..sets.name..".xml", 256)
    }, {
        "revolvedmoonlight_item",
        "yellowgem",
        "heatrocklight",
        "revolvedmoonlight_fx"
    }))
end

MakeRevolved({ name = "revolvedmoonlight" })
MakeRevolved({ name = "revolvedmoonlight_pro", ispro = true })

--------------------------------------------------------------------------
--[[ 月折宝剑 ]]
--------------------------------------------------------------------------

local atk_rf_buff = 40
local atk_rf = 10
local atk2_rf_buff = 20
local atk2_rf = 5
local atkmult_rf_hurt = 0.1
local atkmult_rf = 1
local bonus_rf = 1
local bonus_rf_buff = 1.2
local count_rf_max = 4

local lvls_refracted = {}
for i = 1, 14, 1 do
    lvls_refracted[i] = i*CONFIGS_LEGION.REFRACTEDUPDATETIMES/14
end

local function SetCount_refracted(inst, value)
    value = math.clamp(value, 0, count_rf_max)
    inst._count = value
    inst:PushEvent("percentusedchange", { percent = value/count_rf_max }) --界面需要一个百分比
    if value >= 1 then
        inst:AddTag("canmoonsurge_l")
        inst:RemoveTag("cansurge_l")
    elseif value > 0 then
        inst:RemoveTag("canmoonsurge_l")
        inst:AddTag("cansurge_l")
    else
        inst:RemoveTag("canmoonsurge_l")
        inst:RemoveTag("cansurge_l")
    end
end
local function SetAtk_refracted(inst)
    inst.components.weapon:SetDamage(math.floor( (inst._atk+inst._atk_lvl)*inst._atkmult ))
    inst.components.planardamage:SetBaseDamage(math.floor( (inst._atk_sp+inst._atk_sp_lvl)*inst._atkmult ))
end
local function SetLight_refracted(inst)
    if inst._lvl >= lvls_refracted[4] then
        inst._light.Light:SetRadius(inst._revolt_l and 4 or 1)
        EnableLight(inst._light)
    else
        DisableLight(inst._light)
    end
end
local function TrySetOwnerSymbol(inst, doer, revolt)
    if doer == nil then --因为此时有可能不再是装备状态，doer 发生了改变
        doer = inst.components.inventoryitem:GetGrandOwner()
    end
    if doer then
        if doer:HasTag("player") then
            if doer.components.health and doer.components.inventory then
                if inst == doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
                    doer.AnimState:OverrideSymbol("swap_object", inst._dd.build, revolt and "swap2" or "swap1")
                end
            end
        elseif doer:HasTag("equipmentmodel") then
            doer.AnimState:OverrideSymbol("swap_object", inst._dd.build, revolt and "swap2" or "swap1")
        end
    end
    if revolt then
        inst.components.inventoryitem.atlasname = inst._dd.img_atlas2
        inst.components.inventoryitem:ChangeImageName(inst._dd.img_tex2)
        inst.AnimState:PlayAnimation("idle2", true)
    else
        inst.components.inventoryitem.atlasname = inst._dd.img_atlas
        inst.components.inventoryitem:ChangeImageName(inst._dd.img_tex)
        inst.AnimState:PlayAnimation("idle", true)
    end
end
local function DoFxTask_refracted(inst)
    if inst._task_fx == nil then
        inst._task_fx = inst:DoPeriodicTask(0.7, function(inst)
            local owner = inst.components.inventoryitem:GetGrandOwner() or inst
            if owner:IsAsleep() then
                return
            end

            local fx = SpawnPrefab(inst._dd.fx or "refracted_l_spark_fx")
            if fx ~= nil then
                if not owner:HasTag("player") then
                    local xx, yy, zz = owner.Transform:GetWorldPosition()
                    fx.Transform:SetPosition(xx, yy+1.4, zz)
                    return
                end
                fx.entity:SetParent(owner.entity)
                if inst._equip_l then
                    fx.entity:AddFollower()
                    fx.Follower:FollowSymbol(owner.GUID, "swap_object", 10, -80, 0)
                else
                    fx.Transform:SetPosition(0, 1.4, 0)
                end
            end
        end, math.random())
    end
end
local function TriggerRevolt(inst, doer, doit)
    inst._revolt_l = doit
    if doit then
        if inst._dd.fxfn ~= nil then
            inst._dd.fxfn(inst)
        else
            DoFxTask_refracted(inst)
        end

        inst._atk = atk_rf_buff
        inst._atk_sp = atk2_rf_buff
        inst.components.damagetypebonus:AddBonus("shadow_aligned", inst, bonus_rf_buff, "moonsurge")

        if inst._lvl >= lvls_refracted[8] then
            inst.components.weapon:SetRange(2)
        else
            inst.components.weapon:SetRange(0)
        end

        TrySetOwnerSymbol(inst, doer, true)
    else
        if inst._task_fx ~= nil then
            inst._task_fx:Cancel()
            inst._task_fx = nil
        end
        if inst._dd.fxendfn ~= nil then
            inst._dd.fxendfn(inst)
        end

        inst._atk = atk_rf
        inst._atk_sp = atk2_rf
        inst.components.damagetypebonus:RemoveBonus("shadow_aligned", inst, "moonsurge")

        inst.components.weapon:SetRange(0)

        TrySetOwnerSymbol(inst, nil, false)
    end
    SetAtk_refracted(inst)
    SetLight_refracted(inst)
end
local function TryRevolt_refracted(inst, doer)
    if doer == nil then
        doer = inst.components.inventoryitem:GetGrandOwner()
    end
    if inst._count <= 0 then
        return 0
    elseif inst._count < 1 then
        if doer and doer.components.health and doer.components.health:GetPercent() < 1 then
            doer.components.health:DoDelta(20*inst._count, true, "debug_key", true, nil, true) --对旺达回血要特定原因才行
            SetCount_refracted(inst, 0)
        end
        return 1
    else
        SetCount_refracted(inst, inst._count - 1)
    end

    local time = 90
    if inst._lvl >= lvls_refracted[14] then
        local timeleft = inst.components.timer:GetTimeLeft("moonsurge") or 0
        if timeleft > 0 then
            time = math.min(time + timeleft, 480)
        end
    else
        if inst._lvl < lvls_refracted[2] then
            time = 30
        end
    end
    inst.components.timer:StopTimer("moonsurge")
    inst.components.timer:StartTimer("moonsurge", time)
    TriggerRevolt(inst, doer, true)

    return 2
end

local function OnEquip_refracted(inst, owner) --装备武器时
    owner.AnimState:OverrideSymbol("swap_object", inst._dd.build,
        inst.components.timer:TimerExists("moonsurge") and "swap2" or "swap1")
    owner.AnimState:Show("ARM_carry") --显示持物手
    owner.AnimState:Hide("ARM_normal") --隐藏普通的手
    inst._equip_l = true

    if owner:HasTag("equipmentmodel") then return end --假人

    owner:ListenForEvent("healthdelta", inst.fn_onHealthDelta)
    inst:ListenForEvent("attacked", inst.fn_onAttacked, owner)
    inst.fn_onHealthDelta(owner, nil)
    inst:DoTaskInTime(0, function() --需要主动更新一下，不然没反应
        inst:PushEvent("percentusedchange", { percent = inst._count/count_rf_max })
    end)
end
local function OnUnequip_refracted(inst, owner) --卸下武器时
    owner.AnimState:Hide("ARM_carry") --隐藏持物手
    owner.AnimState:Show("ARM_normal") --显示普通的手
    inst._equip_l = nil
    owner:RemoveEventCallback("healthdelta", inst.fn_onHealthDelta)
    inst:RemoveEventCallback("attacked", inst.fn_onAttacked, owner)
    if inst._atkmult == atkmult_rf_hurt then
        inst.fn_onHealthDelta(owner, { newpercent = 1 }) --卸下时，恢复武器默认攻击力，为了正常显示数值
    end
end
local function OnAttack_refracted(inst, owner, target)
    if not inst._revolt_l or inst._lvl >= lvls_refracted[10] then
        SetCount_refracted(inst, inst._count + (inst._lvl >= lvls_refracted[12] and 0.1 or 0.05))
    end
    if inst._lvl >= lvls_refracted[6] and inst._revolt_l then
        if target ~= nil and target:IsValid() then
            if inst._dd.atkfn ~= nil then
                inst._dd.atkfn(inst, owner, target, true)
            else
                local fx = SpawnPrefab(inst._dd.fx or "refracted_l_spark_fx")
                if fx ~= nil then
                    local xx, yy, zz = target.Transform:GetWorldPosition()
                    local x, y, z = TOOLS_L.GetCalculatedPos(xx, yy, zz, 0.1+math.random()*0.9, nil)
                    fx.Transform:SetPosition(x, y+math.random()*2, z)
                end
            end
        end
        if owner.components.health and owner.components.health:GetPercent() < 1 then
            owner.components.health:DoDelta(1.5, true, "debug_key", true, nil, true) --对旺达回血要特定原因才行
            return
        end
    else
        if inst._dd.atkfn ~= nil then
            if target ~= nil and target:IsValid() then
                inst._dd.atkfn(inst, owner, target)
            end
        end
    end
    if inst._atkmult == atkmult_rf_hurt then
        inst.fn_onHealthDelta(owner, nil)
    end
end

local function OnStageUp_refracted(inst)
    local lvl = inst.components.upgradeable:GetStage() - 1
    inst._lvl = lvl
    inst._lvl_l:set(lvl)
    inst.components.workable:SetWorkLeft(5)
    if lvl >= lvls_refracted[13] then
        inst._atk_lvl = 80
        inst._atk_sp_lvl = 60
    elseif lvl >= lvls_refracted[11] then
        inst._atk_lvl = 60
        inst._atk_sp_lvl = 60
    elseif lvl >= lvls_refracted[9] then
        inst._atk_lvl = 60
        inst._atk_sp_lvl = 40
    elseif lvl >= lvls_refracted[7] then
        inst._atk_lvl = 40
        inst._atk_sp_lvl = 40
    elseif lvl >= lvls_refracted[5] then
        inst._atk_lvl = 40
        inst._atk_sp_lvl = 20
    elseif lvl >= lvls_refracted[3] then
        inst._atk_lvl = 20
        inst._atk_sp_lvl = 20
    elseif lvl >= lvls_refracted[1] then
        inst._atk_lvl = 20
        inst._atk_sp_lvl = 0
    else
        inst._atk_lvl = 0
        inst._atk_sp_lvl = 0
        inst.components.workable:SetWorkable(false) --0级时不可以被锤
    end
    TriggerRevolt(inst, nil, inst._revolt_l or inst.components.timer:TimerExists("moonsurge"))
end
local function TimerDone_refracted(inst, data)
    if data.name == "moonsurge" then
        TriggerRevolt(inst, nil, false)
    end
end
local function OnOwnerChange_refracted(inst, owner, newowners)
    if owner:HasTag("pocketdimension_container") or owner:HasTag("buried") then
		inst._light.entity:SetParent(inst.entity)
		if not inst._light:IsInLimbo() then
			inst._light:RemoveFromScene() --直接隐藏，就算因为等级变化导致亮起来了也没事
		end
	else
		inst._light.entity:SetParent(owner.entity)
		if inst._light:IsInLimbo() then
			inst._light:ReturnToScene()
		end
	end
end
local function OnRemove_refracted(inst)
    inst._light:Remove()
end
local function OnWork_refracted(inst, worker, workleft, numworks)
    if worker == nil or not worker:HasTag("player") then --不能被非玩家破坏
        inst.components.workable:SetWorkLeft(5)
    end
end
local function OnFinished_refracted(inst, worker)
    --归还宝石
    DropGems(inst, "opalpreciousgem")

    --恢复数据
    inst.components.upgradeable:SetStage(1)
    OnStageUp_refracted(inst)

    --特效
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("stone")
end
local function Fn_nameDetail_refracted(inst)
    return Fn_nameDetail(inst, CONFIGS_LEGION.REFRACTEDUPDATETIMES)
end
local function OnSave_refracted(inst, data)
	if inst._count > 0 then
		data.count = inst._count
	end
end
local function OnLoad_refracted(inst, data)
	if data ~= nil then
		if data.count ~= nil then
			inst._count = data.count
		end
	end
    inst:DoTaskInTime(0.45, function(inst)
        SetCount_refracted(inst, inst._count)
        OnStageUp_refracted(inst)
    end)
end

table.insert(prefs, Prefab("refractedmoonlight", function()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity() --要在小地图上显示的话，记得加这句
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("refractedmoonlight")
    inst.AnimState:SetBuild("refractedmoonlight")
    inst.AnimState:PlayAnimation("idle", true)

    inst:AddTag("sharp") --武器的标签跟攻击方式跟攻击音效有关 没有特殊的话就用这两个
    inst:AddTag("pointy")
    inst:AddTag("irreplaceable") --防止被猴子、食人花、坎普斯等拿走，防止被流星破坏，并使其下线时会自动掉落
    inst:AddTag("nonpotatable") --这个貌似是？
    inst:AddTag("NORATCHECK") --mod兼容：永不妥协。该道具不算鼠潮分
    inst:AddTag("moontreasure_l")
    inst:AddTag("weapon")

    inst.MiniMapEntity:SetIcon("refractedmoonlight.tex")

    InitLevelNet(inst, Fn_nameDetail_refracted)

    LS_C_Init(inst, "refractedmoonlight", false)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    inst._dd = {
        img_tex = "refractedmoonlight", img_atlas = "images/inventoryimages/refractedmoonlight.xml",
        img_tex2 = "refractedmoonlight2", img_atlas2 = "images/inventoryimages/refractedmoonlight2.xml",
        build = "refractedmoonlight", fx = "refracted_l_spark_fx"
    }
    -- inst._equip_l = nil
    -- inst._task_fx = nil
    -- inst._revolt_l = nil
    inst._atk = atk_rf
    inst._atk_sp = atk2_rf
    inst._atk_lvl = 0
    inst._atk_sp_lvl = 0
    inst._atkmult = atkmult_rf
    inst._count = 0
    inst._lvl = 0
    inst.fn_onHealthDelta = function(owner, data)
        local percent = 0
        if data and data.newpercent then
            percent = 1 - data.newpercent
        else
            if owner.components.health ~= nil then
                percent = 1 - owner.components.health:GetPercent()
            end
        end
        if percent <= inst._count then
            inst._atkmult = atkmult_rf
        else
            inst._atkmult = atkmult_rf_hurt
        end
        SetAtk_refracted(inst)
    end
    inst.fn_onAttacked = function(owner, data)
        if inst._count > 0 then
            SetCount_refracted(inst, inst._count - 0.5)
        end
    end
    inst.fn_tryRevolt = TryRevolt_refracted
    inst.fn_doFxTask = DoFxTask_refracted

    inst:AddComponent("inspectable")

    inst:AddComponent("z_refractedmoonlight")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "refractedmoonlight"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/refractedmoonlight.xml"
    inst.components.inventoryitem:SetSinks(true) --落水时会下沉，但是因为标签的关系会回到绚丽大门

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(atk_rf)
    inst.components.weapon:SetOnAttack(OnAttack_refracted)

    inst:AddComponent("planardamage")
    inst.components.planardamage:SetBaseDamage(atk2_rf)

    inst:AddComponent("damagetypebonus")
    inst.components.damagetypebonus:AddBonus("shadow_aligned", inst, bonus_rf)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip_refracted)
    inst.components.equippable:SetOnUnequip(OnUnequip_refracted)

    inst:AddComponent("upgradeable")
    inst.components.upgradeable.upgradetype = UPGRADETYPES.REFRACTED_L
    inst.components.upgradeable.onupgradefn = OnUpgradeFn
    inst.components.upgradeable.onstageadvancefn = OnStageUp_refracted
    inst.components.upgradeable.numstages = CONFIGS_LEGION.REFRACTEDUPDATETIMES + 1 --因为初始等级为1
    inst.components.upgradeable.upgradesperstage = 1

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(5)
    inst.components.workable:SetOnWorkCallback(OnWork_refracted)
    inst.components.workable:SetOnFinishCallback(OnFinished_refracted)
    inst.components.workable:SetWorkable(false) --0级时不可以被锤

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", TimerDone_refracted)

    inst._light = SpawnPrefab("alterguardianhatlight")
    -- inst._light.Light:SetRadius(0.25)
    -- inst._light.Light:SetFalloff(0.7)
    inst._light.Light:SetColour(180/255, 195/255, 150/255)
    -- inst._light.Light:SetIntensity(0.75)
    inst._light.Light:Enable(false)
    TOOLS_L.ListenOwnerChange(inst, OnOwnerChange_refracted, OnRemove_refracted)

    MakeHauntableLaunch(inst)

    inst.OnSave = OnSave_refracted
    inst.OnLoad = OnLoad_refracted

    return inst
end, {
    Asset("ANIM", "anim/refractedmoonlight.zip"),
    Asset("ATLAS", "images/inventoryimages/refractedmoonlight.xml"),
    Asset("IMAGE", "images/inventoryimages/refractedmoonlight.tex"),
    Asset("ATLAS_BUILD", "images/inventoryimages/refractedmoonlight.xml", 256),
    Asset("ATLAS", "images/inventoryimages/refractedmoonlight2.xml"),
    Asset("IMAGE", "images/inventoryimages/refractedmoonlight2.tex"),
    Asset("ATLAS_BUILD", "images/inventoryimages/refractedmoonlight2.xml", 256)
}, {
    "refracted_l_spark_fx", "refracted_l_wave_fx",
    "refracted_l_skylight_fx", "refracted_l_light_fx",
    "alterguardianhatlight"
}))

--------------------
--------------------

return unpack(prefs)
