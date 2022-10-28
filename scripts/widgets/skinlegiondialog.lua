local Widget = require "widgets/widget"
local Screen = require "widgets/screen"
local AnimButton = require "widgets/animbutton"
local Text = require "widgets/text"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local TEMPLATES = require "widgets/templates"
local TEMPLATES2 = require "widgets/redux/templates"
local ItemImage = require "widgets/redux/itemimage"
local ScrollableList = require "widgets/scrollablelist"
local PopupDialogScreen = require "screens/redux/popupdialog"
local TrueScrollArea = require "widgets/truescrollarea"
local UIAnim = require "widgets/uianim"

local AnimModels = {
    "wilson", "willow", "wendy", "wolfgang", "wx78", "wickerbottom", "woodie", "waxwell", "wathgrithr",
    "webber", "winona", "warly"
}
local AnimNames = {
    "research", "emoteXL_sad", "emoteXL_annoyed", "emoteXL_happycheer", "emoteXL_waving4",
    "emoteXL_waving1", "emoteXL_waving2", "emoteXL_waving3", "emoteXL_loop_dance0", "emoteXL_bonesaw",
    "emoteXL_facepalm", "emoteXL_kiss", "emote_strikepose"
}

local function SetAnim_base(animstate, v)
    if v.bank then
        animstate:SetBank(v.bank)
    end
    if v.build then
        animstate:SetBuild(v.build)
    end
    if v.anim2 == nil then
        animstate:PlayAnimation(v.anim, v.isloop)
    else
        animstate:PlayAnimation(v.anim)
        animstate:PushAnimation(v.anim2, v.isloop)
    end
end
local function SetAnim_flowerbush(self, anim, data)
    local animstate = anim:GetAnimState()
    local tag = anim.tag_anim or 1
    local tag_fruit = nil
    if tag == 1 then --枯萎
        animstate:PlayAnimation("idle_to_dead")
        animstate:PushAnimation("dead", false)
    elseif tag == 2 then --成长中
        animstate:PlayAnimation("dead_to_idle")
        animstate:PushAnimation("idle", true)
        tag_fruit = 0
    elseif tag == 3 then --成熟3
        animstate:PlayAnimation("grow")
        animstate:PushAnimation("idle", true)
        tag_fruit = 3
    elseif tag == 4 then --成熟2
        animstate:PlayAnimation("grow")
        animstate:PushAnimation("idle", true)
        tag_fruit = 2
    elseif tag == 5 then --成熟1
        animstate:PlayAnimation("grow")
        animstate:PushAnimation("idle", true)
        tag_fruit = 1
        tag = 0
    else
        tag = 0
    end
    if tag_fruit == 0 then
        animstate:Hide("berries")
        animstate:Hide("berriesmore")
        animstate:Hide("berriesmost")
    elseif tag_fruit == 1 then
        animstate:Show("berries")
        animstate:Hide("berriesmore")
        animstate:Hide("berriesmost")
    elseif tag_fruit == 2 then
        animstate:Hide("berries")
        animstate:Show("berriesmore")
        animstate:Hide("berriesmost")
    elseif tag_fruit == 3 then
        animstate:Hide("berries")
        animstate:Hide("berriesmore")
        animstate:Show("berriesmost")
    end
    anim.tag_anim = tag + 1
end
local function SetAnim_flowerbush1(self, anim, data)
    local animstate = anim:GetAnimState()
    SetAnim_base(animstate, data)
    animstate:Hide("berries")
    animstate:Hide("berriesmore")
    anim.tag_anim = 4
end
local function SetAnim_flowerbush2(self, anim, data)
    local animstate = anim:GetAnimState()
    SetAnim_base(animstate, data)
    anim.tag_anim = 2
end

local function InitPlayerSymbol(animstate, data)
    animstate:Hide("ARM_carry")
    animstate:Hide("HAT")
    animstate:Hide("HAIR_HAT")
    animstate:Show("HAIR_NOHAT")
    animstate:Show("HAIR")
    animstate:Show("HEAD")
    animstate:Hide("HEAD_HAT")
    for _,v in ipairs(data.symbol) do
        animstate:OverrideSymbol(v.symbol, v.build, v.file)
        if v.type == 1 then --普通手持
            animstate:Show("ARM_carry")
            animstate:Hide("ARM_normal")
        elseif v.type == 2 then --普通戴帽
            animstate:Show("HAT")
            animstate:Show("HAIR_HAT")
            animstate:Hide("HAIR_NOHAT")
            animstate:Hide("HAIR")

            animstate:Hide("HEAD")
            animstate:Show("HEAD_HAT")
        elseif v.type == 3 then --开放戴帽
            animstate:Show("HAT")
            animstate:Hide("HAIR_HAT")
            animstate:Show("HAIR_NOHAT")
            animstate:Show("HAIR")

            animstate:Show("HEAD")
            animstate:Hide("HEAD_HAT")
        end
    end
end
local function SetAnim_player(self, anim, data)
    local animstate = anim:GetAnimState()
    local model = AnimModels[math.random( #AnimModels )]
    animstate:SetBank("wilson")
    animstate:SetBuild(model)
    local pushanim = AnimNames[math.random( #AnimNames )]
    -- print(pushanim)
    animstate:PlayAnimation(pushanim)
    animstate:PushAnimation("idle_loop", true)

    InitPlayerSymbol(animstate, data)

    anim.tag_anim = 2
end
local function SetAnim_player2(self, anim, data)
    -- local animstate = anim:GetAnimState()
    local tag = anim.tag_anim or 1
    if tag == 1 then
        anim:SetFacing(FACING_DOWN)
    elseif tag == 2 then
        anim:SetFacing(FACING_RIGHT)
    elseif tag == 3 then
        anim:SetFacing(FACING_UP)
    elseif tag == 4 then
        anim:SetFacing(FACING_LEFT)
        tag = 0
    else
        tag = 0
    end
    anim.tag_anim = tag + 1
end

local function SetAnim_shuck(self, anim, data)
    local animstate = anim:GetAnimState()
    local tag = anim.tag_anim or 2
    if tag == 1 then
        animstate:PlayAnimation("cocoon_small_hit")
        animstate:PushAnimation("cocoon_small", true)
    elseif tag == 2 then
        animstate:PlayAnimation("cocoon_dead", false)
        tag = 0
    else
        tag = 0
    end
    anim.tag_anim = tag + 1
end

local function SetAnim_heatrock(self, anim, data)
    local animstate = anim:GetAnimState()
    SetAnim_base(animstate, data)
    for _,v in ipairs(data.symbol) do
        animstate:OverrideSymbol(v.symbol, v.build, v.file)
    end
end
local function SetAnim_heatrock2(self, anim, data)
    local animstate = anim:GetAnimState()
    local tag
    if anim.tag_anim == nil then
        tag = data.tag_start or 1
    else
        tag = anim.tag_anim
    end
    animstate:PlayAnimation(tostring(tag), true)
    if tag >= 5 then
        tag = 0
    end
    anim.tag_anim = tag + 1
end

local width_skininfo = 260
local SkinData = {
    rosebush_marble = {
        height_anim = 160, --动画区域高度。默认150
        anims = {
            {
                bank = "berrybush", build = "rosebush_marble",
                anim = "shake", anim2 = "idle", isloop = true,
                fn_anim = SetAnim_flowerbush1, --fn(self, anim, data) 代替前面参数的自定义操作
                fn_click = SetAnim_flowerbush, --fn(self, anim, data) 设置点击事件
                x = -52, y = 5, scale = 0.32
            },
            {
                bank = "berrybush", build = "rosebush_marble",
                anim = "dead", anim2 = nil, isloop = false,
                fn_anim = SetAnim_flowerbush2,
                fn_click = SetAnim_flowerbush,
                x = 50, y = 5, scale = 0.32
            }
        }
    },
    rosorns_marble = {
        height_anim = 140, --带角色的高度最好是140起底
        anims = {
            {
                bank = "rosorns_marble", build = "rosorns_marble",
                anim = "idle", anim2 = nil, isloop = false,
                x = -83, y = 0, scale = 0.38
            },
            {
                bank = "rosorns_marble", build = "rosorns_marble",
                anim = "idle_cover", anim2 = nil, isloop = false,
                x = -25, y = 0, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "swap_object", build = "rosorns_marble", file = "swap_object", type = 1 },
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 45, y = 0, scale = 0.38
            },
            {
                bank = "boomerang", build = "rosorns_marble_fx",
                anim = "used", anim2 = nil, isloop = false,
                x = -50, y = -40, scale = 0.34
            }
        }
    },
    lilybush_marble = {
        height_anim = 110,
        anims = {
            {
                bank = "berrybush", build = "lilybush_marble",
                anim = "shake", anim2 = "idle", isloop = true,
                fn_anim = SetAnim_flowerbush1,
                fn_click = SetAnim_flowerbush,
                x = -42, y = 5, scale = 0.32
            },
            {
                bank = "berrybush", build = "lilybush_marble",
                anim = "dead", anim2 = nil, isloop = false,
                fn_anim = SetAnim_flowerbush2,
                fn_click = SetAnim_flowerbush,
                x = 40, y = 5, scale = 0.32
            }
        }
    },
    lileaves_marble = {
        height_anim = 145,
        anims = {
            {
                bank = "lileaves_marble", build = "lileaves_marble",
                anim = "idle", anim2 = nil, isloop = false,
                x = -75, y = 0, scale = 0.38
            },
            {
                bank = "lileaves_marble", build = "lileaves_marble",
                anim = "idle_cover", anim2 = nil, isloop = false,
                x = -30, y = 0, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "swap_object", build = "lileaves_marble", file = "swap_object", type = 1 },
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 45, y = 0, scale = 0.38
            }
        }
    },
    orchidbush_marble = {
        height_anim = 175,
        anims = {
            {
                bank = "berrybush", build = "orchidbush_marble",
                anim = "shake", anim2 = "idle", isloop = true,
                fn_anim = SetAnim_flowerbush1,
                fn_click = SetAnim_flowerbush,
                x = -47, y = 0, scale = 0.32
            },
            {
                bank = "berrybush", build = "orchidbush_marble",
                anim = "dead", anim2 = nil, isloop = false,
                fn_anim = SetAnim_flowerbush2,
                fn_click = SetAnim_flowerbush,
                x = 45, y = 0, scale = 0.32
            }
        }
    },
    orchitwigs_marble = {
        height_anim = 145,
        anims = {
            {
                bank = "orchitwigs_marble", build = "orchitwigs_marble",
                anim = "idle", anim2 = nil, isloop = false,
                x = -90, y = 0, scale = 0.38
            },
            {
                bank = "orchitwigs_marble", build = "orchitwigs_marble",
                anim = "idle_cover", anim2 = nil, isloop = false,
                x = -30, y = 0, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "swap_object", build = "orchitwigs_marble", file = "swap_object", type = 1 },
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 45, y = 0, scale = 0.38
            },
            {
                bank = "lavaarena_heal_projectile", build = "impact_orchid_fx_marble",
                anim = "hit", anim2 = nil, isloop = false,
                x = -50, y = 0, scale = 0.3
            }
        }
    },
    orchidbush_disguiser = {
        height_anim = 105,
        anims = {
            {
                bank = "berrybush2", build = "orchidbush_disguiser",
                anim = "shake", anim2 = "idle", isloop = true,
                fn_anim = SetAnim_flowerbush1,
                fn_click = SetAnim_flowerbush,
                x = -42, y = 0, scale = 0.32
            },
            {
                bank = "berrybush2", build = "orchidbush_disguiser",
                anim = "dead", anim2 = nil, isloop = false,
                fn_anim = SetAnim_flowerbush2,
                fn_click = SetAnim_flowerbush,
                x = 40, y = 0, scale = 0.32
            }
        }
    },
    orchitwigs_disguiser = {
        height_anim = 155,
        anims = {
            {
                bank = "orchitwigs_disguiser", build = "orchitwigs_disguiser",
                anim = "idle", anim2 = nil, isloop = false,
                x = -83, y = 0, scale = 0.38
            },
            {
                bank = "orchitwigs_disguiser", build = "orchitwigs_disguiser",
                anim = "idle_cover", anim2 = nil, isloop = false,
                x = -30, y = 0, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "swap_object", build = "orchitwigs_disguiser", file = "swap_object", type = 1 },
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 45, y = 0, scale = 0.38
            },
            {
                bank = "lavaarena_heal_projectile", build = "impact_orchid_fx_disguiser",
                anim = "hit", anim2 = nil, isloop = false,
                x = -50, y = 0, scale = 0.32
            }
        }
    },
    neverfade_thanks = {
        height_anim = 270,
        anims = {
            {
                bank = "butterfly", build = "neverfade_butterfly_thanks",
                anim = "take_off", anim2 = "flight_cycle", isloop = true,
                x = -90, y = 145, scale = 0.32
            },
            {
                bank = "neverfadebush_thanks", build = "neverfadebush_thanks",
                anim = "shake", anim2 = "idle", isloop = true,
                fn_anim = SetAnim_flowerbush1,
                fn_click = SetAnim_flowerbush,
                x = -42, y = 145, scale = 0.32
            },
            {
                bank = "neverfadebush_thanks", build = "neverfadebush_thanks",
                anim = "dead", anim2 = nil, isloop = false,
                fn_anim = SetAnim_flowerbush2,
                fn_click = SetAnim_flowerbush,
                x = 40, y = 145, scale = 0.32
            },
            {
                bank = "butterfly", build = "neverfade_butterfly_thanks",
                anim = "land", anim2 = "idle", isloop = true,
                x = 20, y = 145, scale = 0.32
            },
            {
                bank = "butterfly", build = "neverfade_butterfly_thanks",
                anim = "take_off", anim2 = "idle_flight_loop", isloop = true,
                x = 70, y = 145, scale = 0.32
            },
            {
                bank = "neverfade_thanks", build = "neverfade_thanks",
                anim = "idle", anim2 = nil, isloop = false,
                x = -90, y = 0, scale = 0.38
            },
            {
                bank = "neverfade_thanks", build = "neverfade_thanks",
                anim = "idle_cover", anim2 = nil, isloop = false,
                x = -30, y = 0, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "swap_object", build = "neverfade_thanks", file = "normal_swap", type = 1 },
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 45, y = 0, scale = 0.38
            }
        }
    },
    hat_lichen_emo_que = {
        height_anim = 145,
        anims = {
            {
                bank = "hat_lichen_emo_que", build = "hat_lichen_emo_que",
                anim = "idle", anim2 = nil, isloop = false,
                x = -45, y = 5, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "swap_hat", build = "hat_lichen_emo_que", file = "swap_hat", type = 3 },
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 45, y = 0, scale = 0.38
            }
        }
    },
    hat_lichen_disguiser = {
        height_anim = 150,
        anims = {
            {
                bank = "hat_lichen_disguiser", build = "hat_lichen_disguiser",
                anim = "idle", anim2 = nil, isloop = false,
                x = -45, y = 7, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "swap_hat", build = "hat_lichen_disguiser", file = "swap_hat", type = 2 },
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 45, y = 0, scale = 0.38
            }
        }
    },
    hat_cowboy_tvplay = {
        height_anim = 150,
        anims = {
            {
                bank = "hat_cowboy_tvplay", build = "hat_cowboy_tvplay",
                anim = "idle", anim2 = nil, isloop = false,
                x = -45, y = 10, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "swap_hat", build = "hat_cowboy_tvplay", file = "swap_hat", type = 2 },
                    { symbol = "swap_body", build = "hat_cowboy_tvplay", file = "swap_body", type = nil }
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 45, y = 0, scale = 0.38
            }
        }
    },
    boltwingout_disguiser = {
        height_anim = 140,
        anims = {
            {
                bank = "spider_cocoon", build = "boltwingout_shuck_disguiser",
                anim = "cocoon_small_hit", anim2 = "cocoon_small", isloop = true,
                fn_click = SetAnim_shuck,
                x = -10, y = 10, scale = 0.35
            },
            {
                bank = "boltwingout_disguiser", build = "boltwingout_disguiser",
                anim = "idle", anim2 = nil, isloop = false,
                x = -70, y = 10, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "swap_body", build = "boltwingout_disguiser", file = "swap_body", type = nil }
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 70, y = 0, scale = 0.38
            },
            {
                bank = "lavaarena_heal_projectile", build = "boltwingout_fx_disguiser",
                anim = "hit", anim2 = nil, isloop = false,
                x = -10, y = 0, scale = 0.3
            },
        }
    },
    fishhomingtool_awesome_thanks = {
        height_anim = 280,
        anims = {
            {
                bank = "fishhomingtool_normal_thanks", build = "fishhomingtool_normal_thanks",
                anim = "idle", anim2 = nil, isloop = false,
                x = -70, y = 210, scale = 0.38
            },
            {
                bank = "fishhomingtool_awesome_thanks", build = "fishhomingtool_awesome_thanks",
                anim = "idle", anim2 = nil, isloop = false,
                x = -25, y = 150, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "swap_object", build = "fishhomingtool_awesome_thanks", file = "swap", type = 1 }
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 45, y = 140, scale = 0.38
            },
            {
                bank = "fishhomingbait_thanks", build = "fishhomingbait_thanks",
                anim = "idle2", anim2 = nil, isloop = false,
                x = -80, y = 75, scale = 0.38
            },
            {
                bank = "fishhomingbait_thanks", build = "fishhomingbait_thanks",
                anim = "idle3", anim2 = nil, isloop = false,
                x = -30, y = 55, scale = 0.38
            },
            {
                bank = "fishhomingbait_thanks", build = "fishhomingbait_thanks",
                anim = "idle1", anim2 = nil, isloop = false,
                x = -65, y = 5, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "swap_object", build = "fishhomingbait_thanks", file = "swap2", type = 1 }
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 45, y = 0, scale = 0.38
            }
        }
    },
    shield_l_log_emo_pride = {
        height_anim = 140,
        anims = {
            {
                bank = "shield_l_log_emo_pride", build = "shield_l_log_emo_pride",
                anim = "idle", anim2 = nil, isloop = false,
                x = -45, y = 3, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "lantern_overlay", build = "shield_l_log_emo_pride", file = "swap_shield", type = 1 }
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 45, y = 0, scale = 0.38
            },
            {
                bank = "lavaarena_beetletaur_fx", build = "lavaarena_beetletaur_fx",
                anim = "defend_fx", anim2 = nil, isloop = false,
                x = -50, y = 30, scale = 0.22
            }
        }
    },
    shield_l_log_emo_fist = {
        height_anim = 140,
        anims = {
            {
                bank = "shield_l_log_emo_fist", build = "shield_l_log_emo_fist",
                anim = "idle", anim2 = nil, isloop = false,
                x = -45, y = 3, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "lantern_overlay", build = "shield_l_log_emo_fist", file = "swap_shield", type = 1 }
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 45, y = 0, scale = 0.38
            },
            {
                bank = "lavaarena_beetletaur_fx", build = "lavaarena_beetletaur_fx",
                anim = "defend_fx", anim2 = nil, isloop = false,
                x = -45, y = 27, scale = 0.22
            }
        }
    },
    shield_l_log_era = {
        height_anim = 140,
        anims = {
            {
                bank = "shield_l_log_era", build = "shield_l_log_era",
                anim = "idle", anim2 = nil, isloop = false,
                x = -45, y = 1, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "lantern_overlay", build = "shield_l_log_era", file = "swap_shield", type = 1 }
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 45, y = 0, scale = 0.38
            },
            {
                bank = "lavaarena_beetletaur_fx", build = "lavaarena_beetletaur_fx",
                anim = "defend_fx", anim2 = nil, isloop = false,
                x = -45, y = 30, scale = 0.22
            }
        }
    },
    shield_l_sand_era = {
        height_anim = 140,
        anims = {
            {
                bank = "shield_l_sand_era", build = "shield_l_sand_era",
                anim = "idle", anim2 = nil, isloop = false,
                x = -45, y = 1, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "lantern_overlay", build = "shield_l_sand_era", file = "swap_shield", type = 1 }
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 45, y = 0, scale = 0.38
            },
            {
                bank = "lavaarena_beetletaur_fx", build = "lavaarena_beetletaur_fx",
                anim = "defend_fx", anim2 = nil, isloop = false,
                x = -45, y = 30, scale = 0.22
            }
        }
    },
    shield_l_sand_op = {
        height_anim = 140,
        anims = {
            {
                bank = "shield_l_sand_op", build = "shield_l_sand_op",
                anim = "idle", anim2 = nil, isloop = false,
                x = -45, y = 3, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "lantern_overlay", build = "shield_l_sand_op", file = "swap_shield", type = 1 }
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 45, y = 0, scale = 0.38
            },
            {
                bank = "lavaarena_beetletaur_fx", build = "lavaarena_beetletaur_fx",
                anim = "defend_fx", anim2 = nil, isloop = false,
                x = -40, y = 33, scale = 0.22
            }
        }
    },
    icire_rock_era = {
        height_anim = 170,
        anims = {
            { --上
                bank = "heat_rock", build = "heat_rock",
                anim = "3", anim2 = nil, isloop = true,
                tag_start = 4, symbol = {
                    { symbol = "rock", build = "icire_rock_era", file = "rock" },
                    { symbol = "shadow", build = "icire_rock_era", file = "shadow" }
                },
                fn_anim = SetAnim_heatrock,
                fn_click = SetAnim_heatrock2,
                x = 0, y = 13+90, scale = 0.38
            },
            { --右1
                bank = "heat_rock", build = "heat_rock",
                anim = "4", anim2 = nil, isloop = true,
                tag_start = 5, symbol = {
                    { symbol = "rock", build = "icire_rock_era", file = "rock" },
                    { symbol = "shadow", build = "icire_rock_era", file = "shadow" }
                },
                fn_anim = SetAnim_heatrock,
                fn_click = SetAnim_heatrock2,
                x = 70, y = 13+65, scale = 0.38
            },
            { --右2
                bank = "heat_rock", build = "heat_rock",
                anim = "5", anim2 = nil, isloop = true,
                tag_start = 1, symbol = {
                    { symbol = "rock", build = "icire_rock_era", file = "rock" },
                    { symbol = "shadow", build = "icire_rock_era", file = "shadow" }
                },
                fn_anim = SetAnim_heatrock,
                fn_click = SetAnim_heatrock2,
                x = 42, y = 13, scale = 0.38
            },
            { --左1
                bank = "heat_rock", build = "heat_rock",
                anim = "2", anim2 = nil, isloop = true,
                tag_start = 3, symbol = {
                    { symbol = "rock", build = "icire_rock_era", file = "rock" },
                    { symbol = "shadow", build = "icire_rock_era", file = "shadow" }
                },
                fn_anim = SetAnim_heatrock,
                fn_click = SetAnim_heatrock2,
                x = -70, y = 13+65, scale = 0.38
            },
            { --左2
                bank = "heat_rock", build = "heat_rock",
                anim = "1", anim2 = nil, isloop = true,
                tag_start = 2, symbol = {
                    { symbol = "rock", build = "icire_rock_era", file = "rock" },
                    { symbol = "shadow", build = "icire_rock_era", file = "shadow" }
                },
                fn_anim = SetAnim_heatrock,
                fn_click = SetAnim_heatrock2,
                x = -42, y = 13, scale = 0.38
            }
        }
    },
    icire_rock_collector = {
        height_anim = 160,
        anims = {
            { --上
                bank = "icire_rock_collector", build = "icire_rock_collector",
                anim = "3", anim2 = nil, isloop = true,
                tag_start = 4,
                fn_click = SetAnim_heatrock2,
                x = 0, y = 13+90, scale = 0.38
            },
            { --右1
                bank = "icire_rock_collector", build = "icire_rock_collector",
                anim = "4", anim2 = nil, isloop = true,
                tag_start = 5,
                fn_click = SetAnim_heatrock2,
                x = 70, y = 13+65, scale = 0.38
            },
            { --右2
                bank = "icire_rock_collector", build = "icire_rock_collector",
                anim = "5", anim2 = nil, isloop = true,
                tag_start = 1,
                fn_click = SetAnim_heatrock2,
                x = 42, y = 13, scale = 0.38
            },
            { --左1
                bank = "icire_rock_collector", build = "icire_rock_collector",
                anim = "2", anim2 = nil, isloop = true,
                tag_start = 3,
                fn_click = SetAnim_heatrock2,
                x = -70, y = 13+65, scale = 0.38
            },
            { --左2
                bank = "icire_rock_collector", build = "icire_rock_collector",
                anim = "1", anim2 = nil, isloop = true,
                tag_start = 2,
                fn_click = SetAnim_heatrock2,
                x = -42, y = 13, scale = 0.38
            }
        }
    },
    lilybush_era = {
        height_anim = 280,
        anims = {
            {
                bank = "berrybush2", build = "lilybush_era",
                anim = "dead", anim2 = nil, isloop = false,
                fn_anim = SetAnim_flowerbush2,
                fn_click = SetAnim_flowerbush,
                x = 65, y = 138, scale = 0.32
            },
            {
                bank = "berrybush2", build = "lilybush_era",
                anim = "shake", anim2 = "idle", isloop = true,
                fn_anim = SetAnim_flowerbush1,
                fn_click = SetAnim_flowerbush,
                x = -27, y = 138, scale = 0.32
            },
            {
                bank = "lileaves_era", build = "lileaves_era",
                anim = "idle", anim2 = nil, isloop = false,
                x = -83, y = 0, scale = 0.38
            },
            {
                bank = "lileaves_era", build = "lileaves_era",
                anim = "idle_cover", anim2 = nil, isloop = false,
                x = -30, y = 0, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "swap_object", build = "lileaves_era", file = "swap_object", type = 1 },
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 45, y = 0, scale = 0.38
            }
        }
    },
    triplegoldenshovelaxe_era = {
        height_anim = 265,
        anims = {
            {
                bank = "tripleshovelaxe_era", build = "tripleshovelaxe_era",
                anim = "idle", anim2 = nil, isloop = false,
                x = -40, y = 130, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "swap_object", build = "tripleshovelaxe_era", file = "swap", type = 1 },
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 35, y = 130, scale = 0.38
            },
            {
                bank = "triplegoldenshovelaxe_era", build = "triplegoldenshovelaxe_era",
                anim = "idle", anim2 = nil, isloop = false,
                x = -40, y = 0, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "swap_object", build = "triplegoldenshovelaxe_era", file = "swap", type = 1 },
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 35, y = 0, scale = 0.38
            }
        }
    },
    rosebush_collector = {
        height_anim = 360,
        anims = {
            {
                bank = "berrybush", build = "rosebush_collector",
                anim = "dead", anim2 = nil, isloop = false,
                fn_anim = SetAnim_flowerbush2,
                fn_click = SetAnim_flowerbush,
                x = 55, y = 143, scale = 0.28
            },
            {
                bank = "berrybush", build = "rosebush_collector",
                anim = "shake", anim2 = "idle", isloop = true,
                fn_anim = SetAnim_flowerbush1,
                fn_click = SetAnim_flowerbush,
                x = -40, y = 143, scale = 0.28
            },
            {
                bank = "rosorns_collector", build = "rosorns_collector",
                anim = "idle", anim2 = nil, isloop = true,
                x = -83, y = 0, scale = 0.38
            },
            {
                bank = "rosorns_collector", build = "rosorns_collector",
                anim = "idle_cover", anim2 = nil, isloop = true,
                x = -30, y = 0, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "swap_object", build = "rosorns_collector", file = "swap_object", type = 1 },
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 45, y = 0, scale = 0.38
            },
            {
                bank = "lavaarena_heal_projectile", build = "rosorns_collector_fx",
                anim = "cast", anim2 = nil, isloop = false,
                x = -30, y = 15, scale = 0.4
            }
        }
    },
    fimbul_axe_collector = {
        height_anim = 265,
        anims = {
            {
                bank = "fimbul_axe_collector", build = "fimbul_axe_collector",
                anim = "idle", anim2 = nil, isloop = false,
                x = -70, y = 130, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "swap_object", build = "fimbul_axe_collector", file = "swap_base", type = 1 },
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 25, y = 130, scale = 0.38
            },
            {
                bank = "fimbul_axe_collector", build = "fimbul_axe_collector",
                anim = "spin_loop", anim2 = nil, isloop = true,
                x = -50, y = 0, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "swap_object", build = "fimbul_axe_collector", file = "swap_throw", type = 1 },
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 35, y = 0, scale = 0.38
            },
            {
                bank = "fimbul_axe_collector3_fx", build = "fimbul_axe_collector3_fx",
                anim = "idle", anim2 = "nil", isloop = false,
                x = -50, y = 0, scale = 0.4
            },
            {
                bank = "explode", build = "fimbul_axe_collector2_fx",
                anim = "small_firecrackers", anim2 = nil, isloop = false,
                x = -50, y = -15, scale = 0.4
            },
            {
                bank = "fimbul_axe_collector", build = "fimbul_axe_collector",
                anim = "star1", anim2 = "nil", isloop = false,
                x = -20, y = 100, scale = 0.4
            },
            {
                bank = "fimbul_axe_collector", build = "fimbul_axe_collector",
                anim = "star3", anim2 = "nil", isloop = false,
                x = -70, y = 80, scale = 0.4
            },
            {
                bank = "fimbul_axe_collector", build = "fimbul_axe_collector",
                anim = "star2", anim2 = "nil", isloop = false,
                x = -55, y = 60, scale = 0.4
            }
        }
    },
    siving_turn_collector = {
        height_anim = 200,
        anims = {
            {
                bank = "siving_turn_collector", build = "siving_turn_collector",
                anim = "on", anim2 = nil, isloop = true,
                fn_anim = function(self, anim, data)
                    local animstate = anim:GetAnimState()
                    animstate:SetBank(data.bank)
                    animstate:SetBuild(data.bank)
                    animstate:PlayAnimation(data.anim, data.isloop)
                end,
                x = -60, y = 8, scale = 0.3
            },
            
        }
    },
}

local function GetCollection(skin)
    local data = SKINS_LEGION[skin]
    if data ~= nil and data.string ~= nil and data.string.collection ~= nil then
        return STRINGS.SKIN_LEGION.COLLECTION[data.string.collection]
    else
        return STRINGS.SKIN_LEGION.COLLECTION.UNKNOWN
    end
end

local function GetDescription(skin)
    local data = SKINS_LEGION[skin]
    if data ~= nil and data.string ~= nil and data.string.description ~= nil then
        return data.string.description
    else
        return STRINGS.SKIN_LEGION.UNKNOWN_STORY
    end
end

local function GetAccess(skin)
    local data = SKINS_LEGION[skin]
    if data ~= nil and data.string ~= nil and data.string.access ~= nil then
        return STRINGS.SKIN_LEGION.ACCESS[data.string.access]
    else
        return STRINGS.SKIN_LEGION.ACCESS.UNKNOWN
    end
end

local function GetDescItem(skin)
    local data = SKINS_LEGION[skin]
    if data ~= nil and data.string ~= nil and data.string.descitem ~= nil then
        return data.string.descitem
    else
        return ""
    end
end

local function DoRpc(type, data)
    if data == nil then
        SendModRPCToServer(GetModRPC("LegionSkined", "BarHandle"), type, nil)
        return
    end

    local success, result  = pcall(json.encode, data)
	if success then
        SendModRPCToServer(GetModRPC("LegionSkined", "BarHandle"), type, result)
	end
end

function PushPopupDialog(self, title, message, buttontext, fn)
    if self.context_popup ~= nil then
        TheFrontEnd:PopScreen(self.context_popup)
    end

    self.context_popup = PopupDialogScreen(title, message, {
        {
            text = buttontext or STRINGS.UI.POPUPDIALOG.OK,
            cb = function()
                TheFrontEnd:PopScreen(self.context_popup)
                self.context_popup = nil
                if fn then fn() end
            end
        }
    })
    TheFrontEnd:PushScreen(self.context_popup)

    local screen = TheFrontEnd:GetActiveScreen()
    if screen then screen:Enable() end
end

local SkinLegionDialog = Class(Widget, function(self, owner)
	Widget._ctor(self, "SkinLegionDialog")

    if not owner or owner.userid == nil or owner.userid == "" then
        self:Kill()
        return
    end
    self.owner = owner

    self.proot = self:AddChild(Widget("ROOT"))
    self.proot:SetPosition(0, 0, 0)

    --整体背景图
    self.bg = self.proot:AddChild(TEMPLATES.CenterPanel(nil, nil, true))
    self.bg:SetScale(.71, .85)
    self.bg:SetPosition(-50, 0)

    --cdk输入框(tip: 皮肤获取通道删除)
    -- self.input_cdk = self.proot:AddChild(TEMPLATES2.StandardSingleLineTextEntry(nil, 200, 40))
    -- self.input_cdk.textbox:SetTextLengthLimit(20)
    -- self.input_cdk.textbox:EnableWordWrap(false)
    -- self.input_cdk.textbox:EnableScrollEditWindow(true)
    -- self.input_cdk.textbox:SetTextPrompt(STRINGS.SKIN_LEGION.UI_INPUT_CDK, UICOLOURS.GREY)
    -- self.input_cdk.textbox.prompt:SetHAlign(ANCHOR_MIDDLE)
    -- self.input_cdk.textbox:SetHAlign(ANCHOR_MIDDLE)
    -- self.input_cdk.textbox:SetCharacterFilter("-0123456789QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm")
    -- self.input_cdk:SetOnGainFocus( function() self.input_cdk.textbox:OnGainFocus() end )
    -- self.input_cdk:SetOnLoseFocus( function() self.input_cdk.textbox:OnLoseFocus() end )
    -- self.input_cdk:SetPosition(140, -130)
    -- self.input_cdk.focus_forward = self.input_cdk.textbox

    --cdk确认输入按钮(tip: 皮肤获取通道删除)
    -- self.button_cdk = self.proot:AddChild(
    --     ImageButton("images/global_redux.xml", "button_carny_long_normal.tex",
    --         "button_carny_long_hover.tex", "button_carny_long_disabled.tex", "button_carny_long_down.tex")
    -- )
    -- self.button_cdk.image:SetScale(.3, .35)
    -- self.button_cdk:SetFont(CHATFONT)
    -- self.button_cdk:SetPosition(140, -165)
    -- self.button_cdk.text:SetColour(0,0,0,1)
    -- self.button_cdk:SetTextSize(20)
    -- self.button_cdk:SetText(STRINGS.UI.MAINSCREEN.REDEEM)
    -- self.button_cdk:SetOnClick(function()
    --     if self.loadtag_cdk == 0 then
    --         return
    --     end

    --     local cdk = self.input_cdk.textbox:GetString()
    --     if cdk == nil or cdk == "" or cdk:utf8len() <= 6 then
    --         PushPopupDialog(self, "轻声提醒", "请输入正确的兑换码。", "知道啦", nil)
    --         return
    --     end
    --     self:SetCdkState(0, nil) --后续的状态更新需要服务端返回结果过来
    --     DoRpc(2, { cdk = cdk })
    -- end)

    local x_btn = -60
    local y_btn = -248

    --关闭弹窗按钮
    self.button_close = self.proot:AddChild(TEMPLATES.SmallButton(STRINGS.UI.PLAYER_AVATAR.CLOSE, 26, .5, function() self:Close() end))
    self.button_close:SetPosition(x_btn, y_btn)

    --主动刷新皮肤按钮
    self.button_regetskins = self.proot:AddChild(TEMPLATES.IconButton(
        "images/button_icons.xml", "refresh.tex", "刷新我的皮肤", false, false,
        function()
            DoRpc(1, nil)
        end,
        nil, "self_inspect_mod.tex"
    ))
    self.button_regetskins.icon:SetScale(.15)
    self.button_regetskins.icon:SetPosition(-5, 6)
    self.button_regetskins:SetScale(0.65)
    self.button_regetskins:SetPosition(x_btn+110, y_btn-5)

    self.selected_item = nil
    self.context_popup = nil
    self.items = nil

    self:ResetItems()

	-- self.default_focus = self.menu
end)

function SkinLegionDialog:SetCdkState(state, poptype)
    self.loadtag_cdk = state
	if state == 0 then
        self.button_cdk:SetText(STRINGS.SKIN_LEGION.UI_LOAD_CDK)
    elseif state == 1 then
        self.button_cdk:SetText(STRINGS.UI.MAINSCREEN.REDEEM)
        self.input_cdk.textbox:SetString("")

        if poptype then
            PushPopupDialog(self, "感谢支持！", "兑换成功！来，试试看。", "好的", nil)
        end
    elseif state == -1 then
        self.button_cdk:SetText(STRINGS.UI.MAINSCREEN.REDEEM)

        if poptype then
            local str = nil
            if poptype == -1 or poptype == 4 then
                str = "兑换失败！请检查兑换码、网络、已有皮肤情况。实在不行请联系作者。"
            elseif poptype == 2 then
                str = "操作太快了，请等几秒再试试。"
            elseif poptype == 3 then
                str = "服务器调用失败，请联系作者反馈情况。"
            else
                str = "未知情况["..tostring(poptype).."]：请联系作者反馈情况。"
            end
            PushPopupDialog(self, "小声提醒", str, "知道了", nil)
        end
    else
        self.button_cdk:SetText(STRINGS.UI.MAINSCREEN.REDEEM)
        self.input_cdk.textbox:SetString("")
    end
end

function SkinLegionDialog:ResetItems()
    --记下之前选中的皮肤
	local selected_skin = self.selected_item ~= nil and self.selected_item.item_key or nil
    local selected_item = nil

    --初始化皮肤项
    local items = {}
    local myskins = SKINS_CACHE_L[self.owner.userid]
    for idx,skinname in pairs(SKIN_IDX_LEGION) do
        local v = SKINS_LEGION[skinname]
        if v ~= nil then
            if not v.noshopshow then
                local isowned = false
                if v.skin_id == "freeskins" or (myskins ~= nil and myskins[skinname]) then
                    isowned = true
                end
                if not v.onlyownedshow or isowned then
                    local item = {
                        item_key = skinname,
                        item_id = skinname, --(不管)
                        owned_count = 0, --已拥有数量(不管)
                        isnew = false, --是否新皮肤(不管)
                        isfocused = false, --是否处于被鼠标移入状态(不管)
                        isselected = false, --是否处于选中状态
                        isowned = isowned, --是否拥有该皮肤
                        isunlockable = v.string.access == "DONATE", --是否可解锁
                        idx = nil,
                        context = nil, --存下的组件
                    }
                    table.insert(items, item)
                    -- table.insert(items, item)

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

function SkinLegionDialog:SetItems(itemsnew)
    --先清除已有数据
    self:SetItemInfo()
    if self.option_items ~= nil then
        self.option_items:Kill()
    end
    self.items_list = {} --皮肤组，1组5个ui
    self.items = itemsnew

    local start_x = -309
    local itemcount = 0
    local x = start_x
    local item_w = nil
    for k, v in pairs(self.items) do
        if item_w == nil then
            item_w = self.proot:AddChild(Widget("SkinItem"..k))
            table.insert(self.items_list, item_w)
        end
        local a = item_w:AddChild(ItemImage(nil, {
            show_hover_text = true
        }))
        a:ApplyDataToWidget(self, v, nil)
        a.frame:SetAge(v.isnew)
        v.context = a --记下皮肤项对应的ui，方便后续更改
        -- a.warn_marker:Show()
        -- if a.frame.age_text then
        --     a.frame.age_text:SetString("拥有")
        -- end

        --是否已选：会在图标右下方表上“√”
        --是否拥有该皮肤：没有这个皮肤会是暗淡的色调
        --是否处于鼠标移入状态：会在边角上显示金色线
        --是否可解锁：未拥有且可解锁时，会在左下方显示“锁”的图案
        --是否该dlc拥有：不懂，为false即可
        a:SetInteractionState(v.isselected, v.isowned, v.isfocused, v.isunlockable, false)
        a:SetPosition(x, 0)

        if a.SetOnClick then
            a:SetOnClick(function()
                self:SetItemInfo(v)
            end)
        end

        itemcount = itemcount + 1
        v.idx = itemcount
        if itemcount%5 == 0 then --一排最多摆5个皮肤
            item_w = nil
            x = start_x
        else
            x = x + 78
        end
    end

    self.option_items = self.proot:AddChild(ScrollableList(self.items_list, 55, 444, 73, 3)) --总高度=(73+1)x展示行数
    self.option_items:SetPosition(6, -1)
end

function SkinLegionDialog:SetItemInfo(item)
    if item == nil then
        if self.selected_item ~= nil then
            self.selected_item.isselected = false
            self:SetInteractionState(self.selected_item)
            self.selected_item = nil
        end

        if self.panel_iteminfo ~= nil then
            self.panel_iteminfo:Kill()
            self.panel_iteminfo = nil
            self.label_skinname = nil
            self.label_skinrarity = nil
            self.horizontal_line = nil
            self.scroll_skindesc = nil
        end
    else
        if self.selected_item ~= nil then
            if self.selected_item.idx == item.idx then
                return
            end
            self.selected_item.isselected = false
            self:SetInteractionState(self.selected_item)
        end
        item.isselected = true
        self:SetInteractionState(item)
        self.selected_item = item

        if self.panel_iteminfo == nil then
            self.panel_iteminfo = self.proot:AddChild(Widget("SkinItemInfo"))
            self.panel_iteminfo:SetPosition(168, 224)
        end

        --皮肤名称
        if self.label_skinname == nil then
            self.label_skinname = self.panel_iteminfo:AddChild(Text(UIFONT, 30))
            self.label_skinname:SetColour(UICOLOURS.GOLD_SELECTED)
            -- self.label_skinname:SetHAlign(ANCHOR_LEFT)
            -- self.label_skinname:SetRegionSize(180, 30)
            self.label_skinname:SetPosition(0, 0)
        end
        self.label_skinname:SetString(GetSkinName(item.item_key))

        --皮肤品质
        if self.label_skinrarity == nil then
            self.label_skinrarity = self.panel_iteminfo:AddChild(Text(HEADERFONT, 21))
            -- self.label_skinrarity:SetHAlign(ANCHOR_LEFT)
            -- self.label_skinrarity:SetRegionSize(180, 20)
            self.label_skinrarity:SetPosition(0, -22)
        end
        self.label_skinrarity:SetString(GetCollection(item.item_key))
        self.label_skinrarity:SetColour(GetColorForItem(item.item_key))

        --标题分割线
        if self.horizontal_line == nil then
            self.horizontal_line = self.panel_iteminfo:AddChild(Image("images/quagmire_recipebook.xml", "quagmire_recipe_line_break.tex"))
            self.horizontal_line:SetScale(.6, .3)
            self.horizontal_line:SetPosition(0, -38)
        end

        --滑动区域
        if self.scroll_skindesc ~= nil then
            self.scroll_skindesc:Kill()
        end
        self.scroll_skindesc = self.panel_iteminfo:AddChild( self:BuildSkinDesc(item) )
        self.scroll_skindesc:SetPosition(-128, -242)

        --获取按钮(tip: 皮肤获取通道删除)
        --[[
        if item.isowned then
            if self.button_access ~= nil then
                self.button_access:Kill()
                self.button_access = nil
            end
        else
            if item.isunlockable then
                if self.button_access == nil then
                    self.button_access = self.panel_iteminfo:AddChild(
                        ImageButton("images/global_redux.xml", "button_carny_long_normal.tex",
                            "button_carny_long_hover.tex", "button_carny_long_disabled.tex", "button_carny_long_down.tex")
                    )
                    self.button_access.image:SetScale(.2, .35)
                    self.button_access:SetFont(CHATFONT)
                    self.button_access:SetPosition(50, -212)
                    self.button_access.text:SetColour(0,0,0,1)
                    self.button_access:SetTextSize(20)
                    self.button_access:SetText(STRINGS.SKIN_LEGION.UI_ACCESS)
                    self.button_access:SetOnClick(function()
                        local skin = SKINS_LEGION[item.item_key]
                        if skin ~= nil then
                            VisitURL("https://wap.fireleaves.cn/#/qrcode?userId="..self.owner.userid
                                .."&skinId="..skin.skin_id)
                            PushPopupDialog(self, "感谢支持！", "打赏成功了吗？请点击按钮刷新皮肤数据。", "弄好了吧？", function()
                                DoRpc(1, nil)
                            end)
                        end
                    end)
                end
            else
                if self.button_access ~= nil then
                    self.button_access:Kill()
                    self.button_access = nil
                end
            end
        end
        ]]--
    end
end

function SkinLegionDialog:BuildSkinDesc(item)
    local width = width_skininfo
    local height = 0
    local max_visible_height = 390
	local padding = 5
    local left = 20

    local x, y
    local height_anim = 150 --动画区域的高度
    local height_line = 10 --分割线高度
    local height_lag = 3 --项与项之间的间隔

    local w = Widget("scroll_skin_root")

    --动画区域
    local skindata = SkinData[item.item_key]
    if skindata then
        if skindata.height_anim then
            height_anim = skindata.height_anim
        end
        self:BuildSkinAnim(w, skindata)
    end
    height = height - height_anim - height_lag

    --动画分割线
    local line1 = w:AddChild(Image("images/quagmire_recipebook.xml", "quagmire_recipe_line.tex"))
    line1:SetScale(.36, .25)
    line1:SetPosition(0.5*width, height - 0.5*height_line)
    height = height - height_line - height_lag

    --皮肤获取方式描述
    local label_skinaccess = w:AddChild(Text(HEADERFONT, 21))
    label_skinaccess:SetHAlign(ANCHOR_LEFT)
    label_skinaccess:SetRegionSize(200, 20)
    label_skinaccess:SetColour(UICOLOURS.BRONZE)
    label_skinaccess:SetString(GetAccess(item.item_key))
    x, y = label_skinaccess:GetRegionSize()
    label_skinaccess:SetPosition(left + 0.5*x, height - 0.5*y)
    height = height - y

    --皮肤包含项描述
    local label_skindescitem = w:AddChild(Text(CHATFONT, 20))
    label_skindescitem:SetColour(UICOLOURS.BROWN_DARK)
    label_skindescitem:SetHAlign(ANCHOR_LEFT)
    label_skindescitem:SetVAlign(ANCHOR_TOP)
    label_skindescitem:EnableWordWrap(true)
    label_skindescitem:SetRegionSize(200, 36)
    label_skindescitem:SetString(GetDescItem(item.item_key))
    x, y = label_skindescitem:GetRegionSize()
    label_skindescitem:SetPosition(left + 0.5*x, height - 0.5*y)
    height = height - y - height_lag

    --故事分割线
    local line2 = w:AddChild(Image("images/quagmire_recipebook.xml", "quagmire_recipe_line.tex"))
    line2:SetScale(.36, -0.25)
    line2:SetPosition(0.5*width, height - 0.5*height_line)
    height = height - height_line - height_lag

    --短篇故事
    local text_story = w:AddChild(Text(CHATFONT, 21))
    text_story:SetColour(UICOLOURS.BROWN_DARK)
    text_story:SetHAlign(ANCHOR_LEFT)
    text_story:SetVAlign(ANCHOR_TOP)
    text_story:EnableWordWrap(true)
    text_story:SetMultilineTruncatedString(GetDescription(item.item_key), 100, 220)
    x, y = text_story:GetRegionSize()
    text_story:SetPosition(left + 0.5*x, height - 0.5*y)
    height = height - y - height_lag

    height = math.abs(height)

	-- local top = math.min(height, max_visible_height)/2 - padding
    local top = max_visible_height/2 - padding --固定一个高度，这样就能对齐 标题分割线

    local scissor_data = {x = 0, y = -max_visible_height/2, width = width, height = max_visible_height}
	local context = {widget = w, offset = {x = 0, y = top}, size = {w = width, height = height + padding} }
	local scrollbar = { scroll_per_click = 20*3, h_offset = -33 }

    local scroll_area = TrueScrollArea(context, scissor_data, scrollbar)

    scroll_area.up_button:SetTextures("images/ui.xml", "arrow_scrollbar_up.tex")
    scroll_area.up_button:SetScale(0.4)
    -- scroll_area.up_button:SetPosition(-13, 96)

	scroll_area.down_button:SetTextures("images/ui.xml", "arrow_scrollbar_down.tex")
    scroll_area.down_button:SetScale(0.4)
    -- scroll_area.down_button:SetPosition(-13, -96)

	scroll_area.scroll_bar_line:SetTexture("images/ui.xml", "scrollbarline.tex")
	scroll_area.scroll_bar_line:SetScale(.9)
    -- scroll_area.scroll_bar_line:SetPosition(-13, 0)

    -- scroll_area.scroll_bar:SetTextures("images/ui.xml", "scrollbarbox.tex", "scrollbarbox.tex", "scrollbarbox.tex")
	-- scroll_area.scroll_bar:SetScale(.6)
    -- scroll_area.scroll_bar:SetPosition(-13, 100)

	scroll_area.position_marker:SetTextures("images/ui.xml", "scrollbarbox.tex", "scrollbarbox.tex", "scrollbarbox.tex")
    scroll_area.position_marker:OnGainFocus() --获取焦点，以刷新图片
    scroll_area.position_marker:SetScale(.45)
    -- scroll_area.position_marker:SetPosition(-13, 100)

    return scroll_area
end

function SkinLegionDialog:BuildSkinAnim(w, skindata)
    if skindata.anims == nil then
        return
    end

    local xbase = width_skininfo/2
    local ybase = -(skindata.height_anim or 150)

    for _,v in ipairs(skindata.anims) do
        local anim = w:AddChild(UIAnim())
        anim:SetScale(v.scale)
        anim:SetPosition(xbase + v.x, ybase + v.y)
        anim:SetFacing(FACING_DOWN)

        if v.fn_anim ~= nil then
            v.fn_anim(self, anim, v)
        else
            SetAnim_base(anim:GetAnimState(), v)
        end

        if v.fn_click ~= nil then
            anim:SetClickable(true)
            anim.OnControl = function(down, control) --down是uianim自己，不是字符串
                if control == CONTROL_ACCEPT then --鼠标按下与弹回时
                    if not self.anim_down then
                        self.anim_down = true
                        TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
                    else
                        self.anim_down = nil
                        v.fn_click(self, anim, v)
                    end
                end
            end
        end
    end
end

function SkinLegionDialog:SetInteractionState(item)
    if item.context then
        item.context:SetInteractionState(item.isselected, item.isowned, item.isfocused, item.isunlockable, false)
    end
end

function SkinLegionDialog:OnControl(control, down)
    if SkinLegionDialog._base.OnControl(self, control, down) then return true end

    -- if control == CONTROL_CANCEL and not down then
    --     if #self.buttons > 1 and self.buttons[#self.buttons] then
    --         self.buttons[#self.buttons].cb()
    --         TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
    --         return true
    --     end
    -- end
end

function SkinLegionDialog:Close()
    if self.panel_iteminfo ~= nil then
        self.panel_iteminfo:Kill()
    end
	self:Kill()
end

return SkinLegionDialog
