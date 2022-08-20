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
    if not TheWorld.state.isfullmoon then
        inst.canbenifit = true
        return
    end

    if inst.components.container:IsOpen() then --打开时不进行
        return
    end

    if not inst.canbenifit then
        return
    end

    inst:DoTaskInTime(math.random() + 0.4, function()
        if inst.components.container:IsOpen() then --打开时不进行
            return
        end

        local items = inst.components.container:GetAllItems()
        local items_valid = {}
        if #items == 0 then
            return
        end
        for k,v in pairs(items) do
            if v ~= nil and v.components.perishable ~= nil then
                table.insert(items_valid, v)
            end
        end
        if #items_valid == 0 then
            return
        end
        inst.canbenifit = false

        local benifitnum = #items_valid
        benifitnum = benifitnum > 4 and 4 or benifitnum
        for i = 1, benifitnum do
            local benifititem = table.remove(items_valid, math.random(#items_valid))
            benifititem.components.perishable:SetPercent(1)
        end

        local fx = SpawnPrefab("chesterlight")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        fx:TurnOn()
        inst.SoundEmitter:PlaySound("dontstarve/creatures/chester/raise")
        inst:DoTaskInTime(1, function()
            if fx ~= nil then
                fx:TurnOff()
            end
        end)
    end)
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
    DoBenefit(result)
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
    inst.canbenifit = true

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
            return
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
        inst.components.container:DropEverything()
        inst.AnimState:PushAnimation("closed", true)
        inst.components.container:Close()
    end)
    inst.components.workable:SetOnFinishCallback(function(inst, worker)
        -- inst.components.lootdropper:DropLoot()
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

    inst:WatchWorldState("isfullmoon", DoBenefit)
    inst:ListenForEvent("onclose", DoBenefit)

    AddHauntableDropItemOrWork(inst)

    MakeSnowCovered_serv_legion(inst, 0.1 + 0.3 * math.random(), function(inst)
        inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
    end)

    inst.OnSave = function(inst, data)
        if inst.upgradetarget ~= nil then
            data.upgradetarget = inst.upgradetarget
        end
        if not inst.canbenifit then
            data.canbenifit = false
        end
    end
    inst.OnLoad = function(inst, data)
        if data ~= nil then
            if data.upgradetarget ~= nil then
                SetTarget_hidden(inst, data.upgradetarget)
            end
            if not data.canbenifit then
                inst.canbenifit = false
            end
        end
        DoBenefit(inst)
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
        Asset("IMAGE", "images/inventoryimages/revolvedmoonlight_item.tex"),
    },
    prefabs = { "revolvedmoonlight", "revolvedmoonlight_pro" },
    floatable = { 0.1, "med", 0.3, 0.7 },
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

local function MakeRevolved(sets)
    local widgetname = sets.ispro and "revolvedmoonlight_pro" or "revolvedmoonlight"
    table.insert(prefs, Prefab(sets.name, function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddLight()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("revolvedmoonlight")
        inst.AnimState:SetBuild("revolvedmoonlight")
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

        inst.Light:SetRadius(.6)
        inst.Light:SetFalloff(1)
        inst.Light:SetIntensity(.6)
        inst.Light:SetColour(255/255, 234/255, 116/255)
        inst.Light:Enable(true)

        MakeInventoryFloatable(inst, sets.floatable[2], sets.floatable[3], sets.floatable[4])
        if sets.floatable[1] ~= nil then
            local OnLandedClient_old = inst.components.floater.OnLandedClient
            inst.components.floater.OnLandedClient = function(self)
                OnLandedClient_old(self)
                self.inst.AnimState:SetFloatParams(sets.floatable[1], 1, self.bob_percent)
            end
        end

        -- if sets.fn_common ~= nil then
        --     sets.fn_common(inst)
        -- end

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup(widgetname) end
            return inst
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = sets.name
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..sets.name..".xml"

        inst:AddComponent("container")
        inst.components.container:WidgetSetup(widgetname)
        inst.components.container.onopenfn = OnOpen
        inst.components.container.onclosefn = OnClose
        inst.components.container.skipclosesnd = true
        inst.components.container.skipopensnd = true

        inst.OnSave = function(inst, data)
            if inst.upgradetarget ~= nil then
                data.upgradetarget = inst.upgradetarget
            end
            if not inst.canbenifit then
                data.canbenifit = false
            end
        end
        inst.OnLoad = function(inst, data)
            if data ~= nil then
                if data.upgradetarget ~= nil then
                    SetTarget_hidden(inst, data.upgradetarget)
                end
                if not data.canbenifit then
                    inst.canbenifit = false
                end
            end
        end

        if TUNING.SMART_SIGN_DRAW_ENABLE then
            SMART_SIGN_DRAW(inst)
        end

        -- if sets.fn_server ~= nil then
        --     sets.fn_server(inst)
        -- end

        return inst
    end, {
        Asset("ANIM", "anim/ui_chest_3x3.zip"), --官方的容器栏背景动画模板
        Asset("ANIM", "anim/ui_revolvedmoonlight_4x3.zip"),
        Asset("ANIM", "anim/revolvedmoonlight.zip")
    }, {
        "revolvedmoonlight_item"
    }))
end

MakeRevolved({
    name = "revolvedmoonlight",
    floatable = { 0.1, "med", 0.3, 0.7 },
    ispro = nil,
    -- fn_common = function(inst)end,
    -- fn_server = function(inst)end
})
MakeRevolved({
    name = "revolvedmoonlight_pro",
    floatable = { 0.1, "med", 0.3, 0.7 },
    ispro = true,
    -- fn_common = function(inst)end,
    -- fn_server = function(inst)end
})

--------------------
--------------------

return unpack(prefs)
