local L = locale ~= "zh" and locale ~= "zhr" --true-英文; false-中文

--另一种写法
-- name = ChooseTranslationTable({
--     [1] = "[DST] Legion",
--     zh = "[DST] 棱镜",
-- })

name = L and "[DST] Legion" or "[DST] 棱镜"
author = "ti_Tout"
version = "7.0.2" --每次更新时为了上传必须更改
description =
    L and "Thanks for using this mod!\n                                           [version]"..version.."  [file]1392778117\n\n*As you can see, this mod includes much of the imagination of the mod makers. I really want to make this mod like a DLC, can we wait until it happens?\n\nSpecial thanks：半夏微暖半夏凉(Code consultant)、羽中就是他(Guest artist)、Mr鲁鲁(Lines writer)"
    or "感谢订阅本mod！                                    [版本]"..version.."  [文件]1392778117\n\n*如你所见，本mod包括了作者的很多的脑洞，我也很想把这个mod做成像DLC一样的规模，敬请期待吧。\n*本mod为个人爱好所做，禁止任何个人或组织转载、除自用外的修改、发布或其他形式的侵犯本mod权益的行为！\n\n特别感谢：半夏微暖半夏凉(代码指导)、羽中就是他(客串画佬)、Mr鲁鲁(台词写者)"

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
configuration_options =
{
    {name = "Title", label = L and "Language" or "语言", options = {{description = "", data = ""},}, default = "",},
    L and {
        name = "Language",
        label = "Set Language",
        hover = "Choose your language", --这个是鼠标指向选项时会显示更详细的信息
        options =
        {
            -- {description = "Auto", data = "auto"},
            {description = "English", data = "english"},
            {description = "Chinese", data = "chinese"},
        },
        default = "english",
    } or {
        name = "Language",
        label = "设置语言",
        hover = "设置mod语言。亲，你的英语四六级过了吗？",
        options =
        {
            -- {description = "自动", data = "auto"},
            {description = "英文", data = "english"},
            {description = "中文", data = "chinese"},
        },
        default = "chinese",
    },

    -----

    -- {name = "Title", label = "", options = {{description = "", data = ""},}, default = "",},
    -- {
    --     name = "Title",
    --     label = "NewFaces",
    --     options = {{description = "", data = ""},},
    --     default = "",
    -- },
    -- {
    --     name = "NewFaceWarly",
    --     label = "Warly",
    --     hover = "Allow new character-Warly to be added/允许添加新人物-沃利",
    --     options = 
    --     {
    --         {description = "Yes", data = true},
    --         {description = "No", data = false},
    --     },
    --     default = true,
    -- },

    -----

    {name = "Title", label = "", options = {{description = "", data = ""},}, default = "",},
    {
        name = "Title",
        label = L and "ThePowerOfFlowers" or "花香四溢",
        options = {{description = "", data = ""},},
        default = "",
    },
    L and {
        name = "FlowersPower",
        label = "Flowers\' Power",
        hover = "Allow \'the power of flowers\' to be added.",
        options = 
        {
            {description = "Yes", data = true},
            {description = "No", data = false},
        },
        default = true,
    } or {
        name = "FlowersPower",
        label = "开启\"花香四溢\"",
        hover = "允许添加\"花香四溢\"的内容。最好的报复是美丽，最美的盛开是反击！",
        options = 
        {
            {description = "是", data = true},
            {description = "否", data = false},
        },
        default = true,
    },
    L and {
        name = "FlowerWeaponsChance",
        label = "Flower Weapons Chance",
        hover = "Set the chance to get flower weapons.",
        options =
        {
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
            {description = "100%", data = 1.00},
        },
        default = 0.03,
    } or {
        name = "FlowerWeaponsChance",
        label = "花之武器掉落几率",
        hover = "设置花之武器的获取几率。有幸能做一位花中剑客。",
        options =
        {
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
            {description = "100%", data = 1.00},
        },
        default = 0.03,
    },
    L and {
        name = "FoliageathChance",
        label = "Foliageath Chance",
        hover = "Set the chance to get Foliageath.",
        options =
        {
            {description = "0%", data = 0},
            {description = "0.1%", data = 0.001},
            {description = "0.5%(default)", data = 0.005},
            {description = "1%", data = 0.01},
            {description = "3%", data = 0.03},
            {description = "5%", data = 0.05},
            {description = "10%", data = 0.1},
            {description = "25%", data = 0.25},
            {description = "50%", data = 0.5},
            {description = "100%", data = 1.0},
        },
        default = 0.005,
    } or {
        name = "FoliageathChance",
        label = "青枝绿叶掉落几率",
        hover = "设置青枝绿叶的掉落几率。枯叶之下，藏多少情话。",
        options =
        {
            {description = "0%", data = 0},
            {description = "0.1%", data = 0.001},
            {description = "0.5%(默认)", data = 0.005},
            {description = "1%", data = 0.01},
            {description = "3%", data = 0.03},
            {description = "5%", data = 0.05},
            {description = "10%", data = 0.1},
            {description = "25%", data = 0.25},
            {description = "50%", data = 0.5},
            {description = "100%", data = 1.0},
        },
        default = 0.005,
    },

    -----

    {name = "Title", label = "", options = {{description = "", data = ""},}, default = "",},
    {
        name = "Title",
        label = L and "SuperbCuisine" or "美味佳肴",
        options = {{description = "", data = ""},},
        default = "",
    },
    L and {
        name = "SuperbCuisine",
        label = "Superb Cuisine",
        hover = "Allow \'superb cuisine\' to be added.",
        options =
        {
            {description = "Yes", data = true},
            {description = "No", data = false},
        },
        default = true,
    } or {
        name = "SuperbCuisine",
        label = "开启\"美味佳肴\"",
        hover = "允许添加\"美味佳肴\"的内容。给孤独的味蕾增添新的色彩。",
        options =
        {
            {description = "是", data = true},
            {description = "否", data = false},
        },
        default = true,
    },
    L and {
        name = "FestivalRecipes",
        label = "Festival Recipes",
        hover = "Open Festival recipes.",
        options =
        {
            {description = "Yes", data = true},
            {description = "No(default)", data = false},
        },
        default = false,
    } or {
        name = "FestivalRecipes",
        label = "解禁节日料理",
        hover = "开放节日特供的食谱。让你能随时随地烹饪节日料理，享受吧！",
        options =
        {
            {description = "是", data = true},
            {description = "否(默认)", data = false},
        },
        default = false,
    },
    L and {
        name = "BetterCookBook",
        label = "Better CookBook",
        hover = "Players in English environment please ignore this setting.",
        options =
        {
            -- {description = "Yes", data = true},
            {description = "No(default)", data = false},
        },
        default = false,
    } or {
        name = "BetterCookBook",
        label = "优化食谱介绍",
        hover = "优化食谱的介绍界面和信息展示（仅支持中文环境）。这面甜得掉牙了，大叔。",
        options =
        {
            {description = "是(默认)", data = true},
            {description = "否", data = false},
        },
        default = true,
    },

    -----

    {name = "Title", label = "", options = {{description = "", data = ""},}, default = "",},
    {
        name = "Title",
        label = L and "TheSacrificeOfRain" or "祈雨祭",
        options = {{description = "", data = ""},},
        default = "",
    },
    L and {
        name = "PrayForRain",
        label = "Pray For Rain",
        hover = "Allow \'the sacrifice of rain\' to be added.",
        options =
        {
            {description = "Yes", data = true},
            {description = "No", data = false},
        },
        default = true,
    } or {
        name = "PrayForRain",
        label = "开启\"祈雨祭\"",
        hover = "允许添加\"祈雨祭\"的内容。不管是阴还是晴，都是祈求自然而受的恩惠。",
        options =
        {
            {description = "是", data = true},
            {description = "否", data = false},
        },
        default = true,
    },
    L and {
        name = "BookRecipetabs",
        label = "Book Recipetabs",
        hover = "Set recipetabs of Changing Clouds.",
        options =
        {
            {description = "Book(default)", data = "bookbuilder"},
            {description = "Magic", data = "magic"},
        },
        default = "bookbuilder",
    } or {
        name = "BookRecipetabs",
        label = "《多变的云》制作方式",
        hover = "设置《多变的云》的制作栏。书中自有黄金屋，还是真理在人间？",
        options =
        {
            {description = "书籍栏(默认)", data = "bookbuilder"},
            {description = "魔法栏", data = "magic"},
        },
        default = "bookbuilder",
    },

    -----

    {name = "Title", label = "", options = {{description = "", data = ""},}, default = "",},
    {
        name = "Title",
        label = L and "LegendOfFall" or "丰饶传说",
        options = {{description = "", data = ""},},
        default = "",
    },
    L and {
        name = "LegendOfFall",
        label = "Legend Of Fall",
        hover = "Allow \'legend of fall\' to be added.",
        options =
        {
            {description = "Yes", data = true},
            {description = "No", data = false},
        },
        default = true,
    } or {
        name = "LegendOfFall",
        label = "开启\"丰饶传说\"",
        hover = "允许添加\"丰饶传说\"的内容。如果有一天我能够拥有一个大果园，我愿放下所有追求做个农夫去种田。",
        options =
        {
            {description = "是", data = true},
            {description = "否", data = false},
        },
        default = true,
    },
    -- L and {
    --     name = "GrowthRate",
    --     label = "Growth rate",
    --     hover = "Setting growth rate of Crops.",
    --     options =
    --     {
    --         {description = "0.7x", data = 0.7},
    --         {description = "1x(default)", data = 1},
    --         {description = "1.5x", data = 1.5},
    --         {description = "2x", data = 2},
    --     },
    --     default = 1,
    -- } or {
    --     name = "GrowthRate",
    --     label = "农作物生长速度",
    --     hover = "设置农作物的生长速度。长得这么慢，绝对没打激素！",
    --     options =
    --     {
    --         {description = "0.7倍", data = 0.7},
    --         {description = "1倍(默认)", data = 1},
    --         {description = "1.5倍", data = 1.5},
    --         {description = "2倍", data = 2},
    --     },
    --     default = 1,
    -- },
    -- L and {
    --     name = "CropYields",
    --     label = "Crop Yields",
    --     hover = "Setting crop yields.",
    --     options =
    --     {
    --         {description = "random(default)", data = 0},
    --         {description = "at least 1", data = 1},
    --         {description = "at least 2", data = 2},
    --         {description = "at least 3", data = 3},
    --     },
    --     default = 0,
    -- } or {
    --     name = "CropYields",
    --     label = "农作物产量",
    --     hover = "设置农作物的产量。你啥货色，它就给你啥脸色。",
    --     options =
    --     {
    --         {description = "随机(默认)", data = 0},
    --         {description = "至少1个", data = 1},
    --         {description = "至少2个", data = 2},
    --         {description = "至少3个", data = 3},
    --     },
    --     default = 0,
    -- },
    L and {
        name = "OverripeTime",
        label = "Overripe Time",
        hover = "Set overripe time of X-crops.",
        options =
        {
            {description = "1x(default)", data = 1},
            {description = "2x", data = 2},
            {description = "3x", data = 3},
            {description = "Never", data = 0},
        },
        default = 1,
    } or {
        name = "OverripeTime",
        label = "异种作物过熟时间",
        hover = "设置异种作物过熟的时间。果子熟透了就要掉地上，自然规律真奇妙。",
        options =
        {
            {description = "1倍(默认)", data = 1},
            {description = "2倍", data = 2},
            {description = "3倍", data = 3},
            {description = "不过熟", data = 0},
        },
        default = 1,
    },
    L and {
        name = "PestRisk",
        label = "Pest Risk",
        hover = "Set the chance of pest infestation about X-crops.",
        options =
        {
            {description = "Never", data = 0},
            {description = "0.07%", data = 0.0007},
            {description = "0.2%", data = 0.002},
            {description = "0.7%(default)", data = 0.007},
            {description = "1.2%", data = 0.012},
            {description = "2.0%", data = 0.020},
            {description = "10.0%", data = 0.100},
            {description = "Always", data = 1.000},
        },
        default = 0.007,
    } or {
        name = "PestRisk",
        label = "异种作物虫害率",
        hover = "设置异种作物害虫产生几率。种好你的田，管好你的地！",
        options =
        {
            {description = "不产生", data = 0},
            {description = "0.07%", data = 0.0007},
            {description = "0.2%", data = 0.002},
            {description = "0.7%(默认)", data = 0.007},
            {description = "1.2%", data = 0.012},
            {description = "2.0%", data = 0.020},
            {description = "10.0%", data = 0.100},
            {description = "总是产生", data = 1.000},
        },
        default = 0.007,
    },

    -----

    {name = "Title", label = "", options = {{description = "", data = ""},}, default = "",},
    {
        name = "Title",
        label = L and "FlashAndCrush" or "电闪雷鸣",
        options = {{description = "", data = ""},},
        default = "",
    },
    L and {
        name = "FlashAndCrush",
        label = "Flash And Crush",
        hover = "Allow \'flash and crush\' to be added.",
        options =
        {
            {description = "Yes", data = true},
            {description = "No", data = false},
        },
        default = true,
    } or {
        name = "FlashAndCrush",
        label = "开启\"电闪雷鸣\"",
        hover = "允许添加\"电闪雷鸣\"的内容。电气的力量带来了科技的发展。",
        options =
        {
            {description = "是", data = true},
            {description = "否", data = false},
        },
        default = true,
    },
    L and {
        name = "TechUnlock",
        label = "Tech Unlock",
        hover = "Set up ways to unlock new techs.",
        options =
        {
            {description = "Lootdropper", data = "lootdropper"},            --蓝图掉落模式
            {description = "Prototyper(default)", data = "prototyper"},     --科技解锁模式：这个模式是我推荐的，但因为会修改很多地方，兼容性可能不太好，所以才有了这个设置
        },
        default = "prototyper",
    } or {
        name = "TechUnlock",
        label = "[重铸科技]解锁方式",
        hover = "设置解锁重铸科技的方式。请偷偷的告诉我，你怎么学会的。",
        options =
        {
            {description = "Boss掉落蓝图", data = "lootdropper"},
            {description = "电气重铸台(默认)", data = "prototyper"},
        },
        default = "prototyper",
    },

    -----

    {name = "Title", label = "", options = {{description = "", data = ""},}, default = "",},
    {
        name = "Title",
        label = L and "DesertSecret" or "尘市蜃楼",
        options = {{description = "", data = ""},},
        default = "",
    },
    L and {
        name = "DesertSecret",
        label = "The Desert Secret",
        hover = "Allow \'desert secret\' to be added.",
        options =
        {
            {description = "Yes", data = true},
            {description = "No", data = false},
        },
        default = true,
    } or {
        name = "DesertSecret",
        label = "开启\"尘市蜃楼\"",
        hover = "允许添加\"尘市蜃楼\"的内容。黄沙之中，有座幻影般的古城和悲惨的命运。",
        options =
        {
            {description = "是", data = true},
            {description = "否", data = false},
        },
        default = true,
    },
    L and {
        name = "DressUp",
        label = "Enable Facade",
        hover = "Enable facade function.",
        options =
        {
            {description = "Yes", data = true},
            {description = "No", data = false},
        },
        default = true,
    } or {
        name = "DressUp",
        label = "启用幻化机制",
        hover = "是否启用幻化机制。沉迷幻想是件好事吗。",
        options =
        {
            {description = "是", data = true},
            {description = "否", data = false},
        },
        default = true,
    },

    -----

    {name = "Title", label = "", options = {{description = "", data = ""},}, default = "",},
    {
        name = "Title",
        label = L and "Other" or "其他",
        options = {{description = "", data = ""},},
        default = "",
    },
    L and {
        name = "CleaningUpStench",
        label = "Cleaning Up Stench",
        hover = "Auto-cleaning-up smelly things on the ground.",
        options =
        {
            {description = "Yes", data = true},
            {description = "No(default)", data = false},
        },
        default = false,
    } or {
        name = "CleaningUpStench",
        label = "臭臭自动清理",
        hover = "自动清除掉在地上的臭东西(大便、鸟粪、腐烂物)。化作春泥更护花。",
        options =
        {
            {description = "是", data = true},
            {description = "否(默认)", data = false},
        },
        default = false,
    },
    L and {
        name = "BackCubChance",
        label = "Back Cub Chance",
        hover = "Set the chance to get Back Cub.",
        options =
        {
            {description = "100%", data = 1},
            {description = "85%", data = 0.85},
            {description = "70%(default)", data = 0.7},
            {description = "55%", data = 0.55},
            {description = "40%", data = 0.4},
            {description = "25%", data = 0.25},
            {description = "10%", data = 0.1},
            {description = "0%", data = 0},
        },
        default = 0.7,
    } or {
        name = "BackCubChance",
        label = "靠背熊掉落几率",
        hover = "设置靠背熊的掉落几率。又萌又懒又喜欢吃的小宠物谁不爱呢？",
        options =
        {
            {description = "总是掉落", data = 1},
            {description = "85%", data = 0.85},
            {description = "70%(默认)", data = 0.7},
            {description = "55%", data = 0.55},
            {description = "40%", data = 0.4},
            {description = "25%", data = 0.25},
            {description = "10%", data = 0.1},
            {description = "不会掉落", data = 0},
        },
        default = 0.7,
    },
}