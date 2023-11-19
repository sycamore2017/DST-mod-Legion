local prefs = {}
local TOOLS_L = require("tools_legion")

--------------------------------------------------------------------------
--[[ 白木吉他 ]]
--------------------------------------------------------------------------

local TIME_FOURHANDSPLAY = 1.5
local RANGE_FOURHANDSPLAY = 10
local RANGE_PLAY = 20
local COST_HUNGER = -0.5
local TYPE_PLAY = "normal"

local function SpawnFx(fx, target, scale, xOffset, yOffset, zOffset)
    local fx = SpawnPrefab(fx)

    if fx then
        fx.Transform:SetNoFaced()
        xOffset = xOffset or 0 --控制前后
        yOffset = yOffset or 0 --控制高度
        zOffset = zOffset or 0 --控制左右

        -- if target.components.rider ~= nil and target.components.rider:IsRiding() then
        --     yOffset = yOffset + 2.3
        --     xOffset = xOffset + 0.5
        --     zOffset = zOffset + 0.5
        -- end

        target:AddChild(fx)
        fx.Transform:SetPosition(xOffset, yOffset, zOffset)

        scale = scale or 1
        fx.Transform:SetScale(scale, scale, scale)
    end

    return fx
end

local function PlayFail(inst, owner, talktype)
    if talktype ~= nil and owner.components.talker ~= nil then
        owner.components.talker:Say(GetString(owner, "DESCRIBE", { "GUITAR_WHITEWOOD", talktype }))
    end
    owner:PushEvent("playenough")
    if inst.playtask ~= nil then
        inst.playtask:Cancel()
        inst.playtask = nil
    end
end
local function PlayStart(inst, owner)
    owner.AnimState:OverrideSymbol("swap_guitar", "swap_guitar_whitewood", "swap_guitar_whitewood")

    --开始联弹等待阶段
    if owner.fourhands_task ~= nil then
        owner.fourhands_task:Cancel()
    end
    owner.fourhands_playtype = TYPE_PLAY
    owner.fourhands_valid = nil
    owner.fourhands_myleader = nil
    owner.fourhands_status = 1
    owner.fourhands_task = inst:DoTaskInTime(TIME_FOURHANDSPLAY, function()
        owner.fourhands_task = nil
        --主弹才播放音乐
        if owner.fourhands_status == 1 then
            local songs = owner.fourhands_valid and {
                "legion/guitar_songs/never_end_love",
                "legion/guitar_songs/let_her_go"
            } or {
                "legion/guitar_songs/town",
                "legion/guitar_songs/viva_la_vida"
            }

            for _, fn in pairs(GUITARSONGSPOOL_LEGION) do
                if fn then
                    local res = fn(inst, owner, owner.fourhands_valid, songs, TYPE_PLAY)
                    if res and res == "override" then
                        return
                    end
                end
            end
            owner.SoundEmitter:PlaySound(songs[math.random(#songs)], "guitarsong_l")
            owner.SoundEmitter:SetVolume("guitarsong_l", 0.5)
        end
    end)

    --判断周围是否有在弹琴的玩家，如果有，自己就是副弹，没有自己就是主弹
    local x, y, z = owner.Transform:GetWorldPosition()
    for i, v in ipairs(AllPlayers) do
        if
            v ~= owner and
            v.entity:IsVisible() and
            not (v.components.health:IsDead() or v:HasTag("playerghost")) and
            v.fourhands_playtype == TYPE_PLAY and --只判断同类型的吉他
            v:GetDistanceSqToPoint(x, y, z) < RANGE_PLAY * RANGE_PLAY and --距离要够
            v.sg ~= nil and v.sg:HasStateTag("playguitar") and v.fourhands_status == 1 --只判断正在弹的主弹
        then
            --主弹不在联弹等待阶段，或者范围不在联弹有效范围，则自己弹奏失败
            if v.fourhands_task == nil or v:GetDistanceSqToPoint(x, y, z) > RANGE_FOURHANDSPLAY * RANGE_FOURHANDSPLAY then
                owner.fourhands_status = -1 --弹奏失败
            else
                if v.fourhands_valid == nil then --告知主弹这次是联弹
                    v.fourhands_valid = {}
                end
                table.insert(v.fourhands_valid, owner)

                owner.fourhands_myleader = v --记下本次联弹的主弹对象
                owner.fourhands_status = 0  --确定自己副弹的位置

                --产生联弹成功的特效
                inst:DoTaskInTime(math.random(), function()
                    if v:IsValid() and v.entity:IsVisible() then
                        SpawnFx("battlesong_attach", v, 0.6)
                    end
                    if owner:IsValid() and owner.entity:IsVisible() then
                        SpawnFx("battlesong_attach", owner, 0.6)
                    end
                end)
            end
            break
        end
    end
end
local function PlayDoing(inst, owner)
    owner.AnimState:PlayAnimation("soothingplay_loop", true) --之所以把动画改到这里而不是写进sg中，是为了兼容多种弹奏动画。建议写进PlayStart，并改造一下sg

    --尝试联弹失败，弹奏也失败
    if owner.fourhands_status == -1 then
        PlayFail(inst, owner, 'FAILED')
        SpawnFx("battlesong_detach", owner, 0.6)
        return
    end

    --饥饿值没了也无法弹奏
    if owner.components.hunger ~= nil and owner.components.hunger:IsStarving() then
        PlayFail(inst, owner, 'HUNGRY')
        return
    end

    inst.components.fueled:StartConsuming() --开始损坏

    if inst.playtask ~= nil then
        inst.playtask:Cancel()
    end
    inst.playcount = -1 --从-1开始，为了第一次就生效
    inst.playtask = inst:DoPeriodicTask(1,
        owner.fourhands_status == 1 and
        function() --主弹逻辑：效果实施
            if not owner:IsValid() then
                return
            end

            local x, y, z = owner.Transform:GetWorldPosition()
            for i, v in ipairs(AllPlayers) do
                if
                    v.entity:IsVisible() and
                    not (v.components.health:IsDead() or v:HasTag("playerghost")) and
                    v:GetDistanceSqToPoint(x, y, z) < RANGE_PLAY * RANGE_PLAY
                then
                    if v.components.sanity ~= nil then
                        --第二个参数能使数值变化时不播放音效
                        v.components.sanity:DoDelta(owner.fourhands_valid and 1 or 0.5, true)
                    end
                end
            end

            if owner.components.hunger ~= nil then
                --第二个参数能使数值变化时不播放音效
                owner.components.hunger:DoDelta(COST_HUNGER, true)
                if owner.components.hunger:IsStarving() then
                    PlayFail(inst, owner, 'HUNGRY')
                    return
                end
            end

            inst.playcount = inst.playcount + 1
            if inst.playcount % 5 == 0 then --每五秒照料一次作物
                local ents = TheSim:FindEntities(x, y, z, RANGE_PLAY, { "tendable_farmplant" }, { "INLIMBO" })
                for _,v in ipairs(ents) do
                    if v.components.farmplanttendable ~= nil then
                        v.components.farmplanttendable:TendTo(owner)
                    end
                end
                inst.playcount = 0
            end
        end or
        function() --副弹逻辑：监听主弹弹奏状态
            if
                owner.fourhands_myleader == nil or
                not owner.fourhands_myleader:IsValid() or
                not owner.fourhands_myleader.entity:IsVisible() or
                owner.fourhands_myleader.sg == nil or not owner.fourhands_myleader.sg:HasStateTag("playguitar")
            then
                PlayFail(inst, owner, nil)
            else
                if owner.components.hunger ~= nil then
                    owner.components.hunger:DoDelta(COST_HUNGER, true)
                    if owner.components.hunger:IsStarving() then
                        PlayFail(inst, owner, 'HUNGRY')
                        return
                    end
                end
            end
        end,
    1)

    --弹奏时的特效
    if inst.fxtask ~= nil then
        inst.fxtask:Cancel()
    end
    inst.fxtask = inst:DoPeriodicTask(0.5, function()
        if not owner:IsValid() then
            return
        end
        local x, y, z = owner.Transform:GetWorldPosition()
        local rad = math.random(0.5, 1.5)
        local angle = math.random() * 2 * PI
        local fx = SpawnPrefab("guitar_whitewood_doing_fx")
        if fx then
            fx.Transform:SetNoFaced()
            fx.Transform:SetScale(0.4, 0.4, 0.4)
            fx.Transform:SetPosition(x + rad * math.cos(angle), y, z - rad * math.sin(angle))
        end
    end, 0.5)
end
local function PlayEnd(inst, owner)
    if owner.fourhands_status == 1 then
        owner.SoundEmitter:KillSound("guitarsong_l")
    end

    if inst.playtask ~= nil then
        inst.playtask:Cancel()
        inst.playtask = nil
    end
    if inst.fxtask ~= nil then
        inst.fxtask:Cancel()
        inst.fxtask = nil
    end
    inst.playcount = nil
    if owner.fourhands_task ~= nil then
        owner.fourhands_task:Cancel()
        owner.fourhands_task = nil
    end
    owner.fourhands_valid = nil
    owner.fourhands_myleader = nil
    owner.fourhands_status = nil

    if inst.broken then --损坏了，消失
        inst:Remove()
    else                --还没坏，停止损坏
        inst.components.fueled:StopConsuming()
    end
end

local function OnFinished(inst)
    local owner = inst.components.inventoryitem:GetGrandOwner()
    if owner ~= nil then
        owner:PushEvent("playenough")
    end
    inst.broken = true
end

local function Fn_guitar()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst:AddTag("guitar")

    inst.AnimState:SetBank("guitar_whitewood")
    inst.AnimState:SetBuild("guitar_whitewood")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "med", 0.3, 0.6)
    local OnLandedClient_old = inst.components.floater.OnLandedClient
    inst.components.floater.OnLandedClient = function(self)
        OnLandedClient_old(self)
        self.inst.AnimState:SetFloatParams(0.1, 1, self.bob_percent)
    end

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("instrument")

    inst.PlayStart = PlayStart
    inst.PlayDoing = PlayDoing
    inst.PlayEnd = PlayEnd

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.GUITAR
    inst.components.fueled:InitializeFuelLevel(TUNING.TOTAL_DAY_TIME) --1天
    inst.components.fueled:SetDepletedFn(OnFinished)
    inst.components.fueled.accepting = true

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "guitar_whitewood"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/guitar_whitewood.xml"

    MakeHauntableLaunch(inst)

    return inst
end

table.insert(prefs, Prefab(
    "guitar_whitewood",
    Fn_guitar,
    {
        Asset("ANIM", "anim/guitar_whitewood.zip"),
        Asset("ANIM", "anim/swap_guitar_whitewood.zip"),
        Asset("ATLAS", "images/inventoryimages/guitar_whitewood.xml"),
        Asset("IMAGE", "images/inventoryimages/guitar_whitewood.tex"),
    },
    {
        "battlesong_attach",
        "battlesong_detach",
        "guitar_whitewood_doing_fx",
    }
))

--------------------------------------------------------------------------
--[[ 白木地片 ]]
--------------------------------------------------------------------------

local function Fn_mat_item()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst:AddTag("eyeturret") --眼球塔的专属标签，但为了deployable组件的摆放名字而使用（显示为“放置”）

    inst.AnimState:SetBank("mat_whitewood")
    inst.AnimState:SetBuild("mat_whitewood")
    inst.AnimState:PlayAnimation("item")

    MakeInventoryFloatable(inst, "med", 0.3, 0.8)
    local OnLandedClient_old = inst.components.floater.OnLandedClient
    inst.components.floater.OnLandedClient = function(self)
        OnLandedClient_old(self)
        self.inst.AnimState:SetFloatParams(0.1, 1, self.bob_percent)
    end

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "mat_whitewood_item"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/mat_whitewood_item.xml"

    inst:AddComponent("z_repairerlegion")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.WOOD
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = 0

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = function(inst, pt, deployer, rot)
        local tree = SpawnPrefab("mat_whitewood")
        if tree ~= nil then
            tree.Transform:SetPosition(pt:Get())
            inst.components.stackable:Get():Remove()
            tree.SoundEmitter:PlaySound("dontstarve/common/place_structure_wood")
        end
    end
    -- inst.components.deployable:SetDeployMode(DEPLOYMODE.WALL)
    -- inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunch(inst)

    return inst
end

table.insert(prefs, Prefab(
    "mat_whitewood_item",
    Fn_mat_item,
    {
        Asset("ANIM", "anim/mat_whitewood.zip"),
        Asset("ATLAS", "images/inventoryimages/mat_whitewood_item.xml"),
        Asset("IMAGE", "images/inventoryimages/mat_whitewood_item.tex"),
    },
    {
        "mat_whitewood"
    }
))

-----

local function Fn_mat()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    -- MakeObstaclePhysics(inst, .5)

    inst:AddTag("NOBLOCK")

    inst.AnimState:SetBank("mat_whitewood")
    inst.AnimState:SetBuild("mat_whitewood")
    inst.AnimState:PlayAnimation("idle1")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(2)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    -- inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(function(inst)
        inst.components.lootdropper:DropLoot()

        local fx = SpawnPrefab("collapse_small")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        fx:SetMaterial("wood")

        inst:Remove()
    end)

    inst:AddComponent("upgradeable")
    inst.components.upgradeable.upgradetype = UPGRADETYPES.MAT_L
    inst.components.upgradeable.onupgradefn = function(inst, doer, item)
        inst.SoundEmitter:PlaySound("dontstarve/common/place_structure_wood")
    end
    inst.components.upgradeable.onstageadvancefn = function(inst)
        local stagenow = inst.components.upgradeable:GetStage()
        inst.AnimState:PlayAnimation("idle"..tostring(stagenow))

        stagenow = math.floor(stagenow/2)
        if stagenow > 0 then
            local loots = {}
            for i = 1, stagenow, 1 do
                table.insert(loots, "mat_whitewood_item")
            end
            inst.components.lootdropper:SetLoot(loots)
        else
            inst.components.lootdropper:SetLoot(nil)
        end
    end
    inst.components.upgradeable.numstages = 5
    inst.components.upgradeable.upgradesperstage = 1

    inst.OnLoad = function(inst, data) --由于 upgradeable 组件不会自己重新初始化，只能这里再初始化
        inst.components.upgradeable.onstageadvancefn(inst)
    end

    return inst
end

table.insert(prefs, Prefab(
    "mat_whitewood",
    Fn_mat,
    {
        Asset("ANIM", "anim/mat_whitewood.zip"),
    },
    {
        "mat_whitewood_item"
    }
))

--------------------------------------------------------------------------
--[[ 白木展示台、白木展示柜 ]]
--------------------------------------------------------------------------

local invPrefabList = require("mod_inventoryprefabs_list")  --mod中有物品栏图片的prefabs的表
local invBuildMaps = {
    "images_minisign1", "images_minisign2", "images_minisign3",
    "images_minisign4", "images_minisign5", "images_minisign6",
    "images_minisign_skins1", "images_minisign_skins2" --7、8
}

local function SetShowSlot(inst, slot)
    local item = inst.components.container.slots[slot]
    if item == nil then
        inst.AnimState:ClearOverrideSymbol("slot"..tostring(slot))
        inst.AnimState:ClearOverrideSymbol("slotbg"..tostring(slot))
    else
        local atlas, bgimage, bgatlas
        local image = FunctionOrValue(item.drawimageoverride, item, inst) or (#(item.components.inventoryitem.imagename or "") > 0 and item.components.inventoryitem.imagename) or item.prefab or nil
        if image ~= nil then
            atlas = FunctionOrValue(item.drawatlasoverride, item, inst) or (#(item.components.inventoryitem.atlasname or "") > 0 and item.components.inventoryitem.atlasname) or nil
            if item.inv_image_bg ~= nil and item.inv_image_bg.image ~= nil and item.inv_image_bg.image:len() > 4 and item.inv_image_bg.image:sub(-4):lower() == ".tex" then
                bgimage = item.inv_image_bg.image:sub(1, -5)
                bgatlas = item.inv_image_bg.atlas ~= GetInventoryItemAtlas(item.inv_image_bg.image) and item.inv_image_bg.atlas or nil
            end

            if invPrefabList[image] ~= nil then
                inst.AnimState:OverrideSymbol("slot"..tostring(slot), invBuildMaps[invPrefabList[image]] or invBuildMaps[1], image)
            else
                inst.AnimState:OverrideSymbol("slot"..tostring(slot), atlas or GetInventoryItemAtlas(image..".tex"), image..".tex")
            end
            if bgimage ~= nil then
                if invPrefabList[bgimage] ~= nil then
                    inst.AnimState:OverrideSymbol("slotbg"..tostring(slot), invBuildMaps[invPrefabList[bgimage]] or invBuildMaps[1], bgimage)
                else
                    inst.AnimState:OverrideSymbol("slotbg"..tostring(slot), bgatlas or GetInventoryItemAtlas(bgimage..".tex"), bgimage..".tex")
                end
            else
                inst.AnimState:ClearOverrideSymbol("slotbg"..tostring(slot))
            end
        else
            inst.AnimState:ClearOverrideSymbol("slot"..tostring(slot))
            inst.AnimState:ClearOverrideSymbol("slotbg"..tostring(slot))
        end
    end
end
local function ItemGet_chest(inst, data)
    if data and data.slot and data.slot <= inst.shownum_l then
        SetShowSlot(inst, data.slot)
    end
end
local function ItemLose_chest(inst, data)
    if data and data.slot and data.slot <= inst.shownum_l then
        SetShowSlot(inst, data.slot)
    end
end

local function OnOpen_chest(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("open")
        if inst.skin_open_sound then
            inst.SoundEmitter:PlaySound(inst.skin_open_sound)
        else
            inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
        end
    end
end
local function OnClose_chest(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("close")
        inst.AnimState:PushAnimation("closed", false)
        if inst.skin_close_sound then
            inst.SoundEmitter:PlaySound(inst.skin_close_sound)
        else
            inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
        end
        for i = 1, inst.shownum_l, 1 do
            SetShowSlot(inst, i)
        end
    end
end
local function OnHit_chest(inst, worker)
    if not inst:HasTag("burnt") then
        if inst.components.container ~= nil then
            inst.components.container:DropEverything()
            inst.components.container:Close()
        end
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("closed", false)
    end
end
local function OnHammered_chest(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function OnSave_chest(inst, data)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() or inst:HasTag("burnt") then
        data.burnt = true
    end
end
local function OnLoad_chest(inst, data)
    if data ~= nil and data.burnt and inst.components.burnable ~= nil then
        inst.components.burnable.onburnt(inst)
    end
end

local function MakeChest(data)
    table.insert(prefs, Prefab(
        data.name,
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddSoundEmitter()
            inst.entity:AddMiniMapEntity()
            inst.entity:AddNetwork()

            inst.MiniMapEntity:SetIcon("chest_whitewood.tex")

            inst:AddTag("structure")
            inst:AddTag("chest")

            inst.AnimState:SetBank(data.name)
            inst.AnimState:SetBuild(data.name)
            inst.AnimState:PlayAnimation("closed")

            TOOLS_L.MakeSnowCovered_comm(inst)

            -- inst:AddComponent("skinedlegion")
            -- inst.components.skinedlegion:Init(data.name)

            -- if data.fn_common ~= nil then
            --     data.fn_common(inst)
            -- end

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup(data.name) end
                return inst
            end

            inst.shownum_l = 3

            inst:AddComponent("inspectable")

            inst:AddComponent("container")
            inst.components.container:WidgetSetup(data.name)
            inst.components.container.onopenfn = OnOpen_chest
            inst.components.container.onclosefn = OnClose_chest
            inst.components.container.skipclosesnd = true
            inst.components.container.skipopensnd = true

            inst:AddComponent("lootdropper")

            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
            -- inst.components.workable:SetWorkLeft(2)
            inst.components.workable:SetOnWorkCallback(OnHit_chest)
            inst.components.workable:SetOnFinishCallback(OnHammered_chest)

            inst:AddComponent("hauntable")
            inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

            TOOLS_L.MakeSnowCovered_serv(inst, 0.1 + 0.3*math.random(), nil)

            inst.OnSave = OnSave_chest
            inst.OnLoad = OnLoad_chest

            -- inst:ListenForEvent("onbuilt", onbuilt)
            inst:ListenForEvent("itemget", ItemGet_chest)
            inst:ListenForEvent("itemlose", ItemLose_chest)

            -- inst.components.skinedlegion:SetOnPreLoad()

            if data.fn_server ~= nil then
                data.fn_server(inst)
            end

            return inst
        end,
        data.assets,
        data.prefabs
    ))
end

MakeChest({
    name = "chest_whitewood",
    assets = {
        Asset("ANIM", "anim/chest_whitewood.zip"),
        Asset("ANIM", "anim/ui_chester_shadow_3x4.zip"),
        Asset("ANIM", "anim/ui_chest_whitewood_3x4.zip")
    },
    -- prefabs = {},
    -- fn_common = function(inst)end,
    fn_server = function(inst)
        inst.shownum_l = 3

        inst.components.workable:SetWorkLeft(2)

        MakeMediumBurnable(inst, nil, nil, true)
        MakeMediumPropagator(inst)
    end
})

MakeChest({
    name = "chest_whitewood_big",
    assets = {
        Asset("ANIM", "anim/chest_whitewood_big.zip"),
        Asset("ANIM", "anim/ui_bookstation_4x5.zip"),
        Asset("ANIM", "anim/ui_chest_whitewood_4x6.zip")
    },
    -- prefabs = {},
    -- fn_common = function(inst)end,
    fn_server = function(inst)
        inst.shownum_l = 8

        inst.components.workable:SetWorkLeft(4)

        MakeLargeBurnable(inst, nil, nil, true)
        MakeLargePropagator(inst)
    end
})

-----
-----

return unpack(prefs)
