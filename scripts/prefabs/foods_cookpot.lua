local prefs = {}

--------------------------------------------------------------------------
--[[ 食物类料理 ]]
--------------------------------------------------------------------------

local prefabs = {
    "spoiled_food",
}

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

        if data.float ~= nil then
            MakeInventoryFloatable(inst, data.float[2], data.float[3], data.float[4])
            if data.float[1] ~= nil then
                local OnLandedClient_old = inst.components.floater.OnLandedClient
                inst.components.floater.OnLandedClient = function(self)
                    OnLandedClient_old(self)
                    self.inst.AnimState:SetFloatParams(data.float[1], 1, self.bob_percent)
                end
            end
        end

        if data.fn_common ~= nil then
            data.fn_common(inst)
        end

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst.food_symbol_build = data.overridebuild or realname

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

local function UpdateAxe(inst)
    local value = 61.2 * inst.components.perishable:GetPercent()
    value = Remap(value, 0, 61.2, 47.6, 61.2)
    inst.components.weapon:SetDamage(value)

    value = 1.66 * inst.components.perishable:GetPercent()
    value = Remap(value, 0, 1.66, 1.2, 1.66)
    inst.components.tool.actions[ACTIONS.CHOP] = value
end
local function AfterWorking(inst, data)
    if
        data.target and
        data.target.components.workable ~= nil and
        data.target.components.workable:CanBeWorked() and
        data.target.components.workable:GetWorkAction() == ACTIONS.CHOP and
        math.random() < 0.05
    then
        --TIP：事件机制会在发送者那边逻辑当前帧就处理完的。所以这里只需要设置关键变量 workleft=0 即可
        data.target.components.workable.workleft = 0
        if inst.components.talker ~= nil then
            inst.components.talker:Say(GetString(inst, "DESCRIBE", { "DISH_TOMAHAWKSTEAK", "CHOP" }))
        end
    end
end

table.insert(prefs, Prefab(
    "dish_tomahawksteak",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("dish_tomahawksteak")
        inst.AnimState:SetBuild("dish_tomahawksteak")
        inst.AnimState:PlayAnimation("idle")

        inst:AddTag("show_spoilage")
        inst:AddTag("icebox_valid")

        inst:AddTag("sharp")

        --tool (from tool component) added to pristine state for optimization
        inst:AddTag("tool")

        --weapon (from weapon component) added to pristine state for optimization
        inst:AddTag("weapon")

        MakeInventoryFloatable(inst, "small", 0.2, 0.75)
        -- local OnLandedClient_old = inst.components.floater.OnLandedClient
        -- inst.components.floater.OnLandedClient = function(self)
        --     OnLandedClient_old(self)
        --     self.inst.AnimState:SetFloatParams(0.15, 1, self.bob_percent)
        -- end

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = "dish_tomahawksteak"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/dish_tomahawksteak.xml"

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "boneshard"

        inst:AddComponent("tool")
        inst.components.tool:SetAction(ACTIONS.CHOP, 1.66)

        inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(61.2) --34x1.8
        inst.components.weapon:SetOnAttack(function(inst, owner, target)
            UpdateAxe(inst)
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
        end)

        inst:AddComponent("equippable")
        inst.components.equippable:SetOnEquip(function(inst, owner)
            UpdateAxe(inst)
            owner.AnimState:OverrideSymbol("swap_object", "dish_tomahawksteak", "swap")
            owner.AnimState:Show("ARM_carry")
            owner.AnimState:Hide("ARM_normal")
            owner:ListenForEvent("working", AfterWorking)
        end)
        inst.components.equippable:SetOnUnequip(function(inst, owner)
            UpdateAxe(inst)
            owner.AnimState:Hide("ARM_carry")
            owner.AnimState:Show("ARM_normal")
            owner:RemoveEventCallback("working", AfterWorking)
        end)

        inst.OnLoad = function(inst, data)
            UpdateAxe(inst)
        end

        MakeHauntableLaunchAndPerish(inst)

        return inst
    end, {
        Asset("ANIM", "anim/dish_tomahawksteak.zip"),
        Asset("ATLAS", "images/inventoryimages/dish_tomahawksteak.xml"),
        Asset("IMAGE", "images/inventoryimages/dish_tomahawksteak.tex"),
    },
    nil
))

----------
----------

for k, v in pairs(require("preparedfoods_legion")) do
    table.insert(prefs, MakePreparedFood(v))
end
for k, v in pairs(require("preparedfoods_l_spiced")) do
    table.insert(prefs, MakePreparedFood(v))
end

return unpack(prefs)
