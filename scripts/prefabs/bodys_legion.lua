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

local function SetHunger_backcub(inst, value)
    value = value + inst.hunger_l
    if value < 0 then
        value = 0
    elseif value > hunger_max_backcub then
        value = hunger_max_backcub
    end
    local percent = value/hunger_max_backcub
    if math.floor(inst.hunger_l/hunger_max_backcub*100) ~= math.floor(percent*100) then --变化足够大时
        inst:PushEvent("perishchange", { percent = percent })
        if percent >= TUNING.PERISH_FRESH then
            inst.components.insulator:SetInsulation(TUNING.INSULATION_LARGE)
        elseif percent > TUNING.PERISH_STALE then
            inst.components.insulator:SetInsulation(TUNING.INSULATION_MED_LARGE)
        elseif percent > 0 then
            inst.components.insulator:SetInsulation(TUNING.INSULATION_SMALL)
        else
            inst.components.insulator:SetInsulation(TUNING.INSULATION_TINY)
        end
    end
    inst.hunger_l = value
    return percent
end
local function SetHungerCount_backcub(inst, value)
    value = value + inst.count_hunger_l
    if value < 0 then
        value = 0
    elseif value >= 100 then
        value = 0
        local owner = inst.components.inventoryitem.owner or inst --它是背包，只判断一级就行
        TOOLS_L.SpawnStackDrop("furtuft", math.random(2), owner:GetPosition(), nil, nil, { dropper = inst })
    end
    inst.count_hunger_l = value
end
local function OnEat_backcub(inst, food)
    local v = food.components.edible:GetHunger(inst) * inst.components.eater.hungerabsorption
                + food.components.edible:GetSanity(inst) * inst.components.eater.sanityabsorption
                + food.components.edible:GetHealth(inst) * inst.components.eater.healthabsorption
    if v > 0 and food:HasTag("honeyed") then
        v = v * 1.2
    end
    --根据情况来恢复undo
    SetHunger_backcub(inst, v)

    if inst:IsInLimbo() then
        inst.SoundEmitter:PlaySound("dontstarve/HUD/feed")
    else
        --undo 别的声音
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
local function ConsumeHunger_backcub(inst)
    --积累消耗值
    if inst.hunger_l >= hungerrate_backcub then
        SetHungerCount_backcub(inst, hungerrate_backcub)
    elseif inst.hunger_l > 0 then
        SetHungerCount_backcub(inst, inst.hunger_l)
    end

    local percent = SetHunger_backcub(inst, -hungerrate_backcub)
    local needhelp = false
    --装备者是否需要回温
    if percent <= stage_full_backcub then
        local owner = inst.components.inventoryitem.owner
        if
            owner ~= nil and
            owner.components.temperature ~= nil and owner.components.temperature:GetCurrent() <= 10 and
            (owner.components.health == nil or not owner.components.health:IsDead())
        then
            needhelp = true
        end
    end
    --偷吃食物
    if needhelp or percent <= TUNING.PERISH_STALE then --太饿了或者装备者需要回温
        local container = inst.components.container
        for i = container.numslots-1, container.numslots do --一次只吃最后两格的东西
            local item = container.slots[i]
            if item and inst.components.eater:CanEat(item) then
                inst.components.eater:Eat(item, nil)
                if needhelp then
                    if inst.hunger_l/hunger_max_backcub > stage_full_backcub then --太饱了就不吃了
                        break
                    end
                elseif inst.hunger_l/hunger_max_backcub > TUNING.PERISH_STALE then --不饿了就不吃了
                    break
                end
            end
        end
    end
end
local function Init_backcub(inst) --主要是为了显示新鲜度ui
    inst:PushEvent("perishchange", { percent = inst.hunger_l/hunger_max_backcub })
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
    inst:AddTag("show_spoilage")
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
    inst.task_l_hunger = inst:DoPeriodicTask(cycle_backcub, ConsumeHunger_backcub, cycle_backcub)
    -- inst.task_init = inst:DoTaskInTime(1+math.random(), Init_backcub)

    -- MakeHauntableLaunchAndDropFirstItem(inst) --不能被作祟

    inst.components.skinedlegion:SetOnPreLoad()

    -- TOOLS_L.SetImmortalBox_server(inst)

    return inst
end

-------------------------

local prefs = {
    Prefab("backcub", Fn_backcub, assets_backcub, prefabs_backcub)
}

return unpack(prefs)
