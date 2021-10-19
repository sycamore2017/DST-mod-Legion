------skined_legion

local _G = GLOBAL
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()
local ischinese = TUNING.LEGION_MOD_LANGUAGES == "chinese"

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

        skin_idx = nil,
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
                print("??????")
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

local skin_idx = 1
for skinname,v in pairs(_G.SKINS_LEGION) do
    _G.SKIN_IDX_LEGION[skin_idx] = skinname
    v.skin_idx = skin_idx
    skin_idx = skin_idx + 1

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
skin_idx = nil
ischinese = nil

------重新生成一遍PREFAB_SKINS_IDS(在prefabskins.lua中被定义)
_G.PREFAB_SKINS_IDS = {}
for prefab,skins in pairs(_G.PREFAB_SKINS) do
	_G.PREFAB_SKINS_IDS[prefab] = {}
	for k,v in pairs(skins) do
		_G.PREFAB_SKINS_IDS[prefab][v] = k
	end
end

--undo:test
AddRecipe(
    "rosorns", {
        Ingredient("siving_rocks", 6, "images/inventoryimages/siving_rocks.xml"),
        Ingredient("pinecone", 20),
    }, RECIPETABS.FARM, TECH.MAGIC_TWO, nil, nil, nil, nil, nil,
    "images/inventoryimages/rosorns.xml", "rosorns.tex"
)
STRINGS.RECIPE_DESC.ROSORNS = "测试啊"

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

local function DoYouHaveSkin(skinname, myskins)
    if SKIN_IDS_LEGION.freeskins[skinname] then
        return true
    elseif myskins ~= nil and myskins[skinname] then
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
                if DoYouHaveSkin(skinname, self.owner.skinData_legion) then
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

local fn_GetSkinData = nil
local fn_skinDataDirty = nil
local SetNet_skinIdx = nil
if IsServer then
    --不想麻烦地写在世界里了，换个方式
    -- AddPrefabPostInit("shard_network", function(inst) --这个prefab只存在于服务器世界里（且只能存在一个）
    --     inst:AddComponent("shard_skin_legion")
    -- end)

    _G.skinData_cache_legion = {
        -- Kxx_xxxx = { --用户ID
        --     errcount = 0,
        --     loadtag = nil, --空值-未开始、1-成功、-1-失败、0-加载中
        --     task = nil,
        --     lastquerytime = nil, --上次请求时的现实时间
        --     skins = nil,
        -- },
    }

    local function StopQueryTask(state)
        if state.task ~= nil then
            state.task:Cancel()
            state.task = nil
        end
        state.errcount = 0
    end

    SetNet_skinIdx = function(player, skindata)
        if skindata == nil then
            player._skin_idxs1:set({ [1] = 0 })
        else
            local idxs1 = { [1] = 0 }
            -- local idxs2 = {} --备用
            local i = 0
            for skinname,v in pairs(skindata) do
                local skin = SKINS_LEGION[skinname]
                if skin ~= nil then
                    i = i + 1
                    if i <= 25 then
                        idxs1[i] = skin.skin_idx
                    -- elseif i <= 50 then
                    --     idxs2[i] = skin.skin_idx
                    else
                        break
                    end
                end
            end

            player._skin_idxs1:set(idxs1)
            -- if i > 25 then
            --     player._skin_idxs2:set(idxs2)
            -- end
        end
        player.skinData_legion = skindata
    end

    ------获取玩家已有皮肤数据
    fn_GetSkinData = function(player, userid, delaytime)
        if TheWorld == nil then
            return
        end

        local state = {
            errcount = 0,
            loadtag = nil,
            task = nil,
            lastquerytime = os.time(),
            skins = nil,
            used = nil,
        }
        local isbind = nil
        state.task = TheWorld:DoPeriodicTask(3, function()
            --参数有效性判断
            local user_id = player ~= nil and player.userid or userid
            if user_id == nil or user_id == "" then
                StopQueryTask(state)
                return
            end

            --是否已经在进行请求的判断
            if not isbind then
                local skinData_cache = skinData_cache_legion[user_id]
                if skinData_cache ~= nil then
                    if skinData_cache.loadtag == 0 then --有 正在进行 的请求，放弃当前操作
                        StopQueryTask(state)
                        return
                    elseif skinData_cache.loadtag == 1 then --有 已完成 的请求，放弃当前操作，处理已有数据
                        if not skinData_cache.used then
                            StopQueryTask(state)
                            if player ~= nil and player:IsValid() then
                                SetNet_skinIdx(player, skinData_cache.skins)
                                skinData_cache.used = true
                            end
                            return
                        end
                        if skinData_cache.lastquerytime ~= nil then --3分钟之内不会重复请求
                            local timedelay = os.difftime(os.time(), skinData_cache.lastquerytime)
                            if timedelay <= 60*3 then
                                StopQueryTask(state)
                                if player ~= nil and player:IsValid() then
                                    SetNet_skinIdx(player, skinData_cache.skins)
                                    skinData_cache.used = true
                                end
                                return
                            end
                        end
                    end
                    StopQueryTask(skinData_cache) --其他情况，取消已有task
                    state.skins = skinData_cache.skins --记下以前的结果，防止请求失败没数据返回
                end
                skinData_cache_legion[user_id] = state
                isbind = true
            end

            --task请求状态判断
            if state.loadtag == 0 then --加载中，等一会
                return
            elseif state.loadtag == -1 then --失败了，开始计失败次数
                if state.errcount >= 2 then
                    StopQueryTask(state)
                    return
                else
                    state.errcount = state.errcount + 1
                end
            elseif state.loadtag == 1 then --成功啦！结束task
                StopQueryTask(state)
                return
            end

            state.loadtag = 0
            TheSim:QueryServer(
                "https://fireleaves.cn/account/locakedSkin?mid=6041a52be3a3fb1f530b550a&id="..user_id,
                function(result_json, isSuccessful, resultCode)
                    if isSuccessful and string.len(result_json) > 1 and resultCode == 200 then
                        local status, data = pcall( function() return json.decode(result_json) end )
                        -- print("------------skined: ", tostring(result_json))
                        if not status then
                            print("[SkinUser_legion] Faild to parse quest json for "
                                ..tostring(user_id).."! ", tostring(status)
                            )
                            state.loadtag = -1
                        else
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
                            if player ~= nil and player:IsValid() then
                                SetNet_skinIdx(player, skins)
                                state.used = true
                            else
                                state.used = nil
                            end
                            state.loadtag = 1
                            state.skins = skins
                            StopQueryTask(state)
                        end
                    else
                        state.loadtag = -1
                    end
                end,
            "GET")

        end, delaytime)
    end

    --------------------------------------------------------------------------
    --[[ 修改SpawnPrefab()以应用皮肤机制 ]]
    --------------------------------------------------------------------------

    local SpawnPrefab_old = _G.SpawnPrefab
    _G.SpawnPrefab = function(name, skin, skin_id, creator)
        --【服务端】环境
        if skin ~= nil and SKINS_LEGION[skin] ~= nil and creator ~= nil then
            local prefab = SpawnPrefab_old(name, nil, nil, creator)
            if prefab ~= nil then
                if prefab.components.skinedlegion ~= nil then
                    if SKIN_IDS_LEGION.freeskins[skin] then
                        prefab.components.skinedlegion:SetSkin(skin)
                    elseif skinData_cache_legion ~= nil and skinData_cache_legion[creator] ~= nil then
                        local skins = skinData_cache_legion[creator].skins
                        if skins ~= nil and skins[skin] then
                            prefab.components.skinedlegion:SetSkin(skin)
                        end
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
                                if DoYouHaveSkin(skinname, doer.skinData_legion) then
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

else
    fn_skinDataDirty = function(inst, valuekey)
        local idxs = inst[valuekey]:value()
        if idxs ~= nil and #idxs > 0 then
            if idxs[1] == 0 then --第一个元素为0代表想清除皮肤数据
                inst.skinData_legion = nil
            else
                if inst.skinData_legion == nil then
                    inst.skinData_legion = {}
                end
                for k,v in pairs(idxs) do
                    if SKIN_IDX_LEGION[v] ~= nil then
                        inst.skinData_legion[SKIN_IDX_LEGION[v]] = true
                    end
                end
            end
        end
    end
end

AddPlayerPostInit(function(inst)
    inst.skinData_legion = nil
    inst._skin_idxs1 = net_bytearray(inst.GUID, "localplayer._skin_idxs1", "skin_data1_l_dirty")
    --net_bytearray只能装31个元素，所以这里可以准备一下多个变量
    -- inst._skin_idxs2 = net_bytearray(inst.GUID, "localplayer._skin_idxs2", "skin_data2_l_dirty")

    if IsServer then
        fn_GetSkinData(inst, 0.5)

        --还是让玩家实体存储自己的皮肤数据吧，免得网络问题导致皮肤没法用
        local OnSave_old = inst.OnSave
        local OnLoad_old = inst.OnLoad
        inst.OnSave = function(inst, data)
            if OnSave_old ~= nil then
                OnSave_old(inst, data)
            end

            if inst.skinData_legion ~= nil then
                local skins = nil
                for skinname,v in pairs(inst.skinData_legion) do
                    if skins == nil then
                        skins = {}
                    end
                    skins[skinname] = true
                end
                if skins ~= nil then
                    data.skinData_legion = skins
                end
            end
        end
        inst.OnLoad = function(inst, data)
            if OnLoad_old ~= nil then
                OnLoad_old(inst, data)
            end

            local skinData_cache = skinData_cache_legion[inst.userid]
            if skinData_cache == nil then
                if data ~= nil and data.skinData_legion ~= nil then
                    skinData_cache_legion[inst.userid] = {
                        skins = data.skinData_legion
                    }
                    SetNet_skinIdx(inst, data.skinData_legion)
                end
            else
                if data ~= nil and data.skinData_legion ~= nil then
                    skinData_cache.skins = data.skinData_legion
                end
                if skinData_cache.skins ~= nil then --即使玩家自己没缓存，看能不能拿全局的缓存数据
                    SetNet_skinIdx(inst, skinData_cache.skins)
                end
            end
        end
    else
        inst:ListenForEvent("skin_data1_l_dirty", function()
            fn_skinDataDirty(inst, "_skin_idxs1")
        end)
        -- inst:ListenForEvent("skin_data2_l_dirty", function() --备用
        --     fn_skinDataDirty(inst, "_skin_idxs2")
        -- end)
    end
end)

--------------------------------------------------------------------------
--[[ 修改审视自我按钮的弹出界面，增加皮肤界面触发按钮 ]]
--------------------------------------------------------------------------

if not TheNet:IsDedicated() then
    if TUNING.LEGION_MOD_LANGUAGES == "chinese" then
        local ImageButton = require "widgets/imagebutton"
        local PlayerAvatarPopup = require "widgets/playeravatarpopup"
        -- local SkinLegionDialog = require "widgets/skinlegiondialog"

        local right_root = nil
        AddClassPostConstruct("widgets/controls", function(self)
            right_root = self.right_root
        end)

        local Layout_old = PlayerAvatarPopup.Layout
        PlayerAvatarPopup.Layout = function(self, ...)
            Layout_old(self, ...)
            if not TheInput:ControllerAttached() then
                if self.close_button then
                    self.close_button:SetPosition(90, -269)
                end

                if right_root and right_root.skinshop_legion then --再次打开人物自检面板时，需要关闭已有的商城页面
                    right_root.skinshop_legion:Kill()
                    right_root.skinshop_legion = nil
                end

                self.skinshop_l_button = self.proot:AddChild(
                    ImageButton("images/global_redux.xml", "button_carny_long_normal.tex",
                        "button_carny_long_hover.tex", "button_carny_long_disabled.tex", "button_carny_long_down.tex")
                )
                self.skinshop_l_button.image:SetScale(.5)
                self.skinshop_l_button:SetFont(CHATFONT)
                self.skinshop_l_button:SetPosition(-80, -271)
                self.skinshop_l_button.text:SetColour(0,0,0,1)
                self.skinshop_l_button:SetTextSize(26)
                self.skinshop_l_button:SetText("棱镜皮肤铺")
                self.skinshop_l_button:SetOnClick(function()
                    if right_root then
                        if right_root.skinshop_legion then
                            right_root.skinshop_legion:Kill()
                        end
                        local SkinLegionDialog = _G.require("widgets/skinlegiondialog")
                        right_root.skinshop_legion = right_root:AddChild(SkinLegionDialog(self.owner, "tttest"))
                        right_root.skinshop_legion:SetPosition(-380, 0)
                    end
                    self:Close()
                end)
            end
        end
    end
end

--------------------------------------------------------------------------
--[[ RPC使用讲解
    Tip:
        【客户端发送请求】SendModRPCToServer(GetModRPC("LegionSkined", "RefreshSkinData"), 参数2, 参数3, ...)
        【服务器监听与响应请求】
            AddModRPCHandler("LegionSkined", "RefreshSkinData", function(player, 参数2, ...) --第一个参数固定为发起请求的玩家
                --做你想做的
            end)
]]--
--------------------------------------------------------------------------
