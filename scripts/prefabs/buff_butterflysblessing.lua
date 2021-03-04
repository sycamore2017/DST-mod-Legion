local prefabs =
{
    "neverfade_butterfly",
}

----------

local function GetSpawnPoint(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local rad = math.random(1, 3)
    local angle = math.random() * 2 * PI

    return x + rad * math.cos(angle), y, z - rad * math.sin(angle)
end

local function SpawnButterfly(target)
    local butterfly = SpawnPrefab("neverfade_butterfly")
    if target.components.leader ~= nil then
        target.components.leader:AddFollower(butterfly)
        butterfly.Transform:SetPosition(GetSpawnPoint(target))
        return butterfly
    end
    return nil
end

local function AddButterfly(buff, player)
    buff.countbutterflies = buff.countbutterflies + 1
    buff.blessingbutterflies[buff.countbutterflies] = SpawnButterfly(player)
    player.countblessing = buff.countbutterflies --更新玩家的数据
end

local function DeleteButterfly(buff, player)
    if buff.blessingbutterflies[buff.countbutterflies] ~= nil then
        buff.blessingbutterflies[buff.countbutterflies].dead = true
        buff.blessingbutterflies[buff.countbutterflies] = nil
    end
    buff.countbutterflies = buff.countbutterflies - 1
    player.countblessing = buff.countbutterflies --更新玩家的数据

    if buff.countbutterflies <= 0 then
        buff.components.debuff:Stop()
    end
end

local function RegisterRedirectDamageFn(buff, player) --登记自己的redirectdamagefn函数
    --初始化
    if player.redirect_table == nil then
        player.redirect_table = {}
    end
    --登记庇佑的函数
    if player.redirect_table[buff.prefab] == nil then
        player.redirect_table[buff.prefab] = function(victim, attacker, damage, weapon, stimuli)
            if damage > 0 or stimuli == "electric" or stimuli == "darkness" then --骑牛也可以发动效果，爱屋及乌
                if buff.countbutterflies > 0 then
                    local redirect = buff.blessingbutterflies[buff.countbutterflies]
                    DeleteButterfly(buff, victim)
                    return redirect
                end
            end
            return nil
        end
    end
end

----------

local function OnAttached(inst, target) --增
    inst.entity:SetParent(target.entity)
    inst.Transform:SetPosition(0, 0, 0) --in case of loading

    if inst.precount ~= nil then
        for i = 1, inst.precount do
            AddButterfly(inst, target)
        end
        inst.precount = nil
    else
        AddButterfly(inst, target)
    end

    RebuildRedirectDamageFn(target) --全局函数：重新构造combat的redirectdamagefn函数
    RegisterRedirectDamageFn(inst, target)

    inst:ListenForEvent("death", function()
        inst.components.debuff:Stop()
    end, target)
end

local function OnExtended(inst, target) --续
    AddButterfly(inst, target) --在这个文件里并不限制增加的数量，是否要增加数量只在生成方那边判断，不在这边的响应方进行
end

local function OnDetached(inst, target) --删
    --清除自己的redirectdamagefn函数
    if target.redirect_table ~= nil then
        target.redirect_table[inst.prefab] = nil
    end
    --清除buff所有的数据
    for k, v in pairs(inst.blessingbutterflies) do
        v.dead = true
    end
    inst.countbutterflies = 0
    inst.blessingbutterflies = {}
    inst:Remove()
end

----------

local function OnSave(inst, data)
    if inst.countbutterflies >= 2 then --只保存大于1数量的数量，因为初始化时本身肯定就有1只蝴蝶
        data.countbutterflies = inst.countbutterflies
    end
end

local function OnLoad(inst, data)
    if data ~= nil and data.countbutterflies ~= nil then
        inst.precount = data.countbutterflies
    end
end

----------

local function fn()
    local inst = CreateEntity()

    if not TheWorld.ismastersim then
        --Not meant for client!
        inst:DoTaskInTime(0, inst.Remove)

        return inst
    end

    inst.entity:AddTransform()

    --[[Non-networked entity]]
    --inst.entity:SetCanSleep(false)
    inst.entity:Hide()
    inst.persists = false

    inst.precount = nil --记录保存下的数量
    inst.countbutterflies = 0 --记录蝴蝶的数量，并作为下标
    inst.blessingbutterflies = {} --记录了每只蝴蝶的数据

    inst:AddTag("CLASSIFIED")

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff:SetDetachedFn(OnDetached)
    inst.components.debuff:SetExtendedFn(OnExtended)
    inst.components.debuff.keepondespawn = true

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("buff_butterflysblessing", fn, nil, prefabs) --我知道这名字有人觉得应该写成buff_butterfliesblessing，但实际上我的意思是buff_butterfly's blessing
