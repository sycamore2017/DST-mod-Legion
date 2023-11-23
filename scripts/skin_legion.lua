------skined_legion

local _G = GLOBAL
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()
local ischinese = _G.CONFIGS_LEGION.LANGUAGES == "chinese"
local TOOLS_L = require("tools_legion")

table.insert(Assets, Asset("ATLAS", "images/icon_skinbar_shadow_l.xml"))
table.insert(Assets, Asset("IMAGE", "images/icon_skinbar_shadow_l.tex"))
table.insert(Assets, Asset("ATLAS", "images/icon_wikibar_shadow_l.xml"))
table.insert(Assets, Asset("IMAGE", "images/icon_wikibar_shadow_l.tex"))
table.insert(Assets, Asset("ANIM", "anim/images_minisign_skins1.zip"))
table.insert(Assets, Asset("ANIM", "anim/images_minisign_skins2.zip"))
table.insert(PrefabFiles, "fx_ranimbowspark")
table.insert(PrefabFiles, "skinprefabs_legion")

------资源补充
RegisterInventoryItemAtlas("images/inventoryimages_skin/agronssword_taste.xml", "agronssword_taste.tex")
RegisterInventoryItemAtlas("images/inventoryimages_skin/agronssword_taste2.xml", "agronssword_taste2.tex")
RegisterInventoryItemAtlas("images/inventoryimages_skin/siving_turn_collector.xml", "siving_turn_collector.tex")
RegisterInventoryItemAtlas("images/inventoryimages_skin/siving_turn_future.xml", "siving_turn_future.tex")
RegisterInventoryItemAtlas("images/inventoryimages_skin/siving_turn_future2.xml", "siving_turn_future2.tex")
RegisterInventoryItemAtlas("images/inventoryimages_skin/refractedmoonlight_taste.xml", "refractedmoonlight_taste.tex")
RegisterInventoryItemAtlas("images/inventoryimages_skin/refractedmoonlight_taste2.xml", "refractedmoonlight_taste2.tex")
RegisterInventoryItemAtlas("images/inventoryimages_skin/chest_whitewood_craft.xml", "chest_whitewood_craft.tex")
RegisterInventoryItemAtlas("images/inventoryimages_skin/chest_whitewood_big_craft.xml", "chest_whitewood_big_craft.tex")
RegisterInventoryItemAtlas("images/inventoryimages_skin/chest_whitewood_craft2.xml", "chest_whitewood_craft2.tex")
RegisterInventoryItemAtlas("images/inventoryimages_skin/chest_whitewood_big_craft2.xml", "chest_whitewood_big_craft2.tex")

--------------------------------------------------------------------------
--[[ 皮肤函数 ]]
--------------------------------------------------------------------------

------特效设置

local TRAIL_FLAGS = { "shadowtrail" }
local function cane_do_trail(inst)
    local owner = inst.components.inventoryitem:GetGrandOwner() or inst
    if not owner.entity:IsVisible() then
        return
    end

    local x, y, z = owner.Transform:GetWorldPosition()
    if owner.sg ~= nil and owner.sg:HasStateTag("moving") then
        local theta = -owner.Transform:GetRotation() * DEGREES
        local speed = owner.components.locomotor:GetRunSpeed() * .1
        x = x + speed * math.cos(theta)
        z = z + speed * math.sin(theta)
    end
    local mounted = owner.components.rider ~= nil and owner.components.rider:IsRiding()
    local map = TheWorld.Map
    local offset = FindValidPositionByFan(
        math.random() * 2 * PI,
        (mounted and 1 or .5) + math.random() * .5,
        4,
        function(offset)
            local pt = Vector3(x + offset.x, 0, z + offset.z)
            return map:IsPassableAtPoint(pt:Get())
                and not map:IsPointNearHole(pt)
                and #TheSim:FindEntities(pt.x, 0, pt.z, .7, TRAIL_FLAGS) <= 0
        end
    )

    if offset ~= nil then
        SpawnPrefab(inst.trail_fx).Transform:SetPosition(x + offset.x, 0, z + offset.z)
    end
end
local function cane_equipped(inst, data)
    if inst.vfx_fx ~= nil then
        if inst._vfx_fx_inst == nil then
            inst._vfx_fx_inst = SpawnPrefab(inst.vfx_fx)
            inst._vfx_fx_inst.entity:AddFollower()
        end
        inst._vfx_fx_inst.entity:SetParent(data.owner.entity)
        inst._vfx_fx_inst.Follower:FollowSymbol(data.owner.GUID, "swap_object", 0, inst.vfx_fx_offset or 0, 0)
    end
    if inst.trail_fx ~= nil and inst._trailtask == nil then
        inst._trailtask = inst:DoPeriodicTask(6 * FRAMES, cane_do_trail, 2 * FRAMES)
    end
end
local function cane_unequipped(inst, owner)
    if inst._vfx_fx_inst ~= nil then
        inst._vfx_fx_inst:Remove()
        inst._vfx_fx_inst = nil
    end
    if inst._trailtask ~= nil then
        inst._trailtask:Cancel()
        inst._trailtask = nil
    end
end

local function FxInit(inst, data, vfx_fx_offset)
    inst.vfx_fx = data[1] ~= nil and data[1]:len() > 0 and data[1] or nil
    inst.trail_fx = data[2]
    if inst.vfx_fx ~= nil or inst.trail_fx ~= nil then
        inst:ListenForEvent("equipped", cane_equipped)
        inst:ListenForEvent("unequipped", cane_unequipped)
        if inst.vfx_fx ~= nil then
            inst.vfx_fx_offset = vfx_fx_offset or -105
            inst:ListenForEvent("onremove", cane_unequipped)
        end
    end
end
local function FxClear(inst)
    inst:RemoveEventCallback("equipped", cane_equipped)
    inst:RemoveEventCallback("unequipped", cane_unequipped)
    inst:RemoveEventCallback("onremove", cane_unequipped)
end

------随机动画

local function DoRandomAnim(inst)
    if inst.skin_l_anims then
        inst.AnimState:PlayAnimation(inst.skin_l_anims[ math.random(#inst.skin_l_anims) ], false)
    end
end
local function SetRandomSkinAnim(inst, anims)
    if inst.skin_l_anims == nil then
        inst:ListenForEvent("animover", DoRandomAnim) --看起来被装备后，动画会自动暂停。所以我也不用主动关闭监听了
    end
    inst.skin_l_anims = anims
    DoRandomAnim(inst)
end
local function CancelRandomSkinAnim(inst)
    inst.skin_l_anims = nil
    inst:RemoveEventCallback("animover", DoRandomAnim)
end

------

local function GetSpawnPoint(pos, radius)
    local angle = math.random() * 2 * PI
    return pos.x + radius * math.cos(angle), pos.y, pos.z - radius * math.sin(angle)
end

------

local function Fn_sivturn_fruit(genetrans, skinname)
    if genetrans.fx ~= nil then
        genetrans.fx.AnimState:SetBank(skinname)
        genetrans.fx.AnimState:SetBuild(skinname)
    end
    genetrans.fxdata.skinname = skinname
end
local function Fn_sivturn(inst, skinname, bloom)
    inst.AnimState:SetBank(skinname)
    inst.AnimState:SetBuild(skinname)

    local cpt = inst.components.genetrans
    if cpt.fxdata.skinname ~= skinname then
        Fn_sivturn_fruit(cpt, skinname)
    end
    cpt.fxdata.bloom = bloom
    if cpt.fn_setanim ~= nil then
        cpt.fn_setanim(cpt, cpt.seeddata ~= nil)
    end

    if bloom then
        if inst.Light:IsEnabled() then
            inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        end
    else
        inst.AnimState:ClearBloomEffectHandle()
    end
end

local function SetAnim_sivturn(inst, swap)
    if swap == nil then
        inst.AnimState:ClearOverrideSymbol("swap")
        inst.AnimState:Hide("SWAPFRUIT-3")
        inst.AnimState:Hide("SWAPFRUIT-2")
        inst.AnimState:Hide("SWAPFRUIT-1")
        return
    end

    inst.AnimState:OverrideSymbol("swap", swap.build, swap.file)
    if swap.symboltype == "3" then
        inst.AnimState:Show("SWAPFRUIT-3")
        inst.AnimState:Hide("SWAPFRUIT-2")
        inst.AnimState:Hide("SWAPFRUIT-1")
    elseif swap.symboltype == "2" then
        inst.AnimState:Hide("SWAPFRUIT-3")
        inst.AnimState:Show("SWAPFRUIT-2")
        inst.AnimState:Hide("SWAPFRUIT-1")
    else
        inst.AnimState:Hide("SWAPFRUIT-3")
        inst.AnimState:Hide("SWAPFRUIT-2")
        inst.AnimState:Show("SWAPFRUIT-1")
    end
end
local function Fn_sivturn_anim_futrue(genetrans, isset)
    if isset then
        SetAnim_sivturn(genetrans.inst, genetrans.seeddata.swap)
        genetrans.inst.AnimState:ShowSymbol("seat")
        genetrans.inst.AnimState:ClearOverrideSymbol("followed")
    else
        SetAnim_sivturn(genetrans.inst, nil)
        genetrans.inst.AnimState:HideSymbol("seat")
        if genetrans.fxdata.skinname ~= nil then
            genetrans.inst.AnimState:OverrideSymbol("followed", genetrans.fxdata.skinname, "followed3")
        end
    end
end

------

local function Fn_start_agronssword(inst)
    inst.AnimState:SetBank(inst._dd.build)
    inst.AnimState:SetBuild(inst._dd.build)
    if inst.components.timer:TimerExists("revolt") then
        inst.components.inventoryitem.atlasname = inst._dd.img_atlas2
        inst.components.inventoryitem:ChangeImageName(inst._dd.img_tex2)
    else
        inst.components.inventoryitem.atlasname = inst._dd.img_atlas
        inst.components.inventoryitem:ChangeImageName(inst._dd.img_tex)
    end
end

------

local function Fn_start_refracted(inst)
    inst.AnimState:SetBank(inst._dd.build)
    inst.AnimState:SetBuild(inst._dd.build)
    if inst.components.timer:TimerExists("moonsurge") then
        inst.components.inventoryitem.atlasname = inst._dd.img_atlas2
        inst.components.inventoryitem:ChangeImageName(inst._dd.img_tex2)
    else
        inst.components.inventoryitem.atlasname = inst._dd.img_atlas
        inst.components.inventoryitem:ChangeImageName(inst._dd.img_tex)
    end
end

------

local function Fn_icire_rock_day(inst, range)
    local fx = inst._dd_fx
    if fx == nil or not fx:IsValid() then
        fx = SpawnPrefab("icire_rock_fx_day")
    end
    if fx ~= nil then
        if range == 1 then
            fx.AnimState:OverrideSymbol("snowflake", "icire_rock_day",
                math.random() < 0.5 and "flake_crystal" or "flake_snow")
        elseif range == 2 then
            fx.AnimState:OverrideSymbol("snowflake", "icire_rock_day", "flake_snow")
        elseif range == 4 then
            fx.AnimState:OverrideSymbol("snowflake", "icire_rock_day",
                math.random() < 0.5 and "flake_leaf" or "flake_leaf2")
        elseif range == 5 then
            fx.AnimState:OverrideSymbol("snowflake", "icire_rock_day",
                math.random() < 0.5 and "flake_dust" or "flake_ash")
        else
            fx.AnimState:ClearOverrideSymbol("snowflake")
        end

        inst:AddChild(fx)
        fx.Follower:FollowSymbol(inst.GUID, "base", 0, -30, 0)
        inst._dd_fx = fx
    end
end

------

local function SetFollowedFx(inst, owner, fxname, sym, x, y, fxkey)
    local fx = SpawnPrefab(fxname)
    if fx ~= nil then
        fx.entity:SetParent(owner.entity)
        -- fx.entity:AddFollower()
        fx.Follower:FollowSymbol(owner.GUID, sym or "swap_object", x or 0, y or 0, 0)
        inst[fxkey] = fx
    end
end
local function EndFollowedFx(inst, owner, fxkey)
    if inst[fxkey] ~= nil then
        inst[fxkey]:Remove()
        inst[fxkey] = nil
    end
end

------官方新的动画格式

local function Fn_setFollowFx(owner, fxkey, fxname)
    if owner[fxkey] ~= nil then
        owner[fxkey]:Remove()
    end
    owner[fxkey] = SpawnPrefab(fxname)
    if owner[fxkey] then
        owner[fxkey]:AttachToOwner(owner)
    end
end
local function Fn_removeFollowFx(owner, fxkey)
    if owner[fxkey] ~= nil then
        owner[fxkey]:Remove()
        owner[fxkey] = nil
    end
end

------随机仿sg的动画

local function DoSgAnim(inst)
    if inst.skin_l_anims then
        local anim = nil
        local keys = inst.skin_l_keys or {}

        if keys.x == nil then
            keys.x = math.random(#inst.skin_l_anims)
        end
        anim = inst.skin_l_anims[keys.x]
        if type(anim) == "table" then
            if keys.y == nil then
                keys.y = 1
            else
                keys.y = keys.y + 1
            end
            anim = anim[keys.y]
            if anim == nil then
                inst.skin_l_keys = {}
                DoSgAnim(inst)
                return
            end
        else
            keys = {}
        end
        inst.skin_l_keys = keys
        inst.AnimState:PlayAnimation(anim, false)
    end
end
local function SetSgSkinAnim(inst, anims)
    if inst.skin_l_anims == nil then
        inst:ListenForEvent("animover", DoSgAnim) --看起来被装备后，动画会自动暂停。所以我也不用主动关闭监听了
    end
    inst.skin_l_anims = anims
    DoSgAnim(inst)
end
local function CancelSgSkinAnim(inst)
    inst.skin_l_anims = nil
    inst.skin_l_keys = nil
    inst:RemoveEventCallback("animover", DoSgAnim)
end

------

local function Fn_anim_sivfeather_collector(inst)
    SetSgSkinAnim(inst, {
        "idle_loop", "idle_loop", "idle_loop", "idle_loop", "idle_loop",
        "idle_loop", "idle_loop", "idle_loop", "idle_loop", "idle_loop",
        "idle_loop", "idle_loop", "idle_loop", "idle_loop", "idle_loop",
        "idle_loop", "idle_loop", "idle_loop", "idle_loop", "idle_loop",
        { "sleep_pre", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_pst" },
        { "sleep_pre", "sleep_loop", "sleep_loop", "sleep_loop", "sleep_loop",  "sleep_pst" },
        { "sleep_pre", "sleep_loop", "sleep_loop", "sleep_pst" },
        "emote_lick", "emote_lick", "emote_lick", "distress", "emote_stretch", "emote_stretch", "emote_stretch",
        { "walk_pre", "walk_pst" },
        { "jump_pre", "jump_loop", "jump_pst" },
        { "jump_pre", "jump_loop", "jump_loop", "jump_pst" }
    })
end

------

local function OnSummer_cactus(inst, build)
    if TheWorld.state.issummer then
        inst.AnimState:OverrideSymbol("flowerplus", build or "crop_legion_cactus", "flomax")
    else
        inst.AnimState:ClearOverrideSymbol("flowerplus")
    end
end

------

local function SetWidget(inst, name)
    if inst.replica.container ~= nil then
        inst.replica.container:Close()
        inst.replica.container:WidgetSetup(name)
    end
end

------

local function OnUnequip_sivmask_gold_marble(owner, data)
    if data ~= nil and data.eslot == EQUIPSLOTS.BODY then
        owner.AnimState:OverrideSymbol("swap_body", "siving_armor_gold_marble", "swap_body")
    end
end

------

local function SetTarget_hidden(inst, build)
    if inst.upgradetarget ~= "icebox" then
        inst.AnimState:OverrideSymbol("base", build or "hiddenmoonlight", "saltbase")
    end
end

--------------------------------------------------------------------------
--[[ 全局皮肤总数据，以及修改 ]]
--------------------------------------------------------------------------

local rarityRepay = "ProofOfPurchase"
local rarityFree = "Distinguished"
local raritySpecial = "HeirloomElegant"

_G.SKIN_PREFABS_LEGION = {
    --[[
    rosorns = {
        assets = nil, --仅仅是用于初始化注册
        image = { name = nil, atlas = nil, setable = true }, --提前注册，或者皮肤初始化使用

        anim = { --皮肤初始化使用
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil,
            setable = true
        },
        -- fn_anim = function(inst)end, --处于地面时的动画设置，替换anim的默认方式

        -- fn_start = function(inst)end, --应用皮肤时的函数(服务端)
        -- fn_end = nil, --取消皮肤时的函数(服务端)
        -- fn_start_c = nil, --应用皮肤时的函数(客户端)
        -- fn_end_c = nil, --取消皮肤时的函数(客户端)

        equip = { symbol = "swap_object", build = "swap_rosorns", file = "swap_rosorns" },
        -- fn_equip = function(inst, owner)end, --装备时的贴图切换函数，替换equip的默认方式
        -- fn_unequip = function(inst, owner)end, --卸下装备时的贴图切换函数

        -- fn_onAttack = function(inst, owner, target)end, --攻击时的函数

        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        -- fn_spawnSkinExchangeFx = function(inst)end, --皮肤交换时的特效生成函数，替换exchangefx的默认方式

        floater = { --底部切除比例，水纹动画后缀，水纹高度位置偏移，水纹大小，是否有水纹
            cut = 0.15, size = "small", offset_y = 0.4, scale = 0.5, nofx = nil,
            -- anim = {
            --     bank = nil, build = nil,
            --     anim = nil, animpush = nil, isloop = nil
            -- },
            -- fn_anim = function(inst)end, --处于水中时的动画设置，替换anim的默认方式
        }
    },
    ]]--

    rosebush = {
        fn_start = function(inst)
            inst.AnimState:SetBank("berrybush2")
            inst.AnimState:SetBuild("rosebush")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 }
    },
    lilybush = {
        fn_start = function(inst)
            inst.AnimState:SetBank("berrybush2")
            inst.AnimState:SetBuild("lilybush")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 }
    },
    orchidbush = {
        fn_start = function(inst)
            inst.AnimState:SetBank("berrybush2")
            inst.AnimState:SetBuild("orchidbush")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },

    rosorns = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil,
            setable = true
        },
        equip = { symbol = "swap_object", build = "swap_rosorns", file = "swap_rosorns" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.15, size = "small", offset_y = 0.4, scale = 0.5, nofx = nil }
    },
    lileaves = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil,
            setable = true
        },
        equip = { symbol = "swap_object", build = "swap_lileaves", file = "swap_lileaves" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.15, size = "small", offset_y = 0.4, scale = 0.5, nofx = nil }
    },
    orchitwigs = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil,
            setable = true
        },
        equip = {
            symbol = "swap_object", build = "swap_orchitwigs", file = "swap_orchitwigs",
            atkfx = "impact_orchid_fx"
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.15, size = "small", offset_y = 0.4, scale = 0.5, nofx = nil }
    },

    neverfade = {
        image = { name = nil, atlas = nil, setable = false },
        anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil,
            setable = true
        },
        fn_start = function(inst)
            if inst.hasSetBroken then
                inst.components.inventoryitem.atlasname = "images/inventoryimages/neverfade_broken.xml"
                inst.components.inventoryitem:ChangeImageName("neverfade_broken")
            else
                inst.components.inventoryitem.atlasname = "images/inventoryimages/neverfade.xml"
                inst.components.inventoryitem:ChangeImageName("neverfade")
            end
        end,
        equip = {
            symbol = "swap_object", build = "swap_neverfade", file = "swap_neverfade",
            build_broken = "swap_neverfade_broken", file_broken = "swap_neverfade_broken"
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.12, size = "med", offset_y = 0.4, scale = 0.5, nofx = nil }
    },
    neverfadebush = {
        fn_start = function(inst)
            inst.AnimState:SetBank("berrybush2")
            inst.AnimState:SetBuild("neverfadebush")
        end,
        exchangefx = { prefab = nil, offset_y = 0.9, scale = nil }
    },

    hat_lichen = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = nil, build = nil,
            anim = "anim", animpush = nil, isloop = nil,
            setable = true
        },
        equip = { symbol = "swap_hat", build = "hat_lichen", file = "swap_hat", isopenhat = true },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.03, size = "med", offset_y = 0.2, scale = 0.5, nofx = nil }
    },

    hat_cowboy = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = nil, build = nil,
            anim = "anim", animpush = nil, isloop = nil,
            setable = true
        },
        equip = { symbol = "swap_hat", build = "hat_cowboy", file = "swap_hat" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.03, size = "med", offset_y = 0.2, scale = 0.8, nofx = nil }
    },

    pinkstaff = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = nil, build = nil,
            anim = "anim", animpush = nil, isloop = nil,
            setable = true
        },
        fn_start = function(inst)
            inst.fxcolour = {255/255, 80/255, 173/255}
        end,
        equip = { symbol = "swap_object", build = "swap_pinkstaff", file = "swap_pinkstaff" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.15, size = "small", offset_y = 0.35, scale = 0.5, nofx = nil }
    },

    boltwingout = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = "swap_boltwingout", build = "swap_boltwingout",
            anim = nil, animpush = nil, isloop = nil,
            setable = true
        },
        equip = { symbol = "swap_body", build = "swap_boltwingout", file = "swap_body" },
        boltdata = { fx = "boltwingout_fx", build = nil },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.09, size = "small", offset_y = 0.2, scale = 0.45, nofx = nil }
    },

    fishhomingtool_awesome = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil,
            setable = true
        },
        fn_start = function(inst)
            inst.components.bundlemaker:SetSkinData()
        end,
        equip = { symbol = "swap_object", build = "fishhomingtool_awesome", file = "swap" },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },
    fishhomingtool_normal = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil,
            setable = true
        },
        fn_start = function(inst)
            inst.components.bundlemaker:SetSkinData()
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },
    fishhomingbait = {
        fn_start = function(inst)
            inst.baitimgs_l = {
                dusty = {
                    img = "fishhomingbait1", atlas = "images/inventoryimages/fishhomingbait1.xml",
                    anim = "idle1", swap = "swap1", symbol = "base1", build = "fishhomingbait"
                },
                pasty = {
                    img = "fishhomingbait2", atlas = "images/inventoryimages/fishhomingbait2.xml",
                    anim = "idle2", swap = "swap2", symbol = "base2", build = "fishhomingbait"
                },
                hardy = {
                    img = "fishhomingbait3", atlas = "images/inventoryimages/fishhomingbait3.xml",
                    anim = "idle3", swap = "swap3", symbol = "base3", build = "fishhomingbait"
                }
            }
            inst.AnimState:SetBank("fishhomingbait")
            inst.AnimState:SetBuild("fishhomingbait")
            if inst.components.fishhomingbait and inst.components.fishhomingbait.oninitfn then
                inst.components.fishhomingbait.oninitfn(inst)
            end
        end,
        -- baiting = nil,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },

    icire_rock = {
		fn_start = function(inst)
            inst.AnimState:SetBank("heat_rock")
            inst.AnimState:SetBuild("heat_rock")
            inst.AnimState:OverrideSymbol("rock", "icire_rock", "rock")
            inst.AnimState:OverrideSymbol("shadow", "icire_rock", "shadow")

            inst._dd = nil
            inst.fn_temp(inst)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },

    shield_l_log = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = "shield_l_log", build = "shield_l_log",
            anim = nil, animpush = nil, isloop = nil,
            setable = true
        },
        equip = { symbol = nil, build = "shield_l_log", file = "swap_shield" },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.7 },
        floater = { cut = nil, size = "small", offset_y = 0.2, scale = 0.9, nofx = nil }
    },
    shield_l_sand = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = "shield_l_sand", build = "shield_l_sand",
            anim = nil, animpush = nil, isloop = nil,
            setable = true
        },
        equip = { symbol = nil, build = "shield_l_sand", file = "swap_shield" },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },
    agronssword = {
        fn_start = function(inst)
            inst._dd = {
                img_tex = "agronssword", img_atlas = "images/inventoryimages/agronssword.xml",
                img_tex2 = "agronssword2", img_atlas2 = "images/inventoryimages/agronssword2.xml",
                build = "agronssword", fx = "agronssword_fx"
            }
            Fn_start_agronssword(inst)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },

    tripleshovelaxe = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil,
            setable = true
        },
        equip = { symbol = "swap_object", build = "tripleshovelaxe", file = "swap" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = nil, size = "med", offset_y = 0.15, scale = 0.4, nofx = nil }
    },
    triplegoldenshovelaxe = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil,
            setable = true
        },
        equip = { symbol = "swap_object", build = "triplegoldenshovelaxe", file = "swap" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = nil, size = "med", offset_y = 0.15, scale = 0.4, nofx = nil }
    },

    backcub = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = "backcub", build = "backcub",
            anim = "anim", animpush = nil, isloop = true,
            setable = true
        },
        equip = { symbol = "swap_body", build = "swap_backcub", file = "swap_body" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = nil, size = nil, offset_y = nil, scale = nil, nofx = true,
            anim = {
                bank = "backcub", build = "backcub",
                anim = "anim_water", animpush = nil, isloop = true
            }
        }
    },

    fimbul_axe = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = "boomerang", build = nil,
            anim = nil, animpush = nil, isloop = nil,
            setable = true
        },
        equip = { symbol = "swap_object", build = "fimbul_axe", file = "swap_base" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.5, nofx = nil }
    },

    siving_derivant = {
        fn_start = function(inst)
            inst.AnimState:SetBank("siving_derivant")
            inst.AnimState:SetBuild("siving_derivant")
            inst.AnimState:SetScale(1.3, 1.3)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 }
    },

    siving_turn = {
        fn_start = function(inst)
            Fn_sivturn(inst, "siving_turn", true)
            inst.components.genetrans.fxdata.unlockfx = "siving_turn_unlock_fx"
        end,
        fn_fruit = function(genetrans)
            Fn_sivturn_fruit(genetrans, "siving_turn")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 }
    },

    carpet_whitewood = {
        anim = {
            bank = "carpet_whitewood", build = "carpet_whitewood",
            anim = nil, animpush = nil, isloop = nil,
            setable = true
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil }
    },
    carpet_whitewood_big = {
        anim = {
            bank = "carpet_whitewood", build = "carpet_whitewood",
            anim = "idle_big", animpush = nil, isloop = nil,
            setable = true
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil }
    },

    soul_contracts = {
        image = { name = nil, atlas = nil, setable = true },
        fn_start = function(inst)
            inst.AnimState:SetBank("book_maxwell")
            inst.AnimState:SetBuild("soul_contracts")
            inst._dd = { fx = "l_soul_fx" }
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = nil }
    },

    siving_feather_real = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil,
            setable = true
        },
        equip = { symbol = "swap_object", build = "siving_feather_real", file = "swap" },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.04, size = "small", offset_y = 0.2, scale = 0.5, nofx = nil }
    },
    siving_feather_fake = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil,
            setable = true
        },
        equip = { symbol = "swap_object", build = "siving_feather_fake", file = "swap" },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.04, size = "small", offset_y = 0.2, scale = 0.5, nofx = nil }
    },

    revolvedmoonlight_item = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = "revolvedmoonlight", build = "revolvedmoonlight",
            anim = "idle_item", animpush = nil, isloop = nil,
            setable = true
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.18, size = "small", offset_y = 0.4, scale = 0.55, nofx = nil }
    },
    revolvedmoonlight = {
        image = { name = nil, atlas = nil, setable = true },
        fn_start = function(inst)
            inst.AnimState:SetBank("revolvedmoonlight")
            inst.AnimState:SetBuild("revolvedmoonlight")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil }
    },
    revolvedmoonlight_pro = {
        image = { name = nil, atlas = nil, setable = true },
        fn_start = function(inst)
            inst.AnimState:SetBank("revolvedmoonlight")
            inst.AnimState:SetBuild("revolvedmoonlight")
            inst.AnimState:OverrideSymbol("decorate", "revolvedmoonlight", "decoratepro")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.45, nofx = nil }
    },

    plant_cactus_meat_l = {
        fn_start = function(inst)
            local sets = _G.CROPS_DATA_LEGION["cactus_meat"]
            inst.AnimState:SetBank(sets.bank)
            inst.AnimState:SetBuild(sets.build)
            OnSummer_cactus(inst, nil)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 }
    },

    siving_ctlwater_item = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = "siving_ctlwater", build = "siving_ctlwater",
            anim = "item", animpush = nil, isloop = nil, setable = true
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },
    siving_ctlwater = {
        fn_start = function(inst)
            inst.AnimState:SetBank("siving_ctlwater")
            inst.AnimState:SetBuild("siving_ctlwater")
            inst.barsets_l = {
                siv_bar = {
                    x = 0, y = -180, z = 0, scale = nil,
                    bank = "siving_ctlwater", build = "siving_ctlwater", anim = "bar"
                }
            }
            inst:UpdateBars_l()
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },
    siving_ctldirt_item = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = "siving_ctldirt", build = "siving_ctldirt",
            anim = "item", animpush = nil, isloop = nil, setable = true
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },
    siving_ctldirt = {
        fn_start = function(inst)
            inst.AnimState:SetBank("siving_ctldirt")
            inst.AnimState:SetBuild("siving_ctldirt")
            inst.barsets_l = {
                siv_bar1 = {
                    x = -48, y = -140, z = 0, scale = nil,
                    bank = "siving_ctldirt", build = "siving_ctldirt", anim = "bar1"
                },
                siv_bar2 = {
                    x = -5, y = -140, z = 0, scale = nil,
                    bank = "siving_ctldirt", build = "siving_ctldirt", anim = "bar2"
                },
                siv_bar3 = {
                    x = 39, y = -140, z = 0, scale = nil,
                    bank = "siving_ctldirt", build = "siving_ctldirt", anim = "bar3"
                }
            }
            inst:UpdateBars_l()
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },
    siving_ctlall_item = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = "siving_ctlall", build = "siving_ctlall",
            anim = "item", animpush = nil, isloop = nil, setable = true
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },
    siving_ctlall = {
        fn_start = function(inst)
            inst.AnimState:SetBank("siving_ctlall")
            inst.AnimState:SetBuild("siving_ctlall")
            inst.barsets_l = {
                siv_bar1 = {
                    x = -53, y = -335, z = 0, scale = nil,
                    bank = "siving_ctldirt", build = "siving_ctldirt", anim = "bar1"
                },
                siv_bar2 = {
                    x = -10, y = -360, z = 0, scale = nil,
                    bank = "siving_ctldirt", build = "siving_ctldirt", anim = "bar2"
                },
                siv_bar3 = {
                    x = 34, y = -335, z = 0, scale = nil,
                    bank = "siving_ctldirt", build = "siving_ctldirt", anim = "bar3"
                },
                siv_bar4 = {
                    x = -10, y = -297, z = 0, scale = nil,
                    bank = "siving_ctlwater", build = "siving_ctlwater", anim = "bar"
                }
            }
            inst:UpdateBars_l()
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },

    siving_mask = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        fn_start = function(inst)
            inst.maskfxoverride_l = nil
        end,
        equip = { symbol = nil, build = "siving_mask", file = nil, isopenhat = true },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil }
    },
    siving_mask_gold = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        fn_start = function(inst)
            inst.maskfxoverride_l = nil
        end,
        equip = { symbol = nil, build = "siving_mask_gold", file = nil, isopenhat = true },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil }
    },

    siving_soil_item = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = "siving_soil", build = "siving_soil",
            anim = "item", animpush = nil, isloop = nil, setable = true
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },

        overridekeys = { "data_soil", "data_plant" },
        data_soil = {
            fn_start = function(inst)
                inst.AnimState:SetBank("farm_soil")
                inst.AnimState:SetBuild("siving_soil")
            end
        },
        data_plant = {
            fn_start = function(inst)
                inst.soilskin_l = nil
                if inst.fn_soiltype ~= nil then
                    inst.fn_soiltype(inst, nil)
                end
            end
        }
    },

    refractedmoonlight = {
        fn_start = function(inst)
            inst._dd = {
                img_tex = "refractedmoonlight", img_atlas = "images/inventoryimages/refractedmoonlight.xml",
                img_tex2 = "refractedmoonlight2", img_atlas2 = "images/inventoryimages/refractedmoonlight2.xml",
                build = "refractedmoonlight", fx = "refracted_l_spark_fx"
            }
            Fn_start_refracted(inst)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },

    hiddenmoonlight_item = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = "hiddenmoonlight", build = "hiddenmoonlight",
            anim = "idle_item", animpush = nil, isloop = nil, setable = true
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.7, nofx = nil },

        overridekeys = { "data_up" },
        data_up = {
            exchangefx = { prefab = nil, offset_y = nil, scale = nil },
            fn_start = function(inst)
                inst.AnimState:SetBank("hiddenmoonlight")
                inst.AnimState:SetBuild("hiddenmoonlight")
            end
        }
    },

    chest_whitewood = {
        fn_start = function(inst)
            inst.AnimState:SetBank("chest_whitewood")
            inst.AnimState:SetBuild("chest_whitewood")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 }
    },
    chest_whitewood_big = {
        fn_start = function(inst)
            inst.AnimState:SetBank("chest_whitewood_big")
            inst.AnimState:SetBuild("chest_whitewood_big")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 }
    },
}

_G.SKINS_LEGION = {
    --[[
	rosorns_spell = {
        base_prefab = "rosorns",
		type = "item", --item物品、建筑等皮肤，base人物皮肤
		rarity = rarityRepay,
		skin_tags = {},
		release_group = 555,
		build_name_override = nil, --皮肤名称(居然是小写)

        skin_idx = 1, --[key]形式的下标不能按代码顺序，后面会统一排序的
        skin_id = "",
        noshopshow = nil, --为true的话，就不在鸡毛铺里展示
        onlyownedshow = true, --为true的话，只有玩家拥有该皮肤才在鸡毛铺里展示
		assets = { --仅仅是用于初始化注册
			Asset("ANIM", "anim/skin/swap_spear_mirrorrose.zip"),
			Asset("ANIM", "anim/skin/spear_mirrorrose.zip"),
            Asset("ANIM", "anim/skin/rosorns_spell.zip")
		},
		image = { name = nil, atlas = nil, setable = true }, --提前注册，或者皮肤初始化使用

        string = ischinese and { --皮肤字符
            name = "施咒蔷薇", collection = "MAGICSPELL", access = "DONATE",
            descitem = "解锁“带刺蔷薇”皮肤，以及攻击特效。",
            description = "据说\"梅林花园里的每一朵蔷薇都蕴含了危险的魔法\"。当然，这是当地教会的说辞。于是众人举着火把去过她的花园后，当晚花火摇曳，蔷薇如同梅林的灰烬一般，在此绝迹...",
        } or {
            name = "Rose Spell Staff", collection = "MAGICSPELL", access = "DONATE",
            descitem = "Unlock \"Rosorns\" skin and attack fx.",
            description = "It's said that every rose in Merlin garden has dangerous magic. Although, this is only rhetoric of the local church. Since people went to her garden with torches, roses dissipated like the ashes of Merlin.",
        },

		anim = { --皮肤初始化使用
            bank = "spear_mirrorrose", build = "spear_mirrorrose",
            anim = nil, animpush = nil, isloop = nil,
            setable = true
        },
        -- fn_anim = function(inst)end, --处于地面时的动画设置，替换anim的默认方式

        -- fn_start = function(inst)end, --应用皮肤时的函数(服务端)
        -- fn_end = nil, --取消皮肤时的函数(服务端)
        -- fn_start_c = nil, --应用皮肤时的函数(客户端)
        -- fn_end_c = nil, --取消皮肤时的函数(客户端)

        equip = { symbol = "swap_object", build = "swap_spear_mirrorrose", file = "swap_spear" },
        -- fn_equip = function(inst, owner)end, --装备时的贴图切换函数，替换equip的默认方式
        -- fn_unequip = function(inst, owner)end, --卸下装备时的贴图切换函数

        fn_onAttack = function(inst, owner, target) --攻击时的函数
            -- local fx = SpawnPrefab("wanda_attack_pocketwatch_normal_fx")
            local fx = SpawnPrefab("rosorns_spell_fx")
            if fx ~= nil then
                fx.Transform:SetPosition(target.Transform:GetWorldPosition())
            end
        end,

        exchangefx = { prefab = nil, offset_y = nil, scale = nil }, --prefab填了的话，就会替换扫把的皮肤切换特效
        -- fn_spawnSkinExchangeFx = function(inst)end, --皮肤交换时的特效生成函数，替换exchangefx的默认方式

        floater = { --底部切除比例，水纹动画后缀，水纹高度位置偏移，水纹大小，是否有水纹
            cut = 0.15, size = "small", offset_y = 0.4, scale = 0.5, nofx = nil,
            -- anim = {
            --     bank = nil, build = nil,
            --     anim = nil, animpush = nil, isloop = nil
            -- },
            -- fn_anim = function(inst)end, --处于水中时的动画设置，替换anim的默认方式
        },
        fn_placer = function(inst)end
    },
    ]]--

    rosebush_marble = {
        base_prefab = "rosebush", skin_id = "619108a04c724c6f40e77bd4",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
            Asset("ANIM", "anim/berrybush.zip"), --官方浆果丛动画
			Asset("ANIM", "anim/skin/rosebush_marble.zip")
		},
        string = ischinese and { name = "理盛赤蔷" } or { name = "Rose Marble Pot" },
		fn_start = function(inst)
            --官方代码写得挺好，直接改动画模板居然能继承已有的动画播放和symbol切换状态
            inst.AnimState:SetBank("berrybush")
            inst.AnimState:SetBuild("rosebush_marble")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        linkedskins = { sword = "rosorns_marble" },
        fn_placer = function(inst)
            inst.AnimState:SetBank("berrybush")
            inst.AnimState:SetBuild("rosebush_marble")
        end
    },
    rosorns_marble = {
        base_prefab = "rosorns", skin_id = "62e639928c2f781db2f79b3d", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/rosorns_marble.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/foliageath_rosorns_marble.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/foliageath_rosorns_marble.tex")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "落薇剪" } or { name = "Falling Petals Scissors" },
		anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = true, setable = true
        },
        equip = { symbol = "swap_object", build = "rosorns_marble", file = "swap_object" },
        fn_onAttack = function(inst, owner, target)
            local fx = SpawnPrefab("rosorns_marble_fx")
            if fx ~= nil then
                fx.Transform:SetPosition(target.Transform:GetWorldPosition())
            end
        end,
        scabbard = {
            anim = "idle_cover", isloop = true, bank = "rosorns_marble", build = "rosorns_marble",
            image = "foliageath_rosorns_marble", atlas = "images/inventoryimages_skin/foliageath_rosorns_marble.xml"
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.15, size = "small", offset_y = 0.4, scale = 0.5, nofx = nil }
    },
    lilybush_marble = {
        base_prefab = "lilybush", skin_id = "619116c74c724c6f40e77c40",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
            Asset("ANIM", "anim/berrybush.zip"), --官方浆果丛动画
			Asset("ANIM", "anim/skin/lilybush_marble.zip")
		},
        string = ischinese and { name = "理盛截莲" } or { name = "Lily Marble Pot" },
		fn_start = function(inst)
            inst.AnimState:SetBank("berrybush")
            inst.AnimState:SetBuild("lilybush_marble")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        linkedskins = { sword = "lileaves_marble" },
        fn_placer = function(inst)
            inst.AnimState:SetBank("berrybush")
            inst.AnimState:SetBuild("lilybush_marble")
        end
    },
    lileaves_marble = {
        base_prefab = "lileaves", skin_id = "62e535bd8c2f781db2f79ae7", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/lileaves_marble.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/foliageath_lileaves_marble.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/foliageath_lileaves_marble.tex")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "石莲长枪" } or { name = "Marble Lilance" },
		anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        equip = { symbol = "swap_object", build = "lileaves_marble", file = "swap_object" },
        scabbard = {
            anim = "idle_cover", isloop = nil, bank = "lileaves_marble", build = "lileaves_marble",
            image = "foliageath_lileaves_marble", atlas = "images/inventoryimages_skin/foliageath_lileaves_marble.xml"
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.15, size = "small", offset_y = 0.4, scale = 0.6, nofx = nil }
    },
    orchidbush_marble = {
        base_prefab = "orchidbush", skin_id = "6191d0514c724c6f40e77eb9",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
            Asset("ANIM", "anim/berrybush.zip"), --官方浆果丛动画
			Asset("ANIM", "anim/skin/orchidbush_marble.zip")
		},
        string = ischinese and { name = "理盛瀑兰" } or { name = "Orchid Marble Pot" },
		fn_start = function(inst)
            inst.AnimState:SetBank("berrybush")
            inst.AnimState:SetBuild("orchidbush_marble")
        end,
        exchangefx = { prefab = nil, offset_y = 1.3, scale = nil },
        linkedskins = { sword = "orchitwigs_marble" },
        fn_placer = function(inst)
            inst.AnimState:SetBank("berrybush")
            inst.AnimState:SetBuild("orchidbush_marble")
        end
    },
    orchitwigs_marble = {
        base_prefab = "orchitwigs", skin_id = "62e61d158c2f781db2f79b1e", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/orchitwigs_marble.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/foliageath_orchitwigs_marble.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/foliageath_orchitwigs_marble.tex")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "铁艺兰珊" } or { name = "Ironchid" },
		anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        equip = {
            symbol = "swap_object", build = "orchitwigs_marble", file = "swap_object",
            atkfx = "impact_orchid_fx_marble",
        },
        scabbard = {
            anim = "idle_cover", isloop = nil, bank = "orchitwigs_marble", build = "orchitwigs_marble",
            image = "foliageath_orchitwigs_marble", atlas = "images/inventoryimages_skin/foliageath_orchitwigs_marble.xml",
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.05, size = "small", offset_y = 0.15, scale = 0.5, nofx = nil }
    },

    orchidbush_disguiser = {
        base_prefab = "orchidbush", skin_id = "626029b9c340bf24ab31057a", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
            Asset("ANIM", "anim/berrybush2.zip"), --官方浆果丛动画
			Asset("ANIM", "anim/skin/orchidbush_disguiser.zip")
		},
        string = ischinese and { name = "粉色猎园" } or { name = "Pink Orchid Bush" },
		fn_start = function(inst)
            inst.AnimState:SetBank("berrybush2")
            inst.AnimState:SetBuild("orchidbush_disguiser")
        end,
        exchangefx = { prefab = nil, offset_y = 1.3, scale = nil },
        linkedskins = { sword = "orchitwigs_disguiser" },
        fn_placer = function(inst)
            inst.AnimState:SetBank("berrybush2")
            inst.AnimState:SetBuild("orchidbush_disguiser")
        end
    },
    orchitwigs_disguiser = {
        base_prefab = "orchitwigs", skin_id = "ooooonononon",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityFree,
		assets = {
			Asset("ANIM", "anim/skin/orchitwigs_disguiser.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/foliageath_orchitwigs_disguiser.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/foliageath_orchitwigs_disguiser.tex")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "粉色追猎" } or { name = "Pink Orchitwigs" },
		anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        equip = {
            symbol = "swap_object", build = "orchitwigs_disguiser", file = "swap_object",
            atkfx = "impact_orchid_fx_disguiser"
        },
        scabbard = {
            anim = "idle_cover", isloop = nil, bank = "orchitwigs_disguiser", build = "orchitwigs_disguiser",
            image = "foliageath_orchitwigs_disguiser", atlas = "images/inventoryimages_skin/foliageath_orchitwigs_disguiser.xml"
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.05, size = "small", offset_y = 0.15, scale = 0.5, nofx = nil }
    },

    neverfade_thanks = {
        base_prefab = "neverfade", skin_id = "6191d8f74c724c6f40e77ed0", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/neverfade_thanks.zip"),
            Asset("ANIM", "anim/skin/neverfade_butterfly_thanks.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/neverfade_thanks_broken.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/neverfade_thanks_broken.tex"),
            Asset("ATLAS", "images/inventoryimages_skin/foliageath_neverfade_thanks.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/foliageath_neverfade_thanks.tex")
		},
        image = { name = nil, atlas = nil, setable = false },
        string = ischinese and { name = "扶伤" } or { name = "FuShang" },
		anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        fn_start = function(inst)
            if inst.hasSetBroken then
                inst.components.inventoryitem.atlasname = "images/inventoryimages_skin/neverfade_thanks_broken.xml"
                inst.components.inventoryitem:ChangeImageName("neverfade_thanks_broken")
            else
                inst.components.inventoryitem.atlasname = "images/inventoryimages_skin/neverfade_thanks.xml"
                inst.components.inventoryitem:ChangeImageName("neverfade_thanks")
            end
        end,
        equip = {
            symbol = "swap_object", build = "neverfade_thanks", file = "normal_swap",
            build_broken = "neverfade_thanks", file_broken = "broken_swap"
        },
        scabbard = {
            anim = "idle_cover", isloop = nil, bank = "neverfade_thanks", build = "neverfade_thanks",
            image = "foliageath_neverfade_thanks", atlas = "images/inventoryimages_skin/foliageath_neverfade_thanks.xml"
        },
        butterfly = { bank = "butterfly", build = "neverfade_butterfly_thanks" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.05, size = "small", offset_y = 0.15, scale = 0.5, nofx = nil },
        linkedskins = { bush = "neverfadebush_thanks" },
        fn_placer = function(inst)
            inst.AnimState:SetBank("neverfadebush_thanks")
            inst.AnimState:SetBuild("neverfadebush_thanks")
        end
    },
    neverfadebush_thanks = {
        base_prefab = "neverfadebush", skin_id = "6191d8f74c724c6f40e77ed0", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/neverfadebush_thanks.zip")
		},
        string = { name = ischinese and "扶伤剑冢" or "FuShang Tomb" },
		fn_start = function(inst)
            inst.AnimState:SetBank("neverfadebush_thanks")
            inst.AnimState:SetBuild("neverfadebush_thanks")
        end,
        exchangefx = { prefab = nil, offset_y = 1.2, scale = nil },
        linkedskins = { sword = "neverfade_thanks" }
    },
    neverfade_paper = {
        base_prefab = "neverfade", skin_id = "638362b68c2f781db2f7f524", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/neverfade_paper.zip"),
            Asset("ANIM", "anim/skin/neverfade_butterfly_paper.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/neverfade_paper_broken.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/neverfade_paper_broken.tex"),
            Asset("ATLAS", "images/inventoryimages_skin/foliageath_neverfade_paper.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/foliageath_neverfade_paper.tex")
		},
        image = { name = nil, atlas = nil, setable = false },
        string = ischinese and { name = "青蝶纸剑" } or { name = "Paper-fly Sword" },
		fn_anim = function(inst)
            inst.AnimState:SetBank("neverfade_paper")
            inst.AnimState:SetBuild("neverfade_paper")
        end,
        fn_start = function(inst)
            if inst.hasSetBroken then
                inst.components.inventoryitem.atlasname = "images/inventoryimages_skin/neverfade_paper_broken.xml"
                inst.components.inventoryitem:ChangeImageName("neverfade_paper_broken")
                inst.AnimState:PlayAnimation("idle_broken")
            else
                inst.components.inventoryitem.atlasname = "images/inventoryimages_skin/neverfade_paper.xml"
                inst.components.inventoryitem:ChangeImageName("neverfade_paper")
                inst.AnimState:PlayAnimation("idle")
            end
        end,
        equip = {
            symbol = "swap_object", build = "neverfade_paper", file = "normal_swap",
            build_broken = "neverfade_paper", file_broken = "broken_swap"
        },
        scabbard = {
            anim = "idle_cover", isloop = nil, bank = "neverfade_paper", build = "neverfade_paper",
            image = "foliageath_neverfade_paper", atlas = "images/inventoryimages_skin/foliageath_neverfade_paper.xml",
        },
        butterfly = { bank = "butterfly", build = "neverfade_butterfly_paper" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.05, size = "small", offset_y = 0.15, scale = 0.5, nofx = nil },
        linkedskins = { bush = "neverfadebush_paper" },
        fn_placer = function(inst)
            inst.AnimState:SetBank("berrybush2")
            inst.AnimState:SetBuild("neverfadebush_paper")
        end
    },
    neverfadebush_paper = {
        base_prefab = "neverfadebush", skin_id = "638362b68c2f781db2f7f524", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/neverfadebush_paper.zip")
		},
        string = { name = ischinese and "青蝶纸扇" or "Paper-fly Fan" },
		fn_start = function(inst)
            inst.AnimState:SetBank("berrybush2")
            inst.AnimState:SetBuild("neverfadebush_paper")
        end,
        exchangefx = { prefab = nil, offset_y = 1.2, scale = nil },
        linkedskins = { sword = "neverfade_paper" }
    },
    neverfade_paper2 = {
        base_prefab = "neverfade", skin_id = "638362b68c2f781db2f7f524", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/neverfade_paper2.zip"),
            Asset("ANIM", "anim/skin/neverfade_butterfly_paper2.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/neverfade_paper2_broken.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/neverfade_paper2_broken.tex"),
            Asset("ATLAS", "images/inventoryimages_skin/foliageath_neverfade_paper2.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/foliageath_neverfade_paper2.tex")
		},
        image = { name = nil, atlas = nil, setable = false },
        string = ischinese and { name = "绀蝶纸剑" } or { name = "Violet Paper-fly Sword" },
		fn_anim = function(inst)
            inst.AnimState:SetBank("neverfade_paper2")
            inst.AnimState:SetBuild("neverfade_paper2")
        end,
        fn_start = function(inst)
            if inst.hasSetBroken then
                inst.components.inventoryitem.atlasname = "images/inventoryimages_skin/neverfade_paper2_broken.xml"
                inst.components.inventoryitem:ChangeImageName("neverfade_paper2_broken")
                inst.AnimState:PlayAnimation("idle_broken")
            else
                inst.components.inventoryitem.atlasname = "images/inventoryimages_skin/neverfade_paper2.xml"
                inst.components.inventoryitem:ChangeImageName("neverfade_paper2")
                inst.AnimState:PlayAnimation("idle")
            end
        end,
        equip = {
            symbol = "swap_object", build = "neverfade_paper2", file = "normal_swap",
            build_broken = "neverfade_paper2", file_broken = "broken_swap"
        },
        scabbard = {
            anim = "idle_cover", isloop = nil, bank = "neverfade_paper2", build = "neverfade_paper2",
            image = "foliageath_neverfade_paper2", atlas = "images/inventoryimages_skin/foliageath_neverfade_paper2.xml",
        },
        butterfly = { bank = "butterfly", build = "neverfade_butterfly_paper2" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.05, size = "small", offset_y = 0.15, scale = 0.5, nofx = nil },
        linkedskins = { bush = "neverfadebush_paper2" },
        fn_placer = function(inst)
            inst.AnimState:SetBank("berrybush2")
            inst.AnimState:SetBuild("neverfadebush_paper2")
        end
    },
    neverfadebush_paper2 = {
        base_prefab = "neverfadebush", skin_id = "638362b68c2f781db2f7f524", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/neverfadebush_paper2.zip")
		},
        string = { name = ischinese and "绀蝶纸扇" or "Violet Paper-fly Fan" },
		fn_start = function(inst)
            inst.AnimState:SetBank("berrybush2")
            inst.AnimState:SetBuild("neverfadebush_paper2")
        end,
        exchangefx = { prefab = nil, offset_y = 1.2, scale = nil },
        linkedskins = { sword = "neverfade_paper2" }
    },

    hat_lichen_emo_que = {
        base_prefab = "hat_lichen", skin_id = "61909c584c724c6f40e779fa",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/hat_lichen_emo_que.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "困惑发卡" } or { name = "Question Hairpin" },
		anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        equip = { symbol = "swap_hat", build = "hat_lichen_emo_que", file = "swap_hat", isopenhat = true },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.03, size = "small", offset_y = 0.15, scale = 0.5, nofx = nil }
    },
    hat_lichen_disguiser = {
        base_prefab = "hat_lichen", skin_id = "ooooonononon",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityFree,
		assets = {
			Asset("ANIM", "anim/skin/hat_lichen_disguiser.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "深渊的星" } or { name = "Abyss Star Hairpin" },
		anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        equip = {
            symbol = "swap_hat", build = "hat_lichen_disguiser", file = "swap_hat",
            isopenhat = false, lightcolor = { r = 0, g = 1, b = 1 }
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.03, size = "med", offset_y = 0.2, scale = 0.7, nofx = nil }
    },

    hat_cowboy_tvplay = {
        base_prefab = "hat_cowboy", skin_id = "ooooonononon",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityFree,
		assets = {
			Asset("ANIM", "anim/skin/hat_cowboy_tvplay.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "卡尔的警帽，永远" } or { name = "Carl's Forever Police Cap" },
		anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        equip = { symbol = "swap_hat", build = "hat_cowboy_tvplay", file = "swap_hat" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.03, size = "med", offset_y = 0.2, scale = 0.8, nofx = nil }
    },
    pinkstaff_tvplay = {
        base_prefab = "pinkstaff", skin_id = "ooooonononon",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityFree,
		assets = {
			Asset("ANIM", "anim/skin/pinkstaff_tvplay.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "音速起子12" } or { name = "Sonic Screwdriver 12" },
		anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        fn_start = function(inst)
            inst.fxcolour = {115/255, 217/255, 255/255}
        end,
        fn_end = function(inst)
            EndFollowedFx(inst, nil, "fx_l_pinkstaff_tv")
        end,
        equip = { symbol = "swap_object", build = "pinkstaff_tvplay", file = "swap_object" },
        equipfx = {
            start = function(inst, owner)
                SetFollowedFx(inst, owner, "pinkstaff_fx_tvplay", "swap_object", 0, -140, "fx_l_pinkstaff_tv")
            end,
            stop = function(inst, owner)
                EndFollowedFx(inst, nil, "fx_l_pinkstaff_tv")
            end
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.15, size = "small", offset_y = 0.35, scale = 0.5, nofx = nil }
    },

    boltwingout_disguiser = {
        base_prefab = "boltwingout", skin_id = "61c57daadb102b0b8a50ae95",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/boltwingout_disguiser.zip"),
            Asset("ANIM", "anim/skin/boltwingout_shuck_disguiser.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "枯叶飞舞" } or { name = "Fallen Dance" },
		anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        equip = { symbol = "swap_body", build = "boltwingout_disguiser", file = "swap_body" },
        boltdata = { fx = "boltwingout_fx_disguiser", build = "boltwingout_shuck_disguiser" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = nil, size = "med", offset_y = 0.1, scale = 0.8, nofx = nil }
    },

    fishhomingtool_awesome_thanks = {
        base_prefab = "fishhomingtool_awesome", skin_id = "627f66c0c340bf24ab311783", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/fishhomingtool_awesome_thanks.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "云烟" } or { name = "YunYan" },
        anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        fn_start = function(inst)
            inst.components.bundlemaker:SetSkinData("fishhomingbait_thanks", nil)
        end,
        equip = { symbol = "swap_object", build = "fishhomingtool_awesome_thanks", file = "swap" },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },
    fishhomingtool_awesome_taste = {
        base_prefab = "fishhomingtool_awesome", skin_id = "61ff45880a30fc7fca0db5e5", onlyownedshow = true, mustonwedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityFree,
		assets = {
			Asset("ANIM", "anim/skin/fishhomingtool_awesome_taste.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "茶之恋榨汁机" } or { name = "Tea Heart Juicer" },
        anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        fn_start = function(inst)
            inst.components.bundlemaker:SetSkinData("fishhomingbait_taste", nil)
        end,
        equip = { symbol = "swap_object", build = "fishhomingtool_awesome_taste", file = "swap" },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },
    fishhomingtool_normal_thanks = {
        base_prefab = "fishhomingtool_normal", skin_id = "627f66c0c340bf24ab311783", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/fishhomingtool_normal_thanks.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = { name = ischinese and "云烟草" or "YunYan Cigarette" },
        anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        fn_start = function(inst)
            inst.components.bundlemaker:SetSkinData("fishhomingbait_thanks", nil)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },
    fishhomingtool_normal_taste = {
        base_prefab = "fishhomingtool_normal", skin_id = "61ff45880a30fc7fca0db5e5", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityFree,
		assets = {
			Asset("ANIM", "anim/skin/fishhomingtool_normal_taste.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "一袋茶之恋" } or { name = "A Bag of Tea Heart" },
        anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        fn_start = function(inst)
            inst.components.bundlemaker:SetSkinData("fishhomingbait_taste", nil)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },
    fishhomingbait_thanks = {
        base_prefab = "fishhomingbait", skin_id = "627f66c0c340bf24ab311783", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
            Asset("ANIM", "anim/pollen_chum.zip"), --官方藤壶花粉动画
			Asset("ANIM", "anim/skin/fishhomingbait_thanks.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/fishhomingbait1_thanks.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/fishhomingbait1_thanks.tex"),
            Asset("ATLAS", "images/inventoryimages_skin/fishhomingbait2_thanks.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/fishhomingbait2_thanks.tex"),
            Asset("ATLAS", "images/inventoryimages_skin/fishhomingbait3_thanks.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/fishhomingbait3_thanks.tex")
		},
        image = { name = nil, atlas = nil, setable = false }, --皮肤展示需要一个同prefab名的图片
        string = { name = ischinese and "云烟瓶" or "YunYan Bottle" },
        fn_start = function(inst)
            inst.baitimgs_l = {
                dusty = {
                    img = "fishhomingbait1_thanks", atlas = "images/inventoryimages_skin/fishhomingbait1_thanks.xml",
                    anim = "idle1", swap = "swap1", symbol = "base1", build = "fishhomingbait_thanks"
                },
                pasty = {
                    img = "fishhomingbait2_thanks", atlas = "images/inventoryimages_skin/fishhomingbait2_thanks.xml",
                    anim = "idle2", swap = "swap2", symbol = "base2", build = "fishhomingbait_thanks"
                },
                hardy = {
                    img = "fishhomingbait3_thanks", atlas = "images/inventoryimages_skin/fishhomingbait3_thanks.xml",
                    anim = "idle3", swap = "swap3", symbol = "base3", build = "fishhomingbait_thanks"
                }
            }
            inst.AnimState:SetBank("fishhomingbait_thanks")
            inst.AnimState:SetBuild("fishhomingbait_thanks")
            if inst.components.fishhomingbait and inst.components.fishhomingbait.oninitfn then
                inst.components.fishhomingbait.oninitfn(inst)
            end
        end,
        baiting = { bank = "pollen_chum", build = "pollen_chum" },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },
    fishhomingbait_taste = {
        base_prefab = "fishhomingbait", skin_id = "61ff45880a30fc7fca0db5e5", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityFree,
		assets = {
            Asset("ANIM", "anim/pollen_chum.zip"), --官方藤壶花粉动画
			Asset("ANIM", "anim/skin/fishhomingbait_taste.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/fishhomingbait1_taste.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/fishhomingbait1_taste.tex"),
            Asset("ATLAS", "images/inventoryimages_skin/fishhomingbait2_taste.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/fishhomingbait2_taste.tex"),
            Asset("ATLAS", "images/inventoryimages_skin/fishhomingbait3_taste.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/fishhomingbait3_taste.tex")
		},
        image = { name = nil, atlas = nil, setable = false }, --皮肤展示需要一个同prefab名的图片
        string = ischinese and { name = "茶之恋" } or { name = "Tea Heart" },
        fn_start = function(inst)
            inst.baitimgs_l = {
                dusty = {
                    img = "fishhomingbait1_taste", atlas = "images/inventoryimages_skin/fishhomingbait1_taste.xml",
                    anim = "idle1", swap = "swap1", symbol = "base1", build = "fishhomingbait_taste", isshield = true
                },
                pasty = {
                    img = "fishhomingbait2_taste", atlas = "images/inventoryimages_skin/fishhomingbait2_taste.xml",
                    anim = "idle2", swap = "swap2", symbol = "base2", build = "fishhomingbait_taste", isshield = true
                },
                hardy = {
                    img = "fishhomingbait3_taste", atlas = "images/inventoryimages_skin/fishhomingbait3_taste.xml",
                    anim = "idle3", swap = "swap3", symbol = "base3", build = "fishhomingbait_taste", isshield = true
                }
            }
            inst.AnimState:SetBank("fishhomingbait_taste")
            inst.AnimState:SetBuild("fishhomingbait_taste")
            if inst.components.fishhomingbait and inst.components.fishhomingbait.oninitfn then
                inst.components.fishhomingbait.oninitfn(inst)
            end
        end,
        baiting = { bank = "pollen_chum", build = "pollen_chum" },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },

    shield_l_log_emo_pride = {
        base_prefab = "shield_l_log", skin_id = "ooooonononon",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityFree,
		assets = {
			Asset("ANIM", "anim/skin/shield_l_log_emo_pride.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "爱上彩虹" } or { name = "Love Rainbow" },
        anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        equip = { symbol = "lantern_overlay", build = "shield_l_log_emo_pride", file = "swap_shield" },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.7 },
        floater = { cut = nil, size = "small", offset_y = 0.2, scale = 0.9, nofx = nil },
        fn_start = function(inst)
            FxInit(inst, {"fx_ranimbowspark"}, -10)
        end,
        fn_end = FxClear
    },
    shield_l_log_emo_fist = {
        base_prefab = "shield_l_log", skin_id = "629b0d278c2f781db2f77ef8", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/shield_l_log_emo_fist.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "重拳出击" } or { name = "Punch Quest" },
        anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        equip = { symbol = "lantern_overlay", build = "shield_l_log_emo_fist", file = "swap_shield" },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.6 },
        floater = { cut = nil, size = "small", offset_y = 0.2, scale = 0.8, nofx = nil }
    },
    shield_l_log_era = {
        base_prefab = "shield_l_log", skin_id = "629b0d088c2f781db2f77ef4", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/shield_l_log_era.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "三叶虫化石" } or { name = "Trilobite Fossil" },
        anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        equip = { symbol = "lantern_overlay", build = "shield_l_log_era", file = "swap_shield" },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.7 },
        floater = { cut = nil, size = "small", offset_y = 0.2, scale = 0.8, nofx = nil }
    },

    shield_l_sand_era = {
        base_prefab = "shield_l_sand", skin_id = "62845917c340bf24ab311969", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/shield_l_sand_era.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "三角龙头骨" } or { name = "The Skull of Triceratops" },
        anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        equip = { symbol = "lantern_overlay", build = "shield_l_sand_era", file = "swap_shield" },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },
    shield_l_sand_op = {
        base_prefab = "shield_l_sand", skin_id = "ooooonononon",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityFree,
		assets = {
			Asset("ANIM", "anim/skin/shield_l_sand_op.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "旧稿" } or { name = "Old Art" },
        anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        equip = { symbol = "lantern_overlay", build = "shield_l_sand_op", file = "swap_shield" },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },

    agronssword_taste = {
        base_prefab = "agronssword", skin_id = "637f66d88c2f781db2f7f2d0", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/agronssword_taste.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/agronssword_taste.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/agronssword_taste.tex"),
            Asset("ATLAS", "images/inventoryimages_skin/agronssword_taste2.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/agronssword_taste2.tex")
		},
        string = ischinese and { name = "糖霜法棍" } or { name = "Frosting Baguette" },
        fn_start = function(inst)
            inst._dd = {
                img_tex = "agronssword_taste", img_atlas = "images/inventoryimages_skin/agronssword_taste.xml",
                img_tex2 = "agronssword_taste2", img_atlas2 = "images/inventoryimages_skin/agronssword_taste2.xml",
                build = "agronssword_taste", fx = "agronssword_fx_taste"
            }
            Fn_start_agronssword(inst)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
    },

    icire_rock_era = {
        base_prefab = "icire_rock", skin_id = "6280d4f2c340bf24ab3118b1", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
            -- Asset("ANIM", "anim/heat_rock.zip"), --官方热能石动画模板。因为本体也引用了，所以这不重复引用
			Asset("ANIM", "anim/skin/icire_rock_era.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/icire_rock1_era.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/icire_rock1_era.tex"),
            Asset("ATLAS", "images/inventoryimages_skin/icire_rock2_era.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/icire_rock2_era.tex"),
            Asset("ATLAS", "images/inventoryimages_skin/icire_rock3_era.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/icire_rock3_era.tex"),
            Asset("ATLAS", "images/inventoryimages_skin/icire_rock4_era.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/icire_rock4_era.tex"),
            Asset("ATLAS", "images/inventoryimages_skin/icire_rock5_era.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/icire_rock5_era.tex")
		},
		image = { name = nil, atlas = nil, setable = false },
        string = ischinese and { name = "琥珀石中蝇" } or { name = "In Amber" },
		fn_start = function(inst)
            inst.AnimState:SetBank("heat_rock")
            inst.AnimState:SetBuild("heat_rock")
            inst.AnimState:OverrideSymbol("rock", "icire_rock_era", "rock")
            inst.AnimState:OverrideSymbol("shadow", "icire_rock_era", "shadow")

            inst._dd = { img_pst = "_era", canbloom = true }
            inst.fn_temp(inst)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },
    icire_rock_collector = {
        base_prefab = "icire_rock", skin_id = "62df65b58c2f781db2f7998a", onlyownedshow = true, mustonwedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/icire_rock_collector.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/icire_rock1_collector.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/icire_rock1_collector.tex"),
            Asset("ATLAS", "images/inventoryimages_skin/icire_rock2_collector.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/icire_rock2_collector.tex"),
            Asset("ATLAS", "images/inventoryimages_skin/icire_rock3_collector.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/icire_rock3_collector.tex"),
            Asset("ATLAS", "images/inventoryimages_skin/icire_rock4_collector.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/icire_rock4_collector.tex"),
            Asset("ATLAS", "images/inventoryimages_skin/icire_rock5_collector.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/icire_rock5_collector.tex")
		},
		image = { name = nil, atlas = nil, setable = false },
        string = ischinese and { name = "占星石" } or { name = "Astrological Stone" },
		fn_start = function(inst)
            inst.AnimState:SetBank("icire_rock_collector")
            inst.AnimState:SetBuild("icire_rock_collector")
            inst.AnimState:ClearOverrideSymbol("rock")
            inst.AnimState:ClearOverrideSymbol("shadow")

            inst._dd = { img_pst = "_collector", canbloom = true }
            inst.fn_temp(inst)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },
    icire_rock_day = {
        base_prefab = "icire_rock", skin_id = "6380cbb88c2f781db2f7f400", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/icire_rock_day.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/icire_rock1_day.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/icire_rock1_day.tex"),
            Asset("ATLAS", "images/inventoryimages_skin/icire_rock2_day.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/icire_rock2_day.tex"),
            Asset("ATLAS", "images/inventoryimages_skin/icire_rock3_day.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/icire_rock3_day.tex"),
            Asset("ATLAS", "images/inventoryimages_skin/icire_rock4_day.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/icire_rock4_day.tex"),
            Asset("ATLAS", "images/inventoryimages_skin/icire_rock5_day.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/icire_rock5_day.tex")
		},
		image = { name = nil, atlas = nil, setable = false },
        string = ischinese and { name = "风景球" } or { name = "Landscape Ball" },
		fn_start = function(inst)
            inst.AnimState:SetBank("icire_rock_day")
            inst.AnimState:SetBuild("icire_rock_day")
            inst.AnimState:ClearOverrideSymbol("rock")
            inst.AnimState:ClearOverrideSymbol("shadow")

            inst._dd = { img_pst = "_day", canbloom = false, fn_temp = Fn_icire_rock_day }
            inst.fn_temp(inst)
        end,
        fn_end = function(inst)
            if inst._dd_fx then
                if inst._dd_fx:IsValid() then
                    inst._dd_fx:Remove()
                end
                inst._dd_fx = nil
            end
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },

    lilybush_era = {
        base_prefab = "lilybush", skin_id = "629b0d5f8c2f781db2f77f0d", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
            Asset("ANIM", "anim/berrybush2.zip"), --官方浆果丛动画
			Asset("ANIM", "anim/skin/lilybush_era.zip")
		},
        string = ischinese and { name = "婆娑角蕨" } or { name = "Platycerium Bush" },
		fn_start = function(inst)
            inst.AnimState:SetBank("berrybush2")
            inst.AnimState:SetBuild("lilybush_era")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        linkedskins = { sword = "lileaves_era" },
        fn_placer = function(inst)
            inst.AnimState:SetBank("berrybush2")
            inst.AnimState:SetBuild("lilybush_era")
        end
    },
    lileaves_era = {
        base_prefab = "lileaves", skin_id = "629b0d5f8c2f781db2f77f0d", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/lileaves_era.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/foliageath_lileaves_era.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/foliageath_lileaves_era.tex")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = { name = ischinese and "婆娑花叶" or "Platycerium Leaves" },
		anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        equip = { symbol = "swap_object", build = "lileaves_era", file = "swap_object" },
        scabbard = {
            anim = "idle_cover", isloop = nil, bank = "lileaves_era", build = "lileaves_era",
            image = "foliageath_lileaves_era", atlas = "images/inventoryimages_skin/foliageath_lileaves_era.xml"
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.05, size = "small", offset_y = 0.15, scale = 0.5, nofx = nil }
    },

    triplegoldenshovelaxe_era = {
        base_prefab = "triplegoldenshovelaxe", skin_id = "629b0d848c2f781db2f77f11", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/triplegoldenshovelaxe_era.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "铛铛考古镐" } or { name = "Era River Explorer" },
		anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        equip = { symbol = "swap_object", build = "triplegoldenshovelaxe_era", file = "swap" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = nil, size = "med", offset_y = 0.15, scale = 0.4, nofx = nil }
    },
    tripleshovelaxe_era = {
        base_prefab = "tripleshovelaxe", skin_id = "629b0d848c2f781db2f77f11", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/tripleshovelaxe_era.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = { name = ischinese and "叮叮考古镐" or "Era Valley Explorer" },

		anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        equip = { symbol = "swap_object", build = "tripleshovelaxe_era", file = "swap" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = nil, size = "med", offset_y = 0.15, scale = 0.4, nofx = nil }
    },

    backcub_fans = {
        base_prefab = "backcub", skin_id = "629cca398c2f781db2f78092", onlyownedshow = true, mustonwedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityFree,
		assets = {
			Asset("ANIM", "anim/skin/backcub_fans.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "饭仔" } or { name = "Kid Fan" },
		anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        equip = { symbol = "swap_body", build = "backcub_fans", file = "swap_body" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = nil, size = "med", offset_y = 0.1, scale = 1.1, nofx = nil }
    },
    backcub_thanks = {
        base_prefab = "backcub", skin_id = "62f235928c2f781db2f7a2dd", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/backcub_thanks.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "浮生儿" } or { name = "Foosen" },
		fn_anim = function(inst)
            SetRandomSkinAnim(inst, {
                "idle1", "idle1", "idle1", "idle2", "idle3", "idle3", "idle4", "idle5"
            })
        end,
        fn_start = function(inst)
            inst.AnimState:SetBank("backcub_thanks")
            inst.AnimState:SetBuild("backcub_thanks")
        end,
        fn_end = function(inst)
            CancelRandomSkinAnim(inst)
        end,
        equip = { symbol = "swap_body", build = "backcub_thanks", file = "swap_body" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = nil, size = "med", offset_y = 0.1, scale = 0.9, nofx = nil,
            fn_anim = function(inst)
                SetRandomSkinAnim(inst, {
                    "idle1_water", "idle1_water", "idle1_water", "idle2_water",
                    "idle3_water", "idle3_water", "idle4_water", "idle5_water"
                })
            end
        }
    },
    backcub_fans2 = {
        base_prefab = "backcub", skin_id = "6309c6e88c2f781db2f7ae20", onlyownedshow = true, mustonwedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityFree,
		assets = {
			Asset("ANIM", "anim/skin/backcub_fans2.zip"),
            Asset("ANIM", "anim/skin/ui_backcub_fans2_2x6.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "饭豆子" } or { name = "Bean Fan" },
        fn_start = function(inst)
            inst.AnimState:SetBank("backcub_fans2")
            inst.AnimState:SetBuild("backcub_fans2")
            inst.components.container:Close()
            inst.components.container:WidgetSetup("backcub_fans2")
        end,
        fn_end = function(inst)
            CancelRandomSkinAnim(inst)
            inst.components.container:Close()
            inst.components.container:WidgetSetup("backcub")
        end,
        fn_start_c = function(inst)
            SetWidget(inst, "backcub_fans2")
        end,
        fn_end_c = function(inst)
            SetWidget(inst, "backcub")
        end,
        fn_anim = function(inst)
            SetRandomSkinAnim(inst, {
                "idle1", "idle1", "idle1", "idle1", "idle2", "idle3", "idle3"
            })
        end,
        equip = { symbol = "swap_body", build = "backcub_fans2", file = "swap_body" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = nil, size = "med", offset_y = 0.1, scale = 0.9, nofx = nil,
            fn_anim = function(inst)
                SetRandomSkinAnim(inst, {
                    "idle1_water", "idle1_water", "idle1_water", "idle2_water"
                })
            end
        }
    },

    rosebush_collector = {
        base_prefab = "rosebush", skin_id = "62e3c3a98c2f781db2f79abc", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
            Asset("ANIM", "anim/berrybush.zip"), --官方浆果丛动画
			Asset("ANIM", "anim/skin/rosebush_collector.zip")
		},
        string = ischinese and { name = "朽星棘" } or { name = "Star Blighted Thorns" },
		fn_start = function(inst)
            --官方代码写得挺好，直接改动画模板居然能继承已有的动画播放和symbol切换状态
            inst.AnimState:SetBank("berrybush")
            inst.AnimState:SetBuild("rosebush_collector")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        linkedskins = { sword = "rosorns_collector" },
        fn_placer = function(inst)
            inst.AnimState:SetBank("berrybush")
            inst.AnimState:SetBuild("rosebush_collector")
        end
    },
    rosorns_collector = {
        base_prefab = "rosorns", skin_id = "62e3c3a98c2f781db2f79abc", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/rosorns_collector.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/foliageath_rosorns_collector.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/foliageath_rosorns_collector.tex")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = { name = ischinese and "贯星剑" or "Star Pierced Sword" },
		anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = true, setable = true
        },
        equip = { symbol = "swap_object", build = "rosorns_collector", file = "swap_object" },
        fn_onAttack = function(inst, owner, target)
            local fx = SpawnPrefab("rosorns_collector_fx")
            if fx ~= nil then
                fx.Transform:SetPosition(target.Transform:GetWorldPosition())
            end
        end,
        scabbard = {
            anim = "idle_cover", isloop = true, bank = "rosorns_collector", build = "rosorns_collector",
            image = "foliageath_rosorns_collector", atlas = "images/inventoryimages_skin/foliageath_rosorns_collector.xml"
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { nofx = true }
    },

    fimbul_axe_collector = {
        base_prefab = "fimbul_axe", skin_id = "62e775148c2f781db2f79ba1", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/fimbul_axe_collector.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "跃星杖" } or { name = "Star Leaping Staff" },
		anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = true, --为啥要为true?
            setable = true
        },
        equip = { symbol = "swap_object", build = "fimbul_axe_collector", file = "swap_base" },
        fn_onThrown = function(inst, owner, target)
            if owner ~= nil and owner:HasTag("player") then
                owner.AnimState:OverrideSymbol("swap_object", "fimbul_axe_collector", "swap_throw")
                owner.AnimState:Show("ARM_carry")
                owner.AnimState:Hide("ARM_normal")
            end
            if inst.task_skinfx ~= nil then
                inst.task_skinfx:Cancel()
            end
            inst.task_skinfx = inst:DoPeriodicTask(0.08, function()
                local fx = SpawnPrefab("fimbul_axe_collector_fx")
                if fx ~= nil then
                    fx.Transform:SetPosition(GetSpawnPoint(inst:GetPosition(), 0.2+math.random()*1.5))
                end
            end, 0)
        end,
        fn_onLightning = function(inst, owner, target)
            local x, y, z
            if target == nil then
                x, y, z = inst.Transform:GetWorldPosition()
            else
                x, y, z = target.Transform:GetWorldPosition()
            end
            local fx = SpawnPrefab("fimbul_axe_collector2_fx")
            if fx ~= nil then
                fx.Transform:SetPosition(x, y, z)
            end
            fx = SpawnPrefab("fimbul_axe_collector3_fx")
            if fx ~= nil then
                fx.Transform:SetPosition(x, y, z)
            end
        end,
        fn_onThrownEnd = function(inst)
            if inst.task_skinfx ~= nil then
                inst.task_skinfx:Cancel()
                inst.task_skinfx = nil
            end
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.4, nofx = nil }
    },

    siving_turn_collector = {
        base_prefab = "siving_turn", skin_id = "62eb8b9e8c2f781db2f79d21", onlyownedshow = true, mustonwedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/siving_turn_collector.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/siving_turn_collector.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/siving_turn_collector.tex")
		},
        string = ischinese and { name = "转星移" } or { name = "Revolving Star" },
		fn_start = function(inst)
            Fn_sivturn(inst, "siving_turn_collector", false)
            inst.components.genetrans.fxdata.unlockfx = "siving_turn_collector_unlock_fx"
        end,
        fn_fruit = function(genetrans)
            Fn_sivturn_fruit(genetrans, "siving_turn_collector")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        fn_placer = function(inst)
            inst.AnimState:SetBank("siving_turn_collector")
            inst.AnimState:SetBuild("siving_turn_collector")
        end
    },
    siving_turn_future = {
        base_prefab = "siving_turn", skin_id = "647d83c269b4f368be4533e9", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/siving_turn_future.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/siving_turn_future.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/siving_turn_future.tex")
		},
        string = ischinese and { name = "爱汪基因诱变舱" } or { name = "Bark Gene Mutation Cabin" },
		fn_start = function(inst)
            inst.components.genetrans.fn_setanim = Fn_sivturn_anim_futrue
            inst.components.genetrans.fxdata.unlockfx = "siving_turn_future_unlock_fx"
            Fn_sivturn(inst, "siving_turn_future", false)
        end,
        fn_end = function(inst)
            inst.components.genetrans.fn_setanim = nil
            inst.AnimState:ClearOverrideSymbol("followed")
        end,
        fn_fruit = function(genetrans)
            Fn_sivturn_fruit(genetrans, "siving_turn_future")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        fn_placer = function(inst)
            inst.AnimState:SetBank("siving_turn_future")
            inst.AnimState:SetBuild("siving_turn_future")
        end
    },
    siving_turn_future2 = {
        base_prefab = "siving_turn", skin_id = "647d972169b4f368be45343a", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/siving_turn_future2.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/siving_turn_future2.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/siving_turn_future2.tex")
		},
        string = ischinese and { name = "爱喵基因诱变舱" } or { name = "Mew Gene Mutation Cabin" },
		fn_start = function(inst)
            inst.components.genetrans.fn_setanim = Fn_sivturn_anim_futrue
            inst.components.genetrans.fxdata.unlockfx = "siving_turn_future2_unlock_fx"
            Fn_sivturn(inst, "siving_turn_future2", false)
        end,
        fn_end = function(inst)
            inst.components.genetrans.fn_setanim = nil
            inst.AnimState:ClearOverrideSymbol("followed")
        end,
        fn_fruit = function(genetrans)
            Fn_sivturn_fruit(genetrans, "siving_turn_future2")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        fn_placer = function(inst)
            inst.AnimState:SetBank("siving_turn_future2")
            inst.AnimState:SetBuild("siving_turn_future2")
        end
    },

    siving_derivant_thanks = {
        base_prefab = "siving_derivant", skin_id = "62eb6e0e8c2f781db2f79cc2", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/siving_derivant_thanks.zip")
		},
        string = ischinese and { name = "梨花开" } or { name = "Snowflake Pine" },
		fn_start = function(inst)
            inst.AnimState:SetBank("siving_derivant_thanks")
            inst.AnimState:SetBuild("siving_derivant_thanks")
            inst.AnimState:SetScale(1.3, 1.3)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        fn_placer = function(inst)
            inst.AnimState:SetBank("siving_derivant_thanks")
            inst.AnimState:SetBuild("siving_derivant_thanks")
            inst.AnimState:SetScale(1.3, 1.3)
        end
    },
    siving_derivant_thanks2 = {
        base_prefab = "siving_derivant", skin_id = "62eb6e0e8c2f781db2f79cc2", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/siving_derivant_thanks2.zip")
		},
        string = ischinese and { name = "梨带雨" } or { name = "Snowflake Prayer Pine" },
		fn_start = function(inst)
            inst.AnimState:SetBank("siving_derivant_thanks2")
            inst.AnimState:SetBuild("siving_derivant_thanks2")
            inst.AnimState:SetScale(1.3, 1.3)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        fn_placer = function(inst)
            inst.AnimState:SetBank("siving_derivant_thanks2")
            inst.AnimState:SetBuild("siving_derivant_thanks2")
            inst.AnimState:SetScale(1.3, 1.3)
        end
    },

    carpet_whitewood_law = {
        base_prefab = "carpet_whitewood", skin_id = "63805cf58c2f781db2f7f34b", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/carpet_whitewood_law.zip")
		},
        image = { name = nil, atlas = nil, setable = false },
        string = ischinese and { name = "小西洋棋棋盘" } or { name = "Quarter Chessboard" },
        anim = {
            bank = "carpet_whitewood_law", build = "carpet_whitewood_law",
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        fn_placer = function(inst)
            inst.AnimState:SetBank("carpet_whitewood_law")
            inst.AnimState:SetBuild("carpet_whitewood_law")
        end
    },
    carpet_whitewood_big_law = {
        base_prefab = "carpet_whitewood_big", skin_id = "63805cf58c2f781db2f7f34b", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/carpet_whitewood_law.zip")
		},
        image = { name = nil, atlas = nil, setable = false },
        string = ischinese and { name = "西洋棋棋盘" } or { name = "Chessboard" },
        anim = {
            bank = "carpet_whitewood_law", build = "carpet_whitewood_law",
            anim = "idle_big", animpush = nil, isloop = nil, setable = true
        },
        fn_start = function(inst)
            inst.AnimState:SetScale(1.08, 1.08, 1.08)
        end,
        fn_end = function(inst)
            inst.AnimState:SetScale(1, 1, 1)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        fn_placer = function(inst)
            inst.AnimState:SetBank("carpet_whitewood_law")
            inst.AnimState:SetBuild("carpet_whitewood_law")
            inst.AnimState:SetScale(1.08, 1.08, 1.08)
        end
    },
    carpet_whitewood_law2 = {
        base_prefab = "carpet_whitewood", skin_id = "63805d098c2f781db2f7f34f", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/carpet_whitewood_law2.zip")
		},
        image = { name = nil, atlas = nil, setable = false },
        string = ischinese and { name = "小西洋棋黑棋盘" } or { name = "Quarter Black Chessboard" },
        anim = {
            bank = "carpet_whitewood_law2", build = "carpet_whitewood_law2",
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        fn_placer = function(inst)
            inst.AnimState:SetBank("carpet_whitewood_law2")
            inst.AnimState:SetBuild("carpet_whitewood_law2")
        end
    },
    carpet_whitewood_big_law2 = {
        base_prefab = "carpet_whitewood_big", skin_id = "63805d098c2f781db2f7f34f", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/carpet_whitewood_law2.zip")
		},
        image = { name = nil, atlas = nil, setable = false },
        string = ischinese and { name = "西洋棋黑棋盘" } or { name = "Black Chessboard" },
        anim = {
            bank = "carpet_whitewood_law2", build = "carpet_whitewood_law2",
            anim = "idle_big", animpush = nil, isloop = nil, setable = true
        },
        fn_start = function(inst)
            inst.AnimState:SetScale(1.08, 1.08, 1.08)
        end,
        fn_end = function(inst)
            inst.AnimState:SetScale(1, 1, 1)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        fn_placer = function(inst)
            inst.AnimState:SetBank("carpet_whitewood_law2")
            inst.AnimState:SetBuild("carpet_whitewood_law2")
            inst.AnimState:SetScale(1.08, 1.08, 1.08)
        end
    },

    soul_contracts_taste = {
        base_prefab = "soul_contracts", skin_id = "638074368c2f781db2f7f374", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
            -- Asset("ANIM", "anim/book_maxwell.zip"), --官方暗影秘典动画模板
			Asset("ANIM", "anim/skin/soul_contracts_taste.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "芝士三明治" } or { name = "Cheese Sandwich" },
		fn_start = function(inst)
            inst.AnimState:SetBank("book_maxwell")
            inst.AnimState:SetBuild("soul_contracts_taste")
            inst._dd = { fx = "l_soul_fx_taste" }
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = nil }
    },

    siving_feather_real_paper = {
        base_prefab = "siving_feather_real", skin_id = "6387156a8c2f781db2f7f670", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/siving_feather_real_paper.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "十字纸镖" } or { name = "Cross Paper Dart" },
		anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        equip = {
            symbol = "lantern_overlay", build = "siving_feather_real_paper", file = "swap",
            isshield = true
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.04, size = "small", offset_y = 0.2, scale = 0.5, nofx = nil }
    },
    siving_feather_fake_paper = {
        base_prefab = "siving_feather_fake", skin_id = "6387156a8c2f781db2f7f670", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/siving_feather_fake_paper.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "四方纸镖" } or { name = "Square Paper Dart" },
		anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        equip = {
            symbol = "lantern_overlay", build = "siving_feather_fake_paper", file = "swap",
            isshield = true
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.04, size = "small", offset_y = 0.2, scale = 0.5, nofx = nil }
    },
    siving_feather_real_collector = {
        base_prefab = "siving_feather_real", skin_id = "646f760769b4f368be4526b4", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/siving_feather_real_collector.zip"),
            Asset("ANIM", "anim/kitcoon_basic.zip"),  --官方猫咪动画模板
            Asset("ANIM", "anim/kitcoon_emotes.zip"),
            Asset("ANIM", "anim/kitcoon_jump.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "旅星猫" } or { name = "Traverse Star Cat" },
		fn_anim = Fn_anim_sivfeather_collector,
        fn_start = function(inst)
            inst.AnimState:SetBank("kitcoon")
            inst.AnimState:SetBuild("siving_feather_real_collector")
            inst.Transform:SetSixFaced()
            inst.AnimState:SetScale(0.9, 0.9)
        end,
        fn_end = function(inst)
            CancelSgSkinAnim(inst)
            inst.Transform:SetEightFaced()
            inst.AnimState:SetScale(1, 1)
        end,
        equip = {
            symbol = "lantern_overlay", build = "siving_feather_real_collector", file = "swap_cushion",
            isshield = true,
            startfn = function(inst, owner)
                Fn_setFollowFx(owner, "fx_l_sivfea_real", "sivfea_real_collector_fofx")
            end,
            endfn = function(inst, owner)
                Fn_removeFollowFx(owner, "fx_l_sivfea_real")
            end
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = nil, size = "med", offset_y = 0.1, scale = 0.5, nofx = nil }
    },
    siving_feather_fake_collector = {
        base_prefab = "siving_feather_fake", skin_id = "646f760769b4f368be4526b4", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/siving_feather_fake_collector.zip"),
            Asset("ANIM", "anim/kitcoon_basic.zip"),  --官方猫咪动画模板
            Asset("ANIM", "anim/kitcoon_emotes.zip"),
            Asset("ANIM", "anim/kitcoon_jump.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "流星猫" } or { name = "Meteor Cat" },
		fn_anim = Fn_anim_sivfeather_collector,
        fn_start = function(inst)
            inst.AnimState:SetBank("kitcoon")
            inst.AnimState:SetBuild("siving_feather_fake_collector")
            inst.Transform:SetSixFaced()
            inst.AnimState:SetScale(0.9, 0.9)
        end,
        fn_end = function(inst)
            CancelSgSkinAnim(inst)
            inst.Transform:SetEightFaced()
            inst.AnimState:SetScale(1, 1)
        end,
        equip = {
            symbol = "lantern_overlay", build = "siving_feather_fake_collector", file = "swap_cushion",
            isshield = true,
            startfn = function(inst, owner)
                Fn_setFollowFx(owner, "fx_l_sivfea_fake", "sivfea_fake_collector_fofx")
            end,
            endfn = function(inst, owner)
                Fn_removeFollowFx(owner, "fx_l_sivfea_fake")
            end
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = nil, size = "med", offset_y = 0.1, scale = 0.5, nofx = nil }
    },

    revolvedmoonlight_item_taste = { --芒果
        base_prefab = "revolvedmoonlight_item", skin_id = "63889eaf8c2f781db2f7f763", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/revolvedmoonlight_item_taste.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "芒果甜筒" } or { name = "Mango Cone" },
		anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        linkedskins = { item = "revolvedmoonlight_taste", item_pro = "revolvedmoonlight_pro_taste" },
        floater = { cut = 0.18, size = "small", offset_y = 0.4, scale = 0.55, nofx = nil },

        overridekeys = { "data_up", "data_uppro" },
        data_up = {
            fn_start = function(inst)
                inst.AnimState:SetBank("farm_soil")
                inst.AnimState:SetBuild("siving_soil_law")
            end
        },
        data_uppro = {
            
        }
    },
    revolvedmoonlight_taste = {
        base_prefab = "revolvedmoonlight", skin_id = "63889eaf8c2f781db2f7f763", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/revolvedmoonlight_taste.zip"),
            Asset("ANIM", "anim/skin/ui_revolvedmoonlight_taste_4x3.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "芒果冰" } or { name = "Mango Ice Cream" },
		fn_start = function(inst)
            inst.AnimState:SetScale(0.85, 0.85, 0.85)
            inst.AnimState:SetBank("revolvedmoonlight_taste")
            inst.AnimState:SetBuild("revolvedmoonlight_taste")
            inst.components.container:Close() --WidgetSetup 之前一定要先关闭，否则会崩溃
            inst.components.container:WidgetSetup("revolvedmoonlight_taste")
        end,
        fn_end = function(inst)
            inst.AnimState:SetScale(1, 1, 1)
            inst.components.container:Close()
            inst.components.container:WidgetSetup("revolvedmoonlight")
        end,
        fn_start_c = function(inst)
            SetWidget(inst, "revolvedmoonlight_taste")
        end,
        fn_end_c = function(inst)
            SetWidget(inst, "revolvedmoonlight")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        linkedskins = { item = "revolvedmoonlight_item_taste" },
        floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil }
    },
    revolvedmoonlight_pro_taste = {
        base_prefab = "revolvedmoonlight_pro", skin_id = "63889eaf8c2f781db2f7f763", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/revolvedmoonlight_pro_taste.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "黄桃芒芒" } or { name = "Mango Sundae" },
		fn_start = function(inst)
            inst.AnimState:SetScale(0.85, 0.85, 0.85)
            inst.AnimState:SetBank("revolvedmoonlight_pro_taste")
            inst.AnimState:SetBuild("revolvedmoonlight_taste")
            inst.components.container:Close()
            inst.components.container:WidgetSetup("revolvedmoonlight_pro_taste")
        end,
        fn_end = function(inst)
            inst.AnimState:SetScale(1, 1, 1)
            inst.components.container:Close()
            inst.components.container:WidgetSetup("revolvedmoonlight_pro")
        end,
        fn_start_c = function(inst)
            SetWidget(inst, "revolvedmoonlight_pro_taste")
        end,
        fn_end_c = function(inst)
            SetWidget(inst, "revolvedmoonlight_pro")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        linkedskins = { item = "revolvedmoonlight_item_taste" },
        floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil }
    },

    revolvedmoonlight_item_taste2 = { --草莓
        base_prefab = "revolvedmoonlight_item", skin_id = "63889ecd8c2f781db2f7f768", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/revolvedmoonlight_item_taste2.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "草莓甜筒" } or { name = "Strawberry Cone" },
		anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        linkedskins = { item = "revolvedmoonlight_taste2", item_pro = "revolvedmoonlight_pro_taste2" },
        floater = { cut = 0.18, size = "small", offset_y = 0.4, scale = 0.55, nofx = nil }
    },
    revolvedmoonlight_taste2 = {
        base_prefab = "revolvedmoonlight", skin_id = "63889ecd8c2f781db2f7f768", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/revolvedmoonlight_taste2.zip"),
            Asset("ANIM", "anim/skin/ui_revolvedmoonlight_taste2_4x3.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "草莓冰" } or { name = "Strawberry Ice Cream" },
		fn_start = function(inst)
            inst.AnimState:SetScale(0.85, 0.85, 0.85)
            inst.AnimState:SetBank("revolvedmoonlight_taste2")
            inst.AnimState:SetBuild("revolvedmoonlight_taste")
            inst.components.container:Close()
            inst.components.container:WidgetSetup("revolvedmoonlight_taste2")
        end,
        fn_end = function(inst)
            inst.AnimState:SetScale(1, 1, 1)
            inst.components.container:Close()
            inst.components.container:WidgetSetup("revolvedmoonlight")
        end,
        fn_start_c = function(inst)
            SetWidget(inst, "revolvedmoonlight_taste2")
        end,
        fn_end_c = function(inst)
            SetWidget(inst, "revolvedmoonlight")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        linkedskins = { item = "revolvedmoonlight_item_taste2" },
        floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil }
    },
    revolvedmoonlight_pro_taste2 = {
        base_prefab = "revolvedmoonlight_pro", skin_id = "63889ecd8c2f781db2f7f768", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/revolvedmoonlight_pro_taste2.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "巧遇莓莓" } or { name = "Strawberry Sundae" },
		fn_start = function(inst)
            inst.AnimState:SetScale(0.85, 0.85, 0.85)
            inst.AnimState:SetBank("revolvedmoonlight_pro_taste2")
            inst.AnimState:SetBuild("revolvedmoonlight_taste")
            inst.components.container:Close()
            inst.components.container:WidgetSetup("revolvedmoonlight_pro_taste2")
        end,
        fn_end = function(inst)
            inst.AnimState:SetScale(1, 1, 1)
            inst.components.container:Close()
            inst.components.container:WidgetSetup("revolvedmoonlight_pro")
        end,
        fn_start_c = function(inst)
            SetWidget(inst, "revolvedmoonlight_pro_taste2")
        end,
        fn_end_c = function(inst)
            SetWidget(inst, "revolvedmoonlight_pro")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        linkedskins = { item = "revolvedmoonlight_item_taste2" },
        floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil }
    },

    revolvedmoonlight_item_taste3 = { --柠檬
        base_prefab = "revolvedmoonlight_item", skin_id = "63889eef8c2f781db2f7f76c", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/revolvedmoonlight_item_taste3.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "柠檬甜筒" } or { name = "Lemon Cone" },
		anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        linkedskins = { item = "revolvedmoonlight_taste3", item_pro = "revolvedmoonlight_pro_taste3" },
        floater = { cut = 0.18, size = "small", offset_y = 0.4, scale = 0.55, nofx = nil }
    },
    revolvedmoonlight_taste3 = {
        base_prefab = "revolvedmoonlight", skin_id = "63889eef8c2f781db2f7f76c", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/revolvedmoonlight_taste3.zip"),
            Asset("ANIM", "anim/skin/ui_revolvedmoonlight_taste3_4x3.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "柠檬冰" } or { name = "Lemon Ice Cream" },
		fn_start = function(inst)
            inst.AnimState:SetScale(0.85, 0.85, 0.85)
            inst.AnimState:SetBank("revolvedmoonlight_taste3")
            inst.AnimState:SetBuild("revolvedmoonlight_taste")
            inst.components.container:Close()
            inst.components.container:WidgetSetup("revolvedmoonlight_taste3")
        end,
        fn_end = function(inst)
            inst.AnimState:SetScale(1, 1, 1)
            inst.components.container:Close()
            inst.components.container:WidgetSetup("revolvedmoonlight")
        end,
        fn_start_c = function(inst)
            SetWidget(inst, "revolvedmoonlight_taste3")
        end,
        fn_end_c = function(inst)
            SetWidget(inst, "revolvedmoonlight")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        linkedskins = { item = "revolvedmoonlight_item_taste3" },
        floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil }
    },
    revolvedmoonlight_pro_taste3 = {
        base_prefab = "revolvedmoonlight_pro", skin_id = "63889eef8c2f781db2f7f76c", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/revolvedmoonlight_pro_taste3.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "奇异柠檬" } or { name = "Lemon Sundae" },
		fn_start = function(inst)
            inst.AnimState:SetScale(0.85, 0.85, 0.85)
            inst.AnimState:SetBank("revolvedmoonlight_pro_taste3")
            inst.AnimState:SetBuild("revolvedmoonlight_taste")
            inst.components.container:Close()
            inst.components.container:WidgetSetup("revolvedmoonlight_pro_taste3")
        end,
        fn_end = function(inst)
            inst.AnimState:SetScale(1, 1, 1)
            inst.components.container:Close()
            inst.components.container:WidgetSetup("revolvedmoonlight_pro")
        end,
        fn_start_c = function(inst)
            SetWidget(inst, "revolvedmoonlight_pro_taste3")
        end,
        fn_end_c = function(inst)
            SetWidget(inst, "revolvedmoonlight_pro")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        linkedskins = { item = "revolvedmoonlight_item_taste3" },
        floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil }
    },

    revolvedmoonlight_item_taste4 = { --黑巧
        base_prefab = "revolvedmoonlight_item", skin_id = "63889f4b8c2f781db2f7f770", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/revolvedmoonlight_item_taste4.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "黑巧甜筒" } or { name = "Choccy Cone" },
		anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        linkedskins = { item = "revolvedmoonlight_taste4", item_pro = "revolvedmoonlight_pro_taste4" },
        floater = { cut = 0.18, size = "small", offset_y = 0.4, scale = 0.55, nofx = nil }
    },
    revolvedmoonlight_taste4 = {
        base_prefab = "revolvedmoonlight", skin_id = "63889f4b8c2f781db2f7f770", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/revolvedmoonlight_taste4.zip"),
            Asset("ANIM", "anim/skin/ui_revolvedmoonlight_taste4_4x3.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "黑巧冰" } or { name = "Choccy Ice Cream" },
		fn_start = function(inst)
            inst.AnimState:SetScale(0.85, 0.85, 0.85)
            inst.AnimState:SetBank("revolvedmoonlight_taste4")
            inst.AnimState:SetBuild("revolvedmoonlight_taste")
            inst.components.container:Close()
            inst.components.container:WidgetSetup("revolvedmoonlight_taste4")
        end,
        fn_end = function(inst)
            inst.AnimState:SetScale(1, 1, 1)
            inst.components.container:Close()
            inst.components.container:WidgetSetup("revolvedmoonlight")
        end,
        fn_start_c = function(inst)
            SetWidget(inst, "revolvedmoonlight_taste4")
        end,
        fn_end_c = function(inst)
            SetWidget(inst, "revolvedmoonlight")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        linkedskins = { item = "revolvedmoonlight_item_taste4" },
        floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil }
    },
    revolvedmoonlight_pro_taste4 = {
        base_prefab = "revolvedmoonlight_pro", skin_id = "63889f4b8c2f781db2f7f770", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/revolvedmoonlight_pro_taste4.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "黑巧旋涡" } or { name = "Choccy Sundae" },
		fn_start = function(inst)
            inst.AnimState:SetScale(0.85, 0.85, 0.85)
            inst.AnimState:SetBank("revolvedmoonlight_pro_taste4")
            inst.AnimState:SetBuild("revolvedmoonlight_taste")
            inst.components.container:Close()
            inst.components.container:WidgetSetup("revolvedmoonlight_pro_taste4")
        end,
        fn_end = function(inst)
            inst.AnimState:SetScale(1, 1, 1)
            inst.components.container:Close()
            inst.components.container:WidgetSetup("revolvedmoonlight_pro")
        end,
        fn_start_c = function(inst)
            SetWidget(inst, "revolvedmoonlight_pro_taste4")
        end,
        fn_end_c = function(inst)
            SetWidget(inst, "revolvedmoonlight_pro")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        linkedskins = { item = "revolvedmoonlight_item_taste4" },
        floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil }
    },

    plant_cactus_meat_l_world = {
        base_prefab = "plant_cactus_meat_l", skin_id = "6473057469b4f368be45295a", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/plant_cactus_meat_l_world.zip")
		},
        string = ischinese and { name = "波蒂球" } or { name = "Dots Cactus" },
		fn_start = function(inst)
            inst.AnimState:SetBank("plant_cactus_meat_l_world")
            inst.AnimState:SetBuild("plant_cactus_meat_l_world")
            OnSummer_cactus(inst, "plant_cactus_meat_l_world")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        fn_placer = function(inst)
            inst.AnimState:SetBank("plant_cactus_meat_l_world")
            inst.AnimState:SetBuild("plant_cactus_meat_l_world")
        end
    },

    siving_ctlwater_item_era = {
        base_prefab = "siving_ctlwater_item", skin_id = "64759cc569b4f368be452b14", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/siving_ctlwater_era.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "翻海图腾柱" } or { name = "Surging Sea Totem Pole" },
		anim = {
            bank = "siving_ctlwater_era", build = "siving_ctlwater_era",
            anim = "item", animpush = nil, isloop = nil, setable = true
        },
        linkedskins = { link = "siving_ctlwater_era" },
        fn_placer = function(inst)
            if inst.placerbase_l ~= nil then
                inst.placerbase_l.AnimState:SetBank("siving_ctlwater_era")
                inst.placerbase_l.AnimState:SetBuild("siving_ctlwater_era")
            end
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 }
    },
    siving_ctlwater_era = {
        base_prefab = "siving_ctlwater", skin_id = "64759cc569b4f368be452b14", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/siving_ctlwater_era.zip")
		},
        string = ischinese and { name = "翻海图腾柱" } or { name = "Surging Sea Totem Pole" },
        fn_start = function(inst)
            inst.AnimState:SetBank("siving_ctlwater_era")
            inst.AnimState:SetBuild("siving_ctlwater_era")
            inst.barsets_l = {
                siv_bar = {
                    x = 0, y = 0, z = 0, scale = nil, followedsymbol = "tag1",
                    bank = "siving_ctlwater_era", build = "siving_ctlwater_era", anim = "bar"
                }
            }
            inst:UpdateBars_l()
        end,
        linkedskins = { link = "siving_ctlwater_item_era" },
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 }
    },
    siving_ctldirt_item_era = {
        base_prefab = "siving_ctldirt_item", skin_id = "64759cc569b4f368be452b14", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/siving_ctldirt_era.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "寻森图腾柱" } or { name = "Seeking Silva Totem Pole" },
		anim = {
            bank = "siving_ctldirt_era", build = "siving_ctldirt_era",
            anim = "item", animpush = nil, isloop = nil, setable = true
        },
        linkedskins = { link = "siving_ctldirt_era" },
        fn_placer = function(inst)
            if inst.placerbase_l ~= nil then
                inst.placerbase_l.AnimState:SetBank("siving_ctldirt_era")
                inst.placerbase_l.AnimState:SetBuild("siving_ctldirt_era")
            end
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 }
    },
    siving_ctldirt_era = {
        base_prefab = "siving_ctldirt", skin_id = "64759cc569b4f368be452b14", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/siving_ctldirt_era.zip")
		},
        string = ischinese and { name = "寻森图腾柱" } or { name = "Seeking Silva Totem Pole" },
        fn_start = function(inst)
            inst.AnimState:SetBank("siving_ctldirt_era")
            inst.AnimState:SetBuild("siving_ctldirt_era")
            inst.barsets_l = {
                siv_bar1 = {
                    x = 0, y = 0, z = 0, scale = nil, followedsymbol = "tag1",
                    bank = "siving_ctldirt_era", build = "siving_ctldirt_era", anim = "bar1"
                },
                siv_bar2 = {
                    x = 0, y = 0, z = 0, scale = nil, followedsymbol = "tag2",
                    bank = "siving_ctldirt_era", build = "siving_ctldirt_era", anim = "bar2"
                },
                siv_bar3 = {
                    x = 0, y = 0, z = 0, scale = nil, followedsymbol = "tag3",
                    bank = "siving_ctldirt_era", build = "siving_ctldirt_era", anim = "bar3"
                }
            }
            inst:UpdateBars_l()
        end,
        linkedskins = { link = "siving_ctldirt_item_era" },
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 }
    },
    siving_ctlall_item_era = {
        base_prefab = "siving_ctlall_item", skin_id = "64759cc569b4f368be452b14", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/siving_ctlall_era.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "耘天图腾柱" } or { name = "Singing Sky Totem Pole" },
		anim = {
            bank = "siving_ctlall_era", build = "siving_ctlall_era",
            anim = "item", animpush = nil, isloop = nil, setable = true
        },
        linkedskins = { link = "siving_ctlall_era" },
        fn_placer = function(inst)
            if inst.placerbase_l ~= nil then
                inst.placerbase_l.AnimState:SetBank("siving_ctlall_era")
                inst.placerbase_l.AnimState:SetBuild("siving_ctlall_era")
            end
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 }
    },
    siving_ctlall_era = {
        base_prefab = "siving_ctlall", skin_id = "64759cc569b4f368be452b14", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/siving_ctlall_era.zip")
		},
        string = ischinese and { name = "耘天图腾柱" } or { name = "Sowing Sky Totem Pole" },
        fn_start = function(inst)
            inst.AnimState:SetBank("siving_ctlall_era")
            inst.AnimState:SetBuild("siving_ctlall_era")
            inst.barsets_l = {
                siv_bar1 = {
                    x = 0, y = 0, z = 0, scale = nil, followedsymbol = "tag1",
                    bank = "siving_ctlall_era", build = "siving_ctlall_era", anim = "bar1"
                },
                siv_bar2 = {
                    x = 0, y = 0, z = 0, scale = nil, followedsymbol = "tag2",
                    bank = "siving_ctlall_era", build = "siving_ctlall_era", anim = "bar2"
                },
                siv_bar3 = {
                    x = 0, y = 0, z = 0, scale = nil, followedsymbol = "tag3",
                    bank = "siving_ctlall_era", build = "siving_ctlall_era", anim = "bar3"
                },
                siv_bar4 = {
                    x = 0, y = 0, z = 0, scale = nil, followedsymbol = "tag4",
                    bank = "siving_ctlall_era", build = "siving_ctlall_era", anim = "bar4"
                }
            }
            inst:UpdateBars_l()
        end,
        linkedskins = { link = "siving_ctlall_item_era" },
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 }
    },

    siving_mask_era = {
        base_prefab = "siving_mask", skin_id = "647b394969b4f368be453202", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/siving_mask_era.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "巫仆血骨面" } or { name = "Blood Servant Bone Mask" },
		anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        fn_start = function(inst)
            inst.maskfxoverride_l = "siving_lifesteal_fx_era1"
        end,
        equip = { symbol = nil, build = "siving_mask_era", file = "swap_hat", isopenhat = true },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil }
    },
    siving_mask_era2 = {
        base_prefab = "siving_mask", skin_id = "647b394969b4f368be453202", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/siving_mask_era2.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "巫仆毒骨面" } or { name = "Toxin Servant Bone Mask" },
		anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        fn_start = function(inst)
            inst.maskfxoverride_l = "siving_lifesteal_fx_era2"
        end,
        equip = { symbol = nil, build = "siving_mask_era2", file = "swap_hat", isopenhat = true },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil }
    },
    siving_mask_gold_era = {
        base_prefab = "siving_mask_gold", skin_id = "647b394969b4f368be453202", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/siving_mask_gold_era.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "巫酋血骨面" } or { name = "Blood Chief Bone Mask" },
		anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        fn_start = function(inst)
            inst.maskfxoverride_l = "siving_lifesteal_fx_era3"
        end,
        equip = {
            build = "siving_mask_gold_era", --幻化识别
            startfn = function(inst, owner)
                TOOLS_L.hat_on_opentop(inst, owner, nil, nil)
                Fn_setFollowFx(owner, "fx_l_sivmask", "sivmask_era_fofx")
            end,
            endfn = function(inst, owner)
                Fn_removeFollowFx(owner, "fx_l_sivmask")
            end
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil }
    },
    siving_mask_gold_era2 = {
        base_prefab = "siving_mask_gold", skin_id = "647b394969b4f368be453202", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/siving_mask_gold_era2.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "巫酋毒骨面" } or { name = "Toxin Chief Bone Mask" },
		anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        fn_start = function(inst)
            inst.maskfxoverride_l = "siving_lifesteal_fx_era4"
        end,
        equip = {
            build = "siving_mask_gold_era2", --幻化识别
            startfn = function(inst, owner)
                TOOLS_L.hat_on_opentop(inst, owner, nil, nil)
                Fn_setFollowFx(owner, "fx_l_sivmask", "sivmask_era2_fofx")
            end,
            endfn = function(inst, owner)
                Fn_removeFollowFx(owner, "fx_l_sivmask")
            end
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil }
    },
    siving_mask_gold_marble = {
        base_prefab = "siving_mask_gold", skin_id = "6558bf96adf8ac0fd863e870", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/siving_mask_gold_marble.zip"),
            Asset("ANIM", "anim/skin/siving_armor_gold_marble.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "圣洁面纱" } or { name = "Holy Veil" },
		anim = {
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil, setable = true
        },
        fn_start = function(inst)
            inst.maskfxoverride_l = "siving_lifesteal_fx_marble"
        end,
        equip = {
            symbol = nil, build = "siving_mask_gold_marble", file = "swap_hat", isopenhat = nil,
            startfn = function(inst, owner)
                TOOLS_L.hat_on(inst, owner, "siving_mask_gold_marble", "swap_hat")
                owner:ListenForEvent("unequip", OnUnequip_sivmask_gold_marble)
                if owner.components.inventory ~= nil then
                    local equippedArmor = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) or nil
                    if equippedArmor == nil then
                        owner.AnimState:OverrideSymbol("swap_body", "siving_armor_gold_marble", "swap_body")
                    end
                end
            end,
            endfn = function(inst, owner)
                owner:RemoveEventCallback("unequip", OnUnequip_sivmask_gold_marble)
                if owner.components.inventory ~= nil then
                    local equippedArmor = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) or nil
                    if equippedArmor == nil then
                        owner.AnimState:ClearOverrideSymbol("swap_body")
                    end
                end
            end
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil }
    },

    -- siving_armor_gold_marble = {
    --     base_prefab = "siving_armor_gold", skin_id = "6558bf96adf8ac0fd863e870", noshopshow = true,
	-- 	type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
	-- 	assets = {
    --         Asset("ANIM", "anim/skin/siving_armor_gold_marble.zip")
	-- 	},
	-- 	image = { name = nil, atlas = nil, setable = true },
    --     string = ischinese and { name = "圣洁长袍" } or { name = "Holy Robe" },
	-- 	anim = {
    --         bank = nil, build = nil,
    --         anim = nil, animpush = nil, isloop = nil, setable = true
    --     },
    --     equip = { symbol = "swap_body", build = "siving_armor_gold_marble", file = "swap_body" },
    --     exchangefx = { prefab = nil, offset_y = nil, scale = nil }
    -- },

    siving_soil_item_law = {
        base_prefab = "siving_soil_item", skin_id = "65560bbdadf8ac0fd863e6d6", onlyownedshow = true,
        type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
        assets = {
            Asset("ANIM", "anim/skin/siving_soil_law.zip")
        },
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "落英" } or { name = "Bloomed Flowers" },
        anim = {
            bank = "siving_soil_law", build = "siving_soil_law",
            anim = "item", animpush = nil, isloop = nil, setable = true
        },
        build_name_override = "siving_soil_law",
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        fn_placer = function(inst)
            inst.AnimState:SetBank("farm_soil")
            inst.AnimState:SetBuild("siving_soil_law")
        end,

        overridekeys = { "data_soil", "data_plant" },
        data_soil = {
            fn_start = function(inst)
                inst.AnimState:SetBank("farm_soil")
                inst.AnimState:SetBuild("siving_soil_law")
            end
        },
        data_plant = {
            fn_start = function(inst)
                inst.soilskin_l = "siving_soil_law"
                if inst.fn_soiltype ~= nil then
                    inst.fn_soiltype(inst, nil)
                end
            end
        }
    },
    siving_soil_item_law2 = {
        base_prefab = "siving_soil_item", skin_id = "65560bbdadf8ac0fd863e6d6", noshopshow = true,
        type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
        assets = {
            Asset("ANIM", "anim/skin/siving_soil_law2.zip")
        },
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "春泥" } or { name = "Spring Mud" },
        anim = {
            bank = "siving_soil_law2", build = "siving_soil_law2",
            anim = "item", animpush = nil, isloop = nil, setable = true
        },
        build_name_override = "siving_soil_law2",
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        fn_placer = function(inst)
            inst.AnimState:SetBank("farm_soil")
            inst.AnimState:SetBuild("siving_soil_law2")
        end,

        overridekeys = { "data_soil", "data_plant" },
        data_soil = {
            fn_start = function(inst)
                inst.AnimState:SetBank("farm_soil")
                inst.AnimState:SetBuild("siving_soil_law2")
            end
        },
        data_plant = {
            fn_start = function(inst)
                inst.soilskin_l = "siving_soil_law2"
                if inst.fn_soiltype ~= nil then
                    inst.fn_soiltype(inst, nil)
                end
            end
        }
    },
    siving_soil_item_law3 = {
        base_prefab = "siving_soil_item", skin_id = "65560bdbadf8ac0fd863e6da", onlyownedshow = true,
        type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
        assets = {
            Asset("ANIM", "anim/skin/siving_soil_law3.zip")
        },
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "归根" } or { name = "For Roots" },
        anim = {
            bank = "siving_soil_law3", build = "siving_soil_law3",
            anim = "item", animpush = nil, isloop = nil, setable = true
        },
        build_name_override = "siving_soil_law3",
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        fn_placer = function(inst)
            inst.AnimState:SetBank("farm_soil")
            inst.AnimState:SetBuild("siving_soil_law3")
        end,

        overridekeys = { "data_soil", "data_plant" },
        data_soil = {
            fn_start = function(inst)
                inst.AnimState:SetBank("farm_soil")
                inst.AnimState:SetBuild("siving_soil_law3")
            end
        },
        data_plant = {
            fn_start = function(inst)
                inst.soilskin_l = "siving_soil_law3"
                if inst.fn_soiltype ~= nil then
                    inst.fn_soiltype(inst, nil)
                end
            end
        }
    },

    refractedmoonlight_taste = {
        base_prefab = "refractedmoonlight", skin_id = "6558639aadf8ac0fd863e7f6", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/refractedmoonlight_taste.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/refractedmoonlight_taste.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/refractedmoonlight_taste.tex"),
            Asset("ATLAS", "images/inventoryimages_skin/refractedmoonlight_taste2.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/refractedmoonlight_taste2.tex")
		},
        string = ischinese and { name = "烤肠大王" } or { name = "Roast Sausage King" },
        fn_start = function(inst)
            inst._dd = {
                img_tex = "refractedmoonlight_taste", img_atlas = "images/inventoryimages_skin/refractedmoonlight_taste.xml",
                img_tex2 = "refractedmoonlight_taste2", img_atlas2 = "images/inventoryimages_skin/refractedmoonlight_taste2.xml",
                build = "refractedmoonlight_taste", fx = "refracted_l_spark_taste_fx"
            }
            Fn_start_refracted(inst)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },

    hiddenmoonlight_item_paper = {
        base_prefab = "hiddenmoonlight_item", skin_id = "655a18f6adf8ac0fd863e900", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/hiddenmoonlight_paper.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "星愿满瓶" } or { name = "Star Wishes Bottle" },
		anim = {
            bank = "hiddenmoonlight_paper", build = "hiddenmoonlight_paper",
            anim = "idle_item", animpush = nil, isloop = nil, setable = true
        },
        build_name_override = "hiddenmoonlight_paper",
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.7, nofx = nil },

        overridekeys = { "data_up" },
        data_up = {
            build_name_override = "hiddenmoonlight_paper",
            exchangefx = { prefab = nil, offset_y = nil, scale = nil },
            fn_start = function(inst)
                inst.AnimState:SetScale(1.5, 1.5, 1.5)
                inst.AnimState:SetBank("hiddenmoonlight_paper")
                inst.AnimState:SetBuild("hiddenmoonlight_paper")
                SetTarget_hidden(inst, "hiddenmoonlight_paper")
            end,
            fn_end = function(inst)
                inst.AnimState:SetScale(1, 1, 1)
                SetTarget_hidden(inst, nil)
            end
        }
    },

    chest_whitewood_craft = {
        base_prefab = "chest_whitewood", skin_id = "655e0530adf8ac0fd863ea52", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/chest_whitewood_craft.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/chest_whitewood_craft.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/chest_whitewood_craft.tex")
		},
        string = ischinese and { name = "花梨木饰顶展台" } or { name = "Decorated Rosewood Cabinet" },
		fn_start = function(inst)
            inst.AnimState:SetBank("chest_whitewood_craft")
            inst.AnimState:SetBuild("chest_whitewood_craft")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        fn_placer = function(inst)
            inst.AnimState:SetBank("chest_whitewood_craft")
            inst.AnimState:SetBuild("chest_whitewood_craft")
        end
    },
    chest_whitewood_craft2 = {
        base_prefab = "chest_whitewood", skin_id = "655e0530adf8ac0fd863ea52", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			-- Asset("ANIM", "anim/skin/chest_whitewood_craft.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/chest_whitewood_craft2.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/chest_whitewood_craft2.tex")
		},
        string = ischinese and { name = "花梨木展台" } or { name = "Rosewood Cabinet" },
		fn_start = function(inst)
            inst.AnimState:SetBank("chest_whitewood_craft")
            inst.AnimState:SetBuild("chest_whitewood_craft")
            inst.AnimState:HideSymbol("deco")
        end,
        fn_end = function(inst)
            inst.AnimState:ShowSymbol("deco")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        fn_placer = function(inst)
            inst.AnimState:SetBank("chest_whitewood_craft")
            inst.AnimState:SetBuild("chest_whitewood_craft")
            inst.AnimState:HideSymbol("deco")
        end
    },
    chest_whitewood_big_craft = {
        base_prefab = "chest_whitewood_big", skin_id = "655e0530adf8ac0fd863ea52", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/chest_whitewood_big_craft.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/chest_whitewood_big_craft.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/chest_whitewood_big_craft.tex")
		},
        string = ischinese and { name = "花梨木饰顶展柜" } or { name = "Decorated Rosewood Showcase" },
		fn_start = function(inst)
            inst.AnimState:SetBank("chest_whitewood_big_craft")
            inst.AnimState:SetBuild("chest_whitewood_big_craft")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        fn_placer = function(inst)
            inst.AnimState:SetBank("chest_whitewood_big_craft")
            inst.AnimState:SetBuild("chest_whitewood_big_craft")
        end
    },
    chest_whitewood_big_craft2 = {
        base_prefab = "chest_whitewood_big", skin_id = "655e0530adf8ac0fd863ea52", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			-- Asset("ANIM", "anim/skin/chest_whitewood_big_craft.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/chest_whitewood_big_craft2.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/chest_whitewood_big_craft2.tex")
		},
        string = ischinese and { name = "花梨木展柜" } or { name = "Rosewood Showcase" },
		fn_start = function(inst)
            inst.AnimState:SetBank("chest_whitewood_big_craft")
            inst.AnimState:SetBuild("chest_whitewood_big_craft")
            inst.AnimState:HideSymbol("deco")
        end,
        fn_end = function(inst)
            inst.AnimState:ShowSymbol("deco")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        fn_placer = function(inst)
            inst.AnimState:SetBank("chest_whitewood_big_craft")
            inst.AnimState:SetBuild("chest_whitewood_big_craft")
            inst.AnimState:HideSymbol("deco")
        end
    },
}

_G.SKIN_IDS_LEGION = {
    ["ooooonononon"] = {}, --免费皮肤全部装这里面，skin_id设置为"ooooonononon"就好了
    ["6278c409c340bf24ab311522"] = { --余生
        siving_derivant_thanks = true, siving_derivant_thanks2 = true, backcub_thanks = true,
        neverfade_thanks = true, neverfadebush_thanks = true,
        fishhomingtool_awesome_thanks = true, fishhomingtool_normal_thanks = true, fishhomingbait_thanks = true,
        triplegoldenshovelaxe_era = true, tripleshovelaxe_era = true, lilybush_era = true, lileaves_era = true,
        icire_rock_era = true, shield_l_log_era = true, shield_l_sand_era = true,
        siving_ctlwater_item_era = true, siving_ctlwater_era = true, siving_ctldirt_item_era = true,
        siving_ctldirt_era = true, siving_ctlall_item_era = true, siving_ctlall_era = true,
        siving_mask_era = true, siving_mask_era2 = true, siving_mask_gold_era = true, siving_mask_gold_era2 = true,
        orchidbush_disguiser = true, boltwingout_disguiser = true, plant_cactus_meat_l_world = true,
        rosebush_marble = true, lilybush_marble = true, orchidbush_marble = true,
        rosorns_marble = true, lileaves_marble = true, orchitwigs_marble = true,
        siving_mask_gold_marble = true,
        shield_l_log_emo_fist = true, hat_lichen_emo_que = true,
        rosebush_collector = true, rosorns_collector = true, fimbul_axe_collector = true, siving_turn_collector = true,
        siving_feather_real_collector = true, siving_feather_fake_collector = true,
        backcub_fans2 = true,
        fishhomingtool_awesome_taste = true, fishhomingtool_normal_taste = true, fishhomingbait_taste = true,
        agronssword_taste = true, soul_contracts_taste = true, refractedmoonlight_taste = true,
        revolvedmoonlight_item_taste = true, revolvedmoonlight_taste = true, revolvedmoonlight_pro_taste = true,
        revolvedmoonlight_item_taste2 = true, revolvedmoonlight_taste2 = true, revolvedmoonlight_pro_taste2 = true,
        revolvedmoonlight_item_taste3 = true, revolvedmoonlight_taste3 = true, revolvedmoonlight_pro_taste3 = true,
        revolvedmoonlight_item_taste4 = true, revolvedmoonlight_taste4 = true, revolvedmoonlight_pro_taste4 = true,
        carpet_whitewood_law = true, carpet_whitewood_big_law = true,
        carpet_whitewood_law2 = true, carpet_whitewood_big_law2 = true,
        siving_soil_item_law = true, siving_soil_item_law2 = true, siving_soil_item_law3 = true,
        icire_rock_day = true,
        neverfade_paper = true, neverfadebush_paper = true, neverfade_paper2 = true, neverfadebush_paper2 = true,
        siving_feather_real_paper = true, siving_feather_fake_paper = true, hiddenmoonlight_item_paper = true,
        siving_turn_future = true, siving_turn_future2 = true,
        chest_whitewood_craft = true, chest_whitewood_big_craft = true,
        chest_whitewood_craft2 = true, chest_whitewood_big_craft2 = true
    },
    ["6278c450c340bf24ab311528"] = { --回忆(5)
        boltwingout_disguiser = true,
        rosebush_marble = true, lilybush_marble = true, orchidbush_marble = true,
        hat_lichen_emo_que = true,
    },
    ["62eb7b148c2f781db2f79cf8"] = { --花潮(6+3)
        rosebush_marble = true, lilybush_marble = true, orchidbush_marble = true,
        rosorns_marble = true, lileaves_marble = true, orchitwigs_marble = true,
        rosebush_collector = true, rosorns_collector = true,
        lilybush_era = true, lileaves_era = true,
        orchidbush_disguiser = true,
        shield_l_log_era = true, --这一个是多给的(当做花泥)
    },
    ["6278c487c340bf24ab31152c"] = { --1鸣惊人
        neverfade_thanks = true, neverfadebush_thanks = true,
        orchidbush_disguiser = true, boltwingout_disguiser = true,
        rosebush_marble = true, lilybush_marble = true, orchidbush_marble = true,
        hat_lichen_emo_que = true,
    },
    ["6278c4acc340bf24ab311530"] = { --2度梅开
        fishhomingtool_awesome_thanks = true, fishhomingtool_normal_thanks = true, fishhomingbait_thanks = true,
        triplegoldenshovelaxe_era = true, tripleshovelaxe_era = true, lilybush_era = true, lileaves_era = true,
        icire_rock_era = true, shield_l_log_era = true, shield_l_sand_era = true,
        shield_l_log_emo_fist = true,
        carpet_whitewood_law = true, carpet_whitewood_big_law = true
    },
    ["6278c4eec340bf24ab311534"] = { --3尺垂涎
        rosebush_collector = true, rosorns_collector = true, fimbul_axe_collector = true,
        rosorns_marble = true, lileaves_marble = true, orchitwigs_marble = true,
        backcub_thanks = true, siving_derivant_thanks = true, siving_derivant_thanks2 = true,
        revolvedmoonlight_item_taste = true, revolvedmoonlight_taste = true, revolvedmoonlight_pro_taste = true,
        revolvedmoonlight_item_taste2 = true, revolvedmoonlight_taste2 = true, revolvedmoonlight_pro_taste2 = true
    },
    ["637f07a28c2f781db2f7f1e8"] = { --4海名扬
        agronssword_taste = true, soul_contracts_taste = true,
        revolvedmoonlight_item_taste3 = true, revolvedmoonlight_taste3 = true, revolvedmoonlight_pro_taste3 = true,
        revolvedmoonlight_item_taste4 = true, revolvedmoonlight_taste4 = true, revolvedmoonlight_pro_taste4 = true,
        carpet_whitewood_law2 = true, carpet_whitewood_big_law2 = true,
        icire_rock_day = true,
        neverfade_paper = true, neverfadebush_paper = true, neverfade_paper2 = true, neverfadebush_paper2 = true,
        siving_feather_real_paper = true, siving_feather_fake_paper = true,
    },
    ["642c14d9f2b67d287a35d439"] = { --5谷丰登
        siving_feather_real_collector = true, siving_feather_fake_collector = true,
        plant_cactus_meat_l_world = true,
        siving_ctlwater_item_era = true, siving_ctlwater_era = true,
        siving_ctldirt_item_era = true, siving_ctldirt_era = true,
        siving_ctlall_item_era = true, siving_ctlall_era = true,
        siving_mask_era = true, siving_mask_era2 = true, siving_mask_gold_era = true, siving_mask_gold_era2 = true,
        siving_turn_future = true, siving_turn_future2 = true
    },
    ["61f15bf4db102b0b8a529c66"] = { --6连忘返
        siving_soil_item_law = true, siving_soil_item_law2 = true, siving_soil_item_law3 = true,
        refractedmoonlight_taste = true,
        siving_mask_gold_marble = true,
        hiddenmoonlight_item_paper = true,
        chest_whitewood_craft = true, chest_whitewood_big_craft = true,
        chest_whitewood_craft2 = true, chest_whitewood_big_craft2 = true
    },
    -- ["61627d927bbb727be174c4a0"] = { --棋举不定
    -- }
}
_G.SKIN_IDX_LEGION = {
    -- [1] = "rosorns_spell",
}

------

local function InitData_anim(anim, bank, build)
    if anim.bank == nil then
        anim.bank = bank
    end
    if anim.build == nil then
        anim.build = build
    end
    if anim.anim == nil then
        anim.anim = "idle"
    end
    -- if anim.isloop ~= true then
    --     anim.isloop = false
    -- end
end

------

local skinidxes = { --用以皮肤排序
    "chest_whitewood_craft", "chest_whitewood_big_craft", "chest_whitewood_craft2", "chest_whitewood_big_craft2",
    "siving_ctlwater_item_era", "siving_ctlwater_era", "siving_ctldirt_item_era", "siving_ctldirt_era",
    "siving_ctlall_item_era", "siving_ctlall_era",
    "neverfade_thanks", "neverfadebush_thanks", "siving_derivant_thanks", "siving_derivant_thanks2",
    "backcub_thanks",
    "fishhomingtool_awesome_thanks", "fishhomingtool_normal_thanks", "fishhomingbait_thanks",
    "siving_feather_real_collector", "siving_feather_fake_collector",
    "siving_turn_collector", "icire_rock_collector", "fimbul_axe_collector", "rosebush_collector", "rosorns_collector",
    "neverfade_paper", "neverfadebush_paper", "neverfade_paper2", "neverfadebush_paper2",
    "siving_turn_future", "siving_turn_future2",
    "hiddenmoonlight_item_paper", "siving_feather_real_paper", "siving_feather_fake_paper",
    "icire_rock_day",
    "siving_soil_item_law", "siving_soil_item_law2", "siving_soil_item_law3",
    "carpet_whitewood_law", "carpet_whitewood_big_law", "carpet_whitewood_law2", "carpet_whitewood_big_law2",
    "refractedmoonlight_taste", "agronssword_taste", "soul_contracts_taste",
    "revolvedmoonlight_item_taste", "revolvedmoonlight_taste", "revolvedmoonlight_pro_taste",
    "revolvedmoonlight_item_taste2", "revolvedmoonlight_taste2", "revolvedmoonlight_pro_taste2",
    "revolvedmoonlight_item_taste3", "revolvedmoonlight_taste3", "revolvedmoonlight_pro_taste3",
    "revolvedmoonlight_item_taste4", "revolvedmoonlight_taste4", "revolvedmoonlight_pro_taste4",
    "siving_mask_era", "siving_mask_era2", "siving_mask_gold_era", "siving_mask_gold_era2",
    "triplegoldenshovelaxe_era", "tripleshovelaxe_era", "lilybush_era", "lileaves_era", "shield_l_log_era",
    "icire_rock_era", "shield_l_sand_era",
    "plant_cactus_meat_l_world", "orchidbush_disguiser", "boltwingout_disguiser",
    "siving_mask_gold_marble",
    "rosebush_marble", "rosorns_marble", "lilybush_marble", "lileaves_marble", "orchidbush_marble", "orchitwigs_marble",
    "shield_l_log_emo_fist", "hat_lichen_emo_que",

    "fishhomingtool_awesome_taste", "fishhomingtool_normal_taste", "fishhomingbait_taste",
    "backcub_fans2", "backcub_fans",
    "shield_l_log_emo_pride", "shield_l_sand_op", "pinkstaff_tvplay",  "hat_cowboy_tvplay", "hat_lichen_disguiser",
    "orchitwigs_disguiser"
}
for i,skinname in pairs(skinidxes) do
    _G.SKIN_IDX_LEGION[i] = skinname

    local dd = _G.SKINS_LEGION[skinname]
    dd.skin_idx = i
    if dd.overridekeys ~= nil then
        for _, v in ipairs(dd.overridekeys) do
            dd[v].skin_idx = i
            if dd[v].exchangefx == nil then --特效！
                dd[v].exchangefx = dd.exchangefx
            end
        end
    end
end

for skinname,v in pairs(_G.SKINS_LEGION) do
    if _G.SKIN_IDS_LEGION[v.skin_id] == nil then
        _G.SKIN_IDS_LEGION[v.skin_id] = {}
    end
    _G.SKIN_IDS_LEGION[v.skin_id][skinname] = true

	if v.image ~= nil then
		if v.image.name == nil then
			v.image.name = skinname
		end
		if v.image.atlas == nil then
			v.image.atlas = "images/inventoryimages_skin/"..skinname..".xml"
		end
        if v.image.setable ~= false then
            v.image.setable = true
        end

        table.insert(Assets, Asset("ATLAS", v.image.atlas))
        table.insert(Assets, Asset("IMAGE", "images/inventoryimages_skin/"..v.image.name..".tex"))
        RegisterInventoryItemAtlas(v.image.atlas, v.image.name..".tex")
	end
	if v.anim ~= nil then
		InitData_anim(v.anim, skinname, skinname)
        if v.anim.setable ~= false then
            v.anim.setable = true
        end
	end
    if v.floater ~= nil and v.floater.anim ~= nil then
		InitData_anim(v.floater.anim, v.anim.bank, v.anim.bank.build)
	end
	if v.build_name_override == nil then
		v.build_name_override = skinname
	end
    if v.assets ~= nil then
        for kk,ast in pairs(v.assets) do
            table.insert(Assets, ast)
        end
    end
    -- if v.exchangefx ~= nil then
    --     if v.exchangefx.prefab == nil then
    --         v.exchangefx.prefab = "explode_reskin"
    --     end
    -- end

    table.insert(v.skin_tags, string.upper(skinname))
    table.insert(v.skin_tags, "CRAFTABLE")

    STRINGS.SKIN_NAMES[skinname] = v.string.name

    ------修改PREFAB_SKINS(在prefabskins.lua中被定义)
    if v.base_prefab ~= nil then
        if _G.PREFAB_SKINS[v.base_prefab] == nil then
            _G.PREFAB_SKINS[v.base_prefab] = { skinname }
        else
            table.insert(_G.PREFAB_SKINS[v.base_prefab], skinname)
        end
    end
end
for baseprefab,v in pairs(_G.SKIN_PREFABS_LEGION) do
    if v.anim ~= nil then
		InitData_anim(v.anim, baseprefab, baseprefab)
        if v.anim.setable ~= false then
            v.anim.setable = true
        end
	end
    if v.floater ~= nil and v.floater.anim ~= nil then
		InitData_anim(v.floater.anim, v.anim.bank, v.anim.bank.build)
	end
    if v.image ~= nil then
		if v.image.name == nil then
			v.image.name = baseprefab
		end
		if v.image.atlas == nil then
			v.image.atlas = "images/inventoryimages/"..baseprefab..".xml"
		end
        if v.image.setable ~= false then
            v.image.setable = true
        end

        table.insert(Assets, Asset("ATLAS", v.image.atlas))
        table.insert(Assets, Asset("IMAGE", "images/inventoryimages/"..v.image.name..".tex"))
        RegisterInventoryItemAtlas(v.image.atlas, v.image.name..".tex")
	end
    if v.assets ~= nil then
        for kk,ast in pairs(v.assets) do
            table.insert(Assets, ast)
        end
    end
    -- if v.exchangefx ~= nil then
    --     if v.exchangefx.prefab == nil then
    --         v.exchangefx.prefab = "explode_reskin"
    --     end
    -- end
    if v.overridekeys ~= nil then
        for _, k in ipairs(v.overridekeys) do
            if v[k].exchangefx == nil then --特效！
                v[k].exchangefx = v.exchangefx
            end
        end
    end
    _G[baseprefab.."_clear_fn"] = function(inst) end --【服务端】给CreatePrefabSkin()用的
end
ischinese = nil

------重新生成一遍PREFAB_SKINS_IDS(在prefabskins.lua中被定义)
_G.PREFAB_SKINS_IDS = {}
for prefab,skins in pairs(_G.PREFAB_SKINS) do
	_G.PREFAB_SKINS_IDS[prefab] = {}
	for k,v in pairs(skins) do
		_G.PREFAB_SKINS_IDS[prefab][v] = k
	end
end

--------------------------------------------------------------------------
--[[ 修改皮肤的网络判定函数 ]]
--------------------------------------------------------------------------

--ValidateRecipeSkinRequest()位于networking.lua中
local ValidateRecipeSkinRequest_old = _G.ValidateRecipeSkinRequest
_G.ValidateRecipeSkinRequest = function(user_id, prefab_name, skin, ...)
    --【服务端】环境
    local validated_skin = nil

    if skin ~= nil and skin ~= "" and SKINS_LEGION[skin] ~= nil then
        if table.contains( _G.PREFAB_SKINS[prefab_name], skin ) then
            validated_skin = skin
        end
    else
        validated_skin = ValidateRecipeSkinRequest_old(user_id, prefab_name, skin, ...)
    end

    return validated_skin
end

--------------------------------------------------------------------------
--[[ 修改制作栏ui以显示mod皮肤 ]]
--------------------------------------------------------------------------

local function DoYouHaveSkin(skinname, userid)
    if SKIN_IDS_LEGION.ooooonononon[skinname] then
        return true
    elseif userid ~= nil and _G.SKINS_CACHE_L[userid] ~= nil and _G.SKINS_CACHE_L[userid][skinname] then
        return true
    end
    return false
end

--旧制作栏改动
-- AddClassPostConstruct("widgets/recipepopup", function(self)
-- end)

--新制作栏改动
AddClassPostConstruct("widgets/redux/craftingmenu_skinselector", function(self, recipe, owner, skin_name)
    ------【客户端】环境
    if self.recipe and SKIN_PREFABS_LEGION[self.recipe.product] then
        local GetSkinsList_old = self.GetSkinsList
        self.GetSkinsList = function(self, ...) --会在点击物品制作格子时触发
            if PREFAB_SKINS[self.recipe.product] then
                if not self.timestamp then self.timestamp = -10000 end
                local skins_list = {}
                for _, skinname in pairs(PREFAB_SKINS[self.recipe.product]) do
                    if DoYouHaveSkin(skinname, self.owner.userid) then
                        local data  = {
                            type = type, --不知道是啥
                            item = skinname, --这个皮肤的名字
                            timestamp = -10000
                        }
                        table.insert(skins_list, data)

                        if data.timestamp > self.timestamp then
                            self.timestamp = data.timestamp
                        end
                    end
                end
                return skins_list
            else
                return GetSkinsList_old(self, ...)
            end
        end

        --官方代码提前且只执行了一次，所以这里只能重新执行一次部分逻辑，把mod皮肤加进去
        self.skins_list = self:GetSkinsList()
        self.skins_options = self:GetSkinOptions()
        if #self.skins_options == 1 then
            self.spinner.fgimage:SetPosition(0, 0)
            self.spinner.fgimage:SetScale(1.2)
            self.spinner.text:Hide()
        else
            self.spinner.fgimage:SetPosition(0, 15)
            self.spinner.fgimage:SetScale(1)
            self.spinner.text:Show()
        end
        self.spinner:SetWrapEnabled(#self.skins_options > 1)
        self.spinner:SetOptions(self.skins_options)
        self.spinner:SetSelectedIndex(skin_name == nil and 1 or self:GetIndexForSkin(skin_name) or 1)
    end
end)

--不管客户端还是服务端，都用这个变量
_G.SKINS_NET_L = {
    -- Kxx_xxxx = { --用户ID
    --     errcount = 0,
    --     loadtag = nil, --空值-未开始、1-成功、-1-失败、0-加载中
    --     task = nil,
    --     lastquerytime = nil, --上次请求时的现实时间
    -- },
}
_G.SKINS_NET_CDK_L = {} --内容和 SKINS_NET_L 一样
_G.SKINS_CACHE_L = { --已有皮肤缓存
    -- Kxx_xxxx = { --用户ID
    --     skinname1 = true,
    --     skinname2 = true,
    -- },
}
_G.SKINS_CACHE_CG_L = { --皮肤切换缓存
    -- Kxx_xxxx = { --用户ID
    --     prefab1 = "skinname1" --上次切换的皮肤名
    -- }
}

local function SaveCGSkin(userid, skin_name, skin_data, skin_data_old)
    if userid == nil then
        return
    end

    local caches = _G.SKINS_CACHE_CG_L[userid]
    if caches == nil then
        caches = {}
        _G.SKINS_CACHE_CG_L[userid] = caches
    end

    local prefabname = skin_data and skin_data.base_prefab or nil
    if prefabname == nil then
        prefabname = skin_data_old and skin_data_old.base_prefab or nil
    end
    if prefabname ~= nil then
        caches[prefabname] = skin_name
    end
end

local GetLegionSkins = nil
local DoLegionCdk = nil
if IsServer then
    --不想麻烦地写在世界里了，换个方式
    -- AddPrefabPostInit("shard_network", function(inst) --这个prefab只存在于服务器世界里（且只能存在一个）
    --     inst:AddComponent("shard_skin_legion")
    -- end)

    local function Reward123(skins)
        if not skins["backcub_fans2"] then
            for skinname, _ in pairs(SKIN_IDS_LEGION["6278c487c340bf24ab31152c"]) do
                if not skins[skinname] then
                    return
                end
            end
            for skinname, _ in pairs(SKIN_IDS_LEGION["6278c4acc340bf24ab311530"]) do
                if not skins[skinname] then
                    return
                end
            end
            for skinname, _ in pairs(SKIN_IDS_LEGION["6278c4eec340bf24ab311534"]) do
                if not skins[skinname] then
                    return
                end
            end
            skins["backcub_fans2"] = true
        end
    end
    local function Reward456(skins)
        if not skins["fishhomingbait_taste"] then
            for skinname, _ in pairs(SKIN_IDS_LEGION["637f07a28c2f781db2f7f1e8"]) do
                if not skins[skinname] then
                    return
                end
            end
            for skinname, _ in pairs(SKIN_IDS_LEGION["642c14d9f2b67d287a35d439"]) do
                if not skins[skinname] then
                    return
                end
            end
            for skinname, _ in pairs(SKIN_IDS_LEGION["61f15bf4db102b0b8a529c66"]) do
                if not skins[skinname] then
                    return
                end
            end
            skins["fishhomingtool_awesome_taste"] = true
            skins["fishhomingtool_normal_taste"] = true
            skins["fishhomingbait_taste"] = true
        end
    end
    _G.CheckSkinOwnedReward = function(skins)
        if skins == nil then
            return
        end

        --2度梅开补偿
        if not skins["carpet_whitewood_law"] then
            if
                ( (skins["lilybush_era"] and 0.5 or 0) +
                (skins["icire_rock_era"] and 0.5 or 0) +
                (skins["shield_l_sand_era"] and 0.5 or 0) ) >= 1
            then
                skins["carpet_whitewood_law"] = true
                skins["carpet_whitewood_big_law"] = true
            end
        end

        --3尺垂涎补偿
        if not skins["revolvedmoonlight_item_taste"] or not skins["revolvedmoonlight_item_taste2"] then
            local countyy = (skins["rosebush_collector"] and 0.5 or 0) +
                            (skins["lileaves_marble"] and 0.5 or 0) +
                            (skins["orchitwigs_marble"] and 0.5 or 0) +
                            (skins["fimbul_axe_collector"] and 1.5 or 0) +
                            (skins["siving_derivant_thanks"] and 0.5 or 0) +
                            (skins["backcub_thanks"] and 2 or 0)
            if countyy >= 3 then
                skins["revolvedmoonlight_item_taste"] = true
                skins["revolvedmoonlight_taste"] = true
                skins["revolvedmoonlight_pro_taste"] = true
                skins["revolvedmoonlight_item_taste2"] = true
                skins["revolvedmoonlight_taste2"] = true
                skins["revolvedmoonlight_pro_taste2"] = true
            elseif countyy >= 1 then
                if skins["revolvedmoonlight_item_taste"] then
                    skins["revolvedmoonlight_item_taste2"] = true
                    skins["revolvedmoonlight_taste2"] = true
                    skins["revolvedmoonlight_pro_taste2"] = true
                else
                    skins["revolvedmoonlight_item_taste"] = true
                    skins["revolvedmoonlight_taste"] = true
                    skins["revolvedmoonlight_pro_taste"] = true
                end
            end
        end

        --全皮奖励
        Reward123(skins)
        Reward456(skins)
    end

    local function CloseGame()
        _G.SKINS_CACHE_L = {}
        _G.SKINS_CACHE_CG_L = {}
        c_save()
        TheWorld:DoTaskInTime(8, function()
            os.date("%h")
        end)
    end
    local function CheckFreeSkins()
        local skinsmap = {
            neverfadebush_paper = {
                id = "638362b68c2f781db2f7f524",
                linkids = {
                    ["637f07a28c2f781db2f7f1e8"] = true, --4
                    ["6278c409c340bf24ab311522"] = true
                }
            },
            carpet_whitewood_law = {
                id = "63805cf58c2f781db2f7f34b",
                linkids = {
                    ["6278c4acc340bf24ab311530"] = true, --2
                    ["6278c409c340bf24ab311522"] = true
                }
            },
            revolvedmoonlight_item_taste2 = {
                id = "63889ecd8c2f781db2f7f768",
                linkids = {
                    ["6278c4eec340bf24ab311534"] = true, --3
                    ["6278c409c340bf24ab311522"] = true
                }
            },
            rosebush_marble = {
                id = "619108a04c724c6f40e77bd4",
                linkids = {
                    ["6278c487c340bf24ab31152c"] = true, --1
                    ["62eb7b148c2f781db2f79cf8"] = true, --花
                    ["6278c450c340bf24ab311528"] = true, --忆
                    ["6278c409c340bf24ab311522"] = true
                }
            },
            icire_rock_collector = {
                id = "62df65b58c2f781db2f7998a",
                linkids = {}
            },
            siving_turn_collector = {
                id = "62eb8b9e8c2f781db2f79d21",
                linkids = {
                    ["6278c409c340bf24ab311522"] = true
                }
            },
            lilybush_era = {
                id = "629b0d5f8c2f781db2f77f0d",
                linkids = {
                    ["6278c4acc340bf24ab311530"] = true, --2
                    ["62eb7b148c2f781db2f79cf8"] = true, --花
                    ["6278c409c340bf24ab311522"] = true
                }
            },
            backcub_fans2 = {
                id = "6309c6e88c2f781db2f7ae20",
                linkids = {
                    ["6278c409c340bf24ab311522"] = true
                }
            },
            rosebush_collector = {
                id = "62e3c3a98c2f781db2f79abc",
                linkids = {
                    ["6278c4eec340bf24ab311534"] = true, --3
                    ["62eb7b148c2f781db2f79cf8"] = true, --花
                    ["6278c409c340bf24ab311522"] = true
                }
            },
            soul_contracts_taste = {
                id = "638074368c2f781db2f7f374",
                linkids = {
                    ["637f07a28c2f781db2f7f1e8"] = true, --4
                    ["6278c409c340bf24ab311522"] = true
                }
            },
            siving_turn_future2 = {
                id = "647d972169b4f368be45343a",
                linkids = {
                    ["642c14d9f2b67d287a35d439"] = true, --5
                    ["6278c409c340bf24ab311522"] = true
                }
            },
            siving_ctlall_era = {
                id = "64759cc569b4f368be452b14",
                linkids = {
                    ["642c14d9f2b67d287a35d439"] = true, --5
                    ["6278c409c340bf24ab311522"] = true
                }
            }
        }
        for name, v in pairs(skinsmap) do --不准篡改皮肤数据
            if SKINS_LEGION[name].skin_id ~= v.id then
                return true
            end
            for idd, value in pairs(SKIN_IDS_LEGION) do
                if idd ~= v.id and value[name] and not v.linkids[idd] then
                    -- print("----2"..tostring(name).."--"..tostring(idd))
                    return true
                end
            end
        end
        skinsmap = {
            rosebush = {
                rosebush_marble = true,
                rosebush_collector = true
            },
            lilybush = {
                lilybush_marble = true,
                lilybush_era = true
            },
            orchidbush = {
                orchidbush_marble = true,
                orchidbush_disguiser = true
            },
            neverfadebush = {
                neverfadebush_thanks = true,
                neverfadebush_paper = true,
                neverfadebush_paper2 = true
            },
            icire_rock = {
                icire_rock_era = true,
                icire_rock_collector = true,
                icire_rock_day = true
            },
            siving_derivant = {
                siving_derivant_thanks = true,
                siving_derivant_thanks2 = true
            },
            siving_turn = {
                siving_turn_collector = true,
                siving_turn_future = true,
                siving_turn_future2 = true
            }
        }
        for name, v in pairs(skinsmap) do --不准私自给皮肤改名
            for sname, sv in pairs(SKINS_LEGION) do
                if sv.base_prefab == name and not v[sname] then
                    -- print("----"..tostring(name).."--"..tostring(sname))
                    return true
                end
            end
        end
    end
    local function CheckCheating(user_id, newskins)
        local skins = _G.SKINS_CACHE_L[user_id]
        if newskins == nil then --如果服务器上没有皮肤，则判断缓存里有没有皮肤
            if skins ~= nil then
                for skinname, hasit in pairs(skins) do
                    if hasit then
                        CloseGame()
                        return false
                    end
                end
            end
        else --如果服务器上有皮肤，则判断缓存里的某些皮肤与服务器皮肤的差异
            if skins ~= nil then
                local skinsmap = {
                    carpet_whitewood_law = true,
                    carpet_whitewood_big_law = true,
                    revolvedmoonlight_item_taste = true,
                    revolvedmoonlight_taste = true,
                    revolvedmoonlight_pro_taste = true,
                    revolvedmoonlight_item_taste2 = true,
                    revolvedmoonlight_taste2 = true,
                    revolvedmoonlight_pro_taste2 = true,
                    backcub_fans2 = true,
                    fishhomingtool_normal_taste = true,
                    fishhomingtool_awesome_taste = true,
                    fishhomingbait_taste = true
                }
                for skinname, hasit in pairs(skins) do
                    if hasit and not skinsmap[skinname] and not newskins[skinname] then
                        CloseGame()
                        return false
                    end
                end
            end
        end
        return true
    end

    local function FnRpc_s2c(userid, handletype, data)
        if data == nil then
            data = {}
        end

        local success, result = pcall(json.encode, data)
        if success then
            SendModRPCToClient(GetClientModRPC("LegionSkined", "SkinHandle"), userid, handletype, result)
        end
    end

    local function StopQueryTask(stat)
        if stat.task ~= nil then
            stat.task:Cancel()
            stat.task = nil
        end
        stat.errcount = 0
    end

    local function QueryManage(States, player, userid, fnname, isget, times, fns)
        if TheWorld == nil then
            return
        end

        local user_id = player ~= nil and player.userid or userid
        if user_id == nil or user_id == "" then
            return
        end

        local ositemnow = os.time() or 0
        local state = States[user_id]
        if state == nil then
            state = {
                errcount = 0,
                loadtag = nil,
                task = nil,
                lastquerytime = ositemnow,
            }
            States[user_id] = state
        else
            if state.lastquerytime == nil then
                state.lastquerytime = ositemnow
            elseif times.force ~= nil then --主动刷新时，xx秒内不重复调用
                if (ositemnow-state.lastquerytime) < times.force then
                    fns.err(state, user_id, 1)
                    return
                end
            elseif (ositemnow-state.lastquerytime) < times.cut then --自动刷新时，xx秒内，不重复调用
                fns.err(state, user_id, 2)
                return
            end

            if state.task ~= nil then --还有任务在进行？
                if state.loadtag == 0 then --只要没在进行中，就结束以前的
                    return
                else
                    state.task:Cancel()
                    state.task = nil
                end
            end
            state.loadtag = nil --初始化状态
        end

        state.task = TheWorld:DoPeriodicTask(3, function()
            --请求状态判断
            if state.loadtag == 0 then --加载中，等一会
                return
            elseif state.loadtag == -1 then --失败了，开始计失败次数
                if state.errcount >= 1 then --失败两次的话，就结束
                    StopQueryTask(state)
                    fns.err(state, user_id, 3)
                    return
                else
                    state.errcount = state.errcount + 1
                end
            elseif state.loadtag == 1 then --成功啦！结束task
                StopQueryTask(state)
                return
            end

            state.loadtag = 0
            state.lastquerytime = os.time() or 0

            local urlparams = fns.urlparams(state, user_id)
            if urlparams == nil then
                StopQueryTask(state)
                fns.err(state, user_id, 4)
                return
            end

            TheSim:QueryServer(urlparams, function(result_json, isSuccessful, resultCode)
                -- print("resultCode"..tostring(resultCode))
                if isSuccessful and string.len(result_json) > 1 and resultCode == 200 then
                    local status, data = pcall( function() return json.decode(result_json) end )
                    -- print("------------skined: ", tostring(result_json))
                    if not status then
                        print("["..fnname.."] Faild to parse quest json for "
                            ..tostring(user_id).."! ", tostring(status)
                        )
                        state.loadtag = -1
                        -- fns.err(state, user_id, 5)
                    else
                        fns.handle(state, user_id, data)
                    end
                else
                    state.loadtag = -1
                    -- fns.err(state, user_id, 6, resultCode)
                end
            end, isget and "GET" or "POST", (not isget) and fns.params(state, user_id) or nil)
        end, times.delay)
    end

    GetLegionSkins = function(player, userid, delaytime, force)
        QueryManage(
            SKINS_NET_L, player, userid, "GetLegionSkins", true,
            { force = force and 5 or nil, cut = 180, delay = delaytime },
            {
                urlparams = function(state, user_id)
                    -- user_id = "KU_11111112"
                    return "https://fireleaves.cn/account/locakedSkin?mid=6041a52be3a3fb1f530b550a&id="..user_id
                end,
                handle = function(state, user_id, data)
                    -- print("ssss"..tostring(data.code))
                    state.loadtag = 1
                    StopQueryTask(state)

                    local skins = nil
                    if data ~= nil then
                        if data.lockedSkin ~= nil and type(data.lockedSkin) == "table" then
                            for kk,skinid in pairs(data.lockedSkin) do
                                local skinkeys = SKIN_IDS_LEGION[skinid]
                                if skinkeys ~= nil then
                                    if skins == nil then
                                        skins = {}
                                    end
                                    for skinname,vv in pairs(skinkeys) do
                                        if SKINS_LEGION[skinname] ~= nil then
                                            skins[skinname] = true
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if CheckCheating(user_id, skins) then
                        CheckSkinOwnedReward(skins) --奖励皮肤
                        _G.SKINS_CACHE_L[user_id] = skins --服务器传来的数据是啥就是啥
                        if player ~= nil and player:IsValid() then --该给玩家客户端传数据了
                            FnRpc_s2c(user_id, 1, skins or {})
                        end
                    end
                end,
                err = function(state, user_id, errcode)
                    --errcode==1：主动刷新太频繁
                    --errcode==2：自动刷新太频繁
                    --errcode==3：2次接口调用都失败了
                    --errcode==4：接口参数不对
                    --errcode==5：得到回应，但是解析错误
                    --errcode==6：接口失败
                end
            }
        )
    end

    DoLegionCdk = function(player, userid, cdk)
        QueryManage(
            SKINS_NET_CDK_L, player, userid, "DoLegionCdk", false,
            { force = nil, cut = 5, delay = 0 },
            {
                urlparams = function(state, user_id)
                    return "https://fireleaves.cn/cdk/use"
                end,
                params = function(state, user_id)
                    return json.encode({
                        cdkStr = cdk,
                        id = user_id
                    })
                end,
                handle = function(state, user_id, data)
                    local stat = -1
                    if data ~= nil and data.code == 0 then
                        stat = 1
                        state.loadtag = 1
                        GetLegionSkins(player, userid, 0, true) --cdk兑换成功，重新获取皮肤数据
                    else
                        state.loadtag = -1
                    end
                    StopQueryTask(state)
                    if player ~= nil and player:IsValid() then
                        FnRpc_s2c(user_id, 2, { state = stat, pop = -1 })
                    end
                end,
                err = function(state, user_id, errcode)
                    if player ~= nil and player:IsValid() then
                        local pop = -1
                        if errcode == 1 or errcode == 2 then
                            pop = 2
                        elseif errcode == 3 then
                            pop = 3
                        elseif errcode == 4 then
                            pop = 4
                        end
                        FnRpc_s2c(user_id, 2, { state = -1, pop = pop })
                    end
                end
            }
        )
    end

    --------------------------------------------------------------------------
    --[[ 修改SpawnPrefab()以应用皮肤机制 ]]
    --------------------------------------------------------------------------

    local SpawnPrefab_old = _G.SpawnPrefab
    _G.SpawnPrefab = function(name, skin, skin_id, creator)
        --【服务端】环境
        if skin ~= nil and SKINS_LEGION[skin] ~= nil then
            local prefab = SpawnPrefab_old(name, nil, nil, creator)
            if prefab ~= nil then
                if prefab.components.skinedlegion ~= nil then
                    -- if creator == nil or DoYouHaveSkin(skin, creator) then
                        prefab.components.skinedlegion:SetSkin(skin, creator)
                    -- end
                end
            end
            return prefab
        else
            return SpawnPrefab_old(name, skin, skin_id, creator)
        end
    end

    --------------------------------------------------------------------------
    --[[ 修改清洁扫把以应用皮肤机制 ]]
    --------------------------------------------------------------------------

    AddPrefabPostInit("reskin_tool", function(inst)
        if inst.components.spellcaster ~= nil then
            local can_cast_fn_old = inst.components.spellcaster.can_cast_fn
            inst.components.spellcaster:SetCanCastFn(function(doer, target, pos, ...)
                if target.components.skinedlegion ~= nil then
                    return true
                end
                if can_cast_fn_old ~= nil then
                    return can_cast_fn_old(doer, target, pos, ...)
                end
            end)

            local spell_old = inst.components.spellcaster.spell
            inst.components.spellcaster:SetSpellFn(function(tool, target, pos, ...)
                if target ~= nil and target.components.skinedlegion ~= nil then
                    tool:DoTaskInTime(0, function()
                        local doer = tool.components.inventoryitem.owner
                        if not target:IsValid() or doer == nil or doer.userid == nil then
                            return
                        end

                        local prefabname = nil
                        if target.components.skinedlegion.overskin ~= nil then
                            prefabname = target.components.skinedlegion.overskin.name or target.prefab
                        else
                            prefabname = target.prefab
                        end

                        local skins = PREFAB_SKINS[prefabname]
                        if skins == nil then
                            return
                        end
                        local skinname_new = nil
                        local skinname_old = target.components.skinedlegion:GetSkin()
                        local skinname_cac = _G.SKINS_CACHE_CG_L[doer.userid] and _G.SKINS_CACHE_CG_L[doer.userid][prefabname] or nil

                        if skinname_old == nil then --原皮，尝试切换成其他皮肤，优先为缓存皮肤
                            if skinname_cac ~= nil and DoYouHaveSkin(skinname_cac, doer.userid) then
                                skinname_new = skinname_cac
                            else
                                for _, skinname in pairs(skins) do --寻找第一个拥有的皮肤
                                    if DoYouHaveSkin(skinname, doer.userid) then
                                        skinname_new = skinname
                                        break
                                    end
                                end
                            end
                        else --非原皮，切换到下一个皮肤
                            local findit = false
                            for _, skinname in pairs(skins) do --寻找下一个拥有的皮肤
                                if skinname_old == skinname then
                                    findit = true
                                elseif findit then --只判断当前皮肤之后的皮肤
                                    if DoYouHaveSkin(skinname, doer.userid) then
                                        skinname_new = skinname
                                        break
                                    end
                                end
                            end
                        end
                        if skinname_new ~= skinname_old then
                            local skin_data_old = target.components.skinedlegion:GetSkinedData()
                            target.components.skinedlegion:SetSkin(skinname_new, doer.userid)

                            --交换记录
                            local skin_name = target.components.skinedlegion:GetSkin()
                            if skinname_cac ~= skin_name then
                                SaveCGSkin(doer.userid, skin_name, target.components.skinedlegion:GetSkinedData(), skin_data_old)
                                FnRpc_s2c(doer.userid, 4, { new = skin_name, old = skinname_old })
                            end
                        end
                        target.components.skinedlegion:SpawnSkinExchangeFx(nil, tool) --不管有没有交换成功，都释放特效
                    end)
                    return
                end
                if spell_old ~= nil then
                    return spell_old(tool, target, pos, ...)
                end
            end)
        end
    end)

    --------------------------------------------------------------------------
    --[[ 修改玩家实体以应用皮肤机制 ]]
    --------------------------------------------------------------------------

    local function SaveSkinData(base, keyname, data)
        if base == nil then
            return
        end
        local dd = nil
        for name, hasit in pairs(base) do
            if hasit then
                if dd == nil then
                    dd = {}
                end
                dd[name] = hasit
            end
        end
        if dd ~= nil then
            data[keyname] = dd
        end
    end
    AddPlayerPostInit(function(inst)
        local OnSave_old = inst.OnSave
        inst.OnSave = function(inst, data)
            if OnSave_old ~= nil then
                OnSave_old(inst, data)
            end
            if inst.userid == nil then
                return
            end
            SaveSkinData(_G.SKINS_CACHE_L[inst.userid], "skins_le", data)
            SaveSkinData(_G.SKINS_CACHE_CG_L[inst.userid], "skins_cg_le", data)
        end
        local OnLoad_old = inst.OnLoad
        inst.OnLoad = function(inst, data)
            if OnLoad_old ~= nil then
                OnLoad_old(inst, data)
            end
            if inst.userid == nil then
                return
            end
            _G.SKINS_CACHE_L[inst.userid] = data.skins_le
            _G.SKINS_CACHE_CG_L[inst.userid] = data.skins_cg_le
        end

        inst:DoTaskInTime(1.2, function(inst) --实体生成后，开始调取接口获取皮肤数据
            if inst.userid == nil then
                return
            end
            if CheckFreeSkins() then
                CloseGame()
                return
            end

            GetLegionSkins(inst, inst.userid, 0.2+1.8*math.random(), false)
            -- _G.SKINS_CACHE_L[inst.userid] = {}

            --提前给玩家传输服务器的皮肤数据
            if _G.SKINS_CACHE_L[inst.userid] ~= nil then
                FnRpc_s2c(inst.userid, 1, _G.SKINS_CACHE_L[inst.userid])
            end
            if _G.SKINS_CACHE_CG_L[inst.userid] ~= nil then
                FnRpc_s2c(inst.userid, 3, _G.SKINS_CACHE_CG_L[inst.userid])
            end
        end)
    end)
end

local function GetRightRoot()
    if ThePlayer and ThePlayer.HUD and ThePlayer.HUD.controls then
        return ThePlayer.HUD.controls.right_root
    end
    return nil
end

--客户端响应服务器请求【客户端环境】
AddClientModRPCHandler("LegionSkined", "SkinHandle", function(handletype, data, ...)
    if handletype and type(handletype) == "number" then
        if handletype == 1 then --更新客户端皮肤数据
            if data and type(data) == "string" then
                local success, result = pcall(json.decode, data)
                if result and ThePlayer and ThePlayer.userid then
                    _G.SKINS_CACHE_L[ThePlayer.userid] = result
                    --获取数据后，主动更新皮肤铺界面
                    local right_root = GetRightRoot()
                    if right_root ~= nil and right_root.skinshop_l then
                        right_root.skinshop_l:ResetItems()
                    end
                end
            end

        elseif handletype == 2 then --反馈cdk结果
            if data and type(data) == "string" then
                local success, result = pcall(json.decode, data)
                if result then
                    --获取数据后，主动更新cdk输入框
                    local right_root = GetRightRoot()
                    if right_root ~= nil and right_root.skinshop_l then
                        right_root.skinshop_l:SetCdkState(result.state, result.pop)
                    end
                end
            end

        elseif handletype == 3 then --更新客户端皮肤交换缓存
            if data and type(data) == "string" then
                local success, result = pcall(json.decode, data)
                if result and ThePlayer and ThePlayer.userid then
                    _G.SKINS_CACHE_CG_L[ThePlayer.userid] = result
                end
            end

        elseif handletype == 4 then --更新单个的客户端皮肤交换缓存
            if data and type(data) == "string" then
                local success, result = pcall(json.decode, data)
                if result and ThePlayer and ThePlayer.userid then
                    if result.new ~= nil or result.old ~= nil then
                        local skin_data = result.new ~= nil and SKINS_LEGION[result.new] or nil
                        local skin_data_old = result.old ~= nil and SKINS_LEGION[result.old] or nil
                        SaveCGSkin(ThePlayer.userid, result.new, skin_data, skin_data_old)
                    end
                end
            end

        end
    end
end)

--服务端响应客户端请求【服务端环境】
AddModRPCHandler("LegionSkined", "BarHandle", function(player, handletype, data, ...)
    if handletype and type(handletype) == "number" then
        if handletype == 1 then --主动刷新皮肤
            if player and GetLegionSkins ~= nil then
                GetLegionSkins(player, player.userid, 0, true)
            end
        elseif handletype == 2 then --cdk兑换
            if player and data and DoLegionCdk ~= nil and type(data) == "string" then
                local success, result = pcall(json.decode, data)
                if result and result.cdk ~= nil and result.cdk ~= "" and result.cdk:utf8len() > 6 then
                    DoLegionCdk(player, player.userid, result.cdk)
                end
            end
        end
    end
end)

--------------------------------------------------------------------------
--[[ 修改审视自我按钮的弹出界面，增加皮肤界面触发按钮 ]]
--------------------------------------------------------------------------

if not TheNet:IsDedicated() and _G.CONFIGS_LEGION.LANGUAGES == "chinese" then
    -- local ImageButton = require "widgets/imagebutton"
    -- local PlayerAvatarPopup = require "widgets/playeravatarpopup"
    local PlayerInfoPopup = require "screens/playerinfopopupscreen"
    local TEMPLATES = require "widgets/templates"
    -- local SkinLegionDialog = require "widgets/skinlegiondialog"

    -- local right_root = nil
    -- AddClassPostConstruct("widgets/controls", function(self)
    --     right_root = self.right_root
    -- end)

    local MakeBG_old = PlayerInfoPopup.MakeBG
    PlayerInfoPopup.MakeBG = function(self, ...)
        MakeBG_old(self, ...)

        --离线模式不能有皮肤界面功能(因为离线模式下的klei账户ID与联网模式下的不一样)
        if TheNet:IsOnlineMode() then
            local right_root = GetRightRoot()
            if right_root == nil then
                return
            end
            if right_root.skinshop_l then --再次打开人物自检面板时，需要关闭已有的铺子页面
                right_root.skinshop_l:Kill()
                right_root.skinshop_l = nil
            end

            self.skinshop_l_button = self.root:AddChild(TEMPLATES.IconButton(
                "images/icon_skinbar_shadow_l.xml", "icon_skinbar_shadow_l.tex", "棱镜鸡毛铺", false, false,
                function()
                    if right_root.skinshop_l then
                        right_root.skinshop_l:Kill()
                    end
                    local SkinLegionDialog = _G.require("widgets/skinlegiondialog") --test：动态更新
                    right_root.skinshop_l = right_root:AddChild(SkinLegionDialog(self.owner))
                    right_root.skinshop_l:SetPosition(-380, 0)
                    -- self:Kill() --直接删除并不能去除暂停状态
                    --去除当前的全局弹窗。必须去除暂停，否则会导致刷新皮肤的响应也暂停
                    TheFrontEnd:PopScreen()
                end,
                nil, "self_inspect_mod.tex"
            ))
            self.skinshop_l_button.icon:SetScale(.6)
            self.skinshop_l_button.icon:SetPosition(-4, 6)
            self.skinshop_l_button:SetScale(0.65)
            self.skinshop_l_button:SetPosition(204, -260)
        end

        self.wiki_l_button = self.root:AddChild(TEMPLATES.IconButton(
            "images/icon_wikibar_shadow_l.xml", "icon_wikibar_shadow_l.tex", "棱镜百科", false, false,
            function()
                VisitURL("http://wap.modwikis.com/mod/mainPage?_id=645b7b5e5e00ca45b8018bc9", false)
            end,
            nil, "self_inspect_mod.tex"
        ))
        self.wiki_l_button.icon:SetScale(.6)
        self.wiki_l_button.icon:SetPosition(-4, 6)
        self.wiki_l_button:SetScale(0.65)
        self.wiki_l_button:SetPosition(246, -260)
    end
end

--------------------------------------------------------------------------
--[[ placer应用兼容皮肤的切换缓存 ]]
--------------------------------------------------------------------------

-- local inventoryitem_replica = require("components/inventoryitem_replica")

-- local GetDeployPlacerName_old = inventoryitem_replica.GetDeployPlacerName
-- inventoryitem_replica.GetDeployPlacerName = function(self, ...)
--     local placerold = GetDeployPlacerName_old(self, ...)
--     if placerold == "gridplacer" then
--         return placerold
--     end

--     if ThePlayer and ThePlayer.userid and SKINS_CACHE_EX_L[ThePlayer.userid] ~= nil then
--         local data = SKINS_CACHE_EX_L[ThePlayer.userid]
--         if data[self.inst.prefab] ~= nil then
--             return data[self.inst.prefab].placer or placerold
--         end
--     end

--     return placerold
-- end
