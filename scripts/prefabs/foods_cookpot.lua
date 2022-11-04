local prefs = {}

--------------------------------------------------------------------------
--[[ 食物类料理 ]]
--------------------------------------------------------------------------

local prefabs = {
    "spoiled_food"
}

local function MakeFoodFloatable(inst, float)
    if float ~= nil then
        MakeInventoryFloatable(inst, float[2], float[3], float[4])
        if float[1] ~= nil then
            local OnLandedClient_old = inst.components.floater.OnLandedClient
            inst.components.floater.OnLandedClient = function(self)
                OnLandedClient_old(self)
                self.inst.AnimState:SetFloatParams(float[1], 1, self.bob_percent)
            end
        end
    end
end

local function MakePreparedFood(data)
    local realname = data.basename or data.name
    local assets = {
        Asset("ANIM", "anim/"..(data.overridebuild or realname)..".zip"),
        Asset("ATLAS", "images/inventoryimages/"..realname..".xml"),
        Asset("IMAGE", "images/inventoryimages/"..realname..".tex"),
    }

    local spicename = data.spice ~= nil and string.lower(data.spice) or nil
    if spicename ~= nil then
        table.insert(assets, Asset("ANIM", "anim/spices.zip"))
        table.insert(assets, Asset("ANIM", "anim/plate_food.zip"))
        table.insert(assets, Asset("INV_IMAGE", spicename.."_over"))
    end

    local foodprefabs = prefabs
    if data.prefabs ~= nil then
        foodprefabs = shallowcopy(prefabs)
        for i, v in ipairs(data.prefabs) do
            if not table.contains(foodprefabs, v) then
                table.insert(foodprefabs, v)
            end
        end
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        if spicename ~= nil then
            inst.AnimState:SetBuild("plate_food")
            inst.AnimState:SetBank("plate_food")
            inst.AnimState:OverrideSymbol("swap_garnish", "spices", spicename)

            inst:AddTag("spicedfood")

            --设置作为背景的料理图
            inst.inv_image_bg = { atlas = "images/inventoryimages/"..realname..".xml", image = realname..".tex" }
        else
            inst.AnimState:SetBuild(data.overridebuild or realname)
            inst.AnimState:SetBank(data.overridebuild or realname)
        end
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:OverrideSymbol("swap_food", data.overridebuild or realname, realname)

        inst:AddTag("preparedfood")
        if data.tags then
            for i,v in pairs(data.tags) do
                inst:AddTag(v)
            end
        end

        if data.basename ~= nil then
            inst:SetPrefabNameOverride(data.basename)
            if data.spice ~= nil then
                inst.displaynamefn = function(inst)
                    return subfmt(STRINGS.NAMES[data.spice.."_FOOD"], { food = STRINGS.NAMES[string.upper(data.basename)] })
                end
            end
        end

        MakeFoodFloatable(inst, data.float)

        if data.fn_common ~= nil then
            data.fn_common(inst)
        end

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst.food_symbol_build = data.overridebuild or realname
        inst.food_basename = data.basename

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = data.health
        inst.components.edible.hungervalue = data.hunger
        inst.components.edible.foodtype = data.foodtype or FOODTYPE.GENERIC
        inst.components.edible.secondaryfoodtype = data.secondaryfoodtype or nil
        inst.components.edible.sanityvalue = data.sanity or 0
        inst.components.edible.temperaturedelta = data.temperature or 0
        inst.components.edible.temperatureduration = data.temperatureduration or 0
        inst.components.edible.nochill = data.nochill or nil
        inst.components.edible.spice = data.spice
        inst.components.edible:SetOnEatenFn(data.oneatenfn)

        inst:AddComponent("inspectable")
        inst.wet_prefix = data.wet_prefix

        inst:AddComponent("inventoryitem")
        if data.OnPutInInventory then
			inst:ListenForEvent("onputininventory", data.OnPutInInventory)
		end
        inst.components.inventoryitem.imagename = realname
        if spicename ~= nil then --官方调料过的料理
            inst.components.inventoryitem:ChangeImageName(spicename.."_over")
        elseif data.basename ~= nil then --不想用官方调料贴图的调料过的料理
            inst.components.inventoryitem:ChangeImageName(data.basename)
        else --普通料理
            --因为作为前景图的香料是官方的，所以只有这里需要设置自己的料理atlas
            inst.components.inventoryitem.atlasname = "images/inventoryimages/"..realname..".xml"
        end
        if data.float == nil then
            inst.components.inventoryitem:SetSinks(true)
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

		if data.perishtime ~= nil and data.perishtime > 0 then
			inst:AddComponent("perishable")
			inst.components.perishable:SetPerishTime(data.perishtime)
			inst.components.perishable:StartPerishing()
			inst.components.perishable.onperishreplacement = "spoiled_food"
		end

        if not data.noburnable then
            MakeSmallBurnable(inst)
            MakeSmallPropagator(inst)
        end

        MakeHauntableLaunchAndPerish(inst)

        inst:AddComponent("bait")

        inst:AddComponent("tradable")

        if data.fn_server ~= nil then
            data.fn_server(inst)
        end

        return inst
    end

    return Prefab(data.name, fn, assets, foodprefabs)
end

--------------------------------------------------------------------------
--[[ 物品类料理 ]]
--------------------------------------------------------------------------

------牛排战斧------

local prefabs_steak = { "boneshard" }

local function UpdateAxe(inst)
    local value
    if inst._damage then
        value = inst._damage[2] * inst.components.perishable:GetPercent()
        value = Remap(value, 0, inst._damage[2], inst._damage[1], inst._damage[2])
        inst.components.weapon:SetDamage(value)
    end
    if inst._chopvalue then
        value = inst._chopvalue[2] * inst.components.perishable:GetPercent()
        value = Remap(value, 0, inst._chopvalue[2], inst._chopvalue[1], inst._chopvalue[2])
        inst.components.tool.actions[ACTIONS.CHOP] = value
    end
end
local function AfterWorking(inst, data)
    if
        data.target and
        data.target.components.workable ~= nil and
        data.target.components.workable:CanBeWorked() and
        data.target.components.workable:GetWorkAction() == ACTIONS.CHOP and
        math.random() < (inst.steak_l_chop or 0.05)
    then
        --TIP：事件机制会在发送者那边逻辑当前帧就处理完的。所以这里只需要设置关键变量 workleft=0 即可
        data.target.components.workable.workleft = 0
        if inst.components.talker ~= nil then
            inst.components.talker:Say(GetString(inst, "DESCRIBE", { "DISH_TOMAHAWKSTEAK", "CHOP" }))
        end
    end
end
local function SingleFight(inst, owner, target)
    if target ~= nil then
        local hasenemy = false
        local x, y, z = owner.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, 16, { "_combat" }, {"NOCLICK", "INLIMBO", "player"})
        for _,v in ipairs(ents) do
            if
                v ~= target and v:IsValid()
                and v.components.health ~= nil and not v.components.health:IsDead()
                and v.components.combat ~= nil and v.components.combat.target == owner
            then
                v.components.combat:DropTarget(false)
                hasenemy = true
            end
        end
        if hasenemy and math.random() < 0.1 then
            if owner.components.talker ~= nil then
                owner.components.talker:Say(GetString(owner, "DESCRIBE", { "DISH_TOMAHAWKSTEAK", "ATK" }))
            end
        end
    end
end

local function OnEquip_steak(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "dish_tomahawksteak", "swap")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if inst._UpdateAxe then
        inst._UpdateAxe(inst)
    end

    if owner:HasTag("equipmentmodel") then --假人！
        return
    end

    owner:ListenForEvent("working", AfterWorking)
    owner.steak_l_chop = inst._chopchance
end
local function OnUnequip_steak(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    if inst._UpdateAxe then
        inst._UpdateAxe(inst)
    end
    owner:RemoveEventCallback("working", AfterWorking)
    owner.steak_l_chop = nil
end
local function OnAttack_steak(inst, owner, target)
    if inst._UpdateAxe then
        inst._UpdateAxe(inst)
    end
    SingleFight(inst, owner, target)
end

local function MakeSteak(data)
    local assets = {
        Asset("ANIM", "anim/dish_tomahawksteak.zip"),
        Asset("ATLAS", "images/inventoryimages/dish_tomahawksteak.xml"),
        Asset("IMAGE", "images/inventoryimages/dish_tomahawksteak.tex")
    }
    local basename = "dish_tomahawksteak"
    local prefabname = "dish_tomahawksteak"

    if data.spicename ~= nil then
        table.insert(assets, Asset("ANIM", "anim/spices.zip"))
        table.insert(assets, Asset("ANIM", "anim/plate_food.zip"))
        table.insert(assets, Asset("INV_IMAGE", data.spicename.."_over"))
        prefabname = prefabname.."_"..data.spicename
    end

    table.insert(prefs, Prefab(
        prefabname,
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddNetwork()

            MakeInventoryPhysics(inst)

            if data.spicename ~= nil then
                inst.AnimState:SetBuild("plate_food")
                inst.AnimState:SetBank("plate_food")
                inst.AnimState:OverrideSymbol("swap_garnish", "spices", data.spicename)

                inst:AddTag("spicedfood")

                --设置作为背景的料理图
                inst.inv_image_bg = { atlas = "images/inventoryimages/"..basename..".xml", image = basename..".tex" }

                inst:SetPrefabNameOverride(basename)
                inst.displaynamefn = function(inst)
                    return subfmt(
                        STRINGS.NAMES[string.upper(data.spicename).."_FOOD"],
                        { food = STRINGS.NAMES[string.upper(basename)] }
                    )
                end

                MakeFoodFloatable(inst, {nil, "med", 0.05, {0.8, 0.7, 0.8}})
            else
                inst.AnimState:SetBank(basename)
                inst.AnimState:SetBuild(basename)

                MakeInventoryFloatable(inst, "small", 0.2, 0.75)
            end
            inst.AnimState:PlayAnimation("idle")
            inst.AnimState:OverrideSymbol("swap_food", basename, "base")

            inst:AddTag("show_spoilage")
            inst:AddTag("icebox_valid")

            inst:AddTag("sharp")

            --tool (from tool component) added to pristine state for optimization
            inst:AddTag("tool")

            --weapon (from weapon component) added to pristine state for optimization
            inst:AddTag("weapon")

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst.food_symbol_build = basename
            inst.food_basename = data.spicename ~= nil and basename or nil

            inst._damage = nil --基础攻击力
            inst._chopvalue = nil --基础砍伐效率
            inst._chopchance = nil --直接砍倒树的几率
            inst._UpdateAxe = nil

            inst:AddComponent("inspectable")

            inst:AddComponent("inventoryitem")
            inst.components.inventoryitem.imagename = basename
            if data.spicename ~= nil then
                inst.components.inventoryitem:ChangeImageName(data.spicename.."_over")
            else
                inst.components.inventoryitem.atlasname = "images/inventoryimages/"..basename..".xml"
            end

            inst:AddComponent("perishable")
            inst.components.perishable.onperishreplacement = "boneshard"
            inst.components.perishable:SetPerishTime(data.perishtime)
            inst.components.perishable:StartPerishing()

            inst:AddComponent("tool")

            inst:AddComponent("weapon")
            inst.components.weapon:SetOnAttack(OnAttack_steak)

            inst:AddComponent("equippable")
            inst.components.equippable:SetOnEquip(OnEquip_steak)
            inst.components.equippable:SetOnUnequip(OnUnequip_steak)

            inst.OnLoad = function(inst, data)
                inst._UpdateAxe(inst)
            end

            MakeHauntableLaunchAndPerish(inst)

            if data.fn_server ~= nil then
                data.fn_server(inst)
            end

            return inst
        end, assets, prefabs_steak
    ))
end

------

MakeSteak({
    spicename = nil,
    perishtime = TUNING.PERISH_MED,
    fn_server = function(inst)
        inst._damage = { 47.6, 61.2 } --34x1.8
        inst._chopvalue = { 1.2, 1.66 }
        inst._chopchance = 0.05
        inst._UpdateAxe = UpdateAxe

        inst.components.tool:SetAction(ACTIONS.CHOP, inst._chopvalue[2])

        inst.components.weapon:SetDamage(inst._damage[2])
    end
})



----------
----------

for k, v in pairs(require("preparedfoods_legion")) do
    table.insert(prefs, MakePreparedFood(v))
end
for k, v in pairs(require("preparedfoods_l_spiced")) do
    table.insert(prefs, MakePreparedFood(v))
end

return unpack(prefs)
