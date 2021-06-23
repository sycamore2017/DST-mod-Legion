local prefabFiles = {
    "bush_flowers",             --花的灌木丛
    "rosorns",                  --玫瑰刺
    "lileaves",                 --蹄莲叶
    "orchitwigs",               --兰花絮
    "neverfade",                --永不凋零
    "sachet",                   --香包
    "neverfade_butterfly",      --永不凋零的蝴蝶
    "neverfade_shield",         --永不凋零的护盾
    "buff_butterflysblessing",  --蝴蝶庇佑的buff
}

if GLOBAL.CONFIGS_LEGION.FOLIAGEATHCHANCE > 0 then
    table.insert(PrefabFiles, "foliageath")  --青枝绿叶相关
end

for k,v in pairs(prefabFiles) do
    table.insert(PrefabFiles, v)
end

-----

local assets = {
    Asset("ATLAS", "images/inventoryimages/rosorns.xml"), --预加载，给科技栏用的
    Asset("IMAGE", "images/inventoryimages/rosorns.tex"),
    Asset("ATLAS", "images/inventoryimages/lileaves.xml"),
    Asset("IMAGE", "images/inventoryimages/lileaves.tex"),
    Asset("ATLAS", "images/inventoryimages/orchitwigs.xml"),
    Asset("IMAGE", "images/inventoryimages/orchitwigs.tex"),
    Asset("ATLAS", "images/inventoryimages/neverfade.xml"),
    Asset("IMAGE", "images/inventoryimages/neverfade.tex"),
    Asset("ATLAS", "images/inventoryimages/sachet.xml"),
    Asset("IMAGE", "images/inventoryimages/sachet.tex"),
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

AddIngredientValues({"petals_rose", "petals_lily", "petals_orchid"}, {veggie=.5, petals_legion=1}, false, false)

_G.RegistMiniMapImage_legion("rosebush")
_G.RegistMiniMapImage_legion("lilybush")
_G.RegistMiniMapImage_legion("orchidbush")
_G.RegistMiniMapImage_legion("neverfadebush")

AddRecipe("neverfade",
{
    Ingredient("rosorns", 1, "images/inventoryimages/rosorns.xml"),
    Ingredient("lileaves", 1, "images/inventoryimages/lileaves.xml"),
    Ingredient("orchitwigs", 1, "images/inventoryimages/orchitwigs.xml"),
}, 
RECIPETABS.MAGIC, TECH.MAGIC_THREE, nil, nil, nil, nil, nil, "images/inventoryimages/neverfade.xml", "neverfade.tex")

AddRecipe("sachet",
{
    Ingredient("petals_rose", 3, "images/inventoryimages/petals_rose.xml"),
    Ingredient("petals_lily", 3, "images/inventoryimages/petals_lily.xml"),
    Ingredient("petals_orchid", 3, "images/inventoryimages/petals_orchid.xml"),
}, 
RECIPETABS.DRESS, TECH.NONE, nil, nil, nil, nil, nil, "images/inventoryimages/sachet.xml", "sachet.tex")

--------------------------------------------------------------------------
--[[ 给三种花丛增加自然再生方式，防止绝种 ]]
--------------------------------------------------------------------------

if IsServer then
    local function onisraining(inst, israining) --每次下雨时尝试生成花丛
        if israining then
            local hasBush = false
            local flower = nil
            local x, y, z = inst.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x, y, z, 8) --检测周围物体

            for i, ent in ipairs(ents) do
                if ent.prefab == inst.bushCreater.name then
                    hasBush = true
                    break
                elseif ent.prefab == "flower" or ent.prefab == "flower_evil" or ent.prefab == "flower_rose" then
                    flower = ent   --获取花的实体
                end
            end

            if not hasBush and flower ~= nil then --周围没有花丛+有花，有几率把花变成花丛
                if math.random() < inst.bushCreater.chance then
                    local pos = flower:GetPosition()
                    local flowerbush = SpawnPrefab(inst.bushCreater.name)

                    if flowerbush ~= nil then
                        flower:Remove()
                        flowerbush.Transform:SetPosition(pos:Get())
                        --flowerbush.components.pickable:OnTransplant() --这样生成的是枯萎状态的
                    end
                end
            end
        end
    end

    AddPrefabPostInit("stagehand", function(inst)    --通过api重写桌之手的功能
        inst.bushCreater =
        {
            name = "rosebush",
            chance = 0.1,
        }

        inst:WatchWorldState("israining", onisraining)  --监听天气状态，刚下雨时、雨停时都会触发函数，就是说总共会触发两次
        onisraining(inst, TheWorld.state.israining)  --只有这两个参数，不能多加，多加没用
    end)

    AddPrefabPostInit("gravestone", function(inst)    --通过api重写墓碑的功能
        inst.bushCreater =
        {
            name = "orchidbush",
            chance = 0.01,
        }

        inst:WatchWorldState("israining", onisraining)
        onisraining(inst, TheWorld.state.israining)
    end)

    AddPrefabPostInit("pond", function(inst)    --通过api重写青蛙池塘的功能
        inst.bushCreater =
        {
            name = "lilybush",
            chance = 0.03,
        }

        inst:WatchWorldState("israining", onisraining)
        onisraining(inst, TheWorld.state.israining)
    end)
end

--------------------------------------------------------------------------
--[[ 青枝绿叶的修改 ]]
--------------------------------------------------------------------------

--入鞘，修改给予动作的名称
local give_strfn_old = ACTIONS.GIVE.strfn
ACTIONS.GIVE.strfn = function(act)
    if act.target ~= nil and act.target:HasTag("swordscabbard") then
        return "SCABBARD"
    end
    return give_strfn_old(act)
end

--给给予动作加入短动画
AddStategraphPostInit("wilson", function(sg)
    for k, v in pairs(sg.actionhandlers) do
        if v["action"]["id"] == "GIVE" then
            local SGWilson_give_handler_fn = v.deststate

            v.deststate = function(inst, action)
                --入鞘使用短动作
                if action.invobject ~= nil and action.target ~= nil and action.target:HasTag("swordscabbard") then
                    return "doshortaction"
                end
                return SGWilson_give_handler_fn(inst, action)
            end

            break
        end
    end
end)

--出鞘action
local PULLOUTSWORD = Action({ priority = 2, mount_valid = true })
PULLOUTSWORD.id = "PULLOUTSWORD"
PULLOUTSWORD.str = STRINGS.ACTIONS_LEGION.PULLOUTSWORD
PULLOUTSWORD.fn = function(act)
    local obj = act.target or act.invobject

    if obj ~= nil and obj.components.swordscabbard ~= nil then
        obj.components.swordscabbard:BreakUp(act.doer)
        return true
    end
end
AddAction(PULLOUTSWORD)

--往具有某组件的物品添加动作的检测函数，如果满足条件，就向人物的动作可执行表中加入某个动作。right表示是否是右键动作
AddComponentAction("INVENTORY", "swordscabbard", function(inst, doer, actions, right)
    if doer.replica.inventory:GetActiveItem() ~= inst and inst:HasTag("swordscabbardcouple") then
        table.insert(actions, ACTIONS.PULLOUTSWORD)
    end
end)
AddComponentAction("SCENE", "swordscabbard", function(inst, doer, actions, right)
    if right and inst:HasTag("swordscabbardcouple") then
        table.insert(actions, ACTIONS.PULLOUTSWORD)
    end
end)

--将一个动作与state绑定
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.PULLOUTSWORD, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.PULLOUTSWORD, "doshortaction"))

if IsServer then
    if CONFIGS_LEGION.FOLIAGEATHCHANCE > 0 then
        --砍冬青树有几率掉青枝绿叶
        local trees =
        {
            "evergreen_sparse",
            "evergreen_sparse_normal",
            "evergreen_sparse_tall",
            "evergreen_sparse_short",
        }
        for k,v in pairs(trees) do
            AddPrefabPostInit(v, function(inst)
                if inst.components.workable ~= nil then
                    local onfinish_old = inst.components.workable.onfinish
                    inst.components.workable:SetOnFinishCallback(function(inst, chopper)
                        if inst.components.lootdropper ~= nil then
                            if math.random() < CONFIGS_LEGION.FOLIAGEATHCHANCE then
                                inst.components.lootdropper:SpawnLootPrefab("foliageath")
                            end
                        end
                        if onfinish_old ~= nil then
                            onfinish_old(inst, chopper)
                        end
                    end)
                end
            end)
        end
    end

end
