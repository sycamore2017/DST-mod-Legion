--------------------------------------------------------------------------
--[[ 无需网络组建功能的特效创建通用函数 ]]
--------------------------------------------------------------------------

local function MakeNonNetworkedFx(name, animfn, assets, prefabs, needsound, faces)
	local function AnimFn(proxy)
	    local inst = CreateEntity()

	    inst:AddTag("FX")
	    inst:AddTag("NOCLICK")
	    --[[Non-networked entity]]
	    inst.entity:SetCanSleep(false)
	    inst.persists = false

	    inst.entity:AddTransform()
        inst.entity:AddAnimState()
        if needsound then
            inst.entity:AddSoundEmitter()
        end

        local parent = proxy.entity:GetParent()
        if parent ~= nil then
            inst.entity:SetParent(parent.entity)
        end

	    inst.Transform:SetFromProxy(proxy.GUID)

	    if animfn ~= nil then
	    	animfn(inst)
	    end

	    inst:ListenForEvent("animover", inst.Remove)
	end

    local function Fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddNetwork()

        --Dedicated server does not need to spawn the local fx
        if not TheNet:IsDedicated() then
            --Delay one frame so that we are positioned properly before starting the effect
            --or in case we are about to be removed
            inst:DoTaskInTime(0, AnimFn)
        end

        if faces > 0 then
            if faces == 4 then
                inst.Transform:SetFourFaced()
            elseif faces == 8 then
                inst.Transform:SetEightFaced()
            elseif faces == 6 then
                inst.Transform:SetSixFaced()
            elseif faces == 2 then
                inst.Transform:SetTwoFaced()
            end
        end

        inst:AddTag("FX")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false
        inst:DoTaskInTime(1, inst.Remove)

        return inst
    end

    return Prefab(name, Fn, assets, prefabs)
end

---------------
---------------

local prefs = {}

if CONFIGS_LEGION.FLOWERSPOWER then
    table.insert(prefs, MakeNonNetworkedFx( --兰草花剑：飞溅花瓣
        "impact_orchid_fx",
        function(inst)
            inst.AnimState:SetBank("impact")
            inst.AnimState:SetBuild("impact_orchid")
            inst.AnimState:PlayAnimation("idle")
            inst.AnimState:SetFinalOffset(-1)
        end,
        {
            Asset("ANIM", "anim/impact_orchid.zip"),
            Asset("ANIM", "anim/impact.zip"), --官方击中特效动画模板
        },
        nil, false, 0
    ))
end

if CONFIGS_LEGION.PRAYFORRAIN then
    table.insert(prefs, MakeNonNetworkedFx( --艾力冈的剑：燃血
        "agronssword_fx",
        function(inst)
            inst.AnimState:SetBank("lavaarena_boarrior_fx")
            inst.AnimState:SetBuild("agronssword_fx")
            inst.AnimState:PlayAnimation("ground_hit_1")
            inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
            inst.AnimState:SetFinalOffset(1)
        end,
        {
            Asset("ANIM", "anim/lavaarena_boarrior_fx.zip"),    --需要官方的动画模板
            Asset("ANIM", "anim/agronssword_fx.zip"),
        },
        nil, false, 0
    ))
    table.insert(prefs, MakeNonNetworkedFx( --月折宝剑：凝血
        "refractedmoonlight_fx",
        function(inst)
            inst.AnimState:SetBank("lavaarena_boarrior_fx")
            inst.AnimState:SetBuild("refractedmoonlight_fx")
            inst.AnimState:PlayAnimation("ground_hit_1")
            inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
            inst.AnimState:SetFinalOffset(1)
        end,
        {
            Asset("ANIM", "anim/lavaarena_boarrior_fx.zip"),    --需要官方的动画模板
            Asset("ANIM", "anim/refractedmoonlight_fx.zip"),
        },
        nil, false, 0
    ))
end

if TUNING.LEGION_FLASHANDCRUSH then
    table.insert(prefs, MakeNonNetworkedFx( --素白蘑菇帽：作物疾病的治愈时，消散的细菌
        "escapinggerms_fx",
        function(inst)
            inst.AnimState:SetBank("lavaarena_boarrior_fx")
            inst.AnimState:SetBuild("agronssword_fx")
            inst.AnimState:PlayAnimation("ground_hit_1")
            inst.AnimState:SetFinalOffset(1)
            inst.AnimState:SetMultColour(40/255, 40/255, 40/255, 1)
        end,
        {
            Asset("ANIM", "anim/lavaarena_boarrior_fx.zip"),    --需要官方的动画模板
            Asset("ANIM", "anim/agronssword_fx.zip"),           --套用已有的贴图
        },
        nil, false, 0
    ))
    table.insert(prefs, MakeNonNetworkedFx( --素白蘑菇帽：玩家身上不断冒出的孢子
        "residualspores_fx",
        function(inst)
            inst.AnimState:SetBank("wormwood_pollen_fx")
            inst.AnimState:SetBuild("residualspores_fx")
            inst.AnimState:PlayAnimation("pollen"..math.random(1, 5))
            inst.AnimState:SetFinalOffset(2)

            local rand = math.random()
            if rand < 0.1 then
                inst.AnimState:SetMultColour(237/255, 170/255, 165/255, 1)
            elseif rand < 0.2 then
                inst.AnimState:SetMultColour(172/255, 237/255, 165/255, 1)
            elseif rand < 0.3 then
                inst.AnimState:SetMultColour(165/255, 187/255, 237/255, 1)
            end
        end,
        {
            Asset("ANIM", "anim/wormwood_pollen_fx.zip"),    --需要官方的动画模板
            Asset("ANIM", "anim/residualspores_fx.zip"),
        },
        nil, false, 0
    ))
    table.insert(prefs, MakeNonNetworkedFx( --芬布尔斧：击中时贴地扩散的闪电
        "fimbul_cracklebase_fx",
        function(inst)
            inst.AnimState:SetBank("lavaarena_hammer_attack_fx")
            inst.AnimState:SetBuild("fimbul_static_fx")
            inst.AnimState:PlayAnimation("crackle_projection")
            inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
            inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
            inst.AnimState:SetLayer(LAYER_BACKGROUND)
            inst.AnimState:SetSortOrder(3)
            inst.AnimState:SetScale(1.3, 1.3)
            inst.AnimState:SetMultColour(140/255, 239/255, 255/255, 1)
        end,
        {
            Asset("ANIM", "anim/fimbul_static_fx.zip"),
            Asset("ANIM", "anim/lavaarena_hammer_attack_fx.zip"), --官方熔炉锤子大招特效动画模板
        },
        nil, false, 0
    ))
    -- table.insert(prefs, MakeNonNetworkedFx( --芬布尔斧：重锤技能电光
    --     "fimbul_attack_fx",
    --     function(inst)
    --         inst.AnimState:SetBank("lavaarena_hammer_attack_fx")
    --         inst.AnimState:SetBuild("fimbul_attack_fx")
    --         inst.AnimState:PlayAnimation("crackle_hit")
    --         inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    --         inst.AnimState:SetSortOrder(1)
    --         inst.AnimState:SetScale(1.8, 1.8)
    --     end,
    --     {
    --         Asset("ANIM", "anim/fimbul_attack_fx.zip"),
    --         Asset("ANIM", "anim/lavaarena_hammer_attack_fx.zip"), --官方熔炉锤子大招特效动画模板
    --     },
    --     nil, false, 0
    -- ))
    table.insert(prefs, MakeNonNetworkedFx( --重铸boss：远程飞溅攻击特效
        "fimbul_teleport_fx",
        function(inst)
            inst.AnimState:SetBank("lavaarena_creature_teleport")
            inst.AnimState:SetBuild("fimbul_teleport_fx")
            inst.AnimState:PlayAnimation("spawn_medium")
            inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
            inst.AnimState:SetSortOrder(1)

            inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/spark")
            inst.SoundEmitter:PlaySound("dontstarve/common/lava_arena/portal_player")
        end,
        {
            Asset("ANIM", "anim/fimbul_teleport_fx.zip"),
            Asset("ANIM", "anim/lavaarena_creature_teleport.zip"), --官方熔炉敌人出场特效动画模板
        },
        nil, true, 0
    ))
    table.insert(prefs, MakeNonNetworkedFx( --重铸boss：战吼时的爆炸
        "fimbul_explode_fx",
        function(inst)
            inst.AnimState:SetBank("explode")
            inst.AnimState:SetBuild("fimbul_explode_fx")
            inst.AnimState:PlayAnimation("small")
            inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
            inst.AnimState:SetLightOverride(1)
            inst.AnimState:SetScale(3, 3, 3)

            inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo")
        end,
        {
            Asset("ANIM", "anim/fimbul_explode_fx.zip"),
            Asset("ANIM", "anim/explode.zip"), --官方爆炸特效动画模板
        },
        nil, true, 4
    ))
    table.insert(prefs, MakeNonNetworkedFx( --米格尔吉他：飘散的万寿菊花瓣
        "guitar_miguel_float_fx",
        function(inst)
            inst.AnimState:SetBank("pine_needles")
            inst.AnimState:SetBuild("pine_needles")
            inst.AnimState:PlayAnimation(math.random() < 0.5 and "fall" or "chop")
            inst.AnimState:SetSortOrder(1)
            inst.Transform:SetScale(0.6, 0.6, 0.6)
            inst.AnimState:OverrideSymbol("needle", "guitar_miguel_fx", "needle")
            inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        end,
        {
            Asset("ANIM", "anim/pine_needles.zip"), --官方砍树掉落松针特效
            Asset("ANIM", "anim/guitar_miguel_fx.zip"),
        },
        nil, false, 0
    ))
end

if TUNING.LEGION_DESERTSECRET then
    table.insert(prefs, MakeNonNetworkedFx( --白木吉他：弹奏时的飘动音符
        "guitar_whitewood_doing_fx",
        function(inst)
            local anims =
            {
                "fx_durability",
                "fx_fireresistance",
                "fx_healthgain",
                "fx_sanitygain",
            }
            inst.AnimState:SetBank("fx_wathgrithr_buff")
            inst.AnimState:SetBuild("fx_wathgrithr_buff")
            inst.AnimState:PlayAnimation(anims[math.random(#anims)])
            inst.AnimState:OverrideSymbol("fx_icon", "guitar_whitewood_doing_fx", "fx_icon")
            inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        end,
        {
            Asset("ANIM", "anim/guitar_whitewood_doing_fx.zip"),
            Asset("ANIM", "anim/fx_wathgrithr_buff.zip"), --官方战歌特效动画模板
        },
        nil, false, 0
    ))
end

---------------
---------------

return unpack(prefs)
