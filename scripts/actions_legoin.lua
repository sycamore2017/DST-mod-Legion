local _G = GLOBAL
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()

--------------------------------------------------------------------------
--[[ 让地毯类建筑能摆更远 ]]
--------------------------------------------------------------------------

local build_dist_old = ACTIONS.BUILD.extra_arrive_dist
ACTIONS.BUILD.extra_arrive_dist = function(doer, dest, bufferedaction)
    if bufferedaction and bufferedaction.recipe then
        if
            string.len(bufferedaction.recipe) > 7 and
            string.sub(bufferedaction.recipe, 1, 7) == "carpet_"
        then
            return 4
        end
    end
    return build_dist_old and build_dist_old(doer, dest, bufferedaction) or 0
end

--------------------------------------------------------------------------
--[[ 青枝绿叶 ]]
--------------------------------------------------------------------------

------出鞘

local PULLOUTSWORD = Action({ priority = 2, mount_valid = true, encumbered_valid = true, canforce = true })
PULLOUTSWORD.id = "PULLOUTSWORD"
PULLOUTSWORD.str = STRINGS.ACTIONS_LEGION.PULLOUTSWORD
PULLOUTSWORD.fn = function(act)
    local obj = act.target or act.invobject
    if obj ~= nil and obj.components.swordscabbard ~= nil and act.doer ~= nil then
        obj.components.swordscabbard:BreakUp(act.doer)
        return true
    end
end
AddAction(PULLOUTSWORD)

--往具有某组件的物品添加动作的检测函数，如果满足条件，就向人物的动作可执行表中加入某个动作。right表示是否是右键动作
AddComponentAction("INVENTORY", "swordscabbard", function(inst, doer, actions, right)
    table.insert(actions, ACTIONS.PULLOUTSWORD)
end)
AddComponentAction("SCENE", "swordscabbard", function(inst, doer, actions, right)
    if right then
        table.insert(actions, ACTIONS.PULLOUTSWORD)
    end
end)

--将一个动作与state绑定
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.PULLOUTSWORD, "doskipaction_l"))

------入鞘

local INTOSHEATH_L = Action({ priority = 2, mount_valid = true, canforce = true })
INTOSHEATH_L.id = "INTOSHEATH_L"
INTOSHEATH_L.str = STRINGS.ACTIONS.GIVE.SCABBARD
INTOSHEATH_L.fn = function(act)
    local obj = act.target or act.invobject
    if
        obj ~= nil and
        obj.components.z_emptyscabbard ~= nil and obj.components.trader ~= nil and
        act.doer.components.inventory ~= nil
    then
        local sword = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        local able, reason = obj.components.trader:AbleToAccept(sword, act.doer)
        if not able then
            return false, reason
        end
        obj.components.trader:AcceptGift(act.doer, sword)
        return true
    end
end
AddAction(INTOSHEATH_L)

AddComponentAction("INVENTORY", "z_emptyscabbard", function(inst, doer, actions, right)
    table.insert(actions, ACTIONS.INTOSHEATH_L)
end)
AddComponentAction("SCENE", "z_emptyscabbard", function(inst, doer, actions, right)
    if right then
        table.insert(actions, ACTIONS.INTOSHEATH_L)
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.INTOSHEATH_L, "doskipaction_l"))

--------------------------------------------------------------------------
--[[ 月折宝剑 ]]
--------------------------------------------------------------------------

local MOONSURGE_L = Action({ priority = 5, mount_valid = true })
MOONSURGE_L.id = "MOONSURGE_L"
MOONSURGE_L.str = STRINGS.ACTIONS.MOONSURGE_L
MOONSURGE_L.strfn = function(act)
    if act.invobject ~= nil and act.invobject:HasTag("canmoonsurge_l") then
        return "GENERIC"
    end
    return "LACK"
end
MOONSURGE_L.fn = function(act)
    if act.invobject ~= nil and act.invobject.fn_tryRevolt ~= nil then
        act.invobject.fn_tryRevolt(act.invobject, act.doer)
    end
    return true
end
AddAction(MOONSURGE_L)

AddComponentAction("EQUIPPED", "z_refractedmoonlight", function(inst, doer, target, actions, right)
    if
        right and
        doer == target and --对自己使用
        (inst:HasTag("canmoonsurge_l") or inst:HasTag("cansurge_l"))
    then
        table.insert(actions, ACTIONS.MOONSURGE_L)
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.MOONSURGE_L, "moonsurge_l"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.MOONSURGE_L, "moonsurge_l"))
