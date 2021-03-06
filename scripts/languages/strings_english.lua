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

TUNING.LEGION_MOD_LANGUAGES = "english"

--------------------------------------------------------------------------
--[[ the little star in the cave ]]--[[ 洞穴里的星光点点 ]]
--------------------------------------------------------------------------

S_NAMES.HAT_LICHEN = "Lichen Hairpin"
S_RECIPE_DESC.HAT_LICHEN = "I have an \"idea\", like cartoons."
S______GENERIC.DESCRIBE.HAT_LICHEN = "I have an \"idea\", for real!"
S_______WILLOW.DESCRIBE.HAT_LICHEN = "You can't really LIGHT"
S_____WOLFGANG.DESCRIBE.HAT_LICHEN = "Glowy little gadget."
S________WENDY.DESCRIBE.HAT_LICHEN = "Abigail used to wear a hairpin like this on Sundays..."
S_________WX78.DESCRIBE.HAT_LICHEN = "TEMPORARY ORGANIC SOURCE OF LIGHT."
S_WICKERBOTTOM.DESCRIBE.HAT_LICHEN = "Literally radiant...pun intended."
S_______WOODIE.DESCRIBE.HAT_LICHEN = "It ain't get along with the hairy."
S______WAXWELL.DESCRIBE.HAT_LICHEN = "That's such a disgrace!"
--S___WATHGRITHR.DESCRIBE.HAT_LICHEN = ""
S_______WEBBER.DESCRIBE.HAT_LICHEN = "Wendy! Come see our new hairpin!"
S_______WINONA.DESCRIBE.HAT_LICHEN = "For illumination, I'd better put it on for now."
S_____WORMWOOD.DESCRIBE.HAT_LICHEN = "I'dah put a glowy buddy on my head!"
S_________WURT.DESCRIBE.HAT_LICHEN = "It should be eaten, "

--------------------------------------------------------------------------
--[[ the power of flowers ]]--[[ 花香四溢 ]]
--------------------------------------------------------------------------

S_NAMES.ROSORNS = "Rosorns"
S______GENERIC.DESCRIBE.ROSORNS = "Roses always touch my heart directly."
--S_______WILLOW.DESCRIBE.ROSORNS = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.ROSORNS = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.ROSORNS = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.ROSORNS = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.ROSORNS = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.ROSORNS = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.ROSORNS = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.ROSORNS = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.ROSORNS = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.ROSORNS = "Great to cool off after some hard physical labor."

S_NAMES.LILEAVES = "Lileaves"
S______GENERIC.DESCRIBE.LILEAVES = "I was deeply poisoned by loving it."
--S_______WILLOW.DESCRIBE.LILEAVES = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.LILEAVES = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.LILEAVES = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.LILEAVES = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.LILEAVES = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.LILEAVES = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.LILEAVES = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.LILEAVES = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.LILEAVES = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.LILEAVES = "Great to cool off after some hard physical labor."

S_NAMES.ORCHITWIGS = "Orchitwigs"
S______GENERIC.DESCRIBE.ORCHITWIGS = "It's not striking, but I just like it."
--S_______WILLOW.DESCRIBE.ORCHITWIGS = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.ORCHITWIGS = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.ORCHITWIGS = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.ORCHITWIGS = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.ORCHITWIGS = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.ORCHITWIGS = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.ORCHITWIGS = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.ORCHITWIGS = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.ORCHITWIGS = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.ORCHITWIGS = "Great to cool off after some hard physical labor."

S_NAMES.ROSEBUSH = "Rose Bush"
S______GENERIC.DESCRIBE.ROSEBUSH =  --对于某些角色，这里面的"she"可以做点手脚，嘿嘿
{
    BARREN = "It can't recover without my help.",
    WITHERED = "She is no longer beauteous.",
    GENERIC = "She's so different!",
    PICKED = "No one knows her beauty.",
    -- DISEASED = "Is weak. Sickly!",    --不会生病
    -- DISEASING = "Is looking shrivelly.",
    BURNING = "The niceness are disappearing!",
}
--[[
S_______WILLOW.DESCRIBE.ROSEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S_____WOLFGANG.DESCRIBE.ROSEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S________WENDY.DESCRIBE.ROSEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S_________WX78.DESCRIBE.ROSEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S_WICKERBOTTOM.DESCRIBE.ROSEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S_______WOODIE.DESCRIBE.ROSEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S______WAXWELL.DESCRIBE.ROSEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S___WATHGRITHR.DESCRIBE.ROSEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S_______WEBBER.DESCRIBE.ROSEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
S_______WINONA.DESCRIBE.ROSEBUSH =
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

S_NAMES.DUG_ROSEBUSH = "Rose Bush"
S______GENERIC.DESCRIBE.DUG_ROSEBUSH = "Although rose is beautiful, it still has thorns."
--S_______WILLOW.DESCRIBE.DUG_ROSEBUSH = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DUG_ROSEBUSH = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DUG_ROSEBUSH = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DUG_ROSEBUSH = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DUG_ROSEBUSH = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DUG_ROSEBUSH = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DUG_ROSEBUSH = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DUG_ROSEBUSH = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DUG_ROSEBUSH = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DUG_ROSEBUSH = "Great to cool off after some hard physical labor."

S_NAMES.CUTTED_ROSEBUSH = "Rose Twigs"
S______GENERIC.DESCRIBE.CUTTED_ROSEBUSH = "This is a very common way of propagating plants."
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

S_NAMES.LILYBUSH = "Lily Bush"
S______GENERIC.DESCRIBE.LILYBUSH =  --对于某些角色，这里面的"she"可以做点手脚，嘿嘿
{
    BARREN = "It can't recover without my help.",
    WITHERED = "She is no longer beauteous.",
    GENERIC = "She's so different!",
    PICKED = "No one knows her beauty.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "The niceness are disappearing!",
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

S_NAMES.DUG_LILYBUSH = "Lily Bush"
S______GENERIC.DESCRIBE.DUG_LILYBUSH = "I can't wait to see its appearance."
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

S_NAMES.CUTTED_LILYBUSH = "Lily Sprout"
S______GENERIC.DESCRIBE.CUTTED_LILYBUSH = "This is a very common way of propagating plants."
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

S_NAMES.ORCHIDBUSH = "Orchid Bush"
S______GENERIC.DESCRIBE.ORCHIDBUSH =  --对于某些角色，这里面的"she"可以做点手脚，嘿嘿
{
    BARREN = "It can't recover without my help.",
    WITHERED = "She is no longer beauteous.",
    GENERIC = "She's so different!",
    PICKED = "No one knows her beauty.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "The niceness are disappearing!",
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

S_NAMES.DUG_ORCHIDBUSH = "Orchid Bush"
S______GENERIC.DESCRIBE.DUG_ORCHIDBUSH = "Look, it just lies there quietly."
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

S_NAMES.CUTTED_ORCHIDBUSH = "Orchid Seeds"
S______GENERIC.DESCRIBE.CUTTED_ORCHIDBUSH = "This is a very common way of propagating plants."
--S_______WILLOW.DESCRIBE.CUTTED_ORCHIDBUSH = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.CUTTED_ORCHIDBUSH = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.CUTTED_ORCHIDBUSH = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.CUTTED_ORCHIDBUSH = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.CUTTED_ORCHIDBUSH = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.CUTTED_ORCHIDBUSH = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.CUTTED_ORCHIDBUSH = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.CUTTED_ORCHIDBUSH = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.CUTTED_ORCHIDBUSH = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.CUTTED_ORCHIDBUSH = "Great to cool off after some hard physical labor."

S_NAMES.NEVERFADEBUSH = "Neverfade Bush"
S______GENERIC.DESCRIBE.NEVERFADEBUSH =
{
    --BARREN = "It can't recover without my help.",
    --WITHERED = "She is no longer beauteous.",
    GENERIC = "I knew it would never fade!",
    PICKED = "It is gaining the grace of nature.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    --BURNING = "The niceness are disappearing!",
}
--[[
S_______WILLOW.DESCRIBE.NEVERFADEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
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

S_NAMES.NEVERFADE = "Neverfade"    --永不凋零
S_RECIPE_DESC.NEVERFADE = "The power of flowers!"
S______GENERIC.DESCRIBE.NEVERFADE = "Divine... and pure... power!"
--S_______WILLOW.DESCRIBE.NEVERFADE = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.NEVERFADE = "Wolfgang can eat in one bite!"
S________WENDY.DESCRIBE.NEVERFADE = "It's not love, but it still is eternal..."
--S_________WX78.DESCRIBE.NEVERFADE = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.NEVERFADE = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.NEVERFADE = "I'd prefer maple taffy..."
S______WAXWELL.DESCRIBE.NEVERFADE = "Hm... this is something created by another force in the world."
--S___WATHGRITHR.DESCRIBE.NEVERFADE = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.NEVERFADE = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.NEVERFADE = "Great to cool off after some hard physical labor."
S_____WORMWOOD.DESCRIBE.SACHET = "Strong friend"

S_NAMES.SACHET = "Sachet"    --香包
S_RECIPE_DESC.SACHET = "Cover up your stinky sweat."
S______GENERIC.DESCRIBE.SACHET = "Should I smell like flowers?"
--S_______WILLOW.DESCRIBE.SACHET = "This is the opposite of burning."
S_____WOLFGANG.DESCRIBE.SACHET = "To be honest, this is too feminine..."
--S________WENDY.DESCRIBE.SACHET = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.SACHET = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.SACHET = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.SACHET = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.SACHET = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.SACHET = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.SACHET = "Great! We smell sweet!"
--S_______WINONA.DESCRIBE.SACHET = "Great to cool off after some hard physical labor."
S_____WORMWOOD.DESCRIBE.SACHET = "Friend inside?"

S______GENERIC.ANNOUNCE_PICK_ROSEBUSH = "I wish I could hug you, till you're really being free."
-- S_______WILLOW.ANNOUNCE_PICK_ROSEBUSH = ""
-- S_____WOLFGANG.ANNOUNCE_PICK_ROSEBUSH = ""
-- S________WENDY.ANNOUNCE_PICK_ROSEBUSH = ""
S_________WX78.ANNOUNCE_PICK_ROSEBUSH = "SAME BAD HAPPENS EVERYDAY."
-- S_WICKERBOTTOM.ANNOUNCE_PICK_ROSEBUSH = ""
-- S_______WOODIE.ANNOUNCE_PICK_ROSEBUSH = ""
S______WAXWELL.ANNOUNCE_PICK_ROSEBUSH = "You switched to his body?"
-- S___WATHGRITHR.ANNOUNCE_PICK_ROSEBUSH = ""
-- S_______WEBBER.ANNOUNCE_PICK_ROSEBUSH = ""
S_______WINONA.ANNOUNCE_PICK_ROSEBUSH = "One day I will be you."
-- S_______WORTOX.ANNOUNCE_PICK_ROSEBUSH = ""
-- S________WARLY.ANNOUNCE_PICK_ROSEBUSH = ""

S_NAMES.FOLIAGEATH = "Foliageath" --青枝绿叶
-- S_RECIPE_DESC.FOLIAGEATH = "Silent foliage, guard fragrance."
S______GENERIC.DESCRIBE.FOLIAGEATH =
{
    MERGED = "All shall be well.",
    GENERIC = "Who is it waiting for?",
}
-- S_______WILLOW.DESCRIBE.FOLIAGEATH = ""
-- S_____WOLFGANG.DESCRIBE.FOLIAGEATH = ""
-- S________WENDY.DESCRIBE.FOLIAGEATH = ""
-- S_________WX78.DESCRIBE.FOLIAGEATH = ""
-- S_WICKERBOTTOM.DESCRIBE.FOLIAGEATH = ""
-- S_______WOODIE.DESCRIBE.FOLIAGEATH = ""
-- S______WAXWELL.DESCRIBE.FOLIAGEATH = ""
-- S___WATHGRITHR.DESCRIBE.FOLIAGEATH = ""
-- S_______WEBBER.DESCRIBE.FOLIAGEATH = ""
-- S_______WINONA.DESCRIBE.FOLIAGEATH = ""
-- S________WARLY.DESCRIBE.FOLIAGEATH = ""
-- S_______WORTOX.DESCRIBE.FOLIAGEATH = ""
-- S_____WORMWOOD.DESCRIBE.FOLIAGEATH =
-- S_________WURT.DESCRIBE.FOLIAGEATH = ""

--入鞘失败的台词
S______GENERIC.ACTIONFAIL.GIVE.WRONGSWORD = "This is not what it expected!"
-- S_______WILLOW.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- S_____WOLFGANG.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- S________WENDY.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- S_________WX78.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- S_WICKERBOTTOM.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- S_______WOODIE.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- S______WAXWELL.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- S___WATHGRITHR.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- S_______WEBBER.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- S_______WINONA.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- S________WARLY.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- S_______WORTOX.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- S_____WORMWOOD.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- S_________WURT.ACTIONFAIL.GIVE.WRONGSWORD = ""

S_NAMES.FOLIAGEATH_MYLOVE = "Ciao Changqing"
S______GENERIC.DESCRIBE.FOLIAGEATH_MYLOVE = "Pity, you just want to run away." --This is someone's keepsake to his lover.
-- S_______WILLOW.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S_____WOLFGANG.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S________WENDY.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S_________WX78.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S_WICKERBOTTOM.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S_______WOODIE.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S______WAXWELL.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S___WATHGRITHR.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S_______WEBBER.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S_______WINONA.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S________WARLY.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S_______WORTOX.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S_____WORMWOOD.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S_________WURT.DESCRIBE.FOLIAGEATH_MYLOVE = ""

-- 合成一吻长青时的台词
S______GENERIC.ANNOUNCE_HIS_LOVE_WISH = "Wish forever but sometimes..." --Wish love lasts forever!
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

S_NAMES.PETALS_ROSE = "Rose Petals"
S______GENERIC.DESCRIBE.PETALS_ROSE = "A rose is a rose!"
--S_______WILLOW.DESCRIBE.PETALS_ROSE = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.PETALS_ROSE = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.PETALS_ROSE = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.PETALS_ROSE = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.PETALS_ROSE = "Well, isn't that refreshing?"
S_______WOODIE.DESCRIBE.PETALS_ROSE = "Feeling the grass between our toes, and Lucy smile."
S______WAXWELL.DESCRIBE.PETALS_ROSE = "Wise men don’t believe in roses."
--S___WATHGRITHR.DESCRIBE.PETALS_ROSE = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.PETALS_ROSE = "Yaaay! Popsicle, popsicle!"
S_______WINONA.DESCRIBE.PETALS_ROSE = "A rose is a rose, Just like everybody knows."

S_NAMES.PETALS_LILY = "Lily Petals"
S______GENERIC.DESCRIBE.PETALS_LILY = "A lily is a lily!"
S_______WILLOW.DESCRIBE.PETALS_LILY = "If the ground below us turned to dust, Would he come to me?"
--S_____WOLFGANG.DESCRIBE.PETALS_LILY = "Wolfgang can eat in one bite!"
S________WENDY.DESCRIBE.PETALS_LILY = "I'd like it if he say it's a nice gift."
--S_________WX78.DESCRIBE.PETALS_LILY = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.PETALS_LILY = "Well, isn't that refreshing?"
S_______WOODIE.DESCRIBE.PETALS_LILY = "I see a lily on thy brow, with anguish moist and fever dew."
--S______WAXWELL.DESCRIBE.PETALS_LILY = "Hm... I don't know what I was expecting."
S___WATHGRITHR.DESCRIBE.PETALS_LILY = "A white lie, to make up my bravado."
S_______WEBBER.DESCRIBE.PETALS_LILY = "If we were to bring her some flowers, would it be a surprise?"
--S_______WINONA.DESCRIBE.PETALS_LILY = "Great to cool off after some hard physical labor."

S_NAMES.PETALS_ORCHID = "Orchid Petals"
S______GENERIC.DESCRIBE.PETALS_ORCHID = "A orchid is a orchid!"
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

S_NAMES.DISH_CHILLEDROSEJUICE = "Chilled Rose Juice"    --蔷薇冰果汁
STRINGS.UI.COOKBOOK.DISH_CHILLEDROSEJUICE = "Plant flower at random"
S______GENERIC.DESCRIBE.DISH_CHILLEDROSEJUICE = "I have a sense like flowers in my heart."
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

S_NAMES.DISH_TWISTEDROLLLILY = "Twisted Lily Roll"    --蹄莲花卷
STRINGS.UI.COOKBOOK.DISH_TWISTEDROLLLILY = "Call butterfly at random"
S______GENERIC.DESCRIBE.DISH_TWISTEDROLLLILY = "To be a butterfly, fluttering and dancing in the breeze."
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

S_NAMES.DISH_ORCHIDCAKE = "Orchid Cake"    --兰花糕
STRINGS.UI.COOKBOOK.DISH_ORCHIDCAKE = "Have you felt the peace of mind"
S______GENERIC.DESCRIBE.DISH_ORCHIDCAKE = "I seemed to hear a quiet voice that calmed me."
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

S_NAMES.DISH_FLESHNAPOLEON = "Flesh Napoleon"    --真果拿破仑
STRINGS.UI.COOKBOOK.DISH_FLESHNAPOLEON = "Skin glow"
S______GENERIC.DESCRIBE.DISH_FLESHNAPOLEON = "The brightest star in the night sky is coming!"
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

S_NAMES.DISH_BEGGINGMEAT = "Begging Meat"    --叫花焖肉
STRINGS.UI.COOKBOOK.DISH_BEGGINGMEAT = "Hunger emergency"
S______GENERIC.DESCRIBE.DISH_BEGGINGMEAT = "For the moment, at least I don't have to beg for survival."
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

S_NAMES.DISH_FRENCHSNAILSBAKED = "French Snails Baked"    --法式焗蜗牛
STRINGS.UI.COOKBOOK.DISH_FRENCHSNAILSBAKED = "Give it a spark and it'll explode"
S______GENERIC.DESCRIBE.DISH_FRENCHSNAILSBAKED = "I hope there's no fire in my stomach!"
--S_______WILLOW.DESCRIBE.DISH_FRENCHSNAILSBAKED = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DISH_FRENCHSNAILSBAKED = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DISH_FRENCHSNAILSBAKED = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_FRENCHSNAILSBAKED = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DISH_FRENCHSNAILSBAKED = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DISH_FRENCHSNAILSBAKED = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DISH_FRENCHSNAILSBAKED = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_FRENCHSNAILSBAKED = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DISH_FRENCHSNAILSBAKED = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DISH_FRENCHSNAILSBAKED = "Great to cool off after some hard physical labor."

S_NAMES.DISH_NEWORLEANSWINGS = "New Orleans Wings"    --新奥尔良烤翅
STRINGS.UI.COOKBOOK.DISH_NEWORLEANSWINGS = "Absorb the ultrasound"
S______GENERIC.DESCRIBE.DISH_NEWORLEANSWINGS = "Why did I suddenly think of a man in a bat suit?"
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

S_NAMES.DISH_FISHJOYRAMEN = "Fishjoy Ramen"    --鱼乐拉面
STRINGS.UI.COOKBOOK.DISH_FISHJOYRAMEN = "Accidentally inhale something"
S______GENERIC.DESCRIBE.DISH_FISHJOYRAMEN = "Don't slurp your soup, be polite!"
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

S_NAMES.DISH_ROASTEDMARSHMALLOWS = "Roasted Marshmallows"    --烤棉花糖
S______GENERIC.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "It reminds me of my old days camping with my friends."
--S_______WILLOW.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "Wolfgang can eat in one bite!"
S________WENDY.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "Reminding me of my childhood camping with Abigail."
S_________WX78.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "IT REMINDED ME OF PYRO!"
--S_WICKERBOTTOM.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "Well, isn't that refreshing?"
S_______WOODIE.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "Oh, I almost forgot, the time I spent camping with Lucy."
--S______WAXWELL.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "It reminds us of our childhood camping with our family."
--S_______WINONA.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "Great to cool off after some hard physical labor."

S_NAMES.DISH_POMEGRANATEJELLY = "Pomegranate Jelly"    --石榴子果冻
S______GENERIC.DESCRIBE.DISH_POMEGRANATEJELLY = "It's children's stuff, I'm not naive any more."
--S_______WILLOW.DESCRIBE.DISH_POMEGRANATEJELLY = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DISH_POMEGRANATEJELLY = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DISH_POMEGRANATEJELLY = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_POMEGRANATEJELLY = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DISH_POMEGRANATEJELLY = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DISH_POMEGRANATEJELLY = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DISH_POMEGRANATEJELLY = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_POMEGRANATEJELLY = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.DISH_POMEGRANATEJELLY = "We like Jellys!"
--S_______WINONA.DESCRIBE.DISH_POMEGRANATEJELLY = "Great to cool off after some hard physical labor."

S_NAMES.DISH_MEDICINALLIQUOR = "Medicinal Liquor"    --药酒
STRINGS.UI.COOKBOOK.DISH_MEDICINALLIQUOR = "Boost morale"
S______GENERIC.DESCRIBE.DISH_MEDICINALLIQUOR =
{
    GENERIC = "Feel no pain! fight to death!",
    DRUNK = "I'm not drunk!",
}
--S_______WILLOW.DESCRIBE.DISH_MEDICINALLIQUOR = "This is the opposite of burning."
S_____WOLFGANG.DESCRIBE.DISH_MEDICINALLIQUOR =
{
    GENERIC = "Feel no pain! fight to death!",
    DRUNK = "Oh, just water!",
}
S________WENDY.DESCRIBE.DISH_MEDICINALLIQUOR =
{
    GENERIC = "I don't want to drink this.",
    DRUNK = "I shouldn't have drunk this.",
}
--S_________WX78.DESCRIBE.DISH_MEDICINALLIQUOR = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DISH_MEDICINALLIQUOR = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DISH_MEDICINALLIQUOR = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DISH_MEDICINALLIQUOR = "Hm... I don't know what I was expecting."
S___WATHGRITHR.DESCRIBE.DISH_MEDICINALLIQUOR =
{
    GENERIC = "Feel no pain! fight to death!",
    DRUNK = "Oh, just water!",
}
S_______WEBBER.DESCRIBE.DISH_MEDICINALLIQUOR =
{
    GENERIC = "My mom warned me not to drink before.",
    DRUNK = "Mom, We are so sleeeeee...",
}
--S_______WINONA.DESCRIBE.DISH_MEDICINALLIQUOR = "Great to cool off after some hard physical labor."

S_NAMES.DISH_BANANAMOUSSE = "Banana Mousse"    --香蕉慕斯
STRINGS.UI.COOKBOOK.DISH_BANANAMOUSSE = "Stop picky eating"
S______GENERIC.DESCRIBE.DISH_BANANAMOUSSE = "An appetizing dessert. Yummy..."
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

S_NAMES.DISH_RICEDUMPLING = "Rice Dumpling"    --金黄香粽
STRINGS.UI.COOKBOOK.DISH_RICEDUMPLING = "Fill your stomach, you like it"
S______GENERIC.DESCRIBE.DISH_RICEDUMPLING = "It has a natural smell."
--S_______WILLOW.DESCRIBE.DISH_RICEDUMPLING = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DISH_RICEDUMPLING = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DISH_RICEDUMPLING = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_RICEDUMPLING = "STICK ADDON INSTALLED"
S_WICKERBOTTOM.DESCRIBE.DISH_RICEDUMPLING = "Maybe I should throw it into the river to feed the fish."
--S_______WOODIE.DESCRIBE.DISH_RICEDUMPLING = "I'd prefer maple taffy..."
S______WAXWELL.DESCRIBE.DISH_RICEDUMPLING = "My stomach doesn't feel well when I see this."
--S___WATHGRITHR.DESCRIBE.DISH_RICEDUMPLING = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DISH_RICEDUMPLING = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DISH_RICEDUMPLING = "Great to cool off after some hard physical labor."

S_NAMES.DISH_DURIANTARTARE = "Durian Tartare"    --怪味鞑靼
STRINGS.UI.COOKBOOK.DISH_DURIANTARTARE = "Give monster extra recovery"
S______GENERIC.DESCRIBE.DISH_DURIANTARTARE = "Brutal, bloody and yucky..."
S_______WILLOW.DESCRIBE.DISH_DURIANTARTARE = "Mess! needs a fire!"
--S_____WOLFGANG.DESCRIBE.DISH_DURIANTARTARE = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DISH_DURIANTARTARE = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_DURIANTARTARE = "STICK ADDON INSTALLED"
S_WICKERBOTTOM.DESCRIBE.DISH_DURIANTARTARE = "Umm... the meat is still raw, and it stinks."
--S_______WOODIE.DESCRIBE.DISH_DURIANTARTARE = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DISH_DURIANTARTARE = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_DURIANTARTARE = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.DISH_DURIANTARTARE = "A lump of processed raw meat, cool!"
--S_______WINONA.DESCRIBE.DISH_DURIANTARTARE = "Great to cool off after some hard physical labor."
S_______WORTOX.DESCRIBE.DISH_DURIANTARTARE = "Whose flesh is this, with a little yummy soul remained."

S_NAMES.DISH_MERRYCHRISTMASSALAD = "\"Merry Christmas\" Salad"    --“圣诞快乐”沙拉
STRINGS.UI.COOKBOOK.DISH_MERRYCHRISTMASSALAD = "With blessing to accept gift"
S______GENERIC.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "Look at the Christmas tree, and eat a christmas tree."
-- S_______WILLOW.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "Mess! needs a fire!"
S_____WOLFGANG.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "Wolfgang want a gift, Santa Claus, please."
--S________WENDY.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "STICK ADDON INSTALLED"
-- S_WICKERBOTTOM.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "Umm... the meat is still raw, and it stinks."
S_______WOODIE.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "Now I'm not the only one who can eat trees."
--S______WAXWELL.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "Should I eat from the star or from the trunk?"
S_______WINONA.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "Merry Christmas! hah."

S_NAMES.DISH_MURMURANANAS = "Murmur Ananas"    --松萝咕咾肉
S______GENERIC.DESCRIBE.DISH_MURMURANANAS = "Sour and sweet meat, I like it!"
-- S_______WILLOW.DESCRIBE.DISH_MURMURANANAS = "This is the opposite of burning."
S_____WOLFGANG.DESCRIBE.DISH_MURMURANANAS = "Wolfgang loves it so much that he wants to eat it again!"
-- S________WENDY.DESCRIBE.DISH_MURMURANANAS = "I used to eat these with Abigail..."
-- S_________WX78.DESCRIBE.DISH_MURMURANANAS = "STICK ADDON INSTALLED"
-- S_WICKERBOTTOM.DESCRIBE.DISH_MURMURANANAS = "Well, isn't that refreshing?"
-- S_______WOODIE.DESCRIBE.DISH_MURMURANANAS = "I'd prefer maple taffy..."
S______WAXWELL.DESCRIBE.DISH_MURMURANANAS = "This cuisine will never disappear on the menu of Chinatown restaurants."
-- S___WATHGRITHR.DESCRIBE.DISH_MURMURANANAS = "I've somehow found a way to make it even LESS appealing!"
-- S_______WEBBER.DESCRIBE.DISH_MURMURANANAS = "Yaaay! Popsicle, popsicle!"
-- S_______WINONA.DESCRIBE.DISH_MURMURANANAS = "Great to cool off after some hard physical labor."
-- S_______WORTOX.DESCRIBE.DISH_MURMURANANAS = "Whose flesh is this, with a little yummy soul remained."

S_NAMES.DISH_SHYERRYJAM = "Shyerry Jam"    --颤栗果酱
STRINGS.UI.COOKBOOK.DISH_SHYERRYJAM = "Self-healing in moderation"
S______GENERIC.DESCRIBE.DISH_SHYERRYJAM = "I'd love to pour it over scones or make a pie, then eat it."
-- S_______WILLOW.DESCRIBE.DISH_SHYERRYJAM = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.DISH_SHYERRYJAM = "Wolfgang loves it so much that he wants to eat it again!"
-- S________WENDY.DESCRIBE.DISH_SHYERRYJAM = "I used to eat these with Abigail..."
S_________WX78.DESCRIBE.DISH_SHYERRYJAM = "NO DESSERT, JUST EAT IT DIRECTLY."
-- S_WICKERBOTTOM.DESCRIBE.DISH_SHYERRYJAM = "Well, isn't that refreshing?"
-- S_______WOODIE.DESCRIBE.DISH_SHYERRYJAM = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.DISH_SHYERRYJAM = "This "
-- S___WATHGRITHR.DESCRIBE.DISH_SHYERRYJAM = "I've somehow found a way to make it even LESS appealing!"
-- S_______WEBBER.DESCRIBE.DISH_SHYERRYJAM = "Yaaay! Popsicle, popsicle!"
-- S_______WINONA.DESCRIBE.DISH_SHYERRYJAM = "Great to cool off after some hard physical labor."
-- S_______WORTOX.DESCRIBE.DISH_SHYERRYJAM = "Whose flesh is this, with a little yummy soul remained."

--蝙蝠伪装buff
S______GENERIC.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = "I seem to be wearing an invisible bat suit."
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
S______GENERIC.ANNOUNCE_DETACH_BUFF_BATDISGUISE = "Well, I'm not a bat."
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
S______GENERIC.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = "Suddenly, I want to have a big meal."
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
S______GENERIC.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = "My appetite has returned to normal."
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
S______GENERIC.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = "No appetite at all."
-- S_______WILLOW.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
-- S_____WOLFGANG.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
-- S________WENDY.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
-- S_________WX78.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
S_WICKERBOTTOM.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = "This food boosts my satiety."
-- S_______WOODIE.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
S______WAXWELL.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = "Not well for my old stomach."
-- S___WATHGRITHR.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
-- S_______WEBBER.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
S_______WINONA.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = "The less hungry you are, the better you can work."
-- S_______WORTOX.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
-- S________WARLY.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
--
S______GENERIC.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = "Good luck comes when you have an appetite."
-- S_______WILLOW.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
-- S_____WOLFGANG.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
-- S________WENDY.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
-- S_________WX78.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
S_WICKERBOTTOM.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = "Satiety returns to normal."
-- S_______WOODIE.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
S______WAXWELL.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = "My stomach felt better at last."
-- S___WATHGRITHR.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
-- S_______WEBBER.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
S_______WINONA.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = "Even if you're hungry, you have to keep working."
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
S______GENERIC.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = "Oh, headache. Memories of yesterday are vague..."
-- S_______WILLOW.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- S_____WOLFGANG.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- S________WENDY.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
S_________WX78.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = "I BLACKED OUT YESTERDAY?"
-- S_WICKERBOTTOM.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- S_______WOODIE.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- S______WAXWELL.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- S___WATHGRITHR.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- S_______WEBBER.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- S_______WINONA.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- S_______WORTOX.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- S________WARLY.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""

S_NAMES.DISH_SUGARLESSTRICKMAKERCUPCAKES = "Sugarless Trickmaker Cupcakes"   --无糖捣蛋鬼纸杯蛋糕
STRINGS.UI.COOKBOOK.DISH_SUGARLESSTRICKMAKERCUPCAKES = "Naughty elves will help you"
S______GENERIC.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "Trick or treat!",
    TRICKED = "Scared me silly.",
    TREAT = "Here's your candy.",
}
-- S_______WILLOW.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES = ""
S_____WOLFGANG.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "Wolfgang only wants sugar, not to play tricks.",
    TRICKED = "It scared Wolfgang too much.",
    TREAT = "Wolfgang will share the happiness.",
}
S________WENDY.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "Maybe I'm too mature to ask for sugar.",
    TRICKED = "Scared me silly.",
    TREAT = "Would Abigail want candy, too?",
}
S_________WX78.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "MY BODY CRAVES DEOXYRIBOSE.",
    TRICKED = "SUDDEN WARNING!",
    TREAT = "JUST GIVE YOU SOMTHING I DON'T WANT.",
}
S_WICKERBOTTOM.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "I believe it's a trick.",
    TRICKED = "This is not allowed in library!",
    TREAT = "Here's your candy.",
}
-- S_______WOODIE.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES = ""
-- S______WAXWELL.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES = ""
-- S___WATHGRITHR.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES = ""
S_______WEBBER.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "We just want sweety sugar and candy!",
    TRICKED = "You made everyone laugh.",
    TREAT = "We're the ones who want the sugar.",
}
-- S_______WINONA.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES = ""
S_______WORTOX.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "Hey, don't steal my thunder!!!",
    TRICKED = "Hah, small trick.",
    TREAT = "What if I don't give sugar.",
}
S_____WORMWOOD.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "Nectar, please?",
    TRICKED = "It made my leaves tremble.",
    TREAT = "Is today the pollination day?",
}
S________WARLY.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "What a timely snack!",
    TRICKED = "It made my pot shake.",
    TREAT = "This chef is going to treat the guests well.",
}
-- S_________WURT.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES = ""

S_NAMES.DISH_FLOWERMOONCAKE = "Flower Mooncake"    --鲜花月饼
STRINGS.UI.COOKBOOK.DISH_FLOWERMOONCAKE = "Get the power of missing"
S______GENERIC.DESCRIBE.DISH_FLOWERMOONCAKE =
{
    GENERIC = "The scent of flowers, like my yearning.",
    HAPPY = "I will always have someone important on my mind.",
    LONELY = "Lonely and sad.",
}
-- S_______WILLOW.DESCRIBE.DISH_FLOWERMOONCAKE = ""
-- S_____WOLFGANG.DESCRIBE.DISH_FLOWERMOONCAKE = ""
S________WENDY.DESCRIBE.DISH_FLOWERMOONCAKE =
{
    GENERIC = "Come, Abigail, enjoy the moon with me!",
    HAPPY = "So nostalgic for the day we sat on the table cloth on the grass.",
    LONELY = "Unprecedented loneliness is eroding me.",
}
S_________WX78.DESCRIBE.DISH_FLOWERMOONCAKE =
{
    GENERIC = "LOW VALUE FUEL.",
    HAPPY = "UNKNOWN INTRUDER IS TRYING TO REPAIR THE EMOTIONAL COMPONENT.",
    LONELY = "STILL WRONG, THE EMOTIONAL COMPONENT IS NOT RESPONDING.",
}
-- S_WICKERBOTTOM.DESCRIBE.DISH_FLOWERMOONCAKE = ""
-- S_______WOODIE.DESCRIBE.DISH_FLOWERMOONCAKE = ""
S______WAXWELL.DESCRIBE.DISH_FLOWERMOONCAKE =
{
    GENERIC = "It's not decent to get your suit dirty.",
    HAPPY = "I just want to make it all right, Charlie.",
    LONELY = "I deserve it.",
}
-- S___WATHGRITHR.DESCRIBE.DISH_FLOWERMOONCAKE = ""
-- S_______WEBBER.DESCRIBE.DISH_FLOWERMOONCAKE = ""
-- S_______WINONA.DESCRIBE.DISH_FLOWERMOONCAKE = ""
-- S_______WORTOX.DESCRIBE.DISH_FLOWERMOONCAKE = ""
S_____WORMWOOD.DESCRIBE.DISH_FLOWERMOONCAKE =
{
    GENERIC = "The sustenance of friends miss.",
    HAPPY = "So nice to have friends around!",
    LONELY = "It's so lonely without a friend.",
}
S________WARLY.DESCRIBE.DISH_FLOWERMOONCAKE =
{
    GENERIC = "While eating and enjoying the moon, memories come to mind.",
    HAPPY = "Grandma, I miss you.",
    LONELY = "Alas, what's the use of cooking!",
}
-- S_________WURT.DESCRIBE.DISH_FLOWERMOONCAKE = ""
-- S_______WALTER.DESCRIBE.DISH_FLOWERMOONCAKE = ""

S_NAMES.DISH_FAREWELLCUPCAKE = "Farewell Cupcake" --临别的纸杯蛋糕
STRINGS.UI.COOKBOOK.DISH_FLOWERMOONCAKE = "Say goodbye to my life"
S______GENERIC.DESCRIBE.DISH_FAREWELLCUPCAKE = "So easy to be careless, but takes courage to care."
-- S_______WILLOW.DESCRIBE.DISH_FAREWELLCUPCAKE = ""
-- S_____WOLFGANG.DESCRIBE.DISH_FAREWELLCUPCAKE = ""
S________WENDY.DESCRIBE.DISH_FAREWELLCUPCAKE = "Failures, let everyone down, including ourselves."
-- S_________WX78.DESCRIBE.DISH_FAREWELLCUPCAKE = ""
S_WICKERBOTTOM.DESCRIBE.DISH_FAREWELLCUPCAKE = "Unfortunately, most of people are act self-awareness."
S_______WOODIE.DESCRIBE.DISH_FAREWELLCUPCAKE = "People are alienated from each other with a broken heart."
S______WAXWELL.DESCRIBE.DISH_FAREWELLCUPCAKE = "My life is not worth mentioning."
S___WATHGRITHR.DESCRIBE.DISH_FAREWELLCUPCAKE = "Don't you have enough?"
S_______WEBBER.DESCRIBE.DISH_FAREWELLCUPCAKE = "Come on! Our pure spiritual world."
-- S_______WINONA.DESCRIBE.DISH_FAREWELLCUPCAKE = ""
S_______WORTOX.DESCRIBE.DISH_FAREWELLCUPCAKE = "Sorry, it's so painful to be alive and I'm not done yet."
-- S_____WORMWOOD.DESCRIBE.DISH_FAREWELLCUPCAKE = ""
-- S________WARLY.DESCRIBE.DISH_FAREWELLCUPCAKE = ""
S_________WURT.DESCRIBE.DISH_FAREWELLCUPCAKE = "To deliberately believe in lies while knowing their false."
-- S_______WALTER.DESCRIBE.DISH_FAREWELLCUPCAKE = ""

S_NAMES.DISH_BRAISEDMEATWITHFOLIAGES = "Braised Meat With Foliages" --蕨叶扣肉
S______GENERIC.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = "Looks so greasy, just one piece of meat, please."
-- S_______WILLOW.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
S_____WOLFGANG.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = "Wolfgang loves it!"
-- S________WENDY.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- S_________WX78.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- S_WICKERBOTTOM.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
S_______WOODIE.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = "It goes well with rice."
-- S______WAXWELL.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- S___WATHGRITHR.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- S_______WEBBER.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- S_______WINONA.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- S_______WORTOX.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- S_____WORMWOOD.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
S________WARLY.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = "It's not easy to make fat meat non greasy."
-- S_________WURT.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- S_______WALTER.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""

S_NAMES.DISH_WRAPPEDSHRIMPPASTE = "Wrapped Mushrimp" --白菇虾滑卷
STRINGS.UI.COOKBOOK.DISH_WRAPPEDSHRIMPPASTE = "Enhance resistance"
S______GENERIC.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = "Great! The outer layer locks well the shrimp meat essence."
-- S_______WILLOW.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
-- S_____WOLFGANG.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
-- S________WENDY.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
-- S_________WX78.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
-- S_WICKERBOTTOM.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
S_______WOODIE.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = "So delicious. Can I have the wooden dish, too?"
-- S______WAXWELL.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
-- S___WATHGRITHR.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
-- S_______WEBBER.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
S_______WINONA.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = "Made smooth and delicate taste, it's not me."
-- S_______WORTOX.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
S_____WORMWOOD.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = "Beautiful friend, suitable, making beautiful meal."
S________WARLY.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = "Ah, the mushroom, the shrimp, my life has reached the peak!"
S_________WURT.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = "It's cruel, glort."
-- S_______WALTER.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""

S_NAMES.DISH_SOSWEETJARKFRUIT = "So Sweet Jarkfruit" --甜到裂开的松萝蜜
S______GENERIC.DESCRIBE.DISH_SOSWEETJARKFRUIT = "It was so sweet that I flustered."
S_______WILLOW.DESCRIBE.DISH_SOSWEETJARKFRUIT = "Too sweet, chef."
-- S_____WOLFGANG.DESCRIBE.DISH_SOSWEETJARKFRUIT = ""
S________WENDY.DESCRIBE.DISH_SOSWEETJARKFRUIT = "There's two of them, and one for Abigail."
S_________WX78.DESCRIBE.DISH_SOSWEETJARKFRUIT = "FUEL DETECTION: EXCESSIVE HEAT."
S_WICKERBOTTOM.DESCRIBE.DISH_SOSWEETJARKFRUIT = "I shouldn't eat such unhealthy food."
-- S_______WOODIE.DESCRIBE.DISH_SOSWEETJARKFRUIT = ""
-- S______WAXWELL.DESCRIBE.DISH_SOSWEETJARKFRUIT = ""
-- S___WATHGRITHR.DESCRIBE.DISH_SOSWEETJARKFRUIT = ""
S_______WEBBER.DESCRIBE.DISH_SOSWEETJARKFRUIT = "Oh yeah, my favorite!"
S_______WINONA.DESCRIBE.DISH_SOSWEETJARKFRUIT = "Did no one notice a crack in the bottle?"
S_______WORTOX.DESCRIBE.DISH_SOSWEETJARKFRUIT = "Love is sugar, sweet to sadness."
S_____WORMWOOD.DESCRIBE.DISH_SOSWEETJARKFRUIT = "Crack!"
S________WARLY.DESCRIBE.DISH_SOSWEETJARKFRUIT = "I have an appointment with sweet lady."
-- S_________WURT.DESCRIBE.DISH_SOSWEETJARKFRUIT = ""
S_______WALTER.DESCRIBE.DISH_SOSWEETJARKFRUIT = "Not a perfect dish because it's cracked."

--------------------------------------------------------------------------
--[[ the sacrifice of rain ]]--[[ 祈雨祭 ]]
--------------------------------------------------------------------------

S_NAMES.RAINDONATE = "Raindonate"    --雨蝇
S______GENERIC.DESCRIBE.RAINDONATE =
{
    GENERIC = "Elders said that the killing of it would start to rain.",
    HELD = "Look, this blue, winged insect!",
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

S_NAMES.MONSTRAIN = "Monstrain"   --雨竹
S______GENERIC.DESCRIBE.MONSTRAIN =
{
    SUMMER = "The water at the bottom fled.",
    WINTER = "The water at the bottom solidified.",
    GENERIC = "Careful! Don't touch the juice of it!",
    PICKED = "I'll just take a look.",
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

S_NAMES.SQUAMOUSFRUIT = "Squamous Fruit"    --鳞果
S______GENERIC.DESCRIBE.SQUAMOUSFRUIT = "Wow, edible pinecone."
--S_______WILLOW.DESCRIBE.SQUAMOUSFRUIT = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.SQUAMOUSFRUIT = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.SQUAMOUSFRUIT = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.SQUAMOUSFRUIT = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.SQUAMOUSFRUIT = "Well, isn't that refreshing?"
S_______WOODIE.DESCRIBE.SQUAMOUSFRUIT = "Oops, a pinecone that cannot grow up."
--S______WAXWELL.DESCRIBE.SQUAMOUSFRUIT = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.SQUAMOUSFRUIT = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.SQUAMOUSFRUIT = "Wow, pinecone with our favorite color."
--S_______WINONA.DESCRIBE.SQUAMOUSFRUIT = "Great to cool off after some hard physical labor."

S_NAMES.MONSTRAIN_LEAF = "Monstrain Leaf"    --雨竹叶
S______GENERIC.DESCRIBE.MONSTRAIN_LEAF = "When I eat it, it eats me."
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

S_NAMES.BOOK_WEATHER = "Changing Clouds"    --多变的云
S_RECIPE_DESC.BOOK_WEATHER = "Stir the clouds with your heart."
S______GENERIC.DESCRIBE.BOOK_WEATHER = "When clouds cover the sun... when sunlight penetrates the clouds..."
--S_______WILLOW.DESCRIBE.BOOK_WEATHER = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.BOOK_WEATHER = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.BOOK_WEATHER = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.BOOK_WEATHER = "STICK ADDON INSTALLED"
S_WICKERBOTTOM.DESCRIBE.BOOK_WEATHER = "Well, I can forecast the weather correctly now."
--S_______WOODIE.DESCRIBE.BOOK_WEATHER = "I'd prefer maple taffy..."
S______WAXWELL.DESCRIBE.BOOK_WEATHER = "Hm... I can forecast the weather correctly now."
--S___WATHGRITHR.DESCRIBE.BOOK_WEATHER = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.BOOK_WEATHER = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.BOOK_WEATHER = "Great to cool off after some hard physical labor."
--
S______GENERIC.ANNOUNCE_READ_BOOK.BOOK_WEATHER = "Wait, isn't it just Wurt who reads?"
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
S_________WURT.ANNOUNCE_READ_BOOK.BOOK_WEATHER_SUNNY = "Arid, dry, waterless, blablabla..."
S_________WURT.ANNOUNCE_READ_BOOK.BOOK_WEATHER_RAINY = "Drizzle, sprinkle, downpour, that's sweet."

S_NAMES.MERM_SCALES = "Drippy Scales"  --鱼鳞
S______GENERIC.DESCRIBE.MERM_SCALES = "Ewwwwwwww, smell a strong fishy smell."
--S_______WILLOW.DESCRIBE.MERM_SCALES = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.MERM_SCALES = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.MERM_SCALES = "Contrary to Ms Squid's magic."
--S_________WX78.DESCRIBE.MERM_SCALES = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.MERM_SCALES = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.MERM_SCALES = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.MERM_SCALES = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.MERM_SCALES = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.MERM_SCALES = "And how about the one with the drippy nose?"
--S_______WINONA.DESCRIBE.MERM_SCALES = "Great to cool off after some hard physical labor."

S_NAMES.HAT_MERMBREATHING = "Breathing Gills"  --鱼之息
S_RECIPE_DESC.HAT_MERMBREATHING = "Breathing like a merm."
S______GENERIC.DESCRIBE.HAT_MERMBREATHING = "I hope I won't jump into the sea and disappear."
--S_______WILLOW.DESCRIBE.HAT_MERMBREATHING = ""
--S_____WOLFGANG.DESCRIBE.HAT_MERMBREATHING = ""
S________WENDY.DESCRIBE.HAT_MERMBREATHING = "Contrary to Ms Squid's magic."
--S_________WX78.DESCRIBE.HAT_MERMBREATHING = ""
--S_WICKERBOTTOM.DESCRIBE.HAT_MERMBREATHING = ""
--S_______WOODIE.DESCRIBE.HAT_MERMBREATHING = ""
--S______WAXWELL.DESCRIBE.HAT_MERMBREATHING = ""
--S___WATHGRITHR.DESCRIBE.HAT_MERMBREATHING = ""
S_______WEBBER.DESCRIBE.HAT_MERMBREATHING = "I can swim freely! er... need a fish tail."
--S_______WINONA.DESCRIBE.HAT_MERMBREATHING = ""

S_NAMES.AGRONSSWORD = "Agron's Sword"  --艾力冈的剑
S______GENERIC.DESCRIBE.AGRONSSWORD = "I'll fight to be a free man!"
S_______WILLOW.DESCRIBE.AGRONSSWORD = "A single faith can start a freedom fire."
S_____WOLFGANG.DESCRIBE.AGRONSSWORD = "It fills Wolfgang with courage!"
S________WENDY.DESCRIBE.AGRONSSWORD = "If I leave here, Abigail will leave me."
S_________WX78.DESCRIBE.AGRONSSWORD = "YEARN FOR HUMAN NATURE BUT... FEAR TO POSSESS IT."
S_WICKERBOTTOM.DESCRIBE.AGRONSSWORD = "Do not shed tears."
S_______WOODIE.DESCRIBE.AGRONSSWORD = "Lucy comforts me, so I believe I can escape from here one day."
S______WAXWELL.DESCRIBE.AGRONSSWORD = "There is no greater victory than to fall from this world as a free man."
S___WATHGRITHR.DESCRIBE.AGRONSSWORD = "When the Bringer of Rain died, even Valhalla was moved."
S_______WEBBER.DESCRIBE.AGRONSSWORD = "If I could, I would be out of this world with my legion!"
S_______WINONA.DESCRIBE.AGRONSSWORD = "I am a laborer, not a slave, I'm my own!"

S_NAMES.GIANTSFOOT = "Giant's Foot"  --巨人之脚
S_RECIPE_DESC.GIANTSFOOT = "Let giant rule your stuff."
S______GENERIC.DESCRIBE.GIANTSFOOT = "Giant stands on the shoulders of me."
--S_______WILLOW.DESCRIBE.GIANTSFOOT = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.GIANTSFOOT = "Wolfgang can eat in one bite!"
S________WENDY.DESCRIBE.GIANTSFOOT = "Er... Have I seen it somewhere?"
--S_________WX78.DESCRIBE.GIANTSFOOT = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.GIANTSFOOT = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.GIANTSFOOT = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.GIANTSFOOT = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.GIANTSFOOT = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.GIANTSFOOT = "I can swim freely! er... need a fish tail."
--S_______WINONA.DESCRIBE.GIANTSFOOT = "Great to cool off after some hard physical labor."

S_NAMES.REFRACTEDMOONLIGHT = "Refracted Moonlight"  --月折宝剑
S______GENERIC.DESCRIBE.REFRACTEDMOONLIGHT = "Oh my glob! A powerful sword from the Land of Ooo?"
-- S_______WILLOW.DESCRIBE.REFRACTEDMOONLIGHT = "A single faith can start a freedom fire."
-- S_____WOLFGANG.DESCRIBE.REFRACTEDMOONLIGHT = "It fills Wolfgang with courage!"
-- S________WENDY.DESCRIBE.REFRACTEDMOONLIGHT = "If I leave here, Abigail will leave me."
-- S_________WX78.DESCRIBE.REFRACTEDMOONLIGHT = "YEARN FOR HUMAN NATURE BUT... FEAR TO POSSESS IT."
S_WICKERBOTTOM.DESCRIBE.REFRACTEDMOONLIGHT = "Only a person of integrity can control its power."
-- S_______WOODIE.DESCRIBE.REFRACTEDMOONLIGHT = "Lucy comforts me, so I believe I can escape from here one day."
S______WAXWELL.DESCRIBE.REFRACTEDMOONLIGHT = "Only those who are healthy can wield its power."
-- S___WATHGRITHR.DESCRIBE.REFRACTEDMOONLIGHT = "When the Bringer of Rain died, even Valhalla was moved."
-- S_______WEBBER.DESCRIBE.REFRACTEDMOONLIGHT = "If I could, I would be out of this world with my legion!"
-- S_______WINONA.DESCRIBE.REFRACTEDMOONLIGHT = "I am a laborer, not a slave, I'm my own!"

S_NAMES.MOONDUNGEON = "Moon Dungeon"   --月的地下城
S______GENERIC.DESCRIBE.MOONDUNGEON =
{
    SLEEP = "Is that fossilized fossil?",
    GENERIC = "Someone burned up his whole life and built it here.",
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
S___WATHGRITHR.DESCRIBE.MOONDUNGEON =
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

S_NAMES.HIDDENMOONLIGHT = "Hidden Moonlight"  --月藏宝匣
S______GENERIC.DESCRIBE.HIDDENMOONLIGHT = "As empty as the Milky way."
-- S_______WILLOW.DESCRIBE.HIDDENMOONLIGHT = ""
S_____WOLFGANG.DESCRIBE.HIDDENMOONLIGHT = "Look! There are stars blinking at Wolfgang."
S________WENDY.DESCRIBE.HIDDENMOONLIGHT = "Light moonlight, somewhere in my heart."
-- S_________WX78.DESCRIBE.HIDDENMOONLIGHT = ""
S_WICKERBOTTOM.DESCRIBE.HIDDENMOONLIGHT = "The time flow in this box is slower than outside."
-- S_______WOODIE.DESCRIBE.HIDDENMOONLIGHT = ""
S______WAXWELL.DESCRIBE.HIDDENMOONLIGHT = "Moon's magic is more than that!"
-- S___WATHGRITHR.DESCRIBE.HIDDENMOONLIGHT = ""
S_______WEBBER.DESCRIBE.HIDDENMOONLIGHT = "Yeah! Reach in and catch what you think."
-- S_______WINONA.DESCRIBE.HIDDENMOONLIGHT = ""
-- S_______WORTOX.DESCRIBE.HIDDENMOONLIGHT = ""
S_____WORMWOOD.DESCRIBE.HIDDENMOONLIGHT = "Hollow, like me."
S________WARLY.DESCRIBE.HIDDENMOONLIGHT = "Save my ingredients better!"
-- S_________WURT.DESCRIBE.HIDDENMOONLIGHT = ""
S_______WALTER.DESCRIBE.HIDDENMOONLIGHT = "Why is there no sound of waves coming out, florp?"

S_NAMES.HIDDENMOONLIGHT_ITEM = "Unused Hidden Moonlight" --未启用的月藏宝匣
S_RECIPE_DESC.HIDDENMOONLIGHT_ITEM = "Hiding dainties between moon and stars."
S______GENERIC.DESCRIBE.HIDDENMOONLIGHT_ITEM = "Seems to be an upgrade package for food box."
-- S_______WILLOW.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
S_____WOLFGANG.DESCRIBE.HIDDENMOONLIGHT_ITEM = "Is this also a secret fridge part in ancient times?"
-- S________WENDY.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
-- S_________WX78.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
-- S_WICKERBOTTOM.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
-- S_______WOODIE.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
S______WAXWELL.DESCRIBE.HIDDENMOONLIGHT_ITEM = "A box powered by moonlight."
S___WATHGRITHR.DESCRIBE.HIDDENMOONLIGHT_ITEM = "Hope it's not Pandora's box."
-- S_______WEBBER.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
S_______WINONA.DESCRIBE.HIDDENMOONLIGHT_ITEM = "The inspiration of moon!"
S_______WORTOX.DESCRIBE.HIDDENMOONLIGHT_ITEM = "I can feel it being called by a box full of food."
-- S_____WORMWOOD.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
-- S________WARLY.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
-- S_________WURT.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
-- S_______WALTER.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""

--------------------------------------------------------------------------
--[[ legends of the fall ]]--[[ 丰饶传说 ]]
--------------------------------------------------------------------------

S_NAMES.PINEANANAS = "Pineananas"    --松萝
S______GENERIC.DESCRIBE.PINEANANAS = "Eating it raw may numb my mouth."
-- S_______WILLOW.DESCRIBE.PINEANANAS = ""
-- S_____WOLFGANG.DESCRIBE.PINEANANAS = ""
-- S________WENDY.DESCRIBE.PINEANANAS = ""
-- S_________WX78.DESCRIBE.PINEANANAS = ""
-- S_WICKERBOTTOM.DESCRIBE.PINEANANAS = ""
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

S_NAMES.PINEANANAS_COOKED = "Roasted Pineananas"    --烤松萝
S______GENERIC.DESCRIBE.PINEANANAS_COOKED = "It tastes much better after roasted."
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

S_NAMES.PINEANANAS_SEEDS = "Chimeric Seeds"    --嵌合种子
S______GENERIC.DESCRIBE.PINEANANAS_SEEDS = "I'm not sure if it should be a pine cone or pineapple seed."
-- S_______WILLOW.DESCRIBE.PINEANANAS_SEEDS = ""
-- S_____WOLFGANG.DESCRIBE.PINEANANAS_SEEDS = ""
-- S________WENDY.DESCRIBE.PINEANANAS_SEEDS = ""
-- S_________WX78.DESCRIBE.PINEANANAS_SEEDS = ""
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

S_NAMES.PINEANANAS_OVERSIZED = "Giant Pineananas"
S______GENERIC.DESCRIBE.PINEANANAS_OVERSIZED = "What a big orange pinecone!"
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
S________WARLY.DESCRIBE.PINEANANAS_OVERSIZED = "I think of many sweet memori... err, dish!"
-- S_________WURT.DESCRIBE.PINEANANAS_OVERSIZED = ""
-- S_______WALTER.DESCRIBE.PINEANANAS_OVERSIZED = ""

S_NAMES.PINEANANAS_OVERSIZED_ROTTEN = "Giant Rotting Pineananas"
S_NAMES.FARM_PLANT_PINEANANAS = "Pineananas Tree"
S_NAMES.KNOWN_PINEANANAS_SEEDS = "Pineananas Seeds"
STRINGS.UI.PLANTREGISTRY.DESCRIPTIONS.PINEANANAS = "A straight foot is not afraid of a crooked shoe. -W"

-----

S_NAMES.PLANT_NORMAL_LEGION = "Crop"   --农作物(新型)
S______GENERIC.DESCRIBE.PLANT_NORMAL_LEGION =
{
    WITHERED = "What a pity! Waiting to be watered, but...",
    READY = "Oho! Waiting to be eaten!",
    FLORESCENCE = "Gee! Waiting for you to bear fruit.",
    YOUTH = "Meh. Waiting for you to bloom.",
    GROWING = "Mmmm. Waiting for you to grow up.",
}
-- S_______WILLOW.DESCRIBE.PLANT_NORMAL_LEGION =
-- {
--     WITHERED = "What a pity! Waiting to be watered, but...",
--     READY = "Oho! Waiting to be eaten!",
--     FLORESCENCE = "Gee! Waiting for you to bear fruit.",
--     YOUTH = "Meh. Waiting for you to bloom.",
--     GROWING = "Mmmm. Waiting for you to grow up.",
-- }
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
-- S___WATHGRITHR.DESCRIBE.PLANT_NORMAL_LEGION =
-- {
--     WITHERED = "What a pity! Waiting to be watered, but...",
--     READY = "Oho! Waiting to be eaten!",
--     FLORESCENCE = "Gee! Waiting for you to bear fruit.",
--     YOUTH = "Meh. Waiting for you to bloom.",
--     GROWING = "Mmmm. Waiting for you to grow up.",
-- }
-- S_______WEBBER.DESCRIBE.PLANT_NORMAL_LEGION =
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
    WITHERED = "Sorry, I should have paid special attention to you.",
    READY = "Oh, this is an old friend.",
    FLORESCENCE = "Look at you, blooming.",
    YOUTH = "Friend, be mature, OK?",
    GROWING = "Lovely child.",
}
S________WARLY.DESCRIBE.PLANT_NORMAL_LEGION =
{
    WITHERED = "Sorry, this dish is sold out.",
    READY = "Soon, your order will be ready.",
    FLORESCENCE = "Don't rush, your order will be ready in a minute.",
    YOUTH = "Be ready soon. Your order is growing.",
    GROWING = "Don't worry, the dish you ordered just sprouts.",
}
-- S_________WURT.DESCRIBE.PLANT_NORMAL_LEGION =
-- {
--     WITHERED = "What a pity! Waiting to be watered, but...",
--     READY = "Oho! Waiting to be eaten!",
--     FLORESCENCE = "Gee! Waiting for you to bear fruit.",
--     YOUTH = "Meh. Waiting for you to bloom.",
--     GROWING = "Mmmm. Waiting for you to grow up.",
-- }

S_NAMES.FARMINGDUNGBALL_ITEM = "Cultivated Soil Ball"    --栽培肥料球
S_RECIPE_DESC.FARMINGDUNGBALL_ITEM = "This is where the seeds should stay."
S______GENERIC.DESCRIBE.FARMINGDUNGBALL_ITEM = "Nausea! I don't want to know about the process of making it."
--S_______WILLOW.DESCRIBE.FARMINGDUNGBALL_ITEM = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.FARMINGDUNGBALL_ITEM = "Wolfgang can eat in one bite!"
S________WENDY.DESCRIBE.FARMINGDUNGBALL_ITEM = "Cinderella may have done this before."
S_________WX78.DESCRIBE.FARMINGDUNGBALL_ITEM = "IT'S NOT USELESS THAT EVERYONE HATES."
S_WICKERBOTTOM.DESCRIBE.FARMINGDUNGBALL_ITEM = "This method is usually used for maize cultivation."
--S_______WOODIE.DESCRIBE.FARMINGDUNGBALL_ITEM = "I'd prefer maple taffy..."
S______WAXWELL.DESCRIBE.FARMINGDUNGBALL_ITEM = "I'm becoming more and more like a farmer."
--S___WATHGRITHR.DESCRIBE.FARMINGDUNGBALL_ITEM = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.FARMINGDUNGBALL_ITEM = "Kind of like playing with mud, kind of disgusting."
--S_______WINONA.DESCRIBE.FARMINGDUNGBALL_ITEM = "Great to cool off after some hard physical labor."
S_______WORTOX.DESCRIBE.FARMINGDUNGBALL_ITEM = "Hee-hee, I should use this for snowball fights."

S_NAMES.FARMINGDUNGBALL = "A Pile of Cultivated Soil"    --栽培肥料堆
S______GENERIC.DESCRIBE.FARMINGDUNGBALL = "Nausea! I don't want to know about the process of making it."
--S_______WILLOW.DESCRIBE.FARMINGDUNGBALL = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.FARMINGDUNGBALL = "Wolfgang can eat in one bite!"
S________WENDY.DESCRIBE.FARMINGDUNGBALL = "Cinderella may have done this before."
S_________WX78.DESCRIBE.FARMINGDUNGBALL = "IT'S NOT USELESS THAT EVERYONE HATES."
S_WICKERBOTTOM.DESCRIBE.FARMINGDUNGBALL = "This method is usually used for maize cultivation."
--S_______WOODIE.DESCRIBE.FARMINGDUNGBALL = "I'd prefer maple taffy..."
S______WAXWELL.DESCRIBE.FARMINGDUNGBALL = "I'm becoming more and more like a farmer."
--S___WATHGRITHR.DESCRIBE.FARMINGDUNGBALL = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.FARMINGDUNGBALL = "Kind of like playing with mud, kind of disgusting."
--S_______WINONA.DESCRIBE.FARMINGDUNGBALL = "Great to cool off after some hard physical labor."
S_______WORTOX.DESCRIBE.FARMINGDUNGBALL = "Hey, who dropped this in a snowball fight?"

S_NAMES.CROPGNAT = "Pest Swarm"    --植害虫群
S______GENERIC.DESCRIBE.CROPGNAT = "Hey, stay away from my crops, pests!"
S_______WILLOW.DESCRIBE.CROPGNAT = "Do they like fire, too?"
S_____WOLFGANG.DESCRIBE.CROPGNAT = "Fortunately, they don't bite Wolfgang."
-- S________WENDY.DESCRIBE.CROPGNAT = "Baby's always so cute, grown one's not."
-- S_________WX78.DESCRIBE.CROPGNAT = "STICK ADDON INSTALLED"
S_WICKERBOTTOM.DESCRIBE.CROPGNAT = "Find ways to kill them early, or we'll get nothing!"
-- S_______WOODIE.DESCRIBE.CROPGNAT = "Hah. Not as funny as Chaplin."
-- S______WAXWELL.DESCRIBE.CROPGNAT = "Hm... No Monster child, no future trouble."
-- S___WATHGRITHR.DESCRIBE.CROPGNAT = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.CROPGNAT = "Broke the windows of my neighbours and they called me a pest."
-- S_______WINONA.DESCRIBE.CROPGNAT = "Neither the Keystone, nor a key thing."
-- S_______WORTOX.DESCRIBE.CROPGNAT = "Hey, who dropped this in a snowball fight?"
S_____WORMWOOD.DESCRIBE.CROPGNAT = "Some friends who would hurt a plant friend."

S_NAMES.CROPGNAT_INFESTER = "Gnat Swarm"    --叮咬虫群
S______GENERIC.DESCRIBE.CROPGNAT_INFESTER = "Be careful, these flying bugs bite."
S_______WILLOW.DESCRIBE.CROPGNAT_INFESTER = "Stupid bugs will be attracted by my fire."
S_____WOLFGANG.DESCRIBE.CROPGNAT_INFESTER = "Ouch! these little monsters bite!"
-- S________WENDY.DESCRIBE.CROPGNAT_INFESTER = "Baby's always so cute, grown one's not."
S_________WX78.DESCRIBE.CROPGNAT_INFESTER = "THEY BITE EVEN THE IRON?"
S_WICKERBOTTOM.DESCRIBE.CROPGNAT_INFESTER = "Aggressive and can be attracted by light."
-- S_______WOODIE.DESCRIBE.CROPGNAT_INFESTER = "Hah. Not as funny as Chaplin."
-- S______WAXWELL.DESCRIBE.CROPGNAT_INFESTER = "Hm... No Monster child, no future trouble."
-- S___WATHGRITHR.DESCRIBE.CROPGNAT_INFESTER = "I've somehow found a way to make it even LESS appealing!"
-- S_______WEBBER.DESCRIBE.CROPGNAT_INFESTER = "We don't want to grow up, do you?"
S_______WINONA.DESCRIBE.CROPGNAT_INFESTER = "Oh my, the noise is terrible."
S_______WORTOX.DESCRIBE.CROPGNAT_INFESTER = "Hah, you have to get used to this in the wild."
S_____WORMWOOD.DESCRIBE.CROPGNAT_INFESTER = "Some friends who would bite a friend."

S_NAMES.AHANDFULOFWINGS = "A Handful of Wings"    --一捧翅膀
S______GENERIC.DESCRIBE.AHANDFULOFWINGS = "A handful of very small insect wings."
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

S_NAMES.BOLTWINGOUT = "Boltwing-out"    --脱壳之翅
S_RECIPE_DESC.BOLTWINGOUT = "Make a bolt for it."
S______GENERIC.DESCRIBE.BOLTWINGOUT = "It's like a bolt out of threats."
-- S_______WILLOW.DESCRIBE.BOLTWINGOUT = "Stupid bugs will be attracted by my fire."
-- S_____WOLFGANG.DESCRIBE.BOLTWINGOUT = "Ouch! these little monsters bite!"
-- S________WENDY.DESCRIBE.BOLTWINGOUT = "Baby's always so cute, grown one's not."
-- S_________WX78.DESCRIBE.BOLTWINGOUT = "THEY BITE EVEN THE IRON?"
-- S_WICKERBOTTOM.DESCRIBE.BOLTWINGOUT = "Aggressive and can be attracted by light."
-- S_______WOODIE.DESCRIBE.BOLTWINGOUT = "Hah. Not as funny as Chaplin."
S______WAXWELL.DESCRIBE.BOLTWINGOUT = "Learning the way of insect survival."
S___WATHGRITHR.DESCRIBE.BOLTWINGOUT = "Tsk-tsk! A real warrior never runs away!"
-- S_______WEBBER.DESCRIBE.BOLTWINGOUT = "We don't want to grow up, do you?"
S_______WINONA.DESCRIBE.BOLTWINGOUT = "I just wanna run... hide it away!"
S_______WORTOX.DESCRIBE.BOLTWINGOUT = "Meh, I can do the same thing with souls."
-- S_____WORMWOOD.DESCRIBE.BOLTWINGOUT = "Some friends who would bite a friend."

S_NAMES.BOLTWINGOUT_SHUCK = "Post-eclosion Shuck"  --羽化后的壳
S______GENERIC.DESCRIBE.BOLTWINGOUT_SHUCK = "Hah! Most creatures don't know it's just a shuck."
S_______WILLOW.DESCRIBE.BOLTWINGOUT_SHUCK = "What a big fake bug, I can burn it!"
-- S_____WOLFGANG.DESCRIBE.BOLTWINGOUT_SHUCK = "Ouch! these little monsters bite!"
-- S________WENDY.DESCRIBE.BOLTWINGOUT_SHUCK = "Baby's always so cute, grown one's not."
S_________WX78.DESCRIBE.BOLTWINGOUT_SHUCK = "A CRAFTY BUG!"
-- S_WICKERBOTTOM.DESCRIBE.BOLTWINGOUT_SHUCK = "Aggressive and can be attracted by light."
-- S_______WOODIE.DESCRIBE.BOLTWINGOUT_SHUCK = "Hah. Not as funny as Chaplin."
S______WAXWELL.DESCRIBE.BOLTWINGOUT_SHUCK = "For the weak, escape is the best policy."
-- S___WATHGRITHR.DESCRIBE.BOLTWINGOUT_SHUCK = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.BOLTWINGOUT_SHUCK = "We'll not want our old skin after molting."
S_______WINONA.DESCRIBE.BOLTWINGOUT_SHUCK = "The shuck is not a shuck."
-- S_______WORTOX.DESCRIBE.BOLTWINGOUT_SHUCK = "Hah, you have to get used to this in the wild."
S_____WORMWOOD.DESCRIBE.BOLTWINGOUT_SHUCK = "Hey friend, are you still here?"

S_NAMES.CATMINT = "Catmint"   --猫薄荷
S______GENERIC.DESCRIBE.CATMINT = "It smells clean and natural."
-- S_______WILLOW.DESCRIBE.CATMINT = ""
S_____WOLFGANG.DESCRIBE.CATMINT = "Wolfgang misses chewing gum."
-- S________WENDY.DESCRIBE.CATMINT = ""
S_________WX78.DESCRIBE.CATMINT = "JUST SOME COMMON WEED LEAVES."
S_WICKERBOTTOM.DESCRIBE.CATMINT = "Seriously, mint is not the same plant as catmint."
-- S_______WOODIE.DESCRIBE.CATMINT = ""
-- S______WAXWELL.DESCRIBE.CATMINT = ""
-- S___WATHGRITHR.DESCRIBE.CATMINT = ""
S_______WEBBER.DESCRIBE.CATMINT = "How about feeding it to catcoons in the forest?"
-- S_______WINONA.DESCRIBE.CATMINT = ""
S_______WORTOX.DESCRIBE.CATMINT = "Nah, I don't like it."
S_____WORMWOOD.DESCRIBE.CATMINT = "Hello, fragrant friend."
S________WARLY.DESCRIBE.CATMINT = "I wish I could use it as a spice."
S_________WURT.DESCRIBE.CATMINT = "Good for vegetarianism, good for me."

S_NAMES.CATTENBALL = "Cat Wool Ball"   --猫线球
S______GENERIC.DESCRIBE.CATTENBALL = "Although it's poured from the stomach, it's lovely."
-- S_______WILLOW.DESCRIBE.CATTENBALL = ""
-- S_____WOLFGANG.DESCRIBE.CATTENBALL = ""
-- S________WENDY.DESCRIBE.CATTENBALL = ""
S_________WX78.DESCRIBE.CATTENBALL = "SMELLS LIKE A CAT."
-- S_WICKERBOTTOM.DESCRIBE.CATTENBALL = ""
-- S_______WOODIE.DESCRIBE.CATTENBALL = ""
-- S______WAXWELL.DESCRIBE.CATTENBALL = ""
-- S___WATHGRITHR.DESCRIBE.CATTENBALL = ""
S_______WEBBER.DESCRIBE.CATTENBALL = "We must have a toy show in our bed."
S_______WINONA.DESCRIBE.CATTENBALL = "Maybe it can be used to knit sweaters."
S_______WORTOX.DESCRIBE.CATTENBALL = "Look! it's the same color as me."
-- S_____WORMWOOD.DESCRIBE.CATTENBALL = ""
-- S________WARLY.DESCRIBE.CATTENBALL = ""
S_________WURT.DESCRIBE.CATTENBALL = "A witch living in the desert mirage would love this!"

--------------------------------------------------------------------------
--[[ flash and crush ]]--[[ 电闪雷鸣 ]]
--------------------------------------------------------------------------

STRINGS.UI.CRAFTING.ELECOURMALINE_ONE = "Use a elecourmaline to build a prototype!"
STRINGS.UI.CRAFTING.ELECOURMALINE_TWO = "It seems that this stone is not fully activated!"
STRINGS.UI.CRAFTING.ELECOURMALINE_THREE = "It seems that this stone is not fully activated!"

S_NAMES.ELECOURMALINE = "Elecourmaline"    --电气重铸台
S______GENERIC.DESCRIBE.ELECOURMALINE = "It contains the power of electricity and creation."
--S_______WILLOW.DESCRIBE.ELECOURMALINE = "Oh! So cute, like my Bernie."
--S_____WOLFGANG.DESCRIBE.ELECOURMALINE = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.ELECOURMALINE = "Baby's always so cute, grown one's not."
S_________WX78.DESCRIBE.ELECOURMALINE = "I CAN CHARGE MYSELF WITH JUST A LITTLE PIECE."
S_WICKERBOTTOM.DESCRIBE.ELECOURMALINE = "I heard that the stone will discharge when heated."
--S_______WOODIE.DESCRIBE.ELECOURMALINE = "The axe that can't chop is not a good axe."
S______WAXWELL.DESCRIBE.ELECOURMALINE = "Another of Them is coming. Great."
--S___WATHGRITHR.DESCRIBE.ELECOURMALINE = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.ELECOURMALINE = "We don't want to grow up, do you?"
--S_______WINONA.DESCRIBE.ELECOURMALINE = "Great to cool off after some hard physical labor."

S_NAMES.ELECOURMALINE_KEYSTONE = "Key Stone"    --要石
S______GENERIC.DESCRIBE.ELECOURMALINE_KEYSTONE = "Natural creativity."
--S_______WILLOW.DESCRIBE.ELECOURMALINE_KEYSTONE = "Oh! So cute, like my Bernie."
--S_____WOLFGANG.DESCRIBE.ELECOURMALINE_KEYSTONE = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.ELECOURMALINE_KEYSTONE = "Baby's always so cute, grown one's not."
--S_________WX78.DESCRIBE.ELECOURMALINE_KEYSTONE = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.ELECOURMALINE_KEYSTONE = "Well, isn't that refreshing?"
S_______WOODIE.DESCRIBE.ELECOURMALINE_KEYSTONE = "Hah. Not as funny as Chaplin."
--S______WAXWELL.DESCRIBE.ELECOURMALINE_KEYSTONE = "Hm... No Monster child, no future trouble."
--S___WATHGRITHR.DESCRIBE.ELECOURMALINE_KEYSTONE = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.ELECOURMALINE_KEYSTONE = "We don't want to grow up, do you?"
S_______WINONA.DESCRIBE.ELECOURMALINE_KEYSTONE = "Neither the Keystone, nor a key thing."

S_NAMES.FIMBUL_AXE = "Fimbul Axe"    --芬布尔斧
-- S_RECIPE_DESC.FIMBUL_AXE = "Flash and crush!" --这个不能制作
S______GENERIC.DESCRIBE.FIMBUL_AXE = "BOOM SHAKA LAKA!"
--S_______WILLOW.DESCRIBE.FIMBUL_AXE = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.FIMBUL_AXE = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.FIMBUL_AXE = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.FIMBUL_AXE = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.FIMBUL_AXE = "Well, isn't that refreshing?"
S_______WOODIE.DESCRIBE.FIMBUL_AXE = "The axe that can't chop is not a good axe."
--S______WAXWELL.DESCRIBE.FIMBUL_AXE = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.FIMBUL_AXE = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.FIMBUL_AXE = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.FIMBUL_AXE = "Great to cool off after some hard physical labor."

S_NAMES.HAT_COWBOY = "Stetson"    --牛仔帽
S_RECIPE_DESC.HAT_COWBOY = "Do you want to be a master of taming?"
S______GENERIC.DESCRIBE.HAT_COWBOY = "Aha! let's riiiiiiide!"
-- S_______WILLOW.DESCRIBE.HAT_COWBOY = ""
-- S_____WOLFGANG.DESCRIBE.HAT_COWBOY = ""
-- S________WENDY.DESCRIBE.HAT_COWBOY = ""
-- S_________WX78.DESCRIBE.HAT_COWBOY = ""
-- S_WICKERBOTTOM.DESCRIBE.HAT_COWBOY = ""
-- S_______WOODIE.DESCRIBE.HAT_COWBOY = ""
-- S______WAXWELL.DESCRIBE.HAT_COWBOY = ""
-- S___WATHGRITHR.DESCRIBE.HAT_COWBOY = ""
-- S_______WEBBER.DESCRIBE.HAT_COWBOY = ""
-- S_______WINONA.DESCRIBE.HAT_COWBOY = ""

S_NAMES.DUALWRENCH = "Dual-wrench"    --扳手-双用型
S_RECIPE_DESC.DUALWRENCH = "Definitely the wrong way to use it."
S______GENERIC.DESCRIBE.DUALWRENCH = "This is definitely the wrong way to use it."
--S_______WILLOW.DESCRIBE.DUALWRENCH = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DUALWRENCH = "Wolfgang can eat in one bite!"
S________WENDY.DESCRIBE.DUALWRENCH = "I hope I won't wrench my hand any more."
--S_________WX78.DESCRIBE.DUALWRENCH = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DUALWRENCH = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DUALWRENCH = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DUALWRENCH = "Hm... I don't know what I was expecting."
S___WATHGRITHR.DESCRIBE.DUALWRENCH = "A weapon for workmen, smash!"
S_______WEBBER.DESCRIBE.DUALWRENCH = "Let's not wrench our hands again."
S_______WINONA.DESCRIBE.DUALWRENCH = "My, my! my best wrench!"

S_NAMES.ELECARMET = "Elecarmet"    --莱克阿米特
S______GENERIC.DESCRIBE.ELECARMET = "I thought it was the end, but just the beginning."
--S_______WILLOW.DESCRIBE.ELECARMET = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.ELECARMET = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.ELECARMET = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.ELECARMET = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.ELECARMET = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.ELECARMET = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.ELECARMET = "Hm... I don't know what I was expecting."
S___WATHGRITHR.DESCRIBE.ELECARMET = "My greatest enemy, called Fimbul."
--S_______WEBBER.DESCRIBE.ELECARMET = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.ELECARMET = "Great to cool off after some hard physical labor."

S_NAMES.TOURMALINECORE = "Tourmaline"    --电气石
S______GENERIC.DESCRIBE.TOURMALINECORE = "Oh my, can I touch it?"
--S_______WILLOW.DESCRIBE.TOURMALINECORE = "Oh! So cute, like my Bernie."
--S_____WOLFGANG.DESCRIBE.TOURMALINECORE = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.TOURMALINECORE = "Baby's always so cute, grown one's not."
S_________WX78.DESCRIBE.TOURMALINECORE = "THE CORE OF ENERGY, THE ENERGY OF ME!"
--S_WICKERBOTTOM.DESCRIBE.TOURMALINECORE = "Well, isn't that refreshing?"
-- S_______WOODIE.DESCRIBE.TOURMALINECORE = "Hah. Not as funny as Chaplin."
--S______WAXWELL.DESCRIBE.TOURMALINECORE = "Hm... No Monster child, no future trouble."
--S___WATHGRITHR.DESCRIBE.TOURMALINECORE = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.TOURMALINECORE = "We don't want to grow up, do you?"
-- S_______WINONA.DESCRIBE.TOURMALINECORE = "Neither the Keystone, nor a key thing."

S_NAMES.ICIRE_ROCK = "Icire Stone"   --鸳鸯石
S_RECIPE_DESC.ICIRE_ROCK = "Blending of iciness and hotness."
S______GENERIC.DESCRIBE.ICIRE_ROCK =
{
    FROZEN = "Like Snowpiercer.",
    COLD = "The winter is coming.",
    GENERIC = "A precious stone, neither a gem, nor a rock.",
    WARM = "Can spring be far behind?",
    HOT = "In the heat of the sun.",
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

S_NAMES.GUITAR_MIGUEL = "Miguel's guitar"    --米格尔的吉他
S_RECIPE_DESC.GUITAR_MIGUEL = "Being a legendary guitarist."
S______GENERIC.DESCRIBE.GUITAR_MIGUEL = "I'll cross life and death to make you remember me!"
--S_______WILLOW.DESCRIBE.GUITAR_MIGUEL = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.GUITAR_MIGUEL = "Wolfgang can eat in one bite!"
-- S________WENDY.DESCRIBE.GUITAR_MIGUEL = "Hello from the other side, Abigail."
S_________WX78.DESCRIBE.GUITAR_MIGUEL = "NOT MY BUILD FUNCTION TO IMPRESS OTHERS BY MELODY."
--S_WICKERBOTTOM.DESCRIBE.GUITAR_MIGUEL = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.GUITAR_MIGUEL = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.GUITAR_MIGUEL = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.GUITAR_MIGUEL = "A weapon for workmen, smash!"
-- S_______WEBBER.DESCRIBE.GUITAR_MIGUEL = "Let's not wrench our hands again."
-- S_______WINONA.DESCRIBE.GUITAR_MIGUEL = "My, my! my best wrench!"

S_NAMES.WEB_HUMP_ITEM = "Territory Mark"    --蛛网标记，物品
S_RECIPE_DESC.WEB_HUMP_ITEM = "Swear your territorial sovereignty!"
S______GENERIC.DESCRIBE.WEB_HUMP_ITEM = "Anyway, it's not what I want to use."
-- S_______WILLOW.DESCRIBE.WEB_HUMP_ITEM = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.WEB_HUMP_ITEM = "Wolfgang can eat in one bite!"
-- S________WENDY.DESCRIBE.WEB_HUMP_ITEM = "Hello from the other side, Abigail."
S_________WX78.DESCRIBE.WEB_HUMP = "OBJECT CLASS: THAUMIEL"
-- S_WICKERBOTTOM.DESCRIBE.WEB_HUMP_ITEM = "Well, isn't that refreshing?"
-- S_______WOODIE.DESCRIBE.WEB_HUMP_ITEM = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.WEB_HUMP_ITEM = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.WEB_HUMP_ITEM = "A weapon for workmen, smash!"
S_______WEBBER.DESCRIBE.WEB_HUMP_ITEM = "Indeed, we have too little territory."
-- S_______WINONA.DESCRIBE.WEB_HUMP_ITEM = "My, my! my best wrench!"

S_NAMES.WEB_HUMP = "Territory Mark"    --蛛网标记
S______GENERIC.DESCRIBE.WEB_HUMP =
{
    GENERIC = "That's really too much, spiders!",
    TRYDIGUP = "It's not easy to get rid of this.",
}
-- S_______WILLOW.DESCRIBE.WEB_HUMP = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.WEB_HUMP = "Wolfgang can eat in one bite!"
-- S________WENDY.DESCRIBE.WEB_HUMP = "Hello from the other side, Abigail."
S_________WX78.DESCRIBE.WEB_HUMP = 
{
    GENERIC = "SPECIAL CONTAINMENT PROCEDURES.",
    TRYDIGUP = "IT CAN NOT BE RELOCATED.",
}
-- S_WICKERBOTTOM.DESCRIBE.WEB_HUMP = "Well, isn't that refreshing?"
-- S_______WOODIE.DESCRIBE.WEB_HUMP = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.WEB_HUMP = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.WEB_HUMP = "A weapon for workmen, smash!"
S_______WEBBER.DESCRIBE.WEB_HUMP =
{
    GENERIC = "We are very popular with the residents here.",
    TRYDIGUP = "We got this!",
}
-- S_______WINONA.DESCRIBE.WEB_HUMP = "My, my! my best wrench!"

S_NAMES.SADDLE_BAGGAGE = "Baggage Saddle"    --驮运鞍具
S_RECIPE_DESC.SADDLE_BAGGAGE = "Traditional piggyback transport."
S______GENERIC.DESCRIBE.SADDLE_BAGGAGE = "Hope not to be my friend's last straw."
-- S_______WILLOW.DESCRIBE.SADDLE_BAGGAGE = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.SADDLE_BAGGAGE = "Wolfgang can eat in one bite!"
-- S________WENDY.DESCRIBE.SADDLE_BAGGAGE = "Hello from the other side, Abigail."
-- S_________WX78.DESCRIBE.SADDLE_BAGGAGE = "NOT MY BUILD FUNCTION TO IMPRESS OTHERS BY MELODY."
-- S_WICKERBOTTOM.DESCRIBE.SADDLE_BAGGAGE = "Well, isn't that refreshing?"
-- S_______WOODIE.DESCRIBE.SADDLE_BAGGAGE = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.SADDLE_BAGGAGE = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.SADDLE_BAGGAGE = "A weapon for workmen, smash!"
-- S_______WEBBER.DESCRIBE.SADDLE_BAGGAGE = "Indeed, we have too little territory."
-- S_______WINONA.DESCRIBE.SADDLE_BAGGAGE = "My, my! my best wrench!"

S_NAMES.TRIPLESHOVELAXE = "Triple-shovelaxe"    --斧铲-三用型
S_RECIPE_DESC.TRIPLESHOVELAXE = "A low-cost multi-functional tool."
S______GENERIC.DESCRIBE.TRIPLESHOVELAXE = "Oh my, this tool is so-ooooo good!"
-- S_______WILLOW.DESCRIBE.TRIPLESHOVELAXE = ""
-- S_____WOLFGANG.DESCRIBE.TRIPLESHOVELAXE = ""
-- S________WENDY.DESCRIBE.TRIPLESHOVELAXE = ""
S_________WX78.DESCRIBE.TRIPLESHOVELAXE = "IT'S JUST A COMBINATION TOOL."
-- S_WICKERBOTTOM.DESCRIBE.TRIPLESHOVELAXE = ""
S_______WOODIE.DESCRIBE.TRIPLESHOVELAXE = "It's amazing! Oh, I hope Lucy didn't hear it."
-- S______WAXWELL.DESCRIBE.TRIPLESHOVELAXE = ""
-- S___WATHGRITHR.DESCRIBE.TRIPLESHOVELAXE = ""
-- S_______WEBBER.DESCRIBE.TRIPLESHOVELAXE = ""
-- S_______WINONA.DESCRIBE.TRIPLESHOVELAXE = ""
-- S_______WORTOX.DESCRIBE.TRIPLESHOVELAXE = ""
S_____WORMWOOD.DESCRIBE.TRIPLESHOVELAXE = "Ugh, a sharp weapon of the natural destroyer."
-- S________WARLY.DESCRIBE.TRIPLESHOVELAXE = ""
-- S_________WURT.DESCRIBE.TRIPLESHOVELAXE = ""

S_NAMES.HAT_ALBICANS_MUSHROOM = "Albicans Funcap"    --素白蘑菇帽
S_RECIPE_DESC.HAT_ALBICANS_MUSHROOM = "Let lots of antibiotics stick to your head."
S______GENERIC.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "A hat made of antibiotic-rich fungi.",
    HUNGER = "Hungry, I don't have the energy to do this.",
}
-- S_______WILLOW.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
-- S_____WOLFGANG.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
-- S________WENDY.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
S_________WX78.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "SOME CREATURES CROWD OUT OTHERS.",
    HUNGER = "RUN OUT OF FUEL!",
}
S_WICKERBOTTOM.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "Has a good resistance to harmful bacteria.",
    HUNGER = "What if someone is allergic to antibiotics.",
}
-- S_______WOODIE.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
-- S______WAXWELL.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
-- S___WATHGRITHR.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
S_______WEBBER.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "The head shakes and the disease escapes.",
    HUNGER = "We are so hungry.",
}
-- S_______WINONA.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
-- S_______WORTOX.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
S_____WORMWOOD.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "My friends, we are saved.",
    HUNGER = "My stomach is empty!",
}
S________WARLY.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "Can I break a piece and cook it?",
    HUNGER = "Nothing magic is ever done on an empty stomach!",
}
S_________WURT.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "Maybe it can treat plants infected with fungi.",
    HUNGER = "I need fresh food!",
}

S_NAMES.ALBICANS_CAP = "Albicans Cap" --采摘的素白菇
S______GENERIC.DESCRIBE.ALBICANS_CAP = "It's the first time I've seen such delicacies."
-- S_______WILLOW.DESCRIBE.ALBICANS_CAP = ""
-- S_____WOLFGANG.DESCRIBE.ALBICANS_CAP = ""
-- S________WENDY.DESCRIBE.ALBICANS_CAP = ""
-- S_________WX78.DESCRIBE.ALBICANS_CAP = ""
S_WICKERBOTTOM.DESCRIBE.ALBICANS_CAP = "Strange, it should grow deep in the bamboo forest."
-- S_______WOODIE.DESCRIBE.ALBICANS_CAP = ""
-- S______WAXWELL.DESCRIBE.ALBICANS_CAP = ""
-- S___WATHGRITHR.DESCRIBE.ALBICANS_CAP = ""
S_______WEBBER.DESCRIBE.ALBICANS_CAP = "Mushroom in skirt!"
-- S_______WINONA.DESCRIBE.ALBICANS_CAP = ""
S_______WORTOX.DESCRIBE.ALBICANS_CAP = "Side to give up while love you."
-- S_____WORMWOOD.DESCRIBE.ALBICANS_CAP = ""
-- S________WARLY.DESCRIBE.ALBICANS_CAP = ""
-- S_________WURT.DESCRIBE.ALBICANS_CAP = ""
-- S_______WALTER.DESCRIBE.ALBICANS_CAP = ""

S_NAMES.SOUL_CONTRACTS = "Soul Contracts" --灵魂契约
S_RECIPE_DESC.SOUL_CONTRACTS = "To further shackle the soul."
S______GENERIC.DESCRIBE.SOUL_CONTRACTS =
{
    GENERIC = "What devil would have thought of such an evil thing!",
    ONLYONE = "There must be limits to evil!",
}
-- S_______WILLOW.DESCRIBE.SOUL_CONTRACTS = ""
-- S_____WOLFGANG.DESCRIBE.SOUL_CONTRACTS = ""
S________WENDY.DESCRIBE.SOUL_CONTRACTS =
{
    GENERIC = "Roaring, crying, regretting...",
    ONLYONE = "No turning back once the hands are stained.",
}
S_________WX78.DESCRIBE.SOUL_CONTRACTS =
{
    GENERIC = "THIS ENHANCES THE HATE MODULE!",
    ONLYONE = "OVERLOAD THE HATE MODULE!",
}
-- S_WICKERBOTTOM.DESCRIBE.SOUL_CONTRACTS = ""
-- S_______WOODIE.DESCRIBE.SOUL_CONTRACTS = ""
-- S______WAXWELL.DESCRIBE.SOUL_CONTRACTS = ""
-- S___WATHGRITHR.DESCRIBE.SOUL_CONTRACTS = ""
-- S_______WEBBER.DESCRIBE.SOUL_CONTRACTS = ""
-- S_______WINONA.DESCRIBE.SOUL_CONTRACTS = ""
S_______WORTOX.DESCRIBE.SOUL_CONTRACTS =
{
    GENERIC = "Hohoho, I can control my soulself better!",
    ONLYONE = "I don't want to lose myself.",
}
S_____WORMWOOD.DESCRIBE.SOUL_CONTRACTS =
{
    GENERIC = "The glitter on my chest locked heart too.",
    ONLYONE = "No need.",
}
-- S________WARLY.DESCRIBE.SOUL_CONTRACTS = ""
S_________WURT.DESCRIBE.SOUL_CONTRACTS =
{
    GENERIC = "Evil, why have you stolen so much love?",
    ONLYONE = "Enough negative emotions.",
}

--------------------------------------------------------------------------
--[[ desert secret ]]--[[ 尘市蜃楼 ]]
--------------------------------------------------------------------------

S_NAMES.DESERTDEFENSE = "Desert Defense"   --砂之抵御
S_RECIPE_DESC.DESERTDEFENSE = "Use the earth power to protect and fight back."
S______GENERIC.DESCRIBE.DESERTDEFENSE =
{
    GENERIC = "I can feel the power of the earth, maybe?",
    WEAK = "Maybe I can't use it in the rain!",
    INSANE = "Maybe I'm too insane to do it!",
}
--[[
--S_______WILLOW.DESCRIBE.DESERTDEFENSE = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DESERTDEFENSE = "Wolfgang can eat in one bite!"
S________WENDY.DESCRIBE.DESERTDEFENSE = "I can't always escape, I have to face everything."
S_________WX78.DESCRIBE.DESERTDEFENSE = "FIREWALL, START!"
--S_WICKERBOTTOM.DESCRIBE.DESERTDEFENSE = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DESERTDEFENSE = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DESERTDEFENSE = "Hm... I don't know what I was expecting."
S___WATHGRITHR.DESCRIBE.DESERTDEFENSE = "Be my mirror, my sword and shield!"
--S_______WEBBER.DESCRIBE.DESERTDEFENSE = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DESERTDEFENSE = "Great to cool off after some hard physical labor."
]]--

S_NAMES.SHYERRYTREE = "Treembling"    --颤栗树
S______GENERIC.DESCRIBE.SHYERRYTREE =
{
    BURNING = "It's on fire!",
    GENERIC = "Is that a tree with only one or two leaves?",
}
-- S_______WILLOW.DESCRIBE.SHYERRYTREE = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.SHYERRYTREE = "Wolfgang can eat in one bite!"
-- S________WENDY.DESCRIBE.SHYERRYTREE = "Hello from the other side, Abigail."
-- S_________WX78.DESCRIBE.SHYERRYTREE = "NOT MY BUILD FUNCTION TO IMPRESS OTHERS BY MELODY."
S_WICKERBOTTOM.DESCRIBE.SHYERRYTREE =
{
    BURNING = "Don't worry. The fire won't burn the part underground.",
    GENERIC = "In fact, it's not really the trunk that grows outside.",
}
-- S_______WOODIE.DESCRIBE.SHYERRYTREE = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.SHYERRYTREE = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.SHYERRYTREE = "A weapon for workmen, smash!"
-- S_______WEBBER.DESCRIBE.SHYERRYTREE = "Indeed, we have too little territory."
-- S_______WINONA.DESCRIBE.SHYERRYTREE = "My, my! my best wrench!"

S_NAMES.SHYERRYTREE_PLANTED = "Planted Treembling"    --栽种的颤栗树
S______GENERIC.DESCRIBE.SHYERRYTREE_PLANTED =
{
    BURNING = "A precious tree in burning!",
    GENERIC = "Hard transplanted tree still have only one or two leaves.",
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

S_NAMES.SHYERRYFLOWER = "Abloom Treembling"    --颤栗花
S______GENERIC.DESCRIBE.SHYERRYFLOWER =
{
    BURNING = "Precious flower in burning!",
    GENERIC = "It looks as if it did bear before it blossomed.",
}
-- S_______WILLOW.DESCRIBE.SHYERRYFLOWER = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.SHYERRYFLOWER = "Wolfgang can eat in one bite!"
-- S________WENDY.DESCRIBE.SHYERRYFLOWER = "Hello from the other side, Abigail."
-- S_________WX78.DESCRIBE.SHYERRYFLOWER = "NOT MY BUILD FUNCTION TO IMPRESS OTHERS BY MELODY."
S_WICKERBOTTOM.DESCRIBE.SHYERRYFLOWER =
{
    BURNING = "Unfortunately, this tree rarely bears fruit.",
    GENERIC = "In fact, the part that looks like flower isn't a real flower.",
}
-- S_______WOODIE.DESCRIBE.SHYERRYFLOWER = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.SHYERRYFLOWER = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.SHYERRYFLOWER = "A weapon for workmen, smash!"
-- S_______WEBBER.DESCRIBE.SHYERRYFLOWER = "Indeed, we have too little territory."
-- S_______WINONA.DESCRIBE.SHYERRYFLOWER = "My, my! my best wrench!"

S_NAMES.SHYERRY = "Shyerry"    --颤栗果
S______GENERIC.DESCRIBE.SHYERRY = "Wow, what a big blueberry!"
-- S_______WILLOW.DESCRIBE.SHYERRY = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.SHYERRY = "Wolfgang can eat in one bite!"
-- S________WENDY.DESCRIBE.SHYERRY = "Hello from the other side, Abigail."
-- S_________WX78.DESCRIBE.SHYERRY = "NOT MY BUILD FUNCTION TO IMPRESS OTHERS BY MELODY."
S_WICKERBOTTOM.DESCRIBE.SHYERRY = "Rich in nutrition, good for your health."
-- S_______WOODIE.DESCRIBE.SHYERRY = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.SHYERRY = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.SHYERRY = "A weapon for workmen, smash!"
-- S_______WEBBER.DESCRIBE.SHYERRY = "Indeed, we have too little territory."
-- S_______WINONA.DESCRIBE.SHYERRY = "My, my! my best wrench!"

S_NAMES.SHYERRY_COOKED = "Roasted Shyerry"    --烤颤栗果
S______GENERIC.DESCRIBE.SHYERRY_COOKED = "Wow, what a blue roasted orange!"
-- S_______WILLOW.DESCRIBE.SHYERRY_COOKED = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.SHYERRY_COOKED = "Wolfgang can eat in one bite!"
-- S________WENDY.DESCRIBE.SHYERRY_COOKED = "Hello from the other side, Abigail."
-- S_________WX78.DESCRIBE.SHYERRY_COOKED = "NOT MY BUILD FUNCTION TO IMPRESS OTHERS BY MELODY."
S_WICKERBOTTOM.DESCRIBE.SHYERRY_COOKED = "Well, the nutrients were all decomposed."
-- S_______WOODIE.DESCRIBE.SHYERRY_COOKED = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.SHYERRY_COOKED = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.SHYERRY_COOKED = "A weapon for workmen, smash!"
-- S_______WEBBER.DESCRIBE.SHYERRY_COOKED = "Indeed, we have too little territory."
-- S_______WINONA.DESCRIBE.SHYERRY_COOKED = "My, my! my best wrench!"

S_NAMES.SHYERRYLOG = "Big Plancon"    --宽大的木墩
S______GENERIC.DESCRIBE.SHYERRYLOG =
{
    BURNING = "It's going to be a big fire.",
    GENERIC = "Suitable for woodworking.",
}
-- S_______WILLOW.DESCRIBE.SHYERRYLOG = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.SHYERRYLOG = "Wolfgang can eat in one bite!"
-- S________WENDY.DESCRIBE.SHYERRYLOG = "Hello from the other side, Abigail."
-- S_________WX78.DESCRIBE.SHYERRYLOG = "NOT MY BUILD FUNCTION TO IMPRESS OTHERS BY MELODY."
-- S_WICKERBOTTOM.DESCRIBE.SHYERRYLOG = "Well, isn't that refreshing?"
-- S_______WOODIE.DESCRIBE.SHYERRYLOG = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.SHYERRYLOG = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.SHYERRYLOG = "A weapon for workmen, smash!"
-- S_______WEBBER.DESCRIBE.SHYERRYLOG = "Indeed, we have too little territory."
-- S_______WINONA.DESCRIBE.SHYERRYLOG = "My, my! my best wrench!"

-- S_NAMES.FENCE_SHYERRY = "Pastoral Fence"    --田园栅栏
-- S______GENERIC.DESCRIBE.FENCE_SHYERRY = "Disappointing, it's no different from ordinary fences."
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

-- S_NAMES.FENCE_SHYERRY_ITEM = "Pastoral Fence"    --田园栅栏 item
-- S_RECIPE_DESC.FENCE_SHYERRY_ITEM = "Surround your farmland."
-- S______GENERIC.DESCRIBE.FENCE_SHYERRY_ITEM = "Will the place surrounded by it become farmland?"
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

S_NAMES.GUITAR_WHITEWOOD = "White Wood Guitar"    --白木吉他
S_RECIPE_DESC.GUITAR_WHITEWOOD = "A guitar, waiting to be played."
S______GENERIC.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "I really just want to play to you.",
    FAILED = "Oops, slow down a beat.",
    HUNGRY = "Too tired to play.",
}
-- S_______WILLOW.DESCRIBE.GUITAR_WHITEWOOD = ""
-- S_____WOLFGANG.DESCRIBE.GUITAR_WHITEWOOD = ""
S________WENDY.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "Abigail tried, but she didn't have that talent, hah.",
    FAILED = "It's about the consistency of the beat.",
    HUNGRY = "Hunger affects my melody.",
}
S_________WX78.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "THOSE PRIMITIVE CREATURES LOVE IT.",
    FAILED = "WHY AM I THE ONE TO COOPERATE WITH.",
    HUNGRY = "LOW POWER, LIMITED FUNCTION.",
}
S_WICKERBOTTOM.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "Only four strings? Not enough to play it alone.",
    FAILED = "My cooperation is not perfect.",
    HUNGRY = "Not in the mood for this.",
}
-- S_______WOODIE.DESCRIBE.GUITAR_WHITEWOOD = ""
S______WAXWELL.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "The violin is more elegant.",
    FAILED = "Well, I'm an assistant now?",
    HUNGRY = "Now, time for me to eat, and the others play.",
}
-- S___WATHGRITHR.DESCRIBE.GUITAR_WHITEWOOD = ""
-- S_______WEBBER.DESCRIBE.GUITAR_WHITEWOOD = ""
S_______WINONA.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "It's missing the scale.",
    FAILED = "Sorry I didn't catch up, try again?",
    HUNGRY = "How can you work if you are hungry!",
}
S_______WORTOX.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "Hee hee, that's why humans interest me so much.",
    FAILED = "Hah, this is so funny.",
    HUNGRY = "Hey! that's not what's pressing.",
}
-- S_____WORMWOOD.DESCRIBE.GUITAR_WHITEWOOD = ""
-- S________WARLY.DESCRIBE.GUITAR_WHITEWOOD = ""
-- S_________WURT.DESCRIBE.GUITAR_WHITEWOOD = ""
S_______WALTER.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "You'll be surprised. I can play it when I'm three.",
    FAILED = "Don't give up. I'll make it.",
    HUNGRY = "There's the dinner bell, you know.",
}

-- S_NAMES.TOY_SPONGEBOB = "Spongebob Toy"    --玩具小海绵
-- S______GENERIC.DESCRIBE.TOY_SPONGEBOB = "Who is it waiting for?"
-- S_______WILLOW.DESCRIBE.TOY_SPONGEBOB = ""
-- S_____WOLFGANG.DESCRIBE.TOY_SPONGEBOB = ""
-- S________WENDY.DESCRIBE.TOY_SPONGEBOB = "The flower falls, the spring goes."
-- S_________WX78.DESCRIBE.TOY_SPONGEBOB = ""
-- S_WICKERBOTTOM.DESCRIBE.TOY_SPONGEBOB = "It says that there is no place to vent one's enthusiasm."
-- S_______WOODIE.DESCRIBE.TOY_SPONGEBOB = "It also looks forward to the future, that embracing day."
-- S______WAXWELL.DESCRIBE.TOY_SPONGEBOB = "Life is so long, used to be with loneliness."
-- S___WATHGRITHR.DESCRIBE.TOY_SPONGEBOB = "I'm not looking for somebody with some superhuman gifts."
-- S_______WEBBER.DESCRIBE.TOY_SPONGEBOB = "Love it."
-- S_______WINONA.DESCRIBE.TOY_SPONGEBOB = ""
-- S_______WORTOX.DESCRIBE.TOY_SPONGEBOB = ""
-- S_____WORMWOOD.DESCRIBE.TOY_SPONGEBOB = ""
-- S________WARLY.DESCRIBE.TOY_SPONGEBOB = "Just something I can turn to, somebody I can kiss."
-- S_________WURT.DESCRIBE.TOY_SPONGEBOB = ""
-- S_______WALTER.DESCRIBE.TOY_SPONGEBOB = ""

-- S_NAMES.TOY_PATRICKSTAR = "Patrickstar Toy"    --玩具小海星
-- S______GENERIC.DESCRIBE.TOY_PATRICKSTAR = "Moving towards its goal."
-- S_______WILLOW.DESCRIBE.TOY_PATRICKSTAR = ""
-- S_____WOLFGANG.DESCRIBE.TOY_PATRICKSTAR = ""
-- S________WENDY.DESCRIBE.TOY_PATRICKSTAR = "Someone I miss is far away."
-- S_________WX78.DESCRIBE.TOY_PATRICKSTAR = ""
-- S_WICKERBOTTOM.DESCRIBE.TOY_PATRICKSTAR = "It says that time always fades everything."
-- S_______WOODIE.DESCRIBE.TOY_PATRICKSTAR = "It is also full of contradictions, sometimes at a loss."
-- S______WAXWELL.DESCRIBE.TOY_PATRICKSTAR = "Life is so short, hard and ordinary."
-- S___WATHGRITHR.DESCRIBE.TOY_PATRICKSTAR = ""
-- S_______WEBBER.DESCRIBE.TOY_PATRICKSTAR = "Adore it."
-- S_______WINONA.DESCRIBE.TOY_PATRICKSTAR = ""
-- S_______WORTOX.DESCRIBE.TOY_PATRICKSTAR = ""
-- S_____WORMWOOD.DESCRIBE.TOY_PATRICKSTAR = ""
-- S________WARLY.DESCRIBE.TOY_PATRICKSTAR = ""
-- S_________WURT.DESCRIBE.TOY_PATRICKSTAR = ""
-- S_______WALTER.DESCRIBE.TOY_PATRICKSTAR = ""

S_NAMES.PINKSTAFF = "Illusion Staff"    --幻象法杖
S_RECIPE_DESC.PINKSTAFF = "Illusion is eternal beauty."
S______GENERIC.DESCRIBE.PINKSTAFF = "Is this real? I'm imagining a real illusion."
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

S_NAMES.THEEMPERORSCROWN = "The Emperor's Crown"  --皇帝的王冠
S_RECIPE_DESC.THEEMPERORSCROWN = "The symbol of sage."
S______GENERIC.DESCRIBE.THEEMPERORSCROWN = "A wise man don't believe this symbol."
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

S_NAMES.THEEMPERORSMANTLE = "The Emperor's Mantle"    --皇帝的披风
S_RECIPE_DESC.THEEMPERORSMANTLE = "The symbol of gallant."
S______GENERIC.DESCRIBE.THEEMPERORSMANTLE = "A fearless man don't believe this symbol."
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

S_NAMES.THEEMPERORSSCEPTER = "The Emperor's Scepter"  --皇帝的权杖
S_RECIPE_DESC.THEEMPERORSSCEPTER = "The symbol of dignitary."
S______GENERIC.DESCRIBE.THEEMPERORSSCEPTER = "A guileless man don't believe this symbol."
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

S_NAMES.THEEMPERORSPENDANT = "The Emperor's Pendant" --皇帝的吊坠
S_RECIPE_DESC.THEEMPERORSPENDANT = "The symbol of will."
S______GENERIC.DESCRIBE.THEEMPERORSPENDANT = "A determined man don't believe this symbol."
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

S_NAMES.BACKCUB = "Back Cub"    --靠背熊
S______GENERIC.DESCRIBE.BACKCUB = "Hey, I think it likes my back."
S_______WILLOW.DESCRIBE.BACKCUB = "Oh! So cute, like my Bernie."
--S_____WOLFGANG.DESCRIBE.BACKCUB = "Wolfgang can eat in one bite!"
S________WENDY.DESCRIBE.BACKCUB = "Baby's always so cute, grown one's not."
--S_________WX78.DESCRIBE.BACKCUB = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.BACKCUB = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.BACKCUB = "The axe that can't chop is not a good axe."
S______WAXWELL.DESCRIBE.BACKCUB = "Hm... No Monster child, no future trouble."
--S___WATHGRITHR.DESCRIBE.BACKCUB = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.BACKCUB = "We don't want to grow up, do you?"
-- S_______WINONA.DESCRIBE.BACKCUB = "Great to cool off after some hard physical labor."
-- S_______WORTOX.DESCRIBE.BACKCUB = "Hey, who dropped this in a snowball fight?"
-- S_____WORMWOOD.DESCRIBE.BACKCUB = "Hey friend, are you still here?"

STRINGS.ACTIONS_LEGION = {
    PLAYGUITAR = "Play", --弹琴动作的名字
    GIVE_RIGHTCLICK = "Give", --右键喂牛动作的名字
    EAT_CONTRACTS = "Ingest", --从契约书食用灵魂的名字
    PULLOUTSWORD = "Pull out", --拔剑出鞘动作的名字
    USE_UPGRADEKIT = "Assembly upgrade", --升级套件的升级动作的名字
}
STRINGS.ACTIONS.GIVE.SCABBARD = "Put into"  --青枝绿叶放入武器的名字

if CONFIGS_LEGION.ENABLEDMODS.CraftPot then
    STRINGS.NAMES_LEGION = {
        GEL = "Gel",
        PETALS_LEGION = "Petals",
        FALLFULLMOON = "specific to Fall FullMoon Day",
        WINTERSFEAST = "specific to Winter Feast",
        HALLOWEDNIGHTS = "specific to Hallowed Nights",
        NEWMOON = "specific to NewMoon Day",
    }
end
