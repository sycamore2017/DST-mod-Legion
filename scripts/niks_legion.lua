local _G = GLOBAL
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()
local ischinese = _G.CONFIGS_LEGION.LANGUAGES == "chinese"
local TOOLS_L = require("tools_legion")

local rarityRepay = "ProofOfPurchase"
local rarityFree = "Distinguished"
local raritySpecial = "HeirloomElegant"

table.insert(Assets, Asset("ATLAS", "images/icon_skinbar_shadow_l.xml"))
table.insert(Assets, Asset("IMAGE", "images/icon_skinbar_shadow_l.tex"))
table.insert(Assets, Asset("ATLAS", "images/icon_wikibar_shadow_l.xml"))
table.insert(Assets, Asset("IMAGE", "images/icon_wikibar_shadow_l.tex"))
table.insert(Assets, Asset("ANIM", "anim/images_minisign_skins1.zip"))
table.insert(Assets, Asset("ANIM", "anim/images_minisign_skins2.zip"))
table.insert(PrefabFiles, "fx_ranimbowspark")
table.insert(PrefabFiles, "skinprefabs_legion")

local skininvs = {
    "agronssword_taste", "agronssword_taste2",
    "siving_turn_collector", "siving_turn_future", "siving_turn_future2",
    "refractedmoonlight_taste", "refractedmoonlight_taste2",
    "chest_whitewood_craft", "chest_whitewood_big_craft", "chest_whitewood_craft2", "chest_whitewood_big_craft2",
    "revolvedmoonlight_taste", "revolvedmoonlight_pro_taste",
    "revolvedmoonlight_taste2", "revolvedmoonlight_pro_taste2",
    "revolvedmoonlight_taste3", "revolvedmoonlight_pro_taste3",
    "revolvedmoonlight_taste4", "revolvedmoonlight_pro_taste4",
    "foliageath_rosorns_marble", "foliageath_lileaves_marble", "foliageath_orchitwigs_marble",
    "foliageath_orchitwigs_disguiser", "neverfade_thanks_broken", "foliageath_neverfade_thanks",
    "neverfade_paper_broken", "foliageath_neverfade_paper", "neverfade_paper2_broken",
    "foliageath_neverfade_paper2", "fishhomingbait1_thanks", "fishhomingbait2_thanks", "fishhomingbait3_thanks",
    "fishhomingbait1_taste", "fishhomingbait2_taste", "fishhomingbait3_taste", "icire_rock1_era",
    "icire_rock2_era", "icire_rock3_era", "icire_rock4_era", "icire_rock5_era", "icire_rock1_collector",
    "icire_rock2_collector", "icire_rock3_collector", "icire_rock4_collector", "icire_rock5_collector",
    "icire_rock1_day", "icire_rock2_day", "icire_rock3_day", "icire_rock4_day", "icire_rock5_day",
    "foliageath_lileaves_era", "foliageath_rosorns_collector",
}

--------------------------------------------------------------------------
--[[ 皮肤函数 ]]
--------------------------------------------------------------------------

local dd_agronssword = {
    img_tex = "agronssword", img_atlas = "images/inventoryimages/agronssword.xml",
    img_tex2 = "agronssword2", img_atlas2 = "images/inventoryimages/agronssword2.xml",
    build = "agronssword", fx = "agronssword_fx"
}
local dd_fishhomingbait = {
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
local dd_siving_ctlwater = {
    siv_bar = {
        x = 0, y = -180, z = 0, scale = nil,
        bank = "siving_ctlwater", build = "siving_ctlwater", anim = "bar"
    }
}
local dd_siving_ctldirt = {
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
local dd_siving_ctlall = {
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
local dd_refractedmoonlight = {
    img_tex = "refractedmoonlight", img_atlas = "images/inventoryimages/refractedmoonlight.xml",
    img_tex2 = "refractedmoonlight2", img_atlas2 = "images/inventoryimages/refractedmoonlight2.xml",
    build = "refractedmoonlight", fx = "refracted_l_spark_fx"
}

local function CopyValue(data, nokeys)
    if data == nil or type(data) ~= "table" then
        return data
    end
    local dd = {}
    for k, v in pairs(data) do
        if nokeys == nil or not nokeys[k] then --部分数据不需要复制
            dd[k] = CopyValue(v)
        end
    end
    return dd
end
local function CopySkinedData(basedata, copyeddata, nokeys)
    for name, data in pairs(copyeddata) do
        local dd = CopyValue(data, nokeys)
        basedata[name] = dd
    end
end

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

local function Fn_start_sivturn(inst, build, bloom)
    local cpt = inst.components.genetrans
    if cpt.fx ~= nil then
        cpt.fx.AnimState:SetBank(build)
        cpt.fx.AnimState:SetBuild(build)
    end
    if build == "siving_turn" then
        cpt.fxdata.build = nil
    else
        cpt.fxdata.build = build
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
        if genetrans.fxdata.build ~= nil then
            genetrans.inst.AnimState:OverrideSymbol("followed", genetrans.fxdata.build, "followed3")
        end
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
        if fx.Follower == nil then
            fx.entity:AddFollower()
        end
        fx.Follower:FollowSymbol(owner.GUID, sym or "swap_object", x or 0, y or 0, 0)
        if fx.components.highlightchild ~= nil then
            fx.components.highlightchild:SetOwner(owner)
        end
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

local function SetWidget_revolved(inst)
    SetWidget(inst, "revolvedmoonlight")
end
local function SetWidget_revolved_pro(inst)
    SetWidget(inst, "revolvedmoonlight_pro")
end
local function Fn_end_revolved(inst)
    inst.AnimState:SetScale(1, 1, 1)
    inst.components.container:Close()
    inst.components.container:WidgetSetup("revolvedmoonlight")
end
local function Fn_end_revolved_pro(inst)
    inst.AnimState:SetScale(1, 1, 1)
    inst.components.container:Close()
    inst.components.container:WidgetSetup("revolvedmoonlight_pro")
end

------

local function SetTarget_hidden(inst)
    if inst.upgradetarget ~= "icebox" then
        inst.AnimState:OverrideSymbol("base", inst.AnimState:GetBuild() or "hiddenmoonlight", "saltbase")
    end
end

------

local function GetEquippedOwner(inst)
    if
        inst.components.inventoryitem ~= nil and
        inst.components.equippable ~= nil and inst.components.equippable:IsEquipped()
    then
        return inst.components.inventoryitem.owner
    end
end

------

local function Start_icire_rock_collector(inst)
    if inst.inworldbox_l or inst.task_l_skinfx ~= nil then
        return
    end
    inst.task_l_skinfx = inst:DoPeriodicTask(0.4, function(inst)
        local x, y, z = inst.Transform:GetWorldPosition()
        for i = 1, math.random(3), 1 do
            local fx = SpawnPrefab("icire_rock_fx_collector")
            if fx ~= nil then
                local x1, y1, z1 = TOOLS_L.GetCalculatedPos(x, y+math.random()*1.1, z, 0.05+math.random()*0.5, nil)
                fx.Transform:SetPosition(x1, y1, z1)
            end
        end
    end, 0.1+math.random())
end
local function End_icire_rock_collector(inst)
    if inst.task_l_skinfx ~= nil then
        inst.task_l_skinfx:Cancel()
        inst.task_l_skinfx = nil
    end
end

------

local function Fn_start_equip(inst, skined)
    if skined ~= nil then
        inst._dd = skined.equip
    else
        inst._dd = nil
    end
end
local function Fn_start_equipevent(inst, skined)
    if skined ~= nil then
        inst._dd = skined.equip
    else
        inst._dd = nil
    end
    inst:PushEvent("ls_update")
end

local function Fn_start_pinkstaff(inst, skined)
    if skined ~= nil then
        inst._dd = skined.equip
        inst.fxcolour = skined.fxcolour
    else
        inst._dd = nil
        inst.fxcolour = {255/255, 80/255, 173/255}
    end
end
local function Fn_start_fishhomingtool(inst, skined)
    if skined ~= nil then
        inst._dd = skined.dressup
        inst.components.bundlemaker:SetSkinData(skined.baitskin, nil)
    else
        inst._dd = nil
        inst.components.bundlemaker:SetSkinData()
    end
end
local function Fn_start_fishhomingbait(inst, skined)
    if skined ~= nil then
        inst._dd = skined.baiting
    else
        inst._dd = {}
        CopySkinedData(inst._dd, dd_fishhomingbait)
    end
    if inst.components.fishhomingbait and inst.components.fishhomingbait.oninitfn then
        inst.components.fishhomingbait.oninitfn(inst)
    end
end
local function Fn_start_agronssword(inst, skined)
    if skined ~= nil then
        inst._dd = skined.equip
    else
        inst._dd = {}
        CopySkinedData(inst._dd, dd_agronssword)
    end
    if inst.components.timer:TimerExists("revolt") then
        inst.components.inventoryitem.atlasname = inst._dd.img_atlas2
        inst.components.inventoryitem:ChangeImageName(inst._dd.img_tex2)
    else
        inst.components.inventoryitem.atlasname = inst._dd.img_atlas
        inst.components.inventoryitem:ChangeImageName(inst._dd.img_tex)
    end
end
local function Fn_start_siving_ctlwater(inst, skined)
    if skined ~= nil then
        inst._dd = skined.bars
    else
        inst._dd = {}
        CopySkinedData(inst._dd, dd_siving_ctlwater)
    end
    inst:UpdateBars_l()
end
local function Fn_start_siving_ctldirt(inst, skined)
    if skined ~= nil then
        inst._dd = skined.bars
    else
        inst._dd = {}
        CopySkinedData(inst._dd, dd_siving_ctldirt)
    end
    inst:UpdateBars_l()
end
local function Fn_start_siving_ctlall(inst, skined)
    if skined ~= nil then
        inst._dd = skined.bars
    else
        inst._dd = {}
        CopySkinedData(inst._dd, dd_siving_ctlall)
    end
    inst:UpdateBars_l()
end
local function Fn_start_siving_mask(inst, skined)
    if skined ~= nil then
        inst._dd = skined.equip
        inst.maskfxoverride_l = skined.maskfx
    else
        inst._dd = nil
        inst.maskfxoverride_l = nil
    end
end
local function Fn_start_siving_suit(inst, skined)
    if skined ~= nil then
        inst._dd = skined.equip
        inst.suitfxoverride_l = skined.suitfx
    else
        inst._dd = nil
        inst.suitfxoverride_l = nil
    end
end
local function Fn_start_refractedmoonlight(inst, skined)
    if skined ~= nil then
        inst._dd = skined.equip
    else
        inst._dd = {}
        CopySkinedData(inst._dd, dd_refractedmoonlight)
    end
    if inst.components.timer:TimerExists("moonsurge") then
        inst.components.inventoryitem.atlasname = inst._dd.img_atlas2
        inst.components.inventoryitem:ChangeImageName(inst._dd.img_tex2)
    else
        inst.components.inventoryitem.atlasname = inst._dd.img_atlas
        inst.components.inventoryitem:ChangeImageName(inst._dd.img_tex)
    end
end

--------------------------------------------------------------------------
--[[ 皮肤数据，以及官方数据修改 ]]
--------------------------------------------------------------------------

local SKIN_DEFAULT_LEGION = {
    --[[
    rosorns = {
        image = { name = nil, atlas = nil, setable = true }, --皮肤初始化使用

        anim = { --皮肤初始化使用
            bank = nil, build = nil,
            anim = nil, animpush = nil, isloop = nil
        },
        -- fn_anim = function(inst)end, --处于地面时的动画设置，替换anim的默认方式

        -- fn_start = function(inst, skined)end, --应用皮肤时的函数(服务器)
        -- fn_end = nil, --取消皮肤时的函数(服务器)
        -- fn_start_c = nil, --应用皮肤时的函数(客户端)
        -- fn_end_c = nil, --取消皮肤时的函数(客户端)

        equip = { symbol = "swap_object", build = "swap_rosorns", file = "swap_rosorns" },

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
        anim = { bank = "berrybush2", build = nil, anim = 0 },
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 }
    },
    lilybush = {
        anim = { bank = "berrybush2", build = nil, anim = 0 },
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 }
    },
    orchidbush = {
        anim = { bank = "berrybush2", build = nil, anim = 0 },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },

    rosorns = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = { symbol = "swap_object", build = "swap_rosorns", file = "swap_rosorns" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.15, size = "small", offset_y = 0.4, scale = 0.5, nofx = nil }
    },
    lileaves = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = { symbol = "swap_object", build = "swap_lileaves", file = "swap_lileaves" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.15, size = "small", offset_y = 0.4, scale = 0.5, nofx = nil }
    },
    orchitwigs = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = {
            symbol = "swap_object", build = "swap_orchitwigs", file = "swap_orchitwigs",
            atkfx = "impact_orchid_fx"
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.15, size = "small", offset_y = 0.4, scale = 0.5, nofx = nil }
    },

    neverfade = {
        image = { name = nil, atlas = nil, setable = false },
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equipevent,
        equip = {
            symbol = "swap_object", doanim = nil,
            build = "swap_neverfade", file = "swap_neverfade",
            build2 = "swap_neverfade_broken", file2 = "swap_neverfade_broken",
            img_tex = "neverfade", img_atlas = "images/inventoryimages/neverfade.xml",
            img_tex2 = "neverfade_broken", img_atlas2 = "images/inventoryimages/neverfade_broken.xml"
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.12, size = "med", offset_y = 0.4, scale = 0.5, nofx = nil }
    },
    neverfadebush = {
        anim = { bank = "berrybush2", build = nil, anim = 0 },
        exchangefx = { prefab = nil, offset_y = 0.9, scale = nil }
    },

    hat_lichen = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = nil, build = nil, anim = "anim", animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = { symbol = "swap_hat", build = "hat_lichen", file = "swap_hat", isopentop = true },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.03, size = "med", offset_y = 0.2, scale = 0.5, nofx = nil }
    },

    hat_cowboy = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = nil, build = nil, anim = "anim", animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = { symbol = "swap_hat", build = "hat_cowboy", file = "swap_hat" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.03, size = "med", offset_y = 0.2, scale = 0.8, nofx = nil }
    },

    pinkstaff = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = nil, build = nil, anim = "anim", animpush = nil, isloop = nil },
        fn_start = Fn_start_pinkstaff,
        equip = { symbol = "swap_object", build = "swap_pinkstaff", file = "swap_pinkstaff" },
        fxcolour = {255/255, 80/255, 173/255},
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.15, size = "small", offset_y = 0.35, scale = 0.5, nofx = nil }
    },

    boltwingout = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = "swap_boltwingout", build = "swap_boltwingout", anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = {
            symbol = "swap_body", build = "swap_boltwingout", file = "swap_body",
            boltdata = { fx = "boltwingout_fx", build = nil }
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.09, size = "small", offset_y = 0.2, scale = 0.45, nofx = nil }
    },

    fishhomingtool_awesome = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_fishhomingtool,
        dressup = { symbol = "swap_object", build = "fishhomingtool_awesome", file = "swap" },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },
    fishhomingtool_normal = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = function(inst, skined)
            inst.components.bundlemaker:SetSkinData()
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },
    fishhomingbait = {
        anim = { bank = nil, build = nil, anim = 0 },
        fn_start = Fn_start_fishhomingbait,
        baiting = dd_fishhomingbait,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },

    icire_rock = {
        anim = { bank = "heat_rock", build = "heat_rock", anim = 0 },
		fn_start = function(inst, skined)
            inst.AnimState:OverrideSymbol("rock", "icire_rock", "rock")
            inst.AnimState:OverrideSymbol("shadow", "icire_rock", "shadow")
            inst._dd = nil
            inst.fn_temp(inst)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },

    shield_l_log = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = { symbol = "lantern_overlay", build = "shield_l_log", file = "swap_shield", isshield = true },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.7 },
        floater = { cut = nil, size = "small", offset_y = 0.2, scale = 0.9, nofx = nil }
    },
    shield_l_sand = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = { symbol = "lantern_overlay", build = "shield_l_sand", file = "swap_shield", isshield = true },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },
    agronssword = {
        anim = { bank = nil, build = nil, anim = 0 },
        fn_start = Fn_start_agronssword,
        equip = dd_agronssword,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },

    tripleshovelaxe = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = { symbol = "swap_object", build = "tripleshovelaxe", file = "swap" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = nil, size = "med", offset_y = 0.15, scale = 0.4, nofx = nil }
    },
    triplegoldenshovelaxe = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = { symbol = "swap_object", build = "triplegoldenshovelaxe", file = "swap" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = nil, size = "med", offset_y = 0.15, scale = 0.4, nofx = nil }
    },

    backcub = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = nil, build = nil, anim = "anim", animpush = nil, isloop = true },
        fn_start = Fn_start_equip,
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
        anim = { bank = "boomerang", build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = { symbol = "swap_object", build = "fimbul_axe", file = "swap_base" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.5, nofx = nil }
    },

    siving_derivant = {
        anim = { bank = nil, build = nil, anim = 0 },
        fn_start = function(inst, skined)
            inst.AnimState:SetScale(1.3, 1.3)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 }
    },

    siving_turn = {
        anim = { bank = nil, build = nil, anim = 0 },
        fn_start = function(inst, skined)
            inst.components.genetrans.fxdata.unlockfx = "siving_turn_unlock_fx"
            Fn_start_sivturn(inst, "siving_turn", true)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 }
    },

    carpet_whitewood = {
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil }
    },
    carpet_whitewood_big = {
        anim = {
            bank = "carpet_whitewood", build = "carpet_whitewood",
            anim = "idle_big", animpush = nil, isloop = nil
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil }
    },

    soul_contracts = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = "book_maxwell", build = nil, anim = 0 },
        fn_start = function(inst, skined)
            inst._dd = { fx = "l_soul_fx" }
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = nil }
    },

    siving_feather_real = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = { symbol = "swap_object", build = "siving_feather_real", file = "swap" },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.04, size = "small", offset_y = 0.2, scale = 0.5, nofx = nil }
    },
    siving_feather_fake = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = { symbol = "swap_object", build = "siving_feather_fake", file = "swap" },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.04, size = "small", offset_y = 0.2, scale = 0.5, nofx = nil }
    },

    plant_cactus_meat_l = {
        anim = { bank = "crop_legion_cactus", build = "crop_legion_cactus", anim = 0 },
        fn_start = function(inst, skined)
            OnSummer_cactus(inst, nil)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 }
    },

    plant_carrot_l = {
        anim = { bank = "crop_legion_carrot", build = "crop_legion_carrot", anim = 0 },
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 }
    },
    lance_carrot_l = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = { symbol = "swap_object", build = "lance_carrot_l", file = "swap_object" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.1, size = "small", offset_y = 0.3, scale = 0.6, nofx = nil }
    },

    siving_ctlwater_item = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = "siving_ctlwater", build = "siving_ctlwater", anim = "item", animpush = nil, isloop = nil },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },

        overridekeys = { "data_build" },
        data_build = {
            anim = {
                bank = "siving_ctlwater", build = "siving_ctlwater",
                anim = "idle", animpush = nil, isloop = nil
            },
            fn_start = Fn_start_siving_ctlwater,
            bars = dd_siving_ctlwater
        }
    },
    siving_ctldirt_item = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = "siving_ctldirt", build = "siving_ctldirt", anim = "item", animpush = nil, isloop = nil },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },

        overridekeys = { "data_build" },
        data_build = {
            anim = {
                bank = "siving_ctldirt", build = "siving_ctldirt",
                anim = "idle", animpush = nil, isloop = nil
            },
            fn_start = Fn_start_siving_ctldirt,
            bars = dd_siving_ctldirt
        }
    },
    siving_ctlall_item = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = "siving_ctlall", build = "siving_ctlall", anim = "item", animpush = nil, isloop = nil },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },

        overridekeys = { "data_build" },
        data_build = {
            anim = {
                bank = "siving_ctlall", build = "siving_ctlall",
                anim = "idle", animpush = nil, isloop = nil
            },
            fn_start = Fn_start_siving_ctlall,
            bars = dd_siving_ctlall
        }
    },

    siving_mask = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_siving_mask,
        equip = { symbol = "swap_hat", build = "siving_mask", file = nil, isopentop = true },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil }
    },
    siving_mask_gold = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_siving_mask,
        equip = { symbol = "swap_hat", build = "siving_mask_gold", file = nil, isopentop = true },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil }
    },

    siving_suit = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_siving_suit,
        equip = { symbol = "swap_body", build = "siving_suit", file = "swap_body" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil }
    },
    siving_suit_gold = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_siving_suit,
        equip = { symbol = "swap_body", build = "siving_suit_gold", file = "swap_body" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil }
    },

    siving_soil_item = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = "siving_soil", build = "siving_soil", anim = "item", animpush = nil, isloop = nil },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },

        overridekeys = { "data_soil", "data_plant" },
        data_soil = {
            anim = { bank = "farm_soil", build = "siving_soil", anim = 0 }
        },
        data_plant = {
            fn_start = function(inst, skined)
                inst.soilskin_l = nil
                if inst.fn_soiltype ~= nil then
                    inst.fn_soiltype(inst, nil)
                end
            end
        }
    },

    refractedmoonlight = {
        anim = { bank = nil, build = nil, anim = 0 },
        fn_start = Fn_start_refractedmoonlight,
        equip = dd_refractedmoonlight,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },

    hiddenmoonlight_item = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = "hiddenmoonlight", build = "hiddenmoonlight",
            anim = "idle_item", animpush = nil, isloop = nil
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.7, nofx = nil },

        overridekeys = { "data_up", "data_upinf" },
        data_up = {
            exchangefx = { prefab = nil, offset_y = nil, scale = nil },
            anim = { bank = "hiddenmoonlight", build = "hiddenmoonlight", anim = 0 },
            fn_start = function(inst, skined)
                SetTarget_hidden(inst)
            end
        },
        data_upinf = {
            exchangefx = { prefab = nil, offset_y = nil, scale = nil },
            anim = { bank = "hiddenmoonlight", build = "hiddenmoonlight_inf", anim = 0 },
            fn_start = function(inst, skined)
                SetTarget_hidden(inst)
            end
        }
    },
    revolvedmoonlight_item = {
        image = { name = nil, atlas = nil, setable = true },
        anim = {
            bank = "revolvedmoonlight", build = "revolvedmoonlight",
            anim = "idle_item", animpush = nil, isloop = nil
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.18, size = "small", offset_y = 0.4, scale = 0.55, nofx = nil },

        overridekeys = { "data_up", "data_uppro" },
        data_up = {
            image = { name = "revolvedmoonlight", atlas = "images/inventoryimages/revolvedmoonlight.xml", setable = true },
            floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil },
            anim = { bank = "revolvedmoonlight", build = "revolvedmoonlight", anim = 0 }
        },
        data_uppro = {
            image = {
                name = "revolvedmoonlight_pro", atlas = "images/inventoryimages/revolvedmoonlight_pro.xml",
                setable = true
            },
            floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.45, nofx = nil },
            fn_start = function(inst, skined)
                inst.AnimState:SetBank("revolvedmoonlight")
                inst.AnimState:SetBuild("revolvedmoonlight")
                inst.AnimState:OverrideSymbol("decorate", "revolvedmoonlight", "decoratepro")
            end
        }
    },

    chest_whitewood = {
        anim = { bank = nil, build = nil, anim = 0 },
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        overridekeys = { "data_inf" },
        data_inf = {
            anim = { bank = "chest_whitewood", build = "chest_whitewood_inf", anim = 0 }
        }
    },
    chest_whitewood_big = {
        anim = { bank = nil, build = nil, anim = 0 },
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        overridekeys = { "data_inf" },
        data_inf = {
            anim = { bank = "chest_whitewood_big", build = "chest_whitewood_big_inf", anim = 0 }
        }
    },

    tourmalinecore = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },

    explodingfruitcake = {
        image = { name = nil, atlas = nil, setable = true },
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil }
    },
}
local SKINS_LEGION = {
    --[[
	rosorns_spell = {
        base_prefab = "rosorns",
		type = "item", --item物品、建筑等皮肤，base人物皮肤
		rarity = rarityRepay,
		skin_tags = {},
		release_group = 555,
		build_name_override = nil, --皮肤swap-icon通道所在的build文件名

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
            anim = nil, animpush = nil, isloop = nil
        },
        -- fn_anim = function(inst)end, --处于地面时的动画设置，替换anim的默认方式

        -- fn_start = function(inst, skined)end, --应用皮肤时的函数(服务器)
        -- fn_end = nil, --取消皮肤时的函数(服务器)
        -- fn_start_c = nil, --应用皮肤时的函数(客户端)
        -- fn_end_c = nil, --取消皮肤时的函数(客户端)

        equip = { symbol = "swap_object", build = "swap_spear_mirrorrose", file = "swap_spear" },

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
        anim = { bank = "berrybush", build = nil, anim = 0 },
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
			Asset("ANIM", "anim/skin/rosorns_marble.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "落薇剪" } or { name = "Falling Petals Scissors" },
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = true },
        fn_start = Fn_start_equip,
        equip = {
            symbol = "swap_object", build = "rosorns_marble", file = "swap_object",
            scabbard = {
                anim = "idle_cover", isloop = true, bank = "rosorns_marble", build = "rosorns_marble",
                image = "foliageath_rosorns_marble",
                atlas = "images/inventoryimages_skin/foliageath_rosorns_marble.xml"
            },
            atkfn = function(inst, owner, target)
                local fx = SpawnPrefab("rosorns_marble_fx")
                if fx ~= nil then
                    fx.Transform:SetPosition(target.Transform:GetWorldPosition())
                end
            end
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
        anim = { bank = "berrybush", build = nil, anim = 0 },
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
			Asset("ANIM", "anim/skin/lileaves_marble.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "石莲长枪" } or { name = "Marble Lilance" },
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = {
            symbol = "swap_object", build = "lileaves_marble", file = "swap_object",
            scabbard = {
                anim = "idle_cover", isloop = nil, bank = "lileaves_marble", build = "lileaves_marble",
                image = "foliageath_lileaves_marble",
                atlas = "images/inventoryimages_skin/foliageath_lileaves_marble.xml"
            }
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
        anim = { bank = "berrybush", build = nil, anim = 0 },
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
			Asset("ANIM", "anim/skin/orchitwigs_marble.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "铁艺兰珊" } or { name = "Ironchid" },
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = {
            symbol = "swap_object", build = "orchitwigs_marble", file = "swap_object",
            atkfx = "impact_orchid_fx_marble",
            scabbard = {
                anim = "idle_cover", isloop = nil, bank = "orchitwigs_marble", build = "orchitwigs_marble",
                image = "foliageath_orchitwigs_marble",
                atlas = "images/inventoryimages_skin/foliageath_orchitwigs_marble.xml"
            }
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
        anim = { bank = "berrybush2", build = nil, anim = 0 },
        exchangefx = { prefab = nil, offset_y = 1.3, scale = nil },
        linkedskins = { sword = "orchitwigs_disguiser" },
        fn_placer = function(inst)
            inst.AnimState:SetBank("berrybush2")
            inst.AnimState:SetBuild("orchidbush_disguiser")
        end
    },
    orchitwigs_disguiser = {
        base_prefab = "orchitwigs", skin_id = "justffffree",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityFree,
		assets = {
			Asset("ANIM", "anim/skin/orchitwigs_disguiser.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "粉色追猎" } or { name = "Pink Orchitwigs" },
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = {
            symbol = "swap_object", build = "orchitwigs_disguiser", file = "swap_object",
            atkfx = "impact_orchid_fx_disguiser",
            scabbard = {
                anim = "idle_cover", isloop = nil, bank = "orchitwigs_disguiser", build = "orchitwigs_disguiser",
                image = "foliageath_orchitwigs_disguiser",
                atlas = "images/inventoryimages_skin/foliageath_orchitwigs_disguiser.xml"
            }
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.05, size = "small", offset_y = 0.15, scale = 0.5, nofx = nil }
    },

    neverfade_thanks = {
        base_prefab = "neverfade", skin_id = "6191d8f74c724c6f40e77ed0", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/neverfade_thanks.zip"),
            Asset("ANIM", "anim/skin/neverfade_butterfly_thanks.zip")
		},
        image = { name = nil, atlas = nil, setable = false },
        string = ischinese and { name = "扶伤" } or { name = "FuShang" },
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equipevent,
        equip = {
            symbol = "swap_object", doanim = nil,
            build = "neverfade_thanks", file = "normal_swap",
            build2 = "neverfade_thanks", file2 = "broken_swap",
            img_tex = "neverfade_thanks", img_atlas = "images/inventoryimages_skin/neverfade_thanks.xml",
            img_tex2 = "neverfade_thanks_broken", img_atlas2 = "images/inventoryimages_skin/neverfade_thanks_broken.xml",
            butterfly = { bank = "butterfly", build = "neverfade_butterfly_thanks" },
            scabbard = {
                anim = "idle_cover", isloop = nil, bank = "neverfade_thanks", build = "neverfade_thanks",
                image = "foliageath_neverfade_thanks",
                atlas = "images/inventoryimages_skin/foliageath_neverfade_thanks.xml"
            }
        },
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
        anim = { bank = nil, build = nil, anim = 0 },
        exchangefx = { prefab = nil, offset_y = 1.2, scale = nil },
        linkedskins = { sword = "neverfade_thanks" }
    },
    neverfade_paper = {
        base_prefab = "neverfade", skin_id = "638362b68c2f781db2f7f524", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/neverfade_paper.zip"),
            Asset("ANIM", "anim/skin/neverfade_butterfly_paper.zip")
		},
        image = { name = nil, atlas = nil, setable = false },
        string = ischinese and { name = "青蝶纸剑" } or { name = "Paper-fly Sword" },
        anim = { bank = nil, build = nil, anim = 0 },
        fn_start = Fn_start_equipevent,
        equip = {
            symbol = "swap_object", doanim = true,
            build = "neverfade_paper", file = "normal_swap",
            build2 = "neverfade_paper", file2 = "broken_swap",
            img_tex = "neverfade_paper", img_atlas = "images/inventoryimages_skin/neverfade_paper.xml",
            img_tex2 = "neverfade_paper_broken", img_atlas2 = "images/inventoryimages_skin/neverfade_paper_broken.xml",
            butterfly = { bank = "butterfly", build = "neverfade_butterfly_paper" },
            scabbard = {
                anim = "idle_cover", isloop = nil, bank = "neverfade_paper", build = "neverfade_paper",
                image = "foliageath_neverfade_paper",
                atlas = "images/inventoryimages_skin/foliageath_neverfade_paper.xml"
            }
        },
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
        anim = { bank = "berrybush2", build = nil, anim = 0 },
        exchangefx = { prefab = nil, offset_y = 1.2, scale = nil },
        linkedskins = { sword = "neverfade_paper" }
    },
    neverfade_paper2 = {
        base_prefab = "neverfade", skin_id = "638362b68c2f781db2f7f524", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/neverfade_paper2.zip"),
            Asset("ANIM", "anim/skin/neverfade_butterfly_paper2.zip")
		},
        image = { name = nil, atlas = nil, setable = false },
        string = ischinese and { name = "绀蝶纸剑" } or { name = "Violet Paper-fly Sword" },
        anim = { bank = nil, build = nil, anim = 0 },
        fn_start = Fn_start_equipevent,
        equip = {
            symbol = "swap_object", doanim = true,
            build = "neverfade_paper2", file = "normal_swap",
            build2 = "neverfade_paper2", file2 = "broken_swap",
            img_tex = "neverfade_paper2", img_atlas = "images/inventoryimages_skin/neverfade_paper2.xml",
            img_tex2 = "neverfade_paper2_broken", img_atlas2 = "images/inventoryimages_skin/neverfade_paper2_broken.xml",
            butterfly = { bank = "butterfly", build = "neverfade_butterfly_paper2" },
            scabbard = {
                anim = "idle_cover", isloop = nil, bank = "neverfade_paper2", build = "neverfade_paper2",
                image = "foliageath_neverfade_paper2",
                atlas = "images/inventoryimages_skin/foliageath_neverfade_paper2.xml"
            }
        },
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
        anim = { bank = "berrybush2", build = nil, anim = 0 },
        exchangefx = { prefab = nil, offset_y = 1.2, scale = nil },
        linkedskins = { sword = "neverfade_paper2" }
    },

    hat_lichen_emo_que = { --疑问
        base_prefab = "hat_lichen", skin_id = "61909c584c724c6f40e779fa",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/hat_lichen_emo_que.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "困惑" } or { name = "Confusion" },
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = { symbol = "swap_hat", build = "hat_lichen_emo_que", file = "swap_hat", isopentop = true },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.03, size = "small", offset_y = 0.15, scale = 0.5, nofx = nil }
    },
    hat_lichen_disguiser = {
        base_prefab = "hat_lichen", skin_id = "justffffree",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityFree,
		assets = {
			Asset("ANIM", "anim/skin/hat_lichen_disguiser.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "深渊的星" } or { name = "Abyss Star Hairpin" },
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = {
            symbol = "swap_hat", build = "hat_lichen_disguiser", file = "swap_hat",
            isopentop = nil, lightcolor = { r = 0, g = 1, b = 1 }
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.03, size = "med", offset_y = 0.2, scale = 0.7, nofx = nil }
    },
    hat_lichen_emo_3shock = { --非常震惊
        base_prefab = "hat_lichen", skin_id = "6568725bce45c22cf18df688", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/hat_lichen_emo_3shock.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "非常震惊" } or { name = "So Shock" },
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = {
            symbol = "swap_hat", build = "hat_lichen_emo_3shock", file = "swap_hat",
            isopentop = true, lightcolor = { r = 1, g = 226/255, b = 208/255 }
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.03, size = "small", offset_y = 0.15, scale = 0.7, nofx = nil }
    },
    hat_lichen_emo_shock = { --惊讶
        base_prefab = "hat_lichen", skin_id = "6568725bce45c22cf18df688", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/hat_lichen_emo_shock.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "惊讶" } or { name = "Shock" },
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = {
            symbol = "swap_hat", build = "hat_lichen_emo_shock", file = "swap_hat",
            isopentop = true, lightcolor = { r = 1, g = 241/255, b = 212/255 }
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.03, size = "small", offset_y = 0.15, scale = 0.4, nofx = nil }
    },
    hat_lichen_emo_anger = { --生气
        base_prefab = "hat_lichen", skin_id = "6568725bce45c22cf18df688", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/hat_lichen_emo_anger.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "生气" } or { name = "Anger" },
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = {
            symbol = "swap_hat", build = "hat_lichen_emo_anger", file = "swap_hat",
            isopentop = true, lightcolor = { r = 1, g = 221/255, b = 214/255 }
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.03, size = "small", offset_y = 0.15, scale = 0.5, nofx = nil }
    },
    hat_lichen_emo_sweat = { --流汗
        base_prefab = "hat_lichen", skin_id = "6568725bce45c22cf18df688", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/hat_lichen_emo_sweat.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "流汗" } or { name = "Sweat" },
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = {
            symbol = "swap_hat", build = "hat_lichen_emo_sweat", file = "swap_hat",
            isopentop = true, lightcolor = { r = 210/255, g = 243/255, b = 255/255 }
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.02, size = "small", offset_y = 0.15, scale = 0.5, nofx = nil }
    },
    hat_lichen_emo_heart = { --心动
        base_prefab = "hat_lichen", skin_id = "6568725bce45c22cf18df688", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/hat_lichen_emo_heart.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "心动" } or { name = "Heart" },
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = {
            symbol = "swap_hat", build = "hat_lichen_emo_heart", file = "swap_hat",
            isopentop = true, lightcolor = { r = 255/255, g = 208/255, b = 208/255 }
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.02, size = "small", offset_y = 0.15, scale = 0.8, nofx = nil }
    },

    hat_cowboy_tvplay = {
        base_prefab = "hat_cowboy", skin_id = "justffffree",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityFree,
		assets = {
			Asset("ANIM", "anim/skin/hat_cowboy_tvplay.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "卡尔的警帽，永远" } or { name = "Carl's Forever Police Cap" },
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = { symbol = "swap_hat", build = "hat_cowboy_tvplay", file = "swap_hat" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.03, size = "med", offset_y = 0.2, scale = 0.8, nofx = nil }
    },
    pinkstaff_tvplay = {
        base_prefab = "pinkstaff", skin_id = "justffffree",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityFree,
		assets = {
			Asset("ANIM", "anim/skin/pinkstaff_tvplay.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "音速起子12" } or { name = "Sonic Screwdriver 12" },
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_pinkstaff,
        fn_end = function(inst, skined)
            EndFollowedFx(inst, nil, "fx_l_pinkstaff_tv")
        end,
        equip = {
            symbol = "swap_object", build = "pinkstaff_tvplay", file = "swap_object",
            startfn = function(inst, owner)
                SetFollowedFx(inst, owner, "pinkstaff_fx_tvplay", "swap_object", 0, -140, "fx_l_pinkstaff_tv")
            end,
            endfn = function(inst, owner)
                EndFollowedFx(inst, nil, "fx_l_pinkstaff_tv")
            end
        },
        fxcolour = {115/255, 217/255, 255/255},
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
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = {
            symbol = "swap_body", build = "boltwingout_disguiser", file = "swap_body",
            boltdata = { fx = "boltwingout_fx_disguiser", build = "boltwingout_shuck_disguiser" }
        },
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
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_fishhomingtool,
        dressup = { symbol = "swap_object", build = "fishhomingtool_awesome_thanks", file = "swap" },
        baitskin = "fishhomingbait_thanks",
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
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_fishhomingtool,
        dressup = { symbol = "swap_object", build = "fishhomingtool_awesome_taste", file = "swap" },
        baitskin = "fishhomingbait_taste",
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
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = function(inst, skined)
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
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = function(inst, skined)
            inst.components.bundlemaker:SetSkinData("fishhomingbait_taste", nil)
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },
    fishhomingbait_thanks = {
        base_prefab = "fishhomingbait", skin_id = "627f66c0c340bf24ab311783", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
            Asset("ANIM", "anim/pollen_chum.zip"), --官方藤壶花粉动画
			Asset("ANIM", "anim/skin/fishhomingbait_thanks.zip")
		},
        image = { name = nil, atlas = nil, setable = false }, --皮肤展示需要一个同prefab名的图片
        string = { name = ischinese and "云烟瓶" or "YunYan Bottle" },
        anim = { bank = nil, build = nil, anim = 0 },
        fn_start = Fn_start_fishhomingbait,
        baiting = {
            bank = "pollen_chum", build = "pollen_chum",
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
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },
    fishhomingbait_taste = {
        base_prefab = "fishhomingbait", skin_id = "61ff45880a30fc7fca0db5e5", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityFree,
		assets = {
            Asset("ANIM", "anim/pollen_chum.zip"), --官方藤壶花粉动画
			Asset("ANIM", "anim/skin/fishhomingbait_taste.zip")
		},
        image = { name = nil, atlas = nil, setable = false }, --皮肤展示需要一个同prefab名的图片
        string = ischinese and { name = "茶之恋" } or { name = "Tea Heart" },
        anim = { bank = nil, build = nil, anim = 0 },
        fn_start = Fn_start_fishhomingbait,
        baiting = {
            bank = "pollen_chum", build = "pollen_chum",
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
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },

    shield_l_log_emo_pride = {
        base_prefab = "shield_l_log", skin_id = "justffffree",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityFree,
		assets = {
			Asset("ANIM", "anim/skin/shield_l_log_emo_pride.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "爱上彩虹" } or { name = "Love Rainbow" },
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.7 },
        floater = { cut = nil, size = "small", offset_y = 0.2, scale = 0.9, nofx = nil },
        equip = {
            isshield = true,
            symbol = "lantern_overlay", build = "shield_l_log_emo_pride", file = "swap_shield"
        },
        fn_start = function(inst, skined)
            Fn_start_equip(inst, skined)
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
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = {
            isshield = true,
            symbol = "lantern_overlay", build = "shield_l_log_emo_fist", file = "swap_shield"
        },
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
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = { isshield = true, symbol = "lantern_overlay", build = "shield_l_log_era", file = "swap_shield" },
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
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = { isshield = true, symbol = "lantern_overlay", build = "shield_l_sand_era", file = "swap_shield" },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },
    shield_l_sand_op = {
        base_prefab = "shield_l_sand", skin_id = "justffffree",
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityFree,
		assets = {
			Asset("ANIM", "anim/skin/shield_l_sand_op.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "旧稿" } or { name = "Old Art" },
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = { isshield = true, symbol = "lantern_overlay", build = "shield_l_sand_op", file = "swap_shield" },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },

    agronssword_taste = {
        base_prefab = "agronssword", skin_id = "637f66d88c2f781db2f7f2d0", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/agronssword_taste.zip")
		},
        string = ischinese and { name = "糖霜法棍" } or { name = "Frosting Baguette" },
        anim = { bank = nil, build = nil, anim = 0 },
        fn_start = Fn_start_agronssword,
        equip = {
            img_tex = "agronssword_taste", img_atlas = "images/inventoryimages_skin/agronssword_taste.xml",
            img_tex2 = "agronssword_taste2", img_atlas2 = "images/inventoryimages_skin/agronssword_taste2.xml",
            build = "agronssword_taste", fx = "agronssword_fx_taste"
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
    },

    icire_rock_era = {
        base_prefab = "icire_rock", skin_id = "6280d4f2c340bf24ab3118b1", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
            -- Asset("ANIM", "anim/heat_rock.zip"), --官方热能石动画模板。因为本体也引用了，所以这不重复引用
			Asset("ANIM", "anim/skin/icire_rock_era.zip")
		},
		image = { name = nil, atlas = nil, setable = false },
        string = ischinese and { name = "琥珀石中蝇" } or { name = "In Amber" },
		fn_start = function(inst, skined)
            inst.AnimState:SetBank("heat_rock")
            inst.AnimState:SetBuild("heat_rock")
            inst.AnimState:OverrideSymbol("rock", "icire_rock_era", "rock")
            inst.AnimState:OverrideSymbol("shadow", "icire_rock_era", "shadow")
            inst._dd = skined and skined.temp or nil
            inst.fn_temp(inst)
        end,
        temp = { img_pst = "_era", canbloom = true },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },
    icire_rock_collector = {
        base_prefab = "icire_rock", skin_id = "62df65b58c2f781db2f7998a", onlyownedshow = true, mustonwedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/icire_rock_collector.zip")
		},
		image = { name = nil, atlas = nil, setable = false },
        string = ischinese and { name = "占星石" } or { name = "Astrological Stone" },
        anim = { bank = nil, build = nil, anim = 0 },
		fn_start = function(inst, skined)
            inst.AnimState:ClearOverrideSymbol("rock")
            inst.AnimState:ClearOverrideSymbol("shadow")
            inst._dd = skined and skined.temp or nil
            inst.fn_temp(inst)
            if not inst:IsAsleep() then
                Start_icire_rock_collector(inst)
            end
        end,
        fn_end = End_icire_rock_collector,
        temp = {
            img_pst = "_collector", canbloom = true,
            entwakefn = Start_icire_rock_collector, entsleepfn = End_icire_rock_collector
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },
    icire_rock_day = {
        base_prefab = "icire_rock", skin_id = "6380cbb88c2f781db2f7f400", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/icire_rock_day.zip")
		},
		image = { name = nil, atlas = nil, setable = false },
        string = ischinese and { name = "风景球" } or { name = "Landscape Ball" },
        anim = { bank = nil, build = nil, anim = 0 },
		fn_start = function(inst, skined)
            inst.AnimState:ClearOverrideSymbol("rock")
            inst.AnimState:ClearOverrideSymbol("shadow")
            inst._dd = skined and skined.temp or nil
            inst.fn_temp(inst)
        end,
        fn_end = function(inst, skined)
            if inst._dd_fx ~= nil then
                if inst._dd_fx:IsValid() then
                    inst._dd_fx:Remove()
                end
                inst._dd_fx = nil
            end
        end,
        temp = { img_pst = "_day", canbloom = false, tempfn = Fn_icire_rock_day },
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
        anim = { bank = "berrybush2", build = nil, anim = 0 },
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
			Asset("ANIM", "anim/skin/lileaves_era.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = { name = ischinese and "婆娑花叶" or "Platycerium Leaves" },
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = {
            symbol = "swap_object", build = "lileaves_era", file = "swap_object",
            scabbard = {
                anim = "idle_cover", isloop = nil, bank = "lileaves_era", build = "lileaves_era",
                image = "foliageath_lileaves_era",
                atlas = "images/inventoryimages_skin/foliageath_lileaves_era.xml"
            }
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
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
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
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
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
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
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
            inst.AnimState:SetBank("backcub_thanks")
            inst.AnimState:SetBuild("backcub_thanks")
            SetRandomSkinAnim(inst, {
                "idle1", "idle1", "idle1", "idle2", "idle3", "idle3", "idle4", "idle5"
            })
        end,
        fn_start = Fn_start_equip,
        fn_end = function(inst, skined)
            CancelRandomSkinAnim(inst)
        end,
        equip = { symbol = "swap_body", build = "backcub_thanks", file = "swap_body" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = nil, size = "med", offset_y = 0.1, scale = 0.9, nofx = nil,
            fn_anim = function(inst)
                inst.AnimState:SetBank("backcub_thanks")
                inst.AnimState:SetBuild("backcub_thanks")
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
        fn_anim = function(inst)
            inst.AnimState:SetBank("backcub_fans2")
            inst.AnimState:SetBuild("backcub_fans2")
            SetRandomSkinAnim(inst, {
                "idle1", "idle1", "idle1", "idle1", "idle2", "idle3", "idle3"
            })
        end,
        fn_start = function(inst, skined)
            Fn_start_equip(inst, skined)
            inst.components.container:Close()
            inst.components.container:WidgetSetup("backcub_fans2")
        end,
        fn_end = function(inst, skined)
            CancelRandomSkinAnim(inst)
            inst.components.container:Close()
            inst.components.container:WidgetSetup("backcub")
        end,
        fn_start_c = function(inst, skined)
            SetWidget(inst, "backcub_fans2")
        end,
        fn_end_c = function(inst, skined)
            SetWidget(inst, "backcub")
        end,
        equip = { symbol = "swap_body", build = "backcub_fans2", file = "swap_body" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = {
            cut = nil, size = "med", offset_y = 0.1, scale = 0.9, nofx = nil,
            fn_anim = function(inst)
                inst.AnimState:SetBank("backcub_fans2")
                inst.AnimState:SetBuild("backcub_fans2")
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
        anim = { bank = "berrybush", build = nil, anim = 0 },
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
			Asset("ANIM", "anim/skin/rosorns_collector.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = { name = ischinese and "贯星剑" or "Star Pierced Sword" },
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = true },
        fn_start = Fn_start_equip,
        equip = {
            symbol = "swap_object", build = "rosorns_collector", file = "swap_object",
            scabbard = {
                anim = "idle_cover", isloop = true, bank = "rosorns_collector", build = "rosorns_collector",
                image = "foliageath_rosorns_collector",
                atlas = "images/inventoryimages_skin/foliageath_rosorns_collector.xml"
            },
            atkfn = function(inst, owner, target)
                local fx = SpawnPrefab("rosorns_collector_fx")
                if fx ~= nil then
                    fx.Transform:SetPosition(target.Transform:GetWorldPosition())
                end
            end
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
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        fn_end = function(inst, skined)
            if inst.task_skinfx ~= nil then
                inst.task_skinfx:Cancel()
                inst.task_skinfx = nil
            end
        end,
        equip = {
            symbol = "swap_object", build = "fimbul_axe_collector", file = "swap_base",
            thrownfn = function(inst, owner, target)
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
            thrownendfn = function(inst)
                if inst.task_skinfx ~= nil then
                    inst.task_skinfx:Cancel()
                    inst.task_skinfx = nil
                end
            end,
            lightningfn = function(inst, owner, target)
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
            end
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.4, nofx = nil }
    },

    siving_turn_collector = {
        base_prefab = "siving_turn", skin_id = "62eb8b9e8c2f781db2f79d21", onlyownedshow = true, mustonwedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/siving_turn_collector.zip")
		},
        string = ischinese and { name = "转星移" } or { name = "Revolving Star" },
        anim = { bank = nil, build = nil, anim = 0 },
		fn_start = function(inst, skined)
            inst.components.genetrans.fxdata.unlockfx = "siving_turn_collector_unlock_fx"
            Fn_start_sivturn(inst, "siving_turn_collector", false)
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
			Asset("ANIM", "anim/skin/siving_turn_future.zip")
		},
        string = ischinese and { name = "爱汪基因诱变舱" } or { name = "Bark Gene Mutation Cabin" },
        anim = { bank = nil, build = nil, anim = 0 },
		fn_start = function(inst, skined)
            inst.components.genetrans.fn_setanim = Fn_sivturn_anim_futrue
            inst.components.genetrans.fxdata.unlockfx = "siving_turn_future_unlock_fx"
            Fn_start_sivturn(inst, "siving_turn_future", false)
        end,
        fn_end = function(inst, skined)
            inst.components.genetrans.fn_setanim = nil
            inst.AnimState:ClearOverrideSymbol("followed")
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
			Asset("ANIM", "anim/skin/siving_turn_future2.zip")
		},
        string = ischinese and { name = "爱喵基因诱变舱" } or { name = "Mew Gene Mutation Cabin" },
        anim = { bank = nil, build = nil, anim = 0 },
		fn_start = function(inst, skined)
            inst.components.genetrans.fn_setanim = Fn_sivturn_anim_futrue
            inst.components.genetrans.fxdata.unlockfx = "siving_turn_future2_unlock_fx"
            Fn_start_sivturn(inst, "siving_turn_future2", false)
        end,
        fn_end = function(inst, skined)
            inst.components.genetrans.fn_setanim = nil
            inst.AnimState:ClearOverrideSymbol("followed")
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
        anim = { bank = nil, build = nil, anim = 0 },
		fn_start = function(inst, skined)
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
        anim = { bank = nil, build = nil, anim = 0 },
		fn_start = function(inst, skined)
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
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
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
            anim = "idle_big", animpush = nil, isloop = nil
        },
        fn_start = function(inst, skined)
            inst.AnimState:SetScale(1.08, 1.08, 1.08)
        end,
        fn_end = function(inst, skined)
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
        anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
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
            anim = "idle_big", animpush = nil, isloop = nil
        },
        fn_start = function(inst, skined)
            inst.AnimState:SetScale(1.08, 1.08, 1.08)
        end,
        fn_end = function(inst, skined)
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
        anim = { bank = "book_maxwell", build = nil, anim = 0 },
		fn_start = function(inst, skined)
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
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
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
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
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
        fn_start = function(inst, skined)
            Fn_start_equip(inst, skined)
            inst.AnimState:SetBank("kitcoon")
            inst.AnimState:SetBuild("siving_feather_real_collector")
            inst.Transform:SetSixFaced()
            inst.AnimState:SetScale(0.9, 0.9)
        end,
        fn_end = function(inst, skined)
            local owner = GetEquippedOwner(inst)
            if owner ~= nil then
                Fn_removeFollowFx(owner, "fx_l_sivfea_real")
            end
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
        fn_start = function(inst, skined)
            Fn_start_equip(inst, skined)
            inst.AnimState:SetBank("kitcoon")
            inst.AnimState:SetBuild("siving_feather_fake_collector")
            inst.Transform:SetSixFaced()
            inst.AnimState:SetScale(0.9, 0.9)
        end,
        fn_end = function(inst, skined)
            local owner = GetEquippedOwner(inst)
            if owner ~= nil then
                Fn_removeFollowFx(owner, "fx_l_sivfea_fake")
            end
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
			Asset("ANIM", "anim/skin/revolvedmoonlight_item_taste.zip"),

            Asset("ANIM", "anim/skin/revolvedmoonlight_taste.zip"),
            Asset("ANIM", "anim/skin/ui_revolvedmoonlight_taste_4x3.zip"),

            Asset("ANIM", "anim/skin/revolvedmoonlight_pro_taste.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "黄桃芒芒" } or { name = "Mango Sundae" },
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.18, size = "small", offset_y = 0.4, scale = 0.55, nofx = nil },

        overridekeys = { "data_up", "data_uppro" },
        data_up = {
            image = {
                name = "revolvedmoonlight_taste", atlas = "images/inventoryimages_skin/revolvedmoonlight_taste.xml",
                setable = true
            },
            floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil },
            fn_start = function(inst, skined)
                inst.AnimState:SetScale(0.85, 0.85, 0.85)
                inst.AnimState:SetBank("revolvedmoonlight_taste")
                inst.AnimState:SetBuild("revolvedmoonlight_taste")
                inst.components.container:Close() --WidgetSetup 之前一定要先关闭，否则会崩溃
                inst.components.container:WidgetSetup("revolvedmoonlight_taste")
            end,
            fn_end = Fn_end_revolved,
            fn_start_c = function(inst, skined)
                SetWidget(inst, "revolvedmoonlight_taste")
            end,
            fn_end_c = SetWidget_revolved
        },
        data_uppro = {
            image = {
                name = "revolvedmoonlight_pro_taste", atlas = "images/inventoryimages_skin/revolvedmoonlight_pro_taste.xml",
                setable = true
            },
            floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil },
            fn_start = function(inst, skined)
                inst.AnimState:SetScale(0.85, 0.85, 0.85)
                inst.AnimState:SetBank("revolvedmoonlight_pro_taste")
                inst.AnimState:SetBuild("revolvedmoonlight_taste")
                inst.components.container:Close()
                inst.components.container:WidgetSetup("revolvedmoonlight_pro_taste")
            end,
            fn_end = Fn_end_revolved_pro,
            fn_start_c = function(inst, skined)
                SetWidget(inst, "revolvedmoonlight_pro_taste")
            end,
            fn_end_c = SetWidget_revolved_pro
        }
    },
    revolvedmoonlight_item_taste2 = { --草莓
        base_prefab = "revolvedmoonlight_item", skin_id = "63889ecd8c2f781db2f7f768", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/revolvedmoonlight_item_taste2.zip"),

            Asset("ANIM", "anim/skin/revolvedmoonlight_taste2.zip"),
            Asset("ANIM", "anim/skin/ui_revolvedmoonlight_taste2_4x3.zip"),

            Asset("ANIM", "anim/skin/revolvedmoonlight_pro_taste2.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "巧遇莓莓" } or { name = "Strawberry Sundae" },
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.18, size = "small", offset_y = 0.4, scale = 0.55, nofx = nil },

        overridekeys = { "data_up", "data_uppro" },
        data_up = {
            image = {
                name = "revolvedmoonlight_taste2", atlas = "images/inventoryimages_skin/revolvedmoonlight_taste2.xml",
                setable = true
            },
            floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil },
            fn_start = function(inst, skined)
                inst.AnimState:SetScale(0.85, 0.85, 0.85)
                inst.AnimState:SetBank("revolvedmoonlight_taste2")
                inst.AnimState:SetBuild("revolvedmoonlight_taste")
                inst.components.container:Close()
                inst.components.container:WidgetSetup("revolvedmoonlight_taste2")
            end,
            fn_end = Fn_end_revolved,
            fn_start_c = function(inst, skined)
                SetWidget(inst, "revolvedmoonlight_taste2")
            end,
            fn_end_c = SetWidget_revolved
        },
        data_uppro = {
            image = {
                name = "revolvedmoonlight_pro_taste2", atlas = "images/inventoryimages_skin/revolvedmoonlight_pro_taste2.xml",
                setable = true
            },
            floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil },
            fn_start = function(inst, skined)
                inst.AnimState:SetScale(0.85, 0.85, 0.85)
                inst.AnimState:SetBank("revolvedmoonlight_pro_taste2")
                inst.AnimState:SetBuild("revolvedmoonlight_taste")
                inst.components.container:Close()
                inst.components.container:WidgetSetup("revolvedmoonlight_pro_taste2")
            end,
            fn_end = Fn_end_revolved_pro,
            fn_start_c = function(inst, skined)
                SetWidget(inst, "revolvedmoonlight_pro_taste2")
            end,
            fn_end_c = SetWidget_revolved_pro
        }
    },
    revolvedmoonlight_item_taste3 = { --柠檬
        base_prefab = "revolvedmoonlight_item", skin_id = "63889eef8c2f781db2f7f76c", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/revolvedmoonlight_item_taste3.zip"),

            Asset("ANIM", "anim/skin/revolvedmoonlight_taste3.zip"),
            Asset("ANIM", "anim/skin/ui_revolvedmoonlight_taste3_4x3.zip"),

            Asset("ANIM", "anim/skin/revolvedmoonlight_pro_taste3.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "奇异柠檬" } or { name = "Lemon Sundae" },
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.18, size = "small", offset_y = 0.4, scale = 0.55, nofx = nil },

        overridekeys = { "data_up", "data_uppro" },
        data_up = {
            image = {
                name = "revolvedmoonlight_taste3", atlas = "images/inventoryimages_skin/revolvedmoonlight_taste3.xml",
                setable = true
            },
            floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil },
            fn_start = function(inst, skined)
                inst.AnimState:SetScale(0.85, 0.85, 0.85)
                inst.AnimState:SetBank("revolvedmoonlight_taste3")
                inst.AnimState:SetBuild("revolvedmoonlight_taste")
                inst.components.container:Close()
                inst.components.container:WidgetSetup("revolvedmoonlight_taste3")
            end,
            fn_end = Fn_end_revolved,
            fn_start_c = function(inst, skined)
                SetWidget(inst, "revolvedmoonlight_taste3")
            end,
            fn_end_c = SetWidget_revolved
        },
        data_uppro = {
            image = {
                name = "revolvedmoonlight_pro_taste3", atlas = "images/inventoryimages_skin/revolvedmoonlight_pro_taste3.xml",
                setable = true
            },
            floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil },
            fn_start = function(inst, skined)
                inst.AnimState:SetScale(0.85, 0.85, 0.85)
                inst.AnimState:SetBank("revolvedmoonlight_pro_taste3")
                inst.AnimState:SetBuild("revolvedmoonlight_taste")
                inst.components.container:Close()
                inst.components.container:WidgetSetup("revolvedmoonlight_pro_taste3")
            end,
            fn_end = Fn_end_revolved_pro,
            fn_start_c = function(inst, skined)
                SetWidget(inst, "revolvedmoonlight_pro_taste3")
            end,
            fn_end_c = SetWidget_revolved_pro
        }
    },
    revolvedmoonlight_item_taste4 = { --黑巧
        base_prefab = "revolvedmoonlight_item", skin_id = "63889f4b8c2f781db2f7f770", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/revolvedmoonlight_item_taste4.zip"),

            Asset("ANIM", "anim/skin/revolvedmoonlight_taste4.zip"),
            Asset("ANIM", "anim/skin/ui_revolvedmoonlight_taste4_4x3.zip"),

            Asset("ANIM", "anim/skin/revolvedmoonlight_pro_taste4.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "黑巧旋涡" } or { name = "Choccy Sundae" },
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.18, size = "small", offset_y = 0.4, scale = 0.55, nofx = nil },

        overridekeys = { "data_up", "data_uppro" },
        data_up = {
            image = {
                name = "revolvedmoonlight_taste4", atlas = "images/inventoryimages_skin/revolvedmoonlight_taste4.xml",
                setable = true
            },
            floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil },
            fn_start = function(inst, skined)
                inst.AnimState:SetScale(0.85, 0.85, 0.85)
                inst.AnimState:SetBank("revolvedmoonlight_taste4")
                inst.AnimState:SetBuild("revolvedmoonlight_taste")
                inst.components.container:Close()
                inst.components.container:WidgetSetup("revolvedmoonlight_taste4")
            end,
            fn_end = Fn_end_revolved,
            fn_start_c = function(inst, skined)
                SetWidget(inst, "revolvedmoonlight_taste4")
            end,
            fn_end_c = SetWidget_revolved
        },
        data_uppro = {
            image = {
                name = "revolvedmoonlight_pro_taste4", atlas = "images/inventoryimages_skin/revolvedmoonlight_pro_taste4.xml",
                setable = true
            },
            floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.3, nofx = nil },
            fn_start = function(inst, skined)
                inst.AnimState:SetScale(0.85, 0.85, 0.85)
                inst.AnimState:SetBank("revolvedmoonlight_pro_taste4")
                inst.AnimState:SetBuild("revolvedmoonlight_taste")
                inst.components.container:Close()
                inst.components.container:WidgetSetup("revolvedmoonlight_pro_taste4")
            end,
            fn_end = Fn_end_revolved_pro,
            fn_start_c = function(inst, skined)
                SetWidget(inst, "revolvedmoonlight_pro_taste4")
            end,
            fn_end_c = SetWidget_revolved_pro
        }
    },

    plant_cactus_meat_l_world = {
        base_prefab = "plant_cactus_meat_l", skin_id = "6473057469b4f368be45295a", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/plant_cactus_meat_l_world.zip")
		},
        string = ischinese and { name = "波蒂球" } or { name = "Dots Cactus" },
        anim = { bank = nil, build = nil, anim = 0 },
		fn_start = function(inst, skined)
            OnSummer_cactus(inst, "plant_cactus_meat_l_world")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        fn_placer = function(inst)
            inst.AnimState:SetBank("plant_cactus_meat_l_world")
            inst.AnimState:SetBuild("plant_cactus_meat_l_world")
        end
    },

    plant_carrot_l_fact = {
        base_prefab = "plant_carrot_l", skin_id = "665f12e7ce45c22cf18e7082", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/plant_carrot_l_fact.zip")
		},
        string = ischinese and { name = "非常正常的胡萝卜" } or { name = "Realistic Carrot" },
        anim = { bank = nil, build = nil, anim = 0 },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        linkedskins = { weapon = "lance_carrot_l_fact" },
        fn_placer = function(inst)
            inst.AnimState:SetBank("plant_carrot_l_fact")
            inst.AnimState:SetBuild("plant_carrot_l_fact")
        end
    },
    lance_carrot_l_fact = {
        base_prefab = "lance_carrot_l", skin_id = "665f12e7ce45c22cf18e7082", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/lance_carrot_l_fact.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "绑一块儿的胡萝卜" } or { name = "Carrots Tied Together" },
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_equip,
        equip = { symbol = "swap_object", build = "lance_carrot_l_fact", file = "swap_object" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil },
        floater = { cut = 0.1, size = "small", offset_y = 0.3, scale = 0.6, nofx = nil }
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
            anim = "item", animpush = nil, isloop = nil
        },
        fn_placer = function(inst)
            if inst.placerbase_l ~= nil then
                inst.placerbase_l.AnimState:SetBank("siving_ctlwater_era")
                inst.placerbase_l.AnimState:SetBuild("siving_ctlwater_era")
            end
        end,
        build_name_override = "siving_ctlwater_era",
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },

        overridekeys = { "data_build" },
        data_build = {
            anim = {
                bank = "siving_ctlwater_era", build = "siving_ctlwater_era",
                anim = "idle", animpush = nil, isloop = nil
            },
            fn_start = Fn_start_siving_ctlwater,
            bars = {
                siv_bar = {
                    x = 0, y = 0, z = 0, scale = nil, followedsymbol = "tag1",
                    bank = "siving_ctlwater_era", build = "siving_ctlwater_era", anim = "bar"
                }
            }
        }
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
            anim = "item", animpush = nil, isloop = nil
        },
        fn_placer = function(inst)
            if inst.placerbase_l ~= nil then
                inst.placerbase_l.AnimState:SetBank("siving_ctldirt_era")
                inst.placerbase_l.AnimState:SetBuild("siving_ctldirt_era")
            end
        end,
        build_name_override = "siving_ctldirt_era",
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },

        overridekeys = { "data_build" },
        data_build = {
            anim = {
                bank = "siving_ctldirt_era", build = "siving_ctldirt_era",
                anim = "idle", animpush = nil, isloop = nil
            },
            fn_start = Fn_start_siving_ctldirt,
            bars = {
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
        }
    },
    siving_ctlall_item_era = {
        base_prefab = "siving_ctlall_item", skin_id = "64759cc569b4f368be452b14", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/siving_ctlall_era.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "耘天图腾柱" } or { name = "Singing Sky Totem Pole" },
		anim = {
            bank = "siving_ctlall_era", build = "siving_ctlall_era",
            anim = "item", animpush = nil, isloop = nil
        },
        fn_placer = function(inst)
            if inst.placerbase_l ~= nil then
                inst.placerbase_l.AnimState:SetBank("siving_ctlall_era")
                inst.placerbase_l.AnimState:SetBuild("siving_ctlall_era")
            end
        end,
        build_name_override = "siving_ctlall_era",
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },

        overridekeys = { "data_build" },
        data_build = {
            anim = {
                bank = "siving_ctlall_era", build = "siving_ctlall_era",
                anim = "idle", animpush = nil, isloop = nil
            },
            fn_start = Fn_start_siving_ctlall,
            bars = {
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
        }
    },

    siving_mask_era = {
        base_prefab = "siving_mask", skin_id = "647b394969b4f368be453202", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/siving_mask_era.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "巫仆血骨面" } or { name = "Blood Servant Bone Mask" },
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_siving_mask,
        maskfx = "siving_lifesteal_fx_era1",
        equip = { symbol = "swap_hat", build = "siving_mask_era", file = "swap_hat", isopentop = true },
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
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_siving_mask,
        maskfx = "siving_lifesteal_fx_era2",
        equip = { symbol = "swap_hat", build = "siving_mask_era2", file = "swap_hat", isopentop = true },
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
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_siving_mask,
        fn_end = function(inst, skined)
            local owner = GetEquippedOwner(inst)
            if owner ~= nil then
                Fn_removeFollowFx(owner, "fx_l_sivmask")
            end
        end,
        maskfx = "siving_lifesteal_fx_era3",
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
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_siving_mask,
        fn_end = function(inst, skined)
            local owner = GetEquippedOwner(inst)
            if owner ~= nil then
                Fn_removeFollowFx(owner, "fx_l_sivmask")
            end
        end,
        maskfx = "siving_lifesteal_fx_era4",
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
			Asset("ANIM", "anim/skin/siving_mask_gold_marble.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "圣洁面纱" } or { name = "Holy Veil" },
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_siving_mask,
        maskfx = "siving_lifesteal_fx_marble",
        equip = { symbol = "swap_hat", build = "siving_mask_gold_marble", file = "swap_hat" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil }
    },

    siving_suit_gold_marble = {
        base_prefab = "siving_suit_gold", skin_id = "6558bf96adf8ac0fd863e870", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
            Asset("ANIM", "anim/skin/siving_suit_gold_marble.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "圣洁长袍" } or { name = "Holy Robe" },
		anim = { bank = nil, build = nil, anim = nil, animpush = nil, isloop = nil },
        fn_start = Fn_start_siving_suit,
        suitfx = "sivsuitatk_fx_marble",
        equip = { symbol = "swap_body", build = "siving_suit_gold_marble", file = "swap_body" },
        exchangefx = { prefab = nil, offset_y = nil, scale = nil }
    },

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
            anim = "item", animpush = nil, isloop = nil
        },
        build_name_override = "siving_soil_law",
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        fn_placer = function(inst)
            inst.AnimState:SetBank("farm_soil")
            inst.AnimState:SetBuild("siving_soil_law")
        end,

        overridekeys = { "data_soil", "data_plant" },
        data_soil = {
            anim = { bank = "farm_soil", build = "siving_soil_law", anim = 0 }
        },
        data_plant = {
            fn_start = function(inst, skined)
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
            anim = "item", animpush = nil, isloop = nil
        },
        build_name_override = "siving_soil_law2",
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        fn_placer = function(inst)
            inst.AnimState:SetBank("farm_soil")
            inst.AnimState:SetBuild("siving_soil_law2")
        end,

        overridekeys = { "data_soil", "data_plant" },
        data_soil = {
            anim = { bank = "farm_soil", build = "siving_soil_law2", anim = 0 }
        },
        data_plant = {
            fn_start = function(inst, skined)
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
            anim = "item", animpush = nil, isloop = nil
        },
        build_name_override = "siving_soil_law3",
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        fn_placer = function(inst)
            inst.AnimState:SetBank("farm_soil")
            inst.AnimState:SetBuild("siving_soil_law3")
        end,

        overridekeys = { "data_soil", "data_plant" },
        data_soil = {
            anim = { bank = "farm_soil", build = "siving_soil_law3", anim = 0 }
        },
        data_plant = {
            fn_start = function(inst, skined)
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
			Asset("ANIM", "anim/skin/refractedmoonlight_taste.zip")
		},
        string = ischinese and { name = "烤肠大王" } or { name = "Roast Sausage King" },
        anim = { bank = nil, build = nil, anim = 0 },
        fn_start = Fn_start_refractedmoonlight,
        equip = {
            img_tex = "refractedmoonlight_taste", img_atlas = "images/inventoryimages_skin/refractedmoonlight_taste.xml",
            img_tex2 = "refractedmoonlight_taste2", img_atlas2 = "images/inventoryimages_skin/refractedmoonlight_taste2.xml",
            build = "refractedmoonlight_taste", fx = "refracted_l_spark_taste_fx"
        },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },

    hiddenmoonlight_item_paper = {
        base_prefab = "hiddenmoonlight_item", skin_id = "655a18f6adf8ac0fd863e900", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/hiddenmoonlight_paper.zip"),
            Asset("ANIM", "anim/skin/hiddenmoonlight_inf_paper.zip")
		},
        image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "星愿满瓶" } or { name = "Star Wishes Bottle" },
		anim = {
            bank = "hiddenmoonlight_paper", build = "hiddenmoonlight_paper",
            anim = "idle_item", animpush = nil, isloop = nil
        },
        build_name_override = "hiddenmoonlight_paper",
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 },
        floater = { cut = 0.1, size = "med", offset_y = 0.3, scale = 0.7, nofx = nil },

        overridekeys = { "data_up", "data_upinf" },
        data_up = {
            exchangefx = { prefab = nil, offset_y = nil, scale = nil },
            fn_start = function(inst, skined)
                inst.AnimState:SetBank("hiddenmoonlight_paper")
                inst.AnimState:SetBuild("hiddenmoonlight_paper")
                inst.AnimState:SetScale(1.5, 1.5, 1.5)
                SetTarget_hidden(inst)
            end,
            fn_end = function(inst, skined)
                inst.AnimState:SetScale(1, 1, 1)
            end
        },
        data_upinf = {
            exchangefx = { prefab = nil, offset_y = nil, scale = nil },
            dd = {
                openfn = function(inst)
                    if math.random() >= 0.975 then
                        if not inst._iscloudsp then
                            inst._iscloudsp = true
                            inst.AnimState:OverrideSymbol("cloud", "hiddenmoonlight_inf_paper", "cloud_sp")
                        end
                    else
                        if inst._iscloudsp then
                            inst._iscloudsp = nil
                            inst.AnimState:OverrideSymbol("cloud", "hiddenmoonlight_inf_paper", "cloud")
                        end
                    end
                end
            },
            fn_start = function(inst, skined)
                if skined ~= nil then
                    inst._dd = skined.dd
                end
                inst.AnimState:SetBank("hiddenmoonlight_paper")
                inst.AnimState:SetBuild("hiddenmoonlight_inf_paper")
                inst.AnimState:SetScale(1.5, 1.5, 1.5)
                SetTarget_hidden(inst)
            end,
            fn_end = function(inst, skined)
                inst.AnimState:SetScale(1, 1, 1)
                inst._iscloudsp = nil
                inst._dd = nil
            end
        }
    },

    chest_whitewood_craft = {
        base_prefab = "chest_whitewood", skin_id = "655e0530adf8ac0fd863ea52", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/chest_whitewood_craft.zip"),
            Asset("ANIM", "anim/skin/chest_whitewood_inf_craft.zip")
		},
        string = ischinese and { name = "花梨木饰顶展台" } or { name = "Decorated Rosewood Cabinet" },
        anim = { bank = nil, build = nil, anim = 0 },
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        fn_placer = function(inst)
            inst.AnimState:SetBank("chest_whitewood_craft")
            inst.AnimState:SetBuild("chest_whitewood_craft")
        end,

        overridekeys = { "data_inf" },
        data_inf = {
            anim = { bank = "chest_whitewood_craft", build = "chest_whitewood_inf_craft", anim = 0 }
        }
    },
    chest_whitewood_craft2 = {
        base_prefab = "chest_whitewood", skin_id = "655e0530adf8ac0fd863ea52", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		-- assets = { Asset("ANIM", "anim/skin/chest_whitewood_craft.zip") },
        string = ischinese and { name = "花梨木展台" } or { name = "Rosewood Cabinet" },
        anim = { bank = "chest_whitewood_craft", build = "chest_whitewood_craft", anim = 0 },
        build_name_override = "chest_whitewood_craft",
		fn_start = function(inst, skined)
            inst.AnimState:HideSymbol("deco")
        end,
        fn_end = function(inst, skined)
            inst.AnimState:ShowSymbol("deco")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        fn_placer = function(inst)
            inst.AnimState:SetBank("chest_whitewood_craft")
            inst.AnimState:SetBuild("chest_whitewood_craft")
            inst.AnimState:HideSymbol("deco")
        end,

        overridekeys = { "data_inf" },
        data_inf = {
            fn_start = function(inst, skined)
                inst.AnimState:SetBank("chest_whitewood_craft")
                inst.AnimState:SetBuild("chest_whitewood_inf_craft")
                inst.AnimState:HideSymbol("deco")
            end,
            fn_end = function(inst, skined)
                inst.AnimState:ShowSymbol("deco")
            end
        }
    },
    chest_whitewood_big_craft = {
        base_prefab = "chest_whitewood_big", skin_id = "655e0530adf8ac0fd863ea52", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		assets = {
			Asset("ANIM", "anim/skin/chest_whitewood_big_craft.zip"),
            Asset("ANIM", "anim/skin/chest_whitewood_big_inf_craft.zip")
		},
        string = ischinese and { name = "花梨木饰顶展柜" } or { name = "Decorated Rosewood Showcase" },
		anim = { bank = nil, build = nil, anim = 0 },
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        fn_placer = function(inst)
            inst.AnimState:SetBank("chest_whitewood_big_craft")
            inst.AnimState:SetBuild("chest_whitewood_big_craft")
        end,

        overridekeys = { "data_inf" },
        data_inf = {
            anim = { bank = "chest_whitewood_big_craft", build = "chest_whitewood_big_inf_craft", anim = 0 }
        }
    },
    chest_whitewood_big_craft2 = {
        base_prefab = "chest_whitewood_big", skin_id = "655e0530adf8ac0fd863ea52", noshopshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = raritySpecial,
		-- assets = { Asset("ANIM", "anim/skin/chest_whitewood_big_craft.zip") },
        string = ischinese and { name = "花梨木展柜" } or { name = "Rosewood Showcase" },
        anim = { bank = "chest_whitewood_big_craft", build = "chest_whitewood_big_craft", anim = 0 },
        build_name_override = "chest_whitewood_big_craft",
		fn_start = function(inst, skined)
            inst.AnimState:HideSymbol("deco")
        end,
        fn_end = function(inst, skined)
            inst.AnimState:ShowSymbol("deco")
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = 1.5 },
        fn_placer = function(inst)
            inst.AnimState:SetBank("chest_whitewood_big_craft")
            inst.AnimState:SetBuild("chest_whitewood_big_craft")
            inst.AnimState:HideSymbol("deco")
        end,

        overridekeys = { "data_inf" },
        data_inf = {
            fn_start = function(inst, skined)
                inst.AnimState:SetBank("chest_whitewood_big_craft")
                inst.AnimState:SetBuild("chest_whitewood_big_inf_craft")
                inst.AnimState:HideSymbol("deco")
            end,
            fn_end = function(inst, skined)
                inst.AnimState:ShowSymbol("deco")
            end
        }
    },

    tourmalinecore_tale = {
        base_prefab = "tourmalinecore", skin_id = "65687273ce45c22cf18df68d", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/tourmalinecore_tale.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "霹雳神灯" } or { name = "Thunder Lamp" },
        anim = { bank = nil, build = nil, anim = 0 },
		fn_start = function(inst, skined)
            inst._dd = skined and skined.fxdata
        end,
        fn_end = function(inst, skined)
            inst._dd = nil
        end,
        fxdata = { name = "eleccore_spark_fx_tale", y = nil, y_rand = nil },
        exchangefx = { prefab = nil, offset_y = nil, scale = 0.8 }
    },

    explodingfruitcake_day = {
        base_prefab = "explodingfruitcake", skin_id = "665eb9ffce45c22cf18e6d75", onlyownedshow = true,
		type = "item", skin_tags = {}, release_group = 555, rarity = rarityRepay,
		assets = {
			Asset("ANIM", "anim/skin/explodingfruitcake_day.zip")
		},
		image = { name = nil, atlas = nil, setable = true },
        string = ischinese and { name = "爱到爆蛋糕" } or { name = "Exploding Love Cake" },
        anim = { bank = nil, build = nil, anim = 0 },
		fn_start = function(inst, skined)
            inst._dd_fxfn = skined and skined.fxfn
        end,
        fn_end = function(inst, skined)
            inst._dd_fxfn = nil
        end,
        fxfn = function(inst)
            local x, y, z = inst.Transform:GetWorldPosition()
            local fx = SpawnPrefab("explode_l_fruitcake_day")
            if fx ~= nil then
                fx.Transform:SetPosition(x, y-4, z)
            end
            fx = SpawnPrefab("explode_l_fruitcake2_day")
            if fx ~= nil then
                fx.Transform:SetPosition(x, y, z)
            end
        end,
        exchangefx = { prefab = nil, offset_y = nil, scale = nil }
    }
}
local SKIN_IDS_LEGION = {
    ["justffffree"] = {}, --免费皮肤全部装这里面
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
        hat_lichen_emo_que = true
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
        revolvedmoonlight_item_taste = true, revolvedmoonlight_item_taste2 = true
    },
    ["637f07a28c2f781db2f7f1e8"] = { --4海名扬
        agronssword_taste = true, soul_contracts_taste = true,
        revolvedmoonlight_item_taste3 = true, revolvedmoonlight_item_taste4 = true,
        carpet_whitewood_law2 = true, carpet_whitewood_big_law2 = true,
        icire_rock_day = true,
        neverfade_paper = true, neverfadebush_paper = true, neverfade_paper2 = true, neverfadebush_paper2 = true,
        siving_feather_real_paper = true, siving_feather_fake_paper = true
    },
    ["642c14d9f2b67d287a35d439"] = { --5谷丰登
        siving_feather_real_collector = true, siving_feather_fake_collector = true,
        plant_cactus_meat_l_world = true,
        siving_ctlwater_item_era = true, siving_ctldirt_item_era = true, siving_ctlall_item_era = true,
        siving_mask_era = true, siving_mask_era2 = true, siving_mask_gold_era = true, siving_mask_gold_era2 = true,
        siving_turn_future = true, siving_turn_future2 = true
    },
    ["61f15bf4db102b0b8a529c66"] = { --6连忘返
        siving_soil_item_law = true, siving_soil_item_law2 = true, siving_soil_item_law3 = true,
        refractedmoonlight_taste = true,
        siving_mask_gold_marble = true, siving_suit_gold_marble = true,
        hiddenmoonlight_item_paper = true,
        chest_whitewood_craft = true, chest_whitewood_big_craft = true,
        chest_whitewood_craft2 = true, chest_whitewood_big_craft2 = true,
        hat_lichen_emo_3shock = true, hat_lichen_emo_shock = true, hat_lichen_emo_anger = true,
        hat_lichen_emo_sweat = true, hat_lichen_emo_heart = true,
        tourmalinecore_tale = true
    },
    -- ["660579cace45c22cf18e4a87"] = nil, --前六期全部
    ["61627d927bbb727be174c4a0"] = { --7开得胜
        explodingfruitcake_day = true,
        plant_carrot_l_fact = true, lance_carrot_l_fact = true,
    },
    -- ["665eb8a8ce45c22cf18e6d24"] = {}, --8面玲珑
    -- ["6278c409c340bf24ab311522"] = nil --余生
}
local SKIN_IDX_LEGION = {
    -- [1] = "rosorns_spell",
}

local AddSkins = function(skins, baseskins)
    for skinname, _ in pairs(baseskins) do
        skins[skinname] = true
    end
end
local ddskins = {
    backcub_fans2 = true, fishhomingtool_awesome_taste = true,
    fishhomingtool_normal_taste = true, fishhomingbait_taste = true
}
AddSkins(ddskins, SKIN_IDS_LEGION["6278c487c340bf24ab31152c"])
AddSkins(ddskins, SKIN_IDS_LEGION["6278c4acc340bf24ab311530"])
AddSkins(ddskins, SKIN_IDS_LEGION["6278c4eec340bf24ab311534"])
AddSkins(ddskins, SKIN_IDS_LEGION["637f07a28c2f781db2f7f1e8"])
AddSkins(ddskins, SKIN_IDS_LEGION["642c14d9f2b67d287a35d439"])
AddSkins(ddskins, SKIN_IDS_LEGION["61f15bf4db102b0b8a529c66"])
SKIN_IDS_LEGION["660579cace45c22cf18e4a87"] = ddskins

ddskins = { siving_turn_collector = true }
AddSkins(ddskins, SKIN_IDS_LEGION["660579cace45c22cf18e4a87"]) --前六期全部
AddSkins(ddskins, SKIN_IDS_LEGION["61627d927bbb727be174c4a0"]) --第七期
-- AddSkins(ddskins, SKIN_IDS_LEGION["665eb8a8ce45c22cf18e6d24"]) --第八期
--后续记得继续补充
SKIN_IDS_LEGION["6278c409c340bf24ab311522"] = ddskins
ddskins = nil
AddSkins = nil

local dirty_cache = true --代表皮肤数据是否需要保存成文件
local ls_cache = { --所有玩家的已有皮肤缓存
    -- Kxx_xxxx = { --用户ID
    --     skinname1 = true,
    --     skinname2 = true,
    -- },
}
local ls_skinmap = { --根据已有皮肤产生的对应表，用以快速比对数据
    -- skinname = userid
}
local ls_cache_ex = { --所有玩家的皮肤切换缓存
    -- Kxx_xxxx = { --用户ID
    --     prefab1 = "skinname1" --上次切换的皮肤名
    -- }
}
local ls_players = { --所有进过这个档的玩家
    -- Kxx_xxxx = true
}
local ls_cache_net = { --所有玩家的网络请求缓存
    -- Kxx_xxxx = { --用户ID
    --     GetSkins = { --某种请求
    --         lastcode = nil, --上次请求的结果
    --         lasttime = nil, --上次请求时的现实时间
    --     }
    -- }
}
local ls_skinneedclients = { --需要请求客户端数据的玩家
    -- Kxx_xxxx = true
}
local ls_skineddata = {} --单独复制出来的皮肤数据，用以暴露出去，会定期修正以防篡改
local ls_patroltime = nil --上次判断的系统时间
local USERID = TheNet:GetUserID() or "OU_fake"
local LSFNS
local ls_buildmap = { --prefab，build与皮肤的对应表，用以比对动画
    -- prefab = { --其中装有所有能用的build
    --     buildname1 = 0, --代表原皮
    --     buildname2 = skinname,
    -- }
    siving_ctlwater = {
        siving_ctlwater = 0, siving_ctlwater_era = "siving_ctlwater_item_era"
    },
    siving_ctldirt = {
        siving_ctldirt = 0, siving_ctldirt_era = "siving_ctldirt_item_era"
    },
    siving_ctlall = {
        siving_ctlall = 0, siving_ctlall_era = "siving_ctlall_item_era"
    },
    siving_soil = {
        siving_soil = 0, siving_soil_law = "siving_soil_item_law", siving_soil_law2 = "siving_soil_item_law2",
        siving_soil_law3 = "siving_soil_item_law3"
    },
    hiddenmoonlight = {
        hiddenmoonlight = 0, hiddenmoonlight_paper = "hiddenmoonlight_item_paper"
    },
    hiddenmoonlight_inf = {
        hiddenmoonlight_inf = 0, hiddenmoonlight_inf_paper = "hiddenmoonlight_item_paper"
    },
    revolvedmoonlight = {
        revolvedmoonlight = 0,
        revolvedmoonlight_taste = {
            revolvedmoonlight_item_taste = true, revolvedmoonlight_item_taste2 = true,
            revolvedmoonlight_item_taste3 = true, revolvedmoonlight_item_taste4 = true
        }
    },
    revolvedmoonlight_pro = {
        revolvedmoonlight = 0,
        revolvedmoonlight_taste = {
            revolvedmoonlight_item_taste = true, revolvedmoonlight_item_taste2 = true,
            revolvedmoonlight_item_taste3 = true, revolvedmoonlight_item_taste4 = true
        }
    },
    backcub = {
        backcub_thanks = "backcub_thanks", backcub_fans2 = "backcub_fans2"
    },
    siving_feather_real = {
        siving_feather_real_collector = "siving_feather_real_collector"
    },
    siving_feather_fake = {
        siving_feather_fake_collector = "siving_feather_fake_collector"
    },
    chest_whitewood_inf = {
        chest_whitewood_inf = 0, chest_whitewood_inf_craft = "chest_whitewood_craft"
    },
    chest_whitewood_big_inf = {
        chest_whitewood_big_inf = 0, chest_whitewood_big_inf_craft = "chest_whitewood_big_craft"
    }
}

------皮肤排序
local skinidxes = {
    "chest_whitewood_craft", "chest_whitewood_big_craft", "chest_whitewood_craft2", "chest_whitewood_big_craft2",
    "siving_ctlwater_item_era", "siving_ctldirt_item_era", "siving_ctlall_item_era",
    "neverfade_thanks", "neverfadebush_thanks", "siving_derivant_thanks", "siving_derivant_thanks2",
    "backcub_thanks",
    "fishhomingtool_awesome_thanks", "fishhomingtool_normal_thanks", "fishhomingbait_thanks",
    "siving_feather_real_collector", "siving_feather_fake_collector",
    "siving_turn_collector", "icire_rock_collector", "fimbul_axe_collector", "rosebush_collector", "rosorns_collector",
    "neverfade_paper", "neverfadebush_paper", "neverfade_paper2", "neverfadebush_paper2",
    "tourmalinecore_tale",
    "siving_turn_future", "siving_turn_future2",
    "hiddenmoonlight_item_paper", "siving_feather_real_paper", "siving_feather_fake_paper",
    "explodingfruitcake_day", "icire_rock_day",
    "siving_soil_item_law", "siving_soil_item_law2", "siving_soil_item_law3",
    "carpet_whitewood_law", "carpet_whitewood_big_law", "carpet_whitewood_law2", "carpet_whitewood_big_law2",
    "refractedmoonlight_taste", "agronssword_taste", "soul_contracts_taste",
    "revolvedmoonlight_item_taste", "revolvedmoonlight_item_taste2",
    "revolvedmoonlight_item_taste3", "revolvedmoonlight_item_taste4",
    "siving_mask_era", "siving_mask_era2", "siving_mask_gold_era", "siving_mask_gold_era2",
    "triplegoldenshovelaxe_era", "tripleshovelaxe_era", "lilybush_era", "lileaves_era", "shield_l_log_era",
    "icire_rock_era", "shield_l_sand_era",
    "plant_cactus_meat_l_world", "orchidbush_disguiser", "boltwingout_disguiser",
    "siving_mask_gold_marble", "siving_suit_gold_marble",
    "rosebush_marble", "rosorns_marble", "lilybush_marble", "lileaves_marble", "orchidbush_marble", "orchitwigs_marble",
    "plant_carrot_l_fact", "lance_carrot_l_fact",
    "hat_lichen_emo_3shock", "hat_lichen_emo_shock", "hat_lichen_emo_anger", "hat_lichen_emo_sweat",
    "hat_lichen_emo_heart", "shield_l_log_emo_fist", "hat_lichen_emo_que",

    "fishhomingtool_awesome_taste", "fishhomingtool_normal_taste", "fishhomingbait_taste",
    "backcub_fans2", "backcub_fans",
    "shield_l_log_emo_pride", "shield_l_sand_op", "pinkstaff_tvplay",  "hat_cowboy_tvplay", "hat_lichen_disguiser",
    "orchitwigs_disguiser"
}
for i, skinname in pairs(skinidxes) do
    SKIN_IDX_LEGION[i] = skinname

    local dd = SKINS_LEGION[skinname]
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
skinidxes = nil

------皮肤相关数据补充
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
for skinname, v in pairs(SKINS_LEGION) do
    if SKIN_IDS_LEGION[v.skin_id] == nil then
        SKIN_IDS_LEGION[v.skin_id] = {}
    end
    SKIN_IDS_LEGION[v.skin_id][skinname] = true

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
        table.insert(skininvs, v.image.name)
	end
	if v.anim ~= nil then
		InitData_anim(v.anim, skinname, skinname)
        local builds = ls_buildmap[v.base_prefab]
        if builds == nil then
            builds = {}
            ls_buildmap[v.base_prefab] = builds
        end
        builds[v.anim.build] = skinname
	end
    if v.floater ~= nil and v.floater.anim ~= nil then
        if v.anim ~= nil then
            InitData_anim(v.floater.anim, v.anim.bank, v.anim.bank.build)
        else
            InitData_anim(v.floater.anim, skinname, skinname)
        end
	end
	if v.build_name_override == nil then
		v.build_name_override = skinname
	end
    if v.assets ~= nil then
        for kk, ast in pairs(v.assets) do
            table.insert(Assets, ast)
        end
        v.assets = nil
    end
    -- if v.exchangefx ~= nil then
    --     if v.exchangefx.prefab == nil then
    --         v.exchangefx.prefab = "explode_reskin"
    --     end
    -- end

    table.insert(v.skin_tags, string.upper(skinname))
    table.insert(v.skin_tags, "CRAFTABLE")

    STRINGS.SKIN_NAMES[skinname] = v.string.name
    v.string = nil

    ------修改PREFAB_SKINS(在prefabskins.lua中被定义)
    if _G.PREFAB_SKINS[v.base_prefab] == nil then
        _G.PREFAB_SKINS[v.base_prefab] = { skinname }
    else
        table.insert(_G.PREFAB_SKINS[v.base_prefab], skinname)
    end
end
for baseprefab, v in pairs(SKIN_DEFAULT_LEGION) do
    if v.anim ~= nil then
		InitData_anim(v.anim, baseprefab, baseprefab)
        local builds = ls_buildmap[baseprefab]
        if builds == nil then
            builds = {}
            ls_buildmap[baseprefab] = builds
        end
        builds[v.anim.build] = 0
	end
    if v.floater ~= nil and v.floater.anim ~= nil then
        if v.anim ~= nil then
            InitData_anim(v.floater.anim, v.anim.bank, v.anim.bank.build)
        else
            InitData_anim(v.floater.anim, baseprefab, baseprefab)
        end
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
	end
    if v.overridekeys ~= nil then
        for _, k in ipairs(v.overridekeys) do
            if v[k].exchangefx == nil then --特效！
                v[k].exchangefx = v.exchangefx
            end
        end
    end
    _G[baseprefab.."_clear_fn"] = function(inst) end --【服务器】给CreatePrefabSkin()用的
end

------注册图片资源
for _, v in ipairs(skininvs) do
    table.insert(Assets, Asset("ATLAS", "images/inventoryimages_skin/"..v..".xml"))
    table.insert(Assets, Asset("IMAGE", "images/inventoryimages_skin/"..v..".tex"))
    table.insert(Assets, Asset("ATLAS_BUILD", "images/inventoryimages_skin/"..v..".xml", 256))
    RegisterInventoryItemAtlas("images/inventoryimages_skin/"..v..".xml", v..".tex")
end
skininvs = nil
ischinese = nil

------添加PREFAB_SKINS_IDS的数据(在prefabskins.lua中被定义)
for prefab, _ in pairs(SKIN_DEFAULT_LEGION) do
    local skins = _G.PREFAB_SKINS[prefab]
    if skins ~= nil then
        local newids = {}
        for k, skinname in pairs(skins) do
            newids[skinname] = k
        end
        _G.PREFAB_SKINS_IDS[prefab] = newids
    end
end

------生成皮肤复制数据
local SkinsOverride = {
	siving_soil_item = true, hiddenmoonlight_item = true, revolvedmoonlight_item = true,
    siving_ctlwater_item = true, siving_ctldirt_item = true, siving_ctlall_item = true,
    chest_whitewood = true, chest_whitewood_big = true
}
local nocopykeys = {
    skin_id = true, skin_idx = true, onlyownedshow = true, mustonwedshow = true, overridekeys = true,
    linkedskins = true
}
CopySkinedData(ls_skineddata, SKIN_DEFAULT_LEGION, nocopykeys)
CopySkinedData(ls_skineddata, SKINS_LEGION, nocopykeys)

--------------------------------------------------------------------------
--[[ 添加不可修改元表 ]]
--------------------------------------------------------------------------

-- local mtable = { __newindex = function(t, k, v)end }
-- setmetatable(c, mtable)

--------------------------------------------------------------------------
--[[ 全局函数 ]]
--------------------------------------------------------------------------

local LS_C_SetSkin
local DoPeriodicPatrol
local task_periodicpatrol

local function FnRpc_s2c(userid, handlename, data) --【服务器】
    local datajson
    if data ~= nil and type(data) == "table" then --只对表进行json字符化
        local success
        success, datajson = pcall(json.encode, data)
        if not success then
            return
        end
    end
    SendModRPCToClient(GetClientModRPC("LegionSkin", handlename), userid, datajson)
end
local function FnRpc_c2s(handlename, data) --【客户端】
    local datajson
    if data ~= nil and type(data) == "table" then --只对表进行json字符化
        local success
        success, datajson = pcall(json.encode, data)
        if not success then
            return
        end
    end
    SendModRPCToServer(GetModRPC("LegionSkin", handlename), datajson)
end
local function FnRpc_s2s(shardid, handlename, data) --【服务器】
    local datajson
    if data ~= nil and type(data) == "table" then --只对表进行json字符化
        local success
        success, datajson = pcall(json.encode, data)
        if not success then
            return
        end
    end
    SendModRPCToShard(GetShardModRPC("LegionSkin", handlename), shardid, datajson)
end

local function UpdateSkinMap(userid, skins)
    if skins == nil then
        return
    end
    for skinname, _ in pairs(skins) do
        ls_skinmap[skinname] = userid
    end
end
local function NewSkinMap()
    ls_skinmap = {}
    for userid, skins in pairs(ls_cache) do
        UpdateSkinMap(userid, skins)
    end
end
local function LS_IsTableEmpty(t)
    return t == nil or next(t) == nil
end
local function IsOnlineMode(userid) --之所以这样判断是怕别的mod改动 TheNet:IsOnlineMode() 这个
    return TheNet:IsOnlineMode() and string.sub(userid, 1, 2) == "KU" --离线模式下的id是“OU”开头的
end
local function SkinCache2Numbers(skins) --皮肤数据转为id集合，用以传输。这样能缩减字符数据量
    if LS_IsTableEmpty(skins) then
        return nil
    end
    local nums = {}
    local dd
    for skinname, _ in pairs(skins) do
        dd = SKINS_LEGION[skinname]
        if dd ~= nil and dd.skin_idx ~= nil then
            table.insert(nums, dd.skin_idx)
        end
    end
    return nums
end
local function SkinNumbers2Cache(nums) --皮肤id集合转化为正常数据
    local skins = {}
    for _, num in pairs(nums) do
        if SKIN_IDX_LEGION[num] ~= nil then
            skins[SKIN_IDX_LEGION[num]] = true
        end
    end
    return skins
end
local function LS_IsValidPlayer(player) --判断一个玩家是否有效
    return player ~= nil and player.userid ~= nil and player.userid ~= ""
end
local function LS_HasSkin(skinname, userid) --【服务器、客户端】判断一个玩家是否有某个皮肤
    if skinname == nil then
        return true
    elseif SKIN_IDS_LEGION.justffffree[skinname] then
        return true
    elseif userid ~= nil and ls_cache[userid] ~= nil and ls_cache[userid][skinname] then
        return true
    end
    return false
end
local function LS_LastChosenSkin(prefabname, userid) --【服务器、客户端】获取一个玩家对某实体上次切换的皮肤
    if ls_cache_ex[userid] ~= nil then
        return ls_cache_ex[userid][prefabname]
    end
end
local function LS_SkinCache2File() --【服务器、客户端】将皮肤数据缓存为文件
    if not dirty_cache then
        return
    end
    if IsServer then
        local data = { pp = ls_players, dd = ls_cache, origin = TheWorld.meta.session_identifier }
        local res, datajson = pcall(function() return json.encode(data) end)
        if res then
            dirty_cache = false
            if TheNet:IsDedicated() then --单纯的服务器进程，会自动设定为当前存档目录
                TheSim:SetPersistentString("shardiindex", datajson, true) --第三个参数代表文件是否加密
            elseif TheNet:GetServerIsClientHosted() then --无洞穴的服务器进程，得自己设定存档目录，否则就存入客户端目录了
                TheSim:SetPersistentStringInClusterSlot(ShardGameIndex:GetSlot(), "Master", "shardiindex", datajson, true)
            end
        end
    end
    if not TheNet:IsDedicated() then --客户端或者不带洞穴的服务器
        if not IsOnlineMode(USERID) then --离线模式，客户端不需要缓存数据，免得数据混乱
            dirty_cache = false
            return
        end
        local data = { dd = {}, ex = {} } --只保存自己的
        if ls_cache[USERID] ~= nil then
            data.dd[USERID] = ls_cache[USERID]
        end
        if ls_cache_ex[USERID] ~= nil then
            data.ex[USERID] = ls_cache_ex[USERID]
        end
        local res, datajson = pcall(function() return json.encode(data) end)
        if res then
            dirty_cache = false
            TheSim:SetPersistentString("shardiindex_time", datajson, true) --存入客户端目录
        end
    end
end
local function SaveSkinEx(userid, skin_name, prefabname) --记录皮肤交换行为
    local caches = ls_cache_ex[userid]
    if caches == nil then
        caches = {}
        ls_cache_ex[userid] = caches
    end
    caches[prefabname] = skin_name --空值代表原皮
end

local function UI_ExpansionShow(myskins, count, idx, skinids)
    for skinname, _ in pairs(SKIN_IDS_LEGION[skinids[idx]]) do
        if myskins[skinname] then
            count = count + 1
            if count >= 2 then
                return true
            end
            break
        end
    end
    idx = idx + 1
    if skinids[idx] == nil then
        return false
    else
        return UI_ExpansionShow(myskins, count, idx, skinids)
    end
end
local function LS_UI_ResetItems(self) --更新鸡毛铺界面
    if not LS_IsValidPlayer(self.owner) then
        return
    end

    --记下之前选中的皮肤
	local selected_skin = self.selected_item ~= nil and self.selected_item.item_key or nil
    local selected_item = nil

    --确定展示配置
    local myskins = ls_cache[self.owner.userid] or {}
    -- local myskins = {
    --     lileaves_marble = true,
    --     icire_rock_era = true,
    -- }
    local expansionshow = false
    if not LS_IsTableEmpty(myskins) then
        if
            myskins["siving_turn_collector"] or myskins["icire_rock_collector"] or
            myskins["backcub_fans"]
        then
            expansionshow = true
        else
            expansionshow = UI_ExpansionShow(myskins, 0, 1, {
                "6278c487c340bf24ab31152c", "6278c4acc340bf24ab311530", "6278c4eec340bf24ab311534",
                "637f07a28c2f781db2f7f1e8", "642c14d9f2b67d287a35d439", "61f15bf4db102b0b8a529c66"
            })
        end
    end

    --初始化皮肤项
    local items = {}
    for idx, skinname in pairs(SKIN_IDX_LEGION) do
        local v = SKINS_LEGION[skinname]
        if v ~= nil then
            if not v.noshopshow then
                local isowned = false
                if v.skin_id == "justffffree" or myskins[skinname] then
                    isowned = true
                end
                if
                    isowned or --自己拥有的
                    (expansionshow and not v.mustonwedshow) or --拓展显示
                    (not expansionshow and not v.onlyownedshow) --默认显示
                then
                    local item = {
                        item_key = skinname,
                        item_id = skinname, --(不管)
                        owned_count = 0, --已拥有数量(不管)
                        isnew = false, --是否新皮肤(不管)
                        isfocused = false, --是否处于被鼠标移入状态(不管)
                        isselected = false, --是否处于选中状态
                        isowned = isowned, --是否拥有该皮肤
                        isunlockable = not isowned, --是否可解锁
                        idx = nil,
                        context = nil --存下的组件
                    }
                    table.insert(items, item)
                    if selected_item == nil and selected_skin ~= nil and selected_skin == skinname then
                        selected_item = item
                    end
                end
            end
        end
    end
    self:SetItems(items)

    if selected_item ~= nil then --恢复之前选中的皮肤
        self:SetItemInfo(selected_item)
    else --默认选中第一个
        self:SetItemInfo(items[1])
    end
end

local function SaveQueryCache(userid, querykey, code, needtime)
    local dd = ls_cache_net[userid] or {}
    if dd[querykey] == nil then
        dd[querykey] = {}
    end
    dd[querykey].lastcode = code
    if needtime or dd[querykey].lasttime == nil then
        dd[querykey].lasttime = os.time() or 0
    end
    ls_cache_net[userid] = dd
end
local function CoolForQuery(userid, querykey, force, forcecool, autocool)
    if ls_cache_net[userid] ~= nil and ls_cache_net[userid][querykey] ~= nil then
        local dd = ls_cache_net[userid][querykey]
        if dd.lastcode ~= 1 and dd.lastcode ~= 0 then --上次是失败的，那就可以请求
            return true
        end
        local ostime = os.time() or 0
        if force then
            if forcecool ~= nil and (ostime - dd.lasttime) < forcecool then --强制刷新，xx秒内不重复调用
                return false
            end
        elseif autocool ~= nil and (ostime - dd.lasttime) < autocool then --自动刷新，xx秒内不重复调用
            return false
        end
    end
    return true --什么数据都没有，当然可以请求
end
local function DoNothing(code, data) end
local function QueryManage(urlparams, isget, data, fn_handle) --【服务器】
    local params = nil
    if fn_handle == nil then
        fn_handle = DoNothing
    end
    if not isget and data ~= nil then
        local res
        res, params = pcall(function() return json.encode(data) end)
        if not res then
            fn_handle(-2, nil)
            return
        end
    end
    TheSim:QueryServer(urlparams, function(result_json, isSuccessful, resultCode)
        if isSuccessful and resultCode == 200 then
            local status, data = pcall(function() return json.decode(result_json) end)
            --local status, data = pcall(json.decode, result_json) --之前官方是有这样写法的，但不知道为啥后来全消失了
            if status then
                fn_handle(1, data)
            else
                fn_handle(-3, nil)
            end
        else
            fn_handle(-1, resultCode)
        end
    end, isget and "GET" or "POST", params)
end

local function CloseGame()
    ls_cache = {}
    ls_cache_ex = {}
    dirty_cache = true
    if IsServer then
        c_save()
    else
        LS_SkinCache2File()
    end
    if TheWorld ~= nil then
        TheWorld:DoTaskInTime(10, function()
            os.date("%h")
        end)
    end
end
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
local function SetSkinReward(skins)
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
            skins["revolvedmoonlight_item_taste2"] = true
        elseif countyy >= 1 then
            if skins["revolvedmoonlight_item_taste"] then
                skins["revolvedmoonlight_item_taste2"] = true
            else
                skins["revolvedmoonlight_item_taste"] = true
            end
        end
    end

    --全皮奖励
    Reward123(skins)
    Reward456(skins)
end
local function CheckSkinDifference(userid, newskins) --【服务器】检查皮肤缓存和后台数据的差异性
    local skins = ls_cache[userid]
    if newskins == nil then --如果服务器上没有皮肤，则判断缓存里有没有皮肤
        if skins ~= nil then
            for skinname, _ in pairs(skins) do
                return false
            end
        end
    else --如果服务器上有皮肤，则判断缓存里的某些皮肤与服务器皮肤的差异
        if skins ~= nil then
            local skinsmap = {
                carpet_whitewood_law = true,
                carpet_whitewood_big_law = true,
                revolvedmoonlight_item_taste = true,
                revolvedmoonlight_item_taste2 = true,
                backcub_fans2 = true,
                fishhomingtool_normal_taste = true,
                fishhomingtool_awesome_taste = true,
                fishhomingbait_taste = true
            }
            for skinname, _ in pairs(skins) do
                if not skinsmap[skinname] and not newskins[skinname] then
                    return false
                end
            end
        end
    end
    return true
end
local function CheckCodeSafety()
    for name, gfn in pairs(LSFNS) do
        if gfn ~= _G[name] then
            CloseGame()
            return true
        end
    end

    --检查免费皮肤
    local freeskins = {
        orchitwigs_disguiser = true, hat_lichen_disguiser = true,
        hat_cowboy_tvplay = true, pinkstaff_tvplay = true,
        shield_l_log_emo_pride = true, shield_l_sand_op = true
    }
    for skinname, _ in pairs(SKIN_IDS_LEGION.justffffree) do
        if freeskins[skinname] == nil then
            CloseGame()
            return true
        end
    end

    --检查皮肤数据
    local skinsmap = {
        neverfadebush_paper = {
            id = "638362b68c2f781db2f7f524",
            linkids = {
                ["637f07a28c2f781db2f7f1e8"] = true, --4
                ["6278c409c340bf24ab311522"] = true,
                ["660579cace45c22cf18e4a87"] = true, --前六
            }
        },
        revolvedmoonlight_item_taste2 = {
            id = "63889ecd8c2f781db2f7f768",
            linkids = {
                ["6278c4eec340bf24ab311534"] = true, --3
                ["6278c409c340bf24ab311522"] = true,
                ["660579cace45c22cf18e4a87"] = true, --前六
            }
        },
        rosebush_collector = {
            id = "62e3c3a98c2f781db2f79abc",
            linkids = {
                ["6278c4eec340bf24ab311534"] = true, --3
                ["62eb7b148c2f781db2f79cf8"] = true, --花
                ["6278c409c340bf24ab311522"] = true,
                ["660579cace45c22cf18e4a87"] = true, --前六
            }
        },
        rosebush_marble = {
            id = "619108a04c724c6f40e77bd4",
            linkids = {
                ["6278c487c340bf24ab31152c"] = true, --1
                ["62eb7b148c2f781db2f79cf8"] = true, --花
                ["6278c450c340bf24ab311528"] = true, --忆
                ["6278c409c340bf24ab311522"] = true,
                ["660579cace45c22cf18e4a87"] = true, --前六
            }
        },
        lilybush_era = {
            id = "629b0d5f8c2f781db2f77f0d",
            linkids = {
                ["6278c4acc340bf24ab311530"] = true, --2
                ["62eb7b148c2f781db2f79cf8"] = true, --花
                ["6278c409c340bf24ab311522"] = true,
                ["660579cace45c22cf18e4a87"] = true, --前六
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
        backcub_fans2 = {
            id = "6309c6e88c2f781db2f7ae20",
            linkids = {
                ["6278c409c340bf24ab311522"] = true,
                ["660579cace45c22cf18e4a87"] = true, --前六
            }
        },
        fishhomingbait_taste = {
            id = "61ff45880a30fc7fca0db5e5",
            linkids = {
                ["6278c409c340bf24ab311522"] = true,
                ["660579cace45c22cf18e4a87"] = true, --前六
            }
        },
        soul_contracts_taste = {
            id = "638074368c2f781db2f7f374",
            linkids = {
                ["637f07a28c2f781db2f7f1e8"] = true, --4
                ["6278c409c340bf24ab311522"] = true,
                ["660579cace45c22cf18e4a87"] = true, --前六
            }
        },
        siving_ctlall_item_era = {
            id = "64759cc569b4f368be452b14",
            linkids = {
                ["642c14d9f2b67d287a35d439"] = true, --5
                ["6278c409c340bf24ab311522"] = true,
                ["660579cace45c22cf18e4a87"] = true, --前六
            }
        },
        siving_soil_item_law3 = {
            id = "65560bdbadf8ac0fd863e6da",
            linkids = {
                ["61f15bf4db102b0b8a529c66"] = true, --6
                ["6278c409c340bf24ab311522"] = true,
                ["660579cace45c22cf18e4a87"] = true, --前六
            }
        },
        chest_whitewood_craft = {
            id = "655e0530adf8ac0fd863ea52",
            linkids = {
                ["61f15bf4db102b0b8a529c66"] = true, --6
                ["6278c409c340bf24ab311522"] = true,
                ["660579cace45c22cf18e4a87"] = true, --前六
            }
        }
    }
    for name, v in pairs(skinsmap) do --不准篡改皮肤数据
        if SKINS_LEGION[name].skin_id ~= v.id then
            CloseGame()
            return true
        end
        for idd, value in pairs(SKIN_IDS_LEGION) do
            if idd ~= v.id and value[name] and not v.linkids[idd] then
                CloseGame()
                return true
            end
        end
    end
    skinsmap = {
        rosebush = {
            rosebush_marble = true, rosebush_collector = true
        },
        orchidbush = {
            orchidbush_marble = true, orchidbush_disguiser = true
        },
        neverfadebush = {
            neverfadebush_thanks = true, neverfadebush_paper = true, neverfadebush_paper2 = true
        },
        icire_rock = {
            icire_rock_era = true, icire_rock_collector = true, icire_rock_day = true
        },
        siving_derivant = {
            siving_derivant_thanks = true, siving_derivant_thanks2 = true
        },
        siving_turn = {
            siving_turn_collector = true, siving_turn_future = true, siving_turn_future2 = true
        },
        refractedmoonlight = {
            refractedmoonlight_taste = true
        },
        chest_whitewood_big = {
            chest_whitewood_big_craft = true, chest_whitewood_big_craft2 = true
        }
    }
    for name, v in pairs(skinsmap) do --不准私自给皮肤改名
        for sname, sv in pairs(SKINS_LEGION) do
            if sv.base_prefab == name and not v[sname] then
                CloseGame()
                return true
            end
        end
    end

    --重新复制数据
    local newskineddata = {}
    CopySkinedData(newskineddata, SKIN_DEFAULT_LEGION, nocopykeys)
    CopySkinedData(newskineddata, SKINS_LEGION, nocopykeys)
    ls_skineddata = newskineddata
    _G.ls_skineddata = newskineddata

    if not IsServer then return end
    if task_periodicpatrol == nil or task_periodicpatrol.fn ~= DoPeriodicPatrol then
        CloseGame()
        return true
    end
end

local function LS_N_GetSkins(userid, force) --【网络】【服务器】获取一个玩家的已有皮肤数据
    local querykey = "GetSkins"
    if not CoolForQuery(userid, querykey, force, 5, 240) then
        return
    end
    if not ls_players[userid] then --进过档的玩家id才能请求数据
        SaveQueryCache(userid, querykey, -5, true)
        return
    end
    if string.sub(userid, 1, 2) ~= "KU" then --离线模式下的id是“OU”开头的
        ls_skinneedclients[userid] = 1
        FnRpc_s2c(userid, "GetClientSkins")
        SaveQueryCache(userid, querykey, -4, true)
        return
    end
    SaveQueryCache(userid, querykey, 0, true)
    QueryManage(
    "https://fireleaves.cn/account/locakedSkin?mid=6041a52be3a3fb1f530b550a&id="..userid,
    true, nil, function(code, data)
        SaveQueryCache(userid, querykey, code, false)
        if code ~= 1 then
            if code == -1 then --代表网络或服务器出问题了
                --在线模式：没皮肤才去客户端拿皮肤；离线模式：一直去客户端拿皮肤
                if force or not TheNet:IsOnlineMode() or LS_IsTableEmpty(ls_cache[userid]) then
                    ls_skinneedclients[userid] = 1
                    FnRpc_s2c(userid, "GetClientSkins")
                end
            end
            return
        end
        local skins = nil
        if data ~= nil then
            if data.lockedSkin ~= nil and type(data.lockedSkin) == "table" then
                for kk, skinid in pairs(data.lockedSkin) do
                    local skinkeys = SKIN_IDS_LEGION[skinid]
                    if skinkeys ~= nil then
                        if skins == nil then
                            skins = {}
                        end
                        for skinname, _ in pairs(skinkeys) do
                            if SKINS_LEGION[skinname] ~= nil then
                                skins[skinname] = true
                            end
                        end
                    end
                end
            end
        end
        if CheckSkinDifference(userid, skins) then
            SetSkinReward(skins) --奖励皮肤
            ls_cache[userid] = skins --服务器传来的数据是啥就是啥
            UpdateSkinMap(userid, skins)
        else
            skins = nil
            ls_cache[userid] = nil
            ls_cache_ex[userid] = nil
            NewSkinMap()
            print("LS: Skin Punishment!")
        end
        dirty_cache = true
        local nums = SkinCache2Numbers(skins)
        FnRpc_s2c(userid, "UpdateSkinsClient", nums)
        if LookupPlayerInstByUserID(userid) ~= nil then --玩家所在的世界才需要向其他世界发送皮肤数据
            FnRpc_s2s(nil, "UpdateSkinsShard", { nums = nums, userid = userid })
        end
        if ls_cache_net[userid] ~= nil then --清除冷却时间好让玩家重新恢复问题皮肤
            ls_cache_net[userid]["DealProblemSkins"] = nil
        end
    end)
end
local function LS_N_UseCDK(userid, cdk, force) --【网络】【服务器】使用cdk
    local querykey = "UseCDK"
    if not CoolForQuery(userid, querykey, force, 5, 5) then
        return
    end
    if not ls_players[userid] then --进过档的玩家id才能请求数据
        SaveQueryCache(userid, querykey, -5, true)
        FnRpc_s2c(userid, "CallBackSkinTip", { state = -1, pop = -1 })
        return
    end
    if string.sub(userid, 1, 2) ~= "KU" then --离线模式下的id是“OU”开头的
        SaveQueryCache(userid, querykey, -4, true)
        FnRpc_s2c(userid, "CallBackSkinTip", { state = -1, pop = -1 })
        return
    end
    SaveQueryCache(userid, querykey, 0, true)
    QueryManage("https://fireleaves.cn/cdk/use", false, { cdkStr = cdk, id = userid }, function(code, data)
        if code ~= 1 then
            SaveQueryCache(userid, querykey, code, false)
            FnRpc_s2c(userid, "CallBackSkinTip", { state = -1, pop = -1 })
            return
        end
        local stat
        if data ~= nil and data.code == 0 then
            stat = 1
            LS_N_GetSkins(userid, true) --cdk兑换成功，重新获取皮肤数据
        else
            stat = -1
        end
        SaveQueryCache(userid, querykey, stat, false)
        FnRpc_s2c(userid, "CallBackSkinTip", { state = stat, pop = -1 })
    end)
end

local function PeriodicPatrol(inst, list, idx, numall)
    if list[idx] == nil then
        inst:DoTaskInTime(10, function()
            NewSkinMap()
        end)
        return
    end
    LS_N_GetSkins(list[idx], false)
    if idx >= numall then
        inst:DoTaskInTime(10, function()
            NewSkinMap()
        end)
        return
    end
    inst:DoTaskInTime(2+3*math.random(), function()
        PeriodicPatrol(inst, list, idx + 1, numall)
    end)
end
DoPeriodicPatrol = function(inst)
    if CheckCodeSafety() then
        return
    end

    --更新当前玩家以及所有很久未更新的玩家
    local list = {}
    local ostime = os.time() or 0
    local players = {}
    for _, v in ipairs(AllPlayers) do
        if LS_IsValidPlayer(v) then
            players[v.userid] = true
            table.insert(list, v.userid)
        end
    end
    for userid, _ in pairs(ls_players) do
        if not players[userid] then
            local netdd = ls_cache_net[userid] and ls_cache_net[userid]["GetSkins"] or nil
            if netdd == nil or netdd.lasttime == nil or (ostime - netdd.lasttime) >= 14400 then --30天
                table.insert(list, userid)
            end
        end
    end
    ls_patroltime = ostime

    local numall = #list
    if numall > 0 then
        PeriodicPatrol(inst, list, 1, numall)
    end
end
local function LS_StartPeriodicPatrol(inst) --周期更新所有玩家的皮肤缓存
    if task_periodicpatrol ~= nil then
        task_periodicpatrol:Cancel()
    end
    task_periodicpatrol = inst:DoPeriodicTask(4800, DoPeriodicPatrol, 240+240*math.random())
    -- task_periodicpatrol = inst:DoPeriodicTask(400, DoPeriodicPatrol, 15)
end

------
--组件相关
------

local function C_SetAnim(inst, data)
    --官方代码写得挺好，直接改动画模板居然能继承已有的动画播放和symbol切换状态
	inst.AnimState:SetBank(data.bank)
	inst.AnimState:SetBuild(data.build)
    if data.anim == 0 then --有时候只想更新模板而不是动画
        return
    end
	if data.animpush then
		inst.AnimState:PlayAnimation(data.anim)
		inst.AnimState:PushAnimation(data.animpush, data.isloop)
	else
		inst.AnimState:PlayAnimation(data.anim, data.isloop)
	end
end
local function C_Float_OnLandedClient(floatcpt, ...)
    local skincpt = floatcpt.inst.components.skinedlegion
    if skincpt._floater_nofx then
        floatcpt.showing_effect = true
    else
        floatcpt.OnLandedClient_ls(floatcpt, ...)
        if skincpt._floater_cut ~= nil then
            floatcpt.inst.AnimState:SetFloatParams(skincpt._floater_cut, 1, floatcpt.bob_percent)
        end
    end
end
local function C_EmptyAnim(floatcpt, ...)end
local function C_SetFloat(floatcpt, skindata)
	--设置水面动画
	if skindata.floater ~= nil then
		if skindata.floater.fn_anim ~= nil then
			floatcpt.SwitchToFloatAnim = function(floater, ...)
				skindata.floater.fn_anim(floater.inst)
			end
		elseif skindata.floater.anim ~= nil then
			floatcpt.SwitchToFloatAnim = function(floater, ...)
				C_SetAnim(floater.inst, skindata.floater.anim)
			end
		else
			floatcpt.SwitchToFloatAnim = C_EmptyAnim
		end
	else
		floatcpt.SwitchToFloatAnim = C_EmptyAnim
	end

	--设置地面动画
	if skindata.fn_anim ~= nil then
		floatcpt.SwitchToDefaultAnim = function(floater, ...)
			skindata.fn_anim(floater.inst)
		end
	elseif skindata.anim ~= nil then
		floatcpt.SwitchToDefaultAnim = function(floater, ...)
			C_SetAnim(floater.inst, skindata.anim)
		end
	else
		floatcpt.SwitchToDefaultAnim = C_EmptyAnim
	end
end
local function C_GetSkinData(self, skinname)
    local data
    if skinname == nil then
        data = SKIN_DEFAULT_LEGION[self.prefab]
    else
        data = SKINS_LEGION[skinname]
    end
    if data ~= nil and self.overkey ~= nil and SkinsOverride[self.prefab] then
        return data[self.overkey]
    else
        return data
    end
end
local function C_GetSkinedData(self, skinname)
    local data
    if skinname == nil then
        data = ls_skineddata[self.prefab]
    else
        data = ls_skineddata[skinname]
    end
    if data ~= nil and self.overkey ~= nil and SkinsOverride[self.prefab] then
        return data[self.overkey]
    else
        return data
    end
end
local function C_SetSkinClient(inst)
    local self = inst.components.skinedlegion
    local oldskin = self.skin
    local idx = self._skin_idx:value()
    if idx ~= nil and idx ~= 0 and SKIN_IDX_LEGION[idx] ~= nil then
        self.skin = SKIN_IDX_LEGION[idx]
        inst.skinname = self.skin --这个变量控制着“审视自我”、“审视他人”时的皮肤设置
    else
        self.skin = nil
        inst.skinname = nil
    end
    local skindata_old = C_GetSkinData(self, oldskin)
    local skindata = C_GetSkinData(self, self.skin)

	if skindata_old ~= nil then
		if skindata_old.fn_end_c ~= nil then
			skindata_old.fn_end_c(inst, self.skineddata)
		end
	end
    self.skineddata = C_GetSkinedData(self, self.skin)
	if skindata ~= nil then
		--漂浮
		if inst.components.floater ~= nil and skindata.floater ~= nil then
			self._floater_cut = skindata.floater.cut
			self._floater_nofx = skindata.floater.nofx
			if not self._floater_nofx then
				inst.components.floater:SetSize(skindata.floater.size)
				inst.components.floater:SetVerticalOffset(skindata.floater.offset_y or 0)
				inst.components.floater:SetScale(skindata.floater.scale or 1)
			end
			if inst.components.floater:IsFloating() then --由于特效已经生成，这里需要更新状态
				inst.components.floater:OnNoLongerLandedClient()
				inst.components.floater:OnLandedClient()
			end
		end
		--placer
		if skindata.placer ~= nil then
			inst.overridedeployplacername = skindata.placer.name
		else
			inst.overridedeployplacername = nil
		end
        --其他
		if skindata.fn_start_c ~= nil then
			skindata.fn_start_c(inst, self.skineddata)
		end
	end
end
local function C_SetPSkinClient(inst)
    local self = inst.components.skinedlegion
    local idx = self._pskin_idx:value()
    if idx ~= nil and idx ~= 0 and SKIN_IDX_LEGION[idx] ~= nil then
        self.problemskin = SKIN_IDX_LEGION[idx]
    else
        self.problemskin = nil
    end
end
local function LS_C_Set(self)
    -- self.isServe = TheNet:GetIsMasterSimulation()
	-- self.isClient = not TheNet:IsDedicated()
    self._skin_idx = net_byte(self.inst.GUID, "skinedlegion._skin_idx", "skin_idx_l_dirty")
    self._skin_idx:set_local(0)
    self._pskin_idx = net_byte(self.inst.GUID, "skinedlegion._pskin_idx", "pskin_idx_l_dirty")
    self._pskin_idx:set_local(0)
    -- self.prefab = nil
    -- self.overkey = nil
	-- self.skin = nil
	-- self.userid = nil
    -- self.problemskin = nil
	-- self.skineddata = nil
	-- self._floater_cut = nil
	-- self._floater_nofx = nil

	-- if not self.isServe and self.isClient then --非主机【客户端】环境
    if TheNet:GetIsClient() then
        self.inst:ListenForEvent("skin_idx_l_dirty", C_SetSkinClient)
        self.inst:ListenForEvent("pskin_idx_l_dirty", C_SetPSkinClient)
    end
end
local function CheckBuildValid(prefab, build)
    if build == nil then
        return false
    end
    local dd = ls_buildmap[prefab][build]
    if dd == nil then --该build没有记录
        return true
    elseif dd == 0 then
        return false
    else
        if type(dd) == "table" then
            for skinname, _ in pairs(dd) do
                if ls_skinmap[skinname] ~= nil then
                    return false
                end
            end
            return true
        elseif SKIN_IDS_LEGION.justffffree[dd] then
            return false
        elseif ls_skinmap[dd] == nil then --build对应的皮肤是无人拥有的
            return true
        end
    end
    return false
end
local hook_SetBuild = IsServer and UserDataHook.MakeHook("AnimState", "SetBuild", function(inst, build, ...)
    if inst.prefab ~= nil and inst.prefab ~= "" and ls_buildmap[inst.prefab] then
        return CheckBuildValid(inst.prefab, build)
    end
    return false
end) or nil
local function LS_C_Init(inst, prefab, isfloat, overkey, realprefab)
    inst:AddComponent("skinedlegion")
    local self = inst.components.skinedlegion
    self.prefab = prefab --客户端才初始化时居然获取不了inst.prefab，所以才要靠参数传过来
    if overkey ~= nil and SkinsOverride[prefab] then
		self.overkey = overkey
	end
    self.skineddata = C_GetSkinedData(self, nil)

    local skindata = C_GetSkinData(self, nil)
    if isfloat then
        if skindata ~= nil and skindata.floater ~= nil then
            inst:AddComponent("floater")
            local floatcpt = inst.components.floater
            local data = skindata.floater
            if not data.nofx then
                floatcpt:SetSize(data.size or "small")
                if data.offset_y ~= nil then
                    floatcpt:SetVerticalOffset(data.offset_y)
                end
                if data.scale ~= nil then
                    floatcpt:SetScale(data.scale)
                end
            end
            C_SetFloat(floatcpt, skindata)
            self._floater_cut = data.cut
            self._floater_nofx = data.nofx
            floatcpt.OnLandedClient_ls = floatcpt.OnLandedClient
            floatcpt.OnLandedClient = C_Float_OnLandedClient
        else
            MakeInventoryFloatable(inst)
        end
    end
    if IsServer then
        local name = realprefab or prefab
        if name ~= nil and ls_buildmap[name] ~= nil then
            if CheckBuildValid(name, inst.AnimState:GetBuild()) then
                if skindata.fn_anim ~= nil then
                    skindata.fn_anim(inst)
                elseif skindata.anim ~= nil then
                    C_SetAnim(inst, skindata.anim)
                end
            end
            UserDataHook.Hook(inst, hook_SetBuild)
        end
    end
end
local function C_SetProblemSkin(self, skinname)
    if skinname == nil then
        self._pskin_idx:set(0)
        self.problemskin = nil
    else
        local skindata = C_GetSkinData(self, skinname)
        if skindata == nil then
            self._pskin_idx:set(0)
            self.problemskin = nil
        else
            self._pskin_idx:set(skindata.skin_idx)
            self.problemskin = skinname
        end
    end
end
local function LS_C_OnLoad(self, data)
    if data == nil then
		return
	end
    local pskin = data.pskin
    if pskin ~= nil and SKINS_LEGION[pskin] ~= nil then --尝试恢复问题皮肤
        if LS_C_SetSkin(self, pskin, data.userid) then
            return
        end
    else
        pskin = nil
    end
	if data.skin ~= nil and SKINS_LEGION[data.skin] ~= nil then --如果问题皮肤还是没恢复，那就先按已有皮肤来
		LS_C_SetSkin(self, data.skin, data.userid)
	end
    if pskin ~= nil and self.problemskin == nil then
        C_SetProblemSkin(self, pskin)
    end
end
local function LS_C_UserID(inst, player) --获取继承的userid
    if inst.components.skinedlegion.userid ~= nil then
        return inst.components.skinedlegion.userid
    end
    if LS_IsValidPlayer(player) then
        return player.userid
    end
end
local function C_SpawnSkinExchangeFx(inst, skinname, tool)
    local skindata = C_GetSkinData(inst.components.skinedlegion, skinname)
	if skindata ~= nil then
		if skindata.fn_spawnSkinExchangeFx ~= nil then
			skindata.fn_spawnSkinExchangeFx(inst)
		elseif skindata.exchangefx ~= nil then
			local fx = nil
            skindata = skindata.exchangefx
			if skindata.prefab ~= nil then
				fx = SpawnPrefab(skindata.prefab)
			elseif tool ~= nil then
				fx = "explode_reskin"
				local skin_fx = SKIN_FX_PREFAB[tool:GetSkinName()]
				if skin_fx ~= nil and skin_fx[1] ~= nil then
					fx = skin_fx[1]
				end
				fx = SpawnPrefab(fx)
			end
			if fx ~= nil then
				if skindata.scale ~= nil then
					fx.Transform:SetScale(skindata.scale, skindata.scale, skindata.scale)
				end
				if skindata.offset_y ~= nil then
					local fx_pos_x, fx_pos_y, fx_pos_z = inst.Transform:GetWorldPosition()
					fx_pos_y = fx_pos_y + skindata.offset_y
					fx.Transform:SetPosition(fx_pos_x, fx_pos_y, fx_pos_z)
				else
					fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
				end
			end
		end
	end
end
local function SetSkinEx(inst) --这样做是为了在切换皮肤时，更新玩家身上的装备贴图
    local owner = GetEquippedOwner(inst)
    if owner ~= nil and owner.components.inventory ~= nil then
        local item = owner.components.inventory:Unequip(inst.components.equippable.equipslot)
        if item ~= nil then
            owner.components.inventory:Equip(item, nil, true, nil)
        end
    end
end
local function LS_C_SetLinkedSkin(self, newinst, linkedkey, doer)
    local skindata = C_GetSkinData(self, self.skin)
    if skindata == nil or skindata.linkedskins == nil or skindata.linkedskins[linkedkey] == nil then
        return false
    end
    LS_C_SetSkin(newinst.components.skinedlegion, skindata.linkedskins[linkedkey],
        self.userid or (LS_IsValidPlayer(doer) and doer.userid or nil))
end
LS_C_SetSkin = function(self, skinname, userid)
    if not IsServer or self.skin == skinname then
		return true
	end

    local inst = self.inst
    if skinname ~= nil then
        if not LS_HasSkin(skinname, userid) then
            userid = ls_skinmap[skinname]
            if userid == nil then
                C_SetProblemSkin(self, skinname)
                return
            end
        end
    end
    if self.problemskin ~= nil then
        C_SetProblemSkin(self, nil)
    end

	local skindata = C_GetSkinData(self, skinname)
    if skindata == nil then
        return false
    end
    ------取消前一个皮肤的效果
    local skindatalast = C_GetSkinData(self, self.skin)
	if skindatalast ~= nil then
		if skindatalast.fn_end ~= nil then
			skindatalast.fn_end(inst, self.skineddata)
		end
	end
    ------应用新皮肤的效果
	--动画
    if skindata.fn_anim ~= nil or skindata.anim ~= nil then
        local hasset = false
        if inst.components.floater ~= nil then
            if inst.components.floater:IsFloating() then
                if skindata.floater ~= nil then
                    if skindata.floater.fn_anim ~= nil then
                        skindata.floater.fn_anim(inst)
                        hasset = true
                    elseif skindata.floater.anim ~= nil then
                        C_SetAnim(inst, skindata.floater.anim)
                        hasset = true
                    end
                end
            end
        end
        if not hasset then
            if skindata.fn_anim ~= nil then
                skindata.fn_anim(inst)
            elseif skindata.anim ~= nil then
                C_SetAnim(inst, skindata.anim)
            end
        end
    end
    --物品栏图片
    if inst.components.inventoryitem ~= nil and skindata.image ~= nil and skindata.image.setable then
        inst.components.inventoryitem.atlasname = skindata.image.atlas
        inst.components.inventoryitem:ChangeImageName(skindata.image.name)
    end
    --漂浮
    if inst.components.floater ~= nil and skindata.floater ~= nil then
        if not skindata.floater.nofx then
            inst.components.floater:SetSize(skindata.floater.size or "small")
            inst.components.floater:SetVerticalOffset(skindata.floater.offset_y or 0)
            inst.components.floater:SetScale(skindata.floater.scale or 1)
        end
        C_SetFloat(inst.components.floater, skindata)
        self._floater_cut = skindata.floater.cut
        self._floater_nofx = skindata.floater.nofx
        if not TheNet:IsDedicated() and inst.components.floater:IsFloating() then --特效已经生成，这里需要更新状态
            inst.components.floater:OnNoLongerLandedClient()
            inst.components.floater:OnLandedClient()
        end
    end
    --placer
    if skindata.placer ~= nil then
        inst.overridedeployplacername = skindata.placer.name
    else
        inst.overridedeployplacername = nil
    end
    self.skineddata = C_GetSkinedData(self, skinname)
    if skindata.fn_start ~= nil then
        skindata.fn_start(inst, self.skineddata)
    end

    if skinname == nil then --代表恢复原皮肤
        self._skin_idx:set(0)
        self.skin = nil
        self.userid = nil
        inst.skinname = nil
    else
        self._skin_idx:set(skindata.skin_idx)
        self.skin = skinname
        self.userid = userid
        inst.skinname = skinname
    end
    if inst.components.equippable ~= nil and inst.components.equippable:IsEquipped() then --为了更新玩家的装备贴图
        if inst.task_ls_ex ~= nil then
            inst.task_ls_ex:Cancel()
        end
        inst.task_ls_ex = inst:DoTaskInTime(0.1+0.4*math.random(), SetSkinEx)
    end

    return true
end

------
------

LSFNS = {
    LS_IsValidPlayer = LS_IsValidPlayer,
    -- LS_HasSkin = LS_HasSkin,
    LS_LastChosenSkin = LS_LastChosenSkin,
    -- LS_N_GetSkins = LS_N_GetSkins,
    -- LS_N_UseCDK = LS_N_UseCDK,
    LS_SkinCache2File = LS_SkinCache2File,
    LS_StartPeriodicPatrol = LS_StartPeriodicPatrol,
    LS_C_Set = LS_C_Set,
    LS_C_Init = LS_C_Init,
    LS_C_SetLinkedSkin = LS_C_SetLinkedSkin,
    LS_C_SetSkin = LS_C_SetSkin,
    LS_C_OnLoad = LS_C_OnLoad,
    LS_C_UserID = LS_C_UserID,
    LS_UI_ResetItems = LS_UI_ResetItems
}
for fnname, fn in pairs(LSFNS) do --将数据暴露出去
    _G[fnname] = fn
end
_G.ls_skineddata = ls_skineddata

--------------------------------------------------------------------------
--[[ 赶在加载世界数据前，加载缓存数据 ]]
--------------------------------------------------------------------------

AddGlobalClassPostConstruct("shardindex", "ShardIndex", function(self) --文件路径、代码中的类名字、函数
    self.Load_ls = self.Load
    self.Load = function(self, callback, ...)
        local DealDataJson = function(load_success, datajson)
            dirty_cache = not load_success
            if not load_success or datajson == nil then
                return
            end
            local status, data = pcall(function() return json.decode(datajson) end)
            if not status or data == nil or type(data) ~= "table" or data.origin == nil then
                return
            end
            if self.session_id ~= nil and data.origin ~= self.session_id then --验证世界id
                print("LS: Shard session_id is inconsistent.")
                return
            end
            if data.pp ~= nil and type(data.pp) == "table" then
                ls_players = data.pp
            else
                return
            end
            if data.dd ~= nil and type(data.dd) == "table" then
                for kleiid, skins in pairs(data.dd) do
                    if ls_players[kleiid] then --只有进过该档的玩家的数据才能被使用
                        local newdd = {}
                        if type(skins) == "table" then
                            for skinname, has in pairs(skins) do
                                if SKINS_LEGION[skinname] ~= nil then --判断皮肤有效性
                                    newdd[skinname] = true
                                    ls_skinmap[skinname] = kleiid
                                end
                            end
                        end
                        ls_cache[kleiid] = newdd
                    end
                end
            end
        end
        local cb = function()
            if TheNet:IsDedicated() then --单纯的服务器进程，会自动选择当前存档目录
                TheSim:GetPersistentString("shardiindex", DealDataJson)
            elseif TheNet:GetServerIsClientHosted() and Settings.save_slot then
                --无洞穴的服务器进程，得自己设定存档目录，否则就往客户端目录查找了
                TheSim:GetPersistentStringInClusterSlot(Settings.save_slot, "Master", "shardiindex", DealDataJson)
            end
            if callback ~= nil then
                callback()
            end
        end
        return self.Load_ls(self, cb, ...)
    end
end)

--读取客户端的缓存文件
if not TheNet:IsDedicated() then --客户端或者无洞穴的服务器
    TheSim:GetPersistentString("shardiindex_time", function(load_success, datajson)
        dirty_cache = not load_success
        if load_success and datajson ~= nil then
            local status, data = pcall(function() return json.decode(datajson) end)
            if status and data ~= nil then
                if data.dd ~= nil and type(data.dd) == "table" then
                    if IsOnlineMode(USERID) then
                        local myskins = data.dd[USERID]
                        if myskins ~= nil and type(myskins) == "table" then
                            local newdd = {}
                            for skinname, has in pairs(myskins) do
                                if SKINS_LEGION[skinname] ~= nil then --判断皮肤有效性
                                    newdd[skinname] = true
                                end
                            end
                            ls_cache[USERID] = newdd
                        end
                    else --离线模式就继承第一个的皮肤数据
                        for kleiid, skins in pairs(data.dd) do
                            if type(skins) == "table" then
                                local newdd = {}
                                for skinname, has in pairs(skins) do
                                    if SKINS_LEGION[skinname] ~= nil then
                                        newdd[skinname] = true
                                    end
                                end
                                ls_cache[USERID] = newdd
                                break
                            end
                        end
                    end
                end
                if data.ex ~= nil and type(data.ex) == "table" then
                    if IsOnlineMode(USERID) then
                        if data.ex[USERID] ~= nil and type(data.ex[USERID]) == "table" then
                            local newdd = {}
                            for prefabname, skinname in pairs(data.ex[USERID]) do
                                if SKINS_LEGION[skinname] ~= nil then
                                    newdd[prefabname] = skinname
                                end
                            end
                            ls_cache_ex[USERID] = newdd
                        end
                    else --离线模式就继承第一个的交换数据
                        for kleiid, prefabs in pairs(data.ex) do
                            if type(prefabs) == "table" then
                                local newdd = {}
                                for prefabname, skinname in pairs(prefabs) do
                                    if SKINS_LEGION[skinname] ~= nil then
                                        newdd[prefabname] = skinname
                                    end
                                end
                                ls_cache_ex[USERID] = newdd
                                break
                            end
                        end
                    end
                end
            end
        end
    end)
end

--------------------------------------------------------------------------
--[[ 各端响应 ]]
--------------------------------------------------------------------------

local function GetRightRoot()
    if ThePlayer and ThePlayer.HUD and ThePlayer.HUD.controls then
        return ThePlayer.HUD.controls.right_root
    end
    return nil
end

------客户端响应服务器请求【客户端环境】

AddClientModRPCHandler("LegionSkin", "UpdateSkinsClient", function(datajson)
    if datajson == nil then --说明没有皮肤
        ls_cache[USERID] = nil
    else
        local success, data = pcall(json.decode, datajson)
        if not success or type(data) ~= "table" then
            return
        end
        ls_cache[USERID] = SkinNumbers2Cache(data)
    end
    dirty_cache = true
    LS_SkinCache2File() --缓存为皮肤文件

    --获取数据后，主动更新皮肤铺界面
    local right_root = GetRightRoot()
    if right_root ~= nil and right_root.skinshop_l ~= nil then
        right_root.skinshop_l:ResetItems()
    end
end)
AddClientModRPCHandler("LegionSkin", "CallBackSkinTip", function(datajson)
    if datajson == nil then
        return
    end
    local success, data = pcall(json.decode, datajson)
    if not success or data == nil then
        return
    end
    --获取数据后，主动更新cdk输入框
    local right_root = GetRightRoot()
    if right_root ~= nil and right_root.skinshop_l ~= nil then
        right_root.skinshop_l:SetCdkState(data.state, data.pop)
    end
end)
AddClientModRPCHandler("LegionSkin", "SaveSkinEx", function(datajson)
    if datajson == nil then
        return
    end
    local success, data = pcall(json.decode, datajson)
    if not success or data == nil or data.prefab == nil then
        return
    end
    SaveSkinEx(USERID, data.newskin, data.prefab)
    dirty_cache = true
end)
AddClientModRPCHandler("LegionSkin", "GetClientSkins", function()
    FnRpc_c2s("SendClientSkins", SkinCache2Numbers(ls_cache[USERID]))
end)

------服务器响应客户端请求【服务器环境】

AddModRPCHandler("LegionSkin", "UseCDK", function(player, datajson)
    if datajson == nil or not LS_IsValidPlayer(player) then
        return
    end
    local success, data = pcall(json.decode, datajson)
    if success and data ~= nil and data.cdk ~= nil and data.cdk:utf8len() > 6 then
        LS_N_UseCDK(player.userid, data.cdk, true)
    end
end)
AddModRPCHandler("LegionSkin", "GetSkins", function(player)
    if LS_IsValidPlayer(player) then
        LS_N_GetSkins(player.userid, true)
    end
end)
AddModRPCHandler("LegionSkin", "SendClientSkins", function(player, datajson)
    if not LS_IsValidPlayer(player) or ls_skinneedclients[player.userid] == nil then
        return
    end
    ls_skinneedclients[player.userid] = nil

    if datajson == nil then --说明没有皮肤
        ls_cache[player.userid] = nil
        FnRpc_s2s(nil, "UpdateSkinsShard", { nums = nil, userid = player.userid })
    else
        local success, data = pcall(json.decode, datajson)
        if not success or type(data) ~= "table" then
            return
        end
        local newskins = SkinNumbers2Cache(data)
        ls_cache[player.userid] = newskins
        UpdateSkinMap(player.userid, newskins)
        FnRpc_s2s(nil, "UpdateSkinsShard", { nums = data, userid = player.userid })
    end
    dirty_cache = true
    if ls_cache_net[player.userid] ~= nil then --清除冷却时间好让玩家重新恢复问题皮肤
        ls_cache_net[player.userid]["DealProblemSkins"] = nil
    end
end)
AddModRPCHandler("LegionSkin", "SendClientSkinEx", function(player, datajson)
    if not LS_IsValidPlayer(player) then
        return
    end
    if datajson == nil then --说明没有数据
        ls_cache_ex[player.userid] = nil
    else
        local success, data = pcall(json.decode, datajson)
        if not success or type(data) ~= "table" then
            return
        end
        local res = {}
        for prefab, num in pairs(data) do
            if SKIN_IDX_LEGION[num] ~= nil then
                res[prefab] = SKIN_IDX_LEGION[num]
            end
        end
        ls_cache_ex[player.userid] = res
    end
end)
AddModRPCHandler("LegionSkin", "DealProblemSkins", function(player)
    if not LS_IsValidPlayer(player) then
        return
    end
    local querykey = "DealProblemSkins"
    if not CoolForQuery(player.userid, querykey, nil, nil, 240) then
        return
    end

    local skined
    local hasproblem = false
    local alldone = true
    for guid, ent in pairs(Ents) do
        if ent.components.skinedlegion ~= nil then
            skined = ent.components.skinedlegion
            if skined.problemskin ~= nil then
                hasproblem = true
                if alldone then
                    if not LS_C_SetSkin(skined, skined.problemskin, nil) then
                        alldone = false
                    end
                else
                    LS_C_SetSkin(skined, skined.problemskin, nil)
                end
            end
        end
    end
    SaveQueryCache(player.userid, querykey, 1, true)

    local str
    local dd = { doer = player.name or player.userid }
    if not hasproblem then
        str = subfmt(STRINGS.NAMEDETAIL_L.DEALPROBLEMSKIN1, dd)
    elseif alldone then
        str = subfmt(STRINGS.NAMEDETAIL_L.DEALPROBLEMSKIN2, dd)
    else
        str = subfmt(STRINGS.NAMEDETAIL_L.DEALPROBLEMSKIN3, dd)
    end
    TheNet:Announce(str)
end)

------服务器响应服务器请求【服务器环境】

AddShardModRPCHandler("LegionSkin", "PlayerJoined", function(shardid, userid)
    if shardid == TheShard:GetShardId() then --id一样，说明是同一个世界传来的
        return
    end
    if userid ~= nil and not ls_players[userid] then
        ls_players[userid] = true
        dirty_cache = true
    end
end)
AddShardModRPCHandler("LegionSkin", "UpdateSkinsShard", function(shardid, datajson)
    if datajson == nil or shardid == TheShard:GetShardId() then --id一样，说明是同一个世界传来的
        return
    end
    local success, data = pcall(json.decode, datajson)
    if not success or data == nil or data.userid == nil then
        return
    end
    if data.nums == nil then
        ls_cache[data.userid] = nil
    elseif type(data.nums) == "table" then
        local newskins = SkinNumbers2Cache(data.nums)
        ls_cache[data.userid] = newskins
        UpdateSkinMap(data.userid, newskins)
    end
    dirty_cache = true
    if ls_cache_net[data.userid] ~= nil then --清除冷却时间好让玩家重新恢复问题皮肤
        ls_cache_net[data.userid]["DealProblemSkins"] = nil
    end
    SaveQueryCache(data.userid, "GetSkins", 1, true) --刷新冷却时间，防止重复请求
end)

--------------------------------------------------------------------------
--[[ 修改皮肤的网络判定函数 ]]
--------------------------------------------------------------------------

--ValidateRecipeSkinRequest()位于networking.lua中
local ValidateRecipeSkinRequest_old = _G.ValidateRecipeSkinRequest
_G.ValidateRecipeSkinRequest = function(user_id, prefab_name, skin, ...)
    --【服务器】环境
    local validated_skin = nil
    if skin ~= nil and skin ~= "" and SKINS_LEGION[skin] ~= nil then
        if table.contains(_G.PREFAB_SKINS[prefab_name], skin) then
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

AddClassPostConstruct("widgets/redux/craftingmenu_skinselector", function(self, recipe, owner, skin_name)
    ------【客户端】环境
    if self.recipe and SKIN_DEFAULT_LEGION[self.recipe.product] then
        local GetSkinsList_old = self.GetSkinsList
        self.GetSkinsList = function(self, ...) --会在点击物品制作格子时触发
            if self.recipe and PREFAB_SKINS[self.recipe.product] then
                if not self.timestamp then self.timestamp = -10000 end
                local skins_list = {}
                for _, skinname in pairs(PREFAB_SKINS[self.recipe.product]) do
                    if LS_HasSkin(skinname, self.owner.userid) then
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

        --因为这种接口 AddClassPostConstruct，多半是在对象初始化后才执行
        --所以这里只能重新执行一次部分逻辑，把mod皮肤加进去
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
--[[ 修改审视自我按钮的弹出界面，增加皮肤界面触发按钮 ]]
--------------------------------------------------------------------------

if not TheNet:IsDedicated() and _G.CONFIGS_LEGION.LANGUAGES == "chinese" then
    -- local ImageButton = require "widgets/imagebutton"
    -- local PlayerAvatarPopup = require "widgets/playeravatarpopup"
    local PlayerInfoPopup = require "screens/playerinfopopupscreen"
    local TEMPLATES = require "widgets/templates"
    -- local SkinLegionDialog = require "widgets/skinlegiondialog"

    local MakeBG_old = PlayerInfoPopup.MakeBG
    PlayerInfoPopup.MakeBG = function(self, ...)
        MakeBG_old(self, ...)

        local right_root = GetRightRoot()
        if right_root ~= nil and right_root.skinshop_l ~= nil then --再次打开人物自检面板时，需要关闭已有的铺子页面
            right_root.skinshop_l:Kill()
            right_root.skinshop_l = nil
        end

        ------鸡毛铺按钮
        self.skinshop_l_button = self.root:AddChild(TEMPLATES.IconButton(
            "images/icon_skinbar_shadow_l.xml", "icon_skinbar_shadow_l.tex", "棱镜鸡毛铺", false, false,
            function()
                local rightroot = GetRightRoot()
                if rightroot == nil then
                    return
                end
                if rightroot.skinshop_l ~= nil then
                    rightroot.skinshop_l:Kill()
                end
                local SkinLegionDialog = _G.require("widgets/skinlegiondialog") --test：动态更新
                rightroot.skinshop_l = rightroot:AddChild(SkinLegionDialog(self.owner))
                rightroot.skinshop_l:SetPosition(-380, 0)
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

        ------百科按钮
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
--[[ 修改玩家实体以应用皮肤机制 ]]
--------------------------------------------------------------------------

AddPlayerPostInit(function(inst)
    if IsServer then
        inst:DoTaskInTime(1.3, function(inst)
            local ostime = os.time() or 0
            if ls_patroltime == nil then
                if CheckCodeSafety() then
                    return
                end
                ls_patroltime = ostime
            elseif (ostime - ls_patroltime) >= 4320 then
                DoPeriodicPatrol(TheWorld)
                LS_StartPeriodicPatrol(TheWorld)
            end
            if LS_IsValidPlayer(inst) then
                if not ls_players[inst.userid] then
                    ls_players[inst.userid] = true
                    dirty_cache = true
                    FnRpc_s2s(nil, "PlayerJoined", inst.userid)
                end
                LS_N_GetSkins(inst.userid, true)
            end
        end)
    else
        inst:DoTaskInTime(1.3, function(inst)
            local ostime = os.time() or 0
            if ls_patroltime == nil or (ostime - ls_patroltime) >= 4320 then
                if CheckCodeSafety() then
                    return
                end
                ls_patroltime = ostime
            end
            if USERID ~= "" then
                local ex = ls_cache_ex[USERID]
                local res
                if not LS_IsTableEmpty(ex) then
                    res = {}
                    for prefab, skinname in pairs(ex) do
                        local dd = SKINS_LEGION[skinname]
                        if dd ~= nil and dd.skin_idx ~= nil then
                            res[prefab] = dd.skin_idx
                        end
                    end
                end
                FnRpc_c2s("SendClientSkinEx", res)
            end
        end)
    end
end)

------
------

if not IsServer then return end

--------------------------------------------------------------------------
--[[ 修改SpawnPrefab()以应用皮肤机制 ]]
--------------------------------------------------------------------------

local SpawnPrefab_old = _G.SpawnPrefab
_G.SpawnPrefab = function(name, skin, skin_id, userid, ...)
    --【服务器】环境
    if skin ~= nil and SKINS_LEGION[skin] ~= nil then
        local prefab = SpawnPrefab_old(name, nil, nil, userid)
        if prefab ~= nil then
            if prefab.components.skinedlegion ~= nil then
                LS_C_SetSkin(prefab.components.skinedlegion, skin, userid)
            end
        end
        return prefab
    else
        return SpawnPrefab_old(name, skin, skin_id, userid, ...)
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
        inst.components.spellcaster:SetSpellFn(function(tool, target, pos, doer, ...)
            if target ~= nil and target.components.skinedlegion ~= nil then
                tool:DoTaskInTime(0, function()
                    if not target:IsValid() or not tool:IsValid() then
                        return
                    end
                    if not LS_IsValidPlayer(tool.parent) then
                        return
                    end
                    local skincpt = target.components.skinedlegion
                    local userid = tool.parent.userid
                    local prefabname = nil
                    if skincpt.overkey ~= nil then
                        prefabname = skincpt.prefab
                    else
                        prefabname = target.prefab
                    end
                    local skins = PREFAB_SKINS[prefabname]
                    if skins == nil then
                        return
                    end
                    local skinname_new = nil
                    local skinname_old = skincpt:GetSkin()
                    local skinname_cac = LS_LastChosenSkin(prefabname, userid)
                    if skinname_old == nil then --原皮，尝试切换成其他皮肤，优先为缓存皮肤
                        if skinname_cac ~= nil and LS_HasSkin(skinname_cac, userid) then
                            skinname_new = skinname_cac
                        else
                            for _, skinname in pairs(skins) do --寻找第一个拥有的皮肤
                                if LS_HasSkin(skinname, userid) then
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
                                if LS_HasSkin(skinname, userid) then
                                    skinname_new = skinname
                                    break
                                end
                            end
                        end
                    end
                    if skinname_new ~= skinname_old then
                        LS_C_SetSkin(skincpt, skinname_new, userid)
                        skinname_new = skincpt:GetSkin() --重新获取，看看是不是切换成功了
                        C_SpawnSkinExchangeFx(target, skinname_new, tool)
                        if skinname_cac ~= skinname_new then
                            SaveSkinEx(userid, skinname_new, prefabname)
                            FnRpc_s2c(userid, "SaveSkinEx", { newskin = skinname_new, prefab = prefabname })
                        end
                    else
                        C_SpawnSkinExchangeFx(target, skinname_old, tool)
                    end
                end)
                return
            end
            if spell_old ~= nil then
                return spell_old(tool, target, pos, doer, ...)
            end
        end)
    end
end)
