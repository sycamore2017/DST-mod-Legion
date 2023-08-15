local L = locale ~= "zh" and locale ~= "zhr" --true-英文; false-中文

--另一种写法
-- name = ChooseTranslationTable({
--     [1] = "[DST] Legion",
--     zh = "[DST] 棱镜",
-- })

name = L and "[DST] Legion" or "[DST] 棱镜"
author = "ti_Tout"
version = "7.2.8" --每次更新时为了上传必须更改
description =
    L and "Thanks for using this mod!\n                                           [version]"..version.."  [file]1392778117\n\n*As you can see, this mod includes much of the imagination of the mod makers. I really want to make this mod like a DLC, can we wait until it happens?\n\nSpecial thanks：半夏微暖半夏凉(Code consultant)、羽中就是他(Guest artist)、风铃草(Functional supporter)、白饭(Wiki editor)"
    or "感谢订阅本mod！                                    [版本]"..version.."  [文件]1392778117\n\n*如你所见，本mod包括了作者的很多的脑洞，我也很想把这个mod做成像DLC一样的规模，敬请期待吧。\n*本mod为个人爱好所做，禁止任何个人或组织转载、除自用外的修改、发布或其他形式的侵犯本mod权益的行为！\n\n特别感谢：半夏微暖半夏凉(代码指导)、羽中就是他(客串画佬)、风铃草(特功支持)、白饭(百科编辑)"

--个人网址，即使没有也必须留空
forumthread = L and "" or "https://www.zybuluo.com/Tout/note/1509031"

--lua版本，单机写6，联机写10
api_version = 10

--mod加载的优先级，不写就默认为0，越大越优先加载
priority = -345

-- Compatible with Don't Starve Together
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false

--These let clients know if they need to get the mod from the Steam Workshop to join the game, Character mods need this set to true
all_clients_require_mod = true

--This determines whether it causes a server to be marked as modded (and shows in the mod list)
client_only_mod = false

--mod的图标
icon_atlas = "modicon.xml"
icon = "modicon.tex"

-- The mod's tags displayed on the server list
server_filter_tags = L and { "LEGION", } or { "棱镜", }

--mod设置
configuration_options = L and {
    {name = "Title", label = "Special Settings", options = {{description = "", data = ""}}, default = ""},
    {   name = "Language",
        label = "Set Language",
        hover = "Choose your language", --这个是鼠标指向选项时会显示更详细的信息
        options = {
            -- {description = "Auto", data = "auto"},
            {description = "English", data = "english"},
            {description = "Chinese", data = "chinese"}
        },
        default = "english"
    },
    {   name = "CleaningUpStench",
        label = "Cleaning Up Stench",
        hover = "Auto-cleaning-up smelly things on the ground.",
        options = {
            {description = "Yes", data = true},
            {description = "No(default)", data = false}
        },
        default = false
    },

    {name = "Title", label = "", options = {{description = "", data = ""}}, default = ""},
    {name = "Title", label = "The Power of Flowers", options = {{description = "", data = ""}}, default = ""},
    {   name = "FlowerWeaponsChance",
        label = "Flower Weapons Chance",
        hover = "Set the chance to get flower weapons.",
        options = {
            {description = "0%", data = -0.10},
            {description = "1%", data = 0.01},
            {description = "3%(default)", data = 0.03},
            {description = "5%", data = 0.05},
            {description = "7%", data = 0.07},
            {description = "10%", data = 0.10},
            {description = "15%", data = 0.15},
            {description = "20%", data = 0.20},
            {description = "30%", data = 0.30},
            {description = "50%", data = 0.50},
            {description = "100%", data = 1.00}
        },
        default = 0.03
    },
    {   name = "FoliageathChance",
        label = "Foliageath Chance",
        hover = "Set the chance to get Foliageath.",
        options = {
            {description = "0%", data = 0},
            {description = "0.1%", data = 0.001},
            {description = "0.5%(default)", data = 0.005},
            {description = "1%", data = 0.01},
            {description = "3%", data = 0.03},
            {description = "5%", data = 0.05},
            {description = "10%", data = 0.1},
            {description = "25%", data = 0.25},
            {description = "50%", data = 0.5},
            {description = "100%", data = 1.0}
        },
        default = 0.005
    },
    {   name = "RoseBushSpacing",
        label = "Planting limit radius of Rose Bush",
        hover = "Set the planting limit radius of Rose Bush.",
        options = {
            {description = "0", data = 3},
            {description = "0.75", data = 2},
            {description = "1(default)", data = 1},
            {description = "2(pre-setup)", data = 0},
            {description = "3.2", data = 4},
            {description = "4", data = 5}
        },
        default = 1
    },
    {   name = "LilyBushSpacing",
        label = "Planting limit radius of Lily Bush",
        hover = "Set the planting limit radius of Lily Bush.",
        options = {
            {description = "0", data = 3},
            {description = "0.75", data = 2},
            {description = "1(default)", data = 1},
            {description = "2(pre-setup)", data = 0},
            {description = "3.2", data = 4},
            {description = "4", data = 5}
        },
        default = 1
    },
    {   name = "OrchidBushSpacing",
        label = "Planting limit radius of Orchid Bush",
        hover = "Set the planting limit radius of Orchid Bush.",
        options = {
            {description = "0", data = 3},
            {description = "0.75(default)", data = 2},
            {description = "1(pre-setup)", data = 1},
            {description = "2", data = 0},
            {description = "3.2", data = 4},
            {description = "4", data = 5}
        },
        default = 2
    },

    {name = "Title", label = "", options = {{description = "", data = ""}}, default = ""},
    {name = "Title", label = "Superb Cuisine", options = {{description = "", data = ""}}, default = ""},
    {   name = "FestivalRecipes",
        label = "Festival Recipes",
        hover = "Open Festival recipes.",
        options = {
            {description = "Yes", data = true},
            {description = "No(default)", data = false}
        },
        default = false
    },
    {   name = "BetterCookBook",
        label = "Better CookBook",
        hover = "Players in English environment please ignore this setting.",
        options = {
            -- {description = "Yes", data = true},
            {description = "No(default)", data = false}
        },
        default = false
    },

    {name = "Title", label = "", options = {{description = "", data = ""}}, default = ""},
    {name = "Title", label = "Desert Secret", options = {{description = "", data = ""}}, default = ""},
    {   name = "DressUp",
        label = "Enable Facade",
        hover = "Enable facade function.",
        options = {
            {description = "Yes(default)", data = true},
            {description = "No", data = false}
        },
        default = true
    },

    {name = "Title", label = "", options = {{description = "", data = ""}}, default = ""},
    {name = "Title", label = "Legend of Fall", options = {{description = "", data = ""}}, default = ""},
    {   name = "OverripeTime",
        label = "Overripe Time",
        hover = "Set overripe time of X-crops.",
        options = {
            {description = "1x(default)", data = 1},
            {description = "2x", data = 2},
            {description = "3x", data = 3},
            {description = "Never", data = 0}
        },
        default = 1
    },
    {   name = "PestRisk",
        label = "Pest Risk",
        hover = "Set the chance of pest infestation about X-crops.",
        options = {
            {description = "Never", data = 0},
            {description = "0.07%", data = 0.0007},
            {description = "0.2%", data = 0.002},
            {description = "0.7%(default)", data = 0.007},
            {description = "1.2%", data = 0.012},
            {description = "2.0%", data = 0.020},
            {description = "10.0%", data = 0.100},
            {description = "Always", data = 1.000}
        },
        default = 0.007
    },
    {   name = "PhoenixRebirthCycle",
        label = "Phoenix Rebirth Cycle",
        hover = "Set the time for rebirth about Siving Phoenix.",
        options = {
            {description = "5 sec", data = 5},
            {description = "1 day", data = 480},
            {description = "5 day", data = 2400},
            {description = "10 day", data = 4800},
            {description = "15 day(default)", data = 7200},
            {description = "20 day", data = 9600},
            {description = "25 day", data = 12000},
            {description = "30 day", data = 14400}
        },
        default = 7200
    },
    {   name = "PhoenixBattleDifficulty",
        label = "Phoenix Battle Difficulty",
        hover = "Set the difficulty of BOSS battle with Siving Phoenix.",
        options = {
            {description = "Effortlessly", data = 1},
            {description = "Methodically(default)", data = 2},
            {description = "Anxiously", data = 3}
        },
        default = 2
    },
    {   name = "SivingRootTex",
        label = "Siving Root Texture",
        hover = "Set the texture of Siving Root to avoid intensive phobia.",
        options = {
            {description = "Mod(default)", data = 1},
            {description = "Official", data = 2}
        },
        default = 1
    },
    {   name = "SivFeaDamage",
        label = "Siving-Plume Damage",
        hover = "Set damage of Siving-Plume.",
        options = {
            {description = "1", data = 1},
            {description = "3", data = 3},
            {description = "5", data = 5},
            {description = "8", data = 8},
            {description = "10", data = 10},
            {description = "12", data = 12},
            {description = "15", data = 15},
            {description = "17", data = 17},
            {description = "20", data = 20},
            {description = "23", data = 23},
            {description = "26(default)", data = 26},
            {description = "30", data = 30},
            {description = "34", data = 34},
            {description = "38", data = 38},
            {description = "42", data = 42},
            {description = "48", data = 48},
            {description = "51", data = 51},
            {description = "55", data = 55},
            {description = "60", data = 60},
            {description = "68", data = 68},
            {description = "75", data = 75}
        },
        default = 26
    },
    {   name = "SivFeaHealthCost",
        label = "Siving-Plume Health Cost",
        hover = "Set health consumption of Siving-Plume when using its skill.",
        options = {
            {description = "0", data = 0},
            {description = "0.2", data = 0.2},
            {description = "0.5", data = 0.5},
            {description = "0.8", data = 0.8},
            {description = "1", data = 1},
            {description = "1.2", data = 1.2},
            {description = "1.5(default)", data = 1.5},
            {description = "1.8", data = 1.8},
            {description = "2", data = 2},
            {description = "2.5", data = 2.5},
            {description = "3", data = 3},
            {description = "3.5", data = 3.5},
            {description = "4", data = 4},
            {description = "5", data = 5},
            {description = "7", data = 7},
            {description = "10", data = 10},
            {description = "15", data = 15}
        },
        default = 1.5
    },
    {   name = "SivFeaThrowedNum",
        label = "Max number of throws for Feather Split",
        hover = "Set the maximum number of throws for Feather Split.",
        options = {
            {description = "1", data = 1},
            {description = "2", data = 2},
            {description = "3", data = 3},
            {description = "4", data = 4},
            {description = "5(default)", data = 5},
            {description = "6", data = 6},
            {description = "7", data = 7},
            {description = "8", data = 8},
            {description = "9", data = 9},
            {description = "10", data = 10}
        },
        default = 5
    },
    {   name = "DigestedItemMsg",
        label = "Digested-message of Vase Herb",
        hover = "Send a server message when Vase Herb digest items.",
        options = {
            {description = "On(default)", data = true},
            {description = "Off", data = false}
        },
        default = true
    },
    {   name = "TransTimeCrop",
        label = "Mutation Time of Crops",
        hover = "Set the time for ordinary crops mutation with Siving-Trans.",
        options = {
            {description = "30 sec", data = 0.0625},
            {description = "1 min", data = 0.125},
            {description = "2 min", data = 0.25},
            {description = "4 min", data = 0.5},
            {description = "6 min", data = 0.75},
            {description = "8 min(default)", data = 1},
            {description = "12 min", data = 1.5},
            {description = "16 min", data = 2},
            {description = "24 min", data = 3},
            {description = "32 min", data = 4}
        },
        default = 1
    },
    {   name = "TransTimeSpec",
        label = "Mutation Time Mult of Plants",
        hover = "Set the Time Multiplier for special plants mutation with Siving-Trans.",
        options = {
            {description = "0.0625x", data = 0.0625},
            {description = "0.125x", data = 0.125},
            {description = "0.25x", data = 0.25},
            {description = "0.5x", data = 0.5},
            {description = "0.75x", data = 0.75},
            {description = "1x(default)", data = 1},
            {description = "1.5x", data = 1.5},
            {description = "2x", data = 2},
            {description = "3x", data = 3},
            {description = "4x", data = 4}
        },
        default = 1
    },
    {   name = "SivSolToMedal",
        label = "Siving-Sols Bans Crops in Medals",
        hover = "Set whether the crops in the Functional Medal mod can be planted in Siving-Sols.",
        options = {
            {description = "Not Plantable", data = false},
            {description = "Plantable(default)", data = true}
        },
        default = true
    },

    {name = "Title", label = "", options = {{description = "", data = ""}}, default = ""},
    {name = "Title", label = "Flash and Crush", options = {{description = "", data = ""}}, default = ""},
    {   name = "TechUnlock",
        label = "Tech Unlock",
        hover = "Set up ways to unlock new techs.",
        options = {
            {description = "Lootdropper", data = "lootdropper"},        --蓝图掉落模式
            {description = "Prototyper(default)", data = "prototyper"}  --科技解锁模式：这个模式是我推荐的，但因为会修改很多地方，兼容性可能不太好，所以才有了这个设置
        },
        default = "prototyper"
    },

    {name = "Title", label = "", options = {{description = "", data = ""}}, default = ""},
    {name = "Title", label = "The Sacrifice of Rain", options = {{description = "", data = ""}}, default = ""},
    {   name = "BookRecipetabs",
        label = "Book Recipetabs",
        hover = "Set recipetabs of Changing Clouds.",
        options = {
            {description = "Book(default)", data = "bookbuilder"},
            {description = "Magic", data = "magic"}
        },
        default = "bookbuilder"
    },
    {   name = "HiddenUpdateTimes",
        label = "Max Upgrade Times of Hidden Moonlight",
        hover = "Set the maximum upgrade times of Hidden Moonlight.",
        options = {
            { description = "14 times", data = 14 },
            { description = "28 times", data = 28 },
            { description = "42 times", data = 42 },
            { description = "56 times(default)", data = 56 },
            { description = "70 times", data = 70 },
            { description = "84 times", data = 84 },
            { description = "98 times", data = 98 }
        },
        default = 56
    },
    {   name = "RevolvedUpdateTimes",
        label = "Max Upgrade Times of Revolved Moonlight",
        hover = "Set the maximum upgrade times of Revolved Moonlight.",
        options = {
            { description = "4 times", data = 4 },
            { description = "8 times", data = 8 },
            { description = "12 times", data = 12 },
            { description = "16 times", data = 16 },
            { description = "20 times(default)", data = 20 },
            { description = "24 times", data = 24 },
            { description = "30 times", data = 30 },
            { description = "40 times", data = 40 }
        },
        default = 20
    },
    {   name = "RefractedUpdateTimes",
        label = "Max Upgrade Times of Refracted Moonlight",
        hover = "Set the maximum upgrade times of Refracted Moonlight.",
        options = {
            { description = "1 time", data = 1 },
            { description = "2 times", data = 2 },
            { description = "5 times", data = 5 },
            { description = "7 times", data = 7 },
            { description = "10 times", data = 10 },
            { description = "12 times", data = 12 },
            { description = "14 times(default)", data = 14 },
            { description = "16 times", data = 16 },
            { description = "18 times", data = 18 },
            { description = "20 times", data = 20 },
            { description = "24 times", data = 24 },
            { description = "30 times", data = 30 }
        },
        default = 14
    },

    {name = "Title", label = "", options = {{description = "", data = ""}}, default = ""},
    {name = "Title", label = "Bleak Surge", options = {{description = "", data = ""}}, default = ""},
    {   name = "BackCubChance",
        label = "Back Cub Chance",
        hover = "Set the chance to get Back Cub.",
        options = {
            {description = "100%", data = 1},
            {description = "85%", data = 0.85},
            {description = "70%(default)", data = 0.7},
            {description = "55%", data = 0.55},
            {description = "40%", data = 0.4},
            {description = "25%", data = 0.25},
            {description = "10%", data = 0.1},
            {description = "0%", data = 0}
        },
        default = 0.7
    },
} or {
    {name = "Title", label = "特殊设置", options = {{description = "", data = ""},}, default = ""},
    {   name = "Language",
        label = "设置语言",
        hover = "设置mod语言。亲，你的英语四六级过了吗？",
        options = {
            -- {description = "自动", data = "auto"},
            {description = "英文", data = "english"},
            {description = "中文", data = "chinese"}
        },
        default = "chinese"
    },
    {   name = "CleaningUpStench",
        label = "臭臭自动清理",
        hover = "自动清除掉在地上的臭东西(大便、鸟粪、腐烂物)。化作春泥更护花。",
        options = {
            {description = "是", data = true},
            {description = "否(默认)", data = false}
        },
        default = false
    },

    {name = "Title", label = "", options = {{description = "", data = ""}}, default = ""},
    {name = "Title", label = "花香四溢", options = {{description = "", data = ""}}, default = ""},
    {   name = "FlowerWeaponsChance",
        label = "花之武器掉落几率",
        hover = "设置花之武器的获取几率。有幸能做一位花中剑客。",
        options = {
            {description = "0%", data = -0.10},
            {description = "1%", data = 0.01},
            {description = "3%(默认)", data = 0.03},
            {description = "5%", data = 0.05},
            {description = "7%", data = 0.07},
            {description = "10%", data = 0.10},
            {description = "15%", data = 0.15},
            {description = "20%", data = 0.20},
            {description = "30%", data = 0.30},
            {description = "50%", data = 0.50},
            {description = "100%", data = 1.00}
        },
        default = 0.03
    },
    {   name = "FoliageathChance",
        label = "青枝绿叶掉落几率",
        hover = "设置青枝绿叶的掉落几率。枯叶之下，藏多少情话。",
        options = {
            {description = "0%", data = 0},
            {description = "0.1%", data = 0.001},
            {description = "0.5%(默认)", data = 0.005},
            {description = "1%", data = 0.01},
            {description = "3%", data = 0.03},
            {description = "5%", data = 0.05},
            {description = "10%", data = 0.1},
            {description = "25%", data = 0.25},
            {description = "50%", data = 0.5},
            {description = "100%", data = 1.0}
        },
        default = 0.005
    },
    {   name = "RoseBushSpacing",
        label = "蔷薇花丛种植间隔",
        hover = "设置蔷薇花丛种植时的间隔半径限制。选择便捷还是美观？",
        options = {
            {description = "0", data = 3},
            {description = "0.75", data = 2},
            {description = "1(默认)", data = 1},
            {description = "2(旧设)", data = 0},
            {description = "3.2", data = 4},
            {description = "4", data = 5}
        },
        default = 1
    },
    {   name = "LilyBushSpacing",
        label = "蹄莲花丛种植间隔",
        hover = "设置蹄莲花丛种植时的间隔半径限制。选择便捷还是美观？",
        options = {
            {description = "0", data = 3},
            {description = "0.75", data = 2},
            {description = "1(默认)", data = 1},
            {description = "2(旧设)", data = 0},
            {description = "3.2", data = 4},
            {description = "4", data = 5}
        },
        default = 1
    },
    {   name = "OrchidBushSpacing",
        label = "兰草花丛种植间隔",
        hover = "设置兰草花丛种植时的间隔半径限制。选择便捷还是美观？",
        options = {
            {description = "0", data = 3},
            {description = "0.75(默认)", data = 2},
            {description = "1(旧设)", data = 1},
            {description = "2", data = 0},
            {description = "3.2", data = 4},
            {description = "4", data = 5}
        },
        default = 2
    },

    {name = "Title", label = "", options = {{description = "", data = ""}}, default = ""},
    {name = "Title", label = "美味佳肴", options = {{description = "", data = ""}}, default = ""},
    {   name = "FestivalRecipes",
        label = "解禁节日料理",
        hover = "开放节日特供的食谱。让你能随时随地烹饪节日料理，享受吧！",
        options = {
            {description = "是", data = true},
            {description = "否(默认)", data = false}
        },
        default = false
    },
    {   name = "BetterCookBook",
        label = "优化食谱介绍",
        hover = "优化食谱的介绍界面和信息展示（仅支持中文环境）。想吃什么自己做！",
        options = {
            {description = "是(默认)", data = true},
            {description = "否", data = false}
        },
        default = true
    },

    {name = "Title", label = "", options = {{description = "", data = ""}}, default = ""},
    {name = "Title", label = "尘市蜃楼", options = {{description = "", data = ""}}, default = ""},
    {   name = "DressUp",
        label = "启用幻化机制",
        hover = "是否启用幻化机制。沉迷幻想是件好事吗。",
        options = {
            {description = "是(默认)", data = true},
            {description = "否", data = false}
        },
        default = true
    },

    {name = "Title", label = "", options = {{description = "", data = ""}}, default = ""},
    {name = "Title", label = "丰饶传说", options = {{description = "", data = ""}}, default = ""},
    {   name = "OverripeTime",
        label = "异种作物过熟时间",
        hover = "设置异种作物过熟的时间。果子熟透了就要掉地上，自然规律真奇妙。",
        options = {
            {description = "1倍(默认)", data = 1},
            {description = "2倍", data = 2},
            {description = "3倍", data = 3},
            {description = "不过熟", data = 0}
        },
        default = 1
    },
    {   name = "PestRisk",
        label = "异种作物虫害率",
        hover = "设置异种作物害虫产生几率。种好你的田，管好你的地！",
        options = {
            {description = "不产生", data = 0},
            {description = "0.07%", data = 0.0007},
            {description = "0.2%", data = 0.002},
            {description = "0.7%(默认)", data = 0.007},
            {description = "1.2%", data = 0.012},
            {description = "2.0%", data = 0.020},
            {description = "10.0%", data = 0.100},
            {description = "总是产生", data = 1.000}
        },
        default = 0.007
    },
    {   name = "PhoenixRebirthCycle",
        label = "玄鸟重生周期",
        hover = "设置子圭玄鸟再生的所需时间。生死是个循环！",
        options = {
            {description = "5秒", data = 5},
            {description = "1天", data = 480},
            {description = "5天", data = 2400},
            {description = "10天", data = 4800},
            {description = "15天(默认)", data = 7200},
            {description = "20天", data = 9600},
            {description = "25天", data = 12000},
            {description = "30天", data = 14400}
        },
        default = 7200
    },
    {   name = "PhoenixBattleDifficulty",
        label = "玄鸟战斗难度",
        hover = "设置子圭玄鸟BOSS战的难度。谁是战斗之王，我是手残之王。",
        options = {
            {description = "小菜一碟", data = 1},
            {description = "普普通通(默认)", data = 2},
            {description = "步履艰难", data = 3}
        },
        default = 2
    },
    {   name = "SivingRootTex",
        label = "子圭突触贴图",
        hover = "设置子圭突触的贴图。你要是对它密集恐惧症犯了就换成官方的图吧。",
        options = {
            {description = "mod贴图(默认)", data = 1},
            {description = "官方图", data = 2}
        },
        default = 1
    },
    {   name = "SivFeaDamage",
        label = "子圭·翰的攻击力",
        hover = "设置子圭·翰的攻击力。变态，还是不变态，你自己界定！",
        options = {
            {description = "1", data = 1},
            {description = "3", data = 3},
            {description = "5", data = 5},
            {description = "8", data = 8},
            {description = "10", data = 10},
            {description = "12", data = 12},
            {description = "15", data = 15},
            {description = "17", data = 17},
            {description = "20", data = 20},
            {description = "23", data = 23},
            {description = "26(默认)", data = 26},
            {description = "30", data = 30},
            {description = "34", data = 34},
            {description = "38", data = 38},
            {description = "42", data = 42},
            {description = "48", data = 48},
            {description = "51", data = 51},
            {description = "55", data = 55},
            {description = "60", data = 60},
            {description = "68", data = 68},
            {description = "75", data = 75}
        },
        default = 26
    },
    {   name = "SivFeaHealthCost",
        label = "子圭·翰的技能耗血量",
        hover = "设置子圭·翰使用羽刃分掷时的耗血量。这一定得有个代价，对吗？",
        options = {
            {description = "0", data = 0},
            {description = "0.2", data = 0.2},
            {description = "0.5", data = 0.5},
            {description = "0.8", data = 0.8},
            {description = "1", data = 1},
            {description = "1.2", data = 1.2},
            {description = "1.5(默认)", data = 1.5},
            {description = "1.8", data = 1.8},
            {description = "2", data = 2},
            {description = "2.5", data = 2.5},
            {description = "3", data = 3},
            {description = "3.5", data = 3.5},
            {description = "4", data = 4},
            {description = "5", data = 5},
            {description = "7", data = 7},
            {description = "10", data = 10},
            {description = "15", data = 15}
        },
        default = 1.5
    },
    {   name = "SivFeaThrowedNum",
        label = "羽刃分掷的最大投掷数",
        hover = "设置子圭羽毛在羽刃分掷时的最大投掷数。飞吧！",
        options = {
            {description = "1", data = 1},
            {description = "2", data = 2},
            {description = "3", data = 3},
            {description = "4", data = 4},
            {description = "5(默认)", data = 5},
            {description = "6", data = 6},
            {description = "7", data = 7},
            {description = "8", data = 8},
            {description = "9", data = 9},
            {description = "10", data = 10}
        },
        default = 5
    },
    {   name = "DigestedItemMsg",
        label = "巨食草消化提醒",
        hover = "在巨食草消化物品时发送全服消息。毕竟它什么都吃，安全起见。",
        options = {
            {description = "开启(默认)", data = true},
            {description = "关闭", data = false}
        },
        default = true
    },
    {   name = "TransTimeCrop",
        label = "普通作物转成异种的时间",
        hover = "设置子圭·育转化普通作物所需的时间。你也是时间管理大师吗？",
        options = {
            {description = "30秒", data = 0.0625},
            {description = "1分钟", data = 0.125},
            {description = "2分钟", data = 0.25},
            {description = "4分钟", data = 0.5},
            {description = "6分钟", data = 0.75},
            {description = "8分钟(默认)", data = 1},
            {description = "12分钟", data = 1.5},
            {description = "16分钟", data = 2},
            {description = "24分钟", data = 3},
            {description = "32分钟", data = 4}
        },
        default = 1
    },
    {   name = "TransTimeSpec",
        label = "特殊植物转成异种的时间倍率",
        hover = "设置子圭·育转化特殊植物的时间倍率。你肯定是时间管理大师！",
        options = {
            {description = "0.0625倍", data = 0.0625},
            {description = "0.125倍", data = 0.125},
            {description = "0.25倍", data = 0.25},
            {description = "0.5倍", data = 0.5},
            {description = "0.75倍", data = 0.75},
            {description = "1倍(默认)", data = 1},
            {description = "1.5倍", data = 1.5},
            {description = "2倍", data = 2},
            {description = "3倍", data = 3},
            {description = "4倍", data = 4}
        },
        default = 1
    },
    {   name = "SivSolToMedal",
        label = "子圭·垄兼容能力勋章的作物",
        hover = "是否允许能力勋章mod里的作物被种在子圭·垄里。我有我自己的见解和想法，真的。",
        options = {
            {description = "禁止种植", data = false},
            {description = "允许种植(默认)", data = true}
        },
        default = true
    },

    {name = "Title", label = "", options = {{description = "", data = ""}}, default = ""},
    {name = "Title", label = "电闪雷鸣", options = {{description = "", data = ""}}, default = ""},
    {   name = "TechUnlock",
        label = "[重铸科技]解锁方式",
        hover = "设置解锁重铸科技的方式。请偷偷的告诉我，你怎么学会的。",
        options = {
            {description = "Boss掉落蓝图", data = "lootdropper"},
            {description = "电气重铸台(默认)", data = "prototyper"}
        },
        default = "prototyper"
    },

    {name = "Title", label = "", options = {{description = "", data = ""}}, default = ""},
    {name = "Title", label = "祈雨祭", options = {{description = "", data = ""}}, default = ""},
    {   name = "BookRecipetabs",
        label = "《多变的云》制作方式",
        hover = "设置《多变的云》的制作栏。决定一本巨著的沉沦或现世。",
        options = {
            {description = "书籍栏(默认)", data = "bookbuilder"},
            {description = "魔法栏", data = "magic"}
        },
        default = "bookbuilder"
    },
    {   name = "HiddenUpdateTimes",
        label = "月藏宝匣最大升级次数",
        hover = "设置月藏宝匣的升级次数的最大值。",
        options = {
            { description = "14次", data = 14 },
            { description = "28次", data = 28 },
            { description = "42次", data = 42 },
            { description = "56次(默认)", data = 56 },
            { description = "70次", data = 70 },
            { description = "84次", data = 84 },
            { description = "98次", data = 98 }
        },
        default = 56
    },
    {   name = "RevolvedUpdateTimes",
        label = "月轮宝盘最大升级次数",
        hover = "设置月轮宝盘的升级次数的最大值。",
        options = {
            { description = "4次", data = 4 },
            { description = "8次", data = 8 },
            { description = "12次", data = 12 },
            { description = "16次", data = 16 },
            { description = "20次(默认)", data = 20 },
            { description = "24次", data = 24 },
            { description = "30次", data = 30 },
            { description = "40次", data = 40 }
        },
        default = 20
    },
    {   name = "RefractedUpdateTimes",
        label = "月折宝剑最大升级次数",
        hover = "设置月折宝剑的升级次数的最大值。",
        options = {
            { description = "1次", data = 1 },
            { description = "2次", data = 2 },
            { description = "5次", data = 5 },
            { description = "7次", data = 7 },
            { description = "10次", data = 10 },
            { description = "12次", data = 12 },
            { description = "14次(默认)", data = 14 },
            { description = "16次", data = 16 },
            { description = "18次", data = 18 },
            { description = "20次", data = 20 },
            { description = "24次", data = 24 },
            { description = "30次", data = 30 }
        },
        default = 14
    },

    {name = "Title", label = "", options = {{description = "", data = ""}}, default = ""},
    {name = "Title", label = "黯涌", options = {{description = "", data = ""}}, default = ""},
    {   name = "BackCubChance",
        label = "靠背熊掉落几率",
        hover = "设置靠背熊的掉落几率。又萌又懒又喜欢吃的小宠物谁不爱呢？",
        options = {
            {description = "总是掉落", data = 1},
            {description = "85%", data = 0.85},
            {description = "70%(默认)", data = 0.7},
            {description = "55%", data = 0.55},
            {description = "40%", data = 0.4},
            {description = "25%", data = 0.25},
            {description = "10%", data = 0.1},
            {description = "不会掉落", data = 0}
        },
        default = 0.7
    },
}
