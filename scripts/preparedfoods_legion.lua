require("constants")
local cookbookui_legion = require "widgets/cookbookui_legion"

local foods_legion =
{
    dish_duriantartare =
    {
        test = function(cooker, names, tags)
            return (names.durian or names.durian_cooked) and tags.meat and (tags.monster and tags.monster > 2)
        end,
        priority = 20,
        foodtype = FOODTYPE.MEAT,
        secondaryfoodtype = FOODTYPE.MONSTER,
        health = 0,
        hunger = 62.5,
        sanity = 0,
        perishtime = TUNING.PERISH_FAST, --6天
        cooktime = 0.5,
        potlevel = "low",
        float = {nil, "small", 0.2, 1.05},

        cook_need = "(烤)榴莲 肉度 怪物度>2",
        cook_cant = nil,
        recipe_count = 4,

        oneat_desc = STRINGS.UI.COOKBOOK.DISH_DURIANTARTARE,
        oneatenfn = function(inst, eater)   --带怪物标签的生物吃下会回复额外属性
            if eater:HasTag("monster") then
                local Health = eater.components.health
                local Sanity = eater.components.sanity

                if Health ~= nil then
                    Health:DoDelta(30, nil, inst.prefab) --加30血
                end

                if Sanity ~= nil then
                    Sanity:DoDelta(10)   --加10精神
                end
            end
        end,
    },

    dish_merrychristmassalad =
    {
        test = function(cooker, names, tags)
            return names.twiggy_nut and names.corn and names.carrot and (tags.veggie and tags.veggie >= 3)
                    and (
                        tags.winterfeast or --一定要用or
                        TUNING.LEGION_FESTIVALRECIPES or IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) --冬季盛宴专属
                    )
        end,
        priority = 20,
        foodtype = FOODTYPE.VEGGIE,
        health = TUNING.HEALING_SMALL,  --3
        hunger = 120,
        sanity = TUNING.SANITY_TINY,    --5
        perishtime = TUNING.PERISH_SUPERFAST,   --3天
        cooktime = 1,
        potlevel = "low",
        float = {nil, "small", 0.2, 1},

        cook_need = "多枝树种 玉米 萝卜 菜度≥3",
        cook_cant = "冬季盛宴专属",
        recipe_count = 4,

        prefabs = { "sanity_lower", "gift",
                    "flint", "moonrocknugget", "silk", "nitre", "gears", "ice", "twigs", "rocks", "goldnugget", "cutgrass", "cutreeds", "beefalowool",
                    "redgem", "bluegem", "greengem", "orangegem", "yellowgem", "opalpreciousgem",
                    "red_cap", "green_cap", "blue_cap", "spore_tall", "spore_medium", "spore_small",
                    "mole", "rabbit", "bee", "butterfly", "robin", "robin_winter", "canary", "oceanfish_medium_4", "oceanfish_medium_6", "fireflies",
                    "glommerfuel", "carrot_seeds", "corn_seeds", "twiggy_nut", "livinglog", "walrus_tusk", "honeycomb", "tentaclespots", "steelwool",
        },
        oneat_desc = STRINGS.UI.COOKBOOK.DISH_MERRYCHRISTMASSALAD,
        oneatenfn = function(inst, eater)   --食用时，有33%几率获得一个小礼物
            if math.random() < 0.33 then
                local items = {
                    --基础材料
                    "flint", "moonrocknugget", "silk", "nitre", "gears", "ice", "twigs", "rocks", "goldnugget", "cutgrass", "cutreeds", "beefalowool",

                    --宝石
                    "redgem", "bluegem", "greengem", "orangegem", "yellowgem", "opalpreciousgem",

                    --蘑菇
                    "red_cap", "green_cap", "blue_cap", "spore_tall", "spore_medium", "spore_small",

                    --小生物
                    "mole", "rabbit", "bee", "butterfly", "robin", "robin_winter", "canary", "oceanfish_medium_4", "oceanfish_medium_6", "fireflies",

                    --特殊材料
                    "glommerfuel", "carrot", "corn", "twiggy_nut", "livinglog", "walrus_tusk", "honeycomb", "tentaclespots", "steelwool",
                }
                local oneofitems = SpawnPrefab(GetRandomItem(items))

                local item = {}
                table.insert(item, oneofitems)

                local gift = SpawnPrefab("gift")
                gift.components.unwrappable:WrapItems(item)

                --礼物包装完成，删除原本物品
                item = nil
                items = nil
                oneofitems:Remove()

                --选定食用者周围位置
                local pos = eater:GetPosition()
                local radius = eater:GetPhysicsRadius(0) + .7 + math.random() * .5
                local angle = math.random() * 2 * PI
                local x = pos.x + radius * math.cos(angle)
                local z = pos.z - radius * math.sin(angle)

                --生成特效与礼物
                local fx = SpawnPrefab("sanity_lower")
                fx.Transform:SetPosition(x, 0, z)

                if eater.SoundEmitter ~= nil then
                    eater.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/bell")
                    eater.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/chain")
                    eater.SoundEmitter:PlaySound("dontstarve/common/dropGeneric")
                end

                if TheWorld.Map:IsAboveGroundAtPoint(x, 0, z) then   --只在有效地面上生成
                    gift.Transform:SetPosition(x, 0, z)
                end
            end
        end,
    },

    dish_sugarlesstrickmakercupcakes =
    {
        test = function(cooker, names, tags)
            return names.pumpkin and tags.egg and tags.magic and tags.monster and not tags.meat
                    and (
                        tags.hallowednights or --一定要用or
                        TUNING.LEGION_FESTIVALRECIPES or IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS) --万圣节专属
                    )
        end,
        priority = 20,
        foodtype = FOODTYPE.VEGGIE,
        health = 0,
        hunger = TUNING.CALORIES_SMALL*5, --62.5
        sanity = TUNING.SANITY_MEDLARGE,    --20
        perishtime = TUNING.PERISH_PRESERVED,   --20天
        cooktime = 2.5,
        float = {nil, "small", 0.08, 1},

        cook_need = "南瓜 蛋度 魔法度 怪物度",
        cook_cant = "肉度 疯狂万圣专属",
        recipe_count = 4,

        prefabs = { "debuff_panicvolcano" },
        oneat_desc = STRINGS.UI.COOKBOOK.DISH_SUGARLESSTRICKMAKERCUPCAKES,
        oneatenfn = function(inst, eater)   --食用时，吸收周围没有携带糖的玩家的精神值加给自己，否则就偷走糖
            if eater.components.inventory == nil then
                return
            end

            local x1, y1, z1 = eater.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x1, y1, z1, 25, { "player" }, { "DECOR", "NOCLICK", "FX", "shadow", "playerghost", "INLIMBO" })
            local sanitycount = 0

            for i, ent in pairs(ents) do
                if ent ~= eater and ent:IsValid() and ent.entity:IsVisible() and
                    ent.components.inventory ~= nil and ent.components.sanity ~= nil
                then
                    local sugar = ent.components.inventory:FindItem(function(item)
                        return item.components.edible ~= nil and item.components.edible.foodtype == FOODTYPE.GOODIES
                    end)

                    if sugar ~= nil then
                        local smallsugar = ent.components.inventory:DropItem(sugar, false)
                        if smallsugar ~= nil then
                            eater.components.inventory:GiveItem(smallsugar)
                        end

                        if ent.components.talker ~= nil then
                            ent.components.talker:Say(GetString(ent, "DESCRIBE", { "DISH_SUGARLESSTRICKMAKERCUPCAKES", "TREAT" }))
                        end
                    elseif ent.components.debuffable ~= nil and not ent.components.debuffable:HasDebuff("halloweenpotion_bravery_buff") then
                        if ent.components.sanity:GetPercent() <= 0 and ent.components.health ~= nil then
                            ent.components.health:DoDelta(-10, nil, inst.prefab)
                        else
                            ent.components.sanity:DoDelta(-30)
                        end
                        sanitycount = sanitycount + 1

                        ent.components.debuffable:AddDebuff("debuff_panicvolcano", "debuff_panicvolcano")
                    end
                end
            end

            if eater.components.sanity ~= nil and sanitycount > 0 then
                eater.components.sanity:DoDelta(25 * sanitycount)
            end
        end,
    },

    dish_flowermooncake =
    {
        test = function(cooker, names, tags)
            return
                (
                    (tags.petals_legion or 0) --蔷薇花瓣、蹄莲花瓣、兰草花瓣、月树花瓣都属于这个
                    + (names.cactus_flower or 0) --仙人掌花瓣
                    + (names.forgetmelots or 0)  --必忘我
                    + (names.myth_lotus_flower or 0)  --【神话书说】莲花
                    + (names.aip_veggie_sunflower or 0) --【额外物品包】向日葵
                    >= 3
                )
                and (tags.veggie and tags.veggie >= 2) and not tags.monster
                and ( --秋季月圆那天才能做出来
                    tags.fallfullmoon or --一定要用or
                    TheWorld and TheWorld.state
                    and TheWorld.state.moonphase == "full" and TheWorld.state.isautumn
                )
        end,
        priority = 20,
        foodtype = FOODTYPE.GOODIES,
        health = 15,
        hunger = TUNING.CALORIES_MED,   --25
        sanity = 15,
        perishtime = TUNING.PERISH_PRESERVED*3,   --60天
        cooktime = 2,
        float = {nil, "small", 0.08, 1},

        cook_need = "花类食材≥3 菜度≥2",
        cook_cant = "怪物度 秋季月圆天专属",
        recipe_count = 6,

        oneat_desc = STRINGS.UI.COOKBOOK.DISH_FLOWERMOONCAKE,
        oneatenfn = function(inst, eater)   --食用时，周围队友越多，回复量越多
            local nummiss = 0
            local numlove =  0

             --计算周围有多少思念对象
            if eater.prefab ~= "wx78" and not TheWorld.state.isnewmoon then --wx78没有思念对象，同时排除新月
                local x, y, z = inst.Transform:GetWorldPosition()
                if eater.prefab == "wormwood" then --沃姆伍德对植物有思念
                    local ents = TheSim:FindEntities(x, y, z, 18, nil, { "INLIMBO", "wall", "structure" }, { "_combat", "plant" })
                    for i, ent in ipairs(ents) do
                        if ent ~= eater then
                            if
                                ent:HasTag("player")
                            then
                                numlove = numlove + 1
                            elseif
                                ent:HasTag("companion")
                                or ent:HasTag("plant") --普通植物，不管是否枯萎
                                or (ent.components.crop ~= nil and not ent:HasTag("withered")) --未枯萎的作物
                                or (eater.components.leader ~= nil and eater.components.leader:IsFollower(ent)) --跟随者
                            then
                                nummiss = nummiss + 1
                            end
                        end
                    end
                else
                    if eater.prefab == "woodie" then --伍迪自带露西斧的加成
                        numlove = numlove + 1
                    end
                    local ents = TheSim:FindEntities(x, y, z, 18, { "_combat" }, { "INLIMBO", "wall", "structure" })
                    for i, ent in ipairs(ents) do
                        if ent ~= eater then
                            if
                                CONFIGS_LEGION.ENABLEDMODS.MythWords
                                and (
                                    (eater:HasTag("monkey_king") and ent:HasTag("monkey")) --孙悟空的猴子
                                    or (eater:HasTag("myth_yutu") and ent:HasTag("manrabbit")) --玉兔的兔人
                                    or (eater:HasTag("white_bone") and ent.prefab == "bone_pet") --白骨的骷髅随从
                                    or (eater:HasTag("pigsy") and ent:HasTag("pig")) --八戒的猪人
                                    or (eater:HasTag("yangjian") and ent:HasTag("skyhound")) --杨戬的哮天犬
                                )
                            then
                                numlove = numlove + 1
                            elseif
                                CONFIGS_LEGION.ENABLEDMODS.MythWords
                                and (
                                    (eater:HasTag("myth_yutu") and ent:HasTag("rabbit")) --玉兔的兔子
                                )
                            then
                                nummiss = nummiss + 1
                            elseif
                                ent:HasTag("player")
                                or (eater:HasTag("ghostlyfriend") and ent:HasTag("abigail")) --温蒂的阿比盖尔
                                or (eater:HasTag("playermerm") and ent:HasTag("merm")) --沃特的鱼人
                            then
                                numlove = numlove + 1
                            elseif
                                ent:HasTag("companion")
                                or (eater:HasTag("shadowmagic") and ent:HasTag("shadowminion")) --麦克斯韦的暗影随从
                                or (eater:HasTag("spiderwhisperer") and ent:HasTag("spider")) --韦伯的蜘蛛
                                or (eater.components.leader ~= nil and eater.components.leader:IsFollower(ent)) --跟随者
                            then
                                nummiss = nummiss + 1
                            end
                        end
                    end
                end
            end

            --满月自带加成，触发特殊台词
            if TheWorld.state.isfullmoon then
                numlove = numlove + 1
                if eater.components.talker ~= nil then
                    eater.components.talker:Say(GetString(eater, "DESCRIBE", { "DISH_FLOWERMOONCAKE", "HAPPY" }))
                end
            end

            local allemotion = nummiss * 8 + numlove * 24
            if allemotion > 0 then
                if eater.components.health ~= nil then
                    eater.components.health:DoDelta(allemotion, nil, inst.prefab)
                end
                if eater.components.sanity ~= nil then
                    eater.components.sanity:DoDelta(allemotion)
                end
            else
                if eater.components.talker ~= nil then
                    eater.components.talker:Say(GetString(eater, "DESCRIBE", { "DISH_FLOWERMOONCAKE", "LONELY" }))
                end
            end
        end,
    },

    dish_farewellcupcake =
    {
        test = function(cooker, names, tags)
            return (names.red_cap or names.red_cap_cooked) and tags.monster and tags.decoration
                and ( --新月那天才能做出来
                    tags.newmoon or --一定要用or
                    TheWorld and TheWorld.state
                    and TheWorld.state.moonphase == "new"
                )
        end,
        priority = 20,
        foodtype = FOODTYPE.VEGGIE,
        health = 0,
        hunger = 37.5,
        sanity = 72,
        perishtime = TUNING.PERISH_PRESERVED, --20天
        cooktime = 1,
        potlevel = "low",
        float = {nil, "small", 0.12, 0.7},

        cook_need = "(烤)红蘑菇 怪物度 装饰度",
        cook_cant = "新月天专属",
        recipe_count = 6,

        oneat_desc = STRINGS.UI.COOKBOOK.DISH_FAREWELLCUPCAKE,
        oneatenfn = function(inst, eater)   --食用者受到1000点的攻击伤害
            if eater.components.combat ~= nil then
                eater.components.combat:GetAttacked(inst, 1000)
            end
        end,
    },

    dish_braisedmeatwithfoliages =
    {
        test = function(cooker, names, tags)
            return (names.foliage and names.foliage >= 2) and (tags.meat and tags.meat >= 1)
                and not tags.inedible and not tags.sweetener
        end,
        priority = 20,
        foodtype = FOODTYPE.MEAT,
        health = 10,
        hunger = 62.5,
        sanity = 8,
        perishtime = TUNING.PERISH_MED, --10天
        cooktime = 1,
        potlevel = "low",
        float = {0.02, "small", 0.2, 1.1},

        cook_need = "蕨叶≥2 肉度≥1",
        cook_cant = "非食 甜度",
        recipe_count = 6,
    },

	--[[
        CALORIES_TINY = calories_per_day/8, -- berries --9.375
        CALORIES_SMALL = calories_per_day/6, -- veggies --12.5
        CALORIES_MEDSMALL = calories_per_day/4, --18.75
        CALORIES_MED = calories_per_day/3, -- meat --25
        CALORIES_LARGE = calories_per_day/2, -- cooked meat --37.5
        CALORIES_HUGE = calories_per_day, -- crockpot foods? --75
        CALORIES_SUPERHUGE = calories_per_day*2, -- crockpot foods? --150

        HEALING_TINY = 1,
        HEALING_SMALL = 3,
        HEALING_MEDSMALL = 8,
        HEALING_MED = 20,
        HEALING_MEDLARGE = 30,
        HEALING_LARGE = 40,
        HEALING_HUGE = 60,
        HEALING_SUPERHUGE = 100,

        SANITY_SUPERTINY = 1,
        SANITY_TINY = 5,
        SANITY_SMALL = 10,
        SANITY_MED = 15,
        SANITY_MEDLARGE = 20,
        SANITY_LARGE = 33,
        SANITY_HUGE = 50,

        PERISH_ONE_DAY = 1*total_day_time*perish_warp, --1天
        PERISH_TWO_DAY = 2*total_day_time*perish_warp, --2天
        PERISH_SUPERFAST = 3*total_day_time*perish_warp,
        PERISH_FAST = 6*total_day_time*perish_warp,
        PERISH_FASTISH = 8*total_day_time*perish_warp,
        PERISH_MED = 10*total_day_time*perish_warp,
        PERISH_SLOW = 15*total_day_time*perish_warp,
        PERISH_PRESERVED = 20*total_day_time*perish_warp,
        PERISH_SUPERSLOW = 40*total_day_time*perish_warp, --40天
	]]--
}

if CONFIGS_LEGION.FLOWERSPOWER then
    foods_legion.dish_chilledrosejuice =
    {
        test = function(cooker, names, tags)
            return (names.petals_rose and names.petals_rose > 1) and tags.frozen and (tags.fruit and tags.fruit >= 1)
                and not tags.meat and not tags.monster
        end,
        priority = 20,
        foodtype = FOODTYPE.VEGGIE,
        health = 45,
        hunger = 12.5,
        sanity = 25,
        perishtime = TUNING.PERISH_SUPERFAST,   --3天
        cooktime = .5,
        potlevel = "low",
        float = {nil, "small", 0.2, 0.7},

        temperature = TUNING.COLD_FOOD_BONUS_TEMP,
        temperatureduration = TUNING.FOOD_TEMP_AVERAGE,

        cook_need = "蔷薇花瓣>1 冰度 果度≥1",
        cook_cant = "肉度 怪物度",
        recipe_count = 4,

        prefabs = { "flower_rose", "flower" },
        oneat_desc = STRINGS.UI.COOKBOOK.DISH_CHILLEDROSEJUICE,
        oneatenfn = function(inst, eater)   --食用产生花朵
            local pos = eater:GetPosition()
            local flower = nil
            local ran = math.random()

            if ran <= 0.11 then
                flower = SpawnPrefab("flower_rose")
            elseif ran <= 0.33 then
                flower = SpawnPrefab("flower")
            end

            if flower ~= nil and pos ~= nil then
                flower.Transform:SetPosition(pos:Get())
                flower.planted = true
            end
        end,
    }

    foods_legion.dish_twistedrolllily =
    {
        test = function(cooker, names, tags)
            return (names.petals_lily and names.petals_lily > 1) and (tags.meat and tags.meat >= 1) and (tags.veggie and tags.veggie >= 2)
        end,
        priority = 20,
        foodtype = FOODTYPE.MEAT,
        health = -3,
        hunger = 62.5,
        sanity = 35,
        perishtime = TUNING.PERISH_MED, --10天
        cooktime = 1,
        potlevel = "low",
        float = {nil, "small", 0.2, 1.05},

        cook_need = "蹄莲花瓣>1 肉度≥1 菜度≥2",
        cook_cant = nil,
        recipe_count = 6,

        prefabs = { "butterfly", "moonbutterfly" },
        oneat_desc = STRINGS.UI.COOKBOOK.DISH_TWISTEDROLLLILY,
        oneatenfn = function(inst, eater)   --食用产生蝴蝶
            local pos = eater:GetPosition()
            local fly = nil
            local ran = math.random()

            if ran <= 0.1 then
                fly = SpawnPrefab("moonbutterfly")
            elseif ran <= 0.5 then
                fly = SpawnPrefab("butterfly")
            end

            if fly ~= nil and pos ~= nil then
                fly.Transform:SetPosition(pos:Get())
                fly.sg:GoToState("idle")
            end
        end,
    }

    foods_legion.dish_orchidcake =
    {
        test = function(cooker, names, tags)
            return (names.petals_orchid and names.petals_orchid > 1) and (tags.veggie and tags.veggie >= 1.5) and tags.fruit
                and not tags.meat and not tags.monster
        end,
        priority = 20,
        foodtype = FOODTYPE.VEGGIE,
        health = 10,
        hunger = 75,
        sanity = 0,
        perishtime = TUNING.PERISH_PRESERVED,   --20天
        cooktime = 2,
        potlevel = "low",
        float = {nil, "small", 0.2, 1.05},

        cook_need = "兰草花瓣>1 菜度≥1.5 果度",
        cook_cant = "肉度 怪物度",
        recipe_count = 6,

        oneat_desc = STRINGS.UI.COOKBOOK.DISH_ORCHIDCAKE,
        oneatenfn = function(inst, eater)   --食用改变玩家体温
            if eater.components.temperature ~= nil then
                local current = eater.components.temperature:GetCurrent()
                if current == nil then return end

                if TheWorld.state.iswinter and current < 60 then
                    eater.components.temperature:SetTemperature(60) --冬季加体温
                elseif TheWorld.state.issummer and current > 10 then
                    eater.components.temperature:SetTemperature(10) --夏季降体温
                elseif not TheWorld.state.iswinter and not TheWorld.state.issummer then
                    eater.components.temperature:SetTemperature(35) --春秋平体温
                end
            end
        end,
    }
end

if CONFIGS_LEGION.PRAYFORRAIN then
    foods_legion.dish_ricedumpling =
    {
        test = function(cooker, names, tags)
            return names.monstrain_leaf and (tags.veggie and tags.veggie >= 2.5) and tags.egg and not tags.meat
        end,
        priority = 20,
        foodtype = FOODTYPE.VEGGIE,
        health = 3,
        hunger = 62.5,
        sanity = 5,
        perishtime = TUNING.PERISH_SLOW,   --15天
        cooktime = 2.5,
        potlevel = "low",
        float = {nil, "small", 0.2, 1.05},

        cook_need = "雨竹叶 菜度≥2.5 蛋度",
        cook_cant = "肉度",
        recipe_count = 6,

        prefabs = { "buff_hungerretarder" },
        oneat_desc = STRINGS.UI.COOKBOOK.DISH_RICEDUMPLING,
        oneatenfn = function(inst, eater)   --食用后3分钟内暂停饥饿下降
            if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                if eater.components.hunger ~= nil then --这个buff需要有饥饿值组件
                    eater.components.debuffable:AddDebuff("buff_hungerretarder", "buff_hungerretarder")
                end
            end
        end,
    }
end

if CONFIGS_LEGION.LEGENDOFFALL then
    foods_legion.dish_murmurananas =
    {
        test = function(cooker, names, tags)
            return (names.pineananas or names.pineananas_cooked) and (tags.meat and tags.meat >= 2)
                and (not tags.monster or tags.monster <= 1)
        end,
        priority = 20,
        foodtype = FOODTYPE.MEAT,
        health = 18,
        hunger = 150,
        sanity = 12.5,
        perishtime = TUNING.PERISH_MED,   --10天
        cooktime = 1,
        potlevel = "low",
        float = {nil, "small", 0.2, 1.05},

        cook_need = "(烤)松萝 肉度≥2",
        cook_cant = "怪物度≤1",
        recipe_count = 6,
    }
    foods_legion.dish_sosweetjarkfruit =
    {
        test = function(cooker, names, tags)
            return names.pineananas and tags.frozen and (tags.sweetener and tags.sweetener >= 2)
                and not tags.monster and not tags.meat
        end,
        priority = 20,
        foodtype = FOODTYPE.VEGGIE,
        health = 0,
        hunger = 18,
        sanity = 24,
        perishtime = TUNING.PERISH_MED * 3,   --30天
        stacksize = 2,
        cooktime = 0.5,
        potlevel = "low",
        float = {0.02, "small", 0.2, 0.9},

        cook_need = "松萝 冰度 甜度≥2",
        cook_cant = "怪物度 肉度",
        recipe_count = 2,
    }
end

if TUNING.LEGION_FLASHANDCRUSH then
    foods_legion.dish_wrappedshrimppaste =
    {
        test = function(cooker, names, tags)
            return names.wobster_sheller_land and names.albicans_cap and (tags.decoration and tags.decoration >= 1)
                and not tags.fruit and not tags.monster
        end,
        priority = 20,
        foodtype = FOODTYPE.MEAT,
        health = 45,
        hunger = 37.5,
        sanity = 40,
        perishtime = TUNING.PERISH_FASTISH,   --8天
        stacksize = 2,
        cooktime = 0.75,
        potlevel = nil,
        float = {0.01, "small", 0.2, 1.2},

        cook_need = "龙虾 素白菇 装饰度≥1",
        cook_cant = "果度 怪物度",
        recipe_count = 4,

        prefabs = { "buff_sporeresistance" },
        oneat_desc = STRINGS.UI.COOKBOOK.DISH_WRAPPEDSHRIMPPASTE,
        oneatenfn = function(inst, eater)   --食用后获得优化的加血buff
            if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                eater.buff_sporeresistance_time = TUNING.SEG_TIME * 24 --12分钟
                eater.components.debuffable:AddDebuff("buff_sporeresistance", "buff_sporeresistance")
            end
        end,
    }
end

if TUNING.LEGION_DESERTSECRET then
    foods_legion.dish_shyerryjam =
    {
        test = function(cooker, names, tags)
            return names.shyerry and not tags.veggie and not tags.monster
                and not tags.egg and not tags.meat and not tags.inedible and not tags.frozen
        end,
        priority = 20,
        foodtype = FOODTYPE.GOODIES,
        health = TUNING.HEALING_MED,    --20
        hunger = TUNING.CALORIES_SMALL,   --12.5
        sanity = TUNING.SANITY_TINY,    --5
        perishtime = nil,   --不会腐烂
        stacksize = 2,
        cooktime = 3,
        potlevel = "low",
        float = {nil, "small", 0.25, 0.8},

        cook_need = "颤栗果",
        cook_cant = "菜/怪物/蛋/肉/冰度 非食",
        recipe_count = 4,

        prefabs = { "buff_healthstorage" },
        oneat_desc = STRINGS.UI.COOKBOOK.DISH_SHYERRYJAM,
        oneatenfn = function(inst, eater)   --食用后获得优化的加血buff
            if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                eater.buff_healthstorage_times = 50 --因为buff相关组件不支持相同buff叠加时的数据传输，所以这里自己定义了一个传输方式
                eater.components.debuffable:AddDebuff("buff_healthstorage", "buff_healthstorage")
            end
        end,
    }
end

if CONFIGS_LEGION.BETTERCOOKBOOK then
    for k,v in pairs(foods_legion) do
        v.name = k
        v.weight = v.weight or 1
        v.priority = v.priority or 0

        -- v.cookbook_category = "portablecookpot" --如果要设置为便携烹饪锅专属，可以写这个
        -- v.cookbook_category = "cookpot"
        -- v.cookbook_category = "mod" --官方在AddCookerRecipe时就设置好了，所以，cookbook_category字段不需要自己写
        v.recipe_count = v.recipe_count or 1
        v.custom_cookbook_details_fn = function(data, self, top, left) --不用给英语环境的使用这个，因为文本太长，不可能装得下
            local root = cookbookui_legion(data, self, top, left)
            return root
        end
    end
else
    for k,v in pairs(foods_legion) do
        v.name = k
        v.weight = v.weight or 1
        v.priority = v.priority or 0
    end
end

return foods_legion
