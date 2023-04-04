------skined_legion

local _G = GLOBAL
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()
local ischinese = _G.CONFIGS_LEGION.LANGUAGES == "chinese"

table.insert(Assets, Asset("ATLAS", "images/icon_skinbar_shadow_l.xml"))
table.insert(Assets, Asset("IMAGE", "images/icon_skinbar_shadow_l.tex"))
table.insert(Assets, Asset("ANIM", "anim/images_minisign_skins1.zip"))
table.insert(Assets, Asset("ANIM", "anim/images_minisign_skins2.zip"))
table.insert(PrefabFiles, "fx_ranimbowspark")
table.insert(PrefabFiles, "skinprefabs_legion")

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

local function Fn_siving_turn_fruit(genetrans, skinname)
    if genetrans.fx ~= nil then
        genetrans.fx.AnimState:SetBank(skinname)
        genetrans.fx.AnimState:SetBuild(skinname)
    end
    genetrans.fxdata.skinname = skinname
end
local function Fn_siving_turn(inst, skinname, bloom)
    inst.AnimState:SetBank(skinname)
    inst.AnimState:SetBuild(skinname)
    if inst.components.genetrans ~= nil then
        if inst.components.genetrans.fxdata.skinname ~= skinname then
            Fn_siving_turn_fruit(inst.components.genetrans, skinname)
        end
        inst.components.genetrans.fxdata.bloom = bloom
    end
    if bloom then
        if inst.Light:IsEnabled() then
            inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        end
    else
        inst.AnimState:ClearBloomEffectHandle()
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

local function Fn_placer_neverfade(inst)
    for _,v in ipairs({ "berries", "berriesmore", "berriesmost" }) do
        inst.AnimState:Hide(v)
    end
    inst.AnimState:Pause()
end

------

local function SetFollowedFx(inst, owner, fxname, sym, x, y)
    local fx = SpawnPrefab(fxname)
    if fx ~= nil then
        fx.entity:SetParent(owner.entity)
        fx.entity:AddFollower()
        fx.Follower:FollowSymbol(owner.GUID, sym or "swap_object", x or 0, y or 0, 0)
        inst.fx_s_l = fx
    end
end
local function EndFollowedFx(inst, owner)
    if inst.fx_s_l ~= nil then
        inst.fx_s_l:Remove()
        inst.fx_s_l = nil
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
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
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
            --     anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            -- },
            -- fn_anim = function(inst)end, --处于水中时的动画设置，替换anim的默认方式
        },
    },
    ]]--

    rosebush = {
        assets = nil,
        fn_start = function(inst)
            inst.AnimState:SetBank("berrybush2")
            inst.AnimState:SetBuild("rosebush")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
    },
    lilybush = {
        assets = nil,
        fn_start = function(inst)
            inst.AnimState:SetBank("berrybush2")
            inst.AnimState:SetBuild("lilybush")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
    },
    orchidbush = {
        assets = nil,
        fn_start = function(inst)
            inst.AnimState:SetBank("berrybush2")
            inst.AnimState:SetBuild("orchidbush")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
    },

    rosorns = {
        assets = nil,
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = {
            symbol = "swap_object", build = "swap_rosorns", file = "swap_rosorns"
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = 0.15, size = "small", offset_y = 0.4, scale = 0.5, nofx = nil
        },
    },
    lileaves = {
        assets = nil,
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = {
            symbol = "swap_object", build = "swap_lileaves", file = "swap_lileaves"
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = 0.15, size = "small", offset_y = 0.4, scale = 0.5, nofx = nil,
        },
    },
    orchitwigs = {
        assets = nil,
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = {
            symbol = "swap_object", build = "swap_orchitwigs", file = "swap_orchitwigs",
            atkfx = "impact_orchid_fx",
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = 0.15, size = "small", offset_y = 0.4, scale = 0.5, nofx = nil,
        },
    },

    neverfade = {
        image = { name = nil, atlas = nil, setable = false },
        anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
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
        floater = {
            cut = 0.12, size = "med", offset_y = 0.4, scale = 0.5, nofx = nil,
        }
    },
    neverfadebush = {
        fn_start = function(inst)
            inst.AnimState:SetBank("berrybush2")
            inst.AnimState:SetBuild("neverfadebush")
        end,
        exchangefx = { prefab = nil, offset_y = 0.9, scale = nil }
    },

    hat_lichen = {
        assets = nil,
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = nil, build = nil,
            anim = "anim", isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true
        },
        equip = { symbol = "swap_hat", build = "hat_lichen", file = "swap_hat", isopenhat = true },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = 0.03, size = "med", offset_y = 0.2, scale = 0.5, nofx = nil,
        },
    },

    hat_cowboy = {
        assets = nil,
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = nil, build = nil,
            anim = "anim", isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = { symbol = "swap_hat", build = "hat_cowboy", file = "swap_hat" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = 0.03, size = "med", offset_y = 0.2, scale = 0.8, nofx = nil,
        },
    },

    pinkstaff = {
        assets = nil,
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = nil, build = nil,
            anim = "anim", isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true
        },
        fn_start = function(inst)
            inst.fxcolour = {255/255, 80/255, 173/255}
        end,
        equip = {
            symbol = "swap_object", build = "swap_pinkstaff", file = "swap_pinkstaff"
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.15, size = "small", offset_y = 0.35, scale = 0.5, nofx = nil }
    },

    boltwingout = {
        assets = nil,
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = "swap_boltwingout", build = "swap_boltwingout",
            anim = "idle", isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = { symbol = "swap_body", build = "swap_boltwingout", file = "swap_body" },
        boltdata = { fx = "boltwingout_fx", build = nil },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = 0.09, size = "small", offset_y = 0.2, scale = 0.45, nofx = nil,
        },
    },

    fishhomingtool_awesome = {
        assets = nil,
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        fn_start = function(inst)
            inst.components.bundlemaker:SetSkinData()
        end,
        equip = { symbol = "swap_object", build = "fishhomingtool_awesome", file = "swap" },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
    },
    fishhomingtool_normal = {
        assets = nil,
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        fn_start = function(inst)
            inst.components.bundlemaker:SetSkinData()
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
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
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
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
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
    },

    shield_l_log = {
        assets = nil,
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = "shield_l_log", build = "shield_l_log",
            anim = "idle", isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = { symbol = nil, build = "shield_l_log", file = "swap_shield" },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.7 },
        floater = {
            cut = nil, size = "small", offset_y = 0.2, scale = 0.9, nofx = nil,
        },
    },
    shield_l_sand = {
        assets = nil,
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = "shield_l_sand", build = "shield_l_sand",
            anim = "idle", isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = { symbol = nil, build = "shield_l_sand", file = "swap_shield" },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
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
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
    },

    tripleshovelaxe = {
        assets = nil,
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = {
            symbol = "swap_object", build = "tripleshovelaxe", file = "swap"
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = nil, size = "med", offset_y = 0.15, scale = 0.4, nofx = nil,
        },
    },
    triplegoldenshovelaxe = {
        assets = nil,
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = {
            symbol = "swap_object", build = "triplegoldenshovelaxe", file = "swap"
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = nil, size = "med", offset_y = 0.15, scale = 0.4, nofx = nil,
        },
    },

    backcub = {
        assets = nil,
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = "backcub", build = "backcub",
            anim = "anim", isloop_anim = true, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = { symbol = "swap_body", build = "swap_backcub", file = "swap_body" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = nil, size = nil, offset_y = nil, scale = nil, nofx = true,
            anim = {
                bank = "backcub", build = "backcub",
                anim = "anim_water", isloop_anim = true, animpush = nil, isloop_animpush = nil,
            }
        }
    },

    fimbul_axe = {
        assets = nil,
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = "boomerang", build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true
        },
        equip = {
            symbol = "swap_object", build = "fimbul_axe", file = "swap_base"
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = 0.1, size = "med", offset_y = 0.3, scale = 0.5, nofx = nil
        }
    },

    siving_derivant_lvl0 = {
        assets = nil,
        fn_start = function(inst)
            inst.AnimState:SetBank("siving_derivants")
            inst.AnimState:SetBuild("siving_derivants")
            inst.AnimState:SetScale(1.3, 1.3)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
    },
    siving_derivant_lvl1 = {
        assets = nil,
        fn_start = function(inst)
            inst.AnimState:SetBank("siving_derivants")
            inst.AnimState:SetBuild("siving_derivants")
            inst.AnimState:SetScale(1.3, 1.3)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
    },
    siving_derivant_lvl2 = {
        assets = nil,
        fn_start = function(inst)
            inst.AnimState:SetBank("siving_derivants")
            inst.AnimState:SetBuild("siving_derivants")
            inst.AnimState:SetScale(1.3, 1.3)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
    },
    siving_derivant_lvl3 = {
        assets = nil,
        fn_start = function(inst)
            inst.AnimState:SetBank("siving_derivants")
            inst.AnimState:SetBuild("siving_derivants")
            inst.AnimState:SetScale(1.3, 1.3)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
    },

    siving_turn = {
        fn_start = function(inst)
            Fn_siving_turn(inst, "siving_turn", true)
            inst.components.genetrans.fxdata.unlockfx = "siving_turn_unlock_fx"
        end,
        fn_fruit = function(genetrans)
            Fn_siving_turn_fruit(genetrans, "siving_turn")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
    },

    carpet_whitewood = {
        anim = {
            bank = "carpet_whitewood", build = "carpet_whitewood",
            anim = "idle", isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil }
    },
    carpet_whitewood_big = {
        anim = {
            bank = "carpet_whitewood", build = "carpet_whitewood",
            anim = "idle_big", isloop_anim = nil, animpush = nil, isloop_animpush = nil,
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
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true
        },
        equip = {
            symbol = "swap_object", build = "siving_feather_real", file = "swap"
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.04, size = "small", offset_y = 0.2, scale = 0.5, nofx = nil }
    },
    siving_feather_fake = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true
        },
        equip = {
            symbol = "swap_object", build = "siving_feather_fake", file = "swap"
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.04, size = "small", offset_y = 0.2, scale = 0.5, nofx = nil }
    },

    revolvedmoonlight_item = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = "revolvedmoonlight", build = "revolvedmoonlight",
            anim = "idle_item", isloop_anim = nil, animpush = nil, isloop_animpush = nil,
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
        skin_id = "61627d927bbb727be174c4a0",
        noshopshow = nil, --为true的话，就不在鸡毛铺里展示
        onlyownedshow = true, --为true的话，只有玩家拥有该皮肤才在鸡毛铺里展示
		assets = { --仅仅是用于初始化注册
			Asset("ANIM", "anim/skin/swap_spear_mirrorrose.zip"),
			Asset("ANIM", "anim/skin/spear_mirrorrose.zip"),
            Asset("ANIM", "anim/skin/rosorns_spell.zip"),
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
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
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
            --     anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            -- },
            -- fn_anim = function(inst)end, --处于水中时的动画设置，替换anim的默认方式
        },
        placer = { --自定义的placer
            name = nil, bank = nil, build = nil, anim = "dead",
            prefabs = { "prefab1", "prefab2" }, --哪些物品的placer，可对应多个。若为空则表示只用overridedeployplacername机制
        },
    },
    ]]--

    rosebush_marble = {
        base_prefab = "rosebush",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "619108a04c724c6f40e77bd4",
		assets = {
            Asset("ANIM", "anim/berrybush.zip"), --官方浆果丛动画
			Asset("ANIM", "anim/skin/rosebush_marble.zip"),
		},

        string = ischinese and { name = "理盛赤蔷" } or { name = "Rose Marble Pot" },

		fn_start = function(inst)
            --官方代码写得挺好，直接改动画模板居然能继承已有的动画播放和symbol切换状态
            inst.AnimState:SetBank("berrybush")
            inst.AnimState:SetBuild("rosebush_marble")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        linkedskins = { rosorns = "rosorns_marble" },
        placer = {
            name = nil, bank = "berrybush", build = "rosebush_marble", anim = "dead",
            prefabs = { "dug_rosebush", "cutted_rosebush" },
        },
    },
    rosorns_marble = {
        base_prefab = "rosorns",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "62e639928c2f781db2f79b3d",
        onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/rosorns_marble.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/foliageath_rosorns_marble.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/foliageath_rosorns_marble.tex"),
		},
        image = { name = nil, atlas = nil, setable = true },

        string = ischinese and { name = "落薇剪" } or { name = "Falling Petals Scissors" },

		anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = true, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = {
            symbol = "swap_object", build = "rosorns_marble", file = "swap_object"
        },
        fn_onAttack = function(inst, owner, target)
            local fx = SpawnPrefab("rosorns_marble_fx")
            if fx ~= nil then
                fx.Transform:SetPosition(target.Transform:GetWorldPosition())
            end
        end,
        scabbard = {
            anim = "idle_cover", isloop = true, bank = "rosorns_marble", build = "rosorns_marble",
            image = "foliageath_rosorns_marble", atlas = "images/inventoryimages_skin/foliageath_rosorns_marble.xml",
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = 0.15, size = "small", offset_y = 0.4, scale = 0.5, nofx = nil,
        },
    },
    lilybush_marble = {
        base_prefab = "lilybush",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "619116c74c724c6f40e77c40",
		assets = {
            Asset("ANIM", "anim/berrybush.zip"), --官方浆果丛动画
			Asset("ANIM", "anim/skin/lilybush_marble.zip"),
		},

        string = ischinese and { name = "理盛截莲" } or { name = "Lily Marble Pot" },

		fn_start = function(inst)
            inst.AnimState:SetBank("berrybush")
            inst.AnimState:SetBuild("lilybush_marble")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        linkedskins = { lileaves = "lileaves_marble" },
        placer = {
            name = nil, bank = "berrybush", build = "lilybush_marble", anim = "dead",
            prefabs = { "dug_lilybush", "cutted_lilybush" },
        },
    },
    lileaves_marble = {
        base_prefab = "lileaves",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "62e535bd8c2f781db2f79ae7",
        onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/lileaves_marble.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/foliageath_lileaves_marble.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/foliageath_lileaves_marble.tex"),
		},
        image = { name = nil, atlas = nil, setable = true },

        string = ischinese and { name = "石莲长枪" } or { name = "Marble Lilance" },

		anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = {
            symbol = "swap_object", build = "lileaves_marble", file = "swap_object"
        },
        scabbard = {
            anim = "idle_cover", isloop = nil, bank = "lileaves_marble", build = "lileaves_marble",
            image = "foliageath_lileaves_marble", atlas = "images/inventoryimages_skin/foliageath_lileaves_marble.xml",
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = 0.15, size = "small", offset_y = 0.4, scale = 0.6, nofx = nil,
        },
    },
    orchidbush_marble = {
        base_prefab = "orchidbush",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "6191d0514c724c6f40e77eb9",
		assets = {
            Asset("ANIM", "anim/berrybush.zip"), --官方浆果丛动画
			Asset("ANIM", "anim/skin/orchidbush_marble.zip"),
		},

        string = ischinese and { name = "理盛瀑兰" } or { name = "Orchid Marble Pot" },

		fn_start = function(inst)
            inst.AnimState:SetBank("berrybush")
            inst.AnimState:SetBuild("orchidbush_marble")
        end,
        exchangefx = { prefab = nil, offset_y = 1.3, scale = nil },
        linkedskins = { orchitwigs = "orchitwigs_marble" },
        placer = {
            name = nil, bank = "berrybush", build = "orchidbush_marble", anim = "dead",
            prefabs = { "dug_orchidbush", "cutted_orchidbush" },
        },
    },
    orchitwigs_marble = {
        base_prefab = "orchitwigs",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "62e61d158c2f781db2f79b1e",
        onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/orchitwigs_marble.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/foliageath_orchitwigs_marble.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/foliageath_orchitwigs_marble.tex"),
		},
        image = { name = nil, atlas = nil, setable = true },

        string = ischinese and { name = "铁艺兰珊" } or { name = "Ironchid" },

		anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
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
        floater = {
            cut = 0.05, size = "small", offset_y = 0.15, scale = 0.5, nofx = nil,
        },
    },

    orchidbush_disguiser = {
        base_prefab = "orchidbush",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "626029b9c340bf24ab31057a",
        onlyownedshow = true,
		assets = {
            Asset("ANIM", "anim/berrybush2.zip"), --官方浆果丛动画
			Asset("ANIM", "anim/skin/orchidbush_disguiser.zip"),
		},

        string = ischinese and { name = "粉色猎园" } or { name = "Pink Orchid Bush" },

		fn_start = function(inst)
            inst.AnimState:SetBank("berrybush2")
            inst.AnimState:SetBuild("orchidbush_disguiser")
        end,
        exchangefx = { prefab = nil, offset_y = 1.3, scale = nil },
        linkedskins = { orchitwigs = "orchitwigs_disguiser" },
        placer = {
            name = nil, bank = "berrybush2", build = "orchidbush_disguiser", anim = "dead",
            prefabs = { "dug_orchidbush", "cutted_orchidbush" },
        },
    },
    orchitwigs_disguiser = {
        base_prefab = "orchitwigs",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityFree,

        skin_id = "notnononl", --61ff45880a30fc7fca0db5e5
		assets = {
			Asset("ANIM", "anim/skin/orchitwigs_disguiser.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/foliageath_orchitwigs_disguiser.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/foliageath_orchitwigs_disguiser.tex"),
		},
        image = { name = nil, atlas = nil, setable = true },

        string = ischinese and { name = "粉色追猎" } or { name = "Pink Orchitwigs" },

		anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = {
            symbol = "swap_object", build = "orchitwigs_disguiser", file = "swap_object",
            atkfx = "impact_orchid_fx_disguiser",
        },
        scabbard = {
            anim = "idle_cover", isloop = nil, bank = "orchitwigs_disguiser", build = "orchitwigs_disguiser",
            image = "foliageath_orchitwigs_disguiser", atlas = "images/inventoryimages_skin/foliageath_orchitwigs_disguiser.xml",
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = 0.05, size = "small", offset_y = 0.15, scale = 0.5, nofx = nil,
        },
    },

    neverfade_thanks = {
        base_prefab = "neverfade",
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,

        skin_id = "6191d8f74c724c6f40e77ed0",
        onlyownedshow = true,
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
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true
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
            image = "foliageath_neverfade_thanks", atlas = "images/inventoryimages_skin/foliageath_neverfade_thanks.xml",
        },
        butterfly = { bank = "butterfly", build = "neverfade_butterfly_thanks" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = 0.05, size = "small", offset_y = 0.15, scale = 0.5, nofx = nil,
        },
        linkedskins = { bush = "neverfadebush_thanks" },
        placer = {
            name = nil, bank = "neverfadebush_thanks", build = "neverfadebush_thanks", anim = "dead", prefabs = nil
        }
    },
    neverfadebush_thanks = {
        base_prefab = "neverfadebush",
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,

        skin_id = "6191d8f74c724c6f40e77ed0",
        noshopshow = true,
		assets = {
			Asset("ANIM", "anim/skin/neverfadebush_thanks.zip"),
		},
        string = {
            name = ischinese and "扶伤剑冢" or "FuShang Tomb"
        },

		fn_start = function(inst)
            inst.AnimState:SetBank("neverfadebush_thanks")
            inst.AnimState:SetBuild("neverfadebush_thanks")
        end,
        exchangefx = { prefab = nil, offset_y = 1.2, scale = nil },
        linkedskins = { sword = "neverfade_thanks" }
    },
    neverfade_paper = {
        base_prefab = "neverfade",
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,

        skin_id = "638362b68c2f781db2f7f524",
        onlyownedshow = true,
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
        floater = {
            cut = 0.05, size = "small", offset_y = 0.15, scale = 0.5, nofx = nil,
        },
        linkedskins = { bush = "neverfadebush_paper" },
        placer = {
            name = nil, bank = "berrybush2", build = "neverfadebush_paper", anim = "idle", prefabs = nil,
            fn_init = Fn_placer_neverfade
        }
    },
    neverfadebush_paper = {
        base_prefab = "neverfadebush",
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,

        skin_id = "638362b68c2f781db2f7f524",
        noshopshow = true,
		assets = {
			Asset("ANIM", "anim/skin/neverfadebush_paper.zip")
		},
        string = {
            name = ischinese and "青蝶纸扇" or "Paper-fly Fan"
        },

		fn_start = function(inst)
            inst.AnimState:SetBank("berrybush2")
            inst.AnimState:SetBuild("neverfadebush_paper")
        end,
        exchangefx = { prefab = nil, offset_y = 1.2, scale = nil },
        linkedskins = { sword = "neverfade_paper" }
    },
    neverfade_paper2 = {
        base_prefab = "neverfade",
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,

        skin_id = "638362b68c2f781db2f7f524",
        onlyownedshow = true,
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
        floater = {
            cut = 0.05, size = "small", offset_y = 0.15, scale = 0.5, nofx = nil,
        },
        linkedskins = { bush = "neverfadebush_paper2" },
        placer = {
            name = nil, bank = "berrybush2", build = "neverfadebush_paper2", anim = "idle", prefabs = nil,
            fn_init = Fn_placer_neverfade
        }
    },
    neverfadebush_paper2 = {
        base_prefab = "neverfadebush",
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,

        skin_id = "638362b68c2f781db2f7f524",
        noshopshow = true,
		assets = {
			Asset("ANIM", "anim/skin/neverfadebush_paper2.zip")
		},
        string = {
            name = ischinese and "绀蝶纸扇" or "Violet Paper-fly Fan"
        },

		fn_start = function(inst)
            inst.AnimState:SetBank("berrybush2")
            inst.AnimState:SetBuild("neverfadebush_paper2")
        end,
        exchangefx = { prefab = nil, offset_y = 1.2, scale = nil },
        linkedskins = { sword = "neverfade_paper2" }
    },

    hat_lichen_emo_que = {
        base_prefab = "hat_lichen",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "61909c584c724c6f40e779fa",
		assets = {
			Asset("ANIM", "anim/skin/hat_lichen_emo_que.zip"),
		},
		image = { name = nil, atlas = nil, setable = true },

        string = ischinese and { name = "\"困惑\"发卡" } or { name = "Question Hairpin" },

		anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = { symbol = "swap_hat", build = "hat_lichen_emo_que", file = "swap_hat", isopenhat = true },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = 0.03, size = "small", offset_y = 0.15, scale = 0.5, nofx = nil,
        },
    },
    hat_lichen_disguiser = {
        base_prefab = "hat_lichen",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityFree,

        skin_id = "notnononl", --61f15bf4db102b0b8a529c66
		assets = {
			Asset("ANIM", "anim/skin/hat_lichen_disguiser.zip"),
		},
		image = { name = nil, atlas = nil, setable = true },

        string = ischinese and { name = "深渊的星" } or { name = "Abyss Star Hairpin" },

		anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = {
            symbol = "swap_hat", build = "hat_lichen_disguiser", file = "swap_hat",
            isopenhat = false, lightcolor = { r = 0, g = 1, b = 1 }
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = 0.03, size = "med", offset_y = 0.2, scale = 0.7, nofx = nil,
        },
    },

    hat_cowboy_tvplay = {
        base_prefab = "hat_cowboy",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityFree,

        skin_id = "notnononl",
		assets = {
			Asset("ANIM", "anim/skin/hat_cowboy_tvplay.zip"),
		},
		image = { name = nil, atlas = nil, setable = true },

        string = ischinese and { name = "卡尔的警帽，永远" } or { name = "Carl's Forever Police Cap" },

		anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = { symbol = "swap_hat", build = "hat_cowboy_tvplay", file = "swap_hat" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = 0.03, size = "med", offset_y = 0.2, scale = 0.8, nofx = nil,
        },
    },
    pinkstaff_tvplay = {
        base_prefab = "pinkstaff",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityFree,

        skin_id = "notnononl",
		assets = {
			Asset("ANIM", "anim/skin/pinkstaff_tvplay.zip")
		},
        image = { name = nil, atlas = nil, setable = true },

        string = ischinese and { name = "音速起子12" } or { name = "Sonic Screwdriver 12" },

		anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true
        },
        fn_start = function(inst)
            inst.fxcolour = {115/255, 217/255, 255/255}
        end,
        equip = {
            symbol = "swap_object", build = "pinkstaff_tvplay", file = "swap_object"
        },
        equipfx = {
            start = function(inst, owner)
                SetFollowedFx(inst, owner, "pinkstaff_fx_tvplay", "swap_object", 0, -140)
            end,
            stop = EndFollowedFx
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.15, size = "small", offset_y = 0.35, scale = 0.5, nofx = nil }
    },

    boltwingout_disguiser = {
        base_prefab = "boltwingout",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "61c57daadb102b0b8a50ae95",
		assets = {
			Asset("ANIM", "anim/skin/boltwingout_disguiser.zip"),
            Asset("ANIM", "anim/skin/boltwingout_shuck_disguiser.zip"),
		},
		image = { name = nil, atlas = nil, setable = true },

        string = ischinese and { name = "枯叶飞舞" } or { name = "Fallen Dance" },

		anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = { symbol = "swap_body", build = "boltwingout_disguiser", file = "swap_body" },
        boltdata = { fx = "boltwingout_fx_disguiser", build = "boltwingout_shuck_disguiser" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = nil, size = "med", offset_y = 0.1, scale = 0.8, nofx = nil,
        },
    },

    fishhomingtool_awesome_thanks = {
        base_prefab = "fishhomingtool_awesome",
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,

        skin_id = "627f66c0c340bf24ab311783",
        onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/fishhomingtool_awesome_thanks.zip")
		},
        image = { name = nil, atlas = nil, setable = true },

        string = ischinese and { name = "云烟" } or { name = "YunYan" },

        anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        fn_start = function(inst)
            inst.components.bundlemaker:SetSkinData("fishhomingbait_thanks", nil)
        end,
        equip = { symbol = "swap_object", build = "fishhomingtool_awesome_thanks", file = "swap" },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
    },
    fishhomingtool_normal_thanks = {
        base_prefab = "fishhomingtool_normal",
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,

        skin_id = "627f66c0c340bf24ab311783",
        noshopshow = true,
		assets = {
			Asset("ANIM", "anim/skin/fishhomingtool_normal_thanks.zip")
		},
        image = { name = nil, atlas = nil, setable = true },

        string = {
            name = ischinese and "云烟草" or "YunYan Cigarette"
        },

        anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        fn_start = function(inst)
            inst.components.bundlemaker:SetSkinData("fishhomingbait_thanks", nil)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
    },
    fishhomingbait_thanks = {
        base_prefab = "fishhomingbait",
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,

        skin_id = "627f66c0c340bf24ab311783",
        noshopshow = true,
		assets = {
            Asset("ANIM", "anim/pollen_chum.zip"), --官方藤壶花粉动画
			Asset("ANIM", "anim/skin/fishhomingbait_thanks.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/fishhomingbait1_thanks.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/fishhomingbait1_thanks.tex"),
            Asset("ATLAS", "images/inventoryimages_skin/fishhomingbait2_thanks.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/fishhomingbait2_thanks.tex"),
            Asset("ATLAS", "images/inventoryimages_skin/fishhomingbait3_thanks.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/fishhomingbait3_thanks.tex"),
		},
        image = { name = nil, atlas = nil, setable = false }, --皮肤展示需要一个同prefab名的图片

        string = {
            name = ischinese and "云烟瓶" or "YunYan Bottle"
        },

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
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
    },

    shield_l_log_emo_pride = {
        base_prefab = "shield_l_log",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityFree,

        skin_id = "notnononl",
		assets = {
			Asset("ANIM", "anim/skin/shield_l_log_emo_pride.zip"),
		},
		image = { name = nil, atlas = nil, setable = true },

        string = ischinese and { name = "爱上彩虹" } or { name = "Love Rainbow" },

        anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = {
            symbol = "lantern_overlay", build = "shield_l_log_emo_pride", file = "swap_shield"
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.7 },
        floater = {
            cut = nil, size = "small", offset_y = 0.2, scale = 0.9, nofx = nil,
        },

        fn_start = function(inst)
            FxInit(inst, {"fx_ranimbowspark"}, -10)
        end,
        fn_end = FxClear
    },
    shield_l_log_emo_fist = {
        base_prefab = "shield_l_log",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "629b0d278c2f781db2f77ef8",
        onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/shield_l_log_emo_fist.zip"),
		},
		image = { name = nil, atlas = nil, setable = true },

        string = ischinese and { name = "重拳出击" } or { name = "Punch Quest" },

        anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = {
            symbol = "lantern_overlay", build = "shield_l_log_emo_fist", file = "swap_shield"
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.6 },
        floater = {
            cut = nil, size = "small", offset_y = 0.2, scale = 0.8, nofx = nil,
        },
    },
    shield_l_log_era = {
        base_prefab = "shield_l_log",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "629b0d088c2f781db2f77ef4",
        onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/shield_l_log_era.zip"),
		},
		image = { name = nil, atlas = nil, setable = true },

        string = ischinese and { name = "洋流之下匍匐" } or { name = "Under Current Crawl" },

        anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = {
            symbol = "lantern_overlay", build = "shield_l_log_era", file = "swap_shield"
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.7 },
        floater = {
            cut = nil, size = "small", offset_y = 0.2, scale = 0.8, nofx = nil,
        },
    },

    shield_l_sand_era = {
        base_prefab = "shield_l_sand",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "62845917c340bf24ab311969",
        onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/shield_l_sand_era.zip"),
		},
		image = { name = nil, atlas = nil, setable = true },

        string = ischinese and { name = "坚硬头骨低鸣" } or { name = "Squealing Skull" },

        anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = {
            symbol = "lantern_overlay", build = "shield_l_sand_era", file = "swap_shield"
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
    },
    shield_l_sand_op = {
        base_prefab = "shield_l_sand",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityFree,

        skin_id = "notnononl",
		assets = {
			Asset("ANIM", "anim/skin/shield_l_sand_op.zip"),
		},
		image = { name = nil, atlas = nil, setable = true },

        string = ischinese and { name = "旧稿" } or { name = "Old Art" },

        anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = {
            symbol = "lantern_overlay", build = "shield_l_sand_op", file = "swap_shield"
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
    },

    agronssword_taste = {
        base_prefab = "agronssword",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "637f66d88c2f781db2f7f2d0",
        onlyownedshow = true,
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
        base_prefab = "icire_rock",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "6280d4f2c340bf24ab3118b1",
        onlyownedshow = true,
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
            Asset("IMAGE", "images/inventoryimages_skin/icire_rock5_era.tex"),
		},
		image = { name = nil, atlas = nil, setable = false, },

        string = ischinese and { name = "被封存的窸窣" } or { name = "Sealed Rustle" },

		fn_start = function(inst)
            inst.AnimState:SetBank("heat_rock")
            inst.AnimState:SetBuild("heat_rock")
            inst.AnimState:OverrideSymbol("rock", "icire_rock_era", "rock")
            inst.AnimState:OverrideSymbol("shadow", "icire_rock_era", "shadow")

            inst._dd = { img_pst = "_era", canbloom = true }
            inst.fn_temp(inst)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
    },
    icire_rock_collector = {
        base_prefab = "icire_rock",
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,

        skin_id = "62df65b58c2f781db2f7998a",
        onlyownedshow = true, mustonwedshow = true,
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
            Asset("IMAGE", "images/inventoryimages_skin/icire_rock5_collector.tex"),
		},
		image = { name = nil, atlas = nil, setable = false, },

        string = ischinese and { name = "占星石" } or { name = "Astrological Stone" },

		fn_start = function(inst)
            inst.AnimState:SetBank("icire_rock_collector")
            inst.AnimState:SetBuild("icire_rock_collector")
            inst.AnimState:ClearOverrideSymbol("rock")
            inst.AnimState:ClearOverrideSymbol("shadow")

            inst._dd = { img_pst = "_collector", canbloom = true }
            inst.fn_temp(inst)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
    },
    icire_rock_day = {
        base_prefab = "icire_rock",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "6380cbb88c2f781db2f7f400",
        onlyownedshow = true,
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
            Asset("IMAGE", "images/inventoryimages_skin/icire_rock5_day.tex"),
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
        base_prefab = "lilybush",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "629b0d5f8c2f781db2f77f0d",
        onlyownedshow = true,
		assets = {
            Asset("ANIM", "anim/berrybush2.zip"), --官方浆果丛动画
			Asset("ANIM", "anim/skin/lilybush_era.zip"),
		},

        string = ischinese and { name = "满布大地婆娑" } or { name = "Platycerium Bush" },

		fn_start = function(inst)
            inst.AnimState:SetBank("berrybush2")
            inst.AnimState:SetBuild("lilybush_era")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        linkedskins = { lileaves = "lileaves_era" },
        placer = {
            name = nil, bank = "berrybush2", build = "lilybush_era", anim = "dead",
            prefabs = { "dug_lilybush", "cutted_lilybush" },
        }
    },
    lileaves_era = {
        base_prefab = "lileaves",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "629b0d5f8c2f781db2f77f0d",
        noshopshow = true,
		assets = {
			Asset("ANIM", "anim/skin/lileaves_era.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/foliageath_lileaves_era.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/foliageath_lileaves_era.tex"),
		},
        image = { name = nil, atlas = nil, setable = true },

        string = {
            name = ischinese and "花叶婆娑" or "Platycerium Leaves"
        },

		anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = {
            symbol = "swap_object", build = "lileaves_era", file = "swap_object"
        },
        scabbard = {
            anim = "idle_cover", isloop = nil, bank = "lileaves_era", build = "lileaves_era",
            image = "foliageath_lileaves_era", atlas = "images/inventoryimages_skin/foliageath_lileaves_era.xml",
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = 0.05, size = "small", offset_y = 0.15, scale = 0.5, nofx = nil,
        },
    },

    triplegoldenshovelaxe_era = {
        base_prefab = "triplegoldenshovelaxe",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "629b0d848c2f781db2f77f11",
        onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/triplegoldenshovelaxe_era.zip"),
		},
        image = { name = nil, atlas = nil, setable = true },

        string = ischinese and { name = "长河探索叮咚" } or { name = "Era River Explorer" },

		anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = {
            symbol = "swap_object", build = "triplegoldenshovelaxe_era", file = "swap"
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = nil, size = "med", offset_y = 0.15, scale = 0.4, nofx = nil
        },
    },
    tripleshovelaxe_era = {
        base_prefab = "tripleshovelaxe",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "629b0d848c2f781db2f77f11",
        noshopshow = true,
		assets = {
			Asset("ANIM", "anim/skin/tripleshovelaxe_era.zip"),
		},
        image = { name = nil, atlas = nil, setable = true },

        string = {
            name = ischinese and "谷地发现叮咚" or "Era Valley Explorer"
        },

		anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = {
            symbol = "swap_object", build = "tripleshovelaxe_era", file = "swap"
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = nil, size = "med", offset_y = 0.15, scale = 0.4, nofx = nil
        },
    },

    backcub_fans = {
        base_prefab = "backcub",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityFree,

        skin_id = "629cca398c2f781db2f78092",
        onlyownedshow = true, mustonwedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/backcub_fans.zip"),
		},
		image = { name = nil, atlas = nil, setable = true },

        string = ischinese and { name = "饭仔" } or { name = "Kid Fan" },

		anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = { symbol = "swap_body", build = "backcub_fans", file = "swap_body" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = nil, size = "med", offset_y = 0.1, scale = 1.1, nofx = nil,
        },
    },
    backcub_thanks = {
        base_prefab = "backcub",
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,

        skin_id = "62f235928c2f781db2f7a2dd",
        onlyownedshow = true,
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
        base_prefab = "backcub",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityFree,

        skin_id = "6309c6e88c2f781db2f7ae20",
        onlyownedshow = true, mustonwedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/backcub_fans2.zip"),
            Asset("ANIM", "anim/skin/ui_backcub_fans2_2x6.zip"),
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
            inst.replica.container:Close()
            inst.replica.container:WidgetSetup("backcub_fans2")
        end,
        fn_end_c = function(inst)
            inst.replica.container:Close()
            inst.replica.container:WidgetSetup("backcub")
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
        base_prefab = "rosebush",
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,

        skin_id = "62e3c3a98c2f781db2f79abc",
        onlyownedshow = true,
		assets = {
            Asset("ANIM", "anim/berrybush.zip"), --官方浆果丛动画
			Asset("ANIM", "anim/skin/rosebush_collector.zip"),
		},

        string = ischinese and { name = "朽星棘" } or { name = "Star Blighted Thorns" },

		fn_start = function(inst)
            --官方代码写得挺好，直接改动画模板居然能继承已有的动画播放和symbol切换状态
            inst.AnimState:SetBank("berrybush")
            inst.AnimState:SetBuild("rosebush_collector")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        linkedskins = { rosorns = "rosorns_collector" },
        placer = {
            name = nil, bank = "berrybush", build = "rosebush_collector", anim = "dead",
            prefabs = { "dug_rosebush", "cutted_rosebush" },
        },
    },
    rosorns_collector = {
        base_prefab = "rosorns",
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,

        skin_id = "62e3c3a98c2f781db2f79abc",
        noshopshow = true,
		assets = {
			Asset("ANIM", "anim/skin/rosorns_collector.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/foliageath_rosorns_collector.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/foliageath_rosorns_collector.tex"),
		},
        image = { name = nil, atlas = nil, setable = true },

        string = {
            name = ischinese and "贯星剑" or "Star Pierced Sword"
        },

		anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = true, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = {
            symbol = "swap_object", build = "rosorns_collector", file = "swap_object"
        },
        fn_onAttack = function(inst, owner, target)
            local fx = SpawnPrefab("rosorns_collector_fx")
            if fx ~= nil then
                fx.Transform:SetPosition(target.Transform:GetWorldPosition())
            end
        end,
        scabbard = {
            anim = "idle_cover", isloop = true, bank = "rosorns_collector", build = "rosorns_collector",
            image = "foliageath_rosorns_collector", atlas = "images/inventoryimages_skin/foliageath_rosorns_collector.xml",
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            nofx = true
        }
    },

    fimbul_axe_collector = {
        base_prefab = "fimbul_axe",
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,

        skin_id = "62e775148c2f781db2f79ba1",
        onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/fimbul_axe_collector.zip")
		},
        image = { name = nil, atlas = nil, setable = true },

        string = ischinese and { name = "跃星杖" } or { name = "Star Leaping Staff" },

		anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = true, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = {
            symbol = "swap_object", build = "fimbul_axe_collector", file = "swap_base"
        },
        fn_onThrown = function(inst, owner, target)
            if owner:HasTag("player") then
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
            local x, y, z = target.Transform:GetWorldPosition()
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
        floater = {
            cut = 0.1, size = "med", offset_y = 0.3, scale = 0.4, nofx = nil
        },
    },

    siving_turn_collector = {
        base_prefab = "siving_turn",
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,

        skin_id = "62eb8b9e8c2f781db2f79d21",
        onlyownedshow = true, mustonwedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/siving_turn_collector.zip"),
		},
        image = { name = nil, atlas = nil, setable = false, },

        string = ischinese and { name = "转星移" } or { name = "Revolving Star" },

		fn_start = function(inst)
            Fn_siving_turn(inst, "siving_turn_collector", false)
            inst.components.genetrans.fxdata.unlockfx = "siving_turn_collector_unlock_fx"
        end,
        fn_fruit = function(genetrans)
            Fn_siving_turn_fruit(genetrans, "siving_turn_collector")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        fn_setBuildPlacer = function(inst)
            inst.AnimState:SetBank("siving_turn_collector")
            inst.AnimState:SetBuild("siving_turn_collector")
        end
    },

    siving_derivant_lvl0_thanks = {
        base_prefab = "siving_derivant_lvl0",
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,

        skin_id = "62eb6e0e8c2f781db2f79cc2",
        onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/siving_derivants_thanks.zip"),
            Asset("ANIM", "anim/skin/siving_derivant_lvl0_thanks.zip"), --为了swap-icon
		},

        string = ischinese and { name = "梨花开" } or { name = "Snowflake Pine" },

		fn_start = function(inst)
            inst.AnimState:SetBank("siving_derivants_thanks")
            inst.AnimState:SetBuild("siving_derivants_thanks")
            inst.AnimState:SetScale(1.3, 1.3)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        linkedskins = { down = nil, up = "siving_derivant_lvl1_thanks" },
        placer = {
            name = nil, bank = "siving_derivants_thanks", build = "siving_derivants_thanks", anim = "lvl0",
            prefabs = { "siving_derivant_item" },
        },
    },
    siving_derivant_lvl1_thanks = {
        base_prefab = "siving_derivant_lvl1",
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,

        skin_id = "62eb6e0e8c2f781db2f79cc2",
        noshopshow = true,
		assets = {
			Asset("ANIM", "anim/skin/siving_derivants_thanks.zip"),
		},

        string = {
            name = ischinese and "梨花开" or "Snowflake Pine"
        },

		fn_start = function(inst)
            inst.AnimState:SetBank("siving_derivants_thanks")
            inst.AnimState:SetBuild("siving_derivants_thanks")
            inst.AnimState:SetScale(1.3, 1.3)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        linkedskins = { down = "siving_derivant_lvl0_thanks", up = "siving_derivant_lvl2_thanks" }
    },
    siving_derivant_lvl2_thanks = {
        base_prefab = "siving_derivant_lvl2",
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,

        skin_id = "62eb6e0e8c2f781db2f79cc2",
        noshopshow = true,
		assets = {
			Asset("ANIM", "anim/skin/siving_derivants_thanks.zip"),
		},

        string = {
            name = ischinese and "梨花开" or "Snowflake Pine"
        },

		fn_start = function(inst)
            inst.AnimState:SetBank("siving_derivants_thanks")
            inst.AnimState:SetBuild("siving_derivants_thanks")
            inst.AnimState:SetScale(1.3, 1.3)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        linkedskins = { down = "siving_derivant_lvl1_thanks", up = "siving_derivant_lvl3_thanks" }
    },
    siving_derivant_lvl3_thanks = {
        base_prefab = "siving_derivant_lvl3",
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,

        skin_id = "62eb6e0e8c2f781db2f79cc2",
        noshopshow = true,
		assets = {
			Asset("ANIM", "anim/skin/siving_derivants_thanks.zip"),
		},

        string = {
            name = ischinese and "梨花开" or "Snowflake Pine"
        },

		fn_start = function(inst)
            inst.AnimState:SetBank("siving_derivants_thanks")
            inst.AnimState:SetBuild("siving_derivants_thanks")
            inst.AnimState:SetScale(1.3, 1.3)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        linkedskins = { down = "siving_derivant_lvl2_thanks", up = nil }
    },
    siving_derivant_lvl0_thanks2 = {
        base_prefab = "siving_derivant_lvl0",
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,

        skin_id = "62eb6e0e8c2f781db2f79cc2",
        noshopshow = true,
		assets = {
			Asset("ANIM", "anim/skin/siving_derivants_thanks2.zip"),
		},

        string = {
            name = ischinese and "梨带雨" or "Snowflake Prayer Pine"
        },

		fn_start = function(inst)
            inst.AnimState:SetBank("siving_derivants_thanks2")
            inst.AnimState:SetBuild("siving_derivants_thanks2")
            inst.AnimState:SetScale(1.3, 1.3)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        linkedskins = { down = nil, up = "siving_derivant_lvl1_thanks2" },
        placer = {
            name = nil, bank = "siving_derivants_thanks2", build = "siving_derivants_thanks2", anim = "lvl0",
            prefabs = { "siving_derivant_item" },
        },
    },
    siving_derivant_lvl1_thanks2 = {
        base_prefab = "siving_derivant_lvl1",
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,

        skin_id = "62eb6e0e8c2f781db2f79cc2",
        noshopshow = true,
		assets = {
			Asset("ANIM", "anim/skin/siving_derivants_thanks2.zip"),
		},

        string = {
            name = ischinese and "梨带雨" or "Snowflake Prayer Pine"
        },

		fn_start = function(inst)
            inst.AnimState:SetBank("siving_derivants_thanks2")
            inst.AnimState:SetBuild("siving_derivants_thanks2")
            inst.AnimState:SetScale(1.3, 1.3)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        linkedskins = { down = "siving_derivant_lvl0_thanks2", up = "siving_derivant_lvl2_thanks2" }
    },
    siving_derivant_lvl2_thanks2 = {
        base_prefab = "siving_derivant_lvl2",
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,

        skin_id = "62eb6e0e8c2f781db2f79cc2",
        noshopshow = true,
		assets = {
			Asset("ANIM", "anim/skin/siving_derivants_thanks2.zip"),
		},

        string = {
            name = ischinese and "梨带雨" or "Snowflake Prayer Pine"
        },

		fn_start = function(inst)
            inst.AnimState:SetBank("siving_derivants_thanks2")
            inst.AnimState:SetBuild("siving_derivants_thanks2")
            inst.AnimState:SetScale(1.3, 1.3)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        linkedskins = { down = "siving_derivant_lvl1_thanks2", up = "siving_derivant_lvl3_thanks2" }
    },
    siving_derivant_lvl3_thanks2 = {
        base_prefab = "siving_derivant_lvl3",
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,

        skin_id = "62eb6e0e8c2f781db2f79cc2",
        noshopshow = true,
		assets = {
			Asset("ANIM", "anim/skin/siving_derivants_thanks2.zip"),
		},

        string = {
            name = ischinese and "梨带雨" or "Snowflake Prayer Pine"
        },

		fn_start = function(inst)
            inst.AnimState:SetBank("siving_derivants_thanks2")
            inst.AnimState:SetBuild("siving_derivants_thanks2")
            inst.AnimState:SetScale(1.3, 1.3)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        linkedskins = { down = "siving_derivant_lvl2_thanks2", up = nil }
    },

    carpet_whitewood_law = {
        base_prefab = "carpet_whitewood",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "63805cf58c2f781db2f7f34b",
        onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/carpet_whitewood_law.zip")
		},
        image = { name = nil, atlas = nil, setable = false },

        string = ischinese and { name = "小西洋棋棋盘" } or { name = "Quarter Chessboard" },

        anim = {
            bank = "carpet_whitewood_law", build = "carpet_whitewood_law",
            anim = "idle", isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        fn_setBuildPlacer = function(inst)
            inst.AnimState:SetBank("carpet_whitewood_law")
            inst.AnimState:SetBuild("carpet_whitewood_law")
        end
    },
    carpet_whitewood_big_law = {
        base_prefab = "carpet_whitewood_big",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "63805cf58c2f781db2f7f34b",
        noshopshow = true,
		assets = {
			Asset("ANIM", "anim/skin/carpet_whitewood_law.zip")
		},
        image = { name = nil, atlas = nil, setable = false },

        string = ischinese and { name = "西洋棋棋盘" } or { name = "Chessboard" },

        anim = {
            bank = "carpet_whitewood_law", build = "carpet_whitewood_law",
            anim = "idle_big", isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true
        },
        fn_start = function(inst)
            inst.AnimState:SetScale(1.08, 1.08, 1.08)
        end,
        fn_end = function(inst)
            inst.AnimState:SetScale(1, 1, 1)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        fn_setBuildPlacer = function(inst)
            inst.AnimState:SetBank("carpet_whitewood_law")
            inst.AnimState:SetBuild("carpet_whitewood_law")
            inst.AnimState:SetScale(1.08, 1.08, 1.08)
        end
    },
    carpet_whitewood_law2 = {
        base_prefab = "carpet_whitewood",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "63805d098c2f781db2f7f34f",
        onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/carpet_whitewood_law2.zip")
		},
        image = { name = nil, atlas = nil, setable = false },

        string = ischinese and { name = "小西洋棋黑棋盘" } or { name = "Quarter Black Chessboard" },

        anim = {
            bank = "carpet_whitewood_law2", build = "carpet_whitewood_law2",
            anim = "idle", isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        fn_setBuildPlacer = function(inst)
            inst.AnimState:SetBank("carpet_whitewood_law2")
            inst.AnimState:SetBuild("carpet_whitewood_law2")
        end
    },
    carpet_whitewood_big_law2 = {
        base_prefab = "carpet_whitewood_big",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "63805d098c2f781db2f7f34f",
        noshopshow = true,
		assets = {
			Asset("ANIM", "anim/skin/carpet_whitewood_law2.zip")
		},
        image = { name = nil, atlas = nil, setable = false },

        string = ischinese and { name = "西洋棋黑棋盘" } or { name = "Black Chessboard" },

        anim = {
            bank = "carpet_whitewood_law2", build = "carpet_whitewood_law2",
            anim = "idle_big", isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true
        },
        fn_start = function(inst)
            inst.AnimState:SetScale(1.08, 1.08, 1.08)
        end,
        fn_end = function(inst)
            inst.AnimState:SetScale(1, 1, 1)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        fn_setBuildPlacer = function(inst)
            inst.AnimState:SetBank("carpet_whitewood_law2")
            inst.AnimState:SetBuild("carpet_whitewood_law2")
            inst.AnimState:SetScale(1.08, 1.08, 1.08)
        end
    },

    soul_contracts_taste = {
        base_prefab = "soul_contracts",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "638074368c2f781db2f7f374",
        onlyownedshow = true,
		assets = {
            -- Asset("ANIM", "anim/book_maxwell.zip"), --官方暗影秘典动画模板
			Asset("ANIM", "anim/skin/soul_contracts_taste.zip"),
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
        base_prefab = "siving_feather_real",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "6387156a8c2f781db2f7f670",
        onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/siving_feather_real_paper.zip")
		},
        image = { name = nil, atlas = nil, setable = true },

        string = ischinese and { name = "十字纸镖" } or { name = "Cross Paper Dart" },

		anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true
        },
        equip = {
            symbol = "lantern_overlay", build = "siving_feather_real_paper", file = "swap",
            isshield = true
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.04, size = "small", offset_y = 0.2, scale = 0.5, nofx = nil }
    },
    siving_feather_fake_paper = {
        base_prefab = "siving_feather_fake",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "6387156a8c2f781db2f7f670",
        noshopshow = true,
		assets = {
			Asset("ANIM", "anim/skin/siving_feather_fake_paper.zip")
		},
        image = { name = nil, atlas = nil, setable = true },

        string = ischinese and { name = "四方纸镖" } or { name = "Square Paper Dart" },

		anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true
        },
        equip = {
            symbol = "lantern_overlay", build = "siving_feather_fake_paper", file = "swap",
            isshield = true
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.04, size = "small", offset_y = 0.2, scale = 0.5, nofx = nil }
    },

    revolvedmoonlight_item_taste = { --芒果
        base_prefab = "revolvedmoonlight_item",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "63889eaf8c2f781db2f7f763",
        onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/revolvedmoonlight_item_taste.zip")
		},
        image = { name = nil, atlas = nil, setable = true },

        string = ischinese and { name = "芒果甜筒" } or { name = "Mango Cone" },

		anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        linkedskins = { item = "revolvedmoonlight_taste", item_pro = "revolvedmoonlight_pro_taste" },
        floater = { cut = 0.18, size = "small", offset_y = 0.4, scale = 0.55, nofx = nil }
    },
    revolvedmoonlight_taste = {
        base_prefab = "revolvedmoonlight",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "63889eaf8c2f781db2f7f763",
        noshopshow = true,
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
            inst.replica.container:Close()
            inst.replica.container:WidgetSetup("revolvedmoonlight_taste")
        end,
        fn_end_c = function(inst)
            inst.replica.container:Close()
            inst.replica.container:WidgetSetup("revolvedmoonlight")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        linkedskins = { item = "revolvedmoonlight_item_taste" },
        floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil }
    },
    revolvedmoonlight_pro_taste = {
        base_prefab = "revolvedmoonlight_pro",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "63889eaf8c2f781db2f7f763",
        noshopshow = true,
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
            inst.replica.container:Close()
            inst.replica.container:WidgetSetup("revolvedmoonlight_pro_taste")
        end,
        fn_end_c = function(inst)
            inst.replica.container:Close()
            inst.replica.container:WidgetSetup("revolvedmoonlight_pro")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        linkedskins = { item = "revolvedmoonlight_item_taste" },
        floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil }
    },

    revolvedmoonlight_item_taste2 = { --草莓
        base_prefab = "revolvedmoonlight_item",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "63889ecd8c2f781db2f7f768",
        onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/revolvedmoonlight_item_taste2.zip")
		},
        image = { name = nil, atlas = nil, setable = true },

        string = ischinese and { name = "草莓甜筒" } or { name = "Strawberry Cone" },

		anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        linkedskins = { item = "revolvedmoonlight_taste2", item_pro = "revolvedmoonlight_pro_taste2" },
        floater = { cut = 0.18, size = "small", offset_y = 0.4, scale = 0.55, nofx = nil }
    },
    revolvedmoonlight_taste2 = {
        base_prefab = "revolvedmoonlight",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "63889ecd8c2f781db2f7f768",
        noshopshow = true,
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
            inst.replica.container:Close()
            inst.replica.container:WidgetSetup("revolvedmoonlight_taste2")
        end,
        fn_end_c = function(inst)
            inst.replica.container:Close()
            inst.replica.container:WidgetSetup("revolvedmoonlight")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        linkedskins = { item = "revolvedmoonlight_item_taste2" },
        floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil }
    },
    revolvedmoonlight_pro_taste2 = {
        base_prefab = "revolvedmoonlight_pro",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "63889ecd8c2f781db2f7f768",
        noshopshow = true,
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
            inst.replica.container:Close()
            inst.replica.container:WidgetSetup("revolvedmoonlight_pro_taste2")
        end,
        fn_end_c = function(inst)
            inst.replica.container:Close()
            inst.replica.container:WidgetSetup("revolvedmoonlight_pro")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        linkedskins = { item = "revolvedmoonlight_item_taste2" },
        floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil }
    },

    revolvedmoonlight_item_taste3 = { --柠檬
        base_prefab = "revolvedmoonlight_item",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "63889eef8c2f781db2f7f76c",
        onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/revolvedmoonlight_item_taste3.zip")
		},
        image = { name = nil, atlas = nil, setable = true },

        string = ischinese and { name = "柠檬甜筒" } or { name = "Lemon Cone" },

		anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        linkedskins = { item = "revolvedmoonlight_taste3", item_pro = "revolvedmoonlight_pro_taste3" },
        floater = { cut = 0.18, size = "small", offset_y = 0.4, scale = 0.55, nofx = nil }
    },
    revolvedmoonlight_taste3 = {
        base_prefab = "revolvedmoonlight",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "63889eef8c2f781db2f7f76c",
        noshopshow = true,
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
            inst.replica.container:Close()
            inst.replica.container:WidgetSetup("revolvedmoonlight_taste3")
        end,
        fn_end_c = function(inst)
            inst.replica.container:Close()
            inst.replica.container:WidgetSetup("revolvedmoonlight")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        linkedskins = { item = "revolvedmoonlight_item_taste3" },
        floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil }
    },
    revolvedmoonlight_pro_taste3 = {
        base_prefab = "revolvedmoonlight_pro",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "63889eef8c2f781db2f7f76c",
        noshopshow = true,
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
            inst.replica.container:Close()
            inst.replica.container:WidgetSetup("revolvedmoonlight_pro_taste3")
        end,
        fn_end_c = function(inst)
            inst.replica.container:Close()
            inst.replica.container:WidgetSetup("revolvedmoonlight_pro")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        linkedskins = { item = "revolvedmoonlight_item_taste3" },
        floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil }
    },

    revolvedmoonlight_item_taste4 = { --黑巧
        base_prefab = "revolvedmoonlight_item",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "63889f4b8c2f781db2f7f770",
        onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/revolvedmoonlight_item_taste4.zip")
		},
        image = { name = nil, atlas = nil, setable = true },

        string = ischinese and { name = "黑巧甜筒" } or { name = "Choccy Cone" },

		anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        linkedskins = { item = "revolvedmoonlight_taste4", item_pro = "revolvedmoonlight_pro_taste4" },
        floater = { cut = 0.18, size = "small", offset_y = 0.4, scale = 0.55, nofx = nil }
    },
    revolvedmoonlight_taste4 = {
        base_prefab = "revolvedmoonlight",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "63889f4b8c2f781db2f7f770",
        noshopshow = true,
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
            inst.replica.container:Close()
            inst.replica.container:WidgetSetup("revolvedmoonlight_taste4")
        end,
        fn_end_c = function(inst)
            inst.replica.container:Close()
            inst.replica.container:WidgetSetup("revolvedmoonlight")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        linkedskins = { item = "revolvedmoonlight_item_taste4" },
        floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil }
    },
    revolvedmoonlight_pro_taste4 = {
        base_prefab = "revolvedmoonlight_pro",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "63889f4b8c2f781db2f7f770",
        noshopshow = true,
		assets = {
			Asset("ANIM", "anim/skin/revolvedmoonlight_pro_taste4.zip")
		},
        image = { name = nil, atlas = nil, setable = true },

        string = ischinese and { name = "黑色旋涡" } or { name = "Choccy Sundae" },

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
            inst.replica.container:Close()
            inst.replica.container:WidgetSetup("revolvedmoonlight_pro_taste4")
        end,
        fn_end_c = function(inst)
            inst.replica.container:Close()
            inst.replica.container:WidgetSetup("revolvedmoonlight_pro")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        linkedskins = { item = "revolvedmoonlight_item_taste4" },
        floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil }
    },
}

_G.SKIN_IDS_LEGION = {
    ["notnononl"] = {}, --免费皮肤全部装这里面，skin_id设置为"notnononl"就好了
    ["6278c409c340bf24ab311522"] = { --余生
        siving_derivant_lvl0_thanks = true, siving_derivant_lvl1_thanks = true, siving_derivant_lvl2_thanks = true, siving_derivant_lvl3_thanks = true,
        siving_derivant_lvl0_thanks2 = true, siving_derivant_lvl1_thanks2 = true, siving_derivant_lvl2_thanks2 = true, siving_derivant_lvl3_thanks2 = true,
        neverfade_thanks = true, neverfadebush_thanks = true, backcub_thanks = true,
        fishhomingtool_awesome_thanks = true, fishhomingtool_normal_thanks = true, fishhomingbait_thanks = true,
        triplegoldenshovelaxe_era = true, tripleshovelaxe_era = true, lilybush_era = true, lileaves_era = true, icire_rock_era = true, shield_l_log_era = true, shield_l_sand_era = true,
        orchidbush_disguiser = true, boltwingout_disguiser = true,
        rosebush_marble = true, lilybush_marble = true, orchidbush_marble = true, rosorns_marble = true, lileaves_marble = true, orchitwigs_marble = true,
        shield_l_log_emo_fist = true, hat_lichen_emo_que = true,
        rosebush_collector = true, rosorns_collector = true, fimbul_axe_collector = true, siving_turn_collector = true,
        backcub_fans2 = true,
        agronssword_taste = true, soul_contracts_taste = true,
        revolvedmoonlight_item_taste = true, revolvedmoonlight_taste = true, revolvedmoonlight_pro_taste = true,
        revolvedmoonlight_item_taste2 = true, revolvedmoonlight_taste2 = true, revolvedmoonlight_pro_taste2 = true,
        revolvedmoonlight_item_taste3 = true, revolvedmoonlight_taste3 = true, revolvedmoonlight_pro_taste3 = true,
        revolvedmoonlight_item_taste4 = true, revolvedmoonlight_taste4 = true, revolvedmoonlight_pro_taste4 = true,
        carpet_whitewood_law = true, carpet_whitewood_big_law = true, carpet_whitewood_law2 = true, carpet_whitewood_big_law2 = true,
        icire_rock_day = true,
        neverfade_paper = true, neverfadebush_paper = true, neverfade_paper2 = true, neverfadebush_paper2 = true, siving_feather_real_paper = true, siving_feather_fake_paper = true,
    },
    ["6278c450c340bf24ab311528"] = { --回忆(5)
        boltwingout_disguiser = true,
        rosebush_marble = true, lilybush_marble = true, orchidbush_marble = true,
        hat_lichen_emo_que = true,
    },
    ["62eb7b148c2f781db2f79cf8"] = { --花潮(6+3)
        rosebush_marble = true, lilybush_marble = true, orchidbush_marble = true, rosorns_marble = true, lileaves_marble = true, orchitwigs_marble = true,
        rosebush_collector = true, rosorns_collector = true,
        lilybush_era = true, lileaves_era = true,
        orchidbush_disguiser = true,
        shield_l_log_era = true, --这一个是多给的(当做花泥)
    },
    ["6278c487c340bf24ab31152c"] = { --1鸣惊人(7)
        neverfade_thanks = true, neverfadebush_thanks = true,
        orchidbush_disguiser = true, boltwingout_disguiser = true,
        rosebush_marble = true, lilybush_marble = true, orchidbush_marble = true,
        hat_lichen_emo_que = true,
    },
    ["6278c4acc340bf24ab311530"] = { --2度梅开(8)
        fishhomingtool_awesome_thanks = true, fishhomingtool_normal_thanks = true, fishhomingbait_thanks = true,
        triplegoldenshovelaxe_era = true, tripleshovelaxe_era = true, lilybush_era = true, lileaves_era = true, icire_rock_era = true, shield_l_log_era = true, shield_l_sand_era = true,
        shield_l_log_emo_fist = true,
        carpet_whitewood_law = true, carpet_whitewood_big_law = true
    },
    ["6278c4eec340bf24ab311534"] = { --3尺垂涎(9)
        rosebush_collector = true, rosorns_collector = true, fimbul_axe_collector = true,
        rosorns_marble = true, lileaves_marble = true, orchitwigs_marble = true,
        backcub_thanks = true,
        siving_derivant_lvl0_thanks = true, siving_derivant_lvl1_thanks = true, siving_derivant_lvl2_thanks = true, siving_derivant_lvl3_thanks = true,
        siving_derivant_lvl0_thanks2 = true, siving_derivant_lvl1_thanks2 = true, siving_derivant_lvl2_thanks2 = true, siving_derivant_lvl3_thanks2 = true,
        revolvedmoonlight_item_taste = true, revolvedmoonlight_taste = true, revolvedmoonlight_pro_taste = true,
        revolvedmoonlight_item_taste2 = true, revolvedmoonlight_taste2 = true, revolvedmoonlight_pro_taste2 = true
    },
    ["637f07a28c2f781db2f7f1e8"] = { --4海名扬(9)
        agronssword_taste = true, soul_contracts_taste = true,
        revolvedmoonlight_item_taste3 = true, revolvedmoonlight_taste3 = true, revolvedmoonlight_pro_taste3 = true,
        revolvedmoonlight_item_taste4 = true, revolvedmoonlight_taste4 = true, revolvedmoonlight_pro_taste4 = true,
        carpet_whitewood_law2 = true, carpet_whitewood_big_law2 = true,
        icire_rock_day = true,
        neverfade_paper = true, neverfadebush_paper = true, neverfade_paper2 = true, neverfadebush_paper2 = true, siving_feather_real_paper = true, siving_feather_fake_paper = true,
    },
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
    if anim.animpush ~= nil then
        anim.isloop_anim = nil
        if anim.isloop_animpush ~= true then
            anim.isloop_animpush = false
        end
    else
        anim.isloop_animpush = nil
        if anim.isloop_anim ~= true then
            anim.isloop_anim = false
        end
    end
end

------

local skinidxes = { --用以皮肤排序
    "neverfade_thanks", "neverfadebush_thanks",
    "siving_derivant_lvl0_thanks", "siving_derivant_lvl1_thanks", "siving_derivant_lvl2_thanks", "siving_derivant_lvl3_thanks",
    "siving_derivant_lvl0_thanks2", "siving_derivant_lvl1_thanks2", "siving_derivant_lvl2_thanks2", "siving_derivant_lvl3_thanks2",
    "backcub_thanks",
    "fishhomingtool_awesome_thanks", "fishhomingtool_normal_thanks", "fishhomingbait_thanks",
    "siving_turn_collector", "icire_rock_collector", "fimbul_axe_collector", "rosebush_collector", "rosorns_collector",
    "neverfade_paper", "neverfadebush_paper", "neverfade_paper2", "neverfadebush_paper2", "siving_feather_real_paper", "siving_feather_fake_paper",
    "icire_rock_day",
    "carpet_whitewood_law", "carpet_whitewood_big_law", "carpet_whitewood_law2", "carpet_whitewood_big_law2",
    "agronssword_taste", "soul_contracts_taste",
    "revolvedmoonlight_item_taste", "revolvedmoonlight_taste", "revolvedmoonlight_pro_taste",
    "revolvedmoonlight_item_taste2", "revolvedmoonlight_taste2", "revolvedmoonlight_pro_taste2",
    "revolvedmoonlight_item_taste3", "revolvedmoonlight_taste3", "revolvedmoonlight_pro_taste3",
    "revolvedmoonlight_item_taste4", "revolvedmoonlight_taste4", "revolvedmoonlight_pro_taste4",
    "triplegoldenshovelaxe_era", "tripleshovelaxe_era", "lilybush_era", "lileaves_era", "shield_l_log_era", "icire_rock_era", "shield_l_sand_era",
    "orchidbush_disguiser", "boltwingout_disguiser",
    "rosebush_marble", "rosorns_marble", "lilybush_marble", "lileaves_marble", "orchidbush_marble", "orchitwigs_marble",
    "shield_l_log_emo_fist", "hat_lichen_emo_que",

    "backcub_fans2", "backcub_fans",
    "shield_l_log_emo_pride", "shield_l_sand_op", "pinkstaff_tvplay",  "hat_cowboy_tvplay", "hat_lichen_disguiser", "orchitwigs_disguiser"
}
for i,skinname in pairs(skinidxes) do
    _G.SKIN_IDX_LEGION[i] = skinname
    _G.SKINS_LEGION[skinname].skin_idx = i
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
    if v.placer ~= nil then
        if v.placer.name == nil then
            v.placer.name = skinname.."_placer"
        end
        if v.anim ~= nil then
            if v.placer.bank == nil then
                v.placer.bank = v.anim.bank
            end
            if v.placer.build == nil then
                v.placer.build = v.anim.build
            end
            if v.placer.anim == nil then
                v.placer.anim = v.anim.anim
            end
        else
            if v.placer.bank == nil then
                v.placer.bank = skinname
            end
            if v.placer.build == nil then
                v.placer.build = skinname
            end
            if v.placer.anim == nil then
                v.placer.anim = "idle"
            end
        end
    end

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
    _G[baseprefab.."_clear_fn"] = function(inst) end --【服务端】给CreatePrefabSkin()用的
end
ischinese = nil

------资源补充
RegisterInventoryItemAtlas("images/inventoryimages_skin/agronssword_taste.xml", "agronssword_taste.tex")
RegisterInventoryItemAtlas("images/inventoryimages_skin/agronssword_taste2.xml", "agronssword_taste2.tex")

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
    if SKIN_IDS_LEGION.notnononl[skinname] then
        return true
    elseif userid ~= nil and SKINS_CACHE_L[userid] ~= nil and SKINS_CACHE_L[userid][skinname] then
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

--------------------------------------------------------------------------
--[[ 给玩家实体增加已有皮肤获取与管理机制
    Tip：
        TheNet:GetIsMasterSimulation()  --是否为服务器世界(主机+云服)
        TheNet:GetIsServer()            --是否为主机世界(玩家本地电脑开的，既跑进程，也要运行ui)
        TheNet:IsDedicated()            --是否为云服世界(只跑进程，不运行ui)
        TheShard:IsSecondary()          --是否为副世界(所以，not TheShard:IsSecondary() 就能确定是主世界了)
        TheShard:GetShardId()           --获取当前世界的ID

        世界分为3种
            1、主世界(运行主服务器代码，与客户端通信)、
            2、副世界(运行副服务器代码，与客户端通信)、
            3、客户端世界(运行客户端代码，与当前所处的服务器世界通信)
        例如，1个玩家用本地电脑开无洞穴存档，则世界有主世界(与房主客户端世界是同一个)、客户端(其他玩家的各有一个)。
            开了含洞穴的本地存档或云服存档，则世界有主世界(主机或云服)、洞穴世界(副世界)、客户端(所有玩家各有一个)
        modmain会在每个世界都加载一次

        TheWorld.ismastersim        --是否为服务器世界(主机+云服。本质上就是 TheNet:GetIsMasterSimulation())
        TheWorld.ismastershard      --是否为主世界(本质上就是 TheWorld.ismastersim and not TheShard:IsSecondary())
        TheNet:GetIsServer() or TheNet:IsDedicated() --是否为非客户端世界，这个是最精确的判定方式
        not TheNet:IsDedicated()    --这个方式也能判定客户端，但是无法排除客户端和服务端为一体的世界的情况
]]--
--------------------------------------------------------------------------

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
_G.SKINS_CACHE_EX_L = { --皮肤切换缓存
    -- Kxx_xxxx = { --用户ID
    --     prefab1 = { name = skinname1, placer = placername1 },
    --     prefab2 = { name = skinname2, placer = placername2 },
    -- },
}

local function SaveExSkin(userid, skin_name, skin_data, skin_data_old)
    if userid == nil then
        return
    end

    local caches = SKINS_CACHE_EX_L[userid]
    if caches == nil then
        SKINS_CACHE_EX_L[userid] = {}
        caches = SKINS_CACHE_EX_L[userid]
    else
        --先把以前的清除了
        if
            skin_data_old ~= nil and skin_data_old.placer ~= nil and skin_data_old.placer.prefabs ~= nil
        then
            for _,v in pairs(skin_data_old.placer.prefabs) do
                caches[v] = nil
            end
        end
    end

    --再更新目前的
    if
        skin_name ~= nil and
        skin_data ~= nil and skin_data.placer ~= nil and skin_data.placer.prefabs ~= nil
    then
        for _,v in pairs(skin_data.placer.prefabs) do
            caches[v] = {
                name = skin_name,
                placer = skin_data.placer.name
            }
        end
    end
end

local GetLegionSkins = nil
local DoLegionCdk = nil
if IsServer then
    --不想麻烦地写在世界里了，换个方式
    -- AddPrefabPostInit("shard_network", function(inst) --这个prefab只存在于服务器世界里（且只能存在一个）
    --     inst:AddComponent("shard_skin_legion")
    -- end)

    local function CheckSkinOwnedReward(skins)
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
                            (skins["siving_derivant_lvl0_thanks"] and 0.5 or 0) +
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
        if not skins["backcub_fans2"] then
            for skinname,_ in pairs(SKIN_IDS_LEGION["6278c487c340bf24ab31152c"]) do
                if not skins[skinname] then
                    return
                end
            end
            for skinname,_ in pairs(SKIN_IDS_LEGION["6278c4acc340bf24ab311530"]) do
                if not skins[skinname] then
                    return
                end
            end
            for skinname,_ in pairs(SKIN_IDS_LEGION["6278c4eec340bf24ab311534"]) do
                if not skins[skinname] then
                    return
                end
            end
            skins["backcub_fans2"] = true
        end
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
                if isSuccessful and string.len(result_json) > 1 and resultCode == 200 then
                    local status, data = pcall( function() return json.decode(result_json) end )
                    -- print("------------skined: ", tostring(result_json))
                    if not status then
                        print("["..fnname.."] Faild to parse quest json for "
                            ..tostring(user_id).."! ", tostring(status)
                        )
                        state.loadtag = -1
                    else
                        fns.handle(state, user_id, data)
                    end
                else
                    state.loadtag = -1
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
                    return "https://fireleaves.cn/account/locakedSkin?mid=6041a52be3a3fb1f530b550a&id="..user_id
                end,
                handle = function(state, user_id, data)
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
                            CheckSkinOwnedReward(skins)
                        end
                    end
                    if skins ~= nil then --如果数据库皮肤为空，就不该把本地皮肤数据给直接清除
                        SKINS_CACHE_L[user_id] = skins
                    end
                    state.loadtag = 1
                    StopQueryTask(state)
                    if player ~= nil and player:IsValid() then --该给玩家客户端传数据了
                        FnRpc_s2c(user_id, 1, SKINS_CACHE_L[user_id])
                    end
                end,
                err = function(state, user_id, errcode)
                    --errcode==1：主动刷新太频繁
                    --errcode==2：自动刷新太频繁
                    --errcode==3：2次接口调用都失败了
                    --errcode==4：接口参数不对
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
                    if creator == nil or DoYouHaveSkin(skin, creator) then
                        prefab.components.skinedlegion:SetSkin(skin)
                    end
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
                        local skins = PREFAB_SKINS[target.prefab]
                        local skin_data_old = target.components.skinedlegion:GetSkinedData()

                        local skinname_new = nil
                        local skinweight = nil
                        local skinname_old = target.components.skinedlegion:GetSkin()
                        local skinweight_old = 0
                        if skinname_old ~= nil and SKINS_LEGION[skinname_old] ~= nil then
                            skinweight_old = SKINS_LEGION[skinname_old].skin_idx
                        end

                        if skins ~= nil then
                            for _,skinname in pairs(skins) do
                                if DoYouHaveSkin(skinname, doer.userid) then
                                    if SKINS_LEGION[skinname] ~= nil then
                                        local weight = SKINS_LEGION[skinname].skin_idx
                                        if weight > skinweight_old then
                                            if skinweight == nil or skinweight > weight then
                                                skinweight = weight
                                                skinname_new = skinname
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if skinname_new ~= skinname_old then
                            target.components.skinedlegion:SetSkin(skinname_new)

                            --交换记录
                            local skin_name = target.components.skinedlegion:GetSkin()
                            SaveExSkin(doer.userid, skin_name, target.components.skinedlegion:GetSkinedData(), skin_data_old)
                            FnRpc_s2c(doer.userid, 4, { new = skin_name, old = skinname_old })
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

    AddPlayerPostInit(function(inst)
        --还是让玩家实体存储自己的皮肤数据吧，免得网络问题导致皮肤没法用
        local OnSave_old = inst.OnSave
        local OnLoad_old = inst.OnLoad
        inst.OnSave = function(inst, data)
            if OnSave_old ~= nil then
                OnSave_old(inst, data)
            end

            if SKINS_CACHE_L[inst.userid] ~= nil then
                local skins = nil
                for skinname,v in pairs(SKINS_CACHE_L[inst.userid]) do
                    if skins == nil then
                        skins = {}
                    end
                    skins[skinname] = true
                end
                if skins ~= nil then
                    data.skins_legion = skins
                end
            end
            if SKINS_CACHE_EX_L[inst.userid] ~= nil then
                local skins = nil
                for prefabname,v in pairs(SKINS_CACHE_EX_L[inst.userid]) do
                    if v.name ~= nil and v.placer ~= nil then --目前只需要这几个数据
                        if skins == nil then
                            skins = {}
                        end
                        skins[prefabname] = {
                            name = v.name,
                            placer = v.placer
                        }
                    end
                end
                if skins ~= nil then
                    data.skins_ex_legion = skins
                end
            end
        end
        inst.OnLoad = function(inst, data)
            if OnLoad_old ~= nil then
                OnLoad_old(inst, data)
            end

            --先存下来，等服务器皮肤数据确认后才传给客户端
            if data ~= nil then
                if data.skins_legion ~= nil then
                    SKINS_CACHE_L[inst.userid] = data.skins_legion
                end
                if data.skins_ex_legion ~= nil then
                    local newdata = {}
                    for prefabname,v in pairs(data.skins_ex_legion) do
                        if v.name ~= nil and SKINS_LEGION[v.name] ~= nil then --检查皮肤完整性
                            newdata[prefabname] = v
                        end
                    end
                    SKINS_CACHE_EX_L[inst.userid] = newdata
                end
            end
        end

        --实体生成后，开始调取接口获取皮肤数据
        inst.task_skin_l = inst:DoTaskInTime(1.1, function()
            inst.task_skin_l = nil
            GetLegionSkins(inst, inst.userid, 0.5, false)

            if inst.userid ~= nil then --提前给玩家传输服务器的皮肤数据
                if SKINS_CACHE_L[inst.userid] ~= nil then
                    FnRpc_s2c(inst.userid, 1, SKINS_CACHE_L[inst.userid])
                end
                if SKINS_CACHE_EX_L[inst.userid] ~= nil then
                    FnRpc_s2c(inst.userid, 3, SKINS_CACHE_EX_L[inst.userid])
                end
            end
        end)
    end)
end

--------------------------------------------------------------------------
--[[ RPC使用讲解
    Tip:
        !!!所有参数建议弄成数字类型或者字符类型

        【客户端发送请求给服务器】SendModRPCToServer(GetModRPC("LegionSkined", "RefreshSkinData"), 参数2, 参数3, ...)
        【服务器监听与响应请求】
            AddModRPCHandler("LegionSkined", "RefreshSkinData", function(player, 参数2, ...) --第一个参数固定为发起请求的玩家
                --做你想做的
            end)

        【服务端发送请求给客户端】SendModRPCToClient(GetClientModRPC("LegionSkined", "RefreshSkinData"), 玩家ID, 参数2, 参数3, ...)
        --若 玩家ID 为table，则服务端会向table里的全部玩家ID都发送请求
        【客户端监听与响应请求】
            AddClientModRPCHandler("LegionSkined", "RefreshSkinData", function(参数2, ...) --通过 ThePlayer 确定客户端玩家
                --做你想做的
            end)
]]--
--------------------------------------------------------------------------

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
                    SKINS_CACHE_L[ThePlayer.userid] = result

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
                    SKINS_CACHE_EX_L[ThePlayer.userid] = result
                end
            end

        elseif handletype == 4 then --更新单个的客户端皮肤交换缓存
            if data and type(data) == "string" then
                local success, result = pcall(json.decode, data)
                if result and ThePlayer and ThePlayer.userid then
                    if result.new ~= nil or result.old ~= nil then
                        local skin_data = result.new ~= nil and SKINS_LEGION[result.new] or nil
                        local skin_data_old = result.old ~= nil and SKINS_LEGION[result.old] or nil
                        SaveExSkin(ThePlayer.userid, result.new, skin_data, skin_data_old)
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

if not TheNet:IsDedicated() then
    --离线模式不能有皮肤界面功能(因为离线模式下的klei账户ID与联网模式下的不一样)
    if TheNet:IsOnlineMode() and _G.CONFIGS_LEGION.LANGUAGES == "chinese" then
        -- local ImageButton = require "widgets/imagebutton"
        -- local PlayerAvatarPopup = require "widgets/playeravatarpopup"
        local PlayerInfoPopup = require "screens/playerinfopopupscreen"
        local TEMPLATES = require "widgets/templates"
        local SkinLegionDialog = require "widgets/skinlegiondialog"

        -- local right_root = nil
        -- AddClassPostConstruct("widgets/controls", function(self)
        --     right_root = self.right_root
        -- end)

        local MakeBG_old = PlayerInfoPopup.MakeBG
        PlayerInfoPopup.MakeBG = function(self, ...)
            MakeBG_old(self, ...)

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
                    -- local SkinLegionDialog = _G.require("widgets/skinlegiondialog") --test：动态更新
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
            self.skinshop_l_button:SetPosition(246, -260)
        end
    end
end

--------------------------------------------------------------------------
--[[ placer应用兼容皮肤的切换缓存 ]]
--------------------------------------------------------------------------

local inventoryitem_replica = require("components/inventoryitem_replica")

local GetDeployPlacerName_old = inventoryitem_replica.GetDeployPlacerName
inventoryitem_replica.GetDeployPlacerName = function(self, ...)
    local placerold = GetDeployPlacerName_old(self, ...)
    if placerold == "gridplacer" then
        return placerold
    end

    if ThePlayer and ThePlayer.userid and SKINS_CACHE_EX_L[ThePlayer.userid] ~= nil then
        local data = SKINS_CACHE_EX_L[ThePlayer.userid]
        if data[self.inst.prefab] ~= nil then
            return data[self.inst.prefab].placer or placerold
        end
    end

    return placerold
end

--------------------------------------------------------------------------
--[[ 建筑物placer兼容 ]]
--------------------------------------------------------------------------

--建筑的皮肤placer请看playercontroller.StartBuildPlacementMode
_G.Skined_SetBuildPlacer_legion = function(inst)
    if inst.components.placer ~= nil then
        local SetBuilder_old = inst.components.placer.SetBuilder
        inst.components.placer.SetBuilder = function(self, ...)
            SetBuilder_old(self, ...)
            if self.builder and self.builder.components.playercontroller ~= nil then
                --之所以把皮肤修改写到 SetBuilder 里，是因为 Skined_SetBuildPlacer_legion 执行时还没有皮肤数据
                local skin = self.builder.components.playercontroller.placer_recipe_skin
                if skin and SKINS_LEGION[skin] and SKINS_LEGION[skin].fn_setBuildPlacer then
                    SKINS_LEGION[skin].fn_setBuildPlacer(self.inst)
                end
            end
        end
    end
end
