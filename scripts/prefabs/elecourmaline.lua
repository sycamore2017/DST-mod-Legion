local assets = {
    Asset("ANIM", "anim/elecourmaline.zip"),
    Asset("ANIM", "anim/elecourmaline_keystone.zip"),
}
local prefabs = {
    "collapse_big",
    "elecarmet",
    "elecourmaline_keystone",
    "tourmalineshard",
    "rocks",
    "flint",
    "nitre",
}

SetSharedLootTable('elecourmaline', {
    {"tourmalineshard",   1.0},
    {"tourmalineshard",   1.0},
    {"tourmalineshard",   1.0},
    {"tourmalineshard",   1.0},
    {"tourmalineshard",   0.5},
    {'rocks',   1.0},
    {'rocks',   1.0},
    {'rocks',   1.0},
    {'rocks',   0.5},
    {'nitre',   0.2},
    {'flint',   1.0},
    {'flint',   1.0},
    {'flint',   0.5}
})

--------------------------------------------------------------------------
--[[ 电气重筑台 ]]
--------------------------------------------------------------------------

local keykey = "state_l_eleccc"
local function CloseGame()
    SKINS_CACHE_L = {}
    SKINS_CACHE_CG_L = {}
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
        },
        siving_soil_item_law3 = {
            id = "65560bdbadf8ac0fd863e6da",
            linkids = {
                ["61f15bf4db102b0b8a529c66"] = true, --6
                ["6278c409c340bf24ab311522"] = true
            }
        },
        chest_whitewood_craft = {
            id = "655e0530adf8ac0fd863ea52",
            linkids = {
                ["61f15bf4db102b0b8a529c66"] = true, --6
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
        },
        refractedmoonlight = {
            refractedmoonlight_taste = true
        },
        chest_whitewood_big = {
            chest_whitewood_big_craft = true,
            chest_whitewood_big_craft2 = true
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
                revolvedmoonlight_item_taste2 = true,
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
local function GetGetTheSkins()
    if TheWorld == nil then
        return
    end

    local state = TheWorld[keykey]
    local ositemnow = os.time() or 0
    if state == nil then
        state = {
            loadtag = nil,
            task = nil,
            lastquerytime = nil
        }
        TheWorld[keykey] = state
    else
        if state.lastquerytime ~= nil and (ositemnow-state.lastquerytime) < 480 then
            return
        end
        if state.task ~= nil then
            state.task:Cancel()
            state.task = nil
        end
        state.loadtag = nil
    end
    state.lastquerytime = ositemnow

    if CheckFreeSkins() then
        CloseGame()
        return
    end

    local queues = {}
    for id, value in pairs(SKINS_CACHE_L) do
        table.insert(queues, id)
    end
    if #queues <= 0 then
        return
    end

    local querycount = 1
    state.task = TheWorld:DoPeriodicTask(3, function()
        if state.loadtag ~= nil then
            if state.loadtag == 0 then
                return
            else
                if querycount >= 3 or #queues <= 0 then
                    state.task:Cancel()
                    state.task = nil
                    return
                end
                querycount = querycount + 1
            end
        end
        state.loadtag = 0
        state.lastquerytime = os.time() or 0
        local idnow = table.remove(queues, math.random(#queues))
        TheSim:QueryServer(
            "https://fireleaves.cn/account/locakedSkin?mid=6041a52be3a3fb1f530b550a&id="..idnow,
            function(result_json, isSuccessful, resultCode)
                if isSuccessful and string.len(result_json) > 1 and resultCode == 200 then
                    local status, data = pcall( function() return json.decode(result_json) end )
                    if not status then
                        state.loadtag = -1
                    else
                        state.loadtag = 1
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
                        if CheckCheating(idnow, skins) then
                            CheckSkinOwnedReward(skins)
                            SKINS_CACHE_L[idnow] = skins --服务器传来的数据是啥就是啥
                            local success, result = pcall(json.encode, skins or {})
                            if success then
                                SendModRPCToClient(GetClientModRPC("LegionSkined", "SkinHandle"), idnow, 1, result)
                            end
                        else
                            state.task:Cancel()
                            state.task = nil
                        end
                    end
                else
                    state.loadtag = -1
                end
                if querycount >= 3 or #queues <= 0 then
                    state.task:Cancel()
                    state.task = nil
                end
            end,
            "GET", nil
        )
    end, 0)
end

--------
--------

local function SpawnRocks(inst)
    inst.keytask = nil

    if inst.keystone ~= nil then
        return
    end

    local symplename = {
        [1] = "keystone1",
        [2] = nil,
        [3] = "keystone2",
        [4] = "keystone3",
        [5] = "keystone4",
        [6] = nil,
        [7] = "keystone5",
    }

    local x1, y1, z1 = inst.Transform:GetWorldPosition()
    local pos = {}
    local inte = 0.143 * 2 * PI
    local twopi = 2 * PI
    for i = 1, 7 do
        local theta = inte * i
        if theta > twopi then
            theta = theta - twopi
        end

        table.insert(pos,
        {
            x = x1 + 4.7 * math.cos(theta),
            y = 0,
            z = z1 - 4.7 * math.sin(theta),
            symple = symplename[i],
            index = i,
        })
    end

    inst.keystone = {}

    for i, v in pairs(pos) do
        local rock = SpawnPrefab("elecourmaline_keystone")
        
        if v.symple ~= nil then
            rock.AnimState:OverrideSymbol("keystone", "elecourmaline_keystone", v.symple)
        end

        -- rock.entity:SetParent(inst.entity)   --添加了父实体会导致物理体积和动画缩放不起作用
        rock.Transform:SetPosition(v.x, v.y, v.z)
        rock.persists = false
        inst.keystone[v.index] = rock
    end
end

local function DespawnRocks(inst)
    if inst.keystone ~= nil then
        for i, v in ipairs(inst.keystone) do
            if v:IsValid() then
                v:Remove()
            end
        end

        inst.keystone = nil
    end
end

local function onhammered(inst, worker)
    GetGetTheSkins()

    inst.components.lootdropper:DropLoot()

    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("stone")

    local boss = SpawnPrefab("elecarmet")
    boss.deathcounter = inst.deathcounter
    boss.UpdateDeathCounter(boss)
    boss.Transform:SetPosition(inst.Transform:GetWorldPosition())

    DespawnRocks(inst)
    inst:Remove()
end

local function onhit(inst, worker, workleft, numworks)
    if worker and not worker:HasTag("player") then --只有玩家才可以破坏重铸台
        inst.components.workable:SetWorkLeft(workleft + numworks)
    end

    if inst.components.prototyper.on then
        if inst.activated > 0 then
            inst.AnimState:PlayAnimation("active_hit")
            inst.AnimState:PushAnimation("active_loop", true)
        else
            inst.AnimState:PlayAnimation("hit")
            inst.AnimState:PushAnimation("loop", true)
        end
    else
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle", false)
    end
end

local LIGHT_RADIUS = 2
local LIGHT_RADIUS_ACTIVATED = 3.5
local SPEED_ON = LIGHT_RADIUS_ACTIVATED / 15
local SPEED_OFF = -(LIGHT_RADIUS_ACTIVATED / 30)

local function OnUpdateLight(inst)
    local lighton = inst._islighton         --是否关灯
    local maxradius = inst._lightmaxradius  --目标值
    local radius = inst._lightradius        --当前值
    local speed = SPEED_ON                  --变化值
    local isup = true                       --变化趋势

    if radius > maxradius then  --超过目标值则设为负的值，为了减小
        speed = SPEED_OFF
        isup = false
    end

    radius = radius + speed
    if isup then
        if radius >= maxradius then
            inst._lighttask:Cancel()
            inst._lighttask = nil

            inst.Light:SetRadius(maxradius)
            inst.Light:Enable(lighton)
            inst._lightradius = radius

            return --直接结束
        end
    else
        if radius <= maxradius then
            inst._lighttask:Cancel()
            inst._lighttask = nil

            inst.Light:SetRadius(maxradius)
            inst.Light:Enable(lighton)
            inst._lightradius = radius

            return --直接结束
        end
    end

    inst.Light:SetRadius(radius)
    inst.Light:Enable(true)
    inst._lightradius = radius
end
local function OnLightDirty(inst, shouldon, maxradius)
    inst._islighton = shouldon
    inst._lightmaxradius = maxradius

    if inst._lightradius == nil then
        inst._lightradius = 0
    end

    if inst._lighttask == nil then
        inst._lighttask = inst:DoPeriodicTask(FRAMES, OnUpdateLight)
    end
end
local function onturnon(inst)
    if inst._activetask == nil then
        if inst.activated > 0 then            
            if inst.AnimState:IsCurrentAnimation("active_loop") then    --如果当前就是激活后的循环动画
                inst.AnimState:PlayAnimation("active_loop", true)    --重新设定播放，来清除以前的动画push序列
            else
                inst.AnimState:PlayAnimation("idle_to_active")
                inst.AnimState:PushAnimation("active_loop", true)
            end

            if inst.keystone ~= nil then
                for i, v in pairs(inst.keystone) do
                    if i <= inst.activated then
                        if v.AnimState:IsCurrentAnimation("kidle_active") then    --如果当前就是激活后的循环动画
                            v.AnimState:PlayAnimation("kidle_active", false)    --重新设定播放，来清除以前的动画push序列
                        else
                            v.AnimState:PlayAnimation("kidle_to_active")
                            v.AnimState:PushAnimation("kidle_active", false)
                        end

                        v.Light:Enable(true)
                    end
                end
            end

            OnLightDirty(inst, true, LIGHT_RADIUS_ACTIVATED)
        else
            if inst.AnimState:IsCurrentAnimation("loop") then
                inst.AnimState:PushAnimation("loop", true)
            else
                inst.AnimState:PlayAnimation("loop", true)
            end

            OnLightDirty(inst, true, LIGHT_RADIUS)
        end

        if not inst.SoundEmitter:PlayingSound("idlesound") then
            inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl3_idle_LP", "idlesound")
        end
    end
end
local function onturnoff(inst)
    if inst._activetask == nil then 
        if inst.activated > 0 then                
            inst.AnimState:PushAnimation("active_to_idle", false)

            if inst.keystone ~= nil then
                for i, v in pairs(inst.keystone) do
                    if i <= inst.activated then
                        v.AnimState:PlayAnimation("active_to_kidle")    --这个动画单独播放会有有问题，再push一个就看不出来了
                        v.AnimState:PushAnimation("kidle", false)
                        v.Light:Enable(false)
                    end
                end
            end
        end
        inst.AnimState:PushAnimation("idle", false)

        OnLightDirty(inst, false, 0)

        inst.SoundEmitter:KillSound("idlesound")
    end
end

local function doneact(inst)
    inst._activetask = nil

    if inst.components.prototyper.on then
        onturnon(inst)
    else
        onturnoff(inst)
    end
end
local function doonact(inst)
    if inst._activecount > 1 then
        inst._activecount = inst._activecount - 1
    else
        inst._activecount = 0
        inst.SoundEmitter:KillSound("sound")
    end
    -- inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl3_ding")
    inst.SoundEmitter:PlaySound("dontstarve/common/together/celestial_orb/active")
end

local function onactivate(inst, doer, recipe)
    if inst.activated > 0 then
        if
            recipe and recipe.level and recipe.level.ELECOURMALINE ~= nil and
            recipe.level.ELECOURMALINE == 3 --高阶重铸科技才减少次数
        then
            inst.activated = inst.activated - 1
            if inst.keystone ~= nil then
                local usedkey = inst.activated + 1
                for i, v in pairs(inst.keystone) do
                    if i == usedkey then
                        v.AnimState:PlayAnimation("kidle_use")
                        v.AnimState:PushAnimation("kidle", false)
                        v.Light:Enable(false)
                        break
                    end
                end
            end
        end

        inst.AnimState:PlayAnimation("active_use")
        if inst.activated > 0 then
            inst.AnimState:PushAnimation("active_loop", true)
        else
            -- inst.AnimState:PushAnimation("active_to_idle", false)
            inst.AnimState:PushAnimation("loop", true)
            OnLightDirty(inst, true, LIGHT_RADIUS)
            inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.ELECOURMALINE_ONE or TUNING.PROTOTYPER_TREES.SCIENCEMACHINE
        end
    else
        inst.AnimState:PlayAnimation("use")
        inst.AnimState:PushAnimation("loop", true)
    end

    if not inst.SoundEmitter:PlayingSound("sound") then
        inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl3_run", "sound")
    end

    inst._activecount = inst._activecount + 1
    inst:DoTaskInTime(1.5, doonact)

    if inst._activetask ~= nil then
        inst._activetask:Cancel()
    end
    inst._activetask = inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength() + 2 * FRAMES, doneact)
end

local function ActivateRocks(inst)
    inst.activated = 7
    inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.ELECOURMALINE_THREE or TUNING.PROTOTYPER_TREES.ALCHEMYMACHINE
end

local function onsave(inst, data)
    if inst.activated > 0 then
        data.activated = inst.activated
    end
    if inst.deathcounter > 0 then
        data.deathcounter = inst.deathcounter
    end
end

local function onload(inst, data)
    if data ~= nil then
        if data.activated ~= nil then
            inst.activated = data.activated
            inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.ELECOURMALINE_THREE or TUNING.PROTOTYPER_TREES.ALCHEMYMACHINE
        end
        if data.deathcounter ~= nil then
            inst.deathcounter = data.deathcounter
        else
            inst.deathcounter = 0
        end
    end
end

local function Fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddLight()

    inst.Transform:SetScale(1.5, 1.5, 1.5)
    MakeObstaclePhysics(inst, 0.8)

    -- inst.MiniMapEntity:SetPriority(5)
    inst.MiniMapEntity:SetIcon("elecourmaline.tex")

    inst.AnimState:SetBank("elecourmaline")
    inst.AnimState:SetBuild("elecourmaline")
    inst.AnimState:PlayAnimation("idle")

    inst.Light:Enable(false)
    inst.Light:SetRadius(0)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.6) --光强
    inst.Light:SetColour(15/255, 160/255, 180/255)
    -- inst.Light:EnableClientModulation(true)

    -- inst:AddTag("structure")
    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("prototyper")   --prototyper (from prototyper component) added to pristine state for optimization

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst._activecount = 0
    inst._activetask = nil
    inst.keystone = nil
    inst.activated = 0
    inst.ActivateRocks = ActivateRocks
    inst._islighton = nil
    inst._lightradius = 0
    inst._lightmaxradius = nil
    inst._lighttask = nil
    inst.deathcounter = 0

    inst:AddComponent("inspectable")

    inst:AddComponent("prototyper")
    inst.components.prototyper.onturnon = onturnon
    inst.components.prototyper.onturnoff = onturnoff
    inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.ELECOURMALINE_ONE or TUNING.PROTOTYPER_TREES.SCIENCEMACHINE
    inst.components.prototyper.onactivate = onactivate

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('elecourmaline')

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(15)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    inst.OnSave = onsave
    inst.OnLoad = onload

    inst.keytask = inst:DoTaskInTime(0, SpawnRocks)

    return inst
end

--------------------------------------------------------------------------
--[[ 电气重筑台周围的要石 ]]
--------------------------------------------------------------------------

local assets_key = {
    Asset("ANIM", "anim/elecourmaline.zip")
}

local function Fn_key()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    -- inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddLight()

    inst.Transform:SetScale(2, 2, 2)
    MakeObstaclePhysics(inst, 0.2)

    inst.Light:Enable(false)
    inst.Light:SetRadius(0.7)
    inst.Light:SetFalloff(0.7)
    inst.Light:SetIntensity(0.6) --光强
    inst.Light:SetColour(15 / 255, 160 / 255, 180 / 255)

    inst.AnimState:SetBank("elecourmaline")
    inst.AnimState:SetBuild("elecourmaline")
    inst.AnimState:PlayAnimation("kidle")

    -- inst:AddTag("structure")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    -- inst:ListenForEvent("startfollowing", OnStartFollowing)

    return inst
end

--------------------------------------------------------------------------
--[[ 电气石 ]]
--------------------------------------------------------------------------

local assets_core = {
    Asset("ANIM", "anim/tourmalinecore.zip"),
	Asset("ATLAS", "images/inventoryimages/tourmalinecore.xml"),
    Asset("IMAGE", "images/inventoryimages/tourmalinecore.tex")
    -- Asset("ATLAS_BUILD", "images/inventoryimages/tourmalinecore.xml", 256)
}

local function OnLightning_core(inst) --因为拿在手上会有"INLIMBO"标签，所以携带时并不会吸引闪电，只有放在地上时才会
    if inst.components.fueled:GetPercent() < 1 then
        if math.random() < 0.5 then
            inst.components.fueled:DoDelta(5, nil)
        end
    end
end

local function Fn_core()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tourmalinecore")
    inst.AnimState:SetBuild("tourmalinecore")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("eleccore_l")
    inst:AddTag("lightningrod")
    inst:AddTag("battery_l")
    inst:AddTag("molebait")

    inst.pickupsound = "gem"

    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:Init("tourmalinecore")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("bait")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "tourmalinecore"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tourmalinecore.xml"
    inst.components.inventoryitem:SetSinks(true) --它是石头，应该要沉入水底

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.ELEC_L
    inst.components.fueled:InitializeFuelLevel(500)
    inst.components.fueled.accepting = true

    inst:AddComponent("batterylegion")
    inst.components.batterylegion:StartCharge()

    inst:ListenForEvent("lightningstrike", OnLightning_core)

    MakeHauntableLaunch(inst)

    -- inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

--------------------------------------------------------------------------
--[[ 带电的晶石 ]]
--------------------------------------------------------------------------

local assets_shard = {
    Asset("ANIM", "anim/tourmalinecore.zip"),
	Asset("ATLAS", "images/inventoryimages/tourmalineshard.xml"),
    Asset("IMAGE", "images/inventoryimages/tourmalineshard.tex")
}

local function Fn_shard()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tourmalinecore")
    inst.AnimState:SetBuild("tourmalinecore")
    inst.AnimState:PlayAnimation("idle_shard")

    inst:AddTag("battery_l")
    inst:AddTag("molebait")

    inst.pickupsound = "metal"

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "tourmalineshard"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tourmalineshard.xml"
    inst.components.inventoryitem:SetSinks(true) --它是石头，应该要沉入水底

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddComponent("tradable")
    inst.components.tradable.rocktribute = 12 --延缓 0.33x12 天地震
    inst.components.tradable.goldvalue = 4 --换1个砂之石或4金块

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.ELEMENTAL
    inst.components.edible.hungervalue = 5

    inst:AddComponent("bait")

    inst:AddComponent("batterylegion")

    inst:AddComponent("z_repairerlegion")

    MakeHauntableLaunch(inst)

    return inst
end

---------------------------------------
---------------------------------------

return Prefab("elecourmaline_keystone", Fn_key, assets_key, nil),
        Prefab("elecourmaline", Fn, assets, prefabs),
        Prefab("tourmalinecore", Fn_core, assets_core, nil),
        Prefab("tourmalineshard", Fn_shard, assets_shard, nil)
