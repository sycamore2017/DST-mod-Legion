local _G = GLOBAL
local STRINGS = _G.STRINGS

local S_NAMES = STRINGS.NAMES                   --各种对象的名字
local S_RECIPE_DESC = STRINGS.RECIPE_DESC       --科技栏里的描述
local S______GENERIC = STRINGS.CHARACTERS.GENERIC      --威尔逊的台词（如果其他角色没有台词则会默认使用威尔逊的）
local S_______WILLOW = STRINGS.CHARACTERS.WILLOW       --薇洛的台词
local S_____WOLFGANG = STRINGS.CHARACTERS.WOLFGANG     --沃尔夫冈的台词
local S________WENDY = STRINGS.CHARACTERS.WENDY        --温蒂的台词
local S_________WX78 = STRINGS.CHARACTERS.WX78         --WX78的台词
local S_WICKERBOTTOM = STRINGS.CHARACTERS.WICKERBOTTOM --维克伯顿的台词
local S_______WOODIE = STRINGS.CHARACTERS.WOODIE       --伍迪的台词
local S______WAXWELL = STRINGS.CHARACTERS.WAXWELL      --麦克斯韦的台词
local S___WATHGRITHR = STRINGS.CHARACTERS.WATHGRITHR   --瓦丝格蕾的台词
local S_______WEBBER = STRINGS.CHARACTERS.WEBBER       --韦伯的台词
local S_______WINONA = STRINGS.CHARACTERS.WINONA       --薇诺娜的台词
local S________WARLY = STRINGS.CHARACTERS.WARLY        --沃利的台词
local S_______WORTOX = STRINGS.CHARACTERS.WORTOX       --沃托克斯的台词
local S_____WORMWOOD = STRINGS.CHARACTERS.WORMWOOD     --沃姆伍德的台词
local S_________WURT = STRINGS.CHARACTERS.WURT         --沃特的台词
local S_______WALTER = STRINGS.CHARACTERS.WALTER       --沃尔特的台词

TUNING.LEGION_MOD_LANGUAGES = "chinese"

--------------------------------------------------------------------------
--[[ the little star in the cave ]]--[[ 洞穴里的星光点点 ]]
--------------------------------------------------------------------------

S_NAMES.HAT_LICHEN = "苔衣发卡"
S_RECIPE_DESC.HAT_LICHEN = "我会有“主意”的。"
S______GENERIC.DESCRIBE.HAT_LICHEN = "我真的有“主意”了！"
S_______WILLOW.DESCRIBE.HAT_LICHEN = "为什么不直接点了它？"
S_____WOLFGANG.DESCRIBE.HAT_LICHEN = "漂亮的小发卡。"
S________WENDY.DESCRIBE.HAT_LICHEN = "阿比盖尔曾经很喜欢这样的发卡。"
S_________WX78.DESCRIBE.HAT_LICHEN = "临时有机光源"
S_WICKERBOTTOM.DESCRIBE.HAT_LICHEN = "字面上的光彩照人。"
S_______WOODIE.DESCRIBE.HAT_LICHEN = "和我的头发一点儿都不搭。"
S______WAXWELL.DESCRIBE.HAT_LICHEN = "这是真的不体面。"
S___WATHGRITHR.DESCRIBE.HAT_LICHEN = "挺漂亮的，可惜没有防御力。"
S_______WEBBER.DESCRIBE.HAT_LICHEN = "温蒂来看看我们做的发卡！"
S_______WINONA.DESCRIBE.HAT_LICHEN = "为了看清楚东西我还是把它戴上吧。"
S________WARLY.DESCRIBE.HAT_LICHEN = "或许可以当作摆盘蔬菜。"
S_______WORTOX.DESCRIBE.HAT_LICHEN = "水影入朱户，萤光生绿苔。"
S_____WORMWOOD.DESCRIBE.HAT_LICHEN = "把发光的朋友戴在头上"
S_________WURT.DESCRIBE.HAT_LICHEN = "不好看，为什么不拿来吃？"
--STRINGS.CHARACTERS.WAGSTAFF.DESCRIBE.HAT_LICHEN = "这样就可以把化学冷光利用起来。"

--------------------------------------------------------------------------
--[[ the power of flowers ]]--[[ 花香四溢 ]]
--------------------------------------------------------------------------

S_NAMES.ROSORNS = "带刺蔷薇"
S______GENERIC.DESCRIBE.ROSORNS = "爱让人毫无防备。"
--S_______WILLOW.DESCRIBE.ROSORNS = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.ROSORNS = "Wolfgang can eat in one bite!"
S________WENDY.DESCRIBE.ROSORNS = "爱情也能给人带来折磨。"
--S_________WX78.DESCRIBE.ROSORNS = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.ROSORNS = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.ROSORNS = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.ROSORNS = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.ROSORNS = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.ROSORNS = "Yaaay! Popsicle, popsicle!"
S_______WINONA.DESCRIBE.ROSORNS = "这香味总能触动我心房。"

S_NAMES.LILEAVES = "蹄莲翠叶"
S______GENERIC.DESCRIBE.LILEAVES = "别说我无可救药。"
--S_______WILLOW.DESCRIBE.LILEAVES = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.LILEAVES = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.LILEAVES = ""
--S_________WX78.DESCRIBE.LILEAVES = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.LILEAVES = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.LILEAVES = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.LILEAVES = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.LILEAVES = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.LILEAVES = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.LILEAVES = "Great to cool off after some hard physical labor."

S_NAMES.ORCHITWIGS = "兰草花穗"
S______GENERIC.DESCRIBE.ORCHITWIGS = "颠倒众生，倾覆繁华。"
--S_______WILLOW.DESCRIBE.ORCHITWIGS = ""
--S_____WOLFGANG.DESCRIBE.ORCHITWIGS = ""
--S________WENDY.DESCRIBE.ORCHITWIGS = ""
--S_________WX78.DESCRIBE.ORCHITWIGS = ""
--S_WICKERBOTTOM.DESCRIBE.ORCHITWIGS = ""
S_______WOODIE.DESCRIBE.ORCHITWIGS = "一点也不惊艳，但是我就是喜欢。"
--S______WAXWELL.DESCRIBE.ORCHITWIGS = ""
--S___WATHGRITHR.DESCRIBE.ORCHITWIGS = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.ORCHITWIGS = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.ORCHITWIGS = "Great to cool off after some hard physical labor."

S_NAMES.ROSEBUSH = "蔷薇花丛"
S______GENERIC.DESCRIBE.ROSEBUSH =
{
    BARREN = "靠她自己可无法重返王座。",
    WITHERED = "都被晒得小了一圈。",
    GENERIC = "美丽，但是有刺。",
    PICKED = "失了花冠，但不失高贵。",
    BURNING = "糟糕！",
}
S_______WILLOW.DESCRIBE.ROSEBUSH =
{
    BARREN = "你可真没用！",
    WITHERED = "哈，更容易点燃了。",
    GENERIC = "开得火红的花。",
    PICKED = "你倒是快点长啊。",
    BURNING = "烧吧，烧吧，这火红！",
}
S_____WOLFGANG.DESCRIBE.ROSEBUSH =
{
    BARREN = "沃尔夫冈会找到肥料的。",
    WITHERED = "沃尔夫冈应该照顾好她的。",
    GENERIC = "沃尔夫冈喜欢看它，不喜欢摘它。",
    PICKED = "沃尔夫冈不怕被刺。",
    BURNING = "啊！这可不好！",
}
-- S________WENDY.DESCRIBE.ROSEBUSH =
S_________WX78.DESCRIBE.ROSEBUSH =
{
    BARREN = "生长循环已暂停。",
    WITHERED = "高温警告，跳出生长循环。",
    GENERIC = "具有初级防御组件的植物。",
    PICKED = "诱惑功能已下线。",
    BURNING = "脆弱的东西。",
}
-- S_WICKERBOTTOM.DESCRIBE.ROSEBUSH =
-- S_______WOODIE.DESCRIBE.ROSEBUSH =
-- S______WAXWELL.DESCRIBE.ROSEBUSH =
-- S___WATHGRITHR.DESCRIBE.ROSEBUSH =
-- S_______WEBBER.DESCRIBE.ROSEBUSH =
-- S_______WINONA.DESCRIBE.ROSEBUSH =
-- S________WARLY.DESCRIBE.ROSEBUSH =
S_______WORTOX.DESCRIBE.ROSEBUSH =
{
    BARREN = "它无力回天，得帮它一把。",
    WITHERED = "红消香断有谁怜？",
    GENERIC = "花开堪折直须折...",
    PICKED = "不要以为...她的头发开不出蔷薇...",
    BURNING = "唉，自古红颜多薄命。",
}
-- S_____WORMWOOD.DESCRIBE.ROSEBUSH = ""
-- S_________WURT.DESCRIBE.ROSEBUSH = ""

S_NAMES.DUG_ROSEBUSH = "蔷薇花丛"
S______GENERIC.DESCRIBE.DUG_ROSEBUSH = "蔷薇带刺，反而如此特别。"
S_______WILLOW.DESCRIBE.DUG_ROSEBUSH = "挖出来后能烧得更彻底。"
--S_____WOLFGANG.DESCRIBE.DUG_ROSEBUSH = ""
--S________WENDY.DESCRIBE.DUG_ROSEBUSH = ""
S_________WX78.DESCRIBE.DUG_ROSEBUSH = "缺乏生长基质。"
--S_WICKERBOTTOM.DESCRIBE.DUG_ROSEBUSH = ""
--S_______WOODIE.DESCRIBE.DUG_ROSEBUSH = ""
--S______WAXWELL.DESCRIBE.DUG_ROSEBUSH = ""
--S___WATHGRITHR.DESCRIBE.DUG_ROSEBUSH = ""
--S_______WEBBER.DESCRIBE.DUG_ROSEBUSH = ""
--S_______WINONA.DESCRIBE.DUG_ROSEBUSH = ""

S_NAMES.CUTTED_ROSEBUSH = "蔷薇折枝"
S______GENERIC.DESCRIBE.CUTTED_ROSEBUSH = "这是植物很常见的繁殖方式。"
--S_______WILLOW.DESCRIBE.CUTTED_ROSEBUSH = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.CUTTED_ROSEBUSH = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.CUTTED_ROSEBUSH = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.CUTTED_ROSEBUSH = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.CUTTED_ROSEBUSH = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.CUTTED_ROSEBUSH = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.CUTTED_ROSEBUSH = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.CUTTED_ROSEBUSH = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.CUTTED_ROSEBUSH = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.CUTTED_ROSEBUSH = "Great to cool off after some hard physical labor."

S_NAMES.LILYBUSH = "蹄莲花丛"
S______GENERIC.DESCRIBE.LILYBUSH =
{
    BARREN = "它无力回天，得帮它一把。",
    WITHERED = "...花落了就枯萎。",
    GENERIC = "花开的时候最珍贵...",
    PICKED = "...花落了就不美。",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "最后，曲终花散。",
}
--[[
S_______WILLOW.DESCRIBE.LILYBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S_____WOLFGANG.DESCRIBE.LILYBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S________WENDY.DESCRIBE.LILYBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S_________WX78.DESCRIBE.LILYBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S_WICKERBOTTOM.DESCRIBE.LILYBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S_______WOODIE.DESCRIBE.LILYBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S______WAXWELL.DESCRIBE.LILYBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S___WATHGRITHR.DESCRIBE.LILYBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S_______WEBBER.DESCRIBE.LILYBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S_______WINONA.DESCRIBE.LILYBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
]]--

S_NAMES.DUG_LILYBUSH = "蹄莲花丛"
S______GENERIC.DESCRIBE.DUG_LILYBUSH = "迫不及待，想看到它的容颜。"
--S_______WILLOW.DESCRIBE.DUG_LILYBUSH = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DUG_LILYBUSH = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DUG_LILYBUSH = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DUG_LILYBUSH = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DUG_LILYBUSH = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DUG_LILYBUSH = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DUG_LILYBUSH = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DUG_LILYBUSH = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DUG_LILYBUSH = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DUG_LILYBUSH = "Great to cool off after some hard physical labor."

S_NAMES.CUTTED_LILYBUSH = "蹄莲芽束"
S______GENERIC.DESCRIBE.CUTTED_LILYBUSH = "这是植物很常见的繁殖方式。"
--S_______WILLOW.DESCRIBE.CUTTED_LILYBUSH = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.CUTTED_LILYBUSH = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.CUTTED_LILYBUSH = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.CUTTED_LILYBUSH = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.CUTTED_LILYBUSH = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.CUTTED_LILYBUSH = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.CUTTED_LILYBUSH = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.CUTTED_LILYBUSH = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.CUTTED_LILYBUSH = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.CUTTED_LILYBUSH = "Great to cool off after some hard physical labor."

S_NAMES.ORCHIDBUSH = "兰草花丛"
S______GENERIC.DESCRIBE.ORCHIDBUSH =
{
    BARREN = "种在小园中，希望花开早。",
    WITHERED = "不采而佩，于兰何伤。",
    GENERIC = "满庭花处处，添的许多香。",
    PICKED = "兰花却依然，苞也无一个。",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "不知其香，不知其殆。",
}
--[[
S_______WILLOW.DESCRIBE.ORCHIDBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S_____WOLFGANG.DESCRIBE.ORCHIDBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S________WENDY.DESCRIBE.ORCHIDBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S_________WX78.DESCRIBE.ORCHIDBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S_WICKERBOTTOM.DESCRIBE.ORCHIDBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S_______WOODIE.DESCRIBE.ORCHIDBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S______WAXWELL.DESCRIBE.ORCHIDBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S___WATHGRITHR.DESCRIBE.ORCHIDBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S_______WEBBER.DESCRIBE.ORCHIDBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S_______WINONA.DESCRIBE.ORCHIDBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
]]--

S_NAMES.DUG_ORCHIDBUSH = "兰草花丛"
S______GENERIC.DESCRIBE.DUG_ORCHIDBUSH = "我从山中来，带着兰花草。"
--S_______WILLOW.DESCRIBE.DUG_ORCHIDBUSH = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DUG_ORCHIDBUSH = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DUG_ORCHIDBUSH = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DUG_ORCHIDBUSH = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DUG_ORCHIDBUSH = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DUG_ORCHIDBUSH = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DUG_ORCHIDBUSH = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DUG_ORCHIDBUSH = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DUG_ORCHIDBUSH = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DUG_ORCHIDBUSH = "Great to cool off after some hard physical labor."

S_NAMES.CUTTED_ORCHIDBUSH = "兰草种耔"
S______GENERIC.DESCRIBE.CUTTED_ORCHIDBUSH = "这是植物很常见的繁殖方式。"
--S_______WILLOW.DESCRIBE.CUTTED_ORCHIDBUSH = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.CUTTED_ORCHIDBUSH = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.CUTTED_ORCHIDBUSH = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.CUTTED_ORCHIDBUSH = "STICK ADDON INSTALLED"
S_WICKERBOTTOM.DESCRIBE.CUTTED_ORCHIDBUSH = "佩兰的种子。"
--S_______WOODIE.DESCRIBE.CUTTED_ORCHIDBUSH = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.CUTTED_ORCHIDBUSH = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.CUTTED_ORCHIDBUSH = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.CUTTED_ORCHIDBUSH = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.CUTTED_ORCHIDBUSH = "Great to cool off after some hard physical labor."

S_NAMES.NEVERFADEBUSH = "永不凋零花丛"
S______GENERIC.DESCRIBE.NEVERFADEBUSH =
{
    --BARREN = "It can't recover without my help.",
    --WITHERED = "She is no longer beauteous.",
    GENERIC = "我就知道它永远都不会枯萎的！",
    PICKED = "它正在接纳大自然的恩泽。",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    --BURNING = "The niceness are disappearing!",
}
S_______WILLOW.DESCRIBE.NEVERFADEBUSH =
{
    --BARREN = "I need to poop on it.",
    --WITHERED = "Is too hot for bush.",
    GENERIC = "这好像...也是能烧的吧。",
    --PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "我有点后悔了。",
}
--[[
S_____WOLFGANG.DESCRIBE.NEVERFADEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S________WENDY.DESCRIBE.NEVERFADEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S_________WX78.DESCRIBE.NEVERFADEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S_WICKERBOTTOM.DESCRIBE.NEVERFADEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S_______WOODIE.DESCRIBE.NEVERFADEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S______WAXWELL.DESCRIBE.NEVERFADEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S___WATHGRITHR.DESCRIBE.NEVERFADEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S_______WEBBER.DESCRIBE.NEVERFADEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S_______WINONA.DESCRIBE.NEVERFADEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
]]--

S_NAMES.NEVERFADE = "永不凋零"
S_RECIPE_DESC.NEVERFADE = "花香四溢的力量！"
S______GENERIC.DESCRIBE.NEVERFADE = "这是多么...神圣...纯洁...的力量..."
--S_______WILLOW.DESCRIBE.NEVERFADE = "This is the opposite of burning."
S_____WOLFGANG.DESCRIBE.NEVERFADE = "强大的沃尔夫冈挥舞强大的剑！"
S________WENDY.DESCRIBE.NEVERFADE = "我本以为只有爱才可以永恒..."
S_________WX78.DESCRIBE.NEVERFADE = "把自己变成金属，聪明的植物"
S_WICKERBOTTOM.DESCRIBE.NEVERFADE = "充斥着大自然的魔法。"
--S_______WOODIE.DESCRIBE.NEVERFADE = "I'd prefer maple taffy..."
S______WAXWELL.DESCRIBE.NEVERFADE = "嗯？这个是另一方势力所打造出来的。"
S___WATHGRITHR.DESCRIBE.NEVERFADE = "世界树的力量！"
--S_______WEBBER.DESCRIBE.NEVERFADE = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.NEVERFADE = "Great to cool off after some hard physical labor."
--S________WARLY.DESCRIBE.SACHET = ""
--S_______WORTOX.DESCRIBE.SACHET = ""
S_____WORMWOOD.DESCRIBE.SACHET = "强大的朋友"
--S_________WURT.DESCRIBE.SACHET = ""
--STRINGS.CHARACTERS.WAGSTAFF.DESCRIBE.NEVERFADE = "难以置信！它们融合后变成了一把剑！"

S_NAMES.SACHET = "香包"
S_RECIPE_DESC.SACHET = "掩盖你的臭汗！"
S______GENERIC.DESCRIBE.SACHET = "我闻起来应该像花一样吗？"
S_______WILLOW.DESCRIBE.SACHET = "我可没什么兴趣。"
S_____WOLFGANG.DESCRIBE.SACHET = "老实说，这有点娘炮..."
S________WENDY.DESCRIBE.SACHET = "掩盖死亡的恶臭。"
S_________WX78.DESCRIBE.SACHET = "正在验证气味模块"
S_WICKERBOTTOM.DESCRIBE.SACHET = "用于营造优雅的阅读环境。"
S_______WOODIE.DESCRIBE.SACHET = "闻起来还不错，嗯？"
S______WAXWELL.DESCRIBE.SACHET = "优雅男士的必需品。"
S___WATHGRITHR.DESCRIBE.SACHET = "闻起来像精灵。"
S_______WEBBER.DESCRIBE.SACHET = "好棒！我们闻起来棒棒的！"
S_______WINONA.DESCRIBE.SACHET = "花里胡哨的。"
S________WARLY.DESCRIBE.SACHET = "新式的香料...值得一试。"
S_______WORTOX.DESCRIBE.SACHET = "凡人们用它来掩盖体臭。"
S_____WORMWOOD.DESCRIBE.SACHET = "里面有朋友吗？"
S_________WURT.DESCRIBE.SACHET = "浮浪噗，就像一位公主！"
--STRINGS.CHARACTERS.WAGSTAFF.DESCRIBE.SACHET = "这个世界似乎也存在分子热运动的现象。"

--采集玫瑰丛时的台词
S______GENERIC.ANNOUNCE_PICK_ROSEBUSH = "哪朵玫瑰，没有荆棘。"
S_______WILLOW.ANNOUNCE_PICK_ROSEBUSH = "哪种美丽会换来妒忌。"
-- S_____WOLFGANG.ANNOUNCE_PICK_ROSEBUSH = ""
S________WENDY.ANNOUNCE_PICK_ROSEBUSH = "你生而无罪。"
S_________WX78.ANNOUNCE_PICK_ROSEBUSH = "敌方未能击穿我的装甲"
-- S_WICKERBOTTOM.ANNOUNCE_PICK_ROSEBUSH = ""
-- S_______WOODIE.ANNOUNCE_PICK_ROSEBUSH = ""
-- S______WAXWELL.ANNOUNCE_PICK_ROSEBUSH = ""
S___WATHGRITHR.ANNOUNCE_PICK_ROSEBUSH = "最好的报复是美丽，最美的盛开是反击。"
S_______WEBBER.ANNOUNCE_PICK_ROSEBUSH = "我们都从来没忘记。"
-- S_______WINONA.ANNOUNCE_PICK_ROSEBUSH = ""
S_______WORTOX.ANNOUNCE_PICK_ROSEBUSH = "会有人真心的爱你。"
-- S________WARLY.ANNOUNCE_PICK_ROSEBUSH = ""

S_NAMES.FOLIAGEATH = "青枝绿叶" --foliage + sheath = foliageath
-- S_RECIPE_DESC.FOLIAGEATH = "愿作青叶，厮守芳华。"
S______GENERIC.DESCRIBE.FOLIAGEATH =
{
    MERGED = "花繁叶茂，迢迢韶光不曾老。",
    GENERIC = "叶满枝头，默默无花惹人怜。",
}
-- S_______WILLOW.DESCRIBE.FOLIAGEATH = ""
-- S_____WOLFGANG.DESCRIBE.FOLIAGEATH = ""
-- S________WENDY.DESCRIBE.FOLIAGEATH = ""
-- S_________WX78.DESCRIBE.FOLIAGEATH = ""
-- S_WICKERBOTTOM.DESCRIBE.FOLIAGEATH = ""
-- S_______WOODIE.DESCRIBE.FOLIAGEATH = ""
-- S______WAXWELL.DESCRIBE.FOLIAGEATH = ""
S___WATHGRITHR.DESCRIBE.FOLIAGEATH =
{
    MERGED = "花隐翠叶间，岁月不相见。",
    GENERIC = "翠叶铸长匣，留待宝剑归。",
}
-- S_______WEBBER.DESCRIBE.FOLIAGEATH = ""
-- S_______WINONA.DESCRIBE.FOLIAGEATH = ""
S________WARLY.DESCRIBE.FOLIAGEATH =
{
    MERGED = "浪子回头金不换！",
    GENERIC = "待浪子归来。",
}
S_______WORTOX.DESCRIBE.FOLIAGEATH =
{
    MERGED = "一颗心，不大的地方，有许多许多你。",
    GENERIC = "两个人在不同的地方，会是怎么样。",
}
S_____WORMWOOD.DESCRIBE.FOLIAGEATH =
{
    MERGED = "希望你的路上不会一直孤单。",
    GENERIC = "总有一天会再见，总有一天还会再次见面。",
}
S_________WURT.DESCRIBE.FOLIAGEATH =
{
    MERGED = "这就是归宿了吧。",
    GENERIC = "你在期待谁的到来呢？浮浪噗。",
}

--入鞘失败的台词
S______GENERIC.ACTIONFAIL.GIVE.WRONGSWORD = "宝剑不可得，相逢几许难。"
S_______WILLOW.ACTIONFAIL.GIVE.WRONGSWORD = "呸，它不配！"
S_____WOLFGANG.ACTIONFAIL.GIVE.WRONGSWORD = "沃尔夫冈得再找找其他的。"
S________WENDY.ACTIONFAIL.GIVE.WRONGSWORD = "这是个伤感的错误。"
S_________WX78.ACTIONFAIL.GIVE.WRONGSWORD = "这题无解！"
S_WICKERBOTTOM.ACTIONFAIL.GIVE.WRONGSWORD = "它相性不对。"
S_______WOODIE.ACTIONFAIL.GIVE.WRONGSWORD = "找错了人，最终，只剩下心碎。"
S______WAXWELL.ACTIONFAIL.GIVE.WRONGSWORD = "抱歉，这只是我一厢情愿。"
S___WATHGRITHR.ACTIONFAIL.GIVE.WRONGSWORD = "坚守它的原则！"
S_______WEBBER.ACTIONFAIL.GIVE.WRONGSWORD = "我们得找把厉害的剑！"
S_______WINONA.ACTIONFAIL.GIVE.WRONGSWORD = "至少我试过了，错了也无所谓。"
S________WARLY.ACTIONFAIL.GIVE.WRONGSWORD = "它连出场机会都没有。"
S_______WORTOX.ACTIONFAIL.GIVE.WRONGSWORD = "我注定会找到它！"
S_____WORMWOOD.ACTIONFAIL.GIVE.WRONGSWORD = "连朋友都做不成。"
S_________WURT.ACTIONFAIL.GIVE.WRONGSWORD = "人生的出场顺序很重要啊！浮浪噗。"

S_NAMES.FOLIAGEATH_MYLOVE = "青锋剑" --一吻长青
S______GENERIC.DESCRIBE.FOLIAGEATH_MYLOVE = "江山无限，奈何明月照渠沟。" --这是某人给他心中所爱的信物。
-- S_______WILLOW.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S_____WOLFGANG.DESCRIBE.FOLIAGEATH_MYLOVE = "沃尔夫冈不知道该说啥。"
-- S________WENDY.DESCRIBE.FOLIAGEATH_MYLOVE = "姗姗来迟的他，送你一枝含苞的花。"
-- S_________WX78.DESCRIBE.FOLIAGEATH_MYLOVE = "等待人类灭绝的感觉真好。"
-- S_WICKERBOTTOM.DESCRIBE.FOLIAGEATH_MYLOVE = "在我那个年代，这种爱是隐晦的、不被众人接受的。"
-- S_______WOODIE.DESCRIBE.FOLIAGEATH_MYLOVE = "枯叶之下，藏多少情话。"
-- S______WAXWELL.DESCRIBE.FOLIAGEATH_MYLOVE = "有道是人生得意须尽欢，难得最是心从容。"
-- S___WATHGRITHR.DESCRIBE.FOLIAGEATH_MYLOVE = "别害怕，这是神明的恩惠。"
-- S_______WEBBER.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S_______WINONA.DESCRIBE.FOLIAGEATH_MYLOVE = "红花当然配绿叶，这一辈子谁来陪。"
-- S________WARLY.DESCRIBE.FOLIAGEATH_MYLOVE = "泛舟北海中，波光玲珑映白昼。"
-- S_______WORTOX.DESCRIBE.FOLIAGEATH_MYLOVE = "我一个恶魔，还有能爱某个人的心吗？"
-- S_____WORMWOOD.DESCRIBE.FOLIAGEATH_MYLOVE = "这是一种朋友之上的感觉！"
-- S_________WURT.DESCRIBE.FOLIAGEATH_MYLOVE = "荒草埋过小石板路，春园逃出一支桃花。"

-- 合成一吻长青时的台词
S______GENERIC.ANNOUNCE_HIS_LOVE_WISH = "天长地久有时尽。" --惟愿爱情长青！
-- S_______WILLOW.ANNOUNCE_HIS_LOVE_WISH = ""
-- S_____WOLFGANG.ANNOUNCE_HIS_LOVE_WISH = ""
-- S________WENDY.ANNOUNCE_HIS_LOVE_WISH = ""
-- S_________WX78.ANNOUNCE_HIS_LOVE_WISH = ""
-- S_WICKERBOTTOM.ANNOUNCE_HIS_LOVE_WISH = ""
-- S_______WOODIE.ANNOUNCE_HIS_LOVE_WISH = ""
-- S______WAXWELL.ANNOUNCE_HIS_LOVE_WISH = ""
-- S___WATHGRITHR.ANNOUNCE_HIS_LOVE_WISH = ""
-- S_______WEBBER.ANNOUNCE_HIS_LOVE_WISH = ""
-- S_______WINONA.ANNOUNCE_HIS_LOVE_WISH = ""
-- S________WARLY.ANNOUNCE_HIS_LOVE_WISH = ""
-- S_______WORTOX.ANNOUNCE_HIS_LOVE_WISH = ""
-- S_____WORMWOOD.ANNOUNCE_HIS_LOVE_WISH = ""
-- S_________WURT.ANNOUNCE_HIS_LOVE_WISH = ""

--------------------------------------------------------------------------
--[[ superb cuisine ]]--[[ 美味佳肴 ]]
--------------------------------------------------------------------------

S_NAMES.PETALS_ROSE = "蔷薇花瓣"
S______GENERIC.DESCRIBE.PETALS_ROSE = "玫瑰即玫瑰，花香无因由。"
--S_______WILLOW.DESCRIBE.PETALS_ROSE = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.PETALS_ROSE = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.PETALS_ROSE = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.PETALS_ROSE = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.PETALS_ROSE = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.PETALS_ROSE = "I'd prefer maple taffy..."
S______WAXWELL.DESCRIBE.PETALS_ROSE = "聪明的人绝不会相信玫瑰！"
--S___WATHGRITHR.DESCRIBE.PETALS_ROSE = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.PETALS_ROSE = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.PETALS_ROSE = "Great to cool off after some hard physical labor."

S_NAMES.PETALS_LILY = "蹄莲花瓣"
S______GENERIC.DESCRIBE.PETALS_LILY = "很期待与某个人的相遇。"
S_______WILLOW.DESCRIBE.PETALS_LILY = "如果这世界即将化为灰烬，他会来找我吗？"
--S_____WOLFGANG.DESCRIBE.PETALS_LILY = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.PETALS_LILY = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.PETALS_LILY = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.PETALS_LILY = "Well, isn't that refreshing?"
S_______WOODIE.DESCRIBE.PETALS_LILY = "你额角病似百合，带着痛苦的湿热的露水...抱歉我走神了。"
--S______WAXWELL.DESCRIBE.PETALS_LILY = "Hm... I don't know what I was expecting."
S___WATHGRITHR.DESCRIBE.PETALS_LILY = "一个善意的谎言，来掩饰我的虚张声势。"
--S_______WEBBER.DESCRIBE.PETALS_LILY = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.PETALS_LILY = "Great to cool off after some hard physical labor."

S_NAMES.PETALS_ORCHID = "兰草花瓣"
S______GENERIC.DESCRIBE.PETALS_ORCHID = "我渴望重获自由，而不是像它一样。"
--S_______WILLOW.DESCRIBE.PETALS_ORCHID = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.PETALS_ORCHID = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.PETALS_ORCHID = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.PETALS_ORCHID = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.PETALS_ORCHID = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.PETALS_ORCHID = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.PETALS_ORCHID = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.PETALS_ORCHID = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.PETALS_ORCHID = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.PETALS_ORCHID = "Great to cool off after some hard physical labor."

S_NAMES.DISH_CHILLEDROSEJUICE = "蔷薇冰果汁"
STRINGS.UI.COOKBOOK.DISH_CHILLEDROSEJUICE = "在心田播撒浪漫的种子"
S______GENERIC.DESCRIBE.DISH_CHILLEDROSEJUICE = "哈，浪漫与食物的完美的融合。"
--S_______WILLOW.DESCRIBE.DISH_CHILLEDROSEJUICE = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DISH_CHILLEDROSEJUICE = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DISH_CHILLEDROSEJUICE = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_CHILLEDROSEJUICE = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DISH_CHILLEDROSEJUICE = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DISH_CHILLEDROSEJUICE = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DISH_CHILLEDROSEJUICE = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_CHILLEDROSEJUICE = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DISH_CHILLEDROSEJUICE = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DISH_CHILLEDROSEJUICE = "Great to cool off after some hard physical labor."

S_NAMES.DISH_TWISTEDROLLLILY = "蹄莲花卷"
STRINGS.UI.COOKBOOK.DISH_TWISTEDROLLLILY = "心中有翩翩飞舞的感觉"
S______GENERIC.DESCRIBE.DISH_TWISTEDROLLLILY = "我会不会化作蝴蝶，翩翩飞舞。"
--S_______WILLOW.DESCRIBE.DISH_TWISTEDROLLLILY = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DISH_TWISTEDROLLLILY = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DISH_TWISTEDROLLLILY = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_TWISTEDROLLLILY = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DISH_TWISTEDROLLLILY = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DISH_TWISTEDROLLLILY = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DISH_TWISTEDROLLLILY = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_TWISTEDROLLLILY = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DISH_TWISTEDROLLLILY = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DISH_TWISTEDROLLLILY = "Great to cool off after some hard physical labor."

S_NAMES.DISH_ORCHIDCAKE = "兰花糕"
STRINGS.UI.COOKBOOK.DISH_ORCHIDCAKE = "感受到了么，心中的平静"
S______GENERIC.DESCRIBE.DISH_ORCHIDCAKE = "平心静气才是最好的，对吧。"
--S_______WILLOW.DESCRIBE.DISH_ORCHIDCAKE = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DISH_ORCHIDCAKE = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DISH_ORCHIDCAKE = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_ORCHIDCAKE = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DISH_ORCHIDCAKE = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DISH_ORCHIDCAKE = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DISH_ORCHIDCAKE = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_ORCHIDCAKE = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DISH_ORCHIDCAKE = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DISH_ORCHIDCAKE = "Great to cool off after some hard physical labor."

S_NAMES.DISH_FLESHNAPOLEON = "真果拿破仑"
STRINGS.UI.COOKBOOK.DISH_FLESHNAPOLEON = "发光物质会通过皮肤逐渐散去"
S______GENERIC.DESCRIBE.DISH_FLESHNAPOLEON = "吃下它，我就是夜空中最亮的星！"
--S_______WILLOW.DESCRIBE.DISH_FLESHNAPOLEON = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DISH_FLESHNAPOLEON = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DISH_FLESHNAPOLEON = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_FLESHNAPOLEON = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DISH_FLESHNAPOLEON = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DISH_FLESHNAPOLEON = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DISH_FLESHNAPOLEON = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_FLESHNAPOLEON = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DISH_FLESHNAPOLEON = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DISH_FLESHNAPOLEON = "Great to cool off after some hard physical labor."

S_NAMES.DISH_BEGGINGMEAT = "叫花焖肉"
STRINGS.UI.COOKBOOK.DISH_BEGGINGMEAT = "极度饥饿时，吃它会是享受"
S______GENERIC.DESCRIBE.DISH_BEGGINGMEAT = "至少，暂时不用为生存而乞讨了。"
--S_______WILLOW.DESCRIBE.DISH_BEGGINGMEAT = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DISH_BEGGINGMEAT = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DISH_BEGGINGMEAT = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_BEGGINGMEAT = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DISH_BEGGINGMEAT = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DISH_BEGGINGMEAT = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DISH_BEGGINGMEAT = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_BEGGINGMEAT = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DISH_BEGGINGMEAT = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DISH_BEGGINGMEAT = "Great to cool off after some hard physical labor."

S_NAMES.DISH_FRENCHSNAILSBAKED = "法式焗蜗牛"
STRINGS.UI.COOKBOOK.DISH_FRENCHSNAILSBAKED = "给个火星它就会爆炸"
S______GENERIC.DESCRIBE.DISH_FRENCHSNAILSBAKED = "易燃易爆炸，胃里别有火！"
--S_______WILLOW.DESCRIBE.DISH_FRENCHSNAILSBAKED = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DISH_FRENCHSNAILSBAKED = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DISH_FRENCHSNAILSBAKED = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_FRENCHSNAILSBAKED = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DISH_FRENCHSNAILSBAKED = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DISH_FRENCHSNAILSBAKED = "I'd prefer maple taffy..."
S______WAXWELL.DESCRIBE.DISH_FRENCHSNAILSBAKED = "呃...真就吃这个吗？"
--S___WATHGRITHR.DESCRIBE.DISH_FRENCHSNAILSBAKED = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DISH_FRENCHSNAILSBAKED = "Yaaay! Popsicle, popsicle!"
S_______WINONA.DESCRIBE.DISH_FRENCHSNAILSBAKED = "味道不错，可惜不管饱。"

S_NAMES.DISH_NEWORLEANSWINGS = "新奥尔良烤翅"
STRINGS.UI.COOKBOOK.DISH_NEWORLEANSWINGS = "让身体吸收超声波，懂了吧"
S______GENERIC.DESCRIBE.DISH_NEWORLEANSWINGS = "这道菜总让我想起一个穿着蝙蝠衣的人"
--S_______WILLOW.DESCRIBE.DISH_NEWORLEANSWINGS = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DISH_NEWORLEANSWINGS = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DISH_NEWORLEANSWINGS = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_NEWORLEANSWINGS = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DISH_NEWORLEANSWINGS = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DISH_NEWORLEANSWINGS = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DISH_NEWORLEANSWINGS = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_NEWORLEANSWINGS = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DISH_NEWORLEANSWINGS = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DISH_NEWORLEANSWINGS = "Great to cool off after some hard physical labor."

S_NAMES.DISH_FISHJOYRAMEN = "鱼乐拉面"
STRINGS.UI.COOKBOOK.DISH_FISHJOYRAMEN = "哧溜一声会不小心吸入别的东西"
S______GENERIC.DESCRIBE.DISH_FISHJOYRAMEN = "哧溜...哧溜哧溜...哧溜哧溜..."
--S_______WILLOW.DESCRIBE.DISH_FISHJOYRAMEN = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DISH_FISHJOYRAMEN = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DISH_FISHJOYRAMEN = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_FISHJOYRAMEN = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DISH_FISHJOYRAMEN = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DISH_FISHJOYRAMEN = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DISH_FISHJOYRAMEN = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_FISHJOYRAMEN = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DISH_FISHJOYRAMEN = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DISH_FISHJOYRAMEN = "Great to cool off after some hard physical labor."

S_NAMES.DISH_ROASTEDMARSHMALLOWS = "烤棉花糖"
S______GENERIC.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "让我想起以前的野营时光，嘿嘿。"
S_______WILLOW.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "碳烤棉花糖，来一串？"
--S_____WOLFGANG.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "Wolfgang can eat in one bite!"
S________WENDY.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "这让我忆起过去与阿比盖尔一起野炊的时光。"
S_________WX78.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "这让我想起了Pyro！"
--S_WICKERBOTTOM.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "Well, isn't that refreshing?"
S_______WOODIE.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "唉，我都快忘记了，与露西一起野营的时光。"
--S______WAXWELL.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "这让我们想起小时候与家人野营的时光。"
--S_______WINONA.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "Great to cool off after some hard physical labor."

S_NAMES.DISH_POMEGRANATEJELLY = "石榴子果冻"
S______GENERIC.DESCRIBE.DISH_POMEGRANATEJELLY = "小孩子才会喜欢吃的东西吧？"
--S_______WILLOW.DESCRIBE.DISH_POMEGRANATEJELLY = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DISH_POMEGRANATEJELLY = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DISH_POMEGRANATEJELLY = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_POMEGRANATEJELLY = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DISH_POMEGRANATEJELLY = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DISH_POMEGRANATEJELLY = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DISH_POMEGRANATEJELLY = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_POMEGRANATEJELLY = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.DISH_POMEGRANATEJELLY = "我们喜欢果冻！"
--S_______WINONA.DESCRIBE.DISH_POMEGRANATEJELLY = "Great to cool off after some hard physical labor."

S_NAMES.DISH_MEDICINALLIQUOR = "药酒"
STRINGS.UI.COOKBOOK.DISH_MEDICINALLIQUOR = "大战之前来它一碗，提升士气"
S______GENERIC.DESCRIBE.DISH_MEDICINALLIQUOR =
{
    GENERIC = "喝下决战酒！战死方休！",
    DRUNK = "我才没醉！",
}
--S_______WILLOW.DESCRIBE.DISH_MEDICINALLIQUOR = 
S_____WOLFGANG.DESCRIBE.DISH_MEDICINALLIQUOR =
{
    GENERIC = "喝下决战酒！战死方休！",
    DRUNK = "像水一样，没啥感觉。",
}
S________WENDY.DESCRIBE.DISH_MEDICINALLIQUOR =
{
    GENERIC = "我不想喝这个。",
    DRUNK = "我就不该喝这个。",
}
S_________WX78.DESCRIBE.DISH_MEDICINALLIQUOR = 
{
    GENERIC = "可以模拟宿醉状态",
    DRUNK = "状态模拟结束",
}
--S_WICKERBOTTOM.DESCRIBE.DISH_MEDICINALLIQUOR = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DISH_MEDICINALLIQUOR = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DISH_MEDICINALLIQUOR = "Hm... I don't know what I was expecting."
S___WATHGRITHR.DESCRIBE.DISH_MEDICINALLIQUOR =
{
    GENERIC = "喝下决战酒！战死方休！",
    DRUNK = "像水一样，没啥感觉。",
}
S_______WEBBER.DESCRIBE.DISH_MEDICINALLIQUOR =
{
    GENERIC = "以前妈妈警告过我不要喝酒。",
    DRUNK = "妈妈，我们好困...",
}
--S_______WINONA.DESCRIBE.DISH_MEDICINALLIQUOR = "Great to cool off after some hard physical labor."

S_NAMES.DISH_BANANAMOUSSE = "香蕉慕斯"
STRINGS.UI.COOKBOOK.DISH_BANANAMOUSSE = "不再挑食的你，能发现更多心头好"
S______GENERIC.DESCRIBE.DISH_BANANAMOUSSE = "开胃小甜点，美味！"
--S_______WILLOW.DESCRIBE.DISH_BANANAMOUSSE = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DISH_BANANAMOUSSE = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DISH_BANANAMOUSSE = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_BANANAMOUSSE = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DISH_BANANAMOUSSE = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DISH_BANANAMOUSSE = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DISH_BANANAMOUSSE = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_BANANAMOUSSE = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DISH_BANANAMOUSSE = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DISH_BANANAMOUSSE = "Great to cool off after some hard physical labor."
S________WARLY.DESCRIBE.DISH_BANANAMOUSSE = "如果你们喜欢的话，我还会做另一种香蕉甜品。"

S_NAMES.DISH_RICEDUMPLING = "金黄香粽"
STRINGS.UI.COOKBOOK.DISH_RICEDUMPLING = "塞满你的胃，喜欢这感觉么"
S______GENERIC.DESCRIBE.DISH_RICEDUMPLING = "散发着自然的香气。"
--S_______WILLOW.DESCRIBE.DISH_RICEDUMPLING = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DISH_RICEDUMPLING = "Wolfgang can eat in one bite!"
S________WENDY.DESCRIBE.DISH_RICEDUMPLING = "长太息以掩涕兮，哀民生之多艰。"
--S_________WX78.DESCRIBE.DISH_RICEDUMPLING = "STICK ADDON INSTALLED"
S_WICKERBOTTOM.DESCRIBE.DISH_RICEDUMPLING = "也许我应该把这个丢进河里喂鱼。"
--S_______WOODIE.DESCRIBE.DISH_RICEDUMPLING = "I'd prefer maple taffy..."
S______WAXWELL.DESCRIBE.DISH_RICEDUMPLING = "看到这东西我的胃就不舒服。"
--S___WATHGRITHR.DESCRIBE.DISH_RICEDUMPLING = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DISH_RICEDUMPLING = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DISH_RICEDUMPLING = "Great to cool off after some hard physical labor."

S_NAMES.DISH_DURIANTARTARE = "怪味鞑靼"
STRINGS.UI.COOKBOOK.DISH_DURIANTARTARE = "非常合怪物们的口味与其残暴的心里"
S______GENERIC.DESCRIBE.DISH_DURIANTARTARE = "野蛮，血腥，难以下咽。"
S_______WILLOW.DESCRIBE.DISH_DURIANTARTARE = "就不能拿火烤烤这坨肉？"
--S_____WOLFGANG.DESCRIBE.DISH_DURIANTARTARE = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DISH_DURIANTARTARE = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_DURIANTARTARE = "STICK ADDON INSTALLED"
S_WICKERBOTTOM.DESCRIBE.DISH_DURIANTARTARE = "肉都是血淋淋的，还臭气扑鼻！"
--S_______WOODIE.DESCRIBE.DISH_DURIANTARTARE = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DISH_DURIANTARTARE = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_DURIANTARTARE = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.DISH_DURIANTARTARE = "一坨加工精细的生食，合我们胃口。"
--S_______WINONA.DESCRIBE.DISH_DURIANTARTARE = "Great to cool off after some hard physical labor."
S________WARLY.DESCRIBE.DISH_DURIANTARTARE = "加入榴莲果然是个好主意。"
S_______WORTOX.DESCRIBE.DISH_DURIANTARTARE = "这是谁的鲜肉，还残留着一点点美味的灵魂。"

S_NAMES.DISH_MERRYCHRISTMASSALAD = "“圣诞快乐”沙拉"
STRINGS.UI.COOKBOOK.DISH_MERRYCHRISTMASSALAD = "圣诞快乐，带着祝福收下小礼物吧"
S______GENERIC.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "看上圣诞树，吃定圣诞树。"
-- S_______WILLOW.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "Mess! needs a fire!"
S_____WOLFGANG.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "沃尔夫冈想要礼物，好心的圣诞老人。"
--S________WENDY.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "STICK ADDON INSTALLED"
-- S_WICKERBOTTOM.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "Umm... the meat is still raw, and it stinks."
S_______WOODIE.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "我终于不是唯一一个会吃树的人了。"
--S______WAXWELL.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "该从星星吃起，还是树干吃起呢？"
S_______WINONA.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "哈哈！圣诞节快乐！"
S________WARLY.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "孩子们很喜欢我的摆盘艺术呢。"
S_______WORTOX.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "凡人们在谈论克劳斯？"

S_NAMES.DISH_MURMURANANAS = "松萝咕咾肉"
S______GENERIC.DESCRIBE.DISH_MURMURANANAS = "酸酸甜甜，我喜欢！"
-- S_______WILLOW.DESCRIBE.DISH_MURMURANANAS = "This is the opposite of burning."
S_____WOLFGANG.DESCRIBE.DISH_MURMURANANAS = "沃尔夫冈超爱的，好想再吃一次啊！"
-- S________WENDY.DESCRIBE.DISH_MURMURANANAS = "I used to eat these with Abigail..."
-- S_________WX78.DESCRIBE.DISH_MURMURANANAS = "STICK ADDON INSTALLED"
-- S_WICKERBOTTOM.DESCRIBE.DISH_MURMURANANAS = "Well, isn't that refreshing?"
-- S_______WOODIE.DESCRIBE.DISH_MURMURANANAS = "I'd prefer maple taffy..."
S______WAXWELL.DESCRIBE.DISH_MURMURANANAS = "它永远都不会在唐人街那些餐厅的菜单上消失。"
-- S___WATHGRITHR.DESCRIBE.DISH_MURMURANANAS = "I've somehow found a way to make it even LESS appealing!"
-- S_______WEBBER.DESCRIBE.DISH_MURMURANANAS = "Yaaay! Popsicle, popsicle!"
-- S_______WINONA.DESCRIBE.DISH_MURMURANANAS = "Great to cool off after some hard physical labor."
-- S_______WORTOX.DESCRIBE.DISH_MURMURANANAS = "Whose flesh is this, with a little yummy soul remained."

S_NAMES.DISH_SHYERRYJAM = "颤栗果酱"
STRINGS.UI.COOKBOOK.DISH_SHYERRYJAM = "营养丰富，极大增强身体自愈能力"
S______GENERIC.DESCRIBE.DISH_SHYERRYJAM = "我挺想把它倒在司康饼上或者做成派后再吃。"
-- S_______WILLOW.DESCRIBE.DISH_SHYERRYJAM = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.DISH_SHYERRYJAM = "Wolfgang loves it so much that he wants to eat it again!"
-- S________WENDY.DESCRIBE.DISH_SHYERRYJAM = "I used to eat these with Abigail..."
S_________WX78.DESCRIBE.DISH_SHYERRYJAM = "没有甜点可以使用，直接吃！"
-- S_WICKERBOTTOM.DESCRIBE.DISH_SHYERRYJAM = "Well, isn't that refreshing?"
-- S_______WOODIE.DESCRIBE.DISH_SHYERRYJAM = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.DISH_SHYERRYJAM = "This "
-- S___WATHGRITHR.DESCRIBE.DISH_SHYERRYJAM = "I've somehow found a way to make it even LESS appealing!"
-- S_______WEBBER.DESCRIBE.DISH_SHYERRYJAM = "Yaaay! Popsicle, popsicle!"
-- S_______WINONA.DESCRIBE.DISH_SHYERRYJAM = "Great to cool off after some hard physical labor."
-- S_______WORTOX.DESCRIBE.DISH_SHYERRYJAM = "Whose flesh is this, with a little yummy soul remained."

--蝙蝠伪装buff
S______GENERIC.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = "感觉像穿了一套隐形的蝙蝠衣。"
-- S_______WILLOW.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- S_____WOLFGANG.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- S________WENDY.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- S_________WX78.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- S_WICKERBOTTOM.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- S_______WOODIE.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- S______WAXWELL.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- S___WATHGRITHR.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- S_______WEBBER.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- S_______WINONA.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- S_______WORTOX.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- S________WARLY.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
--
S______GENERIC.ANNOUNCE_DETACH_BUFF_BATDISGUISE = "我既不是蝙蝠，也没有钱。"
-- S_______WILLOW.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- S_____WOLFGANG.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- S________WENDY.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- S_________WX78.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- S_WICKERBOTTOM.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- S_______WOODIE.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- S______WAXWELL.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- S___WATHGRITHR.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- S_______WEBBER.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- S_______WINONA.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- S_______WORTOX.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- S________WARLY.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""

--最佳胃口buff
S______GENERIC.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = "突然好想大吃特吃！"
-- S_______WILLOW.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- S_____WOLFGANG.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- S________WENDY.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- S_________WX78.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- S_WICKERBOTTOM.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- S_______WOODIE.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- S______WAXWELL.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- S___WATHGRITHR.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- S_______WEBBER.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- S_______WINONA.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- S_______WORTOX.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- S________WARLY.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
--
S______GENERIC.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = "胃口变回平常了。"
-- S_______WILLOW.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- S_____WOLFGANG.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- S________WENDY.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- S_________WX78.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- S_WICKERBOTTOM.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- S_______WOODIE.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- S______WAXWELL.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- S___WATHGRITHR.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- S_______WEBBER.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- S_______WINONA.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- S_______WORTOX.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- S________WARLY.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""

--胃梗塞buff
S______GENERIC.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = "完全没胃口了。"
-- S_______WILLOW.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
-- S_____WOLFGANG.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
-- S________WENDY.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
-- S_________WX78.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
S_WICKERBOTTOM.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = "这食物有很强的饱腹度。"
-- S_______WOODIE.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
S______WAXWELL.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = "这可对我的老胃不好！"
-- S___WATHGRITHR.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
-- S_______WEBBER.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
S_______WINONA.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = "越不易饿，越好干活。"
-- S_______WORTOX.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
-- S________WARLY.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
--
S______GENERIC.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = "胃口常开，好彩自然来。"
-- S_______WILLOW.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
-- S_____WOLFGANG.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
-- S________WENDY.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
-- S_________WX78.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
S_WICKERBOTTOM.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = "强烈的饱腹感没有了。"
-- S_______WOODIE.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
S______WAXWELL.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = "胃终于舒服了。"
-- S___WATHGRITHR.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
-- S_______WEBBER.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
S_______WINONA.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = "即使饿了，也得继续干活。"
-- S_______WORTOX.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
-- S________WARLY.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""

--力量增幅buff
-- S______GENERIC.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = "" --属于药酒的buff，但是药酒已经会让玩家说话了，所以这里不再重复说
-- S_______WILLOW.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = ""
-- S_____WOLFGANG.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = ""
-- S________WENDY.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = ""
-- S_________WX78.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = ""
-- S_WICKERBOTTOM.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = ""
-- S_______WOODIE.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = ""
-- S______WAXWELL.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = ""
-- S___WATHGRITHR.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = ""
-- S_______WEBBER.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = ""
-- S_______WINONA.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = ""
-- S_______WORTOX.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = ""
-- S________WARLY.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = ""
--
S______GENERIC.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = "噢，头好痛，昨天的记忆也是模模糊糊的..."
-- S_______WILLOW.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- S_____WOLFGANG.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- S________WENDY.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
S_________WX78.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = "我昨天喝断片了？"
-- S_WICKERBOTTOM.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- S_______WOODIE.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- S______WAXWELL.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- S___WATHGRITHR.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- S_______WEBBER.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- S_______WINONA.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- S_______WORTOX.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- S________WARLY.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""

S_NAMES.DISH_SUGARLESSTRICKMAKERCUPCAKES = "无糖捣蛋鬼纸杯蛋糕"
STRINGS.UI.COOKBOOK.DISH_SUGARLESSTRICKMAKERCUPCAKES = "鬼马小精灵会暗中助你捣蛋"
S______GENERIC.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "不给糖就捣蛋！",
    TRICKED = "吓我一跳。",
    TREAT = "给你糖果就是了。",
}
-- S_______WILLOW.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES = ""
S_____WOLFGANG.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "沃尔夫冈不想捉弄别人，只想要糖果。",
    TRICKED = "快把沃尔夫冈吓尿了。",
    TREAT = "沃尔夫冈会把快乐分给大家。",
}
S________WENDY.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "我是不是已经到了不该讨要糖的年纪了。",
    TRICKED = "吓我一跳。",
    TREAT = "阿比盖尔会不会也想要糖果呢。",
}
S_________WX78.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "我的身体渴望由脱氧核糖组成。",
    TRICKED = "突发警告！",
    TREAT = "只是给你我不想要的东西而已。",
}
S_WICKERBOTTOM.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "我觉得这是个圈套。",
    TRICKED = "图书馆里不准发生这种事情！",
    TREAT = "给你糖果就是了。",
}
-- S_______WOODIE.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES = ""
-- S______WAXWELL.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES = ""
-- S___WATHGRITHR.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES = ""
S_______WEBBER.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "我们只想要甜甜的蜜心糖果。",
    TRICKED = "你把大伙都逗乐了。",
    TREAT = "我们才是要糖的那一方啊。",
}
-- S_______WINONA.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES = ""
S_______WORTOX.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "嘿，别和我抢风头！！！",
    TRICKED = "切，雕虫小技。",
    TREAT = "不给糖又会怎样嘛。",
}
S_____WORMWOOD.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "能给点花蜜吗？",
    TRICKED = "吓得我花枝乱颤。",
    TREAT = "今天是传粉节吗？",
}
S________WARLY.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "多么合时宜的点心啊。",
    TRICKED = "吓得我的锅都抖了一下。",
    TREAT = "本大厨可要好好招待客人们。",
}
-- S_________WURT.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES = ""

S_NAMES.DISH_FLOWERMOONCAKE = "鲜花月饼"
STRINGS.UI.COOKBOOK.DISH_FLOWERMOONCAKE = "化思念为力量"
S______GENERIC.DESCRIBE.DISH_FLOWERMOONCAKE =
{
    GENERIC = "这淡淡花香如同我悠悠思念。",
    HAPPY = "但愿人长久，千里共婵娟。",
    LONELY = "冷冷清清，凄凄惨惨戚戚。",
}
-- S_______WILLOW.DESCRIBE.DISH_FLOWERMOONCAKE = ""
-- S_____WOLFGANG.DESCRIBE.DISH_FLOWERMOONCAKE = ""
S________WENDY.DESCRIBE.DISH_FLOWERMOONCAKE =
{
    GENERIC = "来，阿比盖尔，一起赏月吧。",
    HAPPY = "我好怀恋那天，我们一起坐在草地的餐布上。",
    LONELY = "前所未有的孤独正侵蚀着我，你快回来吧。",
}
S_________WX78.DESCRIBE.DISH_FLOWERMOONCAKE =
{
    GENERIC = "价值很低的燃料。",
    HAPPY = "遭到未知侵入，它在尝试修复感情组件。",
    LONELY = "依旧错误，感情组件无响应。",
}
-- S_WICKERBOTTOM.DESCRIBE.DISH_FLOWERMOONCAKE = ""
-- S_______WOODIE.DESCRIBE.DISH_FLOWERMOONCAKE = ""
S______WAXWELL.DESCRIBE.DISH_FLOWERMOONCAKE =
{
    GENERIC = "小心点，弄脏西装就不体面了。",
    HAPPY = "我只想挽回这一切，查理。",
    LONELY = "老无所依，这是我活该。",
}
-- S___WATHGRITHR.DESCRIBE.DISH_FLOWERMOONCAKE = ""
-- S_______WEBBER.DESCRIBE.DISH_FLOWERMOONCAKE = ""
-- S_______WINONA.DESCRIBE.DISH_FLOWERMOONCAKE = ""
-- S_______WORTOX.DESCRIBE.DISH_FLOWERMOONCAKE = ""
S_____WORMWOOD.DESCRIBE.DISH_FLOWERMOONCAKE =
{
    GENERIC = "寄托着朋友们的思念。",
    HAPPY = "朋友们都在身边，真好！",
    LONELY = "没有一个朋友，太孤独了。",
}
S________WARLY.DESCRIBE.DISH_FLOWERMOONCAKE =
{
    GENERIC = "边吃边赏月，顿时思如泉涌。",
    HAPPY = "我想奶奶了。",
    LONELY = "我要这厨艺有何用！",
}
-- S_________WURT.DESCRIBE.DISH_FLOWERMOONCAKE = ""
-- S_______WALTER.DESCRIBE.DISH_FLOWERMOONCAKE = ""

S_NAMES.DISH_FAREWELLCUPCAKE = "临别的纸杯蛋糕"
STRINGS.UI.COOKBOOK.DISH_FAREWELLCUPCAKE = "向悲惨的人生说再见"
S______GENERIC.DESCRIBE.DISH_FAREWELLCUPCAKE = "要不去在乎很容易，在乎才需要勇气。"
-- S_______WILLOW.DESCRIBE.DISH_FAREWELLCUPCAKE = ""
-- S_____WOLFGANG.DESCRIBE.DISH_FAREWELLCUPCAKE = ""
S________WENDY.DESCRIBE.DISH_FAREWELLCUPCAKE = "失败的意义就是，让每个人都失望。包括我们自己。"
-- S_________WX78.DESCRIBE.DISH_FAREWELLCUPCAKE = ""
S_WICKERBOTTOM.DESCRIBE.DISH_FAREWELLCUPCAKE = "遗憾的是，大多数人都按自我意识行动。"
S_______WOODIE.DESCRIBE.DISH_FAREWELLCUPCAKE = "人们彼此疏远，内心却支离破碎。"
S______WAXWELL.DESCRIBE.DISH_FAREWELLCUPCAKE = "你看到的我，不过是个空壳。"
S___WATHGRITHR.DESCRIBE.DISH_FAREWELLCUPCAKE = "你难道没有受够的时候，没有想过让某人滚蛋？"
S_______WEBBER.DESCRIBE.DISH_FAREWELLCUPCAKE = "来吧！我们纯粹的精神世界。"
-- S_______WINONA.DESCRIBE.DISH_FAREWELLCUPCAKE = ""
S_______WORTOX.DESCRIBE.DISH_FAREWELLCUPCAKE = "抱歉，活着就是这么痛苦。而我，还要活一辈子。"
-- S_____WORMWOOD.DESCRIBE.DISH_FAREWELLCUPCAKE = ""
-- S________WARLY.DESCRIBE.DISH_FAREWELLCUPCAKE = ""
S_________WURT.DESCRIBE.DISH_FAREWELLCUPCAKE = "即使明知是谎言，也会去相信。"
-- S_______WALTER.DESCRIBE.DISH_FAREWELLCUPCAKE = ""

S_NAMES.DISH_BRAISEDMEATWITHFOLIAGES = "蕨叶扣肉"
S______GENERIC.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = "看着好油腻，我只想吃一片。"
-- S_______WILLOW.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
S_____WOLFGANG.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = "沃尔夫冈超爱的！"
-- S________WENDY.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- S_________WX78.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- S_WICKERBOTTOM.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
S_______WOODIE.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = "很下饭的料理。"
-- S______WAXWELL.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- S___WATHGRITHR.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- S_______WEBBER.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- S_______WINONA.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- S_______WORTOX.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- S_____WORMWOOD.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
S________WARLY.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = "能把肥肉做得不油腻也挺不简单的。"
-- S_________WURT.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- S_______WALTER.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""

S_NAMES.DISH_WRAPPEDSHRIMPPASTE = "白菇虾滑卷"
STRINGS.UI.COOKBOOK.DISH_WRAPPEDSHRIMPPASTE = "提高抵抗力"
S______GENERIC.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = "赞诶！外层的素白菇很好地锁住了虾肉精华。"
-- S_______WILLOW.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
-- S_____WOLFGANG.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
-- S________WENDY.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
-- S_________WX78.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
-- S_WICKERBOTTOM.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
S_______WOODIE.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = "太好吃了，我能把木皿也吃了吗？"
-- S______WAXWELL.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
-- S___WATHGRITHR.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
-- S_______WEBBER.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
S_______WINONA.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = "这是怎么做出爽滑细腻口感的，反正不是我。"
-- S_______WORTOX.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
S_____WORMWOOD.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = "美丽的朋友，就适合做美丽的饭饭。"
S________WARLY.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = "啊，这菇，啊，这虾，感觉厨生到达了巅峰！"
S_________WURT.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = "做法实在是太残忍了，噗噗。"
-- S_______WALTER.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""

--------------------------------------------------------------------------
--[[ the sacrifice of rain ]]--[[ 祈雨祭 ]]
--------------------------------------------------------------------------

S_NAMES.RAINDONATE = "雨蝇"
S______GENERIC.DESCRIBE.RAINDONATE =
{
    GENERIC = "老一辈的总说杀死它就会开始下雨。",
    HELD = "瞧瞧，这只蓝色的小飞虫！",
}
--S_______WILLOW.DESCRIBE.RAINDONATE = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.RAINDONATE = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.RAINDONATE = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.RAINDONATE = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.RAINDONATE = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.RAINDONATE = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.RAINDONATE = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.RAINDONATE = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.RAINDONATE = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.RAINDONATE = "Great to cool off after some hard physical labor."

S_NAMES.MONSTRAIN = "雨竹"
S______GENERIC.DESCRIBE.MONSTRAIN =
{
    SUMMER = "底部的水分消失了。",
    WINTER = "底部的水分凝结了。",
    GENERIC = "当心，别碰到它的汁液！",
    PICKED = "我就看看，不碰。",
}
--[[
S_______WILLOW.DESCRIBE.MONSTRAIN =
{
    SUMMER = "The water at the bottom fled.",
    WINTER = "The water at the bottom solidified.",
    GENERIC = "Careful! Don't touch the juice of it!",
    PICKED = "I'll just take a look.",
}
S_____WOLFGANG.DESCRIBE.MONSTRAIN =
{
    SUMMER = "The water at the bottom fled.",
    WINTER = "The water at the bottom solidified.",
    GENERIC = "Careful! Don't touch the juice of it!",
    PICKED = "I'll just take a look.",
}
S________WENDY.DESCRIBE.MONSTRAIN =
{
    SUMMER = "The water at the bottom fled.",
    WINTER = "The water at the bottom solidified.",
    GENERIC = "Careful! Don't touch the juice of it!",
    PICKED = "I'll just take a look.",
}
S_________WX78.DESCRIBE.MONSTRAIN =
{
    SUMMER = "The water at the bottom fled.",
    WINTER = "The water at the bottom solidified.",
    GENERIC = "Careful! Don't touch the juice of it!",
    PICKED = "I'll just take a look.",
}
S_WICKERBOTTOM.DESCRIBE.MONSTRAIN =
{
    SUMMER = "The water at the bottom fled.",
    WINTER = "The water at the bottom solidified.",
    GENERIC = "Careful! Don't touch the juice of it!",
    PICKED = "I'll just take a look.",
}
S_______WOODIE.DESCRIBE.MONSTRAIN =
{
    SUMMER = "The water at the bottom fled.",
    WINTER = "The water at the bottom solidified.",
    GENERIC = "Careful! Don't touch the juice of it!",
    PICKED = "I'll just take a look.",
}
S______WAXWELL.DESCRIBE.MONSTRAIN =
{
    SUMMER = "The water at the bottom fled.",
    WINTER = "The water at the bottom solidified.",
    GENERIC = "Careful! Don't touch the juice of it!",
    PICKED = "I'll just take a look.",
}
S___WATHGRITHR.DESCRIBE.MONSTRAIN =
{
    SUMMER = "The water at the bottom fled.",
    WINTER = "The water at the bottom solidified.",
    GENERIC = "Careful! Don't touch the juice of it!",
    PICKED = "I'll just take a look.",
}
S_______WEBBER.DESCRIBE.MONSTRAIN =
{
    SUMMER = "The water at the bottom fled.",
    WINTER = "The water at the bottom solidified.",
    GENERIC = "Careful! Don't touch the juice of it!",
    PICKED = "I'll just take a look.",
}
S_______WINONA.DESCRIBE.MONSTRAIN =
{
    SUMMER = "The water at the bottom fled.",
    WINTER = "The water at the bottom solidified.",
    GENERIC = "Careful! Don't touch the juice of it!",
    PICKED = "I'll just take a look.",
}
]]--

S_NAMES.SQUAMOUSFRUIT = "鳞果"
S______GENERIC.DESCRIBE.SQUAMOUSFRUIT = "哇哦，可以吃的松果。"
--S_______WILLOW.DESCRIBE.SQUAMOUSFRUIT = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.SQUAMOUSFRUIT = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.SQUAMOUSFRUIT = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.SQUAMOUSFRUIT = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.SQUAMOUSFRUIT = "Well, isn't that refreshing?"
S_______WOODIE.DESCRIBE.SQUAMOUSFRUIT = "切，不能发芽的松果。"
--S______WAXWELL.DESCRIBE.SQUAMOUSFRUIT = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.SQUAMOUSFRUIT = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.SQUAMOUSFRUIT = "哇哦，带着我们最喜欢颜色的松果。"
--S_______WINONA.DESCRIBE.SQUAMOUSFRUIT = "Great to cool off after some hard physical labor."

S_NAMES.MONSTRAIN_LEAF = "雨竹叶"
S______GENERIC.DESCRIBE.MONSTRAIN_LEAF = "若我服食它，它也会腐蚀我。"
--S_______WILLOW.DESCRIBE.MONSTRAIN_LEAF = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.MONSTRAIN_LEAF = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.MONSTRAIN_LEAF = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.MONSTRAIN_LEAF = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.MONSTRAIN_LEAF = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.MONSTRAIN_LEAF = "Oops, a pinecone that cannot grow up."
--S______WAXWELL.DESCRIBE.MONSTRAIN_LEAF = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.MONSTRAIN_LEAF = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.MONSTRAIN_LEAF = "Wow, pinecone with our favorite color."
--S_______WINONA.DESCRIBE.MONSTRAIN_LEAF = "Great to cool off after some hard physical labor."

S_NAMES.BOOK_WEATHER = "多变的云"
S_RECIPE_DESC.BOOK_WEATHER = "拨云见日。"
S______GENERIC.DESCRIBE.BOOK_WEATHER = "当云层遮蔽烈日... 当阳光穿透阴霾..."
--S_______WILLOW.DESCRIBE.BOOK_WEATHER = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.BOOK_WEATHER = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.BOOK_WEATHER = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.BOOK_WEATHER = "STICK ADDON INSTALLED"
S_WICKERBOTTOM.DESCRIBE.BOOK_WEATHER = "嗯，现在我可以准确预测天气了。"
--S_______WOODIE.DESCRIBE.BOOK_WEATHER = "I'd prefer maple taffy..."
S______WAXWELL.DESCRIBE.BOOK_WEATHER = "嗯，现在我不用再玩骗人的把戏了。"
--S___WATHGRITHR.DESCRIBE.BOOK_WEATHER = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.BOOK_WEATHER = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.BOOK_WEATHER = "Great to cool off after some hard physical labor."
--STRINGS.CHARACTERS.WAGSTAFF.DESCRIBE.BOOK_WEATHER = "它违背了混沌学原理..."

S______GENERIC.ANNOUNCE_READ_BOOK.BOOK_WEATHER = "等等，不是只有沃特才会看书吗？"
-- S_______WILLOW.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- S_____WOLFGANG.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- S________WENDY.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- S_________WX78.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- S_WICKERBOTTOM.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- S_______WOODIE.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- S______WAXWELL.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- S___WATHGRITHR.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- S_______WEBBER.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- S_______WINONA.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- S_______WORTOX.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- S_____WORMWOOD.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- S________WARLY.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
S_________WURT.ANNOUNCE_READ_BOOK.BOOK_WEATHER_SUNNY = "太阳当空照，鳞片裂开来。"
S_________WURT.ANNOUNCE_READ_BOOK.BOOK_WEATHER_RAINY = "雨一直下，气氛融洽。"

S_NAMES.MERM_SCALES = "鱼鳞"
S______GENERIC.DESCRIBE.MERM_SCALES = "恶心，一大股鱼腥味。"
--S_______WILLOW.DESCRIBE.MERM_SCALES = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.MERM_SCALES = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.MERM_SCALES = "Contrary to Ms Squid's magic."
--S_________WX78.DESCRIBE.MERM_SCALES = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.MERM_SCALES = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.MERM_SCALES = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.MERM_SCALES = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.MERM_SCALES = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.MERM_SCALES = "流鼻涕的孩子又怎么了嘛？"
--S_______WINONA.DESCRIBE.MERM_SCALES = "Great to cool off after some hard physical labor."
S_________WURT.DESCRIBE.MERM_SCALES = "为什么..."

S_NAMES.HAT_MERMBREATHING = "鱼之息"
S_RECIPE_DESC.HAT_MERMBREATHING = "与鱼人同呼吸。"
S______GENERIC.DESCRIBE.HAT_MERMBREATHING = "希望我不会跳进海里也消失了。"
--S_______WILLOW.DESCRIBE.HAT_MERMBREATHING = ""
--S_____WOLFGANG.DESCRIBE.HAT_MERMBREATHING = ""
S________WENDY.DESCRIBE.HAT_MERMBREATHING = "与乌贼女士的魔法相反。"
--S_________WX78.DESCRIBE.HAT_MERMBREATHING = ""
--S_WICKERBOTTOM.DESCRIBE.HAT_MERMBREATHING = ""
--S_______WOODIE.DESCRIBE.HAT_MERMBREATHING = ""
--S______WAXWELL.DESCRIBE.HAT_MERMBREATHING = ""
--S___WATHGRITHR.DESCRIBE.HAT_MERMBREATHING = ""
S_______WEBBER.DESCRIBE.HAT_MERMBREATHING = "畅游大海指日可...额...缺个鱼尾巴。"
--S_______WINONA.DESCRIBE.HAT_MERMBREATHING = ""

S_NAMES.AGRONSSWORD = "艾力冈的剑"
S______GENERIC.DESCRIBE.AGRONSSWORD = "我会为了自由而战！"
S_______WILLOW.DESCRIBE.AGRONSSWORD = "星星信念，点燃自由之火。"
S_____WOLFGANG.DESCRIBE.AGRONSSWORD = "这让沃尔夫冈充满了勇气！"
S________WENDY.DESCRIBE.AGRONSSWORD = "如果我离开这里，阿比盖尔也会离我而去。"
S_________WX78.DESCRIBE.AGRONSSWORD = "渴望人性，但是也惧怕人性。"
S_WICKERBOTTOM.DESCRIBE.AGRONSSWORD = "别流泪，历史就是残酷的。"
S_______WOODIE.DESCRIBE.AGRONSSWORD = "露西总给我安慰，让我相信终有一天能逃离这里。"
S______WAXWELL.DESCRIBE.AGRONSSWORD = "能以一个自由的身份死去，这就是伟大的胜利了！"
S___WATHGRITHR.DESCRIBE.AGRONSSWORD = "当携雨使者陨落，英灵殿也为之动容。"
S_______WEBBER.DESCRIBE.AGRONSSWORD = "如果可以的话，我会带着我的蜘蛛大军杀出这里！"
S_______WINONA.DESCRIBE.AGRONSSWORD = "我是个工人，不是奴隶，我是我自己的！"
S_________WURT.DESCRIBE.AGRONSSWORD = "格勒...勇士没能成功吗？"

S_NAMES.GIANTSFOOT = "巨人之脚"
S_RECIPE_DESC.GIANTSFOOT = "让巨人掌管你的物品。"
S______GENERIC.DESCRIBE.GIANTSFOOT = "巨人能站在我的肩膀上。"
--S_______WILLOW.DESCRIBE.GIANTSFOOT = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.GIANTSFOOT = "Wolfgang can eat in one bite!"
S________WENDY.DESCRIBE.GIANTSFOOT = "嗯... 我是不是在哪见过它？"
--S_________WX78.DESCRIBE.GIANTSFOOT = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.GIANTSFOOT = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.GIANTSFOOT = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.GIANTSFOOT = "Hm... I don't know what I was expecting."
S___WATHGRITHR.DESCRIBE.GIANTSFOOT = "我出征约顿海姆的纪念品。"
--S_______WEBBER.DESCRIBE.GIANTSFOOT = "I can swim freely! er... need a fish tail."
--S_______WINONA.DESCRIBE.GIANTSFOOT = "Great to cool off after some hard physical labor."

S_NAMES.REFRACTEDMOONLIGHT = "月折宝剑"
S______GENERIC.DESCRIBE.REFRACTEDMOONLIGHT = "我的团啊！这是来自噢噢大陆的神器吗？"
-- S_______WILLOW.DESCRIBE.REFRACTEDMOONLIGHT = "A single faith can start a freedom fire."
-- S_____WOLFGANG.DESCRIBE.REFRACTEDMOONLIGHT = "It fills Wolfgang with courage!"
-- S________WENDY.DESCRIBE.REFRACTEDMOONLIGHT = "If I leave here, Abigail will leave me."
-- S_________WX78.DESCRIBE.REFRACTEDMOONLIGHT = "YEARN FOR HUMAN NATURE BUT... FEAR TO POSSESS IT."
S_WICKERBOTTOM.DESCRIBE.REFRACTEDMOONLIGHT = "只有身体健康的人才可以控制它的力量。"
-- S_______WOODIE.DESCRIBE.REFRACTEDMOONLIGHT = "Lucy comforts me, so I believe I can escape from here one day."
S______WAXWELL.DESCRIBE.REFRACTEDMOONLIGHT = "唯有完好无缺之人，才可驾驭它的力量。"
-- S___WATHGRITHR.DESCRIBE.REFRACTEDMOONLIGHT = "When the Bringer of Rain died, even Valhalla was moved."
-- S_______WEBBER.DESCRIBE.REFRACTEDMOONLIGHT = "If I could, I would be out of this world with my legion!"
-- S_______WINONA.DESCRIBE.REFRACTEDMOONLIGHT = "I am a laborer, not a slave, I'm my own!"

S_NAMES.MOONDUNGEON = "月的地下城"
S______GENERIC.DESCRIBE.MOONDUNGEON =
{
    SLEEP = "那是古化石吗？",
    GENERIC = "某人用毕生心血打造了这个奇怪建筑。",
}
S___WATHGRITHR.DESCRIBE.MOONDUNGEON =
{
    SLEEP = "摩尼的宫殿。",
    GENERIC = "某人用毕生心血打造了这个奇怪建筑。",
}
--[[
S_______WILLOW.DESCRIBE.MOONDUNGEON =
{
    SLEEP = "Is that fossilized fossil?",
    GENERIC = "Someone burned up his whole life and built it here.",
}
S_____WOLFGANG.DESCRIBE.MOONDUNGEON =
{
    SLEEP = "Is that fossilized fossil?",
    GENERIC = "Someone burned up his whole life and built it here.",
}
S________WENDY.DESCRIBE.MOONDUNGEON =
{
    SLEEP = "Is that fossilized fossil?",
    GENERIC = "Someone burned up his whole life and built it here.",
}
S_________WX78.DESCRIBE.MOONDUNGEON =
{
    SLEEP = "Is that fossilized fossil?",
    GENERIC = "Someone burned up his whole life and built it here.",
}
S_WICKERBOTTOM.DESCRIBE.MOONDUNGEON =
{
    SLEEP = "Is that fossilized fossil?",
    GENERIC = "Someone burned up his whole life and built it here.",
}
S_______WOODIE.DESCRIBE.MOONDUNGEON =
{
    SLEEP = "Is that fossilized fossil?",
    GENERIC = "Someone burned up his whole life and built it here.",
}
S______WAXWELL.DESCRIBE.MOONDUNGEON =
{
    SLEEP = "Is that fossilized fossil?",
    GENERIC = "Someone burned up his whole life and built it here.",
}
S_______WEBBER.DESCRIBE.MOONDUNGEON =
{
    SLEEP = "Is that fossilized fossil?",
    GENERIC = "Someone burned up his whole life and built it here.",
}
S_______WINONA.DESCRIBE.MOONDUNGEON =
{
    SLEEP = "Is that fossilized fossil?",
    GENERIC = "Someone burned up his whole life and built it here.",
}
]]--

S_NAMES.HIDDENMOONLIGHT = "月藏宝匣"
S______GENERIC.DESCRIBE.HIDDENMOONLIGHT = "里面如银河一般深邃。"
-- S_______WILLOW.DESCRIBE.HIDDENMOONLIGHT = ""
S_____WOLFGANG.DESCRIBE.HIDDENMOONLIGHT = "瞧！有星星在对沃尔夫冈眨眼。"
S________WENDY.DESCRIBE.HIDDENMOONLIGHT = "白月光，心里某个地方。"
-- S_________WX78.DESCRIBE.HIDDENMOONLIGHT = ""
S_WICKERBOTTOM.DESCRIBE.HIDDENMOONLIGHT = "这盒子里的时间流速比外面缓慢得多。"
-- S_______WOODIE.DESCRIBE.HIDDENMOONLIGHT = ""
S______WAXWELL.DESCRIBE.HIDDENMOONLIGHT = "月的魔法可不止这点用途。"
-- S___WATHGRITHR.DESCRIBE.HIDDENMOONLIGHT = ""
S_______WEBBER.DESCRIBE.HIDDENMOONLIGHT = "耶！伸手进去想到什么就能抓到什么。"
-- S_______WINONA.DESCRIBE.HIDDENMOONLIGHT = ""
-- S_______WORTOX.DESCRIBE.HIDDENMOONLIGHT = ""
S_____WORMWOOD.DESCRIBE.HIDDENMOONLIGHT = "内心空洞，和我一样。"
-- S________WARLY.DESCRIBE.HIDDENMOONLIGHT = ""
-- S_________WURT.DESCRIBE.HIDDENMOONLIGHT = ""
S_______WALTER.DESCRIBE.HIDDENMOONLIGHT = "噗噜，咋没有海浪的声音传出来呢？"

S_NAMES.HIDDENMOONLIGHT_ITEM = "未启用的月藏宝匣"
S_RECIPE_DESC.HIDDENMOONLIGHT_ITEM = "藏珍馐于星月交辉处。"
S______GENERIC.DESCRIBE.HIDDENMOONLIGHT_ITEM = "它貌似是储食类箱子的升级套件。"
-- S_______WILLOW.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
S_____WOLFGANG.DESCRIBE.HIDDENMOONLIGHT_ITEM = "这难道也是古法秘制的冰箱零件？"
-- S________WENDY.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
-- S_________WX78.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
-- S_WICKERBOTTOM.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
-- S_______WOODIE.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
S______WAXWELL.DESCRIBE.HIDDENMOONLIGHT_ITEM = "一个以月光为能源的盒子。"
S___WATHGRITHR.DESCRIBE.HIDDENMOONLIGHT_ITEM = "希望别是潘多拉的盒子。"
-- S_______WEBBER.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
S_______WINONA.DESCRIBE.HIDDENMOONLIGHT_ITEM = "这是月给予的灵感。"
S_______WORTOX.DESCRIBE.HIDDENMOONLIGHT_ITEM = "我能感受到它正受装满食物的盒子的召唤。"
-- S_____WORMWOOD.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
-- S________WARLY.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
-- S_________WURT.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
-- S_______WALTER.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""

--------------------------------------------------------------------------
--[[ legends of the fall ]]--[[ 丰饶传说 ]]
--------------------------------------------------------------------------

S_NAMES.PINEANANAS = "松萝"
S______GENERIC.DESCRIBE.PINEANANAS = "生吃它会麻掉我的整张嘴。"
-- S_______WILLOW.DESCRIBE.PINEANANAS = ""
-- S_____WOLFGANG.DESCRIBE.PINEANANAS = ""
-- S________WENDY.DESCRIBE.PINEANANAS = ""
-- S_________WX78.DESCRIBE.PINEANANAS = ""
S_WICKERBOTTOM.DESCRIBE.PINEANANAS = "你知道吗？有些地区的人们会搭配酱油食用这种水果。"
-- S_______WOODIE.DESCRIBE.PINEANANAS = ""
-- S______WAXWELL.DESCRIBE.PINEANANAS = ""
-- S___WATHGRITHR.DESCRIBE.PINEANANAS = ""
-- S_______WEBBER.DESCRIBE.PINEANANAS = ""
-- S_______WINONA.DESCRIBE.PINEANANAS = ""
-- S_______WORTOX.DESCRIBE.PINEANANAS = ""
-- S_____WORMWOOD.DESCRIBE.PINEANANAS = ""
-- S________WARLY.DESCRIBE.PINEANANAS = ""
-- S_________WURT.DESCRIBE.PINEANANAS = ""
-- S_______WALTER.DESCRIBE.PINEANANAS = ""

S_NAMES.PINEANANAS_COOKED = "烤松萝"
S______GENERIC.DESCRIBE.PINEANANAS_COOKED = "烤过之后尝起来就挺棒的了。"
-- S_______WILLOW.DESCRIBE.PINEANANAS_COOKED = ""
-- S_____WOLFGANG.DESCRIBE.PINEANANAS_COOKED = ""
-- S________WENDY.DESCRIBE.PINEANANAS_COOKED = ""
-- S_________WX78.DESCRIBE.PINEANANAS_COOKED = ""
-- S_WICKERBOTTOM.DESCRIBE.PINEANANAS_COOKED = ""
-- S_______WOODIE.DESCRIBE.PINEANANAS_COOKED = ""
-- S______WAXWELL.DESCRIBE.PINEANANAS_COOKED = ""
-- S___WATHGRITHR.DESCRIBE.PINEANANAS_COOKED = ""
-- S_______WEBBER.DESCRIBE.PINEANANAS_COOKED = ""
-- S_______WINONA.DESCRIBE.PINEANANAS_COOKED = ""
-- S_______WORTOX.DESCRIBE.PINEANANAS_COOKED = ""
-- S_____WORMWOOD.DESCRIBE.PINEANANAS_COOKED = ""
-- S________WARLY.DESCRIBE.PINEANANAS_COOKED = ""
-- S_________WURT.DESCRIBE.PINEANANAS_COOKED = ""
-- S_______WALTER.DESCRIBE.PINEANANAS_COOKED = ""

S_NAMES.PINEANANAS_SEEDS = "嵌合种子"
S______GENERIC.DESCRIBE.PINEANANAS_SEEDS = "我不确定这应该是个松果还是菠萝种子。"
-- S_______WILLOW.DESCRIBE.PINEANANAS_SEEDS = ""
-- S_____WOLFGANG.DESCRIBE.PINEANANAS_SEEDS = ""
-- S________WENDY.DESCRIBE.PINEANANAS_SEEDS = ""
S_________WX78.DESCRIBE.PINEANANAS_SEEDS = "嵌合体植物的源代码"
-- S_WICKERBOTTOM.DESCRIBE.PINEANANAS_SEEDS = ""
-- S_______WOODIE.DESCRIBE.PINEANANAS_SEEDS = ""
-- S______WAXWELL.DESCRIBE.PINEANANAS_SEEDS = ""
-- S___WATHGRITHR.DESCRIBE.PINEANANAS_SEEDS = ""
-- S_______WEBBER.DESCRIBE.PINEANANAS_SEEDS = ""
-- S_______WINONA.DESCRIBE.PINEANANAS_SEEDS = ""
-- S_______WORTOX.DESCRIBE.PINEANANAS_SEEDS = ""
-- S_____WORMWOOD.DESCRIBE.PINEANANAS_SEEDS = ""
-- S________WARLY.DESCRIBE.PINEANANAS_SEEDS = ""
-- S_________WURT.DESCRIBE.PINEANANAS_SEEDS = ""
-- S_______WALTER.DESCRIBE.PINEANANAS_SEEDS = ""

S_NAMES.PINEANANAS_OVERSIZED = "巨型松萝"
S______GENERIC.DESCRIBE.PINEANANAS_OVERSIZED = "好大一个橘色的松果！"
-- S_______WILLOW.DESCRIBE.PINEANANAS_OVERSIZED = ""
-- S_____WOLFGANG.DESCRIBE.PINEANANAS_OVERSIZED = ""
-- S________WENDY.DESCRIBE.PINEANANAS_OVERSIZED = ""
-- S_________WX78.DESCRIBE.PINEANANAS_OVERSIZED = ""
-- S_WICKERBOTTOM.DESCRIBE.PINEANANAS_OVERSIZED = ""
-- S_______WOODIE.DESCRIBE.PINEANANAS_OVERSIZED = ""
-- S______WAXWELL.DESCRIBE.PINEANANAS_OVERSIZED = ""
-- S___WATHGRITHR.DESCRIBE.PINEANANAS_OVERSIZED = ""
-- S_______WEBBER.DESCRIBE.PINEANANAS_OVERSIZED = ""
-- S_______WINONA.DESCRIBE.PINEANANAS_OVERSIZED = ""
-- S_______WORTOX.DESCRIBE.PINEANANAS_OVERSIZED = ""
-- S_____WORMWOOD.DESCRIBE.PINEANANAS_OVERSIZED = ""
S________WARLY.DESCRIBE.PINEANANAS_OVERSIZED = "我想到许多甜蜜的回忆，额，不是，料理。"
-- S_________WURT.DESCRIBE.PINEANANAS_OVERSIZED = ""
-- S_______WALTER.DESCRIBE.PINEANANAS_OVERSIZED = ""

S_NAMES.PINEANANAS_OVERSIZED_ROTTEN = "巨型腐烂松萝"
S_NAMES.FARM_PLANT_PINEANANAS = "松萝树"
S_NAMES.KNOWN_PINEANANAS_SEEDS = "松萝种子"
STRINGS.UI.PLANTREGISTRY.DESCRIPTIONS.PINEANANAS = "根深不怕风摇动，树正何愁影子斜。——W"

-----

S_NAMES.PLANT_NORMAL_LEGION = "农作物"
S______GENERIC.DESCRIBE.PLANT_NORMAL_LEGION =
{
    WITHERED = "唉，只是需要水而已。",
    READY = "我希望马上吃掉它。",
    FLORESCENCE = "我希望它快点结果。",
    YOUTH = "我希望它快点开花。",
    GROWING = "我希望它快点长大。",
}
S_______WILLOW.DESCRIBE.PLANT_NORMAL_LEGION =
{
    WITHERED = "才这点温度就蔫了，就这？",
    READY = "终于长好了，我等的花都谢了。",
    FLORESCENCE = "快给我结果！",
    YOUTH = "快给我开花！",
    GROWING = "快给我长大！",
}
S_______WEBBER.DESCRIBE.PLANT_NORMAL_LEGION =
{
    WITHERED = "唉，本该种另一颗种子的。",
    READY = "耶！收获时间到！",
    FLORESCENCE = "哇！快快结果吧。",
    YOUTH = "嘿，快快开花吧。",
    GROWING = "嗯，快快长大吧。",
}
S___WATHGRITHR.DESCRIBE.PLANT_NORMAL_LEGION =
{
    WITHERED = "我就知道，脆弱如蝼蚁。",
    READY = "真正的战士不需要，但她的朋友们需要！",
    FLORESCENCE = "像我一样，在自己的领地大放光彩！",
    YOUTH = "我看不到它有任何的可取之处。",
    GROWING = "真正的战士是不需要种地的。",
}
-- S_____WOLFGANG.DESCRIBE.PLANT_NORMAL_LEGION =
-- {
--     WITHERED = "What a pity! Waiting to be watered, but...",
--     READY = "Oho! Waiting to be eaten!",
--     FLORESCENCE = "Gee! Waiting for you to bear fruit.",
--     YOUTH = "Meh. Waiting for you to bloom.",
--     GROWING = "Mmmm. Waiting for you to grow up.",
-- }
-- S________WENDY.DESCRIBE.PLANT_NORMAL_LEGION =
-- {
--     WITHERED = "What a pity! Waiting to be watered, but...",
--     READY = "Oho! Waiting to be eaten!",
--     FLORESCENCE = "Gee! Waiting for you to bear fruit.",
--     YOUTH = "Meh. Waiting for you to bloom.",
--     GROWING = "Mmmm. Waiting for you to grow up.",
-- }
-- S_________WX78.DESCRIBE.PLANT_NORMAL_LEGION =
-- {
--     WITHERED = "What a pity! Waiting to be watered, but...",
--     READY = "Oho! Waiting to be eaten!",
--     FLORESCENCE = "Gee! Waiting for you to bear fruit.",
--     YOUTH = "Meh. Waiting for you to bloom.",
--     GROWING = "Mmmm. Waiting for you to grow up.",
-- }
-- S_WICKERBOTTOM.DESCRIBE.PLANT_NORMAL_LEGION =
-- {
--     WITHERED = "What a pity! Waiting to be watered, but...",
--     READY = "Oho! Waiting to be eaten!",
--     FLORESCENCE = "Gee! Waiting for you to bear fruit.",
--     YOUTH = "Meh. Waiting for you to bloom.",
--     GROWING = "Mmmm. Waiting for you to grow up.",
-- }
-- S_______WOODIE.DESCRIBE.PLANT_NORMAL_LEGION =
-- {
--     WITHERED = "What a pity! Waiting to be watered, but...",
--     READY = "Oho! Waiting to be eaten!",
--     FLORESCENCE = "Gee! Waiting for you to bear fruit.",
--     YOUTH = "Meh. Waiting for you to bloom.",
--     GROWING = "Mmmm. Waiting for you to grow up.",
-- }
-- S______WAXWELL.DESCRIBE.PLANT_NORMAL_LEGION =
-- {
--     WITHERED = "What a pity! Waiting to be watered, but...",
--     READY = "Oho! Waiting to be eaten!",
--     FLORESCENCE = "Gee! Waiting for you to bear fruit.",
--     YOUTH = "Meh. Waiting for you to bloom.",
--     GROWING = "Mmmm. Waiting for you to grow up.",
-- }
-- S_______WINONA.DESCRIBE.PLANT_NORMAL_LEGION =
-- {
--     WITHERED = "What a pity! Waiting to be watered, but...",
--     READY = "Oho! Waiting to be eaten!",
--     FLORESCENCE = "Gee! Waiting for you to bear fruit.",
--     YOUTH = "Meh. Waiting for you to bloom.",
--     GROWING = "Mmmm. Waiting for you to grow up.",
-- }
S________WARLY.DESCRIBE.PLANT_NORMAL_LEGION =
{
    WITHERED = "对不起，这道菜卖光了。",
    READY = "快啦，你点的菜就要做好了。",
    FLORESCENCE = "别催，你点的菜马上就好。",
    YOUTH = "马上就好了，你点的菜正在长。",
    GROWING = "别着急，你点的菜才发芽。",
}
-- S_______WORTOX.DESCRIBE.PLANT_NORMAL_LEGION =
-- {
--     WITHERED = "What a pity! Waiting to be watered, but...",
--     READY = "Oho! Waiting to be eaten!",
--     FLORESCENCE = "Gee! Waiting for you to bear fruit.",
--     YOUTH = "Meh. Waiting for you to bloom.",
--     GROWING = "Mmmm. Waiting for you to grow up.",
-- }
S_____WORMWOOD.DESCRIBE.PLANT_NORMAL_LEGION =
{
    WITHERED = "抱歉朋友，本应该特别关照你的。",
    READY = "噢，这是位老朋友了。",
    FLORESCENCE = "瞧瞧你，都乐开花了。",
    YOUTH = "朋友，成熟一点，好吗。",
    GROWING = "可爱的小朋友。",
}
-- S_________WURT.DESCRIBE.PLANT_NORMAL_LEGION =
-- {
--     WITHERED = "What a pity! Waiting to be watered, but...",
--     READY = "Oho! Waiting to be eaten!",
--     FLORESCENCE = "Gee! Waiting for you to bear fruit.",
--     YOUTH = "Meh. Waiting for you to bloom.",
--     GROWING = "Mmmm. Waiting for you to grow up.",
-- }

S_NAMES.FARMINGDUNGBALL_ITEM = "栽培肥料球"
S_RECIPE_DESC.FARMINGDUNGBALL_ITEM = "种子该待的地方。"
S______GENERIC.DESCRIBE.FARMINGDUNGBALL_ITEM = "真是恶心！我并不想知道它的制作过程。"
--S_______WILLOW.DESCRIBE.FARMINGDUNGBALL_ITEM = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.FARMINGDUNGBALL_ITEM = "Wolfgang can eat in one bite!"
S________WENDY.DESCRIBE.FARMINGDUNGBALL_ITEM = "灰姑娘以前可能也做过这个。"
S_________WX78.DESCRIBE.FARMINGDUNGBALL_ITEM = "所有人都讨厌的东西不一定是完全没用的。"
S_WICKERBOTTOM.DESCRIBE.FARMINGDUNGBALL_ITEM = "这种方法一般用于玉米栽培。"
--S_______WOODIE.DESCRIBE.FARMINGDUNGBALL_ITEM = "I'd prefer maple taffy..."
S______WAXWELL.DESCRIBE.FARMINGDUNGBALL_ITEM = "我越来越像个农民了。"
--S___WATHGRITHR.DESCRIBE.FARMINGDUNGBALL_ITEM = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.FARMINGDUNGBALL_ITEM = "有点像玩泥巴，也有点臭臭的。"
--S_______WINONA.DESCRIBE.FARMINGDUNGBALL_ITEM = "Great to cool off after some hard physical labor."
S_______WORTOX.DESCRIBE.FARMINGDUNGBALL_ITEM = "嘻嘻嘻，我应该在打雪仗的时候用这个。"

S_NAMES.FARMINGDUNGBALL = "栽培肥料堆"
S______GENERIC.DESCRIBE.FARMINGDUNGBALL = "真是恶心！我并不想知道它的制作过程。"
--S_______WILLOW.DESCRIBE.FARMINGDUNGBALL = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.FARMINGDUNGBALL = "Wolfgang can eat in one bite!"
S________WENDY.DESCRIBE.FARMINGDUNGBALL = "灰姑娘以前可能也做过这个。"
S_________WX78.DESCRIBE.FARMINGDUNGBALL = "所有人都讨厌的东西不一定是完全没用的。"
S_WICKERBOTTOM.DESCRIBE.FARMINGDUNGBALL = "这种方法一般用于玉米栽培。"
--S_______WOODIE.DESCRIBE.FARMINGDUNGBALL = "I'd prefer maple taffy..."
S______WAXWELL.DESCRIBE.FARMINGDUNGBALL = "我越来越像个农民了。"
--S___WATHGRITHR.DESCRIBE.FARMINGDUNGBALL = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.FARMINGDUNGBALL = "有点像玩泥巴，也有点臭臭的。"
--S_______WINONA.DESCRIBE.FARMINGDUNGBALL = "Great to cool off after some hard physical labor."
S_______WORTOX.DESCRIBE.FARMINGDUNGBALL = "嘿，谁在打雪仗时掉的这个？"

S_NAMES.CROPGNAT = "植害虫群"
S______GENERIC.DESCRIBE.CROPGNAT = "嘿！离我的作物远点，小害虫们！"
S_______WILLOW.DESCRIBE.CROPGNAT = "它们也喜欢火吗？"
S_____WOLFGANG.DESCRIBE.CROPGNAT = "幸运的是，它们不会叮咬沃尔夫冈。"
-- S________WENDY.DESCRIBE.CROPGNAT = "Baby's always so cute, grown one's not."
-- S_________WX78.DESCRIBE.CROPGNAT = "STICK ADDON INSTALLED"
S_WICKERBOTTOM.DESCRIBE.CROPGNAT = "最好找到方法解决它们，不然就会颗粒无收。"
-- S_______WOODIE.DESCRIBE.CROPGNAT = "Hah. Not as funny as Chaplin."
-- S______WAXWELL.DESCRIBE.CROPGNAT = "Hm... No Monster child, no future trouble."
-- S___WATHGRITHR.DESCRIBE.CROPGNAT = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.CROPGNAT = "在我打坏邻居家窗户的时候他们也叫我小害虫！"
-- S_______WINONA.DESCRIBE.CROPGNAT = "Neither the Keystone, nor a key thing."
-- S_______WORTOX.DESCRIBE.CROPGNAT = "Hey, who dropped this in a snowball fight?"
S_____WORMWOOD.DESCRIBE.CROPGNAT = "会伤害植物朋友的朋友。"

S_NAMES.CROPGNAT_INFESTER = "叮咬虫群"
S______GENERIC.DESCRIBE.CROPGNAT_INFESTER = "小心点，这些飞虫会叮咬人。"
S_______WILLOW.DESCRIBE.CROPGNAT_INFESTER = "这些蠢虫子会被我的火光吸引。"
S_____WOLFGANG.DESCRIBE.CROPGNAT_INFESTER = "噢，这些小怪物会咬人！"
-- S________WENDY.DESCRIBE.CROPGNAT_INFESTER = "Baby's always so cute, grown one's not."
S_________WX78.DESCRIBE.CROPGNAT_INFESTER = "它们连铁皮都咬？"
S_WICKERBOTTOM.DESCRIBE.CROPGNAT_INFESTER = "具备攻击性的趋光生物。"
-- S_______WOODIE.DESCRIBE.CROPGNAT_INFESTER = "Hah. Not as funny as Chaplin."
-- S______WAXWELL.DESCRIBE.CROPGNAT_INFESTER = "Hm... No Monster child, no future trouble."
-- S___WATHGRITHR.DESCRIBE.CROPGNAT_INFESTER = "I've somehow found a way to make it even LESS appealing!"
-- S_______WEBBER.DESCRIBE.CROPGNAT_INFESTER = "We don't want to grow up, do you?"
S_______WINONA.DESCRIBE.CROPGNAT_INFESTER = "我的天，它们太吵了。"
S_______WORTOX.DESCRIBE.CROPGNAT_INFESTER = "哈哈，你得习惯在野外的生活。"
S_____WORMWOOD.DESCRIBE.CROPGNAT_INFESTER = "会叮咬朋友的朋友。"

S_NAMES.AHANDFULOFWINGS = "一捧翅膀"
S______GENERIC.DESCRIBE.AHANDFULOFWINGS = "一捧非常小的昆虫翅膀。"
-- S_______WILLOW.DESCRIBE.AHANDFULOFWINGS = "Stupid bugs will be attracted by my fire."
-- S_____WOLFGANG.DESCRIBE.AHANDFULOFWINGS = "Ouch! these little monsters bite!"
-- S________WENDY.DESCRIBE.AHANDFULOFWINGS = "Baby's always so cute, grown one's not."
-- S_________WX78.DESCRIBE.AHANDFULOFWINGS = "THEY BITE EVEN THE IRON?"
-- S_WICKERBOTTOM.DESCRIBE.AHANDFULOFWINGS = "Aggressive and can be attracted by light."
-- S_______WOODIE.DESCRIBE.AHANDFULOFWINGS = "Hah. Not as funny as Chaplin."
-- S______WAXWELL.DESCRIBE.AHANDFULOFWINGS = "Hm... No Monster child, no future trouble."
-- S___WATHGRITHR.DESCRIBE.AHANDFULOFWINGS = "I've somehow found a way to make it even LESS appealing!"
-- S_______WEBBER.DESCRIBE.AHANDFULOFWINGS = "We don't want to grow up, do you?"
-- S_______WINONA.DESCRIBE.AHANDFULOFWINGS = "Oh my, the noise is terrible."
-- S_______WORTOX.DESCRIBE.AHANDFULOFWINGS = "Hah, you have to get used to this in the wild."
-- S_____WORMWOOD.DESCRIBE.AHANDFULOFWINGS = "Some friends who would bite a friend."

S_NAMES.BOLTWINGOUT = "脱壳之翅"
S_RECIPE_DESC.BOLTWINGOUT = "金蝉脱壳，逃之夭夭。"
S______GENERIC.DESCRIBE.BOLTWINGOUT = "命悬一线，死里逃生。"
-- S_______WILLOW.DESCRIBE.BOLTWINGOUT = "Stupid bugs will be attracted by my fire."
-- S_____WOLFGANG.DESCRIBE.BOLTWINGOUT = "Ouch! these little monsters bite!"
-- S________WENDY.DESCRIBE.BOLTWINGOUT = "Baby's always so cute, grown one's not."
S_________WX78.DESCRIBE.BOLTWINGOUT = "短时间加速设备"
-- S_WICKERBOTTOM.DESCRIBE.BOLTWINGOUT = "Aggressive and can be attracted by light."
-- S_______WOODIE.DESCRIBE.BOLTWINGOUT = "Hah. Not as funny as Chaplin."
S______WAXWELL.DESCRIBE.BOLTWINGOUT = "学习昆虫的生存之道。"
S___WATHGRITHR.DESCRIBE.BOLTWINGOUT = "啧啧，真正的战士从不逃跑！"
-- S_______WEBBER.DESCRIBE.BOLTWINGOUT = "We don't want to grow up, do you?"
S_______WINONA.DESCRIBE.BOLTWINGOUT = "I just wanna run... hide it away!" --这句是英语歌词，所以不翻译
S_______WORTOX.DESCRIBE.BOLTWINGOUT = "切，我用灵魂也能做出这个效果。"
-- S_____WORMWOOD.DESCRIBE.BOLTWINGOUT = "Some friends who would bite a friend."

S_NAMES.BOLTWINGOUT_SHUCK = "羽化后的壳"
S______GENERIC.DESCRIBE.BOLTWINGOUT_SHUCK = "哈哈，很多生物都看不出来这只是一个壳而已。"
S_______WILLOW.DESCRIBE.BOLTWINGOUT_SHUCK = "好大一只假虫子，烧掉烧掉！"
-- S_____WOLFGANG.DESCRIBE.BOLTWINGOUT_SHUCK = "Ouch! these little monsters bite!"
-- S________WENDY.DESCRIBE.BOLTWINGOUT_SHUCK = "Baby's always so cute, grown one's not."
S_________WX78.DESCRIBE.BOLTWINGOUT_SHUCK = "狡猾的虫子！"
-- S_WICKERBOTTOM.DESCRIBE.BOLTWINGOUT_SHUCK = "Aggressive and can be attracted by light."
-- S_______WOODIE.DESCRIBE.BOLTWINGOUT_SHUCK = "Hah. Not as funny as Chaplin."
S______WAXWELL.DESCRIBE.BOLTWINGOUT_SHUCK = "三十六计，走为上策。"
-- S___WATHGRITHR.DESCRIBE.BOLTWINGOUT_SHUCK = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.BOLTWINGOUT_SHUCK = "我们蜕皮之后也会丢掉老旧的皮。"
S_______WINONA.DESCRIBE.BOLTWINGOUT_SHUCK = "这壳才不是随便丢掉的，它自有用途。"
-- S_______WORTOX.DESCRIBE.BOLTWINGOUT_SHUCK = "Hah, you have to get used to this in the wild."
S_____WORMWOOD.DESCRIBE.BOLTWINGOUT_SHUCK = "嘿朋友，你还在里面吗？"

S_NAMES.CATMINT = "猫薄荷"
S______GENERIC.DESCRIBE.CATMINT = "有清香的味道。"
-- S_______WILLOW.DESCRIBE.CATMINT = ""
S_____WOLFGANG.DESCRIBE.CATMINT = "沃尔夫冈想吃口香糖了。"
-- S________WENDY.DESCRIBE.CATMINT = ""
S_________WX78.DESCRIBE.CATMINT = "不就是一些普通杂草吗。"
S_WICKERBOTTOM.DESCRIBE.CATMINT = "说真的，薄荷和猫薄荷不是同一种植物。"
-- S_______WOODIE.DESCRIBE.CATMINT = ""
-- S______WAXWELL.DESCRIBE.CATMINT = ""
-- S___WATHGRITHR.DESCRIBE.CATMINT = ""
S_______WEBBER.DESCRIBE.CATMINT = "拿去喂给森林里的猫们怎么样？"
-- S_______WINONA.DESCRIBE.CATMINT = ""
S_______WORTOX.DESCRIBE.CATMINT = "算了，我不会喜欢这个。"
S_____WORMWOOD.DESCRIBE.CATMINT = "你好啊，香香的朋友。"
S________WARLY.DESCRIBE.CATMINT = "我能拿来当做调料就好了。"
S_________WURT.DESCRIBE.CATMINT = "作为素食者，我很喜欢。"

S_NAMES.CATTENBALL = "猫线球"
S______GENERIC.DESCRIBE.CATTENBALL = "尽管是从胃里倒腾出来的，但还是很可爱。"
-- S_______WILLOW.DESCRIBE.CATTENBALL = ""
-- S_____WOLFGANG.DESCRIBE.CATTENBALL = ""
-- S________WENDY.DESCRIBE.CATTENBALL = ""
S_________WX78.DESCRIBE.CATTENBALL = "闻起来一股猫的味道。"
-- S_WICKERBOTTOM.DESCRIBE.CATTENBALL = ""
-- S_______WOODIE.DESCRIBE.CATTENBALL = ""
-- S______WAXWELL.DESCRIBE.CATTENBALL = ""
-- S___WATHGRITHR.DESCRIBE.CATTENBALL = ""
S_______WEBBER.DESCRIBE.CATTENBALL = "我们必须要在床上办个玩具展。"
S_______WINONA.DESCRIBE.CATTENBALL = "也许可以用来织毛衣。"
S_______WORTOX.DESCRIBE.CATTENBALL = "看看看，和我一样的颜色呢。"
-- S_____WORMWOOD.DESCRIBE.CATTENBALL = ""
-- S________WARLY.DESCRIBE.CATTENBALL = ""
S_________WURT.DESCRIBE.CATTENBALL = "住在荒漠幻影里的那位老婆婆肯定很喜欢这个。"

--------------------------------------------------------------------------
--[[ flash and crush ]]--[[ 电闪雷鸣 ]]
--------------------------------------------------------------------------

STRINGS.UI.CRAFTING.ELECOURMALINE_ONE = "使用电气重铸台制造一个原型！"
STRINGS.UI.CRAFTING.ELECOURMALINE_TWO = "看起来这个重铸台没有被完全激活！"
STRINGS.UI.CRAFTING.ELECOURMALINE_THREE = "看起来这个重铸台没有被完全激活！"

S_NAMES.ELECOURMALINE = "电气重铸台"
S______GENERIC.DESCRIBE.ELECOURMALINE = "电与创造力量的结晶。"
--S_______WILLOW.DESCRIBE.ELECOURMALINE = "Oh! So cute, like my Bernie."
--S_____WOLFGANG.DESCRIBE.ELECOURMALINE = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.ELECOURMALINE = "Baby's always so cute, grown one's not."
S_________WX78.DESCRIBE.ELECOURMALINE = "只需一小块，我就能给自己充能。"
S_WICKERBOTTOM.DESCRIBE.ELECOURMALINE = "我听说这种石头被加热后会放电。"
--S_______WOODIE.DESCRIBE.ELECOURMALINE = "The axe that can't chop is not a good axe."
S______WAXWELL.DESCRIBE.ELECOURMALINE = "他们中的另一个也来了，真棒。"
--S___WATHGRITHR.DESCRIBE.ELECOURMALINE = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.ELECOURMALINE = "我们的毛发都竖起来了。"
--S_______WINONA.DESCRIBE.ELECOURMALINE = "Great to cool off after some hard physical labor."

S_NAMES.ELECOURMALINE_KEYSTONE = "要石"
S______GENERIC.DESCRIBE.ELECOURMALINE_KEYSTONE = "大自然的鬼斧神工。"
--S_______WILLOW.DESCRIBE.ELECOURMALINE_KEYSTONE = "Oh! So cute, like my Bernie."
--S_____WOLFGANG.DESCRIBE.ELECOURMALINE_KEYSTONE = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.ELECOURMALINE_KEYSTONE = "Baby's always so cute, grown one's not."
--S_________WX78.DESCRIBE.ELECOURMALINE_KEYSTONE = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.ELECOURMALINE_KEYSTONE = "Well, isn't that refreshing?"
S_______WOODIE.DESCRIBE.ELECOURMALINE_KEYSTONE = "切，这东西可没有卓别林搞笑。"
--S______WAXWELL.DESCRIBE.ELECOURMALINE_KEYSTONE = "Hm... No Monster child, no future trouble."
--S___WATHGRITHR.DESCRIBE.ELECOURMALINE_KEYSTONE = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.ELECOURMALINE_KEYSTONE = "We don't want to grow up, do you?"
S_______WINONA.DESCRIBE.ELECOURMALINE_KEYSTONE = "既不被人知晓，也不是真的重要吧。"

S_NAMES.FIMBUL_AXE = "芬布尔斧"
-- S_RECIPE_DESC.FIMBUL_AXE = "感受这，电闪雷鸣般愤怒！" --这个不能制作
S______GENERIC.DESCRIBE.FIMBUL_AXE = "BOOM SHAKA LAKA！"
--S_______WILLOW.DESCRIBE.FIMBUL_AXE = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.FIMBUL_AXE = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.FIMBUL_AXE = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.FIMBUL_AXE = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.FIMBUL_AXE = "Well, isn't that refreshing?"
S_______WOODIE.DESCRIBE.FIMBUL_AXE = "不能砍树的斧头不是好斧头。"
--S______WAXWELL.DESCRIBE.FIMBUL_AXE = "Hm... I don't know what I was expecting."
S___WATHGRITHR.DESCRIBE.FIMBUL_AXE = "它叫做\"芬布尔\"，但召唤的却是闪电？"
--S_______WEBBER.DESCRIBE.FIMBUL_AXE = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.FIMBUL_AXE = "Great to cool off after some hard physical labor."

S_NAMES.HAT_COWBOY = "牛仔帽"
S_RECIPE_DESC.HAT_COWBOY = "想成为驯服大师吗？"
S______GENERIC.DESCRIBE.HAT_COWBOY = "这让我充满了驯服野性的自信！"
--S_______WILLOW.DESCRIBE.HAT_COWBOY = ""
--S_____WOLFGANG.DESCRIBE.HAT_COWBOY = ""
--S________WENDY.DESCRIBE.HAT_COWBOY = ""
S_________WX78.DESCRIBE.HAT_COWBOY = "过时的文化产物"
--S_WICKERBOTTOM.DESCRIBE.HAT_COWBOY = ""
--S_______WOODIE.DESCRIBE.HAT_COWBOY = ""
--S______WAXWELL.DESCRIBE.HAT_COWBOY = ""
S___WATHGRITHR.DESCRIBE.HAT_COWBOY = "这不是女武神该有的装束。"
S_______WEBBER.DESCRIBE.HAT_COWBOY = "我们看不到正前方啦！"
--S_______WINONA.DESCRIBE.HAT_COWBOY = ""

S_NAMES.DUALWRENCH = "扳手-双用型"
S_RECIPE_DESC.DUALWRENCH = "这绝对是错误的用法。"
S______GENERIC.DESCRIBE.DUALWRENCH = "这绝对是错误的扳手用法。"
--S_______WILLOW.DESCRIBE.DUALWRENCH = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DUALWRENCH = "Wolfgang can eat in one bite!"
S________WENDY.DESCRIBE.DUALWRENCH = "我希望不要再扭伤到我的手了。"
--S_________WX78.DESCRIBE.DUALWRENCH = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DUALWRENCH = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DUALWRENCH = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DUALWRENCH = "Hm... I don't know what I was expecting."
S___WATHGRITHR.DESCRIBE.DUALWRENCH = "工匠的武器，锤它丫的！"
S_______WEBBER.DESCRIBE.DUALWRENCH = "希望不要再扭伤到我们的手了。"
S_______WINONA.DESCRIBE.DUALWRENCH = "我最最最棒的扳手！"

S_NAMES.ELECARMET = "莱克阿米特"
S______GENERIC.DESCRIBE.ELECARMET = "本以为那已是终结，结果却才是开始。"
--S_______WILLOW.DESCRIBE.ELECARMET = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.ELECARMET = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.ELECARMET = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.ELECARMET = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.ELECARMET = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.ELECARMET = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.ELECARMET = "Hm... I don't know what I was expecting."
S___WATHGRITHR.DESCRIBE.ELECARMET = "我最伟大的敌人，也称作芬布尔。"
--S_______WEBBER.DESCRIBE.ELECARMET = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.ELECARMET = "Great to cool off after some hard physical labor."
S_______WORTOX.DESCRIBE.ELECARMET = "一个迷失的灵魂。"

S_NAMES.TOURMALINECORE = "电气石"
S______GENERIC.DESCRIBE.TOURMALINECORE = "天啦，我能摸摸看吗？"
--S_______WILLOW.DESCRIBE.TOURMALINECORE = ""
--S_____WOLFGANG.DESCRIBE.TOURMALINECORE = ""
--S________WENDY.DESCRIBE.TOURMALINECORE = ""
S_________WX78.DESCRIBE.TOURMALINECORE = "这可以作为我的能源核心！"
S_WICKERBOTTOM.DESCRIBE.TOURMALINECORE = "它聚集了大量的正电荷。"
-- S_______WOODIE.DESCRIBE.TOURMALINECORE = ""
S______WAXWELL.DESCRIBE.TOURMALINECORE = "青色带来雷电。"
-- S___WATHGRITHR.DESCRIBE.TOURMALINECORE = ""
-- S_______WEBBER.DESCRIBE.TOURMALINECORE = ""
-- S_______WINONA.DESCRIBE.TOURMALINECORE = ""
-- S________WARLY.DESCRIBE.TOURMALINECORE = ""
-- S_______WORTOX.DESCRIBE.TOURMALINECORE = ""
-- S_____WORMWOOD.DESCRIBE.TOURMALINECORE = ""
-- S_________WURT.DESCRIBE.TOURMALINECORE = ""
-- STRINGS.CHARACTERS.WAGSTAFF.DESCRIBE.TOURMALINECORE = "这可以用作我机器人的能源核心！"

S_NAMES.ICIRE_ROCK = "鸳鸯石"
S_RECIPE_DESC.ICIRE_ROCK = "炙热与严寒的交融。"
S______GENERIC.DESCRIBE.ICIRE_ROCK =
{
    FROZEN = "就像雪国列车里一样。",
    COLD = "严冬将至。",
    GENERIC = "一颗珍贵的石头，不稀有，但也不常见。",
    WARM = "离春天还会远吗？",
    HOT = "阳光灿烂的日子。",
}
-- S_______WILLOW.DESCRIBE.ICIRE_ROCK = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.ICIRE_ROCK = "Wolfgang can eat in one bite!"
-- S________WENDY.DESCRIBE.ICIRE_ROCK = "I can't always escape, I have to face everything."
-- S_________WX78.DESCRIBE.ICIRE_ROCK = "FIREWALL, START!"
-- S_WICKERBOTTOM.DESCRIBE.ICIRE_ROCK = "Well, isn't that refreshing?"
-- S_______WOODIE.DESCRIBE.ICIRE_ROCK = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.ICIRE_ROCK = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.ICIRE_ROCK = "Be my mirror, my sword and shield!"
-- S_______WEBBER.DESCRIBE.ICIRE_ROCK = "Yaaay! Popsicle, popsicle!"
-- S_______WINONA.DESCRIBE.ICIRE_ROCK = "Great to cool off after some hard physical labor."

S_NAMES.GUITAR_MIGUEL = "米格尔的吉他"
S_RECIPE_DESC.GUITAR_MIGUEL = "成为传奇吉他手。"
S______GENERIC.DESCRIBE.GUITAR_MIGUEL = "跨越生与死，只为让你记住我！"
--S_______WILLOW.DESCRIBE.GUITAR_MIGUEL = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.GUITAR_MIGUEL = "Wolfgang can eat in one bite!"
S________WENDY.DESCRIBE.GUITAR_MIGUEL = "它的原主人至少被人们所铭记。"
S_________WX78.DESCRIBE.GUITAR_MIGUEL = "用旋律打动别人不是我的组件功能。"
--S_WICKERBOTTOM.DESCRIBE.GUITAR_MIGUEL = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.GUITAR_MIGUEL = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.GUITAR_MIGUEL = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.GUITAR_MIGUEL = "A weapon for workmen, smash!"
S_______WEBBER.DESCRIBE.GUITAR_MIGUEL = "薇克巴顿女士！歌王是坏人吗？"
-- S_______WINONA.DESCRIBE.GUITAR_MIGUEL = "My, my! my best wrench!"
S_________WURT.DESCRIBE.GUITAR_MIGUEL = "薇克巴顿女士！歌王是坏人吗？"

S_NAMES.WEB_HUMP_ITEM = "蛛网标记"
S_RECIPE_DESC.WEB_HUMP_ITEM = "宣誓你们的领地主权！"
S______GENERIC.DESCRIBE.WEB_HUMP_ITEM = "反正，我是肯定不会使用这个的。"
-- S_______WILLOW.DESCRIBE.WEB_HUMP_ITEM = "This is the opposite of burning."
S_____WOLFGANG.DESCRIBE.WEB_HUMP_ITEM = "啊！这样可怕的虫子就不会在外面乱跑了吗？"
--S________WENDY.DESCRIBE.WEB_HUMP_ITEM = "Hello from the other side, Abigail."
S_________WX78.DESCRIBE.WEB_HUMP_ITEM = "项目等级：Thaumiel"
S_WICKERBOTTOM.DESCRIBE.WEB_HUMP_ITEM = "蜘蛛是有领地意识的吗？"
-- S_______WOODIE.DESCRIBE.WEB_HUMP_ITEM = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.WEB_HUMP_ITEM = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.WEB_HUMP_ITEM = "A weapon for workmen, smash!"
S_______WEBBER.DESCRIBE.WEB_HUMP_ITEM = "的确，我们的领地太少了。"
-- S_______WINONA.DESCRIBE.WEB_HUMP_ITEM = "My, my! my best wrench!"

S_NAMES.WEB_HUMP = "蛛网标记"
S______GENERIC.DESCRIBE.WEB_HUMP =
{
    GENERIC = "真的太过分了，臭蜘蛛们！",
    TRYDIGUP = "弄掉它并不容易。",
}
-- S_______WILLOW.DESCRIBE.WEB_HUMP = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.WEB_HUMP = "Wolfgang can eat in one bite!"
-- S________WENDY.DESCRIBE.WEB_HUMP = "Hello from the other side, Abigail."
S_________WX78.DESCRIBE.WEB_HUMP = 
{
    GENERIC = "特殊收容措施。",
    TRYDIGUP = "无法执行迁移程序。",
}
-- S_WICKERBOTTOM.DESCRIBE.WEB_HUMP = "Well, isn't that refreshing?"
-- S_______WOODIE.DESCRIBE.WEB_HUMP = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.WEB_HUMP = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.WEB_HUMP = "A weapon for workmen, smash!"
S_______WEBBER.DESCRIBE.WEB_HUMP =
{
    GENERIC = "这里的居民很喜欢我们！",
    TRYDIGUP = "我们做得到！",
}
-- S_______WINONA.DESCRIBE.WEB_HUMP = "My, my! my best wrench!"

S_NAMES.SADDLE_BAGGAGE = "驮运鞍具"
S_RECIPE_DESC.SADDLE_BAGGAGE = "传统的驮运方式。"
S______GENERIC.DESCRIBE.SADDLE_BAGGAGE = "希望这别是我朋友的最后一根稻草。"
-- S_______WILLOW.DESCRIBE.SADDLE_BAGGAGE = ""
-- S_____WOLFGANG.DESCRIBE.SADDLE_BAGGAGE = ""
-- S________WENDY.DESCRIBE.SADDLE_BAGGAGE = ""
S_________WX78.DESCRIBE.SADDLE_BAGGAGE = "现在那些肉体生物可以给我打更多白工了"
-- S_WICKERBOTTOM.DESCRIBE.SADDLE_BAGGAGE = ""
-- S_______WOODIE.DESCRIBE.SADDLE_BAGGAGE = ""
-- S______WAXWELL.DESCRIBE.SADDLE_BAGGAGE = ""
-- S___WATHGRITHR.DESCRIBE.SADDLE_BAGGAGE = ""
-- S_______WEBBER.DESCRIBE.SADDLE_BAGGAGE = ""
-- S_______WINONA.DESCRIBE.SADDLE_BAGGAGE = ""
-- S________WARLY.DESCRIBE.SADDLE_BAGGAGE = ""
-- S_______WORTOX.DESCRIBE.SADDLE_BAGGAGE = ""
-- S_____WORMWOOD.DESCRIBE.SADDLE_BAGGAGE = ""
-- S_________WURT.DESCRIBE.SADDLE_BAGGAGE = ""

S_NAMES.TRIPLESHOVELAXE = "斧铲-三用型"
S_RECIPE_DESC.TRIPLESHOVELAXE = "成本低廉的多功能工具。"
S______GENERIC.DESCRIBE.TRIPLESHOVELAXE = "天啦，这个工具也太棒了吧。"
-- S_______WILLOW.DESCRIBE.TRIPLESHOVELAXE = ""
-- S_____WOLFGANG.DESCRIBE.TRIPLESHOVELAXE = ""
-- S________WENDY.DESCRIBE.TRIPLESHOVELAXE = ""
S_________WX78.DESCRIBE.TRIPLESHOVELAXE = "就是个组合式工具嘛。"
-- S_WICKERBOTTOM.DESCRIBE.TRIPLESHOVELAXE = ""
S_______WOODIE.DESCRIBE.TRIPLESHOVELAXE = "这东西太厉害了。噢，希望露西没听到。"
S______WAXWELL.DESCRIBE.TRIPLESHOVELAXE = "我怎么就没想到呢。"
S___WATHGRITHR.DESCRIBE.TRIPLESHOVELAXE = "披荆斩棘！"
-- S_______WEBBER.DESCRIBE.TRIPLESHOVELAXE = ""
-- S_______WINONA.DESCRIBE.TRIPLESHOVELAXE = ""
-- S________WARLY.DESCRIBE.TRIPLESHOVELAXE = ""
-- S_______WORTOX.DESCRIBE.TRIPLESHOVELAXE = ""
S_____WORMWOOD.DESCRIBE.TRIPLESHOVELAXE = "呕，自然破坏者的利器。"


S_NAMES.HAT_ALBICANS_MUSHROOM = "素白蘑菇帽"
S_RECIPE_DESC.HAT_ALBICANS_MUSHROOM = "让抗生素粘满你的头。"
S______GENERIC.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "一顶由富含抗生素的菌类做成的帽子。",
    HUNGER = "不知道为啥没力气。",
}
-- S_______WILLOW.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
-- S_____WOLFGANG.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
-- S________WENDY.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
S_________WX78.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "不过是一些生物压迫另一些生物罢了。",
    HUNGER = "燃料耗尽！",
}
S_WICKERBOTTOM.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "对致病菌有很好的抵抗性。",
    HUNGER = "要是有人抗生素过敏怎么办。",
}
-- S_______WOODIE.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
S______WAXWELL.DESCRIBE.HAT_ALBICANS_MUSHROOM = 
{
    GENERIC = "终于有办法解决那些病菌了。",
    HUNGER = "空着肚子是没法好好释放魔法的。",
}
-- S___WATHGRITHR.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
S_______WEBBER.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "脑袋摇摇，疾病逃逃。",
    HUNGER = "我们的肚子好饿。",
}
-- S_______WINONA.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
S________WARLY.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "保证食材健康新鲜。",
    HUNGER = "饿着肚子是放不出有价值的魔法的！",
}
-- S_______WORTOX.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
S_____WORMWOOD.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "朋友们，我们有救啦！",
    HUNGER = "肚子空空的。",
}
S_________WURT.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "也许它能治疗那些被真菌感染的植物。",
    HUNGER = "我需要食物！",
}

S_NAMES.ALBICANS_CAP = "采摘的素白菇"
S______GENERIC.DESCRIBE.ALBICANS_CAP = "第一次见如此上等的山珍。"
-- S_______WILLOW.DESCRIBE.ALBICANS_CAP = ""
-- S_____WOLFGANG.DESCRIBE.ALBICANS_CAP = ""
-- S________WENDY.DESCRIBE.ALBICANS_CAP = ""
-- S_________WX78.DESCRIBE.ALBICANS_CAP = ""
S_WICKERBOTTOM.DESCRIBE.ALBICANS_CAP = "奇怪，它应该长在竹林深处才对。"
-- S_______WOODIE.DESCRIBE.ALBICANS_CAP = ""
-- S______WAXWELL.DESCRIBE.ALBICANS_CAP = ""
-- S___WATHGRITHR.DESCRIBE.ALBICANS_CAP = ""
S_______WEBBER.DESCRIBE.ALBICANS_CAP = "穿了裙子的蘑菇耶！"
-- S_______WINONA.DESCRIBE.ALBICANS_CAP = ""
S_______WORTOX.DESCRIBE.ALBICANS_CAP = "此物只应天上有，人间能得几回闻。"
-- S_____WORMWOOD.DESCRIBE.ALBICANS_CAP = ""
-- S________WARLY.DESCRIBE.ALBICANS_CAP = ""
-- S_________WURT.DESCRIBE.ALBICANS_CAP = ""
-- S_______WALTER.DESCRIBE.ALBICANS_CAP = ""

S_NAMES.SOUL_CONTRACTS = "灵魂契约"
S_RECIPE_DESC.SOUL_CONTRACTS = "变本加厉地束缚灵魂。"
S______GENERIC.DESCRIBE.SOUL_CONTRACTS =
{
    GENERIC = "哪个恶魔会想到这么个邪恶的东西！",
    ONLYONE = "邪恶，也是要有限度的！",
}
-- S_______WILLOW.DESCRIBE.SOUL_CONTRACTS = ""
-- S_____WOLFGANG.DESCRIBE.SOUL_CONTRACTS = ""
S________WENDY.DESCRIBE.SOUL_CONTRACTS =
{
    GENERIC = "嘶吼、啜泣、懊悔，我感受到的这些。",
    ONLYONE = "一旦双手被玷污，就不可挽回了。",
}
S_________WX78.DESCRIBE.SOUL_CONTRACTS =
{
    GENERIC = "这能增强仇视模块。",
    ONLYONE = "超负荷加载仇视模块！",
}
-- S_WICKERBOTTOM.DESCRIBE.SOUL_CONTRACTS = ""
-- S_______WOODIE.DESCRIBE.SOUL_CONTRACTS = ""
S______WAXWELL.DESCRIBE.SOUL_CONTRACTS = 
{
    GENERIC = "不要玩弄你所不理解的力量。",
    ONLYONE = "收手吧。",
}
S___WATHGRITHR.DESCRIBE.SOUL_CONTRACTS = 
{
    GENERIC = "又是洛基的诡计吗？",
    ONLYONE = "不可以！",
}
-- S_______WEBBER.DESCRIBE.SOUL_CONTRACTS = ""
-- S_______WINONA.DESCRIBE.SOUL_CONTRACTS = ""
-- S________WARLY.DESCRIBE.SOUL_CONTRACTS = ""
S_______WORTOX.DESCRIBE.SOUL_CONTRACTS =
{
    GENERIC = "吼啊，我能更好地折磨灵魂啦！",
    ONLYONE = "我可不想迷失自我。",
}
S_____WORMWOOD.DESCRIBE.SOUL_CONTRACTS =
{
    GENERIC = "我胸前的亮晶晶也锁着心。",
    ONLYONE = "不需要。",
}
S_________WURT.DESCRIBE.SOUL_CONTRACTS =
{
    GENERIC = "坏蛋，偷走那么多人的心！",
    ONLYONE = "负面情绪够多了。",
}

--------------------------------------------------------------------------
--[[ desert secret ]]--[[ 大漠隐情 ]]
--------------------------------------------------------------------------

S_NAMES.DESERTDEFENSE = "砂之抵御"
S_RECIPE_DESC.DESERTDEFENSE = "借用大地的力量，保护与反击。"
S______GENERIC.DESCRIBE.DESERTDEFENSE =
{
    GENERIC = "我能感受到其中大地的力量，应该吧。",
    WEAK = "这雨切断了它与大地的联系！",
    INSANE = "我已经无法集中精神了！",
}
--S_______WILLOW.DESCRIBE.DESERTDEFENSE = ""
--S_____WOLFGANG.DESCRIBE.DESERTDEFENSE = ""
S________WENDY.DESCRIBE.DESERTDEFENSE = "我不能一直逃避，我总得去面对一切。"
S_________WX78.DESCRIBE.DESERTDEFENSE = "防火墙，启动！"
S_WICKERBOTTOM.DESCRIBE.DESERTDEFENSE = "它的魔法可以保护我免于受伤。"
--S_______WOODIE.DESCRIBE.DESERTDEFENSE = ""
--S______WAXWELL.DESCRIBE.DESERTDEFENSE = ""
--S_______WEBBER.DESCRIBE.DESERTDEFENSE = ""
S___WATHGRITHR.DESCRIBE.DESERTDEFENSE = "作我明镜，作我利剑与护盾！"
--S_______WINONA.DESCRIBE.DESERTDEFENSE = ""


S_NAMES.SHYERRYTREE = "颤栗树"
S______GENERIC.DESCRIBE.SHYERRYTREE =
{
    BURNING = "它着火了！",
    GENERIC = "只有一两片叶子，这是树吗？",
}
-- S_______WILLOW.DESCRIBE.SHYERRYTREE = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.SHYERRYTREE = "Wolfgang can eat in one bite!"
-- S________WENDY.DESCRIBE.SHYERRYTREE = "Hello from the other side, Abigail."
-- S_________WX78.DESCRIBE.SHYERRYTREE = "NOT MY BUILD FUNCTION TO IMPRESS OTHERS BY MELODY."
S_WICKERBOTTOM.DESCRIBE.SHYERRYTREE =
{
    BURNING = "别担心，火焰不会烧毁地下的那部分。",
    GENERIC = "事实上，长在外面的并不是真正的树干。",
}
S_______WOODIE.DESCRIBE.SHYERRYTREE = 
{
    BURNING = "真是浪费。",
    GENERIC = "我还从未见过这么奇怪的树。",
}
S______WAXWELL.DESCRIBE.SHYERRYTREE = 
{
    BURNING = "可惜。",
    GENERIC = "我以为它们不会长出来了呢。",
}

-- S___WATHGRITHR.DESCRIBE.SHYERRYTREE = "A weapon for workmen, smash!"
-- S_______WEBBER.DESCRIBE.SHYERRYTREE = "Indeed, we have too little territory."
-- S_______WINONA.DESCRIBE.SHYERRYTREE = "My, my! my best wrench!"

S_NAMES.SHYERRYTREE_PLANTED = "栽种的颤栗树"
S______GENERIC.DESCRIBE.SHYERRYTREE_PLANTED =
{
    BURNING = "珍贵的树着火了！",
    GENERIC = "辛苦移植过来的还是只有一两片叶子。",
}
-- S_______WILLOW.DESCRIBE.SHYERRYTREE_PLANTED = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.SHYERRYTREE_PLANTED = "Wolfgang can eat in one bite!"
-- S________WENDY.DESCRIBE.SHYERRYTREE_PLANTED = "Hello from the other side, Abigail."
-- S_________WX78.DESCRIBE.SHYERRYTREE_PLANTED = "NOT MY BUILD FUNCTION TO IMPRESS OTHERS BY MELODY."
-- S_WICKERBOTTOM.DESCRIBE.SHYERRYTREE_PLANTED = "Well, isn't that refreshing?"
-- S_______WOODIE.DESCRIBE.SHYERRYTREE_PLANTED = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.SHYERRYTREE_PLANTED = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.SHYERRYTREE_PLANTED = "A weapon for workmen, smash!"
-- S_______WEBBER.DESCRIBE.SHYERRYTREE_PLANTED = "Indeed, we have too little territory."
-- S_______WINONA.DESCRIBE.SHYERRYTREE_PLANTED = "My, my! my best wrench!"

S_NAMES.SHYERRYFLOWER = "颤栗花"
S______GENERIC.DESCRIBE.SHYERRYFLOWER =
{
    BURNING = "珍贵的花着火了！",
    GENERIC = "看起来它是先结果再开花的。",
}
-- S_______WILLOW.DESCRIBE.SHYERRYFLOWER = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.SHYERRYFLOWER = "Wolfgang can eat in one bite!"
-- S________WENDY.DESCRIBE.SHYERRYFLOWER = "Hello from the other side, Abigail."
-- S_________WX78.DESCRIBE.SHYERRYFLOWER = "NOT MY BUILD FUNCTION TO IMPRESS OTHERS BY MELODY."
S_WICKERBOTTOM.DESCRIBE.SHYERRYFLOWER =
{
    BURNING = "很不幸，这种植物很少结果。",
    GENERIC = "事实上，像花的那部分并不是真的花。",
}
-- S_______WOODIE.DESCRIBE.SHYERRYFLOWER = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.SHYERRYFLOWER = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.SHYERRYFLOWER = "A weapon for workmen, smash!"
-- S_______WEBBER.DESCRIBE.SHYERRYFLOWER = "Indeed, we have too little territory."
-- S_______WINONA.DESCRIBE.SHYERRYFLOWER = "My, my! my best wrench!"

S_NAMES.SHYERRY = "颤栗果"
S______GENERIC.DESCRIBE.SHYERRY = "哇，好大一颗蓝莓！"
-- S_______WILLOW.DESCRIBE.SHYERRY = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.SHYERRY = "Wolfgang can eat in one bite!"
-- S________WENDY.DESCRIBE.SHYERRY = "Hello from the other side, Abigail."
-- S_________WX78.DESCRIBE.SHYERRY = "NOT MY BUILD FUNCTION TO IMPRESS OTHERS BY MELODY."
S_WICKERBOTTOM.DESCRIBE.SHYERRY = "富含营养，对身体很好。"
-- S_______WOODIE.DESCRIBE.SHYERRY = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.SHYERRY = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.SHYERRY = "A weapon for workmen, smash!"
-- S_______WEBBER.DESCRIBE.SHYERRY = "Indeed, we have too little territory."
-- S_______WINONA.DESCRIBE.SHYERRY = "My, my! my best wrench!"

S_NAMES.SHYERRY_COOKED = "烤颤栗果"
S______GENERIC.DESCRIBE.SHYERRY_COOKED = "哇，好蓝的烤橘子！"
-- S_______WILLOW.DESCRIBE.SHYERRY_COOKED = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.SHYERRY_COOKED = "Wolfgang can eat in one bite!"
-- S________WENDY.DESCRIBE.SHYERRY_COOKED = "Hello from the other side, Abigail."
-- S_________WX78.DESCRIBE.SHYERRY_COOKED = "NOT MY BUILD FUNCTION TO IMPRESS OTHERS BY MELODY."
S_WICKERBOTTOM.DESCRIBE.SHYERRY_COOKED = "嗯，营养成分全被分解了。"
-- S_______WOODIE.DESCRIBE.SHYERRY_COOKED = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.SHYERRY_COOKED = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.SHYERRY_COOKED = "A weapon for workmen, smash!"
-- S_______WEBBER.DESCRIBE.SHYERRY_COOKED = "Indeed, we have too little territory."
-- S_______WINONA.DESCRIBE.SHYERRY_COOKED = "My, my! my best wrench!"

S_NAMES.SHYERRYLOG = "宽大的木墩"
S______GENERIC.DESCRIBE.SHYERRYLOG =
{
    BURNING = "即将有一场大火。",
    GENERIC = "很适合当木工的材料。",
}
-- S_______WILLOW.DESCRIBE.SHYERRYLOG = ""
-- S_____WOLFGANG.DESCRIBE.SHYERRYLOG = ""
-- S________WENDY.DESCRIBE.SHYERRYLOG = ""
-- S_________WX78.DESCRIBE.SHYERRYLOG = ""
-- S_WICKERBOTTOM.DESCRIBE.SHYERRYLOG = ""
-- S_______WOODIE.DESCRIBE.SHYERRYLOG = ""
-- S______WAXWELL.DESCRIBE.SHYERRYLOG = ""
-- S___WATHGRITHR.DESCRIBE.SHYERRYLOG = ""
-- S_______WEBBER.DESCRIBE.SHYERRYLOG = ""
-- S_______WINONA.DESCRIBE.SHYERRYLOG = ""

-- S_NAMES.FENCE_SHYERRY = "田园栅栏"
-- S______GENERIC.DESCRIBE.FENCE_SHYERRY = "让人失望，和普通栅栏并没啥区别。"
-- S_______WILLOW.DESCRIBE.FENCE_SHYERRY = ""
-- S_____WOLFGANG.DESCRIBE.FENCE_SHYERRY = ""
-- S________WENDY.DESCRIBE.FENCE_SHYERRY = ""
-- S_________WX78.DESCRIBE.FENCE_SHYERRY = ""
-- S_WICKERBOTTOM.DESCRIBE.FENCE_SHYERRY = ""
-- S_______WOODIE.DESCRIBE.FENCE_SHYERRY = ""
-- S______WAXWELL.DESCRIBE.FENCE_SHYERRY = ""
-- S___WATHGRITHR.DESCRIBE.FENCE_SHYERRY = ""
-- S_______WEBBER.DESCRIBE.FENCE_SHYERRY = ""
-- S_______WINONA.DESCRIBE.FENCE_SHYERRY = ""
-- S_______WORTOX.DESCRIBE.FENCE_SHYERRY = ""
-- S_____WORMWOOD.DESCRIBE.FENCE_SHYERRY = ""
-- S________WARLY.DESCRIBE.FENCE_SHYERRY = ""
-- S_________WURT.DESCRIBE.FENCE_SHYERRY = ""

-- S_NAMES.FENCE_SHYERRY_ITEM = "田园栅栏"
-- S_RECIPE_DESC.FENCE_SHYERRY_ITEM = "应该用来围住农田。"
-- S______GENERIC.DESCRIBE.FENCE_SHYERRY_ITEM = "用它围住的地方就会变成农田吗？"
-- S_______WILLOW.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- S_____WOLFGANG.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- S________WENDY.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- S_________WX78.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- S_WICKERBOTTOM.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- S_______WOODIE.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- S______WAXWELL.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- S___WATHGRITHR.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- S_______WEBBER.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- S_______WINONA.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- S_______WORTOX.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- S_____WORMWOOD.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- S________WARLY.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- S_________WURT.DESCRIBE.FENCE_SHYERRY_ITEM = ""

S_NAMES.GUITAR_WHITEWOOD = "白木吉他"
S_RECIPE_DESC.GUITAR_WHITEWOOD = "有一把吉他，在等待被弹拨。"
S______GENERIC.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "不管外面世界如何变化，这里依然歌舞升平。",
    FAILED = "慢了一拍。",
    HUNGRY = "没力气弹了。",
}
-- S_______WILLOW.DESCRIBE.GUITAR_WHITEWOOD = ""
-- S_____WOLFGANG.DESCRIBE.GUITAR_WHITEWOOD = ""
S________WENDY.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "阿比盖尔尝试过，可惜她没那个天赋，哈哈。",
    FAILED = "这讲究节拍一致。",
    HUNGRY = "饥饿感会影响我的旋律。",
}
S_________WX78.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "那些低级生物很喜欢它。",
    FAILED = "无语，我为何是配合的那个。",
    HUNGRY = "电量不足，功能受限。",
}
S_WICKERBOTTOM.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "这吉他只有四根弦，一个人弹是不够用的。",
    FAILED = "配合不够完美。",
    HUNGRY = "现在没心情弹这个。",
}
-- S_______WOODIE.DESCRIBE.GUITAR_WHITEWOOD = ""
S______WAXWELL.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "还是小提琴更优雅。",
    FAILED = "哼，我现在成助手了？",
    HUNGRY = "现在应该我用餐，其他人弹给我听才对。",
}
-- S___WATHGRITHR.DESCRIBE.GUITAR_WHITEWOOD = ""
-- S_______WEBBER.DESCRIBE.GUITAR_WHITEWOOD = ""
S_______WINONA.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "少了点音色。",
    FAILED = "抱歉没跟上，能再试试嘛？",
    HUNGRY = "不吃饱哪有力气干活啊！",
}
S_______WORTOX.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "嘻嘻，人类让我如此感兴趣是有原因的。",
    FAILED = "哈哈，这太有趣了。",
    HUNGRY = "现在有比这更重要的恶作...哦不...事要做。",
}
-- S_____WORMWOOD.DESCRIBE.GUITAR_WHITEWOOD = ""
-- S________WARLY.DESCRIBE.GUITAR_WHITEWOOD = ""
-- S_________WURT.DESCRIBE.GUITAR_WHITEWOOD = ""
S_______WALTER.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "惊讶吧，这个我三岁就会弹了。",
    FAILED = "不要放弃，会成功的。",
    HUNGRY = "人是铁饭是钢，你懂的。",
}

-- S_NAMES.TOY_SPONGEBOB = "玩具小海绵"
-- S______GENERIC.DESCRIBE.TOY_SPONGEBOB = "它在等着谁呢。"
-- S_______WILLOW.DESCRIBE.TOY_SPONGEBOB = ""
-- S_____WOLFGANG.DESCRIBE.TOY_SPONGEBOB = ""
-- S________WENDY.DESCRIBE.TOY_SPONGEBOB = "花落水流，春去无踪。"
-- S_________WX78.DESCRIBE.TOY_SPONGEBOB = ""
-- S_WICKERBOTTOM.DESCRIBE.TOY_SPONGEBOB = "它说一腔热情无处宣泄。"
-- S_______WOODIE.DESCRIBE.TOY_SPONGEBOB = "它也憧憬未来，那如胶似漆的日子。"
-- S______WAXWELL.DESCRIBE.TOY_SPONGEBOB = "一生漫长，习惯与孤独为伴。"
-- S___WATHGRITHR.DESCRIBE.TOY_SPONGEBOB = ""
-- S_______WEBBER.DESCRIBE.TOY_SPONGEBOB = "爱它。"
-- S_______WINONA.DESCRIBE.TOY_SPONGEBOB = ""
-- S_______WORTOX.DESCRIBE.TOY_SPONGEBOB = "一城烟雨一楼台，一花只为一树开。"
-- S_____WORMWOOD.DESCRIBE.TOY_SPONGEBOB = ""
-- S________WARLY.DESCRIBE.TOY_SPONGEBOB = ""
-- S_________WURT.DESCRIBE.TOY_SPONGEBOB = ""
-- S_______WALTER.DESCRIBE.TOY_SPONGEBOB = ""

-- S_NAMES.TOY_PATRICKSTAR = "玩具小海星"
-- S______GENERIC.DESCRIBE.TOY_PATRICKSTAR = "它在向着目标前行呢。"
-- S_______WILLOW.DESCRIBE.TOY_PATRICKSTAR = ""
-- S_____WOLFGANG.DESCRIBE.TOY_PATRICKSTAR = ""
-- S________WENDY.DESCRIBE.TOY_PATRICKSTAR = "所谓伊人，在水一方。"
-- S_________WX78.DESCRIBE.TOY_PATRICKSTAR = ""
-- S_WICKERBOTTOM.DESCRIBE.TOY_PATRICKSTAR = "它说时间总会冲淡一切。"
-- S_______WOODIE.DESCRIBE.TOY_PATRICKSTAR = "它也充满矛盾，时而不知所措。"
-- S______WAXWELL.DESCRIBE.TOY_PATRICKSTAR = "一生苦短，辛苦而充实。"
-- S___WATHGRITHR.DESCRIBE.TOY_PATRICKSTAR = ""
-- S_______WEBBER.DESCRIBE.TOY_PATRICKSTAR = "恋它。"
-- S_______WINONA.DESCRIBE.TOY_PATRICKSTAR = ""
-- S_______WORTOX.DESCRIBE.TOY_PATRICKSTAR = "爬上树梢的月亮，是否还在它心上。"
-- S_____WORMWOOD.DESCRIBE.TOY_PATRICKSTAR = ""
-- S________WARLY.DESCRIBE.TOY_PATRICKSTAR = ""
-- S_________WURT.DESCRIBE.TOY_PATRICKSTAR = ""
-- S_______WALTER.DESCRIBE.TOY_PATRICKSTAR = ""

S_NAMES.PINKSTAFF = "幻象法杖"
S_RECIPE_DESC.PINKSTAFF = "幻想既是永恒的美丽。"
S______GENERIC.DESCRIBE.PINKSTAFF = "不敢相信，我在想象一个真的幻想。"
-- S_______WILLOW.DESCRIBE.PINKSTAFF = ""
-- S_____WOLFGANG.DESCRIBE.PINKSTAFF = ""
-- S________WENDY.DESCRIBE.PINKSTAFF = ""
-- S_________WX78.DESCRIBE.PINKSTAFF = ""
-- S_WICKERBOTTOM.DESCRIBE.PINKSTAFF = ""
-- S_______WOODIE.DESCRIBE.PINKSTAFF = ""
-- S______WAXWELL.DESCRIBE.PINKSTAFF = ""
-- S___WATHGRITHR.DESCRIBE.PINKSTAFF = ""
-- S_______WEBBER.DESCRIBE.PINKSTAFF = ""
-- S_______WINONA.DESCRIBE.PINKSTAFF = ""
-- S_______WORTOX.DESCRIBE.PINKSTAFF = ""
-- S_____WORMWOOD.DESCRIBE.PINKSTAFF = ""
-- S________WARLY.DESCRIBE.PINKSTAFF = ""
-- S_________WURT.DESCRIBE.PINKSTAFF = ""
-- S_______WALTER.DESCRIBE.PINKSTAFF = ""

S_NAMES.THEEMPERORSCROWN = "皇帝的王冠"
S_RECIPE_DESC.THEEMPERORSCROWN = "智者的象征。"
S______GENERIC.DESCRIBE.THEEMPERORSCROWN = "聪明的人才不会信这个。"
-- S_______WILLOW.DESCRIBE.THEEMPERORSCROWN = ""
-- S_____WOLFGANG.DESCRIBE.THEEMPERORSCROWN = ""
-- S________WENDY.DESCRIBE.THEEMPERORSCROWN = ""
-- S_________WX78.DESCRIBE.THEEMPERORSCROWN = ""
-- S_WICKERBOTTOM.DESCRIBE.THEEMPERORSCROWN = ""
-- S_______WOODIE.DESCRIBE.THEEMPERORSCROWN = ""
-- S______WAXWELL.DESCRIBE.THEEMPERORSCROWN = ""
-- S___WATHGRITHR.DESCRIBE.THEEMPERORSCROWN = ""
-- S_______WEBBER.DESCRIBE.THEEMPERORSCROWN = ""
-- S_______WINONA.DESCRIBE.THEEMPERORSCROWN = ""
-- S_______WORTOX.DESCRIBE.THEEMPERORSCROWN = ""
-- S_____WORMWOOD.DESCRIBE.THEEMPERORSCROWN = ""
-- S________WARLY.DESCRIBE.THEEMPERORSCROWN = ""
-- S_________WURT.DESCRIBE.THEEMPERORSCROWN = ""
-- S_______WALTER.DESCRIBE.THEEMPERORSCROWN = ""

S_NAMES.THEEMPERORSMANTLE = "皇帝的披风"
S_RECIPE_DESC.THEEMPERORSMANTLE = "英勇的象征。"
S______GENERIC.DESCRIBE.THEEMPERORSMANTLE = "无畏的人才不会信这个。"
-- S_______WILLOW.DESCRIBE.THEEMPERORSMANTLE = ""
-- S_____WOLFGANG.DESCRIBE.THEEMPERORSMANTLE = ""
-- S________WENDY.DESCRIBE.THEEMPERORSMANTLE = ""
-- S_________WX78.DESCRIBE.THEEMPERORSMANTLE = ""
-- S_WICKERBOTTOM.DESCRIBE.THEEMPERORSMANTLE = ""
-- S_______WOODIE.DESCRIBE.THEEMPERORSMANTLE = ""
-- S______WAXWELL.DESCRIBE.THEEMPERORSMANTLE = ""
-- S___WATHGRITHR.DESCRIBE.THEEMPERORSMANTLE = ""
-- S_______WEBBER.DESCRIBE.THEEMPERORSMANTLE = ""
-- S_______WINONA.DESCRIBE.THEEMPERORSMANTLE = ""
-- S_______WORTOX.DESCRIBE.THEEMPERORSMANTLE = ""
-- S_____WORMWOOD.DESCRIBE.THEEMPERORSMANTLE = ""
-- S________WARLY.DESCRIBE.THEEMPERORSMANTLE = ""
-- S_________WURT.DESCRIBE.THEEMPERORSMANTLE = ""
-- S_______WALTER.DESCRIBE.THEEMPERORSMANTLE = ""

S_NAMES.THEEMPERORSSCEPTER = "皇帝的权杖"
S_RECIPE_DESC.THEEMPERORSSCEPTER = "权贵的象征。"
S______GENERIC.DESCRIBE.THEEMPERORSSCEPTER = "质善的人才不会信这个。"
-- S_______WILLOW.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S_____WOLFGANG.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S________WENDY.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S_________WX78.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S_WICKERBOTTOM.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S_______WOODIE.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S______WAXWELL.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S___WATHGRITHR.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S_______WEBBER.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S_______WINONA.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S_______WORTOX.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S_____WORMWOOD.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S________WARLY.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S_________WURT.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S_______WALTER.DESCRIBE.THEEMPERORSSCEPTER = ""

S_NAMES.THEEMPERORSPENDANT = "皇帝的吊坠"
S_RECIPE_DESC.THEEMPERORSPENDANT = "毅力的象征。"
S______GENERIC.DESCRIBE.THEEMPERORSPENDANT = "坚定的人才不会信这个。"
-- S_______WILLOW.DESCRIBE.THEEMPERORSPENDANT = ""
-- S_____WOLFGANG.DESCRIBE.THEEMPERORSPENDANT = ""
-- S________WENDY.DESCRIBE.THEEMPERORSPENDANT = ""
-- S_________WX78.DESCRIBE.THEEMPERORSPENDANT = ""
-- S_WICKERBOTTOM.DESCRIBE.THEEMPERORSPENDANT = ""
-- S_______WOODIE.DESCRIBE.THEEMPERORSPENDANT = ""
-- S______WAXWELL.DESCRIBE.THEEMPERORSPENDANT = ""
-- S___WATHGRITHR.DESCRIBE.THEEMPERORSPENDANT = ""
-- S_______WEBBER.DESCRIBE.THEEMPERORSPENDANT = ""
-- S_______WINONA.DESCRIBE.THEEMPERORSPENDANT = ""
-- S_______WORTOX.DESCRIBE.THEEMPERORSPENDANT = ""
-- S_____WORMWOOD.DESCRIBE.THEEMPERORSPENDANT = ""
-- S________WARLY.DESCRIBE.THEEMPERORSPENDANT = ""
-- S_________WURT.DESCRIBE.THEEMPERORSPENDANT = ""
-- S_______WALTER.DESCRIBE.THEEMPERORSPENDANT = ""

--------------------------------------------------------------------------
--[[ other ]]--[[ 其他 ]]
--------------------------------------------------------------------------

S_NAMES.BACKCUB = "靠背熊"
S______GENERIC.DESCRIBE.BACKCUB = "嘿，我想它喜欢趴在我的背上。"
S_______WILLOW.DESCRIBE.BACKCUB = "哇哦，像我的伯尼一样可爱呢。"
--S_____WOLFGANG.DESCRIBE.BACKCUB = ""
S________WENDY.DESCRIBE.BACKCUB = "小时候可爱至极，长大后截然相反。"
S_________WX78.DESCRIBE.BACKCUB = "普通的幼年肉体生物，我根本就无...无法拒绝"
--S_WICKERBOTTOM.DESCRIBE.BACKCUB = ""
--S_______WOODIE.DESCRIBE.BACKCUB = ""
S______WAXWELL.DESCRIBE.BACKCUB = "嗯...我觉得斩草除根比较好。"
S___WATHGRITHR.DESCRIBE.BACKCUB = "一位不适合长期合作的盟友。"
S_______WEBBER.DESCRIBE.BACKCUB = "我们不想长大啊，你呢？"
-- S_______WINONA.DESCRIBE.BACKCUB = ""
-- S________WARLY.DESCRIBE.BACKCUB = ""
-- S_______WORTOX.DESCRIBE.BACKCUB = ""
-- S_____WORMWOOD.DESCRIBE.BACKCUB = ""
-- S_________WURT.DESCRIBE.BACKCUB = ""

STRINGS.ACTIONS_LEGION = {
    PLAYGUITAR = "弹", --弹琴动作的名字
    GIVE_RIGHTCLICK = "给", --右键喂牛动作的名字
    EAT_CONTRACTS = "摄食", --从契约书食用灵魂的名字
    PULLOUTSWORD = "出鞘", --拔剑出鞘动作的名字
    USE_UPGRADEKIT = "组装升级", --升级套件的升级动作的名字
}
STRINGS.ACTIONS.GIVE.SCABBARD = "入鞘"  --青枝绿叶放入武器的名字

if CONFIGS_LEGION.ENABLEDMODS.CraftPot then
    STRINGS.NAMES_LEGION = {
        GEL = "黏液度",
        PETALS_LEGION = "花度",
        FALLFULLMOON = "秋季月圆天专属",
        WINTERSFEAST = "冬季盛宴专属",
        HALLOWEDNIGHTS = "疯狂万圣专属",
        NEWMOON = "新月天专属",
    }

    --帮craft pot翻译下吧
    S_NAMES.FROZEN = "冰度"
    S_NAMES.VEGGIE = "菜度"
    S_NAMES.SWEETENER = "甜度"
    -- S_NAMES.MEAT = "肉度" --和大肉重名了，不能这样改
    -- S_NAMES.FISH = "鱼度" --和鱼重名了，不能这样改
    S_NAMES.MONSTER = "怪物度"
    S_NAMES.FRUIT = "果度"
    S_NAMES.EGG = "蛋度"
    S_NAMES.INEDIBLE = "非食"
    S_NAMES.MAGIC = "魔法度"
    S_NAMES.DECORATION = "装饰度"
    S_NAMES.SEED = "种子度"
    S_NAMES.DAIRY = "乳度"
    S_NAMES.FAT = "脂度"
end
