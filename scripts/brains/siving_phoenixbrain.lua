require("stategraphs/commonstates")
require("behaviours/wander")

require "behaviours/chaseandattack"

local SEE_FOOD_DIST = 15
local SEE_THREAT_DIST = 7.5

local NO_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO" }
local FOOD_TAGS = {}
for i, v in ipairs(FOODGROUP.OMNI.types) do
    table.insert(FOOD_TAGS, "edible_"..v)
end

local FINDTHREAT_MUST_TAGS = { "notarget" }
local FINDTHREAT_CANT_TAGS = { "player", "monster", "scarytoprey" }

local function FindThreat(inst, radius)
    return FindEntity(
            inst,
            radius,
            function(guy)
                return not guy:HasTag("buzzard")
                    or inst:IsNear(guy, inst.components.combat:GetAttackRange() + guy:GetPhysicsRadius(0))
            end,
            nil,
            FINDTHREAT_MUST_TAGS,
            FINDTHREAT_CANT_TAGS
        )
end

local function CanEat(food)
    return food:IsOnValidGround()
end

local function FindFood(inst, radius)
    return FindEntity(inst, radius, CanEat, nil, NO_TAGS, FOOD_TAGS)
end

local function IsThreatened(inst)
    return not (inst.sg:HasStateTag("sleeping") or
                inst.sg:HasStateTag("busy") or
                inst.sg:HasStateTag("flight"))
        and FindThreat(inst, SEE_THREAT_DIST) ~= nil
end

local function DealWithThreat(inst)
    --If you have some food then defend it! Otherwise... cheese it!
    if FindFood(inst, 1.5) ~= nil then
        local threat = FindThreat(inst, SEE_THREAT_DIST)
        if threat ~= nil then
            if not threat:IsOnValidGround() then
                -- If our threat is out on the ocean, or otherwise somewhere we can't reach,
                -- we should just go away. Sorry, "cheese it".
                inst.shouldGoAway = true
            elseif not inst.components.combat:TargetIs(threat) then
                inst.components.locomotor:Stop()
                inst:ClearBufferedAction()
                inst.components.combat:SetTarget(threat)
            end
        end
    else
        inst.shouldGoAway = true
    end
end

local function EatFoodAction(inst)  --Look for food to eat
    if inst.sg:HasStateTag("busy") then
        return
    end

    local food = FindFood(inst, SEE_FOOD_DIST)
    return food ~= nil and BufferedAction(inst, food, ACTIONS.EAT) or nil
end

local function GoHome(inst)
    return inst.shouldGoAway and BufferedAction(inst, nil, ACTIONS.GOHOME) or nil
end


local CHASE_TIME = 10

------

local Siving_PhoenixBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function Siving_PhoenixBrain:OnStart()
    local root = PriorityNode({
        WhileNode(function() return not self.inst.sg:HasStateTag("flight") end, "Not Flying", --飞行时脑子停运
            PriorityNode{
                ChaseAndAttack(self.inst, CHASE_TIME, self.inst.DIST_REMOTE), --追着攻击

                IfNode(function() return IsThreatened(self.inst) end, "Threat Near",
                    ActionNode(function() return DealWithThreat(self.inst) end)),
                DoAction(self.inst, EatFoodAction),
                Wander(self.inst, function() return self.inst:GetPosition() end, 5)
            }
        )
    }, .25)

    self.bt = BT(self.inst, root)
end

function Siving_PhoenixBrain:OnInitializationComplete()
    self.inst.components.knownlocations:RememberLocation("spawnpoint", self.inst:GetPosition(), true)
end

return Siving_PhoenixBrain
