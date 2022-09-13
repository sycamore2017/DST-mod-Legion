require("stategraphs/commonstates")
require("behaviours/wander")
require "behaviours/chaseandattack"
require "behaviours/leash"

-- local SEE_FOOD_DIST = 15
-- local SEE_THREAT_DIST = 7.5

-- local NO_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO" }
-- local FOOD_TAGS = {}
-- for i, v in ipairs(FOODGROUP.OMNI.types) do
--     table.insert(FOOD_TAGS, "edible_"..v)
-- end

-- local FINDTHREAT_MUST_TAGS = { "notarget" }
-- local FINDTHREAT_CANT_TAGS = { "player", "monster", "scarytoprey" }


-- local function CanEat(food)
--     return food:IsOnValidGround()
-- end

-- local function FindFood(inst, radius)
--     return FindEntity(inst, radius, CanEat, nil, NO_TAGS, FOOD_TAGS)
-- end

-- local function EatFoodAction(inst)  --Look for food to eat
--     if inst.sg:HasStateTag("busy") then
--         return
--     end

--     local food = FindFood(inst, SEE_FOOD_DIST)
--     return food ~= nil and BufferedAction(inst, food, ACTIONS.EAT) or nil
-- end



local CHASE_TIME = 10

local function GetMatePos(inst)
    if
        not inst.iswarrior and --护卫模式才需要跟着伴侣
        inst.mate ~= nil and
        not inst.mate.iseye and
        not inst.mate.sg:HasStateTag("flight")
    then
        return inst.mate:GetPosition()
    end
end
local function GetHomePos(inst)
    return inst.components.knownlocations:GetLocation("tree") or
        inst.components.knownlocations:GetLocation("spawnpoint")
end

------

local Siving_PhoenixBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function Siving_PhoenixBrain:OnStart()
    local root = PriorityNode({
        WhileNode(function() return not self.inst.sg:HasStateTag("flight") end, "Not Flying", --飞行时脑子停运
            PriorityNode{
                Leash(self.inst, GetMatePos, self.inst.DIST_MATE, self.inst.DIST_MATE/2), --被伴侣牵制
                ChaseAndAttack(self.inst, CHASE_TIME, self.inst.DIST_REMOTE), --追着攻击
                Leash(self.inst, GetHomePos, self.inst.DIST_REMOTE, self.inst.DIST_REMOTE/2), --被神木或出生点牵制
                -- DoAction(self.inst, EatFoodAction),
                Wander(self.inst, GetHomePos, self.inst.DIST_REMOTE) --神木或出生点周围徘徊
            }
        )
    }, .75)

    self.bt = BT(self.inst, root)
end

function Siving_PhoenixBrain:OnInitializationComplete()
    self.inst.components.knownlocations:RememberLocation("spawnpoint", self.inst:GetPosition(), true)
end

return Siving_PhoenixBrain
