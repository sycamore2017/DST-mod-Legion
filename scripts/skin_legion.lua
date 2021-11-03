------skined_legion

local _G = GLOBAL
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()
local ischinese = TUNING.LEGION_MOD_LANGUAGES == "chinese"

table.insert(Assets, Asset("ATLAS", "images/icon_skinbar_shadow_l.xml"))
table.insert(Assets, Asset("IMAGE", "images/icon_skinbar_shadow_l.tex"))

--------------------------------------------------------------------------
--[[ 全局皮肤总数据，以及修改 ]]
--------------------------------------------------------------------------

local rarityRepay = "ProofOfPurchase"
local rarityFree = "Event"

_G.SKIN_PREFABS_LEGION = {
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
}

_G.SKINS_LEGION = {
	rosorns_spell = {
        base_prefab = "rosorns",
		type = "item", --item物品皮肤，base人物皮肤
		rarity = rarityRepay,
		skin_tags = {},
		release_group = 555,
		build_name_override = nil, --皮肤名称(居然是小写)

        skin_idx = 1, --只能我来确定的数据了，谁叫[key]形式的下标不能按代码顺序呢
        skin_id = "61627d927bbb727be174c4a0",
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
}

_G.SKIN_IDS_LEGION = {
    ["freeskins"] = {}, --免费皮肤全部装这里面，skin_id设置为"freeskins"就好了
    -- ["61627d927bbb727be174c4a0"] = { rosorns_spell = true, },
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
        },
        UI_ACCESS = "获取",
        UI_INPUT_CDK = "请输入兑换码",
        UI_LOAD_CDK = "兑换中...",
        ACCESS = {
            UNKNOWN = "无法获取",
            DONATE = "通过打赏获取",
            FREE = "自动获取",
        },
    }
else
    STRINGS.SKIN_LEGION = {
        UNKNOWN_STORY = "The story is not worth mentioning.",
        COLLECTION = {
            UNKNOWN = "Strange Collection",
            MAGICSPELL = "Rose Spell Staff",
        },
        UI_ACCESS = "Get It",
        UI_INPUT_CDK = "Please enter CDK",
        UI_LOAD_CDK = "Redeeming...",
        ACCESS = {
            UNKNOWN = "Unable to get",
            DONATE = "Get it by donation",
            FREE = "Free access",
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

for skinname,v in pairs(_G.SKINS_LEGION) do
    _G.SKIN_IDX_LEGION[v.skin_idx] = skinname

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
    if v.exchangefx ~= nil then
        if v.exchangefx.prefab == nil then
            v.exchangefx.prefab = "explode_reskin"
        end
    end

    table.insert(v.skin_tags, string.upper(skinname))
    table.insert(v.skin_tags, "CRAFTABLE")

    STRINGS.SKIN_NAMES[skinname] = v.string.name

    ------修改PREFAB_SKINS(在prefabskins.lua中被定义)
    if _G.PREFAB_SKINS[v.base_prefab] == nil then
        _G.PREFAB_SKINS[v.base_prefab] = { skinname }
    else
        table.insert(_G.PREFAB_SKINS[v.base_prefab], skinname)
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
    if v.exchangefx ~= nil then
        if v.exchangefx.prefab == nil then
            v.exchangefx.prefab = "explode_reskin"
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
    if SKIN_IDS_LEGION.freeskins[skinname] then
        return true
    elseif userid ~= nil and SKINS_CACHE_L[userid] ~= nil and SKINS_CACHE_L[userid][skinname] then
        return true
    end
    return false
end

AddClassPostConstruct("widgets/recipepopup", function(self)
    ------【客户端】环境
    local GetSkinsList_old = self.GetSkinsList
    self.GetSkinsList = function(self, ...)
        if self.owner == nil then
            return GetSkinsList_old(self, ...)
        end

        GetSkinsList_old(self, ...)
        if self.recipe and SKIN_PREFABS_LEGION[self.recipe.product] and PREFAB_SKINS[self.recipe.product] then
            for _, skinname in pairs(PREFAB_SKINS[self.recipe.product]) do
                if DoYouHaveSkin(skinname, self.owner.userid) then
                    local data  = {
                        type = type, --不知道是啥
                        item = skinname, --这个皮肤的名字
                        timestamp = -10000,
                        -- ismodskin = true, --多加的变量，用来标记mod皮肤
                    }
                    table.insert(self.skins_list, data)
                end
            end
        end

        return self.skins_list
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
_G.SKINS_CACHE_L = {
    -- Kxx_xxxx = { --用户ID
    --     skinname1 = true,
    --     skinname2 = true,
    -- },
}

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
        if skin ~= nil and creator ~= nil and SKINS_LEGION[skin] ~= nil then
            local prefab = SpawnPrefab_old(name, nil, nil, creator)
            if prefab ~= nil then
                if prefab.components.skinedlegion ~= nil then
                    if DoYouHaveSkin(skin, creator) then
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
                        end
                        target.components.skinedlegion:SpawnSkinExchangeFx() --不管有没有交换成功，都释放特效
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
        end
        inst.OnLoad = function(inst, data)
            if OnLoad_old ~= nil then
                OnLoad_old(inst, data)
            end

            if data ~= nil and data.skins_legion ~= nil then
                SKINS_CACHE_L[inst.userid] = data.skins_legion --先存下来，等服务器皮肤数据确认后才传给客户端
            end
        end

        --实体生成后，开始调取接口获取皮肤数据
        inst.task_skin_l = inst:DoTaskInTime(0.1, function()
            inst.task_skin_l = nil
            GetLegionSkins(inst, inst.userid, 0.5, false)

            if inst.userid ~= nil and SKINS_CACHE_L[inst.userid] ~= nil then --提前给玩家传输服务器的皮肤数据
                FnRpc_s2c(inst.userid, 1, SKINS_CACHE_L[inst.userid])
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

        elseif handletype == 2 then
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
    if TUNING.LEGION_MOD_LANGUAGES == "chinese" then
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