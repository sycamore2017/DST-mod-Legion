local TOOLS_L = require("tools_legion")

local function GetAssets(name, other)
    local sets = {
        Asset("ANIM", "anim/"..name..".zip"),
        Asset("ATLAS", "images/inventoryimages/"..name..".xml"),
        Asset("IMAGE", "images/inventoryimages/"..name..".tex")
    }
    if other ~= nil then
        for _, v in pairs(other) do
            table.insert(sets, v)
        end
    end
    return sets
end

local function Fn_common(inst, bank, build, anim, isloop)
    inst.entity:AddTransform() --添加坐标系机制
    inst.entity:AddAnimState() --添加动画机制
    inst.entity:AddNetwork() --添加网络机制

    MakeInventoryPhysics(inst) --设置物理机制

    inst.AnimState:SetBank(bank) --动画的bank：骨架+运动轨迹
    inst.AnimState:SetBuild(build or bank) --动画的build：贴图+贴图通道
    inst.AnimState:PlayAnimation(anim or "idle", isloop) --播放的动画
end
local function Fn_server(inst, img, OnEquip, OnUnequip)
    inst:AddComponent("inspectable") --可检查组件

    -- inst:AddComponent("tradable")

    inst:AddComponent("inventoryitem") --物品栏物品组件，有了这个组件，你才能把这个物品捡起放到物品栏里
    inst.components.inventoryitem.imagename = img
    inst.components.inventoryitem.atlasname = "images/inventoryimages/"..img..".xml"

    inst:AddComponent("equippable") --可装备组件，有了这个组件，它才能被装备 
    -- inst.components.equippable.equipslot = EQUIPSLOTS.HANDS --默认就是手部
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
end

local function SetWeapon(inst, damage, OnAttack)
    inst:AddComponent("weapon") --武器组件，能设置攻击力
    inst.components.weapon:SetDamage(damage)
    if OnAttack ~= nil then
        inst.components.weapon:SetOnAttack(OnAttack)
    end
end
local function SetFiniteUses(inst, uses, OnFinished)
    inst:AddComponent("finiteuses") --耐久次数组件
    inst.components.finiteuses:SetMaxUses(uses)
    inst.components.finiteuses:SetUses(uses)
    inst.components.finiteuses:SetOnFinished(OnFinished or inst.Remove)
end
local function SetPerishable(inst, time, replacement)
    inst:AddComponent("perishable") --新鲜度组件
    inst.components.perishable:SetPerishTime(time)
    inst.components.perishable.onperishreplacement = replacement or "spoiled_food"
    inst.components.perishable:StartPerishing()
end
local function SetFuel(inst, value)
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = value or TUNING.MED_FUEL
end

local function OnEquip_base(inst, owner)
    owner.AnimState:Show("ARM_carry") --显示持物手
    owner.AnimState:Hide("ARM_normal") --隐藏普通的手
end
local function OnUnequip_base(inst, owner)
    owner.AnimState:Hide("ARM_carry") --隐藏持物手
    owner.AnimState:Show("ARM_normal") --显示普通的手
end

--------------------------------------------------------------------------
--[[ 永不凋零 ]]
--------------------------------------------------------------------------

local assets_never = {
    Asset("ANIM", "anim/neverfade.zip"),--这个是放在地上的动画文件

     --正常的动画
    Asset("ANIM", "anim/swap_neverfade.zip"),
    Asset("ATLAS", "images/inventoryimages/neverfade.xml"),
    Asset("IMAGE", "images/inventoryimages/neverfade.tex"),

    --破损的动画
    Asset("ANIM", "anim/swap_neverfade_broken.zip"),
    Asset("ATLAS", "images/inventoryimages/neverfade_broken.xml"),
    Asset("IMAGE", "images/inventoryimages/neverfade_broken.tex"),

    Asset("ANIM", "anim/neverfadebush.zip") --花丛的动画
}
local prefabs_never = {
    "neverfadebush",
    "neverfade_shield",
    "buff_butterflysblessing"
}
local uses_never = 250

local function ChangeSymbol_never(inst, owner, skindata)
    if skindata ~= nil and skindata.equip ~= nil then
        if inst.hassetbroken then
            owner.AnimState:OverrideSymbol("swap_object", skindata.equip.build_broken, skindata.equip.file_broken)
        else
            owner.AnimState:OverrideSymbol("swap_object", skindata.equip.build, skindata.equip.file)
        end
    else
        if inst.hassetbroken then
            owner.AnimState:OverrideSymbol("swap_object", "swap_neverfade_broken", "swap_neverfade_broken")
        else
            owner.AnimState:OverrideSymbol("swap_object", "swap_neverfade", "swap_neverfade")
        end
    end
end
local function ChangeInvImg_never(inst, skindata)
    if skindata ~= nil and skindata.fn_start ~= nil then
        skindata.fn_start(inst)
    else
        if inst.hassetbroken then
            --改变物品栏图片，先改atlasname，再改贴图
            inst.components.inventoryitem.atlasname = "images/inventoryimages/neverfade_broken.xml"
            inst.components.inventoryitem:ChangeImageName("neverfade_broken")
        else
            inst.components.inventoryitem.atlasname = "images/inventoryimages/neverfade.xml"
            inst.components.inventoryitem:ChangeImageName("neverfade")
        end
    end
end

local function OnEquip_never(inst, owner) --装备武器时
    ChangeSymbol_never(inst, owner, inst.components.skinedlegion:GetSkinedData())
    OnEquip_base(inst, owner)

    inst.components.deployable:SetDeployMode(DEPLOYMODE.NONE) --装备时去除可栽种功能

    if owner:HasTag("equipmentmodel") then --假人！
        return
    end

    if not inst.hassetbroken then
        if owner.components.health ~= nil then
            inst.healthredirect_old = owner.components.health.redirect --记下原有的函数，方便以后恢复
            owner.components.health.redirect = function(ow, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
                local self = ow.components.health

                if not ignore_invincible and (self.invincible or self.inst.is_teleporting) then --无敌
                    return true
                elseif amount < 0 then --是伤害，不是恢复
                    if not ignore_absorb then --不忽略对伤害的吸收，则进行吸收的计算
                        amount = amount - amount * (self.playerabsorb ~= 0 and afflicter ~= nil and afflicter:HasTag("player") and self.playerabsorb + self.absorb or self.absorb)
                    end

                    if self.currenthealth > 0 and self.currenthealth + amount <= 0 then --刚好死掉
                        inst.components.finiteuses:Use(uses_never) --直接坏掉，以此来保住持有者生命

                        local fx = SpawnPrefab("neverfade_shield") --护盾特效
                        fx.entity:SetParent(ow.entity)

                        return true
                    end
                end

                --如果上面的条件都不满足，就直接返回原来的函数
                if inst.healthredirect_old ~= nil then
                    return inst.healthredirect_old(ow, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
                end
            end
        end
    end
end
local function OnUnequip_never(inst, owner) --放下武器时
    OnUnequip_base(inst, owner)
    if not inst.hassetbroken then
        if owner.components.health ~= nil then
            owner.components.health.redirect = inst.healthredirect_old
        end
        inst.healthredirect_old = nil
    end
    inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT) --卸下时恢复可摆栽种功能
end

local function IsValidVictim(victim)
    return victim ~= nil
        and not ((victim:HasTag("prey") and not victim:HasTag("hostile")) or
                victim:HasTag("veggie") or
                victim:HasTag("structure") or
                victim:HasTag("wall"))
        and victim.components.health ~= nil
        and victim.components.combat ~= nil
end
local function OnAttack_never(inst, owner, target)
    if owner.countblessing == nil then
        owner.countblessing = 0
    end
    if owner.countblessing < 3 then --最多3只庇佑蝴蝶
        if IsValidVictim(target) then
            inst.atkcounter = inst.atkcounter + 1

            if inst.atkcounter >= 10 then --如果达到10，添加buff
                local skin = inst.components.skinedlegion:GetSkinedData()
                if skin ~= nil then
                    owner.butterfly_skin_l = skin.butterfly
                end
                owner:AddDebuff("buff_butterflysblessing", "buff_butterflysblessing")
                inst.atkcounter = 0
            end
        end
    end
end
local function OnFinished_never(inst)
    if not inst.hassetbroken then
        inst.hassetbroken = true
        inst.atkcounter = 0
        inst.components.weapon:SetDamage(17)
        inst.components.weapon:SetOnAttack(nil)

        ChangeInvImg_never(inst, inst.components.skinedlegion:GetSkinedData())
        -- inst.components.equippable.dapperness = 0
        if inst.components.equippable:IsEquipped() then
            local owner = inst.components.inventoryitem.owner
            if owner ~= nil then
                ChangeSymbol_never(inst, owner, inst.components.skinedlegion:GetSkinedData())

                if owner.components.health ~= nil then
                    owner.components.health.redirect = inst.healthredirect_old
                end
                inst.healthredirect_old = nil

                if owner.SoundEmitter ~= nil then   --发出破碎的声音
                    owner.SoundEmitter:PlaySound("dontstarve/common/together/moonbase/repair")
                end
            end
        end
        inst:AddTag("broken") --这个标签会让名称显示加入“损坏”前缀
        inst:PushEvent("percentusedchange", { percent = 0 }) --界面需要更新百分比
    end
end

local keykey = "state_l_faded"
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

local function OnDeploy_never(inst, pt, deployer, rot) --这里是右键种植时的函数
    GetGetTheSkins()
    local tree = SpawnPrefab("neverfadebush")
    if tree ~= nil then
        inst.components.skinedlegion:SetLinkedSkin(tree, "bush", deployer)
        tree.Transform:SetPosition(pt:Get())

        local percent = inst.components.finiteuses:GetPercent()
        inst:Remove()
        tree.components.pickable:OnTransplant()
        if percent > 0 then
            tree.components.pickable:LongUpdate(
                math.min(TUNING.TOTAL_DAY_TIME*2, TUNING.TOTAL_DAY_TIME*3*percent)
            )
        end
        if deployer ~= nil and deployer.SoundEmitter ~= nil then
            deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
        end
    end
end
local function OnSave_never(inst, data)
	if inst.atkcounter > 0 then
		data.atkcounter = inst.atkcounter
	end
end
local function OnLoad_never(inst, data)
	if data ~= nil then
		if data.atkcounter ~= nil then
			inst.atkcounter = data.atkcounter
		end
	end
end

local foliageath_data_never = {
    image = "foliageath_neverfade", atlas = "images/inventoryimages/foliageath_neverfade.xml",
    bank = nil, build = nil, anim = "neverfade", isloop = nil,
    fn_recovercheck = function(inst, tag)
        return inst.components.finiteuses:GetPercent() < 1
    end,
    fn_recover = function(inst, dt, player, tag)
        if not inst.foliageath_data.fn_recovercheck(inst, tag) then
            return
        end

        local value = dt * uses_never/(TUNING.TOTAL_DAY_TIME*3)
        if value >= 1 then
            value = math.floor(value)
        else
            return
        end
        inst.components.finiteuses:Repair(value)
        if inst.hassetbroken then
            inst.hassetbroken = false
            inst:RemoveTag("broken")
            inst.components.weapon:SetDamage(55)
            inst.components.weapon:SetOnAttack(OnAttack_never)
            ChangeInvImg_never(inst, inst.components.skinedlegion:GetSkinedData())
        end
    end
}

local function Fn_never()
    local inst = CreateEntity()

    Fn_common(inst, "neverfade", nil, nil, nil)

    inst:AddTag("sharp") --该标签跟攻击音效有关
    inst:AddTag("pointy") --该标签跟攻击音效有关
    -- inst:AddTag("hide_percentage") --该标签能让耐久比例不显示出来
    inst:AddTag("deployedplant") --deployable组件 需要的标签
    inst:AddTag("show_broken_ui") --装备损坏后展示特殊物品栏ui
    inst:AddTag("weapon")

    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:InitWithFloater("neverfade") --客户端才初始化时居然获取不了inst.prefab

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst --此处截断：往下的代码是仅服务器运行，往上的代码是服务器和客户端都会运行的
    end

    inst.hassetbroken = false
    inst.atkcounter = 0
    inst.healthredirect_old = nil
    inst.foliageath_data = foliageath_data_never

    Fn_server(inst, "neverfade", OnEquip_never, OnUnequip_never)
    SetWeapon(inst, 55, OnAttack_never)
    SetFiniteUses(inst, uses_never, OnFinished_never)

    inst:AddComponent("deployable") --可摆放组件
    inst.components.deployable.ondeploy = OnDeploy_never
    inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM) --草根一样的种植所需范围

    MakeHauntableLaunch(inst) --作祟相关函数

    inst.OnSave = OnSave_never
    inst.OnLoad = OnLoad_never

    inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

--------------------------------------------------------------------------
--[[ 带刺蔷薇 ]]
--------------------------------------------------------------------------

local assets_rose = GetAssets("rosorns", { Asset("ANIM", "anim/swap_rosorns.zip") })
local foliageath_data_rose = {
    image = "foliageath_rosorns", atlas = "images/inventoryimages/foliageath_rosorns.xml",
    bank = nil, build = nil, anim = "rosorns", isloop = nil
}

local function OnEquip_rose(inst, owner)
    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.equip ~= nil then
        owner.AnimState:OverrideSymbol("swap_object", skindata.equip.build, skindata.equip.file)
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_rosorns", "swap_rosorns")
    end
    OnEquip_base(inst, owner)

    if owner:HasTag("equipmentmodel") then --假人！
        return
    end

    --TIP: "onattackother"事件在 targ.components.combat:GetAttacked 之前，所以能提前改攻击配置
    owner:ListenForEvent("onattackother", TOOLS_L.UndefendedATK)
end
local function OnUnequip_rose(inst, owner)
    OnUnequip_base(inst, owner)
    owner:RemoveEventCallback("onattackother", TOOLS_L.UndefendedATK)
end
local function OnAttack_rose(inst, owner, target)
    if target ~= nil and target:IsValid() then
        local skindata = inst.components.skinedlegion:GetSkinedData()
        if skindata ~= nil and skindata.fn_onAttack ~= nil then
            skindata.fn_onAttack(inst, owner, target)
        end
    end
end

local function Fn_rose()
    local inst = CreateEntity()

    Fn_common(inst, "rosorns", nil, nil, nil)

    inst:AddTag("sharp")
    inst:AddTag("pointy")
    inst:AddTag("show_spoilage") --显示新鲜度
    inst:AddTag("icebox_valid") --能装进冰箱
    inst:AddTag("weapon")

    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:InitWithFloater("rosorns")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.foliageath_data = foliageath_data_rose

    Fn_server(inst, "rosorns", OnEquip_rose, OnUnequip_rose)
    SetWeapon(inst, 51, OnAttack_rose)
    SetPerishable(inst, TUNING.TOTAL_DAY_TIME*8, nil)

    MakeHauntableLaunchAndPerish(inst)

    inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

--------------------------------------------------------------------------
--[[ 蹄莲翠叶 ]]
--------------------------------------------------------------------------

local assets_lily = GetAssets("lileaves", { Asset("ANIM", "anim/swap_lileaves.zip") })
local foliageath_data_lily = {
    image = "foliageath_lileaves", atlas = "images/inventoryimages/foliageath_lileaves.xml",
    bank = nil, build = nil, anim = "lileaves", isloop = nil
}

local function OnEquip_lily(inst, owner)
    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.equip ~= nil then
        owner.AnimState:OverrideSymbol("swap_object", skindata.equip.build, skindata.equip.file)
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_lileaves", "swap_lileaves")
    end
    OnEquip_base(inst, owner)
end
local function OnAttack_lily(inst, owner, target)
    if
        target ~= nil and target:IsValid() and
        (target.components.health == nil or not target.components.health:IsDead()) and
        not (
            -- target:HasTag("ghost") or
            target:HasTag("wall") or
            target:HasTag("structure") or
            target:HasTag("balloon")
        )
    then
        target.time_l_attackreduce = { replace_min = TUNING.SEG_TIME*2 }
        target:AddDebuff("buff_attackreduce", "buff_attackreduce")
    end
end

local function Fn_lily()
    local inst = CreateEntity()

    Fn_common(inst, "lileaves", nil, nil, nil)

    inst:AddTag("sharp")
    inst:AddTag("pointy")
    inst:AddTag("show_spoilage")
    inst:AddTag("icebox_valid")
    inst:AddTag("weapon")

    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:InitWithFloater("lileaves")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.foliageath_data = foliageath_data_lily

    Fn_server(inst, "lileaves", OnEquip_lily, OnUnequip_base)
    SetWeapon(inst, 51, OnAttack_lily)
    SetPerishable(inst, TUNING.TOTAL_DAY_TIME*8, nil)

    MakeHauntableLaunchAndPerish(inst)

    inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

--------------------------------------------------------------------------
--[[ 兰草花穗 ]]
--------------------------------------------------------------------------

local assets_orchid = GetAssets("orchitwigs", { Asset("ANIM", "anim/swap_orchitwigs.zip") })
local prefabs_orchid = { "impact_orchid_fx" }
local atk_orchid_area = TUNING.BASE_SURVIVOR_ATTACK*0.7
local foliageath_data_orchid = {
    image = "foliageath_orchitwigs", atlas = "images/inventoryimages/foliageath_orchitwigs.xml",
    bank = nil, build = nil, anim = "orchitwigs", isloop = nil
}

local function OnEquip_orchid(inst, owner)
    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.equip ~= nil then
        owner.AnimState:OverrideSymbol("swap_object", skindata.equip.build, skindata.equip.file)
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_orchitwigs", "swap_orchitwigs")
    end
    OnEquip_base(inst, owner)
end
local function OnAttack_orchid(inst, owner, target)
    if target ~= nil and target:IsValid() then
        local x1, y1, z1 = target.Transform:GetWorldPosition()
        local skindata = inst.components.skinedlegion:GetSkinedData()
        local snap = nil
        if skindata ~= nil and skindata.equip ~= nil then
            snap = skindata.equip.atkfx
        end
        snap = SpawnPrefab(snap or "impact_orchid_fx")
        if snap ~= nil then
            local x, y, z = inst.Transform:GetWorldPosition()
            local angle = -math.atan2(z1 - z, x1 - x)
            snap.Transform:SetPosition(x1, y1, z1)
            snap.Transform:SetRotation(angle * RADIANS)
        end

        local tags_cant
        local validfn
        if TheNet:GetPVPEnabled() then
            tags_cant = TOOLS_L.TagsCombat3()
            validfn = TOOLS_L.MaybeEnemy_me
        else
            tags_cant = TOOLS_L.TagsCombat3({ "player" })
            validfn = TOOLS_L.MaybeEnemy_player
        end

        local dmg, spdmg, stimuli
        local ents = TheSim:FindEntities(x1, y1, z1, 6.5, { "_combat" }, tags_cant)
        for _, ent in ipairs(ents) do
            if ent ~= target and ent ~= owner and ent:IsValid() and ent.entity:IsVisible() then
                --为啥官方要这样写，难道是 owner 会因为那些受击者的反伤导致自身失效？
                if owner ~= nil and (not owner:IsValid() or owner.components.combat == nil) then
                    owner = nil
                end
                tags_cant = 3.5 + ent:GetPhysicsRadius(0)
                if
                    ent:GetDistanceSqToPoint(x1, y1, z1) < tags_cant * tags_cant --这里的距离算上了生物的体积半径
                    and validfn(owner, ent, true)
                then
                    --Tip：范围性伤害还是加个判断！防止打到不该打的对象
                    if owner ~= nil then
                        if owner.components.combat:IsValidTarget(ent) then
                            dmg, spdmg, stimuli = TOOLS_L.CalcDamage(owner, ent, inst, nil, nil, atk_orchid_area, nil, true)
                            ent.components.combat:GetAttacked(owner, dmg, inst, stimuli, spdmg)
                        end
                    elseif ent.components.combat:CanBeAttacked() then
                        ent.components.combat:GetAttacked(inst, atk_orchid_area, nil, nil, nil)
                    end
                end
            end
        end
    end
end

local function Fn_orchid()
    local inst = CreateEntity()

    Fn_common(inst, "orchitwigs", nil, nil, nil)

    inst:AddTag("sharp")
    inst:AddTag("pointy")
    inst:AddTag("show_spoilage")
    inst:AddTag("icebox_valid")
    inst:AddTag("weapon")

    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:InitWithFloater("orchitwigs")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.foliageath_data = foliageath_data_orchid

    Fn_server(inst, "orchitwigs", OnEquip_orchid, OnUnequip_base)
    SetWeapon(inst, TUNING.BASE_SURVIVOR_ATTACK*0.9, OnAttack_orchid)
    SetPerishable(inst, TUNING.TOTAL_DAY_TIME*8, nil)

    MakeHauntableLaunchAndPerish(inst)

    inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

--------------------------------------------------------------------------
--[[ 多变的云 ]]
--------------------------------------------------------------------------

local assets_bookweather = GetAssets("book_weather")
local prefabs_bookweather = {
    "waterballoon_splash", "fx_book_rain", "fx_book_rain_mount"
}

local function FixSymbol_bookweather(owner, data) --因为书籍的攻击贴图会因为读书而被替换，所以这里重新覆盖一次
    if data and data.statename == "attack" then
        -- owner.AnimState:OverrideSymbol("book_open", "book_weather", "book_open")
        owner.AnimState:OverrideSymbol("book_closed", "book_weather", "book_closed") --书籍攻击贴图在这里面
    end
end
local function OnEquip_bookweather(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object") --清除上一把武器的贴图效果，因为一般武器卸下时都不清除贴图
    owner.AnimState:OverrideSymbol("book_open", "book_weather", "book_open")
    owner.AnimState:OverrideSymbol("book_closed", "book_weather", "book_closed")
    -- owner.AnimState:OverrideSymbol("book_open_pages", "book_weather", "book_open_pages")

    if owner:HasTag("equipmentmodel") then --假人！
        return
    end

    TOOLS_L.AddTag(owner, "ignorewet", inst.prefab)
    inst:ListenForEvent("newstate", FixSymbol_bookweather, owner)
end
local function OnUnequip_bookweather(inst, owner)
    OnUnequip_base(inst, owner)

    --还原书的贴图
    owner.AnimState:OverrideSymbol("book_open", "player_actions_uniqueitem", "book_open")
    owner.AnimState:OverrideSymbol("book_closed", "player_actions_uniqueitem", "book_closed")
    -- owner.AnimState:OverrideSymbol("book_open_pages", "player_actions_uniqueitem", "book_open_pages")

    TOOLS_L.RemoveTag(owner, "ignorewet", inst.prefab)
    inst:RemoveEventCallback("newstate", FixSymbol_bookweather, owner)
end
local function OnAttack_bookweather(inst, owner, target)
    if target ~= nil and target:IsValid() then
        SpawnPrefab("waterballoon_splash").Transform:SetPosition(target.Transform:GetWorldPosition())
        inst.components.wateryprotection:SpreadProtection(target) --潮湿度组件增加潮湿

        if
            target.components.health ~= nil and not target.components.health:IsDead() and
            not target:HasTag("likewateroffducksback")
        then
            if target.components.inventoryitem ~= nil then --物品组件增加潮湿
                target.components.inventoryitem:AddMoisture(TUNING.OCEAN_WETNESS)
                return
            end

            if target.task_l_iswet == nil then
                if target:HasTag("wet") then
                    return
                end
                target:AddTag("wet") --标签方式增加潮湿
            else
                target.task_l_iswet:Cancel()
            end
            target.task_l_iswet = target:DoTaskInTime(15, function()
                target:RemoveTag("wet")
                target.task_l_iswet = nil
            end)
        end
    end
end
local function OnWateryProtection_bookweather(inst, x, y, z)
    inst.components.finiteuses:Use(1)
end
local function ConsumeUse_bookweather(self)
    self.inst.components.finiteuses:Use(20) --可以使用15次
end

local function OnRead_bookweather(inst, reader)
    -- if TheWorld.state.israining or TheWorld.state.issnowing then
    --     TheWorld:PushEvent("ms_forceprecipitation", false)
    -- else
    --     TheWorld:PushEvent("ms_forceprecipitation", true)
    -- end
    if TheWorld.state.precipitation ~= "none" then
        TheWorld:PushEvent("ms_forceprecipitation", false)
    else
        TheWorld:PushEvent("ms_forceprecipitation", true)
    end

    local x, y, z = reader.Transform:GetWorldPosition()
    local size = TILE_SCALE

    for i = x-size, x+size do
        for j = z-size, z+size do
            if TheWorld.Map:GetTileAtPoint(i, 0, j) == WORLD_TILES.FARMING_SOIL then
                TheWorld.components.farming_manager:AddSoilMoistureAtPoint(i, y, j, 100)
            end
        end
    end

    return true
end
local function OnPeruse_bookweather(inst, reader)
    if reader.prefab == "wurt" then
        if TheWorld.state.israining or TheWorld.state.issnowing then --雨雪天时，书中全是关于放晴的字眼，沃特不喜欢
            inst.components.book:SetPeruseSanity(-TUNING.SANITY_LARGE)
            reader.components.talker:Say(GetString(reader, "ANNOUNCE_READ_BOOK","BOOK_WEATHER_SUNNY"))
        else --晴天时，书中全是关于下雨的字眼，沃特好喜欢
            inst.components.book:SetPeruseSanity(TUNING.SANITY_LARGE)
            reader.components.talker:Say(GetString(reader, "ANNOUNCE_READ_BOOK","BOOK_WEATHER_RAINY"))
        end
    else
        if reader.peruse_weather ~= nil then
            reader.peruse_weather(reader)
        end
        if reader.components.talker ~= nil then
            reader.components.talker:Say(GetString(reader, "ANNOUNCE_READ_BOOK","BOOK_WEATHER"))
        end
    end

    return true
end

local function Fn_bookweather()
    local inst = CreateEntity()

    Fn_common(inst, "book_weather", nil, nil, nil)

    inst:AddTag("book") --加入book标签就能使攻击时使用人物的书本攻击的动画
    inst:AddTag("bookcabinet_item") --能放入书柜的标签
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", 0.1, 0.75)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.swap_build = "book_weather"
    inst.swap_prefix = "book"

    Fn_server(inst, "book_weather", OnEquip_bookweather, OnUnequip_bookweather)
    SetWeapon(inst, 50, OnAttack_bookweather)
    SetFiniteUses(inst, 300, nil)
    SetFuel(inst, nil)

    inst:AddComponent("wateryprotection")
    inst.components.wateryprotection.extinguishheatpercent = TUNING.WATERBALLOON_EXTINGUISH_HEAT_PERCENT
    inst.components.wateryprotection.temperaturereduction = TUNING.WATERBALLOON_TEMP_REDUCTION
    inst.components.wateryprotection.witherprotectiontime = TUNING.WATERBALLOON_PROTECTION_TIME
    inst.components.wateryprotection.addwetness = TUNING.WATERBALLOON_ADD_WETNESS
    inst.components.wateryprotection.onspreadprotectionfn = OnWateryProtection_bookweather
    if TheNet:GetPVPEnabled() then
        inst.components.wateryprotection:AddIgnoreTag("ignorewet")  --PVP，防止使用者被打湿
    else
        inst.components.wateryprotection:AddIgnoreTag("player")  --PVE，防止所有玩家被打湿
    end

    inst:AddComponent("book")
    inst.components.book:SetOnRead(OnRead_bookweather)
    inst.components.book:SetOnPeruse(OnPeruse_bookweather)
    inst.components.book:SetReadSanity(-TUNING.SANITY_LARGE) --读书的精神消耗
    -- inst.components.book:SetPeruseSanity() --阅读的精神消耗/增益
    inst.components.book:SetFx("fx_book_rain", "fx_book_rain_mount")
    inst.components.book.ConsumeUse = ConsumeUse_bookweather

    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunch(inst)

    return inst
end

--------------------------------------------------------------------------
--[[ 幻象法杖 ]]
--------------------------------------------------------------------------

local assets_staffpink = GetAssets("pinkstaff", { Asset("ANIM", "anim/swap_pinkstaff.zip") })

local function OnFinished_staffpink(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
    inst:Remove()
end
local function OnEquip_staffpink(inst, owner)
    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil then
        if skindata.equip ~= nil then
            owner.AnimState:OverrideSymbol("swap_object", skindata.equip.build, skindata.equip.file)
        else
            owner.AnimState:OverrideSymbol("swap_object", "swap_pinkstaff", "swap_pinkstaff")
        end
        if skindata.equipfx ~= nil then
            skindata.equipfx.start(inst, owner)
        end
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_pinkstaff", "swap_pinkstaff")
    end
    OnEquip_base(inst, owner)
end
local function OnUnequip_staffpink(inst, owner)
    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.equipfx ~= nil then
        skindata.equipfx.stop(inst, owner)
    end
    OnUnequip_base(inst, owner)
end
local function DressUpItem(staff, target)
    local caster = staff.components.inventoryitem.owner
    if caster ~= nil and caster.components.dressup ~= nil then
        if target == nil then --解除幻化（右键装备栏的法杖）
            caster.components.dressup:TakeOffAll()
        elseif target == caster then --解除幻化（右键玩家自己）
            caster.components.dressup:TakeOffAll()
        else                  --添加幻化
            local didit = caster.components.dressup:PutOn(target)
            if didit then
                caster.SoundEmitter:PlaySound("dontstarve/common/staff_dissassemble")
                if caster.components.sanity ~= nil then
                    caster.components.sanity:DoDelta(-10)
                end
                staff.components.finiteuses:Use(1)
            end
        end
    end
end
local function DressUpTest(doer, target, pos)
    if target == nil then --解除幻化，也是可以生效的
        return true
    elseif target == doer then --对自己施法：解除幻化
        return true
    elseif DRESSUP_DATA_LEGION[target.prefab] ~= nil then
        return true
    end
    return false
end

local function Fn_staffpink()
    local inst = CreateEntity()
    inst.entity:AddSoundEmitter()

    Fn_common(inst, "pinkstaff", nil, "anim", nil)

    inst:AddTag("nopunch") --这个标签的作用应该是让本身没有武器组件的道具用武器攻击的动作，而不是用拳头攻击的动作

    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:InitWithFloater("pinkstaff")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.fxcolour = { 255/255, 80/255, 173/255 }

    Fn_server(inst, "pinkstaff", OnEquip_staffpink, OnUnequip_staffpink)
    SetFiniteUses(inst, 30, OnFinished_staffpink)

    inst:AddComponent("spellcaster")
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canusefrominventory = true
    inst.components.spellcaster:SetSpellFn(DressUpItem)
    inst.components.spellcaster:SetCanCastFn(DressUpTest)

    MakeHauntableLaunch(inst)

    inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

--------------------------------------------------------------------------
--[[ 芬布尔斧 ]]
--------------------------------------------------------------------------

local assets_fimbulaxe = GetAssets("fimbul_axe", { Asset("ANIM", "anim/boomerang.zip") }) --官方回旋镖动画模板
local prefabs_fimbulaxe = {
    "fimbul_lightning",
    "fimbul_cracklebase_fx"
}
local atk_fimbulaxe = TUNING.BASE_SURVIVOR_ATTACK*0.4 --13.6

local function OnFinished_fimbulaxe(inst)
    inst.AnimState:PlayAnimation("used")
    inst:ListenForEvent("animover", inst.Remove)

    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.fn_onThrownEnd ~= nil then
        skindata.fn_onThrownEnd(inst)
    end

    if inst.returntask ~= nil then
        inst.returntask:Cancel()
        inst.returntask = nil
    end
end
local function OnEquip_fimbulaxe(inst, owner)
    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.equip ~= nil then
        owner.AnimState:OverrideSymbol("swap_object", skindata.equip.build, skindata.equip.file)
    else
        owner.AnimState:OverrideSymbol("swap_object", "fimbul_axe", "swap_base")
    end
    OnEquip_base(inst, owner)
end
local function OnDropped_fimbulaxe(inst)
    inst.AnimState:PlayAnimation("idle")
    inst.components.inventoryitem.pushlandedevents = true
    inst.components.inventoryitem.canbepickedup = true
    inst:PushEvent("on_landed")

    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.fn_onThrownEnd ~= nil then
        skindata.fn_onThrownEnd(inst)
    end
end
local function OnThrown_fimbulaxe(inst, owner, target)
    if owner and owner.SoundEmitter ~= nil then
        owner.SoundEmitter:PlaySound("dontstarve/wilson/boomerang_throw")
    end
    inst.AnimState:PlayAnimation("spin_loop", true)
    inst.components.inventoryitem.pushlandedevents = false
    inst.components.inventoryitem.canbepickedup = false

    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.fn_onThrown ~= nil then
        skindata.fn_onThrown(inst, owner, target)
    end
end
local function ReturnToOwner_fimbulaxe(inst, owner)
    OnDropped_fimbulaxe(inst)
    if owner ~= nil and owner:IsValid() then
        -- owner.SoundEmitter:PlaySound("dontstarve/wilson/boomerang_return")
        -- inst.components.projectile:Throw(owner, owner)

        if not (owner.components.health ~= nil and owner.components.health:IsDead()) then --玩家还活着，自动接住
            --如果使用者已装备手持武器，就放进物品栏，没有的话就直接装备上
            if not owner.components.inventory:GetEquippedItem(inst.components.equippable.equipslot) then
                owner.components.inventory:Equip(inst)
            else
                owner.components.inventory:GiveItem(inst)
            end
        end
    end
end
local function GiveSomeShock(inst, owner, target, doshock, hittarget) --击中时的特殊效果
    local givelightning = false
    local tags_cant
    local tags_one
    local validfn
    if TheNet:GetPVPEnabled() then
        tags_cant = TOOLS_L.TagsCombat3({ "lightningblocker" }) --排除了水中木
        validfn = TOOLS_L.MaybeEnemy_me
    else
        tags_cant = TOOLS_L.TagsCombat3({ "lightningblocker", "player" })
        validfn = TOOLS_L.MaybeEnemy_player
    end
    if doshock then
        tags_one = { "_combat", "shockable", "CHOP_workable" }
    else
        tags_one = { "_combat", "CHOP_workable" }
    end

    local x, y, z
    if target ~= nil and target:IsValid() then
        x, y, z = target.Transform:GetWorldPosition()
    else
        target = nil
        x, y, z = inst.Transform:GetWorldPosition()
    end
    if owner ~= nil and not owner:IsValid() then
        owner = nil
    end

    local dmg, spdmg, stimuli
    local ents = TheSim:FindEntities(x, y, z, 6.5, nil, tags_cant, tags_one)
    for _, v in ipairs(ents) do
        if v ~= owner and v:IsValid() and v.entity:IsVisible() then
            if v.components.workable ~= nil then --直接破坏可以砍的物体
                if v.components.workable:CanBeWorked() and v.components.lightningblocker == nil then
                    v.components.workable:Destroy(inst)
                end
            elseif (hittarget or v ~= target) or doshock then
                --为啥官方要这样写，难道是 owner 会因为那些受击者的反伤导致自身失效？
                if owner ~= nil and (not owner:IsValid() or owner.components.combat == nil) then
                    owner = nil
                end
                tags_cant = 3.5 + v:GetPhysicsRadius(0)
                if
                    v:GetDistanceSqToPoint(x, y, z) < tags_cant * tags_cant --这里的距离算上了生物的体积半径
                    and validfn(owner, v, true)
                then
                    if (hittarget or v ~= target) and v.components.combat:CanBeAttacked(owner) then
                        if owner ~= nil then
                            dmg, spdmg, stimuli = TOOLS_L.CalcDamage(owner, v, inst, inst, nil, nil, nil, true)
                            v.components.combat:GetAttacked(owner, dmg, inst, stimuli, spdmg)
                        else
                            v.components.combat:GetAttacked(inst, atk_fimbulaxe, nil, "electric", nil)
                        end
                    end
                    if doshock and v.components.shockable ~= nil and math.random() < 0.3 then
                        givelightning = true
                        v.components.shockable:Shock(6)
                    end
                end
            end
        end
    end

    if givelightning then
        local skindata = inst.components.skinedlegion:GetSkinedData()
        if skindata ~= nil and skindata.fn_onLightning ~= nil then
            skindata.fn_onLightning(inst, owner, target)
            return
        end

        if not TheWorld:HasTag("cave") then
            local lightning = SpawnPrefab("fimbul_lightning")
            lightning.Transform:SetPosition(x, y, z)
        end
        local cracklebase = SpawnPrefab("fimbul_cracklebase_fx")
        cracklebase.Transform:SetPosition(x, y, z)
    end
end
local function DelayReturnToOwner(inst, owner, target)
    inst.returntask = inst:DoTaskInTime(0.6, function(inst)
        inst.returntask = inst:DoTaskInTime(0.4, function(inst)
            ReturnToOwner_fimbulaxe(inst, owner)
            inst.returntask = nil
        end)
        GiveSomeShock(inst, owner, target, false, true)
    end)
end
local function OnPreHit_fimbulaxe(inst, owner, target) --击中前
    GiveSomeShock(inst, owner, target, true, false)
end
local function OnHit_fimbulaxe(inst, owner, target) --击中后
    if inst:IsValid() and inst.components.finiteuses:GetUses() > 0 then --耐久可能是用完了
        DelayReturnToOwner(inst, owner, target)
    end
end
local function OnMiss_fimbulaxe(inst, owner, target)
    if owner == target then
        ReturnToOwner_fimbulaxe(inst, owner)
    else
        DelayReturnToOwner(inst, owner, target)
    end
end
local function OnLightning_fimbulaxe(inst) --因为拿在手上会有"INLIMBO"标签，所以装备时并不会吸引闪电，只有放在地上时才会
    GiveSomeShock(inst, nil, nil, true, true)
    if inst.components.finiteuses:GetPercent() < 1 then
        inst.components.finiteuses:Repair(10)
    end
end

local function Fn_fimbulaxe()
    local inst = CreateEntity()

    Fn_common(inst, "boomerang", "fimbul_axe", nil, nil)
    RemovePhysicsColliders(inst)
    inst.AnimState:SetRayTestOnBB(true)

    inst:AddTag("thrown")
    inst:AddTag("lightningrod") --避雷针标签，会吸引闪电
    inst:AddTag("weapon")
    inst:AddTag("projectile")

    -- MakeInventoryFloatable(inst, "med", 0.1, {1.3, 0.6, 1.3}, true, -9, {
    --     sym_build = "swap_fimbul_axe",
    --     sym_name = "swap_fimbul_axe",
    --     bank = "fimbul_axe",
    --     anim = "idle"
    -- })
    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:InitWithFloater("fimbul_axe")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    -- inst.returntask = nil

    Fn_server(inst, "fimbul_axe", OnEquip_fimbulaxe, OnUnequip_base)
    inst.components.inventoryitem:SetOnDroppedFn(OnDropped_fimbulaxe)

    SetWeapon(inst, atk_fimbulaxe, nil)
    inst.components.weapon:SetRange(TUNING.BOOMERANG_DISTANCE, TUNING.BOOMERANG_DISTANCE + 2)
    inst.components.weapon:SetElectric() --设置为带电的武器，带电武器自带攻击加成

    SetFiniteUses(inst, 250, OnFinished_fimbulaxe)

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(15)
    --inst.components.projectile:SetCanCatch(true)      --默认，不能被主动抓住
    inst.components.projectile:SetOnThrownFn(OnThrown_fimbulaxe)  --扔出时
    inst.components.projectile:SetOnPreHitFn(OnPreHit_fimbulaxe)  --敌方或者自己被击中前
    inst.components.projectile:SetOnHitFn(OnHit_fimbulaxe)        --敌方或者自己被击中后
    inst.components.projectile:SetOnMissFn(OnMiss_fimbulaxe)      --丢失目标时
    --inst.components.projectile:SetOnCaughtFn(OnCaught)--被抓住时

    inst:ListenForEvent("lightningstrike", OnLightning_fimbulaxe)

    MakeHauntableLaunch(inst)

    inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

--------------------------------------------------------------------------
--[[ 扳手-双用型 ]]
--------------------------------------------------------------------------

local assets_2wrench = GetAssets("dualwrench", { Asset("ANIM", "anim/swap_dualwrench.zip") })

local function OnEquip_2wrench(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_dualwrench", "swap_dualwrench")
    OnEquip_base(inst, owner)
end

local function Fn_2wrench()
    local inst = CreateEntity()
    inst.entity:AddSoundEmitter()

    Fn_common(inst, "dualwrench", nil, nil, nil)

    inst:AddTag("hammer")
    inst:AddTag("weapon")
    inst:AddTag("tool")

    MakeInventoryFloatable(inst, "med", 0.1, {1.1, 0.5, 1.1}, true, -9, {
        sym_build = "swap_dualwrench",
        sym_name = "swap_dualwrench",
        bank = "dualwrench",
        anim = "idle"
    })

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    Fn_server(inst, "dualwrench", OnEquip_2wrench, OnUnequip_base)
    SetWeapon(inst, TUNING.HAMMER_DAMAGE, nil)

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.HAMMER) --添加锤子功能

    --添加草叉功能
    inst:AddInherentAction(ACTIONS.TERRAFORM)
    inst:AddComponent("terraformer")
    inst:AddComponent("carpetpullerlegion")

    SetFiniteUses(inst, TUNING.HAMMER_USES, nil) --总共75次，可攻击75次
    --设置每种功能的消耗量
    inst.components.finiteuses:SetConsumption(ACTIONS.HAMMER, 0.3) --可以使用75/0.3=250次
    inst.components.finiteuses:SetConsumption(ACTIONS.TERRAFORM, 0.3)

    MakeHauntableLaunch(inst)

    return inst
end

--------------------------------------------------------------------------
--[[ 斧铲-三用型 ]]
--------------------------------------------------------------------------

local assets_3axe = GetAssets("tripleshovelaxe")

local function OnEquip_3axe(inst, owner)
    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.equip ~= nil then
        owner.AnimState:OverrideSymbol("swap_object", skindata.equip.build, skindata.equip.file)
    else
        owner.AnimState:OverrideSymbol("swap_object", "tripleshovelaxe", "swap")
    end
    OnEquip_base(inst, owner)
end

local function Fn_3axe()
    local inst = CreateEntity()
    inst.entity:AddSoundEmitter()

    Fn_common(inst, "tripleshovelaxe", nil, nil, nil)

    inst:AddTag("sharp")
    inst:AddTag("tool")
    inst:AddTag("weapon")

    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:InitWithFloater("tripleshovelaxe")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    Fn_server(inst, "tripleshovelaxe", OnEquip_3axe, OnUnequip_base)
    SetWeapon(inst, TUNING.AXE_DAMAGE, nil)

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 1)
    inst.components.tool:SetAction(ACTIONS.MINE, 1)
    inst.components.tool:SetAction(ACTIONS.DIG,  1)

    SetFiniteUses(inst, 108, nil) --总共108次，可攻击108次
    --设置每种功能的消耗量
    inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 0.6) --可以使用108/0.6=180次
    inst.components.finiteuses:SetConsumption(ACTIONS.MINE, 0.6)
    inst.components.finiteuses:SetConsumption(ACTIONS.DIG,  0.6)

    MakeHauntableLaunch(inst)

    inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

--------------------------------------------------------------------------
--[[ 斧铲-黄金三用型 ]]
--------------------------------------------------------------------------

local assets_3axegold = GetAssets("triplegoldenshovelaxe")

local function OnEquip_3axegold(inst, owner)
    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.equip ~= nil then
        owner.AnimState:OverrideSymbol("swap_object", skindata.equip.build, skindata.equip.file)
    else
        owner.AnimState:OverrideSymbol("swap_object", "triplegoldenshovelaxe", "swap")
    end
    OnEquip_base(inst, owner)
end

local function Fn_3axegold()
    local inst = CreateEntity()
    inst.entity:AddSoundEmitter()

    Fn_common(inst, "triplegoldenshovelaxe", nil, nil, nil)

    inst:AddTag("sharp")
    inst:AddTag("tool")
    inst:AddTag("weapon")

    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:InitWithFloater("triplegoldenshovelaxe")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    Fn_server(inst, "triplegoldenshovelaxe", OnEquip_3axegold, OnUnequip_base)
    SetWeapon(inst, TUNING.AXE_DAMAGE, nil)

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 1.25)
    inst.components.tool:SetAction(ACTIONS.MINE, 1.25)
    inst.components.tool:SetAction(ACTIONS.DIG,  1.25)
    inst.components.tool:EnableToughWork(true) --可以开凿更坚硬的对象

    SetFiniteUses(inst, 180, nil)
    --设置每种功能的消耗量
    inst.components.finiteuses:SetConsumption(ACTIONS.CHOP, 0.1) --可以使用180/0.1=1800次
    inst.components.finiteuses:SetConsumption(ACTIONS.MINE, 0.1)
    inst.components.finiteuses:SetConsumption(ACTIONS.DIG,  0.1)
    inst.components.weapon.attackwear = 0.1

    MakeHauntableLaunch(inst)

    inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

--------------------------------------------------------------------------
--[[ 胡萝卜长枪 ]]
--------------------------------------------------------------------------

local assets_carl = GetAssets("lance_carrot_l")
local atk_min_carl = 10

local function UpdateCarrot(inst, force)
	local num = 0
	local num2 = 0
	for k,v in pairs(inst.components.container.slots) do
		if v then
			if v.prefab == "carrot" or v.prefab == "carrot_cooked" then
				if v.components.stackable ~= nil then
					num = num + v.components.stackable:StackSize()
				else
					num = num + 1
				end
			elseif v.prefab == "carrat" then
				num2 = num2 + 1
			end
		end
	end

	if not force and inst.num_carrot_l == num and inst.num_carrat_l == num2 then --防止一直计算
		return
	end

	inst.num_carrot_l = num
	inst.num_carrat_l = num2
    if num2 == 1 then --防止用加堆叠上限的mod来做骚操作
        if num > 40 then
            num = 40
        end
    elseif num2 == 0 then
        if num > 80 then
            num = 80
        end
    else
        num2 = 2
        num = 0
    end
    inst.components.weapon:SetDamage(atk_min_carl + num*0.85) --0.85=68/80
    num = 0.0275*num --0.0275=2.2/80
    if num2 > 0 then
        inst.components.planardamage:SetBaseDamage(num2*34)
        inst.components.damagetypebonus:AddBonus("shadow_aligned", inst, 1+( 0.05*num2 ), "carrat")
        num = num + 1.1*num2
    else
        inst.components.planardamage:SetBaseDamage(0)
        inst.components.damagetypebonus:RemoveBonus("shadow_aligned", inst, "carrat")
    end
	num = math.floor(num*10) / 10 --这一些操作是为了仅保留小数点后1位
	inst.components.weapon:SetRange(num)
end
local function OnOwnerItemChange_carl(owner, data)
	local hands = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	if hands ~= nil and hands.prefab == "lance_carrot_l" then
		if hands.task_carrot_l ~= nil then
			hands.task_carrot_l:Cancel()
		end
		hands.task_carrot_l = hands:DoTaskInTime(0, function(hands)
			if hands.components.container ~= nil then
				UpdateCarrot(hands)
			end
			hands.task_carrot_l = nil
		end)
	end
end
local function OnEquip_carl(inst, owner)
    -- local skindata = inst.components.skinedlegion:GetSkinedData()
    -- if skindata ~= nil and skindata.equip ~= nil then
    --     owner.AnimState:OverrideSymbol("swap_object", skindata.equip.build, skindata.equip.file)
    -- else
        owner.AnimState:OverrideSymbol("swap_object", "lance_carrot_l", "swap_object")
    -- end

    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

	if owner:HasTag("equipmentmodel") then --假人！
        return
    end

	if inst.components.container ~= nil then
        inst.components.container:Open(owner)

		inst:ListenForEvent("gotnewitem", OnOwnerItemChange_carl, owner)
		inst:ListenForEvent("itemget", OnOwnerItemChange_carl, owner)
		inst:ListenForEvent("itemlose", OnOwnerItemChange_carl, owner)
		UpdateCarrot(inst, true)
    end
end
local function OnUnequip_carl(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

	if owner:HasTag("equipmentmodel") then --假人！
        return
    end

	if inst.components.container ~= nil then
        inst.components.container:Close()
    end
	inst:RemoveEventCallback("gotnewitem", OnOwnerItemChange_carl, owner)
	inst:RemoveEventCallback("itemget", OnOwnerItemChange_carl, owner)
	inst:RemoveEventCallback("itemlose", OnOwnerItemChange_carl, owner)
end
local function OnFinished_carl(inst)
	if inst.components.container ~= nil then
		inst.components.container:DropEverything()
	end
	inst:Remove()
end
local function OnEntityReplicated_carl(inst)
    if inst.replica.container ~= nil then
        inst.replica.container:WidgetSetup("lance_carrot_l")
    end
end

local function Fn_carl()
    local inst = CreateEntity()

    Fn_common(inst, "lance_carrot_l", nil, nil, nil)

    inst:AddTag("jab") --使用捅击的动作进行攻击
    inst:AddTag("rp_carrot_l")
    inst:AddTag("weapon")

    -- inst:AddComponent("skinedlegion")
    -- inst.components.skinedlegion:InitWithFloater("lance_carrot_l")

    MakeInventoryFloatable(inst, "small", 0.4, 0.5)
    local OnLandedClient_old = inst.components.floater.OnLandedClient
    inst.components.floater.OnLandedClient = function(self)
        OnLandedClient_old(self)
        self.inst.AnimState:SetFloatParams(0.15, 1, self.bob_percent)
    end

    TOOLS_L.SetImmortalBox_common(inst)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = OnEntityReplicated_carl
        return inst
    end

    inst.num_carrot_l = 0
    inst.num_carrat_l = 0

    Fn_server(inst, "lance_carrot_l", OnEquip_carl, OnUnequip_carl)
    SetWeapon(inst, atk_min_carl, nil)
    -- inst.components.weapon:SetRange(-1, -1) --人物默认攻击距离为3、3
    SetFiniteUses(inst, 200, OnFinished_carl)

    inst:AddComponent("planardamage")
    inst.components.planardamage:SetBaseDamage(0)

    inst:AddComponent("damagetypebonus")

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("lance_carrot_l")
    inst.components.container.canbeopened = false

    inst:AddComponent("preserver")
    inst.components.preserver:SetPerishRateMultiplier(0.3)

    MakeHauntableLaunch(inst)

    -- inst.components.skinedlegion:SetOnPreLoad()

    TOOLS_L.SetImmortalBox_server(inst)

    return inst
end

-------------------------

local prefs = {
    Prefab("neverfade", Fn_never, assets_never, prefabs_never),
    Prefab("rosorns", Fn_rose, assets_rose),
    Prefab("lileaves", Fn_lily, assets_lily),
    Prefab("orchitwigs", Fn_orchid, assets_orchid, prefabs_orchid),
    Prefab("book_weather", Fn_bookweather, assets_bookweather, prefabs_bookweather),
    Prefab("fimbul_axe", Fn_fimbulaxe, assets_fimbulaxe, prefabs_fimbulaxe),
    Prefab("dualwrench", Fn_2wrench, assets_2wrench),
    Prefab("tripleshovelaxe", Fn_3axe, assets_3axe),
    Prefab("triplegoldenshovelaxe", Fn_3axegold, assets_3axegold),
    Prefab("lance_carrot_l", Fn_carl, assets_carl)
}
if CONFIGS_LEGION.DRESSUP then
    table.insert(prefs, Prefab("pinkstaff", Fn_staffpink, assets_staffpink))
end

return unpack(prefs)
