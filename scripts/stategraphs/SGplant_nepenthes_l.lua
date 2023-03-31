require("stategraphs/commonstates")

local TIME_TRYSWALLOW = 4.5 --吞食检查周期
local TIME_DOLURE = 10 --引诱周期

local function IsBusy(inst)
    return inst.sg:HasStateTag("busy") or inst.components.health:IsDead()
end
local function CheckState(inst)
    --冷却期
    if inst.task_digest ~= nil or inst.components.timer:TimerExists("digested") then
        inst.sg:GoToState("digest")
        return true
    end

    --尝试吞食
    if inst.sg.mem.to_swallow then
        if inst.fn_trySwallow(inst) then
            return true
        end
    elseif not inst.components.timer:TimerExists("swallow") then
        inst.components.timer:StartTimer("swallow", TIME_TRYSWALLOW)
    end

    --尝试引诱
    if inst.sg.mem.to_lure then
        inst.fn_doLure(inst)
    elseif not inst.components.timer:TimerExists("lure") then
        inst.components.timer:StartTimer("lure", TIME_DOLURE)
    end

    return false
end

local events = {
    EventHandler("death", function(inst, data) inst.sg:GoToState("death", data) end),
    EventHandler("attacked", function(inst, data)
        if inst.components.health:IsDead() then return end
        if data.attacker and data.attacker:HasTag("player") then --被玩家攻击，会损失额外血量
            inst.components.health:DoDelta(-200)
            if inst.components.health:IsDead() then
                return
            end
        end
        if inst.sg:HasStateTag("doing") then return end
        inst.sg:GoToState("hit")
    end),
    EventHandler("doswallow", function(inst) --可以吞食了
        inst.sg.mem.to_swallow = true
        if IsBusy(inst) then return end
        CheckState(inst)
    end),
    EventHandler("dolure", function(inst) --可以引诱了
        inst.sg.mem.to_lure = true
        if IsBusy(inst) then return end
        CheckState(inst)
    end),
    EventHandler("digested", function(inst) --主动吞食的冷却时间结束
        if IsBusy(inst) then return end
        CheckState(inst)
    end),
    -- EventHandler("onopen", function(inst, data) --不用该方式，因为它是每次有人打开容器就会触发，onopenfn 才是第一次打开时才触发
    --     if inst.components.health:IsDead() then return end
    --     inst.sg:GoToState("openmouth")
    -- end),
}

local states= {
    State{ --idle
        name = "idle",
        tags = { "idle" },
        onenter = function(inst, pushanim)
            if CheckState(inst) then
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
        end,
        -- events = {
        --     EventHandler("animover", function(inst)
        --         if inst.AnimState:AnimDone() then
        --             inst.sg:GoToState("idle")
        --         end
        --     end)
        -- }
    },
    State{ --死亡
        name = "death",
        tags = { "busy" },
        onenter = function(inst, data)
            inst.AnimState:PlayAnimation("hit")
            RemovePhysicsColliders(inst)
            inst.SoundEmitter:PlaySound(inst.sounds.leaf, nil, 0.6)
	        inst.SoundEmitter:PlaySound(inst.sounds.death, nil, 0.3)
            inst.fn_death(inst, data)
        end
    },
    State{ --受击
        name = "hit",
        tags = { "hit" },
        onenter = function(inst)
            inst.AnimState:PlayAnimation("hit")
            inst.SoundEmitter:PlaySound(inst.sounds.leaf, nil, 0.6)
	        inst.SoundEmitter:PlaySound(inst.sounds.hurt, nil, 0.3)

            inst.components.container:Close()
        end,
        events = {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end)
        }
    },
    State{ --容器打开
        name = "openmouth",
        tags = { "busy", "open" },
        onenter = function(inst, data)
            inst.AnimState:PlayAnimation("open")
            inst.SoundEmitter:PlaySound(inst.sounds.leaf, nil, 0.6)
	        inst.SoundEmitter:PlaySound(inst.sounds.open, nil, 0.3)
        end
    },
    State{ --容器关闭
        name = "closemouth",
        tags = { "busy" },
        onenter = function(inst, data)
            inst.AnimState:PlayAnimation("close")
            inst.SoundEmitter:PlaySound(inst.sounds.leaf, nil, 0.6)
	        inst.SoundEmitter:PlaySound(inst.sounds.close, nil, 0.3)
        end,
        events = {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end)
        }
    },
    State{ --消化
        name = "digest",
        tags = { "busy" },
        onenter = function(inst, data)
            inst.AnimState:PlayAnimation("eat", true)
            -- inst.SoundEmitter:PlaySound(inst.sounds.leaf, nil, 0.6)
	        -- inst.SoundEmitter:PlaySound(inst.sounds.close, nil, 0.3)
        end,
        events = {
            EventHandler("animover", function(inst) --动画结束才判定是否要离开当前sg，保证动画连贯性
                if inst.task_digest == nil and not inst.components.timer:TimerExists("digested") then
                    inst.sg:GoToState("idle")
                end
            end)
        }
    },
    State{ --主动吞食
        name = "swallow",
        tags = { "busy", "doing" },
        onenter = function(inst, data)
            inst.AnimState:PlayAnimation("open")
            inst.AnimState:PushAnimation("close")
            inst.SoundEmitter:PlaySound(inst.sounds.leaf, nil, 0.6)
	        inst.SoundEmitter:PlaySound(inst.sounds.open, nil, 0.3)
        end,
        timeline = {
            TimeEvent(11 * FRAMES, function(inst)
                inst.fn_doSwallow(inst)
            end)
        },
        events = {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                else
                    inst.SoundEmitter:PlaySound(inst.sounds.leaf, nil, 0.6)
                    inst.SoundEmitter:PlaySound(inst.sounds.close, nil, 0.3)
                end
            end)
        }
    }
}

return StateGraph("plant_nepenthes_l", states, events, "idle", nil)
