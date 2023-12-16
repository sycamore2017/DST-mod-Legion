local TOOLS_L = require("tools_legion")

--------------------------------------------------------------------------
--[[ 苔衣发卡 ]]
--------------------------------------------------------------------------

local assets_lichen = {
    Asset("ANIM", "anim/hat_lichen.zip"),
	Asset("ATLAS", "images/inventoryimages/hat_lichen.xml"),
    Asset("IMAGE", "images/inventoryimages/hat_lichen.tex")
}
local prefabs_lichen = {
    "lichenhatlight"
}

local function OnEquip_lichen(inst, owner)
    if inst._light == nil or not inst._light:IsValid() then
        inst._light = SpawnPrefab("lichenhatlight") --生成光源
        inst._light.entity:SetParent(owner.entity)  --给光源设置父节点
    end

    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.equip ~= nil then
        if skindata.equip.isopenhat then
            TOOLS_L.hat_on_opentop(inst, owner, skindata.equip.build, skindata.equip.file)
        else
            TOOLS_L.hat_on(inst, owner, skindata.equip.build, skindata.equip.file)
        end
        if skindata.equip.lightcolor ~= nil then
            local rgb = skindata.equip.lightcolor
            inst._light.Light:SetColour(rgb.r, rgb.g, rgb.b)
        end
    else
        TOOLS_L.hat_on_opentop(inst, owner, "hat_lichen", "swap_hat")
    end

    TOOLS_L.AddTag(owner, "ignoreMeat", inst.prefab) --添加忽略带着肉的标签

    local soundemitter = owner ~= nil and owner.SoundEmitter or inst.SoundEmitter
    soundemitter:PlaySound("dontstarve/common/minerhatAddFuel") --装备时的音效
end
local function OnUnequip_lichen(inst, owner)
    TOOLS_L.hat_off(inst, owner)

    TOOLS_L.RemoveTag(owner, "ignoreMeat", inst.prefab)
    if inst._light ~= nil then
        if inst._light:IsValid() then
            inst._light:Remove() --把光源移除
        end
        inst._light = nil
    end

    local soundemitter = owner ~= nil and owner.SoundEmitter or inst.SoundEmitter
    soundemitter:PlaySound("dontstarve/common/minerhatOut") --卸下时的音效
end

local function Fn_lichen()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hat_lichen")
    inst.AnimState:SetBuild("hat_lichen")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("hat")
    inst:AddTag("show_spoilage")
    inst:AddTag("icebox_valid")
    inst:AddTag("open_top_hat") --虽然这个标签作用于植物人的贴图切换，但我没看出来到底哪里变了

    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:InitWithFloater("hat_lichen")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst._light = nil

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_ONE_DAY*5)
    inst.components.perishable:StartPerishing()
    inst.components.perishable:SetOnPerishFn(inst.Remove)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "hat_lichen"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hat_lichen.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED
    inst.components.equippable:SetOnEquip(OnEquip_lichen)
    inst.components.equippable:SetOnUnequip(OnUnequip_lichen)

    inst:AddComponent("tradable")

    MakeHauntableLaunchAndPerish(inst)

    inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

local function Fn_lichenlight() --苔衣发卡的光源实体
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst:AddTag("FX")

    inst.Light:SetFalloff(0.4)  --衰减
    inst.Light:SetIntensity(.7) --亮度
    inst.Light:SetRadius(2)     --半径
    inst.Light:SetColour(237/255, 237/255, 209/255) --颜色，和灯泡花一样

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

--------------------------------------------------------------------------
--[[ 牛仔帽 ]]
--------------------------------------------------------------------------

local assets_cowboy = {
    Asset("ANIM", "anim/hat_cowboy.zip"),
	Asset("ATLAS", "images/inventoryimages/hat_cowboy.xml"),
    Asset("IMAGE", "images/inventoryimages/hat_cowboy.tex")
}
local COW_PERIOD = 10
local GAIN_DOMESTICATION = TUNING.BEEFALO_DOMESTICATION_GAIN_DOMESTICATION * 0.33 * COW_PERIOD

local function CowboyTaming(inst)
    if inst.mycowboy == nil or not inst.mycowboy:IsValid() then
        if inst.task_cowboy ~= nil then
            inst.task_cowboy:Cancel()
            inst.task_cowboy = nil
        end
        inst.mycowboy = nil
        return
    end

    --取消骑行时间限制(先取消，后面可以少触发一些官方逻辑)
    local mount = inst.mycowboy.components.rider ~= nil and inst.mycowboy.components.rider:GetMount() or nil
    if mount ~= nil then
        if
            mount._bucktask ~= nil and
            mount.components.domesticatable ~= nil and
            mount.components.domesticatable:IsDomesticated() --只对已驯化完成的坐骑有用
        then
            mount._bucktask:Cancel()
            mount._bucktask = nil
        end
        mount = nil
    end
    --范围提升驯化度
    local x, y, z = inst.mycowboy.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 20, nil, { "INLIMBO", "NOCLICK" }, { "player", "domesticatable" })
    for _, v in ipairs(ents) do
        if
            v.entity:IsVisible() and
            (v.components.health == nil or not v.components.health:IsDead())
        then
            if v.components.rider ~= nil then --玩家
                mount = v.components.rider:GetMount()
            elseif v.components.domesticatable ~= nil then --坐骑
                if v.components.domesticatable:GetDomestication() > 0 then --驯化度不能为0
                    mount = v
                end
            end
            if mount ~= nil and mount.components.domesticatable ~= nil then
                mount = mount.components.domesticatable
                if mount:GetDomestication() < 1 then
                    mount:DeltaDomestication(GAIN_DOMESTICATION)
                end
                if mount:GetObedience() < mount.maxobedience then
                    mount:DeltaObedience(0.2)
                end
            end
            mount = nil
        end
    end
end
local function OnUnequip_cowboyscarf(owner, data)
    if data ~= nil and data.eslot == EQUIPSLOTS.BODY then
        owner.AnimState:OverrideSymbol("swap_body", owner.scarf_skin_l or "hat_cowboy", "swap_body")
    end
end
local function OnMounted_cowboy(owner, data)
    TOOLS_L.AddTag(owner, "firmbody_l", "hat_cowboy")
end
local function OnDismounted_cowboy(owner, data)
    TOOLS_L.RemoveTag(owner, "firmbody_l", "hat_cowboy")
end
local function OnEquip_cowboy(inst, owner)
    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.equip ~= nil then
        TOOLS_L.hat_on(inst, owner, skindata.equip.build, skindata.equip.file)
        owner.scarf_skin_l = skindata.equip.build
    else
        TOOLS_L.hat_on(inst, owner, "hat_cowboy", "swap_hat")
        owner.scarf_skin_l = nil
    end

    if owner:HasTag("equipmentmodel") then --假人！
        return
    end

    if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end
    owner:AddTag("beefalo") --牛牛的标签，加入后不会被发情牛主动攻击
    if owner:HasTag("player") then
        if owner.components.inventory ~= nil then --与传统帽子不同的是，这个帽子会有红色牛仔围巾的套装效果
            if owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) == nil then --没穿衣服时，换上牛仔围巾
                owner.AnimState:OverrideSymbol("swap_body", owner.scarf_skin_l or "hat_cowboy", "swap_body")
            end
            owner:ListenForEvent("unequip", OnUnequip_cowboyscarf)
        end
    end
    if owner.components.rider ~= nil then
        owner:ListenForEvent("mounted", OnMounted_cowboy)
        owner:ListenForEvent("dismounted", OnDismounted_cowboy)
        if owner.components.rider:IsRiding() then
            OnMounted_cowboy(owner, nil)
        end
        TOOLS_L.AddTag(owner, "cowboy_l", inst.prefab)
    end

    if inst.task_cowboy ~= nil then
        inst.task_cowboy:Cancel()
    end
    inst.mycowboy = owner
    inst.task_cowboy = inst:DoPeriodicTask(COW_PERIOD, CowboyTaming, COW_PERIOD)
end
local function OnUnequip_cowboy(inst, owner)
    TOOLS_L.hat_off(inst, owner)
    owner.scarf_skin_l = nil

    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
    owner:RemoveTag("beefalo")
    if owner:HasTag("player") then
        if owner.components.inventory ~= nil then
            if owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) == nil then --没穿衣服时，去除牛仔围巾
                owner.AnimState:ClearOverrideSymbol("swap_body")
            end
        end
        owner:RemoveEventCallback("unequip", OnUnequip_cowboyscarf)
    end
    owner:RemoveEventCallback("mounted", OnMounted_cowboy)
    owner:RemoveEventCallback("dismounted", OnDismounted_cowboy)
    OnDismounted_cowboy(owner, nil)
    TOOLS_L.RemoveTag(owner, "cowboy_l", inst.prefab)

    if inst.task_cowboy ~= nil then
        inst.task_cowboy:Cancel()
        inst.task_cowboy = nil
    end
    inst.mycowboy = nil
end

local function Fn_cowboy()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hat_cowboy")
    inst.AnimState:SetBuild("hat_cowboy")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("hat")
    inst:AddTag("waterproofer")

    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:InitWithFloater("hat_cowboy")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    -- inst.mycowboy = nil

    inst:AddComponent("inspectable")

    inst:AddComponent("tradable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "hat_cowboy"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hat_cowboy.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED --和高礼帽一样的精神恢复
    inst.components.equippable.insulated = true --防电
    inst.components.equippable:SetOnEquip(OnEquip_cowboy)
    inst.components.equippable:SetOnUnequip(OnUnequip_cowboy)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_HUGE) --90%防水

    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(TUNING.INSULATION_MED) --2分钟
    inst.components.insulator:SetSummer() --设置为夏季后，就是延缓温度上升的效果了

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING.TOTAL_DAY_TIME*10) --10天的佩戴时间
    inst.components.fueled:SetDepletedFn(inst.Remove)

    MakeHauntableLaunch(inst)

    inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

-------------------------

local prefs = {
    Prefab("hat_lichen", Fn_lichen, assets_lichen, prefabs_lichen),
    Prefab("lichenhatlight", Fn_lichenlight),
    Prefab("hat_cowboy", Fn_cowboy, assets_cowboy)
}

return unpack(prefs)
