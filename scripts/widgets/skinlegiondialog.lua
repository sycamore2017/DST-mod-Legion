local Widget = require "widgets/widget"
-- local Screen = require "widgets/screen"
-- local AnimButton = require "widgets/animbutton"
local Text = require "widgets/text"
local Image = require "widgets/image"
-- local ImageButton = require "widgets/imagebutton"
local TEMPLATES = require "widgets/templates"
-- local TEMPLATES2 = require "widgets/redux/templates"
local ItemImage = require "widgets/redux/itemimage"
local ScrollableList = require "widgets/scrollablelist"
local PopupDialogScreen = require "screens/redux/popupdialog"
local TrueScrollArea = require "widgets/truescrollarea"
local UIAnim = require "widgets/uianim"

local ischinese = CONFIGS_LEGION.LANGUAGES == "chinese"
local SkinStrings = ischinese and {
    UNKNOWN_STORY = "这个故事不值一提。",
    COLLECTION = {
        UNKNOWN = "陌生系列",
        MAGICSPELL = "魔咒系列",
        EMOTICON = "印象系列",
        MARBLE = "大理石园丁系列",
        THANKS = "江湖一枝花系列",
        TVPLAY = "N次元系列",
        DISGUISER = "奇妙物语系列",
        ERA = "古早系列",
        OLDPIC = "念旧系列",
        FANS = "饭制系列",
        COLLECTOR = "星河收藏家系列",
        TASTE = "厨心百味系列",
        LAW = "律系列",
        DAY = "节典系列",
        PAPER = "纸忆系列"
    },
    UI_ACCESS = "获取",
    UI_INPUT_CDK = "请输入兑换码",
    UI_LOAD_CDK = "兑换中...",
    ACCESS = {
        UNKNOWN = "无法获取",
        DONATE = "通过回忆获取",
        FREE = "自动获取",
        SPECIAL = "通过特殊方式获取",
        REWARD = "链锁奖励",
        LUCK = "幸运眷顾"
    }
} or {
    UNKNOWN_STORY = "The story is not worth mentioning.",
    COLLECTION = {
        UNKNOWN = "Strange Collection",
        MAGICSPELL = "Magic Spell Collection",
        EMOTICON = "Notion Collection",
        MARBLE = "Marble Gardener Collection",
        THANKS = "Heartfelt Thanks Collection",
        TVPLAY = "N-dimension Collection",
        DISGUISER = "Wonderful Creatures Collection",
        ERA = "Ancient Era Collection",
        OLDPIC = "Nostalgia Collection",
        FANS = "Fans Creation",
        COLLECTOR = "Galaxy Collector Collection",
        TASTE = "Tastes Collection",
        LAW = "Rule Collection",
        DAY = "Festival Collection",
        PAPER = "Paper Memoir Collection"
    },
    UI_ACCESS = "Get It",
    UI_INPUT_CDK = "Please enter CDK",
    UI_LOAD_CDK = "Redeeming...",
    ACCESS = {
        UNKNOWN = "Unable to get",
        DONATE = "Get it by memory",
        FREE = "Free access",
        SPECIAL = "Get it by special ways",
        REWARD = "Chain reward",
        LUCK = "Get it by luck"
    }
}

local AnimModels = {
    "wilson", "willow", "wendy", "wolfgang", "wx78", "wickerbottom", "woodie", "waxwell", "wathgrithr",
    "webber", "winona", "warly", "wes"
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

local function SetAnim_neverfadebush(self, anim, data)
    local animstate = anim:GetAnimState()
    SetAnim_base(animstate, data)
    animstate:Hide("berries")
    animstate:Hide("berriesmore")
    animstate:Hide("berriesmost")
    anim.tag_anim = 3
end
local function SetClick_neverfadebush(self, anim, data)
    local animstate = anim:GetAnimState()
    local tag = anim.tag_anim or 3

    animstate:PlayAnimation("grow")
    animstate:PushAnimation("idle", true)
    if tag == 3 then
        animstate:Show("berriesmost")
        anim.tag_anim = 4
    else
        animstate:Hide("berriesmost")
        anim.tag_anim = 3
    end
end
local function SetClick_neverfade(self, anim, data)
    local animstate = anim:GetAnimState()
    local tag = anim.tag_anim or 1

    if tag == 1 then
        animstate:PlayAnimation("idle_broken", false)
        anim.tag_anim = 2
    else
        animstate:PlayAnimation("idle", false)
        anim.tag_anim = 1
    end
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
local function SetAnim_icire_rock_day(self, anim, data)
    local animstate = anim:GetAnimState()
    SetAnim_base(animstate, data)

    local filename = ""
    if data.tag == 1 then
        filename = math.random() < 0.5 and "flake_crystal" or "flake_snow"
    elseif data.tag == 2 then
        filename = "flake_snow"
    elseif data.tag == 4 then
        filename = math.random() < 0.5 and "flake_leaf" or "flake_leaf2"
    elseif data.tag == 5 then
        filename = math.random() < 0.5 and "flake_dust" or "flake_ash"
    end
    animstate:OverrideSymbol("snowflake", "icire_rock_day", filename)
end

local function SetAnim_sivturn(self, anim, data)
    local animstate = anim:GetAnimState()
    local tag
    if anim.tag_anim == nil then
        tag = data.tag_start or 1
    else
        tag = anim.tag_anim
    end

    if tag == 1 then
        animstate:PlayAnimation("on_to_idle")
        animstate:PushAnimation("idle", true)
        animstate:OverrideSymbol("followed", data.build, "followed1")
    elseif tag == 2 then
        animstate:PlayAnimation("idle_to_on")
        animstate:PushAnimation("on", true)
        animstate:OverrideSymbol("followed", data.build, "followed2")
        tag = 0
    else
        tag = 0
    end
    anim.tag_anim = tag + 1
end

local function SetAnim_sivderivant(self, anim, data)
    local animstate = anim:GetAnimState()
    local tag = anim.tag_anim or 2

    if tag == 1 then
        animstate:PlayAnimation("lvl3", true)
    elseif tag == 2 then
        animstate:PlayAnimation("lvl2", true)
    elseif tag == 3 then
        animstate:PlayAnimation("lvl1", true)
    elseif tag == 4 then
        animstate:PlayAnimation("lvl0", true)
    elseif tag == 5 then
        animstate:PlayAnimation("lvl3_live", true)
    elseif tag == 6 then
        animstate:PlayAnimation("lvl2_live", true)
    elseif tag == 7 then
        animstate:PlayAnimation("lvl1_live", true)
    elseif tag == 8 then
        animstate:PlayAnimation("lvl0_live", true)
        tag = 0
    else
        tag = 0
    end
    anim.tag_anim = tag + 1
end

local function SetAnim_backcub(self, anim, data)
    local animstate = anim:GetAnimState()
    animstate:PlayAnimation(data.touchanim)
    animstate:PushAnimation(data.anim2 or data.anim, data.isloop)
end

local function SetAnim_soul_contracts(self, anim, data)
    local animstate = anim:GetAnimState()
    local tag
    if anim.tag_anim == nil then
        tag = 1
    else
        tag = anim.tag_anim
    end

    if tag == 1 then
        animstate:PlayAnimation("proximity_pre")
        animstate:PushAnimation("proximity_loop", true)
    elseif tag == 2 then
        animstate:PlayAnimation("proximity_pst")
        animstate:PushAnimation("idle", false)
        tag = 0
    else
        tag = 0
    end
    anim.tag_anim = tag + 1
end
local function SetAnim_soul_contracts2(self, anim, data)
    local animstate = anim:GetAnimState()
    animstate:PlayAnimation("use")
    animstate:PushAnimation("proximity_loop", true)
end

local function SetClick_revolvedmoonlight(self, anim, data)
    local animstate = anim:GetAnimState()
    local tag = anim.tag_anim or 1

    if tag == 1 then
        animstate:PlayAnimation("open")
        animstate:PushAnimation("opened", true)
        anim.tag_anim = 2
    else
        animstate:PlayAnimation("close")
        animstate:PushAnimation("closed", false)
        anim.tag_anim = 1
    end
end

local function SetAnim_sivfeather(self, anim, data)
    local animstate = anim:GetAnimState()
    local tag = anim.tag_anim or 1

    if tag == 1 then
        animstate:PlayAnimation("sleep_pst")
        animstate:PushAnimation("idle_loop", true)
        anim.tag_anim = 2
    elseif tag == 2 then
        animstate:PlayAnimation("emote_stretch")
        animstate:PushAnimation("idle_loop", true)
        anim.tag_anim = 3
    elseif tag == 3 then
        animstate:PlayAnimation("sleep_pre")
        animstate:PushAnimation("sleep_loop", true)
        anim.tag_anim = 1
    end
end

local function SetAnim_plant_cactus(self, anim, data)
    local animstate = anim:GetAnimState()
    SetAnim_base(animstate, data)
    for _,v in ipairs(data.symbol) do
        animstate:OverrideSymbol(v.symbol, v.build, v.file)
    end
end
local function SetClick_plant_cactus(self, anim, data)
    local animstate = anim:GetAnimState()
    local tag = anim.tag_anim or data.tag_start

    if tag == nil or tag == 5 then
        animstate:PlayAnimation("dead1")
        anim.tag_anim = 1
    elseif tag == 1 then
        animstate:PlayAnimation("level1_3")
        anim.tag_anim = 2
    elseif tag == 2 then
        animstate:PlayAnimation("level2_3")
        anim.tag_anim = 3
    elseif tag == 3 then
        animstate:PlayAnimation("level3_3")
        anim.tag_anim = 4
    else
        animstate:PlayAnimation("level4_3")
        anim.tag_anim = 5
    end
end

local function SetClick_siving_ctl(self, anim, data)
    local animstate = anim:GetAnimState()
    local tag = anim.tag_anim or 2

    if tag == 2 then
        animstate:PlayAnimation("item")
        anim.tag_anim = 1
    else
        animstate:PlayAnimation("idle")
        anim.tag_anim = 2
    end
end

local width_skininfo = 260
local SkinData = {
    rosebush_marble = {
        string = ischinese and {
            collection = "MARBLE", access = "DONATE",
            descitem = "解锁\"蔷薇花丛\"的皮肤。",
            description = "“什么事？”王后慵懒地挑选着名贵的珠宝首饰，眼皮都不愿抬起一下。一盆夺目的蔷薇被摆在梳妆台上，王后瞥了一眼，见蔷薇开得确实美，有心取一朵添妆。“嘶——”指尖一滴鲜血滑落，眼前突然浮现前日游行时，骑士长剑上滴落的鲜血。国王却对她说，贱民而已。她突然寒从胆边生，退后仔细端详。蔷薇无言，却绽放得猩红恣意。",
        } or {
            collection = "MARBLE", access = "DONATE",
            descitem = "Unlock \"Rose Bush\" skin.",
            description = "The story was not translated.",
        },
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
        string = ischinese and {
            collection = "MARBLE", access = "SPECIAL",
            descitem = "解锁\"带刺蔷薇\"以及入鞘后的皮肤。",
            description = "昔日王后的御剪如今竟然被用来剪去死刑犯的头发，据说这是为了防止刽子手砍头时，受到头发阻力拖泥带水，反而不美。究其原因，是王后修剪花丛时不慎被剪刀扎伤，这才特此给这把剪刀这样的“美差”。如今唯一能证明其身份的就是上面那精致的红蔷花纹，不过如今都被污迹遮住了大半。"
        } or {
            collection = "MARBLE", access = "SPECIAL",
            descitem = "Unlock \"Rosorns\" skin.",
            description = "The story was not translated."
        },
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
        string = ischinese and {
            collection = "MARBLE", access = "DONATE",
            descitem = "解锁\"蹄莲花丛\"的皮肤。",
            description = "少女坐在马车内，欢喜地看着怀中被精心打理过的蹄莲。阳光穿透层层阴云，照进这暗无天日的城镇，落在这一盆娇嫩的花上，露珠熠熠生辉，隐隐反射出彩虹的光芒，一如今晨那座新落成的哥特式大教堂中那复杂繁华的琉璃透射的光芒一样美丽。偌大的庄园，少女只将花摆在窗前，快乐地起舞，透过窗子依稀可见一街之隔的处刑场，囚犯被关在笼中已成枯骨，垂下的骨指刚好触及窗内蹄莲洁白的花瓣，仿佛拼死都要抚摸这份美好。"
        } or {
            collection = "MARBLE", access = "DONATE",
            descitem = "Unlock \"Lily Bush\" skin.",
            description = "The story was not translated."
        },
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
        string = ischinese and {
            collection = "MARBLE", access = "SPECIAL",
            descitem = "解锁\"蹄莲翠叶\"以及入鞘后的皮肤。",
            description = "他照着少女赠与的蹄莲的样子制了一把大理石长枪，本想建功立业，为国家开疆拓土，却没想到最后挥向的竟然是老鼠和饥肠辘辘苦求进城却不幸感染鼠疫的子民。昔日的铮光发亮的鞘如今已然锈迹斑斑，他虽如今已身获爵位，却也早已说不清那鞘上到底是铁锈还是血锈。"
        } or {
            collection = "MARBLE", access = "SPECIAL",
            descitem = "Unlock \"Lileaves\" skin.",
            description = "The story was not translated."
        },
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
        string = ischinese and {
            collection = "MARBLE", access = "DONATE",
            descitem = "解锁\"兰草花丛\"的皮肤。",
            description = "他将一束精心打理过的兰花放入这亲手打造的铁艺花架之中赠与她，一丝微笑渐渐攀上她的嘴角，正如这兰草瀑布般攀援在架子上灿烂动人。然而今日他却收到噩耗，奴隶主要求她在新婚之夜将这束兰花亲自送入奴隶主的庄园。在这个人贱于牲畜的时代，他无力反抗。好在隔壁庄园的奴隶主曾被他挽救于鼠疫之中，便答应买下两人收入自己庄园当差。"
        } or {
            collection = "MARBLE", access = "DONATE",
            descitem = "Unlock \"Orchid Bush\" skin.",
            description = "The story was not translated."
        },
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
        string = ischinese and {
            collection = "MARBLE", access = "SPECIAL",
            descitem = "解锁\"兰草花穗\"以及入鞘后的皮肤。",
            description = "婚礼虽不隆重却令人心安，如今他为新奴隶主看家护院，她为奴隶主的家眷莳花弄草，新铸的剑配上爱人所赠的兰花配饰，他紧握手中剑，誓死捍卫属于自己的一方安宁。听说隔壁庄园因奴隶暴动，看守松懈，庄园外墙已被涂满大大的“P”字母，（在黑死病时期，p代表不要靠近，有黑死病人）他一语不发，将擦拭好的剑推回剑鞘。"
        } or {
            collection = "MARBLE", access = "SPECIAL",
            descitem = "Unlock \"Orchitwigs\" skin.",
            description = "The story was not translated.",
        },
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
        string = ischinese and {
            collection = "DISGUISER", access = "SPECIAL",
            descitem = "解锁\"兰草花丛\"的皮肤。",
            description = "昨夜雨疏风骤，猎人不知所踪，仅留下这片茂盛的兰花丛纪念着曾经的点点滴滴。已不知是多少个春秋，花开花落，鸟去还回，它的等待始终落得一场空。恍惚间风吹过，摆动的兰花像极了猎人的身影，然而它也不知那潇洒果决的狩猎者是否还会归来……",
        } or {
            collection = "DISGUISER", access = "SPECIAL",
            descitem = "Unlock \"Orchid Bush\" skin.",
            description = "The story was not translated.",
        },
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
        string = ischinese and {
            collection = "DISGUISER", access = "FREE",
            descitem = "解锁\"兰草花穗\"以及入鞘后的皮肤。",
            description = "花色清浅，嫣粉各异，它隐匿其中，随着环境变化调整隐身衣的颜色，静候时机。若有猎物在此歇脚，它便踮起拟态为兰花瓣的步肢悄然靠近，只待猎物放松警惕，倏然伸出利爪，又消失在粉色的芬芳中。尽管有人批评它菩萨面蛇蝎心，但是待到下一次追猎时，它仍然会全力以赴。",
        } or {
            collection = "DISGUISER", access = "FREE",
            descitem = "Unlock \"Orchitwigs\" skin.",
            description = "The story was not translated.",
        },
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
        string = ischinese and {
            collection = "THANKS", access = "SPECIAL",
            descitem = "解锁\"永不凋零\"、\"永不凋零花丛\"、\"庇佑蝴蝶\"以及入鞘后的皮肤。",
            description = "“话说，这夜京郊外小竹林中，那是充满了肃杀之气，本是人来人往的入城必经之路，此刻却连只鸟儿都没有。只见有一双身影在其中对峙，两人遮步相互打量了半晌，那女子方才立起剑来。这剑可大有名堂，唤作青玉扶伤，通体碧色，光洁如玉，敲之竟闻金铁之声，最厉害之处在于此剑有灵，能够护主。而这女子对面的敌人也是毫不示弱，双手缓缓拔出这雌雄双刀。江湖中人皆知，这习武之人大部分都是右利手，这刀疤脸男子却不同，他自小苦练，终成就双手皆能惯用，这一双雌雄狂刀，雌刀薄，攻在速，取敌不备；雄刀厚，攻在力，更可防守。这两人将武器亮出，霎时间那是天地变色，狂风大作，竹林之中落叶飞舞，竟在刀疤脸上留下一丝血痕，反观那女子衣服也多有破口，原是这两人在用内力较劲。刀疤脸冷笑一声，刀光一闪，就冲上前去，招招皆冲着柳氏的命门而去，这柳氏也不甘示弱，见招拆招，身边青蝶环绕护体，却又见缝插针地进攻刀疤脸的要害，两人正是势均力敌难解难分，然而只听得‘叮咛’一声，玉剑折断，一纤长身影艰难起身，逐渐隐没在渐起的夜雾之中。正是，十年冤案无处诉，玉剑傍身除恶徒！”",
        } or {
            collection = "THANKS", access = "SPECIAL",
            descitem = "Unlock \"Neverfade\", \"Neverfade Bush\", and \"Neverfade Butterfly\" skin.",
            description = "The story was not translated.",
        },
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
                fn_click = SetClick_neverfadebush,
                x = -42, y = 145, scale = 0.32
            },
            {
                bank = "neverfadebush_thanks", build = "neverfadebush_thanks",
                anim = "dead", anim2 = nil, isloop = false,
                fn_anim = SetAnim_neverfadebush,
                fn_click = SetClick_neverfadebush,
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
        string = ischinese and {
            collection = "EMOTICON", access = "DONATE",
            descitem = "解锁\"苔衣发卡\"的皮肤。",
            description = "你知道哲学的基本问题吗？你认为意识和物质的关系是怎样的呢？你是唯心主义者还是唯物主义者？你支持意识能够正确认识物质的可知论，还是意识不能正确认识物质的不可知论呢？你对人类的存在是宇宙增墒这一判断有何看法？你认为人活着的意义是什么？什么？你什么都不知道？",
        } or {
            collection = "EMOTICON", access = "DONATE",
            descitem = "Unlock \"Lichen Hairpin\" skin.",
            description = "The story was not translated.",
        },
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
        string = ischinese and {
            collection = "DISGUISER", access = "FREE",
            descitem = "解锁\"苔衣发卡\"的皮肤。",
            description = "洋流之下，是暗流涌动的深渊。终年阴暗，偶有一点光明便格外显眼。远处突然出现忽闪忽闪的淡蓝色光点，小小鱼虾们好奇前去追寻。越游越近，突现一张长满尖牙的恐怖大嘴一口咬了下来。",
        } or {
            collection = "DISGUISER", access = "FREE",
            descitem = "Unlock \"Lichen Hairpin\" skin.",
            description = "The story was not translated.",
        },
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
        string = ischinese and {
            collection = "TVPLAY", access = "FREE",
            descitem = "解锁\"牛仔帽\"的皮肤。",
            description = "卡尔与伙伴一同返回基地途中，因发生争论无心警惕周围，他们拐过树丛时被突然冲出的五个丧尸扑倒。两人慌乱中解决了麻烦。但卡尔突然感到肚子刺痛，掀起衬衣发现自己已被咬伤……年过三十的卡尔梦中惊醒，看了看还在熟睡的妻女，又望了望桌上警徽虽早已脱落但保养还算完好的警帽，感叹还好只是梦一场。",
        } or {
            collection = "TVPLAY", access = "FREE",
            descitem = "Unlock \"Stetson\" skin.",
            description = "The story was not translated.",
        },
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
        string = ischinese and {
            collection = "DISGUISER", access = "DONATE",
            descitem = "解锁\"脱壳之翅\"、\"羽化后的壳\"的皮肤。",
            description = "它进化出了一对枯叶般的翅膀。饿了，花丛中有黄叶辗转；恋了，风中有木下双双飞舞；累了，树干上有翠减停留。这不夺人耳目的一生，最终也会悄悄离场。",
        } or {
            collection = "DISGUISER", access = "DONATE",
            descitem = "Unlock \"Boltwing-out\", \"Post-eclosion Shuck\" skin.",
            description = "The story was not translated.",
        },
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
        string = ischinese and {
            collection = "THANKS", access = "SPECIAL",
            descitem = "解锁\"简易打窝饵制作器\"、\"专业打窝饵制作器\"和\"打窝饵\"的皮肤。",
            description = "“书接上回，扶伤剑护主而断，这消息不知怎地不胫而走，而江湖上现今又流传着一个新的消息，说这食铁兽的遗孤已然认扶伤剑持剑者为主。而今扶伤剑再无护主能力，那这食铁兽是否会易主就成了众人茶余饭后最大的谈资。是夜，就看这京城一隅的一方小小茶楼，几人正悄声低语着最新消息，却是各不相同，几人各执一词。殊不知，这茶楼屋顶有一男子头戴斗笠手持一奇形烟斗吞云吐雾，只见他嘴角扯起一抹不屑的笑容，抬手招来黑鹰，将一卷密信放入信筒。至此，这食铁兽被捉进京都衙门内的消息便如同长了翅膀一样飞了出去。当夜丑时，衙门内除了个别看门打盹的官兵一片寂然，突然后院传来悉悉索索的异响。‘哼，上钩了’仔细瞧那墙角黑雾中，一名颓郁男子摘下斗笠，而他身周的云雾似乎有了感应，翻涌得愈发诡谲。这便是，江湖人心难餍足，云烟缭绕不肯渡！”",
        } or {
            collection = "THANKS", access = "SPECIAL",
            descitem = "Unlock \"Fish-homing Bait Maker\", \"Fish-homing Bait Maker+\", and \"Fish-homing Bait\" skin.",
            description = "The story was not translated.",
        },
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
        string = ischinese and {
            collection = "EMOTICON", access = "FREE",
            descitem = "解锁\"木盾\"的皮肤。",
            description = "多一丝宽容，你就少一份疑惑；多一丝爱心，你就少一份怨恨；多一丝理解，你就少一份紧张。你我都是独一无二，为自己骄傲吧。"
        } or {
            collection = "EMOTICON", access = "FREE",
            descitem = "Unlock \"Log Shield\" skin.",
            description = "More tolerance,less doubt.More love,less resentment.More understanding,less nervousness.You and I are unique.Be proud of yourself.",
        },
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
        string = ischinese and {
            collection = "EMOTICON", access = "SPECIAL",
            descitem = "解锁\"木盾\"的皮肤。",
            description = "观点不一，骂Ta；羡慕嫉妒，恨Ta；没有黑点？监视Ta。不管发生什么，敲起键盘如同打拳，咬文嚼字断章取义也能搞得鸡飞狗跳。非我皆是恶，活在自己的世界，这就是拳的意义。打的就是你，陌生人。"
        } or {
            collection = "EMOTICON", access = "SPECIAL",
            descitem = "Unlock \"Log Shield\" skin.",
            description = "The story was not translated.",
        },
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
        string = ischinese and {
            collection = "ERA", access = "SPECIAL",
            descitem = "解锁\"木盾\"的皮肤。",
            description = "他们是生命的奇迹，在寒武纪那个物种大爆发的时代，他们不甘籍籍无名，最早进化出了眼睛，试图看清这洪流般的时代，还进化出了坚硬的外壳，保护自己的族群生生不息。可惜的是，他们引以为傲的甲胄最终在三亿年的进化中成为了积重难返的弊端，最终被自然淘汰。平凡的他们常常以背景或被猎杀的对象出现在纪录片中，如同英雄故事里籍籍无名的平民百姓，然而历经三亿年荣辱兴衰的他们却为研究不同时期的自然环境留下了无法估量的价值。"
        } or {
            collection = "ERA", access = "SPECIAL",
            descitem = "Unlock \"Log Shield\" skin.",
            description = "The story was not translated.",
        },
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
        string = ischinese and {
            collection = "ERA", access = "SPECIAL",
            descitem = "解锁\"砂之抵御\"的皮肤。",
            description = "在洞穴深处一个不起眼的角落，它孤独着。它的头骨暴露在外，与古旧的头部甲胄融为一体，身体早已腐朽，只留下部分残缺的脊椎。它骨头上道道触目惊心的伤疤诉说着生前如何无数次顽强地抵御捕食者，它的下颌张开，仿佛在拼命呼唤着族群与希望。在生命的尽头，大地之母听见了它最后的低鸣，拥抱并亲吻了它的遗骨。",
        } or {
            collection = "ERA", access = "SPECIAL",
            descitem = "Unlock \"Desert Defense\" skin.",
            description = "The story was not translated.",
        },
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
        string = ischinese and {
            collection = "OLDPIC", access = "FREE",
            descitem = "解锁\"砂之抵御\"的皮肤。",
            description = "画完就觉得左右貌似不太整齐，但是都画好，不想再改。现在我绘画时会不时左右翻转来查看画面的问题，也算是一个进步吧。贴图上结合了沙之石的纹路以及大量向外突出的晶石，中间是金块，现在想想金块不足以被摆在中间好像很重要似的。",
        } or {
            collection = "OLDPIC", access = "FREE",
            descitem = "Unlock \"Desert Defense\" skin.",
            description = "The story was not translated.",
        },
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
        string = ischinese and {
            collection = "ERA", access = "SPECIAL",
            descitem = "解锁\"鸳鸯石\"的皮肤。",
            description = "一颗苍天大树拔地而起，直冲云霄，然而在这地洞之内更显得蔚为壮观。更奇特的是，继续考察后，我们在树下的枯枝中发现一颗精美的琥珀。仔细清理之下，这才看到里面还有一只不知品类的有翅昆虫，琥珀将其包裹得如此完好，仿佛仍能听到窸窸窣窣的昆虫振翅声，而下一秒它就能活过来飞出琥珀似的。在火把的包围中，琥珀竟然渐渐变色，而其中的昆虫开始发出微弱的光芒，令人诧异的是，我突然感受到了它对生命瞬间凝滞的不甘……",
        } or {
            collection = "ERA", access = "SPECIAL",
            descitem = "Unlock \"Icire Stone\" skin.",
            description = "The story was not translated.",
        },
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
        string = ischinese and {
            collection = "COLLECTOR", access = "SPECIAL",
            descitem = "解锁\"鸳鸯石\"的皮肤。",
            description = "我族世代守护占星石，并流传着一个不可思议的秘密。占星石每三百年都会选中一位族人，只有他能读懂占星预言。到那时只要听从星的指导，就能让我族发扬兴盛，摆脱命运安排。然而，距离上一位族人逝去已过快四百年，占星石也只剩隐隐的光。"
        } or {
            collection = "COLLECTOR", access = "SPECIAL",
            descitem = "Unlock \"Icire Stone\" skin.",
            description = "The story was not translated.",
        },
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
        string = ischinese and {
            collection = "ERA", access = "SPECIAL",
            descitem = "解锁\"蹄莲花丛\"、\"蹄莲翠叶\"以及入鞘后的皮肤。",
            description = "沿着地下河道一路向前，我们在巨大地洞的入口处发现一片蓝色荧光花海，这里的植被花萼巨大，花瓣柔软光滑，金、蓝、紫相隔相接，却不甚芬芳。不知是不是我们的到来惊动了它们，花海仿佛有了生命，从我们身周开始，缓缓催动起波涛，迷幻的色彩摄人心魄，细长的蕨叶互相摩擦，传来木叶婆娑之声，仿佛在轻声欢迎我们的到来。"
        } or {
            collection = "ERA", access = "SPECIAL",
            descitem = "Unlock \"Lily Bush\", \"Lileaves\" skin.",
            description = "The story was not translated.",
        },
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
        string = ischinese and {
            name = "叮叮铛铛考古镐",
            collection = "ERA", access = "SPECIAL",
            descitem = "解锁\"斧铲-三用型\"、\"斧铲-黄金三用型\"的皮肤。",
            description = "在参加这一次的考古活动前，我们无论如何都想不到接下来我们将有怎样的奇遇。在深山中我们找到了一支新的古老河道，河道与山体相接，可惜被一块顽石堵住，老师和同学们齐心协力，终于在一片叮叮咚咚声中打开了新世界的入口，顺着河道进入山洞，不远处发现了奇怪的图腾，暗示我们顺流而下，越往前走地势便愈发低，而河流中也渐渐出现蓝色的荧光物，终于在河流尽头，我们发现了一片蓝色荧光瀑布和瀑布之下那个神秘的地洞入口。"
        } or {
            name = "Era Explorers",
            collection = "ERA", access = "SPECIAL",
            descitem = "Unlock \"Triple-shovelaxe\", \"Snazzy Triple-shovelaxe\" skin.",
            description = "The story was not translated.",
        },
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
        string = ischinese and {
            collection = "COLLECTOR", access = "SPECIAL",
            descitem = "解锁\"蔷薇花丛\"、\"带刺蔷薇\"以及入鞘后的皮肤。",
            description = "作为银河系最大的军阀统领，从小便渴望权利与力量。他用尽半生精力，终于在极其遥远的星云残骸中找到传说中能贯穿星辰的神剑。他带着贯星剑回到了自己的星球，憧憬着一统宇宙成为唯一的神……\n他高傲自豪地在高台上举起贯星剑，正准备发起向其他银河统领的宣战时，剑体却突然碎裂开来，化作无数金色光束向地面射去。在众人诧异中，地面开始朽化龟裂，水晶般的荆棘开始迅速长出，不断往周围蔓延。整个星球失去了生机，他也在崩坏与腐朽中失踪。",
        } or {
            collection = "COLLECTOR", access = "SPECIAL",
            descitem = "Unlock \"Rose Bush\", \"Rosorns\" skin.",
            description = "The story was not translated.",
        },
        height_anim = 320,
        anims = {
            {
                bank = "berrybush", build = "rosebush_collector",
                anim = "dead", anim2 = nil, isloop = false,
                fn_anim = SetAnim_flowerbush2,
                fn_click = SetAnim_flowerbush,
                x = 45, y = 143, scale = 0.24
            },
            {
                bank = "berrybush", build = "rosebush_collector",
                anim = "shake", anim2 = "idle", isloop = true,
                fn_anim = SetAnim_flowerbush1,
                fn_click = SetAnim_flowerbush,
                x = -45, y = 143, scale = 0.24
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
                x = -30, y = 10, scale = 0.4
            }
        }
    },
    fimbul_axe_collector = {
        string = ischinese and {
            collection = "COLLECTOR", access = "SPECIAL",
            descitem = "解锁\"芬布尔斧\"的皮肤。",
            description = "十七年前，盛夏流星群过后，一对夫妻在自己营地附近捡到一名戴着星星吊坠的女婴。现在，女婴已长大，每晚望着璀璨的星空着迷，但夫妻太爱这个孩子，不忍告诉她的来历，并藏起了属于她的吊坠。\n盛夏时节，女孩忽然有某种感应跑到楼顶，原来是流星群再次来临。女孩眼睛瞪得老大，欣赏着这场视觉的盛宴，留下了眼泪。\n夫妻觉得离别的时刻已经到来，把吊坠还给了女孩。吊坠交到女孩手里的那一刻，女孩理解了一切。她跃向天空，在耀眼的光芒过后，化作了流星群的一员飞出目光尽头，留下夫妻二人黯然神伤。\n两年后某个盛夏的夜晚，夫妻二人仍然依照往日习惯在楼顶看星星，此时一颗星星从天上划落，熟悉的少女身影闪现在夫妻眼前，三人默契相拥……"
        } or {
            collection = "COLLECTOR", access = "SPECIAL",
            descitem = "Unlock \"Fimbul's Axe\" skin.",
            description = "The story was not translated.",
        },
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
        string = ischinese and {
            collection = "COLLECTOR", access = "LUCK",
            descitem = "解锁\"子圭·育\"的皮肤。",
            description = "自从飞船失控，他被困在这片星漩中已过去3周。他无数次尝试与总部沟通，皆以失败告终。每每失落之际，他都会望着那颗最近的星球，星体一开始如黑洞般深邃，但又会逐渐闪耀起来，如同他的遭遇。“真好，你一直在我身边”，望着这颗美丽的星球他总能重燃信心，“你就是我的希望”。如今弹尽粮绝，飞船内的氧气也低到极限，他瘫倒在甲板，恍惚间，他好像发现很多生物的残骸漂浮在星环中，“为什么3周以来我都没看到过？”，他心生疑问。三周前，飞船突然收到求救讯号，然后他决定脱离航线前去救援，到达救援坐标后，飞船突然失控，那颗暗星也开始了光与暗的循环。在昏迷前，他终于理解这颗星球的秘密，“来吧，来吧，投入我的怀抱……”。昏迷的他，居然打开了舱门，向那颗星球跳去，很快便隐没在星环之中。",
        } or {
            collection = "COLLECTOR", access = "LUCK",
            descitem = "Unlock \"Siving-Trans\" skin.",
            description = "The story was not translated.",
        },
        height_anim = 190,
        anims = {
            {
                bank = "siving_turn_collector", build = "siving_turn_collector",
                anim = "on_to_idle", anim2 = "idle", isloop = true,
                tag_start = 2, symbol = {
                    { symbol = "followed", build = "siving_turn_collector", file = "followed1" }
                },
                fn_anim = SetAnim_heatrock,
                fn_click = SetAnim_sivturn,
                x = 60, y = 8, scale = 0.3
            },
            {
                bank = "siving_turn_collector", build = "siving_turn_collector",
                anim = "idle_to_on", anim2 = "on", isloop = true,
                tag_start = 1, symbol = {
                    { symbol = "followed", build = "siving_turn_collector", file = "followed2" }
                },
                fn_anim = SetAnim_heatrock,
                fn_click = SetAnim_sivturn,
                x = -60, y = 8, scale = 0.3
            }
        }
    },
    siving_derivant_thanks = {
        string = ischinese and {
            collection = "THANKS", access = "SPECIAL",
            descitem = "解锁\"子圭奇型岩\"的2套皮肤。",
            description = "“上回说到，柳氏重伤，扶伤也已玉碎，她拖着残躯跌跌撞撞回到梨花洞，这洞外虽然是郁郁葱葱，却只是普通森林景致，不比里面别有洞天。洞中有几棵奇异的银叶树，散发着青绿色的微光，虽不甚亮堂却堪堪能够照亮整个洞穴。洞穴正中有一阵法，柳氏将断剑插入阵眼，只见银叶树上的微光竟然活泛起来，逐渐向阵眼汇集，刹那间，阵法其光大盛，从阵眼中渐渐生出嫩绿枝芽，攀在剑身，逐渐将整柄剑包裹起来，而那断剑似乎活了般一明一暗地发出白色微光，似在呼吸，剑身上的裂痕也肉眼可见地被修复消失。而柳氏盘腿席地而坐，青光一片中，她身上的伤口也在快速结痂愈合。原来这银叶树名曰青冥梨花树，有生死人肉白骨之效，又与这青玉扶伤剑同宗同源，故而能够医治扶伤剑痕和剑主肉躯。这可真是，玉人妙运天不绝，洞中八卦有乾坤！”"
        } or {
            collection = "THANKS", access = "SPECIAL",
            descitem = "Unlock all \"Siving Derivant\" skin.",
            description = "The story was not translated."
        },
        height_anim = 255,
        anims = {
            {
                bank = "siving_derivant_thanks", build = "siving_derivant_thanks",
                anim = "lvl3", anim2 = nil, isloop = false,
                fn_click = SetAnim_sivderivant,
                x = -60, y = 100, scale = 0.22
            },
            {
                bank = "siving_derivant_thanks2", build = "siving_derivant_thanks2",
                anim = "lvl3", anim2 = nil, isloop = false,
                fn_click = SetAnim_sivderivant,
                x = 0, y = 1, scale = 0.22
            }
        }
    },
    backcub_fans = {
        string = ischinese and {
            collection = "FANS", access = "SPECIAL",
            descitem = "解锁\"靠背熊\"的皮肤。",
            description = "他叫饭仔，有着简单的几个爱好。吃饭饭，能吃就行；睡觉觉，要抱着他最爱的偶像抱枕才睡得着；不过，他最喜欢的还是给朋友们爱的抱抱。\n--感谢白饭的绘制",
        } or {
            collection = "FANS", access = "SPECIAL",
            descitem = "Unlock \"Backcub\" skin.",
            description = "The story was not translated.",
        },
        height_anim = 140,
        anims = {
            {
                bank = "backcub_fans", build = "backcub_fans",
                anim = "idle", anim2 = nil, isloop = false,
                x = -45, y = 17, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "swap_body", build = "backcub_fans", file = "swap_body", type = nil }
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 45, y = 0, scale = 0.38
            }
        }
    },
    backcub_thanks = {
        string = ischinese and {
            collection = "THANKS", access = "SPECIAL",
            descitem = "解锁\"靠背熊\"的皮肤。",
            description = "“这江湖中早有竹居食铁兽这种奇兽的传闻，言此兽贪食，因而肚量巨大，得之认主后可借兽腹容纳万物。正所谓匹夫无罪，怀璧其罪，很快便有人盯上了它们。当夜竹林中人头攒动，火把几乎照亮了半边天。要说这食铁兽一家也是自然之灵长，为了护幼舍命与猎人们周旋，长者们硬生生抗住漫天箭雨，幼兽方才安然逃出。眼见幼兽逃出天罗地网，老兽们自然更不会俯首称臣，由最年长者带头，只见它们齐齐祭出修炼多年的灵丹，以多年修为引动自爆。那爆炸声惊天动地，毁去了大半竹林，更带走了泰半猎人的性命，剩下的人也只是一息尚存苟延残喘。据说，后来当其他人在他们面前再提起食铁兽时，他们无一不浑身颤抖如临大敌。正所谓父母之爱子，则为之计深远，老兽们正是以壮烈之举彻底打消了后人想猎取它们的幼子的念头，真乃可叹可惜也！而今幼兽孑然一身，举目无亲，只得潜藏于农神山。这农神山因森林茂密，地形奇崛，罕有人迹。不过，这一天，兽子却在农神山山涧发现一名重伤昏迷的女子。这兽子本性纯良，虽经历灭族惨案，仍心怀善念，不欲见有生灵逝于前，便将这女子驮至其藏身的梨花洞，借梨花洞内天地灵气为女子愈合伤口，奇妙的是，这剑竟然也能自主吸取天地精华缓慢修复。女子醒来后出于感谢，用玉竹炼制背篓，容兽子隐息藏身，而在女子养伤过程中，一人一兽逐渐建立了对彼此的信任，遂为兽子起名为浮生儿，一起在洞中修行八年，直到这一日出山。这可谓，浮沉尘世见险恶，生死度外结善缘！”"
        } or {
            collection = "THANKS", access = "SPECIAL",
            descitem = "Unlock \"Backcub\" skin.",
            description = "The story was not translated."
        },
        height_anim = 170,
        anims = {
            {
                bank = "backcub_thanks", build = "backcub_thanks",
                anim = "idle2_water", anim2 = "idle3_water", isloop = true,
                touchanim = "idle5_water",
                fn_click = SetAnim_backcub,
                x = -25, y = 90, scale = 0.36
            },
            {
                bank = "backcub_thanks", build = "backcub_thanks",
                anim = "idle4", anim2 = "idle1", isloop = true,
                touchanim = "idle4",
                fn_click = SetAnim_backcub,
                x = -55, y = 10, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "swap_body", build = "backcub_thanks", file = "swap_body", type = nil }
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 65, y = 0, scale = 0.38
            }
        }
    },
    backcub_fans2 = {
        string = ischinese and {
            collection = "FANS", access = "REWARD",
            descitem = "解锁\"靠背熊\"的皮肤。",
            description = "饭豆子睡着时思想喜欢飘向各处。暴雨来临，孩童们都被雷声吓得噩梦不断。饭豆子放下自己的美梦而去帮助他们改善梦境。一觉醒来，孩子们终记不得它的模样，只记得那沙子般细腻的柔软。\n--感谢白饭的绘制",
        } or {
            collection = "FANS", access = "REWARD",
            descitem = "Unlock \"Backcub\" skin.",
            description = "The story was not translated."
        },
        height_anim = 185,
        anims = {
            {
                bank = "backcub_fans2", build = "backcub_fans2",
                anim = "idle1_water", anim2 = "idle2_water", isloop = true,
                touchanim = "idle1_water",
                fn_click = SetAnim_backcub,
                x = -25, y = 70, scale = 0.36
            },
            {
                bank = "backcub_fans2", build = "backcub_fans2",
                anim = "idle2", anim2 = "idle1", isloop = true,
                touchanim = "idle3",
                fn_click = SetAnim_backcub,
                x = -50, y = 10, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "swap_body", build = "backcub_fans2", file = "swap_body", type = nil }
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 65, y = 0, scale = 0.38
            }
        }
    },
    agronssword_taste = {
        string = ischinese and {
            collection = "TASTE", access = "SPECIAL",
            descitem = "解锁\"艾力冈的剑\"的皮肤。",
            description = "米歇尔凌晨就起床，在厨房和面、醒面、擀面，还用上了烤箱。很快来到早上，丈夫奥多穿着整洁的军装下楼，米歇尔赶紧端上来一大盘法棍，并往法棍上撒上一层糖霜，她知道奥多最喜欢加这个。两人的早餐是糖霜法棍，美味夹杂着别离，因为奥多马上要应征上战场，在如今非常动荡的时期。奥多怀揣家国情怀，觉得这是一份荣耀；米歇尔担心丈夫，期盼他一定要安全归来……"
        } or {
            collection = "TASTE", access = "SPECIAL",
            descitem = "Unlock \"Agron's Sword\" skin.",
            description = "The story was not translated."
        },
        height_anim = 265,
        anims = {
            {
                bank = "agronssword_taste", build = "agronssword_taste",
                anim = "idle", anim2 = nil, isloop = false,
                x = -55, y = 145, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "lantern_overlay", build = "agronssword_taste", file = "swap1", type = 1 },
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 35, y = 130, scale = 0.38
            },
            {
                bank = "agronssword_taste", build = "agronssword_taste",
                anim = "idle2", anim2 = nil, isloop = false,
                x = -55, y = 12, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "lantern_overlay", build = "agronssword_taste", file = "swap2", type = 1 },
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 35, y = 0, scale = 0.38
            },
            {
                bank = "lavaarena_beetletaur_fx", build = "lavaarena_beetletaur_fx",
                anim = "defend_fx", anim2 = nil, isloop = false,
                x = -55, y = 165, scale = 0.22
            },
            {
                bank = "lavaarena_beetletaur_fx", build = "lavaarena_beetletaur_fx",
                anim = "defend_fx", anim2 = nil, isloop = false,
                x = -55, y = 50, scale = 0.22
            }
        }
    },
    carpet_whitewood_law = {
        string = ischinese and {
            name = "西洋棋棋盘",
            collection = "LAW", access = "SPECIAL",
            descitem = "解锁\"白木地垫\"、\"白木地毯\"的皮肤。",
            description = "不大不小的棋盘上，我方对方。每一颗棋子都是我的工具，让我在每一个方格上施展自己的权谋。不管是开局，结局，残局，败局，我都心思缜密，处变不惊。一横一竖的棋盘上，进攻防御，不到最后一刻都不要放弃！带领自己的棋子冲破封锁，进攻还是防御，都有我个人风格。"
        } or {
            name = "Chessboard",
            collection = "LAW", access = "SPECIAL",
            descitem = "Unlock \"White Wood Mat\", \"White Wood Carpet\" skin.",
            description = "The story was not translated."
        },
        height_anim = 140,
        anims = {
            {
                bank = "carpet_whitewood_law", build = "carpet_whitewood_law",
                anim = "idle_big", anim2 = nil, isloop = false,
                x = -45, y = 70, scale = 0.12
            },
            {
                bank = "carpet_whitewood_law", build = "carpet_whitewood_law",
                anim = "idle", anim2 = nil, isloop = false,
                x = 65, y = 70, scale = 0.12
            }
        }
    },
    carpet_whitewood_law2 = {
        string = ischinese and {
            name = "西洋棋黑棋盘",
            collection = "LAW", access = "SPECIAL",
            descitem = "解锁\"白木地垫\"、\"白木地毯\"的皮肤。",
            description = "一横一竖的棋盘上，我方对方。每一颗棋子都是我的工具，让我在每一个方格上施展自己的权谋。不管是开局，结局，残局，败局，我都心思缜密，处变不惊。一黑一白的棋盘上，进攻防御，不到最后一刻都不要放弃！带领自己的棋子冲破封锁，进攻还是防御，都有我独特个性。"
        } or {
            name = "Black Chessboard",
            collection = "LAW", access = "SPECIAL",
            descitem = "Unlock \"White Wood Mat\", \"White Wood Carpet\" skin.",
            description = "The story was not translated."
        },
        height_anim = 140,
        anims = {
            {
                bank = "carpet_whitewood_law2", build = "carpet_whitewood_law2",
                anim = "idle_big", anim2 = nil, isloop = false,
                x = -45, y = 70, scale = 0.12
            },
            {
                bank = "carpet_whitewood_law2", build = "carpet_whitewood_law2",
                anim = "idle", anim2 = nil, isloop = false,
                x = 65, y = 70, scale = 0.12
            }
        }
    },
    soul_contracts_taste = {
        string = ischinese and {
            collection = "TASTE", access = "SPECIAL",
            descitem = "解锁\"灵魂契约\"的皮肤。",
            description = "他才二十岁出头，就成为了当地知名高级餐厅的主厨。都说每位成功的大厨都有自己的拿手好菜，他自然也不例外。一般人也许会猜是焗蜗牛、北极贝寿司这类奢华的菜品，而他的出名作却是普普通通的芝士三明治。他烤出来的三明治既酥脆又软绵，入口回甘。内陷里一边是新鲜的生菜搭配微熏火腿肉，爽脆喷香，另一边是牛肉边角料剁碎后煎出来的肉饼，然后用完全融化的芝士贯浇两边，将两部分完美融合为一体。无论是用料还是做法都和平常的一致，但只有他的芝士三明治，因为他特殊的细节把控，有着超出预料的口感使人难以忘怀。\n其他人都是想着探究料理的做法，而我好奇他的童年，是什么样的经历能磨炼并诞生出这样一位三明治烹饪大师。或许他已出卖了灵魂，为了治愈自己，为了填补曾经的遗憾！"
        } or {
            collection = "TASTE", access = "SPECIAL",
            descitem = "Unlock \"Soul Contracts\" skin.",
            description = "The story was not translated."
        },
        height_anim = 110,
        anims = {
            {
                bank = "book_maxwell", build = "soul_contracts_taste",
                anim = "use", anim2 = "proximity_loop", isloop = true,
                fn_click = SetAnim_soul_contracts2,
                x = -50, y = 15, scale = 0.32
            },
            {
                bank = "book_maxwell", build = "soul_contracts_taste",
                anim = "proximity_pst", anim2 = "idle", isloop = false,
                fn_click = SetAnim_soul_contracts,
                x = 50, y = 15, scale = 0.32
            }
        }
    },
    icire_rock_day = {
        string = ischinese and {
            collection = "DAY", access = "SPECIAL",
            descitem = "解锁\"鸳鸯石\"的皮肤。",
            description = "圣诞节礼物？！我最想要的是一颗雪景球。轻拿起它，快速摇动，雪花飘落，透过玻璃，尽收美景。在那几秒内，我看尽欢愉，短暂脱离枯槁的现实。此刻你将得到一颗能变化球内景色的风景球，不同的画面有着不同欢乐氛围。在这重要时节，我希望你快乐……"
        } or {
            collection = "DAY", access = "SPECIAL",
            descitem = "Unlock \"Icire Stone\" skin.",
            description = "The story was not translated."
        },
        height_anim = 170,
        anims = {
            { --上
                bank = "icire_rock_day", build = "icire_rock_day",
                anim = "3", anim2 = nil, isloop = true,
                x = 0, y = 13+90, scale = 0.38
            },
            {
                bank = "wintersfeastfuel", build = "icire_rock_day",
                anim = "idle_loop", anim2 = nil, isloop = true,
                fn_anim = SetAnim_icire_rock_day, tag = 4,
                x = 70, y = 13+65+13, scale = 0.46
            },
            { --右1
                bank = "icire_rock_day", build = "icire_rock_day",
                anim = "4", anim2 = nil, isloop = true,
                x = 70, y = 13+65, scale = 0.38
            },
            {
                bank = "wintersfeastfuel", build = "icire_rock_day",
                anim = "idle_loop", anim2 = nil, isloop = true,
                fn_anim = SetAnim_icire_rock_day, tag = 5,
                x = 42, y = 13+13, scale = 0.46
            },
            { --右2
                bank = "icire_rock_day", build = "icire_rock_day",
                anim = "5", anim2 = nil, isloop = true,
                x = 42, y = 13, scale = 0.38
            },
            {
                bank = "wintersfeastfuel", build = "icire_rock_day",
                anim = "idle_loop", anim2 = nil, isloop = true,
                fn_anim = SetAnim_icire_rock_day, tag = 2,
                x = -70, y = 13+65+13, scale = 0.46
            },
            { --左1
                bank = "icire_rock_day", build = "icire_rock_day",
                anim = "2", anim2 = nil, isloop = true,
                x = -70, y = 13+65, scale = 0.38
            },
            {
                bank = "wintersfeastfuel", build = "icire_rock_day",
                anim = "idle_loop", anim2 = nil, isloop = true,
                fn_anim = SetAnim_icire_rock_day, tag = 1,
                x = -42, y = 13+13, scale = 0.46
            },
            { --左2
                bank = "icire_rock_day", build = "icire_rock_day",
                anim = "1", anim2 = nil, isloop = true,
                x = -42, y = 13, scale = 0.38
            }
        }
    },
    neverfade_paper = {
        string = ischinese and {
            collection = "PAPER", access = "SPECIAL",
            descitem = "解锁\"永不凋零\"、\"永不凋零花丛\"、\"庇佑蝴蝶\"以及入鞘后的皮肤。",
            description = "先在纸的边缘画上浅蓝色花纹，然后折成纸扇，再把外端稍稍压平。按照这个方式多做一些不同大小的，把所有拼凑在一起粘起来。最后做三个纸蝴蝶插上去，一捧花丛扇就做好了。佩柏细细欣赏着自己新的作品。\n“你怎么又在做这些垃圾！？给我好好做功课去！”佩柏的父亲吼他，当着他的面把他的新作品捏成团丢进垃圾桶，“给我把作业写了。”随后扬长而去。\n当晚，佩柏偷偷在被窝里开着手电。“妈，我想你”，佩柏在白纸上写了这几个字，折成了一个纸蝴蝶，然后又折了一把纸剑，他将纸蝴蝶黏在纸剑上，不知不觉居然睡着了。“我说了你不听是不是！”睡梦中的佩柏突然被父亲从床上拽起，当着他的面把蝴蝶纸剑撕得粉碎，“以后我见一次撕一次！”父亲说完就出去了。佩柏小声啜泣起来。",
        } or {
            collection = "PAPER", access = "SPECIAL",
            descitem = "Unlock \"Neverfade\", \"Neverfade Bush\", and \"Neverfade Butterfly\" skin.",
            description = "The story was not translated.",
        },
        height_anim = 300,
        anims = {
            {
                bank = "berrybush2", build = "neverfadebush_paper",
                anim = "shake", anim2 = "idle", isloop = true,
                fn_anim = SetAnim_flowerbush1,
                fn_click = SetClick_neverfadebush,
                x = -48, y = 200, scale = 0.25
            },
            {
                bank = "berrybush2", build = "neverfadebush_paper",
                anim = "shake", anim2 = "idle", isloop = true,
                fn_anim = SetAnim_neverfadebush,
                fn_click = SetClick_neverfadebush,
                x = 45, y = 145, scale = 0.25
            },
            {
                bank = "butterfly", build = "neverfade_butterfly_paper",
                anim = "land", anim2 = "idle", isloop = true,
                x = 5, y = 145, scale = 0.25
            },
            {
                bank = "butterfly", build = "neverfade_butterfly_paper",
                anim = "take_off", anim2 = "idle_flight_loop", isloop = true,
                x = 70, y = 195, scale = 0.25
            },
            {
                bank = "butterfly", build = "neverfade_butterfly_paper",
                anim = "take_off", anim2 = "flight_cycle", isloop = true,
                x = -90, y = 90, scale = 0.25
            },
            {
                bank = "neverfade_paper", build = "neverfade_paper",
                anim = "idle", anim2 = nil, isloop = false,
                fn_click = SetClick_neverfade,
                x = -85, y = 0, scale = 0.38
            },
            {
                bank = "neverfade_paper", build = "neverfade_paper",
                anim = "idle_cover", anim2 = nil, isloop = false,
                x = -30, y = -2, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "swap_object", build = "neverfade_paper", file = "normal_swap", type = 1 },
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 45, y = 0, scale = 0.38
            }
        }
    },
    neverfade_paper2 = {
        string = ischinese and {
            collection = "PAPER", access = "SPECIAL",
            descitem = "解锁\"永不凋零\"、\"永不凋零花丛\"、\"庇佑蝴蝶\"以及入鞘后的皮肤。",
            description = "佩柏把自己的折纸作品都藏在了床下盒子里，他不敢让父亲知道。一天放学回家，发现父亲正在屋外烧自己的折纸。父亲见佩柏回来，拿起木棍准备打人。佩柏立即激动起来，压抑的情绪终于爆发，“要是妈还在，她才不会让你这样对我！”“呜…”佩柏哭起来，“都怪你这个酒鬼…对我最好的妈妈已经不在了！”佩柏放声大哭。父亲愣住了，放下手里的木棍，想抱住佩柏。佩柏躲开了，跑向屋里。父亲掩面哭泣，他知道他错了，但他不会改。佩柏是这样认为的。\n从那之后，佩柏不再尝试折纸，不再尝试倾注情感于他物，所有的折纸都藏进了心里！",
        } or {
            collection = "PAPER", access = "SPECIAL",
            descitem = "Unlock \"Neverfade\", \"Neverfade Bush\", and \"Neverfade Butterfly\" skin.",
            description = "The story was not translated.",
        },
        height_anim = 300,
        anims = {
            {
                bank = "berrybush2", build = "neverfadebush_paper2",
                anim = "shake", anim2 = "idle", isloop = true,
                fn_anim = SetAnim_flowerbush1,
                fn_click = SetClick_neverfadebush,
                x = -48, y = 200, scale = 0.25
            },
            {
                bank = "berrybush2", build = "neverfadebush_paper2",
                anim = "shake", anim2 = "idle", isloop = true,
                fn_anim = SetAnim_neverfadebush,
                fn_click = SetClick_neverfadebush,
                x = 45, y = 145, scale = 0.25
            },
            {
                bank = "butterfly", build = "neverfade_butterfly_paper2",
                anim = "land", anim2 = "idle", isloop = true,
                x = 5, y = 145, scale = 0.25
            },
            {
                bank = "butterfly", build = "neverfade_butterfly_paper2",
                anim = "take_off", anim2 = "idle_flight_loop", isloop = true,
                x = 70, y = 195, scale = 0.25
            },
            {
                bank = "butterfly", build = "neverfade_butterfly_paper2",
                anim = "take_off", anim2 = "flight_cycle", isloop = true,
                x = -90, y = 90, scale = 0.25
            },
            {
                bank = "neverfade_paper2", build = "neverfade_paper2",
                anim = "idle", anim2 = nil, isloop = false,
                fn_click = SetClick_neverfade,
                x = -85, y = 0, scale = 0.38
            },
            {
                bank = "neverfade_paper2", build = "neverfade_paper2",
                anim = "idle_cover", anim2 = nil, isloop = false,
                x = -30, y = -2, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "swap_object", build = "neverfade_paper2", file = "normal_swap", type = 1 },
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 45, y = 0, scale = 0.38
            }
        }
    },
    siving_feather_real_paper = {
        string = ischinese and {
            name = "十字四方纸镖",
            collection = "PAPER", access = "SPECIAL",
            descitem = "解锁\"子圭·翰\"、\"子圭玄鸟绒羽\"的皮肤。",
            description = "“啊，我的眼睛！”，一位同学的眼睛被纸飞镖戳伤，肇事者逃之夭夭。班主任知道后为这位同学主持公道，看到地上的纸飞镖，精致不一般，立马就觉得这是佩柏的“杰作”，把这件事告诉了佩柏的父亲。\n佩柏的纸飞镖本来放在自己的书包里，他课间休息时总喜欢偷偷拿出来把玩，被身后的同学瞄到。于是他趁着佩柏上厕所，擅自拿走了纸飞镖，跑到人头攒动的走廊玩耍，一不小心就戳到了一位同学的眼睛，知道闯祸的他迅速离开“案发现场”。\n当天佩柏放学回到家，父亲早就守在门口。父亲责怪他不知道努力学习，就搞些没用的纸玩意，佩柏很郁闷，但无力反驳。佩柏被罚不准吃晚饭，于是趁着父亲吃饭的时机，再次折起纸来。由于自己的纸飞镖被没收，他决定重新做一个。这次的纸飞镖，工序更复杂更繁美，每一折每一转都是他的心事流露。"
        } or {
            name = "Cross Square Paper Dart",
            collection = "PAPER", access = "SPECIAL",
            descitem = "Unlock \"True Siving Feather\", \"Siving Feather\" skin.",
            description = "The story was not translated."
        },
        height_anim = 265,
        anims = {
            {
                bank = "siving_feather_real_paper", build = "siving_feather_real_paper",
                anim = "item", anim2 = nil, isloop = false,
                x = -55, y = 130, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "lantern_overlay", build = "siving_feather_real_paper", file = "swap", type = 1 },
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 35, y = 130, scale = 0.38
            },
            {
                bank = "siving_feather_fake_paper", build = "siving_feather_fake_paper",
                anim = "item", anim2 = nil, isloop = false,
                x = -55, y = 0, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "lantern_overlay", build = "siving_feather_fake_paper", file = "swap", type = 1 },
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 35, y = 0, scale = 0.38
            }
        }
    },
    siving_feather_real_collector = {
        string = ischinese and {
            collection = "COLLECTOR", access = "SPECIAL",
            descitem = "解锁\"子圭·翰\"、\"子圭玄鸟绒羽\"的皮肤。",
            description = ""
        } or {
            collection = "COLLECTOR", access = "SPECIAL",
            descitem = "Unlock \"True Siving Feather\", \"Siving Feather\" skin.",
            description = "The story was not translated."
        },
        height_anim = 265,
        anims = {
            {
                bank = "kitcoon", build = "siving_feather_real_collector", face = FACING_DOWNRIGHT,
                anim = "jump_out", anim2 = "idle_loop", isloop = true,
                touchanim = "emote_lick",
                fn_click = SetAnim_backcub,
                x = -55, y = 135, scale = 0.34
            },
            {
                symbol = {
                    { symbol = "lantern_overlay", build = "siving_feather_real_collector", file = "swap_show", type = 1 },
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 35, y = 130, scale = 0.38
            },
            {
                bank = "kitcoon", build = "siving_feather_fake_collector", face = FACING_DOWNRIGHT,
                anim = "sleep_pre", anim2 = "sleep_loop", isloop = true,
                fn_click = SetAnim_sivfeather,
                x = -55, y = 5, scale = 0.34
            },
            {
                symbol = {
                    { symbol = "lantern_overlay", build = "siving_feather_fake_collector", file = "swap_show", type = 1 },
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 35, y = 0, scale = 0.38
            },
            {
                bank = "goldnugget", build = "siving_feather_collector_fx",
                anim = "sparkle", anim2 = nil, isloop = false,
                x = -50, y = 180, scale = 0.38
            },
            {
                bank = "goldnugget", build = "siving_feather_collector_fx",
                anim = "sparkle", anim2 = nil, isloop = false,
                x = -40, y = 190, scale = 0.38
            },
            {
                bank = "goldnugget", build = "siving_feather_collector_fx",
                anim = "sparkle", anim2 = nil, isloop = false,
                x = -70, y = 150, scale = 0.38
            },
            {
                bank = "goldnugget", build = "siving_feather_collector_fx",
                anim = "sparkle", anim2 = nil, isloop = false,
                x = -90, y = 220, scale = 0.38
            },
            {
                bank = "goldnugget", build = "siving_feather_collector_fx",
                anim = "sparkle", anim2 = nil, isloop = false,
                x = -65, y = 40, scale = 0.38
            },
            {
                bank = "goldnugget", build = "siving_feather_collector_fx",
                anim = "sparkle", anim2 = nil, isloop = false,
                x = -100, y = 55, scale = 0.38
            },
            {
                bank = "goldnugget", build = "siving_feather_collector_fx",
                anim = "sparkle", anim2 = nil, isloop = false,
                x = -30, y = -5, scale = 0.38
            }
        }
    },
    revolvedmoonlight_item_taste = {
        string = ischinese and {
            name = "黄桃芒芒",
            collection = "TASTE", access = "SPECIAL",
            descitem = "解锁\"月轮宝盘套件\"、\"月轮宝盘\"的皮肤。",
            description = "近几月冰之国总是遭到蘑怪的侵扰。冰灵损失惨重，因为被蘑怪抓伤后会逐渐长满菌丝绒毛而死。冰王不得已加快了冰灵的创造，用料和做工也不再那么细心。小芒就是冰王用低廉的冰激凌底料，普通黄桃以及滥大街的芒果而创造出来的冰灵，然后马上就被派到了边哨站岗。\n芒队长每天都认真教授小芒等队员如何与蘑怪对抗。芒队长已经见证了太多队友的离别，所以格外强调，最重要的是如何活下来！\n没过几天，夜里警报响起！小芒虽然知道自己是粗制滥造出来的劣质冰灵，浑身发抖，但为了王国，坚定了信念，还是冲了出去……",
        } or {
            name = "Mango Sundae",
            collection = "TASTE", access = "SPECIAL",
            descitem = "Unlock \"Revolved Moonlight Kit\", \"Revolved Moonlight\" skin.",
            description = "The story was not translated.",
        },
        height_anim = 180,
        anims = {
            {
                bank = "ui_chest_3x3", build = "ui_revolvedmoonlight_taste_4x3",
                anim = "open", anim2 = nil, isloop = false,
                x = 0, y = 140, scale = 0.24
            },
            {
                bank = "revolvedmoonlight_item_taste", build = "revolvedmoonlight_item_taste",
                anim = "idle", anim2 = nil, isloop = false,
                x = 0, y = 0, scale = 0.32
            },
            {
                bank = "revolvedmoonlight_taste", build = "revolvedmoonlight_taste",
                anim = "close", anim2 = "closed", isloop = false,
                fn_click = SetClick_revolvedmoonlight,
                x = -65, y = 0, scale = 0.32
            },
            {
                bank = "revolvedmoonlight_pro_taste", build = "revolvedmoonlight_taste",
                anim = "close", anim2 = "closed", isloop = false,
                fn_click = SetClick_revolvedmoonlight,
                x = 65, y = 0, scale = 0.32
            }
        }
    },
    revolvedmoonlight_item_taste2 = {
        string = ischinese and {
            name = "巧遇莓莓",
            collection = "TASTE", access = "SPECIAL",
            descitem = "解锁\"月轮宝盘套件\"、\"月轮宝盘\"的皮肤。",
            description = "红主色调，黑色是点缀。草莓圣代，巧克力为其新增一种高级感。酸酸甜甜，如青春的可爱。",
        } or {
            name = "Strawberry Sundae",
            collection = "TASTE", access = "SPECIAL",
            descitem = "Unlock \"Revolved Moonlight Kit\", \"Revolved Moonlight\" skin.",
            description = "The story was not translated.",
        },
        height_anim = 180,
        anims = {
            {
                bank = "ui_chest_3x3", build = "ui_revolvedmoonlight_taste2_4x3",
                anim = "open", anim2 = nil, isloop = false,
                x = 0, y = 140, scale = 0.24
            },
            {
                bank = "revolvedmoonlight_item_taste2", build = "revolvedmoonlight_item_taste2",
                anim = "idle", anim2 = nil, isloop = false,
                x = 0, y = 0, scale = 0.32
            },
            {
                bank = "revolvedmoonlight_taste2", build = "revolvedmoonlight_taste",
                anim = "close", anim2 = "closed", isloop = false,
                fn_click = SetClick_revolvedmoonlight,
                x = -65, y = 0, scale = 0.32
            },
            {
                bank = "revolvedmoonlight_pro_taste2", build = "revolvedmoonlight_taste",
                anim = "close", anim2 = "closed", isloop = false,
                fn_click = SetClick_revolvedmoonlight,
                x = 65, y = 0, scale = 0.32
            }
        }
    },
    revolvedmoonlight_item_taste3 = {
        string = ischinese and {
            name = "奇异柠檬",
            collection = "TASTE", access = "SPECIAL",
            descitem = "解锁\"月轮宝盘套件\"、\"月轮宝盘\"的皮肤。",
            description = "绿主色调，黄色是点缀。柠檬圣代，奇异果为其新增一种搞怪感。清新酸拧，如跳脱的思维。",
        } or {
            name = "Lemon Sundae",
            collection = "TASTE", access = "SPECIAL",
            descitem = "Unlock \"Revolved Moonlight Kit\", \"Revolved Moonlight\" skin.",
            description = "The story was not translated.",
        },
        height_anim = 180,
        anims = {
            {
                bank = "ui_chest_3x3", build = "ui_revolvedmoonlight_taste3_4x3",
                anim = "open", anim2 = nil, isloop = false,
                x = 0, y = 135, scale = 0.24
            },
            {
                bank = "revolvedmoonlight_item_taste3", build = "revolvedmoonlight_item_taste3",
                anim = "idle", anim2 = nil, isloop = false,
                x = 0, y = 0, scale = 0.32
            },
            {
                bank = "revolvedmoonlight_taste3", build = "revolvedmoonlight_taste",
                anim = "close", anim2 = "closed", isloop = false,
                fn_click = SetClick_revolvedmoonlight,
                x = -65, y = 0, scale = 0.32
            },
            {
                bank = "revolvedmoonlight_pro_taste3", build = "revolvedmoonlight_taste",
                anim = "close", anim2 = "closed", isloop = false,
                fn_click = SetClick_revolvedmoonlight,
                x = 65, y = 0, scale = 0.32
            }
        }
    },
    revolvedmoonlight_item_taste4 = {
        string = ischinese and {
            name = "黑巧旋涡",
            collection = "TASTE", access = "SPECIAL",
            descitem = "解锁\"月轮宝盘套件\"、\"月轮宝盘\"的皮肤。",
            description = "黑主色调，蓝色是点缀。黑巧圣代，蓝莓为其新增一种活跃感。丝滑香软，如随性的心态。",
        } or {
            name = "Choccy Sundae",
            collection = "TASTE", access = "SPECIAL",
            descitem = "Unlock \"Revolved Moonlight Kit\", \"Revolved Moonlight\" skin.",
            description = "The story was not translated.",
        },
        height_anim = 180,
        anims = {
            {
                bank = "ui_chest_3x3", build = "ui_revolvedmoonlight_taste4_4x3",
                anim = "open", anim2 = nil, isloop = false,
                x = 0, y = 140, scale = 0.24
            },
            {
                bank = "revolvedmoonlight_item_taste4", build = "revolvedmoonlight_item_taste4",
                anim = "idle", anim2 = nil, isloop = false,
                x = 0, y = 0, scale = 0.32
            },
            {
                bank = "revolvedmoonlight_taste4", build = "revolvedmoonlight_taste",
                anim = "close", anim2 = "closed", isloop = false,
                fn_click = SetClick_revolvedmoonlight,
                x = -65, y = 0, scale = 0.32
            },
            {
                bank = "revolvedmoonlight_pro_taste4", build = "revolvedmoonlight_taste",
                anim = "close", anim2 = "closed", isloop = false,
                fn_click = SetClick_revolvedmoonlight,
                x = 65, y = 0, scale = 0.32
            }
        }
    },
    pinkstaff_tvplay = {
        string = ischinese and {
            collection = "TVPLAY", access = "FREE",
            descitem = "解锁\"幻象法杖\"的皮肤。",
            description = "无人的街道旁蓝光闪过，一位年老的绅士从一个老旧的电话亭里匆忙走出……\n他最近总是收到一个穿越时空传来的警告信号，于是，怀揣不安的心情来到了3202年的地球。\n由于太阳因未知原因而熄灭，地球环境已经破败不堪。他立即前往信号来源，一个空旷的地下农场。在一排排次世代人工培育箱中穿梭，光线强弱不一看不太清，他被突然跳下来的黑影打倒在地……\n“啧啧，约翰·史密斯，啊不，还是该叫你神秘博士”，恍惚中他看到一个满脸疤痕异常渗人的怪物站在自己面前，“好久不见，我猜你肯定不认识我了”。他正准备使用一个钢笔样的东西脱身，却被这个怪物一下打掉，“哈哈，别以为我不知道你的能耐，之前我可被你害惨了！”。他吃痛回复道，“是吗，让你尝尝我这一世的新花样吧”，然后被打飞的那个东西一瞬间发出了强烈的电光……"
        } or {
            collection = "TVPLAY", access = "FREE",
            descitem = "Unlock \"Illusion Staff\" skin.",
            description = "The story was not translated."
        },
        height_anim = 145,
        anims = {
            {
                bank = "pinkstaff_tvplay", build = "pinkstaff_tvplay",
                anim = "idle", anim2 = nil, isloop = false,
                x = -45, y = 0, scale = 0.38
            },
            {
                bank = "pinkstaff_fx_tvplay", build = "pinkstaff_fx_tvplay",
                anim = "idle", anim2 = nil, isloop = true,
                fn_anim = function(self, anim, data)
                    local animstate = anim:GetAnimState()
                    SetAnim_base(animstate, data)
                    animstate:SetBloomEffectHandle("shaders/anim.ksh")
                    animstate:SetMultColour(115/255, 217/255, 255/255, 0.8)
                end,
                x = -54, y = 56, scale = 0.38
            },
            {
                symbol = {
                    { symbol = "swap_object", build = "pinkstaff_tvplay", file = "swap_object", type = 1 },
                },
                fn_anim = SetAnim_player,
                fn_click = SetAnim_player2,
                x = 45, y = 0, scale = 0.38
            }
        }
    },
    plant_cactus_meat_l_world = {
        string = ischinese and {
            collection = "DISGUISER", access = "SPECIAL",
            descitem = "解锁\"仙人柱\"的皮肤。",
            description = ""
        } or {
            collection = "DISGUISER", access = "SPECIAL",
            descitem = "Unlock \"Cactaceae\" skin.",
            description = "The story was not translated."
        },
        height_anim = 134,
        anims = {
            {
                bank = "plant_cactus_meat_l_world", build = "plant_cactus_meat_l_world",
                anim = "level4_3", anim2 = nil, isloop = false,
                symbol = {
                    { symbol = "flowerplus", build = "plant_cactus_meat_l_world", file = "flomax" }
                },
                fn_anim = SetAnim_plant_cactus,
                fn_click = SetClick_plant_cactus,
                x = -52, y = 5, scale = 0.32
            },
            {
                bank = "plant_cactus_meat_l_world", build = "plant_cactus_meat_l_world",
                anim = "level1_3", anim2 = nil, isloop = false,
                tag_start = 2,
                fn_click = SetClick_plant_cactus,
                x = 50, y = 5, scale = 0.32
            }
        }
    },
    siving_ctlall_era = {
        string = ischinese and {
            collection = "ERA", access = "SPECIAL",
            descitem = "解锁\"子圭·利川\"、\"子圭·益矩\"、\"子圭·崇溟\"的皮肤。",
            description = ""
        } or {
            collection = "ERA", access = "SPECIAL",
            descitem = "Unlock \"Siving-Eau\", \"Siving-Alim\", \"Siving-Ridge\" skin.",
            description = "The story was not translated."
        },
        height_anim = 213,
        anims = {
            {
                bank = "siving_ctlall_era", build = "siving_ctlall_era",
                anim = "idle", anim2 = nil, isloop = false,
                fn_click = SetClick_siving_ctl,
                x = 0, y = 5, scale = 0.26
            },
            {
                bank = "siving_ctlwater_era", build = "siving_ctlwater_era",
                anim = "idle", anim2 = nil, isloop = false,
                fn_click = SetClick_siving_ctl,
                x = -66, y = 5, scale = 0.26
            },
            {
                bank = "siving_ctldirt_era", build = "siving_ctldirt_era",
                anim = "idle", anim2 = nil, isloop = false,
                fn_click = SetClick_siving_ctl,
                x = 66, y = 5, scale = 0.26
            },
            {
                bank = "farm_plant_happiness", build = "farm_plant_happiness",
                anim = "happy", anim2 = nil, isloop = false,
                x = 0, y = 5, scale = 0.26
            },
            {
                bank = "farm_plant_happiness", build = "farm_plant_happiness",
                anim = "happy", anim2 = nil, isloop = false,
                x = -66, y = 5, scale = 0.26
            },
            {
                bank = "farm_plant_happiness", build = "farm_plant_happiness",
                anim = "happy", anim2 = nil, isloop = false,
                x = 66, y = 5, scale = 0.26
            }
        }
    },
}

local function GetName(skin)
    local data = SkinData[skin]
    if data ~= nil and data.string ~= nil and data.string.name ~= nil then
        return data.string.name
    else
        return GetSkinName(skin)
    end
end
local function GetCollection(skin)
    local data = SkinData[skin]
    if data ~= nil and data.string ~= nil and data.string.collection ~= nil then
        return SkinStrings.COLLECTION[data.string.collection]
    else
        return SkinStrings.COLLECTION.UNKNOWN
    end
end
local function GetDescription(data)
    if data ~= nil and data.string ~= nil and data.string.description ~= nil then
        return data.string.description
    else
        return SkinStrings.UNKNOWN_STORY
    end
end
local function GetAccess(data)
    if data ~= nil and data.string ~= nil and data.string.access ~= nil then
        return SkinStrings.ACCESS[data.string.access]
    else
        return SkinStrings.ACCESS.UNKNOWN
    end
end
local function GetDescItem(data)
    if data ~= nil and data.string ~= nil and data.string.descitem ~= nil then
        return data.string.descitem
    else
        return "未知解锁项目"
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
local function PushPopupDialog(self, title, message, buttontext, fn)
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

    --[[(tip: 皮肤获取通道删除)
    --cdk输入框
    self.input_cdk = self.proot:AddChild(TEMPLATES2.StandardSingleLineTextEntry(nil, 200, 40))
    self.input_cdk.textbox:SetTextLengthLimit(20)
    self.input_cdk.textbox:EnableWordWrap(false)
    self.input_cdk.textbox:EnableScrollEditWindow(true)
    self.input_cdk.textbox:SetTextPrompt(SkinStrings.UI_INPUT_CDK, UICOLOURS.GREY)
    self.input_cdk.textbox.prompt:SetHAlign(ANCHOR_MIDDLE)
    self.input_cdk.textbox:SetHAlign(ANCHOR_MIDDLE)
    self.input_cdk.textbox:SetCharacterFilter("-0123456789QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm")
    self.input_cdk:SetOnGainFocus( function() self.input_cdk.textbox:OnGainFocus() end )
    self.input_cdk:SetOnLoseFocus( function() self.input_cdk.textbox:OnLoseFocus() end )
    self.input_cdk:SetPosition(140, -130)
    self.input_cdk.focus_forward = self.input_cdk.textbox

    --cdk确认输入按钮
    self.button_cdk = self.proot:AddChild(
        ImageButton("images/global_redux.xml", "button_carny_long_normal.tex",
            "button_carny_long_hover.tex", "button_carny_long_disabled.tex", "button_carny_long_down.tex")
    )
    self.button_cdk.image:SetScale(.3, .35)
    self.button_cdk:SetFont(CHATFONT)
    self.button_cdk:SetPosition(140, -165)
    self.button_cdk.text:SetColour(0,0,0,1)
    self.button_cdk:SetTextSize(20)
    self.button_cdk:SetText(STRINGS.UI.MAINSCREEN.REDEEM)
    self.button_cdk:SetOnClick(function()
        if self.loadtag_cdk == 0 then
            return
        end

        local cdk = self.input_cdk.textbox:GetString()
        if cdk == nil or cdk == "" or cdk:utf8len() <= 6 then
            PushPopupDialog(self, "轻声提醒", "请输入正确的兑换码。", "知道啦", nil)
            return
        end
        self:SetCdkState(0, nil) --后续的状态更新需要服务端返回结果过来
        DoRpc(2, { cdk = cdk })
    end)
    ]]--

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
        self.button_cdk:SetText(SkinStrings.UI_LOAD_CDK)
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

    --确定展示配置
    local myskins = SKINS_CACHE_L[self.owner.userid] or {}
    -- local myskins = {
    --     lileaves_marble = true,
    --     icire_rock_era = true,
    -- }
    local expansionshow = false
    local owned1 = 0
    local owned2 = 0
    local owned3 = 0
    local owned4 = 0
    for skinname, value in pairs(SKIN_IDS_LEGION["6278c487c340bf24ab31152c"]) do
        if myskins[skinname] then
            owned1 = 1
            break
        end
    end
    for skinname, value in pairs(SKIN_IDS_LEGION["6278c4acc340bf24ab311530"]) do
        if myskins[skinname] then
            owned2 = 1
            break
        end
    end
    for skinname, value in pairs(SKIN_IDS_LEGION["6278c4eec340bf24ab311534"]) do
        if myskins[skinname] then
            owned3 = 1
            break
        end
    end
    for skinname, value in pairs(SKIN_IDS_LEGION["637f07a28c2f781db2f7f1e8"]) do
        if myskins[skinname] then
            owned4 = 1
            break
        end
    end
    if (owned1 + owned2 + owned3 + owned4) >= 2 then
        expansionshow = true
    end

    --初始化皮肤项
    local items = {}
    for idx,skinname in pairs(SKIN_IDX_LEGION) do
        local v = SKINS_LEGION[skinname]
        if v ~= nil then
            if not v.noshopshow then
                local isowned = false
                if v.skin_id == "notnononl" or myskins[skinname] then
                    isowned = true
                end

                if
                    isowned or --自己拥有的
                    (expansionshow and not v.mustonwedshow) or --拓展显示
                    (not expansionshow and not v.onlyownedshow) --默认显示
                then
                    local item = {
                        item_key = skinname,
                        item_id = skinname, --(不管)
                        owned_count = 0, --已拥有数量(不管)
                        isnew = false, --是否新皮肤(不管)
                        isfocused = false, --是否处于被鼠标移入状态(不管)
                        isselected = false, --是否处于选中状态
                        isowned = isowned, --是否拥有该皮肤
                        isunlockable = not isowned, --是否可解锁
                        idx = nil,
                        context = nil --存下的组件
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
        self.label_skinname:SetString(GetName(item.item_key))

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
                    self.button_access:SetText(SkinStrings.UI_ACCESS)
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
    label_skinaccess:SetString(GetAccess(skindata))
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
    label_skindescitem:SetString(GetDescItem(skindata))
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
    text_story:SetMultilineTruncatedString(GetDescription(skindata), 100, 220)
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
        anim:SetFacing(v.face or FACING_DOWN)

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

local function GetRightRoot()
    if ThePlayer and ThePlayer.HUD and ThePlayer.HUD.controls then
        return ThePlayer.HUD.controls.right_root
    end
    return nil
end
function SkinLegionDialog:Close()
    if self.panel_iteminfo ~= nil then
        self.panel_iteminfo:Kill()
    end
	self:Kill()

    local right_root = GetRightRoot()
    if right_root ~= nil then
        right_root.skinshop_l = nil
    end
end

return SkinLegionDialog
