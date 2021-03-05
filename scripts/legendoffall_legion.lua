-- local prefabFiles = {
-- }

-- for k,v in pairs(prefabFiles) do
--     table.insert(PrefabFiles, v)
-- end

-----

local assets = {
    Asset("ANIM", "anim/mushroom_farm_cutlichen_build.zip"), --洞穴苔藓的蘑菇农场贴图
    Asset("ANIM", "anim/mushroom_farm_foliage1_build.zip"), --蕨叶(森林)的蘑菇农场贴图
    Asset("ANIM", "anim/mushroom_farm_foliage2_build.zip"), --蕨叶(洞穴)的蘑菇农场贴图
}

for k,v in pairs(assets) do
    table.insert(Assets, v)
end

-----

local _G = GLOBAL
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()

--------------------------------------------------------------------------
--[[ 基础 ]]
--------------------------------------------------------------------------

AddIngredientValues({"pineananas"}, {veggie=1, fruit=1}, true, false)

--------------------------------------------------------------------------
--[[ 让蘑菇农场能种植新东西 ]]
--------------------------------------------------------------------------

if IsServer then
    local newproducts = {
        cutlichen = { product = "cutlichen", produce = 4, },
        foliage = { product = "foliage", produce = 6, },
    }
    if TUNING.LEGION_FLASHANDCRUSH then
        newproducts["albicans_cap"] = { product = "albicans_cap", produce = 4, }
    end

    AddPrefabPostInit("mushroom_farm", function(inst)
        local AbleToAcceptTest_old = inst.components.trader.abletoaccepttest
        inst.components.trader:SetAbleToAcceptTest(function(farm, item, ...)
            if item ~= nil then
                if farm.remainingharvests == 0 then
                    if item.prefab == "shyerrylog" then
                        return true
                    end
                elseif newproducts[item.prefab] ~= nil then
                    return true
                end
            end
            return AbleToAcceptTest_old(farm, item, ...)
        end)

        local OnAccept_old = inst.components.trader.onaccept
        inst.components.trader.onaccept = function(farm, giver, item, ...)
            if farm.remainingharvests ~= 0 and newproducts[item.prefab] ~= nil then
                if farm.components.harvestable ~= nil then
                    local data = newproducts[item.prefab]
                    if item.prefab == "foliage" then
                        farm.AnimState:OverrideSymbol(
                            "swap_mushroom",
                            TheWorld:HasTag("cave") and "mushroom_farm_foliage2_build" or "mushroom_farm_foliage1_build",
                            "swap_mushroom"
                        )
                    else
                        farm.AnimState:OverrideSymbol("swap_mushroom", "mushroom_farm_"..data.product.."_build", "swap_mushroom")
                    end
                    farm.components.harvestable:SetProduct(data.product, data.produce)
                    farm.components.harvestable:SetGrowTime(TUNING.MUSHROOMFARM_FULL_GROW_TIME / data.produce)
                    farm.components.harvestable:Grow()

                    TheWorld:PushEvent("itemplanted", { doer = giver, pos = farm:GetPosition() }) --this event is pushed in other places too
                end
            else
                OnAccept_old(farm, giver, item, ...)
            end
        end

        local OnLoad_old = inst.OnLoad
        inst.OnLoad = function(farm, data)
            OnLoad_old(farm, data)
            if data ~= nil and not data.burnt and data.product ~= nil then
                for k,v in pairs(newproducts) do
                    if v.product == data.product then
                        if data.product == "foliage" then
                            farm.AnimState:OverrideSymbol(
                                "swap_mushroom",
                                TheWorld:HasTag("cave") and "mushroom_farm_foliage2_build" or "mushroom_farm_foliage1_build",
                                "swap_mushroom"
                            )
                        else
                            farm.AnimState:OverrideSymbol("swap_mushroom", "mushroom_farm_"..data.product.."_build", "swap_mushroom")
                        end
                        break
                    end
                end
            end
        end

    end)
end
