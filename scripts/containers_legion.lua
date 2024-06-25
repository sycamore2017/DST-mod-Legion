local _G = GLOBAL
local containers = require("containers")

--------------------------------------------------------------------------
--[[ 容器数据设定 ]]
--------------------------------------------------------------------------

local params = {}

local function TestContainer_base(container, item, slot)
    return not (item:HasTag("irreplaceable") or item:HasTag("nobundling") or item:HasTag("boxopener_l"))
        and (
            item:HasTag("unwrappable") or not (
                item:HasTag("_container") or item:HasTag("bundle")
            )
        )
end

------
--靠背熊
------

local slotbg_backcub = { image = "slot_bearspaw_l.tex", atlas = "images/slot_bearspaw_l.xml" }
local function MakeBackcub(name, animbuild)
    params[name] = {
        widget = {
            slotpos = {},
            slotbg = { [11] = slotbg_backcub, [12] = slotbg_backcub },
            animbank = "ui_piggyback_2x6",
            animbuild = animbuild,
            pos = Vector3(-5, -90, 0)
        },
        issidewidget = true,
        type = "pack",
        openlimit = 1
    }
    for y = 0, 5 do
        table.insert(params[name].widget.slotpos, Vector3(-162, -75 * y + 170, 0))
        table.insert(params[name].widget.slotpos, Vector3(-162 + 75, -75 * y + 170, 0))
    end
end
MakeBackcub("backcub", "ui_piggyback_2x6")
MakeBackcub("backcub_fans2", "ui_backcub_fans2_2x6")

------
--驮运鞍具
------

params.beefalo = {
    widget = {
        slotpos = {},
        animbank = "ui_chester_shadow_3x4",
        animbuild = "ui_chester_shadow_3x4",
        pos = Vector3(0, 220, 0),
        side_align_tip = 160
    },
    type = "chest",
    openlimit = 1
}
for y = 2.5, -0.5, -1 do
    for x = 0, 2 do
        table.insert(params.beefalo.widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
    end
end

params.beefalo.itemtestfn = TestContainer_base

------
--巨人之脚
------

params.giantsfoot = {
    widget = {
        slotpos = {},
        animbank = "ui_backpack_2x4",
        animbuild = "ui_backpack_2x4",
        pos = Vector3(-5, -80, 0)
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

------
--月藏宝匣
------

params.hiddenmoonlight = {
    widget = {
        slotpos = {},
        animbank = "ui_chest_3x3",
        animbuild = "ui_hiddenmoonlight_4x4",
        -- animbank_upgraded = "ui_chest_3x3",
        animbuild_upgraded = "ui_hiddenmoonlight_inf_4x4",
        pos = Vector3(0, 200, 0),
        side_align_tip = 160
    },
    type = "chest"
}
for y = 3, 0, -1 do
    for x = 0, 3 do
        table.insert(params.hiddenmoonlight.widget.slotpos, Vector3(80 * (x - 2) + 37, 80 * (y - 2) + 43, 0))
    end
end

local cooking = require("cooking")
function params.hiddenmoonlight.itemtestfn(container, item, slot)
    if item:HasTag("icebox_valid") then
        return true
    end

    if cooking.IsCookingIngredient(item.prefab) then --只要是烹饪食材，就能放入
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

------
--月轮宝盘
------

params.revolvedmoonlight = {
    widget = {
        slotpos = {},
        animbank = "ui_chest_3x3",
        animbuild = "ui_revolvedmoonlight_4x3",
        pos = Vector3(0, -150, 0),
        side_align_tip = 160,
    },
    type = "chest_l",
    lowpriorityselection = true
}
for y = 2, 1, -1 do
    for x = 0, 2 do
        table.insert(params.revolvedmoonlight.widget.slotpos, Vector3(80*x - 80*2 + 72, 80*y - 80*2 + 47, 0))
    end
end
params.revolvedmoonlight.itemtestfn = TestContainer_base

params.revolvedmoonlight_pro = {
    widget = {
        slotpos = {},
        animbank = "ui_chest_3x3",
        animbuild = "ui_revolvedmoonlight_4x3",
        pos = Vector3(0, -150, 0),
        side_align_tip = 160,
    },
    type = "chest_l",
    lowpriorityselection = true
}
for y = 0, 2 do --                                                    x轴基础               y轴基础
    table.insert(params.revolvedmoonlight_pro.widget.slotpos, Vector3(-122      , (-77*y) + 80 - (y*2), 0))
    table.insert(params.revolvedmoonlight_pro.widget.slotpos, Vector3(-122 + 75 , (-77*y) + 80 - (y*2), 0))
    table.insert(params.revolvedmoonlight_pro.widget.slotpos, Vector3(-122 + 150, (-77*y) + 80 - (y*2), 0))
    table.insert(params.revolvedmoonlight_pro.widget.slotpos, Vector3(-122 + 225, (-77*y) + 80 - (y*2), 0))
end
params.revolvedmoonlight_pro.itemtestfn = TestContainer_base

--月轮宝盘皮肤
local function MakeSkin_revolvedmoonlight(data)
    local name = "revolvedmoonlight_"..data.skin
    local animbuild = "ui_"..name.."_4x3"
    params[name] = {
        widget = {
            slotpos = {},
            animbank = "ui_chest_3x3",
            animbuild = animbuild,
            pos = Vector3(0, -150, 0),
            side_align_tip = 160
        },
        type = "chest_l",
        lowpriorityselection = true
    }
    for y = 2, 1, -1 do
        for x = 0, 2 do
            table.insert(params[name].widget.slotpos, Vector3(80*x - 80*2 + 72, 80*y - 80*2 + 47, 0))
        end
    end
    params[name].itemtestfn = TestContainer_base

    name = "revolvedmoonlight_pro_"..data.skin
    params[name] = {
        widget = {
            slotpos = {},
            animbank = "ui_chest_3x3",
            animbuild = animbuild,
            pos = Vector3(0, -150, 0),
            side_align_tip = 160
        },
        type = "chest_l",
        lowpriorityselection = true
    }
    for y = 0, 2 do --                                    x轴基础               y轴基础
        table.insert(params[name].widget.slotpos, Vector3(-122      , (-77*y) + 80 - (y*2), 0))
        table.insert(params[name].widget.slotpos, Vector3(-122 + 75 , (-77*y) + 80 - (y*2), 0))
        table.insert(params[name].widget.slotpos, Vector3(-122 + 150, (-77*y) + 80 - (y*2), 0))
        table.insert(params[name].widget.slotpos, Vector3(-122 + 225, (-77*y) + 80 - (y*2), 0))
    end
    params[name].itemtestfn = TestContainer_base
end
MakeSkin_revolvedmoonlight({ skin = "taste" })
MakeSkin_revolvedmoonlight({ skin = "taste2" })
MakeSkin_revolvedmoonlight({ skin = "taste3" })
MakeSkin_revolvedmoonlight({ skin = "taste4" })

------
--脱壳之翅
------

params.boltwingout = {
    widget = {
        slotpos = {},
        animbank = "ui_piggyback_2x6",
        animbuild = "ui_piggyback_2x6",
        pos = Vector3(-5, -90, 0)
    },
    issidewidget = true,
    type = "pack",
    openlimit = 1,
    priorityfn = function(container, item, slot)
        return BOLTCOST_LEGION[item.prefab] ~= nil or item:HasTag("yes_boltout")
    end
}
for y = 0, 5 do
    table.insert(params.boltwingout.widget.slotpos, Vector3(-162, -75 * y + 170, 0))
    table.insert(params.boltwingout.widget.slotpos, Vector3(-162 + 75, -75 * y + 170, 0))
end

------
--打窝饵制作器
------

params.fishhomingtool = {
    widget = {
        slotpos = {
            Vector3(-37.5, 32 + 4, 0),
            Vector3(37.5, 32 + 4, 0),
            Vector3(-37.5, -(32 + 4), 0),
            Vector3(37.5, -(32 + 4), 0),
        },
        animbank = "ui_bundle_2x2",
        animbuild = "ui_bundle_2x2",
        pos = Vector3(200, 0, 0),
        side_align_tip = 120,
        buttoninfo = {
            text = STRINGS.ACTIONS_LEGION.MAKE,
            position = Vector3(0, -100, 0)
        }
    },
    type = "cooker"
}
function params.fishhomingtool.itemtestfn(container, item, slot)
    if item.prefab == "fruitflyfruit" then
        return not item:HasTag("fruitflyfruit") --没有 fruitflyfruit 就代表是枯萎了
    elseif item.prefab == "glommerflower" then
		return not item:HasTag("glommerflower") --没有 glommerflower 就代表是枯萎了
    end
    if
        FISHHOMING_INGREDIENTS_L[item.prefab] ~= nil or
        not (item:HasTag("irreplaceable") or item:HasTag("nobundling") or item:HasTag("nodigest_l"))
        -- item:HasTag("edible_MEAT") or item:HasTag("edible_VEGGIE") or item:HasTag("edible_MONSTER") or
        -- item:HasTag("edible_SEEDS") or item:HasTag("winter_ornament")
    then
        return true
    end
    return false
end
function params.fishhomingtool.widget.buttoninfo.fn(inst, doer)
    if inst.components.container ~= nil then
        BufferedAction(doer, inst, ACTIONS.WRAPBUNDLE):Do()
    elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
        SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.WRAPBUNDLE.code, inst, ACTIONS.WRAPBUNDLE.mod_name)
    end
end
function params.fishhomingtool.widget.buttoninfo.validfn(inst)
    return inst.replica.container ~= nil and not inst.replica.container:IsEmpty()
end

------
--胡萝卜长枪
------

local function IsCarrot(container, item, slot)
    return item.prefab == "carrot" or item.prefab == "carrot_cooked" or item.prefab == "carrat"
end

params.lance_carrot_l = {
    widget = {
        slotpos = {
            Vector3(0,   32 + 4,  0),
            Vector3(0, -(32 + 4), 0)
        },
        animbank = "ui_cookpot_1x2",
        animbuild = "ui_cookpot_1x2",
        pos = Vector3(0, 60, 0)
    },
    type = "hand_inv",
    excludefromcrafting = true,
    priorityfn = IsCarrot
}
function params.lance_carrot_l.itemtestfn(container, item, slot)
    return IsCarrot(container, item, slot) or item.prefab == "spoiled_food"
end

------
--巨食草
------

local slotbg_nepenthes = { image = "slot_juice_l.tex", atlas = "images/slot_juice_l.xml" }
params.plant_nepenthes_l = {
    widget = {
        slotpos = {},
        slotbg = {},
        animbank = "ui_chest_3x3",
        animbuild = "ui_nepenthes_l_4x4",
        pos = Vector3(0, 200, 0),
        side_align_tip = 160,
    },
    type = "chest"
}
for y = 3, 0, -1 do
    for x = 0, 3 do
        table.insert(params.plant_nepenthes_l.widget.slotpos, Vector3(80 * (x - 2) + 40, 80 * (y - 2) + 40, 0))
        table.insert(params.plant_nepenthes_l.widget.slotbg, slotbg_nepenthes)
    end
end
function params.plant_nepenthes_l.itemtestfn(container, item, slot)
    if item.prefab == "fruitflyfruit" then
        return not item:HasTag("fruitflyfruit") --没有 fruitflyfruit 就代表是枯萎了
    elseif item.prefab == "glommerflower" then
		return not item:HasTag("glommerflower") --没有 glommerflower 就代表是枯萎了
    end
    return not (item:HasTag("irreplaceable") or item:HasTag("nobundling") or item:HasTag("nodigest_l"))
end

------
--白木展示台
------

params.chest_whitewood = {
    widget = {
        slotpos = {},
        animbank = "ui_chester_shadow_3x4",
        animbuild = "ui_chest_whitewood_3x4",
        -- animbank_upgraded = "ui_chester_shadow_3x4",
        animbuild_upgraded = "ui_chest_whitewood_inf_3x4",
        pos = Vector3(0, 220, 0),
        side_align_tip = 160
    },
    type = "chest"
}
for y = 2.5, -0.5, -1 do
    for x = 0, 2 do
        table.insert(params.chest_whitewood.widget.slotpos, Vector3(75*x - 75*2 + 75, 75*y - 75*2 + 67, 0))
    end
end

------
--白木展示柜
------

params.chest_whitewood_big = {
    widget = {
        slotpos = {},
        animbank = "ui_bookstation_4x5",
        animbuild = "ui_chest_whitewood_4x6",
        -- animbank_upgraded = "ui_bookstation_4x5",
        animbuild_upgraded = "ui_chest_whitewood_inf_4x6",
        pos = Vector3(0, 280, 0),
        side_align_tip = 160
    },
    type = "chest"
}
for y = 0, 5 do
    table.insert(params.chest_whitewood_big.widget.slotpos, Vector3(-114      , (-77 * y) + 114 - (y * 2), 0))
    table.insert(params.chest_whitewood_big.widget.slotpos, Vector3(-114 + 75 , (-77 * y) + 114 - (y * 2), 0))
    table.insert(params.chest_whitewood_big.widget.slotpos, Vector3(-114 + 150, (-77 * y) + 114 - (y * 2), 0))
    table.insert(params.chest_whitewood_big.widget.slotpos, Vector3(-114 + 225, (-77 * y) + 114 - (y * 2), 0))
end

------
--子圭·釜
------

params.siving_suit_gold = {
    widget = {
        slotpos = {},
        animbank = "ui_piggyback_2x6",
        animbuild = "ui_piggyback_2x6",
        pos = Vector3(-5, -90, 0)
    },
    issidewidget = true,
    type = "pack",
    openlimit = 1
}
for y = 0, 5 do
    table.insert(params.siving_suit_gold.widget.slotpos, Vector3(-162, -75 * y + 170, 0))
    table.insert(params.siving_suit_gold.widget.slotpos, Vector3(-162 + 75, -75 * y + 170, 0))
end

------
--云青松容器
------

------高级
params.cloudpine_box_l3 = {
    widget = {
        slotpos = {},
        animbank = "ui_bookstation_4x5",
        animbuild = "ui_cloudpine_box_4x6",
        pos = Vector3(0, 280, 0),
        side_align_tip = 160
    },
    type = "chest",
    itemtestfn = TestContainer_base
}
for y = 0, 5 do
    table.insert(params.cloudpine_box_l3.widget.slotpos, Vector3(-114      , (-77 * y) + 127 - (y * 2), 0))
    table.insert(params.cloudpine_box_l3.widget.slotpos, Vector3(-114 + 75 , (-77 * y) + 127 - (y * 2), 0))
    table.insert(params.cloudpine_box_l3.widget.slotpos, Vector3(-114 + 150, (-77 * y) + 127 - (y * 2), 0))
    table.insert(params.cloudpine_box_l3.widget.slotpos, Vector3(-114 + 225, (-77 * y) + 127 - (y * 2), 0))
end

------豪华高级
params.cloudpine_box_l4 = params.cloudpine_box_l3

------中级
params.cloudpine_box_l2 = {
    widget = {
        slotpos = {},
        animbank = "ui_bookstation_4x5",
        animbuild = "ui_cloudpine_box_4x3",
        pos = Vector3(0, 200, 0),
        side_align_tip = 160
    },
    type = "chest",
    itemtestfn = TestContainer_base
}
for y = 0, 2 do
    table.insert(params.cloudpine_box_l2.widget.slotpos, Vector3(-114      , (-77 * y) + 80 - (y * 2), 0))
    table.insert(params.cloudpine_box_l2.widget.slotpos, Vector3(-114 + 75 , (-77 * y) + 80 - (y * 2), 0))
    table.insert(params.cloudpine_box_l2.widget.slotpos, Vector3(-114 + 150, (-77 * y) + 80 - (y * 2), 0))
    table.insert(params.cloudpine_box_l2.widget.slotpos, Vector3(-114 + 225, (-77 * y) + 80 - (y * 2), 0))
end

------低级
params.cloudpine_box_l1 = {
    widget = {
        slotpos = {},
        animbank = "ui_bookstation_4x5",
        animbuild = "ui_cloudpine_box_4x1",
        pos = Vector3(0, 160, 0),
        side_align_tip = 160
    },
    type = "chest",
    itemtestfn = TestContainer_base
}
table.insert(params.cloudpine_box_l1.widget.slotpos, Vector3(-114      , 0, 0))
table.insert(params.cloudpine_box_l1.widget.slotpos, Vector3(-114 + 75 , 0, 0))
table.insert(params.cloudpine_box_l1.widget.slotpos, Vector3(-114 + 150, 0, 0))
table.insert(params.cloudpine_box_l1.widget.slotpos, Vector3(-114 + 225, 0, 0))

------
--夜盏花
------

params.plant_lightbulb_l = {
    widget = {
        slotpos = {
            Vector3(0, 64 + 32 + 8 + 4, 0),
            Vector3(0, 32 + 4, 0),
            Vector3(0, -(32 + 4), 0),
            Vector3(0, -(64 + 32 + 8 + 4), 0)
        },
        animbank = "ui_lamp_1x4",
        animbuild = "ui_lamp_1x4",
        pos = Vector3(200, 0, 0),
        side_align_tip = 100
    },
    acceptsstacks = false,
    type = "cooker",
    itemtestfn = function(container, item, slot)
        return item:HasTag("lightbattery") or item:HasTag("spore") or item:HasTag("lightcontainer")
    end
}

--------------------------------------------------------------------------
--[[ 修改容器注册函数 ]]
--------------------------------------------------------------------------

for k, v in pairs(params) do
    containers.params[k] = v

    --更新容器格子数量的最大值
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end
params = nil

--------------------------------------------------------------------------
--mod兼容：Show Me (中文)
--------------------------------------------------------------------------

------以下代码参考自风铃草大佬的穹妹------

local showmeneed = { --这里的名字是指容器所属预制物的名字，不是指容器本身的名字
    "backcub", "beefalo", "giantsfoot",
    "hiddenmoonlight", "hiddenmoonlight_inf", "revolvedmoonlight", "revolvedmoonlight_pro",
    "boltwingout", "plant_nepenthes_l", "plant_lightbulb_l",
    "chest_whitewood", "chest_whitewood_big", "chest_whitewood_inf", "chest_whitewood_big_inf",
    "siving_suit_gold"
}

--showme优先级如果比本mod高，那么这部分代码会生效
for k, mod in pairs(ModManager.mods) do
    if mod and _G.rawget(mod, "SHOWME_STRINGS") then --showme特有的全局变量
        if
            mod.postinitfns and mod.postinitfns.PrefabPostInit and
            mod.postinitfns.PrefabPostInit.treasurechest
        then
            for _, v in ipairs(showmeneed) do
				mod.postinitfns.PrefabPostInit[v] = mod.postinitfns.PrefabPostInit.treasurechest
			end
        end
        break
    end
end

--showme优先级如果比本mod低，那么这部分代码会生效
TUNING.MONITOR_CHESTS = TUNING.MONITOR_CHESTS or {}
for _, v in ipairs(showmeneed) do
	TUNING.MONITOR_CHESTS[v] = true
end

showmeneed = nil
