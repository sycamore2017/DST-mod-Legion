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
local S________WANDA = STRINGS.CHARACTERS.WANDA        --旺达的台词

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
S______WAXWELL.DESCRIBE.SACHET = "优雅男士的必需品。" --哈哈
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
S______GENERIC.DESCRIBE.DISH_MEDICINALLIQUOR = {
    GENERIC = "喝完也许能打出醉拳呢。",
    DRUNK = "我才没醉！",
}
S_______WILLOW.DESCRIBE.DISH_MEDICINALLIQUOR = {
    GENERIC = "能给我的力量加把火。",
    DRUNK = "就这？",
}
S_____WOLFGANG.DESCRIBE.DISH_MEDICINALLIQUOR = {
    GENERIC = "沃尔夫冈可喜欢喝酒了。",
    DRUNK = "沃尔夫冈酒量好得不行。",
}
S________WENDY.DESCRIBE.DISH_MEDICINALLIQUOR = {
    GENERIC = "我不想喝这个。",
    DRUNK = "我就不该喝这个。",
}
S_________WX78.DESCRIBE.DISH_MEDICINALLIQUOR = {
    GENERIC = "可以模拟宿醉状态",
    DRUNK = "状态模拟结束",
}
--S_WICKERBOTTOM.DESCRIBE.DISH_MEDICINALLIQUOR =
S_______WOODIE.DESCRIBE.DISH_MEDICINALLIQUOR = {
    GENERIC = "三碗不过岗。",
    DRUNK = "我很清醒，不会去打老虎的。",
}
--S______WAXWELL.DESCRIBE.DISH_MEDICINALLIQUOR =
S___WATHGRITHR.DESCRIBE.DISH_MEDICINALLIQUOR = {
    GENERIC = "喝下决战酒！战死方休！",
    DRUNK = "像水一样，没啥感觉。",
}
S_______WEBBER.DESCRIBE.DISH_MEDICINALLIQUOR = {
    GENERIC = "以前妈妈警告过我不要喝酒。",
    DRUNK = "我们好困呀...",
}
-- S_______WINONA.DESCRIBE.DISH_MEDICINALLIQUOR =
-- S_______WORTOX.DESCRIBE.DISH_MEDICINALLIQUOR =
-- S_____WORMWOOD.DESCRIBE.DISH_MEDICINALLIQUOR =
-- S________WARLY.DESCRIBE.DISH_MEDICINALLIQUOR =
-- S_________WURT.DESCRIBE.DISH_MEDICINALLIQUOR =
-- S_______WALTER.DESCRIBE.DISH_MEDICINALLIQUOR =
-- S________WANDA.DESCRIBE.DISH_MEDICINALLIQUOR =

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
S________WENDY.DESCRIBE.DISH_RICEDUMPLING = "长太息以掩涕兮，哀民生之多艰。" --牛逼
--S_________WX78.DESCRIBE.DISH_RICEDUMPLING = "STICK ADDON INSTALLED"
S_WICKERBOTTOM.DESCRIBE.DISH_RICEDUMPLING = "也许我应该把这个丢进河里献给屈原。"
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

S_NAMES.DISH_SOSWEETJARKFRUIT = "甜到裂开的松萝蜜"
S______GENERIC.DESCRIBE.DISH_SOSWEETJARKFRUIT = "这不是糖果超甜，这是糖果齁甜。"
S_______WILLOW.DESCRIBE.DISH_SOSWEETJARKFRUIT = "这甜得掉牙了，大厨。"
-- S_____WOLFGANG.DESCRIBE.DISH_SOSWEETJARKFRUIT = ""
S________WENDY.DESCRIBE.DISH_SOSWEETJARKFRUIT = "刚好有两份，能分阿比盖尔一份。"
S_________WX78.DESCRIBE.DISH_SOSWEETJARKFRUIT = "可悲的生物靠它积累脂肪。"
S_WICKERBOTTOM.DESCRIBE.DISH_SOSWEETJARKFRUIT = "老年人不该吃这么不健康的食物。"
S_______WOODIE.DESCRIBE.DISH_SOSWEETJARKFRUIT = "很多人问我糖水松萝到底甜不甜，额，甜！"
S______WAXWELL.DESCRIBE.DISH_SOSWEETJARKFRUIT = "我一把年纪就别吃了。"
S___WATHGRITHR.DESCRIBE.DISH_SOSWEETJARKFRUIT = "看我给你们表演吃一个，松萝，...，呕。"
S_______WEBBER.DESCRIBE.DISH_SOSWEETJARKFRUIT = "欧耶，我的最最爱！" --只有韦伯本人格爱吃糖，而且蜘蛛不吃素，所以没说我们
S_______WINONA.DESCRIBE.DISH_SOSWEETJARKFRUIT = "就没有人注意到它瓶子上有个裂口吗？"
S_______WORTOX.DESCRIBE.DISH_SOSWEETJARKFRUIT = "爱情是糖，甜到忧伤。"
S_____WORMWOOD.DESCRIBE.DISH_SOSWEETJARKFRUIT = "裂开！"
S________WARLY.DESCRIBE.DISH_SOSWEETJARKFRUIT = "我与甜蜜有个约会。"
-- S_________WURT.DESCRIBE.DISH_SOSWEETJARKFRUIT = ""
S_______WALTER.DESCRIBE.DISH_SOSWEETJARKFRUIT = "这不是一道完美的料理，它裂开了。"

S_NAMES.DISH_FRIEDFISHWITHPUREE = "果泥香煎鱼"
STRINGS.UI.COOKBOOK.DISH_FRIEDFISHWITHPUREE = "让你腹得流油"
S______GENERIC.DESCRIBE.DISH_FRIEDFISHWITHPUREE = "鱼肉外酥里嫩，果泥甜而不腻，赞！"
S_______WILLOW.DESCRIBE.DISH_FRIEDFISHWITHPUREE = "火焰把它烤得很好看。"
S_____WOLFGANG.DESCRIBE.DISH_FRIEDFISHWITHPUREE = "好吃就对了。"
-- S________WENDY.DESCRIBE.DISH_FRIEDFISHWITHPUREE = ""
-- S_________WX78.DESCRIBE.DISH_FRIEDFISHWITHPUREE = ""
S_WICKERBOTTOM.DESCRIBE.DISH_FRIEDFISHWITHPUREE = "说实话，这鱼肉看起来有点可疑。"
S_______WOODIE.DESCRIBE.DISH_FRIEDFISHWITHPUREE = "快点吃完，还要继续干活呢。"
-- S______WAXWELL.DESCRIBE.DISH_FRIEDFISHWITHPUREE = ""
S___WATHGRITHR.DESCRIBE.DISH_FRIEDFISHWITHPUREE = "我可以勉为其难试一试。"
-- S_______WEBBER.DESCRIBE.DISH_FRIEDFISHWITHPUREE = ""
-- S_______WINONA.DESCRIBE.DISH_FRIEDFISHWITHPUREE = ""
S_______WORTOX.DESCRIBE.DISH_FRIEDFISHWITHPUREE = "这把戏，哦不对，这道菜太有趣了。"
-- S_____WORMWOOD.DESCRIBE.DISH_FRIEDFISHWITHPUREE = ""
S________WARLY.DESCRIBE.DISH_FRIEDFISHWITHPUREE = "凭我多年烹饪经验来看，吃不得。"
S_________WURT.DESCRIBE.DISH_FRIEDFISHWITHPUREE = "它将会惩罚那些吃鱼肉的人！"
-- S_______WALTER.DESCRIBE.DISH_FRIEDFISHWITHPUREE = ""
S________WANDA.DESCRIBE.DISH_FRIEDFISHWITHPUREE = "哈哈，不止你的时间在流逝。"

-----

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
-- S_______WORTOX.ANNOUNCE_ATTACH_BUFF_BATDISGUISE =
-- S_____WORMWOOD.ANNOUNCE_ATTACH_BUFF_BATDISGUISE =
-- S________WARLY.ANNOUNCE_ATTACH_BUFF_BATDISGUISE =
-- S_________WURT.ANNOUNCE_ATTACH_BUFF_BATDISGUISE =
-- S_______WALTER.ANNOUNCE_ATTACH_BUFF_BATDISGUISE =
-- S________WANDA.ANNOUNCE_ATTACH_BUFF_BATDISGUISE =
--
S______GENERIC.ANNOUNCE_DETACH_BUFF_BATDISGUISE = "好吧，其实我既不是蝙蝠，也没有钱。"
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
-- S_______WORTOX.ANNOUNCE_DETACH_BUFF_BATDISGUISE =
-- S_____WORMWOOD.ANNOUNCE_DETACH_BUFF_BATDISGUISE =
-- S________WARLY.ANNOUNCE_DETACH_BUFF_BATDISGUISE =
-- S_________WURT.ANNOUNCE_DETACH_BUFF_BATDISGUISE =
-- S_______WALTER.ANNOUNCE_DETACH_BUFF_BATDISGUISE =
-- S________WANDA.ANNOUNCE_DETACH_BUFF_BATDISGUISE =

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
-- S_____WORMWOOD.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE =
-- S________WARLY.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE =
-- S_________WURT.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE =
-- S_______WALTER.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE =
-- S________WANDA.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE =
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
-- S_____WORMWOOD.ANNOUNCE_DETACH_BUFF_BESTAPPETITE =
-- S________WARLY.ANNOUNCE_DETACH_BUFF_BESTAPPETITE =
-- S_________WURT.ANNOUNCE_DETACH_BUFF_BESTAPPETITE =
-- S_______WALTER.ANNOUNCE_DETACH_BUFF_BESTAPPETITE =
-- S________WANDA.ANNOUNCE_DETACH_BUFF_BESTAPPETITE =

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
-- S_______WORTOX.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER =
-- S_____WORMWOOD.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER =
-- S________WARLY.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER =
-- S_________WURT.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER =
-- S_______WALTER.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER =
-- S________WANDA.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER =
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
-- S_______WORTOX.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER =
-- S_____WORMWOOD.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER =
-- S________WARLY.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER =
-- S_________WURT.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER =
-- S_______WALTER.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER =
-- S________WANDA.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER =

--力量增幅buff
-- S______GENERIC.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = "" --属于药酒的buff，但是药酒已经会让玩家说话了，所以这里不再重复说
--
S______GENERIC.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = "力量增强效果消失了。"
S_______WILLOW.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = "肌肉的燃烧已经结束。"
S_____WOLFGANG.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = "沃尔夫冈感觉到了蛮力的消失。"
-- S________WENDY.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
S_________WX78.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = "力量组件超频运作结束。"
S_WICKERBOTTOM.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = "靠捷径得来的力量终究不持久。"
-- S_______WOODIE.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- S______WAXWELL.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
S___WATHGRITHR.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = "这份力量还是散去了。"
S_______WEBBER.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = "哎呀，人家的小手又轻飘飘的了。"
-- S_______WINONA.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
S_______WORTOX.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = "如果能给我的强大加个期限，我希望是一万年。"
-- S_____WORMWOOD.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
S________WARLY.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = "额外的力量已被我消化完全。"
-- S_________WURT.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- S_______WALTER.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
S________WANDA.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = "我该回去重新获取一下力量了。"

--腹得流油buff
S______GENERIC.ANNOUNCE_ATTACH_BUFF_OILFLOW = "好像也没事发生。"
-- S_______WILLOW.ANNOUNCE_ATTACH_BUFF_OILFLOW = ""
S_____WOLFGANG.ANNOUNCE_ATTACH_BUFF_OILFLOW = "沃尔夫冈想去趟洗手间。"
-- S________WENDY.ANNOUNCE_ATTACH_BUFF_OILFLOW = ""
S_________WX78.ANNOUNCE_ATTACH_BUFF_OILFLOW = "燃料系统遭到未知泄露！"
S_WICKERBOTTOM.ANNOUNCE_ATTACH_BUFF_OILFLOW = "我想我会需要成人纸尿布。"
-- S_______WOODIE.ANNOUNCE_ATTACH_BUFF_OILFLOW = ""
S______WAXWELL.ANNOUNCE_ATTACH_BUFF_OILFLOW = "我肚子有不好的预感。"
-- S___WATHGRITHR.ANNOUNCE_ATTACH_BUFF_OILFLOW = ""
S_______WEBBER.ANNOUNCE_ATTACH_BUFF_OILFLOW = "肚子要哭了，但我们不能哭。"
-- S_______WINONA.ANNOUNCE_ATTACH_BUFF_OILFLOW = ""
S_______WORTOX.ANNOUNCE_ATTACH_BUFF_OILFLOW = "一场自我恶作剧即将上演。"
S_____WORMWOOD.ANNOUNCE_ATTACH_BUFF_OILFLOW = "奥利给！"
S________WARLY.ANNOUNCE_ATTACH_BUFF_OILFLOW = "好奇心就这么重吗？"
-- S_________WURT.ANNOUNCE_ATTACH_BUFF_OILFLOW = ""
S_______WALTER.ANNOUNCE_ATTACH_BUFF_OILFLOW = "沃尔特要敢于尝试。"
S________WANDA.ANNOUNCE_ATTACH_BUFF_OILFLOW = "没有回头路了。"
--
S______GENERIC.ANNOUNCE_DETACH_BUFF_OILFLOW = "噢，终于，现在我只想找个洞钻进去。"
S_______WILLOW.ANNOUNCE_DETACH_BUFF_OILFLOW = "我现在谁也不想理，别和我说话！"
S_____WOLFGANG.ANNOUNCE_DETACH_BUFF_OILFLOW = "沃尔夫冈上完厕所了。"
S________WENDY.ANNOUNCE_DETACH_BUFF_OILFLOW = "你觉得这是会发生在小仙女身上的事吗。"
S_________WX78.ANNOUNCE_DETACH_BUFF_OILFLOW = "燃料系统修复完毕。"
S_WICKERBOTTOM.ANNOUNCE_DETACH_BUFF_OILFLOW = "还好没人看见，没什么丢脸的。"
S_______WOODIE.ANNOUNCE_DETACH_BUFF_OILFLOW = "该去田里解决的，不能浪费啊。"
S______WAXWELL.ANNOUNCE_DETACH_BUFF_OILFLOW = "我脸面何在？！"
S___WATHGRITHR.ANNOUNCE_DETACH_BUFF_OILFLOW = "这和战士的荣耀无关。"
S_______WEBBER.ANNOUNCE_DETACH_BUFF_OILFLOW = "啊，这太糟了，会被妈妈骂的。"
S_______WINONA.ANNOUNCE_DETACH_BUFF_OILFLOW = "结束了，一堆破事等着收拾。"
S_______WORTOX.ANNOUNCE_DETACH_BUFF_OILFLOW = "真是绝了，感觉我的灵魂都快被拉出来了。"
S_____WORMWOOD.ANNOUNCE_DETACH_BUFF_OILFLOW = "真是一段奇妙的经历。"
S________WARLY.ANNOUNCE_DETACH_BUFF_OILFLOW = "好奇害死猫。"
S_________WURT.ANNOUNCE_DETACH_BUFF_OILFLOW = "好好笑，我以前养的牛也这样过。"
S_______WALTER.ANNOUNCE_DETACH_BUFF_OILFLOW = "这将是我一生的污点。"
S________WANDA.ANNOUNCE_DETACH_BUFF_OILFLOW = "我后悔了，真的。"
--
S______GENERIC.BUFF_OILFLOW = {
    "我滴乖乖...", "...", "... ...", "……", "这下要社死了。", "可不能让人看见。", "噢不！",
    "啥时候停啊？", "噩梦何时醒来？", "疯球了...", "快停下！", "不要啊...", "洗手间在哪里？！",
    "此刻我只想离开地球。", "不...", "停停停！", "这...", "快虚脱了。", "不！", "...！", "唉...",
    "真是不好意思。", "抱歉...", "抱歉！",
}
-- S_______WILLOW.BUFF_OILFLOW = ""
-- S_____WOLFGANG.BUFF_OILFLOW = ""
-- S________WENDY.BUFF_OILFLOW = ""
-- S_________WX78.BUFF_OILFLOW = ""
S_WICKERBOTTOM.BUFF_OILFLOW = {
    "我就知道。", "那个料理有问题...", "这里可没有洗手间。", "不！", "...！", "...", "... ...", "……",
    "不...", "这...", "别看见我，别看见我...", "吃一堑长一智。", "身体吃不消了。", "此刻没有优雅可言。",
    "我还没老到这个程度吧。", "人有三急...", "快想想有什么药可以治治。", "我想我知道原因了...",
    "冷静！这位女士...", "没什么大不了的。", "让你见笑了。", "老了还得受这般折腾。",
}
-- S_______WOODIE.BUFF_OILFLOW = ""
S______WAXWELL.BUFF_OILFLOW = {
    "我就知道。", "那道菜有问题...", "这里没有洗手间。", "不！", "...！", "...", "... ...", "……",
    "不...", "这...", "别看见我，别看见我...", "吃一堑长一智。", "身体吃不消了。", "此刻没有体面可言。",
    "我还没老到这个程度吧。", "人有三急...", "快想想有什么办法。", "我想我知道原因了...",
    "冷静！", "没什么大不了的。", "让你见笑了。", "太不体面了！", "老了还得受这般折腾。",
}
-- S___WATHGRITHR.BUFF_OILFLOW = ""
-- S_______WEBBER.BUFF_OILFLOW = ""
-- S_______WINONA.BUFF_OILFLOW = ""
S_______WORTOX.BUFF_OILFLOW = {
    "你好啊，小朋友。", "见到你很高兴...", "噢，啥时候结束啊！", "不！", "...！", "...", "... ...", "……",
    "不...", "这...", "你好...", "给我整无语了。", "唉...", "唉。", "真是低俗的恶作剧。", "好好笑！",
    "一点都不好笑。", "哈哈哈哈，真是尴尬...", "尴尬。", "不好意思。", "请问，洗手间在哪里？", "我应该溜走。",
    "嗨...", "化作春泥更护花...", "嘿！看什么看！", "没有文化的人不伤心...", "看啥看，没见过恶魔拉粑粑吗！",
}
S_____WORMWOOD.BUFF_OILFLOW = {
    "很奇怪。", "不过也是好事。", "对我来说还好。", "亩产一万斤...", "...", "... ...", "……", "哈哈。",
    "这下朋友们有福啦。", "太好了。", "我越来越饿了...", "噢...", "还好。", "有意思。", "这...",
}
-- S________WARLY.BUFF_OILFLOW = ""
-- S_________WURT.BUFF_OILFLOW = ""
-- S_______WALTER.BUFF_OILFLOW = ""
-- S________WANDA.BUFF_OILFLOW = ""

S_NAMES.DISH_TOMAHAWKSTEAK = "牛排战斧"
STRINGS.UI.COOKBOOK.DISH_TOMAHAWKSTEAK = "单挑之王最爱的斧头"
S______GENERIC.DESCRIBE.DISH_TOMAHAWKSTEAK = {
    GENERIC = "煎得又硬又糙的牛排，会有人喜欢吗？",
    CHOP = "砍倒啦！",
    ATK = "有本事来单挑啊！",
}
S_______WILLOW.DESCRIBE.DISH_TOMAHAWKSTEAK = {
    GENERIC = "哪个小鬼浪费粮食做这种东西！？",
    CHOP = "吃我一招！",
    ATK = "单挑才是真本事！",
}
S_____WOLFGANG.DESCRIBE.DISH_TOMAHAWKSTEAK = {
    GENERIC = "这不能吃吗，可惜了。",
    CHOP = "沃尔夫冈，力大无穷！",
    ATK = "沃尔夫冈可是一对一的不败传奇！",
}
-- S________WENDY.DESCRIBE.DISH_TOMAHAWKSTEAK = ""
-- S_________WX78.DESCRIBE.DISH_TOMAHAWKSTEAK = ""
S_WICKERBOTTOM.DESCRIBE.DISH_TOMAHAWKSTEAK = {
    GENERIC = "有着特殊的香味，也许还有出人意料的效果。",
    CHOP = "刚刚砍到了完美的角度。",
    ATK = "咱们可以来个知识的较量！",
}
S_______WOODIE.DESCRIBE.DISH_TOMAHAWKSTEAK = {
    GENERIC = "大自然的最爱，肉香斧头。",
    CHOP = "无树存活的世界就要达成了。",
    ATK = "其他闹事的给我走远点！",
}
-- S______WAXWELL.DESCRIBE.DISH_TOMAHAWKSTEAK = ""
S___WATHGRITHR.DESCRIBE.DISH_TOMAHAWKSTEAK = {
    GENERIC = "我已预想到敌人会流着口水与我战斗。",
    CHOP = "我是战无不胜的，额，砍树方面。",
    ATK = "这是一场只关于你我的对决！",
}
-- S_______WEBBER.DESCRIBE.DISH_TOMAHAWKSTEAK = ""
S_______WINONA.DESCRIBE.DISH_TOMAHAWKSTEAK = {
    GENERIC = "不能当美食的斧子不是好武器。",
    CHOP = "好斧子！",
    ATK = "公平较量，怎么样？",
}
S_______WORTOX.DESCRIBE.DISH_TOMAHAWKSTEAK = {
    GENERIC = "美食的诱惑。",
    CHOP = "多粗壮的树干也要拜倒在我的酥肉斧头下！",
    ATK = "我单方面给你下达了挑战书！",
}
S_____WORMWOOD.DESCRIBE.DISH_TOMAHAWKSTEAK = {
    GENERIC = "香香，啊不对，坏坏！",
    CHOP = "轻轻的，不痛。",
    ATK = "来来来！",
}
S________WARLY.DESCRIBE.DISH_TOMAHAWKSTEAK = {
    GENERIC = "我要挑战自然的味蕾。",
    CHOP = "切菜一样容易。",
    ATK = "吃了吗，没吃的话，吃我一斧！",
}
-- S_________WURT.DESCRIBE.DISH_TOMAHAWKSTEAK = ""
-- S_______WALTER.DESCRIBE.DISH_TOMAHAWKSTEAK = ""
-- S________WANDA.DESCRIBE.DISH_TOMAHAWKSTEAK = ""

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

S_NAMES.CROPGNAT = "植害虫群"
S______GENERIC.DESCRIBE.CROPGNAT = "嘿！离我的作物远点，小害虫们！"
S_______WILLOW.DESCRIBE.CROPGNAT = "它们也喜欢火吗？"
S_____WOLFGANG.DESCRIBE.CROPGNAT = "幸运的是，它们不会叮咬沃尔夫冈。"
-- S________WENDY.DESCRIBE.CROPGNAT = ""
-- S_________WX78.DESCRIBE.CROPGNAT = ""
S_WICKERBOTTOM.DESCRIBE.CROPGNAT = "最好找到方法解决它们，不然就会颗粒无收。"
-- S_______WOODIE.DESCRIBE.CROPGNAT = ""
-- S______WAXWELL.DESCRIBE.CROPGNAT = ""
-- S___WATHGRITHR.DESCRIBE.CROPGNAT = ""
S_______WEBBER.DESCRIBE.CROPGNAT = "在我打坏邻居家窗户的时候他们也叫我小害虫！"
-- S_______WINONA.DESCRIBE.CROPGNAT = ""
-- S_______WORTOX.DESCRIBE.CROPGNAT = ""
S_____WORMWOOD.DESCRIBE.CROPGNAT = "会伤害植物朋友的朋友。"
S________WARLY.DESCRIBE.CROPGNAT = "住手！优秀的食材快被你们毁了！"
S_________WURT.DESCRIBE.CROPGNAT = "给我留条活路吧，小东西们。"
S_______WALTER.DESCRIBE.CROPGNAT = "优秀的管理者会管好自己的作物。"
S________WANDA.DESCRIBE.CROPGNAT = "我可没时间管这些虫子。"

S_NAMES.CROPGNAT_INFESTER = "叮咬虫群"
S______GENERIC.DESCRIBE.CROPGNAT_INFESTER = "小心点，这些飞虫会叮咬人。"
S_______WILLOW.DESCRIBE.CROPGNAT_INFESTER = "这些蠢虫子会被我的火光吸引。"
S_____WOLFGANG.DESCRIBE.CROPGNAT_INFESTER = "噢，这些小怪物会咬人！"
-- S________WENDY.DESCRIBE.CROPGNAT_INFESTER = ""
S_________WX78.DESCRIBE.CROPGNAT_INFESTER = "它们连铁皮都咬？"
S_WICKERBOTTOM.DESCRIBE.CROPGNAT_INFESTER = "具备攻击性的趋光生物。"
-- S_______WOODIE.DESCRIBE.CROPGNAT_INFESTER = ""
-- S______WAXWELL.DESCRIBE.CROPGNAT_INFESTER = ""
-- S___WATHGRITHR.DESCRIBE.CROPGNAT_INFESTER = ""
-- S_______WEBBER.DESCRIBE.CROPGNAT_INFESTER = ""
S_______WINONA.DESCRIBE.CROPGNAT_INFESTER = "我的天，它们太吵了。"
S_______WORTOX.DESCRIBE.CROPGNAT_INFESTER = "哈哈，你得习惯在野外的生活。"
S_____WORMWOOD.DESCRIBE.CROPGNAT_INFESTER = "会叮咬朋友的朋友。"
S________WARLY.DESCRIBE.CROPGNAT_INFESTER = "别逼我拿你们下饭！"
-- S_________WURT.DESCRIBE.CROPGNAT_INFESTER = ""
-- S_______WALTER.DESCRIBE.CROPGNAT_INFESTER = ""
S________WANDA.DESCRIBE.CROPGNAT_INFESTER = "我现在可有大把时间治治你们！"

S_NAMES.AHANDFULOFWINGS = "一捧翅膀"
S______GENERIC.DESCRIBE.AHANDFULOFWINGS = "一捧非常小的昆虫翅膀。"
S_______WILLOW.DESCRIBE.AHANDFULOFWINGS = "残忍又恶心。"
-- S_____WOLFGANG.DESCRIBE.AHANDFULOFWINGS = ""
-- S________WENDY.DESCRIBE.AHANDFULOFWINGS = ""
-- S_________WX78.DESCRIBE.AHANDFULOFWINGS = ""
S_WICKERBOTTOM.DESCRIBE.AHANDFULOFWINGS = "是的，它们终于被消灭了。"
-- S_______WOODIE.DESCRIBE.AHANDFULOFWINGS = ""
-- S______WAXWELL.DESCRIBE.AHANDFULOFWINGS = ""
S___WATHGRITHR.DESCRIBE.AHANDFULOFWINGS = "解决它们可轻松了。"
-- S_______WEBBER.DESCRIBE.AHANDFULOFWINGS = ""
-- S_______WINONA.DESCRIBE.AHANDFULOFWINGS = ""
-- S_______WORTOX.DESCRIBE.AHANDFULOFWINGS = ""
S_____WORMWOOD.DESCRIBE.AHANDFULOFWINGS = "坏朋友们的遗物。"
-- S________WARLY.DESCRIBE.AHANDFULOFWINGS = ""
S_________WURT.DESCRIBE.AHANDFULOFWINGS = "这可真解气，格罗噗。"
-- S_______WALTER.DESCRIBE.AHANDFULOFWINGS = ""
-- S________WANDA.DESCRIBE.AHANDFULOFWINGS = ""

S_NAMES.BOLTWINGOUT = "脱壳之翅"
S_RECIPE_DESC.BOLTWINGOUT = "金蝉脱壳，逃之夭夭。"
S______GENERIC.DESCRIBE.BOLTWINGOUT = "命悬一线，死里逃生。"
-- S_______WILLOW.DESCRIBE.BOLTWINGOUT = ""
S_____WOLFGANG.DESCRIBE.BOLTWINGOUT = "我像风一样自由..."
-- S________WENDY.DESCRIBE.BOLTWINGOUT = ""
S_________WX78.DESCRIBE.BOLTWINGOUT = "短时间加速设备"
-- S_WICKERBOTTOM.DESCRIBE.BOLTWINGOUT = ""
-- S_______WOODIE.DESCRIBE.BOLTWINGOUT = ""
S______WAXWELL.DESCRIBE.BOLTWINGOUT = "学习昆虫的生存之道。"
S___WATHGRITHR.DESCRIBE.BOLTWINGOUT = "啧啧，真正的战士从不逃跑！"
S_______WEBBER.DESCRIBE.BOLTWINGOUT = "我们会忍术啦！"
S_______WINONA.DESCRIBE.BOLTWINGOUT = "I just wanna run... hide it away!" --这句是英语歌词，所以不翻译
S_______WORTOX.DESCRIBE.BOLTWINGOUT = "切，我用灵魂也能做出这个效果。"
-- S_____WORMWOOD.DESCRIBE.BOLTWINGOUT = ""
-- S________WARLY.DESCRIBE.BOLTWINGOUT = ""
-- S_________WURT.DESCRIBE.BOLTWINGOUT = ""
S_______WALTER.DESCRIBE.BOLTWINGOUT = "能让我实现逃跑策略的有用道具。"
S________WANDA.DESCRIBE.BOLTWINGOUT = "我能以空间形式溜走。"

S_NAMES.BOLTWINGOUT_SHUCK = "羽化后的壳"
S______GENERIC.DESCRIBE.BOLTWINGOUT_SHUCK = "哈哈，很多生物都看不出来这只是一个壳而已。"
S_______WILLOW.DESCRIBE.BOLTWINGOUT_SHUCK = "好大一只假虫子，烧掉烧掉！"
S_____WOLFGANG.DESCRIBE.BOLTWINGOUT_SHUCK = "就像你的温柔，无法挽留。"
-- S________WENDY.DESCRIBE.BOLTWINGOUT_SHUCK = ""
S_________WX78.DESCRIBE.BOLTWINGOUT_SHUCK = "狡猾的虫子！"
-- S_WICKERBOTTOM.DESCRIBE.BOLTWINGOUT_SHUCK = ""
-- S_______WOODIE.DESCRIBE.BOLTWINGOUT_SHUCK = ""
S______WAXWELL.DESCRIBE.BOLTWINGOUT_SHUCK = "三十六计，走为上策。"
S___WATHGRITHR.DESCRIBE.BOLTWINGOUT_SHUCK = "还残留着懦弱的气息。"
S_______WEBBER.DESCRIBE.BOLTWINGOUT_SHUCK = "我们蜕皮之后也会丢掉老旧的皮。"
S_______WINONA.DESCRIBE.BOLTWINGOUT_SHUCK = "这壳才不是随便丢掉的，它自有用途。"
-- S_______WORTOX.DESCRIBE.BOLTWINGOUT_SHUCK = ""
S_____WORMWOOD.DESCRIBE.BOLTWINGOUT_SHUCK = "嘿朋友，你还在里面吗？"
-- S________WARLY.DESCRIBE.BOLTWINGOUT_SHUCK = ""
-- S_________WURT.DESCRIBE.BOLTWINGOUT_SHUCK = ""
S_______WALTER.DESCRIBE.BOLTWINGOUT_SHUCK = "有时候逃跑也是一种策略。"
S________WANDA.DESCRIBE.BOLTWINGOUT_SHUCK = "居然留下了痕迹，等等，我明白了。"

S_NAMES.MINT_L = "猫薄荷"
S______GENERIC.DESCRIBE.MINT_L = "有清香的味道。"
-- S_______WILLOW.DESCRIBE.MINT_L = ""
S_____WOLFGANG.DESCRIBE.MINT_L = "沃尔夫冈想吃口香糖了。"
-- S________WENDY.DESCRIBE.MINT_L = ""
S_________WX78.DESCRIBE.MINT_L = "不就是一些普通杂草吗。"
S_WICKERBOTTOM.DESCRIBE.MINT_L = "说真的，薄荷和猫薄荷不是同一种植物。"
-- S_______WOODIE.DESCRIBE.MINT_L = ""
-- S______WAXWELL.DESCRIBE.MINT_L = ""
-- S___WATHGRITHR.DESCRIBE.MINT_L = ""
S_______WEBBER.DESCRIBE.MINT_L = "拿去喂给森林里的猫们怎么样？"
-- S_______WINONA.DESCRIBE.MINT_L = ""
S_______WORTOX.DESCRIBE.MINT_L = "算了，我不会喜欢这个。"
S_____WORMWOOD.DESCRIBE.MINT_L = "你好啊，香香的朋友。"
S________WARLY.DESCRIBE.MINT_L = "我能拿来当做调料就好了。"
S_________WURT.DESCRIBE.MINT_L = "作为素食者，我很喜欢。"
-- S_______WALTER.DESCRIBE.MINT_L = ""
-- S________WANDA.DESCRIBE.MINT_L = ""

S_NAMES.CATTENBALL = "猫线球"
S______GENERIC.DESCRIBE.CATTENBALL = "尽管是从胃里倒腾出来的，但还是很可爱。"
-- S_______WILLOW.DESCRIBE.CATTENBALL = ""
-- S_____WOLFGANG.DESCRIBE.CATTENBALL = ""
-- S________WENDY.DESCRIBE.CATTENBALL = ""
S_________WX78.DESCRIBE.CATTENBALL = "闻起来一股猫味。"
-- S_WICKERBOTTOM.DESCRIBE.CATTENBALL = ""
-- S_______WOODIE.DESCRIBE.CATTENBALL = ""
-- S______WAXWELL.DESCRIBE.CATTENBALL = ""
-- S___WATHGRITHR.DESCRIBE.CATTENBALL = ""
S_______WEBBER.DESCRIBE.CATTENBALL = "我们必须要在床上办个玩具展。"
S_______WINONA.DESCRIBE.CATTENBALL = "也许可以用来织毛衣。"
S_______WORTOX.DESCRIBE.CATTENBALL = "看看看，和我一样可爱的颜色呢。"
-- S_____WORMWOOD.DESCRIBE.CATTENBALL = ""
-- S________WARLY.DESCRIBE.CATTENBALL = ""
S_________WURT.DESCRIBE.CATTENBALL = "住在荒漠幻影里的那位老婆婆肯定很喜欢这个。"
-- S_______WALTER.DESCRIBE.CATTENBALL = ""
-- S________WANDA.DESCRIBE.CATTENBALL = ""

S_NAMES.SIVING_ROCKS = "子圭石"
S______GENERIC.DESCRIBE.SIVING_ROCKS = "生命的力量在其中涌动。"
S_______WILLOW.DESCRIBE.SIVING_ROCKS = "没错，我一点想烧的想法都没有。"
S_____WOLFGANG.DESCRIBE.SIVING_ROCKS = "漂亮的小石头。"
S________WENDY.DESCRIBE.SIVING_ROCKS = "说不痛苦那是假的，毕竟我的心也是肉做的。"
S_________WX78.DESCRIBE.SIVING_ROCKS = "和我一样，是非碳基生命。"
S_WICKERBOTTOM.DESCRIBE.SIVING_ROCKS = "我很震惊，这矿石居然有生命的活性！"
S_______WOODIE.DESCRIBE.SIVING_ROCKS = "它轮廓和形状都很像一片叶子。"
S______WAXWELL.DESCRIBE.SIVING_ROCKS = "这，难道就是传说中的..."
S___WATHGRITHR.DESCRIBE.SIVING_ROCKS = "难道是世界之树的落叶？！"
S_______WEBBER.DESCRIBE.SIVING_ROCKS = "嘻嘻，稀有的石头增加了！"
S_______WINONA.DESCRIBE.SIVING_ROCKS = "神秘的绿色在其中看着我。"
S_______WORTOX.DESCRIBE.SIVING_ROCKS = "在这个世界，的确不常见。"
S_____WORMWOOD.DESCRIBE.SIVING_ROCKS = "石头朋友的一部分。"
S________WARLY.DESCRIBE.SIVING_ROCKS = "不涉及我的领域，不多说。"
S_________WURT.DESCRIBE.SIVING_ROCKS = "我在我的故乡见过。"
S_______WALTER.DESCRIBE.SIVING_ROCKS = "啊哈，物种大发现！"
S________WANDA.DESCRIBE.SIVING_ROCKS = "在阳光下，它很耀眼。"

S_NAMES.SIVING_DERIVANT_ITEM = "未种下的子圭一型岩"
S______GENERIC.DESCRIBE.SIVING_DERIVANT_ITEM = "我倒想看看它会长成什么样。"
-- S_______WILLOW.DESCRIBE.SIVING_DERIVANT_ITEM = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_DERIVANT_ITEM = ""
-- S________WENDY.DESCRIBE.SIVING_DERIVANT_ITEM = ""
-- S_________WX78.DESCRIBE.SIVING_DERIVANT_ITEM = ""
S_WICKERBOTTOM.DESCRIBE.SIVING_DERIVANT_ITEM = "栽种后值得研究一番。"
-- S_______WOODIE.DESCRIBE.SIVING_DERIVANT_ITEM = ""
S______WAXWELL.DESCRIBE.SIVING_DERIVANT_ITEM = "费尽心思从怪鸟那里抢过来的，可别让我失望。"
S___WATHGRITHR.DESCRIBE.SIVING_DERIVANT_ITEM = "难道是世界树的衍生物？！"
-- S_______WEBBER.DESCRIBE.SIVING_DERIVANT_ITEM = ""
-- S_______WINONA.DESCRIBE.SIVING_DERIVANT_ITEM = ""
-- S_______WORTOX.DESCRIBE.SIVING_DERIVANT_ITEM = ""
S_____WORMWOOD.DESCRIBE.SIVING_DERIVANT_ITEM = "石头朋友的孩子，还在睡觉呢。"
-- S________WARLY.DESCRIBE.SIVING_DERIVANT_ITEM = ""
S_________WURT.DESCRIBE.SIVING_DERIVANT_ITEM = "这是它的种子，需要种土里。"
-- S_______WALTER.DESCRIBE.SIVING_DERIVANT_ITEM = ""
-- S________WANDA.DESCRIBE.SIVING_DERIVANT_ITEM = ""

S_NAMES.SIVING_DERIVANT_LVL0 = "子圭一型岩"
S______GENERIC.DESCRIBE.SIVING_DERIVANT_LVL0 = "没看出在生长的痕迹。"
-- S_______WILLOW.DESCRIBE.SIVING_DERIVANT_LVL0 = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_DERIVANT_LVL0 = ""
-- S________WENDY.DESCRIBE.SIVING_DERIVANT_LVL0 = ""
-- S_________WX78.DESCRIBE.SIVING_DERIVANT_LVL0 = ""
S_WICKERBOTTOM.DESCRIBE.SIVING_DERIVANT_LVL0 = "值得研究一番。"
-- S_______WOODIE.DESCRIBE.SIVING_DERIVANT_LVL0 = ""
-- S______WAXWELL.DESCRIBE.SIVING_DERIVANT_LVL0 = ""
S___WATHGRITHR.DESCRIBE.SIVING_DERIVANT_LVL0 = "希望它能长成世界树。"
-- S_______WEBBER.DESCRIBE.SIVING_DERIVANT_LVL0 = ""
-- S_______WINONA.DESCRIBE.SIVING_DERIVANT_LVL0 = ""
-- S_______WORTOX.DESCRIBE.SIVING_DERIVANT_LVL0 = ""
S_____WORMWOOD.DESCRIBE.SIVING_DERIVANT_LVL0 = "石头朋友的孩子，它醒了。"
-- S________WARLY.DESCRIBE.SIVING_DERIVANT_LVL0 = ""
S_________WURT.DESCRIBE.SIVING_DERIVANT_LVL0 = "种下去就等着吧，格洛噗。"
-- S_______WALTER.DESCRIBE.SIVING_DERIVANT_LVL0 = ""
S________WANDA.DESCRIBE.SIVING_DERIVANT_LVL0 = "它需要的可不止一点时间。"

S_NAMES.SIVING_DERIVANT_LVL1 = "子圭木型岩"
S______GENERIC.DESCRIBE.SIVING_DERIVANT_LVL1 = "谢天谢地，终于长一小截了。"
-- S_______WILLOW.DESCRIBE.SIVING_DERIVANT_LVL1 = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_DERIVANT_LVL1 = ""
S________WENDY.DESCRIBE.SIVING_DERIVANT_LVL1 = "真是充满希望。"
-- S_________WX78.DESCRIBE.SIVING_DERIVANT_LVL1 = ""
S_WICKERBOTTOM.DESCRIBE.SIVING_DERIVANT_LVL1 = "不错，值得继续观察。"
-- S_______WOODIE.DESCRIBE.SIVING_DERIVANT_LVL1 = ""
-- S______WAXWELL.DESCRIBE.SIVING_DERIVANT_LVL1 = ""
-- S___WATHGRITHR.DESCRIBE.SIVING_DERIVANT_LVL1 = ""
-- S_______WEBBER.DESCRIBE.SIVING_DERIVANT_LVL1 = ""
-- S_______WINONA.DESCRIBE.SIVING_DERIVANT_LVL1 = ""
-- S_______WORTOX.DESCRIBE.SIVING_DERIVANT_LVL1 = ""
S_____WORMWOOD.DESCRIBE.SIVING_DERIVANT_LVL1 = "它很健康地在长高呢。"
-- S________WARLY.DESCRIBE.SIVING_DERIVANT_LVL1 = ""
-- S_________WURT.DESCRIBE.SIVING_DERIVANT_LVL1 = ""
-- S_______WALTER.DESCRIBE.SIVING_DERIVANT_LVL1 = ""
S________WANDA.DESCRIBE.SIVING_DERIVANT_LVL1 = "它需要不止一点时间来继续生长。"

S_NAMES.SIVING_DERIVANT_LVL2 = "子圭林型岩"
S______GENERIC.DESCRIBE.SIVING_DERIVANT_LVL2 = "真棒，长得还不错。"
-- S_______WILLOW.DESCRIBE.SIVING_DERIVANT_LVL2 = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_DERIVANT_LVL2 = ""
-- S________WENDY.DESCRIBE.SIVING_DERIVANT_LVL2 = ""
-- S_________WX78.DESCRIBE.SIVING_DERIVANT_LVL2 = ""
S_WICKERBOTTOM.DESCRIBE.SIVING_DERIVANT_LVL2 = "我会继续研究下去的。"
-- S_______WOODIE.DESCRIBE.SIVING_DERIVANT_LVL2 = ""
-- S______WAXWELL.DESCRIBE.SIVING_DERIVANT_LVL2 = ""
-- S___WATHGRITHR.DESCRIBE.SIVING_DERIVANT_LVL2 = ""
-- S_______WEBBER.DESCRIBE.SIVING_DERIVANT_LVL2 = ""
-- S_______WINONA.DESCRIBE.SIVING_DERIVANT_LVL2 = ""
-- S_______WORTOX.DESCRIBE.SIVING_DERIVANT_LVL2 = ""
S_____WORMWOOD.DESCRIBE.SIVING_DERIVANT_LVL2 = "个头都比我高了。"
-- S________WARLY.DESCRIBE.SIVING_DERIVANT_LVL2 = ""
S_________WURT.DESCRIBE.SIVING_DERIVANT_LVL2 = "我从来没种活过，噗噜！"
-- S_______WALTER.DESCRIBE.SIVING_DERIVANT_LVL2 = ""
S________WANDA.DESCRIBE.SIVING_DERIVANT_LVL2 = "这时间对我来说就是一小会。"

S_NAMES.SIVING_DERIVANT_LVL3 = "子圭森型岩"
S______GENERIC.DESCRIBE.SIVING_DERIVANT_LVL3 = "这石头长得很茂盛。"
S_______WILLOW.DESCRIBE.SIVING_DERIVANT_LVL3 = "又没法烧，差评。"
-- S_____WOLFGANG.DESCRIBE.SIVING_DERIVANT_LVL3 = ""
-- S________WENDY.DESCRIBE.SIVING_DERIVANT_LVL3 = ""
-- S_________WX78.DESCRIBE.SIVING_DERIVANT_LVL3 = ""
S_WICKERBOTTOM.DESCRIBE.SIVING_DERIVANT_LVL3 = "应该是它的最终形态了。"
S_______WOODIE.DESCRIBE.SIVING_DERIVANT_LVL3 = "它可不吃斧头那一套。"
-- S______WAXWELL.DESCRIBE.SIVING_DERIVANT_LVL3 = ""
-- S___WATHGRITHR.DESCRIBE.SIVING_DERIVANT_LVL3 = ""
-- S_______WEBBER.DESCRIBE.SIVING_DERIVANT_LVL3 = ""
-- S_______WINONA.DESCRIBE.SIVING_DERIVANT_LVL3 = ""
S_______WORTOX.DESCRIBE.SIVING_DERIVANT_LVL3 = "长得再好也是没有灵魂的家伙。"
S_____WORMWOOD.DESCRIBE.SIVING_DERIVANT_LVL3 = "成熟的石头朋友了。"
S________WARLY.DESCRIBE.SIVING_DERIVANT_LVL3 = "这里啥都有，最不缺的就是奇怪。"
S_________WURT.DESCRIBE.SIVING_DERIVANT_LVL3 = "故乡的森林深处，都是这玩意。"
-- S_______WALTER.DESCRIBE.SIVING_DERIVANT_LVL3 = ""
S________WANDA.DESCRIBE.SIVING_DERIVANT_LVL3 = "真神奇啊，但我见怪不怪了。"

S_NAMES.SIVING_THETREE = "子圭神木岩"
S______GENERIC.DESCRIBE.SIVING_THETREE = "我整个生命都拜倒在它的神秘威严之下。"
S_______WILLOW.DESCRIBE.SIVING_THETREE = "它不能燃烧，但它能燃烧生命之火。"
S_____WOLFGANG.DESCRIBE.SIVING_THETREE = "沃尔夫冈不应该离氪石这么近。"
S________WENDY.DESCRIBE.SIVING_THETREE = "它正牵着我，和平地走向死亡，真是欣慰。"
S_________WX78.DESCRIBE.SIVING_THETREE = "它渴望夺取生命。"
S_WICKERBOTTOM.DESCRIBE.SIVING_THETREE = "危险！它有一股宛如黑洞般的生命吸引力。"
S_______WOODIE.DESCRIBE.SIVING_THETREE = "露西，别想着砍它了，听我的没错。"
S______WAXWELL.DESCRIBE.SIVING_THETREE = "看起来不像查理的作品。"
S___WATHGRITHR.DESCRIBE.SIVING_THETREE = "青光闪过，神树永恒！"
S_______WEBBER.DESCRIBE.SIVING_THETREE = "好想爬上去玩玩。"
S_______WINONA.DESCRIBE.SIVING_THETREE = "看看，多精美的纹路。"
S_______WORTOX.DESCRIBE.SIVING_THETREE = "这鬼东西想要我的命，但明明我的灵魂更好吃。"
S_____WORMWOOD.DESCRIBE.SIVING_THETREE = "这还算朋友吗？"
S________WARLY.DESCRIBE.SIVING_THETREE = "我的生命和我做的料理一样鲜美。"
S_________WURT.DESCRIBE.SIVING_THETREE = "为什么它不像家乡的一样安全，格浪噗？"
S_______WALTER.DESCRIBE.SIVING_THETREE = "离真相越近，往往就越危险。"
S________WANDA.DESCRIBE.SIVING_THETREE = "一靠近它我就感到自己的时间在流逝。"

S_NAMES.SIVING_SOIL_ITEM = "未放置的子圭·垄"
S_RECIPE_DESC.SIVING_SOIL_ITEM = "从种子开始，入生命轮回。"
S______GENERIC.DESCRIBE.SIVING_SOIL_ITEM = "找个方向放下，找颗种子种下。"
-- S_______WILLOW.DESCRIBE.SIVING_SOIL_ITEM = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_SOIL_ITEM = ""
S________WENDY.DESCRIBE.SIVING_SOIL_ITEM = "小小种子也要被困在灵魂的牢笼里了。"
-- S_________WX78.DESCRIBE.SIVING_SOIL_ITEM = ""
S_WICKERBOTTOM.DESCRIBE.SIVING_SOIL_ITEM = "能为植株提供不断再生的环境。"
-- S_______WOODIE.DESCRIBE.SIVING_SOIL_ITEM = ""
-- S______WAXWELL.DESCRIBE.SIVING_SOIL_ITEM = ""
S___WATHGRITHR.DESCRIBE.SIVING_SOIL_ITEM = "我不太需要这个，但队友们需要吧。"
-- S_______WEBBER.DESCRIBE.SIVING_SOIL_ITEM = ""
-- S_______WINONA.DESCRIBE.SIVING_SOIL_ITEM = ""
S_______WORTOX.DESCRIBE.SIVING_SOIL_ITEM = "红豆生南国，春来发几枝。"
-- S_____WORMWOOD.DESCRIBE.SIVING_SOIL_ITEM = ""
S________WARLY.DESCRIBE.SIVING_SOIL_ITEM = "新鲜的食材培养器。"
S_________WURT.DESCRIBE.SIVING_SOIL_ITEM = "看到这个我就来了兴趣，浮浪噗。"
-- S_______WALTER.DESCRIBE.SIVING_SOIL_ITEM = ""
-- S________WANDA.DESCRIBE.SIVING_SOIL_ITEM = ""

S_NAMES.SIVING_SOIL = "子圭·垄"
S______GENERIC.DESCRIBE.SIVING_SOIL = "高级种植的第一步，我会吃撑的一大步！"
S_______WILLOW.DESCRIBE.SIVING_SOIL = "播种，发芽，成熟，烧掉。就这么干！"
S_____WOLFGANG.DESCRIBE.SIVING_SOIL = "俺勤劳的双手已经准备好了。"
S________WENDY.DESCRIBE.SIVING_SOIL = "我还在考虑要不要继续做下去。"
S_________WX78.DESCRIBE.SIVING_SOIL = "这可以是一种清洁燃料的来源。"
S_WICKERBOTTOM.DESCRIBE.SIVING_SOIL = "再生环境已经放置完毕，等待下一步操作。"
S_______WOODIE.DESCRIBE.SIVING_SOIL = "谁还记得我以前只是个普通的伐木工。"
S______WAXWELL.DESCRIBE.SIVING_SOIL = "就算要做，也要做个体面的农民。"
S___WATHGRITHR.DESCRIBE.SIVING_SOIL = "还是一场精彩的战斗有趣得多。"
S_______WEBBER.DESCRIBE.SIVING_SOIL = "栽培课时间到！"
S_______WINONA.DESCRIBE.SIVING_SOIL = "播种这点事，不在话下。"
S_______WORTOX.DESCRIBE.SIVING_SOIL = "春种一粒粟，秋收万颗子。"
S_____WORMWOOD.DESCRIBE.SIVING_SOIL = "宝宝们的摇篮，高级版！"
S________WARLY.DESCRIBE.SIVING_SOIL = "接下来只需要撒下一点点种子。"
S_________WURT.DESCRIBE.SIVING_SOIL = "真激动，我该种什么呢。"
S_______WALTER.DESCRIBE.SIVING_SOIL = "这个能让我拿到种植徽章。"
S________WANDA.DESCRIBE.SIVING_SOIL = "作物也要陷入时间循环了吗。"

S_NAMES.SIVING_CTLWATER_ITEM = "未放置的子圭·利川"
S_RECIPE_DESC.SIVING_CTLWATER_ITEM = "掌方寸间水分。"
S______GENERIC.DESCRIBE.SIVING_CTLWATER_ITEM = "放置后能发挥控制土壤水分的作用。"
-- S_______WILLOW.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S________WENDY.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S_________WX78.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S_WICKERBOTTOM.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S_______WOODIE.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S______WAXWELL.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S___WATHGRITHR.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S_______WEBBER.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S_______WINONA.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S_______WORTOX.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S_____WORMWOOD.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S________WARLY.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S_________WURT.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S_______WALTER.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S________WANDA.DESCRIBE.SIVING_CTLWATER_ITEM = ""

S_NAMES.SIVING_CTLWATER = "子圭·利川"
S______GENERIC.DESCRIBE.SIVING_CTLWATER = {
    GENERIC = "它能像心脏一样向周围土壤输送水分。",
    ISFULL = "储存的水分足够了。",
    REFUSE = "这东西水分太少了。",
}
-- S_______WILLOW.DESCRIBE.SIVING_CTLWATER = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_CTLWATER = ""
-- S________WENDY.DESCRIBE.SIVING_CTLWATER = ""
-- S_________WX78.DESCRIBE.SIVING_CTLWATER = ""
-- S_WICKERBOTTOM.DESCRIBE.SIVING_CTLWATER = ""
-- S_______WOODIE.DESCRIBE.SIVING_CTLWATER = ""
-- S______WAXWELL.DESCRIBE.SIVING_CTLWATER = ""
-- S___WATHGRITHR.DESCRIBE.SIVING_CTLWATER = ""
-- S_______WEBBER.DESCRIBE.SIVING_CTLWATER = ""
-- S_______WINONA.DESCRIBE.SIVING_CTLWATER = ""
-- S_______WORTOX.DESCRIBE.SIVING_CTLWATER = ""
-- S_____WORMWOOD.DESCRIBE.SIVING_CTLWATER = ""
-- S________WARLY.DESCRIBE.SIVING_CTLWATER = ""
-- S_________WURT.DESCRIBE.SIVING_CTLWATER = ""
-- S_______WALTER.DESCRIBE.SIVING_CTLWATER = ""
-- S________WANDA.DESCRIBE.SIVING_CTLWATER = ""

S_NAMES.SIVING_CTLDIRT_ITEM = "未放置的子圭·益矩"
S_RECIPE_DESC.SIVING_CTLDIRT_ITEM = "控方寸间养分。"
S______GENERIC.DESCRIBE.SIVING_CTLDIRT_ITEM = "放置后能发挥控制土壤养分的作用。"
-- S_______WILLOW.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S________WENDY.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S_________WX78.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S_WICKERBOTTOM.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S_______WOODIE.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S______WAXWELL.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S___WATHGRITHR.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S_______WEBBER.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S_______WINONA.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S_______WORTOX.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S_____WORMWOOD.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S________WARLY.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S_________WURT.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S_______WALTER.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S________WANDA.DESCRIBE.SIVING_CTLDIRT_ITEM = ""

S_NAMES.SIVING_CTLDIRT = "子圭·益矩"
S______GENERIC.DESCRIBE.SIVING_CTLDIRT = {
    GENERIC = "它能像心脏一样向周围土壤输送养分。",
    ISFULL = "储藏的养分足够了。",
    REFUSE = "这东西不能化作养料。",
}
-- S_______WILLOW.DESCRIBE.SIVING_CTLDIRT = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_CTLDIRT = ""
-- S________WENDY.DESCRIBE.SIVING_CTLDIRT = ""
-- S_________WX78.DESCRIBE.SIVING_CTLDIRT = ""
-- S_WICKERBOTTOM.DESCRIBE.SIVING_CTLDIRT = ""
-- S_______WOODIE.DESCRIBE.SIVING_CTLDIRT = ""
-- S______WAXWELL.DESCRIBE.SIVING_CTLDIRT = ""
-- S___WATHGRITHR.DESCRIBE.SIVING_CTLDIRT = ""
-- S_______WEBBER.DESCRIBE.SIVING_CTLDIRT = ""
-- S_______WINONA.DESCRIBE.SIVING_CTLDIRT = ""
-- S_______WORTOX.DESCRIBE.SIVING_CTLDIRT = ""
-- S_____WORMWOOD.DESCRIBE.SIVING_CTLDIRT = ""
-- S________WARLY.DESCRIBE.SIVING_CTLDIRT = ""
-- S_________WURT.DESCRIBE.SIVING_CTLDIRT = ""
-- S_______WALTER.DESCRIBE.SIVING_CTLDIRT = ""
-- S________WANDA.DESCRIBE.SIVING_CTLDIRT = ""

S_NAMES.SIVING_CTLAll_ITEM = "未放置的子圭·崇溟"
S_RECIPE_DESC.SIVING_CTLAll_ITEM = "掌控方寸间水土。"
S______GENERIC.DESCRIBE.SIVING_CTLAll_ITEM = "放置后能发挥控制水分与养分的作用。"
-- S_______WILLOW.DESCRIBE.SIVING_CTLAll_ITEM = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_CTLAll_ITEM = ""
-- S________WENDY.DESCRIBE.SIVING_CTLAll_ITEM = ""
-- S_________WX78.DESCRIBE.SIVING_CTLAll_ITEM = ""
-- S_WICKERBOTTOM.DESCRIBE.SIVING_CTLAll_ITEM = ""
-- S_______WOODIE.DESCRIBE.SIVING_CTLAll_ITEM = ""
-- S______WAXWELL.DESCRIBE.SIVING_CTLAll_ITEM = ""
-- S___WATHGRITHR.DESCRIBE.SIVING_CTLAll_ITEM = ""
-- S_______WEBBER.DESCRIBE.SIVING_CTLAll_ITEM = ""
-- S_______WINONA.DESCRIBE.SIVING_CTLAll_ITEM = ""
-- S_______WORTOX.DESCRIBE.SIVING_CTLAll_ITEM = ""
-- S_____WORMWOOD.DESCRIBE.SIVING_CTLAll_ITEM = ""
-- S________WARLY.DESCRIBE.SIVING_CTLAll_ITEM = ""
-- S_________WURT.DESCRIBE.SIVING_CTLAll_ITEM = ""
-- S_______WALTER.DESCRIBE.SIVING_CTLAll_ITEM = ""
-- S________WANDA.DESCRIBE.SIVING_CTLAll_ITEM = ""

S_NAMES.SIVING_CTLAll = "子圭·崇溟"
S______GENERIC.DESCRIBE.SIVING_CTLAll = {
    GENERIC = "能像心脏一样向周围土壤输送水分与养分。",
    ISFULL = "内容物已经满了。",
    REFUSE = "不是它能掌控的东西。",
}
-- S_______WILLOW.DESCRIBE.SIVING_CTLAll = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_CTLAll = ""
-- S________WENDY.DESCRIBE.SIVING_CTLAll = ""
-- S_________WX78.DESCRIBE.SIVING_CTLAll = ""
-- S_WICKERBOTTOM.DESCRIBE.SIVING_CTLAll = ""
-- S_______WOODIE.DESCRIBE.SIVING_CTLAll = ""
-- S______WAXWELL.DESCRIBE.SIVING_CTLAll = ""
-- S___WATHGRITHR.DESCRIBE.SIVING_CTLAll = ""
-- S_______WEBBER.DESCRIBE.SIVING_CTLAll = ""
-- S_______WINONA.DESCRIBE.SIVING_CTLAll = ""
-- S_______WORTOX.DESCRIBE.SIVING_CTLAll = ""
-- S_____WORMWOOD.DESCRIBE.SIVING_CTLAll = ""
-- S________WARLY.DESCRIBE.SIVING_CTLAll = ""
-- S_________WURT.DESCRIBE.SIVING_CTLAll = ""
-- S_______WALTER.DESCRIBE.SIVING_CTLAll = ""
-- S________WANDA.DESCRIBE.SIVING_CTLAll = ""

S_NAMES.FISHHOMINGTOOL_NORMAL = "简易打窝饵制作器"
S_RECIPE_DESC.FISHHOMINGTOOL_NORMAL = "一次性的打窝饵料制作器。"
S______GENERIC.DESCRIBE.FISHHOMINGTOOL_NORMAL = "据说每个垂钓好手都有自己独特的配方。"
-- S_______WILLOW.DESCRIBE.FISHHOMINGTOOL_NORMAL = ""
-- S_____WOLFGANG.DESCRIBE.FISHHOMINGTOOL_NORMAL = ""
-- S________WENDY.DESCRIBE.FISHHOMINGTOOL_NORMAL = ""
-- S_________WX78.DESCRIBE.FISHHOMINGTOOL_NORMAL = ""
-- S_WICKERBOTTOM.DESCRIBE.FISHHOMINGTOOL_NORMAL = ""
-- S_______WOODIE.DESCRIBE.FISHHOMINGTOOL_NORMAL = ""
-- S______WAXWELL.DESCRIBE.FISHHOMINGTOOL_NORMAL = ""
-- S___WATHGRITHR.DESCRIBE.FISHHOMINGTOOL_NORMAL = ""
-- S_______WEBBER.DESCRIBE.FISHHOMINGTOOL_NORMAL = ""
S_______WINONA.DESCRIBE.FISHHOMINGTOOL_NORMAL = "做工实在不咋地，用一次就会坏了。"
-- S_______WORTOX.DESCRIBE.FISHHOMINGTOOL_NORMAL = ""
-- S_____WORMWOOD.DESCRIBE.FISHHOMINGTOOL_NORMAL = ""
S________WARLY.DESCRIBE.FISHHOMINGTOOL_NORMAL = "就算是做鱼类的厨师，我也是有两把刷子的。"
S_________WURT.DESCRIBE.FISHHOMINGTOOL_NORMAL = "给每种鱼儿找到它们的喜好，浮勒浮。"
-- S_______WALTER.DESCRIBE.FISHHOMINGTOOL_NORMAL = ""
-- S________WANDA.DESCRIBE.FISHHOMINGTOOL_NORMAL = ""

S_NAMES.FISHHOMINGTOOL_AWESOME = "专业打窝饵制作器"
S_RECIPE_DESC.FISHHOMINGTOOL_AWESOME = "超专业的打窝饵料制作器。"
S______GENERIC.DESCRIBE.FISHHOMINGTOOL_AWESOME = "据说每个垂钓大佬都有独树一格的工具与配方。"
-- S_______WILLOW.DESCRIBE.FISHHOMINGTOOL_AWESOME = ""
-- S_____WOLFGANG.DESCRIBE.FISHHOMINGTOOL_AWESOME = ""
-- S________WENDY.DESCRIBE.FISHHOMINGTOOL_AWESOME = ""
-- S_________WX78.DESCRIBE.FISHHOMINGTOOL_AWESOME = ""
-- S_WICKERBOTTOM.DESCRIBE.FISHHOMINGTOOL_AWESOME = ""
-- S_______WOODIE.DESCRIBE.FISHHOMINGTOOL_AWESOME = ""
-- S______WAXWELL.DESCRIBE.FISHHOMINGTOOL_AWESOME = ""
-- S___WATHGRITHR.DESCRIBE.FISHHOMINGTOOL_AWESOME = ""
-- S_______WEBBER.DESCRIBE.FISHHOMINGTOOL_AWESOME = ""
S_______WINONA.DESCRIBE.FISHHOMINGTOOL_AWESOME = "做工小巧精致，可以用很久了吧。"
-- S_______WORTOX.DESCRIBE.FISHHOMINGTOOL_AWESOME = ""
-- S_____WORMWOOD.DESCRIBE.FISHHOMINGTOOL_AWESOME = ""
S________WARLY.DESCRIBE.FISHHOMINGTOOL_AWESOME = "就算是在海洋里当厨师，我也是能胜任的。"
S_________WURT.DESCRIBE.FISHHOMINGTOOL_AWESOME = "给海里的朋友找到它们的喜好，浮勒浮。"
-- S_______WALTER.DESCRIBE.FISHHOMINGTOOL_AWESOME = ""
S________WANDA.DESCRIBE.FISHHOMINGTOOL_AWESOME = "我看也没节约多少时间，还不如直接造渔网。"

STRINGS.FISHHOMING1_LEGION = {
    HARDY = "粒状",
    PASTY = "糊状",
    DUSTY = "粉状"
}
STRINGS.FISHHOMING2_LEGION = {
    MEAT = "荤",
    VEGGIE = "素",
    MONSTER = "怪"
}
STRINGS.FISHHOMING3_LEGION = {
    LUCKY = "好彩来", --金锦鲤、花锦鲤
    FROZEN = "好凉凉", --冰鲷鱼
    HOT = "烫烫烫", --炽热太阳鱼
    STICKY = "黏乎乎", --甜味鱼
    SLIPPERY = "麻溜的", --口水鱼
    FRAGRANT = "香喷喷", --花朵金枪鱼
    WRINKLED = "皱巴巴", --落叶比目鱼
    COMICAL = "滑稽的", --爆米花鱼、玉米鳕鱼
    SHINY = "亮晶晶", --鱿鱼
    BLOODY = "血腥味", --岩石大白鲨
    WHISPERING = "低语的", --一角鲸
    ROTTEN = "发烂发臭", --龙虾
    RUSTY = "生锈的", --月光龙虾
    SHAKING = "摇摆的", --海黾
    GRASSY = "青草味", --草鳄鱼
    EVIL = "拽拽的", --邪天翁
    FRIZZY = "蠕动的", --海鹦鹉
}

S_NAMES.FISHHOMINGBAIT = "打窝饵"
S______GENERIC.DESCRIBE.FISHHOMINGBAIT = "丢进水里吸引鱼儿的饵料。"
-- S_______WILLOW.DESCRIBE.FISHHOMINGBAIT = ""
-- S_____WOLFGANG.DESCRIBE.FISHHOMINGBAIT = ""
-- S________WENDY.DESCRIBE.FISHHOMINGBAIT = ""
S_________WX78.DESCRIBE.FISHHOMINGBAIT = "愚蠢的水中生物！"
S_WICKERBOTTOM.DESCRIBE.FISHHOMINGBAIT = "很对水栖生物的胃口。"
-- S_______WOODIE.DESCRIBE.FISHHOMINGBAIT = ""
-- S______WAXWELL.DESCRIBE.FISHHOMINGBAIT = ""
-- S___WATHGRITHR.DESCRIBE.FISHHOMINGBAIT = ""
-- S_______WEBBER.DESCRIBE.FISHHOMINGBAIT = ""
-- S_______WINONA.DESCRIBE.FISHHOMINGBAIT = ""
-- S_______WORTOX.DESCRIBE.FISHHOMINGBAIT = ""
S_____WORMWOOD.DESCRIBE.FISHHOMINGBAIT = "鱼鱼，饭饭，饿饿..."
S________WARLY.DESCRIBE.FISHHOMINGBAIT = "鱼儿们，菜来咯！"
S_________WURT.DESCRIBE.FISHHOMINGBAIT = "浮勒浮，今天是哪条可爱的鱼儿要被它吸引呢？"
S_______WALTER.DESCRIBE.FISHHOMINGBAIT = "我记得某电影里男主角说去钓鱼却从没打开过钓具袋..."
S________WANDA.DESCRIBE.FISHHOMINGBAIT = "好了好了，某人就是想挥霍时间钓鱼对吧。"

STRINGS.PLANT_CROP_L = {
    WITHERED = "枯萎",
    BLUE = "沮丧",
    DRY = "干燥",
    FEEBLE = "虚弱",
    PREPOSITION = "的",
    FLORESCENCE = "花期",
    SEEDS = "异种",
}
S_NAMES.PLANT_CARROT_L = "胡萝卜"
S_NAMES.PLANT_CORN_L = "玉米杆"
S_NAMES.PLANT_PUMPKIN_L = "南瓜架"
S_NAMES.PLANT_EGGPLANT_L = "茄巢"
S_NAMES.PLANT_DURIAN_L = "榴莲柳"
S_NAMES.PLANT_POMEGRANATE_L = "石榴树"
S_NAMES.PLANT_DRAGONFRUIT_L = "火龙果树"
S_NAMES.PLANT_WATERMELON_L = "西瓜草"
S_NAMES.PLANT_PINEANANAS_L = "松萝树"
S_NAMES.PLANT_ONION_L = "洋葱圈"
S_NAMES.PLANT_PEPPER_L = "薄荷椒"
S_NAMES.PLANT_POTATO_L = "三地薯"
S_NAMES.PLANT_GARLIC_L = "鸡毛蒜"
S_NAMES.PLANT_TOMATO_L = "刺茄"
S_NAMES.PLANT_ASPARAGUS_L = "芦笋丛"
S_NAMES.PLANT_MANDRAKE_L = "培植曼草"
S_NAMES.PLANT_GOURD_L = "葫芦藤"

S______GENERIC.DESCRIBE.PLANT_CROP_L = {
    WITHERED = "已经枯萎了，就待春风吹又生...",
    SPROUT = "已经发芽了，接下来会是什么样子呢...",
    GROWING = "长吧，长吧，我会等到丰饶号角吹响的那天...",
    FLORESCENCE = "开花了，正是招蜂引蝶的好时候...",
    READY = "感谢我的付出与等待，更感谢自然的慷慨馈赠！",
}

S______GENERIC.DESCRIBE.SEEDS_CROP_L = "经过特殊环境催化，它已经变异了。"
-- S_______WILLOW.DESCRIBE.SEEDS_CROP_L = ""
-- S_____WOLFGANG.DESCRIBE.SEEDS_CROP_L = ""
-- S________WENDY.DESCRIBE.SEEDS_CROP_L = ""
-- S_________WX78.DESCRIBE.SEEDS_CROP_L = ""
S_WICKERBOTTOM.DESCRIBE.SEEDS_CROP_L = "这样的变异让它离无机物更近了一步。"
-- S_______WOODIE.DESCRIBE.SEEDS_CROP_L = ""
-- S______WAXWELL.DESCRIBE.SEEDS_CROP_L = ""
-- S___WATHGRITHR.DESCRIBE.SEEDS_CROP_L = ""
S_______WEBBER.DESCRIBE.SEEDS_CROP_L = "放心吧，我们不会用另类的眼光看待它。"
-- S_______WINONA.DESCRIBE.SEEDS_CROP_L = ""
-- S_______WORTOX.DESCRIBE.SEEDS_CROP_L = ""
S_____WORMWOOD.DESCRIBE.SEEDS_CROP_L = "宝宝，变了。"
-- S________WARLY.DESCRIBE.SEEDS_CROP_L = ""
-- S_________WURT.DESCRIBE.SEEDS_CROP_L = ""
-- S_______WALTER.DESCRIBE.SEEDS_CROP_L = ""
-- S________WANDA.DESCRIBE.SEEDS_CROP_L = ""

S_NAMES.SIVING_TURN = "子圭·育"
S_RECIPE_DESC.SIVING_TURN = "转昨日繁茂，生明日种种。"
S______GENERIC.DESCRIBE.SIVING_TURN = {
    GENERIC = "这是能重现昨日的时空穿梭机吗？",
    DONE = "包裹得很完整了，拿下来试试。",
    DOING = "放上去的东西被不明碎片包裹着。",
    NOENERGY = "这又不是永动机，找点它需要的能量吧。"
}
-- S_______WILLOW.DESCRIBE.SIVING_TURN = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_TURN = ""
-- S________WENDY.DESCRIBE.SIVING_TURN = ""
-- S_________WX78.DESCRIBE.SIVING_TURN = ""
S_WICKERBOTTOM.DESCRIBE.SIVING_TURN = {
    GENERIC = "包含了引力装置，看起来能放上某些物品。",
    DONE = "转化完成了，真像个茧。",
    DOING = "在进行某种特殊的基因转化。",
    NOENERGY = "能量用尽了，它的构成就是它的能源。"
}
-- S_______WOODIE.DESCRIBE.SIVING_TURN = ""
-- S______WAXWELL.DESCRIBE.SIVING_TURN = ""
-- S___WATHGRITHR.DESCRIBE.SIVING_TURN = ""
-- S_______WEBBER.DESCRIBE.SIVING_TURN = ""
-- S_______WINONA.DESCRIBE.SIVING_TURN = ""
S_______WORTOX.DESCRIBE.SIVING_TURN = {
    GENERIC = "没有翅膀，但却能够带着你到处飞翔。",
    DONE = "不管今天是什么结果，都是最好的安排。",
    DOING = "日子像旋转木马，在脑海里转不停。",
    NOENERGY = "再转一圈吧那些自作多情的相逢。"
}
S_____WORMWOOD.DESCRIBE.SIVING_TURN = {
    GENERIC = "摩天轮轮？",
    DONE = "小宝宝，在里面！",
    DOING = "转转转...",
    NOENERGY = "它饿了。"
}
-- S________WARLY.DESCRIBE.SIVING_TURN = ""
-- S_________WURT.DESCRIBE.SIVING_TURN = ""
-- S_______WALTER.DESCRIBE.SIVING_TURN = ""
-- S________WANDA.DESCRIBE.SIVING_TURN = ""

S_NAMES.SIVING_FEATHER_REAL = "子圭玄鸟正羽"
S______GENERIC.DESCRIBE.SIVING_FEATHER_REAL = "我已经迫不及待要把什么东西戳破了。"
S_______WILLOW.DESCRIBE.SIVING_FEATHER_REAL = "漫天飞羽！"
S_____WOLFGANG.DESCRIBE.SIVING_FEATHER_REAL = "锋利的飞刀。"
S________WENDY.DESCRIBE.SIVING_FEATHER_REAL = "太过锐利，会划伤我的手。"
-- S_________WX78.DESCRIBE.SIVING_FEATHER_REAL = ""
S_WICKERBOTTOM.DESCRIBE.SIVING_FEATHER_REAL = "岩石质感的羽毛，比看起来更锋利。"
-- S_______WOODIE.DESCRIBE.SIVING_FEATHER_REAL = ""
-- S______WAXWELL.DESCRIBE.SIVING_FEATHER_REAL = ""
S___WATHGRITHR.DESCRIBE.SIVING_FEATHER_REAL = "千刀万剐只不过是前奏。"
S_______WEBBER.DESCRIBE.SIVING_FEATHER_REAL = "你想动手吗？！"
-- S_______WINONA.DESCRIBE.SIVING_FEATHER_REAL = ""
S_______WORTOX.DESCRIBE.SIVING_FEATHER_REAL = "小玩意还会噬主，这可不兴用。"
-- S_____WORMWOOD.DESCRIBE.SIVING_FEATHER_REAL = ""
S________WARLY.DESCRIBE.SIVING_FEATHER_REAL = "对，我要把它们切成细丝儿！"
-- S_________WURT.DESCRIBE.SIVING_FEATHER_REAL = ""
S_______WALTER.DESCRIBE.SIVING_FEATHER_REAL = "比我的弹弓还好用。"
S________WANDA.DESCRIBE.SIVING_FEATHER_REAL = "真希望能它切断我的诅咒。"

S_NAMES.SIVING_FEATHER_FAKE = "子圭玄鸟绒羽"
S______GENERIC.DESCRIBE.SIVING_FEATHER_FAKE = "我要扇人了！扇你们每个人！"
-- S_______WILLOW.DESCRIBE.SIVING_FEATHER_FAKE = ""
S_____WOLFGANG.DESCRIBE.SIVING_FEATHER_FAKE = "不太锋利的飞刀。"
-- S________WENDY.DESCRIBE.SIVING_FEATHER_FAKE = ""
-- S_________WX78.DESCRIBE.SIVING_FEATHER_FAKE = ""
-- S_WICKERBOTTOM.DESCRIBE.SIVING_FEATHER_FAKE = ""
-- S_______WOODIE.DESCRIBE.SIVING_FEATHER_FAKE = ""
S______WAXWELL.DESCRIBE.SIVING_FEATHER_FAKE = "我和魔法一样狂野。"
S___WATHGRITHR.DESCRIBE.SIVING_FEATHER_FAKE = "没有架打那还能叫派对吗？"
S_______WEBBER.DESCRIBE.SIVING_FEATHER_FAKE = "比玩具飞镖好用一点。"
-- S_______WINONA.DESCRIBE.SIVING_FEATHER_FAKE = ""
S_______WORTOX.DESCRIBE.SIVING_FEATHER_FAKE = "很想试试和它比谁的速度快。"
-- S_____WORMWOOD.DESCRIBE.SIVING_FEATHER_FAKE = ""
-- S________WARLY.DESCRIBE.SIVING_FEATHER_FAKE = ""
-- S_________WURT.DESCRIBE.SIVING_FEATHER_FAKE = ""
S_______WALTER.DESCRIBE.SIVING_FEATHER_FAKE = "乐子，我要找些乐子，现在就要！"
-- S________WANDA.DESCRIBE.SIVING_FEATHER_FAKE = ""

S_NAMES.SIVING_FEATHER_LINE = "牵羽牵寻"
S______GENERIC.DESCRIBE.SIVING_FEATHER_LINE = "隐秘的丝线，牵动着每根羽毛的一端。"
S_______WILLOW.DESCRIBE.SIVING_FEATHER_LINE = "就像刀锋女王一样在战斗。"
-- S_____WOLFGANG.DESCRIBE.SIVING_FEATHER_LINE = ""
S________WENDY.DESCRIBE.SIVING_FEATHER_LINE = "有时候我会反思，阿比盖尔是否也像羽毛一般被我牵制。"
-- S_________WX78.DESCRIBE.SIVING_FEATHER_LINE = ""
S_WICKERBOTTOM.DESCRIBE.SIVING_FEATHER_LINE = "每次往复，丝线都可能会被扯断。"
S_______WOODIE.DESCRIBE.SIVING_FEATHER_LINE = "露西和我对这招太熟悉了。"
S______WAXWELL.DESCRIBE.SIVING_FEATHER_LINE = "羽毛如同傀儡，用来伤害而不是戏剧。"
S___WATHGRITHR.DESCRIBE.SIVING_FEATHER_LINE = "有翅膀的战士也应该学一下这招！"
S_______WEBBER.DESCRIBE.SIVING_FEATHER_LINE = "我们在玩悠悠球，你来吗？"
S_______WINONA.DESCRIBE.SIVING_FEATHER_LINE = "锋利的羽毛会在我的牵引下来回穿梭。"
S_______WORTOX.DESCRIBE.SIVING_FEATHER_LINE = "命运的红线，将你我拉扯纠缠。"
S_____WORMWOOD.DESCRIBE.SIVING_FEATHER_LINE = "拉锯战。"
S________WARLY.DESCRIBE.SIVING_FEATHER_LINE = "切菜也是有这种手法的，但我一般不用。"
-- S_________WURT.DESCRIBE.SIVING_FEATHER_LINE = ""
S_______WALTER.DESCRIBE.SIVING_FEATHER_LINE = "我也想给弹弓加这个，但没成功过。"
-- S________WANDA.DESCRIBE.SIVING_FEATHER_LINE = ""

S_NAMES.SIVING_MASK = "子圭·汲"
S_RECIPE_DESC.SIVING_MASK = "以命换命的戴价。"
S______GENERIC.DESCRIBE.SIVING_MASK = "一块会吸血的石头面具。"
S_______WILLOW.DESCRIBE.SIVING_MASK = "为我燃烧生命吧，卑微的仆人们！"
-- S_____WOLFGANG.DESCRIBE.SIVING_MASK = ""
S________WENDY.DESCRIBE.SIVING_MASK = "还好它不会伤害到阿比盖尔。"
-- S_________WX78.DESCRIBE.SIVING_MASK = ""
S_WICKERBOTTOM.DESCRIBE.SIVING_MASK = "使用了一种不好的魔法，不当使用会噬主。"
-- S_______WOODIE.DESCRIBE.SIVING_MASK = ""
S______WAXWELL.DESCRIBE.SIVING_MASK = "也许我能在这个面具下活得久一点。"
S___WATHGRITHR.DESCRIBE.SIVING_MASK = "卑鄙的败者才喜欢这样的伎俩。"
S_______WEBBER.DESCRIBE.SIVING_MASK = "我们都觉得这样做不对！" --因为蜘蛛是群居生物，韦伯善良，所以都不想使用这个装备
-- S_______WINONA.DESCRIBE.SIVING_MASK = ""
S_______WORTOX.DESCRIBE.SIVING_MASK = "戴上它就化身为不需要被邀请进屋的吸血鬼，啊哈哈哈！"
S_____WORMWOOD.DESCRIBE.SIVING_MASK = "它很少对朋友们产生敌意。"
S________WARLY.DESCRIBE.SIVING_MASK = "吃啥补啥，对吧。"
-- S_________WURT.DESCRIBE.SIVING_MASK = ""
-- S_______WALTER.DESCRIBE.SIVING_MASK = ""
S________WANDA.DESCRIBE.SIVING_MASK = "时间也会这样的魔法，慢慢带走所有人的生命。"

S_NAMES.SIVING_MASK_GOLD = "子圭·歃"
S_RECIPE_DESC.SIVING_MASK_GOLD = "生命呼叫转移。"
S______GENERIC.DESCRIBE.SIVING_MASK_GOLD = "一块玩弄生命的精致碎金面具。"
S_______WILLOW.DESCRIBE.SIVING_MASK_GOLD = "为火焰女王献上生命吧，卑微的仆人们！"
S_____WOLFGANG.DESCRIBE.SIVING_MASK_GOLD = "沃尔夫冈愿意献出自己成就他人。"
S________WENDY.DESCRIBE.SIVING_MASK_GOLD = "尝试过用它复活阿比盖尔，失败了，一如既往。"
S_________WX78.DESCRIBE.SIVING_MASK_GOLD = "被它复活时，我居然感受到了一点温暖。"
S_WICKERBOTTOM.DESCRIBE.SIVING_MASK_GOLD = "对生命魔法的控制更加成熟，不会伤到自己。"
S_______WOODIE.DESCRIBE.SIVING_MASK_GOLD = "早点想到它就能挽回露西了……"
S______WAXWELL.DESCRIBE.SIVING_MASK_GOLD = "我会隐藏身份，直到胜利的到来。"
S___WATHGRITHR.DESCRIBE.SIVING_MASK_GOLD = "堕落之主就擅用这样的手段。"
S_______WEBBER.DESCRIBE.SIVING_MASK_GOLD = "我们只会更加厌恶这种东西！"
S_______WINONA.DESCRIBE.SIVING_MASK_GOLD = "我的命运由我做主！"
S_______WORTOX.DESCRIBE.SIVING_MASK_GOLD = "戴上它就化身为肉身不灭的德古拉，呀哈哈哈！"
S_____WORMWOOD.DESCRIBE.SIVING_MASK_GOLD = "感觉不对。"
S________WARLY.DESCRIBE.SIVING_MASK_GOLD = "吃的是草，产的是超级棒的奶！"
-- S_________WURT.DESCRIBE.SIVING_MASK_GOLD = ""
-- S_______WALTER.DESCRIBE.SIVING_MASK_GOLD = ""
S________WANDA.DESCRIBE.SIVING_MASK_GOLD = "它比时间的魔法更高效与残忍。"

--------------------------------------------------------------------------
--[[ flash and crush ]]--[[ 电闪雷鸣 ]]
--------------------------------------------------------------------------

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
S_______WOODIE.DESCRIBE.TRIPLESHOVELAXE = "再好的斧头都代替不了露西。"
S______WAXWELL.DESCRIBE.TRIPLESHOVELAXE = "我怎么就没想到呢。"
S___WATHGRITHR.DESCRIBE.TRIPLESHOVELAXE = "披荆斩棘！"
-- S_______WEBBER.DESCRIBE.TRIPLESHOVELAXE = ""
-- S_______WINONA.DESCRIBE.TRIPLESHOVELAXE = ""
-- S________WARLY.DESCRIBE.TRIPLESHOVELAXE = ""
-- S_______WORTOX.DESCRIBE.TRIPLESHOVELAXE = ""
S_____WORMWOOD.DESCRIBE.TRIPLESHOVELAXE = "呕，伤害友谊的利器。"
-- S_________WURT.DESCRIBE.TRIPLESHOVELAXE = ""
-- S_______WALTER.DESCRIBE.TRIPLESHOVELAXE = ""
S________WANDA.DESCRIBE.TRIPLESHOVELAXE = "其他时空的我会准备好我所需要的一切。"

S_NAMES.TRIPLEGOLDENSHOVELAXE = "斧铲-黄金三用型"
S_RECIPE_DESC.TRIPLEGOLDENSHOVELAXE = "经久不衰的多功能工具。"
S______GENERIC.DESCRIBE.TRIPLEGOLDENSHOVELAXE = "低调奢华的多功能工具。"
-- S_______WILLOW.DESCRIBE.TRIPLEGOLDENSHOVELAXE = ""
S_____WOLFGANG.DESCRIBE.TRIPLEGOLDENSHOVELAXE = "沃尔夫冈要准备大干一番了！"
-- S________WENDY.DESCRIBE.TRIPLEGOLDENSHOVELAXE = ""
-- S_________WX78.DESCRIBE.TRIPLEGOLDENSHOVELAXE = ""
S_WICKERBOTTOM.DESCRIBE.TRIPLEGOLDENSHOVELAXE = "真是便携的野外生存工具。"
S_______WOODIE.DESCRIBE.TRIPLEGOLDENSHOVELAXE = "这东西太厉害了。噢，希望露西没听到。"
-- S______WAXWELL.DESCRIBE.TRIPLEGOLDENSHOVELAXE = ""
-- S___WATHGRITHR.DESCRIBE.TRIPLEGOLDENSHOVELAXE = ""
-- S_______WEBBER.DESCRIBE.TRIPLEGOLDENSHOVELAXE = ""
S_______WINONA.DESCRIBE.TRIPLEGOLDENSHOVELAXE = "我的工具箱里就该多装几把这样的东西。"
-- S_______WORTOX.DESCRIBE.TRIPLEGOLDENSHOVELAXE = ""
S_____WORMWOOD.DESCRIBE.TRIPLEGOLDENSHOVELAXE = "怕怕，这东东被诅咒了，快丢掉。"
S________WARLY.DESCRIBE.TRIPLEGOLDENSHOVELAXE = "把自然资源像蛋糕一样吃干抹净吧！"
-- S_________WURT.DESCRIBE.TRIPLEGOLDENSHOVELAXE = ""
-- S_______WALTER.DESCRIBE.TRIPLEGOLDENSHOVELAXE = ""
S________WANDA.DESCRIBE.TRIPLEGOLDENSHOVELAXE = "我不介意带一把在身上。"

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

S_NAMES.EXPLODINGFRUITCAKE = "爆炸水果蛋糕"
S_RECIPE_DESC.EXPLODINGFRUITCAKE = "甜啦，是炸蛋耶。"
S______GENERIC.DESCRIBE.EXPLODINGFRUITCAKE = "充满恶意的礼物。"
S_______WILLOW.DESCRIBE.EXPLODINGFRUITCAKE = "爆炸，爆炸，都炸了吧。"
-- S_____WOLFGANG.DESCRIBE.EXPLODINGFRUITCAKE = ""
S________WENDY.DESCRIBE.EXPLODINGFRUITCAKE = "是我做的，那又怎样..."
S_________WX78.DESCRIBE.EXPLODINGFRUITCAKE = "仔细分析，这会不会是我做的？"
S_WICKERBOTTOM.DESCRIBE.EXPLODINGFRUITCAKE = "如何引爆呢，点燃还是咬下？"
-- S_______WOODIE.DESCRIBE.EXPLODINGFRUITCAKE = ""
S______WAXWELL.DESCRIBE.EXPLODINGFRUITCAKE = "我们与恶的距离..."
S___WATHGRITHR.DESCRIBE.EXPLODINGFRUITCAKE = "光明正大的比试才是我的风格！"
S_______WEBBER.DESCRIBE.EXPLODINGFRUITCAKE = "哇，是蛋糕耶！"
S_______WINONA.DESCRIBE.EXPLODINGFRUITCAKE = "一点技术含量都没有，引线这么明显？！"
S_______WORTOX.DESCRIBE.EXPLODINGFRUITCAKE = "本人可不会做这种会搞出人命的恶作剧！"
S_____WORMWOOD.DESCRIBE.EXPLODINGFRUITCAKE = "甜甜的，好想咬一口。"
S________WARLY.DESCRIBE.EXPLODINGFRUITCAKE = "糖衣炮弹，可得小心。"
-- S_________WURT.DESCRIBE.EXPLODINGFRUITCAKE = ""
-- S_______WALTER.DESCRIBE.EXPLODINGFRUITCAKE = ""
S________WANDA.DESCRIBE.EXPLODINGFRUITCAKE = "还好我有时间阻止这场悲剧。"

--------------------------------------------------------------------------
--[[ desert secret ]]--[[ 尘市蜃楼 ]]
--------------------------------------------------------------------------

S_NAMES.SHIELD_L_SAND = "砂之抵御"
S_RECIPE_DESC.SHIELD_L_SAND = "借用大地的力量，保护与反击。"
S______GENERIC.DESCRIBE.SHIELD_L_SAND =
{
    GENERIC = "我能感受到其中大地的力量，应该吧。",
    WEAK = "这雨切断了它与大地的联系！",
    INSANE = "我已经无法集中精神了！",
}
S_______WILLOW.DESCRIBE.SHIELD_L_SAND = "还好它不防火，不然本姑娘可要生气了。"
--S_____WOLFGANG.DESCRIBE.SHIELD_L_SAND = ""
S________WENDY.DESCRIBE.SHIELD_L_SAND = "我不能一直逃避，我总得去面对一切。"
S_________WX78.DESCRIBE.SHIELD_L_SAND = "防火墙，启动！"
S_WICKERBOTTOM.DESCRIBE.SHIELD_L_SAND = "它的魔法可以保护我免于雷电。"
--S_______WOODIE.DESCRIBE.SHIELD_L_SAND = ""
--S______WAXWELL.DESCRIBE.SHIELD_L_SAND = ""
--S_______WEBBER.DESCRIBE.SHIELD_L_SAND = ""
S___WATHGRITHR.DESCRIBE.SHIELD_L_SAND = "作我明镜，作我利剑与护盾！"
--S_______WINONA.DESCRIBE.SHIELD_L_SAND = ""


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

S_NAMES.MAT_WHITEWOOD_ITEM = "白木地垫"
S_RECIPE_DESC.MAT_WHITEWOOD_ITEM = "双脚体验木质感。"
S______GENERIC.DESCRIBE.MAT_WHITEWOOD_ITEM = "装饰地面的白色木片。"
-- S_______WILLOW.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
-- S_____WOLFGANG.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
-- S________WENDY.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
-- S_________WX78.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
-- S_WICKERBOTTOM.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
-- S_______WOODIE.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
S______WAXWELL.DESCRIBE.MAT_WHITEWOOD_ITEM = "地上垫了一层让我更有踏实的感觉。"
-- S___WATHGRITHR.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
-- S_______WEBBER.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
-- S_______WINONA.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
-- S_______WORTOX.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
-- S_____WORMWOOD.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
-- S________WARLY.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
-- S_________WURT.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
-- S_______WALTER.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
-- S________WANDA.DESCRIBE.MAT_WHITEWOOD_ITEM = ""

--------------------------------------------------------------------------
--[[ tips ]]--[[ 加载台词 ]]
--------------------------------------------------------------------------

local SURVIVAL_TIPS = { --介绍探险技巧
    "对付暴怒状态的莱克阿米特，砂之抵御、雨帽和眼球伞等防电装备是很必要的……",
    "颤栗花对接触非常敏感，会被靠近的生物吓得枯萎，如果我有芳香气味的伪装就能靠近它了吧。",
    "在我进行基地大装修时，偶然发现人造地皮居然能阻止颤栗树的再生，对它的了解又多了一层……",
    "《多变的云》里的知识水分非常重，字面意思。",
    "今晚没有月亮，朋友不知道在冰箱捣鼓什么，我昏沉睡去。醒来发现每个烹饪锅都盛满了诡异笑脸的黑色蛋糕……",
    "沃拓克斯煎了一条甜味鱼，说是送我。香气扑鼻，我大口吃下，还在诧异平日自私的他怎么会请我吃如此美味……",
    "当你看见水果蛋糕里有条引线，请不要抱有吃它的想法。就算真的吃了，也不会送你水果的。",
    "白色的蘑菇帽产生的孢子有很强的的药用价值。生理上，能增强抵抗力，物理上，沾满皮肤也能减少我受到的伤害。",
    "靠近某块奇异的巨石后我突发奇想做出来了几种多功能工具，它们用起来实在是太方便了，我觉得我就是个天才……",
    "专业的钓鱼者都会提前给鱼儿们打窝，不仅能吸引不同的鱼类，提高钓鱼效率，而且有时甚至会吸引到一些不速之客。",
    "我觉得，蟹族因其当时的科技或魔法水平不够，只能将子圭神木岩封印到地下，但现在就不同了，我们能用先进的思想与技术将其为我所用……",
    "子圭·垄中蕴含了足够的生命力，能维持作物不断循环生长。",
    "像宽大的木墩和活木这些木料，堆在一起就可以培植孢子植物了。不过这类植物似乎很怕冷，总是活不过大雪皑皑。",
    "小时候奶奶经常跟我说，雨蝇是益虫，逝去时会导致下雨。至今，我都记着她这句话。",
    "作物总是产生烦人的害虫，整天跟着我嗡嗡嗡嗡，还咬我。我受不了了，我一定要找到消灭它们的办法。今天我就把话撂在这儿了……",
    "靠背熊真是太可爱了，恨不得天天撸它的毛，而且它还特别喜欢趴我背上。虽然在背上时我看不到它在干嘛，但是非常温暖。诶？我的曼德拉草汤和冰激凌去哪了……",
}
local LORE_TIPS = { --介绍故事背景
    "传言沙漠里藏着一位女巫，也许有天我能找到她，听她娓娓道来那悲惨的故事。",
    "天外飞仙，噬命以滋养玄鸟。蟹类倾族所有，移至洞坑，炸其入地脉，遂不见天日。",
    "莱克阿米特每次被打败都会反思，精进技巧提升力量，至今没人知道它的上限到底在哪。",
    "灵魂契约和众多无辜灵魂签下了不平等契约，唯独与其主人不会签订协议，大概是他还有利用价值吧……",
    "有一把不常见的花刃剑，坚硬洁白，能不断保护它的主人，当主人遇到致命威胁时甚至会断掉自己使主人得以保命。",
}
local CONTROL_TIPS_NOT_CONSOLE = { --介绍键鼠控制
    "盾击动作的前8帧内被攻击，就能成功触发盾反。",
}

for i,str in ipairs(SURVIVAL_TIPS) do
    AddLoadingTip(STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_L"..tostring(i), "“"..str.."”-W")
end
for i,str in ipairs(LORE_TIPS) do
    AddLoadingTip(STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_L"..tostring(i), str)
end
for i,str in ipairs(CONTROL_TIPS_NOT_CONSOLE) do
    AddLoadingTip(STRINGS.UI.LOADING_SCREEN_OTHER_TIPS, "TIP_L"..tostring(i), str)
end

SURVIVAL_TIPS = nil
LORE_TIPS = nil
CONTROL_TIPS_NOT_CONSOLE = nil

-- 设置mod提示的权重
SetLoadingTipCategoryWeights(LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_START,
    { CONTROLS = 1, SURVIVAL = 1, LORE = 1, LOADING_SCREEN = 1, OTHER = 5 })
SetLoadingTipCategoryWeights(LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_END,
    { CONTROLS = 1, SURVIVAL = 1, LORE = 1, LOADING_SCREEN = 1, OTHER = 5 })

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

S_NAMES.SHIELD_L_LOG = "木盾"
S_RECIPE_DESC.SHIELD_L_LOG = "防御与反击的初步尝试。"
S______GENERIC.DESCRIBE.SHIELD_L_LOG = "好简陋的盾牌，也许能用用看。"
-- S_______WILLOW.DESCRIBE.SHIELD_L_LOG = ""
S_____WOLFGANG.DESCRIBE.SHIELD_L_LOG = "上面的涂鸦有点艺术感呢。"
-- S________WENDY.DESCRIBE.SHIELD_L_LOG = ""
-- S_________WX78.DESCRIBE.SHIELD_L_LOG = ""
-- S_WICKERBOTTOM.DESCRIBE.SHIELD_L_LOG = ""
S_______WOODIE.DESCRIBE.SHIELD_L_LOG = "不是很趁手。"
S______WAXWELL.DESCRIBE.SHIELD_L_LOG = "我才不要拿着个破盾在那傻傻地挥来挥去。"
S___WATHGRITHR.DESCRIBE.SHIELD_L_LOG = "为勇士们提供了新的战斗思路。"
-- S_______WEBBER.DESCRIBE.SHIELD_L_LOG = ""
-- S_______WINONA.DESCRIBE.SHIELD_L_LOG = ""
S_______WORTOX.DESCRIBE.SHIELD_L_LOG = "躲不开的时候溜走就行了，哪还需要这破盾。"
S_____WORMWOOD.DESCRIBE.SHIELD_L_LOG = "呜呜，朋友身躯成了我的壁垒。"
-- S________WARLY.DESCRIBE.SHIELD_L_LOG = ""
-- S_________WURT.DESCRIBE.SHIELD_L_LOG = ""
-- S_______WALTER.DESCRIBE.SHIELD_L_LOG = ""
-- S________WANDA.DESCRIBE.SHIELD_L_LOG = ""

STRINGS.ACTIONS_LEGION = {
    PLAYGUITAR = "弹", --弹琴动作的名字
    STORE_BEEF_L = "存放", --右键给予牛物品动作的名字
    FEED_BEEF_L = "喂食", --左键给牛喂食
    RETURN_CONTRACTS = "解", --从契约书索取灵魂的名字
    PICKUP_CONTRACTS = "收", --捡起契约书的名字
    GIVE_CONTRACTS = "契", --给予灵魂给契约书的名字
    PULLOUTSWORD = "出鞘", --拔剑出鞘动作的名字
    USE_UPGRADEKIT = "组装升级", --升级套件的升级动作的名字
    MAKE = "制作", --打窝器容器的按钮名字
    ATTACK_SHIELD_L = "盾击", --盾牌类道具通用动作的名字
}
STRINGS.ACTIONS.GIVE.SCABBARD = "入鞘"  --青枝绿叶放入武器的名字
STRINGS.ACTIONS.PICK.GENETRANS = "解开"  --收获子圭·育的名字

STRINGS.ACTIONS.OPEN_CRAFTING.RECAST = "激发灵感" --靠近解锁时的前置提示。名字与AddPrototyperDef里的action_str一致
STRINGS.UI.CRAFTING_STATION_FILTERS.RECAST = "重铸"
STRINGS.UI.CRAFTING_FILTERS.RECAST = "重铸"

--NEEDS..新tech的名字
STRINGS.UI.CRAFTING.NEEDSELECOURMALINE_ONE = "寻找电气重铸台激发灵感！"
STRINGS.UI.CRAFTING.NEEDSELECOURMALINE_TWO = "看起来这个重铸台没有被完全激活！"
STRINGS.UI.CRAFTING.NEEDSELECOURMALINE_THREE = "寻找激活的电气重铸台激发灵感！"

STRINGS.ACTIONS.REPAIR_LEGION = {
    GENERIC = "修理",
    MERGE = "合并",
}
S______GENERIC.ACTIONFAIL.REPAIR_LEGION = {
    GUITAR = "很新，没啥好修的。",
    FUNGUS = "很新鲜，不用修了。",
    MAT = "已经是最大的样子了。",
}
-- S_______WILLOW.ACTIONFAIL.REPAIR_LEGION =
-- S_____WOLFGANG.ACTIONFAIL.REPAIR_LEGION =
-- S________WENDY.ACTIONFAIL.REPAIR_LEGION =
-- S_________WX78.ACTIONFAIL.REPAIR_LEGION =
-- S_WICKERBOTTOM.ACTIONFAIL.REPAIR_LEGION =
-- S_______WOODIE.ACTIONFAIL.REPAIR_LEGION =
-- S______WAXWELL.ACTIONFAIL.REPAIR_LEGION =
-- S___WATHGRITHR.ACTIONFAIL.REPAIR_LEGION =
S_______WEBBER.ACTIONFAIL.REPAIR_LEGION = {
    GUITAR = "没我们事啦。",
    FUNGUS = "我们好几只眼睛都看不出哪里坏了。",
    MAT = "好，够啦。",
}
S_______WINONA.ACTIONFAIL.REPAIR_LEGION = {
    GUITAR = "完美如初。",
    FUNGUS = "很完整了。",
    MAT = "我想这是它能保持坚固的最大极限了。",
}
-- S_______WORTOX.ACTIONFAIL.REPAIR_LEGION =
-- S_____WORMWOOD.ACTIONFAIL.REPAIR_LEGION =
-- S________WARLY.ACTIONFAIL.REPAIR_LEGION =
-- S_________WURT.ACTIONFAIL.REPAIR_LEGION =
-- S_______WALTER.ACTIONFAIL.REPAIR_LEGION =

STRINGS.CROP_LEGION = {
    SEED = "种下的{crop}种子",
    SPROUT = "{crop}芽",
    SMALL = "{crop}苗",
    GROWING = "在生长的{crop}",
    GROWN = "成熟的{crop}",
    HUGE = "丰硕的{crop}",
    ROT = "枯萎的{crop}",
    HUGE_ROT = "腐烂的丰硕{crop}",
}
S______GENERIC.ACTIONFAIL.POUR_WATER_LEGION = S______GENERIC.ACTIONFAIL.POUR_WATER_GROUNDTILE
S_______WILLOW.ACTIONFAIL.POUR_WATER_LEGION = S_______WILLOW.ACTIONFAIL.POUR_WATER_GROUNDTILE
S_____WOLFGANG.ACTIONFAIL.POUR_WATER_LEGION = S_____WOLFGANG.ACTIONFAIL.POUR_WATER_GROUNDTILE
S________WENDY.ACTIONFAIL.POUR_WATER_LEGION = S________WENDY.ACTIONFAIL.POUR_WATER_GROUNDTILE
S_________WX78.ACTIONFAIL.POUR_WATER_LEGION = S_________WX78.ACTIONFAIL.POUR_WATER_GROUNDTILE
S_WICKERBOTTOM.ACTIONFAIL.POUR_WATER_LEGION = S_WICKERBOTTOM.ACTIONFAIL.POUR_WATER_GROUNDTILE
S_______WOODIE.ACTIONFAIL.POUR_WATER_LEGION = S_______WOODIE.ACTIONFAIL.POUR_WATER_GROUNDTILE
S______WAXWELL.ACTIONFAIL.POUR_WATER_LEGION = S______WAXWELL.ACTIONFAIL.POUR_WATER_GROUNDTILE
S___WATHGRITHR.ACTIONFAIL.POUR_WATER_LEGION = S___WATHGRITHR.ACTIONFAIL.POUR_WATER_GROUNDTILE
S_______WEBBER.ACTIONFAIL.POUR_WATER_LEGION = S_______WEBBER.ACTIONFAIL.POUR_WATER_GROUNDTILE
S_______WINONA.ACTIONFAIL.POUR_WATER_LEGION = S_______WINONA.ACTIONFAIL.POUR_WATER_GROUNDTILE
S_______WORTOX.ACTIONFAIL.POUR_WATER_LEGION = S_______WORTOX.ACTIONFAIL.POUR_WATER_GROUNDTILE
S_____WORMWOOD.ACTIONFAIL.POUR_WATER_LEGION = S_____WORMWOOD.ACTIONFAIL.POUR_WATER_GROUNDTILE
S________WARLY.ACTIONFAIL.POUR_WATER_LEGION = S________WARLY.ACTIONFAIL.POUR_WATER_GROUNDTILE
S_________WURT.ACTIONFAIL.POUR_WATER_LEGION = S_________WURT.ACTIONFAIL.POUR_WATER_GROUNDTILE
S_______WALTER.ACTIONFAIL.POUR_WATER_LEGION = S_______WALTER.ACTIONFAIL.POUR_WATER_GROUNDTILE
S________WANDA.ACTIONFAIL.POUR_WATER_LEGION = S________WANDA.ACTIONFAIL.POUR_WATER_GROUNDTILE

STRINGS.ACTIONS.EXSTAY_CONTRACTS = {
    GENERIC = "随",
    STAY = "止"
}
S______GENERIC.ACTIONFAIL.EXSTAY_CONTRACTS = {
    NORIGHT = "它不听我的使唤。",
    ONLYONE = S______GENERIC.DESCRIBE.SOUL_CONTRACTS.ONLYONE
}
-- S_______WILLOW.ACTIONFAIL.EXSTAY_CONTRACTS =
-- S_____WOLFGANG.ACTIONFAIL.EXSTAY_CONTRACTS =
-- S________WENDY.ACTIONFAIL.EXSTAY_CONTRACTS =
-- S_________WX78.ACTIONFAIL.EXSTAY_CONTRACTS =
S_WICKERBOTTOM.ACTIONFAIL.EXSTAY_CONTRACTS = {
    NORIGHT = "封面上的署名此时不是我。",
    ONLYONE = (S_WICKERBOTTOM.DESCRIBE.SOUL_CONTRACTS or S______GENERIC.DESCRIBE.SOUL_CONTRACTS).ONLYONE
}
-- S_______WOODIE.ACTIONFAIL.EXSTAY_CONTRACTS =
S______WAXWELL.ACTIONFAIL.EXSTAY_CONTRACTS = {
    NORIGHT = "我在权力的更替中被淘汰了。",
    ONLYONE = (S______WAXWELL.DESCRIBE.SOUL_CONTRACTS or S______GENERIC.DESCRIBE.SOUL_CONTRACTS).ONLYONE
}
-- S___WATHGRITHR.ACTIONFAIL.EXSTAY_CONTRACTS =
-- S_______WEBBER.ACTIONFAIL.EXSTAY_CONTRACTS =
-- S_______WINONA.ACTIONFAIL.EXSTAY_CONTRACTS =
S_______WORTOX.ACTIONFAIL.EXSTAY_CONTRACTS = {
    NORIGHT = "我堂堂灵魂界窃瓦辛格，还使唤不了你了？！",
    ONLYONE = (S_______WORTOX.DESCRIBE.SOUL_CONTRACTS or S______GENERIC.DESCRIBE.SOUL_CONTRACTS).ONLYONE
}
-- S_____WORMWOOD.ACTIONFAIL.EXSTAY_CONTRACTS =
-- S________WARLY.ACTIONFAIL.EXSTAY_CONTRACTS =
-- S_________WURT.ACTIONFAIL.EXSTAY_CONTRACTS =
-- S_______WALTER.ACTIONFAIL.EXSTAY_CONTRACTS =
S________WANDA.ACTIONFAIL.EXSTAY_CONTRACTS = {
    NORIGHT = "算了，反正它用处也不大。",
    ONLYONE = (S________WANDA.DESCRIBE.SOUL_CONTRACTS or S______GENERIC.DESCRIBE.SOUL_CONTRACTS).ONLYONE
}

S______GENERIC.ACTIONFAIL.PICKUP_CONTRACTS = S______GENERIC.ACTIONFAIL.EXSTAY_CONTRACTS
-- S_______WILLOW.ACTIONFAIL.PICKUP_CONTRACTS =
-- S_____WOLFGANG.ACTIONFAIL.PICKUP_CONTRACTS =
-- S________WENDY.ACTIONFAIL.PICKUP_CONTRACTS =
-- S_________WX78.ACTIONFAIL.PICKUP_CONTRACTS =
S_WICKERBOTTOM.ACTIONFAIL.PICKUP_CONTRACTS = S_WICKERBOTTOM.ACTIONFAIL.EXSTAY_CONTRACTS
-- S_______WOODIE.ACTIONFAIL.PICKUP_CONTRACTS =
S______WAXWELL.ACTIONFAIL.PICKUP_CONTRACTS = S______WAXWELL.ACTIONFAIL.EXSTAY_CONTRACTS
-- S___WATHGRITHR.ACTIONFAIL.PICKUP_CONTRACTS =
-- S_______WEBBER.ACTIONFAIL.PICKUP_CONTRACTS =
-- S_______WINONA.ACTIONFAIL.PICKUP_CONTRACTS =
S_______WORTOX.ACTIONFAIL.PICKUP_CONTRACTS = S_______WORTOX.ACTIONFAIL.EXSTAY_CONTRACTS
-- S_____WORMWOOD.ACTIONFAIL.PICKUP_CONTRACTS =
-- S________WARLY.ACTIONFAIL.PICKUP_CONTRACTS =
-- S_________WURT.ACTIONFAIL.PICKUP_CONTRACTS =
-- S_______WALTER.ACTIONFAIL.PICKUP_CONTRACTS =
S________WANDA.ACTIONFAIL.PICKUP_CONTRACTS = S________WANDA.ACTIONFAIL.EXSTAY_CONTRACTS

STRINGS.ACTIONS.PLANTSOIL_LEGION = {
    GENERIC = "栽种",
    DISPLAY = "重新栽种"
}

STRINGS.ACTIONS.GENETRANS = {
    GENERIC = "放入",
    CHARGE = "充能",
}
S______GENERIC.ACTIONFAIL.GENETRANS = {
    DONE = "先把转化好的取下来吧。",
    GROWING = "已经有东西在转化了。",
    ENERGYOUT = "它需要充能后才能启动。",
    WRONGITEM = "这不是它能转化的。",
    ENERGYMAX = "它已经充满了生命的能量。"
}
-- S_______WILLOW.ACTIONFAIL.GENETRANS =
-- S_____WOLFGANG.ACTIONFAIL.GENETRANS =
-- S________WENDY.ACTIONFAIL.GENETRANS =
-- S_________WX78.ACTIONFAIL.GENETRANS =
-- S_WICKERBOTTOM.ACTIONFAIL.GENETRANS =
-- S_______WOODIE.ACTIONFAIL.GENETRANS =
-- S______WAXWELL.ACTIONFAIL.GENETRANS =
-- S___WATHGRITHR.ACTIONFAIL.GENETRANS =
-- S_______WEBBER.ACTIONFAIL.GENETRANS =
-- S_______WINONA.ACTIONFAIL.GENETRANS =
-- S_______WORTOX.ACTIONFAIL.GENETRANS =
-- S_____WORMWOOD.ACTIONFAIL.GENETRANS =
S________WARLY.ACTIONFAIL.GENETRANS = {
    DONE = "一个盘子只能摆一道菜！",
    GROWING = "一口锅一次只能做一种菜！",
    NOENERGY = "这炉子没火了。",
    WRONGITEM = "错误的食材。",
    ENERGYMAX = "已经到达了最大火力。"
}
-- S_________WURT.ACTIONFAIL.GENETRANS =
-- S_______WALTER.ACTIONFAIL.GENETRANS =
-- S________WANDA.ACTIONFAIL.GENETRANS =

S______GENERIC.ACTIONFAIL.STORE_BEEF_L = S______GENERIC.ACTIONFAIL.STORE
S_______WILLOW.ACTIONFAIL.STORE_BEEF_L = S_______WILLOW.ACTIONFAIL.STORE
S_____WOLFGANG.ACTIONFAIL.STORE_BEEF_L = S_____WOLFGANG.ACTIONFAIL.STORE
S________WENDY.ACTIONFAIL.STORE_BEEF_L = S________WENDY.ACTIONFAIL.STORE
S_________WX78.ACTIONFAIL.STORE_BEEF_L = S_________WX78.ACTIONFAIL.STORE
S_WICKERBOTTOM.ACTIONFAIL.STORE_BEEF_L = S_WICKERBOTTOM.ACTIONFAIL.STORE
S_______WOODIE.ACTIONFAIL.STORE_BEEF_L = S_______WOODIE.ACTIONFAIL.STORE
S______WAXWELL.ACTIONFAIL.STORE_BEEF_L = S______WAXWELL.ACTIONFAIL.STORE
S___WATHGRITHR.ACTIONFAIL.STORE_BEEF_L = S___WATHGRITHR.ACTIONFAIL.STORE
S_______WEBBER.ACTIONFAIL.STORE_BEEF_L = S_______WEBBER.ACTIONFAIL.STORE
S_______WINONA.ACTIONFAIL.STORE_BEEF_L = S_______WINONA.ACTIONFAIL.STORE
S_______WORTOX.ACTIONFAIL.STORE_BEEF_L = S_______WORTOX.ACTIONFAIL.STORE
S_____WORMWOOD.ACTIONFAIL.STORE_BEEF_L = S_____WORMWOOD.ACTIONFAIL.STORE
S________WARLY.ACTIONFAIL.STORE_BEEF_L = S________WARLY.ACTIONFAIL.STORE
S_________WURT.ACTIONFAIL.STORE_BEEF_L = S_________WURT.ACTIONFAIL.STORE
S_______WALTER.ACTIONFAIL.STORE_BEEF_L = S_______WALTER.ACTIONFAIL.STORE
S________WANDA.ACTIONFAIL.STORE_BEEF_L = S________WANDA.ACTIONFAIL.STORE

S______GENERIC.ACTIONFAIL.FEED_BEEF_L = S______GENERIC.ACTIONFAIL.GIVE
S_______WILLOW.ACTIONFAIL.FEED_BEEF_L = S_______WILLOW.ACTIONFAIL.GIVE
S_____WOLFGANG.ACTIONFAIL.FEED_BEEF_L = S_____WOLFGANG.ACTIONFAIL.GIVE
S________WENDY.ACTIONFAIL.FEED_BEEF_L = S________WENDY.ACTIONFAIL.GIVE
S_________WX78.ACTIONFAIL.FEED_BEEF_L = S_________WX78.ACTIONFAIL.GIVE
S_WICKERBOTTOM.ACTIONFAIL.FEED_BEEF_L = S_WICKERBOTTOM.ACTIONFAIL.GIVE
S_______WOODIE.ACTIONFAIL.FEED_BEEF_L = S_______WOODIE.ACTIONFAIL.GIVE
S______WAXWELL.ACTIONFAIL.FEED_BEEF_L = S______WAXWELL.ACTIONFAIL.GIVE
S___WATHGRITHR.ACTIONFAIL.FEED_BEEF_L = S___WATHGRITHR.ACTIONFAIL.GIVE
S_______WEBBER.ACTIONFAIL.FEED_BEEF_L = S_______WEBBER.ACTIONFAIL.GIVE
S_______WINONA.ACTIONFAIL.FEED_BEEF_L = S_______WINONA.ACTIONFAIL.GIVE
S_______WORTOX.ACTIONFAIL.FEED_BEEF_L = S_______WORTOX.ACTIONFAIL.GIVE
S_____WORMWOOD.ACTIONFAIL.FEED_BEEF_L = S_____WORMWOOD.ACTIONFAIL.GIVE
S________WARLY.ACTIONFAIL.FEED_BEEF_L = S________WARLY.ACTIONFAIL.GIVE
S_________WURT.ACTIONFAIL.FEED_BEEF_L = S_________WURT.ACTIONFAIL.GIVE
S_______WALTER.ACTIONFAIL.FEED_BEEF_L = S_______WALTER.ACTIONFAIL.GIVE
S________WANDA.ACTIONFAIL.FEED_BEEF_L = S________WANDA.ACTIONFAIL.GIVE

STRINGS.ACTIONS.RC_SKILL_L = {
    GENERIC = "施法",
    FEATHERTHROW = "羽刃分掷",
    FEATHERPULL = "羽刃合收"
}

STRINGS.ACTIONS.LIFEBEND = {
    GENERIC = "恢复生机",
    REVIVE = "以命换命",
    CURE = "治愈"
}
S______GENERIC.ACTIONFAIL.LIFEBEND = {
    NOLIFE = "我给不了更多生命了。",
    GHOST = "它的灵魂已经残缺到无法挽回的地步。",
    NOTHURT = "生命足够，不需要我输送。",
    NOWITHERED = "它长得好好的，没问题！"
}
-- S_______WILLOW.ACTIONFAIL.LIFEBEND =
-- S_____WOLFGANG.ACTIONFAIL.LIFEBEND =
S________WENDY.ACTIONFAIL.LIFEBEND = {
    NOLIFE = "我的生命已经见底，还要想着付出吗。",
    GHOST = "虽然尝试过很多次，但我还不想放弃。",
    NOTHURT = "你不再需要我了，对吗？",
    NOWITHERED = "看看你，长得太好了，一生也还完美。"
}
S_________WX78.ACTIONFAIL.LIFEBEND = {
    NOLIFE = "警告：自我生命能量不足！",
    GHOST = "我居然会尝试复活一个孤魂野鬼。",
    NOTHURT = "扫描：机能正常。",
    NOWITHERED = "扫描：状态正常。"
}
-- S_WICKERBOTTOM.ACTIONFAIL.LIFEBEND =
-- S_______WOODIE.ACTIONFAIL.LIFEBEND =
-- S______WAXWELL.ACTIONFAIL.LIFEBEND =
-- S___WATHGRITHR.ACTIONFAIL.LIFEBEND =
-- S_______WEBBER.ACTIONFAIL.LIFEBEND =
-- S_______WINONA.ACTIONFAIL.LIFEBEND =
-- S________WARLY.ACTIONFAIL.LIFEBEND =
-- S_______WORTOX.ACTIONFAIL.LIFEBEND =
S_____WORMWOOD.ACTIONFAIL.LIFEBEND = {
    NOLIFE = "养分不够。",
    GHOST = "没反应。",
    NOTHURT = "健康。",
    NOWITHERED = "茁壮！"
}
-- S_________WURT.ACTIONFAIL.LIFEBEND =
-- S_______WALTER.ACTIONFAIL.LIFEBEND =
-- S________WANDA.ACTIONFAIL.LIFEBEND =
