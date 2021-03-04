local function OnIgniteFn(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_fuse_LP", "hiss")
    DefaultBurnFn(inst)
end

local function OnExtinguishFn(inst)
    inst.SoundEmitter:KillSound("hiss")
    DefaultExtinguishFn(inst)
end

local function OnExplodeFn(inst)
    inst.SoundEmitter:KillSound("hiss")
    SpawnPrefab("explode_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

-----

local prefabs =
{
    "spoiled_food",
}

local function MakePreparedFood(data)
    local realname = data.basename or data.name
    local assets =
    {
        Asset("ANIM", "anim/"..realname..".zip"),
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

    local function DisplayNameFn(inst)
        return subfmt(STRINGS.NAMES[data.spice.."_FOOD"], { food = STRINGS.NAMES[string.upper(data.basename)] })
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        if data.name == "dish_frenchsnailsbaked" then    --法式焗蜗牛有声音
            inst.entity:AddSoundEmitter()
        end

        MakeInventoryPhysics(inst)

        if spicename ~= nil then
            inst.AnimState:SetBuild("plate_food")
            inst.AnimState:SetBank("plate_food")
            inst.AnimState:OverrideSymbol("swap_garnish", "spices", spicename)

            inst:AddTag("spicedfood")

            --设置作为背景的料理图
            inst.inv_image_bg = { atlas = "images/inventoryimages/"..realname..".xml", image = realname..".tex" }
        else
            inst.AnimState:SetBuild(realname)   --对于mod菜品，只能是一种菜品一个动画文件，所有名字全为该菜品的名字
            inst.AnimState:SetBank(realname)
        end
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:OverrideSymbol("swap_food", realname, realname)

        inst:AddTag("preparedfood")
        if data.tags then
            for i,v in pairs(data.tags) do
                inst:AddTag(v)
            end
        end

        if data.basename ~= nil then
            inst:SetPrefabNameOverride(data.basename)
            if data.spice ~= nil then
                inst.displaynamefn = DisplayNameFn
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

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

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

        if realname == "dish_frenchsnailsbaked" then    --法式焗蜗牛具有点燃爆炸效果
            MakeSmallBurnable(inst, 3 + math.random() * 3)  --延时着火
            inst.components.burnable:SetOnBurntFn(nil)
            inst.components.burnable:SetOnIgniteFn(OnIgniteFn)
            inst.components.burnable:SetOnExtinguishFn(OnExtinguishFn)

            inst:AddComponent("explosive")
            inst.components.explosive:SetOnExplodeFn(OnExplodeFn)
            inst.components.explosive.explosivedamage = TUNING.SLURTLESLIME_EXPLODE_DAMAGE
            inst.components.explosive.buildingdamage = 1
            inst.components.explosive.lightonexplode = false
        else
            MakeSmallBurnable(inst) --可点燃
        end
        MakeSmallPropagator(inst)

        MakeHauntableLaunchAndPerish(inst)

        inst:AddComponent("bait")

        inst:AddComponent("tradable")

        return inst
    end

    return Prefab(data.name, fn, assets, foodprefabs)
end

----------

local prefs = {}

for k, v in pairs(require("preparedfoods_legion")) do
    table.insert(prefs, MakePreparedFood(v))
end
for k, v in pairs(require("preparedfoods_particular")) do
    table.insert(prefs, MakePreparedFood(v))
end
for k, v in pairs(require("preparedfoods_spiced")) do
    table.insert(prefs, MakePreparedFood(v))
end

return unpack(prefs)
