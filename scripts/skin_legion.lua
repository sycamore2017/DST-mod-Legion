------skined_legion

local _G = GLOBAL
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()
local ischinese = TUNING.LEGION_MOD_LANGUAGES == "chinese"

table.insert(Assets, Asset("ATLAS", "images/icon_skinbar_shadow_l.xml"))
table.insert(Assets, Asset("IMAGE", "images/icon_skinbar_shadow_l.tex"))
table.insert(Assets, Asset("ANIM", "anim/images_minisign_skins1.zip"))
table.insert(PrefabFiles, "fx_ranimbowspark")
table.insert(PrefabFiles, "skinprefabs_legion")

--------------------------------------------------------------------------
--[[ 特效设置 ]]
--------------------------------------------------------------------------

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
        image = { name = nil, atlas = nil, setable = true, }, --提前注册，或者皮肤初始化使用

        anim = { --皮肤初始化使用
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        -- fn_anim = function(inst)end, --处于地面时的动画设置，替换anim的默认方式

        -- fn_start = function(inst)end, --应用皮肤时的函数
        -- fn_end = nil, --取消皮肤时的函数

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

    lileaves = {
        assets = nil,
        image = { name = nil, atlas = nil, setable = true, },
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
        image = { name = nil, atlas = nil, setable = true, },
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
        assets = nil,
        image = { name = nil, atlas = nil, setable = false, },
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
        },
    },
    neverfadebush = {
        assets = nil,
        fn_start = function(inst)
            inst.AnimState:SetBank("berrybush2")
            inst.AnimState:SetBuild("neverfadebush")
        end,
        exchangefx = { prefab = nil, offset_y = 0.9, scale = nil },
    },

    hat_lichen = {
        assets = nil,
        image = { name = nil, atlas = nil, setable = true, },
        anim = {
            bank = nil, build = nil,
            anim = "anim", isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = { symbol = "swap_hat", build = "hat_lichen", file = "swap_hat", isopenhat = true },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = 0.03, size = "med", offset_y = 0.2, scale = 0.5, nofx = nil,
        },
    },

    hat_cowboy = {
        assets = nil,
        image = { name = nil, atlas = nil, setable = true, },
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

    boltwingout = {
        assets = nil,
        image = { name = nil, atlas = nil, setable = true, },
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
        image = { name = nil, atlas = nil, setable = true, },
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
        image = { name = nil, atlas = nil, setable = true, },
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

            inst.changeimgfn = function(inst)
                local newname = "icire_rock"..tostring(inst.currentTempRange)
                inst.components.inventoryitem.atlasname = "images/inventoryimages/"..newname..".xml"
                inst.components.inventoryitem:ChangeImageName(newname)
            end
            inst.changeimgfn(inst)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
    },

    shield_l_log = {
        assets = nil,
        image = { name = nil, atlas = nil, setable = true, },
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
        image = { name = nil, atlas = nil, setable = true, },
        anim = {
            bank = "shield_l_sand", build = "shield_l_sand",
            anim = "idle", isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
        },
        equip = { symbol = nil, build = "shield_l_sand", file = "swap_shield" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
    },

    tripleshovelaxe = {
        assets = nil,
        image = { name = nil, atlas = nil, setable = true, },
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
        image = { name = nil, atlas = nil, setable = true, },
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
        image = { name = nil, atlas = nil, setable = true, },
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
        },
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
		image = { name = nil, atlas = nil, setable = true, }, --提前注册，或者皮肤初始化使用

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

        -- fn_start = function(inst)end, --应用皮肤时的函数
        -- fn_end = nil, --取消皮肤时的函数

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

        string = ischinese and {
            name = "理盛赤蔷", collection = "MARBLE", access = "DONATE",
            descitem = "解锁\"蔷薇花丛\"的皮肤。",
            description = "他和妻子辛苦半生，买下一个不知名庄园。庄园幽静，有些偏僻，但很快便被幸福浸满。他喜欢园艺，常和孩子一起用蔷薇等花束将庄园装点。好羡慕，曾经那么热闹非凡。他离世后，孩子卖掉庄园离开。好遗憾，只剩稀疏红蔷绽放证明着曾经的幸福。",
        } or {
            name = "Rose Marble Pot", collection = "MARBLE", access = "DONATE",
            descitem = "Unlock \"Rose Bush\" skin.",
            description = "The story was not translated.",
        },

		fn_start = function(inst)
            --官方代码写得挺好，直接改动画模板居然能继承已有的动画播放和symbol切换状态
            inst.AnimState:SetBank("berrybush")
            inst.AnimState:SetBuild("rosebush_marble")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        placer = {
            name = nil, bank = "berrybush", build = "rosebush_marble", anim = "dead",
            prefabs = { "dug_rosebush", "cutted_rosebush" },
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

        string = ischinese and {
            name = "理盛截莲", collection = "MARBLE", access = "DONATE",
            descitem = "解锁\"蹄莲花丛\"的皮肤。",
            description = "她和自己的\"孩子们\"被强制带到庄园。庄园幽静，非常偏僻，但很快变得喧闹不已，孩子们可喜欢这里了。照顾小孩的工作可不容易，也经常见她在水池边种小簇蹄莲。越种越多，喧闹声也逐渐不见踪影。感觉到自己命不久矣，她给自己也种了一簇。",
        } or {
            name = "Lily Marble Pot", collection = "MARBLE", access = "DONATE",
            descitem = "Unlock \"Lily Bush\" skin.",
            description = "The story was not translated.",
        },

		fn_start = function(inst)
            inst.AnimState:SetBank("berrybush")
            inst.AnimState:SetBuild("lilybush_marble")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        placer = {
            name = nil, bank = "berrybush", build = "lilybush_marble", anim = "dead",
            prefabs = { "dug_lilybush", "cutted_lilybush" },
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

        string = ischinese and {
            name = "理盛瀑兰", collection = "MARBLE", access = "DONATE",
            descitem = "解锁\"兰草花丛\"的皮肤。",
            description = "这庄园是最近令他欣喜的发现。庄园幽深，远离人烟，古典的大理石装潢，长满了各色花草，着实令这个隐居者着迷。他走遍庄园，看见了大厅的破烂玩具与黑板，卧室里发黄全家福，后山有长着兰草的墓碑。庄园无声述说着历史的变迁。",
        } or {
            name = "Orchid Marble Pot", collection = "MARBLE", access = "DONATE",
            descitem = "Unlock \"Orchid Bush\" skin.",
            description = "The story was not translated.",
        },

		fn_start = function(inst)
            inst.AnimState:SetBank("berrybush")
            inst.AnimState:SetBuild("orchidbush_marble")
        end,
        exchangefx = { prefab = nil, offset_y = 1.3, scale = nil },
        placer = {
            name = nil, bank = "berrybush", build = "orchidbush_marble", anim = "dead",
            prefabs = { "dug_orchidbush", "cutted_orchidbush" },
        },
    },

    orchitwigs_disguiser = {
        base_prefab = "orchitwigs",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityFree,

        skin_id = "freeskins", --61ff45880a30fc7fca0db5e5
		assets = {
			Asset("ANIM", "anim/skin/orchitwigs_disguiser.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/orchitwigs_disguiser.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/orchitwigs_disguiser.tex"),
            Asset("ATLAS", "images/inventoryimages_skin/foliageath_orchitwigs_disguiser.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/foliageath_orchitwigs_disguiser.tex"),
		},
        image = { name = nil, atlas = nil, setable = true, },

        string = ischinese and {
            name = "粉色追猎", collection = "DISGUISER", access = "FREE",
            descitem = "解锁\"兰草花穗\"以及入鞘后的皮肤。",
            description = "这片粉色花园是它的生活的点点滴滴。它打点自己的小天地，也借花谋生。它藏在自己的伪装里，招蜂引蝶，追猎而食。芸芸言它残勤劳心害美丽身，它无所顾忌，刹那间伸出死亡利爪又消失于粉脂。",
        } or {
            name = "Pink Orchitwigs", collection = "DISGUISER", access = "FREE",
            descitem = "Unlock \"Orchitwigs\" skin.",
            description = "The story was not translated.",
        },

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
            anim = "idle_cover", bank = "orchitwigs_disguiser", build = "orchitwigs_disguiser",
            image = "foliageath_orchitwigs_disguiser", atlas = "images/inventoryimages_skin/foliageath_orchitwigs_disguiser.xml",
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

        string = ischinese and {
            name = "粉色猎园", collection = "DISGUISER", access = "SPECIAL",
            descitem = "解锁\"兰草花丛\"的皮肤。",
            description = "猎人从不离开它的狩猎花园，毕竟这里有生活的点点滴滴。直至忽来风雨将猎人打落花枝，它不见踪迹。日月轮转，花开花落，它等了好久好久，始终不见猎人归来，它知道再也见不到那潇洒身影与狩猎姿态。\"猎人会回来的\"，它这样说道。",
        } or {
            name = "Pink Orchid Bush", collection = "DISGUISER", access = "SPECIAL",
            descitem = "Unlock \"Orchid Bush\" skin.",
            description = "The story was not translated.",
        },

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

    neverfade_thanks = {
        base_prefab = "neverfade",
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,

        skin_id = "6191d8f74c724c6f40e77ed0",
        onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/neverfade_thanks.zip"),
            Asset("ANIM", "anim/skin/neverfade_butterfly_thanks.zip"),
            Asset("ATLAS", "images/inventoryimages_skin/neverfade_thanks.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/neverfade_thanks.tex"),
            Asset("ATLAS", "images/inventoryimages_skin/neverfade_thanks_broken.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/neverfade_thanks_broken.tex"),
            Asset("ATLAS", "images/inventoryimages_skin/foliageath_neverfade_thanks.xml"),
            Asset("IMAGE", "images/inventoryimages_skin/foliageath_neverfade_thanks.tex"),
		},
        image = { name = nil, atlas = nil, setable = false, },

        string = ischinese and {
            name = "扶伤", collection = "THANKS", access = "SPECIAL",
            descitem = "解锁\"永不凋零\"、\"永不凋零花丛\"、\"庇佑蝴蝶\"以及入鞘后的皮肤。",
            description = "雌雄狂刀疯狂挥舞，招招致命。他手持青玉扶伤剑，欲以还击。刹时刀光四射青光蝶影，一刺一避一挥一转，双方都要使取命一击。最后，只见玉断剑折，有身影逍遥离去。恶徒终除，十年血案终有结果。",
        } or {
            name = "FuShang", collection = "THANKS", access = "SPECIAL",
            descitem = "Unlock \"Neverfade\", \"Neverfade Bush\", and \"Neverfade Butterfly\" skin.",
            description = "The story was not translated.",
        },

		anim = {
            bank = nil, build = nil,
            anim = nil, isloop_anim = nil, animpush = nil, isloop_animpush = nil,
            setable = true,
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
            anim = "idle_cover", bank = "neverfade_thanks", build = "neverfade_thanks",
            image = "foliageath_neverfade_thanks", atlas = "images/inventoryimages_skin/foliageath_neverfade_thanks.xml",
        },
        butterfly = { bank = "butterfly", build = "neverfade_butterfly_thanks" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = 0.05, size = "small", offset_y = 0.15, scale = 0.5, nofx = nil,
        },
        linkedskins = { bush = "neverfadebush_thanks" },
        placer = {
            name = nil, bank = "neverfadebush_thanks", build = "neverfadebush_thanks", anim = "dead", prefabs = nil,
        },
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
            name = ischinese and "扶伤剑冢" or "FuShang Tomb", collection = "THANKS", access = "SPECIAL",
        },

		fn_start = function(inst)
            inst.AnimState:SetBank("neverfadebush_thanks")
            inst.AnimState:SetBuild("neverfadebush_thanks")
        end,
        exchangefx = { prefab = nil, offset_y = 1.2, scale = nil },
        linkedskins = { sword = "neverfade_thanks", },
    },

    hat_lichen_emo_que = {
        base_prefab = "hat_lichen",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "61909c584c724c6f40e779fa",
		assets = {
			Asset("ANIM", "anim/skin/hat_lichen_emo_que.zip"),
		},
		image = { name = nil, atlas = nil, setable = true, },

        string = ischinese and {
            name = "\"困惑\"发卡", collection = "EMOTICON", access = "DONATE",
            descitem = "解锁\"苔衣发卡\"的皮肤。",
            description = "我有个疑问。不对，我为啥会有这个想法？就在我想提出问题时，心里就会有个阴影质疑我的问题：\"你提出这些问题难道不该想想是你自己的问题还是真的有问题\"。然后我又会问它，凭什么你这个问题觉得我的问题有问题！",
        } or {
            name = "Question Hairpin", collection = "EMOTICON", access = "DONATE",
            descitem = "Unlock \"Lichen Hairpin\" skin.",
            description = "The story was not translated.",
        },

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

        skin_id = "freeskins", --61f15bf4db102b0b8a529c66
		assets = {
			Asset("ANIM", "anim/skin/hat_lichen_disguiser.zip"),
		},
		image = { name = nil, atlas = nil, setable = true, },

        string = ischinese and {
            name = "深渊的星", collection = "DISGUISER", access = "FREE",
            descitem = "解锁\"苔衣发卡\"的皮肤。",
            description = "洋流之下，是暗流涌动的深渊。终年阴暗，这里的生物都渴望光明。偶尔会有忽闪忽闪的淡蓝色星光，小小鱼虾们前去追寻。越游越近，突现一张长满尖牙的恐怖大嘴一口咬了下来。",
        } or {
            name = "Abyss Star Hairpin", collection = "DISGUISER", access = "FREE",
            descitem = "Unlock \"Lichen Hairpin\" skin.",
            description = "The story was not translated.",
        },

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

        skin_id = "freeskins",
		assets = {
			Asset("ANIM", "anim/skin/hat_cowboy_tvplay.zip"),
		},
		image = { name = nil, atlas = nil, setable = true, },

        string = ischinese and {
            name = "卡尔的警帽，永远", collection = "TVPLAY", access = "FREE",
            descitem = "解锁\"牛仔帽\"的皮肤。",
            description = "卡尔回基地途中拐过树丛时被突然冲出的三个丧尸扑倒，慌忙解决麻烦后感到肚子刺痛，掀起衬衣发现自己已被咬伤...年过三十的卡尔惊醒，看了看还在熟睡的妻女，又望了望桌上警徽虽早已脱落但保养还算完好的警帽，感叹还好只是梦一场。",
        } or {
            name = "Carl's Forever Police Cap", collection = "TVPLAY", access = "FREE",
            descitem = "Unlock \"Stetson\" skin.",
            description = "The story was not translated.",
        },

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

    boltwingout_disguiser = {
        base_prefab = "boltwingout",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,

        skin_id = "61c57daadb102b0b8a50ae95",
		assets = {
			Asset("ANIM", "anim/skin/boltwingout_disguiser.zip"),
            Asset("ANIM", "anim/skin/boltwingout_shuck_disguiser.zip"),
		},
		image = { name = nil, atlas = nil, setable = true, },

        string = ischinese and {
            name = "枯叶飞舞", collection = "DISGUISER", access = "DONATE",
            descitem = "解锁\"脱壳之翅\"、\"羽化后的壳\"的皮肤。",
            description = "它进化出了一对枯叶般的翅膀。饿了，花丛中有落叶辗转；恋了，风中有落叶双双飞舞；累了，树干上有落叶停留。这不夺人耳目的一生，最终也会悄悄离场。",
        } or {
            name = "Fallen Dance", collection = "DISGUISER", access = "DONATE",
            descitem = "Unlock \"Boltwing-out\", \"Post-eclosion Shuck\" skin.",
            description = "The story was not translated.",
        },

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
        image = { name = nil, atlas = nil, setable = true, },

        string = ischinese and {
            name = "云烟", collection = "THANKS", access = "SPECIAL",
            descitem = "解锁\"简易打窝饵制作器\"、\"专业打窝饵制作器\"和\"打窝饵\"的皮肤。",
            description = "\"早闻浮生儿与扶伤剑现任持有者有着密不可分的联系。近日密探来报说扶伤剑已断，预感这次势在必得，并派人在京城散播浮生儿已被捉入衙内的消息...\"当夜丑时，云烟之雾开始浑浊，随后突然庭院异响，\"上钩了\"，一名颓郁男子正隐匿于烟雾中等待时机。",
        } or {
            name = "YunYan", collection = "THANKS", access = "SPECIAL",
            descitem = "Unlock \"Fish-homing Bait Maker\", \"Fish-homing Bait Maker+\", and \"Fish-homing Bait\" skin.",
            description = "The story was not translated.",
        },

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
        image = { name = nil, atlas = nil, setable = true, },

        string = {
            name = ischinese and "云烟草" or "YunYan Cigarette", collection = "THANKS", access = "SPECIAL",
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
            name = ischinese and "云烟瓶" or "YunYan Bottle", collection = "THANKS", access = "SPECIAL",
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

        skin_id = "freeskins",
		assets = {
			Asset("ANIM", "anim/skin/shield_l_log_emo_pride.zip"),
		},
		image = { name = nil, atlas = nil, setable = true, },

        string = ischinese and {
            name = "爱上彩虹", collection = "EMOTICON", access = "FREE",
            descitem = "解锁\"木盾\"的皮肤。",
            description = "多一丝宽容，你就少一份疑惑；多一丝爱心，你就少一份怨恨；多一丝理解，你就少一份紧张。你我都是独一无二，为自己骄傲吧。"
        } or {
            name = "Love Rainbow", collection = "EMOTICON", access = "FREE",
            descitem = "Unlock \"Log Shield\" skin.",
            description = "More tolerance,less doubt.More love,less resentment.More understanding,less nervousness.You and I are unique.Be proud of yourself.",
        },

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
		image = { name = nil, atlas = nil, setable = true, },

        string = ischinese and {
            name = "重拳出击", collection = "EMOTICON", access = "SPECIAL",
            descitem = "解锁\"木盾\"的皮肤。",
            description = "观点不一，骂Ta；羡慕嫉妒，恨Ta；没有黑点？监视Ta。不管发生什么，敲起键盘如同打拳，咬文嚼字断章取义也能搞得鸡飞狗跳。非我皆是恶，活在自己的世界，这就是拳的意义。打的就是你，陌生人。"
        } or {
            name = "Punch Quest", collection = "EMOTICON", access = "SPECIAL",
            descitem = "Unlock \"Log Shield\" skin.",
            description = "The story was not translated.",
        },

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
		image = { name = nil, atlas = nil, setable = true, },

        string = ischinese and {
            name = "洋流之下匍匐", collection = "ERA", access = "SPECIAL",
            descitem = "解锁\"木盾\"的皮肤。",
            description = "奔涌回转的洋流，它们的大家族聚集着散布于看似沉寂的海床。沙子上沾满了行动的足迹，都是它们漫无目的的匍匐寻找。在一段时光里，能顽强地生存在这里，真的是太不可思议了。抱着科学研究的心态，决定去那里走走，一定有更多我能听到的。"
        } or {
            name = "Under Current Crawl", collection = "ERA", access = "SPECIAL",
            descitem = "Unlock \"Log Shield\" skin.",
            description = "The story was not translated.",
        },

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
		image = { name = nil, atlas = nil, setable = true, },

        string = ischinese and {
            name = "坚硬头骨低鸣", collection = "ERA", access = "SPECIAL",
            descitem = "解锁\"砂之抵御\"的皮肤。",
            description = "在一个不起眼的角落它孤独着，被摆在那里，整个头部包括头甲都暴露在外，身体却只剩部分脊骨。某一瞬间，我仿佛看到了，与族群走散，在孤独与绝望的低鸣中被捕食者包围...还好，在生命尽头，大地之母将它怀抱，将它灵魂轻揉。",
        } or {
            name = "Squealing Skull", collection = "ERA", access = "SPECIAL",
            descitem = "Unlock \"Desert Defense\" skin.",
            description = "The story was not translated.",
        },

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

        skin_id = "freeskins",
		assets = {
			Asset("ANIM", "anim/skin/shield_l_sand_op.zip"),
		},
		image = { name = nil, atlas = nil, setable = true, },

        string = ischinese and {
            name = "旧稿", collection = "OLDPIC", access = "FREE",
            descitem = "解锁\"砂之抵御\"的皮肤。",
            description = "画完就觉得左右貌似不太整齐，但是都画好，不想再改。现在我绘画时会不时左右翻转来查看画面的问题，也算是一个进步吧。贴图上结合了沙之石的纹路以及大量向外突出的晶石，中间是金块，现在想想金块不足以被摆在中间好像很重要似的。",
        } or {
            name = "Squealing Skull", collection = "OLDPIC", access = "FREE",
            descitem = "Unlock \"Desert Defense\" skin.",
            description = "The story was not translated.",
        },

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

        string = ischinese and {
            name = "被封存的窸窣", collection = "ERA", access = "SPECIAL",
            descitem = "解锁\"鸳鸯石\"的皮肤。",
            description = "我走进了一家博物馆，刹那，仿佛听到一阵朦朦胧胧的低语，又或是窸窸窣窣的昆虫振翅声。向着声音的方向看去，有一颗西瓜大小的精美琥珀。走进后，里面居然还包裹了一只仿佛仍活着的带翅昆虫。诧异的是，我感受到了它对生命突然凝滞的不甘...",
        } or {
            name = "Sealed Rustle", collection = "ERA", access = "SPECIAL",
            descitem = "Unlock \"Icire Stone\" skin.",
            description = "The story was not translated.",
        },

		fn_start = function(inst)
            inst.AnimState:SetBank("heat_rock")
            inst.AnimState:SetBuild("heat_rock")
            inst.AnimState:OverrideSymbol("rock", "icire_rock_era", "rock")
            inst.AnimState:OverrideSymbol("shadow", "icire_rock_era", "shadow")

            inst.changeimgfn = function(inst)
                local newname = "icire_rock"..tostring(inst.currentTempRange).."_era"
                inst.components.inventoryitem.atlasname = "images/inventoryimages_skin/"..newname..".xml"
                inst.components.inventoryitem:ChangeImageName(newname)
            end
            inst.changeimgfn(inst)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
    },
    icire_rock_collector = {
        base_prefab = "icire_rock",
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,

        skin_id = "62df65b58c2f781db2f7998a",
        onlyownedshow = true,
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

        string = ischinese and {
            name = "占星石", collection = "COLLECTOR", access = "SPECIAL",
            descitem = "解锁\"鸳鸯石\"的皮肤。",
            description = "我族世代守护占星石，并流传着一个不可思议的秘密。占星石每三百年都会选中一位族人，只有他能读懂占星预言。到那时只要听从星的指导，就能让我族发扬兴盛，摆脱命运安排。然而，距离上一位族人逝去已过快四百年，占星石也只剩隐隐的光。"
        } or {
            name = "Astrological Stone", collection = "COLLECTOR", access = "SPECIAL",
            descitem = "Unlock \"Icire Stone\" skin.",
            description = "The story was not translated.",
        },

		fn_start = function(inst)
            inst.AnimState:SetBank("icire_rock_collector")
            inst.AnimState:SetBuild("icire_rock_collector")
            inst.AnimState:ClearOverrideSymbol("rock")
            inst.AnimState:ClearOverrideSymbol("shadow")

            inst.changeimgfn = function(inst)
                local newname = "icire_rock"..tostring(inst.currentTempRange).."_collector"
                inst.components.inventoryitem.atlasname = "images/inventoryimages_skin/"..newname..".xml"
                inst.components.inventoryitem:ChangeImageName(newname)
            end
            inst.changeimgfn(inst)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
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

        string = ischinese and {
            name = "满布大地婆娑", collection = "ERA", access = "SPECIAL",
            descitem = "解锁\"蹄莲花丛\"、\"蹄莲翠叶\"以及入鞘后的皮肤。",
            description = "从奇异的地下河暗道中返回后，脑海中不断回响洞内的蓝色荧光。细长的蕨叶互相轻触，随风摆动，巨大的蓝色花朵极具迷幻色彩，让人目不暇接陷入其中。花叶婆娑的样子真的久久不能忘怀，仿佛有股魔力将思绪不断拉回昨日。"
        } or {
            name = "Platycerium Bush", collection = "ERA", access = "SPECIAL",
            descitem = "Unlock \"Lily Bush\", \"Lileaves\" skin.",
            description = "The story was not translated.",
        },

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
        image = { name = nil, atlas = nil, setable = true, },

        string = {
            name = ischinese and "花叶婆娑" or "Platycerium Leaves", collection = "ERA", access = "SPECIAL",
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
            anim = "idle_cover", bank = "lileaves_era", build = "lileaves_era",
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
        image = { name = nil, atlas = nil, setable = true, },

        string = ischinese and {
            name = "长河探索叮咚", collection = "ERA", access = "SPECIAL",
            descitem = "解锁\"斧铲-三用型\"、\"斧铲-黄金三用型\"的皮肤。",
            description = "几年前我参加了学校组织的考古活动，地点在一个新发现的古老河道。老师同学们在附近叮叮咚咚敲着找着，我发现了一条凿有奇怪图腾的地下河入口，莫名被吸引进去，洞内闪着蓝色荧光并有细流经过，待我出来时，已是次日傍晚。"
        } or {
            name = "Era River Explorer", collection = "ERA", access = "SPECIAL",
            descitem = "Unlock \"Triple-shovelaxe\", \"Snazzy Triple-shovelaxe\" skin.",
            description = "The story was not translated.",
        },

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
        image = { name = nil, atlas = nil, setable = true, },

        string = {
            name = ischinese and "谷地发现叮咚" or "Era Valley Explorer", collection = "ERA", access = "SPECIAL",
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
        onlyownedshow = true,
		assets = {
			Asset("ANIM", "anim/skin/backcub_fans.zip"),
		},
		image = { name = nil, atlas = nil, setable = true, },

        string = ischinese and {
            name = "饭仔", collection = "FANS", access = "FREE",
            descitem = "解锁\"靠背熊\"的皮肤。",
            description = "他叫饭仔，有着简单的几个爱好。吃饭饭，能吃就行；睡觉觉，要抱着他最爱的偶像抱枕才睡得着；不过，他最喜欢的还是给朋友们爱的抱抱。\n--感谢白饭的绘制",
        } or {
            name = "Kid Fan", collection = "FANS", access = "FREE",
            descitem = "Unlock \"Backcub\" skin.",
            description = "The story was not translated.",
        },

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
}

_G.SKIN_IDS_LEGION = {
    ["freeskins"] = {}, --免费皮肤全部装这里面，skin_id设置为"freeskins"就好了
    ["6278c409c340bf24ab311522"] = { --余生
        neverfade_thanks = true, neverfadebush_thanks = true,
        fishhomingtool_awesome_thanks = true, fishhomingtool_normal_thanks = true, fishhomingbait_thanks = true,
        triplegoldenshovelaxe_era = true, tripleshovelaxe_era = true, lilybush_era = true, lileaves_era = true, icire_rock_era = true, shield_l_log_era = true, shield_l_sand_era = true,
        orchidbush_disguiser = true, boltwingout_disguiser = true,
        rosebush_marble = true, lilybush_marble = true, orchidbush_marble = true,
        shield_l_log_emo_fist = true, hat_lichen_emo_que = true,
    },
    ["6278c450c340bf24ab311528"] = { --回忆(5)
        boltwingout_disguiser = true,
        rosebush_marble = true, lilybush_marble = true, orchidbush_marble = true,
        hat_lichen_emo_que = true,
    },
    ["6278c487c340bf24ab31152c"] = { --1鸣惊人(7)
        neverfade_thanks = true, neverfadebush_thanks = true,
        orchidbush_disguiser = true, boltwingout_disguiser = true,
        rosebush_marble = true, lilybush_marble = true, orchidbush_marble = true,
        hat_lichen_emo_que = true,
    },
    ["6278c4acc340bf24ab311530"] = { --2度梅开(7)
        fishhomingtool_awesome_thanks = true, fishhomingtool_normal_thanks = true, fishhomingbait_thanks = true,
        triplegoldenshovelaxe_era = true, tripleshovelaxe_era = true, lilybush_era = true, lileaves_era = true, icire_rock_era = true, shield_l_log_era = true, shield_l_sand_era = true,
        shield_l_log_emo_fist = true,
    },
}
_G.SKIN_IDX_LEGION = {
    -- [1] = "rosorns_spell",
}

if ischinese then
    STRINGS.SKIN_LEGION = {
        UNKNOWN_STORY = "这个故事不值一提。",
        COLLECTION = {
            UNKNOWN = "陌生系列",
            MAGICSPELL = "魔咒系列",
            EMOTICON = "网上冲浪系列",
            MARBLE = "大理石园丁系列",
            THANKS = "江湖一枝花系列",
            TVPLAY = "剧迷系列",
            DISGUISER = "伪装学者系列",
            ERA = "先古回响系列",
            OLDPIC = "念旧系列",
            FANS = "饭制系列",
            COLLECTOR = "星河收藏家系列"
        },
        UI_ACCESS = "获取",
        UI_INPUT_CDK = "请输入兑换码",
        UI_LOAD_CDK = "兑换中...",
        ACCESS = {
            UNKNOWN = "无法获取",
            DONATE = "通过回忆获取",
            FREE = "自动获取",
            SPECIAL = "通过特殊方式获取",
        },
    }
else
    STRINGS.SKIN_LEGION = {
        UNKNOWN_STORY = "The story is not worth mentioning.",
        COLLECTION = {
            UNKNOWN = "Strange Collection",
            MAGICSPELL = "Magic Spell Collection",
            EMOTICON = "Surf Net Collection",
            MARBLE = "Marble Gardener Collection",
            THANKS = "Heartfelt Thanks Collection",
            TVPLAY = "TV Play Fans Collection",
            DISGUISER = "Master of Disguise Collection",
            ERA = "Era Echo Collection",
            OLDPIC = "Nostalgia Collection",
            FANS = "Fans Creation",
            COLLECTOR = "Galaxy Collector Collection"
        },
        UI_ACCESS = "Get It",
        UI_INPUT_CDK = "Please enter CDK",
        UI_LOAD_CDK = "Redeeming...",
        ACCESS = {
            UNKNOWN = "Unable to get",
            DONATE = "Get it by memory", --Get it by donation
            FREE = "Free access",
            SPECIAL = "Get it by special ways",
        },
    }
end

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
    "fishhomingtool_awesome_thanks", "fishhomingtool_normal_thanks", "fishhomingbait_thanks",
    "icire_rock_collector",
    "triplegoldenshovelaxe_era", "tripleshovelaxe_era", "lilybush_era", "lileaves_era", "shield_l_log_era", "icire_rock_era", "shield_l_sand_era",
    "orchidbush_disguiser", "boltwingout_disguiser",
    "rosebush_marble", "lilybush_marble", "orchidbush_marble",
    "shield_l_log_emo_fist", "hat_lichen_emo_que",

    "shield_l_log_emo_pride", "shield_l_sand_op", "hat_cowboy_tvplay", "hat_lichen_disguiser", "orchitwigs_disguiser", "backcub_fans"
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
    if SKIN_IDS_LEGION.freeskins[skinname] then
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

--undo：建筑的皮肤placer请看playercontroller.StartBuildPlacementMode

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
        inst.task_skin_l = inst:DoTaskInTime(0.1, function()
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
                    if right_root ~= nil and right_root.skinshop_legion then
                        right_root.skinshop_legion:ResetItems()
                    end
                end
            end

        elseif handletype == 2 then --反馈cdk结果
            if data and type(data) == "string" then
                local success, result = pcall(json.decode, data)
                if result then
                    --获取数据后，主动更新cdk输入框
                    local right_root = GetRightRoot()
                    if right_root ~= nil and right_root.skinshop_legion then
                        right_root.skinshop_legion:SetCdkState(result.state, result.pop)
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
    if TheNet:IsOnlineMode() and TUNING.LEGION_MOD_LANGUAGES == "chinese" then
        -- local ImageButton = require "widgets/imagebutton"
        local PlayerAvatarPopup = require "widgets/playeravatarpopup"
        local TEMPLATES = require "widgets/templates"
        local SkinLegionDialog = require "widgets/skinlegiondialog"

        -- local right_root = nil
        -- AddClassPostConstruct("widgets/controls", function(self)
        --     right_root = self.right_root
        -- end)

        local Layout_old = PlayerAvatarPopup.Layout
        PlayerAvatarPopup.Layout = function(self, ...)
            Layout_old(self, ...)
            if not TheInput:ControllerAttached() then
                -- if self.close_button then
                --     self.close_button:SetPosition(90, -269)
                -- end

                local right_root = GetRightRoot()
                if right_root == nil then
                    return
                end

                if right_root.skinshop_legion then --再次打开人物自检面板时，需要关闭已有的铺子页面
                    right_root.skinshop_legion:Kill()
                    right_root.skinshop_legion = nil
                end

                self.skinshop_l_button = self.proot:AddChild(TEMPLATES.IconButton(
                    "images/icon_skinbar_shadow_l.xml", "icon_skinbar_shadow_l.tex", "棱镜鸡毛铺", false, false,
                    function()
                        if right_root.skinshop_legion then
                            right_root.skinshop_legion:Kill()
                        end
                        -- local SkinLegionDialog = _G.require("widgets/skinlegiondialog") --test
                        right_root.skinshop_legion = right_root:AddChild(SkinLegionDialog(self.owner))
                        right_root.skinshop_legion:SetPosition(-380, 0)
                        self:Close()
                    end,
                    nil, "self_inspect_mod.tex"
                ))
                self.skinshop_l_button.icon:SetScale(.6)
                self.skinshop_l_button.icon:SetPosition(-4, 6)
                self.skinshop_l_button:SetScale(0.65)
                self.skinshop_l_button:SetPosition(-100, -273)

                -- self.skinshop_l_button = self.proot:AddChild(
                --     ImageButton("images/global_redux.xml", "button_carny_long_normal.tex",
                --         "button_carny_long_hover.tex", "button_carny_long_disabled.tex", "button_carny_long_down.tex")
                -- )
                -- self.skinshop_l_button.image:SetScale(0.2, 0.5)
                -- self.skinshop_l_button:SetFont(CHATFONT)
                -- self.skinshop_l_button:SetPosition(-80, -271)
                -- self.skinshop_l_button.text:SetColour(0,0,0,1)
                -- self.skinshop_l_button:SetTextSize(26)
                -- self.skinshop_l_button:SetText("*")
                -- self.skinshop_l_button:SetOnClick(function()
                --     if right_root.skinshop_legion then
                --         right_root.skinshop_legion:Kill()
                --     end
                --     right_root.skinshop_legion = right_root:AddChild(SkinLegionDialog(self.owner))
                --     right_root.skinshop_legion:SetPosition(-380, 0)
                --     self:Close()
                -- end)
            end
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
