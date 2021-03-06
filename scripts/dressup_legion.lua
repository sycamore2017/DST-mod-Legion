local _G = GLOBAL
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()

---

table.insert(Assets, Asset("ANIM", "anim/hat_straw_perd.zip"))

--------------------------------------------------------------------------
--[[ 全局幻化数据 ]]
--------------------------------------------------------------------------

local dressup_data =
{
    -------------------------------
    --手部-------------------------
    -------------------------------

    spear =
    {
        -- dressslot = nil,            --如果是非装备的幻化道具，就需要定义这个
        -- isnoskin = nil,             --是否有皮肤（主要针对mod物品）
        -- isopentop = nil,
        -- istallbody = nil,
        -- isbackpack = nil,
        -- iswhip = nil,
        buildfile = "swap_spear",   --（通用）贴图文件名
        buildsymbol = "swap_spear", --（通用）贴图文件中的文件夹名
        -- buildfn = nil,              --当通用机制不满足时，在这个函数里自定义幻化信息。(dressup, item, buildskin)
        -- unbuildfn = nil,            --当通用机制不满足时，在这个函数里自定义去幻信息。(dressup, item)
        -- equipfn = nil,              --幻化时函数。data.equipfn(player, item)
        -- unequipfn = nil,            --去幻时函数。data.unequipfn(player, item)
    },
    hambat =
    {
        buildfile = "swap_ham_bat",
        buildsymbol = "swap_ham_bat",
    },
    spear_wathgrithr =
    {
        buildfile = "swap_spear_wathgrithr",
        buildsymbol = "swap_spear_wathgrithr",
    },
    nightsword =
    {
        buildfile = "swap_nightmaresword",
        buildsymbol = "swap_nightmaresword",
    },
    lantern =
    {
        buildfn = function(dressup, item, buildskin)
            local itemswap = {}
            itemswap["swap_object"] = dressup:GetDressData(
                buildskin, "swap_lantern", "swap_lantern", item.GUID, "swap"
            )

            --提灯光效贴图没法控制了，就像鞭子类武器的鞭子击打动画一样没法强制改，只能跟随目前的装备类型才行。
            --比如，幻化鞭子后，装备海带鞭才会看见鞭子的击打动画；幻化提灯后，装备提灯时才会看见提灯光效
            if item.components.fueled:IsEmpty() then
                itemswap["lantern_overlay"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
            else
                itemswap["lantern_overlay"] = dressup:GetDressData(
                    buildskin, "swap_lantern", "lantern_overlay", item.GUID, "swap"
                )
            end
            itemswap["whipline"] = dressup:GetDressData(nil, nil, nil, nil, "clear")

            return itemswap
        end,
        equipfn = function(player, item)
            --幻化前需要关闭它，防止玩家发光
            if item.components.machine ~= nil and item.components.machine:IsOn() then
                item.components.machine:TurnOff()
            end
        end,
    },
    bugnet =
    {
        buildfile = "swap_bugnet",
        buildsymbol = "swap_bugnet",
    },
    fishingrod =
    {
        buildfile = "swap_fishingrod",
        buildsymbol = "swap_fishingrod",
    },
    grass_umbrella =
    {
        buildfile = "swap_parasol",
        buildsymbol = "swap_parasol",
    },
    umbrella =
    {
        buildfile = "swap_umbrella",
        buildsymbol = "swap_umbrella",
    },
    waterballoon =
    {
        buildfile = "swap_waterballoon",
        buildsymbol = "swap_waterballoon",
    },
    compass =
    {
        buildfile = "swap_compass",
        buildsymbol = "swap_compass",
    },
    axe =
    {
        buildfile = "swap_axe",
        buildsymbol = "swap_axe",
    },
    goldenaxe =
    {
        buildfile = "swap_goldenaxe",
        buildsymbol = "swap_goldenaxe",
    },
    pickaxe =
    {
        buildfile = "swap_pickaxe",
        buildsymbol = "swap_pickaxe",
    },
    goldenpickaxe =
    {
        buildfile = "swap_goldenpickaxe",
        buildsymbol = "swap_goldenpickaxe",
    },
    shovel =
    {
        buildfile = "swap_shovel",
        buildsymbol = "swap_shovel",
    },
    goldenshovel =
    {
        buildfile = "swap_goldenshovel",
        buildsymbol = "swap_goldenshovel",
    },
    multitool_axe_pickaxe =
    {
        buildfile = "swap_multitool_axe_pickaxe",
        buildsymbol = "swap_object",
    },
    hammer =
    {
        buildfile = "swap_hammer",
        buildsymbol = "swap_hammer",
    },
    pitchfork =
    {
        buildfile = "swap_pitchfork",
        buildsymbol = "swap_pitchfork",
    },
    saddlehorn =
    {
        buildfile = "swap_saddlehorn",
        buildsymbol = "swap_saddlehorn",
    },
    brush =
    {
        buildfile = "swap_beefalobrush",
        buildsymbol = "swap_beefalobrush",
    },
    batbat =
    {
        buildfile = "swap_batbat",
        buildsymbol = "swap_batbat",
    },
    firestaff =
    {
        buildfile = "swap_staffs",
        buildsymbol = "swap_redstaff",
    },
    icestaff =
    {
        buildfile = "swap_staffs",
        buildsymbol = "swap_bluestaff",
    },
    telestaff =
    {
        buildfile = "swap_staffs",
        buildsymbol = "swap_purplestaff",
    },
    yellowstaff =
    {
        buildfile = "swap_staffs",
        buildsymbol = "swap_yellowstaff",
    },
    greenstaff =
    {
        buildfile = "swap_staffs",
        buildsymbol = "swap_greenstaff",
    },
    orangestaff =
    {
        buildfile = "swap_staffs",
        buildsymbol = "swap_orangestaff",
    },
    opalstaff =
    {
        buildfile = "swap_staffs",
        buildsymbol = "swap_opalstaff",
    },
    nightstick =
    {
        buildfile = "swap_nightstick",
        buildsymbol = "swap_nightstick",
    },
    whip =
    {
        iswhip = true,
        buildfile = "swap_whip",
        buildsymbol = "swap_whip",
    },
    sleepbomb =
    {
        buildfile = "swap_sleepbomb",
        buildsymbol = "swap_sleepbomb",
    },
    blowdart_sleep =
    {
        buildfile = "swap_blowdart",
        buildsymbol = "swap_blowdart",
    },
    blowdart_fire =
    {
        buildfile = "swap_blowdart",
        buildsymbol = "swap_blowdart",
    },
    blowdart_yellow =
    {
        buildfile = "swap_blowdart",
        buildsymbol = "swap_blowdart",
    },
    blowdart_pipe =
    {
        buildfile = "swap_blowdart_pipe",
        buildsymbol = "swap_blowdart_pipe",
    },
    boomerang =
    {
        buildfile = "swap_boomerang",
        buildsymbol = "swap_boomerang",
    },
    staff_tornado =
    {
        buildfile = "swap_tornado_stick",
        buildsymbol = "swap_tornado_stick",
    },
    cane =
    {
        buildfile = "swap_cane",
        buildsymbol = "swap_cane",
    },
    ruins_bat =
    {
        buildfile = "swap_ruins_bat",
        buildsymbol = "swap_ruins_bat",
    },
    tentaclespike =
    {
        isnoskin = true,
        buildfile = "swap_spike",
        buildsymbol = "swap_spike",
    },
    propsign =
    {
        isnoskin = true,
        buildfile = "swap_sign_elite",
        buildsymbol = "swap_sign_elite",
    },
    bullkelp_root =
    {
        isnoskin = true,
        iswhip = true,
        buildfile = "swap_bullkelproot",
        buildsymbol = "swap_whip",
    },
    chum = --鱼食
    {
        buildfile = "swap_chum_pouch",
        buildsymbol = "swap_chum_pouch",
    },
    diviningrod = --零件探测器
    {
        isnoskin = true,
        buildfile = "swap_diviningrod",
        buildsymbol = "swap_diviningrod",
    },
    fishingnet = --渔网
    {
        buildfile = "swap_boat_net",
        buildsymbol = "swap_boat_net",
    },
    glasscutter = --月玻璃刀
    {
        buildfile = "swap_glasscutter",
        buildsymbol = "swap_glasscutter",
    },
    gnarwail_horn = --多角鲸的角
    {
        isnoskin = true,
        buildfile = "swap_gnarwailhorn",
        buildsymbol = "swap_gnarwailhorn",
    },
    messagebottle = --有信的漂流瓶
    {
        isnoskin = true,
        dressslot = EQUIPSLOTS.HANDS,
        buildfile = "swap_bottle",
        buildsymbol = "swap_bottle",
    },
    oar = --木桨
    {
        buildfile = "swap_oar",
        buildsymbol = "swap_oar",
    },
    oar_driftwood = --浮木桨
    {
        buildfile = "swap_oar_driftwood",
        buildsymbol = "swap_oar_driftwood",
    },
    malbatross_beak = --邪天翁喙
    {
        buildfile = "swap_malbatross_beak",
        buildsymbol = "swap_malbatross_beak",
    },
    oceanfishingrod = --海洋钓竿
    {
        buildfn = function(dressup, item, buildskin)
            local itemswap = {}
            itemswap["swap_object"] = dressup:GetDressData(
                buildskin, "swap_fishingrod_ocean", "swap_fishingrod_ocean", item.GUID, "swap"
            )
            itemswap["fishingline"] = dressup:GetDressData(
                buildskin, "swap_fishingrod_ocean", "fishingline", item.GUID, "swap"
            )
            itemswap["FX_fishing"] = dressup:GetDressData(
                buildskin, "swap_fishingrod_ocean", "FX_fishing", item.GUID, "swap"
            )

            --切记，手持物品一定要清除不相关贴图
            itemswap["lantern_overlay"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
            itemswap["whipline"] = dressup:GetDressData(nil, nil, nil, nil, "clear")

            return itemswap
        end,
        unbuildfn = function(dressup, item)
            dressup:InitClear("swap_object")
            dressup:InitClear("whipline")
            dressup:InitClear("lantern_overlay")
            dressup:InitHide("LANTERN_OVERLAY")

            dressup:InitClear("fishingline")
            dressup:InitClear("FX_fishing")
        end,
    },
    reskin_tool = --皮肤扫把
    {
        buildfile = "swap_reskin_tool",
        buildsymbol = "swap_reskin_tool",
    },
    slingshot = --弹弓
    {
        buildfile = "swap_slingshot",
        buildsymbol = "swap_slingshot",
    },
    trident = --破音三叉戟
    {
        buildfile = "swap_trident",
        buildsymbol = "swap_trident",
    },
    waterplant_bomb = --藤壶花的飞弹
    {
        isnoskin = true,
        buildfile = "swap_barnacle_burr",
        buildsymbol = "swap_barnacle_burr",
    },
    moonglassaxe =
    {
        buildfile = "swap_glassaxe",
        buildsymbol = "swap_glassaxe",
    },
    lighter =
    {
        buildfile = "swap_lighter",
        buildsymbol = "swap_lighter",
    },
    torch =
    {
        buildfile = "swap_torch",
        buildsymbol = "swap_torch",
    },
    farm_hoe =
    {
        buildfile = "quagmire_hoe",
        buildsymbol = "swap_quagmire_hoe",
    },
    golden_farm_hoe =
    {
        buildfile = "swap_goldenhoe",
        buildsymbol = "swap_goldenhoe",
    },
    wateringcan =
    {
        buildfile = "swap_wateringcan",
        buildsymbol = "swap_wateringcan",
    },
    premiumwateringcan =
    {
        buildfile = "swap_premiumwateringcan",
        buildsymbol = "swap_premiumwateringcan",
    },
    -- minifan = --有贴图之外的实体，不做幻化
    -- {
    --     buildfile = "swap_minifan",
    --     buildsymbol = "swap_minifan",
    -- },
    -- redlantern = --有贴图之外的实体，不做幻化
    -- {
    --     buildfile = "swap_redlantern",
    --     buildsymbol = "swap_redlantern",
    -- },
    -- thurible = --暗影香炉。有贴图之外的实体，不做幻化
    -- {
    --     buildfile = "swap_thurible",
    --     buildsymbol = "swap_thurible",
    -- },
    -- lucy = --露西斧，伍迪只有一把，不做幻化
    -- {
    --     buildfile = "swap_lucy_axe",lucy
    --     buildsymbol = "swap_lucy_axe",
    -- },
    -- bernie_inactive = --伯尼熊，机制特殊，精神值过低时会引发崩溃
    -- {
    --     buildfn = function(dressup, item, buildskin)
    --         local itemswap = {}
    --         if item.components.fueled:IsEmpty() then
    --             itemswap["swap_object"] = dressup:GetDressData(
    --                 buildskin, "bernie_build", "swap_bernie_dead", item.GUID, "swap"
    --             )
    --             itemswap["swap_object_bernie"] = dressup:GetDressData(
    --                 buildskin, "bernie_build", "swap_bernie_dead_idle_willow", item.GUID, "swap"
    --             )
    --         else
    --             itemswap["swap_object"] = dressup:GetDressData(
    --                 buildskin, "bernie_build", "swap_bernie", item.GUID, "swap"
    --             )
    --             itemswap["swap_object_bernie"] = dressup:GetDressData(
    --                 buildskin, "bernie_build", "swap_bernie_idle_willow", item.GUID, "swap"
    --             )
    --         end

    --         --切记，手持物品一定要清除不相关贴图
    --         itemswap["lantern_overlay"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
    --         itemswap["whipline"] = dressup:GetDressData(nil, nil, nil, nil, "clear")

    --         return itemswap
    --     end,
    -- },

    -------------------------------
    --头部-------------------------
    -------------------------------

    strawhat =
    {
        buildfile = "hat_straw",
        buildsymbol = "swap_hat",
    },
    tophat =
    {
        buildfile = "hat_top",
        buildsymbol = "swap_hat",
    },
    beefalohat =
    {
        buildfile = "hat_beefalo",
        buildsymbol = "swap_hat",
    },
    featherhat =
    {
        buildfile = "hat_feather",
        buildsymbol = "swap_hat",
    },
    beehat =
    {
        buildfile = "hat_bee",
        buildsymbol = "swap_hat",
    },
    minerhat =
    {
        buildfile = "hat_miner",
        buildsymbol = "swap_hat_off",
        buildfn = function(dressup, item, buildskin)
            local itemswap = {}

            if item.components.fueled:IsEmpty() then
                itemswap["swap_hat"] = dressup:GetDressData(
                    buildskin, "hat_miner", "swap_hat_off", item.GUID, "swap"
                )
            else
                itemswap["swap_hat"] = dressup:GetDressData(
                    buildskin, "hat_miner", "swap_hat", item.GUID, "swap"
                )
            end
            itemswap["HAT"] = dressup:GetDressData(nil, nil, nil, nil, "show")
            itemswap["HAIR_HAT"] = dressup:GetDressData(nil, nil, nil, nil, "show")
            itemswap["HAIR_NOHAT"] = dressup:GetDressData(nil, nil, nil, nil, "hide")
            itemswap["HAIR"] = dressup:GetDressData(nil, nil, nil, nil, "hide")

            itemswap["HEAD"] = dressup:GetDressData(nil, nil, nil, nil, "hide")
            itemswap["HEAD_HAT"] = dressup:GetDressData(nil, nil, nil, nil, "show")

            return itemswap
        end,
    },
    spiderhat =
    {
        buildfile = "hat_spider",
        buildsymbol = "swap_hat",
    },
    earmuffshat =
    {
        isopentop = true,
        buildfile = "hat_earmuffs",
        buildsymbol = "swap_hat",
    },
    footballhat =
    {
        buildfile = "hat_football",
        buildsymbol = "swap_hat",
    },
    winterhat =
    {
        buildfile = "hat_winter",
        buildsymbol = "swap_hat",
    },
    bushhat =
    {
        buildfile = "hat_bush",
        buildsymbol = "swap_hat",
    },
    flowerhat =
    {
        isopentop = true,
        buildfile = "hat_flower",
        buildsymbol = "swap_hat",
    },
    walrushat =
    {
        buildfile = "hat_walrus",
        buildsymbol = "swap_hat",
    },
    slurtlehat =
    {
        buildfile = "hat_slurtle",
        buildsymbol = "swap_hat",
    },
    ruinshat =
    {
        isopentop = true,
        buildfile = "hat_ruins",
        buildsymbol = "swap_hat",
    },
    molehat =
    {
        buildfile = "hat_mole",
        buildsymbol = "swap_hat",
    },
    wathgrithrhat =
    {
        buildfn = function(dressup, item, buildskin)
            local itemswap = {}

            if buildskin == "wathgrithrhat_valkyrie" then
                itemswap["swap_hat"] = dressup:GetDressData(
                    buildskin, "hat_wathgrithr", "swap_hat", item.GUID, "swap"
                )
                itemswap["HAT"] = dressup:GetDressData(nil, nil, nil, nil, "show")
                itemswap["HAIR_HAT"] = dressup:GetDressData(nil, nil, nil, nil, "hide")
                itemswap["HAIR_NOHAT"] = dressup:GetDressData(nil, nil, nil, nil, "show")
                itemswap["HAIR"] = dressup:GetDressData(nil, nil, nil, nil, "show")

                itemswap["HEAD"] = dressup:GetDressData(nil, nil, nil, nil, "show")
                itemswap["HEAD_HAT"] = dressup:GetDressData(nil, nil, nil, nil, "hide")
            else
                itemswap["swap_hat"] = dressup:GetDressData(
                    buildskin, "hat_wathgrithr", "swap_hat", item.GUID, "swap"
                )
                itemswap["HAT"] = dressup:GetDressData(nil, nil, nil, nil, "show")
                itemswap["HAIR_HAT"] = dressup:GetDressData(nil, nil, nil, nil, "show")
                itemswap["HAIR_NOHAT"] = dressup:GetDressData(nil, nil, nil, nil, "hide")
                itemswap["HAIR"] = dressup:GetDressData(nil, nil, nil, nil, "hide")

                itemswap["HEAD"] = dressup:GetDressData(nil, nil, nil, nil, "hide")
                itemswap["HEAD_HAT"] = dressup:GetDressData(nil, nil, nil, nil, "show")
            end

            return itemswap
        end,
    },
    icehat =
    {
        buildfile = "hat_ice",
        buildsymbol = "swap_hat",
    },
    rainhat =
    {
        buildfile = "hat_rain",
        buildsymbol = "swap_hat",
    },
    catcoonhat =
    {
        buildfile = "hat_catcoon",
        buildsymbol = "swap_hat",
    },
    watermelonhat =
    {
        buildfile = "hat_watermelon",
        buildsymbol = "swap_hat",
    },
    eyebrellahat =
    {
        buildfile = "hat_eyebrella",
        buildsymbol = "swap_hat",
    },
    red_mushroomhat =
    {
        buildfile = "hat_red_mushroom",
        buildsymbol = "swap_hat",
    },
    green_mushroomhat =
    {
        buildfile = "hat_green_mushroom",
        buildsymbol = "swap_hat",
    },
    blue_mushroomhat =
    {
        buildfile = "hat_blue_mushroom",
        buildsymbol = "swap_hat",
    },
    hivehat =
    {
        buildfile = "hat_hive",
        buildsymbol = "swap_hat",
    },
    dragonheadhat =
    {
        buildfile = "hat_dragonhead",
        buildsymbol = "swap_hat",
    },
    dragonbodyhat =
    {
        buildfile = "hat_dragonbody",
        buildsymbol = "swap_hat",
    },
    dragontailhat =
    {
        buildfile = "hat_dragontail",
        buildsymbol = "swap_hat",
    },
    goggleshat =
    {
        isopentop = true,
        buildfile = "hat_goggles",
        buildsymbol = "swap_hat",
    },
    deserthat =
    {
        buildfile = "hat_desert",
        buildsymbol = "swap_hat",
    },
    skeletonhat =
    {
        buildfile = "hat_skeleton",
        buildsymbol = "swap_hat",
    },
    walterhat =
    {
        buildfn = function(dressup, item, buildskin)
            local itemswap = {}

            if dressup.inst.prefab == "walter" then
                itemswap["swap_hat"] = dressup:GetDressData(
                    buildskin, "hat_walter", "swap_hat", item.GUID, "swap"
                )
            else
                itemswap["swap_hat"] = dressup:GetDressData(
                    buildskin, "hat_walter", "swap_hat_large", item.GUID, "swap"
                )
            end
            itemswap["HAT"] = dressup:GetDressData(nil, nil, nil, nil, "show")
            itemswap["HAIR_HAT"] = dressup:GetDressData(nil, nil, nil, nil, "show")
            itemswap["HAIR_NOHAT"] = dressup:GetDressData(nil, nil, nil, nil, "hide")
            itemswap["HAIR"] = dressup:GetDressData(nil, nil, nil, nil, "hide")

            itemswap["HEAD"] = dressup:GetDressData(nil, nil, nil, nil, "hide")
            itemswap["HEAD_HAT"] = dressup:GetDressData(nil, nil, nil, nil, "show")

            return itemswap
        end,
    },
    kelphat =
    {
        isopentop = true,
        buildfile = "hat_kelp",
        buildsymbol = "swap_hat",
    },
    mermhat =
    {
        isopentop = true,
        buildfile = "hat_merm",
        buildsymbol = "swap_hat",
    },
    cookiecutterhat =
    {
        buildfile = "hat_cookiecutter",
        buildsymbol = "swap_hat",
    },
    batnosehat =
    {
        isnoskin = true,
        buildfile = "hat_batnose",
        buildsymbol = "swap_hat",
    },
    slurper = --啜食者
    {
        isnoskin = true,
        buildfile = "hat_slurper",
        buildsymbol = "swap_hat",
        equipfn = function(player, item)
            --幻化前需要关闭发光，防止玩家发光
            if item._light ~= nil and item._light.Light ~= nil then
                item._light.Light:Enable(false)
            end
        end,
        unequipfn = function(player, item)
            --取消幻化后需要恢复发光
            if item._light ~= nil and item._light.Light ~= nil then
                item._light.Light:Enable(true)
            end
        end,
    },
    perd = --火鸡
    {
        isnoskin = true,
        dressslot = EQUIPSLOTS.HEAD,
        buildfile = "hat_straw_perd",
        buildsymbol = "swap_hat",
    },
    plantregistryhat = --农研帽
    {
        buildfile = "hat_plantregistry",
        buildsymbol = "swap_hat",
    },
    nutrientsgoggleshat = --远古农研帽
    {
        buildfile = "hat_nutrientsgoggles",
        buildsymbol = "swap_hat",
    },

    -------------------------------
    --身体-------------------------
    -------------------------------

    armorwood =
    {
        buildfile = "armor_wood",
        buildsymbol = "swap_body",
    },
    armorgrass =
    {
        buildfile = "armor_grass",
        buildsymbol = "swap_body",
    },
    armordragonfly =
    {
        buildfile = "torso_dragonfly",
        buildsymbol = "swap_body",
    },
    armorslurper =
    {
        buildfile = "armor_slurper",
        buildsymbol = "swap_body",
    },
    armorskeleton =
    {
        buildfile = "armor_skeleton",
        buildsymbol = "swap_body",
    },
    armor_sanity =
    {
        buildfile = "armor_sanity",
        buildsymbol = "swap_body",
    },
    armorruins =
    {
        buildfile = "armor_ruins",
        buildsymbol = "swap_body",
    },
    armormarble =
    {
        buildfile = "armor_marble",
        buildsymbol = "swap_body",
    },
    armorsnurtleshell =
    {
        istallbody = true,
        buildfile = "armor_slurtleshell",
        buildsymbol = "swap_body_tall",
    },
    backpack =
    {
        isbackpack = true,
        buildfile = "swap_backpack",
    },
    krampus_sack =
    {
        isbackpack = true,
        buildfile = "swap_krampus_sack",
    },
    candybag =
    {
        isbackpack = true,
        buildfile = "candybag",
    },
    piggyback =
    {
        isbackpack = true,
        buildfile = "swap_piggyback",
    },
    icepack =
    {
        isbackpack = true,
        buildfile = "swap_icepack",
    },
    onemanband =
    {
        istallbody = true,
        buildfile = "swap_one_man_band",
        buildsymbol = "swap_body_tall",
    },
    amulet =
    {
        buildfn = function(dressup, item, buildskin)
            local itemswap = {}

            if buildskin ~= nil then
                itemswap["swap_body"] = dressup:GetDressData(
                    buildskin, "torso_amulets", "swap_body", item.GUID, "swap"
                )
            else
                itemswap["swap_body"] = dressup:GetDressData(
                    buildskin, "torso_amulets", "redamulet", item.GUID, "swap"
                )
            end
            itemswap["backpack"] = dressup:GetDressData(nil, nil, nil, nil, "clear")

            return itemswap
        end,
    },
    blueamulet =
    {
        buildfile = "torso_amulets",
        buildsymbol = "blueamulet",
    },
    purpleamulet =
    {
        buildfile = "torso_amulets",
        buildsymbol = "purpleamulet",
    },
    greenamulet =
    {
        buildfile = "torso_amulets",
        buildsymbol = "greenamulet",
    },
    orangeamulet =
    {
        buildfile = "torso_amulets",
        buildsymbol = "orangeamulet",
    },
    yellowamulet =
    {
        buildfile = "torso_amulets",
        buildsymbol = "yellowamulet",
    },
    raincoat =
    {
        buildfile = "torso_rain",
        buildsymbol = "swap_body",
    },
    sweatervest =
    {
        buildfile = "armor_sweatervest",
        buildsymbol = "swap_body",
    },
    trunkvest_summer =
    {
        buildfile = "armor_trunkvest_summer",
        buildsymbol = "swap_body",
    },
    trunkvest_winter =
    {
        buildfile = "armor_trunkvest_winter",
        buildsymbol = "swap_body",
    },
    reflectivevest =
    {
        buildfile = "torso_reflective",
        buildsymbol = "swap_body",
    },
    hawaiianshirt =
    {
        buildfile = "torso_hawaiian",
        buildsymbol = "swap_body",
    },
    beargervest =
    {
        buildfile = "torso_bearger",
        buildsymbol = "swap_body",
    },
    cavein_boulder =
    {
        isnoskin = true,
        istallbody = true,
        buildfn = function(dressup, item, buildskin)
            local itemswap = {}

            itemswap["swap_body_tall"] = dressup:GetDressData(
                buildskin, "swap_cavein_boulder", "swap_body"..tostring(item.variation or ""), item.GUID, "swap"
            )

            return itemswap
        end,
    },
    sunkenchest = --上锁的贝壳宝箱
    {
        isnoskin = true,
        istallbody = true,
        buildfile = "swap_sunken_treasurechest",
        buildsymbol = "swap_body",
    },
    shell_cluster = --贝壳垃圾堆
    {
        isnoskin = true,
        istallbody = true,
        buildfile = "singingshell_cluster",
        buildsymbol = "swap_body",
    },
    glassspike_short = --小尖玻璃雕塑
    {
        isnoskin = true,
        istallbody = true,
        buildfile = "swap_glass_spike",
        buildsymbol = "swap_body_short",
    },
    glassspike_med = --中尖玻璃雕塑
    {
        isnoskin = true,
        istallbody = true,
        buildfile = "swap_glass_spike",
        buildsymbol = "swap_body_med",
    },
    glassspike_tall = --大尖玻璃雕塑
    {
        isnoskin = true,
        istallbody = true,
        buildfile = "swap_glass_spike",
        buildsymbol = "swap_body_tall",
    },
    glassblock = --钝玻璃雕塑
    {
        isnoskin = true,
        istallbody = true,
        buildfile = "swap_glass_block",
        buildsymbol = "swap_body",
    },
    armor_bramble = --荆棘甲
    {
        buildfile = "armor_bramble",
        buildsymbol = "swap_body",
    },
    spicepack =
    {
        isbackpack = true,
        buildfile = "swap_chefpack",
    },
    seedpouch =
    {
        isbackpack = true,
        buildfile = "seedpouch",
    },
    -- moon_altar --月科技系列的可搬动建筑，独一无二的，不能幻化
    -- sculpture_knighthead = --骑士的大理石碎片。全图唯一性，不做幻化
    -- {
    --     isnoskin = true,
    --     buildfile = "swap_sculpture_knighthead",
    --     buildsymbol = "swap_body",
    -- },
    -- sculpture_bishophead = --主教的大理石碎片。全图唯一性，不做幻化
    -- {
    --     isnoskin = true,
    --     buildfile = "swap_sculpture_bishophead",
    --     buildsymbol = "swap_body",
    -- },
    -- sculpture_rooknose = --战车的大理石碎片。全图唯一性，不做幻化
    -- {
    --     isnoskin = true,
    --     buildfile = "swap_sculpture_rooknose",
    --     buildsymbol = "swap_body",
    -- },

    -------------------------------
    --棱镜-------------------------
    -------------------------------

    agronssword = --tip：通过幻化就可以把这把剑带到其他世界啦！
    {
        isnoskin = true,
        buildfile = "swap_agronssword",
        buildsymbol = "swap_agronssword",
    },
    backcub =
    {
        isnoskin = true,
        buildfn = function(dressup, item, buildskin)
            local itemswap = {}

            if dressup.inst.prefab == "webber" then
                itemswap["swap_body_tall"] = dressup:GetDressData(
                    buildskin, "swap_backcub", "swap_body", item.GUID, "swap"
                )
            else
                itemswap["swap_body"] = dressup:GetDressData(
                    buildskin, "swap_backcub", "swap_body", item.GUID, "swap"
                )
                itemswap["backpack"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
            end

            return itemswap
        end,
        unbuildfn = function(dressup, item)
            if dressup.inst.prefab == "webber" then
                dressup:InitClear("swap_body_tall")
            else
                dressup:InitClear("swap_body")
                dressup:InitClear("backpack")
            end
        end,
    },
    boltwingout =
    {
        isnoskin = true,
        buildfile = "swap_boltwingout",
        buildsymbol = "swap_body",
    },
    -- book_weather --该道具贴图切换比较特殊，不做幻化
    desertdefense =
    {
        isnoskin = true,
        buildfile = "swap_desertdefense",
        buildsymbol = "swap_desertdefense",
    },
    dualwrench =
    {
        isnoskin = true,
        buildfile = "swap_dualwrench",
        buildsymbol = "swap_dualwrench",
    },
    fimbul_axe =
    {
        isnoskin = true,
        buildfile = "swap_fimbul_axe",
        buildsymbol = "swap_fimbul_axe",
    },
    giantsfoot =
    {
        isnoskin = true,
        isbackpack = true,
        buildfile = "giantsfoot",
        buildsymbol = "swap_body",
    },
    hat_albicans_mushroom =
    {
        isnoskin = true,
        buildfile = "hat_albicans_mushroom",
        buildsymbol = "swap_hat",
    },
    hat_cowboy =
    {
        isnoskin = true,
        buildfn = function(dressup, item, buildskin)
            local itemswap = {}

            itemswap["swap_hat"] = dressup:GetDressData(
                buildskin, "hat_cowboy", "swap_hat", item.GUID, "swap"
            )
            itemswap["HAT"] = dressup:GetDressData(nil, nil, nil, nil, "show")
            itemswap["HAIR_HAT"] = dressup:GetDressData(nil, nil, nil, nil, "show")
            itemswap["HAIR_NOHAT"] = dressup:GetDressData(nil, nil, nil, nil, "hide")
            itemswap["HAIR"] = dressup:GetDressData(nil, nil, nil, nil, "hide")

            itemswap["HEAD"] = dressup:GetDressData(nil, nil, nil, nil, "hide")
            itemswap["HEAD_HAT"] = dressup:GetDressData(nil, nil, nil, nil, "show")

            --增加牛仔围巾的贴图
            itemswap["swap_body"] = dressup:GetDressData(
                buildskin, "scarf_cowboy", "swap_body", item.GUID, "swap"
            )

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

            --还原牛仔围巾的效果
            dressup:InitClear("swap_body")
        end,
    },
    hat_lichen =
    {
        isnoskin = true,
        isopentop = true,
        buildfile = "hat_lichen",
        buildsymbol = "swap_hat",
    },
    hat_mermbreathing =
    {
        isnoskin = true,
        isopentop = true,
        buildfile = "hat_mermbreathing",
        buildsymbol = "swap_hat",
    },
    lileaves =
    {
        isnoskin = true,
        buildfile = "swap_lileaves",
        buildsymbol = "swap_lileaves",
    },
    neverfade =
    {
        isnoskin = true,
        buildfn = function(dressup, item, buildskin)
            local itemswap = {}

            if item.hasSetBroken then
                itemswap["swap_object"] = dressup:GetDressData(
                    buildskin, "swap_neverfade_broken", "swap_neverfade_broken", item.GUID, "swap"
                )
            else
                itemswap["swap_object"] = dressup:GetDressData(
                    buildskin, "swap_neverfade", "swap_neverfade", item.GUID, "swap"
                )
            end
            itemswap["whipline"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
            itemswap["lantern_overlay"] = dressup:GetDressData(nil, nil, nil, nil, "clear")

            return itemswap
        end,
    },
    orchitwigs =
    {
        isnoskin = true,
        buildfile = "swap_orchitwigs",
        buildsymbol = "swap_orchitwigs",
    },
    pinkstaff =
    {
        isnoskin = true,
        buildfile = "swap_pinkstaff",
        buildsymbol = "swap_pinkstaff",
    },
    refractedmoonlight = --tip：通过幻化就可以把这把剑带到其他世界啦！
    {
        isnoskin = true,
        buildfile = "swap_refractedmoonlight",
        buildsymbol = "swap_refractedmoonlight",
    },
    rosorns =
    {
        isnoskin = true,
        buildfile = "swap_rosorns",
        buildsymbol = "swap_rosorns",
    },
    sachet =
    {
        isnoskin = true,
        buildfile = "sachet",
        buildsymbol = "swap_body",
    },
    tripleshovelaxe =
    {
        isnoskin = true,
        buildfile = "swap_tripleshovelaxe",
        buildsymbol = "swap_tripleshovelaxe",
    },
    theemperorscrown =
    {
        isnoskin = true,
        buildfn = function(dressup, item, buildskin)
            local itemswap = {}

            itemswap["swap_hat"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
            itemswap["HAT"] = dressup:GetDressData(nil, nil, nil, nil, "show")
            itemswap["HAIR_HAT"] = dressup:GetDressData(nil, nil, nil, nil, "hide")
            itemswap["HAIR_NOHAT"] = dressup:GetDressData(nil, nil, nil, nil, "show")
            itemswap["HAIR"] = dressup:GetDressData(nil, nil, nil, nil, "show")

            itemswap["HEAD"] = dressup:GetDressData(nil, nil, nil, nil, "show")
            itemswap["HEAD_HAT"] = dressup:GetDressData(nil, nil, nil, nil, "hide")

            return itemswap
        end,
        unbuildfn = function(dressup, item) end, --没啥好恢复的
    },
    theemperorsmantle =
    {
        isnoskin = true,
        istallbody = true,
        buildfn = function(dressup, item, buildskin)
            local itemswap = {}

            itemswap["swap_body_tall"] = dressup:GetDressData(nil, nil, nil, nil, "clear")

            return itemswap
        end,
        unbuildfn = function(dressup, item) end, --没啥好恢复的
    },
    theemperorspendant =
    {
        isnoskin = true,
        buildfn = function(dressup, item, buildskin)
            local itemswap = {}

            itemswap["backpack"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
            itemswap["swap_body"] = dressup:GetDressData(nil, nil, nil, nil, "clear")

            return itemswap
        end,
        unbuildfn = function(dressup, item) end, --没啥好恢复的
    },
    theemperorsscepter =
    {
        isnoskin = true,
        buildfn = function(dressup, item, buildskin)
            local itemswap = {}

            itemswap["swap_object"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
            itemswap["whipline"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
            itemswap["lantern_overlay"] = dressup:GetDressData(nil, nil, nil, nil, "clear")

            return itemswap
        end,
        unbuildfn = function(dressup, item) end, --没啥好恢复的
    },
}

if not _G.rawget(_G, "DRESSUP_DATA_LEGION") then
    _G.DRESSUP_DATA_LEGION = {}
end
for k,v in pairs(dressup_data) do
    _G.DRESSUP_DATA_LEGION[k] = v

    -- if v.isnorecipe then --增加统一配方，让幻象法杖能生效
    --     AddRecipe(k,
    --     {
    --         Ingredient("nightmarefuel", 1),
    --     },
    --     nil, TECH.LOST, nil, nil, true)
    -- end
end

--统一添加各种雕像的幻化数据
local pieces =
{
    "pawn",
    "rook",
    "knight",
    "bishop",
    "muse",
    "formal",
    "hornucopia",
    "pipe",

    "deerclops",
    "bearger",
    "moosegoose",
    "dragonfly",
    "clayhound",
    "claywarg",
    "butterfly",
    "anchor",
    "moon",
    "carrat",
    "beefalo",
    "crabking",
    "malbatross",
    "toadstool",
    "stalker",
    "klaus",
    "beequeen",
    "antlion",
    "minotaur",
}
local materials =
{
    "marble", "stone", "moonglass",
}
for k,v in pairs(pieces) do
    _G.DRESSUP_DATA_LEGION["chesspiece_"..v] =
    {
        isnoskin = true,
        istallbody = true,
        buildfn = function(dressup, item, buildskin)
            local itemswap = {}

            if item.materialid ~= nil and materials[item.materialid] ~= nil then
                itemswap["swap_body_tall"] = dressup:GetDressData(
                    buildskin, "swap_chesspiece_"..v.."_"..materials[item.materialid], "swap_body", item.GUID, "swap"
                )
            end

            return itemswap
        end,
    }
end

--统一添加各种巨型作物的幻化数据
local oversizecrops =
{
    asparagus = "farm_plant_asparagus",
    garlic = "farm_plant_garlic",
    pumpkin = "farm_plant_pumpkin",
    corn = "farm_plant_corn_build",
    onion = "farm_plant_onion_build",
    potato = "farm_plant_potato",
    dragonfruit = "farm_plant_dragonfruit_build",
    pomegranate = "farm_plant_pomegranate_build",
    eggplant = "farm_plant_eggplant_build",
    tomato = "farm_plant_tomato",
    watermelon = "farm_plant_watermelon_build",
    pepper = "farm_plant_pepper",
    durian = "farm_plant_durian_build",
    carrot = "farm_plant_carrot",
}
if CONFIGS_LEGION.ENABLEDMODS.MythWords then
    oversizecrops["gourd"] = "farm_plant_gourd"
end
if CONFIGS_LEGION.LEGENDOFFALL then
    oversizecrops["pineananas"] = "farm_plant_pineananas"
end
for k,v in pairs(oversizecrops) do
    _G.DRESSUP_DATA_LEGION[k.."_oversized"] =
    {
        isnoskin = true,
        istallbody = true,
        buildfn = function(dressup, item, buildskin)
            local itemswap = {}

            itemswap["swap_body_tall"] = dressup:GetDressData(
                buildskin, v, "swap_body", item.GUID, "swap"
            )

            return itemswap
        end,
    }
    _G.DRESSUP_DATA_LEGION[k.."_oversized_waxed"] = _G.DRESSUP_DATA_LEGION[k.."_oversized"]
end

-------------------
-------------------

if not IsServer then
    return
end

--------------------------------------------------------------------------
--[[ 切换symbol时固定为幻化的装饰 ]]
--------------------------------------------------------------------------

local SymbolCommDealFn = function(inst, animstate, symbol)
    if inst.components.dressup ~= nil and inst.components.dressup.swaplist[symbol] ~= nil then
        local swapdata = inst.components.dressup.swaplist[symbol]
        if swapdata.type == "swap" then
            if swapdata.buildskin ~= nil then
                animstate:OverrideItemSkinSymbol(
                    symbol,
                    swapdata.buildskin,
                    swapdata.buildsymbol,
                    swapdata.guid,
                    swapdata.buildfile
                )
            else
                animstate:OverrideSymbol(symbol, swapdata.buildfile, swapdata.buildsymbol)
            end
        elseif swapdata.type == "clear" then
            animstate:ClearOverrideSymbol(symbol)
        elseif swapdata.type == "show" then
            animstate:Show(symbol)
        else
            animstate:Hide(symbol)
        end
        return true
    else
        return false
    end
end

local hook_OverrideSymbol = UserDataHook.MakeHook("AnimState","OverrideSymbol",
    function(inst, symbol, ...)
        -- print(build)
        return SymbolCommDealFn(inst, inst.userdatas.AnimState, symbol)
    end
)
local hook_OverrideItemSkinSymbol = UserDataHook.MakeHook("AnimState","OverrideItemSkinSymbol",
    function(inst, symbol, ...)
        return SymbolCommDealFn(inst, inst.userdatas.AnimState, symbol)
    end
)
local hook_ClearOverrideSymbol = UserDataHook.MakeHook("AnimState","ClearOverrideSymbol",
    function(inst, symbol, ...)
        return SymbolCommDealFn(inst, inst.userdatas.AnimState, symbol)
    end
)
local hook_Show = UserDataHook.MakeHook("AnimState","Show",
    function(inst, symbol, ...)
        return SymbolCommDealFn(inst, inst.userdatas.AnimState, symbol)
    end
)
local hook_Hide = UserDataHook.MakeHook("AnimState","Hide",
    function(inst, symbol, ...)
        return SymbolCommDealFn(inst, inst.userdatas.AnimState, symbol)
    end
)
AddPlayerPostInit(function(inst)
    UserDataHook.Hook(inst, hook_OverrideSymbol)
    UserDataHook.Hook(inst, hook_OverrideItemSkinSymbol)
    UserDataHook.Hook(inst, hook_ClearOverrideSymbol)
    UserDataHook.Hook(inst, hook_Show)
    UserDataHook.Hook(inst, hook_Hide)

    inst.AnimState:Hide("LANTERN_OVERLAY") --人物默认清除提灯光效贴图，防止幻化的提灯显示出问题
    inst:AddComponent("dressup")
end)

--知识点，就不删除了
-- AddPlayerPostInit(function(inst)
--     local AnimState = getmetatable(inst.AnimState).__index
--     local OverrideSymbol_old = AnimState.OverrideSymbol
-- end)
