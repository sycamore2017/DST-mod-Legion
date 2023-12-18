local TOOLS_L = require("tools_legion")

--------------------------------------------------------------------------
--[[ 靠背熊 ]]
--------------------------------------------------------------------------

local assets_backcub = {
    Asset("ANIM", "anim/backcub.zip"),
    Asset("ANIM", "anim/swap_backcub.zip"),
    Asset("ATLAS", "images/inventoryimages/backcub.xml"),
    Asset("IMAGE", "images/inventoryimages/backcub.tex"),
    Asset("ANIM", "anim/ui_piggyback_2x6.zip")
}
local prefabs_backcub = {
    "cookedsmallmeat",
    "furtuft"
}
local cycle_backcub = 10
local hunger_max_backcub = 300
local hungerrate_backcub = 50*cycle_backcub/TUNING.TOTAL_DAY_TIME
local stage_full_backcub = 0.9
local stage_3_backcub = 0.5
local stage_2_backcub = 0.2

local function SetHunger_backcub(inst, value)
    value = value + inst.hunger_l
    if value < 0 then
        value = 0
    elseif value > hunger_max_backcub then
        value = hunger_max_backcub
    end
    local percent = value/hunger_max_backcub
    if percent >= stage_3_backcub then
        inst.components.insulator:SetInsulation(TUNING.INSULATION_LARGE)
    elseif percent >= stage_2_backcub then
        inst.components.insulator:SetInsulation(TUNING.INSULATION_MED_LARGE)
    elseif percent > 0 then
        inst.components.insulator:SetInsulation(TUNING.INSULATION_SMALL)
    else
        inst.components.insulator:SetInsulation(TUNING.INSULATION_TINY)
    end
    inst:PushEvent("percentusedchange", { percent = percent }) --界面需要一个百分比
    inst.hunger_l = value
    return percent
end
local function SetHungerCount_backcub(inst, value)
    value = value + inst.count_hunger_l
    if value < 0 then
        value = 0
    elseif value >= 100 then
        value = value - 100
        local owner = inst.components.inventoryitem.owner or inst --它是背包，只判断一级就行
        TOOLS_L.SpawnStackDrop("furtuft", math.random(2), owner:GetPosition(), nil, nil, { dropper = inst })
    end
    inst.count_hunger_l = value
end
local function IsFull_backcub(inst)
    if not inst.buffon_l_bestappetite and inst.hunger_l/hunger_max_backcub > stage_full_backcub then
        return true
    end
    return false
end
local function OnEat_backcub(inst, food)
    local v = food.components.edible:GetHunger(inst) * inst.components.eater.hungerabsorption
                + food.components.edible:GetSanity(inst) * inst.components.eater.sanityabsorption
                + food.components.edible:GetHealth(inst) * inst.components.eater.healthabsorption
    if v > 0 then
        if food:HasTag("honeyed") then --蜜类料理加成
            v = v * 1.2
        end
        if not IsFull_backcub(inst) then
            local tempcpt = inst.components.inventoryitem.owner
            if
                tempcpt ~= nil and
                tempcpt.components.temperature ~= nil and
                (tempcpt.components.health == nil or not tempcpt.components.health:IsDead())
            then
                tempcpt = tempcpt.components.temperature
                if
                    tempcpt:GetCurrent() <= 10 or
                    (inst.dotemphelp_l and tempcpt:GetCurrent() < (tempcpt.overheattemp-5.1)) --太接近高温的话会有界面提示的
                then
                    tempcpt:SetTemperature( math.min(tempcpt:GetCurrent()+v*0.4, tempcpt.overheattemp-5.1) )
                    v = v * 0.6
                end
            end
        end
    end
    inst.dotemphelp_l = nil
    SetHunger_backcub(inst, v)
    if not inst:IsAsleep() then
        inst.SoundEmitter:PlaySound("dontstarve/HUD/feed")
    end
end
local function OnGround_backcub(inst)
    if inst.task_l_sound == nil then
        inst.task_l_sound = inst:DoPeriodicTask(4, function()
            inst.SoundEmitter:KillSound("sleep")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/monkey/sleep", "sleep")
        end, 0)
    end
end
local function ConsumeHunger_backcub(inst, value)
    --积累消耗值
    if inst.hunger_l >= value then
        SetHungerCount_backcub(inst, value)
    elseif inst.hunger_l > 0 then
        SetHungerCount_backcub(inst, inst.hunger_l)
    end

    local percent = SetHunger_backcub(inst, -value)
    local tempcpt = nil
    --装备者是否需要回温
    if not IsFull_backcub(inst) then
        tempcpt = inst.components.inventoryitem.owner
        if
            tempcpt ~= nil and
            tempcpt.components.temperature ~= nil and tempcpt.components.temperature:GetCurrent() <= 10 and
            (tempcpt.components.health == nil or not tempcpt.components.health:IsDead())
        then
            tempcpt = tempcpt.components.temperature
        else
            tempcpt = nil
        end
    end
    --偷吃食物
    if tempcpt ~= nil or percent < stage_2_backcub then --太饿了或者装备者需要回温
        local container = inst.components.container
        for i = container.numslots-1, container.numslots do --一次只吃最后两格的东西
            local item = container.slots[i]
            if item and inst.components.eater:CanEat(item) then
                inst.dotemphelp_l = tempcpt ~= nil
                inst.components.eater:Eat(item, nil)
                if tempcpt ~= nil and tempcpt:GetCurrent() < (tempcpt.overheattemp-5.1) then --尽量温度补满
                    if IsFull_backcub(inst) then --太饱了就不吃了
                        break
                    end
                elseif inst.hunger_l/hunger_max_backcub >= stage_2_backcub then --不饿了就不吃了
                    break
                end
            end
        end
    end
end
local function HungerCycle_backcub(inst)
    ConsumeHunger_backcub(inst, hungerrate_backcub)
end
local function OnEquip_backcub(inst, owner)
    local symbol = owner.prefab == "webber" and "swap_body_tall" or "swap_body"
    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.equip ~= nil then
        owner.AnimState:OverrideSymbol(symbol, skindata.equip.build, skindata.equip.file)
    else
        owner.AnimState:OverrideSymbol(symbol, "swap_backcub", "swap_body")
    end

    if inst.task_l_sound ~= nil then
        inst.task_l_sound:Cancel()
        inst.task_l_sound = nil
    end
    inst.SoundEmitter:KillSound("sleep")

    if owner:HasTag("equipmentmodel") then --假人！
        return
    end

    if inst.components.container ~= nil then
        inst.components.container:Open(owner)
    end
    inst:DoTaskInTime(0, function() --需要主动更新一下，不然没反应
        inst:PushEvent("percentusedchange", { percent = inst.hunger_l/hunger_max_backcub })
    end)
end
local function OnUnequip_backcub(inst, owner)
    if owner.prefab == "webber" then
        owner.AnimState:ClearOverrideSymbol("swap_body_tall")
    else
        owner.AnimState:ClearOverrideSymbol("swap_body")
    end

    if inst.components.container ~= nil then
        inst.components.container:Close(owner)
    end
end

local function OnBurnt_backcub(inst)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
        inst.components.container:Close()
    end
    SpawnPrefab("cookedsmallmeat").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end
local function OnIgnite_backcub(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = false
    end
end
local function OnExtinguish_backcub(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = true
    end
end
local function OnLongUpdate_backcub(inst, dt)
    if dt == nil or dt <= 0 then
        return
    end
    ConsumeHunger_backcub(inst, dt*50/TUNING.TOTAL_DAY_TIME) --将经过时间换算成所需消耗的饱食度
    if inst:IsAsleep() then
        inst.hungertime_l = GetTime()
    else
        inst.hungertime_l = nil
    end
end
local function OnSave_backcub(inst, data)
	if inst.hunger_l > 0 then
		data.hunger_l = inst.hunger_l
	end
    if inst.count_hunger_l > 0 then
		data.count_hunger_l = inst.count_hunger_l
	end
    if inst.hungertime_l ~= nil then
        data.hungertime_l = GetTime() - inst.hungertime_l
    end
end
local function OnLoad_backcub(inst, data)
	if data ~= nil then
		if data.hunger_l ~= nil then
			SetHunger_backcub(inst, data.hunger_l)
		end
        if data.count_hunger_l ~= nil then
			inst.count_hunger_l = data.count_hunger_l --这个就不初始化了
		end
        if data.hungertime_l ~= nil then
			local hungertime = data.hungertime_l --缓存一下，因为下一帧data就没有数据了
            inst:DoTaskInTime(1+math.random(), function(inst)
                OnLongUpdate_backcub(inst, hungertime)
            end)
		end
	end
end
local function OnEntityWake_backcub(inst)
    if inst.hungertime_l ~= nil then
        OnLongUpdate_backcub(inst, GetTime() - inst.hungertime_l)
        inst.hungertime_l = nil
    end
    if inst.task_l_hunger == nil then
        inst.task_l_hunger = inst:DoPeriodicTask(cycle_backcub, HungerCycle_backcub, cycle_backcub)
    end
end
local function OnEntitySleep_backcub(inst)
    if inst.task_l_hunger ~= nil then
        inst.task_l_hunger:Cancel()
        inst.task_l_hunger = nil
    end
    inst.hungertime_l = GetTime()
end

local function Fn_backcub()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("backcub.tex")

    MakeInventoryPhysics(inst)
    -- inst.Transform:SetScale(0.5, 0.5, 0.5) --一旦这里改变动画大小，会导致火焰燃烧特效也跟着变化

    inst.AnimState:SetBank("backcub")
    inst.AnimState:SetBuild("backcub")
    -- inst.AnimState:PlayAnimation("anim_water", true) --在海难的水里就用这个动画
    inst.AnimState:PlayAnimation("anim", true)

    inst:AddTag("backpack")
    inst:AddTag("NORATCHECK") --mod兼容：永不妥协。该道具不算鼠潮分
    inst:AddTag("handfed") --能在被携带时被喂食
    inst:AddTag("fedbyall") --使得能被所有玩家喂食(不然就只能局限于跟随者)
    inst:AddTag("eatsrawmeat")
    inst:AddTag("strongstomach")

    --inst.foleysound = "dontstarve/movement/foley/backpack"

    --漂浮动画与地面动画的修改
    -- MakeInventoryFloatable(inst, "small", 0, nil, false, -9)
    -- inst.components.floater.OnLandedClient = function(self) --取消掉进海里时生成的波纹特效
    --     self.showing_effect = true
    -- end
    -- local OnLandedServer_old = inst.components.floater.OnLandedServer
    -- inst.components.floater.OnLandedServer = function(self) --掉进海里时使用自己的水面动画
    --     OnLandedServer_old(self)
    --     inst.AnimState:PlayAnimation(self:IsFloating() and "anim_water" or "anim", true)
    -- end
    -- local OnNoLongerLandedServer_old = inst.components.floater.OnNoLongerLandedServer
    -- inst.components.floater.OnNoLongerLandedServer = function(self) --非待在海里时使用自己的陆地动画
    --     OnNoLongerLandedServer_old(self)
    --     inst.AnimState:PlayAnimation(self:IsFloating() and "anim_water" or "anim", true)
    -- end

    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:InitWithFloater("backcub")

    -- TOOLS_L.SetImmortalBox_common(inst) --勋章已经自动对所有带 "backpack" 标签的物品加了不朽兼容

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("backcub") end
        return inst
    end

    inst.hunger_l = 0
    inst.count_hunger_l = 0
    -- inst.hungertime_l = nil
    -- inst.dotemphelp_l = nil

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "backcub"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/backcub.xml"
    inst.components.inventoryitem.cangoincontainer = false

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(OnEquip_backcub)
    inst.components.equippable:SetOnUnequip(OnUnequip_backcub)

    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(TUNING.INSULATION_TINY)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("backcub")

    inst:AddComponent("eater")
    inst.components.eater:SetOnEatFn(OnEat_backcub)
    -- inst.components.eater:SetAbsorptionModifiers(1, 1, 1)
    inst.components.eater:SetCanEatRawMeat(true)
    inst.components.eater:SetStrongStomach(true)
    inst.components.eater:SetCanEatHorrible(true)

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    inst.components.burnable:SetOnBurntFn(OnBurnt_backcub)
    inst.components.burnable:SetOnIgniteFn(OnIgnite_backcub)
    inst.components.burnable:SetOnExtinguishFn(OnExtinguish_backcub)

    inst:ListenForEvent("ondropped", OnGround_backcub)
    OnGround_backcub(inst)
    inst.task_l_hunger = inst:DoPeriodicTask(cycle_backcub, HungerCycle_backcub, cycle_backcub)

    -- MakeHauntableLaunchAndDropFirstItem(inst) --不能被作祟

    inst.OnSave = OnSave_backcub
    inst.OnLoad = OnLoad_backcub
    inst.OnLongUpdate = OnLongUpdate_backcub
    inst.OnEntitySleep = OnEntitySleep_backcub
    inst.OnEntityWake = OnEntityWake_backcub

    inst.components.skinedlegion:SetOnPreLoad()

    -- TOOLS_L.SetImmortalBox_server(inst)

    return inst
end

-------------------------

local prefs = {
    Prefab("backcub", Fn_backcub, assets_backcub, prefabs_backcub)
}

return unpack(prefs)
