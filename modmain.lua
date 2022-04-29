--------------------------------------------------------------------------
--[[ Update Logs ]]--[[ 更新说明 ]]
--------------------------------------------------------------------------

--[[

]]

--------------------------------------------------------------------------
--[[ Globals ]]--[[ 全局 ]]
--------------------------------------------------------------------------

--下行代码只代表查值时自动查global，增加global的变量或者修改global的变量时还是需要带"GLOBAL."
GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })
local _G = GLOBAL

--------------------------------------------------------------------------
--[[ Main ]]--[[ 主要 ]]
--------------------------------------------------------------------------

PrefabFiles = {
    "hat_lichen",               --苔衣发卡
    "backcub",                  --靠背熊
    "ingredients_legion",       --食材
    "plantables_legion",        --新种植根
    "turfs_legion",             --新地皮
    "wants_sandwitch",          --沙之女巫所欲之物
    -- "guitar_greenery",
    -- "aatest_anim",
    "fx_legion",                --特效
    "buffs_legion",             --buff
}

Assets = {
    Asset("ANIM", "anim/images_minisign1.zip"),  --专门为小木牌上的图画准备的文件(真是奢侈0.0)
    Asset("ANIM", "anim/images_minisign2.zip"),
    Asset("ANIM", "anim/images_minisign3.zip"),
    Asset("ANIM", "anim/images_minisign4.zip"),
    Asset("ANIM", "anim/images_minisign5.zip"),
    Asset("ANIM", "anim/images_minisign6.zip"),

    Asset("ANIM", "anim/playguitar.zip"),   --弹吉他动画模板
    Asset("SOUNDPACKAGE", "sound/legion.fev"),   --吉他的声音
    Asset("SOUND", "sound/legion.fsb"),

    --预加载，给科技栏用的
    Asset("ATLAS", "images/inventoryimages/hat_lichen.xml"),
    Asset("IMAGE", "images/inventoryimages/hat_lichen.tex"),

    --为了在菜谱和农谱里显示材料的图片，所以不管玩家设置，还是要注册一遍
    Asset("ATLAS", "images/inventoryimages/monstrain_leaf.xml"),
    Asset("IMAGE", "images/inventoryimages/monstrain_leaf.tex"),
    Asset("ATLAS", "images/inventoryimages/shyerry.xml"),
    Asset("IMAGE", "images/inventoryimages/shyerry.tex"),
    Asset("ATLAS", "images/inventoryimages/shyerry_cooked.xml"),
    Asset("IMAGE", "images/inventoryimages/shyerry_cooked.tex"),
    Asset("ATLAS", "images/inventoryimages/petals_rose.xml"),
    Asset("IMAGE", "images/inventoryimages/petals_rose.tex"),
    Asset("ATLAS", "images/inventoryimages/petals_lily.xml"),
    Asset("IMAGE", "images/inventoryimages/petals_lily.tex"),
    Asset("ATLAS", "images/inventoryimages/petals_orchid.xml"),
    Asset("IMAGE", "images/inventoryimages/petals_orchid.tex"),
    Asset("ATLAS", "images/inventoryimages/pineananas.xml"),
    Asset("IMAGE", "images/inventoryimages/pineananas.tex"),
    Asset("ATLAS", "images/inventoryimages/pineananas_cooked.xml"),
    Asset("IMAGE", "images/inventoryimages/pineananas_cooked.tex"),
    Asset("ATLAS", "images/inventoryimages/pineananas_seeds.xml"),
    Asset("IMAGE", "images/inventoryimages/pineananas_seeds.tex"),
    -- Asset("ATLAS", "images/inventoryimages/catmint.xml"), --delete_crop
    -- Asset("IMAGE", "images/inventoryimages/catmint.tex"),
    Asset("ATLAS", "images/inventoryimages/albicans_cap.xml"),
    Asset("IMAGE", "images/inventoryimages/albicans_cap.tex"),
}

--为了在菜谱和农谱里显示材料的图片，所以不管玩家设置，还是要注册一遍
RegisterInventoryItemAtlas("images/inventoryimages/monstrain_leaf.xml", "monstrain_leaf.tex")
RegisterInventoryItemAtlas("images/inventoryimages/shyerry.xml", "shyerry.tex")
RegisterInventoryItemAtlas("images/inventoryimages/shyerry_cooked.xml", "shyerry_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/petals_rose.xml", "petals_rose.tex")
RegisterInventoryItemAtlas("images/inventoryimages/petals_lily.xml", "petals_lily.tex")
RegisterInventoryItemAtlas("images/inventoryimages/petals_orchid.xml", "petals_orchid.tex")
RegisterInventoryItemAtlas("images/inventoryimages/pineananas.xml", "pineananas.tex")
RegisterInventoryItemAtlas("images/inventoryimages/pineananas_cooked.xml", "pineananas_cooked.tex")
RegisterInventoryItemAtlas("images/inventoryimages/pineananas_seeds.xml", "pineananas_seeds.tex")
-- RegisterInventoryItemAtlas("images/inventoryimages/catmint.xml", "catmint.tex") --delete_crop
RegisterInventoryItemAtlas("images/inventoryimages/albicans_cap.xml", "albicans_cap.tex")

-- local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()

--------------------------------------------------------------------------
--[[ Test ]]--[[ test ]]
--------------------------------------------------------------------------

-- local function ResumeHands(inst)
--     --需要恢复贴图显示状态
--     local hands = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
--     if hands ~= nil and not hands:HasTag("book") then
--         inst.AnimState:Show("ARM_carry")
--         inst.AnimState:Hide("ARM_normal")
--     else
--         inst.AnimState:Hide("ARM_carry")
--         inst.AnimState:Show("ARM_normal")
--         inst.AnimState:ClearOverrideSymbol("swap_object")
--     end
-- end

-- local gosg = State {
--     name = "gosg",
--     tags = { "gosg" },

--     onenter = function(inst)
--         --需注意，拿在手上的药杵和做捣药动作时用的贴图不一样
--         inst.AnimState:OverrideSymbol("swap_object","medicine_pestle_myth","objectpestle")
--         inst.AnimState:OverrideSymbol("mortar_myth","medicine_pestle_myth","mortar")

--         --这两个贴图都要显示，因为都用到了
--         inst.AnimState:Show("ARM_carry")
--         inst.AnimState:Show("ARM_normal")

--         inst.AnimState:PlayAnimation("pound_medicine_myth_pre")
--         inst.AnimState:PushAnimation("pound_medicine_myth_loop", true)

--         inst.sg:SetTimeout(120 * FRAMES)
--     end,

--     ontimeout = function(inst)
--         inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength() - inst.AnimState:GetCurrentAnimationTime()%inst.AnimState:GetCurrentAnimationLength(), function()
--             ResumeHands(inst)
--             --需注意，拿在手上的药杵和做捣药动作时用的贴图不一样
--             inst.AnimState:OverrideSymbol("swap_object","swap_medicine_pestle_myth","swap_medicine_pestle_myth")
--             inst.AnimState:PlayAnimation("pound_medicine_myth_pst", false)
--             inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength(), function()
--                 inst.sg:GoToState("idle")
--             end)
--         end)
--     end,

--     events =
--     {
--         EventHandler("equip", function(inst)    --防止装备时改变手的显示状态
--             inst.AnimState:OverrideSymbol("swap_object","pound_medicine_myth","swap_object")
--             inst.AnimState:Show("ARM_carry")
--             inst.AnimState:Show("ARM_normal")
--         end),

--         EventHandler("unequip", function(inst)  --防止卸下时改变手的显示状态
--             inst.AnimState:OverrideSymbol("swap_object","pound_medicine_myth","swap_object")
--             inst.AnimState:Show("ARM_carry")
--             inst.AnimState:Show("ARM_normal")
--         end),
--     },

--     onexit = function(inst)
--         ResumeHands(inst)
--     end,
-- }
-- AddStategraphState("wilson", gosg)

-- TheInput:AddKeyUpHandler(KEY_V, function()
--     ThePlayer.sg:GoToState("gosg")
-- end)

--------------------------------------------------------------------------
--[[ Options ]]--[[ 各项设置 ]]
--------------------------------------------------------------------------

_G.CONFIGS_LEGION = {
    ENABLEDMODS = {},
}

if GetModConfigData("FlowersPower") then --花香四溢 bool
    _G.CONFIGS_LEGION.FLOWERSPOWER = true
    _G.CONFIGS_LEGION.FLOWERWEAPONSCHANCE = GetModConfigData("FlowerWeaponsChance")
    _G.CONFIGS_LEGION.FOLIAGEATHCHANCE = GetModConfigData("FoliageathChance")
else
    _G.CONFIGS_LEGION.FLOWERSPOWER = false
end

_G.CONFIGS_LEGION.BETTERCOOKBOOK = false
if GetModConfigData("SuperbCuisine") then --美味佳肴 bool
    TUNING.LEGION_SUPERBCUISINE = true

    if GetModConfigData("FestivalRecipes") then --开放节日食谱 bool
        TUNING.LEGION_FESTIVALRECIPES = true
    end
end

if GetModConfigData("PrayForRain") then --祈雨祭 bool
    _G.CONFIGS_LEGION.PRAYFORRAIN = true

    TUNING.LEGION_BOOKRECIPETABS = GetModConfigData("BookRecipetabs") --设置多变的云的制作栏 "bookbuilder" "magic"
end

if GetModConfigData("LegendOfFall") then --丰饶传说 bool
    _G.CONFIGS_LEGION.LEGENDOFFALL = true

    -- TUNING.LEGION_GROWTHRATE = GetModConfigData("GrowthRate") --设置生长速度 int 0.7 1 1.5 2
    -- TUNING.LEGION_CROPYIELDS = GetModConfigData("CropYields") --设置果实数量 int 0 1 2 3
    -- TUNING.LEGION_OVERRIPETIME = GetModConfigData("OverripeTime") --设置过熟的时间倍数 int 1 2 0
    -- TUNING.LEGION_PESTRISK = GetModConfigData("PestRisk") --设置虫害几率 double 0.007 0.012
end

if GetModConfigData("FlashAndCrush") then --电闪雷鸣 bool
    TUNING.LEGION_FLASHANDCRUSH = true

    TUNING.LEGION_TECHUNLOCK = GetModConfigData("TechUnlock") --设置新道具的科技解锁方式 "lootdropper" "prototyper"
end

if GetModConfigData("DesertSecret") then --尘市蜃楼 bool
    TUNING.LEGION_DESERTSECRET = true

    if GetModConfigData("DressUp") then --启用幻化机制 bool
        _G.CONFIGS_LEGION.DRESSUP = true
    else
        _G.CONFIGS_LEGION.DRESSUP = false
    end
end

if GetModConfigData("CleaningUpStench") then --自动清除地上的臭臭 bool
    TUNING.LEGION_CLEANINGUPSTENCH = true
end

----------
--语言设置
----------

local language_legion = GetModConfigData("Language")    --获取设置里"语言"的选项值

if language_legion == "english" then
    modimport("scripts/languages/strings_english.lua")
elseif language_legion == "chinese" then
    modimport("scripts/languages/strings_chinese.lua")

    _G.CONFIGS_LEGION.BETTERCOOKBOOK = GetModConfigData("BetterCookBook")
else
    modimport("scripts/languages/strings_english.lua")
end

--------------------------------------------------------------------------
--[[ hot reload ]]--[[ 热更新机制 ]]
--------------------------------------------------------------------------

-- modimport("scripts/hotreload_legion.lua")

--------------------------------------------------------------------------
--[[ compatibility enhancement ]]--[[ 兼容性修改 ]]
--------------------------------------------------------------------------

modimport("scripts/apublicsupporter.lua")

if
    TUNING.LEGION_FLASHANDCRUSH or  --驮物牛鞍
    CONFIGS_LEGION.PRAYFORRAIN or    --巨人之脚、月藏宝匣
    CONFIGS_LEGION.LEGENDOFFALL          --脱壳之翅、打窝器
then
    modimport("scripts/widgetcreation_legion.lua")
end

--------------------------------------------------------------------------
--[[ the power of flowers ]]--[[ 花香四溢 ]]
--------------------------------------------------------------------------

if CONFIGS_LEGION.FLOWERSPOWER then
    modimport("scripts/flowerspower_legion.lua")
end

--------------------------------------------------------------------------
--[[ superb cuisine ]]--[[ 美味佳肴 ]]
--------------------------------------------------------------------------

if TUNING.LEGION_SUPERBCUISINE then
    table.insert(PrefabFiles, "foods_cookpot")

    ------为工艺锅mod加的（此时并不明确是否启用了该mod）
    local assets_craftpot = {
        Asset("ATLAS", "images/foodtags/foodtag_gel.xml"),
        Asset("IMAGE", "images/foodtags/foodtag_gel.tex"),
        Asset("ATLAS", "images/foodtags/foodtag_petals.xml"),
        Asset("IMAGE", "images/foodtags/foodtag_petals.tex"),
        Asset("ATLAS", "images/foodtags/foodtag_fallfullmoon.xml"),
        Asset("IMAGE", "images/foodtags/foodtag_fallfullmoon.tex"),
        Asset("ATLAS", "images/foodtags/foodtag_winterfeast.xml"),
        Asset("IMAGE", "images/foodtags/foodtag_winterfeast.tex"),
        Asset("ATLAS", "images/foodtags/foodtag_hallowednights.xml"),
        Asset("IMAGE", "images/foodtags/foodtag_hallowednights.tex"),
        Asset("ATLAS", "images/foodtags/foodtag_newmoon.xml"),
        Asset("IMAGE", "images/foodtags/foodtag_newmoon.tex"),
    }
    for k,v in pairs(assets_craftpot) do
        table.insert(Assets, v)
    end

    -- AddIngredientValues({"plantmeat"}, {meat=.5, veggie=.5}, true, false)   --食人花肉块茎
    -- AddIngredientValues({"batwing"}, {meat=.5}, true, false)    --蝙蝠翅膀，虽然可以晾晒，但是得到的不是蝙蝠翅膀干，而是小肉干，所以candry不能填true
    AddIngredientValues({"ash"}, {inedible=1}, false, false)    --灰烬
    AddIngredientValues({"slurtleslime"}, {gel=1}, false, false)    --蜗牛黏液
    AddIngredientValues({"glommerfuel"}, {gel=1}, false, false)    --格罗姆黏液
    AddIngredientValues({"phlegm"}, {gel=1}, false, false)    --钢羊黏痰
    -- AddIngredientValues({"wormlight_lesser"}, {veggie=.5}, false, false)    --发光小浆果
    -- AddIngredientValues({"wormlight"}, {veggie=1}, false, false)    --发光浆果
    AddIngredientValues({"furtuft"}, {inedible=1}, false, false)    --熊毛屑(非熊皮)
    AddIngredientValues({"twiggy_nut"}, {inedible=1}, false, false) --添加树枝树种作为新的料理原材料
    AddIngredientValues({"moon_tree_blossom"}, {veggie=.5, petals_legion=1}, false, false)   --月树花
    AddIngredientValues({"foliage"}, {decoration=1}, false, false)   --蕨叶

    for k, recipe in pairs(require("preparedfoods_legion")) do
        table.insert(Assets, Asset("ATLAS", "images/cookbookimages/"..recipe.name..".xml"))
        table.insert(Assets, Asset("IMAGE", "images/cookbookimages/"..recipe.name..".tex"))

        AddCookerRecipe("cookpot", recipe)
        AddCookerRecipe("portablecookpot", recipe)
        RegisterInventoryItemAtlas("images/cookbookimages/"..recipe.name..".xml", recipe.name..".tex")
    end

    local foodrecipes_spice = require("preparedfoods_l_spiced")
    for k, recipe in pairs(foodrecipes_spice) do
        AddCookerRecipe("portablespicer", recipe)
    end

    --官方的便携香料站代码没改新机制，这里用另类方式手动改一下。等官方更新了我就删除了。相关文件 prefabs\portablespicer.lua
    local IsModCookingProduct_old = IsModCookingProduct
    _G.IsModCookingProduct = function(cooker, name)
        if foodrecipes_spice[name] ~= nil then
            return false
        end
        if IsModCookingProduct_old ~= nil then
            return IsModCookingProduct_old(cooker, name)
        end
        return false
    end

    if CONFIGS_LEGION.BETTERCOOKBOOK then
        local cookbookui_legion = require("widgets/cookbookui_legion")
        local fooduidata_legion = require("languages/recipedesc_legion_chinese")

        local function SetNewCookBookUI(recipe, uidata)
            if uidata ~= nil then
                recipe.cook_need = uidata.cook_need
                recipe.cook_cant = uidata.cook_cant
                recipe.recipe_count = uidata.recipe_count or 1
                recipe.custom_cookbook_details_fn = function(data, self, top, left)
                    local root = cookbookui_legion(data, self, top, left)
                    return root
                end
            end
        end

        for k,v in pairs(require("preparedfoods")) do
            SetNewCookBookUI(v, fooduidata_legion.klei[k])
        end
        for k,v in pairs(require("preparedfoods_warly")) do
            SetNewCookBookUI(v, fooduidata_legion.warly[k])
        end
        for k,v in pairs(require("preparednonfoods")) do
            SetNewCookBookUI(v, fooduidata_legion.nofood[k])
        end
    end
end

--------------------------------------------------------------------------
--[[ desert secret ]]--[[ 尘市蜃楼 ]]
--------------------------------------------------------------------------

if TUNING.LEGION_DESERTSECRET then
    if CONFIGS_LEGION.DRESSUP then
        modimport("scripts/fengl_userdatahook.lua")
        modimport("scripts/dressup_legion.lua")
    end
    modimport("scripts/desertsecret_legion.lua")
end

--------------------------------------------------------------------------
--[[ the sacrifice of rain ]]--[[ 祈雨祭 ]]
--------------------------------------------------------------------------

if CONFIGS_LEGION.PRAYFORRAIN then
    modimport("scripts/prayforrain_legion.lua")
end

--------------------------------------------------------------------------
--[[ legends of the fall ]]--[[ 丰饶传说 ]]
--------------------------------------------------------------------------

if CONFIGS_LEGION.LEGENDOFFALL then
    -- modimport("scripts/new_farm_legion.lua")    --关于农场新机制的部分全在这里
    modimport("scripts/legendoffall_legion.lua")
end

--------------------------------------------------------------------------
--[[ flash and crush ]]--[[ 电闪雷鸣 ]]
--------------------------------------------------------------------------

if TUNING.LEGION_FLASHANDCRUSH then
    if TUNING.LEGION_TECHUNLOCK == "prototyper" then
        modimport("scripts/new_techtree_legion.lua")    --新增制作栏的所需代码
    end

    modimport("scripts/flashandcrush_legion.lua")
end

--------------------------------------------------------------------------
--[[ other ]]--[[ 其他补充 ]]
--------------------------------------------------------------------------

----------
--靠背熊背包的来源
----------

if GetModConfigData("BackCubChance") > 0 then
    SetSharedLootTable( 'bearger_legion',
    {
        {'meat',             1.00},
        {'meat',             1.00},
        {'meat',             1.00},
        {'meat',             1.00},
        {'meat',             1.00},
        {'meat',             1.00},
        {'meat',             1.00},
        {'meat',             1.00},
        {'bearger_fur',      1.00},
        {'chesspiece_bearger_sketch', 1.00},

        {'backcub',          GetModConfigData("BackCubChance")},
    })

    AddPrefabPostInit("bearger", function(inst)    --通过api重写熊獾的掉落物
        if TheWorld.ismastersim then
            inst.components.lootdropper:SetChanceLootTable('bearger_legion')
        end
    end)
end

----------
--苔衣发卡的作用
----------

AddRecipe2(
    "hat_lichen", {
        Ingredient("lightbulb", 6),
        Ingredient("cutlichen", 4),
    }, TECH.NONE, {
        atlas = "images/inventoryimages/hat_lichen.xml", image = "hat_lichen.tex"
    }, { "CLOTHING", "LIGHT" }
)

AddPrefabPostInit("bunnyman", function(inst)    --通过api重写兔人的识别敌人函数
    if TheWorld.ismastersim then
        local targetfn_old = inst.components.combat.targetfn
        inst.components.combat:SetRetargetFunction(3, function(inst)
            local target = targetfn_old(inst)
            if
                target == nil or
                (
                    not target:HasTag("monster") and --可不会保护怪物
                    (
                        (target.components.inventory ~= nil and target.components.inventory:EquipHasTag("ignoreMeat")) or
                        target:HasTag("ignoreMeat")
                    )
                )
            then
                return nil
            else
                return target
            end
        end)

        local GetBattleCryString_old = inst.components.combat.GetBattleCryString
        inst.components.combat.GetBattleCryString = function(combatcmp, target)
            local cry, strid = GetBattleCryString_old(combatcmp, target)
            if
                cry ~= nil and cry ~= "RABBIT_BATTLECRY" and
                (
                    (target.components.inventory ~= nil and target.components.inventory:EquipHasTag("ignoreMeat")) or
                    target:HasTag("ignoreMeat")
                )
            then
                return "RABBIT_BATTLECRY", math.random(#STRINGS["RABBIT_BATTLECRY"])
            else
                return cry, strid
            end
        end
    end
end)

----------
--增加新的周期性怪物
----------

-- AddPrefabPostInit("forest", function(inst)
--     if TheWorld.ismastersim then
--         local houndspawn =
--         {
--             base_prefab = "bishop",
--             winter_prefab = "killerbee",
--             summer_prefab = "killerbee",

--             attack_levels =
--             {
--                 intro   = { warnduration = function() return 120 end, numspawns = function() return 2 end },
--                 light   = { warnduration = function() return 60 end, numspawns = function() return 2 + math.random(2) end },
--                 med     = { warnduration = function() return 45 end, numspawns = function() return 3 + math.random(3) end },
--                 heavy   = { warnduration = function() return 30 end, numspawns = function() return 4 + math.random(3) end },
--                 crazy   = { warnduration = function() return 30 end, numspawns = function() return 6 + math.random(4) end },
--             },

--             attack_delays =
--             {
--                 rare        = function() return TUNING.TOTAL_DAY_TIME * 3, math.random() * TUNING.TOTAL_DAY_TIME * 1 end,
--                 occasional  = function() return TUNING.TOTAL_DAY_TIME * 2, math.random() * TUNING.TOTAL_DAY_TIME * 1 end,
--                 frequent    = function() return TUNING.TOTAL_DAY_TIME * 1, math.random() * TUNING.TOTAL_DAY_TIME * 1 end,
--             },

--             warning_speech = "ANNOUNCE_HOUNDS",

--             --Key = time, Value = sound prefab
--             warning_sound_thresholds =
--             {
--                 { time = 30, sound =  "LVL4" },
--                 { time = 60, sound =  "LVL3" },
--                 { time = 90, sound =  "LVL2" },
--                 { time = 500, sound = "LVL1" },
--             },
--         }

--         inst.components.hounded:SetSpawnData(houndspawn)
--     end
-- end)

--------------------------------------------------------------------------
--[[ 皮肤 ]]
--------------------------------------------------------------------------

modimport("scripts/skin_legion.lua") --skined_legion

--------------------------------------------------------------------------
--[[ mod之间的兼容 ]]
--------------------------------------------------------------------------

----------
--黑化排队论2(有好几个版本，但组件好像是相同的)
----------
AddComponentPostInit("actionqueuer", function(self)
	if self.AddAction then
		self.AddAction("leftclick", "PLANTSOIL_LEGION", true)
        self.AddAction("rightclick", "POUR_WATER_LEGION", true)
        self.AddAction("leftclick", "FERTILIZE_LEGION", true)
	end
end)

--AddSimPostInit()在所有mod加载完毕后才执行，这时能更准确判定是否启用某mod，不用考虑优先级
AddSimPostInit(function()
	-- table.insert(Assets, Asset("ANIM", "anim/player_actions_roll.zip")) --这个函数里没法再注册动画数据了

    ----------
    --神话书说
    ----------
    _G.CONFIGS_LEGION.ENABLEDMODS.MythWords = TUNING.MYTH_WORDS_MOD_OPEN
    if TUNING.MYTH_WORDS_MOD_OPEN then
        if CONFIGS_LEGION.DRESSUP then
            ------给神话的巨型葫芦添加幻化
            local DRESSUP_DATA = _G.DRESSUP_DATA_LEGION
            DRESSUP_DATA["gourd_oversized"] = {
                isnoskin = true,
                istallbody = true,
                buildfile = "farm_plant_gourd",
                buildsymbol = "swap_body",
            }
            DRESSUP_DATA["gourd_oversized_waxed"] = DRESSUP_DATA["gourd_oversized"]
            -- DRESSUP_DATA["gourd_oversized_rotten"] = { --神话还没改
            --     isnoskin = true,
            --     istallbody = true,
            --     buildfile = "farm_plant_gourd",
            --     buildsymbol = "swap_body_rotten",
            -- }

            DRESSUP_DATA["xzhat_mk"] = { --行者帽
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}

                    local mythskin = item.components.myth_itemskin
                    local skinname = mythskin.skin:value()
                    local skindata = mythskin.swap or mythskin.data.default.swap
                    if skinname == "ear" then
                        itemswap["swap_hat"] = dressup:GetDressData(
                            nil, skindata.build, skindata.folder, item.GUID, "swap"
                        )
                        dressup:SetDressOpenTop(itemswap)
                        itemswap["swap_face"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
                        itemswap["hair"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
                    elseif skinname == "horse" then
                        itemswap["hair"] = dressup:GetDressData(
                            nil, skindata.build, skindata.folder, item.GUID, "swap"
                        )
                        dressup:SetDressOpenTop(itemswap)
                        itemswap["swap_face"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
                        itemswap["swap_hat"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
                        itemswap["HAT"] = dressup:GetDressData(nil, nil, nil, nil, "show")
                        itemswap["HAIR_HAT"] = dressup:GetDressData(nil, nil, nil, nil, "show")
                    elseif skinname == "wine" then
                        itemswap["swap_face"] = dressup:GetDressData(
                            nil, skindata.build, skindata.folder, item.GUID, "swap"
                        )
                        dressup:SetDressOpenTop(itemswap)
                        itemswap["hair"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
                        itemswap["swap_hat"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
                    else
                        skindata = mythskin.data.default.swap
                        itemswap["swap_hat"] = dressup:GetDressData(
                            nil, skindata.build, skindata.folder, item.GUID, "swap"
                        )
                        dressup:SetDressTop(itemswap)
                        itemswap["swap_face"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
                        itemswap["hair"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
                    end

                    return itemswap
                end,
                unbuildfn = function(dressup, item)
                    dressup:InitClear("swap_hat")
                    dressup:InitHide("HAT")
                    dressup:InitHide("HAIR_HAT")
                    dressup:InitShow("HAIR_NOHAT")
                    dressup:InitShow("HAIR")

                    dressup:InitShow("HEAD")
                    dressup:InitHide("HEAD_HAT")

                    dressup:InitClear("hair")
                    dressup:InitClear("swap_face")
                end,
            }
            DRESSUP_DATA["cassock"] = { --袈裟
                isnoskin = true, buildfile = "cassock", buildsymbol = "swap_body",
            }
            DRESSUP_DATA["kam_lan_cassock"] = { --锦斓袈裟
                isnoskin = true, buildfile = "kam_Lan_cassock", buildsymbol = "swap_body",
            }
            DRESSUP_DATA["myth_lotusleaf"] = { --莲叶
                isnoskin = true, buildfile = "myth_lotusleaf_umbrella", buildsymbol = "swap_leaves",
            }
            DRESSUP_DATA["myth_lotusleaf_hat"] = { --莲叶帽
                isnoskin = true, buildfile = "myth_lotusleaf_hat", buildsymbol = "swap_hat",
            }
            DRESSUP_DATA["bone_blade"] = { --骨刃
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}

                    local mythskin = item.components.myth_itemskin
                    local skindata = mythskin.swap or mythskin.data.default.swap
                    itemswap["swap_object"] = dressup:GetDressData(
                        nil, skindata.build, skindata.folder, item.GUID, "swap"
                    )
                    itemswap["whipline"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
                    itemswap["lantern_overlay"] = dressup:GetDressData(nil, nil, nil, nil, "clear")

                    return itemswap
                end,
            }
            DRESSUP_DATA["bone_wand"] = { --骨杖
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}

                    local mythskin = item.components.myth_itemskin
                    local skindata = mythskin.swap or mythskin.data.default.swap
                    itemswap["swap_object"] = dressup:GetDressData(
                        nil, skindata.build, skindata.folder, item.GUID, "swap"
                    )
                    itemswap["whipline"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
                    itemswap["lantern_overlay"] = dressup:GetDressData(nil, nil, nil, nil, "clear")

                    return itemswap
                end,
            }
            DRESSUP_DATA["bone_whip"] = { --骨鞭
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}

                    local key = item.components.myth_itemskin.skin:value()
                    if key == nil or key == "" or key == 'default' then
                        key = 'none'
                    end
                    itemswap["swap_object"] = dressup:GetDressData(
                        nil, "bone_whip", "swap_whip_"..key, item.GUID, "swap"
                    )
                    itemswap["whipline"] = dressup:GetDressData(
                        nil, "bone_whip", "whipline_"..key, item.GUID, "swap"
                    )
                    itemswap["lantern_overlay"] = dressup:GetDressData(nil, nil, nil, nil, "clear")

                    return itemswap
                end,
            }
            DRESSUP_DATA["pigsy_hat"] = { --墨兰帽
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}

                    local mythskin = item.components.myth_itemskin
                    local skindata = mythskin.swap or mythskin.data.default.swap
                    itemswap["swap_hat"] = dressup:GetDressData(
                        nil, skindata.build, skindata.folder, item.GUID, "swap"
                    )
                    dressup:SetDressOpenTop(itemswap)

                    return itemswap
                end,
            }
            DRESSUP_DATA["myth_bamboo_basket"] = { --竹药篓
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}

                    local mythskin = item.components.myth_itemskin
                    local skinname = mythskin.skin:value()
                    local skindata = mythskin.swap or mythskin.data.default.swap
                    if skinname == "apricot" then
                        itemswap["swap_body_tall"] = dressup:GetDressData(
                            nil, skindata.build, "swap_none", item.GUID, "swap"
                        )
                    else
                        itemswap["backpack"] = dressup:GetDressData(
                            nil, skindata.build, skindata.folder, item.GUID, "swap"
                        )
                        itemswap["swap_body"] = dressup:GetDressData(
                            nil, skindata.build, skindata.folder, item.GUID, "swap"
                        )
                    end

                    return itemswap
                end,
                unbuildfn = function(dressup, item)
                    dressup:InitClear("swap_body_tall")
                    dressup:InitClear("backpack")
                    dressup:InitClear("swap_body")
                end,
            }
            DRESSUP_DATA["bananafan_big"] = { --芭蕉宝扇
                isnoskin = true, buildfile = "swap_bananafan_big", buildsymbol = "swap_fan",
            }
            DRESSUP_DATA["myth_ruyi"] = { --莹月如意
                isnoskin = true, buildfile = "myth_ruyi", buildsymbol = "swap_ruyi",
            }
            DRESSUP_DATA["siving_hat"] = { --子圭战盔
                isnoskin = true, buildfile = "siving_hat", buildsymbol = "swap_hat",
            }
            DRESSUP_DATA["armorsiving"] = { --子圭战甲
                isnoskin = true, buildfile = "armor_siving", buildsymbol = "swap_body",
            }
            DRESSUP_DATA["myth_qxj"] = { --七星剑
                isnoskin = true, buildfile = "myth_qxj", buildsymbol = "swap_qxj",
            }
            DRESSUP_DATA["wb_armorbone"] = { --坚骨披
                isnoskin = true, dressslot = EQUIPSLOTS.BODY, buildfile = "wb_armorbone", buildsymbol = "swap_body",
            }
            DRESSUP_DATA["wb_armorblood"] = { --血色霓
                isnoskin = true, dressslot = EQUIPSLOTS.BODY, buildfile = "wb_armorblood", buildsymbol = "swap_body",
            }
            DRESSUP_DATA["wb_armorfog"] = { --雾隐裳
                isnoskin = true, dressslot = EQUIPSLOTS.BODY, buildfile = "wb_armorfog", buildsymbol = "swap_body",
            }
            DRESSUP_DATA["wb_armorgreed"] = { --不魇衣
                isnoskin = true, dressslot = EQUIPSLOTS.BODY, buildfile = "wb_armorgreed", buildsymbol = "swap_body",
            }
            DRESSUP_DATA["wb_armorlight"] = { --盈风绸
                isnoskin = true, dressslot = EQUIPSLOTS.BODY, buildfile = "wb_armorlight", buildsymbol = "swap_body",
            }
            DRESSUP_DATA["wb_armorstorage"] = { --蕴玄袍
                isnoskin = true, dressslot = EQUIPSLOTS.BODY, buildfile = "wb_armorstorage", buildsymbol = "swap_body",
            }
            DRESSUP_DATA["purple_gourd"] = { --紫金红葫芦
                isnoskin = true, buildfile = "purple_gourd", buildsymbol = "swap_2",
            }
            DRESSUP_DATA["myth_fuchen"] = { --拂尘
                isnoskin = true, iswhip = true, buildfile = "swap_myth_fuchen", buildsymbol = "swap_whip",
            }
            DRESSUP_DATA["myth_weapon_syf"] = { --霜钺斧
                isnoskin = true, buildfile = "myth_weapon_syf", buildsymbol = "swap",
            }
            DRESSUP_DATA["myth_weapon_gtt"] = { --扢挞藤
                isnoskin = true, buildfile = "myth_weapon_gtt", buildsymbol = "swap",
            }
            DRESSUP_DATA["myth_weapon_syd"] = { --暑熠刀
                isnoskin = true, buildfile = "myth_weapon_syd", buildsymbol = "swap",
            }
            DRESSUP_DATA["myth_iron_helmet"] = { --铸铁头盔
                isnoskin = true, buildfile = "myth_iron_helmet", buildsymbol = "swap_hat",
            }
            DRESSUP_DATA["myth_iron_broadsword"] = { --铸铁大刀
                isnoskin = true, buildfile = "myth_iron_broadsword", buildsymbol = "swap_object",
            }
            DRESSUP_DATA["myth_iron_battlegear"] = { --铸铁战甲
                isnoskin = true, buildfile = "myth_iron_battlegear", buildsymbol = "swap_body",
            }
            DRESSUP_DATA["myth_food_tr"] = { --糖人
                isnoskin = true, buildfile = "swap_myth_food_tr", buildsymbol = "image",
            }
        end

        if _G.rawget(_G, "AddBambooShopItems") then
            local chancemap = { 1, 3, 7, 10, 15 }
            _G.AddBambooShopItems("rareitem", {
                tourmalinecore = {
                    img_tex = "tourmalinecore.tex", img_atlas = "images/inventoryimages/tourmalinecore.xml",
                    buy = { value = 320, chance = chancemap[1], count_min = 1, count_max = 1, stacksize = 5, },
                    sell = { value = 180, chance = chancemap[1], count_min = 1, count_max = 1, stacksize = 5, }
                },
            })
            _G.AddBambooShopItems("ingredient", {
                pineananas = {
                    img_tex = "pineananas.tex", img_atlas = "images/inventoryimages/pineananas.xml",
                    buy = { value = 5, chance = chancemap[2], count_min = 3, count_max = 5, stacksize = 20, },
                    sell = { value = 2, chance = chancemap[2], count_min = 3, count_max = 5, stacksize = 20, },
                },
            })
            _G.AddBambooShopItems("plants", {
                pineananas_seeds = {
                    img_tex = "pineananas_seeds.tex", img_atlas = "images/inventoryimages/pineananas_seeds.xml",
                    buy = { value = 12, chance = chancemap[3], count_min = 2, count_max = 3, stacksize = 10, num_mix = 4, },
                    sell = { value = nil, chance = chancemap[3], count_min = 2, count_max = 3, stacksize = 10, num_mix = 4, }
                },
                pineananas_oversized = {
                    img_tex = "pineananas_oversized.tex", img_atlas = "images/inventoryimages/pineananas_oversized.xml",
                    buy = { value = nil, chance = chancemap[5], count_min = 1, count_max = 2, stacksize = 5, },
                    sell = { value = 10, chance = chancemap[5], count_min = 1, count_max = 2, stacksize = 5, }
                },
                dug_rosebush = {
                    img_tex = "dug_rosebush.tex", img_atlas = "images/inventoryimages/dug_rosebush.xml",
                    buy = { value = 15, chance = chancemap[2], count_min = 1, count_max = 3, stacksize = 10, },
                    sell = { value = nil, chance = chancemap[2], count_min = 1, count_max = 3, stacksize = 10, },
                },
                dug_lilybush = {
                    img_tex = "dug_lilybush.tex", img_atlas = "images/inventoryimages/dug_lilybush.xml",
                    buy = { value = 15, chance = chancemap[2], count_min = 1, count_max = 3, stacksize = 10, },
                    sell = { value = nil, chance = chancemap[2], count_min = 1, count_max = 3, stacksize = 10, },
                },
                dug_orchidbush = {
                    img_tex = "dug_orchidbush.tex", img_atlas = "images/inventoryimages/dug_orchidbush.xml",
                    buy = { value = 15, chance = chancemap[2], count_min = 1, count_max = 3, stacksize = 10, },
                    sell = { value = nil, chance = chancemap[2], count_min = 1, count_max = 3, stacksize = 10, },
                },
                cutted_rosebush = {
                    img_tex = "cutted_rosebush.tex", img_atlas = "images/inventoryimages/cutted_rosebush.xml",
                    buy = { value = 15, chance = chancemap[2], count_min = 1, count_max = 3, stacksize = 20, },
                    sell = { value = 6, chance = chancemap[2], count_min = 2, count_max = 4, stacksize = 20, },
                },
                cutted_lilybush = {
                    img_tex = "cutted_lilybush.tex", img_atlas = "images/inventoryimages/cutted_lilybush.xml",
                    buy = { value = 15, chance = chancemap[2], count_min = 1, count_max = 3, stacksize = 20, },
                    sell = { value = 6, chance = chancemap[2], count_min = 2, count_max = 4, stacksize = 20, },
                },
                cutted_orchidbush = {
                    img_tex = "cutted_orchidbush.tex", img_atlas = "images/inventoryimages/cutted_orchidbush.xml",
                    buy = { value = 15, chance = chancemap[2], count_min = 1, count_max = 3, stacksize = 20, },
                    sell = { value = 6, chance = chancemap[2], count_min = 2, count_max = 4, stacksize = 20, },
                },
            })
            _G.AddBambooShopItems("animals", {
                raindonate = {
                    img_tex = "raindonate.tex", img_atlas = "images/inventoryimages/raindonate.xml",
                    buy = { value = 10, chance = chancemap[3], count_min = 2, count_max = 4, stacksize = 10, },
                    sell = { value = 5, chance = chancemap[3], count_min = 2, count_max = 4, stacksize = 10, },
                },
            })
            _G.AddBambooShopItems("construct", {
                shyerrylog = {
                    img_tex = "shyerrylog.tex", img_atlas = "images/inventoryimages/shyerrylog.xml",
                    buy = { value = 4, chance = chancemap[4], count_min = 3, count_max = 5, stacksize = 20, },
                    sell = { value = 2, chance = chancemap[4], count_min = 3, count_max = 5, stacksize = 20, },
                },
            })
        end
    end

    ----------
    --工艺锅（Craft Pot）
    ----------
    _G.CONFIGS_LEGION.ENABLEDMODS.CraftPot = AddFoodTag ~= nil --AddFoodTag()是该mod里的全局函数
    if CONFIGS_LEGION.ENABLEDMODS.CraftPot then
        if TUNING.LEGION_SUPERBCUISINE then
            --写这个是为了注册特殊烹饪条件(craft pot的机制)
            AddIngredientValues({"craftpot"}, {
                fallfullmoon = 1,
                winterfeast = 1,
                hallowednights = 1,
                newmoon = 1,
            }, false, false)

            if TUNING.LEGION_MOD_LANGUAGES == "chinese" then
                STRINGS.NAMES_LEGION = {
                    GEL = "黏液度",
                    PETALS_LEGION = "花度",
                    FALLFULLMOON = "秋季月圆天专属",
                    WINTERSFEAST = "冬季盛宴专属",
                    HALLOWEDNIGHTS = "疯狂万圣专属",
                    NEWMOON = "新月天专属",
                }

                --帮craft pot翻译下吧
                STRINGS.NAMES.FROZEN = "冰度"
                STRINGS.NAMES.VEGGIE = "菜度"
                STRINGS.NAMES.SWEETENER = "甜度"
                -- STRINGS.NAMES.MEAT = "肉度" --和大肉重名了，不能这样改
                -- STRINGS.NAMES.FISH = "鱼度" --和鱼重名了，不能这样改
                STRINGS.NAMES.MONSTER = "怪物度"
                STRINGS.NAMES.FRUIT = "果度"
                STRINGS.NAMES.EGG = "蛋度"
                STRINGS.NAMES.INEDIBLE = "非食"
                STRINGS.NAMES.MAGIC = "魔法度"
                STRINGS.NAMES.DECORATION = "装饰度"
                STRINGS.NAMES.SEED = "种子度"
                STRINGS.NAMES.DAIRY = "乳度"
                STRINGS.NAMES.FAT = "脂度"
            else
                STRINGS.NAMES_LEGION = {
                    GEL = "Gel",
                    PETALS_LEGION = "Petals",
                    FALLFULLMOON = "specific to Fall FullMoon Day",
                    WINTERSFEAST = "specific to Winter Feast",
                    HALLOWEDNIGHTS = "specific to Hallowed Nights",
                    NEWMOON = "specific to NewMoon Day",
                }
            end

            AddFoodTag('gel', {
                name = STRINGS.NAMES_LEGION.GEL,
                tex = "foodtag_gel.tex",
                atlas = "images/foodtags/foodtag_gel.xml"
            })
            AddFoodTag('petals_legion', {
                name = STRINGS.NAMES_LEGION.PETALS_LEGION,
                tex = "foodtag_petals.tex",
                atlas = "images/foodtags/foodtag_petals.xml"
            })
            AddFoodTag('fallfullmoon', {
                name = STRINGS.NAMES_LEGION.FALLFULLMOON,
                tex = "foodtag_fallfullmoon.tex",
                atlas = "images/foodtags/foodtag_fallfullmoon.xml"
            })
            AddFoodTag('winterfeast', {
                name = STRINGS.NAMES_LEGION.WINTERSFEAST,
                tex = "foodtag_winterfeast.tex",
                atlas = "images/foodtags/foodtag_winterfeast.xml"
            })
            AddFoodTag('hallowednights', {
                name = STRINGS.NAMES_LEGION.HALLOWEDNIGHTS,
                tex = "foodtag_hallowednights.tex",
                atlas = "images/foodtags/foodtag_hallowednights.xml"
            })
            AddFoodTag('newmoon', {
                name = STRINGS.NAMES_LEGION.NEWMOON,
                tex = "foodtag_newmoon.tex",
                atlas = "images/foodtags/foodtag_newmoon.xml"
            })
            --这里本来想把冰度、菜度等图标都改为自己的图标，但是原mod里的图标其实更简单直接，适合新手，所以就不弄啦
        end
    end
end)
