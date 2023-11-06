local prefabFiles = {
    "fimbul_fx",                --芬布尔相关fx
    "boss_elecarmet",           --莱克阿米特
    "elecourmaline",            --电气重铸台
    "hat_cowboy",               --牛仔套装
    "icire_rock",               --鸳鸯石
    "guitar_miguel",            --米格尔的吉他
    "legion_soul_fx",           --灵魂契约特效
    "the_gifted",               --重铸科技，针对每个角色的独有制作物
    "saddle_baggage",           --驮物牛鞍
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
    Asset("ATLAS", "images/inventoryimages/triplegoldenshovelaxe.xml"),
    Asset("IMAGE", "images/inventoryimages/triplegoldenshovelaxe.tex"),
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
    Asset("ATLAS", "images/inventoryimages/tourmalinecore.xml"),
    Asset("IMAGE", "images/inventoryimages/tourmalinecore.tex"),
    Asset("ATLAS", "images/inventoryimages/tourmalineshard.xml"),
    Asset("IMAGE", "images/inventoryimages/tourmalineshard.tex")
}

for k,v in pairs(assets) do
    table.insert(Assets, v)
end

-----

local _G = GLOBAL
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()
local TOOLS_L = require("tools_legion")

--监听函数修改工具，超强der大佬写滴！
local upvaluehelper = require "hua_upvaluehelper"

_G.RegistMiniMapImage_legion("elecourmaline")
_G.RegistMiniMapImage_legion("soul_contracts")

--------------------------------------------------------------------------
--[[ 电气石重铸台相关 ]]
--------------------------------------------------------------------------

local tech_recast
local lock_recast
if _G.CONFIGS_LEGION.TECHUNLOCK == "lootdropper" then
    tech_recast = { TECH.LOST, TECH.LOST }
    lock_recast = nil
else
    tech_recast = { TECH.ELECOURMALINE_ONE, TECH.ELECOURMALINE_THREE }
    lock_recast = true
end

AddRecipe2(
    "tripleshovelaxe", {
        Ingredient("axe", 1),
        Ingredient("pickaxe", 1),
        Ingredient("shovel", 1)
    }, tech_recast[1], {
        nounlock = lock_recast,
        atlas = "images/inventoryimages/tripleshovelaxe.xml", image = "tripleshovelaxe.tex"
    }, { "RECAST", "TOOLS" }
)
AddRecipe2(
    "dualwrench", {
        Ingredient("hammer", 1),
        Ingredient("goldnugget", 1),
        Ingredient("pitchfork", 1)
    }, tech_recast[1], {
        nounlock = lock_recast,
        atlas = "images/inventoryimages/dualwrench.xml", image = "dualwrench.tex"
    }, { "RECAST", "TOOLS" }
)
AddRecipe2(
    "icire_rock", {
        Ingredient("amulet", 1),
        Ingredient("heatrock", 2),
        Ingredient("blueamulet", 1)
    }, tech_recast[1], {
        nounlock = lock_recast,
        atlas = "images/inventoryimages/icire_rock.xml", image = "icire_rock.tex"
    }, { "RECAST", "WINTER", "SUMMER" }
)
AddRecipe2(
    "explodingfruitcake", {
        Ingredient("winter_food4", 1),
        Ingredient("gunpowder", 2)
    }, tech_recast[1], {
        nounlock = lock_recast,
        atlas = "images/inventoryimages/explodingfruitcake.xml", image = "explodingfruitcake.tex"
    }, { "RECAST", "WEAPONS" }
)
AddRecipe2(
    "fishhomingtool_awesome", {
        Ingredient("fishhomingtool_normal", 5, "images/inventoryimages/fishhomingtool_normal.xml"),
        Ingredient("chum", 2)
    }, tech_recast[1], {
        nounlock = lock_recast,
        atlas = "images/inventoryimages/fishhomingtool_awesome.xml", image = "fishhomingtool_awesome.tex"
    }, { "RECAST", "FISHING" }
)
AddRecipe2(
    "tourmalinecore", {
        Ingredient("redgem", 10),
        Ingredient("tourmalineshard", 10, "images/inventoryimages/tourmalineshard.xml"),
        Ingredient("moonstorm_spark", 10)
    }, tech_recast[2], {
        nounlock = lock_recast, no_deconstruction = true,
        atlas = "images/inventoryimages/tourmalinecore.xml", image = "tourmalinecore.tex"
    }, { "RECAST", "REFINE" }
)
AddRecipe2(
    "triplegoldenshovelaxe", {
        Ingredient("goldenaxe", 2),
        Ingredient("goldenpickaxe", 2),
        Ingredient("goldenshovel", 2)
    }, tech_recast[2], {
        nounlock = lock_recast,
        atlas = "images/inventoryimages/triplegoldenshovelaxe.xml", image = "triplegoldenshovelaxe.tex"
    }, { "RECAST", "TOOLS" }
)
AddRecipe2(
    "hat_cowboy", {
        Ingredient("beefalohat", 1),
        Ingredient("rainhat", 1),
        Ingredient("tophat", 1)
    }, tech_recast[2], {
        nounlock = lock_recast,
        atlas = "images/inventoryimages/hat_cowboy.xml", image = "hat_cowboy.tex"
    }, { "RECAST", "RAIN", "SUMMER", "RIDING", "CLOTHING" }
)
AddRecipe2(
    "saddle_baggage", {
        Ingredient("bedroll_straw", 1),
        Ingredient("saddle_basic", 1),
        Ingredient("bundlewrap", 2)
    }, tech_recast[2], {
        nounlock = lock_recast,
        atlas = "images/inventoryimages/saddle_baggage.xml", image = "saddle_baggage.tex"
    }, { "RECAST", "RIDING", "COOKING", "CONTAINERS" }
)
AddRecipe2(
    "hat_albicans_mushroom", {
        Ingredient("red_mushroomhat", 1),
        Ingredient("green_mushroomhat", 1),
        Ingredient("blue_mushroomhat", 1)
    }, tech_recast[2], {
        nounlock = lock_recast,
        atlas = "images/inventoryimages/hat_albicans_mushroom.xml", image = "hat_albicans_mushroom.tex"
    }, { "RECAST", "CLOTHING", "SUMMER", "GARDENING", "RAIN" }
)
AddRecipe2(
    "siving_mask_gold", {
        Ingredient("goggleshat", 1),
        Ingredient("siving_mask", 1, "images/inventoryimages/siving_mask.xml"),
        Ingredient("siving_derivant_item", 1, "images/inventoryimages/siving_derivant_item.xml"),
        Ingredient("dish_shyerryjam", 1, "images/inventoryimages/dish_shyerryjam.xml")
    }, tech_recast[2], {
        nounlock = lock_recast,
        atlas = "images/inventoryimages/siving_mask_gold.xml", image = "siving_mask_gold.tex"
    }, { "RECAST", "ARMOUR", "MAGIC", "RESTORATION" }
)
AddRecipe2(
    "siving_ctlall_item", {
        Ingredient("siving_ctlwater_item", 1, "images/inventoryimages/siving_ctlwater_item.xml"),
        Ingredient("siving_ctldirt_item", 1, "images/inventoryimages/siving_ctldirt_item.xml"),
        Ingredient("siving_derivant_item", 1, "images/inventoryimages/siving_derivant_item.xml"),
        Ingredient("singingshell_octave4", 1, nil, nil, "singingshell_octave4_1.tex")
    }, tech_recast[2], {
        nounlock = lock_recast,
        atlas = "images/inventoryimages/siving_ctlall_item.xml", image = "siving_ctlall_item.tex"
    }, { "RECAST", "MAGIC", "GARDENING", "STRUCTURES" }
)
AddRecipe2(
    "hat_elepheetle", {
        Ingredient("cookiecutterhat", 1),
        Ingredient("insectshell_l", 30, "images/inventoryimages/insectshell_l.xml"),
        Ingredient("goldnugget", 10),
        Ingredient("slurtlehat", 1)
    }, tech_recast[2], {
        nounlock = lock_recast,
        atlas = "images/inventoryimages/hat_elepheetle.xml", image = "hat_elepheetle.tex"
    }, { "RECAST", "ARMOUR" }
)
AddRecipe2(
    "armor_elepheetle", {
        Ingredient("armormarble", 1),
        Ingredient("insectshell_l", 30, "images/inventoryimages/insectshell_l.xml"),
        Ingredient("goldnugget", 10),
        Ingredient("armorsnurtleshell", 1)
    }, tech_recast[2], {
        nounlock = lock_recast,
        atlas = "images/inventoryimages/armor_elepheetle.xml", image = "armor_elepheetle.tex"
    }, { "RECAST", "ARMOUR" }
)
AddRecipe2(
    "guitar_miguel", {
        Ingredient("panflute", 1),
        Ingredient("onemanband", 1)
    }, tech_recast[2], {
        nounlock = lock_recast,
        atlas = "images/inventoryimages/guitar_miguel.xml", image = "guitar_miguel.tex"
    }, { "RECAST", "GARDENING", "MAGIC" }
)
AddRecipe2(
    "web_hump_item", {
        Ingredient("monstermeat_dried", 12),
        Ingredient("minisign_item", 2),
        Ingredient("silk", 12)
    }, tech_recast[2], {
        nounlock = lock_recast, builder_tag = lock_recast and "spiderwhisperer" or nil,
        atlas = "images/inventoryimages/web_hump_item.xml", image = "web_hump_item.tex"
    }, { "RECAST", "STRUCTURES", "DECOR", "CHARACTER" }
)
AddRecipe2(
    "soul_contracts", {
        Ingredient("wortox_soul", 20),
        Ingredient("mapscroll", 5),
        Ingredient("reviver", 2),
        Ingredient("nightmarefuel", 20)
    }, tech_recast[2], {
        nounlock = lock_recast, builder_tag = lock_recast and "soulstealer" or nil,
        atlas = "images/inventoryimages/soul_contracts.xml", image = "soul_contracts.tex"
    }, { "RECAST", "RESTORATION", "MAGIC", "CHARACTER" }
)

--这个配方用来便于绿宝石法杖分解
AddDeconstructRecipe("web_hump", {
    Ingredient("monstermeat_dried", 12),
    Ingredient("minisign_item", 2),
    Ingredient("silk", 12)
})

tech_recast = nil
lock_recast = nil

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
    MakeSmallBurnableCharacter_old(inst, sym, offset)
    AddShockable(inst, 1)
end

local MakeMediumBurnableCharacter_old = MakeMediumBurnableCharacter
_G.MakeMediumBurnableCharacter = function(inst, sym, offset)
    MakeMediumBurnableCharacter_old(inst, sym, offset)
    AddShockable(inst, 2)
end

local MakeLargeBurnableCharacter_old = MakeLargeBurnableCharacter
_G.MakeLargeBurnableCharacter = function(inst, sym, offset)
    MakeLargeBurnableCharacter_old(inst, sym, offset)
    AddShockable(inst, 3)
end

local MakeTinyFreezableCharacter_old = MakeTinyFreezableCharacter
_G.MakeTinyFreezableCharacter = function(inst, sym, offset)
    MakeTinyFreezableCharacter_old(inst, sym, offset)
    AddShockable(inst, 1)
end

local MakeSmallFreezableCharacter_old = MakeSmallFreezableCharacter
_G.MakeSmallFreezableCharacter = function(inst, sym, offset)
    MakeSmallFreezableCharacter_old(inst, sym, offset)
    AddShockable(inst, 1)
end

local MakeMediumFreezableCharacter_old = MakeMediumFreezableCharacter
_G.MakeMediumFreezableCharacter = function(inst, sym, offset)
    MakeMediumFreezableCharacter_old(inst, sym, offset)
    AddShockable(inst, 2)
end

local MakeLargeFreezableCharacter_old = MakeLargeFreezableCharacter
_G.MakeLargeFreezableCharacter = function(inst, sym, offset)
    MakeLargeFreezableCharacter_old(inst, sym, offset)
    AddShockable(inst, 2)
end

local MakeHugeFreezableCharacter_old = MakeHugeFreezableCharacter
_G.MakeHugeFreezableCharacter = function(inst, sym, offset)
    MakeHugeFreezableCharacter_old(inst, sym, offset)
    AddShockable(inst, 3)
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
    tags = { "busy", "nopredict", "nodangle", "shocked_l" },

    onenter = function(inst)
        ClearStatusAilments(inst)
        TOOLS_L.ForceStopHeavyLifting(inst)
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

    events = {
        EventHandler("unshocked", function(inst)
            inst.sg:GoToState("shocked_exit")
        end),
        EventHandler("attacked", function(inst)
            inst.sg:GoToState("shocked_exit")
        end)
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
    end
}
local shocked_exit = State{
    name = "shocked_exit",
    tags = { "idle", "canrotate", "nodangle" },

    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst:ClearBufferedAction()

        inst.AnimState:PlayAnimation("shock_pst")

        inst.sg:SetTimeout(6 * FRAMES)
    end,

    ontimeout = function(inst)
        inst.sg:GoToState("idle", true)
    end
}

AddStategraphState("wilson", shocked_enter)
--AddStategraphState("wilson_client", sanddefense_enter) --客户端与服务端的sg有区别，这里只需要服务端有就行了
AddStategraphState("wilson", shocked_exit)

--通过api添加触电响应函数
AddStategraphEvent("wilson", EventHandler("beshocked", function(inst)
    if inst.components.health ~= nil and not inst.components.health:IsDead() then
        if not inst.sg:HasStateTag("shocked_l") then --防止重复进入sg导致触发 onexit 中的 Unshock() 而导致连续麻痹时会失效
            inst.sg:GoToState("shocked_enter")
        end
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

    if IsServer then
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

------右键存放动作------

local STORE_BEEF_L = Action({ priority = 2, mount_valid = true })
STORE_BEEF_L.id = "STORE_BEEF_L" --这个操作的id
STORE_BEEF_L.str = STRINGS.ACTIONS_LEGION.STORE_BEEF_L --这个操作的名字，比如法杖是castspell，蜗牛壳甲是use
STORE_BEEF_L.fn = ACTIONS.STORE.fn --这个操作执行时进行的功能函数
AddAction(STORE_BEEF_L) --向游戏注册一个动作

-- STORE_BEEF_L 组件动作响应已移到 CA_U_INVENTORYITEM_L 中

--将一个动作与state绑定
AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.STORE_BEEF_L, "give"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.STORE_BEEF_L, "give")) --在联机版中添加新动作需要对wilson和wilson_cient两个sg都进行state绑定

------左键喂食动作------

--喂食的优先级得小于存放的
local FEED_BEEF_L = Action({ priority = 1, mount_valid = true, canforce=true, rangecheckfn = ACTIONS.GIVE.rangecheckfn })
FEED_BEEF_L.id = "FEED_BEEF_L"
FEED_BEEF_L.str = STRINGS.ACTIONS_LEGION.FEED_BEEF_L
FEED_BEEF_L.fn = ACTIONS.GIVE.fn
AddAction(FEED_BEEF_L)

AddComponentAction("USEITEM", "tradable", function(inst, doer, target, actions, right)
    if
        target:HasTag("trader") and target:HasTag("saddleable") and
        target.replica.container ~= nil and target.replica.container:CanBeOpened() and --该动作只针对驮运鞍具的牛
        not (
            doer.replica.rider ~= nil and doer.replica.rider:IsRiding() and
            not (target.replica.inventoryitem ~= nil and target.replica.inventoryitem:IsGrandOwner(doer))
        )
    then
        table.insert(actions, ACTIONS.FEED_BEEF_L) --非要我重新写一个动作才让这个动作生效，无语
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.FEED_BEEF_L, "give"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.FEED_BEEF_L, "give"))

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

--------------------------------------------------------------------------
--[[ 灵魂契约书瞬移、加血相关 ]]
--------------------------------------------------------------------------

-- local function FindItemWithoutContainer(inst, fn)
--     local inventory = inst.components.inventory
--     for k,v in pairs(inventory.itemslots) do
--         if v and fn(v) then
--             return v
--         end
--     end
--     if inventory.activeitem and fn(inventory.activeitem) then
--         return inventory.activeitem
--     end
-- end

--[[
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
                    if
                        right and useitem == nil and
                        not TheWorld.Map:IsGroundTargetBlocked(pos) and
                        (inst.replica.rider == nil or not inst.replica.rider:IsRiding())
                    then
                        local items = inst.replica.inventory:GetItems()
                        for _,v in pairs(items) do
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
]]--

if IsServer then
    local function GetSouls(inst)
        local souls = inst.components.inventory:FindItems(function(item)
            return item.prefab == "wortox_soul"
        end)
        local soulscount = 0
        for i, v in ipairs(souls) do
            soulscount = soulscount +
                (v.components.stackable ~= nil and v.components.stackable:StackSize() or 1)
        end
        return souls, soulscount
    end
    local function SetSoulFx(book, doer)
        local fx = SpawnPrefab(book._dd and book._dd.fx or "wortox_soul_in_fx")
        fx.Transform:SetPosition(doer.Transform:GetWorldPosition())
        fx:Setup(doer)
    end
    local function ValidSoulTarget(v)
        if
            v.components.health ~= nil and not v.components.health:IsDead() and
            not v:HasTag("playerghost")
        then
            return true
        end
    end

    local seeksoulstealer_f = false
    AddPrefabPostInit("wortox_soul_spawn", function(inst)
        --灵魂优先寻找契约，或者契约的主人
        if not seeksoulstealer_f then
            seeksoulstealer_f = true
            local SeekSoulStealer_old = upvaluehelper.Get(_G.Prefabs["wortox_soul_spawn"].fn, "SeekSoulStealer")
            if SeekSoulStealer_old ~= nil then
                local function SeekSoulStealer_new(inst)
                    local toer = FindEntity(inst, TUNING.WORTOX_SOULSTEALER_RANGE+4, function(one, inst)
                        if one.components.finiteuses ~= nil then
                            if one.components.finiteuses:GetPercent() >= 1 then
                                if
                                    one._contractsowner ~= nil and one._contractsowner:IsValid() and
                                    ValidSoulTarget(one._contractsowner)
                                then
                                    return true
                                end
                            else
                                return true
                            end
                        elseif one._contracts_l ~= nil and ValidSoulTarget(one) then
                            return true
                        end
                    end, nil, { "INLIMBO", "NOCLICK", "playerghost", "notarget" }, { "soulcontracts", "player" })
                    if toer ~= nil then
                        if toer.components.finiteuses ~= nil and toer.components.finiteuses:GetPercent() >= 1 then
                            if toer._contractsowner ~= nil then
                                toer = toer._contractsowner --如果耐久满了，则寻找其主人
                            end
                        end
                        inst.components.projectile:Throw(inst, toer, inst)
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
                local owner = nil
                local book = nil
                if target:HasTag("soulcontracts") then
                    book = target
                    if book._contractsowner ~= nil and book._contractsowner:IsValid() then
                        owner = book._contractsowner
                    end
                elseif target.components.inventory ~= nil then
                    owner = target
                    if owner._contracts_l ~= nil and owner._contracts_l:IsValid() then
                        book = owner._contracts_l
                    end
                end
                if book ~= nil and book.components.finiteuses ~= nil then
                    if book.components.finiteuses:GetPercent() < 1 then
                        book.components.finiteuses:Repair(1)
                        SetSoulFx(book, book)
                    elseif
                        owner ~= nil and owner.components.inventory ~= nil and
                        owner.components.inventory.isopen --这里应该可以规避死亡状态的玩家，所以就不多判断了
                    then
                        local souls, count = GetSouls(owner)
                        if count >= TUNING.WORTOX_MAX_SOULS then --灵魂达到上限，自动释放
                            if book._SoulHealing ~= nil  then
                                book._SoulHealing(owner)
                            end
                        else
                            owner.components.inventory:GiveItem(SpawnPrefab("wortox_soul"), nil, owner:GetPosition())
                        end
                        SetSoulFx(book, owner)
                    elseif book._SoulHealing ~= nil then
                        book._SoulHealing(book)
                        SetSoulFx(book, book)
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
end

--------------------------------------------------------------------------
--[[ 灵魂契约的索取动作 ]]
--------------------------------------------------------------------------

local RETURN_CONTRACTS = Action({ mount_valid=true })
RETURN_CONTRACTS.id = "RETURN_CONTRACTS"
RETURN_CONTRACTS.str = STRINGS.ACTIONS_LEGION.RETURN_CONTRACTS
RETURN_CONTRACTS.fn = function(act)
    local obj = act.target or act.invobject
    if obj ~= nil then
        if obj.components.soulcontracts ~= nil then
            return obj.components.soulcontracts:ReturnSouls(act.doer)
        end
    end
end
AddAction(RETURN_CONTRACTS)

AddComponentAction("INVENTORY", "soulcontracts", function(inst, doer, actions, right)
    --鼠标指向物品栏里的对象时，或者在鼠标上的对象指向玩家自己时，触发
    if not inst:HasTag("nosoulleft") then
        table.insert(actions, ACTIONS.RETURN_CONTRACTS)
    end
end)

AddStategraphActionHandler("wilson", ActionHandler(ACTIONS.RETURN_CONTRACTS, "doshortaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ACTIONS.RETURN_CONTRACTS, "doshortaction"))

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
        return act.target.components.soulcontracts:TriggerOwner(nil, act.doer)
    end
    return false, "NORIGHT"
end
AddAction(EXSTAY_CONTRACTS)

AddComponentAction("SCENE", "soulcontracts", function(inst, doer, actions, right)
    if right then
        table.insert(actions, ACTIONS.EXSTAY_CONTRACTS)
    elseif doer.replica.inventory ~= nil and doer.replica.inventory:GetNumSlots() > 0 then
        table.insert(actions, ACTIONS.PICKUP_CONTRACTS)
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
