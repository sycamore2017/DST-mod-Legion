local assets_item =
{
    Asset("ANIM", "anim/hiddenmoonlight.zip"),
    Asset("ATLAS", "images/inventoryimages/hiddenmoonlight_item.xml"),
    Asset("IMAGE", "images/inventoryimages/hiddenmoonlight_item.tex"),
}

local prefabs_item =
{
    "hiddenmoonlight",
}

local function GetPerishRateMultiplier(inst, item)
    if item == nil then
        return
    end
    if item:HasTag("frozen") then
        return 0
    elseif inst.upgradetarget ~= nil then --盐箱是0.25，冰箱0.5。给盐盒就是0.15，给冰箱就是0.3
        if inst.upgradetarget == "icebox" then
            return 0.3
        elseif inst.upgradetarget == "saltbox" then
            return 0.15
        end
    end
    return 0.5
end

local function SetLoot(inst, targetprefab)
    inst.upgradetarget = targetprefab
    if inst.components.preserver ~= nil and inst.components.lootdropper ~= nil then
        if targetprefab == "icebox" then
            inst.components.lootdropper:SetChanceLootTable('hiddenmoonlight_ice')
        elseif targetprefab == "saltbox" then
            inst.AnimState:OverrideSymbol("base", "hiddenmoonlight", "saltbase")
            inst.components.lootdropper:SetChanceLootTable('hiddenmoonlight_salt')
        else
            inst.components.lootdropper:AddChanceLoot("hiddenmoonlight_item", 1)
        end
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

local function OnUpgrade(item, doer, target, result)
    if result.SoundEmitter ~= nil then
        result.SoundEmitter:PlaySound("dontstarve/common/place_structure_straw")
    end
    SetLoot(result, target.prefab)

    --将原箱子中的物品转移到新箱子中
    if target.components.container ~= nil and result.components.container ~= nil then
        target.components.container:Close() --强制关闭使用中的箱子
        target.components.container.canbeopened = false
        local allitems = target.components.container:RemoveAllItems()
        for i,v in ipairs(allitems) do
            result.components.container:GiveItem(v)
        end
    end

    item:Remove() --该道具是一次性的
    DoBenefit(result)
end

local function Fn_item()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hiddenmoonlight")
    inst.AnimState:SetBuild("hiddenmoonlight")
    inst.AnimState:PlayAnimation("idle_item")

    MakeInventoryFloatable(inst, "med", 0.3, 0.7)
    local OnLandedClient_old = inst.components.floater.OnLandedClient
    inst.components.floater.OnLandedClient = function(self)
        OnLandedClient_old(self)
        self.inst.AnimState:SetFloatParams(0.1, 1, self.bob_percent)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "hiddenmoonlight_item"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hiddenmoonlight_item.xml"

    inst:AddComponent("upgradekit")
    inst.components.upgradekit:SetData({
        icebox =
        {
            prefabresult = "hiddenmoonlight",
            onupgradefn = OnUpgrade,
        },
        saltbox =
        {
            prefabresult = "hiddenmoonlight",
            onupgradefn = OnUpgrade,
        }
    })

    MakeHauntableLaunchAndIgnite(inst)

    return inst
end

----------
----------

local assets =
{
    Asset("ANIM", "anim/ui_chest_3x3.zip"), --官方的箱子动画模板
    Asset("ANIM", "anim/ui_hiddenmoonlight_4x4.zip"),
    Asset("ANIM", "anim/hiddenmoonlight.zip"),
}

local prefabs =
{
    "collapse_small",
    "hiddenmoonlight_item",
    "chesterlight",
}

SetSharedLootTable('hiddenmoonlight_ice',
{
    {'hiddenmoonlight_item',   1.00},
    {'goldnugget',             1.00},
    {'gears',                  1.00},
    {'cutstone',               1.00},
})
SetSharedLootTable('hiddenmoonlight_salt',
{
    {'hiddenmoonlight_item',   1.00},
    {'saltrock',               1.00},
    {'saltrock',               1.00},
    {'saltrock',               1.00},
    {'saltrock',               1.00},
    {'saltrock',               1.00},
    {'bluegem',                1.00},
    {'cutstone',               1.00},
})

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

local function OnHammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    inst.components.container:DropEverything()

    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("stone")
    inst:Remove()
end

local function OnHit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.components.container:DropEverything()
    inst.AnimState:PushAnimation("closed", true)
    inst.components.container:Close()
end

local function OnSave(inst, data)
    if inst.upgradetarget ~= nil then
        data.upgradetarget = inst.upgradetarget
    end
    if not inst.canbenifit then
        data.canbenifit = false
    end
end

local function OnLoad(inst, data)
    if data ~= nil then
        if data.upgradetarget ~= nil then
            SetLoot(inst, data.upgradetarget)
        end
        if not data.canbenifit then
            inst.canbenifit = false
        end
    end
    DoBenefit(inst)
end

local function OnSnowCoveredChagned(inst, covered)
    if TheWorld.state.issnowcovered then
		inst.AnimState:OverrideSymbol("snow", "hiddenmoonlight", "snow")
	else
		inst.AnimState:OverrideSymbol("snow", "hiddenmoonlight", "emptysnow")
	end
end

local function Fn()
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
    inst.AnimState:OverrideSymbol("snow", "hiddenmoonlight", "emptysnow")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("hiddenmoonlight") end
        return inst
    end

    inst.upgradetarget = nil
    inst.canbenifit = true

    inst:AddComponent("inspectable")

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("hiddenmoonlight")
    inst.components.container.onopenfn = OnOpen
    inst.components.container.onclosefn = OnClose
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true

    inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(GetPerishRateMultiplier)

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(5)
    inst.components.workable:SetOnFinishCallback(OnHammered)
    inst.components.workable:SetOnWorkCallback(OnHit)

    inst:WatchWorldState("isfullmoon", DoBenefit)
    inst:ListenForEvent("onclose", DoBenefit)

    AddHauntableDropItemOrWork(inst)

    inst:WatchWorldState("issnowcovered", OnSnowCoveredChagned)
    inst:DoTaskInTime(0.3, function()
		OnSnowCoveredChagned(inst)
        inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
	end)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("hiddenmoonlight_item", Fn_item, assets_item, prefabs_item),
    Prefab("hiddenmoonlight", Fn, assets, prefabs)
