local prefs = {}
local birdbrain = require("brains/siving_phoenixbrain")

--------------------------------------------------------------------------
--[[ 通用 ]]
--------------------------------------------------------------------------

local LineMap = {
    silk = 2,
    steelwool = 20,
    cattenball = 15
}

local BossSounds = {
    step = "dontstarve_DLC001/creatures/buzzard/hurt",
    death = "dontstarve_DLC001/creatures/buzzard/death",
    flyaway = "dontstarve_DLC001/creatures/buzzard/flyout",
    flap = "dontstarve_DLC001/creatures/buzzard/flap",
    atk = "dontstarve_DLC001/creatures/buzzard/attack",
    taunt = "dontstarve_DLC001/creatures/buzzard/taunt",
    caw = "dontstarve_DLC001/creatures/buzzard/squack",
    hurt = "dontstarve_DLC001/creatures/buzzard/hurt"
}

local DIST_MATE = 9 --离伴侣的最远距离
local DIST_REMOTE = 25 --最大活动范围
local DIST_ATK = 3.5 --普通攻击范围
local DIST_SPAWN = DIST_REMOTE + DIST_ATK --距离神木的最大距离
local DIST_FLAP = 7 --羽乱舞射程
local DIST_FEA_EXPLODE = 2.5 --精致子圭翎羽的爆炸半径
local DIST_ROOT_ATK = 1.5 --子圭突触的攻击半径

local TIME_BUFF_WARBLE = 6 --魔音绕耳debuff 持续时间
local TIME_FLAP = 40 --羽乱舞 冷却时间
local TIME_FEA_EXPLODE = 30 --精致子圭翎羽爆炸时间
local TIME_TAUNT = 50 --魔音绕梁 冷却时间 50
local TIME_CAW = 50 --花寄语 冷却时间 50

local ATK_NORMAL = 20 --啄击攻击力
local ATK_GRIEF = 10 --悲愤状态额外攻击力
local ATK_FEA = 50 --子圭翎羽攻击力
local ATK_FEA_REAL = 80 --精致子圭翎羽攻击力
local ATK_FEA_EXPLODE = 100 --精致子圭翎羽的爆炸伤害
local ATK_ROOT = 100 --子圭突触攻击力

local COUNT_FLAP = 3 --羽乱舞次数
local COUNT_FLAP_GRIEF = 4 --羽乱舞次数（悲愤状态）

local TAGS_CANT = { "NOCLICK", "shadow", "playerghost", "ghost",
                    "INLIMBO", "wall", "structure", "balloon", "siving", "boat" }

local function IsValid(one)
    return one:IsValid() and
        one.components.health ~= nil and not one.components.health:IsDead()
end
local function CheckMate(inst)
    if inst.mate ~= nil then
        if not IsValid(inst.mate) then
            inst.mate = nil
        end
    end
end
local function GetDamage(inst, target, basedamage)
    if inst.isgrief then
        basedamage = basedamage + ATK_GRIEF
    end
    if target:HasTag("player") then
        return basedamage
    else
        return basedamage*3
    end
end
local function GetDamage2(target, basedamage)
    if target:HasTag("player") then
        return basedamage
    else
        return basedamage*3
    end
end
local function DoDefenselessATK(inst, target, basedamage)
    target.components.combat:GetAttacked(inst, 1, nil, nil) --为了进行一遍被攻击后的逻辑(这里能触发盾反)
    if
        target.components.health == nil or target.components.health:IsDead() or
        target.shield_l_success --盾反成功
    then
        return
    end
    target.components.health:DoDelta(
        -GetDamage(inst, target, basedamage), nil, (inst.nameoverride or inst.prefab), false, inst, true)
end
local function SpawnFlower(inst, target)
    local flower = SpawnPrefab("siving_boss_flowerfx")
    if flower ~= nil then
        flower.Transform:SetPosition(target.Transform:GetWorldPosition())
        flower:fn_onBind(inst, target)
    end
end
local function SpawnRoot(bird, x, z, delaytime)
    if TheWorld.Map:IsAboveGroundAtPoint(x, 0, z) then
        local root = SpawnPrefab("siving_boss_root")
        if root ~= nil then
            root.Transform:SetPosition(x, 0, z)
            root.OnTreeLive(root, bird.tree and bird.tree.treeState or 0)
            root.fn_onAttack(root, bird, delaytime or 0.3)
        end
    end
end
local function SetBehaviorTree(inst, done)
    if done == "atk" then
        inst._count_atk = inst._count_atk + 1
        if inst._count_atk >= 4 then --每啄击几下，进行一次羽乱舞
            inst.components.timer:StopTimer("flap")
            inst.sg.mem.to_flap = true --不用事件，回到idle时自己检查吧
        end
    elseif done == "flap" then
        inst._count_atk = 0
        inst.components.timer:StopTimer("flap")
        inst.components.timer:StartTimer("flap", TIME_FLAP)
    elseif done == "taunt" then
        inst._count_atk = 0
        inst.components.timer:StopTimer("taunt")
        inst.components.timer:StartTimer("taunt", TIME_TAUNT)
    elseif done == "caw" then
        inst._count_atk = 0
        inst.components.timer:StopTimer("caw")
        inst.components.timer:StartTimer("caw", TIME_CAW)
    end
end

local function MagicWarble(inst) --魔音绕梁
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, 0, z, DIST_REMOTE, { "_combat", "_inventory" }, { "INLIMBO", "siving", "l_noears" })
    for _, v in ipairs(ents) do
        if
            (v.components.health == nil or not v.components.health:IsDead()) and
            v.components.inventory ~= nil and
            v.components.locomotor ~= nil
        then
            local hat = v.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
            v.components.inventory:DropEquipped(false)

            --装备了兔耳罩就能避免后续的debuff
            if hat ~= nil and (hat.prefab == "earmuffshat" or hat.protect_l_magicwarble) then
                return
            end

            v.time_l_magicwarble = { replace_min = TIME_BUFF_WARBLE }
            v:AddDebuff("debuff_magicwarble", "debuff_magicwarble")

            if inst.isgrief then --悲愤状态：附加睡醒的移速缓慢状态
                if v.task_groggy_warble ~= nil then
                    v.task_groggy_warble:Cancel()
                end
                v:AddTag("groggy") --添加标签，走路会摇摇晃晃
                v.components.locomotor:SetExternalSpeedMultiplier(v, "magicwarble", 0.4)
                v.task_groggy_warble = v:DoTaskInTime(TIME_BUFF_WARBLE, function(v)
                    if v.components.locomotor ~= nil then
                        v.components.locomotor:RemoveExternalSpeedMultiplier(v, "magicwarble")
                    end
                    v:RemoveTag("groggy")
                    v.task_groggy_warble = nil
                end)
            end
        end
    end
    SetBehaviorTree(inst, "taunt")
end
local function DiscerningPeck(inst, target) --啄击（因为替换了官方的普攻逻辑，所以整体得模仿官方的普攻逻辑）
    if target == nil then
        target = inst.components.combat.target
    end
    if
        target ~= nil and
        target.components.health ~= nil and not target.components.health:IsDead() and
        inst.components.combat:CanHitTarget(target, nil) --计算距离和有效性
    then
        DoDefenselessATK(inst, target, ATK_NORMAL)
        inst:PushEvent("onattackother", { target = target, weapon = nil, projectile = nil, stimuli = nil })
        inst.components.combat.lastdoattacktime = GetTime()
    else
        inst:PushEvent("onmissother", { target = target, weapon = nil })
    end
    inst.components.combat:ClearAttackTemps()
    SetBehaviorTree(inst, "atk")
end
local function ReleaseFlowers(inst) --花寄语
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, 0, z, DIST_REMOTE, { "_combat", "_health" }, TAGS_CANT)

    --特效 undo

    for _, v in ipairs(ents) do
        if
            not v.hassivflower and --防止重复寄生
            v.components.health ~= nil and not v.components.health:IsDead() and
            (v.components.inventory == nil or not v.components.inventory:EquipHasTag("siv_BFF")) and
            (inst.isgrief or math.random() < 0.33)
        then
            SpawnFlower(inst, v)
        end
    end
    SetBehaviorTree(inst, "caw")
end
local function BeTreeEye(inst) --同目同心
    if inst:fn_canBeEye() then
        local eye = SpawnPrefab("siving_boss_eye")
        if eye ~= nil then
            eye:fn_onBind(inst.tree, inst)
            return true
        end
    end
    return false
end
local function FeathersFlap(inst) --羽乱舞
    local x, y, z = inst.Transform:GetWorldPosition()
    local num = math.random(2, 3)
    for i = 1, num, 1 do
        local fea = SpawnPrefab(math.random() < 0.2 and "siving_bossfea_real" or "siving_bossfea_fake")
        if fea ~= nil then
            fea.Transform:SetPosition(x, 0, z)
            fea.components.projectilelegion:Throw(fea, Vector3(GetCalculatedPos_legion(x, 0, z, 2)), inst, nil)
            fea.components.projectilelegion:DelayVisibility(fea.projectiledelay)
        end
    end
    SetBehaviorTree(inst, "flap")
end

local function MakeBoss(data)
    table.insert(prefs, Prefab(
        data.name,
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddSoundEmitter()
            inst.entity:AddDynamicShadow()
            inst.entity:AddLight()
            inst.entity:AddNetwork()

            inst.DynamicShadow:SetSize(2.5, 1.5)
            inst.Transform:SetScale(2.1, 2.1, 2.1)
            inst.Transform:SetFourFaced()

            MakeGhostPhysics(inst, 1500, 1.2) --鬼魂类物理，主要是为了不对子圭羽毛产生碰撞

            inst:AddTag("epic")
            -- inst:AddTag("noepicmusic")
            inst:AddTag("scarytoprey")
            inst:AddTag("hostile")
            inst:AddTag("largecreature")
            inst:AddTag("siving")
            -- inst:AddTag("flying")
            inst:AddTag("ignorewalkableplatformdrowning")

            --trader (from trader component) added to pristine state for optimization
            inst:AddTag("trader")

            inst.Light:Enable(true)
            inst.Light:SetRadius(2)
            inst.Light:SetFalloff(1)
            inst.Light:SetIntensity(.5)
            inst.Light:SetColour(15/255, 180/255, 132/255)
            inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

            inst.AnimState:SetBank("buzzard")
            inst.AnimState:SetBuild(data.name)
            inst.AnimState:PlayAnimation("idle", true)

            inst:SetPrefabNameOverride("siving_phoenix")

            -- if data.fn_common ~= nil then
            --     data.fn_common(inst)
            -- end

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst._count_atk = 0 --啄击次数
            inst._count_rock = 0 --喂食后需要掉落的子圭石数量

            inst.sounds = BossSounds
            inst.tree = nil
            inst.mate = nil --另一个伴侣
            inst.isgrief = false --是否处于悲愤状态
            inst.iseye = false --是否是木之眼状态
            inst.eyefx = nil --木之眼实体
            inst.fn_onGrief = function(inst, tree, dotaunt)
                inst.isgrief = true
                inst.AnimState:OverrideSymbol("buzzard_eye", data.name, "buzzard_angryeye")
                inst.Light:SetColour(255/255, 127/255, 82/255)
                inst.components.combat:SetDefaultDamage(ATK_NORMAL+ATK_GRIEF)
                if dotaunt then
                    inst:PushEvent("dotaunt")
                end
            end
            inst.fn_leave = function(inst)
                inst.tree = nil
                inst.mate = nil
                if inst.eyefx ~= nil and inst.eyefx:IsValid() then
                    inst.eyefx:Remove()
                end
                if inst:IsAsleep() or inst.iseye then
                    inst:Remove()
                else
                    inst:PushEvent("dotakeoff")
                end
            end
            inst.fn_canBeEye = function(inst)
                if
                    inst.tree ~= nil and inst.tree:IsValid()
                then
                    if inst.tree.myEye == nil then
                        return true
                    end
                    if inst.tree.myEye == inst then --因为提前占用了，所以是自己很正常
                        return true
                    end
                    if not IsValid(inst.tree.myEye) then
                        inst.tree.myEye = nil
                        return true
                    end
                    if not inst.tree.myEye.iseye then --木眼对象没有木眼标志(猜测可能正在进入木眼状态)
                        if not inst.tree.myEye.sg:HasStateTag("flyaway") then --然而并没有在进入木眼状态
                            inst.tree.myEye = nil
                            return true
                        end
                    end
                end
                return false
            end
            inst.fn_onFly = function(inst, params)
                if params ~= nil then
                    if params.x and params.z then
                        inst.Transform:SetPosition(params.x, params.y or 30, params.z)
                        inst.sg:GoToState("glide")
                        return
                    elseif params.beeye then --同目同心
                        if not inst:fn_beTreeEye() then
                            if inst.tree then
                                inst.tree.myEye = nil
                            end
                            local x, y, z = inst.Transform:GetWorldPosition()
                            inst.Transform:SetPosition(x, 30, z)
                            inst.sg:GoToState("glide")
                        end
                        return
                    end
                end
                inst:Remove() --飞上天就消失啦
            end

            inst.COUNT_FLAP = COUNT_FLAP
            inst.COUNT_FLAP_GRIEF = COUNT_FLAP_GRIEF
            inst.DIST_FLAP = DIST_FLAP
            inst.DIST_REMOTE = DIST_REMOTE
            inst.DIST_MATE = DIST_MATE
            inst.DIST_ATK = DIST_ATK
            inst.DIST_SPAWN = DIST_SPAWN
            inst.TIME_FLAP = TIME_FLAP

            inst.fn_magicWarble = MagicWarble
            inst.fn_discerningPeck = DiscerningPeck
            inst.fn_releaseFlowers = ReleaseFlowers
            inst.fn_beTreeEye = BeTreeEye
            inst.fn_feathersFlap = FeathersFlap

            inst:AddComponent("locomotor") --locomotor must be constructed before the stategraph
            inst.components.locomotor.walkspeed = 4
            inst.components.locomotor.runspeed = 8
            inst.components.locomotor:EnableGroundSpeedMultiplier(true)
            inst.components.locomotor:SetTriggersCreep(true)
            inst.components.locomotor.pathcaps = { ignorewalls = true, allowocean = true }

            inst:AddComponent("health")
            inst.components.health:SetMaxHealth(9000)
            inst.components.health.destroytime = 3

            inst:AddComponent("combat")
            inst.components.combat:SetDefaultDamage(ATK_NORMAL)
            -- inst.components.combat.playerdamagepercent = 0.5
            inst.components.combat.hiteffectsymbol = "buzzard_body"
            inst.components.combat.battlecryenabled = false
            inst.components.combat:SetRange(DIST_ATK)
            inst.components.combat:SetAttackPeriod(3)
            inst.components.combat:SetRetargetFunction(1.5, function(inst)
                CheckMate(inst)
                return FindEntity(inst.tree or inst, DIST_SPAWN,
                        inst.mate == nil and function(guy) --对自己有仇恨就行
                            return (inst.isgrief or guy.components.combat.target == inst)
                                and inst.components.combat:CanTarget(guy)
                        end or function(guy) --对自己有仇恨并且不能和伴侣的目标相同
                            return (inst.isgrief or guy.components.combat.target == inst)
                                and inst.components.combat:CanTarget(guy)
                                and inst.mate.components.combat.target ~= guy
                        end,
                        { "_combat" },
                        { "INLIMBO", "siving" }
                    )
            end)
            inst.components.combat:SetKeepTargetFunction(function(inst, target)
                CheckMate(inst)
                if inst.components.combat:CanTarget(target) then
                    if inst.mate == nil then --只需要不跑出神木范围就行
                        return target:GetDistanceSqToPoint(
                                inst.components.knownlocations:GetLocation("tree") or
                                inst.components.knownlocations:GetLocation("spawnpoint")
                            ) < DIST_SPAWN^2
                    else --不跑得离伴侣以及神木范围太远就行
                        return (
                                target:GetDistanceSqToPoint(
                                    inst.components.knownlocations:GetLocation("tree") or
                                    inst.components.knownlocations:GetLocation("spawnpoint")
                                ) < DIST_SPAWN^2
                            ) and (
                                inst.mate.iseye or
                                inst:GetDistanceSqToPoint(inst.mate:GetPosition()) < (DIST_MATE+DIST_ATK)^2
                            )
                    end
                end
            end)
            -- inst.components.combat.bonusdamagefn --攻击时针对于被攻击对象的额外伤害值
            inst.components.combat:SetHurtSound(BossSounds.hurt) --undo

            inst:AddComponent("trader")
            inst.components.trader.acceptnontradable = true
            inst.components.trader:SetAcceptTest(function(inst, item, giver)
                if inst.components.combat.target ~= nil or inst.sg:HasStateTag("busy") then
                    return false
                end
                local loveditems = {
                    myth_lotus_flower = 1,
                    aip_veggie_sunflower = 1,
                    cutted_rosebush = 1,
                    cutted_lilybush = 1,
                    cutted_orchidbush = 1
                }
                if loveditems[item.prefab] ~= nil or item.sivbird_l_food ~= nil then
                    --由于一次只给一个太慢了，这里手动从玩家身上全部拿下来
                    local num = item.components.stackable ~= nil and item.components.stackable.stacksize or 1
                    if num > 1 then
                        --拿走只剩1个，以供剩下的逻辑调用
                        local itemlast = item.components.stackable:Get(num - 1)
                        itemlast:Remove()
                    end
                    inst._count_rock = inst._count_rock + num*(loveditems[item.prefab] or item.sivbird_l_food)
                    return true
                else
                    return false
                end
            end)
            inst.components.trader.onaccept = function(inst, giver, item)
                inst:PushEvent("dofeeded")
            end
            inst.components.trader.onrefuse = function(inst, giver, item)
                inst:PushEvent("dorefuse")
            end

            inst:AddComponent("debuffable")
            inst.components.debuffable:SetFollowSymbol("buzzard_body", 0, -200, 0)

            -- inst:AddComponent("eater")
            -- inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI })

            inst:AddComponent("inspectable")
            inst.components.inspectable.getstatus = function(inst)
                return inst.isgrief and "GRIEF" or "GENERIC"
            end

            inst:AddComponent("explosiveresist")

            inst:AddComponent("sleeper")
            inst.components.sleeper:SetResistance(4)
            inst.components.sleeper:SetSleepTest(function(inst)
                return false
            end)
            inst.components.sleeper:SetWakeTest(function(inst)
                return true
            end)

            inst:AddComponent("knownlocations")

            inst:AddComponent("timer")
            inst.components.timer:StartTimer("flap", TIME_FLAP)
            inst.components.timer:StartTimer("taunt", TIME_TAUNT)
            inst.components.timer:StartTimer("caw", TIME_CAW)

            inst:AddComponent("lootdropper")

            MakeMediumFreezableCharacter(inst, "buzzard_body")

            inst:AddComponent("hauntable")

            inst:SetStateGraph("SGsiving_phoenix") --这个应该是指文件的名字，而不是数据的名字
            inst:SetBrain(birdbrain)

            inst:ListenForEvent("attacked", function(inst, data)
                if data.attacker and IsValid(data.attacker) then
                    if data.damage and data.attacker.components.combat ~= nil then
                        --将单次伤害超过120的部分反弹给攻击者
                        if data.damage > 120 then
                            --为了不受到盾反伤害，不设定玄鸟为攻击者
                            data.attacker.components.combat:GetAttacked(nil, data.damage-120)
                            --反击特效 undo
                            if not IsValid(data.attacker) then --攻击者死亡，就结束
                                return
                            end
                        end

                        --受到远程攻击，神木会帮忙做出惩罚
                        if --远程武器分为两类，一类是有projectile组件、一类是weapon组件中有projectile属性
                            data.attacker:HasTag("structure") or --针对建筑型攻击者
                            (data.weapon ~= nil and (
                                data.weapon.components.projectile ~= nil or
                                data.weapon.components.projectilelegion ~= nil or
                                data.weapon:HasTag("rangedweapon") or
                                (data.weapon.components.weapon ~= nil and data.weapon.components.weapon.projectile ~= nil)
                            ))
                        then
                            local x, y, z = data.attacker.Transform:GetWorldPosition()
                            SpawnRoot(inst, x, z)
                        end
                    end

                    CheckMate(inst)
                    if inst.components.health:IsDead() then
                        if inst.mate ~= nil then --自己被打死，伴侣仇恨攻击者
                            inst.mate.components.combat:SetTarget(data.attacker)
                        end
                        return
                    end

                    --现在是雌雄双打
                    local lasttarget = inst.components.combat.target
                    --谁离得近打谁
                    if lasttarget ~= nil and IsValid(lasttarget) then
                        if
                            inst:GetDistanceSqToPoint(lasttarget:GetPosition())
                            > inst:GetDistanceSqToPoint(data.attacker:GetPosition())
                        then
                            inst.components.combat:SetTarget(data.attacker)
                        end
                    else
                        inst.components.combat:SetTarget(data.attacker)
                    end
                    lasttarget = inst.components.combat.target
                    if lasttarget and inst.mate ~= nil and inst.mate.components.combat.target == nil then
                        inst.mate.components.combat:SetTarget(lasttarget)
                    end

                    --[[
                    local lasttarget = inst.components.combat.target

                    --保持伴侣和自己同时仇恨不同的对象
                    if inst.mate == nil then
                        if data.attacker == lasttarget then
                            return
                        end

                        --谁离得近打谁
                        if lasttarget ~= nil and IsValid(lasttarget) then
                            if
                                inst:GetDistanceSqToPoint(lasttarget:GetPosition())
                                > inst:GetDistanceSqToPoint(data.attacker:GetPosition())
                            then
                                inst.components.combat:SetTarget(data.attacker)
                            end
                        else
                            inst.components.combat:SetTarget(data.attacker)
                        end
                    else
                        local matetarget = inst.mate.components.combat.target

                        if data.attacker == lasttarget then
                            if lasttarget == matetarget then
                                inst.mate.components.combat:SetTarget(nil)
                            end
                            return
                        end

                        --谁离得近打谁
                        if lasttarget ~= nil and IsValid(lasttarget) then
                            if
                                inst:GetDistanceSqToPoint(lasttarget:GetPosition())
                                > inst:GetDistanceSqToPoint(data.attacker:GetPosition())
                            then
                                inst.components.combat:SetTarget(data.attacker)
                                if data.attacker == matetarget then
                                    inst.mate.components.combat:SetTarget(nil)
                                end
                            end
                        else
                            inst.components.combat:SetTarget(data.attacker)
                            if data.attacker == matetarget then
                                inst.mate.components.combat:SetTarget(nil)
                            end
                        end
                    end
                    ]]--
                end
            end)
            inst:ListenForEvent("timerdone", function(inst, data)
                if data.name == "flap" then
                    inst:PushEvent("doflap")
                elseif data.name == "taunt" then
                    inst:PushEvent("dotaunt")
                elseif data.name == "caw" then
                    inst:PushEvent("docaw")
                end
            end)

            -- inst.OnSave = OnSave
            inst.OnPreLoad = function(inst, data) --防止保存时正在飞起或降落导致重载时位置不对
                local x, y, z = inst.Transform:GetWorldPosition()
                if y > 0 then
                    inst.Transform:SetPosition(x, 0, z)
                end
            end
            -- inst.OnLoad = function(inst, data)end
            inst.OnEntitySleep = function(inst)
                inst.components.combat:SetTarget(nil)
            end
            -- inst.OnRemoveEntity = function(inst)end

            if data.fn_server ~= nil then
                data.fn_server(inst)
            end

            inst:DoTaskInTime(0, function(i)
                i.fx1 = SpawnPrefab("siving_treeprotect_fx")
                i.fx1.entity:SetParent(i.entity)
            end)

            return inst
        end,
        {
            Asset("ANIM", "anim/buzzard_basic.zip"), --官方秃鹫动画模板
            Asset("ANIM", "anim/"..data.name..".zip"),
        },
        {
            "debuff_magicwarble",
            "siving_boss_flowerfx",
            "siving_boss_eye",
            "siving_bossfea_real",
            "siving_bossfea_fake",
            "siving_boss_taunt_fx",
            "siving_boss_caw_fx",
            "siving_boss_root"
        }
    ))
end

------
------

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", inst.prefab, "swap")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    owner:AddTag("s_l_throw") --skill_legion_throw
    owner:AddTag("siv_feather")
end
local function OnUnequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    owner:RemoveTag("s_l_throw") --skill_legion_throw
    owner:RemoveTag("siv_feather")
end

local function OnDropped(inst)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.Default)
    inst.AnimState:PlayAnimation("item", false)
    inst.components.inventoryitem.pushlandedevents = true
    inst.components.inventoryitem.canbepickedup = true
    inst:PushEvent("on_landed")
end
local function OnThrown(inst, owner, targetpos, attacker)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:PlayAnimation("shoot", false)
    inst.components.inventoryitem.pushlandedevents = false
    inst.components.inventoryitem.canbepickedup = false
    inst:PushEvent("on_no_longer_landed")
    inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/swipe", nil, 0.3)
end
local function OnMiss(inst, targetpos, attacker)
    if inst.components.projectilelegion.isgoback then
        inst.components.projectilelegion.isgoback = nil
        if attacker and attacker.sivfeathers_l ~= nil then
            local num = 0
            for _,v in ipairs(attacker.sivfeathers_l) do
                if v and not v.isbroken then
                    num = num + 1
                end
            end
            attacker.sivfeathers_l = nil
            if num > 0 then
                if num > 1 then
                    inst.components.stackable:SetStackSize(num)
                end

                if attacker:IsValid() then
                    local line = attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                    if line and line.prefab == "siving_feather_line" and line:IsValid() then
                        attacker.components.inventory:RemoveItem(line, true)
                        line:Remove()
                    end
                    inst.components.inventoryitem.canbepickedup = true
                    if not attacker.components.inventory:Equip(inst) then
                        attacker.components.inventory:GiveItem(inst)
                    end
                else --此时攻击者实体无效了(可能是掉线了)，就掉地上吧
                    OnDropped(inst)
                end
                return
            end
        end
        inst:Remove()
    else
        OnDropped(inst)
        inst.components.inventoryitem.canbepickedup = false
        inst:DoTaskInTime(4.5, function(inst) --暂时不能被捡起，防止拉回前被偷走
            inst.components.inventoryitem.canbepickedup = true
        end)
    end
end

--[[
local function ReticuleTargetFn()
    return Vector3(ThePlayer.entity:LocalToWorldSpace(6.5, 0, 0))
end
local function ReticuleMouseTargetFn(inst, mousepos)
    if mousepos ~= nil then
        local x, y, z = inst.Transform:GetWorldPosition()
        local dx = mousepos.x - x
        local dz = mousepos.z - z
        local l = dx * dx + dz * dz
        if l <= 0 then
            return inst.components.reticule.targetpos
        end
        l = 6.5 / math.sqrt(l)
        return Vector3(x + dx * l, 0, z + dz * l)
    end
end
local function ReticuleUpdatePositionFn(inst, pos, reticule, ease, smoothing, dt)
    local x, y, z = inst.Transform:GetWorldPosition()
    reticule.Transform:SetPosition(x, 0, z)
    local rot = -math.atan2(pos.z - z, pos.x - x) / DEGREES
    if ease and dt ~= nil then
        local rot0 = reticule.Transform:GetRotation()
        local drot = rot - rot0
        rot = Lerp((drot > 180 and rot0 + 360) or (drot < -180 and rot0 - 360) or rot0, rot, dt * smoothing)
    end
    reticule.Transform:SetRotation(rot)
end
]]--

local function MakeWeapon(data)
    table.insert(prefs, Prefab(
        data.name,
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddSoundEmitter()
            inst.entity:AddNetwork()

            MakeInventoryPhysics(inst)
            RemovePhysicsColliders(inst)

            inst:AddTag("sharp")
            inst:AddTag("s_l_throw") --skill_legion_throw
            inst:AddTag("siv_feather")
            inst:AddTag("allow_action_on_impassable")

            --weapon (from weapon component) added to pristine state for optimization
            inst:AddTag("weapon")

            inst.AnimState:SetBank(data.name)
            inst.AnimState:SetBuild(data.name)
            inst.AnimState:PlayAnimation("item", false)
            -- inst.Transform:SetEightFaced()

            --Tip：官方的战斗辅助组件。加上后就能右键先瞄准再触发攻击。缺点是会导致其他对象的右键动作全部不起作用
            -- inst:AddComponent("aoetargeting")
            -- inst.components.aoetargeting:SetAlwaysValid(true)
            -- inst.components.aoetargeting.reticule.reticuleprefab = "reticulelongmulti"
            -- inst.components.aoetargeting.reticule.pingprefab = "reticulelongmultiping"
            -- inst.components.aoetargeting.reticule.targetfn = ReticuleTargetFn
            -- inst.components.aoetargeting.reticule.mousetargetfn = ReticuleMouseTargetFn
            -- inst.components.aoetargeting.reticule.updatepositionfn = ReticuleUpdatePositionFn
            -- inst.components.aoetargeting.reticule.validcolour = { 117/255, 1, 1, 1 }
            -- inst.components.aoetargeting.reticule.invalidcolour = { 0, 72/255, 72/255, 1 }
            -- inst.components.aoetargeting.reticule.ease = true
            -- inst.components.aoetargeting.reticule.mouseenabled = true

            inst.projectiledelay = 2 * FRAMES

            MakeInventoryFloatable(inst, "small", 0.2, 0.5)
            local OnLandedClient_old = inst.components.floater.OnLandedClient
            inst.components.floater.OnLandedClient = function(self)
                OnLandedClient_old(self)
                self.inst.AnimState:SetFloatParams(0.04, 1, self.bob_percent)
            end

            if data.fn_common ~= nil then
                data.fn_common(inst)
            end

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst:AddComponent("inspectable")

            inst:AddComponent("stackable")
            inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

            inst:AddComponent("inventoryitem")
            inst.components.inventoryitem.imagename = data.name
            inst.components.inventoryitem.atlasname = "images/inventoryimages/"..data.name..".xml"
            inst.components.inventoryitem:SetOnDroppedFn(OnDropped)

            inst:AddComponent("equippable")
            inst.components.equippable:SetOnEquip(OnEquip)
            inst.components.equippable:SetOnUnequip(OnUnequip)
            inst.components.equippable.equipstack = true --装备时可以叠加装备

            inst:AddComponent("weapon")
            inst.components.weapon:SetRange(-1, -1) --人物默认攻击距离为3、3

            inst:AddComponent("projectilelegion")
            inst.components.projectilelegion.speed = 45
            inst.components.projectilelegion.onthrown = OnThrown
            inst.components.projectilelegion.onmiss = OnMiss

            inst:AddComponent("skillspelllegion")
            inst.components.skillspelllegion.fn_spell = function(inst, caster, pos, options)
                if caster.components.inventory then
                    local doerpos = caster:GetPosition()
                    local angles = {}
                    local poss = {}
                    local direction = (pos - doerpos):GetNormalized() --单位向量
                    local angle = math.acos(direction:Dot(Vector3(1, 0, 0))) / DEGREES --这个角度是动画的，不能用来做物理的角度
                    local ang_lag = 2.5

                    --查询是否有能拉回的材料
                    local lines = caster.components.inventory:FindItems(function(i)
                        if i.line_l_value ~= nil or LineMap[i.prefab] then
                            return true
                        end
                    end)

                    local items = nil --需要丢出去的羽毛
                    local num = inst.components.stackable:StackSize()
                    if num <= 5 then
                        items = caster.components.inventory:RemoveItem(inst, true)
                    else
                        items = inst.components.stackable:Get(5)
                        items.components.inventoryitem:OnRemoved() --由于此时还处于物品栏状态，需要恢复为非物品栏状态
                    end

                    if num == 1 then
                        angles = { 0 }
                        poss[1] = pos
                    else
                        if num == 2 then
                            angles = { -ang_lag, ang_lag }
                        elseif num == 3 then
                            angles = { -2*ang_lag, 0, 2*ang_lag }
                        elseif num == 4 then
                            angles = { -3*ang_lag, -ang_lag, ang_lag, 3*ang_lag }
                        else --最多5个
                            angles = { -4*ang_lag, -2*ang_lag, 0, 2*ang_lag, 4*ang_lag }
                        end

                        local ang = caster:GetAngleToPoint(pos.x, pos.y, pos.z) --原始角度，单位:度，比如33
                        for i,v in ipairs(angles) do
                            v = v + math.random()*2 - 1
                            angles[i] = v
                            local an = (ang+v)*DEGREES
                            poss[i] = Vector3(doerpos.x+math.cos(an), 0, doerpos.z-math.sin(an))
                        end
                    end

                    local feathers = {}
                    for i,v in ipairs(angles) do
                        local item = items.components.stackable:Get(1)
                        item.Transform:SetPosition(doerpos:Get())
                        feathers[i] = item
                        item.components.projectilelegion:Throw(item, poss[i], caster, angle+v)
                        item.components.projectilelegion:DelayVisibility(item.projectiledelay)
                    end

                    if caster.components.health ~= nil and not caster.components.health:IsDead() then
                        local mask = caster.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
                        if mask ~= nil and mask.feather_l_reducer ~= nil then
                            mask = mask.feather_l_reducer
                        else
                            mask = 0
                        end
                        if caster.feather_l_reducer ~= nil then --简单地兼容其他东西
                            mask = mask + caster.feather_l_reducer
                        end
                        caster.components.health:DoDelta(-(4 + mask)*num, true, data.name, false, nil, true)
                        if not caster.components.health:IsDead() and #lines > 0 then
                            local line = SpawnPrefab("siving_feather_line")
                            caster.sivfeathers_l = feathers
                            line.linedoer = caster
                            if not caster.components.inventory:Equip(line) then
                                line:Remove()
                            end
                        end
                    end

                    return true
                end
            end

            MakeHauntableLaunch(inst)

            if data.fn_server ~= nil then
                data.fn_server(inst)
            end

            return inst
        end,
        data.assets,
        data.prefabs
    ))
end

------
------

local function MakeBossWeapon(data)
    local scale = 1.2
    table.insert(prefs, Prefab(
        data.name,
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddSoundEmitter()
            inst.entity:AddNetwork()

            MakeInventoryPhysics(inst)
            RemovePhysicsColliders(inst)

            inst.Transform:SetScale(scale, scale, scale)
            inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)

            inst:AddTag("sharp")

            --weapon (from weapon component) added to pristine state for optimization
            inst:AddTag("weapon")

            inst.projectiledelay = 3 * FRAMES

            if data.fn_common ~= nil then
                data.fn_common(inst)
            end

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst.persists = false

            inst:AddComponent("weapon")

            inst:AddComponent("projectilelegion")
            inst.components.projectilelegion.speed = 45
            inst.components.projectilelegion.shootrange = DIST_FLAP
            inst.components.projectilelegion.onthrown = function(inst, owner, targetpos, attacker)
                inst.AnimState:PlayAnimation("shoot3", false)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/swipe", nil, 0.2)
            end
            inst.components.projectilelegion.onmiss = function(inst, targetpos, attacker)
                local block = SpawnPrefab(data.name.."_block")
                if block ~= nil then
                    block.Transform:SetRotation(inst.Transform:GetRotation())
                    block.Transform:SetPosition(inst.Transform:GetWorldPosition())
                end
                inst:Remove()
            end
            inst.components.projectilelegion.exclude_tags = { "INLIMBO", "NOCLICK", "siving", "boat" }

            if data.fn_server ~= nil then
                data.fn_server(inst)
            end

            return inst
        end,
        data.assets,
        data.prefabs
    ))
    table.insert(prefs, Prefab(
        data.name.."_block",
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddSoundEmitter()
            inst.entity:AddNetwork()

            inst:SetPhysicsRadiusOverride(0.15)
            MakeWaterObstaclePhysics(inst, 0.15, 2, 0.75)

            inst:AddTag("siv_boss_block") --用来被清场
            inst:AddTag("ignorewalkableplatforms")

            inst.Transform:SetScale(scale, scale, scale)
            inst.Transform:SetEightFaced()

            inst:SetPrefabNameOverride(data.name)

            MakeInventoryFloatable(inst, "small", 0.2, 0.5)
            -- local OnLandedClient_old = inst.components.floater.OnLandedClient
            -- inst.components.floater.OnLandedClient = function(self)
            --     OnLandedClient_old(self)
            --     self.inst.AnimState:SetFloatParams(0.04, 1, self.bob_percent)
            -- end

            if data.fn_common2 ~= nil then
                data.fn_common2(inst)
            end

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            --加载水面特效
            inst:DoTaskInTime(POPULATING and math.random()*5*FRAMES or 0, function(inst)
                inst.components.floater:OnLandedServer()
            end)

            inst:AddComponent("inspectable")

            inst:AddComponent("lootdropper")

            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(ACTIONS.MINE)
            inst.components.workable:SetWorkLeft(1)

            inst:AddComponent("savedrotation") --保存旋转角度的组件

            MakeHauntableWork(inst)

            inst:ListenForEvent("on_collide", function(inst, data) --被船撞时
                local boat_physics = data.other.components.boatphysics
                if boat_physics ~= nil then
                    inst.components.workable:WorkedBy(data.other, 1)
                end
            end)

            if data.fn_server2 ~= nil then
                data.fn_server2(inst)
            end

            return inst
        end,
        data.assets,
        data.prefabs2
    ))
end

--------------------------------------------------------------------------
--[[ 子圭玄鸟（雌） ]]
--------------------------------------------------------------------------

SetSharedLootTable('siving_foenix', {
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_rocks',        0.50},
    {'siving_rocks',        0.50},
    {'siving_rocks',        0.50},
    {'siving_feather_fake',     1.00},
    {'siving_feather_fake',     0.50},
    {'siving_derivant_item',    1.00},
    {'siving_derivant_item',    1.00},
    {'siving_mask_blueprint',   1.00},
    -- {'chesspiece_moosegoose_sketch', 1.00},
})

MakeBoss({
    name = "siving_foenix",
    -- assets = nil,
    -- prefabs = nil,
    -- fn_common = function(inst)end,
    fn_server = function(inst)
        inst.components.lootdropper:SetChanceLootTable('siving_foenix')
    end
})

--------------------------------------------------------------------------
--[[ 子圭玄鸟（雄） ]]
--------------------------------------------------------------------------

SetSharedLootTable('siving_moenix', {
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_rocks',        1.00},
    {'siving_rocks',        0.50},
    {'siving_rocks',        0.50},
    {'siving_rocks',        0.50},
    {'siving_feather_fake',     1.00},
    {'siving_feather_fake',     1.00},
    {'siving_feather_fake',     1.00},
    {'siving_feather_fake',     0.50},
    {'siving_feather_fake',     0.50},
    {'siving_feather_real',     1.00},
    {'siving_mask_blueprint',   1.00},
    -- {'chesspiece_moosegoose_sketch', 1.00},
})

MakeBoss({
    name = "siving_moenix",
    -- assets = nil,
    -- prefabs = nil,
    -- fn_common = function(inst)end,
    fn_server = function(inst)
        inst.ismale = true
        inst.components.lootdropper:SetChanceLootTable('siving_moenix')
    end
})

--------------------------------------------------------------------------
--[[ 子圭石子 ]]
--------------------------------------------------------------------------

local TIME_EGG = 30 --孵化时间

local function SetEggState(inst, state)
    inst.state = state
    if state == 2 then
        inst.AnimState:OverrideSymbol("eggbase", "siving_egg", "egg2")
        inst.AnimState:PushAnimation("idle2", true)
    elseif state == 3 then
        inst.AnimState:OverrideSymbol("eggbase", "siving_egg", "egg3")
        inst.AnimState:PushAnimation("idle3", true)
    elseif state == 4 then
        inst.AnimState:OverrideSymbol("eggbase", "siving_egg", "egg4")
        inst.AnimState:PushAnimation("idle4", true)
    else
        inst.AnimState:ClearOverrideSymbol("eggbase")
        inst.AnimState:PushAnimation("idle1", true)
    end
end
local function OnTimerDone_egg(inst, data)
    if data.name == "state1" then
        SetEggState(inst, 2)
        inst.components.timer:StartTimer("state2", TIME_EGG*0.35)
        inst.SoundEmitter:PlaySound("dontstarve/creatures/egg/egg_hatch_crack")
    elseif data.name == "state2" then
        SetEggState(inst, 3)
        inst.components.timer:StartTimer("state3", TIME_EGG*0.35)
        inst.SoundEmitter:PlaySound("dontstarve/creatures/egg/egg_hatch_crack")
    elseif data.name == "state3" then
        SetEggState(inst, 4)
        inst.components.timer:StartTimer("birth", 2.5)
        inst.task_sound = inst:DoPeriodicTask(0.2, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/egg/egg_hatch_crack")
        end, 0)
    elseif data.name == "birth" then
        if inst.tree == nil or not inst.tree:IsValid() then --生成一个非BOSS战的玄鸟
            local bird = SpawnPrefab(inst.ismale and "siving_moenix" or "siving_foenix")
            if bird ~= nil then
                bird.Transform:SetPosition(inst.Transform:GetWorldPosition())
                bird.components.knownlocations:RememberLocation("spawnpoint", inst:GetPosition(), false)
            end
        else --BOSS战的玄鸟由神木在管理
            inst.ishatched = true
        end
        if inst.task_sound ~= nil then
            inst.task_sound:Cancel()
            inst.task_sound = nil
        end
        inst.AnimState:PlayAnimation("break", false)
        inst:ListenForEvent("animover", inst.Remove)
    end
end

table.insert(prefs, Prefab(
    "siving_egg",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeObstaclePhysics(inst, 0.4)

        inst:AddTag("hostile")
        inst:AddTag("siving")

        inst.AnimState:SetBank("siving_egg")
        inst.AnimState:SetBuild("siving_egg")
        inst.AnimState:PlayAnimation("idle1", true)

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst.ismale = false
        inst.ishatched = nil --是否正常孵化
        inst.tree = nil
        inst.state = 1

        inst.DIST_SPAWN = DIST_SPAWN

        inst:AddComponent("inspectable")

        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(300)

        inst:AddComponent("combat")

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetLoot({ "siving_rocks", "siving_rocks", "siving_rocks",
            "siving_rocks", "siving_rocks", "siving_rocks" })

        inst:AddComponent("timer")
        inst.components.timer:StartTimer("state1", TIME_EGG*0.3)

        inst:ListenForEvent("timerdone", OnTimerDone_egg)
        inst:ListenForEvent("attacked", function(inst, data)
            if not inst.components.health:IsDead() then
                inst.AnimState:PlayAnimation("hit")
                SetEggState(inst, inst.state)
            end
        end)
        inst:ListenForEvent("death", function(inst, data)
            inst:RemoveEventCallback("timerdone", OnTimerDone_egg)
            inst.components.lootdropper:DropLoot()
            inst.AnimState:PlayAnimation("break", false)
        end)

        inst.OnLoad = function(inst, data)
            if inst.components.timer:TimerExists("state2") then
                inst.components.timer:StopTimer("state1")
                SetEggState(inst, 2)
            elseif inst.components.timer:TimerExists("state3") then
                inst.components.timer:StopTimer("state1")
                SetEggState(inst, 3)
            elseif inst.components.timer:TimerExists("birth") then
                inst.components.timer:StopTimer("state1")
                SetEggState(inst, 4)
            end
        end

        return inst
    end,
    {
        Asset("ANIM", "anim/siving_egg.zip")
    },
    {
        "siving_foenix",
        "siving_moenix"
    }
))

--------------------------------------------------------------------------
--[[ 子圭寄生花 ]]
--------------------------------------------------------------------------

local HEALTH_FLOWER = 480
local TIME_FLOWER = 11 --治疗玄鸟的延迟时间

local function SetFlowerState(inst, value, pushanim)
    local name = nil
    if value <= HEALTH_FLOWER*0.33 then
        if inst.state ~= 1 then
            inst.state = 1
            name = "idle1"
            pushanim = false --没有to_idle1这个动画
        end
    elseif value <= HEALTH_FLOWER*0.66 then
        if inst.state ~= 2 then
            inst.state = 2
            name = "idle2"
        end
    else
        if inst.state ~= 3 then
            inst.state = 3
            name = "idle3"
        end
    end
    if name ~= nil then
        if pushanim then
            inst.AnimState:PlayAnimation("to_"..name)
            inst.AnimState:PushAnimation(name, true)
        else
            inst.AnimState:PlayAnimation(name, true)
        end
    end
end
local function GiveLife(target, value)
    local health = target.components.health
    if health:IsHurt() then
        local need = health.maxhealth - health.currenthealth
        if need >= value then
            health:DoDelta(value)
            return 0
        else
            health:DoDelta(need)
            return value-need
        end
    end
    return value
end

table.insert(prefs, Prefab( --特效
    "siving_boss_flowerfx",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddFollower()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst:AddTag("NOCLICK")
        inst:AddTag("FX")

        inst.AnimState:SetBank("siving_boss_flower")
        inst.AnimState:SetBuild("siving_boss_flower")
        inst.AnimState:PlayAnimation("idle1", true)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetFinalOffset(3)

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false
        inst.tree = nil
        inst.bird = nil
        inst.target = nil
        inst.countHealth = 0
        inst.state = 1

        inst.fn_onUnbind = function(target) --落地
            inst:RemoveEventCallback("death", inst.fn_onUnbind, target)
            inst:RemoveEventCallback("onremove", inst.fn_onUnbind, target)
            target.hassivflower = nil

            if inst.task_bind ~= nil then
                inst.task_bind:Cancel()
                inst.task_bind = nil
            end
            if inst.countHealth > 0 then
                local flower = SpawnPrefab("siving_boss_flower")
                if flower ~= nil then
                    flower.tree = inst.tree
                    flower.bird = inst.bird
                    if inst.countHealth < HEALTH_FLOWER then
                        flower.components.health:SetCurrentHealth(inst.countHealth)
                    end
                    SetFlowerState(flower, inst.countHealth, false)
                    flower.Transform:SetRotation(target.Transform:GetRotation())

                    local x, y, z = target.Transform:GetWorldPosition()
                    flower.Transform:SetPosition(x, 0.5, z)
                end
            end
            inst:Remove()
        end
        inst.fn_onBind = function(inst, bird, target) --寄生
            inst.tree = bird.tree
            inst.bird = bird
            inst.target = target
            target.hassivflower = true
            inst.entity:SetParent(target.entity)

            --获取能跟随的symbol
            local symbol = target.components.debuffable and target.components.debuffable.followsymbol or nil
            if symbol == nil or symbol == "" then
                if target.components.combat ~= nil then
                    symbol = target.components.combat.hiteffectsymbol
                end
            end
            if symbol == nil or symbol == "" then
                if target.components.freezable ~= nil then
                    for _, v in pairs(target.components.freezable.fxdata) do
                        if v.follow ~= nil then
                            symbol = v.follow
                            break
                        end
                    end
                end
                if symbol == nil or symbol == "" then
                    if target.components.burnable ~= nil then
                        for _, v in pairs(target.components.burnable.fxdata) do
                            if v.follow ~= nil then
                                symbol = v.follow
                                break
                            end
                        end
                    end
                end
            end
            if symbol ~= nil then
                local ox, oy, oz = 0, 0, 0
                if target.components.debuffable ~= nil then
                    local debuffable = target.components.debuffable
                    ox = debuffable.followoffset.x
                    oy = debuffable.followoffset.y
                    oz = debuffable.followoffset.z
                end
                if oy == 0 then
                    oy = -140
                end
                inst.Follower:FollowSymbol(target.GUID, symbol, ox, oy, oz)
            end

            inst:ListenForEvent("death", inst.fn_onUnbind, target)
            inst:ListenForEvent("onremove", inst.fn_onUnbind, target)

            if inst._task_re ~= nil then
                inst._task_re:Cancel()
                inst._task_re = nil
            end

            inst.task_bind = inst:DoPeriodicTask(2, function(inst)
                if IsValid(inst.target) then
                    inst.target.components.health:DoDelta(-4, true, inst.prefab, false, inst, true)
                    inst.countHealth = inst.countHealth + 40

                    --宿主还没死，并且也没有达到吸血上限，就更新自己的动画
                    if not inst.target.components.health:IsDead() and inst.countHealth < HEALTH_FLOWER then
                        SetFlowerState(inst, inst.countHealth, true)
                        return
                    end
                end
                inst.fn_onUnbind(inst.target)
            end, 2)
        end

        inst._task_re = inst:DoTaskInTime(1, inst.Remove)

        return inst
    end,
    {
        Asset("ANIM", "anim/siving_boss_flower.zip")
    },
    {
        "siving_boss_flower"
    }
))

table.insert(prefs, Prefab( --实体
    "siving_boss_flower",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        inst.entity:AddLight()

        inst:AddTag("hostile")
        inst:AddTag("siving")
        inst:AddTag("soulless") --没有灵魂

        inst.Transform:SetTwoFaced()

        inst.AnimState:SetBank("siving_boss_flower")
        inst.AnimState:SetBuild("siving_boss_flower")
        inst.AnimState:PlayAnimation("idle3", true)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

        inst.Light:Enable(true)
        inst.Light:SetRadius(.6)
        inst.Light:SetFalloff(1)
        inst.Light:SetIntensity(.5)
        inst.Light:SetColour(15/255, 180/255, 132/255)

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false
        inst.tree = nil
        inst.bird = nil
        inst.state = 3

        inst:AddComponent("inspectable")

        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(HEALTH_FLOWER)

        inst:AddComponent("combat")

        inst:ListenForEvent("attacked", function(inst, data)
            if not inst.components.health:IsDead() then
                inst.AnimState:PlayAnimation("hit"..tostring(inst.state))
                inst.AnimState:PushAnimation("idle"..tostring(inst.state), true)
            end
        end)
        inst:ListenForEvent("death", function(inst, data)
            if inst._task_health ~= nil then
                inst._task_health:Cancel()
                inst._task_health = nil
            end
            inst.Light:Enable(false)
            inst.AnimState:ClearBloomEffectHandle()
            inst.AnimState:PlayAnimation("dead"..tostring(inst.state), false)
        end)

        inst._task_health = inst:DoTaskInTime(TIME_FLOWER, function(inst)
            if inst.tree ~= nil and inst.tree:IsValid() then
                local value = inst.components.health.currenthealth
                local valuelast = 0
                if inst.tree.bossBirds ~= nil then --优先直接给玄鸟加血(我嫌给神木再转给玄鸟的话太慢了)
                    local female = inst.tree.bossBirds.female
                    local male = inst.tree.bossBirds.male
                    if female ~= nil and not IsValid(female) then
                        female = nil
                    end
                    if male ~= nil and not IsValid(male) then
                        male = nil
                    end
                    if female ~= nil or male ~= nil then
                        if female ~= nil and male ~= nil then
                            value = value/2
                        end
                        if female ~= nil then
                            valuelast = valuelast + GiveLife(female, value)
                        end
                        if male ~= nil then
                            valuelast = valuelast + GiveLife(male, value)
                        end
                    else
                        valuelast = value
                    end
                else
                    valuelast = value
                end

                if valuelast > 0 then --然后才是给神木增加生命计数器
                    inst.tree.countHealth = inst.tree.countHealth + valuelast
                end
            elseif inst.bird ~= nil and IsValid(inst.bird) then
                GiveLife(inst.bird, inst.components.health.currenthealth)
            end

            local fx = SpawnPrefab("siving_boss_flower_fx")
            if fx ~= nil then
                local x, y, z = inst.Transform:GetWorldPosition()
                fx.Transform:SetPosition(x, 0, z)
            end

            inst._task_health = nil
            inst:Remove()
        end)

        return inst
    end,
    {
        Asset("ANIM", "anim/siving_boss_flower.zip")
    },
    { "siving_boss_flower_fx" }
))

--------------------------------------------------------------------------
--[[ 子圭之眼 ]]
--------------------------------------------------------------------------

local TIME_EYE_DT = 2
local TIME_EYE_DT_GRIEF = 0.5
local COUNT_EYE = 6 --6
local COUNT_EYE_GRIEF = 9 --9

local function UnbindBird(inst, landpos)
    inst.bird.iseye = false
    inst.bird.eyefx = nil
    if IsValid(inst.bird) then
        if landpos == nil then
            landpos = inst.bird.components.knownlocations:GetLocation("spawnpoint") or inst.tree:GetPosition()
        end
        inst.bird.Transform:SetPosition(landpos.x, 30, landpos.z)
        inst.bird:ReturnToScene()
        inst.bird.sg:GoToState("glide")
        inst.bird._count_atk = 0
    end
end
local function EyeATK1(inst)
    if inst.task_eye2 ~= nil then
        return
    end
    inst.task_eye2 = inst:DoPeriodicTask(1.5, function(inst)
        if inst:IsAsleep() or inst.target == nil then
            return
        end
        local xx, yy, zz = inst.target.Transform:GetWorldPosition()
        local numpot = inst.bird.isgrief and 7 or 5
        local the = math.random()*2*PI
        local the_dt = 2*PI/numpot
        local emptykey = math.random(numpot)
        local x2, y2, z2
        for i = 1, numpot, 1 do
            if emptykey ~= i then
                x2, y2, z2 = GetCalculatedPos_legion(xx, 0, zz, 3.5, the+the_dt*(i-1))
                SpawnRoot(inst.bird, x2, z2, 0.4)
            end
        end
    end, 0.5)
end
local function EyeAttack(inst, dt, countnow, countmax, x, z)
    inst.task_eye = inst:DoTaskInTime(dt, function(inst)
        --确定攻击者
        local tar = nil
        if inst.bird.mate ~= nil and inst.bird.mate.components.combat.target ~= nil then
            tar = inst.bird.mate.components.combat.target
        else
            local ents = TheSim:FindEntities(x, 0, z, DIST_SPAWN, { "_combat", "_health" }, TAGS_CANT)
            for _, v in ipairs(ents) do
                if v.components.health ~= nil and not v.components.health:IsDead() then
                    if v:HasTag("player") then
                        tar = v
                        break
                    elseif tar == nil then
                        tar = v
                    end
                end
            end
        end

        --判定是否结束
        if countnow >= countmax then
            inst.task_eye = nil
            inst:fn_onUnbind(tar and tar:GetPosition() or nil)
            return
        end

        --预备施法
        inst.AnimState:PlayAnimation("spell", true)
        countnow = countnow + 1
        inst.target = tar

        --玩家逃避
        if tar == nil then
            --防御值+1层 undo
        end

        ------攻击方式1
        EyeATK1(inst)

        ------攻击方式2
        local theta = nil
        local xx, yy, zz
        if tar ~= nil then
            xx, yy, zz = tar.Transform:GetWorldPosition()
            theta = math.atan2(z - zz, xx - x)
        else
            theta = math.random()*2*PI
        end
        --开始突袭！
        local num = 0
        local nummax = math.random(15, 19)
        local the = theta
        inst.task_eye = inst:DoPeriodicTask(0.12, function(inst)
            num = num + 1
            if not inst:IsAsleep() then
                if inst.bird.isgrief then
                    if num%2 == 1 then
                        the = theta + 2*DEGREES
                    else
                        the = theta - 2*DEGREES
                    end
                end
                xx, yy, zz = GetCalculatedPos_legion(x, 0, z, 3+num*1.2, the)
                SpawnRoot(inst.bird, xx, zz, 0.3)
            end
            if num >= nummax then
                if inst.task_eye ~= nil then
                    inst.task_eye:Cancel()
                    inst.task_eye = nil
                end
                if not inst.bird.isgrief then
                    inst.target = nil
                end
                inst.AnimState:PlayAnimation("idle", true)
                EyeAttack(inst, dt, countnow, countmax, x, z)
            end
        end, 1)
    end)
end

table.insert(prefs, Prefab(
    "siving_boss_eye",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddFollower()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst:AddTag("NOCLICK")
        inst:AddTag("FX")

        inst.AnimState:SetBank("siving_boss_eye")
        inst.AnimState:SetBuild("siving_boss_eye")
        inst.AnimState:PlayAnimation("bind")
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetScale(1.3, 1.3)
        inst.AnimState:SetFinalOffset(3)
        inst.AnimState:SetSortOrder(3)

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false
        inst.tree = nil
        inst.bird = nil
        inst.target = nil

        inst.fn_onUnbind = function(inst, landpos) --解除
            if inst.task_eye ~= nil then
                inst.task_eye:Cancel()
                inst.task_eye = nil
            end
            if inst.task_eye2 ~= nil then
                inst.task_eye2:Cancel()
                inst.task_eye2 = nil
            end

            if inst.tree:IsValid() then
                inst.tree.components.timer:StopTimer("eye")
                inst.tree.components.timer:StartTimer("eye", inst.tree.TIME_EYE)
                if inst:IsAsleep() then
                    UnbindBird(inst, landpos)
                    inst.tree.myEye = nil
                    inst:Remove()
                else
                    inst.AnimState:PlayAnimation("unbind")
                    inst:ListenForEvent("animover", function(inst) --如果离玩家太远，动画会暂停
                        UnbindBird(inst, landpos)
                        inst.tree.myEye = nil
                        inst:Remove()
                    end)
                end
            else
                UnbindBird(inst, landpos)
                inst.tree.myEye = nil
                inst:Remove()
            end
        end
        inst.fn_onBind = function(inst, tree, bird) --化作
            if inst._task_re ~= nil then
                inst._task_re:Cancel()
                inst._task_re = nil
            end

            if bird.components.combat.target ~= nil then --把仇恨对象交给伴侣，不然仇恨就断了
                CheckMate(bird)
                if bird.mate ~= nil and bird.mate.components.combat.target == nil then
                    bird.mate.components.combat:SetTarget(bird.components.combat.target)
                end
                bird.components.combat:SetTarget(nil)
            end

            bird:RemoveFromScene()
            bird.iseye = true
            bird.eyefx = inst
            tree.myEye = bird
            inst.tree = tree
            inst.bird = bird

            local x, y, z = tree.Transform:GetWorldPosition()
            inst.Transform:SetPosition(x, y, z)
            bird.Transform:SetPosition(x, 0, z)

            inst.entity:SetParent(tree.entity)
            inst.Follower:FollowSymbol(tree.GUID, "trunk", 0, -760, 0)

            inst.AnimState:PlayAnimation("bind")
            inst.AnimState:PushAnimation("idle", true)

            if bird.isgrief then
                inst.AnimState:OverrideSymbol("eye", "siving_boss_eye", "griefeye")
                EyeAttack(inst, TIME_EYE_DT_GRIEF, 0, COUNT_EYE_GRIEF, x, z)
            else
                EyeAttack(inst, TIME_EYE_DT, 0, COUNT_EYE, x, z)
            end
        end

        inst._task_re = inst:DoTaskInTime(1, inst.Remove)

        return inst
    end,
    {
        Asset("ANIM", "anim/siving_boss_eye.zip")
    },
    {
        "siving_boss_root"
    }
))

--------------------------------------------------------------------------
--[[ 子圭突触 ]]
--------------------------------------------------------------------------

local function SetClosedPhysics(inst)
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.ITEMS)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
end
local function SetOpenedPhysics(inst)
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.ITEMS)
end

table.insert(prefs, Prefab(
    "siving_boss_root",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()
        inst.entity:AddLight()

        inst:AddTag("siv_boss_block") --用来被清场
        inst:AddTag("siving_derivant")

        inst.AnimState:SetBank("atrium_fence")
        inst.AnimState:SetBuild("siving_boss_root")
        inst.AnimState:PlayAnimation("shrunk")
        -- inst.AnimState:SetScale(1.3, 1.3)

        inst.Light:Enable(false)
        inst.Light:SetRadius(1.5)
        inst.Light:SetFalloff(1)
        inst.Light:SetIntensity(.6)
        inst.Light:SetColour(15/255, 180/255, 132/255)

        MakeObstaclePhysics(inst, 0.15)
        SetOpenedPhysics(inst)

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst.fenceid = math.random(5)
        inst.treeState = 0

        inst.OnTreeLive = function(inst, state)
            inst.treeState = state
            if state == 2 then
                -- inst.AnimState:SetBuild("siving_boss_root2") --undo
                inst.components.bloomer:PushBloom("activetree", "shaders/anim.ksh", 1)
                inst.Light:SetRadius(1.5)
                inst.Light:Enable(true)
            elseif state == 1 then
                inst.AnimState:SetBuild("siving_boss_root")
                inst.components.bloomer:PushBloom("activetree", "shaders/anim.ksh", 1)
                inst.Light:SetRadius(0.8)
                inst.Light:Enable(true)
            else
                inst.AnimState:SetBuild("siving_boss_root")
                inst.components.bloomer:PopBloom("activetree")
                inst.Light:Enable(false)
            end
        end
        inst.fn_onAttack = function(inst, bird, delaytime)
            inst.AnimState:PlayAnimation("grow"..tostring(inst.fenceid))
            inst.AnimState:PushAnimation("idle"..tostring(inst.fenceid), false)
            inst.SoundEmitter:PlaySound("dontstarve/common/together/atrium/gate_spike")
            inst.components.workable:SetWorkable(false)
            inst._task_atk = inst:DoTaskInTime(delaytime, function(inst)
                inst._task_atk = nil

                --攻击！破坏！
                local x, y, z = inst.Transform:GetWorldPosition()
                local ents = TheSim:FindEntities(x, 0, z, DIST_ROOT_ATK,
                    nil, { "INLIMBO", "NOCLICK", "siving", "shadow", "ghost" },
                    { "_combat", "CHOP_workable", "DIG_workable", "HAMMER_workable", "MINE_workable" }
                )
                for _, v in ipairs(ents) do
                    if v.components.combat ~= nil then
                        if v.components.health ~= nil and not v.components.health:IsDead() then
                            if v.components.locomotor == nil then --可以秒杀触手等没有移动组件但有战斗组件的实体
                                v.components.health:Kill()
                            elseif v.components.combat:CanBeAttacked() then
                                v.components.combat:GetAttacked(inst, GetDamage(bird or inst, v, ATK_ROOT))
                            end
                        end
                    elseif v.components.workable ~= nil then
                        if v.components.workable:CanBeWorked() then
                            v.components.workable:WorkedBy(inst, 3)
                        end
                    end
                end

                SetClosedPhysics(inst)
            end)
            inst._task_work = inst:DoTaskInTime(delaytime+3, function(inst)
                inst._task_work = nil
                inst.components.workable:SetWorkable(true)
            end)
        end
        inst.fn_onClear = function(inst)
            if inst._task_atk ~= nil then
                inst._task_atk:Cancel()
                inst._task_atk = nil
            end
            if inst._task_work ~= nil then
                inst._task_work:Cancel()
                inst._task_work = nil
            end

            inst.persists = false
            if inst:IsAsleep() then
                inst:Remove()
                return
            end

            inst:AddTag("NOCLICK")
            inst.components.bloomer:PopBloom("activetree")
            inst.Light:Enable(false)
            inst.AnimState:PlayAnimation("shrink"..tostring(inst.fenceid))
            inst:DoTaskInTime(0.6, inst.Remove) --我嫌动画末尾太拖了，提前结束！
            inst.SoundEmitter:PlaySound("dontstarve/common/together/atrium/retract")
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("bloomer")

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.MINE)
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnFinishCallback(function(inst, worker)
            SetOpenedPhysics(inst)
            inst.components.lootdropper:DropLoot()
            inst:fn_onClear()
        end)

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:AddChanceLoot("siving_rocks", 0.001)

        MakeHauntableWork(inst)

        inst.OnSave = function(inst, data)
            data.fenceid = inst.fenceid
        end
        inst.OnLoad = function(inst, data)
            if data ~= nil and data.fenceid ~= nil then
                inst.fenceid = data.fenceid
            end
            inst.AnimState:PushAnimation("idle"..tostring(inst.fenceid), false)
            SetClosedPhysics(inst)
        end

        return inst
    end,
    {
        Asset("ANIM", "anim/siving_boss_root.zip"),
        -- Asset("ANIM", "anim/siving_boss_root2.zip"),
        Asset("ANIM", "anim/atrium_fence.zip")
    },
    nil
))

--------------------------------------------------------------------------
--[[ 子圭玄鸟正羽 ]]
--------------------------------------------------------------------------

--玩家武器
MakeWeapon({
    name = "siving_feather_real",
    assets = {
        Asset("ANIM", "anim/siving_feather_real.zip"),
        Asset("ATLAS", "images/inventoryimages/siving_feather_real.xml"),
        Asset("IMAGE", "images/inventoryimages/siving_feather_real.tex"),
    },
    prefabs = {
        -- "reticulelongmulti", --Tip：官方的战斗辅助组件
        -- "reticulelongmultiping",
        "siving_feather_line"
    },
    -- fn_common = function(inst) end,
    fn_server = function(inst)
        inst.components.weapon:SetDamage(61.2) --34*1.8

        inst.components.projectilelegion.shootrange = 13
    end
})

--BOSS产物：精致子圭翎羽
local function AddWeaponLight(inst)
    inst.entity:AddLight()
    inst.Light:Enable(true)
    inst.Light:SetRadius(.6)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(15/255, 180/255, 132/255)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
end
local function ExplodeFeather(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, DIST_FEA_EXPLODE, nil, { "INLIMBO", "NOCLICK", "FX", "siving" })
    for _, v in ipairs(ents) do
        if v ~= inst and v:IsValid() then
            if v.components.workable ~= nil then
                if v.components.workable:CanBeWorked() then
                    if v:HasTag("siv_boss_block") then
                        v.explode_chain_l = true --连锁爆炸
                    end
                    v.components.workable:WorkedBy(inst, 3)
                end
            elseif
                v.components.combat ~= nil and
                not (v.components.health ~= nil and v.components.health:IsDead())
            then
                v.components.combat:GetAttacked(inst, GetDamage2(v, ATK_FEA_EXPLODE), nil)
            end
            v:PushEvent("explosion", { explosive = inst })
        end
    end

    --爆炸特效(声音也在里面)
    SpawnPrefab("explode_small_slurtle").Transform:SetPosition(x, y, z)

    inst.components.lootdropper:DropLoot()
    inst:Remove()
end

MakeBossWeapon({
    name = "siving_bossfea_real",
    assets = {
        Asset("ANIM", "anim/siving_feather_real.zip")
    },
    prefabs = { "siving_bossfea_real_block" },
    fn_common = function(inst)
        AddWeaponLight(inst)
        inst.AnimState:SetBank("siving_feather_real")
        inst.AnimState:SetBuild("siving_feather_real")
    end,
    fn_server = function(inst)
        inst.components.weapon:SetDamage(ATK_FEA_REAL)
    end,
    prefabs2 = { "explode_small_slurtle" },
    fn_common2 = function(inst)
        AddWeaponLight(inst)
        inst.AnimState:SetBank("siving_feather_real")
        inst.AnimState:SetBuild("siving_feather_real")
        inst.AnimState:PlayAnimation("idle", false)
    end,
    fn_server2 = function(inst)
        inst.components.lootdropper:AddChanceLoot("siving_rocks", 0.1)
        inst.components.workable:SetOnFinishCallback(function(inst, worker)
            if inst.task_explode ~= nil then
                inst.task_explode:Cancel()
                inst.task_explode = nil
            end
            ExplodeFeather(inst)
        end)

        inst.task_explode = inst:DoTaskInTime(TIME_FEA_EXPLODE, function(inst)
            inst.task_explode = nil
            ExplodeFeather(inst)
        end)

        inst.fn_onClear = function(inst)
            if inst.task_explode ~= nil then
                inst.task_explode:Cancel()
                inst.task_explode = nil
            end

            inst.persists = false
            if inst:IsAsleep() then
                inst:Remove()
                return
            end

            inst:AddTag("NOCLICK")
            inst.Light:Enable(false)
            inst.AnimState:ClearBloomEffectHandle()
            ErodeAway(inst)
        end
    end,
})

--------------------------------------------------------------------------
--[[ 子圭玄鸟绒羽 ]]
--------------------------------------------------------------------------

--玩家武器
MakeWeapon({
    name = "siving_feather_fake",
    assets = {
        Asset("ANIM", "anim/siving_feather_fake.zip"),
        Asset("ATLAS", "images/inventoryimages/siving_feather_fake.xml"),
        Asset("IMAGE", "images/inventoryimages/siving_feather_fake.tex"),
    },
    prefabs = {
        -- "reticulelongmulti", --Tip：官方的战斗辅助组件
        -- "reticulelongmultiping",
        "siving_feather_line"
    },
    -- fn_common = function(inst) end,
    fn_server = function(inst)
        inst.components.weapon:SetDamage(40.8) --34*1.2

        inst.components.projectilelegion.shootrange = 10
        inst.components.projectilelegion.onhit = function(inst, targetpos, doer, target)
            if not inst.isbroken and math.random() < 0.05 then
                inst.isbroken = true
                inst.Physics:Stop()
                inst:StopUpdatingComponent(inst.components.projectilelegion)
                inst:DoTaskInTime(0, function()
                    inst:Remove()
                end)
            end
        end
    end
})

--BOSS产物：子圭翎羽
MakeBossWeapon({
    name = "siving_bossfea_fake",
    assets = {
        Asset("ANIM", "anim/siving_feather_fake.zip")
    },
    prefabs = { "siving_bossfea_fake_block" },
    fn_common = function(inst)
        inst.AnimState:SetBank("siving_feather_fake")
        inst.AnimState:SetBuild("siving_feather_fake")
    end,
    fn_server = function(inst)
        inst.components.weapon:SetDamage(ATK_FEA)
    end,
    prefabs2 = { "explode_small_slurtle" },
    fn_common2 = function(inst)
        inst.AnimState:SetBank("siving_feather_fake")
        inst.AnimState:SetBuild("siving_feather_fake")
        inst.AnimState:PlayAnimation("idle", false)
    end,
    fn_server2 = function(inst)
        inst.components.lootdropper:AddChanceLoot("siving_rocks", 0.02)
        inst.components.workable:SetOnFinishCallback(function(inst, worker)
            if inst.explode_chain_l then --被连锁爆炸
                ExplodeFeather(inst)
                return
            end
            inst.components.lootdropper:DropLoot()
            --特效 undo
            inst:Remove()
        end)

        inst.fn_onClear = function(inst)
            inst.persists = false
            if inst:IsAsleep() then
                inst:Remove()
                return
            end

            inst:AddTag("NOCLICK")
            ErodeAway(inst)
        end
    end,
})

--------------------------------------------------------------------------
--[[ 临时的羽刃拉扯器 ]]
--------------------------------------------------------------------------

local function RemoveFromOnwer(inst)
    if inst.components.inventoryitem ~= nil then
        local owner = inst.components.inventoryitem:GetGrandOwner()
        if owner then
            local cpt = owner.components.inventory or owner.components.container
            if cpt then
                local reomveditem = cpt:RemoveItem(inst, true, true)
                if reomveditem then
                    reomveditem:Remove()
                    return
                end
            end
        end
    end
    inst:Remove()
end
local function RemoveLine(inst)
    if inst.linedoer ~= nil then
        inst.linedoer.sivfeathers_l = nil
    end
    inst:DoTaskInTime(0, function()
        RemoveFromOnwer(inst)
    end)
end

table.insert(prefs, Prefab(
    "siving_feather_line",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst:AddTag("s_l_pull") --skill_legion_pull
        inst:AddTag("siv_line")
        inst:AddTag("allow_action_on_impassable")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false
        inst.linedoer = nil --指发起这个动作的玩家

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = "siving_feather_line"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/siving_feather_line.xml"
        inst.components.inventoryitem:SetOnDroppedFn(RemoveLine)

        inst:AddComponent("equippable")
        inst.components.equippable:SetOnEquip(function(inst, owner)
            owner:AddTag("s_l_pull") --skill_legion_pull
            owner:AddTag("siv_line")
        end)
        inst.components.equippable:SetOnUnequip(function(inst, owner)
            owner:RemoveTag("s_l_pull")
            owner:RemoveTag("siv_line")
            RemoveLine(inst)
        end)

        inst:AddComponent("skillspelllegion")
        inst.components.skillspelllegion.fn_spell = function(inst, doer, pos, options)
            if doer.sivfeathers_l ~= nil then
                --查询能拉回的材料
                local lines = doer.components.inventory:FindItems(function(i)
                    if i.line_l_value ~= nil or LineMap[i.prefab] then
                        return true
                    end
                end)
                if #lines <= 0 then --没有能拉回的材料，直接结束
                    return
                end

                local cost = nil
                if doer.feather_l_value == nil then --提前加1，用来消耗
                    cost = 1
                else
                    cost = doer.feather_l_value + 1
                end
                for _,v in ipairs(lines) do
                    local value = v.line_l_value or LineMap[v.prefab]
                    if cost < value then --还未到消耗之时
                        break
                    end

                    if v.components.stackable == nil then
                        local costitem = doer.components.inventory:RemoveItem(v, nil, true)
                        if costitem then
                            costitem:Remove()
                        end
                        cost = cost - value
                    else
                        local num = v.components.stackable:StackSize()
                        for i = 1, num, 1 do
                            local costitem = doer.components.inventory:RemoveItem(v, nil, true)
                            if costitem then
                                costitem:Remove()
                            end
                            cost = cost - value
                            if cost < value then
                                break
                            end
                        end
                    end
                    if cost < value then
                        break
                    end
                end
                if cost <= 0 then
                    doer.feather_l_value = nil
                else
                    doer.feather_l_value = cost
                end

                local throwed = false
                local doerpos = doer:GetPosition()
                for _,v in ipairs(doer.sivfeathers_l) do
                    if v and v:IsValid() and not v.isbroken then
                        --如果在背包里，就删除自己
                        if v.components.inventoryitem ~= nil and v.components.inventoryitem:IsHeld() then
                            RemoveFromOnwer(v)
                        elseif v.components.projectilelegion ~= nil then
                            v.components.projectilelegion.isgoback = true
                            v.components.projectilelegion:Throw(v, doerpos, doer)
                            throwed = true
                        end
                    end
                end

                inst.linedoer = nil --拉回触发时，提前把这个数据清除，就不会解除玩家的数据了
                if not throwed then --如果没有能拉回来的羽毛，那就直接结算拉回的结果
                    local num = 0
                    local itemname = nil
                    for _,v in ipairs(doer.sivfeathers_l) do
                        if v and not v.isbroken then
                            num = num + 1
                            if not itemname then
                                itemname = v.prefab
                            end
                            if v:IsValid() then
                                v:Remove()
                            end
                        end
                    end
                    doer.sivfeathers_l = nil
                    if num > 0 and itemname then
                        local newitem = SpawnPrefab(itemname)
                        if newitem then
                            if num > 1 and newitem.components.stackable ~= nil then
                                newitem.components.stackable:SetStackSize(num)
                            end
                            newitem.Transform:SetPosition(doerpos:Get())

                            if not doer.components.inventory:Equip(newitem) then
                                doer.components.inventory:GiveItem(newitem)
                            end
                        end
                    else
                        RemoveLine(inst)
                    end
                end
            end
        end

        inst.task_remove = inst:DoTaskInTime(3.5, RemoveLine)

        return inst
    end,
    {
        Asset("ATLAS", "images/inventoryimages/siving_feather_line.xml"),
        Asset("IMAGE", "images/inventoryimages/siving_feather_line.tex"),
    },
    nil
))

--------------------------------------------------------------------------
--[[ 神木特防的特效 ]]
--------------------------------------------------------------------------

table.insert(prefs, Prefab(
    "siving_treeprotect_fx",
    function()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst:AddTag("FX")

        inst.AnimState:SetBank("terrariumchest_fx") --位于前面?
        inst.AnimState:SetBuild("siving_treeprotect_fx")
        inst.AnimState:PlayAnimation("idle_front", true)
        inst.AnimState:SetScale(1.2, 1.2)
        inst.AnimState:SetFinalOffset(1)

        if not TheNet:IsDedicated() then --位于后面?
            local fx_front = CreateEntity()
            fx_front.entity:AddTransform()
            fx_front.entity:AddAnimState()
            fx_front.entity:SetParent(inst.entity)

            fx_front:AddTag("FX")
            fx_front:AddTag("CLASSIFIED")

            fx_front.AnimState:SetBank("terrariumchest_fx")
            fx_front.AnimState:SetBuild("siving_treeprotect_fx")
            fx_front.AnimState:SetScale(1.2, 1.2)
            fx_front.AnimState:SetFinalOffset(-3)

            fx_front:DoTaskInTime(1, function(fx_front)
                fx_front.AnimState:PlayAnimation("idle_front", true)
            end)

            local btm = CreateEntity()
            btm.entity:AddTransform()
            btm.entity:AddAnimState()
            btm.entity:SetParent(inst.entity)

            btm:AddTag("FX")
            btm:AddTag("CLASSIFIED")

            btm.AnimState:SetBank("lavaarena_beetletaur_fx")
            btm.AnimState:SetBuild("lavaarena_beetletaur_fx")
            btm.AnimState:PlayAnimation("attack_fx3", true)
            btm.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
            btm.AnimState:SetLayer(LAYER_BACKGROUND)
            btm.AnimState:SetScale(0.15, 0.15)
            btm.AnimState:SetFinalOffset(-3)
        end

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false

        return inst
    end,
    {
        Asset("ANIM", "anim/terrariumchest_fx.zip"), --官方特拉瑞亚箱子的特效
        Asset("ANIM", "anim/lavaarena_beetletaur_fx.zip"),
        Asset("ANIM", "anim/siving_treeprotect_fx.zip")
    },
    nil
))

--------------------
--------------------

return unpack(prefs)
