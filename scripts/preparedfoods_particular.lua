local cookbookui_legion = require "widgets/cookbookui_legion"

local foods_particular =
{
	dish_fleshnapoleon =
    {
        test = function(cooker, names, tags)
            return ((names.wormlight_lesser and names.wormlight_lesser > 1) or names.wormlight)
                and not tags.meat and not tags.inedible and not tags.frozen
        end,
        priority = 20,
        foodtype = FOODTYPE.GOODIES,
        health = 12,
        hunger = 25,
        sanity = 10,
        perishtime = TUNING.PERISH_SLOW,   --15天
        cooktime = 2.5,
        potlevel = "low",
        float = {nil, "small", 0.2, 0.9},

        cook_need = "发光浆果/小发光浆果>1",
        cook_cant = "肉度 非食 冰度",
        recipe_count = 6,

        prefabs = { "wormlight_light" },
        oneat_desc = STRINGS.UI.COOKBOOK.DISH_FLESHNAPOLEON,
        oneatenfn = function(inst, eater)   --食用后生物发光
            ----------------
            --发光效果自带保存机制，所以就不用写成buff的机制了
            ----------------
            if eater.wormlight ~= nil then
                if eater.wormlight.prefab == "wormlight_light" then
                    eater.wormlight.components.spell.lifetime = 0   --本身还有光效时就重置发光时间
                    eater.wormlight.components.spell:ResumeSpell()
                    return
                else
                    eater.wormlight.components.spell:OnFinish() --如果是其他类型的光效，会被新的给替换掉
                end
            end

            local light = SpawnPrefab("wormlight_light")
            light.components.spell.duration = 480   --8分钟的发光时间，神秘浆果发光时间为4分钟，发光浆果时间为1分钟
            light.components.spell:SetTarget(eater)
            if light:IsValid() then
                if light.components.spell.target == nil then
                    light:Remove()
                else
                    light.components.spell:StartSpell()
                end
            end
        end,
    },

    dish_beggingmeat =
    {
        test = function(cooker, names, tags)
            return names.ash and tags.meat and (not tags.monster or tags.monster <= 1) and not tags.sweetener and not tags.frozen
        end,
        priority = 20,
        foodtype = FOODTYPE.MEAT,
        health = 0,
        hunger = 37.5,
        sanity = 5,
        perishtime = TUNING.PERISH_FAST, --6天
        cooktime = 0.75,
        potlevel = "low",
        float = {nil, "small", 0.2, 1},

        cook_need = "肉度 灰烬",
        cook_cant = "怪物度≤1 甜度 冰度",
        recipe_count = 6,

        oneat_desc = STRINGS.UI.COOKBOOK.DISH_BEGGINGMEAT,
        oneatenfn = function(inst, eater)   --角色低饱食吃下去时会有额外回复属性
            if eater:HasTag("player") then
                local Health = eater.components.health
                local Hunger = eater.components.hunger
                local Sanity = eater.components.sanity

                if Hunger ~= nil and (Hunger.current - 37.5)/Hunger.max <= 0.06 then    --吃之前低饱食的话，增加回复属性
                    Hunger:DoDelta(25)  --加25饱食

                    if Health ~= nil then
                        Health:DoDelta(3, nil, inst.prefab) --加3血
                    end

                    if Sanity ~= nil then
                        Sanity:DoDelta(5)   --加5精神
                    end
                end
            end
        end,
    },

    dish_frenchsnailsbaked =
    {
        test = function(cooker, names, tags)
            return names.slurtleslime and names.cutlichen and tags.meat and (not tags.monster or tags.monster <= 1)
        end,
        priority = 20,
        foodtype = FOODTYPE.MEAT,
        health = 30,
        hunger = 37.5,
        sanity = 33,
        perishtime = TUNING.PERISH_SUPERFAST, --3天
        cooktime = 0.5,
        tags = {"explosive"},
        prefabs = { "explode_small" },
        float = {nil, "small", 0.2, 1.05},

        cook_need = "蛞蝓龟黏液 苔藓 肉度",
        cook_cant = "怪物度≤1",
        recipe_count = 6,

        oneat_desc = STRINGS.UI.COOKBOOK.DISH_FRENCHSNAILSBAKED,
    },

    dish_neworleanswings =
    {
        test = function(cooker, names, tags)
            return (names.batwing or names.batwing_cooked) and (tags.meat and tags.meat >= 2) and (not tags.monster or tags.monster <= 2)
        end,
        priority = 20,
        foodtype = FOODTYPE.MEAT,
        health = 3,
        hunger = 120,
        sanity = 5,
        perishtime = TUNING.PERISH_MED, --10天
        cooktime = 2,
        float = {nil, "small", 0.2, 1.05},

        cook_need = "(烤)蝙蝠翅膀 肉度≥2",
        cook_cant = "怪物度≤2",
        recipe_count = 6,

        prefabs = { "buff_batdisguise" },
        oneat_desc = STRINGS.UI.COOKBOOK.DISH_NEWORLEANSWINGS,
        oneatenfn = function(inst, eater)
            if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                not eater:HasTag("playerghost") then
                eater.components.debuffable:AddDebuff("buff_batdisguise", "buff_batdisguise")
            end
        end,
    },

    dish_fishjoyramen =
    {
        test = function(cooker, names, tags)
            return (names.plantmeat or names.plantmeat_cooked) and tags.fish and (not tags.monster or tags.monster <= 1)
                and not tags.inedible and not tags.sweetener
        end,
        priority = 20,
        foodtype = FOODTYPE.MEAT,
        health = 3,
        hunger = 62.5,
        sanity = 15,
        perishtime = TUNING.PERISH_MED, --10天
        cooktime = 0.5,
        potlevel = "low",
        float = {nil, "small", 0.2, 1},

        cook_need = "(烤)叶肉 鱼度",
        cook_cant = "怪物度≤1 非食 甜度",
        recipe_count = 6,

        prefabs = { "sand_puff" },
        oneat_desc = STRINGS.UI.COOKBOOK.DISH_FISHJOYRAMEN,
        oneatenfn = function(inst, eater)   --玩家食用后拾取周围一个物品
            if eater:HasTag("player") then
                if eater == nil or eater.components.inventory == nil then
                    return
                end
                local x, y, z = eater.Transform:GetWorldPosition()
                local ents = TheSim:FindEntities(x, y, z, TUNING.ORANGEAMULET_RANGE, { "_inventoryitem" }, { "INLIMBO", "NOCLICK", "catchable", "fire", "minesprung", "mineactive" })
                for i, v in ipairs(ents) do
                    if v.components.inventoryitem ~= nil and
                        v.components.inventoryitem.canbepickedup and
                        v.components.inventoryitem.cangoincontainer and
                        not v.components.inventoryitem:IsHeld() and
                        eater.components.inventory:CanAcceptCount(v, 1) > 0 then

                        --will only ever pick up items one at a time. Even from stacks.
                        SpawnPrefab("sand_puff").Transform:SetPosition(v.Transform:GetWorldPosition())

                        local v_pos = v:GetPosition()
                        if v.components.stackable ~= nil then
                            v = v.components.stackable:Get()
                        end

                        if v.components.trap ~= nil and v.components.trap:IsSprung() then
                            v.components.trap:Harvest(eater)
                        else
                            eater.components.inventory:GiveItem(v, nil, v_pos)
                        end
                        return
                    end
                end
            end
        end,
    },

    dish_roastedmarshmallows =
    {
        test = function(cooker, names, tags)
            return names.glommerfuel and tags.sweetener and names.twigs and not tags.meat and not tags.frozen and not tags.egg
        end,
        priority = 20,
        foodtype = FOODTYPE.VEGGIE,
        health = 60,
        hunger = 18.75,
        sanity = 5,
        perishtime = TUNING.PERISH_MED*3,   --30天
        cooktime = 0.5,
        tags = {"honeyed"},
        potlevel = "low",
        float = {nil, "small", 0.2, 0.7},

        cook_need = "格罗姆黏液 甜度 树枝",
        cook_cant = "肉度 冰度 蛋度",
        recipe_count = 6,
    },

    dish_pomegranatejelly =
    {
        test = function(cooker, names, tags)
            return (names.pomegranate or names.pomegranate_cooked) and
                (tags.gel or names.slurtleslime or names.glommerfuel or names.phlegm) and
                not tags.veggie and not tags.meat and not tags.egg
        end,
        priority = 25,
        foodtype = FOODTYPE.VEGGIE,
        health = 3,
        hunger = 37.5,
        sanity = 50,
        perishtime = TUNING.PERISH_SLOW,   --15天
        cooktime = 3,
        potlevel = "low",
        float = {nil, "small", 0.2, 1.05},

        cook_need = "(烤)石榴 黏液度",
        cook_cant = "菜度 肉度 蛋度",
        recipe_count = 6,
    },

    dish_medicinalliquor =
    {
        test = function(cooker, names, tags)
            return names.furtuft and tags.frozen and not tags.meat and not tags.sweetener
                and not tags.egg and (tags.inedible and tags.inedible <= 1)
        end,
        priority = 20,
        foodtype = FOODTYPE.GOODIES,
        health = 8,
        hunger = 9.375,
        sanity = 10,
        perishtime = nil,   --不会腐烂
        cooktime = 3,
        potlevel = "low",
        float = {nil, "small", 0.2, 0.85},

        cook_need = "熊毛簇 冰度",
        cook_cant = "肉度 甜度 蛋度 非食≤1",
        recipe_count = 6,

        prefabs = { "buff_strengthenhancer" },
        oneat_desc = STRINGS.UI.COOKBOOK.DISH_MEDICINALLIQUOR,
        oneatenfn = function(inst, eater)
            if eater:HasTag("player") then
                --说醉酒话
                if eater.components.talker ~= nil then
                    eater.components.talker:Say(GetString(eater, "DESCRIBE", { "DISH_MEDICINALLIQUOR", "DRUNK" }))
                end

                --加强攻击力
                if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                    not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                    not eater:HasTag("playerghost") then
                    if eater.components.combat ~= nil then --这个buff需要攻击组件
                        eater.components.debuffable:AddDebuff("buff_strengthenhancer", "buff_strengthenhancer")
                    end
                end

                --喝醉了，要么睡着要么醉步
                if
                    eater.prefab == "wendy" or
                    eater.prefab == "webber" or
                    eater.prefab == "willow" or
                    eater.prefab == "wes" or
                    eater.prefab == "wormwood" or
                    eater.prefab == "wurt"
                then    --直接睡着30秒
                    if eater.components.grogginess ~= nil then
                        eater.components.grogginess:AddGrogginess(15, 15)   --第一个参数为0会导致无法触发该功能
                    end
                else    --其他角色则是30秒内减移速
                    if eater.groggy_time ~= nil then
                        eater.groggy_time:Cancel()
                        eater.groggy_time = nil
                    end

                    eater:AddTag("groggy")  --添加标签，走路会摇摇晃晃
                    if eater.components.locomotor ~= nil then
                        eater.components.locomotor:SetExternalSpeedMultiplier(eater, "grogginess", 0.4)

                        eater.groggy_time = eater:DoTaskInTime(30, function()
                            if eater ~= nil and eater.components.locomotor ~= nil then
                                eater:RemoveTag("groggy")
                                eater.components.locomotor:RemoveExternalSpeedMultiplier(eater, "grogginess")
                                eater.groggy_time = nil
                            end
                        end)
                    end
                end
            elseif eater.components.grogginess ~= nil then  --其他生物能醉酒也会醉酒
                eater.components.grogginess:AddGrogginess(15, 15)
            elseif eater.components.sleeper ~= nil then --其他生物会睡觉的就会睡觉
                eater.components.sleeper:AddSleepiness(15, 15)
            end
        end,
    },

    dish_bananamousse =
    {
        test = function(cooker, names, tags)
            return (names.cave_banana or names.cave_banana_cooked) and (tags.fruit and tags.fruit > 1) and tags.egg
                and not tags.meat and not tags.inedible and not tags.monster
        end,
        priority = 20,
        foodtype = FOODTYPE.GOODIES,
        health = 8,
        hunger = 9.375,
        sanity = 5,
        perishtime = TUNING.PERISH_MED,   --10天
        cooktime = 0.75,
        stacksize = 2,
        potlevel = "low",
        float = {nil, "small", 0.2, 0.9},

        cook_need = "(烤)香蕉 果度>1 蛋度",
        cook_cant = "肉度 非食 怪物度",
        recipe_count = 6,

        prefabs = { "buff_bestappetite" },
        oneat_desc = STRINGS.UI.COOKBOOK.DISH_BANANAMOUSSE,
        oneatenfn = function(inst, eater)
            if eater:HasTag("player") then
                if eater.components.debuffable ~= nil and eater.components.debuffable:IsEnabled() and
                    not (eater.components.health ~= nil and eater.components.health:IsDead()) and
                    not eater:HasTag("playerghost") then
                    eater.components.debuffable:AddDebuff("buff_bestappetite", "buff_bestappetite")
                end
            end
        end,
    },
}

if CONFIGS_LEGION.BETTERCOOKBOOK then
    for k,v in pairs(foods_particular) do
        v.name = k
        v.weight = v.weight or 1
        v.priority = v.priority or 0

        v.recipe_count = v.recipe_count or 1
        v.custom_cookbook_details_fn = function(data, self, top, left) --不用给英语环境的使用这个，因为文本太长，不可能装得下
            local root = cookbookui_legion(data, self, top, left)
            return root
        end
    end
else
    for k,v in pairs(foods_particular) do
        v.name = k
        v.weight = v.weight or 1
        v.priority = v.priority or 0
    end
end

return foods_particular
