require("stategraphs/commonstates")

local function IsValid(one)
    return one:IsValid() and
        one.components.health ~= nil and not one.components.health:IsDead()
end
local function IsBusy(inst)
    return inst.sg:HasStateTag("busy") or inst.components.health:IsDead()
end
local function PlaySound(inst, key, name, volume)
    inst.SoundEmitter:PlaySound(inst.sounds[key], name, volume)
end
local function GetDistance(inst, target)--得到的是距离的平方
    return target:GetDistanceSqToPoint(inst.Transform:GetWorldPosition())
end
local function GetTarget(inst) --优先获取自己的敌人，其次才是伴侣的敌人
    local target = inst.components.combat.target
    if target and IsValid(target) then
        return target
    end
    if inst.mate and IsValid(inst.mate) then
        target = inst.mate.components.combat.target
        if target and IsValid(target) then
            return target
        end
    end
end
local function CheckSkills(inst, isidle)
    if inst.sg.mem.to_flyaway then
        if inst.sg.mem.to_flyaway.beeye then
            if inst:fn_canBeEye() then
                inst.sg:GoToState("flyaway", inst.sg.mem.to_flyaway)
                return true
            end
        else
            inst.sg:GoToState("flyaway", inst.sg.mem.to_flyaway)
            return true
        end
    end
    if inst.sg.mem.to_taunt then
        inst.sg:GoToState("taunt")
        return true
    elseif inst.sg.mem.to_caw then
        inst.sg:GoToState("caw")
        return true
    elseif inst.sg.mem.to_feeded or inst._count_rock >= 1 then
        inst.sg:GoToState("feeded")
        return true
    end

    local target = GetTarget(inst)
    if target ~= nil then --自己或伴侣有仇恨对象
        if inst.sg.mem.to_flap then
            if GetDistance(inst, target) <= (inst.DIST_FLAP)^2 then --羽乱舞对目标和距离有要求
                inst.sg:GoToState("flap_pre")
                return true
            end
        end
        if not inst.components.combat:InCooldown() then --啄击冷却时间到了就自动尝试攻击最近的敌人
            local x, y, z = inst.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x, 0, z, inst.DIST_ATK+1, { "_combat" }, { "INLIMBO", "siving" })
            for _, v in ipairs(ents) do
                if
                    v:HasTag("player") or ( --对玩家无条件攻击
                        v.components.combat ~= nil and
                        v.components.combat.target ~= nil and
                        v.components.combat.target:HasTag("siving") --只攻击对玄鸟有仇恨的对象
                    )
                then
                    inst.sg:GoToState("attack", {target = v})
                    return true
                end
            end
        end
    elseif isidle then
        local rand = math.random()
        if rand < 0.05 then
            inst.sg:GoToState("feeded")
            return true
        elseif rand < 0.1 then
            inst.sg:GoToState("refuse")
            return true
        end
    end

    return false
end

local actionhandlers = {
    -- ActionHandler(ACTIONS.EAT, "eat")
}

local events = {
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
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
    EventHandler("doattack", function(inst, params) --啄击
        if IsBusy(inst) then return end
        if not inst.sg:HasStateTag("attack") then
            inst.sg:GoToState("attack", params)
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
                if params.beeye then
                    if inst:fn_canBeEye() then
                        inst.sg:GoToState("flyaway", params)
                    else
                        inst.sg.mem.to_flyaway = params
                    end
                else
                    inst.sg:GoToState("flyaway", params)
                end
            end
        end
    end),
    EventHandler("dotaunt", function(inst) --魔音绕梁
        if IsBusy(inst) then
            inst.sg.mem.to_taunt = true
        else
            inst.sg:GoToState("taunt")
        end
    end),
    EventHandler("docaw", function(inst) --花寄语
        if IsBusy(inst) then
            inst.sg.mem.to_caw = true
        else
            inst.sg:GoToState("caw")
        end
    end),
    EventHandler("doflap", function(inst) --羽乱舞
        if IsBusy(inst) then
            inst.sg.mem.to_flap = true
        else
            inst.sg:GoToState("flap_pre")
        end
    end),

    EventHandler("dofeeded", function(inst) --被喂食
        if IsBusy(inst) or inst.sg:HasStateTag("eat") then
            inst.sg.mem.to_feeded = true
        else
            inst.sg:GoToState("feeded")
        end
    end),
    EventHandler("dorefuse", function(inst) --拒绝
        if IsBusy(inst) or inst.components.combat.target ~= nil then
            return
        end
        if not inst.sg:HasStateTag("eat") and not inst.sg:HasStateTag("refuse") then
            inst.sg:GoToState("refuse")
        end
    end),
}

local states = {
    State{ --idle
        name = "idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst, pushanim)
            inst.Physics:Stop()
            if CheckSkills(inst, true) then
                return
            end
            if pushanim then
                if type(pushanim) == "string" then
                    inst.AnimState:PlayAnimation(pushanim)
                end
                inst.AnimState:PushAnimation("idle", true)
            else
                inst.AnimState:PlayAnimation("idle", true)
            end
        end
    },
    State{ --移动（跳跃式）
        name = "hop",
        tags = {"moving", "canrotate", "hopping"},
        onenter = function(inst)
            if CheckSkills(inst, false) then
                return
            end
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
    State{ --啄击
        name = "attack",
        tags = {"attack", "busy"},
        onenter = function(inst, params)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("atk")
            inst.components.combat:StartAttack()
            if params then
                inst.sg.statemem.target = params.target
            end
        end,
        events = {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
        timeline = {
            TimeEvent(15*FRAMES, function(inst)
                inst:fn_discerningPeck(inst.sg.statemem.target)
                PlaySound(inst, "atk", nil, nil)
            end),
            TimeEvent(20*FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
        }
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
            inst.sg.mem.to_flyaway = nil
            PlaySound(inst, "flyaway", nil, nil)

            if params and params.beeye and inst.tree then
                inst.tree.myEye = inst --提前占用，防止两只玄鸟一起化目
            end
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
                    elseif params.beeye then --同目同心
                        if not inst:fn_beTreeEye() then
                            if inst.tree then
                                inst.tree.myEye = nil
                            end
                            local x, y, z = inst.Transform:GetWorldPosition()
                            inst.Transform:SetPosition(x, 30, z)
                            inst.sg:GoToState("glide")
                        end
                        return
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
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("taunt")
            inst.sg.mem.to_taunt = nil
        end,
        timeline = {
            TimeEvent(FRAMES*0, function(inst)
                PlaySound(inst, "taunt", nil, nil)
            end),
            TimeEvent(FRAMES*6, function(inst)
                inst:fn_magicWarble()
            end)
        },
        events = {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
    State{ --花寄语
        name = "caw",
        tags = {"busy"},
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("caw")
            inst.sg.mem.to_caw = nil
        end,
        timeline = {
            TimeEvent(FRAMES*0, function(inst)
                PlaySound(inst, "caw", nil, nil)
            end),
            TimeEvent(FRAMES*8, function(inst)
                inst:fn_releaseFlowers()
            end)
        },
        events = {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
    State{ --羽乱舞 pre
        name = "flap_pre",
        tags = {"busy"},
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("flap_pre")
            inst.sg.mem.to_flap = nil
        end,
        events = {
            EventHandler("animover", function(inst)
                local params = { max = 1, now = 0, hop = nil }
                if inst.isgrief then
                    params.max = inst.COUNT_FLAP_GRIEF
                    params.hop = true
                else
                    params.max = inst.COUNT_FLAP
                end
                inst.sg:GoToState("flap", params)
            end),
        },
    },
    State{ --羽乱舞
        name = "flap",
        tags = {"attack", "busy"},
        onenter = function(inst, params)
            inst.AnimState:PlayAnimation("flap_loop")
            inst.sg.statemem.params = params

            --悲愤状态时能边跳边追着敌人攻击
            if params.hop then
                local target = GetTarget(inst)
                if target ~= nil then
                    inst:ForceFacePoint(target.Transform:GetWorldPosition())
                    inst.components.locomotor:RunForward()
                end
            end
        end,
        timeline = {
            TimeEvent(FRAMES*0, function(inst)
                PlaySound(inst, "caw", nil, nil)
            end),
            TimeEvent(6*FRAMES, function(inst)
                PlaySound(inst, "step", nil, nil)
                if inst.sg.statemem.params.hop then
                    inst.components.locomotor:StopMoving()
                end
            end),
            TimeEvent(FRAMES*9, function(inst)
                inst:fn_feathersFlap()
            end)
        },
        events = {
            EventHandler("animover", function(inst)
                local params = inst.sg.statemem.params
                params.now = params.now + 1
                if params.now >= params.max then
                    inst.sg:GoToState("idle")
                else
                    inst.sg:GoToState("flap", params)
                end
            end),
        },
    },
    State{ --被喂食
        name = "feeded",
        tags = {"idle", "eat"},
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("peck")
        end,
        timeline = {
            TimeEvent(FRAMES*24, function(inst)
                local num = math.floor(inst._count_rock)
                if num >= 1 then
                    local loot = SpawnPrefab("siving_rocks")
                    if loot ~= nil then
                        if num > 1 then --丢也得一起丢，不然很难捡
                            loot.components.stackable:SetStackSize(num)
                        end
                        loot.components.inventoryitem:InheritMoisture(TheWorld.state.wetness, TheWorld.state.iswet)
                        inst.components.lootdropper:FlingItem(loot, nil)
                        loot:PushEvent("on_loot_dropped", {dropper = inst})
                        inst:PushEvent("loot_prefab_spawned", {loot = loot})
                        inst._count_rock = inst._count_rock - num
                    end
                end
            end)
        },
        events = {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end)
        }
    },
    State{ --拒绝
        name = "refuse",
        tags = {"idle", "refuse"},
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("caw")
        end,
        events = {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end)
        }
    },
    State{ --主动吃东西（没用到）
        name = "eat",
        tags = {"idle", "eat"},
        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation("peck")
        end,
        timeline = {
            TimeEvent(FRAMES*10, function(inst)
                -- inst:PerformBufferedAction()
            end)
        },
        events = {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
                -- if inst.brain then
                --     inst.brain:ForceUpdate()
                -- end
            end),
        },
    },
}

CommonStates.AddSleepStates(states)
CommonStates.AddFrozenStates(states)

return StateGraph("SGsiving_phoenix", states, events, "idle", actionhandlers)
