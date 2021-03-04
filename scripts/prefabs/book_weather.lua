local assets =
{
    Asset("ANIM", "anim/book_weather.zip"),--放在地上的动画
    Asset("ANIM", "anim/swap_book_weather.zip"), --手上动画
    Asset("ATLAS", "images/inventoryimages/book_weather.xml"),
    Asset("IMAGE", "images/inventoryimages/book_weather.tex"),
}

local prefabs =
{
    "waterballoon_splash",
}

local function OnEquip(inst, owner) --装备武器时
    owner.AnimState:ClearOverrideSymbol("swap_object")  --清除上一把武器的贴图效果，因为一般武器卸下时都不清除贴图

    owner.AnimState:OverrideSymbol("book_open", "swap_book_weather", "book_open")
    owner.AnimState:OverrideSymbol("book_closed", "swap_book_weather", "book_closed")
    owner.AnimState:OverrideSymbol("book_open_pages", "swap_book_weather", "book_open_pages")

    owner:AddTag("ignorewet")
end

local function OnUnequip(inst, owner)   --放下武器时
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    --还原书的贴图
    owner.AnimState:OverrideSymbol("book_open", "player_actions_uniqueitem", "book_open")
    owner.AnimState:OverrideSymbol("book_closed", "player_actions_uniqueitem", "book_closed")
    owner.AnimState:OverrideSymbol("book_open_pages", "player_actions_uniqueitem", "book_open_pages")

    owner:RemoveTag("ignorewet")
end

local function onattack(inst, owner, target)
    if target ~= nil and target:IsValid() then
        SpawnPrefab("waterballoon_splash").Transform:SetPosition(target.Transform:GetWorldPosition())

        if inst.components.wateryprotection then
            inst.components.wateryprotection:SpreadProtection(target)
        end
    end
end

local function OnRead(inst, reader)
    reader.components.sanity:DoDelta(-TUNING.SANITY_LARGE)

    if inst.components.finiteuses then
        inst.components.finiteuses:Use(19)  --为了达到10次使用次数，每次读书应扣除20，读书时本身还要用1次，所以是19+1=20
    end

    if TheWorld.state.israining or TheWorld.state.issnowing then
        TheWorld:PushEvent("ms_forceprecipitation", false)
    else
        TheWorld:PushEvent("ms_forceprecipitation", true)
    end

    return true
end

local function OnPeruse(inst, reader)
    if reader.prefab == "wurt" then
        if TheWorld.state.israining or TheWorld.state.issnowing then --雨雪天时，书中全是关于放晴的字眼，沃特不喜欢
            reader.components.sanity:DoDelta(-TUNING.SANITY_LARGE)
            reader.components.talker:Say(GetString(reader, "ANNOUNCE_READ_BOOK","BOOK_WEATHER_SUNNY"))
        else                             --晴天时，书中全是关于下雨的字眼，沃特好喜欢
            reader.components.sanity:DoDelta(TUNING.SANITY_HUGE)
            reader.components.talker:Say(GetString(reader, "ANNOUNCE_READ_BOOK","BOOK_WEATHER_RAINY"))
        end
    else
        if reader.peruse_weather ~= nil then
            reader.peruse_weather(reader)
        end
        if reader.components.talker ~= nil then
            reader.components.talker:Say(GetString(reader, "ANNOUNCE_READ_BOOK","BOOK_WEATHER"))
        end
    end

    if inst.components.finiteuses then
        inst.components.finiteuses:Use(19)
    end

    return true
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("book_weather")
    inst.AnimState:SetBuild("book_weather")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("book") --加入book标签就能使攻击时使用人物的书本攻击的动画

    MakeInventoryFloatable(inst, "med", 0.1, 0.75)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "book_weather"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/book_weather.xml"

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(50) --设置伤害，如果为0会吸引不了仇恨、不触发被攻击动画
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("wateryprotection")
    inst.components.wateryprotection.extinguishheatpercent = TUNING.WATERBALLOON_EXTINGUISH_HEAT_PERCENT
    inst.components.wateryprotection.temperaturereduction = TUNING.WATERBALLOON_TEMP_REDUCTION
    inst.components.wateryprotection.witherprotectiontime = TUNING.WATERBALLOON_PROTECTION_TIME
    inst.components.wateryprotection.addwetness = TUNING.WATERBALLOON_ADD_WETNESS
    if TheNet:GetPVPEnabled() then
        inst.components.wateryprotection:AddIgnoreTag("ignorewet")  --PVP，防止使用者被打湿
    else
        inst.components.wateryprotection:AddIgnoreTag("player")  --PVE，防止所有玩家被打湿
    end

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(200)
    inst.components.finiteuses:SetUses(200)
    inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("book")
    inst.components.book.onread = OnRead
    inst.components.book.onperuse = OnPeruse

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("book_weather", fn, assets, prefabs)