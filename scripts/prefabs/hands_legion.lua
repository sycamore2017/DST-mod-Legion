local TOOLS_L = require("tools_legion")

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
    owner.AnimState:Show("ARM_carry") --显示持物手
    owner.AnimState:Hide("ARM_normal") --隐藏普通的手

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
    owner.AnimState:Hide("ARM_carry") --隐藏持物手
    owner.AnimState:Show("ARM_normal") --显示普通的手

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
local function OnRecovered_never(inst, dt, player) --每次被剑鞘恢复时执行的函数
    if inst.components.finiteuses:GetPercent() >= 1 then
        return
    end

    local value = dt * uses_never/(TUNING.TOTAL_DAY_TIME*3) --后面一截是每秒该恢复多少耐久
    if value >= 1 then
        value = math.floor(value)
    else
        return
    end

    local newvalue = inst.components.finiteuses:GetUses() + value
    inst.components.finiteuses:SetUses(math.min(uses_never, newvalue))
    if inst.hassetbroken then
        inst.hassetbroken = false
        inst:RemoveTag("broken")
        inst.components.weapon:SetDamage(55)
        inst.components.weapon:SetOnAttack(OnAttack_never)
        ChangeInvImg_never(inst, inst.components.skinedlegion:GetSkinedData())
    end
end

local keykey = "state_l_fade"
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

local function Fn_never()
    local inst = CreateEntity()

    inst.entity:AddTransform() --添加坐标系机制
    inst.entity:AddAnimState() --添加动画机制
    inst.entity:AddNetwork() --添加网络机制

    MakeInventoryPhysics(inst) --设置物理机制

    inst.AnimState:SetBank("neverfade")--动画的bank：骨架+运动轨迹
    inst.AnimState:SetBuild("neverfade")--动画的build：贴图+贴图通道
    inst.AnimState:PlayAnimation("idle")--播放的动画

    inst:AddTag("sharp") --该标签跟攻击音效有关
    inst:AddTag("pointy") --该标签跟攻击音效有关
    -- inst:AddTag("hide_percentage") --该标签能让耐久比例不显示出来
    inst:AddTag("deployedplant") --deployable组件 需要的标签
    inst:AddTag("show_broken_ui") --装备损坏后展示特殊物品栏ui

    --weapon (from weapon component) added to pristine state for optimization
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
    inst.OnScabbardRecoveredFn = OnRecovered_never

    inst:AddComponent("inventoryitem") --物品栏物品组件，有了这个组件，你才能把这个物品捡起放到物品栏里
    inst.components.inventoryitem.imagename = "neverfade"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/neverfade.xml"

    inst:AddComponent("inspectable") --可检查组件

    inst:AddComponent("equippable") --可装备组件，有了这个组件，它才能被装备 
    inst.components.equippable:SetOnEquip(OnEquip_never)
    inst.components.equippable:SetOnUnequip(OnUnequip_never)
    -- inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED --高礼帽般的回复精神效果

    inst:AddComponent("weapon") --武器组件，能设置攻击力
    inst.components.weapon:SetDamage(55)
    inst.components.weapon:SetOnAttack(OnAttack_never)

    inst:AddComponent("finiteuses") --耐久次数组件
    inst.components.finiteuses:SetMaxUses(uses_never)
    inst.components.finiteuses:SetUses(uses_never)
    inst.components.finiteuses:SetOnFinished(OnFinished_never)

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

local assets_rose = {
    Asset("ANIM", "anim/rosorns.zip"),
    Asset("ANIM", "anim/swap_rosorns.zip"),
    Asset("ATLAS", "images/inventoryimages/rosorns.xml"),
    Asset("IMAGE", "images/inventoryimages/rosorns.tex")
}

local function OnEquip_rose(inst, owner)
    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.equip ~= nil then
        owner.AnimState:OverrideSymbol("swap_object", skindata.equip.build, skindata.equip.file)
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_rosorns", "swap_rosorns")
    end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if owner:HasTag("equipmentmodel") then --假人！
        return
    end

    --TIP: "onattackother"事件在 targ.components.combat:GetAttacked 之前，所以能提前改攻击配置
    owner:ListenForEvent("onattackother", TOOLS_L.UndefendedATK)
end
local function OnUnequip_rose(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
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

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("rosorns")
    inst.AnimState:SetBuild("rosorns")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")
    inst:AddTag("show_spoilage") --显示新鲜度
    inst:AddTag("icebox_valid") --能装进冰箱

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:InitWithFloater("rosorns")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "rosorns"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/rosorns.xml"

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip_rose)
    inst.components.equippable:SetOnUnequip(OnUnequip_rose)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(51)
    inst.components.weapon:SetOnAttack(OnAttack_rose)

    inst:AddComponent("perishable") --新鲜度组件
    inst.components.perishable:SetPerishTime(TUNING.TOTAL_DAY_TIME*8)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)

    inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

--------------------------------------------------------------------------
--[[ 蹄莲翠叶 ]]
--------------------------------------------------------------------------

local assets_lily = {
    Asset("ANIM", "anim/lileaves.zip"),
    Asset("ANIM", "anim/swap_lileaves.zip"),
    Asset("ATLAS", "images/inventoryimages/lileaves.xml"),
    Asset("IMAGE", "images/inventoryimages/lileaves.tex")
}

local function OnEquip_lily(inst, owner)
    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.equip ~= nil then
        owner.AnimState:OverrideSymbol("swap_object", skindata.equip.build, skindata.equip.file)
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_lileaves", "swap_lileaves")
    end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end
local function OnUnequip_lily(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end
local function OnAttack_lily(inst, owner, target)
    if
        target ~= nil and target:IsValid() and
        (target.components.health == nil or not target.components.health:IsDead())
    then
        target.time_l_attackreduce = { replace_min = TUNING.SEG_TIME*2 }
        target:AddDebuff("buff_attackreduce", "buff_attackreduce")
    end
end

local function Fn_lily()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("lileaves")
    inst.AnimState:SetBuild("lileaves")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")
    inst:AddTag("show_spoilage")
    inst:AddTag("icebox_valid")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:InitWithFloater("lileaves")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "lileaves"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/lileaves.xml"

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip_lily)
    inst.components.equippable:SetOnUnequip(OnUnequip_lily)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(51)
    inst.components.weapon:SetOnAttack(OnAttack_lily)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.TOTAL_DAY_TIME*8)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)

    inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

--------------------------------------------------------------------------
--[[ 兰草花穗 ]]
--------------------------------------------------------------------------

local assets_orchid = {
    Asset("ANIM", "anim/orchitwigs.zip"),
    Asset("ANIM", "anim/swap_orchitwigs.zip"),
    Asset("ATLAS", "images/inventoryimages/orchitwigs.xml"),
    Asset("IMAGE", "images/inventoryimages/orchitwigs.tex")
}
local prefabs_orchid = {
    "impact_orchid_fx"
}
local atk_orchid_area = TUNING.BASE_SURVIVOR_ATTACK*0.7

local function OnEquip_orchid(inst, owner)
    local skindata = inst.components.skinedlegion:GetSkinedData()
    if skindata ~= nil and skindata.equip ~= nil then
        owner.AnimState:OverrideSymbol("swap_object", skindata.equip.build, skindata.equip.file)
    else
        owner.AnimState:OverrideSymbol("swap_object", "swap_orchitwigs", "swap_orchitwigs")
    end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end
local function OnUnequip_orchid(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
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
        local ents = TheSim:FindEntities(x1, y1, z1, 3, { "_combat" }, tags_cant)
        for _, ent in ipairs(ents) do
            if
                ent ~= target and ent ~= owner and
                ent.entity:IsVisible() and
                owner.components.combat:IsValidTarget(ent) and --Tip：范围性伤害还是加个判断！防止打到不该打的对象
                validfn(owner, ent, true)
            then
                dmg, spdmg, stimuli = TOOLS_L.CalcDamage(owner, ent, inst, nil, nil, atk_orchid_area, nil, true)
                ent.components.combat:GetAttacked(owner, dmg, inst, stimuli, spdmg)
            end
        end
    end
end

local function Fn_orchid()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("orchitwigs")
    inst.AnimState:SetBuild("orchitwigs")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")
    inst:AddTag("show_spoilage")
    inst:AddTag("icebox_valid")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:InitWithFloater("orchitwigs")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "orchitwigs"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/orchitwigs.xml"

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(OnEquip_orchid)
    inst.components.equippable:SetOnUnequip(OnUnequip_orchid)

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.BASE_SURVIVOR_ATTACK*0.9)
    inst.components.weapon:SetOnAttack(OnAttack_orchid)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.TOTAL_DAY_TIME*8)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    MakeHauntableLaunchAndPerish(inst)

    inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

return Prefab("neverfade", Fn_never, assets_never, prefabs_never),
        Prefab("rosorns", Fn_rose, assets_rose),
        Prefab("lileaves", Fn_lily, assets_lily),
        Prefab("orchitwigs", Fn_orchid, assets_orchid, prefabs_orchid)
