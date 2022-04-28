local prefabFiles = {
    "fimbul_axe",               --芬布尔之斧
    "fimbul_fx",                --芬布尔相关fx
    "boss_elecarmet",           --莱克阿米特
    "elecourmaline",            --电气重铸台
    "hat_cowboy",               --牛仔套装
    "dualwrench",               --扳手-双用型
    "tourmalinecore",           --电气石
    "icire_rock",               --鸳鸯石
    "guitar_miguel",            --米格尔的吉他
    "the_gifted",               --重铸科技，针对每个角色的独有制作物
    "saddle_baggage",           --驮物牛鞍
    "tripleshovelaxe",          --铲斧-三用型
    "hat_albicans_mushroom",    --素白蘑菇帽
    "albicansmushroomhat_fx",   --素白蘑菇帽相关fx
    "explodingfruitcake",       --爆炸水果蛋糕
}

for k,v in pairs(prefabFiles) do
    table.insert(PrefabFiles, v)
end

-----

local assets = {
    Asset("ATLAS", "images/station_recast.xml"),
    Asset("IMAGE", "images/station_recast.tex"),

    Asset("ANIM", "anim/albicansspore_fx.zip"),
    Asset("ANIM", "anim/mushroom_farm_albicans_cap_build.zip"), --竹荪的蘑菇农场贴图

    Asset("ATLAS", "images/inventoryimages/tripleshovelaxe.xml"), --预加载，给科技栏用的
    Asset("IMAGE", "images/inventoryimages/tripleshovelaxe.tex"),
    Asset("ATLAS", "images/inventoryimages/dualwrench.xml"),
    Asset("IMAGE", "images/inventoryimages/dualwrench.tex"),
    Asset("ATLAS", "images/inventoryimages/icire_rock.xml"),
    Asset("IMAGE", "images/inventoryimages/icire_rock.tex"),
    Asset("ATLAS", "images/inventoryimages/hat_cowboy.xml"),
    Asset("IMAGE", "images/inventoryimages/hat_cowboy.tex"),
    Asset("ATLAS", "images/inventoryimages/guitar_miguel.xml"),
    Asset("IMAGE", "images/inventoryimages/guitar_miguel.tex"),
    Asset("ATLAS", "images/inventoryimages/web_hump_item.xml"),
    Asset("IMAGE", "images/inventoryimages/web_hump_item.tex"),
    Asset("ATLAS", "images/inventoryimages/saddle_baggage.xml"),
    Asset("IMAGE", "images/inventoryimages/saddle_baggage.tex"),
    Asset("ATLAS", "images/inventoryimages/hat_albicans_mushroom.xml"),
    Asset("IMAGE", "images/inventoryimages/hat_albicans_mushroom.tex"),
    Asset("ATLAS", "images/inventoryimages/soul_contracts.xml"),
    Asset("IMAGE", "images/inventoryimages/soul_contracts.tex"),
    Asset("ATLAS", "images/inventoryimages/explodingfruitcake.xml"),
    Asset("IMAGE", "images/inventoryimages/explodingfruitcake.tex"),
}

for k,v in pairs(assets) do
    table.insert(Assets, v)
end

-----

local _G = GLOBAL
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()

--监听函数修改工具，超强der大佬写滴！
local upvaluehelper = require "hua_upvaluehelper"

--------------------------------------------------------------------------
--[[ 电气石重铸台相关 ]]
--------------------------------------------------------------------------

_G.RegistMiniMapImage_legion("elecourmaline")

if TUNING.LEGION_TECHUNLOCK == "lootdropper" then
    AddRecipe2(
        "tripleshovelaxe", {
            Ingredient("axe", 1),
            Ingredient("pickaxe", 1),
            Ingredient("shovel", 1),
        }, TECH.LOST, {
            atlas = "images/inventoryimages/tripleshovelaxe.xml", image = "tripleshovelaxe.tex"
        }, { "RECAST", "TOOLS" }
    )

    AddRecipe2(
        "dualwrench", {
            Ingredient("hammer", 1),
            Ingredient("goldnugget", 1),
            Ingredient("pitchfork", 1),
        }, TECH.LOST, {
            atlas = "images/inventoryimages/dualwrench.xml", image = "dualwrench.tex"
        }, { "RECAST", "TOOLS" }
    )

    AddRecipe2(
        "icire_rock", {
            Ingredient("amulet", 1),
            Ingredient("heatrock", 2),
            Ingredient("blueamulet", 1),
        }, TECH.LOST, {
            atlas = "images/inventoryimages/icire_rock.xml", image = "icire_rock.tex"
        }, { "RECAST", "WINTER", "SUMMER" }
    )

    AddRecipe2(
        "explodingfruitcake", {
            Ingredient("winter_food4", 1),
            Ingredient("gunpowder", 2),
        }, TECH.LOST, {
            atlas = "images/inventoryimages/explodingfruitcake.xml", image = "explodingfruitcake.tex"
        }, { "RECAST", "WEAPONS" }
    )

    AddRecipe2(
        "hat_cowboy", {
            Ingredient("beefalohat", 1),
            Ingredient("rainhat", 1),
            Ingredient("tophat", 1),
        }, TECH.LOST, {
            atlas = "images/inventoryimages/hat_cowboy.xml", image = "hat_cowboy.tex"
        }, { "RECAST", "RAIN", "SUMMER", "RIDING", "CLOTHING" }
    )

    AddRecipe2(
        "guitar_miguel", {
            Ingredient("panflute", 1),
            Ingredient("onemanband", 1),
        }, TECH.LOST, {
            atlas = "images/inventoryimages/guitar_miguel.xml", image = "guitar_miguel.tex"
        }, { "RECAST", "GARDENING", "MAGIC" }
    )

    AddRecipe2(
        "web_hump_item", {
            Ingredient("monstermeat_dried", 12),
            Ingredient("minisign_item", 2),
            Ingredient("silk", 12),
        }, TECH.LOST, {
            atlas = "images/inventoryimages/web_hump_item.xml", image = "web_hump_item.tex"
        }, { "RECAST", "STRUCTURES", "DECOR" }
    )

    AddRecipe2(
        "saddle_baggage", {
            Ingredient("bedroll_straw", 1),
            Ingredient("saddle_basic", 1),
            Ingredient("bundlewrap", 2),
        }, TECH.LOST, {
            atlas = "images/inventoryimages/saddle_baggage.xml", image = "saddle_baggage.tex"
        }, { "RECAST", "RIDING", "COOKING", "CONTAINERS" }
    )

    AddRecipe2(
        "hat_albicans_mushroom", {
            Ingredient("red_mushroomhat", 1),
            Ingredient("green_mushroomhat", 1),
            Ingredient("blue_mushroomhat", 1),
        }, TECH.LOST, {
            atlas = "images/inventoryimages/hat_albicans_mushroom.xml", image = "hat_albicans_mushroom.tex"
        }, { "RECAST", "CLOTHING", "SUMMER", "GARDENING", "RAIN" }
    )

    AddRecipe2(
        "soul_contracts", {
            Ingredient("wortox_soul", 20),
            Ingredient("waxwelljournal", 1),
            Ingredient("nightmarefuel", 20),
        }, TECH.LOST, {
            atlas = "images/inventoryimages/soul_contracts.xml", image = "soul_contracts.tex"
        }, { "RECAST", "RESTORATION", "MAGIC" }
    )
else
    AddRecipe2(
        "tripleshovelaxe", {
            Ingredient("axe", 1),
            Ingredient("pickaxe", 1),
            Ingredient("shovel", 1),
        }, TECH.ELECOURMALINE_ONE, {
            nounlock = true,
            atlas = "images/inventoryimages/tripleshovelaxe.xml", image = "tripleshovelaxe.tex"
        }, { "RECAST", "TOOLS" }
    )

    AddRecipe2(
        "dualwrench", {
            Ingredient("hammer", 1),
            Ingredient("goldnugget", 1),
            Ingredient("pitchfork", 1),
        }, TECH.ELECOURMALINE_ONE, {
            nounlock = true,
            atlas = "images/inventoryimages/dualwrench.xml", image = "dualwrench.tex"
        }, { "RECAST", "TOOLS" }
    )

    AddRecipe2(
        "icire_rock", {
            Ingredient("amulet", 1),
            Ingredient("heatrock", 2),
            Ingredient("blueamulet", 1),
        }, TECH.ELECOURMALINE_ONE, {
            nounlock = true,
            atlas = "images/inventoryimages/icire_rock.xml", image = "icire_rock.tex"
        }, { "RECAST", "WINTER", "SUMMER" }
    )

    AddRecipe2(
        "explodingfruitcake", {
            Ingredient("winter_food4", 1),
            Ingredient("gunpowder", 2),
        }, TECH.ELECOURMALINE_ONE, {
            nounlock = true,
            atlas = "images/inventoryimages/explodingfruitcake.xml", image = "explodingfruitcake.tex"
        }, { "RECAST", "WEAPONS" }
    )

    AddRecipe2(
        "hat_cowboy", {
            Ingredient("beefalohat", 1),
            Ingredient("rainhat", 1),
            Ingredient("tophat", 1),
        }, TECH.ELECOURMALINE_THREE, {
            nounlock = true,
            atlas = "images/inventoryimages/hat_cowboy.xml", image = "hat_cowboy.tex"
        }, { "RECAST", "RAIN", "SUMMER", "RIDING", "CLOTHING" }
    )

    AddRecipe2(
        "guitar_miguel", {
            Ingredient("panflute", 1),
            Ingredient("onemanband", 1),
        }, TECH.ELECOURMALINE_THREE, {
            nounlock = true,
            atlas = "images/inventoryimages/guitar_miguel.xml", image = "guitar_miguel.tex"
        }, { "RECAST", "GARDENING", "MAGIC" }
    )

    AddRecipe2(
        "web_hump_item", {
            Ingredient("monstermeat_dried", 12),
            Ingredient("minisign_item", 2),
            Ingredient("silk", 12),
        }, TECH.ELECOURMALINE_THREE, {
            nounlock = true, builder_tag = "spiderwhisperer",
            atlas = "images/inventoryimages/web_hump_item.xml", image = "web_hump_item.tex"
        }, { "RECAST", "STRUCTURES", "DECOR", "CHARACTER" }
    )

    AddRecipe2(
        "saddle_baggage", {
            Ingredient("bedroll_straw", 1),
            Ingredient("saddle_basic", 1),
            Ingredient("bundlewrap", 2),
        }, TECH.ELECOURMALINE_THREE, {
            nounlock = true,
            atlas = "images/inventoryimages/saddle_baggage.xml", image = "saddle_baggage.tex"
        }, { "RECAST", "RIDING", "COOKING", "CONTAINERS" }
    )

    AddRecipe2(
        "hat_albicans_mushroom", {
            Ingredient("red_mushroomhat", 1),
            Ingredient("green_mushroomhat", 1),
            Ingredient("blue_mushroomhat", 1),
        }, TECH.ELECOURMALINE_THREE, {
            nounlock = true,
            atlas = "images/inventoryimages/hat_albicans_mushroom.xml", image = "hat_albicans_mushroom.tex"
        }, { "RECAST", "CLOTHING", "SUMMER", "GARDENING", "RAIN" }
    )

    AddRecipe2(
        "soul_contracts", {
            Ingredient("wortox_soul", 20),
            Ingredient("waxwelljournal", 1),
            Ingredient("nightmarefuel", 20),
        }, TECH.ELECOURMALINE_THREE, {
            nounlock = true, builder_tag = "soulstealer",
            atlas = "images/inventoryimages/soul_contracts.xml", image = "soul_contracts.tex"
        }, { "RECAST", "RESTORATION", "MAGIC", "CHARACTER" }
    )
end

--这个配方用来便于绿宝石法杖分解
AddDeconstructRecipe("web_hump", {
    Ingredient("monstermeat_dried", 12),
    Ingredient("minisign_item", 2),
    Ingredient("silk", 12)
})

--------------------------------------------------------------------------
--[[ 修改基础函数以给生物添加触电组件 ]]
--------------------------------------------------------------------------

local function CanShockable(inst)
    return (inst:HasTag("player")
           or inst:HasTag("character")
           or inst:HasTag("smallcreature")
           or inst:HasTag("largecreature")
           or inst:HasTag("animal")
           or inst:HasTag("monster")
           or inst:HasTag("mufflehat"))     --啜食者的专属标签
           and not inst:HasTag("shadowcreature")    --暗影生物不会被触电
           and not inst:HasTag("electrified")       --电气生物不会被触电
           and not inst:HasTag("lightninggoat")     --电羊不会被触电
end

local function AddShockableComponent_fire(inst, sym, offset, level)
    if inst.canshockable or CanShockable(inst) then  --防止非生物物品加入这个组件
        inst.canshockable = true

        if inst.components.shockable == nil then
            inst:AddComponent("shockable")
        else
            inst.canshockable = nil
        end
        inst.components.shockable:InitStaticFx(sym, offset or Vector3(0, 0, 1), level)    --这里的设置是为了让着火的sympol被设定的优先级高一些，覆盖的冰冻的sympol
    end
end

local function AddShockableComponent_ice(inst, sym, offset, level)
    if inst.canshockable or CanShockable(inst) then  --防止非生物物品加入这个组件
        inst.canshockable = true

        if inst.components.shockable == nil then
            inst:AddComponent("shockable")
            inst.components.shockable:InitStaticFx(sym, offset or Vector3(0, 0, 0), level)
        else
            inst.canshockable = nil
        end
    end
end

local MakeSmallBurnableCharacter_old = MakeSmallBurnableCharacter
_G.MakeSmallBurnableCharacter = function(inst, sym, offset)
    MakeSmallBurnableCharacter_old(inst, sym, offset)
    AddShockableComponent_fire(inst, sym, offset, 1)
end

local MakeMediumBurnableCharacter_old = MakeMediumBurnableCharacter
_G.MakeMediumBurnableCharacter = function(inst, sym, offset)
    MakeMediumBurnableCharacter_old(inst, sym, offset)
    AddShockableComponent_fire(inst, sym, offset, 2)
end

local MakeLargeBurnableCharacter_old = MakeLargeBurnableCharacter
_G.MakeLargeBurnableCharacter = function(inst, sym, offset)
    MakeLargeBurnableCharacter_old(inst, sym, offset)
    AddShockableComponent_fire(inst, sym, offset, 3)
end

local MakeTinyFreezableCharacter_old = MakeTinyFreezableCharacter
_G.MakeTinyFreezableCharacter = function(inst, sym, offset)
    MakeTinyFreezableCharacter_old(inst, sym, offset)
    AddShockableComponent_ice(inst, sym, offset, 1)
end

local MakeSmallFreezableCharacter_old = MakeSmallFreezableCharacter
_G.MakeSmallFreezableCharacter = function(inst, sym, offset)
    MakeSmallFreezableCharacter_old(inst, sym, offset)
    AddShockableComponent_ice(inst, sym, offset, 1)
end

local MakeMediumFreezableCharacter_old = MakeMediumFreezableCharacter
_G.MakeMediumFreezableCharacter = function(inst, sym, offset)
    MakeMediumFreezableCharacter_old(inst, sym, offset)
    AddShockableComponent_ice(inst, sym, offset, 2)
end

local MakeLargeFreezableCharacter_old = MakeLargeFreezableCharacter
_G.MakeLargeFreezableCharacter = function(inst, sym, offset)
    MakeLargeFreezableCharacter_old(inst, sym, offset)
    AddShockableComponent_ice(inst, sym, offset, 2)
end

local MakeHugeFreezableCharacter_old = MakeHugeFreezableCharacter
_G.MakeHugeFreezableCharacter = function(inst, sym, offset)
    MakeHugeFreezableCharacter_old(inst, sym, offset)
    AddShockableComponent_ice(inst, sym, offset, 3)
end

--------------------------------------------------------------------------
--[[ 添加触电相关的sg ]]
--------------------------------------------------------------------------

local function ClearStatusAilments(inst)
    if inst.components.freezable ~= nil and inst.components.freezable:IsFrozen() then
        inst.components.freezable:Unfreeze()
    end
    if inst.components.pinnable ~= nil and inst.components.pinnable:IsStuck() then
        inst.components.pinnable:Unstick()
    end
end

------

local shocked_enter = State{
    name = "shocked_enter",
    tags = { "busy", "nopredict", "nodangle", "shocked" },

    onenter = function(inst)
        ClearStatusAilments(inst)
        _G.ForceStopHeavyLifting_legion(inst)
        inst.components.locomotor:Stop()
        inst:ClearBufferedAction()

        inst.components.inventory:Hide()    --物品栏与科技栏消失
        inst:PushEvent("ms_closepopups")    --关掉打开着的箱子、冰箱等
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:EnableMapControls(false)   --不能打开地图
            inst.components.playercontroller:Enable(false)  --玩家不能操控
            -- inst.components.playercontroller:RemotePausePrediction()
        end

        inst.AnimState:PlayAnimation("shock", true)
    end,

    events =
    {
        EventHandler("unshocked", function(inst)
            inst.sg:GoToState("shocked_exit")
        end),
    },

    onexit = function(inst)
        inst.components.inventory:Show()
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:EnableMapControls(true)
            inst.components.playercontroller:Enable(true)
        end

        if inst.components.shockable ~= nil then
            inst.components.shockable:Unshock()
        end
    end,
}

local shocked_exit = State{
    name = "shocked_exit",
    tags = { "busy", "nopredict", "nodangle" },

    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst:ClearBufferedAction()

        inst.AnimState:PlayAnimation("shock_pst")

        inst.sg:SetTimeout(6 * FRAMES)
    end,

    ontimeout = function(inst)
        inst.sg:GoToState("idle", true)
    end,
}

AddStategraphState("wilson", shocked_enter)
--AddStategraphState("wilson_client", sanddefense_enter)    --客户端与服务端的sg有区别，这里只需要服务端有就行了
AddStategraphState("wilson", shocked_exit)

--通过api添加触电响应函数
AddStategraphEvent("wilson", EventHandler("beshocked", function(inst)
    if inst.components.health ~= nil and not inst.components.health:IsDead() then
        inst.sg:GoToState("shocked_enter")
    end
end))

--------------------------------------------------------------------------
--[[ 修改beefalo以适应新的牛鞍 ]]
--------------------------------------------------------------------------

local function onopen(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
    inst.SoundEmitter:PlaySound("dontstarve/common/together/packaged")

    if not inst.components.combat:HasTarget() then --防止打开箱子时牛乱跑，如果牛有攻击目标则不停止脑子
        if inst.brain ~= nil and not inst.brain.stopped then
            inst.brain:Stop()
        end

        if inst.components.locomotor ~= nil then
            inst.components.locomotor:Stop()
        end
    end
end

local function onclose(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
    inst.SoundEmitter:PlaySound("dontstarve/common/together/packaged")

    if inst.brain ~= nil and inst.brain.stopped then --关闭箱子时恢复牛的脑子
        inst.brain:Start()
    end
end

local function OnMySaddleChanged(inst, data)
    if inst.components.container ~= nil then
        if data.saddle ~= nil and data.saddle:HasTag("containersaddle") then
            inst.components.container.canbeopened = true
        else
            inst.components.container:Close()
            inst.components.container:DropEverything()
            inst.components.container.canbeopened = false
        end
    end
end

local function OnMyDeath(inst, data)
    if inst.components.container ~= nil then
        inst.components.container:Close()
        inst.components.container.canbeopened = false
    end
end

local function OnMyAttacked(inst, data)
    if inst.components.container ~= nil then
        inst.components.container:Close()
    end
end

local function OnMyRiderChanged(inst, data)
    if inst.components.container ~= nil then
        inst.components.container:Close()
    end
end

AddPrefabPostInit("beefalo", function(inst)
    inst:AddTag("fridge") --给予容器0.5保鲜效果
    inst:AddTag("nocool") --没有冷冻的效果

    if TheWorld.ismastersim then
        if inst.components.container == nil then --由于官方的动作检测函数的问题，导致不能中途加入容器组件，所以只能默认每个牛都加个容器组件
            inst:AddComponent("container")
            inst.components.container:WidgetSetup("beefalo")
            inst.components.container.onopenfn = onopen
            inst.components.container.onclosefn = onclose
            inst.components.container.canbeopened = false
        end

        inst:ListenForEvent("saddlechanged", OnMySaddleChanged)
        inst:ListenForEvent("death", OnMyDeath)
        inst:ListenForEvent("attacked", OnMyAttacked)
        inst:ListenForEvent("riderchanged", OnMyRiderChanged)
    end
end)

--------------------------------------------------------------------------
--[[ 新增专属喂牛动作以适应新的牛鞍 ]]
--------------------------------------------------------------------------

local GIVE_RIGHTCLICK = Action({ priority = 1, canforce = true, mount_valid = false, rangecheckfn = ACTIONS.GIVE.rangecheckfn })
GIVE_RIGHTCLICK.id = "GIVE_RIGHTCLICK"    --这个操作的id
GIVE_RIGHTCLICK.str = STRINGS.ACTIONS_LEGION.GIVE_RIGHTCLICK    --这个操作的名字，比如法杖是castspell，蜗牛壳甲是use
GIVE_RIGHTCLICK.fn = function(act) --这个操作执行时进行的功能函数
    if act.target ~= nil then
        if act.target.components.trader ~= nil then
            local able, reason = act.target.components.trader:AbleToAccept(act.invobject, act.doer)
            if not able then
                return false, reason
            end
            act.target.components.trader:AcceptGift(act.doer, act.invobject)
            return true
        end
    end
end
AddAction(GIVE_RIGHTCLICK) --向游戏注册一个动作

--往具有某组件的物品添加动作的检测函数，如果满足条件，就向人物的动作可执行表中加入某个动作。right表示是否是右键动作
AddComponentAction("USEITEM", "tradable", function(inst, doer, target, actions, right)
    if right and target:HasTag("trader")
        and target:HasTag("saddleable") --目标是可骑行的
        and target.replica.container ~= nil and target.replica.container:CanBeOpened() --容器组件可打开
        and not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding()) then --不能骑着牛给东西
        table.insert(actions, ACTIONS.GIVE_RIGHTCLICK) --这里为动作的id
    end
end)

--将一个动作与state绑定
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.GIVE_RIGHTCLICK, "give"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.GIVE_RIGHTCLICK, "give"))    --在联机版中添加新动作需要对wilson和wilson_cient两个sg都进行state绑定

--------------------------------------------------------------------------
--[[ 素白蘑菇帽的打喷嚏释放其技能的sg ]]
--------------------------------------------------------------------------

local release_spores = State{
    name = "release_spores",
    tags = { "busy", "doing", "canrotate" },

    onenter = function(inst, hat)
        if hat == nil then
            inst.sg:GoToState("idle")
            return
        end
        inst.sg.statemem.hat = hat
        inst.sg.statemem.fxcolour = hat.fxcolour or { 1, 1, 1 }
        inst.sg.statemem.castsound = hat.castsound

        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(false)
        end
        inst.AnimState:PlayAnimation("cointoss_pre")
        inst.AnimState:PushAnimation("cointoss", false)
        inst.components.locomotor:Stop()
    end,

    events =
    {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    timeline =
    {
        TimeEvent(7 * FRAMES, function(inst)
            inst.sg.statemem.stafffx = SpawnPrefab((inst.components.rider ~= nil and inst.components.rider:IsRiding()) and "cointosscastfx_mount" or "cointosscastfx")
            inst.sg.statemem.stafffx.AnimState:OverrideSymbol("coin01", "albicansspore_fx", "coin01")
            inst.sg.statemem.stafffx.entity:SetParent(inst.entity)
            inst.sg.statemem.stafffx.Transform:SetRotation(inst.Transform:GetRotation())
            inst.sg.statemem.stafffx:SetUp(inst.sg.statemem.fxcolour)
        end),
        TimeEvent(15 * FRAMES, function(inst)
            inst.sg.statemem.stafflight = SpawnPrefab("staff_castinglight")
            inst.sg.statemem.stafflight.Transform:SetPosition(inst.Transform:GetWorldPosition())
            inst.sg.statemem.stafflight:SetUp(inst.sg.statemem.fxcolour, 1.2, .33)
        end),
        TimeEvent(13 * FRAMES, function(inst)
            if inst.sg.statemem.castsound then
                inst.SoundEmitter:PlaySound(inst.sg.statemem.castsound)
            end
        end),
        TimeEvent(43*FRAMES, function(inst)
            SpawnPrefab("albicanscloud_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
        end),
        TimeEvent(53 * FRAMES, function(inst)
            inst.sg.statemem.stafffx = nil --Can't be cancelled anymore
            inst.sg.statemem.stafflight = nil --Can't be cancelled anymore
            if inst.sg.statemem.hat.releasedfn ~= nil then
                inst.sg.statemem.hat:releasedfn(inst)
            end
        end),
    },

    onexit = function(inst)
        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:Enable(true)
        end
        if inst.sg.statemem.stafffx ~= nil and inst.sg.statemem.stafffx:IsValid() then
            inst.sg.statemem.stafffx:Remove()
        end
        if inst.sg.statemem.stafflight ~= nil and inst.sg.statemem.stafflight:IsValid() then
            inst.sg.statemem.stafflight:Remove()
        end
        if inst.sg.statemem.hat.components.useableitem ~= nil then
            inst.sg.statemem.hat.components.useableitem:StopUsingItem()
        end
    end,
}

AddStategraphState("wilson", release_spores)

AddIngredientValues({"albicans_cap"}, {veggie=2}, false, false)

--------------------------------------------------------------------------
--[[ 灵魂契约书瞬移、加血相关 ]]
--------------------------------------------------------------------------

local function FindItemWithoutContainer(inst, fn)
    local inventory = inst.components.inventory

    for k,v in pairs(inventory.itemslots) do
        if v and fn(v) then
            return v
        end
    end
    if inventory.activeitem and fn(inventory.activeitem) then
        return inventory.activeitem
    end
end

-- 辅助沃托克斯管理灵魂
local onsetonwer_f = false
local ondropitem_f = false
AddPrefabPostInit("wortox", function(inst)
    --携带契约书能够使用瞬移
    if not onsetonwer_f then
        onsetonwer_f = true
        ---------------------------
        --因为upvaluehelper机制是一次修改，影响全局，所以用onsetonwer_f等变量来控制只修改一次，防止函数越套越厚，
        --还要记得清除不再使用的变量
        ---------------------------
        local OnSetOwner = upvaluehelper.GetEventHandle(inst, "setowner", "prefabs/wortox")
        if OnSetOwner ~= nil then
            local GetPointSpecialActions_old = upvaluehelper.Get(OnSetOwner, "GetPointSpecialActions")
            if GetPointSpecialActions_old ~= nil then
                local function GetPointSpecialActions_new(inst, pos, useitem, right)
                    if right and useitem == nil and (inst.replica.rider == nil or not inst.replica.rider:IsRiding()) then
                        local items = inst.replica.inventory:GetItems()
                        for k,v in pairs(items) do
                            if v:HasTag("soulcontracts") and not v:HasTag("nosoulleft") then
                                return { ACTIONS.BLINK }
                            end
                        end
                    end
                    return GetPointSpecialActions_old(inst, pos, useitem, right)
                end
                upvaluehelper.Set(OnSetOwner, "GetPointSpecialActions", GetPointSpecialActions_new)
            end
        end
        OnSetOwner = nil
    end

    if IsServer then
        --使用灵魂后提示契约书中灵魂数量
        if not ondropitem_f then
            ondropitem_f = true
            local OnDropItem = upvaluehelper.GetEventHandle(inst, "dropitem", "prefabs/wortox")
            if OnDropItem ~= nil then
                local CheckSoulsRemoved_old = upvaluehelper.Get(OnDropItem, "CheckSoulsRemoved")
                if CheckSoulsRemoved_old ~= nil then
                    local function CheckSoulsRemoved_new(inst)
                        local book = FindItemWithoutContainer(inst, function(item)
                            return item:HasTag("soulcontracts")
                        end)
                        if book ~= nil and book.components.finiteuses ~= nil then
                            inst._checksoulstask = nil
                            if book.components.finiteuses:GetPercent() <= 0 then
                                inst:PushEvent("soulempty")
                            elseif book.components.finiteuses:GetPercent() < 0.2 then
                                inst:PushEvent("soultoofew")
                            end
                        else
                            CheckSoulsRemoved_old(inst)
                        end
                    end
                    upvaluehelper.Set(OnDropItem, "CheckSoulsRemoved", CheckSoulsRemoved_new)
                end
            end
            OnDropItem = nil
        end
    end

end)

if IsServer then
    local seeksoulstealer_f = false
    AddPrefabPostInit("wortox_soul_spawn", function(inst)
        --灵魂优先寻找契约
        if not seeksoulstealer_f then
            seeksoulstealer_f = true
            local SeekSoulStealer_old = upvaluehelper.Get(_G.Prefabs["wortox_soul_spawn"].fn, "SeekSoulStealer")
            if SeekSoulStealer_old ~= nil then
                local function SeekSoulStealer_new(inst)
                    local thebook = FindEntity(
                        inst,
                        TUNING.WORTOX_SOULSTEALER_RANGE,
                        function(item)
                            --寻找未装满的契约书
                            return item:IsValid() and item.entity:IsVisible() and
                                (item.components.finiteuses ~= nil and item.components.finiteuses:GetPercent() < 1)
                        end,
                        { "soulcontracts" },
                        { "NOCLICK", "FX", "INLIMBO" },
                        nil
                    )
                    if thebook ~= nil then
                        inst.components.projectile:Throw(inst, thebook, inst)
                    else
                        SeekSoulStealer_old(inst)
                    end
                end
                upvaluehelper.Set(_G.Prefabs["wortox_soul_spawn"].fn, "SeekSoulStealer", SeekSoulStealer_new)
            end
        end

        --优化灵魂进入契约或者玩家时的逻辑
        local OnHit_old = inst.components.projectile.onhit
        inst.components.projectile:SetOnHitFn(function(inst, attacker, target)
            if target ~= nil then
                local book = nil
                if target:HasTag("soulcontracts") then --进入地面的契约书
                    book = target
                elseif target.components.inventory ~= nil then --击中玩家时，有携带契约书的话
                    book = FindItemWithoutContainer(target, function(item)
                        if item:HasTag("soulcontracts") then
                            return true
                        end
                        return false
                    end)
                end

                if book ~= nil then
                    --命中特效
                    local fx = SpawnPrefab("wortox_soul_in_fx")
                    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
                    fx:Setup(target)

                    --直接跳过灵魂进入物品栏过程，给书恢复耐久，并且释放多余灵魂
                    if book.components.finiteuses ~= nil and book._SoulHealing ~= nil then
                        if book.components.finiteuses:GetPercent() >= 1 then --耐久满了
                            if target.components.inventory == nil then --地面的书，触发加血效果
                                book._SoulHealing(book)
                            else --物品栏的书，如果携带的灵魂满了才释放加血效果
                                local souls = target.components.inventory:FindItems(function(item)
                                    return item.prefab == "wortox_soul"
                                end)
                                local soulscount = 0
                                for i, v in ipairs(souls) do
                                    soulscount = soulscount +
                                        (v.components.stackable ~= nil and v.components.stackable:StackSize() or 1)
                                end
                                if soulscount >= TUNING.WORTOX_MAX_SOULS then --灵魂满了，释放加血效果
                                    book._SoulHealing(target)
                                else --灵魂没有满，直接给玩家灵魂
                                    if OnHit_old ~= nil then
                                        OnHit_old(inst, attacker, target)
                                        return
                                    end
                                end
                            end
                        else
                            book.components.finiteuses:SetUses(book.components.finiteuses:GetUses() + 1)
                        end
                    end

                    inst:Remove()
                    return
                end
            end

            if OnHit_old ~= nil then
                OnHit_old(inst, attacker, target)
            end
        end)
    end)

    --瞬移动作响应时能消耗契约书中的灵魂
    local BLINK_fn_old = ACTIONS.BLINK.fn
    ACTIONS.BLINK.fn = function(act)
        local act_pos = act:GetActionPoint()
        if act.invobject == nil
            and act.doer ~= nil
            and act.doer:HasTag("soulstealer")
            and act.doer.sg ~= nil
            and act.doer.sg.currentstate.name == "portal_jumpin_pre"
            and act_pos ~= nil
            and act.doer.components.inventory ~= nil
        then
            local contracts = FindItemWithoutContainer(act.doer, function(item)
                return item:HasTag("soulcontracts") and
                    item.components.finiteuses ~= nil and
                    item.components.finiteuses:GetUses() > 0
            end)

            if contracts ~= nil then
                contracts.components.finiteuses:Use(1)
                act.doer.sg:GoToState("portal_jumpin", act_pos)
                return true
            end
        end

        return BLINK_fn_old(act)
    end
end

--------------------------------------------------------------------------
--[[ 灵魂契约的摄食动作 ]]
--------------------------------------------------------------------------

-- local eat_contracts = State{
--     name = "eat_contracts",
--     tags = { "busy", "nodangle" },

--     onenter = function(inst, foodinfo)
--         inst.components.locomotor:Stop()

--         local feed = foodinfo and foodinfo.feed
--         if feed ~= nil then
--             inst.components.locomotor:Clear()
--             inst:ClearBufferedAction()
--             inst.sg.statemem.feed = foodinfo.feed
--             inst.sg.statemem.feeder = foodinfo.feeder
--             inst.sg:AddStateTag("pausepredict")
--             if inst.components.playercontroller ~= nil then
--                 inst.components.playercontroller:RemotePausePrediction()
--             end
--         elseif inst:GetBufferedAction() then
--             feed = inst:GetBufferedAction().invobject
--         end

--         inst.SoundEmitter:PlaySound("dontstarve/wilson/eat", "eating")

--         if feed ~= nil and feed.components.soulcontracts ~= nil then
--             inst.sg.statemem.soulfx = SpawnPrefab("wortox_eat_soul_fx")
--             inst.sg.statemem.soulfx.Transform:SetRotation(inst.Transform:GetRotation())
--             inst.sg.statemem.soulfx.entity:SetParent(inst.entity)
--             if inst.components.rider:IsRiding() then
--                 inst.sg.statemem.soulfx:MakeMounted()
--             end
--         end

--         if inst.components.inventory:IsHeavyLifting() and not inst.components.rider:IsRiding() then
--             inst.AnimState:PlayAnimation("heavy_eat")
--         else
--             inst.AnimState:PlayAnimation("eat_pre")
--             inst.AnimState:PushAnimation("eat", false)
--         end

--         inst.components.hunger:Pause()
--     end,

--     timeline =
--     {
--         TimeEvent(28 * FRAMES, function(inst)
--             if inst.sg.statemem.feed == nil then
--                 --触发这里action.fn的食用来自于自己吃
--                 inst:PerformBufferedAction()
--             elseif inst.sg.statemem.feeder ~= nil and
--                 inst.sg.statemem.feed.components.soulcontracts ~= nil and
--                 inst.sg.statemem.feed.components.soulcontracts:CanEat(inst.sg.statemem.feeder)
--             then
--                 --触发这里的食用来自于别人的喂食
--                 inst.sg.statemem.feed.components.soulcontracts:EatSoul(inst.sg.statemem.feeder)
--             end
--         end),
--         TimeEvent(30 * FRAMES, function(inst)
--             inst.sg:RemoveStateTag("busy")
--             inst.sg:RemoveStateTag("pausepredict")
--         end),
--         TimeEvent(70 * FRAMES, function(inst)
--             inst.SoundEmitter:KillSound("eating")
--         end),
--     },

--     events =
--     {
--         EventHandler("animqueueover", function(inst)
--             if inst.AnimState:AnimDone() then
--                 inst.sg:GoToState("idle")
--             end
--         end),
--     },

--     onexit = function(inst)
--         inst.SoundEmitter:KillSound("eating")
--         if not GetGameModeProperty("no_hunger") then
--             inst.components.hunger:Resume()
--         end
--         if inst.sg.statemem.soulfx ~= nil then
--             inst.sg.statemem.soulfx:Remove()
--         end
--     end,
-- }
-- AddStategraphState("wilson", eat_contracts)

----------

local EAT_CONTRACTS = Action({ mount_valid=true })
EAT_CONTRACTS.id = "EAT_CONTRACTS"
EAT_CONTRACTS.str = STRINGS.ACTIONS_LEGION.EAT_CONTRACTS
EAT_CONTRACTS.fn = function(act)
    local obj = act.target or act.invobject
    if obj ~= nil then
        if obj.components.soulcontracts ~= nil and obj.components.soulcontracts:CanEat(act.doer) then
            return obj.components.soulcontracts:EatSoul(act.doer)
        end
    end
end
AddAction(EAT_CONTRACTS)

AddComponentAction("INVENTORY", "soulcontracts", function(inst, doer, actions, right)
    --鼠标指向物品栏里的对象时，或者在鼠标上的对象指向玩家自己时，触发
    if doer:HasTag("souleater") and not inst:HasTag("nosoulleft") then
        table.insert(actions, ACTIONS.EAT_CONTRACTS)
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.EAT_CONTRACTS, function(inst, action)
    if inst.sg:HasStateTag("busy") then
        return
    end

    local obj = action.target or action.invobject --实际上invobject才有数据
    if obj == nil or obj.components.soulcontracts == nil or not obj.components.soulcontracts:CanEat(inst) then
        return
    end

    --这样设置是为了使用原版的sg，不然要是官方改了什么细节我还得跟着改
    -- action.invobject = SpawnPrefab("wortox_soul") --tip：动作触发物品不能被修改，改了就会导致动作失败
    inst:DoTaskInTime(0, function() --增加摄食灵魂时的特效（因为不满足sg里的条件，所以这里我自己加了特效）
        if inst.sg and inst.sg.statemem then
            inst.sg.statemem.soulfx = SpawnPrefab("wortox_eat_soul_fx")
            inst.sg.statemem.soulfx.entity:SetParent(inst.entity)
            if inst.components.rider:IsRiding() then
                inst.sg.statemem.soulfx:MakeMounted()
            end
        end
    end)

    return "eat"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.EAT_CONTRACTS, function(inst, action)
    if inst.sg:HasStateTag("busy") or inst:HasTag("busy") or not inst:HasTag("souleater") then
        return
    end
    local obj = action.target or action.invobject
    if obj == nil then
        return
    elseif obj:HasTag("soulcontracts") and not obj:HasTag("nosoulleft") then
        return "eat" --这里可以直接用客机的sg
    end
end))

--------------------------------------------------------------------------
--[[ 灵魂契约的收回动作 ]]
--------------------------------------------------------------------------

local PICKUP_CONTRACTS = Action({ mount_valid=true })
PICKUP_CONTRACTS.id = "PICKUP_CONTRACTS"
PICKUP_CONTRACTS.str = STRINGS.ACTIONS_LEGION.PICKUP_CONTRACTS
PICKUP_CONTRACTS.fn = function(act)
    if
        act.doer.components.inventory ~= nil and
        act.target ~= nil and
        act.target.components.soulcontracts ~= nil and
        not act.target:IsInLimbo()
    then
        return act.target.components.soulcontracts:PickUp(act.doer)
    end
end
AddAction(PICKUP_CONTRACTS)

AddComponentAction("SCENE", "inventoryitem", function(inst, doer, actions, right)
    if
        doer.replica.inventory ~= nil and doer.replica.inventory:GetNumSlots() > 0 and
        not right
    then
        table.insert(actions, ACTIONS.PICKUP_CONTRACTS)
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.PICKUP_CONTRACTS, function(inst, action)
    return (inst.components.rider ~= nil and inst.components.rider:IsRiding()) and "domediumaction" or "doshortaction"
end))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.PICKUP_CONTRACTS, function(inst, action)
    return (inst.replica.rider ~= nil and inst.replica.rider:IsRiding()) and "domediumaction" or "doshortaction"
end))

--------------------------------------------------------------------------
--[[ 灵魂契约的跟随状态切换动作 ]]
--------------------------------------------------------------------------

local EXSTAY_CONTRACTS = Action({ mount_valid=true, distance=20 })
EXSTAY_CONTRACTS.id = "EXSTAY_CONTRACTS"
EXSTAY_CONTRACTS.str = STRINGS.ACTIONS.EXSTAY_CONTRACTS
EXSTAY_CONTRACTS.strfn = function(act)
    if act.target ~= nil then
        if act.target:HasTag("bookstaying") then
            return "GENERIC"
        end
    end
    return "STAY"
end
EXSTAY_CONTRACTS.fn = function(act)
    if
        act.target ~= nil and not act.target:IsInLimbo() and
        act.target.components.soulcontracts ~= nil
    then
        return act.target.components.soulcontracts:TriggerStaying(
            not act.target.components.soulcontracts.staying, act.doer)
    end

    return false, "NORIGHT"
end
AddAction(EXSTAY_CONTRACTS)

AddComponentAction("SCENE", "soulcontracts", function(inst, doer, actions, right)
    if right then
        table.insert(actions, ACTIONS.EXSTAY_CONTRACTS)
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.EXSTAY_CONTRACTS, "veryquickcastspell"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.EXSTAY_CONTRACTS, "veryquickcastspell"))

--------------------------------------------------------------------------
--[[ 灵魂契约的给予灵魂动作 ]]
--------------------------------------------------------------------------

local GIVE_CONTRACTS = Action({ priority=4, mount_valid=true })
GIVE_CONTRACTS.id = "GIVE_CONTRACTS"
GIVE_CONTRACTS.str = STRINGS.ACTIONS_LEGION.GIVE_CONTRACTS
GIVE_CONTRACTS.fn = function(act)
    if
        act.invobject ~= nil and
        act.target ~= nil and act.target.components.soulcontracts ~= nil
    then
        return act.target.components.soulcontracts:GiveSoul(act.doer, act.invobject)
    end
end
AddAction(GIVE_CONTRACTS)

AddComponentAction("USEITEM", "soul", function(inst, doer, target, actions, right)
    if target and target:HasTag("soulcontracts") then
        table.insert(actions, ACTIONS.GIVE_CONTRACTS)
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.GIVE_CONTRACTS, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.GIVE_CONTRACTS, "doshortaction"))
