local _G = GLOBAL
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()

--------------------------------------------------------------------------
--[[ 修改基础函数以给生物添加触电组件 ]]
--------------------------------------------------------------------------

local function CanShockable(inst)
    return (inst:HasTag("player")
           or inst:HasTag("character")
           or inst:HasTag("hostile")
           or inst:HasTag("smallcreature")
           or inst:HasTag("largecreature")
           or inst:HasTag("animal")
           or inst:HasTag("monster"))
           and not inst:HasTag("shadowcreature")    --暗影生物不会被触电
           and not inst:HasTag("electrified")       --电气生物不会被触电
           and not inst:HasTag("lightninggoat")     --电羊不会被触电
end
local function AddShockable(inst, level)
    if not CanShockable(inst) then
        return
    end
    local symbol = nil
    local x, y, z = 0, 0, 0
    local cpt = inst.components.burnable
    if cpt ~= nil then
        for _, v in pairs(cpt.fxdata) do
            if v.follow ~= nil then
                symbol = v.follow
                -- level = cpt.fxlevel
                x = v.x
                y = v.y
                z = v.z
                break
            end
        end
    end
    if symbol == nil or symbol == "" then
        cpt = inst.components.freezable
        if cpt ~= nil then
            for _, v in pairs(cpt.fxdata) do
                if v.follow ~= nil then
                    symbol = v.follow
                    -- level = cpt.fxlevel
                    x = v.x
                    y = v.y
                    z = v.z
                    break
                end
            end
        end
        if symbol == nil or symbol == "" then
            cpt = inst.components.combat
            if cpt ~= nil then
                symbol = cpt.hiteffectsymbol
            end
        end
    end
    if inst.components.shockable == nil then
        inst:AddComponent("shockable")
    end
    if z == 0 then
        z = 1
    end
    inst.components.shockable:InitStaticFx(symbol, Vector3(x or 0, y or 0, z), level or 1)
end

local MakeSmallBurnableCharacter_old = MakeSmallBurnableCharacter
_G.MakeSmallBurnableCharacter = function(inst, sym, offset)
    local burnable, propagator = MakeSmallBurnableCharacter_old(inst, sym, offset)
    AddShockable(inst, 1)
    return burnable, propagator
end

local MakeMediumBurnableCharacter_old = MakeMediumBurnableCharacter
_G.MakeMediumBurnableCharacter = function(inst, sym, offset)
    local burnable, propagator = MakeMediumBurnableCharacter_old(inst, sym, offset)
    AddShockable(inst, 2)
    return burnable, propagator
end

local MakeLargeBurnableCharacter_old = MakeLargeBurnableCharacter
_G.MakeLargeBurnableCharacter = function(inst, sym, offset)
    local burnable, propagator = MakeLargeBurnableCharacter_old(inst, sym, offset)
    AddShockable(inst, 3)
    return burnable, propagator
end

local MakeTinyFreezableCharacter_old = MakeTinyFreezableCharacter
_G.MakeTinyFreezableCharacter = function(inst, sym, offset)
    local freezable = MakeTinyFreezableCharacter_old(inst, sym, offset)
    AddShockable(inst, 1)
    return freezable
end

local MakeSmallFreezableCharacter_old = MakeSmallFreezableCharacter
_G.MakeSmallFreezableCharacter = function(inst, sym, offset)
    local freezable = MakeSmallFreezableCharacter_old(inst, sym, offset)
    AddShockable(inst, 1)
    return freezable
end

local MakeMediumFreezableCharacter_old = MakeMediumFreezableCharacter
_G.MakeMediumFreezableCharacter = function(inst, sym, offset)
    local freezable = MakeMediumFreezableCharacter_old(inst, sym, offset)
    AddShockable(inst, 2)
    return freezable
end

local MakeLargeFreezableCharacter_old = MakeLargeFreezableCharacter
_G.MakeLargeFreezableCharacter = function(inst, sym, offset)
    local freezable = MakeLargeFreezableCharacter_old(inst, sym, offset)
    AddShockable(inst, 2)
    return freezable
end

local MakeHugeFreezableCharacter_old = MakeHugeFreezableCharacter
_G.MakeHugeFreezableCharacter = function(inst, sym, offset)
    local freezable = MakeHugeFreezableCharacter_old(inst, sym, offset)
    AddShockable(inst, 3)
    return freezable
end

------
------

if not IsServer then --后面的是针对服务器的修改，客户端不需要
    return
end

--------------------------------------------------------------------------
--[[ 给三种花丛增加自然再生方式，防止绝种 ]]
--------------------------------------------------------------------------

local function onisraining(inst, israining) --每次下雨时尝试生成花丛
    if math.random() >= inst.bushCreater.chance then
        return
    end

    local flower = nil
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 8, nil, { "NOCLICK", "FX", "INLIMBO" }) --检测周围物体
    for _, ent in ipairs(ents) do
        if ent.prefab == inst.bushCreater.name then
            return
        elseif ent.prefab == "flower" or ent.prefab == "flower_evil" or ent.prefab == "flower_rose" then
            flower = ent --获取花的实体
        end
    end
    if flower ~= nil then --周围没有花丛+有花
        local pos = flower:GetPosition()
        local flowerbush = SpawnPrefab(inst.bushCreater.name)
        if flowerbush ~= nil then
            flower:Remove()
            flowerbush.Transform:SetPosition(pos:Get())
            --flowerbush.components.pickable:OnTransplant() --这样生成的是枯萎状态的
        end
    end
end
AddPrefabPostInit("gravestone", function(inst) --通过api重写墓碑的功能
    inst.bushCreater = { name = "orchidbush", chance = 0.01 }
    inst:WatchWorldState("israining", onisraining)
end)
AddPrefabPostInit("pond", function(inst) --通过api重写青蛙池塘的功能
    inst.bushCreater = { name = "lilybush", chance = 0.03 }
    inst:WatchWorldState("israining", onisraining)
end)

local function OnDeath_hedge(inst)
    local dropnum = 0
    if TheWorld then
        if TheWorld.deathcount_l_hedgehound == nil then
            TheWorld.deathcount_l_hedgehound = 1
        else
            TheWorld.deathcount_l_hedgehound = TheWorld.deathcount_l_hedgehound + 1
            if TheWorld.deathcount_l_hedgehound >= 6 then
                dropnum = 1
                TheWorld.deathcount_l_hedgehound = nil
            end
        end
    end
    if math.random() < 0.1 then
        dropnum = dropnum + 1
    end
    if dropnum > 0 then
        for i = 1, dropnum, 1 do
            local loot = SpawnPrefab("cutted_rosebush")
            if loot ~= nil then
                inst.components.lootdropper:FlingItem(loot)
            end
        end
    end
end
AddPrefabPostInit("hedgehound", function(inst)
    inst:ListenForEvent("death", OnDeath_hedge)
end)

--------------------------------------------------------------------------
--[[ 青枝绿叶的修改 ]]
--------------------------------------------------------------------------

------掉落物设定

if _G.CONFIGS_LEGION.FOLIAGEATHCHANCE > 0 then
    --砍臃肿常青树有几率掉青枝绿叶
    local trees = {
        "evergreen_sparse",
        "evergreen_sparse_normal",
        "evergreen_sparse_tall",
        "evergreen_sparse_short"
    }
    local function OnFinish_evergreen_sparse(inst, chopper)
        if inst.components.lootdropper ~= nil then
            if math.random() < CONFIGS_LEGION.FOLIAGEATHCHANCE then
                inst.components.lootdropper:SpawnLootPrefab("foliageath")
            end
        end
        if inst.components.workable.onfinish_l ~= nil then
            inst.components.workable.onfinish_l(inst, chopper)
        end
    end
    local function FnSet_evergreen(inst)
        if inst.components.workable ~= nil then
            inst.components.workable.onfinish_l = inst.components.workable.onfinish
            inst.components.workable:SetOnFinishCallback(OnFinish_evergreen_sparse)
        end
    end
    for _,v in pairs(trees) do
        AddPrefabPostInit(v, FnSet_evergreen)
    end
    trees = nil

    --臃肿常青树的树精有几率掉青枝绿叶
    local function OnDeath_leif_sparse(inst, data)
        if inst.components.lootdropper ~= nil then
            if math.random() < 10*CONFIGS_LEGION.FOLIAGEATHCHANCE then
                inst.components.lootdropper:SpawnLootPrefab("foliageath")
            end
        end
    end
    AddPrefabPostInit("leif_sparse", function(inst)
        inst:ListenForEvent("death", OnDeath_leif_sparse)
    end)
end

------让某些官方物品能入鞘

local foliageath_data_hambat = {
    image = "foliageath_hambat", atlas = "images/inventoryimages/foliageath_hambat.xml",
    bank = nil, build = nil, anim = "hambat", isloop = nil
}
local foliageath_data_bullkelp = {
    image = "foliageath_bullkelp_root", atlas = "images/inventoryimages/foliageath_bullkelp_root.xml",
    bank = nil, build = nil, anim = "bullkelp_root", isloop = nil
}
AddPrefabPostInit("hambat", function(inst)
    inst.foliageath_data = foliageath_data_hambat
end)
AddPrefabPostInit("bullkelp_root", function(inst)
    inst.foliageath_data = foliageath_data_bullkelp
end)

--------------------------------------------------------------------------
--[[ 修改鱼人，使其可以掉落鱼鳞 ]]
--------------------------------------------------------------------------

AddPrefabPostInit("merm", function(inst)
    if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:AddChanceLoot("merm_scales", 0.1)
    end
end)
AddPrefabPostInit("mermguard", function(inst)
    if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:AddChanceLoot("merm_scales", 0.1)
    end
end)



