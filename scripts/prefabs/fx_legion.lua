--------------------------------------------------------------------------
--[[ 无需网络组建功能的特效创建通用函数 ]]
--------------------------------------------------------------------------

local prefs = {}

local function MakeFx(data)
	table.insert(prefs, Prefab(
		data.name,
		function()
			local inst = CreateEntity()

			inst.entity:AddTransform()
			inst.entity:AddNetwork()

			--Dedicated server does not need to spawn the local fx
			if not TheNet:IsDedicated() then
				--Delay one frame so that we are positioned properly before starting the effect
				--or in case we are about to be removed
				inst:DoTaskInTime(0, function(proxy)
					local inst2 = CreateEntity()

					--[[Non-networked entity]]

					inst2.entity:AddTransform()
					inst2.entity:AddAnimState()
					inst2.entity:SetCanSleep(false)
					inst2.persists = false

                    inst2:AddTag("FX")

					local parent = proxy.entity:GetParent()
					if parent ~= nil then
						inst2.entity:SetParent(parent.entity)
					end
					inst2.Transform:SetFromProxy(proxy.GUID)

					if data.fn_anim ~= nil then
						data.fn_anim(inst2)
					end

                    if data.fn_remove ~= nil then
						data.fn_remove(inst2)
                    else
                        inst2:ListenForEvent("animover", inst2.Remove)
					end
				end)
			end

            inst:AddTag("FX")

            if data.fn_common ~= nil then
				data.fn_common(inst)
			end

			inst.entity:SetPristine()
			if not TheWorld.ismastersim then
				return inst
			end

			inst.persists = false
			inst:DoTaskInTime(1, inst.Remove)

			return inst
		end,
		data.assets,
		data.prefabs
	))
end

---------------
---------------

if CONFIGS_LEGION.FLOWERSPOWER then
    MakeFx({ --兰草花剑：飞溅花瓣
        name = "impact_orchid_fx",
        assets = {
            Asset("ANIM", "anim/impact_orchid.zip"),
            Asset("ANIM", "anim/impact.zip"), --官方击中特效动画模板
        },
        prefabs = nil,
        fn_common = nil,
        fn_anim = function(inst)
            inst.AnimState:SetBank("impact")
            inst.AnimState:SetBuild("impact_orchid")
            inst.AnimState:PlayAnimation("idle")
            inst.AnimState:SetFinalOffset(-1)
        end,
        fn_remove = nil,
    })
    MakeFx({ --兰草花剑：飞溅花瓣（粉色追猎皮肤）
        name = "impact_orchid_fx_disguiser",
        assets = {
            Asset("ANIM", "anim/lavaarena_heal_projectile.zip"), --官方的熔炉奶杖击中特效动画
            Asset("ANIM", "anim/skin/impact_orchid_fx_disguiser.zip"),
        },
        prefabs = nil,
        fn_common = nil,
        fn_anim = function(inst)
            inst.AnimState:SetBank("lavaarena_heal_projectile")
            inst.AnimState:SetBuild("impact_orchid_fx_disguiser")
            inst.AnimState:SetFinalOffset(-1)
            inst.AnimState:PlayAnimation("hit")
            inst.AnimState:SetScale(0.7, 0.7)
        end,
        fn_remove = nil,
    })
    MakeFx({ --永不凋零：损坏自己庇佑玩家的特效
        name = "neverfade_shield",
        assets = {
            Asset("ANIM", "anim/stalker_shield.zip"), --官方影织者护盾动画模板
            Asset("ANIM", "anim/neverfade_shield.zip"),
        },
        prefabs = nil,
        fn_common = nil,
        fn_anim = function(inst)
            inst.entity:AddSoundEmitter()
            inst:DoTaskInTime(0, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/stalker/shield")
            end)

            inst.AnimState:SetBank("stalker_shield")
            inst.AnimState:SetBuild("neverfade_shield")
            -- inst.AnimState:PlayAnimation("idle"..tostring(math.random(1, 3)))
            inst.AnimState:PlayAnimation("idle1")   --原图太大了，所以我去除了多余的贴图，只用了这个动画里的贴图
            -- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
            -- inst.AnimState:SetSortOrder(1)
            -- inst.AnimState:SetScale(1.5, 1.5)
            -- inst.AnimState:SetMultColour(140/255, 239/255, 255/255, 1)
            inst.AnimState:SetScale(Vector3(-1, 1, 1):Get())
            inst.AnimState:SetFinalOffset(2)
        end,
        fn_remove = nil,
    })

    -- MakeFx({ --施咒蔷薇：火花爆炸
    --     name = "rosorns_spell_fx",
    --     assets = {
    --         Asset("ANIM", "anim/lavaarena_firebomb.zip"), --官方熔炉燃烧瓶特效动画模板
    --     },
    --     prefabs = nil,
    --     fn_common = nil,
    --     fn_anim = function(inst)
    --         inst.AnimState:SetBank("lavaarena_firebomb")
    --         inst.AnimState:SetBuild("lavaarena_firebomb")
    --         inst.AnimState:PlayAnimation("hitfx")
    --         inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    --         inst.AnimState:SetFinalOffset(1)
    --         inst.AnimState:SetScale(0.7, 0.7)
    --     end,
    --     fn_remove = nil,
    -- })
    MakeFx({ --施咒蔷薇：火花爆炸2
        name = "rosorns_spell_fx",
        assets = {
            Asset("ANIM", "anim/lavaarena_heal_projectile.zip"), --官方熔炉燃烧瓶特效动画模板
        },
        prefabs = nil,
        fn_common = nil,
        fn_anim = function(inst)
            inst.AnimState:SetBank("lavaarena_heal_projectile")
            inst.AnimState:SetBuild("lavaarena_heal_projectile")
            inst.AnimState:PlayAnimation("hit")
            inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
            inst.AnimState:SetFinalOffset(1)
            -- inst.AnimState:SetScale(0.7, 0.7)
        end,
        fn_remove = nil,
    })
end

if CONFIGS_LEGION.PRAYFORRAIN then
    MakeFx({ --艾力冈的剑：燃血
        name = "agronssword_fx",
        assets = {
            Asset("ANIM", "anim/lavaarena_boarrior_fx.zip"),    --需要官方的动画模板
            Asset("ANIM", "anim/agronssword_fx.zip"),
        },
        prefabs = nil,
        fn_common = nil,
        fn_anim = function(inst)
            inst.AnimState:SetBank("lavaarena_boarrior_fx")
            inst.AnimState:SetBuild("agronssword_fx")
            inst.AnimState:PlayAnimation("ground_hit_1")
            inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
            inst.AnimState:SetFinalOffset(1)
        end,
        fn_remove = nil,
    })
    MakeFx({ --月折宝剑：凝血
        name = "refractedmoonlight_fx",
        assets = {
            Asset("ANIM", "anim/lavaarena_boarrior_fx.zip"),    --需要官方的动画模板
            Asset("ANIM", "anim/refractedmoonlight_fx.zip"),
        },
        prefabs = nil,
        fn_common = nil,
        fn_anim = function(inst)
            inst.AnimState:SetBank("lavaarena_boarrior_fx")
            inst.AnimState:SetBuild("refractedmoonlight_fx")
            inst.AnimState:PlayAnimation("ground_hit_1")
            inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
            inst.AnimState:SetFinalOffset(1)
        end,
        fn_remove = nil,
    })
end

if TUNING.LEGION_FLASHANDCRUSH then
    MakeFx({ --素白蘑菇帽：作物疾病的治愈时，消散的细菌
        name = "escapinggerms_fx",
        assets = {
            Asset("ANIM", "anim/lavaarena_boarrior_fx.zip"),    --需要官方的动画模板
            Asset("ANIM", "anim/agronssword_fx.zip"),           --套用已有的贴图
        },
        prefabs = nil,
        fn_common = nil,
        fn_anim = function(inst)
            inst.AnimState:SetBank("lavaarena_boarrior_fx")
            inst.AnimState:SetBuild("agronssword_fx")
            inst.AnimState:PlayAnimation("ground_hit_1")
            inst.AnimState:SetFinalOffset(1)
            inst.AnimState:SetMultColour(40/255, 40/255, 40/255, 1)
        end,
        fn_remove = nil,
    })
    MakeFx({ --素白蘑菇帽：玩家身上不断冒出的孢子
        name = "residualspores_fx",
        assets = {
            Asset("ANIM", "anim/wormwood_pollen_fx.zip"),    --需要官方的动画模板
            Asset("ANIM", "anim/residualspores_fx.zip"),
        },
        prefabs = nil,
        fn_common = nil,
        fn_anim = function(inst)
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
        fn_remove = nil,
    })

    MakeFx({ --芬布尔斧：击中时贴地扩散的闪电
        name = "fimbul_cracklebase_fx",
        assets = {
            Asset("ANIM", "anim/fimbul_static_fx.zip"),
            Asset("ANIM", "anim/lavaarena_hammer_attack_fx.zip"), --官方熔炉锤子大招特效动画模板
        },
        prefabs = nil,
        fn_common = nil,
        fn_anim = function(inst)
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
        fn_remove = nil,
    })
    -- MakeFx({ --芬布尔斧：重锤技能电光
    --     name = "fimbul_attack_fx",
    --     assets = {
    --         Asset("ANIM", "anim/fimbul_attack_fx.zip"),
    --         Asset("ANIM", "anim/lavaarena_hammer_attack_fx.zip"), --官方熔炉锤子大招特效动画模板
    --     },
    --     prefabs = nil,
    --     fn_common = nil,
    --     fn_anim = function(inst)
    --         inst.AnimState:SetBank("lavaarena_hammer_attack_fx")
    --         inst.AnimState:SetBuild("fimbul_attack_fx")
    --         inst.AnimState:PlayAnimation("crackle_hit")
    --         inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    --         inst.AnimState:SetSortOrder(1)
    --         inst.AnimState:SetScale(1.8, 1.8)
    --     end,
    --     fn_remove = nil,
    -- })
    MakeFx({ --重铸boss：远程飞溅攻击特效
        name = "fimbul_teleport_fx",
        assets = {
            Asset("ANIM", "anim/fimbul_teleport_fx.zip"),
            Asset("ANIM", "anim/lavaarena_creature_teleport.zip"), --官方熔炉敌人出场特效动画模板
        },
        prefabs = nil,
        fn_common = nil,
        fn_anim = function(inst)
            inst.AnimState:SetBank("lavaarena_creature_teleport")
            inst.AnimState:SetBuild("fimbul_teleport_fx")
            inst.AnimState:PlayAnimation("spawn_medium")
            inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
            inst.AnimState:SetSortOrder(1)

            inst.entity:AddSoundEmitter()
            inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/spark")
            inst.SoundEmitter:PlaySound("dontstarve/common/lava_arena/portal_player")
        end,
        fn_remove = nil,
    })
    MakeFx({ --重铸boss：战吼时的爆炸
        name = "fimbul_explode_fx",
        assets = {
            Asset("ANIM", "anim/fimbul_explode_fx.zip"),
            Asset("ANIM", "anim/explode.zip"), --官方爆炸特效动画模板
        },
        prefabs = nil,
        fn_common = function(inst)
            inst.Transform:SetFourFaced()
        end,
        fn_anim = function(inst)
            inst.AnimState:SetBank("explode")
            inst.AnimState:SetBuild("fimbul_explode_fx")
            inst.AnimState:PlayAnimation("small")
            inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
            inst.AnimState:SetLightOverride(1)
            inst.AnimState:SetScale(3, 3, 3)

            inst.entity:AddSoundEmitter()
            inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo")
        end,
        fn_remove = nil,
    })

    MakeFx({ --米格尔吉他：飘散的万寿菊花瓣
        name = "guitar_miguel_float_fx",
        assets = {
            Asset("ANIM", "anim/pine_needles.zip"), --官方砍树掉落松针特效
            Asset("ANIM", "anim/guitar_miguel_fx.zip"),
        },
        prefabs = nil,
        fn_common = nil,
        fn_anim = function(inst)
            inst.AnimState:SetBank("pine_needles")
            inst.AnimState:SetBuild("pine_needles")
            inst.AnimState:PlayAnimation(math.random() < 0.5 and "fall" or "chop")
            inst.AnimState:SetSortOrder(1)
            inst.Transform:SetScale(0.6, 0.6, 0.6)
            inst.AnimState:OverrideSymbol("needle", "guitar_miguel_fx", "needle")
            inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        end,
        fn_remove = nil,
    })
end

if TUNING.LEGION_DESERTSECRET then
    MakeFx({ --白木吉他：弹奏时的飘动音符
        name = "guitar_whitewood_doing_fx",
        assets = {
            Asset("ANIM", "anim/guitar_whitewood_doing_fx.zip"),
            Asset("ANIM", "anim/fx_wathgrithr_buff.zip"), --官方战歌特效动画模板
        },
        prefabs = nil,
        fn_common = nil,
        fn_anim = function(inst)
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
        fn_remove = nil,
    })
end

if CONFIGS_LEGION.LEGENDOFFALL then
    MakeFx({ --脱壳之翅：逃脱时的茸毛特效
        name = "boltwingout_fx",
        assets = {
            Asset("ANIM", "anim/lavaarena_heal_projectile.zip"), --官方的熔炉奶杖击中特效动画
            Asset("ANIM", "anim/boltwingout_fx.zip"),
        },
        prefabs = nil,
        fn_common = nil,
        fn_anim = function(inst)
            inst.AnimState:SetBank("lavaarena_heal_projectile")
            inst.AnimState:SetBuild("boltwingout_fx")
            inst.AnimState:SetFinalOffset(-1)
            inst.AnimState:PlayAnimation("hit")
        end,
        fn_remove = nil,
    })
    MakeFx({ --脱壳之翅：逃脱时的茸毛特效（枯叶飞舞皮肤）
        name = "boltwingout_fx_disguiser",
        assets = {
            Asset("ANIM", "anim/lavaarena_heal_projectile.zip"), --官方的熔炉奶杖击中特效动画
            Asset("ANIM", "anim/skin/boltwingout_fx_disguiser.zip"),
        },
        prefabs = nil,
        fn_common = nil,
        fn_anim = function(inst)
            inst.AnimState:SetBank("lavaarena_heal_projectile")
            inst.AnimState:SetBuild("boltwingout_fx_disguiser")
            inst.AnimState:SetFinalOffset(-1)
            inst.AnimState:PlayAnimation("hit")
        end,
        fn_remove = nil,
    })
end

---------------
---------------

return unpack(prefs)
