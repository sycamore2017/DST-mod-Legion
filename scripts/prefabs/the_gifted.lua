local TOOLS_L = require("tools_legion")

--------------------------------------------------------------------------
--[[ 韦伯 ]]
--------------------------------------------------------------------------

local assets_creep_item =
{
    Asset("ANIM", "anim/web_hump.zip"),
    Asset("ATLAS", "images/inventoryimages/web_hump_item.xml"),
    Asset("IMAGE", "images/inventoryimages/web_hump_item.tex"),
    Asset("ATLAS_BUILD", "images/inventoryimages/web_hump_item.xml", 256)
}

local prefabs_creep_item =
{
    "web_hump",
}

local function OnDeploy_creep_item(inst, pt, deployer, rot)
    local tree = SpawnPrefab("web_hump")
    if tree ~= nil then
        tree.Transform:SetPosition(pt:Get())
        inst.components.stackable:Get():Remove()

        if deployer ~= nil and deployer.SoundEmitter ~= nil then
            deployer.SoundEmitter:PlaySound("dontstarve/creatures/spider/spider_egg_sack")
        end
    end
end

local function fn_creep_item()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    -- inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("web_hump")
    inst.AnimState:SetBuild("web_hump")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("cattoy")

    MakeInventoryFloatable(inst, "med", 0.3, 0.65)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("inspectable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "web_hump_item"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/web_hump_item.xml"
    -- inst.components.inventoryitem:SetOnPickupFn(function(inst)
    --     inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spider_egg_sack")
    -- end)

    inst:AddComponent("tradable")

    inst:AddComponent("deployable")
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.NONE)
    inst.components.deployable.ondeploy = OnDeploy_creep_item

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndIgnite(inst)

    return inst
end

----------
----------

local assets_creep =
{
    Asset("ANIM", "anim/web_hump.zip"),
}

local prefabs_creep =
{
    "web_hump_item",
    "silk",
}

local function OnWork_creep(inst, worker)
    if worker.components.talker ~= nil then
        worker.components.talker:Say(GetString(worker, "DESCRIBE", { "WEB_HUMP", "TRYDIGUP" }))
    end

    if worker:HasTag("spiderwhisperer") then    --只有蜘蛛人可以挖起
        inst.components.workable.workleft = 0
    else
        inst.components.workable:SetWorkLeft(10)    --恢复工作量，永远都破坏不了
    end
end

local function OnDigUp_creep(inst, worker)
    if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:SpawnLootPrefab("web_hump_item")

        if inst.components.upgradeable ~= nil and inst.components.upgradeable.stage > 1 then
            for k = 1, inst.components.upgradeable.stage do
                inst.components.lootdropper:SpawnLootPrefab("silk")
            end
        end
    end
    inst:Remove()
end

local function FindSpiderdens(inst)
    inst.spiderdens = {}
    inst.lasttesttime = GetTime()
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 25, nil, { "INLIMBO", "NOCLICK" })
    for _, ent in ipairs(ents) do
        if ent ~= inst then
            if ent:HasTag("spiderden") or ent.prefab == "spiderhole" then
                table.insert(inst.spiderdens, ent)
            end
        end
    end
end

local function Warning(inst, data)
    if data == nil or data.target == nil or inst.testlock then
        return
    end

    inst.testlock = true

    if GetTime() - inst.lasttesttime >= 180 then --每3分钟才更新能响应的蜘蛛巢
        FindSpiderdens(inst)
    end

    if inst.spiderdens ~= nil then
        for i, ent in pairs(inst.spiderdens) do
            if ent ~= nil and ent:IsValid() then
                ent:PushEvent("creepactivate", { target = data.target })
            end
        end
    end

    inst.testlock = false
end

local function OnStageAdvance_creep(inst)
    if inst.components.upgradeable ~= nil then
        local creep_size =
        {
            5, 8, 10, 12, 13,
        }

        inst.GroundCreepEntity:SetRadius(creep_size[inst.components.upgradeable.stage] or 3)
    end
end

local function OnLoad_creep(inst, data)
    OnStageAdvance_creep(inst)
end

local function fn_creep()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddGroundCreepEntity()
    inst.entity:AddNetwork()

    inst:AddTag("NOBLOCK")  --不妨碍玩家摆放建筑物，即使没有添加物理组件也需要这个标签

    inst.AnimState:SetBank("web_hump")
    inst.AnimState:SetBuild("web_hump")
    inst.AnimState:PlayAnimation("anim")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    inst.spiderdens = {}
    inst.lasttesttime = 0

    inst:DoTaskInTime(0, FindSpiderdens)

    inst.GroundCreepEntity:SetRadius(5)

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(10)
    inst.components.workable:SetOnWorkCallback(OnWork_creep)
    inst.components.workable:SetOnFinishCallback(OnDigUp_creep)

    inst:AddComponent("upgradeable")
    inst.components.upgradeable.upgradetype = UPGRADETYPES.SPIDER
    -- inst.components.upgradeable.onupgradefn = OnUpgrade --升级时的函数
    inst.components.upgradeable.onstageadvancefn = OnStageAdvance_creep --到下一阶段时的函数
    inst.components.upgradeable.numstages = 5 --总阶段数
    inst.components.upgradeable.upgradesperstage = 2 --到下一阶段的升级次数

    inst:ListenForEvent("creepactivate", Warning)

    MakeHauntableLaunch(inst)

    inst.OnLoad = OnLoad_creep

    return inst
end

--------------------------------------------------------------------------
--[[ 沃托克斯 ]]
--------------------------------------------------------------------------

local wortox_soul_common = require("prefabs/wortox_soul_common")
local brain_contracts = require("brains/soul_contractsbrain")

local assets_contracts = {
    Asset("ANIM", "anim/book_maxwell.zip"), --官方暗影秘典动画模板
    Asset("ANIM", "anim/soul_contracts.zip"),
    Asset("ATLAS", "images/inventoryimages/soul_contracts.xml"),
    Asset("IMAGE", "images/inventoryimages/soul_contracts.tex"),
    Asset("ATLAS_BUILD", "images/inventoryimages/soul_contracts.xml", 256),
    Asset("SOUND", "sound/together.fsb"),   --官方音效包
    Asset("SCRIPT", "scripts/prefabs/wortox_soul_common.lua") --官方灵魂通用功能函数文件
}
local prefabs_contracts = {
    "wortox_soul_heal_fx",
    "wortox_soul",          --物品栏里的灵魂
    -- "wortox_soul_spawn",    --地面的灵魂
    -- "wortox_eat_soul_fx",
    "l_soul_fx",    --灵魂被吸收时的特效
}

local function ContractsDoHeal(inst)
    wortox_soul_common.DoHeal(inst)
end
local function UpadateHealTag(inst)
    if inst.components.finiteuses:GetUses() <= 1 then --耐久很低时就不加血了，防止无法跟随玩家
        inst._needheal = false
        return
    end

    local shouldheal = false
    local x, y, z = inst.Transform:GetWorldPosition()
    for _, v in ipairs(AllPlayers) do
        if
            v.entity:IsVisible() and
            not v:HasTag("health_as_oldage") and --旺达没法被加血，所以不管她了
            not (v.components.health:IsDead() or v:HasTag("playerghost") or v.components.health.invincible) and
            (v.components.health:GetMaxWithPenalty() - v.components.health.currenthealth) >= 10 and
            v:GetDistanceSqToPoint(x, y, z) < TUNING.WORTOX_SOULHEAL_RANGE * TUNING.WORTOX_SOULHEAL_RANGE --64
        then
            shouldheal = true
            break
        end
    end
    inst._needheal = shouldheal
end
local function StartUpadateHealTag(inst)
    if inst._taskheal == nil then
        inst._needheal = false
        inst._taskheal = inst:DoPeriodicTask(0.6, UpadateHealTag, 1+5*math.random())
    end
end
local function StopUpadateHealTag(inst)
    if inst._taskheal ~= nil then
        inst._taskheal:Cancel()
        inst._taskheal = nil
    end
    inst._needheal = false
end

local function OnPutInInventory_contracts(inst) --放进物品栏时(在鼠标和格子相互切换时也会触发)
    StopUpadateHealTag(inst)
    --因为契约书只能放进物品栏，不存在多级owner情况(物品->包裹->背包->玩家)，所以这里可以直接获取玩家
    local owner = inst.components.inventoryitem.owner
    if owner ~= nil then
        local res, reason = inst.components.soulcontracts:TriggerOwner(true, owner)
        if not res then
            owner:DoTaskInTime(0, function()
                owner.components.inventory:DropItem(inst)
                if owner.components.talker ~= nil then
                    owner.components.talker:Say(GetString(owner, "DESCRIBE", { "SOUL_CONTRACTS", reason or "NORIGHT" }))
                end
            end)
        end
    end
end
local function OnDropped_contracts(inst) --丢在地上时
    if inst.sg ~= nil then
        inst.sg:GoToState("powerdown")
    end
    if inst.components.finiteuses:GetUses() > 0 then
        StartUpadateHealTag(inst)
    else
        StopUpadateHealTag(inst)
    end
    if inst._contractsowner ~= nil then
        if inst._contractsowner:IsValid() then
            inst.components.follower:SetLeader(inst._contractsowner)
        else
            inst._contractsowner = nil
        end
    end
end
local function OnHaunt_contracts(inst, haunter) --被作祟时
    if math.random() <= 0.2 and inst.components.finiteuses:GetPercent() < 1 then
        inst.components.finiteuses:Repair(1)
    elseif inst.components.finiteuses:GetUses() > 0 then
        inst._needheal = true
    end
    inst.components.hauntable.hauntvalue = TUNING.HAUNT_TINY
    return true
end
local function SoulLeaking(inst, posInst) --释放全部灵魂
    if inst.components.finiteuses:GetUses() <= 0 then
        return
    end
    local x, y, z = posInst.Transform:GetWorldPosition()
    local count = math.min(20, inst.components.finiteuses:GetUses()) --怕卡顿
    for k = 1, count do
        local soul = SpawnPrefab("wortox_soul")
        soul.Transform:SetPosition(x, y, z)
        if soul.components.inventoryitem ~= nil then
            soul.components.inventoryitem:OnDropped(true) --传true是为了随机位置掉落
        end
    end
end
local function FuelTaken_contracts(inst, taker) --被当作燃料消耗时
    SoulLeaking(inst, taker)
    StopUpadateHealTag(inst)
end
local function PercentChanged_contracts(inst, data) --耐久变化时
    if data ~= nil and data.percent ~= nil then
        if data.percent <= 0 then --耐久用光
            if not inst:HasTag("nosoulleft") then
                inst:AddTag("nosoulleft")
            end
            StopUpadateHealTag(inst)
        else --还有耐久
            if inst:HasTag("nosoulleft") then
                inst:RemoveTag("nosoulleft")
            end
            if inst.components.inventoryitem.owner == nil then --不在背包里时
                StartUpadateHealTag(inst)
            end
        end
    end
end

local function EmptyCptFn(self, ...)end
local function OnUpgradeFn_contracts(inst, doer, item)
    (inst.SoundEmitter or doer.SoundEmitter):PlaySound("dontstarve/characters/wortox/soul/spawn", nil, .5)
end
local function SetLevel_contracts(inst, uses)
    local lvl = inst.components.upgradeable:GetStage() - 1
    if lvl > 0 then
        local maxuse = 40 + lvl
        if uses == nil then
            uses = inst.components.finiteuses:GetUses()
        end
        inst.components.finiteuses:SetMaxUses(maxuse)
        inst.components.finiteuses:SetUses(math.min(maxuse, uses))
    end
    if inst.components.soulcontracts ~= nil then
        inst.components.soulcontracts.lvl = lvl
    end
end
local function OnSave_contracts(inst, data)
	data.uses_l = inst.components.finiteuses:GetUses() --主要是怕 finiteuses 以后会限制大小
end
local function OnLoad_contracts(inst, data)
    SetLevel_contracts(inst, data and data.uses_l or nil)
end
local function Fn_dealdata_contracts(inst, data)
    local dd = {
        us = tostring(data.us or 0), usmax = tostring((data.lv or 0)+40),
        lv = tostring(data.lv or 0)
    }
    if data.ow == nil then
        return subfmt(STRINGS.NAMEDETAIL_L.SOUL_CONTRACTS1, dd)
    else
        dd.ow = data.ow
        return subfmt(STRINGS.NAMEDETAIL_L.SOUL_CONTRACTS2, dd)
    end
end
local function Fn_getdata_contracts(inst)
    local data = {}
    data.us = inst.components.finiteuses:GetUses()
    if data.us <= 0 then
        data.us = nil
    end
    data.lv = inst.components.upgradeable:GetStage() - 1
    if data.lv <= 0 then
        data.lv = nil
    end
    if inst._contractsowner ~= nil and inst._contractsowner:IsValid() then
        data.ow = inst._contractsowner.name or inst._contractsowner.userid
    end
    return data
end

local function Fn_contracts()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("soul_contracts.tex")

    MakeFlyingCharacterPhysics(inst, 1, .5)

    inst.AnimState:SetBank("book_maxwell")
    inst.AnimState:SetBuild("soul_contracts")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("soulcontracts")
    inst:AddTag("ignorewalkableplatformdrowning")
    inst:AddTag("NOBLOCK")
    inst:AddTag("flying")
    inst:AddTag("bookstaying")
    inst:AddTag("meteor_protection") --防止被流星破坏
    inst:AddTag("NORATCHECK") --mod兼容：永不妥协。该道具不算鼠潮分

    TOOLS_L.InitMouseInfo(inst, Fn_dealdata_contracts, Fn_getdata_contracts)
    LS_C_Init(inst, "soul_contracts", false)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    inst._needheal = false
    inst._taskheal = nil
    inst._contractsowner = nil
    inst._dd = { fx = "l_soul_fx" }
    inst._SoulHealing = ContractsDoHeal
    StartUpadateHealTag(inst)

    inst:AddComponent("inspectable")

    inst:AddComponent("follower")
    inst.components.follower.CachePlayerLeader = EmptyCptFn --不想它在重进世界时出错了还跟着玩家
    inst.components.follower.keepdeadleader = true
    inst.components.follower.keepleaderduringminigame = true

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.canonlygoinpocket = true --只能放进物品栏中，不能放进箱子、背包等容器内
    inst.components.inventoryitem.imagename = "soul_contracts"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/soul_contracts.xml"
    inst.components.inventoryitem.pushlandedevents = false
    inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem.canbepickedup = false --无法被直接捡起来

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(40)
    inst.components.finiteuses:SetUses(40)

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL
    inst.components.fuel:SetOnTakenFn(FuelTaken_contracts)

    inst:AddComponent("hauntable")
    inst.components.hauntable.cooldown = TUNING.HAUNT_COOLDOWN_SMALL
    inst.components.hauntable:SetOnHauntFn(OnHaunt_contracts)

    inst:AddComponent("upgradeable")
    inst.components.upgradeable.upgradetype = UPGRADETYPES.CONTRACTS_L
    inst.components.upgradeable.onupgradefn = OnUpgradeFn_contracts --升级前
    inst.components.upgradeable.onstageadvancefn = SetLevel_contracts --升级时
    inst.components.upgradeable.numstages = 100
    inst.components.upgradeable.upgradesperstage = 1

    inst:AddComponent("soulcontracts")

    inst:ListenForEvent("percentusedchange", PercentChanged_contracts)
    inst:ListenForEvent("onputininventory", OnPutInInventory_contracts)
    inst:ListenForEvent("ondropped", OnDropped_contracts)
    -- inst:ListenForEvent("stopfollowing", OnStopFollowing_contracts)
    -- inst:ListenForEvent("startfollowing", OnStartFollowing_contracts)

    inst:SetBrain(brain_contracts)
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
    inst.components.locomotor.pathcaps = { ignorewalls = true, allowocean = true } --能直接穿墙移动
    inst.components.locomotor.walkspeed = 8
    inst.components.locomotor.runspeed = 8
    inst:SetStateGraph("SGsoul_contracts")

    inst.OnSave = OnSave_contracts
    inst.OnLoad = OnLoad_contracts

    return inst
end

--------------------------------------------------------------------------
--[[ 威尔逊 ]]
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--[[ 薇诺娜 ]]
--------------------------------------------------------------------------

--全息组件

--------------------------------------------------------------------------
--[[ 沃姆伍德 ]]
--------------------------------------------------------------------------

--花园铲

--------------------------------------------------------------------------
--[[ 沃利 ]]
--------------------------------------------------------------------------

--便携式烧烤架

-----
-----

return Prefab("web_hump_item", fn_creep_item, assets_creep_item, prefabs_creep_item),
        Prefab("web_hump", fn_creep, assets_creep, prefabs_creep),
        Prefab("soul_contracts", Fn_contracts, assets_contracts, prefabs_contracts)
