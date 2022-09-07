require("stategraphs/commonstates")

local function IsBusy(inst)
    return inst.sg:HasStateTag("busy") or inst.components.health:IsDead()
end
local function PlaySound(inst, key, name, volume)
    inst.SoundEmitter:PlaySound(inst.sounds[key], name, volume)
end

local actionhandlers = {
    ActionHandler(ACTIONS.EAT, "eat"),
    ActionHandler(ACTIONS.GOHOME, function(inst)
        if inst.components.health and not inst.components.health:IsDead() then
            inst.sg:GoToState("flyaway")
        end
    end),
}

local events = {
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    -- CommonHandlers.OnAttack(),
    CommonHandlers.OnDeath(),

    EventHandler("locomote", function(inst)
        if IsBusy(inst) then return end

        if inst.components.locomotor:WantsToMoveForward() then
            if not inst.sg:HasStateTag("hopping") then
                inst.sg:GoToState("hop")
            end
        else
            if not inst.sg:HasStateTag("idle") then
                inst.sg:GoToState("idle")
            end
        end
    end),
    EventHandler("attacked", function(inst)
        if IsBusy(inst) then return end
        if not inst.sg:HasStateTag("hit") then --这次受击动画完毕才能下一个
            inst.sg:GoToState("hit")
        end
    end),
    EventHandler("dotakeoff", function(inst, params) --强制飞走
        if not inst.components.health:IsDead() then
            if inst.sg:HasStateTag("flyaway") then --正在飞，但不一定是我想要的那个
                if params == nil then --如果是想要移除的，那马上移除吧
                    inst:Remove()
                else
                    inst.sg.mem.to_flyaway = params
                end
            else
                inst.sg:GoToState("flyaway", params)
            end
        end
    end),

}

local states = {
    State{ --idle
        name = "idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst, pushanim)
            inst.Physics:Stop()
            if pushanim then
                if type(pushanim) == "string" then
                    inst.AnimState:PlayAnimation(pushanim)
                end
                inst.AnimState:PushAnimation("idle", true)
            else
                inst.AnimState:PlayAnimation("idle", true)
            end
            inst.sg:SetTimeout(3 + math.random()*1)
        end,

        ontimeout= function(inst)
			if inst.bufferedaction and inst.bufferedaction.action == ACTIONS.EAT then
				inst.sg:GoToState("eat")
			else
				local r = math.random()
				if r < .75 then
					inst.sg:GoToState("idle")
				else
                    if inst.components.combat.target then
                        inst.sg:GoToState("taunt")
                    else
					   inst.sg:GoToState("caw")
                    end
				end
			end
        end,
    },
    State{ --移动（跳跃式）
        name = "hop",
        tags = {"moving", "canrotate", "hopping"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("hop")
            inst.components.locomotor:WalkForward()
            inst.sg:SetTimeout(2*math.random()+.5)
        end,
        onupdate = function(inst)
            if not inst.components.locomotor:WantsToMoveForward() then
                inst.sg:GoToState("idle")
            end
        end,
        timeline = {
            TimeEvent(8*FRAMES, function(inst)
                PlaySound(inst, "step", nil, nil)
                inst.Physics:Stop() --跳一下，然后会停下来，等待下次跳跃
            end),
        },
        ontimeout = function(inst)
            inst.sg:GoToState("hop")
        end,
    },
    State{ --死亡
        name = "death",
        tags = {"busy"},
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("death")
            inst:AddTag("NOCLICK")
            inst.components.lootdropper:DropLoot(inst:GetPosition())
            PlaySound(inst, "death", nil, nil)
        end,
        onexit = function(inst)
            inst:RemoveTag("NOCLICK")
        end,
    },
    State{ --受击
        name = "hit",
        tags = {"hit"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()

            --在飞行时被击中，会掉下来。但是不适用于这个BOSS
            -- local pt = Vector3(inst.Transform:GetWorldPosition())
            -- if pt.y > 1 then
            --     inst.sg:GoToState("fall")
            -- end
        end,
        events = {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },
    State{ --飞天
        name = "flyaway",
        tags = {"flight", "busy", "canrotate", "flyaway"},
        onenter = function(inst, params)
            inst.Physics:Stop()
            inst.sg:SetTimeout(.1+math.random()*.2)
            inst.sg.statemem.params = params
            inst.sg.statemem.vert = math.random() > .5
            if inst.sg.statemem.vert then
                inst.AnimState:PlayAnimation("takeoff_vertical_pre")
            else
                inst.AnimState:PlayAnimation("takeoff_diagonal_pre")
            end
            PlaySound(inst, "flyaway", nil, nil)
        end,
        ontimeout = function(inst)
            if inst.sg.statemem.vert then
                inst.AnimState:PushAnimation("takeoff_vertical_loop", true)
                inst.Physics:SetMotorVel(-2+math.random()*4, 15+math.random()*5, -2+math.random()*4)
            else
                inst.AnimState:PushAnimation("takeoff_diagonal_loop", true)
                local x = 8+math.random()*8
                inst.Physics:SetMotorVel(x, 15+math.random()*5, -2+math.random()*4)
            end
        end,
        timeline = {
            TimeEvent(2, function(inst)
                local params = inst.sg.statemem.params
                if params ~= nil then
                    if params.x and params.z then
                        inst.Transform:SetPosition(params.x, params.y or 30, params.z)
                        inst.sg:GoToState("glide")
                        return
                    -- elseif  then --同目同心
                    end
                end
                inst:Remove() --飞上天就消失啦
            end),
        }
    },
    State{ --降落
        name = "glide",
        tags = {"idle", "flight", "busy", "glide"},
        onenter = function(inst)
            inst.AnimState:PlayAnimation("glide", true)
            inst.Physics:SetMotorVelOverride(0, -15, 0)
            inst.flapSound = inst:DoPeriodicTask(6*FRAMES, function(inst)
                PlaySound(inst, "flap", nil, nil)
            end)
        end,
        onupdate = function(inst)
            inst.Physics:SetMotorVelOverride(0,-15,0)
            local pt = Point(inst.Transform:GetWorldPosition())
            if pt.y <= .1 or inst:IsAsleep() then
                inst.Physics:ClearMotorVelOverride()
                pt.y = 0
                inst.Physics:Stop()
                inst.Physics:Teleport(pt.x, pt.y, pt.z)
                inst.AnimState:PlayAnimation("land")
                inst.DynamicShadow:Enable(true)
                inst.sg:GoToState("idle", true)
            end
        end,
        onexit = function(inst)
            if inst.flapSound then
                inst.flapSound:Cancel()
                inst.flapSound = nil
            end
            local pos = inst:GetPosition()
            if pos.y ~= 0 then
                pos.y = 0
                inst.Transform:SetPosition(pos:Get())
            end
            inst.components.knownlocations:RememberLocation("spawnpoint", pos, true)
        end,
    },









    

    State{ --魔音绕梁
        name = "taunt",
        tags = {"busy"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
        end,

        timeline=
        {
            TimeEvent(FRAMES*0, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/buzzard/taunt") end)
        },

        events=
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "caw",
        tags = {"idle"},
        onenter= function(inst)
            inst.AnimState:PlayAnimation("caw")
        end,

        timeline=
        {
            TimeEvent(FRAMES*0, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/buzzard/squack") end)
        },

        events=
        {
            EventHandler("animover", function(inst) if math.random() < .5 then inst.sg:GoToState("caw") else inst.sg:GoToState("idle") end end ),
        },
    },

    State{
        name = "distress_pre",
        tags = {"busy"},
        onenter= function(inst)
            inst.AnimState:PlayAnimation("flap_pre")
        end,
        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("distress") end ),
        },
    },

    State{ --悲愤状态时能边跳边追着敌人攻击
        name = "distress",
        tags = {"busy"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("flap_loop")
        end,

        timeline=
        {
            TimeEvent(FRAMES*0, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/buzzard/squack") end)
        },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("distress") end ),
            EventHandler("onextinguish", function(inst) if not inst.components.health:IsDead() then inst.sg:GoToState("idle", "flap_pst") end end ),
        },
    },

    

    State{
        name = "kill",
        tags = {"busy", "canrotate"},
        onenter = function(inst, data)
            inst.AnimState:PushAnimation("atk", false)
            if data and data.target:HasTag("prey") then
                inst.sg.statemem.target = data.target
            end
        end,

        timeline =
        {
            TimeEvent(15*FRAMES, function(inst)
                if inst.sg.statemem.target ~= nil and inst.sg.statemem.target:IsValid() then
                    inst:FacePoint(inst.sg.statemem.target.Transform:GetWorldPosition())
                end
            end),
            TimeEvent(27*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/buzzard/attack")
                local target = inst.sg.statemem.target
                if target ~= nil and
                    target:IsValid() and
                    inst:IsNear(target, TUNING.BUZZARD_ATTACK_RANGE) and
                    inst.components.combat:CanAttack(target) then
                    target.components.health:Kill()
                end
            end)
        },

        events =
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end)
        },
    },

    State{
        name = "eat",
        tags = {"busy"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("peck")
        end,

        events=
        {
            EventHandler("animover", function(inst)
                if math.random() < .3 then
					inst:PerformBufferedAction()
                end
                inst.sg:GoToState("idle")
                if inst.brain then
                    inst.brain:ForceUpdate()
                end
            end),
        },
    },

    

    

    State{
        name = "fall",
        tags = {"busy"},
        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("fall_loop", true)
        end,

        onupdate = function(inst)
            local pt = Vector3(inst.Transform:GetWorldPosition())
            if pt.y <= .2 then
                pt.y = 0
                inst.Physics:Stop()
                inst.Physics:Teleport(pt.x,pt.y,pt.z)
	            inst.DynamicShadow:Enable(true)
                inst.sg:GoToState("stunned")
            end
        end,
    },
}

CommonStates.AddCombatStates(states,
{
    attacktimeline =
    {
        TimeEvent(15*FRAMES, function(inst)
            inst.components.combat:DoAttack(inst.sg.statemem.target)
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/buzzard/attack")
        end),
        TimeEvent(20*FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
    },
})

CommonStates.AddSleepStates(states)
CommonStates.AddFrozenStates(states)

return StateGraph("SGsiving_phoenix", states, events, "idle", actionhandlers)
