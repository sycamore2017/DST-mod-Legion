------skined_legion

local _G = GLOBAL
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()

--------------------------------------------------------------------------
--[[ 全局皮肤总数据，以及修改 ]]
--------------------------------------------------------------------------

local rarityRepay = "ProofOfPurchase"
local rarityFree = "Event"

_G.SKIN_PREFABS_LEGION = {
    rosorns = {
        assets = nil, --仅仅是用于初始化注册
        image = { name = nil, atlas = nil }, --提前注册，让客户端科技栏使用的皮肤图片
        fn_start = function(inst, skindata) --应用皮肤时的函数
            inst.AnimState:SetBank("rosorns")
            inst.AnimState:SetBuild("rosorns")
            inst.AnimState:PlayAnimation("idle")

            inst.components.inventoryitem.atlasname = skindata.image.atlas
			inst.components.inventoryitem:ChangeImageName(skindata.image.name)
        end,
        fn_end = nil, --取消皮肤时的函数
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
		},
		image = { name = nil, atlas = nil }, --提前注册，让客户端科技栏使用的皮肤图片
		anim = { bank = "spear_mirrorrose", build = "spear_mirrorrose", anim = nil },
        namestr = { chs = "施咒蔷薇", eng = "Rose Spell Staff" }, --皮肤名字
        fn_start = function(inst, skindata) --应用皮肤时的函数
            inst.AnimState:SetBank(skindata.anim.bank)
			inst.AnimState:SetBuild(skindata.anim.build)
			inst.AnimState:PlayAnimation(skindata.anim.anim)

            inst.components.inventoryitem.atlasname = skindata.image.atlas
			inst.components.inventoryitem:ChangeImageName(skindata.image.name)
        end,
        fn_end = nil, --取消皮肤时的函数

        fn_onEquip = function(skindata, inst, owner)
            owner.AnimState:OverrideSymbol("swap_object", "swap_spear_mirrorrose", "swap_spear")
            owner.AnimState:Show("ARM_carry")
            owner.AnimState:Hide("ARM_normal")
        end,
    },
}

_G.SKIN_IDS_LEGION = {
    ["freeskins"] = {}, --免费皮肤全部装这里面，skin_id设置为"freeskins"就好了
    -- ["61627d927bbb727be174c4a0"] = { rosorns_spell = true, },
}
_G.SKIN_IDX_LEGION = {
    -- [1] = "rosorns_spell",
}

local ischinese = TUNING.LEGION_MOD_LANGUAGES == "chinese"
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

        table.insert(Assets, Asset("ATLAS", v.image.atlas))
        table.insert(Assets, Asset("IMAGE", "images/inventoryimages_skin/"..v.image.name..".tex"))
        RegisterInventoryItemAtlas(v.image.atlas, v.image.name..".tex")
	end
	if v.anim ~= nil then
		if v.anim.bank == nil then
			v.anim.bank = skinname
		end
		if v.anim.build == nil then
			v.anim.build = skinname
		end
		if v.anim.anim == nil then
			v.anim.anim = "idle"
		end
	end
	if v.build_name_override == nil then
		v.build_name_override = skinname
	end
    if v.assets ~= nil then
        for kk,ast in pairs(v.assets) do
            table.insert(Assets, ast)
        end
    end

    table.insert(v.skin_tags, string.upper(skinname))
    table.insert(v.skin_tags, "CRAFTABLE")

    if ischinese then
        STRINGS.SKIN_NAMES[skinname] = v.namestr.chs
    else
        STRINGS.SKIN_NAMES[skinname] = v.namestr.eng
    end

    ------修改PREFAB_SKINS(在prefabskins.lua中被定义)
    if _G.PREFAB_SKINS[v.base_prefab] == nil then
        _G.PREFAB_SKINS[v.base_prefab] = { skinname }
    else
        table.insert(_G.PREFAB_SKINS[v.base_prefab], skinname)
    end
end
for baseprefab,v in pairs(_G.SKIN_PREFABS_LEGION) do
    if v.image ~= nil then
		if v.image.name == nil then
			v.image.name = baseprefab
		end
		if v.image.atlas == nil then
			v.image.atlas = "images/inventoryimages/"..baseprefab..".xml"
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
--[[ 修改SpawnPrefab()以应用皮肤机制 ]]
--------------------------------------------------------------------------

if IsServer then
    local SpawnPrefab_old = _G.SpawnPrefab
    _G.SpawnPrefab = function(name, skin, skin_id, creator)
        --【服务端】环境
        if skin ~= nil and SKINS_LEGION[skin] ~= nil then
            local prefab = SpawnPrefab_old(name, nil, nil, creator)
            if prefab ~= nil and creator ~= nil then
                if prefab.components.skinedlegion ~= nil then
                    prefab.components.skinedlegion:SetSkin(skin)
                end
            end
            return prefab
        else
            return SpawnPrefab_old(name, skin, skin_id, creator)
        end
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

AddClassPostConstruct("widgets/recipepopup", function(self)
    ------【客户端】环境
    local GetSkinsList_old = self.GetSkinsList
    self.GetSkinsList = function(self, ...)
        self.skins_list = GetSkinsList_old(self, ...)

        --undo这里需要确定玩家是否拥有该皮肤
        if self.recipe and PREFAB_SKINS[self.recipe.product] then
            for _, item_type in pairs(PREFAB_SKINS[self.recipe.product]) do
                if SKINS_LEGION[item_type] then
                    local data  = {
                        type = type, --不知道是啥
                        item = item_type, --就是这个皮肤的名字
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
        例如，1个玩家用本地电脑开含洞穴存档，则世界有主世界(与房主客户端世界是同一个)、洞穴世界(副世界)、客户端(其他玩家的各有一个)。
            开了含洞穴云服存档，则世界有主世界(云服)、洞穴世界(副世界)、客户端(所有玩家各有一个)
        modmain会在每个世界都加载一次

        TheWorld.ismastersim        --是否为服务器世界(主机+云服。本质上就是 TheNet:GetIsMasterSimulation())
        TheWorld.ismastershard      --是否为主世界(本质上就是 TheWorld.ismastersim and not TheShard:IsSecondary())
]]--
--------------------------------------------------------------------------

local fn_GetSkinData = nil
local fn_skinDataDirty = nil
if IsServer then
    --不想麻烦地写在世界里了，换个方式
    -- AddPrefabPostInit("shard_network", function(inst) --这个prefab只存在于服务器世界里（且只能存在一个）
    --     inst:AddComponent("shard_skin_legion")
    -- end)

    _G.skinData_cache_legion = {
        -- Kxx_xxxx = {
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

    local function SetNet_skinIdx(player, skindata)
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
        }
        local isbind = nil
        state.task = TheWorld:DoPeriodicTask(3, function()
            --参数有效性判断
            local user_id = player ~= nil and player.userid or userid
            if user_id == nil or user_id == "" then
                if state.errcount >= 2 then
                    StopQueryTask(state)
                else
                    state.errcount = state.errcount + 1
                end
                return
            end

            --是否已经在进行请求的判断
            if not isbind then
                local skinData_cache = skinData_cache_legion[user_id]
                if skinData_cache ~= nil then
                    if skinData_cache.loadtag == 0 then --有 正在进行 的请求，放弃当前操作
                        StopQueryTask(state)
                        return
                    elseif skinData_cache.loadtag == 1 then --有 已完成 的请求，放弃当前操作，并处理已有数据
                        StopQueryTask(state)
                        if player ~= nil then
                            SetNet_skinIdx(player, skinData_cache.skins)
                            skinData_cache.loadtag = nil --被用过后才恢复初始值
                        end
                        return
                    end
                    StopQueryTask(skinData_cache) --其他情况，取消已有task
                end
                skinData_cache_legion[user_id] = state
                isbind = true
            end

            --实体有效性判断
            if player ~= nil and not player:IsValid() then
                StopQueryTask(state)
                state.loadtag = nil
                return
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
                        print("------------skined: ", tostring(result_json)) --test
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
                            if player ~= nil then
                                SetNet_skinIdx(player, skins)
                                state.loadtag = nil
                            else
                                state.loadtag = 1
                            end
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
--[[ 玩家实体监听当前世界的皮肤数据并管理自己客户端皮肤数据 ]]
--------------------------------------------------------------------------
