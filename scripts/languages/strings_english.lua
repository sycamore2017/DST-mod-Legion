local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

TUNING.LEGION_MOD_LANGUAGES = "english"

--------------------------------------------------------------------------
--[[ the little star in the cave ]]--[[ 洞穴里的星光点点 ]]
--------------------------------------------------------------------------

STRINGS.NAMES.HAT_LICHEN = "Lichen Hairpin"
STRINGS.RECIPE_DESC.HAT_LICHEN = "I have an \"idea\", like cartoons."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HAT_LICHEN = "I have an \"idea\", truly."  --人物检查的描述，GENERIC就代表威尔逊的台词(威尔逊就表示是默认的台词，mod角色的台词也沿用威尔逊的？)
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.HAT_LICHEN = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.HAT_LICHEN = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.HAT_LICHEN = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.HAT_LICHEN = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.HAT_LICHEN = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.HAT_LICHEN = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.HAT_LICHEN = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.HAT_LICHEN = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.HAT_LICHEN = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.HAT_LICHEN = "Great to cool off after some hard physical labor."
STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.HAT_LICHEN = "Glowy Friends for head"

--------------------------------------------------------------------------
--[[ the power of flowers ]]--[[ 花香四溢 ]]
--------------------------------------------------------------------------

STRINGS.NAMES.ROSORNS = "Rosorns"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ROSORNS = "Roses always touch my heart directly."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.ROSORNS = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ROSORNS = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.ROSORNS = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.ROSORNS = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ROSORNS = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.ROSORNS = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.ROSORNS = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.ROSORNS = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.ROSORNS = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.ROSORNS = "Great to cool off after some hard physical labor."

STRINGS.NAMES.LILEAVES = "Lileaves"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LILEAVES = "I was deeply poisoned by loving it."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.LILEAVES = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.LILEAVES = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.LILEAVES = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.LILEAVES = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.LILEAVES = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.LILEAVES = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.LILEAVES = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.LILEAVES = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.LILEAVES = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.LILEAVES = "Great to cool off after some hard physical labor."

STRINGS.NAMES.ORCHITWIGS = "Orchitwigs"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ORCHITWIGS = "It's not striking, but I just like it."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.ORCHITWIGS = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ORCHITWIGS = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.ORCHITWIGS = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.ORCHITWIGS = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ORCHITWIGS = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.ORCHITWIGS = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.ORCHITWIGS = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.ORCHITWIGS = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.ORCHITWIGS = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.ORCHITWIGS = "Great to cool off after some hard physical labor."

STRINGS.NAMES.ROSEBUSH = "Rose Bush"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ROSEBUSH =  --对于某些角色，这里面的"she"可以做点手脚，嘿嘿
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
STRINGS.CHARACTERS.WILLOW.DESCRIBE.ROSEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ROSEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WENDY.DESCRIBE.ROSEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WX78.DESCRIBE.ROSEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ROSEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WOODIE.DESCRIBE.ROSEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.ROSEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.ROSEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WEBBER.DESCRIBE.ROSEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WINONA.DESCRIBE.ROSEBUSH =
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

STRINGS.NAMES.DUG_ROSEBUSH = "Rose Bush"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DUG_ROSEBUSH = "Although rose is beautiful, it still has thorns."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.DUG_ROSEBUSH = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DUG_ROSEBUSH = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.DUG_ROSEBUSH = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.DUG_ROSEBUSH = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DUG_ROSEBUSH = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.DUG_ROSEBUSH = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DUG_ROSEBUSH = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DUG_ROSEBUSH = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.DUG_ROSEBUSH = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.DUG_ROSEBUSH = "Great to cool off after some hard physical labor."

STRINGS.NAMES.CUTTED_ROSEBUSH = "Rose Twigs"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CUTTED_ROSEBUSH = "This is a very common way of propagating plants."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.CUTTED_ROSEBUSH = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.CUTTED_ROSEBUSH = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.CUTTED_ROSEBUSH = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.CUTTED_ROSEBUSH = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.CUTTED_ROSEBUSH = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.CUTTED_ROSEBUSH = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.CUTTED_ROSEBUSH = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.CUTTED_ROSEBUSH = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.CUTTED_ROSEBUSH = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.CUTTED_ROSEBUSH = "Great to cool off after some hard physical labor."

STRINGS.NAMES.LILYBUSH = "Lily Bush"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.LILYBUSH =  --对于某些角色，这里面的"she"可以做点手脚，嘿嘿
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
STRINGS.CHARACTERS.WILLOW.DESCRIBE.LILYBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.LILYBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WENDY.DESCRIBE.LILYBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WX78.DESCRIBE.LILYBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.LILYBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WOODIE.DESCRIBE.LILYBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.LILYBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.LILYBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WEBBER.DESCRIBE.LILYBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WINONA.DESCRIBE.LILYBUSH =
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

STRINGS.NAMES.DUG_LILYBUSH = "Lily Bush"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DUG_LILYBUSH = "I can't wait to see its appearance."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.DUG_LILYBUSH = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DUG_LILYBUSH = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.DUG_LILYBUSH = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.DUG_LILYBUSH = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DUG_LILYBUSH = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.DUG_LILYBUSH = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DUG_LILYBUSH = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DUG_LILYBUSH = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.DUG_LILYBUSH = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.DUG_LILYBUSH = "Great to cool off after some hard physical labor."

STRINGS.NAMES.CUTTED_LILYBUSH = "Lily Sprout"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CUTTED_LILYBUSH = "This is a very common way of propagating plants."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.CUTTED_LILYBUSH = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.CUTTED_LILYBUSH = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.CUTTED_LILYBUSH = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.CUTTED_LILYBUSH = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.CUTTED_LILYBUSH = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.CUTTED_LILYBUSH = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.CUTTED_LILYBUSH = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.CUTTED_LILYBUSH = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.CUTTED_LILYBUSH = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.CUTTED_LILYBUSH = "Great to cool off after some hard physical labor."

STRINGS.NAMES.ORCHIDBUSH = "Orchid Bush"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ORCHIDBUSH =  --对于某些角色，这里面的"she"可以做点手脚，嘿嘿
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
STRINGS.CHARACTERS.WILLOW.DESCRIBE.ORCHIDBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ORCHIDBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WENDY.DESCRIBE.ORCHIDBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WX78.DESCRIBE.ORCHIDBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ORCHIDBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WOODIE.DESCRIBE.ORCHIDBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.ORCHIDBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.ORCHIDBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WEBBER.DESCRIBE.ORCHIDBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WINONA.DESCRIBE.ORCHIDBUSH =
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

STRINGS.NAMES.DUG_ORCHIDBUSH = "Orchid Bush"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DUG_ORCHIDBUSH = "Look, it just lies there quietly."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.DUG_ORCHIDBUSH = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DUG_ORCHIDBUSH = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.DUG_ORCHIDBUSH = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.DUG_ORCHIDBUSH = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DUG_ORCHIDBUSH = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.DUG_ORCHIDBUSH = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DUG_ORCHIDBUSH = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DUG_ORCHIDBUSH = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.DUG_ORCHIDBUSH = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.DUG_ORCHIDBUSH = "Great to cool off after some hard physical labor."

STRINGS.NAMES.CUTTED_ORCHIDBUSH = "Orchid Seeds"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CUTTED_ORCHIDBUSH = "This is a very common way of propagating plants."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.CUTTED_ORCHIDBUSH = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.CUTTED_ORCHIDBUSH = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.CUTTED_ORCHIDBUSH = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.CUTTED_ORCHIDBUSH = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.CUTTED_ORCHIDBUSH = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.CUTTED_ORCHIDBUSH = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.CUTTED_ORCHIDBUSH = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.CUTTED_ORCHIDBUSH = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.CUTTED_ORCHIDBUSH = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.CUTTED_ORCHIDBUSH = "Great to cool off after some hard physical labor."

STRINGS.NAMES.NEVERFADEBUSH = "Neverfade Bush"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.NEVERFADEBUSH =
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
STRINGS.CHARACTERS.WILLOW.DESCRIBE.NEVERFADEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.NEVERFADEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WENDY.DESCRIBE.NEVERFADEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WX78.DESCRIBE.NEVERFADEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.NEVERFADEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WOODIE.DESCRIBE.NEVERFADEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.NEVERFADEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.NEVERFADEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WEBBER.DESCRIBE.NEVERFADEBUSH =
{
    BARREN = "I need to poop on it.",
    WITHERED = "Is too hot for bush.",
    GENERIC = "Is full of food-balls!",
    PICKED = "Eating part is gone.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "Ah! Is burning!",
}
STRINGS.CHARACTERS.WINONA.DESCRIBE.NEVERFADEBUSH =
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

STRINGS.NAMES.NEVERFADE = "Neverfade"    --永不凋零
STRINGS.RECIPE_DESC.NEVERFADE = "The power of flowers!" --科技栏里的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.NEVERFADE = "Divine... and pure... power!"
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.NEVERFADE = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.NEVERFADE = "Wolfgang can eat in one bite!"
STRINGS.CHARACTERS.WENDY.DESCRIBE.NEVERFADE = "It's not love, but it still is eternal..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.NEVERFADE = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.NEVERFADE = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.NEVERFADE = "I'd prefer maple taffy..."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.NEVERFADE = "Hm... this is something created by another force in the world."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.NEVERFADE = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.NEVERFADE = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.NEVERFADE = "Great to cool off after some hard physical labor."
STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.SACHET = "Strong friend"

STRINGS.NAMES.SACHET = "Sachet"    --香包
STRINGS.RECIPE_DESC.SACHET = "Cover up your stinky sweat." --科技栏里的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SACHET = "Should I smell like flowers?"
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.SACHET = "This is the opposite of burning."
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.SACHET = "To be honest, this is too feminine..."
--STRINGS.CHARACTERS.WENDY.DESCRIBE.SACHET = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.SACHET = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.SACHET = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.SACHET = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.SACHET = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.SACHET = "I've somehow found a way to make it even LESS appealing!"
STRINGS.CHARACTERS.WEBBER.DESCRIBE.SACHET = "Great! We smell sweet!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.SACHET = "Great to cool off after some hard physical labor."
STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.SACHET = "Friend inside?"

STRINGS.CHARACTERS.GENERIC.ANNOUNCE_PICK_ROSEBUSH = "I wish I could hug you, till you're really being free."
-- STRINGS.CHARACTERS.WILLOW.ANNOUNCE_PICK_ROSEBUSH = ""
-- STRINGS.CHARACTERS.WOLFGANG.ANNOUNCE_PICK_ROSEBUSH = ""
-- STRINGS.CHARACTERS.WENDY.ANNOUNCE_PICK_ROSEBUSH = ""
STRINGS.CHARACTERS.WX78.ANNOUNCE_PICK_ROSEBUSH = "SAME BAD HAPPENS EVERYDAY."
-- STRINGS.CHARACTERS.WICKERBOTTOM.ANNOUNCE_PICK_ROSEBUSH = ""
-- STRINGS.CHARACTERS.WOODIE.ANNOUNCE_PICK_ROSEBUSH = ""
STRINGS.CHARACTERS.WAXWELL.ANNOUNCE_PICK_ROSEBUSH = "You switched to his body?"
-- STRINGS.CHARACTERS.WATHGRITHR.ANNOUNCE_PICK_ROSEBUSH = ""
-- STRINGS.CHARACTERS.WEBBER.ANNOUNCE_PICK_ROSEBUSH = ""
STRINGS.CHARACTERS.WINONA.ANNOUNCE_PICK_ROSEBUSH = "One day I will be you."
-- STRINGS.CHARACTERS.WORTOX.ANNOUNCE_PICK_ROSEBUSH = ""
-- STRINGS.CHARACTERS.WARLY.ANNOUNCE_PICK_ROSEBUSH = ""

STRINGS.NAMES.FOLIAGEATH = "Foliageath" --青枝绿叶
-- STRINGS.RECIPE_DESC.FOLIAGEATH = "Silent foliage, guard fragrance." --科技栏里的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FOLIAGEATH =
{
    MERGED = "All shall be well.",
    GENERIC = "Who is it waiting for?",
}
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.FOLIAGEATH = ""
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.FOLIAGEATH = ""
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.FOLIAGEATH = ""
-- STRINGS.CHARACTERS.WX78.DESCRIBE.FOLIAGEATH = ""
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.FOLIAGEATH = ""
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.FOLIAGEATH = ""
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.FOLIAGEATH = ""
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.FOLIAGEATH = ""
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.FOLIAGEATH = ""
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.FOLIAGEATH = ""
-- STRINGS.CHARACTERS.WARLY.DESCRIBE.FOLIAGEATH = ""
-- STRINGS.CHARACTERS.WORTOX.DESCRIBE.FOLIAGEATH = ""
-- STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.FOLIAGEATH =
-- STRINGS.CHARACTERS.WURT.DESCRIBE.FOLIAGEATH = ""

--入鞘失败的台词
STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.GIVE.WRONGSWORD = "This is not what it expected!"
-- STRINGS.CHARACTERS.WILLOW.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- STRINGS.CHARACTERS.WOLFGANG.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- STRINGS.CHARACTERS.WENDY.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- STRINGS.CHARACTERS.WX78.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- STRINGS.CHARACTERS.WICKERBOTTOM.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- STRINGS.CHARACTERS.WOODIE.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- STRINGS.CHARACTERS.WAXWELL.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- STRINGS.CHARACTERS.WATHGRITHR.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- STRINGS.CHARACTERS.WEBBER.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- STRINGS.CHARACTERS.WINONA.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- STRINGS.CHARACTERS.WARLY.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- STRINGS.CHARACTERS.WORTOX.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- STRINGS.CHARACTERS.WORMWOOD.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- STRINGS.CHARACTERS.WURT.ACTIONFAIL.GIVE.WRONGSWORD = ""

STRINGS.NAMES.FOLIAGEATH_MYLOVE = "Ciao Changqing"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FOLIAGEATH_MYLOVE = "Pity, you just want to run away." --This is someone's keepsake to his lover.
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- STRINGS.CHARACTERS.WX78.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- STRINGS.CHARACTERS.WARLY.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- STRINGS.CHARACTERS.WORTOX.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- STRINGS.CHARACTERS.WURT.DESCRIBE.FOLIAGEATH_MYLOVE = ""

--合成一吻长青时的台词
STRINGS.CHARACTERS.GENERIC.ANNOUNCE_HIS_LOVE_WISH = "Wish forever but sometimes..." --Wish love lasts forever!
-- STRINGS.CHARACTERS.WILLOW.ANNOUNCE_HIS_LOVE_WISH = ""
-- STRINGS.CHARACTERS.WOLFGANG.ANNOUNCE_HIS_LOVE_WISH = ""
-- STRINGS.CHARACTERS.WENDY.ANNOUNCE_HIS_LOVE_WISH = ""
-- STRINGS.CHARACTERS.WX78.ANNOUNCE_HIS_LOVE_WISH = ""
-- STRINGS.CHARACTERS.WICKERBOTTOM.ANNOUNCE_HIS_LOVE_WISH = ""
-- STRINGS.CHARACTERS.WOODIE.ANNOUNCE_HIS_LOVE_WISH = ""
-- STRINGS.CHARACTERS.WAXWELL.ANNOUNCE_HIS_LOVE_WISH = ""
-- STRINGS.CHARACTERS.WATHGRITHR.ANNOUNCE_HIS_LOVE_WISH = ""
-- STRINGS.CHARACTERS.WEBBER.ANNOUNCE_HIS_LOVE_WISH = ""
-- STRINGS.CHARACTERS.WINONA.ANNOUNCE_HIS_LOVE_WISH = ""
-- STRINGS.CHARACTERS.WARLY.ANNOUNCE_HIS_LOVE_WISH = ""
-- STRINGS.CHARACTERS.WORTOX.ANNOUNCE_HIS_LOVE_WISH = ""
-- STRINGS.CHARACTERS.WORMWOOD.ANNOUNCE_HIS_LOVE_WISH = ""
-- STRINGS.CHARACTERS.WURT.ANNOUNCE_HIS_LOVE_WISH = ""

--------------------------------------------------------------------------
--[[ superb cuisine ]]--[[ 美味佳肴 ]]
--------------------------------------------------------------------------

STRINGS.NAMES.PETALS_ROSE = "Rose Petals"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PETALS_ROSE = "A rose is a rose!"
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.PETALS_ROSE = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.PETALS_ROSE = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.PETALS_ROSE = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.PETALS_ROSE = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.PETALS_ROSE = "Well, isn't that refreshing?"
STRINGS.CHARACTERS.WOODIE.DESCRIBE.PETALS_ROSE = "Feeling the grass between our toes, and Lucy smile."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.PETALS_ROSE = "Wise men don’t believe in roses."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.PETALS_ROSE = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.PETALS_ROSE = "Yaaay! Popsicle, popsicle!"
STRINGS.CHARACTERS.WINONA.DESCRIBE.PETALS_ROSE = "A rose is a rose, Just like everybody knows."

STRINGS.NAMES.PETALS_LILY = "Lily Petals"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PETALS_LILY = "A lily is a lily!"
STRINGS.CHARACTERS.WILLOW.DESCRIBE.PETALS_LILY = "If the ground below us turned to dust, Would he come to me?"
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.PETALS_LILY = "Wolfgang can eat in one bite!"
STRINGS.CHARACTERS.WENDY.DESCRIBE.PETALS_LILY = "I'd like it if he say it's a nice gift."
--STRINGS.CHARACTERS.WX78.DESCRIBE.PETALS_LILY = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.PETALS_LILY = "Well, isn't that refreshing?"
STRINGS.CHARACTERS.WOODIE.DESCRIBE.PETALS_LILY = "I see a lily on thy brow, with anguish moist and fever dew."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.PETALS_LILY = "Hm... I don't know what I was expecting."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.PETALS_LILY = "A white lie, to make up my bravado."
STRINGS.CHARACTERS.WEBBER.DESCRIBE.PETALS_LILY = "If we were to bring her some flowers, would it be a surprise?"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.PETALS_LILY = "Great to cool off after some hard physical labor."

STRINGS.NAMES.PETALS_ORCHID = "Orchid Petals"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PETALS_ORCHID = "A orchid is a orchid!"
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.PETALS_ORCHID = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.PETALS_ORCHID = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.PETALS_ORCHID = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.PETALS_ORCHID = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.PETALS_ORCHID = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.PETALS_ORCHID = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.PETALS_ORCHID = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.PETALS_ORCHID = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.PETALS_ORCHID = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.PETALS_ORCHID = "Great to cool off after some hard physical labor."

STRINGS.NAMES.DISH_CHILLEDROSEJUICE = "Chilled Rose Juice"    --蔷薇冰果汁
STRINGS.UI.COOKBOOK.DISH_CHILLEDROSEJUICE = "Plant flower at random"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISH_CHILLEDROSEJUICE = "I have a sense like flowers in my heart."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.DISH_CHILLEDROSEJUICE = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DISH_CHILLEDROSEJUICE = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.DISH_CHILLEDROSEJUICE = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.DISH_CHILLEDROSEJUICE = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DISH_CHILLEDROSEJUICE = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.DISH_CHILLEDROSEJUICE = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DISH_CHILLEDROSEJUICE = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DISH_CHILLEDROSEJUICE = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.DISH_CHILLEDROSEJUICE = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.DISH_CHILLEDROSEJUICE = "Great to cool off after some hard physical labor."

STRINGS.NAMES.DISH_TWISTEDROLLLILY = "Twisted Lily Roll"    --蹄莲花卷
STRINGS.UI.COOKBOOK.DISH_TWISTEDROLLLILY = "Call butterfly at random"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISH_TWISTEDROLLLILY = "To be a butterfly, fluttering and dancing in the breeze."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.DISH_TWISTEDROLLLILY = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DISH_TWISTEDROLLLILY = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.DISH_TWISTEDROLLLILY = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.DISH_TWISTEDROLLLILY = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DISH_TWISTEDROLLLILY = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.DISH_TWISTEDROLLLILY = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DISH_TWISTEDROLLLILY = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DISH_TWISTEDROLLLILY = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.DISH_TWISTEDROLLLILY = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.DISH_TWISTEDROLLLILY = "Great to cool off after some hard physical labor."

STRINGS.NAMES.DISH_ORCHIDCAKE = "Orchid Cake"    --兰花糕
STRINGS.UI.COOKBOOK.DISH_ORCHIDCAKE = "Have you felt the peace of mind"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISH_ORCHIDCAKE = "I seemed to hear a quiet voice that calmed me."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.DISH_ORCHIDCAKE = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DISH_ORCHIDCAKE = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.DISH_ORCHIDCAKE = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.DISH_ORCHIDCAKE = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DISH_ORCHIDCAKE = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.DISH_ORCHIDCAKE = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DISH_ORCHIDCAKE = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DISH_ORCHIDCAKE = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.DISH_ORCHIDCAKE = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.DISH_ORCHIDCAKE = "Great to cool off after some hard physical labor."

STRINGS.NAMES.DISH_FLESHNAPOLEON = "Flesh Napoleon"    --真果拿破仑
STRINGS.UI.COOKBOOK.DISH_FLESHNAPOLEON = "Skin glow"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISH_FLESHNAPOLEON = "The brightest star in the night sky is coming!"
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.DISH_FLESHNAPOLEON = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DISH_FLESHNAPOLEON = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.DISH_FLESHNAPOLEON = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.DISH_FLESHNAPOLEON = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DISH_FLESHNAPOLEON = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.DISH_FLESHNAPOLEON = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DISH_FLESHNAPOLEON = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DISH_FLESHNAPOLEON = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.DISH_FLESHNAPOLEON = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.DISH_FLESHNAPOLEON = "Great to cool off after some hard physical labor."

STRINGS.NAMES.DISH_BEGGINGMEAT = "Begging Meat"    --叫花焖肉
STRINGS.UI.COOKBOOK.DISH_BEGGINGMEAT = "Hunger emergency"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISH_BEGGINGMEAT = "For the moment, at least I don't have to beg for survival."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.DISH_BEGGINGMEAT = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DISH_BEGGINGMEAT = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.DISH_BEGGINGMEAT = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.DISH_BEGGINGMEAT = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DISH_BEGGINGMEAT = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.DISH_BEGGINGMEAT = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DISH_BEGGINGMEAT = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DISH_BEGGINGMEAT = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.DISH_BEGGINGMEAT = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.DISH_BEGGINGMEAT = "Great to cool off after some hard physical labor."

STRINGS.NAMES.DISH_FRENCHSNAILSBAKED = "French Snails Baked"    --法式焗蜗牛
STRINGS.UI.COOKBOOK.DISH_FRENCHSNAILSBAKED = "Give it a spark and it'll explode"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISH_FRENCHSNAILSBAKED = "I hope there's no fire in my stomach!"
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.DISH_FRENCHSNAILSBAKED = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DISH_FRENCHSNAILSBAKED = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.DISH_FRENCHSNAILSBAKED = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.DISH_FRENCHSNAILSBAKED = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DISH_FRENCHSNAILSBAKED = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.DISH_FRENCHSNAILSBAKED = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DISH_FRENCHSNAILSBAKED = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DISH_FRENCHSNAILSBAKED = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.DISH_FRENCHSNAILSBAKED = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.DISH_FRENCHSNAILSBAKED = "Great to cool off after some hard physical labor."

STRINGS.NAMES.DISH_NEWORLEANSWINGS = "New Orleans Wings"    --新奥尔良烤翅
STRINGS.UI.COOKBOOK.DISH_NEWORLEANSWINGS = "Absorb the ultrasound"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISH_NEWORLEANSWINGS = "Why did I suddenly think of a man in a bat suit?"
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.DISH_NEWORLEANSWINGS = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DISH_NEWORLEANSWINGS = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.DISH_NEWORLEANSWINGS = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.DISH_NEWORLEANSWINGS = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DISH_NEWORLEANSWINGS = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.DISH_NEWORLEANSWINGS = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DISH_NEWORLEANSWINGS = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DISH_NEWORLEANSWINGS = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.DISH_NEWORLEANSWINGS = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.DISH_NEWORLEANSWINGS = "Great to cool off after some hard physical labor."

STRINGS.NAMES.DISH_FISHJOYRAMEN = "Fishjoy Ramen"    --鱼乐拉面
STRINGS.UI.COOKBOOK.DISH_FISHJOYRAMEN = "Accidentally inhale something"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISH_FISHJOYRAMEN = "Don't slurp your soup, be polite!"
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.DISH_FISHJOYRAMEN = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DISH_FISHJOYRAMEN = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.DISH_FISHJOYRAMEN = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.DISH_FISHJOYRAMEN = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DISH_FISHJOYRAMEN = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.DISH_FISHJOYRAMEN = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DISH_FISHJOYRAMEN = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DISH_FISHJOYRAMEN = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.DISH_FISHJOYRAMEN = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.DISH_FISHJOYRAMEN = "Great to cool off after some hard physical labor."

STRINGS.NAMES.DISH_ROASTEDMARSHMALLOWS = "Roasted Marshmallows"    --烤棉花糖
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "It reminds me of my old days camping with my friends."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "Wolfgang can eat in one bite!"
STRINGS.CHARACTERS.WENDY.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "Reminding me of my childhood camping with Abigail."
STRINGS.CHARACTERS.WX78.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "IT REMINDED ME OF PYRO!"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "Well, isn't that refreshing?"
STRINGS.CHARACTERS.WOODIE.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "Oh, I almost forgot, the time I spent camping with Lucy."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "I've somehow found a way to make it even LESS appealing!"
STRINGS.CHARACTERS.WEBBER.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "It reminds us of our childhood camping with our family."
--STRINGS.CHARACTERS.WINONA.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "Great to cool off after some hard physical labor."

STRINGS.NAMES.DISH_POMEGRANATEJELLY = "Pomegranate Jelly"    --石榴子果冻
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISH_POMEGRANATEJELLY = "It's children's stuff, I'm not naive any more."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.DISH_POMEGRANATEJELLY = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DISH_POMEGRANATEJELLY = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.DISH_POMEGRANATEJELLY = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.DISH_POMEGRANATEJELLY = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DISH_POMEGRANATEJELLY = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.DISH_POMEGRANATEJELLY = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DISH_POMEGRANATEJELLY = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DISH_POMEGRANATEJELLY = "I've somehow found a way to make it even LESS appealing!"
STRINGS.CHARACTERS.WEBBER.DESCRIBE.DISH_POMEGRANATEJELLY = "We like Jellys!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.DISH_POMEGRANATEJELLY = "Great to cool off after some hard physical labor."

STRINGS.NAMES.DISH_MEDICINALLIQUOR = "Medicinal Liquor"    --药酒
STRINGS.UI.COOKBOOK.DISH_MEDICINALLIQUOR = "Boost morale"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISH_MEDICINALLIQUOR =
{
    GENERIC = "Feel no pain! fight to death!",
    DRUNK = "I'm not drunk!",
}
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.DISH_MEDICINALLIQUOR = "This is the opposite of burning."
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DISH_MEDICINALLIQUOR =
{
    GENERIC = "Feel no pain! fight to death!",
    DRUNK = "Oh, just water!",
}
STRINGS.CHARACTERS.WENDY.DESCRIBE.DISH_MEDICINALLIQUOR =
{
    GENERIC = "I don't want to drink this.",
    DRUNK = "I shouldn't have drunk this.",
}
--STRINGS.CHARACTERS.WX78.DESCRIBE.DISH_MEDICINALLIQUOR = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DISH_MEDICINALLIQUOR = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.DISH_MEDICINALLIQUOR = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DISH_MEDICINALLIQUOR = "Hm... I don't know what I was expecting."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DISH_MEDICINALLIQUOR =
{
    GENERIC = "Feel no pain! fight to death!",
    DRUNK = "Oh, just water!",
}
STRINGS.CHARACTERS.WEBBER.DESCRIBE.DISH_MEDICINALLIQUOR =
{
    GENERIC = "My mom warned me not to drink before.",
    DRUNK = "Mom, We are so sleeeeee...",
}
--STRINGS.CHARACTERS.WINONA.DESCRIBE.DISH_MEDICINALLIQUOR = "Great to cool off after some hard physical labor."

STRINGS.NAMES.DISH_BANANAMOUSSE = "Banana Mousse"    --香蕉慕斯
STRINGS.UI.COOKBOOK.DISH_BANANAMOUSSE = "Stop picky eating"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISH_BANANAMOUSSE = "An appetizing dessert. Yummy..."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.DISH_BANANAMOUSSE = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DISH_BANANAMOUSSE = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.DISH_BANANAMOUSSE = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.DISH_BANANAMOUSSE = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DISH_BANANAMOUSSE = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.DISH_BANANAMOUSSE = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DISH_BANANAMOUSSE = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DISH_BANANAMOUSSE = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.DISH_BANANAMOUSSE = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.DISH_BANANAMOUSSE = "Great to cool off after some hard physical labor."

STRINGS.NAMES.DISH_RICEDUMPLING = "Rice Dumpling"    --金黄香粽
STRINGS.UI.COOKBOOK.DISH_RICEDUMPLING = "Fill your stomach, you like it"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISH_RICEDUMPLING = "It has a natural smell."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.DISH_RICEDUMPLING = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DISH_RICEDUMPLING = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.DISH_RICEDUMPLING = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.DISH_RICEDUMPLING = "STICK ADDON INSTALLED"
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DISH_RICEDUMPLING = "Maybe I should throw it into the river to feed the fish."
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.DISH_RICEDUMPLING = "I'd prefer maple taffy..."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DISH_RICEDUMPLING = "My stomach doesn't feel well when I see this."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DISH_RICEDUMPLING = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.DISH_RICEDUMPLING = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.DISH_RICEDUMPLING = "Great to cool off after some hard physical labor."

STRINGS.NAMES.DISH_DURIANTARTARE = "Durian Tartare"    --怪味鞑靼
STRINGS.UI.COOKBOOK.DISH_DURIANTARTARE = "Give monster extra recovery"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISH_DURIANTARTARE = "Brutal, bloody and yucky..."
STRINGS.CHARACTERS.WILLOW.DESCRIBE.DISH_DURIANTARTARE = "Mess! needs a fire!"
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DISH_DURIANTARTARE = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.DISH_DURIANTARTARE = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.DISH_DURIANTARTARE = "STICK ADDON INSTALLED"
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DISH_DURIANTARTARE = "Umm... the meat is still raw, and it stinks."
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.DISH_DURIANTARTARE = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DISH_DURIANTARTARE = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DISH_DURIANTARTARE = "I've somehow found a way to make it even LESS appealing!"
STRINGS.CHARACTERS.WEBBER.DESCRIBE.DISH_DURIANTARTARE = "A lump of processed raw meat, cool!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.DISH_DURIANTARTARE = "Great to cool off after some hard physical labor."
STRINGS.CHARACTERS.WORTOX.DESCRIBE.DISH_DURIANTARTARE = "Whose flesh is this, with a little yummy soul remained."

STRINGS.NAMES.DISH_MERRYCHRISTMASSALAD = "\"Merry Christmas\" Salad"    --“圣诞快乐”沙拉
STRINGS.UI.COOKBOOK.DISH_MERRYCHRISTMASSALAD = "With blessing to accept gift"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "Look at the Christmas tree, and eat a christmas tree."
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "Mess! needs a fire!"
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "Wolfgang want a gift, Santa Claus, please."
--STRINGS.CHARACTERS.WENDY.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "STICK ADDON INSTALLED"
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "Umm... the meat is still raw, and it stinks."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "Now I'm not the only one who can eat trees."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "I've somehow found a way to make it even LESS appealing!"
STRINGS.CHARACTERS.WEBBER.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "Should I eat from the star or from the trunk?"
STRINGS.CHARACTERS.WINONA.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "Merry Christmas! hah."

STRINGS.NAMES.DISH_MURMURANANAS = "Murmur Ananas"    --松萝咕咾肉
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISH_MURMURANANAS = "Sour and sweet meat, I like it!"
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.DISH_MURMURANANAS = "This is the opposite of burning."
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DISH_MURMURANANAS = "Wolfgang loves it so much that he wants to eat it again!"
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.DISH_MURMURANANAS = "I used to eat these with Abigail..."
-- STRINGS.CHARACTERS.WX78.DESCRIBE.DISH_MURMURANANAS = "STICK ADDON INSTALLED"
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DISH_MURMURANANAS = "Well, isn't that refreshing?"
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.DISH_MURMURANANAS = "I'd prefer maple taffy..."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DISH_MURMURANANAS = "This cuisine will never disappear on the menu of Chinatown restaurants."
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DISH_MURMURANANAS = "I've somehow found a way to make it even LESS appealing!"
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.DISH_MURMURANANAS = "Yaaay! Popsicle, popsicle!"
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.DISH_MURMURANANAS = "Great to cool off after some hard physical labor."
-- STRINGS.CHARACTERS.WORTOX.DESCRIBE.DISH_MURMURANANAS = "Whose flesh is this, with a little yummy soul remained."

STRINGS.NAMES.DISH_SHYERRYJAM = "Shyerry Jam"    --颤栗果酱
STRINGS.UI.COOKBOOK.DISH_SHYERRYJAM = "Self-healing in moderation"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISH_SHYERRYJAM = "I'd love to pour it over scones or make a pie, then eat it."
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.DISH_SHYERRYJAM = "This is the opposite of burning."
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DISH_SHYERRYJAM = "Wolfgang loves it so much that he wants to eat it again!"
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.DISH_SHYERRYJAM = "I used to eat these with Abigail..."
STRINGS.CHARACTERS.WX78.DESCRIBE.DISH_SHYERRYJAM = "NO DESSERT, JUST EAT IT DIRECTLY."
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DISH_SHYERRYJAM = "Well, isn't that refreshing?"
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.DISH_SHYERRYJAM = "I'd prefer maple taffy..."
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DISH_SHYERRYJAM = "This "
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DISH_SHYERRYJAM = "I've somehow found a way to make it even LESS appealing!"
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.DISH_SHYERRYJAM = "Yaaay! Popsicle, popsicle!"
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.DISH_SHYERRYJAM = "Great to cool off after some hard physical labor."
-- STRINGS.CHARACTERS.WORTOX.DESCRIBE.DISH_SHYERRYJAM = "Whose flesh is this, with a little yummy soul remained."

--蝙蝠伪装buff
STRINGS.CHARACTERS.GENERIC.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = "I seem to be wearing an invisible bat suit."
-- STRINGS.CHARACTERS.WILLOW.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- STRINGS.CHARACTERS.WOLFGANG.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- STRINGS.CHARACTERS.WENDY.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- STRINGS.CHARACTERS.WX78.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- STRINGS.CHARACTERS.WICKERBOTTOM.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- STRINGS.CHARACTERS.WOODIE.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- STRINGS.CHARACTERS.WAXWELL.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- STRINGS.CHARACTERS.WATHGRITHR.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- STRINGS.CHARACTERS.WEBBER.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- STRINGS.CHARACTERS.WINONA.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- STRINGS.CHARACTERS.WORTOX.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- STRINGS.CHARACTERS.WARLY.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
--
STRINGS.CHARACTERS.GENERIC.ANNOUNCE_DETACH_BUFF_BATDISGUISE = "Well, I'm not a bat."
-- STRINGS.CHARACTERS.WILLOW.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- STRINGS.CHARACTERS.WOLFGANG.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- STRINGS.CHARACTERS.WENDY.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- STRINGS.CHARACTERS.WX78.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- STRINGS.CHARACTERS.WICKERBOTTOM.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- STRINGS.CHARACTERS.WOODIE.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- STRINGS.CHARACTERS.WAXWELL.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- STRINGS.CHARACTERS.WATHGRITHR.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- STRINGS.CHARACTERS.WEBBER.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- STRINGS.CHARACTERS.WINONA.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- STRINGS.CHARACTERS.WORTOX.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- STRINGS.CHARACTERS.WARLY.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""

--最佳胃口buff
STRINGS.CHARACTERS.GENERIC.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = "Suddenly, I want to have a big meal."
-- STRINGS.CHARACTERS.WILLOW.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- STRINGS.CHARACTERS.WOLFGANG.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- STRINGS.CHARACTERS.WENDY.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- STRINGS.CHARACTERS.WX78.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- STRINGS.CHARACTERS.WICKERBOTTOM.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- STRINGS.CHARACTERS.WOODIE.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- STRINGS.CHARACTERS.WAXWELL.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- STRINGS.CHARACTERS.WATHGRITHR.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- STRINGS.CHARACTERS.WEBBER.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- STRINGS.CHARACTERS.WINONA.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- STRINGS.CHARACTERS.WORTOX.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- STRINGS.CHARACTERS.WARLY.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
--
STRINGS.CHARACTERS.GENERIC.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = "My appetite has returned to normal."
-- STRINGS.CHARACTERS.WILLOW.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- STRINGS.CHARACTERS.WOLFGANG.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- STRINGS.CHARACTERS.WENDY.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- STRINGS.CHARACTERS.WX78.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- STRINGS.CHARACTERS.WICKERBOTTOM.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- STRINGS.CHARACTERS.WOODIE.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- STRINGS.CHARACTERS.WAXWELL.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- STRINGS.CHARACTERS.WATHGRITHR.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- STRINGS.CHARACTERS.WEBBER.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- STRINGS.CHARACTERS.WINONA.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- STRINGS.CHARACTERS.WORTOX.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- STRINGS.CHARACTERS.WARLY.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""

--胃梗塞buff
STRINGS.CHARACTERS.GENERIC.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = "No appetite at all."
-- STRINGS.CHARACTERS.WILLOW.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
-- STRINGS.CHARACTERS.WOLFGANG.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
-- STRINGS.CHARACTERS.WENDY.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
-- STRINGS.CHARACTERS.WX78.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
STRINGS.CHARACTERS.WICKERBOTTOM.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = "This food boosts my satiety."
-- STRINGS.CHARACTERS.WOODIE.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
STRINGS.CHARACTERS.WAXWELL.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = "Not well for my old stomach."
-- STRINGS.CHARACTERS.WATHGRITHR.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
-- STRINGS.CHARACTERS.WEBBER.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
STRINGS.CHARACTERS.WINONA.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = "The less hungry you are, the better you can work."
-- STRINGS.CHARACTERS.WORTOX.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
-- STRINGS.CHARACTERS.WARLY.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
--
STRINGS.CHARACTERS.GENERIC.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = "Good luck comes when you have an appetite."
-- STRINGS.CHARACTERS.WILLOW.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
-- STRINGS.CHARACTERS.WOLFGANG.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
-- STRINGS.CHARACTERS.WENDY.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
-- STRINGS.CHARACTERS.WX78.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
STRINGS.CHARACTERS.WICKERBOTTOM.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = "Satiety returns to normal."
-- STRINGS.CHARACTERS.WOODIE.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
STRINGS.CHARACTERS.WAXWELL.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = "My stomach felt better at last."
-- STRINGS.CHARACTERS.WATHGRITHR.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
-- STRINGS.CHARACTERS.WEBBER.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
STRINGS.CHARACTERS.WINONA.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = "Even if you're hungry, you have to keep working."
-- STRINGS.CHARACTERS.WORTOX.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
-- STRINGS.CHARACTERS.WARLY.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""

--力量增幅buff
-- STRINGS.CHARACTERS.GENERIC.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = "" --属于药酒的buff，但是药酒已经会让玩家说话了，所以这里不再重复说
-- STRINGS.CHARACTERS.WILLOW.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = ""
-- STRINGS.CHARACTERS.WOLFGANG.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = ""
-- STRINGS.CHARACTERS.WENDY.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = ""
-- STRINGS.CHARACTERS.WX78.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = ""
-- STRINGS.CHARACTERS.WICKERBOTTOM.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = ""
-- STRINGS.CHARACTERS.WOODIE.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = ""
-- STRINGS.CHARACTERS.WAXWELL.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = ""
-- STRINGS.CHARACTERS.WATHGRITHR.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = ""
-- STRINGS.CHARACTERS.WEBBER.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = ""
-- STRINGS.CHARACTERS.WINONA.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = ""
-- STRINGS.CHARACTERS.WORTOX.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = ""
-- STRINGS.CHARACTERS.WARLY.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = ""
--
STRINGS.CHARACTERS.GENERIC.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = "Oh, headache. Memories of yesterday are vague..."
-- STRINGS.CHARACTERS.WILLOW.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- STRINGS.CHARACTERS.WOLFGANG.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- STRINGS.CHARACTERS.WENDY.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
STRINGS.CHARACTERS.WX78.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = "I BLACKED OUT YESTERDAY?"
-- STRINGS.CHARACTERS.WICKERBOTTOM.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- STRINGS.CHARACTERS.WOODIE.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- STRINGS.CHARACTERS.WAXWELL.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- STRINGS.CHARACTERS.WATHGRITHR.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- STRINGS.CHARACTERS.WEBBER.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- STRINGS.CHARACTERS.WINONA.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- STRINGS.CHARACTERS.WORTOX.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- STRINGS.CHARACTERS.WARLY.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""

STRINGS.NAMES.DISH_SUGARLESSTRICKMAKERCUPCAKES = "Sugarless Trickmaker Cupcakes"   --无糖捣蛋鬼纸杯蛋糕
STRINGS.UI.COOKBOOK.DISH_SUGARLESSTRICKMAKERCUPCAKES = "Naughty elves will help you"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "Trick or treat!",
    TRICKED = "Scared me silly.",
    TREAT = "Here's your candy.",
}
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES = ""
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "Wolfgang only wants sugar, not to play tricks.",
    TRICKED = "It scared Wolfgang too much.",
    TREAT = "Wolfgang will share the happiness.",
}
STRINGS.CHARACTERS.WENDY.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "Maybe I'm too mature to ask for sugar.",
    TRICKED = "Scared me silly.",
    TREAT = "Would Abigail want candy, too?",
}
STRINGS.CHARACTERS.WX78.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "MY BODY CRAVES DEOXYRIBOSE.",
    TRICKED = "SUDDEN WARNING!",
    TREAT = "JUST GIVE YOU SOMTHING I DON'T WANT.",
}
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "I believe it's a trick.",
    TRICKED = "This is not allowed in library!",
    TREAT = "Here's your candy.",
}
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES = ""
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES = ""
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES = ""
STRINGS.CHARACTERS.WEBBER.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "We just want sweety sugar and candy!",
    TRICKED = "You made everyone laugh.",
    TREAT = "We're the ones who want the sugar.",
}
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES = ""
STRINGS.CHARACTERS.WORTOX.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "Hey, don't steal my thunder!!!",
    TRICKED = "Hah, small trick.",
    TREAT = "What if I don't give sugar.",
}
STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "Nectar, please?",
    TRICKED = "It made my leaves tremble.",
    TREAT = "Is today the pollination day?",
}
STRINGS.CHARACTERS.WARLY.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "What a timely snack!",
    TRICKED = "It made my pot shake.",
    TREAT = "This chef is going to treat the guests well.",
}
-- STRINGS.CHARACTERS.WURT.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES = ""

STRINGS.NAMES.DISH_FLOWERMOONCAKE = "Flower Mooncake"    --鲜花月饼
STRINGS.UI.COOKBOOK.DISH_FLOWERMOONCAKE = "Get the power of missing"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISH_FLOWERMOONCAKE =
{
    GENERIC = "The scent of flowers, like my yearning.",
    HAPPY = "I will always have someone important on my mind.",
    LONELY = "Lonely and sad.",
}
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.DISH_FLOWERMOONCAKE = ""
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DISH_FLOWERMOONCAKE = ""
STRINGS.CHARACTERS.WENDY.DESCRIBE.DISH_FLOWERMOONCAKE =
{
    GENERIC = "Come, Abigail, enjoy the moon with me!",
    HAPPY = "So nostalgic for the day we sat on the table cloth on the grass.",
    LONELY = "Unprecedented loneliness is eroding me.",
}
STRINGS.CHARACTERS.WX78.DESCRIBE.DISH_FLOWERMOONCAKE =
{
    GENERIC = "LOW VALUE FUEL.",
    HAPPY = "UNKNOWN INTRUDER IS TRYING TO REPAIR THE EMOTIONAL COMPONENT.",
    LONELY = "STILL WRONG, THE EMOTIONAL COMPONENT IS NOT RESPONDING.",
}
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DISH_FLOWERMOONCAKE = ""
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.DISH_FLOWERMOONCAKE = ""
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DISH_FLOWERMOONCAKE =
{
    GENERIC = "It's not decent to get your suit dirty.",
    HAPPY = "I just want to make it all right, Charlie.",
    LONELY = "I deserve it.",
}
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DISH_FLOWERMOONCAKE = ""
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.DISH_FLOWERMOONCAKE = ""
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.DISH_FLOWERMOONCAKE = ""
-- STRINGS.CHARACTERS.WORTOX.DESCRIBE.DISH_FLOWERMOONCAKE = ""
STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.DISH_FLOWERMOONCAKE =
{
    GENERIC = "The sustenance of friends miss.",
    HAPPY = "So nice to have friends around!",
    LONELY = "It's so lonely without a friend.",
}
STRINGS.CHARACTERS.WARLY.DESCRIBE.DISH_FLOWERMOONCAKE =
{
    GENERIC = "While eating and enjoying the moon, memories come to mind.",
    HAPPY = "Grandma, I miss you.",
    LONELY = "Alas, what's the use of cooking!",
}
-- STRINGS.CHARACTERS.WURT.DESCRIBE.DISH_FLOWERMOONCAKE = ""
-- STRINGS.CHARACTERS.WALTER.DESCRIBE.DISH_FLOWERMOONCAKE = ""

STRINGS.NAMES.DISH_FAREWELLCUPCAKE = "Farewell Cupcake" --临别的纸杯蛋糕
STRINGS.UI.COOKBOOK.DISH_FLOWERMOONCAKE = "Say goodbye to my life"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISH_FAREWELLCUPCAKE = "So easy to be careless, but takes courage to care."
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.DISH_FAREWELLCUPCAKE = ""
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DISH_FAREWELLCUPCAKE = ""
STRINGS.CHARACTERS.WENDY.DESCRIBE.DISH_FAREWELLCUPCAKE = "Failures, let everyone down, including ourselves."
-- STRINGS.CHARACTERS.WX78.DESCRIBE.DISH_FAREWELLCUPCAKE = ""
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DISH_FAREWELLCUPCAKE = "Unfortunately, most of people are act self-awareness."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.DISH_FAREWELLCUPCAKE = "People are alienated from each other with a broken heart."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DISH_FAREWELLCUPCAKE = "My life is not worth mentioning."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DISH_FAREWELLCUPCAKE = "Don't you have enough?"
STRINGS.CHARACTERS.WEBBER.DESCRIBE.DISH_FAREWELLCUPCAKE = "Come on! Our pure spiritual world."
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.DISH_FAREWELLCUPCAKE = ""
STRINGS.CHARACTERS.WORTOX.DESCRIBE.DISH_FAREWELLCUPCAKE = "Sorry, it's so painful to be alive and I'm not done yet."
-- STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.DISH_FAREWELLCUPCAKE = ""
-- STRINGS.CHARACTERS.WARLY.DESCRIBE.DISH_FAREWELLCUPCAKE = ""
STRINGS.CHARACTERS.WURT.DESCRIBE.DISH_FAREWELLCUPCAKE = "To deliberately believe in lies while knowing their false."
-- STRINGS.CHARACTERS.WALTER.DESCRIBE.DISH_FAREWELLCUPCAKE = ""

STRINGS.NAMES.DISH_BRAISEDMEATWITHFOLIAGES = "Braised Meat With Foliages" --蕨叶扣肉
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = "Looks so greasy, just one piece of meat, please."
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = "Wolfgang loves it!"
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- STRINGS.CHARACTERS.WX78.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
STRINGS.CHARACTERS.WOODIE.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = "It goes well with rice."
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- STRINGS.CHARACTERS.WORTOX.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
STRINGS.CHARACTERS.WARLY.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = "It's not easy to make fat meat non greasy."
-- STRINGS.CHARACTERS.WURT.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- STRINGS.CHARACTERS.WALTER.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""

STRINGS.NAMES.DISH_WRAPPEDSHRIMPPASTE = "Wrapped Mushrimp" --白菇虾滑卷
STRINGS.UI.COOKBOOK.DISH_WRAPPEDSHRIMPPASTE = "Enhance resistance"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = "Great! The outer layer locks well the shrimp meat essence."
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
-- STRINGS.CHARACTERS.WX78.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
STRINGS.CHARACTERS.WOODIE.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = "So delicious. Can I have the wooden dish, too?"
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
STRINGS.CHARACTERS.WINONA.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = "Made smooth and delicate taste, it's not me."
-- STRINGS.CHARACTERS.WORTOX.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = "Beautiful friend, suitable, making beautiful meal."
STRINGS.CHARACTERS.WARLY.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = "Ah, the mushroom, the shrimp, my life has reached the peak!"
STRINGS.CHARACTERS.WURT.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = "It's cruel, glort."
-- STRINGS.CHARACTERS.WALTER.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""

--------------------------------------------------------------------------
--[[ the sacrifice of rain ]]--[[ 祈雨祭 ]]
--------------------------------------------------------------------------

STRINGS.NAMES.RAINDONATE = "Raindonate"    --雨蝇
STRINGS.CHARACTERS.GENERIC.DESCRIBE.RAINDONATE =
{
    GENERIC = "Elders said that the killing of it would start to rain.",
    HELD = "Look, this blue, winged insect!",
}
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.RAINDONATE = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.RAINDONATE = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.RAINDONATE = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.RAINDONATE = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.RAINDONATE = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.RAINDONATE = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.RAINDONATE = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.RAINDONATE = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.RAINDONATE = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.RAINDONATE = "Great to cool off after some hard physical labor."

STRINGS.NAMES.MONSTRAIN = "Monstrain"   --雨竹
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MONSTRAIN =
{
    SUMMER = "The water at the bottom fled.",
    WINTER = "The water at the bottom solidified.",
    GENERIC = "Careful! Don't touch the juice of it!",
    PICKED = "I'll just take a look.",
}
--[[
STRINGS.CHARACTERS.WILLOW.DESCRIBE.MONSTRAIN =
{
    SUMMER = "The water at the bottom fled.",
    WINTER = "The water at the bottom solidified.",
    GENERIC = "Careful! Don't touch the juice of it!",
    PICKED = "I'll just take a look.",
}
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.MONSTRAIN =
{
    SUMMER = "The water at the bottom fled.",
    WINTER = "The water at the bottom solidified.",
    GENERIC = "Careful! Don't touch the juice of it!",
    PICKED = "I'll just take a look.",
}
STRINGS.CHARACTERS.WENDY.DESCRIBE.MONSTRAIN =
{
    SUMMER = "The water at the bottom fled.",
    WINTER = "The water at the bottom solidified.",
    GENERIC = "Careful! Don't touch the juice of it!",
    PICKED = "I'll just take a look.",
}
STRINGS.CHARACTERS.WX78.DESCRIBE.MONSTRAIN =
{
    SUMMER = "The water at the bottom fled.",
    WINTER = "The water at the bottom solidified.",
    GENERIC = "Careful! Don't touch the juice of it!",
    PICKED = "I'll just take a look.",
}
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.MONSTRAIN =
{
    SUMMER = "The water at the bottom fled.",
    WINTER = "The water at the bottom solidified.",
    GENERIC = "Careful! Don't touch the juice of it!",
    PICKED = "I'll just take a look.",
}
STRINGS.CHARACTERS.WOODIE.DESCRIBE.MONSTRAIN =
{
    SUMMER = "The water at the bottom fled.",
    WINTER = "The water at the bottom solidified.",
    GENERIC = "Careful! Don't touch the juice of it!",
    PICKED = "I'll just take a look.",
}
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.MONSTRAIN =
{
    SUMMER = "The water at the bottom fled.",
    WINTER = "The water at the bottom solidified.",
    GENERIC = "Careful! Don't touch the juice of it!",
    PICKED = "I'll just take a look.",
}
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.MONSTRAIN =
{
    SUMMER = "The water at the bottom fled.",
    WINTER = "The water at the bottom solidified.",
    GENERIC = "Careful! Don't touch the juice of it!",
    PICKED = "I'll just take a look.",
}
STRINGS.CHARACTERS.WEBBER.DESCRIBE.MONSTRAIN =
{
    SUMMER = "The water at the bottom fled.",
    WINTER = "The water at the bottom solidified.",
    GENERIC = "Careful! Don't touch the juice of it!",
    PICKED = "I'll just take a look.",
}
STRINGS.CHARACTERS.WINONA.DESCRIBE.MONSTRAIN =
{
    SUMMER = "The water at the bottom fled.",
    WINTER = "The water at the bottom solidified.",
    GENERIC = "Careful! Don't touch the juice of it!",
    PICKED = "I'll just take a look.",
}
]]--

STRINGS.NAMES.SQUAMOUSFRUIT = "Squamous Fruit"    --鳞果
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SQUAMOUSFRUIT = "Wow, edible pinecone."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.SQUAMOUSFRUIT = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.SQUAMOUSFRUIT = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.SQUAMOUSFRUIT = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.SQUAMOUSFRUIT = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.SQUAMOUSFRUIT = "Well, isn't that refreshing?"
STRINGS.CHARACTERS.WOODIE.DESCRIBE.SQUAMOUSFRUIT = "Oops, a pinecone that cannot grow up."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.SQUAMOUSFRUIT = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.SQUAMOUSFRUIT = "I've somehow found a way to make it even LESS appealing!"
STRINGS.CHARACTERS.WEBBER.DESCRIBE.SQUAMOUSFRUIT = "Wow, pinecone with our favorite color."
--STRINGS.CHARACTERS.WINONA.DESCRIBE.SQUAMOUSFRUIT = "Great to cool off after some hard physical labor."

STRINGS.NAMES.MONSTRAIN_LEAF = "Monstrain Leaf"    --雨竹叶
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MONSTRAIN_LEAF = "When I eat it, it eats me."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.MONSTRAIN_LEAF = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.MONSTRAIN_LEAF = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.MONSTRAIN_LEAF = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.MONSTRAIN_LEAF = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.MONSTRAIN_LEAF = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.MONSTRAIN_LEAF = "Oops, a pinecone that cannot grow up."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.MONSTRAIN_LEAF = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.MONSTRAIN_LEAF = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.MONSTRAIN_LEAF = "Wow, pinecone with our favorite color."
--STRINGS.CHARACTERS.WINONA.DESCRIBE.MONSTRAIN_LEAF = "Great to cool off after some hard physical labor."

STRINGS.NAMES.BOOK_WEATHER = "Changing Clouds"    --多变的云
STRINGS.RECIPE_DESC.BOOK_WEATHER = "Stir the clouds with your heart." --科技栏里的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOOK_WEATHER = "When clouds cover the sun... when sunlight penetrates the clouds..."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.BOOK_WEATHER = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.BOOK_WEATHER = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.BOOK_WEATHER = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.BOOK_WEATHER = "STICK ADDON INSTALLED"
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.BOOK_WEATHER = "Well, I can forecast the weather correctly now."
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.BOOK_WEATHER = "I'd prefer maple taffy..."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.BOOK_WEATHER = "Hm... I can forecast the weather correctly now."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.BOOK_WEATHER = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.BOOK_WEATHER = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.BOOK_WEATHER = "Great to cool off after some hard physical labor."
--
STRINGS.CHARACTERS.GENERIC.ANNOUNCE_READ_BOOK.BOOK_WEATHER = "Wait, isn't it just Wurt who reads?"
-- STRINGS.CHARACTERS.WILLOW.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- STRINGS.CHARACTERS.WOLFGANG.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- STRINGS.CHARACTERS.WENDY.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- STRINGS.CHARACTERS.WX78.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- STRINGS.CHARACTERS.WICKERBOTTOM.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- STRINGS.CHARACTERS.WOODIE.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- STRINGS.CHARACTERS.WAXWELL.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- STRINGS.CHARACTERS.WATHGRITHR.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- STRINGS.CHARACTERS.WEBBER.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- STRINGS.CHARACTERS.WINONA.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- STRINGS.CHARACTERS.WORTOX.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- STRINGS.CHARACTERS.WORMWOOD.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- STRINGS.CHARACTERS.WARLY.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
STRINGS.CHARACTERS.WURT.ANNOUNCE_READ_BOOK.BOOK_WEATHER_SUNNY = "Arid, dry, waterless, blablabla..."
STRINGS.CHARACTERS.WURT.ANNOUNCE_READ_BOOK.BOOK_WEATHER_RAINY = "Drizzle, sprinkle, downpour, that's sweet."

STRINGS.NAMES.MERM_SCALES = "Drippy Scales"  --鱼鳞
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MERM_SCALES = "Ewwwwwwww, smell a strong fishy smell."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.MERM_SCALES = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.MERM_SCALES = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.MERM_SCALES = "Contrary to Ms Squid's magic."
--STRINGS.CHARACTERS.WX78.DESCRIBE.MERM_SCALES = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.MERM_SCALES = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.MERM_SCALES = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.MERM_SCALES = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.MERM_SCALES = "I've somehow found a way to make it even LESS appealing!"
STRINGS.CHARACTERS.WEBBER.DESCRIBE.MERM_SCALES = "And how about the one with the drippy nose?"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.MERM_SCALES = "Great to cool off after some hard physical labor."

STRINGS.NAMES.HAT_MERMBREATHING = "Breathing Gills"  --鱼之息
STRINGS.RECIPE_DESC.HAT_MERMBREATHING = "Breathing like a merm." --科技栏里的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HAT_MERMBREATHING = "I hope I won't jump into the sea and disappear."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.HAT_MERMBREATHING = ""
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.HAT_MERMBREATHING = ""
STRINGS.CHARACTERS.WENDY.DESCRIBE.HAT_MERMBREATHING = "Contrary to Ms Squid's magic."
--STRINGS.CHARACTERS.WX78.DESCRIBE.HAT_MERMBREATHING = ""
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.HAT_MERMBREATHING = ""
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.HAT_MERMBREATHING = ""
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.HAT_MERMBREATHING = ""
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.HAT_MERMBREATHING = ""
STRINGS.CHARACTERS.WEBBER.DESCRIBE.HAT_MERMBREATHING = "I can swim freely! er... need a fish tail."
--STRINGS.CHARACTERS.WINONA.DESCRIBE.HAT_MERMBREATHING = ""

STRINGS.NAMES.AGRONSSWORD = "Agron's Sword"  --艾力冈的剑
STRINGS.CHARACTERS.GENERIC.DESCRIBE.AGRONSSWORD = "I'll fight to be a free man!"
STRINGS.CHARACTERS.WILLOW.DESCRIBE.AGRONSSWORD = "A single faith can start a freedom fire."
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.AGRONSSWORD = "It fills Wolfgang with courage!"
STRINGS.CHARACTERS.WENDY.DESCRIBE.AGRONSSWORD = "If I leave here, Abigail will leave me."
STRINGS.CHARACTERS.WX78.DESCRIBE.AGRONSSWORD = "YEARN FOR HUMAN NATURE BUT... FEAR TO POSSESS IT."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.AGRONSSWORD = "Do not shed tears."
STRINGS.CHARACTERS.WOODIE.DESCRIBE.AGRONSSWORD = "Lucy comforts me, so I believe I can escape from here one day."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.AGRONSSWORD = "There is no greater victory than to fall from this world as a free man."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.AGRONSSWORD = "When the Bringer of Rain died, even Valhalla was moved."
STRINGS.CHARACTERS.WEBBER.DESCRIBE.AGRONSSWORD = "If I could, I would be out of this world with my legion!"
STRINGS.CHARACTERS.WINONA.DESCRIBE.AGRONSSWORD = "I am a laborer, not a slave, I'm my own!"

STRINGS.NAMES.GIANTSFOOT = "Giant's Foot"  --巨人之脚
STRINGS.RECIPE_DESC.GIANTSFOOT = "Let giant rule your stuff." --科技栏里的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GIANTSFOOT = "Giant stands on the shoulders of me."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.GIANTSFOOT = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.GIANTSFOOT = "Wolfgang can eat in one bite!"
STRINGS.CHARACTERS.WENDY.DESCRIBE.GIANTSFOOT = "Er... Have I seen it somewhere?"
--STRINGS.CHARACTERS.WX78.DESCRIBE.GIANTSFOOT = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.GIANTSFOOT = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.GIANTSFOOT = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.GIANTSFOOT = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.GIANTSFOOT = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.GIANTSFOOT = "I can swim freely! er... need a fish tail."
--STRINGS.CHARACTERS.WINONA.DESCRIBE.GIANTSFOOT = "Great to cool off after some hard physical labor."

STRINGS.NAMES.REFRACTEDMOONLIGHT = "Refracted Moonlight"  --月折宝剑
STRINGS.CHARACTERS.GENERIC.DESCRIBE.REFRACTEDMOONLIGHT = "Oh my glob! A powerful sword from the Land of Ooo?"
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.REFRACTEDMOONLIGHT = "A single faith can start a freedom fire."
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.REFRACTEDMOONLIGHT = "It fills Wolfgang with courage!"
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.REFRACTEDMOONLIGHT = "If I leave here, Abigail will leave me."
-- STRINGS.CHARACTERS.WX78.DESCRIBE.REFRACTEDMOONLIGHT = "YEARN FOR HUMAN NATURE BUT... FEAR TO POSSESS IT."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.REFRACTEDMOONLIGHT = "Only a person of integrity can control its power."
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.REFRACTEDMOONLIGHT = "Lucy comforts me, so I believe I can escape from here one day."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.REFRACTEDMOONLIGHT = "Only those who are healthy can wield its power."
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.REFRACTEDMOONLIGHT = "When the Bringer of Rain died, even Valhalla was moved."
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.REFRACTEDMOONLIGHT = "If I could, I would be out of this world with my legion!"
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.REFRACTEDMOONLIGHT = "I am a laborer, not a slave, I'm my own!"

STRINGS.NAMES.MOONDUNGEON = "Moon Dungeon"   --月的地下城
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MOONDUNGEON =
{
    SLEEP = "Is that fossilized fossil?",
    GENERIC = "Someone burned up his whole life and built it here.",
}
--[[
STRINGS.CHARACTERS.WILLOW.DESCRIBE.MOONDUNGEON =
{
    SLEEP = "Is that fossilized fossil?",
    GENERIC = "Someone burned up his whole life and built it here.",
}
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.MOONDUNGEON =
{
    SLEEP = "Is that fossilized fossil?",
    GENERIC = "Someone burned up his whole life and built it here.",
}
STRINGS.CHARACTERS.WENDY.DESCRIBE.MOONDUNGEON =
{
    SLEEP = "Is that fossilized fossil?",
    GENERIC = "Someone burned up his whole life and built it here.",
}
STRINGS.CHARACTERS.WX78.DESCRIBE.MOONDUNGEON =
{
    SLEEP = "Is that fossilized fossil?",
    GENERIC = "Someone burned up his whole life and built it here.",
}
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.MOONDUNGEON =
{
    SLEEP = "Is that fossilized fossil?",
    GENERIC = "Someone burned up his whole life and built it here.",
}
STRINGS.CHARACTERS.WOODIE.DESCRIBE.MOONDUNGEON =
{
    SLEEP = "Is that fossilized fossil?",
    GENERIC = "Someone burned up his whole life and built it here.",
}
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.MOONDUNGEON =
{
    SLEEP = "Is that fossilized fossil?",
    GENERIC = "Someone burned up his whole life and built it here.",
}
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.MOONDUNGEON =
{
    SLEEP = "Is that fossilized fossil?",
    GENERIC = "Someone burned up his whole life and built it here.",
}
STRINGS.CHARACTERS.WEBBER.DESCRIBE.MOONDUNGEON =
{
    SLEEP = "Is that fossilized fossil?",
    GENERIC = "Someone burned up his whole life and built it here.",
}
STRINGS.CHARACTERS.WINONA.DESCRIBE.MOONDUNGEON =
{
    SLEEP = "Is that fossilized fossil?",
    GENERIC = "Someone burned up his whole life and built it here.",
}
]]--

STRINGS.NAMES.HIDDENMOONLIGHT = "Hidden Moonlight"  --月藏宝匣
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HIDDENMOONLIGHT = "As empty as the Milky way."
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.HIDDENMOONLIGHT = ""
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.HIDDENMOONLIGHT = "Look! There are stars blinking at Wolfgang."
STRINGS.CHARACTERS.WENDY.DESCRIBE.HIDDENMOONLIGHT = "Light moonlight, somewhere in my heart."
-- STRINGS.CHARACTERS.WX78.DESCRIBE.HIDDENMOONLIGHT = ""
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.HIDDENMOONLIGHT = "The time flow in this box is slower than outside."
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.HIDDENMOONLIGHT = ""
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.HIDDENMOONLIGHT = "Moon's magic is more than that!"
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.HIDDENMOONLIGHT = ""
STRINGS.CHARACTERS.WEBBER.DESCRIBE.HIDDENMOONLIGHT = "Yeah! Reach in and catch what you think."
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.HIDDENMOONLIGHT = ""
-- STRINGS.CHARACTERS.WORTOX.DESCRIBE.HIDDENMOONLIGHT = ""
STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.HIDDENMOONLIGHT = "Hollow, like me."
STRINGS.CHARACTERS.WARLY.DESCRIBE.HIDDENMOONLIGHT = "Save my ingredients better!"
-- STRINGS.CHARACTERS.WURT.DESCRIBE.HIDDENMOONLIGHT = ""
STRINGS.CHARACTERS.WALTER.DESCRIBE.HIDDENMOONLIGHT = "Why is there no sound of waves coming out, florp?"

STRINGS.NAMES.HIDDENMOONLIGHT_ITEM = "Unused Hidden Moonlight" --未启用的月藏宝匣
STRINGS.RECIPE_DESC.HIDDENMOONLIGHT_ITEM = "Hiding dainties between moon and stars."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HIDDENMOONLIGHT_ITEM = "Seems to be an upgrade package for food box."
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.HIDDENMOONLIGHT_ITEM = "Is this also a secret fridge part in ancient times?"
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
-- STRINGS.CHARACTERS.WX78.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.HIDDENMOONLIGHT_ITEM = "A box powered by moonlight."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.HIDDENMOONLIGHT_ITEM = "Hope it's not Pandora's box."
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
STRINGS.CHARACTERS.WINONA.DESCRIBE.HIDDENMOONLIGHT_ITEM = "The inspiration of moon!"
STRINGS.CHARACTERS.WORTOX.DESCRIBE.HIDDENMOONLIGHT_ITEM = "I can feel it being called by a box full of food."
-- STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
-- STRINGS.CHARACTERS.WARLY.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
-- STRINGS.CHARACTERS.WURT.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
-- STRINGS.CHARACTERS.WALTER.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""

--------------------------------------------------------------------------
--[[ legends of the fall ]]--[[ 秋天传说 ]]
--------------------------------------------------------------------------

STRINGS.NAMES.PLANT_NORMAL_LEGION = "Crop"   --农作物(新型)
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PLANT_NORMAL_LEGION =
{
    WITHERED = "What a pity! Waiting to be watered, but...",
    READY = "Oho! Waiting to be eaten!",
    FLORESCENCE = "Gee! Waiting for you to bear fruit.",
    YOUTH = "Meh. Waiting for you to bloom.",
    GROWING = "Mmmm. Waiting for you to grow up.",
}
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.PLANT_NORMAL_LEGION =
-- {
--     WITHERED = "What a pity! Waiting to be watered, but...",
--     READY = "Oho! Waiting to be eaten!",
--     FLORESCENCE = "Gee! Waiting for you to bear fruit.",
--     YOUTH = "Meh. Waiting for you to bloom.",
--     GROWING = "Mmmm. Waiting for you to grow up.",
-- }
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.PLANT_NORMAL_LEGION =
-- {
--     WITHERED = "What a pity! Waiting to be watered, but...",
--     READY = "Oho! Waiting to be eaten!",
--     FLORESCENCE = "Gee! Waiting for you to bear fruit.",
--     YOUTH = "Meh. Waiting for you to bloom.",
--     GROWING = "Mmmm. Waiting for you to grow up.",
-- }
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.PLANT_NORMAL_LEGION =
-- {
--     WITHERED = "What a pity! Waiting to be watered, but...",
--     READY = "Oho! Waiting to be eaten!",
--     FLORESCENCE = "Gee! Waiting for you to bear fruit.",
--     YOUTH = "Meh. Waiting for you to bloom.",
--     GROWING = "Mmmm. Waiting for you to grow up.",
-- }
-- STRINGS.CHARACTERS.WX78.DESCRIBE.PLANT_NORMAL_LEGION =
-- {
--     WITHERED = "What a pity! Waiting to be watered, but...",
--     READY = "Oho! Waiting to be eaten!",
--     FLORESCENCE = "Gee! Waiting for you to bear fruit.",
--     YOUTH = "Meh. Waiting for you to bloom.",
--     GROWING = "Mmmm. Waiting for you to grow up.",
-- }
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.PLANT_NORMAL_LEGION =
-- {
--     WITHERED = "What a pity! Waiting to be watered, but...",
--     READY = "Oho! Waiting to be eaten!",
--     FLORESCENCE = "Gee! Waiting for you to bear fruit.",
--     YOUTH = "Meh. Waiting for you to bloom.",
--     GROWING = "Mmmm. Waiting for you to grow up.",
-- }
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.PLANT_NORMAL_LEGION =
-- {
--     WITHERED = "What a pity! Waiting to be watered, but...",
--     READY = "Oho! Waiting to be eaten!",
--     FLORESCENCE = "Gee! Waiting for you to bear fruit.",
--     YOUTH = "Meh. Waiting for you to bloom.",
--     GROWING = "Mmmm. Waiting for you to grow up.",
-- }
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.PLANT_NORMAL_LEGION =
-- {
--     WITHERED = "What a pity! Waiting to be watered, but...",
--     READY = "Oho! Waiting to be eaten!",
--     FLORESCENCE = "Gee! Waiting for you to bear fruit.",
--     YOUTH = "Meh. Waiting for you to bloom.",
--     GROWING = "Mmmm. Waiting for you to grow up.",
-- }
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.PLANT_NORMAL_LEGION =
-- {
--     WITHERED = "What a pity! Waiting to be watered, but...",
--     READY = "Oho! Waiting to be eaten!",
--     FLORESCENCE = "Gee! Waiting for you to bear fruit.",
--     YOUTH = "Meh. Waiting for you to bloom.",
--     GROWING = "Mmmm. Waiting for you to grow up.",
-- }
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.PLANT_NORMAL_LEGION =
-- {
--     WITHERED = "What a pity! Waiting to be watered, but...",
--     READY = "Oho! Waiting to be eaten!",
--     FLORESCENCE = "Gee! Waiting for you to bear fruit.",
--     YOUTH = "Meh. Waiting for you to bloom.",
--     GROWING = "Mmmm. Waiting for you to grow up.",
-- }
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.PLANT_NORMAL_LEGION =
-- {
--     WITHERED = "What a pity! Waiting to be watered, but...",
--     READY = "Oho! Waiting to be eaten!",
--     FLORESCENCE = "Gee! Waiting for you to bear fruit.",
--     YOUTH = "Meh. Waiting for you to bloom.",
--     GROWING = "Mmmm. Waiting for you to grow up.",
-- }
-- STRINGS.CHARACTERS.WORTOX.DESCRIBE.PLANT_NORMAL_LEGION =
-- {
--     WITHERED = "What a pity! Waiting to be watered, but...",
--     READY = "Oho! Waiting to be eaten!",
--     FLORESCENCE = "Gee! Waiting for you to bear fruit.",
--     YOUTH = "Meh. Waiting for you to bloom.",
--     GROWING = "Mmmm. Waiting for you to grow up.",
-- }
STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.PLANT_NORMAL_LEGION =
{
    WITHERED = "Sorry, I should have paid special attention to you.",
    READY = "Oh, this is an old friend.",
    FLORESCENCE = "Look at you, blooming.",
    YOUTH = "Friend, be mature, OK?",
    GROWING = "Lovely child.",
}
STRINGS.CHARACTERS.WARLY.DESCRIBE.PLANT_NORMAL_LEGION =
{
    WITHERED = "Sorry, this dish is sold out.",
    READY = "Soon, your order will be ready.",
    FLORESCENCE = "Don't rush, your order will be ready in a minute.",
    YOUTH = "Be ready soon. Your order is growing.",
    GROWING = "Don't worry, the dish you ordered just sprouts.",
}
-- STRINGS.CHARACTERS.WURT.DESCRIBE.PLANT_NORMAL_LEGION =
-- {
--     WITHERED = "What a pity! Waiting to be watered, but...",
--     READY = "Oho! Waiting to be eaten!",
--     FLORESCENCE = "Gee! Waiting for you to bear fruit.",
--     YOUTH = "Meh. Waiting for you to bloom.",
--     GROWING = "Mmmm. Waiting for you to grow up.",
-- }

STRINGS.NAMES.FARMINGDUNGBALL_ITEM = "Cultivated Soil Ball"    --栽培肥料球
STRINGS.RECIPE_DESC.FARMINGDUNGBALL_ITEM = "This is where the seeds should stay." --科技栏里的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FARMINGDUNGBALL_ITEM = "Nausea! I don't want to know about the process of making it."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.FARMINGDUNGBALL_ITEM = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.FARMINGDUNGBALL_ITEM = "Wolfgang can eat in one bite!"
STRINGS.CHARACTERS.WENDY.DESCRIBE.FARMINGDUNGBALL_ITEM = "Cinderella may have done this before."
STRINGS.CHARACTERS.WX78.DESCRIBE.FARMINGDUNGBALL_ITEM = "IT'S NOT USELESS THAT EVERYONE HATES."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.FARMINGDUNGBALL_ITEM = "This method is usually used for maize cultivation."
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.FARMINGDUNGBALL_ITEM = "I'd prefer maple taffy..."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.FARMINGDUNGBALL_ITEM = "I'm becoming more and more like a farmer."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.FARMINGDUNGBALL_ITEM = "I've somehow found a way to make it even LESS appealing!"
STRINGS.CHARACTERS.WEBBER.DESCRIBE.FARMINGDUNGBALL_ITEM = "Kind of like playing with mud, kind of disgusting."
--STRINGS.CHARACTERS.WINONA.DESCRIBE.FARMINGDUNGBALL_ITEM = "Great to cool off after some hard physical labor."
STRINGS.CHARACTERS.WORTOX.DESCRIBE.FARMINGDUNGBALL_ITEM = "Hee-hee, I should use this for snowball fights."

STRINGS.NAMES.FARMINGDUNGBALL = "A Pile of Cultivated Soil"    --栽培肥料堆
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FARMINGDUNGBALL = "Nausea! I don't want to know about the process of making it."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.FARMINGDUNGBALL = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.FARMINGDUNGBALL = "Wolfgang can eat in one bite!"
STRINGS.CHARACTERS.WENDY.DESCRIBE.FARMINGDUNGBALL = "Cinderella may have done this before."
STRINGS.CHARACTERS.WX78.DESCRIBE.FARMINGDUNGBALL = "IT'S NOT USELESS THAT EVERYONE HATES."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.FARMINGDUNGBALL = "This method is usually used for maize cultivation."
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.FARMINGDUNGBALL = "I'd prefer maple taffy..."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.FARMINGDUNGBALL = "I'm becoming more and more like a farmer."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.FARMINGDUNGBALL = "I've somehow found a way to make it even LESS appealing!"
STRINGS.CHARACTERS.WEBBER.DESCRIBE.FARMINGDUNGBALL = "Kind of like playing with mud, kind of disgusting."
--STRINGS.CHARACTERS.WINONA.DESCRIBE.FARMINGDUNGBALL = "Great to cool off after some hard physical labor."
STRINGS.CHARACTERS.WORTOX.DESCRIBE.FARMINGDUNGBALL = "Hey, who dropped this in a snowball fight?"

STRINGS.NAMES.PINEANANAS = "Pineananas"    --松萝
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PINEANANAS = "Eating it raw may numb my mouth."
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.PINEANANAS = ""
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.PINEANANAS = ""
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.PINEANANAS = ""
-- STRINGS.CHARACTERS.WX78.DESCRIBE.PINEANANAS = ""
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.PINEANANAS = ""
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.PINEANANAS = ""
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.PINEANANAS = ""
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.PINEANANAS = ""
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.PINEANANAS = ""
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.PINEANANAS = ""
-- STRINGS.CHARACTERS.WORTOX.DESCRIBE.PINEANANAS = ""
-- STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.PINEANANAS = ""
-- STRINGS.CHARACTERS.WARLY.DESCRIBE.PINEANANAS = ""
-- STRINGS.CHARACTERS.WURT.DESCRIBE.PINEANANAS = ""
-- STRINGS.CHARACTERS.WALTER.DESCRIBE.PINEANANAS = ""

STRINGS.NAMES.PINEANANAS_COOKED = "Roasted Pineananas"    --烤松萝
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PINEANANAS_COOKED = "It tastes much better after roasted."
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.PINEANANAS_COOKED = ""
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.PINEANANAS_COOKED = ""
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.PINEANANAS_COOKED = ""
-- STRINGS.CHARACTERS.WX78.DESCRIBE.PINEANANAS_COOKED = ""
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.PINEANANAS_COOKED = ""
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.PINEANANAS_COOKED = ""
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.PINEANANAS_COOKED = ""
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.PINEANANAS_COOKED = ""
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.PINEANANAS_COOKED = ""
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.PINEANANAS_COOKED = ""
-- STRINGS.CHARACTERS.WORTOX.DESCRIBE.PINEANANAS_COOKED = ""
-- STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.PINEANANAS_COOKED = ""
-- STRINGS.CHARACTERS.WARLY.DESCRIBE.PINEANANAS_COOKED = ""
-- STRINGS.CHARACTERS.WURT.DESCRIBE.PINEANANAS_COOKED = ""
-- STRINGS.CHARACTERS.WALTER.DESCRIBE.PINEANANAS_COOKED = ""

STRINGS.NAMES.PINEANANAS_SEEDS = "Pineananas Seeds"    --松萝种子
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PINEANANAS_SEEDS = "I'm not sure if it should be a pine cone or pineapple seed."
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.PINEANANAS_SEEDS = ""
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.PINEANANAS_SEEDS = ""
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.PINEANANAS_SEEDS = ""
-- STRINGS.CHARACTERS.WX78.DESCRIBE.PINEANANAS_SEEDS = ""
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.PINEANANAS_SEEDS = ""
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.PINEANANAS_SEEDS = ""
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.PINEANANAS_SEEDS = ""
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.PINEANANAS_SEEDS = ""
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.PINEANANAS_SEEDS = ""
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.PINEANANAS_SEEDS = ""
-- STRINGS.CHARACTERS.WORTOX.DESCRIBE.PINEANANAS_SEEDS = ""
-- STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.PINEANANAS_SEEDS = ""
-- STRINGS.CHARACTERS.WARLY.DESCRIBE.PINEANANAS_SEEDS = ""
-- STRINGS.CHARACTERS.WURT.DESCRIBE.PINEANANAS_SEEDS = ""
-- STRINGS.CHARACTERS.WALTER.DESCRIBE.PINEANANAS_SEEDS = ""

STRINGS.NAMES.CROPGNAT = "Pest Swarm"    --植害虫群
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CROPGNAT = "Hey, stay away from my crops, pests!"
STRINGS.CHARACTERS.WILLOW.DESCRIBE.CROPGNAT = "Do they like fire, too?"
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.CROPGNAT = "Fortunately, they don't bite Wolfgang."
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.CROPGNAT = "Baby's always so cute, grown one's not."
-- STRINGS.CHARACTERS.WX78.DESCRIBE.CROPGNAT = "STICK ADDON INSTALLED"
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.CROPGNAT = "Find ways to kill them early, or we'll get nothing!"
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.CROPGNAT = "Hah. Not as funny as Chaplin."
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.CROPGNAT = "Hm... No Monster child, no future trouble."
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.CROPGNAT = "I've somehow found a way to make it even LESS appealing!"
STRINGS.CHARACTERS.WEBBER.DESCRIBE.CROPGNAT = "Broke the windows of my neighbours and they called me a pest."
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.CROPGNAT = "Neither the Keystone, nor a key thing."
-- STRINGS.CHARACTERS.WORTOX.DESCRIBE.CROPGNAT = "Hey, who dropped this in a snowball fight?"
STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.CROPGNAT = "Some friends who would hurt a plant friend."

STRINGS.NAMES.CROPGNAT_INFESTER = "Gnat Swarm"    --叮咬虫群
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CROPGNAT_INFESTER = "Be careful, these flying bugs bite."
STRINGS.CHARACTERS.WILLOW.DESCRIBE.CROPGNAT_INFESTER = "Stupid bugs will be attracted by my fire."
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.CROPGNAT_INFESTER = "Ouch! these little monsters bite!"
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.CROPGNAT_INFESTER = "Baby's always so cute, grown one's not."
STRINGS.CHARACTERS.WX78.DESCRIBE.CROPGNAT_INFESTER = "THEY BITE EVEN THE IRON?"
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.CROPGNAT_INFESTER = "Aggressive and can be attracted by light."
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.CROPGNAT_INFESTER = "Hah. Not as funny as Chaplin."
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.CROPGNAT_INFESTER = "Hm... No Monster child, no future trouble."
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.CROPGNAT_INFESTER = "I've somehow found a way to make it even LESS appealing!"
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.CROPGNAT_INFESTER = "We don't want to grow up, do you?"
STRINGS.CHARACTERS.WINONA.DESCRIBE.CROPGNAT_INFESTER = "Oh my, the noise is terrible."
STRINGS.CHARACTERS.WORTOX.DESCRIBE.CROPGNAT_INFESTER = "Hah, you have to get used to this in the wild."
STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.CROPGNAT_INFESTER = "Some friends who would bite a friend."

STRINGS.NAMES.AHANDFULOFWINGS = "A Handful of Wings"    --一捧翅膀
STRINGS.CHARACTERS.GENERIC.DESCRIBE.AHANDFULOFWINGS = "A handful of very small insect wings."
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.AHANDFULOFWINGS = "Stupid bugs will be attracted by my fire."
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.AHANDFULOFWINGS = "Ouch! these little monsters bite!"
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.AHANDFULOFWINGS = "Baby's always so cute, grown one's not."
-- STRINGS.CHARACTERS.WX78.DESCRIBE.AHANDFULOFWINGS = "THEY BITE EVEN THE IRON?"
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.AHANDFULOFWINGS = "Aggressive and can be attracted by light."
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.AHANDFULOFWINGS = "Hah. Not as funny as Chaplin."
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.AHANDFULOFWINGS = "Hm... No Monster child, no future trouble."
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.AHANDFULOFWINGS = "I've somehow found a way to make it even LESS appealing!"
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.AHANDFULOFWINGS = "We don't want to grow up, do you?"
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.AHANDFULOFWINGS = "Oh my, the noise is terrible."
-- STRINGS.CHARACTERS.WORTOX.DESCRIBE.AHANDFULOFWINGS = "Hah, you have to get used to this in the wild."
-- STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.AHANDFULOFWINGS = "Some friends who would bite a friend."

STRINGS.NAMES.BOLTWINGOUT = "Boltwing-out"    --脱壳之翅
STRINGS.RECIPE_DESC.BOLTWINGOUT = "Make a bolt for it." --科技栏里的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOLTWINGOUT = "It's like a bolt out of threats."
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.BOLTWINGOUT = "Stupid bugs will be attracted by my fire."
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.BOLTWINGOUT = "Ouch! these little monsters bite!"
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.BOLTWINGOUT = "Baby's always so cute, grown one's not."
-- STRINGS.CHARACTERS.WX78.DESCRIBE.BOLTWINGOUT = "THEY BITE EVEN THE IRON?"
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.BOLTWINGOUT = "Aggressive and can be attracted by light."
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.BOLTWINGOUT = "Hah. Not as funny as Chaplin."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.BOLTWINGOUT = "Learning the way of insect survival."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.BOLTWINGOUT = "Tsk-tsk! A real warrior never runs away!"
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.BOLTWINGOUT = "We don't want to grow up, do you?"
STRINGS.CHARACTERS.WINONA.DESCRIBE.BOLTWINGOUT = "I just wanna run... hide it away!"
STRINGS.CHARACTERS.WORTOX.DESCRIBE.BOLTWINGOUT = "Meh, I can do the same thing with souls."
-- STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.BOLTWINGOUT = "Some friends who would bite a friend."

STRINGS.NAMES.BOLTWINGOUT_SHUCK = "Post-eclosion Shuck"  --羽化后的壳
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOLTWINGOUT_SHUCK = "Hah! Most creatures don't know it's just a shuck."
STRINGS.CHARACTERS.WILLOW.DESCRIBE.BOLTWINGOUT_SHUCK = "What a big fake bug, I can burn it!"
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.BOLTWINGOUT_SHUCK = "Ouch! these little monsters bite!"
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.BOLTWINGOUT_SHUCK = "Baby's always so cute, grown one's not."
STRINGS.CHARACTERS.WX78.DESCRIBE.BOLTWINGOUT_SHUCK = "A CRAFTY BUG!"
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.BOLTWINGOUT_SHUCK = "Aggressive and can be attracted by light."
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.BOLTWINGOUT_SHUCK = "Hah. Not as funny as Chaplin."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.BOLTWINGOUT_SHUCK = "For the weak, escape is the best policy."
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.BOLTWINGOUT_SHUCK = "I've somehow found a way to make it even LESS appealing!"
STRINGS.CHARACTERS.WEBBER.DESCRIBE.BOLTWINGOUT_SHUCK = "We'll not want our old skin after molting."
STRINGS.CHARACTERS.WINONA.DESCRIBE.BOLTWINGOUT_SHUCK = "The shuck is not a shuck."
-- STRINGS.CHARACTERS.WORTOX.DESCRIBE.BOLTWINGOUT_SHUCK = "Hah, you have to get used to this in the wild."
STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.BOLTWINGOUT_SHUCK = "Hey friend, are you still here?"

STRINGS.NAMES.CATMINT = "Catmint"   --猫薄荷
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CATMINT = "It smells clean and natural."
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.CATMINT = ""
STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.CATMINT = "Wolfgang misses chewing gum."
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.CATMINT = ""
STRINGS.CHARACTERS.WX78.DESCRIBE.CATMINT = "JUST SOME COMMON WEED LEAVES."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.CATMINT = "Seriously, mint is not the same plant as catmint."
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.CATMINT = ""
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.CATMINT = ""
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.CATMINT = ""
STRINGS.CHARACTERS.WEBBER.DESCRIBE.CATMINT = "How about feeding it to catcoons in the forest?"
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.CATMINT = ""
STRINGS.CHARACTERS.WORTOX.DESCRIBE.CATMINT = "Nah, I don't like it."
STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.CATMINT = "Hello, fragrant friend."
STRINGS.CHARACTERS.WARLY.DESCRIBE.CATMINT = "I wish I could use it as a spice."
STRINGS.CHARACTERS.WURT.DESCRIBE.CATMINT = "Good for vegetarianism, good for me."

STRINGS.NAMES.CATTENBALL = "Cat Wool Ball"   --猫线球
STRINGS.CHARACTERS.GENERIC.DESCRIBE.CATTENBALL = "Although it's poured from the stomach, it's lovely."
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.CATTENBALL = ""
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.CATTENBALL = ""
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.CATTENBALL = ""
STRINGS.CHARACTERS.WX78.DESCRIBE.CATTENBALL = "SMELLS LIKE A CAT."
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.CATTENBALL = ""
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.CATTENBALL = ""
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.CATTENBALL = ""
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.CATTENBALL = ""
STRINGS.CHARACTERS.WEBBER.DESCRIBE.CATTENBALL = "We must have a toy show in our bed."
STRINGS.CHARACTERS.WINONA.DESCRIBE.CATTENBALL = "Maybe it can be used to knit sweaters."
STRINGS.CHARACTERS.WORTOX.DESCRIBE.CATTENBALL = "Look! it's the same color as me."
-- STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.CATTENBALL = ""
-- STRINGS.CHARACTERS.WARLY.DESCRIBE.CATTENBALL = ""
STRINGS.CHARACTERS.WURT.DESCRIBE.CATTENBALL = "A witch living in the desert mirage would love this!"

--------------------------------------------------------------------------
--[[ flash and crush ]]--[[ 电闪雷鸣 ]]
--------------------------------------------------------------------------

STRINGS.UI.CRAFTING.ELECOURMALINE_ONE = "Use a elecourmaline to build a prototype!"
STRINGS.UI.CRAFTING.ELECOURMALINE_TWO = "It seems that this stone is not fully activated!"
STRINGS.UI.CRAFTING.ELECOURMALINE_THREE = "It seems that this stone is not fully activated!"

STRINGS.NAMES.ELECOURMALINE = "Elecourmaline"    --电气重铸台
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ELECOURMALINE = "It contains the power of electricity and creation."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.ELECOURMALINE = "Oh! So cute, like my Bernie."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ELECOURMALINE = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.ELECOURMALINE = "Baby's always so cute, grown one's not."
STRINGS.CHARACTERS.WX78.DESCRIBE.ELECOURMALINE = "I CAN CHARGE MYSELF WITH JUST A LITTLE PIECE."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ELECOURMALINE = "I heard that the stone will discharge when heated."
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.ELECOURMALINE = "The axe that can't chop is not a good axe."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.ELECOURMALINE = "Another of Them is coming. Great."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.ELECOURMALINE = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.ELECOURMALINE = "We don't want to grow up, do you?"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.ELECOURMALINE = "Great to cool off after some hard physical labor."

STRINGS.NAMES.ELECOURMALINE_KEYSTONE = "Key Stone"    --要石
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ELECOURMALINE_KEYSTONE = "Natural creativity."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.ELECOURMALINE_KEYSTONE = "Oh! So cute, like my Bernie."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ELECOURMALINE_KEYSTONE = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.ELECOURMALINE_KEYSTONE = "Baby's always so cute, grown one's not."
--STRINGS.CHARACTERS.WX78.DESCRIBE.ELECOURMALINE_KEYSTONE = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ELECOURMALINE_KEYSTONE = "Well, isn't that refreshing?"
STRINGS.CHARACTERS.WOODIE.DESCRIBE.ELECOURMALINE_KEYSTONE = "Hah. Not as funny as Chaplin."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.ELECOURMALINE_KEYSTONE = "Hm... No Monster child, no future trouble."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.ELECOURMALINE_KEYSTONE = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.ELECOURMALINE_KEYSTONE = "We don't want to grow up, do you?"
STRINGS.CHARACTERS.WINONA.DESCRIBE.ELECOURMALINE_KEYSTONE = "Neither the Keystone, nor a key thing."

STRINGS.NAMES.FIMBUL_AXE = "Fimbul Axe"    --芬布尔斧
-- STRINGS.RECIPE_DESC.FIMBUL_AXE = "Flash and crush!" --这个不能制作
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FIMBUL_AXE = "BOOM SHAKA LAKA!"
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.FIMBUL_AXE = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.FIMBUL_AXE = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.FIMBUL_AXE = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.FIMBUL_AXE = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.FIMBUL_AXE = "Well, isn't that refreshing?"
STRINGS.CHARACTERS.WOODIE.DESCRIBE.FIMBUL_AXE = "The axe that can't chop is not a good axe."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.FIMBUL_AXE = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.FIMBUL_AXE = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.FIMBUL_AXE = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.FIMBUL_AXE = "Great to cool off after some hard physical labor."

STRINGS.NAMES.HAT_COWBOY = "Stetson"    --牛仔帽
STRINGS.RECIPE_DESC.HAT_COWBOY = "Do you want to be a master of taming?" --科技栏里的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HAT_COWBOY = "Aha! let's riiiiiiide!"
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.HAT_COWBOY = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.HAT_COWBOY = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.HAT_COWBOY = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.HAT_COWBOY = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.HAT_COWBOY = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.HAT_COWBOY = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.HAT_COWBOY = "Hm... I don't know what I was expecting."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.HAT_COWBOY = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.HAT_COWBOY = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.HAT_COWBOY = "Great to cool off after some hard physical labor."

STRINGS.NAMES.DUALWRENCH = "Dual-wrench"    --扳手-双用型
STRINGS.RECIPE_DESC.DUALWRENCH = "Definitely the wrong way to use it." --科技栏里的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DUALWRENCH = "This is definitely the wrong way to use it."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.DUALWRENCH = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DUALWRENCH = "Wolfgang can eat in one bite!"
STRINGS.CHARACTERS.WENDY.DESCRIBE.DUALWRENCH = "I hope I won't wrench my hand any more."
--STRINGS.CHARACTERS.WX78.DESCRIBE.DUALWRENCH = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DUALWRENCH = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.DUALWRENCH = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DUALWRENCH = "Hm... I don't know what I was expecting."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DUALWRENCH = "A weapon for workmen, smash!"
STRINGS.CHARACTERS.WEBBER.DESCRIBE.DUALWRENCH = "Let's not wrench our hands again."
STRINGS.CHARACTERS.WINONA.DESCRIBE.DUALWRENCH = "My, my! my best wrench!"

STRINGS.NAMES.ELECARMET = "Elecarmet"    --莱克阿米特
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ELECARMET = "I thought it was the end, but just the beginning."
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.ELECARMET = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ELECARMET = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.ELECARMET = "I used to eat these with Abigail..."
--STRINGS.CHARACTERS.WX78.DESCRIBE.ELECARMET = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ELECARMET = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.ELECARMET = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.ELECARMET = "Hm... I don't know what I was expecting."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.ELECARMET = "My greatest enemy, called Fimbul."
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.ELECARMET = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.ELECARMET = "Great to cool off after some hard physical labor."

STRINGS.NAMES.TOURMALINECORE = "Tourmaline"    --电气石
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TOURMALINECORE = "Oh my, can I touch it?"
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.TOURMALINECORE = "Oh! So cute, like my Bernie."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.TOURMALINECORE = "Wolfgang can eat in one bite!"
--STRINGS.CHARACTERS.WENDY.DESCRIBE.TOURMALINECORE = "Baby's always so cute, grown one's not."
STRINGS.CHARACTERS.WX78.DESCRIBE.TOURMALINECORE = "THE CORE OF ENERGY, THE ENERGY OF ME!"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.TOURMALINECORE = "Well, isn't that refreshing?"
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.TOURMALINECORE = "Hah. Not as funny as Chaplin."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.TOURMALINECORE = "Hm... No Monster child, no future trouble."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.TOURMALINECORE = "I've somehow found a way to make it even LESS appealing!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.TOURMALINECORE = "We don't want to grow up, do you?"
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.TOURMALINECORE = "Neither the Keystone, nor a key thing."

STRINGS.NAMES.ICIRE_ROCK = "Icire Stone"   --鸳鸯石
STRINGS.RECIPE_DESC.ICIRE_ROCK = "Blending of iciness and hotness." --科技栏里的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ICIRE_ROCK =
{
    FROZEN = "Like Snowpiercer.",
    COLD = "The winter is coming.",
    GENERIC = "A precious stone, neither a gem, nor a rock.",
    WARM = "Can spring be far behind?",
    HOT = "In the heat of the sun.",
}
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.ICIRE_ROCK = "This is the opposite of burning."
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ICIRE_ROCK = "Wolfgang can eat in one bite!"
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.ICIRE_ROCK = "I can't always escape, I have to face everything."
-- STRINGS.CHARACTERS.WX78.DESCRIBE.ICIRE_ROCK = "FIREWALL, START!"
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ICIRE_ROCK = "Well, isn't that refreshing?"
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.ICIRE_ROCK = "I'd prefer maple taffy..."
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.ICIRE_ROCK = "Hm... I don't know what I was expecting."
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.ICIRE_ROCK = "Be my mirror, my sword and shield!"
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.ICIRE_ROCK = "Yaaay! Popsicle, popsicle!"
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.ICIRE_ROCK = "Great to cool off after some hard physical labor."

STRINGS.NAMES.GUITAR_MIGUEL = "Miguel's guitar"    --米格尔的吉他
STRINGS.RECIPE_DESC.GUITAR_MIGUEL = "Being a legendary guitarist." --科技栏里的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GUITAR_MIGUEL = "I'll cross life and death to make you remember me!"
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.GUITAR_MIGUEL = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.GUITAR_MIGUEL = "Wolfgang can eat in one bite!"
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.GUITAR_MIGUEL = "Hello from the other side, Abigail."
STRINGS.CHARACTERS.WX78.DESCRIBE.GUITAR_MIGUEL = "NOT MY BUILD FUNCTION TO IMPRESS OTHERS BY MELODY."
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.GUITAR_MIGUEL = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.GUITAR_MIGUEL = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.GUITAR_MIGUEL = "Hm... I don't know what I was expecting."
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.GUITAR_MIGUEL = "A weapon for workmen, smash!"
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.GUITAR_MIGUEL = "Let's not wrench our hands again."
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.GUITAR_MIGUEL = "My, my! my best wrench!"

STRINGS.NAMES.WEB_HUMP_ITEM = "Territory Mark"    --蛛网标记，物品
STRINGS.RECIPE_DESC.WEB_HUMP_ITEM = "Swear your territorial sovereignty!" --科技栏里的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WEB_HUMP_ITEM = "Anyway, it's not what I want to use."
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.WEB_HUMP_ITEM = "This is the opposite of burning."
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.WEB_HUMP_ITEM = "Wolfgang can eat in one bite!"
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.WEB_HUMP_ITEM = "Hello from the other side, Abigail."
STRINGS.CHARACTERS.WX78.DESCRIBE.WEB_HUMP = "OBJECT CLASS: THAUMIEL"
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.WEB_HUMP_ITEM = "Well, isn't that refreshing?"
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.WEB_HUMP_ITEM = "I'd prefer maple taffy..."
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.WEB_HUMP_ITEM = "Hm... I don't know what I was expecting."
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.WEB_HUMP_ITEM = "A weapon for workmen, smash!"
STRINGS.CHARACTERS.WEBBER.DESCRIBE.WEB_HUMP_ITEM = "Indeed, we have too little territory."
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.WEB_HUMP_ITEM = "My, my! my best wrench!"

STRINGS.NAMES.WEB_HUMP = "Territory Mark"    --蛛网标记
STRINGS.CHARACTERS.GENERIC.DESCRIBE.WEB_HUMP =
{
    GENERIC = "That's really too much, spiders!",
    TRYDIGUP = "It's not easy to get rid of this.",
}
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.WEB_HUMP = "This is the opposite of burning."
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.WEB_HUMP = "Wolfgang can eat in one bite!"
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.WEB_HUMP = "Hello from the other side, Abigail."
STRINGS.CHARACTERS.WX78.DESCRIBE.WEB_HUMP = 
{
    GENERIC = "SPECIAL CONTAINMENT PROCEDURES.",
    TRYDIGUP = "IT CAN NOT BE RELOCATED.",
}
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.WEB_HUMP = "Well, isn't that refreshing?"
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.WEB_HUMP = "I'd prefer maple taffy..."
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.WEB_HUMP = "Hm... I don't know what I was expecting."
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.WEB_HUMP = "A weapon for workmen, smash!"
STRINGS.CHARACTERS.WEBBER.DESCRIBE.WEB_HUMP =
{
    GENERIC = "We are very popular with the residents here.",
    TRYDIGUP = "We got this!",
}
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.WEB_HUMP = "My, my! my best wrench!"

STRINGS.NAMES.SADDLE_BAGGAGE = "Baggage Saddle"    --驮运鞍具
STRINGS.RECIPE_DESC.SADDLE_BAGGAGE = "Traditional piggyback transport." --科技栏里的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SADDLE_BAGGAGE = "Hope not to be my friend's last straw."
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.SADDLE_BAGGAGE = "This is the opposite of burning."
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.SADDLE_BAGGAGE = "Wolfgang can eat in one bite!"
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.SADDLE_BAGGAGE = "Hello from the other side, Abigail."
-- STRINGS.CHARACTERS.WX78.DESCRIBE.SADDLE_BAGGAGE = "NOT MY BUILD FUNCTION TO IMPRESS OTHERS BY MELODY."
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.SADDLE_BAGGAGE = "Well, isn't that refreshing?"
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.SADDLE_BAGGAGE = "I'd prefer maple taffy..."
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.SADDLE_BAGGAGE = "Hm... I don't know what I was expecting."
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.SADDLE_BAGGAGE = "A weapon for workmen, smash!"
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.SADDLE_BAGGAGE = "Indeed, we have too little territory."
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.SADDLE_BAGGAGE = "My, my! my best wrench!"

STRINGS.NAMES.TRIPLESHOVELAXE = "Triple-shovelaxe"    --斧铲-三用型
STRINGS.RECIPE_DESC.TRIPLESHOVELAXE = "A low-cost multi-functional tool." --科技栏里的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRIPLESHOVELAXE = "Oh my, this tool is so-ooooo good!"
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.TRIPLESHOVELAXE = ""
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.TRIPLESHOVELAXE = ""
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.TRIPLESHOVELAXE = ""
STRINGS.CHARACTERS.WX78.DESCRIBE.TRIPLESHOVELAXE = "IT'S JUST A COMBINATION TOOL."
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.TRIPLESHOVELAXE = ""
STRINGS.CHARACTERS.WOODIE.DESCRIBE.TRIPLESHOVELAXE = "It's amazing! Oh, I hope Lucy didn't hear it."
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.TRIPLESHOVELAXE = ""
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.TRIPLESHOVELAXE = ""
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.TRIPLESHOVELAXE = ""
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.TRIPLESHOVELAXE = ""
-- STRINGS.CHARACTERS.WORTOX.DESCRIBE.TRIPLESHOVELAXE = ""
STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.TRIPLESHOVELAXE = "Ugh, a sharp weapon of the natural destroyer."
-- STRINGS.CHARACTERS.WARLY.DESCRIBE.TRIPLESHOVELAXE = ""
-- STRINGS.CHARACTERS.WURT.DESCRIBE.TRIPLESHOVELAXE = ""

STRINGS.NAMES.HAT_ALBICANS_MUSHROOM = "Albicans Funcap"    --素白蘑菇帽
STRINGS.RECIPE_DESC.HAT_ALBICANS_MUSHROOM = "Let lots of antibiotics stick to your head." --科技栏里的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "A hat made of antibiotic-rich fungi.",
    HUNGER = "Hungry, I don't have the energy to do this.",
}
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
STRINGS.CHARACTERS.WX78.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "SOME CREATURES CROWD OUT OTHERS.",
    HUNGER = "RUN OUT OF FUEL!",
}
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "Has a good resistance to harmful bacteria.",
    HUNGER = "What if someone is allergic to antibiotics.",
}
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
STRINGS.CHARACTERS.WEBBER.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "The head shakes and the disease escapes.",
    HUNGER = "We are so hungry.",
}
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
-- STRINGS.CHARACTERS.WORTOX.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "My friends, we are saved.",
    HUNGER = "My stomach is empty!",
}
STRINGS.CHARACTERS.WARLY.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "Can I break a piece and cook it?",
    HUNGER = "Nothing magic is ever done on an empty stomach!",
}
STRINGS.CHARACTERS.WURT.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "Maybe it can treat plants infected with fungi.",
    HUNGER = "I need fresh food!",
}

STRINGS.NAMES.ALBICANS_CAP = "Albicans Cap" --采摘的素白菇
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ALBICANS_CAP = "It's the first time I've seen such delicacies."
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.ALBICANS_CAP = ""
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.ALBICANS_CAP = ""
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.ALBICANS_CAP = ""
-- STRINGS.CHARACTERS.WX78.DESCRIBE.ALBICANS_CAP = ""
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.ALBICANS_CAP = "Strange, it should grow deep in the bamboo forest."
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.ALBICANS_CAP = ""
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.ALBICANS_CAP = ""
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.ALBICANS_CAP = ""
STRINGS.CHARACTERS.WEBBER.DESCRIBE.ALBICANS_CAP = "Mushroom in skirt!"
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.ALBICANS_CAP = ""
STRINGS.CHARACTERS.WORTOX.DESCRIBE.ALBICANS_CAP = "Side to give up while love you."
-- STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.ALBICANS_CAP = ""
-- STRINGS.CHARACTERS.WARLY.DESCRIBE.ALBICANS_CAP = ""
-- STRINGS.CHARACTERS.WURT.DESCRIBE.ALBICANS_CAP = ""
-- STRINGS.CHARACTERS.WALTER.DESCRIBE.ALBICANS_CAP = ""

STRINGS.NAMES.SOUL_CONTRACTS = "Soul Contracts" --灵魂契约
STRINGS.RECIPE_DESC.SOUL_CONTRACTS = "To further shackle the soul." --科技栏里的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SOUL_CONTRACTS =
{
    GENERIC = "What devil would have thought of such an evil thing!",
    ONLYONE = "There must be limits to evil!",
}
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.SOUL_CONTRACTS = ""
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.SOUL_CONTRACTS = ""
STRINGS.CHARACTERS.WENDY.DESCRIBE.SOUL_CONTRACTS =
{
    GENERIC = "Roaring, crying, regretting...",
    ONLYONE = "No turning back once the hands are stained.",
}
STRINGS.CHARACTERS.WX78.DESCRIBE.SOUL_CONTRACTS =
{
    GENERIC = "THIS ENHANCES THE HATE MODULE!",
    ONLYONE = "OVERLOAD THE HATE MODULE!",
}
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.SOUL_CONTRACTS = ""
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.SOUL_CONTRACTS = ""
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.SOUL_CONTRACTS = ""
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.SOUL_CONTRACTS = ""
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.SOUL_CONTRACTS = ""
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.SOUL_CONTRACTS = ""
STRINGS.CHARACTERS.WORTOX.DESCRIBE.SOUL_CONTRACTS =
{
    GENERIC = "Hohoho, I can control my soulself better!",
    ONLYONE = "I don't want to lose myself.",
}
STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.SOUL_CONTRACTS =
{
    GENERIC = "The glitter on my chest locked heart too.",
    ONLYONE = "No need.",
}
-- STRINGS.CHARACTERS.WARLY.DESCRIBE.SOUL_CONTRACTS = ""
STRINGS.CHARACTERS.WURT.DESCRIBE.SOUL_CONTRACTS =
{
    GENERIC = "Evil, why have you stolen so much love?",
    ONLYONE = "Enough negative emotions.",
}

--------------------------------------------------------------------------
--[[ desert secret ]]--[[ 大漠隐情 ]]
--------------------------------------------------------------------------

STRINGS.NAMES.DESERTDEFENSE = "Desert Defense"   --砂之抵御
STRINGS.RECIPE_DESC.DESERTDEFENSE = "Use the earth power to protect and fight back." --科技栏里的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.DESERTDEFENSE =
{
    GENERIC = "I can feel the power of the earth, maybe?",
    WEAK = "Maybe I can't use it in the rain!",
    INSANE = "Maybe I'm too insane to do it!",
}
--[[
--STRINGS.CHARACTERS.WILLOW.DESCRIBE.DESERTDEFENSE = "This is the opposite of burning."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.DESERTDEFENSE = "Wolfgang can eat in one bite!"
STRINGS.CHARACTERS.WENDY.DESCRIBE.DESERTDEFENSE = "I can't always escape, I have to face everything."
STRINGS.CHARACTERS.WX78.DESCRIBE.DESERTDEFENSE = "FIREWALL, START!"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.DESERTDEFENSE = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.DESERTDEFENSE = "I'd prefer maple taffy..."
--STRINGS.CHARACTERS.WAXWELL.DESCRIBE.DESERTDEFENSE = "Hm... I don't know what I was expecting."
STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.DESERTDEFENSE = "Be my mirror, my sword and shield!"
--STRINGS.CHARACTERS.WEBBER.DESCRIBE.DESERTDEFENSE = "Yaaay! Popsicle, popsicle!"
--STRINGS.CHARACTERS.WINONA.DESCRIBE.DESERTDEFENSE = "Great to cool off after some hard physical labor."
]]--

STRINGS.NAMES.SHYERRYTREE = "Treembling"    --颤栗树
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHYERRYTREE =
{
    BURNING = "It's on fire!",
    GENERIC = "Is that a tree with only one or two leaves?",
}
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.SHYERRYTREE = "This is the opposite of burning."
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.SHYERRYTREE = "Wolfgang can eat in one bite!"
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.SHYERRYTREE = "Hello from the other side, Abigail."
-- STRINGS.CHARACTERS.WX78.DESCRIBE.SHYERRYTREE = "NOT MY BUILD FUNCTION TO IMPRESS OTHERS BY MELODY."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.SHYERRYTREE =
{
    BURNING = "Don't worry. The fire won't burn the part underground.",
    GENERIC = "In fact, it's not really the trunk that grows outside.",
}
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.SHYERRYTREE = "I'd prefer maple taffy..."
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.SHYERRYTREE = "Hm... I don't know what I was expecting."
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.SHYERRYTREE = "A weapon for workmen, smash!"
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.SHYERRYTREE = "Indeed, we have too little territory."
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.SHYERRYTREE = "My, my! my best wrench!"

STRINGS.NAMES.SHYERRYTREE_PLANTED = "Planted Treembling"    --栽种的颤栗树
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHYERRYTREE_PLANTED =
{
    BURNING = "A precious tree in burning!",
    GENERIC = "Hard transplanted tree still have only one or two leaves.",
}
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.SHYERRYTREE_PLANTED = "This is the opposite of burning."
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.SHYERRYTREE_PLANTED = "Wolfgang can eat in one bite!"
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.SHYERRYTREE_PLANTED = "Hello from the other side, Abigail."
-- STRINGS.CHARACTERS.WX78.DESCRIBE.SHYERRYTREE_PLANTED = "NOT MY BUILD FUNCTION TO IMPRESS OTHERS BY MELODY."
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.SHYERRYTREE_PLANTED = "Well, isn't that refreshing?"
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.SHYERRYTREE_PLANTED = "I'd prefer maple taffy..."
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.SHYERRYTREE_PLANTED = "Hm... I don't know what I was expecting."
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.SHYERRYTREE_PLANTED = "A weapon for workmen, smash!"
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.SHYERRYTREE_PLANTED = "Indeed, we have too little territory."
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.SHYERRYTREE_PLANTED = "My, my! my best wrench!"

STRINGS.NAMES.SHYERRYFLOWER = "Abloom Treembling"    --颤栗花
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHYERRYFLOWER =
{
    BURNING = "Precious flower in burning!",
    GENERIC = "It looks as if it did bear before it blossomed.",
}
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.SHYERRYFLOWER = "This is the opposite of burning."
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.SHYERRYFLOWER = "Wolfgang can eat in one bite!"
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.SHYERRYFLOWER = "Hello from the other side, Abigail."
-- STRINGS.CHARACTERS.WX78.DESCRIBE.SHYERRYFLOWER = "NOT MY BUILD FUNCTION TO IMPRESS OTHERS BY MELODY."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.SHYERRYFLOWER =
{
    BURNING = "Unfortunately, this tree rarely bears fruit.",
    GENERIC = "In fact, the part that looks like flower isn't a real flower.",
}
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.SHYERRYFLOWER = "I'd prefer maple taffy..."
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.SHYERRYFLOWER = "Hm... I don't know what I was expecting."
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.SHYERRYFLOWER = "A weapon for workmen, smash!"
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.SHYERRYFLOWER = "Indeed, we have too little territory."
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.SHYERRYFLOWER = "My, my! my best wrench!"

STRINGS.NAMES.SHYERRY = "Shyerry"    --颤栗果
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHYERRY = "Wow, what a big blueberry!"
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.SHYERRY = "This is the opposite of burning."
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.SHYERRY = "Wolfgang can eat in one bite!"
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.SHYERRY = "Hello from the other side, Abigail."
-- STRINGS.CHARACTERS.WX78.DESCRIBE.SHYERRY = "NOT MY BUILD FUNCTION TO IMPRESS OTHERS BY MELODY."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.SHYERRY = "Rich in nutrition, good for your health."
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.SHYERRY = "I'd prefer maple taffy..."
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.SHYERRY = "Hm... I don't know what I was expecting."
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.SHYERRY = "A weapon for workmen, smash!"
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.SHYERRY = "Indeed, we have too little territory."
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.SHYERRY = "My, my! my best wrench!"

STRINGS.NAMES.SHYERRY_COOKED = "Roasted Shyerry"    --烤颤栗果
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHYERRY_COOKED = "Wow, what a blue roasted orange!"
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.SHYERRY_COOKED = "This is the opposite of burning."
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.SHYERRY_COOKED = "Wolfgang can eat in one bite!"
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.SHYERRY_COOKED = "Hello from the other side, Abigail."
-- STRINGS.CHARACTERS.WX78.DESCRIBE.SHYERRY_COOKED = "NOT MY BUILD FUNCTION TO IMPRESS OTHERS BY MELODY."
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.SHYERRY_COOKED = "Well, the nutrients were all decomposed."
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.SHYERRY_COOKED = "I'd prefer maple taffy..."
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.SHYERRY_COOKED = "Hm... I don't know what I was expecting."
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.SHYERRY_COOKED = "A weapon for workmen, smash!"
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.SHYERRY_COOKED = "Indeed, we have too little territory."
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.SHYERRY_COOKED = "My, my! my best wrench!"

STRINGS.NAMES.SHYERRYLOG = "Big Plancon"    --宽大的木墩
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHYERRYLOG =
{
    BURNING = "It's going to be a big fire.",
    GENERIC = "Suitable for woodworking.",
}
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.SHYERRYLOG = "This is the opposite of burning."
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.SHYERRYLOG = "Wolfgang can eat in one bite!"
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.SHYERRYLOG = "Hello from the other side, Abigail."
-- STRINGS.CHARACTERS.WX78.DESCRIBE.SHYERRYLOG = "NOT MY BUILD FUNCTION TO IMPRESS OTHERS BY MELODY."
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.SHYERRYLOG = "Well, isn't that refreshing?"
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.SHYERRYLOG = "I'd prefer maple taffy..."
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.SHYERRYLOG = "Hm... I don't know what I was expecting."
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.SHYERRYLOG = "A weapon for workmen, smash!"
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.SHYERRYLOG = "Indeed, we have too little territory."
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.SHYERRYLOG = "My, my! my best wrench!"

-- STRINGS.NAMES.FENCE_SHYERRY = "Pastoral Fence"    --田园栅栏
-- STRINGS.CHARACTERS.GENERIC.DESCRIBE.FENCE_SHYERRY = "Disappointing, it's no different from ordinary fences."
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.FENCE_SHYERRY = ""
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.FENCE_SHYERRY = ""
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.FENCE_SHYERRY = ""
-- STRINGS.CHARACTERS.WX78.DESCRIBE.FENCE_SHYERRY = ""
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.FENCE_SHYERRY = ""
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.FENCE_SHYERRY = ""
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.FENCE_SHYERRY = ""
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.FENCE_SHYERRY = ""
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.FENCE_SHYERRY = ""
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.FENCE_SHYERRY = ""
-- STRINGS.CHARACTERS.WORTOX.DESCRIBE.FENCE_SHYERRY = ""
-- STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.FENCE_SHYERRY = ""
-- STRINGS.CHARACTERS.WARLY.DESCRIBE.FENCE_SHYERRY = ""
-- STRINGS.CHARACTERS.WURT.DESCRIBE.FENCE_SHYERRY = ""

-- STRINGS.NAMES.FENCE_SHYERRY_ITEM = "Pastoral Fence"    --田园栅栏 item
-- STRINGS.RECIPE_DESC.FENCE_SHYERRY_ITEM = "Surround your farmland." --科技栏里的描述
-- STRINGS.CHARACTERS.GENERIC.DESCRIBE.FENCE_SHYERRY_ITEM = "Will the place surrounded by it become farmland?"
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- STRINGS.CHARACTERS.WX78.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- STRINGS.CHARACTERS.WORTOX.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- STRINGS.CHARACTERS.WARLY.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- STRINGS.CHARACTERS.WURT.DESCRIBE.FENCE_SHYERRY_ITEM = ""

STRINGS.NAMES.GUITAR_WHITEWOOD = "White Wood Guitar"    --白木吉他
STRINGS.RECIPE_DESC.GUITAR_WHITEWOOD = "A guitar, waiting to be played." --科技栏里的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "I really just want to play to you.",
    FAILED = "Oops, slow down a beat.",
    HUNGRY = "Too tired to play.",
}
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.GUITAR_WHITEWOOD = ""
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.GUITAR_WHITEWOOD = ""
STRINGS.CHARACTERS.WENDY.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "Abigail tried, but she didn't have that talent, hah.",
    FAILED = "It's about the consistency of the beat.",
    HUNGRY = "Hunger affects my melody.",
}
STRINGS.CHARACTERS.WX78.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "THOSE PRIMITIVE CREATURES LOVE IT.",
    FAILED = "WHY AM I THE ONE TO COOPERATE WITH.",
    HUNGRY = "LOW POWER, LIMITED FUNCTION.",
}
STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "Only four strings? Not enough to play it alone.",
    FAILED = "My cooperation is not perfect.",
    HUNGRY = "Not in the mood for this.",
}
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.GUITAR_WHITEWOOD = ""
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "The violin is more elegant.",
    FAILED = "Well, I'm an assistant now?",
    HUNGRY = "Now, time for me to eat, and the others play.",
}
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.GUITAR_WHITEWOOD = ""
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.GUITAR_WHITEWOOD = ""
STRINGS.CHARACTERS.WINONA.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "It's missing the scale.",
    FAILED = "Sorry I didn't catch up, try again?",
    HUNGRY = "How can you work if you are hungry!",
}
STRINGS.CHARACTERS.WORTOX.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "Hee hee, that's why humans interest me so much.",
    FAILED = "Hah, this is so funny.",
    HUNGRY = "Hey! that's not what's pressing.",
}
-- STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.GUITAR_WHITEWOOD = ""
-- STRINGS.CHARACTERS.WARLY.DESCRIBE.GUITAR_WHITEWOOD = ""
-- STRINGS.CHARACTERS.WURT.DESCRIBE.GUITAR_WHITEWOOD = ""
STRINGS.CHARACTERS.WALTER.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "You'll be surprised. I can play it when I'm three.",
    FAILED = "Don't give up. I'll make it.",
    HUNGRY = "There's the dinner bell, you know.",
}

-- STRINGS.NAMES.TOY_SPONGEBOB = "Spongebob Toy"    --玩具小海绵
-- STRINGS.CHARACTERS.GENERIC.DESCRIBE.TOY_SPONGEBOB = "Who is it waiting for?"
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.TOY_SPONGEBOB = ""
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.TOY_SPONGEBOB = ""
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.TOY_SPONGEBOB = "The flower falls, the spring goes."
-- STRINGS.CHARACTERS.WX78.DESCRIBE.TOY_SPONGEBOB = ""
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.TOY_SPONGEBOB = "It says that there is no place to vent one's enthusiasm."
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.TOY_SPONGEBOB = "It also looks forward to the future, that embracing day."
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.TOY_SPONGEBOB = "Life is so long, used to be with loneliness."
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.TOY_SPONGEBOB = "I'm not looking for somebody with some superhuman gifts."
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.TOY_SPONGEBOB = "Love it."
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.TOY_SPONGEBOB = ""
-- STRINGS.CHARACTERS.WORTOX.DESCRIBE.TOY_SPONGEBOB = ""
-- STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.TOY_SPONGEBOB = ""
-- STRINGS.CHARACTERS.WARLY.DESCRIBE.TOY_SPONGEBOB = "Just something I can turn to, somebody I can kiss."
-- STRINGS.CHARACTERS.WURT.DESCRIBE.TOY_SPONGEBOB = ""
-- STRINGS.CHARACTERS.WALTER.DESCRIBE.TOY_SPONGEBOB = ""

-- STRINGS.NAMES.TOY_PATRICKSTAR = "Patrickstar Toy"    --玩具小海星
-- STRINGS.CHARACTERS.GENERIC.DESCRIBE.TOY_PATRICKSTAR = "Moving towards its goal."
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.TOY_PATRICKSTAR = ""
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.TOY_PATRICKSTAR = ""
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.TOY_PATRICKSTAR = "Someone I miss is far away."
-- STRINGS.CHARACTERS.WX78.DESCRIBE.TOY_PATRICKSTAR = ""
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.TOY_PATRICKSTAR = "It says that time always fades everything."
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.TOY_PATRICKSTAR = "It is also full of contradictions, sometimes at a loss."
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.TOY_PATRICKSTAR = "Life is so short, hard and ordinary."
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.TOY_PATRICKSTAR = ""
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.TOY_PATRICKSTAR = "Adore it."
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.TOY_PATRICKSTAR = ""
-- STRINGS.CHARACTERS.WORTOX.DESCRIBE.TOY_PATRICKSTAR = ""
-- STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.TOY_PATRICKSTAR = ""
-- STRINGS.CHARACTERS.WARLY.DESCRIBE.TOY_PATRICKSTAR = ""
-- STRINGS.CHARACTERS.WURT.DESCRIBE.TOY_PATRICKSTAR = ""
-- STRINGS.CHARACTERS.WALTER.DESCRIBE.TOY_PATRICKSTAR = ""

STRINGS.NAMES.PINKSTAFF = "Illusion Staff"    --幻象法杖
STRINGS.RECIPE_DESC.PINKSTAFF = "Illusion is eternal beauty." --科技栏里的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PINKSTAFF = "Is this real? I'm imagining a real illusion."
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.PINKSTAFF = ""
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.PINKSTAFF = ""
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.PINKSTAFF = ""
-- STRINGS.CHARACTERS.WX78.DESCRIBE.PINKSTAFF = ""
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.PINKSTAFF = ""
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.PINKSTAFF = ""
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.PINKSTAFF = ""
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.PINKSTAFF = ""
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.PINKSTAFF = ""
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.PINKSTAFF = ""
-- STRINGS.CHARACTERS.WORTOX.DESCRIBE.PINKSTAFF = ""
-- STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.PINKSTAFF = ""
-- STRINGS.CHARACTERS.WARLY.DESCRIBE.PINKSTAFF = ""
-- STRINGS.CHARACTERS.WURT.DESCRIBE.PINKSTAFF = ""
-- STRINGS.CHARACTERS.WALTER.DESCRIBE.PINKSTAFF = ""

STRINGS.NAMES.THEEMPERORSCROWN = "The Emperor's Crown"  --皇帝的王冠
STRINGS.RECIPE_DESC.THEEMPERORSCROWN = "The symbol of sage." --科技栏里的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.THEEMPERORSCROWN = "A wise man don't believe this symbol."
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.THEEMPERORSCROWN = ""
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.THEEMPERORSCROWN = ""
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.THEEMPERORSCROWN = ""
-- STRINGS.CHARACTERS.WX78.DESCRIBE.THEEMPERORSCROWN = ""
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.THEEMPERORSCROWN = ""
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.THEEMPERORSCROWN = ""
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.THEEMPERORSCROWN = ""
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.THEEMPERORSCROWN = ""
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.THEEMPERORSCROWN = ""
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.THEEMPERORSCROWN = ""
-- STRINGS.CHARACTERS.WORTOX.DESCRIBE.THEEMPERORSCROWN = ""
-- STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.THEEMPERORSCROWN = ""
-- STRINGS.CHARACTERS.WARLY.DESCRIBE.THEEMPERORSCROWN = ""
-- STRINGS.CHARACTERS.WURT.DESCRIBE.THEEMPERORSCROWN = ""
-- STRINGS.CHARACTERS.WALTER.DESCRIBE.THEEMPERORSCROWN = ""

STRINGS.NAMES.THEEMPERORSMANTLE = "The Emperor's Mantle"    --皇帝的披风
STRINGS.RECIPE_DESC.THEEMPERORSMANTLE = "The symbol of gallant." --科技栏里的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.THEEMPERORSMANTLE = "A fearless man don't believe this symbol."
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.THEEMPERORSMANTLE = ""
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.THEEMPERORSMANTLE = ""
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.THEEMPERORSMANTLE = ""
-- STRINGS.CHARACTERS.WX78.DESCRIBE.THEEMPERORSMANTLE = ""
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.THEEMPERORSMANTLE = ""
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.THEEMPERORSMANTLE = ""
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.THEEMPERORSMANTLE = ""
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.THEEMPERORSMANTLE = ""
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.THEEMPERORSMANTLE = ""
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.THEEMPERORSMANTLE = ""
-- STRINGS.CHARACTERS.WORTOX.DESCRIBE.THEEMPERORSMANTLE = ""
-- STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.THEEMPERORSMANTLE = ""
-- STRINGS.CHARACTERS.WARLY.DESCRIBE.THEEMPERORSMANTLE = ""
-- STRINGS.CHARACTERS.WURT.DESCRIBE.THEEMPERORSMANTLE = ""
-- STRINGS.CHARACTERS.WALTER.DESCRIBE.THEEMPERORSMANTLE = ""

STRINGS.NAMES.THEEMPERORSSCEPTER = "The Emperor's Scepter"  --皇帝的权杖
STRINGS.RECIPE_DESC.THEEMPERORSSCEPTER = "The symbol of dignitary." --科技栏里的描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.THEEMPERORSSCEPTER = "A guileless man don't believe this symbol."
-- STRINGS.CHARACTERS.WILLOW.DESCRIBE.THEEMPERORSSCEPTER = ""
-- STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.THEEMPERORSSCEPTER = ""
-- STRINGS.CHARACTERS.WENDY.DESCRIBE.THEEMPERORSSCEPTER = ""
-- STRINGS.CHARACTERS.WX78.DESCRIBE.THEEMPERORSSCEPTER = ""
-- STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.THEEMPERORSSCEPTER = ""
-- STRINGS.CHARACTERS.WOODIE.DESCRIBE.THEEMPERORSSCEPTER = ""
-- STRINGS.CHARACTERS.WAXWELL.DESCRIBE.THEEMPERORSSCEPTER = ""
-- STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.THEEMPERORSSCEPTER = ""
-- STRINGS.CHARACTERS.WEBBER.DESCRIBE.THEEMPERORSSCEPTER = ""
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.THEEMPERORSSCEPTER = ""
-- STRINGS.CHARACTERS.WORTOX.DESCRIBE.THEEMPERORSSCEPTER = ""
-- STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.THEEMPERORSSCEPTER = ""
-- STRINGS.CHARACTERS.WARLY.DESCRIBE.THEEMPERORSSCEPTER = ""
-- STRINGS.CHARACTERS.WURT.DESCRIBE.THEEMPERORSSCEPTER = ""
-- STRINGS.CHARACTERS.WALTER.DESCRIBE.THEEMPERORSSCEPTER = ""

--------------------------------------------------------------------------
--[[ other ]]--[[ 其他 ]]
--------------------------------------------------------------------------

STRINGS.NAMES.BACKCUB = "Back Cub"    --靠背熊
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BACKCUB = "Hey, I think it likes my back."
STRINGS.CHARACTERS.WILLOW.DESCRIBE.BACKCUB = "Oh! So cute, like my Bernie."
--STRINGS.CHARACTERS.WOLFGANG.DESCRIBE.BACKCUB = "Wolfgang can eat in one bite!"
STRINGS.CHARACTERS.WENDY.DESCRIBE.BACKCUB = "Baby's always so cute, grown one's not."
--STRINGS.CHARACTERS.WX78.DESCRIBE.BACKCUB = "STICK ADDON INSTALLED"
--STRINGS.CHARACTERS.WICKERBOTTOM.DESCRIBE.BACKCUB = "Well, isn't that refreshing?"
--STRINGS.CHARACTERS.WOODIE.DESCRIBE.BACKCUB = "The axe that can't chop is not a good axe."
STRINGS.CHARACTERS.WAXWELL.DESCRIBE.BACKCUB = "Hm... No Monster child, no future trouble."
--STRINGS.CHARACTERS.WATHGRITHR.DESCRIBE.BACKCUB = "I've somehow found a way to make it even LESS appealing!"
STRINGS.CHARACTERS.WEBBER.DESCRIBE.BACKCUB = "We don't want to grow up, do you?"
-- STRINGS.CHARACTERS.WINONA.DESCRIBE.BACKCUB = "Great to cool off after some hard physical labor."
-- STRINGS.CHARACTERS.WORTOX.DESCRIBE.BACKCUB = "Hey, who dropped this in a snowball fight?"
-- STRINGS.CHARACTERS.WORMWOOD.DESCRIBE.BACKCUB = "Hey friend, are you still here?"

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
