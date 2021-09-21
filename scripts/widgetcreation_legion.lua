local _G = GLOBAL
local containers = require("containers")

--------------------------------------------------------------------------
--[[ 容器数据设定 ]]
--------------------------------------------------------------------------

local params = {}

if TUNING.LEGION_FLASHANDCRUSH then
    params.beefalo =
    {
        widget =
        {
            slotpos = {},
            animbank = "ui_chester_shadow_3x4",
            animbuild = "ui_chester_shadow_3x4",
            pos = Vector3(0, 220, 0),
            side_align_tip = 160,
        },
        type = "chest",
        openlimit = 1,
    }
    for y = 2.5, -0.5, -1 do
        for x = 0, 2 do
            table.insert(params.beefalo.widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
        end
    end

    params.beefalo.itemtestfn = containers.params.bundle_container.itemtestfn
end

if CONFIGS_LEGION.PRAYFORRAIN then
    params.giantsfoot =
    {
        widget =
        {
            slotpos = {},
            animbank = "ui_backpack_2x4",
            animbuild = "ui_backpack_2x4",
            pos = Vector3(-5, -70, 0),
        },
        issidewidget = true,
        type = "pack",
        openlimit = 1,
        priorityfn = function(container, item, slot)
            return item.prefab == "cane" or item.prefab == "ruins_bat" or item:HasTag("weapon")
        end
    }
    for y = 0, 3 do
        table.insert(params.giantsfoot.widget.slotpos, Vector3(-162, -75 * y + 114, 0))
        table.insert(params.giantsfoot.widget.slotpos, Vector3(-162 + 75, -75 * y + 114, 0))
    end

    params.hiddenmoonlight =
    {
        widget =
        {
            slotpos = {},
            animbank = "ui_chest_3x3",
            animbuild = "ui_hiddenmoonlight_4x4",
            pos = Vector3(0, 200, 0),
            side_align_tip = 160,
        },
        type = "chest",
    }

    for y = 3, 0, -1 do
        for x = 0, 3 do
            table.insert(params.hiddenmoonlight.widget.slotpos, Vector3(80 * (x - 2) + 40, 80 * (y - 2) + 40, 0))
        end
    end

    function params.hiddenmoonlight.itemtestfn(container, item, slot)
        if item:HasTag("icebox_valid") then
            return true
        end

        local validitems = --特殊食材也能放入，比如树枝、灰烬等
        {
            ash = true,
            slurtleslime = true,
            glommerfuel = true,
            phlegm = true,
            furtuft = true,
            twiggy_nut = true,
            twigs = true,
            honeycomb = true,
            lightninggoathorn = true,
            nightmarefuel = true,
            boneshard = true,
            pigskin = true,
        }
        if validitems[item.prefab] then
            return true
        end

        if item:HasTag("smallcreature") then
            return true
        end

        if not (item:HasTag("fresh") or item:HasTag("stale") or item:HasTag("spoiled")) then
            return false
        end

        for k, v in pairs(FOODTYPE) do
            if item:HasTag("edible_"..v) then
                return true
            end
        end

        return false
    end
end

if CONFIGS_LEGION.LEGENDOFFALL then
    params.boltwingout =
    {
        widget =
        {
            slotpos = {},
            animbank = "ui_backpack_2x4",
            animbuild = "ui_backpack_2x4",
            pos = Vector3(-5, -70, 0),
        },
        issidewidget = true,
        type = "pack",
        openlimit = 1,
        priorityfn = function(container, item, slot)
            local costs =
            {
                stinger = 3,            --蜂刺
                honey = 5,              --蜂蜜
                royal_jelly = 0.1,      --蜂王浆
                honeycomb = 0.25,       --蜂巢
                beeswax = 0.2,          --蜂蜡
                bee = 0.5,              --蜜蜂
                killerbee = 0.45,       --杀人蜂

                mosquitosack = 1,       --蚊子血袋
                mosquito = 0.45,        --蚊子

                ahandfulofwings = 0.25, --一捧翅膀

                glommerwings = 0.25,    --格罗姆翅膀
                glommerfuel = 0.5,      --格罗姆黏液

                butterflywings = 3,     --蝴蝶翅膀
                butter = 0.1,           --黄油
                butterfly = 0.6,        --蝴蝶

                raindonate = 0.45,      --雨蝇

                wormlight = 0.25,       --神秘浆果
                wormlight_lesser = 1,   --神秘小浆果

                moonbutterflywings = 1, --月蛾翅膀
                moonbutterfly = 0.3,    --月蛾
            }
            return costs[item.prefab] ~= nil or item:HasTag("yes_boltout")
        end
    }
    for y = 0, 3 do
        table.insert(params.boltwingout.widget.slotpos, Vector3(-162, -75 * y + 114, 0))
        table.insert(params.boltwingout.widget.slotpos, Vector3(-162 + 75, -75 * y + 114, 0))
    end
end

--------------------------------------------------------------------------
--[[ 修改容器注册函数 ]]
--------------------------------------------------------------------------

for k, v in pairs(params) do
    containers.params[k] = v

    --更新容器格子数量的最大值
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end
params = nil

--加入mod的容器
-- local widgetsetup_old = containers.widgetsetup
-- function containers.widgetsetup(container, prefab, data)
--     local t = params[prefab or container.inst.prefab]
--     if t ~= nil then   --是mod里用到的格子就注册，否则就返回官方的格子注册函数
--         for k, v in pairs(t) do
--             container[k] = v
--         end
--         container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
--     else
--         return widgetsetup_old(container, prefab, data)
--     end
-- end
