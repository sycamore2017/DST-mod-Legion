local _G = GLOBAL
local TOOLS_L = require("tools_legion")
local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()

--------------------------------------------------------------------------
--[[ 装备套装数据，套装仅指护甲与头盔 ]]
--------------------------------------------------------------------------

_G.EQUIPMENTSETNAMES.SIVING = "siving"
_G.EQUIPMENTSETNAMES.SIVING2 = "siving2"
_G.EQUIPMENTSETNAMES.ELEPHEETLE = "elepheetle"

--------------------------------------------------------------------------
--[[ 修改基础函数以给生物添加触电组件 ]]
--------------------------------------------------------------------------

local function CanShockable(inst)
    return (inst:HasTag("player")
           or inst:HasTag("character")
           or inst:HasTag("hostile")
           or inst:HasTag("smallcreature")
           or inst:HasTag("largecreature")
           or inst:HasTag("animal")
           or inst:HasTag("monster"))
           and not inst:HasTag("shadowcreature")    --暗影生物不会被触电
           and not inst:HasTag("electrified")       --电气生物不会被触电
           and not inst:HasTag("lightninggoat")     --电羊不会被触电
end
local function AddShockable(inst, level)
    if not CanShockable(inst) then
        return
    end
    local symbol = nil
    local x, y, z = 0, 0, 0
    local cpt = inst.components.burnable
    if cpt ~= nil then
        for _, v in pairs(cpt.fxdata) do
            if v.follow ~= nil then
                symbol = v.follow
                -- level = cpt.fxlevel
                x = v.x
                y = v.y
                z = v.z
                break
            end
        end
    end
    if symbol == nil or symbol == "" then
        cpt = inst.components.freezable
        if cpt ~= nil then
            for _, v in pairs(cpt.fxdata) do
                if v.follow ~= nil then
                    symbol = v.follow
                    -- level = cpt.fxlevel
                    x = v.x
                    y = v.y
                    z = v.z
                    break
                end
            end
        end
        if symbol == nil or symbol == "" then
            cpt = inst.components.combat
            if cpt ~= nil then
                symbol = cpt.hiteffectsymbol
            end
        end
    end
    if inst.components.shockable == nil then
        inst:AddComponent("shockable")
    end
    if z == 0 then
        z = 1
    end
    inst.components.shockable:InitStaticFx(symbol, Vector3(x or 0, y or 0, z), level or 1)
end

local MakeSmallBurnableCharacter_old = MakeSmallBurnableCharacter
_G.MakeSmallBurnableCharacter = function(inst, sym, offset)
    local burnable, propagator = MakeSmallBurnableCharacter_old(inst, sym, offset)
    AddShockable(inst, 1)
    return burnable, propagator
end

local MakeMediumBurnableCharacter_old = MakeMediumBurnableCharacter
_G.MakeMediumBurnableCharacter = function(inst, sym, offset)
    local burnable, propagator = MakeMediumBurnableCharacter_old(inst, sym, offset)
    AddShockable(inst, 2)
    return burnable, propagator
end

local MakeLargeBurnableCharacter_old = MakeLargeBurnableCharacter
_G.MakeLargeBurnableCharacter = function(inst, sym, offset)
    local burnable, propagator = MakeLargeBurnableCharacter_old(inst, sym, offset)
    AddShockable(inst, 3)
    return burnable, propagator
end

local MakeTinyFreezableCharacter_old = MakeTinyFreezableCharacter
_G.MakeTinyFreezableCharacter = function(inst, sym, offset)
    local freezable = MakeTinyFreezableCharacter_old(inst, sym, offset)
    AddShockable(inst, 1)
    return freezable
end

local MakeSmallFreezableCharacter_old = MakeSmallFreezableCharacter
_G.MakeSmallFreezableCharacter = function(inst, sym, offset)
    local freezable = MakeSmallFreezableCharacter_old(inst, sym, offset)
    AddShockable(inst, 1)
    return freezable
end

local MakeMediumFreezableCharacter_old = MakeMediumFreezableCharacter
_G.MakeMediumFreezableCharacter = function(inst, sym, offset)
    local freezable = MakeMediumFreezableCharacter_old(inst, sym, offset)
    AddShockable(inst, 2)
    return freezable
end

local MakeLargeFreezableCharacter_old = MakeLargeFreezableCharacter
_G.MakeLargeFreezableCharacter = function(inst, sym, offset)
    local freezable = MakeLargeFreezableCharacter_old(inst, sym, offset)
    AddShockable(inst, 2)
    return freezable
end

local MakeHugeFreezableCharacter_old = MakeHugeFreezableCharacter
_G.MakeHugeFreezableCharacter = function(inst, sym, offset)
    local freezable = MakeHugeFreezableCharacter_old(inst, sym, offset)
    AddShockable(inst, 3)
    return freezable
end

--------------------------------------------------------------------------
--[[ 新增作物 ]]
--------------------------------------------------------------------------

------松萝

--新增作物植株设定（会自动生成对应prefab）
local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS
PLANT_DEFS.pineananas = {
    --贴图与动画
    build = "farm_plant_pineananas", bank = "farm_plant_pineananas",
    --生长时间
    grow_time = PLANT_DEFS.dragonfruit.grow_time,
    --需水量：低
    moisture = PLANT_DEFS.carrot.moisture,
    --喜好季节
    good_seasons = { autumn = true, summer = true },
    --需肥类型
	nutrient_consumption = { TUNING.FARM_PLANT_CONSUME_NUTRIENT_LOW, 0, TUNING.FARM_PLANT_CONSUME_NUTRIENT_LOW },
	--会生成的肥料
	nutrient_restoration = { nil, true, nil },
    --扫兴容忍度
	max_killjoys_tolerance = TUNING.FARM_PLANT_KILLJOY_TOLERANCE,
    --是否随机种子
    is_randomseed = false,
    --是否防火
    fireproof = false,
    --重量范围
    weight_data	= { 422.22, 700.22, 0.93 },
    --音效
    sounds = PLANT_DEFS.pepper.sounds,
    --作物 代码名称
	prefab = "farm_plant_pineananas",
    --产物 代码名称
	product = "pineananas",
	--巨型产物 代码名称
	product_oversized = "pineananas_oversized",
	--种子 代码名称
	seed = "pineananas_seeds",
	--家族标签
	plant_type_tag = "farm_plant_pineananas",
    --巨型产物腐烂后的收获物
    loot_oversized_rot = { "spoiled_food", "spoiled_food", "spoiled_food", "pineananas_seeds",
        "fruitfly", "fruitfly", "pinecone" },
    --家族化所需数量：4
	family_min_count = TUNING.FARM_PLANT_SAME_FAMILY_MIN,
	--家族化检索距离：5
	family_check_dist = TUNING.FARM_PLANT_SAME_FAMILY_RADIUS + 1,
    --状态的net(如果你的植物状态超过了7个阶段 换别的net)
	stage_netvar = PLANT_DEFS.pepper.stage_netvar,
    --界面相关(官方支持mod使用自己的界面)
    plantregistrywidget = PLANT_DEFS.pepper.plantregistrywidget,
	plantregistrysummarywidget = PLANT_DEFS.pepper.plantregistrysummarywidget,
    --图鉴里玩家的庆祝动作
    pictureframeanim = PLANT_DEFS.pepper.pictureframeanim,
    --生长状态(hidden 表示这个阶段不显示)
    plantregistryinfo = PLANT_DEFS.pepper.plantregistryinfo
}

--------------------------------------------------------------------------
--[[ 打窝器材料表 ]]
--------------------------------------------------------------------------

if not _G.rawget(_G, "FISHHOMING_INGREDIENTS_L") then
    _G.FISHHOMING_INGREDIENTS_L = {}
end

local fishhoming_ingredients = {
    cutgrass =              { dusty=1, pasty=1, veggie=0.5 }, --采下的草
    twigs =                 { pasty=1, hardy=1, veggie=0.5 }, --树枝
    log =                   { hardy=1, veggie=0.5 }, --木头
    rocks =                 { hardy=1 }, --石头
    flint =                 { dusty=1, hardy=1 }, --燧石
    ice =                   { pasty=1, hardy=1 }, --冰
    ash =                   { dusty=1 }, --灰烬
    silk =                  { pasty=1 }, --蜘蛛丝
    beefalowool =           { dusty=1 }, --牛毛
    spoiled_food =          { pasty=1, rotten=0.5 }, --腐烂物(龙虾)
    poop =                  { pasty=1, rotten=1 }, --粪肥(龙虾)
    stinger =               { dusty=1, frizzy=0.5 }, --蜂刺(海鹦鹉)
    goldnugget =            { hardy=1, lucky=1, shiny=0.5 }, --金块(金锦鲤、花锦鲤、鱿鱼)
    lucky_goldnugget =      { hardy=1, lucky=1, shiny=0.5 }, --幸运黄金(金锦鲤、花锦鲤、鱿鱼)
    livinglog =             { pasty=1, hardy=1, veggie=1 }, --活木头
    cutreeds =              { pasty=1, hardy=1, veggie=0.5 }, --采下的芦苇
    redgem =                { hardy=1, hot=1 }, --红宝石(炽热太阳鱼)
    bluegem =               { hardy=1, frozen=1 }, --蓝宝石(冰鲷鱼)
    purplegem =             { hardy=1, hot=0.5, frozen=0.5 }, --紫宝石(炽热太阳鱼、冰鲷鱼)
    orangegem =             { hardy=1 }, --橙宝石
    yellowgem =             { hardy=1, shiny=1 }, --黄宝石(鱿鱼)
    greengem =              { hardy=1 }, --绿宝石
    opalpreciousgem =       { hardy=1, shiny=1, rusty=1 }, --彩虹宝石(鱿鱼、月光龙虾)
    moonglass =             { dusty=1, hardy=1, rusty=1 }, --月亮碎片(月光龙虾)
    moonglass_charged =     { hardy=1, rusty=1, shiny=0.5 }, --注能月亮碎片(月光龙虾、鱿鱼)
    moonrocknugget =        { hardy=1, rusty=1 }, --月岩(月光龙虾)
    moonstorm_spark =       { shiny=1, rusty=1 }, --月熠(鱿鱼、月光龙虾)
    marble =                { hardy=1 }, --大理石
    houndstooth =           { hardy=1, bloody=0.5 }, --犬牙
    nitre =                 { dusty=1, hardy=1, salty=0.5 }, --硝石(饼干切割机)
    saltrock =              { dusty=1, salty=1 }, --盐晶(饼干切割机)
    spidergland =           { pasty=1, monster=1 }, --蜘蛛腺
    siving_rocks =          { pasty=1, hardy=1 }, --子圭石
    feather_crow =          { dusty=1 }, --黑色羽毛
    feather_robin =         { dusty=1, hot=0.5 }, --红色羽毛(炽热太阳鱼)
    feather_robin_winter =  { pasty=1, frozen=0.5 }, --蓝色羽毛(冰鲷鱼)
    feather_canary =        { hardy=1, shiny=0.5 }, --黄色羽毛(鱿鱼)
    beardhair =             { dusty=1 }, --胡须
    charcoal =              { dusty=1, hardy=1, hot=0.5 }, --木炭(炽热太阳鱼)
    phlegm =                { pasty=1, slippery=1 }, --脓鼻涕(口水鱼)
    slurtleslime =          { pasty=1, slippery=1 }, --蛞蝓龟黏液(口水鱼)
    nightmarefuel =         { whispering=0.5 }, --噩梦燃料(一角鲸)
    horn =                  { hardy=1, whispering=1, lucky=0.5 }, --牛角(一角鲸、金锦鲤、花锦鲤)
    gnarwail_horn =         { hardy=1, whispering=1 }, --一角鲸的角(一角鲸)
    lightninggoathorn =     { hardy=1 }, --伏特羊角
    coontail =              { dusty=1, pasty=1, meat=0.5 }, --猫尾
    tentaclespots =         { pasty=1, meat=0.5, monster=1 }, --触手皮
    tentaclespike =         { pasty=2, hardy=2, meat=1, monster=2 }, --触手尖刺
    pigskin =               { pasty=1, meat=0.5 }, --猪皮
    manrabbit_tail =        { dusty=1, pasty=1, meat=0.5 }, --兔绒
    gears =                 { hardy=1 }, --齿轮
    purebrilliance =        { hardy=1, shiny=0.5, rusty=0.5 }, --纯粹辉煌(鱿鱼、月光龙虾)
    lunarplant_husk =       { pasty=1, hardy=1, veggie=0.5 }, --亮茄外壳
    voidcloth =             { dusty=1, pasty=1 }, --暗影碎布
    dreadstone =            { dusty=1, hardy=1, monster=1, whispering=0.5 }, --绝望石(一角鲸)
    horrorfuel =            { monster=1, whispering=1 }, --纯粹恐惧(一角鲸)
    cookiecuttershell =     { dusty=1, hardy=1, salty=1 }, --饼干切割机壳(饼干切割机)
    slurtle_shellpieces =   { hardy=1 }, --外壳碎片
    slurper_pelt =          { pasty=1, meat=0.5 }, --啜食者皮
    townportaltalisman =    { dusty=1, pasty=1, hardy=1 }, --沙之石
    driftwood_log =         { pasty=1, hardy=1, veggie=0.5 }, --浮木桩
    blackflag =             { hardy=1 }, --黑旗
    thulecite_pieces =      { hardy=1 }, --铥矿碎片
    messagebottleempty =    { dusty=1, hardy=1 }, --空瓶子
    messagebottle =         { dusty=1, pasty=1, hardy=1 }, --瓶中信
    carnival_prizeticket =  { dusty=1, pasty=1 }, --奖票
    wintersfeastfuel =      { rotten=0.5 }, --节日欢愉(龙虾)
    boneshard =             { hardy=1 }, --骨头碎片
    walrus_tusk =           { hardy=1 }, --海象牙
    walrushat =             { dusty=1, pasty=1 }, --贝雷帽
    waterplant_bomb =       { hardy=1, veggie=0.5 }, --种壳
    tourmalinecore =        { hardy=1, shiny=0.5 }, --电气石(鱿鱼)
    tourmalineshard =       { dusty=1, hardy=1 }, --带电的晶石
    fimbul_axe =            { hardy=1 }, --芬布尔斧
    scandata =              { pasty=1 }, --生物数据
    firepen =               { hardy=1, hot=1 }, --火焰笔(炽热太阳鱼)
    canary_poisoned =       { pasty=1, hardy=1, meat=1, shiny=0.5 }, --中毒金丝雀(鱿鱼)
    crow =                  { pasty=1, meat=1 }, --乌鸦
    puffin =                { pasty=1, meat=1 }, --海鹦鹉
    robin =                 { dusty=1, meat=1, hot=0.5 }, --红雀(炽热太阳鱼)
    robin_winter =          { pasty=1, meat=1, frozen=0.5 }, --雪雀(冰鲷鱼)
    canary =                { hardy=1, meat=1, shiny=1 }, --金丝雀(鱿鱼)
    bird_mutant =           { dusty=1, meat=1, rusty=0.5, rotten=0.5 }, --月盲乌鸦(月光龙虾、龙虾)
    bird_mutant_spitter =   { pasty=1, meat=1, rusty=0.5, rotten=0.5 }, --奇形鸟(月光龙虾、龙虾)
    rabbit =                { pasty=1, hardy=1, meat=1 }, --兔子
    lightbulb =             { dusty=1, pasty=1, veggie=0.5, shiny=1 }, --荧光果(鱿鱼)
    lightcrab =             { pasty=1, hardy=1, meat=1, shiny=1 }, --发光蟹(鱿鱼)
    fig =                   { pasty=1, veggie=1, sticky=1, grassy=0.5 }, --无花果(甜味鱼、草鳄鱼)
    fig_cooked =            { pasty=1, veggie=1, sticky=1 }, --烤无花果(甜味鱼)
    kelp =                  { pasty=1, veggie=1 }, --海带叶
    kelp_cooked =           { pasty=1, veggie=1 }, --熟海带叶
    kelp_dried =            { dusty=1, pasty=1, veggie=1, wrinkled=1 }, --干海带叶(落叶比目鱼)
    rock_avocado_fruit =    { hardy=1, veggie=1 }, --石果
    rock_avocado_fruit_ripe={ pasty=1, hardy=1, veggie=1, grassy=1 }, --成熟石果(草鳄鱼)
    rock_avocado_fruit_ripe_cooked={ pasty=1, veggie=1 }, --熟石果
    rock_avocado_fruit_sprout={ pasty=1, hardy=1, veggie=1, grassy=1 }, --发芽的石果(草鳄鱼)
    cactus_meat =           { pasty=1, veggie=1, grassy=1 }, --仙人掌肉(草鳄鱼)
    cactus_meat_cooked =    { pasty=1, veggie=1 }, --熟仙人掌肉
    petals_rose =           { pasty=1, veggie=1, fragrant=1 }, --蔷薇花瓣(花朵金枪鱼)
    petals_lily =           { pasty=1, veggie=1, fragrant=1 }, --蹄莲花瓣(花朵金枪鱼)
    petals_orchid =         { pasty=1, veggie=1, fragrant=1 }, --兰草花瓣(花朵金枪鱼)
    forgetmelots =          { veggie=0.5, fragrant=1 }, --必忘我(花朵金枪鱼)
    myth_lotus_flower =     { pasty=1, veggie=1, fragrant=1 }, --莲花(花朵金枪鱼)
    moon_tree_blossom =     { pasty=1, veggie=0.5, fragrant=1 }, --月树花(花朵金枪鱼)
    petals_evil =           { veggie=0.5, monster=1, evil=0.5 }, --深色花瓣(邪天翁)
    cutted_rosebush =       { pasty=1, hardy=1, veggie=0.5, grassy=0.5 }, --蔷薇折枝(草鳄鱼)
    cutted_lilybush =       { pasty=1, veggie=0.5, grassy=0.5 }, --蹄莲芽束(草鳄鱼)
    cutted_orchidbush =     { dusty=1, pasty=1, veggie=0.5, wrinkled=0.5, grassy=0.5 }, --兰草种籽(落叶比目鱼、草鳄鱼)
    dug_monstrain =         { pasty=1, hardy=1, veggie=0.5, monster=1 }, --雨竹块茎
    squamousfruit =         { pasty=1, hardy=1, veggie=0.5, monster=1 }, --鳞果
    monstrain_leaf =        { pasty=1, veggie=1, monster=2 }, --雨竹叶
    dragonfruit =           { pasty=1, veggie=1, hot=0.5 }, --火龙果(炽热太阳鱼)
    dragonfruit_cooked =    { pasty=1, veggie=1, hot=0.5 }, --熟火龙果(炽热太阳鱼)
    pepper =                { pasty=1, veggie=1, hot=0.5 }, --辣椒(炽热太阳鱼)
    pepper_cooked =         { dusty=1, pasty=1, veggie=1, hot=0.5 }, --烤辣椒(炽热太阳鱼)
    durian =                { pasty=1, hardy=1, veggie=1, monster=2, rotten=0.5 }, --榴莲(龙虾)
    durian_cooked =         { pasty=1, hardy=1, veggie=1, monster=2, rotten=0.5 }, --超臭榴莲(龙虾)
    pomegranate =           { pasty=1, hardy=1, veggie=1, bloody=0.5 }, --石榴(岩石大白鲨)
    pomegranate_cooked =    { pasty=1, hardy=1, veggie=1, bloody=0.5 }, --切片熟石榴(岩石大白鲨)
    watermelon =            { pasty=1, veggie=1, grassy=0.5 }, --西瓜(草鳄鱼)
    watermelon_cooked =     { pasty=1, veggie=1 }, --烤西瓜
    corn =                  { pasty=1, hardy=1, veggie=1 }, --玉米
    corn_cooked =           { pasty=1, hardy=1, veggie=1, comical=1 }, --爆米花(爆米花鱼、玉米鳕鱼)
    twiggy_nut =            { hardy=1, veggie=0.5 }, --多枝树种
    acorn =                 { hardy=1, veggie=0.5, grassy=0.5 }, --桦栗果(草鳄鱼)
    acorn_cooked =          { pasty=1, veggie=0.5 }, --烤桦栗果
    pinecone =              { dusty=1, hardy=1, veggie=0.5 }, --松果
    palmcone_seed =         { dusty=1, veggie=0.5 }, --棕榈松果树芽
    palmcone_scale =        { dusty=1, pasty=1, veggie=0.5 }, --棕榈松果树鳞片
    dug_rosebush =          { pasty=1, hardy=1, veggie=0.5 }, --蔷薇花丛
    dug_lilybush =          { pasty=1, veggie=0.5 }, --蹄莲花丛
    dug_orchidbush =        { dusty=1, pasty=1, veggie=0.5 }, --兰草花丛
    dug_berrybush =         { pasty=1, hardy=1, veggie=0.5 }, --浆果丛
    dug_berrybush2 =        { pasty=1, veggie=0.5 }, --特殊浆果丛
    dug_berrybush_juicy =   { pasty=1, veggie=0.5 }, --多汁浆果丛
    dug_grass =             { dusty=1, pasty=1, veggie=0.5 }, --草丛
    dug_marsh_bush =        { pasty=1, hardy=1, veggie=0.5 }, --尖刺灌木
    dug_monkeytail =        { pasty=1, hardy=1, veggie=0.5 }, --猴尾草
    dug_bananabush =        { pasty=1, veggie=0.5 }, --香蕉丛
    dug_rock_avocado_bush = { pasty=1, hardy=1, veggie=0.5 }, --石果灌木丛
    dug_sapling =           { pasty=1, hardy=1, veggie=0.5 }, --树苗
    dug_sapling_moon =      { pasty=1, hardy=1, veggie=0.5, rusty=0.5 }, --月岛树苗(月光龙虾)
    dug_trap_starfish =     { pasty=1, hardy=1, meat=0.5 }, --海星陷阱
    spore_small =           { shiny=1 }, --绿色孢子(鱿鱼)
    spore_medium =          { shiny=1 }, --红色孢子(鱿鱼)
    spore_tall =            { shiny=1 }, --蓝色孢子(鱿鱼)
    spore_moon =            { shiny=1, rusty=0.5 }, --月亮孢子(鱿鱼、月光龙虾)
    bird_egg =              { dusty=1, pasty=1, meat=0.5, slippery=1 }, --鸟蛋(口水鱼)
    bird_egg_cooked =       { dusty=1, pasty=1, meat=0.5 }, --熟鸟蛋
    egg =                   { dusty=1, pasty=1, meat=0.5, slippery=1 }, --蛋(口水鱼)
    egg_cooked =            { dusty=1, pasty=1, meat=0.5 }, --熟蛋
    tallbirdegg =           { pasty=1, hardy=1, meat=1, slippery=5 }, --高脚鸟蛋(口水鱼)
    tallbirdegg_cracked =   { pasty=1, hardy=1, meat=1, slippery=5 }, --孵化中的高脚鸟蛋(口水鱼)
    tallbirdegg_cooked =    { dusty=1, pasty=1, meat=1 }, --煎高脚鸟蛋
    batwing =               { pasty=1, meat=1, monster=1, whispering=0.5 }, --洞穴蝙蝠翅膀(一角鲸)
    batwing_cooked =        { pasty=1, meat=1, monster=1 }, --熟蝙蝠翅膀
    meat =                  { pasty=1, meat=1, bloody=1 }, --肉(岩石大白鲨)
    cookedmeat =            { pasty=1, meat=1 }, --熟肉
    meat_dried =            { hardy=1, meat=1, wrinkled=1 }, --肉干(落叶比目鱼)
    monstermeat =           { pasty=1, hardy=1, meat=1, monster=2, bloody=1 }, --怪物肉(岩石大白鲨)
    cookedmonstermeat =     { pasty=1, hardy=1, meat=1, monster=2 }, --熟怪物肉
    monstermeat_dried =     { hardy=1, meat=1, monster=2, wrinkled=1 }, --怪物肉干(落叶比目鱼)
    smallmeat =             { pasty=1, meat=1 }, --小肉
    cookedsmallmeat =       { pasty=1, meat=1 }, --熟小肉
    smallmeat_dried =       { hardy=1, meat=1, wrinkled=1 }, --小风干肉(落叶比目鱼)
    dish_duriantartare =    { pasty=2, meat=2, monster=4, bloody=2 }, --怪味鞑靼(岩石大白鲨)
    monstertartare =        { pasty=2, meat=2, monster=4, bloody=2 }, --怪物鞑靼(岩石大白鲨)
    shroom_skin =           { pasty=5, meat=2, monster=5, rotten=4, evil=5 }, --蘑菇皮(龙虾、邪天翁)
    compost =               { pasty=1, veggie=0.5, rotten=1 }, --堆肥(龙虾)
    spoiled_fish =          { pasty=1, hardy=1, meat=0.5, rotten=1 }, --变质的鱼(龙虾)
    spoiled_fish_small =    { pasty=1, hardy=1, meat=0.5, rotten=1 }, --变质的小鱼块(龙虾)
    guano =                 { dusty=1, rotten=1, salty=0.5 }, --鸟粪(龙虾、饼干切割机)
    rottenegg =             { pasty=1, hardy=1, rotten=1, slippery=1 }, --腐烂鸟蛋(龙虾、口水鱼)
    lightflier =            { dusty=1, pasty=1, meat=0.5, shiny=1, shaking=1 }, --球状光虫(鱿鱼、海黾)
    dragon_scales =         { hardy=5, hot=5, evil=5 }, --鳞片(炽热太阳鱼、邪天翁)
    lavae_egg =             { hardy=4, meat=4, hot=4, evil=4, frizzy=2 }, --岩浆虫卵(炽热太阳鱼、邪天翁、海鹦鹉)
    lavae_egg_cracked =     { hardy=4, meat=4, hot=5, evil=5, frizzy=2 }, --岩浆虫卵(炽热太阳鱼、邪天翁、海鹦鹉)
    lavae_cocoon =          { dusty=4, hardy=4, meat=2, evil=2, frizzy=2 }, --冷冻虫卵(邪天翁、海鹦鹉)
    honey =                 { pasty=1, sticky=1 }, --蜂蜜(甜味鱼)
    royal_jelly =           { pasty=1, sticky=5 }, --蜂王浆(甜味鱼)
    honeycomb =             { dusty=1, pasty=1, sticky=5 }, --蜂巢(甜味鱼)
    beeswax =               { dusty=1, hardy=1, sticky=5, wrinkled=0.5 }, --蜂蜡(甜味鱼、落叶比目鱼)
    butter =                { pasty=1, sticky=1 }, --黄油(甜味鱼)
    butterfly =             { dusty=1, meat=0.5, shaking=1 }, --蝴蝶(海黾)
    butterflywings =        { dusty=1, shaking=0.5 }, --蝴蝶翅膀(海黾)
    moonbutterfly =         { pasty=1, meat=0.5, shaking=1, frizzy=0.5, rusty=0.5 }, --月蛾(海黾、海鹦鹉、月光龙虾)
    moonbutterflywings =    { dusty=1, pasty=1, shaking=0.5, rusty=0.5 }, --月蛾翅膀(海黾、月光龙虾)
    wormlight =             { pasty=1, veggie=1, shiny=1, frizzy=0.5 }, --发光浆果(鱿鱼、海鹦鹉)
    wormlight_lesser =      { pasty=1, veggie=1, shiny=0.5, frizzy=0.5 }, --小发光浆果(鱿鱼、海鹦鹉)
    fireflies =             { dusty=1, meat=0.5, shaking=1, shiny=0.5 }, --萤火虫(海黾、鱿鱼)
    bee =                   { dusty=1, meat=0.5, shaking=1, frizzy=0.5 }, --蜜蜂(海黾、海鹦鹉)
    killerbee =             { dusty=1, pasty=1, meat=0.5, shaking=1 }, --杀人蜂(海黾)
    mosquitosack =          { pasty=1, bloody=1, frizzy=0.5 }, --蚊子血囊(岩石大白鲨、海鹦鹉)
    mosquito =              { pasty=1, meat=0.5, shaking=1, bloody=0.5 }, --蚊子(海黾、岩石大白鲨)
    raindonate =            { pasty=1, meat=0.5, shaking=1 }, --雨蝇(海黾)
    ahandfulofwings =       { dusty=1, pasty=1, shaking=0.5 }, --虫翅碎片(海黾)
    insectshell_l =         { dusty=1, hardy=1, frizzy=0.5 }, --虫甲碎片(海鹦鹉)
    glommerfuel =           { pasty=1, whispering=1, frizzy=0.5 }, --格罗姆的黏液(一角鲸、海鹦鹉)
    glommerwings =          { dusty=1, whispering=1, shaking=1 }, --格罗姆翅膀(一角鲸、海黾)
    glommerflower =         { pasty=5, whispering=5 }, --格罗姆花(一角鲸)
    fruitflyfruit =         { pasty=5, shaking=5, wrinkled=2 }, --友好果蝇果(海黾、落叶比目鱼)
    minotaurhorn =          { hardy=5, meat=2, evil=5 }, --守护者之角(邪天翁)
    malbatross_feather =    { pasty=2, hardy=2, evil=2 }, --邪天翁羽毛(邪天翁)
    malbatross_beak =       { hardy=5, evil=5 }, --邪天翁喙(邪天翁)
    deerclops_eyeball =     { pasty=5, meat=5, monster=6, evil=5, frozen=2 }, --独眼巨鹿眼球(邪天翁、冰鲷鱼)
    bearger_fur =           { pasty=5, monster=5, evil=5 }, --熊皮(邪天翁)
    furtuft =               { dusty=1, evil=0.5 }, --毛丛(邪天翁)
    goose_feather =         { dusty=2, evil=2 }, --麋鹿鹅羽毛(邪天翁)
    milkywhites =           { pasty=2, monster=2, evil=2, sticky=1 }, --乳白物(邪天翁、甜味鱼)
    -- xx =             { dusty=1, pasty=1, hardy=1 }, --
}
for name, data in pairs(fishhoming_ingredients) do
    _G.FISHHOMING_INGREDIENTS_L[name] = data
end
fishhoming_ingredients = nil

--冬季盛宴小食物
local basefactors = { hardy=1, pasty=1, dusty=1, veggie=1, meat=1, monster=1 }
for k = 1, _G.NUM_WINTERFOOD do
    _G.FISHHOMING_INGREDIENTS_L["winter_food"..tostring(k)] = basefactors
end
--爆米花鱼、玉米鳕鱼
basefactors = { hardy=1, pasty=1, dusty=1, comical=1 }
for k = 1, _G.NUM_TRINKETS do
    _G.FISHHOMING_INGREDIENTS_L["trinket_"..tostring(k)] = basefactors
end
basefactors = { hardy=1, pasty=1, dusty=1, monster=1, comical=1 }
for k = 1, _G.NUM_HALLOWEEN_ORNAMENTS do
    _G.FISHHOMING_INGREDIENTS_L["halloween_ornament_"..tostring(k)] = basefactors
end
basefactors = nil

--------------------------------------------------------------------------
--[[ 异种植物数据表 ]]
--------------------------------------------------------------------------

if not _G.rawget(_G, "CROPS_DATA_LEGION") then --对于global来说，不能直接检测是否有某个元素，需要用rawget才行
    _G.CROPS_DATA_LEGION = {}
end

local xmult = _G.CONFIGS_LEGION.X_GROWTHTIME or 1
local time_grow = TUNING.TOTAL_DAY_TIME*xmult
local time_crop = 12*TUNING.TOTAL_DAY_TIME*xmult --普通作物一般是5天生长期
local time_day1 = TUNING.TOTAL_DAY_TIME*xmult
local time_day2 = TUNING.TOTAL_DAY_TIME*(_G.CONFIGS_LEGION.X_OVERRIPETIME or 1)
xmult = nil

_G.CROPS_DATA_LEGION.carrot = {
    growthmults = { 1.2, 0.8, 1.2, 0.5 }, --春x秋冬。大于1为快，小于1为慢
    regrowstage = 1, --重新生长的阶段
    -- cangrowindrak = true, --能否在黑暗中生长(默认不能，false)。若不为true，晚上并且周围无光源时就无法生长
    -- nogrowinlight = true, --能否在阳光下生长(默认能，false)。若为true，白天或者周围有光源时就无法生长
    -- getsickchance = 0.007, --害虫产生率
    -- fireproof = false, --是否防火
    -- nomagicgrow = true, --是否禁止被魔法催熟
    -- dataonly = true, --是否不用通用预制物代码
    bank = "crop_legion_carrot", build = "crop_legion_carrot",
    leveldata = {
        { anim = "level1", time = time_crop*0.45, deadanim = "dead1", witheredprefab = nil },
        { anim = "level2", time = time_crop*0.55, deadanim = "dead1", witheredprefab = {"cutgrass"} },
        { anim = { "level3_1", "level3_2", "level3_3" }, time = time_day2*6, deadanim = "dead1", witheredprefab = {"cutgrass"} }
    },
    cluster_size = { 1, 1.5 },
    fn_loot = function(self, doer, ispicked, isburnt, loots)
        if self.stage == self.stage_max then
            self:GetBaseLoot(loots, {
                doer = doer, ispicked = ispicked, isburnt = isburnt,
                crop = self.cropprefab, crop_rot = "spoiled_food",
                lootothers = nil
            })
            if self.cluster >= 50 then
                self:AddLoot(loots, "lance_carrot_l", 1)
            end
        end
    end,
    fn_lootset = function(self, doer, ispicked, isburnt, loot)
        if doer ~= nil and (TheWorld == doer or doer.userid ~= nil) then
            for _, item in pairs(loot) do
                if item.prefab == "lance_carrot_l" then
                    self.inst.components.skinedlegion:SetLinkedSkin(item, "weapon", doer)
                end
            end
        end
    end
}
_G.CROPS_DATA_LEGION.corn = {
    growthmults = { 1.2, 1.2, 1.2, 0 }, --春夏秋x
    regrowstage = 2,
    bank = "plant_normal_legion", build = "plant_normal_legion",
    leveldata = {
        { anim = "level3_corn", time = time_grow,      deadanim = "dead123_corn", witheredprefab = nil },
        { anim = "level4_corn", time = time_crop*0.45, deadanim = "dead456_corn", witheredprefab = {"twigs"} },
        { anim = "level5_corn", time = time_crop*0.55, deadanim = "dead456_corn", witheredprefab = {"twigs"}, bloom = true },
        { anim = { "level6_corn_1", "level6_corn_2", "level6_corn_3" }, time = time_day2*6, deadanim = "dead456_corn", witheredprefab = {"twigs", "twigs"} }
    }
}
_G.CROPS_DATA_LEGION.pumpkin = {
    growthmults = { 0.8, 0.8, 1.2, 0.5 }, --xx秋冬
    regrowstage = 2,
    bank = "plant_normal_legion", build = "plant_normal_legion",
    leveldata = {
        { anim = "level3_pumpkin", time = time_grow,      deadanim = "dead123_pumpkin", witheredprefab = nil },
        { anim = "level4_pumpkin", time = time_crop*0.45, deadanim = "dead456_pumpkin", witheredprefab = {"cutgrass"} },
        { anim = "level5_pumpkin", time = time_crop*0.55, deadanim = "dead456_pumpkin", witheredprefab = {"cutgrass", "cutgrass"}, bloom = true },
        { anim = { "level6_pumpkin_1", "level6_pumpkin_2", "level6_pumpkin_3" }, time = time_day2*6, deadanim = "dead456_pumpkin", witheredprefab = {"cutgrass", "rope"} }
    },
    cluster_size = { 1, 1.5 }
}
_G.CROPS_DATA_LEGION.eggplant = {
    growthmults = { 1.2, 0.8, 1.2, 0 }, --春x秋x
    regrowstage = 2,
    bank = "crop_legion_eggplant", build = "crop_legion_eggplant",
    leveldata = {
        { anim = "level3", time = time_grow,      deadanim = "dead1", witheredprefab = nil },
        { anim = "level4", time = time_crop*0.45, deadanim = "dead2", witheredprefab = {"cutgrass"} },
        { anim = "level5", time = time_crop*0.55, deadanim = "dead2", witheredprefab = {"rope"}, bloom = true },
        { anim = { "level6_1", "level6_2", "level6_3" }, time = time_day2*6, deadanim = "dead2", witheredprefab = {"rope", "bird_egg"} }
    },
    lootothers = {
        { israndom=true, factor=0.4, name="bird_egg", name_rot="rottenegg" },
        { israndom=false, factor=0.2, name="bird_egg", name_rot="rottenegg" }
    }
}
_G.CROPS_DATA_LEGION.durian = {
    growthmults = { 1.2, 0.8, 0.8, 0 }, --春xxx
    regrowstage = 2,
    bank = "plant_normal_legion", build = "plant_normal_legion",
    leveldata = {
        { anim = "level3_durian", time = time_grow,      deadanim = "dead123_durian", witheredprefab = nil },
        { anim = "level4_durian", time = time_crop*0.45, deadanim = "dead456_durian", witheredprefab = {"log"} },
        { anim = "level5_durian", time = time_crop*0.55, deadanim = "dead456_durian", witheredprefab = {"livinglog"}, bloom = true },
        { anim = { "level6_durian_1", "level6_durian_2", "level6_durian_3" }, time = time_day2*6, deadanim = "dead456_durian", witheredprefab = {"livinglog", "log"} }
    },
    lootothers = {
        { israndom=true, factor=0.05, name="livinglog", name_rot="livinglog" },
        { israndom=false, factor=0.0625, name="livinglog", name_rot="livinglog" }
    }
}
_G.CROPS_DATA_LEGION.pomegranate = {
    growthmults = { 1.2, 1.2, 0.8, 0 }, --春夏xx
    regrowstage = 2,
    bank = "plant_normal_legion", build = "plant_normal_legion",
    leveldata = {
        { anim = "level3_pomegranate", time = time_grow,      deadanim = "dead123_pomegranate", witheredprefab = nil },
        { anim = "level4_pomegranate", time = time_crop*0.45, deadanim = "dead456_pomegranate", witheredprefab = {"log"} },
        { anim = "level5_pomegranate", time = time_crop*0.55, deadanim = "dead456_pomegranate", witheredprefab = {"log"}, bloom = true },
        { anim = { "level6_pomegranate_1", "level6_pomegranate_2", "level6_pomegranate_3" }, time = time_day2*6, deadanim = "dead456_pomegranate", witheredprefab = {"log", "log"} }
    }
}
_G.CROPS_DATA_LEGION.dragonfruit = {
    growthmults = { 1.2, 1.2, 0.8, 0 }, --春夏xx
    regrowstage = 2,
    bank = "plant_normal_legion", build = "plant_normal_legion",
    leveldata = {
        { anim = "level3_dragonfruit", time = time_grow,      deadanim = "dead123_dragonfruit", witheredprefab = nil },
        { anim = "level4_dragonfruit", time = time_crop*0.45, deadanim = "dead456_dragonfruit", witheredprefab = {"log"} },
        { anim = "level5_dragonfruit", time = time_crop*0.55, deadanim = "dead456_dragonfruit", witheredprefab = {"log", "twigs"}, bloom = true },
        { anim = { "level6_dragonfruit_1", "level6_dragonfruit_2", "level6_dragonfruit_3" }, time = time_day2*6, deadanim = "dead456_dragonfruit", witheredprefab = {"log", "twigs"} }
    }
}
_G.CROPS_DATA_LEGION.watermelon = {
    growthmults = { 1.2, 1.2, 0.8, 0 }, --春夏xx
    regrowstage = 1,
    bank = "plant_normal_legion", build = "plant_normal_legion",
    leveldata = {
        { anim = "level3_watermelon", time = time_crop*0.25, deadanim = "dead123_watermelon", witheredprefab = nil },
        { anim = "level4_watermelon", time = time_crop*0.35, deadanim = "dead456_watermelon", witheredprefab = {"cutgrass"} },
        { anim = "level5_watermelon", time = time_crop*0.40, deadanim = "dead456_watermelon", witheredprefab = {"cutgrass"}, bloom = true },
        { anim = { "level6_watermelon_1", "level6_watermelon_2", "level6_watermelon_3" }, time = time_day2*6, deadanim = "dead456_watermelon", witheredprefab = {"cutgrass", "cutgrass"} }
    }
}
_G.CROPS_DATA_LEGION.pineananas = {
    growthmults = { 0.8, 1.2, 1.2, 0 }, --x夏秋x
    regrowstage = 2,
    bank = "crop_legion_pineananas", build = "crop_legion_pineananas",
    image = { name = "pineananas.tex", atlas = "images/inventoryimages/pineananas.xml" },
    leveldata = {
        { anim = "level3", time = time_grow,      deadanim = "dead1", witheredprefab = nil },
        { anim = "level4", time = time_crop*0.45, deadanim = "dead2", witheredprefab = {"log"} },
        { anim = "level5", time = time_crop*0.55, deadanim = "dead2", witheredprefab = {"log", "cutgrass"}, bloom = true },
        { anim = { "level6_1", "level6_2", "level6_3" }, time = time_day2*6, deadanim = "dead2", witheredprefab = {"log", "cutgrass"} }
    },
    cluster_size = { 1, 1.5 },
    lootothers = {
        { israndom=true, factor=0.05, name="pinecone", name_rot="pinecone" },
        { israndom=false, factor=0.0625, name="pinecone", name_rot="pinecone" }
    }
}
_G.CROPS_DATA_LEGION.onion = {
    growthmults = { 1.2, 1.2, 1.2, 0 }, --春夏秋x
    regrowstage = 1,
    bank = "crop_legion_onion", build = "crop_legion_onion",
    image = { name = "quagmire_onion.tex", atlas = nil },
    leveldata = {
        { anim = "level2", time = time_crop*0.25, deadanim = "dead1", witheredprefab = nil },
        { anim = "level3", time = time_crop*0.35, deadanim = "dead2", witheredprefab = {"cutgrass"} },
        { anim = "level4", time = time_crop*0.40, deadanim = "dead2", witheredprefab = {"cutgrass"}, bloom = true },
        { anim = { "level5_1", "level5_2", "level5_3" }, time = time_day2*6, deadanim = "dead2", witheredprefab = {"cutgrass", "cutgrass"} }
    },
    cluster_size = { 1, 1.5 }
}
_G.CROPS_DATA_LEGION.pepper = {
    growthmults = { 0.8, 1.2, 1.2, 0 }, --x夏秋x
    regrowstage = 2,
    bank = "crop_legion_pepper", build = "crop_legion_pepper",
    leveldata = {
        { anim = "level2", time = time_grow,      deadanim = "dead1", witheredprefab = nil },
        { anim = "level3", time = time_crop*0.45, deadanim = "dead2", witheredprefab = {"cutgrass"} },
        { anim = "level4", time = time_crop*0.55, deadanim = "dead2", witheredprefab = {"cutgrass"}, bloom = true },
        { anim = { "level5_1", "level5_2", "level5_3" }, time = time_day2*6, deadanim = "dead2", witheredprefab = {"cutgrass", "cutgrass"} }
    },
    lootothers = {
        { israndom=true, factor=0.4, name="mint_l", name_rot=nil },
        { israndom=false, factor=0.2, name="mint_l", name_rot=nil }
    }
}
_G.CROPS_DATA_LEGION.potato = {
    growthmults = { 1.2, 0.8, 1.2, 0.5 }, --春x秋冬
    regrowstage = 1,
    bank = "crop_legion_potato", build = "crop_legion_potato",
    leveldata = {
        { anim = "level2", time = time_crop*0.25, deadanim = "dead1", witheredprefab = nil },
        { anim = "level3", time = time_crop*0.35, deadanim = "dead2", witheredprefab = {"cutgrass"} },
        { anim = "level4", time = time_crop*0.40, deadanim = "dead2", witheredprefab = {"cutgrass", "potato"}, bloom = true },
        { anim = { "level5_1", "level5_2", "level5_3" }, time = time_day2*6, deadanim = "dead2", witheredprefab = {"cutgrass", "potato"} }
    }
}
_G.CROPS_DATA_LEGION.garlic = {
    growthmults = { 1.2, 1.2, 1.2, 0.5 }, --春夏秋冬
    regrowstage = 1,
    bank = "crop_legion_garlic", build = "crop_legion_garlic",
    leveldata = {
        { anim = "level2", time = time_crop*0.25, deadanim = "dead1", witheredprefab = nil },
        { anim = "level3", time = time_crop*0.35, deadanim = "dead2", witheredprefab = {"cutgrass"} },
        { anim = "level4", time = time_crop*0.40, deadanim = "dead2", witheredprefab = {"cutgrass"}, bloom = true },
        { anim = { "level5_1", "level5_2", "level5_3" }, time = time_day2*6, deadanim = "dead2", witheredprefab = {"feather_crow", "feather_robin"} }
    },
    lootothers = {
        { israndom=true, factor=0.03, name="feather_crow", name_rot="feather_crow" },
        { israndom=false, factor=0.0375, name="feather_crow", name_rot="feather_crow" },
        { israndom=true, factor=0.02, name="feather_robin", name_rot="feather_robin" },
        { israndom=false, factor=0.025, name="feather_robin", name_rot="feather_robin" }
    }
}
_G.CROPS_DATA_LEGION.tomato = {
    growthmults = { 1.2, 1.2, 1.2, 0 }, --春夏秋x
    regrowstage = 2,
    bank = "crop_legion_tomato", build = "crop_legion_tomato",
    image = { name = "quagmire_tomato.tex", atlas = nil },
    leveldata = {
        { anim = "level2", time = time_grow,      deadanim = "dead1", witheredprefab = nil },
        { anim = "level3", time = time_crop*0.45, deadanim = "dead2", witheredprefab = {"twigs"} },
        { anim = "level4", time = time_crop*0.55, deadanim = "dead2", witheredprefab = {"twigs"}, bloom = true },
        { anim = { "level5_1", "level5_2", "level5_3" }, time = time_day2*6, deadanim = "dead2", witheredprefab = {"twigs", "twigs"} }
    },
    cluster_size = { 1, 1.7 }
}
_G.CROPS_DATA_LEGION.asparagus = {
    growthmults = { 1.2, 0.8, 0.8, 0.5 }, --春xx冬
    regrowstage = 2,
    bank = "crop_legion_asparagus", build = "crop_legion_asparagus",
    leveldata = {
        { anim = "level2", time = time_grow,      deadanim = "dead1", witheredprefab = nil },
        { anim = "level3", time = time_crop*0.45, deadanim = "dead2", witheredprefab = {"cutgrass"} },
        { anim = "level4", time = time_crop*0.55, deadanim = "dead2", witheredprefab = {"cutgrass", "cutgrass"}, bloom = true },
        { anim = { "level5_1", "level5_2", "level5_3" }, time = time_day2*6, deadanim = "dead2", witheredprefab = {"cutgrass", "cutgrass", "cutgrass"} }
    },
    cluster_size = { 1, 1.7 }
}
_G.CROPS_DATA_LEGION.mandrake = {
    growthmults = { 1, 1, 1, 0.5 }, --xxx冬
    regrowstage = 1, nomagicgrow = true, getsickchance = 0,
    bank = "crop_legion_mandrake", build = "crop_legion_mandrake",
    leveldata = {
        { anim = "level2", time = time_crop*0.5, deadanim = "dead1", witheredprefab = nil },
        { anim = "level3", time = time_crop*0.7, deadanim = "dead1", witheredprefab = {"cutgrass"} },
        { anim = "level4", time = time_crop*0.8, deadanim = "dead1", witheredprefab = {"cutgrass"} },
        { anim = "level5", time = nil,           deadanim = "dead1", witheredprefab = {"cutgrass"} }
    },
    fn_loot = function(self, doer, ispicked, isburnt, loots)
        if self.stage == self.stage_max then
            local num = self.cluster + 1 --曼德拉产量固定1
            if self.isrotten then
                self:AddLoot(loots, "livinglog", num*2)
            else
                self:AddLoot(loots, "mandrake", num)
            end
        end
    end,
    fn_defend = function(inst, target)
        local doer = target or inst --只能尽量由 target 来执行操作，因为下一帧 inst 可能就没了
        if doer.SoundEmitter then
            doer.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/death")
        else
            inst.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/death")
        end
        local x, y, z = inst.Transform:GetWorldPosition()
        local timemult = inst.components.perennialcrop2.cluster*0.03 --99级大概会增加3倍时间
        doer:DoTaskInTime(0.4+0.2*math.random(), function()
            local time = 10
            if timemult > 0 then
                time = time + time*timemult
            end
            TOOLS_L.DoAreaSleep({
                doer = doer, x = x, y = y, z = z,
                range = 25, -- tagscant = nil, tagsone = nil,
                lvl = 5, time = time + math.random(), --noyawn = nil,
                -- fn_valid = nil, fn_do = nil
            })
        end)
    end
}
_G.CROPS_DATA_LEGION.gourd = {
    growthmults = { 0.8, 0.8, 1.2, 0 }, --xx秋x
    regrowstage = 2,
    bank = "crop_mythword_gourd", build = "crop_mythword_gourd",
    image = { name = "gourd.tex", atlas = "images/inventoryimages/gourd.xml" },
    leveldata = {
        { anim = "level3", time = time_grow,      deadanim = "dead1", witheredprefab = nil },
        { anim = "level4", time = time_crop*0.45, deadanim = "dead2", witheredprefab = {"cutgrass"} },
        { anim = "level5", time = time_crop*0.55, deadanim = "dead2", witheredprefab = {"cutgrass", "cutgrass"}, bloom = true },
        { anim = { "level6_1", "level6_2", "level6_3" }, time = time_day2*6, deadanim = "dead2", witheredprefab = {"cutgrass", "rope"} }
    }
}
_G.CROPS_DATA_LEGION.cactus_meat = {
    growthmults = { 0.8, 1.2, 0.8, 0 }, --x夏xx
    regrowstage = 1,
    bank = "crop_legion_cactus", build = "crop_legion_cactus",
    leveldata = {
        { anim = { "level1_1", "level1_2", "level1_3" }, time = time_day1*10*0.45, deadanim = "dead1", witheredprefab = nil },
        { anim = { "level2_1", "level2_2", "level2_3" }, time = time_day1*10*0.55, deadanim = "dead1", witheredprefab = {"cutgrass"} },
        { anim = { "level3_1", "level3_2", "level3_3" }, time = time_grow, deadanim = "dead1", witheredprefab = {"cutgrass"}, pickable = 1 },
        { anim = { "level4_1", "level4_2", "level4_3" }, time = time_day2*6, deadanim = "dead1", witheredprefab = {"cutgrass"}, bloom = true }
    },
    cluster_size = { 0.9, 1.3 },
    fn_loot = function(self, doer, ispicked, isburnt, loots)
        if self.stage == self.stage_max or self.level.pickable == 1 then
            self:GetBaseLoot(loots, {
                doer = doer, ispicked = ispicked, isburnt = isburnt,
                crop = self.cropprefab, crop_rot = "spoiled_food",
                lootothers = self.stage == self.stage_max and { --最终阶段才有仙人掌花
                    { israndom=true, factor=0.4, name="cactus_flower", name_rot=nil },
                    { israndom=false, factor= TheWorld.state.issummer and 0.7 or 0.2, name="cactus_flower", name_rot=nil }
                } or nil
            })
        end
    end,
    fn_pick = function(self, doer, loot) --采集时被刺伤
        if
            doer ~= nil and doer.components.combat ~= nil and
            not doer:HasTag("shadowminion") and
            not (
                doer.components.inventory ~= nil and
                (
                    doer.components.inventory:EquipHasTag("bramble_resistant") or
                    (CONFIGS_LEGION.ENABLEDMODS.MythWords and doer.components.inventory:Has("thorns_pill", 1))
                )
            )
        then
            doer.components.combat:GetAttacked(self.inst, 6 + 0.2*self.cluster)
            doer:PushEvent("thorns")
        end
    end,
    fn_common = function(inst)
        inst:AddTag("thorny")
    end,
    fn_season = function(self) --夏季时切换花朵贴图
        if TheWorld.state.season == "summer" then
            self.inst.AnimState:OverrideSymbol("flowerplus",
                self.inst.AnimState:GetBuild() or "crop_legion_cactus", "flomax")
        else
            self.inst.AnimState:ClearOverrideSymbol("flowerplus")
        end
    end
}
_G.CROPS_DATA_LEGION.plantmeat = {
    growthmults = { 1.2, 0.8, 1.2, 0 }, --春x秋x
    regrowstage = 1, cangrowindrak = true, getsickchance = 0,
    plant2 = "plant_nepenthes_l", --这个的三阶段是单独的实体，也需要升级
    bank = "crop_legion_lureplant", build = "crop_legion_lureplant",
    leveldata = {
        { anim = "level1", time = time_day1*7*0.45, deadanim = "dead1", witheredprefab = nil },
        { anim = "level2", time = time_day1*7*0.55, deadanim = "dead1", witheredprefab = {"cutgrass" ,"cutgrass"} },
        { anim = "idle", time = nil, deadanim = "dead1", witheredprefab = {"cutgrass" ,"cutgrass", "cutgrass"}, pickable = -1 }
    },
    cluster_size = { 0.9, 1.5 },
    fn_growth = function(self, data) --成熟阶段得换成生物实体
        if data.stage < self.stage_max then
            return
        end
        local bios = SpawnPrefab("plant_nepenthes_l")
        if bios ~= nil then
            bios.fn_switch(bios, self.inst)
        end
        self.inst:Remove()
    end,
    fn_stage = function(self) --成熟阶段枯萎，变回1阶段的枯萎植物实体
        if self.stage < self.stage_max or not self.isrotten then
            return
        end
        local plant = self.inst.fn_switch(self.inst)
        if plant ~= nil then
            plant.components.perennialcrop2:SetStage(1, true) --弄成枯萎的
        end
        self.inst:Remove()
    end
}
_G.CROPS_DATA_LEGION.berries = {
    growthmults = { 1.2, 0.8, 1.2, 0 }, --春x秋x
    regrowstage = 1,
    bank = "crop_legion_berries", build = "crop_legion_berries",
    leveldata = {
        { anim = "level1", time = time_day1*8*0.45, deadanim = "dead1", witheredprefab = nil },
        { anim = "level2", time = time_day1*8*0.55, deadanim = "dead1", witheredprefab = {"log"}, bloom = true },
        { anim = { "level3_1", "level3_2", "level3_3" }, time = time_grow, deadanim = "dead1", witheredprefab = {"log", "twigs"}, pickable = 1 },
        { anim = { "level3_1", "level3_2", "level3_3" }, time = time_day2*6, deadanim = "dead1", witheredprefab = {"log", "twigs"} }
    },
    cluster_size = { 0.9, 1.3 },
    fn_loot = function(self, doer, ispicked, isburnt, loots)
        if self.stage == self.stage_max then
            self:GetBaseLoot(loots, {
                doer = doer, ispicked = ispicked, isburnt = isburnt,
                crop = self.cropprefab, crop_rot = "spoiled_food",
                lootothers = {
                    { israndom=true, factor=0.4, name="berries_juicy", name_rot=nil },
                    { israndom=false, factor=0.2, name="berries_juicy", name_rot=nil }
                }
            })
        elseif self.level.pickable == 1 then
            self:GetBaseLoot(loots, {
                doer = doer, ispicked = ispicked, isburnt = isburnt,
                crop = "berries_juicy", crop_rot = "spoiled_food",
                lootothers = {
                    { israndom=true, factor=0.4, name=self.cropprefab, name_rot=nil },
                    { israndom=false, factor=0.2, name=self.cropprefab, name_rot=nil }
                }
            })
        end
    end,
    fn_stage = function(self)
        if self.stage >= self.stage_max then
            self.inst.AnimState:OverrideSymbol("fruit1", "crop_legion_berries", "fruit2")
        else
            self.inst.AnimState:ClearOverrideSymbol("fruit1")
        end
    end
}
_G.CROPS_DATA_LEGION.log = {
    growthmults = { 1.2, 0.8, 1.2, 0.5 }, --春x秋冬
    regrowstage = 1, cangrowindrak = true, dataonly = true,
    bank = "crop_legion_pine", build = "crop_legion_pine",
    leveldata = {
        { anim = "idle", time = time_day1*8*0.34, deadanim = nil, witheredprefab = nil },
        { anim = "idle", time = time_day1*8*0.66, deadanim = nil, witheredprefab = nil },
        { anim = "idle", time = nil, deadanim = nil, witheredprefab = nil, pickable = -1 }
    },
    cluster_size = { 0.9, 1.5 },
    fn_placer = function(placer)
        placer.AnimState:Hide("base2") --Tip：动画中，对应贴图名需要复写为base2_00x，x为序号，否则就只会第一个生效
		placer.AnimState:Hide("base3")
    end
}
_G.CROPS_DATA_LEGION.lightbulb = {
    growthmults = { 1.2, 0.8, 1.2, 0.5 }, --春x秋冬
    regrowstage = 1, cangrowindrak = true, nogrowinlight = true, dataonly = true,
    bank = "crop_legion_lightbulb", build = "crop_legion_lightbulb",
    leveldata = {
        { anim = "level3", time = time_day1*6*0.4, deadanim = "dead1", witheredprefab = nil },
        { anim = "level3", time = time_day1*6*0.6, deadanim = "dead1", witheredprefab = {"twigs"} },
        { anim = "level3", time = nil, deadanim = "dead1", witheredprefab = {"twigs", "twigs"}, bloom = true, pickable = -1 }
    },
    cluster_size = { 0.9, 1.4 },
    fn_placer = function(placer)
        placer.AnimState:HideSymbol("fruit2")
        placer.AnimState:HideSymbol("light2")
        placer.AnimState:HideSymbol("stem")
    end
}

--------------------------------------------------------------------------
--[[ 子圭·育转化数据表 ]]
--------------------------------------------------------------------------

if not _G.rawget(_G, "TRANS_DATA_LEGION") then --对于global来说，不能直接检测是否有某个元素，需要用rawget才行
    _G.TRANS_DATA_LEGION = {}
end

local mapseeds = {
    carrot_oversized = {
        swap = { build = "farm_plant_carrot", file = "swap_body", symboltype = "3" },
        fruit = "seeds_carrot_l"
    },
    corn_oversized = {
        swap = { build = "farm_plant_corn_build", file = "swap_body", symboltype = "3" },
        fruit = "seeds_corn_l"
    },
    pumpkin_oversized = {
        swap = { build = "farm_plant_pumpkin", file = "swap_body", symboltype = "3" },
        fruit = "seeds_pumpkin_l"
    },
    eggplant_oversized = {
        swap = { build = "farm_plant_eggplant_build", file = "swap_body", symboltype = "3" },
        fruit = "seeds_eggplant_l"
    },
    durian_oversized = {
        swap = { build = "farm_plant_durian_build", file = "swap_body", symboltype = "3" },
        fruit = "seeds_durian_l"
    },
    pomegranate_oversized = {
        swap = { build = "farm_plant_pomegranate_build", file = "swap_body", symboltype = "3" },
        fruit = "seeds_pomegranate_l"
    },
    dragonfruit_oversized = {
        swap = { build = "farm_plant_dragonfruit_build", file = "swap_body", symboltype = "3" },
        fruit = "seeds_dragonfruit_l"
    },
    watermelon_oversized = {
        swap = { build = "farm_plant_watermelon_build", file = "swap_body", symboltype = "3" },
        fruit = "seeds_watermelon_l"
    },
    pineananas_oversized = {
        swap = { build = "farm_plant_pineananas", file = "swap_body", symboltype = "3" },
        fruit = "seeds_pineananas_l"
    },
    onion_oversized = {
        swap = { build = "farm_plant_onion_build", file = "swap_body", symboltype = "3" },
        fruit = "seeds_onion_l"
    },
    pepper_oversized = {
        swap = { build = "farm_plant_pepper", file = "swap_body", symboltype = "3" },
        fruit = "seeds_pepper_l"
    },
    potato_oversized = {
        swap = { build = "farm_plant_potato", file = "swap_body", symboltype = "3" },
        fruit = "seeds_potato_l"
    },
    garlic_oversized = {
        swap = { build = "farm_plant_garlic", file = "swap_body", symboltype = "3" },
        fruit = "seeds_garlic_l"
    },
    tomato_oversized = {
        swap = { build = "farm_plant_tomato", file = "swap_body", symboltype = "3" },
        fruit = "seeds_tomato_l"
    },
    asparagus_oversized = {
        swap = { build = "farm_plant_asparagus", file = "swap_body", symboltype = "3" },
        fruit = "seeds_asparagus_l"
    },
    mandrake = {
        swap = { build = "siving_turn", file = "swap_mandrake", symboltype = "1" },
        fruit = "seeds_mandrake_l", time = 20,
        fruitnum_min = 1, fruitnum_max = 1, genekey = "mandrakesoup"
    },
    gourd_oversized = {
        swap = { build = "farm_plant_gourd", file = "swap_body", symboltype = "3" },
        fruit = "seeds_gourd_l"
    },
    squamousfruit = {
        swap = { build = "squamousfruit", file = "swap_turn", symboltype = "1" },
        fruit = "dug_monstrain", time = 2,
        fruitnum_min = 1, fruitnum_max = 1, genekey = "raindonate"
    },
    cactus_flower = {
        swap = { build = "crop_legion_cactus", file = "swap_turn", symboltype = "1" },
        fruit = "seeds_cactus_meat_l", time = 2,
        fruitnum_min = 1, fruitnum_max = 1, genekey = "tissue_l_cactus"
    },
    lureplantbulb = {
        swap = { build = "crop_legion_lureplant", file = "swap_turn", symboltype = "1" },
        fruit = "seeds_plantmeat_l", time = 2,
        fruitnum_min = 1, fruitnum_max = 1, genekey = "tissue_l_lureplant"
    },
    dug_berrybush = {
        swap = { build = "crop_legion_berries", file = "swap_turn1", symboltype = "1" },
        fruit = "seeds_berries_l", time = 2,
        fruitnum_min = 1, fruitnum_max = 1, genekey = "tissue_l_berries"
    },
    dug_berrybush2 = {
        swap = { build = "crop_legion_berries", file = "swap_turn2", symboltype = "1" },
        fruit = "seeds_berries_l", time = 2,
        fruitnum_min = 1, fruitnum_max = 2, genekey = "tissue_l_berries"
    },
    dug_berrybush_juicy = {
        swap = { build = "crop_legion_berries", file = "swap_turn3", symboltype = "1" },
        fruit = "seeds_berries_l", time = 5,
        fruitnum_min = 2, fruitnum_max = 3, genekey = "tissue_l_berries"
    },
    pinecone = {
        swap = { build = "crop_legion_pine", file = "swap_turn", symboltype = "1" },
        fruit = "seeds_log_l",
        fruitnum_min = 1, fruitnum_max = 1, genekey = "foliageath"
    },
    lightcrab = {
        swap = { build = "crop_legion_lightbulb", file = "swap_turn1", symboltype = "1" },
        fruit = "seeds_lightbulb_l", time = 3,
        fruitnum_min = 2, fruitnum_max = 3, genekey = "tissue_l_lightbulb"
    },
    lightflier = {
        swap = { build = "crop_legion_lightbulb", file = "swap_turn2", symboltype = "1" },
        fruit = "seeds_lightbulb_l", time = 3,
        fruitnum_min = 2, fruitnum_max = 3, genekey = "tissue_l_lightbulb"
    }
}
for k, v in pairs(mapseeds) do
    _G.TRANS_DATA_LEGION[k] = v
end
mapseeds = nil

--------------------------------------------------------------------------
--[[ 巨食草消化表 ]]
--------------------------------------------------------------------------

if not _G.rawget(_G, "DIGEST_DATA_LEGION") then
    _G.DIGEST_DATA_LEGION = {}
end

local function FnD_lordfruitfly(inst, eater, items_free)
    TheWorld:PushEvent("ms_lordfruitflykilled")
end

local lvls = { 0, 5, 10, 20, 30, 40, 50, 65, 80 }
local digest_data_l = {
    bee = {
        lvl = nil, --巨食草要达到这个簇栽等级后才能主动吞下该对象，如果为 nil 则代表无法主动吞下
        attract = nil, --为true的话，可以被巨食草主动吸引(是靠战斗组件来吸引)
        loot = { ahandfulofwings = 0.2, insectshell_l = 1, honey = 0.2 }, --key value 对应 产物prefab 数量比例
        -- fn_digest = function(inst, eater, items_free)end --被消化或吞食时的
    },
    butterfly = { lvl = nil, attract = nil, loot = { ahandfulofwings = 0.2, insectshell_l = 1 } }, --蝴蝶
    moonbutterfly = { lvl = nil, attract = nil, loot = { ahandfulofwings = 0.5, insectshell_l = 1 } }, --月蛾
    carrat = { lvl = nil, attract = nil, loot = { carrot_seeds = 1 } }, --胡萝卜鼠
    lightcrab = { lvl = nil, attract = nil, loot = { slurtle_shellpieces = 1 } }, --发光蟹
    oceanfish_small_1_inv = { lvl = nil, attract = nil, loot = { boneshard = 1 } }, --小孔雀鱼
    oceanfish_small_2_inv = { lvl = nil, attract = nil, loot = { boneshard = 1 } }, --针鼻喷墨鱼
    oceanfish_small_3_inv = { lvl = nil, attract = nil, loot = { boneshard = 1 } }, --小饵鱼
    oceanfish_small_4_inv = { lvl = nil, attract = nil, loot = { boneshard = 1 } }, --三文鱼苗
    oceanfish_small_5_inv = { lvl = nil, attract = nil, loot = { corn_seeds = 1 } }, --爆米花鱼
    oceanfish_small_6_inv = { lvl = nil, attract = nil, loot = { boneshard = 3 } }, --落叶比目鱼
    oceanfish_small_7_inv = { lvl = nil, attract = nil, loot = { boneshard = 3 } }, --花朵金枪鱼
    oceanfish_small_8_inv = { lvl = nil, attract = nil, loot = { boneshard = 3 } }, --炽热太阳鱼
    oceanfish_small_9_inv = { lvl = nil, attract = nil, loot = { boneshard = 1 } }, --口水鱼
    oceanfish_medium_1_inv = { lvl = nil, attract = nil, loot = { boneshard = 1 } }, --泥鱼
    oceanfish_medium_2_inv = { lvl = nil, attract = nil, loot = { boneshard = 1 } }, --斑鱼
    oceanfish_medium_3_inv = { lvl = nil, attract = nil, loot = { boneshard = 1 } }, --浮夸狮子鱼
    oceanfish_medium_4_inv = { lvl = nil, attract = nil, loot = { boneshard = 1 } }, --黑鲶鱼
    oceanfish_medium_5_inv = { lvl = nil, attract = nil, loot = { corn_seeds = 1 } }, --玉米鳕鱼
    oceanfish_medium_6_inv = { lvl = nil, attract = nil, loot = { boneshard = 3 } }, --花锦鲤
    oceanfish_medium_7_inv = { lvl = nil, attract = nil, loot = { boneshard = 3 } }, --金锦鲤
    oceanfish_medium_8_inv = { lvl = nil, attract = nil, loot = { boneshard = 3 } }, --冰鲷鱼
    oceanfish_medium_9_inv = { lvl = nil, attract = nil, loot = { boneshard = 1, honey = 0.2 } }, --甜味鱼
    pondfish = { lvl = nil, attract = nil, loot = { boneshard = 1 } }, --淡水鱼
    pondeel = { lvl = nil, attract = nil, loot = { boneshard = 4 } }, --活鳗鱼
    lightflier = { lvl = nil, attract = nil, loot = { ahandfulofwings = 0.5, insectshell_l = 1 } }, --球状光虫
    dragon_scales = { lvl = nil, attract = nil, loot = { insectshell_l = 28 } }, --鳞片(龙蝇)
    lavae_egg = { lvl = nil, attract = nil, loot = { insectshell_l = 20 } }, --岩浆虫卵
    lavae_egg_cracked = { lvl = nil, attract = nil, loot = { insectshell_l = 20 } }, --岩浆虫卵(孵化中)
    lavae_cocoon = { lvl = nil, attract = nil, loot = { insectshell_l = 28 } }, --冷冻虫卵
    butter = { lvl = nil, attract = nil, loot = { insectshell_l = 16 } }, --黄油
    royal_jelly = { lvl = nil, attract = nil, loot = { insectshell_l = 16 } }, --蜂王浆
    glommerflower = { lvl = nil, attract = nil, loot = { insectshell_l = 16 } }, --格罗姆花
    glommerwings = { lvl = nil, attract = nil, loot = { insectshell_l = 16 } }, --格罗姆翅膀
    glommerfuel = { lvl = nil, attract = nil, loot = { insectshell_l = 8 } }, --格罗姆的黏液
    honeycomb = { lvl = nil, attract = nil, loot = { insectshell_l = 16 } }, --蜂巢
    beeswax = { lvl = nil, attract = nil, loot = { insectshell_l = 18 } }, --蜂蜡
    wormlight = { lvl = nil, attract = nil, loot = { insectshell_l = 4 } }, --发光浆果
    wormlight_lesser = { lvl = nil, attract = nil, loot = { insectshell_l = 1 } }, --小发光浆果
    fruitflyfruit = { lvl = nil, attract = nil, loot = { insectshell_l = 20 } }, --友好果蝇果
    fireflies = { lvl = nil, attract = nil, loot = { ahandfulofwings = 0.5, insectshell_l = 1 } }, --萤火虫
    raindonate = { lvl = lvls[1], attract = true, loot = { ahandfulofwings = 1, insectshell_l = 1 } }, --雨蝇
    cropgnat = { lvl = lvls[1], attract = true, loot = { ahandfulofwings = 1, insectshell_l = 1 } }, --植害虫群
    cropgnat_infester = { lvl = lvls[1], attract = true, loot = { ahandfulofwings = 1, insectshell_l = 1 } }, --叮咬虫群
    killerbee = { lvl = lvls[1], attract = true, loot = { ahandfulofwings = 0.2, insectshell_l = 1, honey = 0.2 } }, --杀人蜂
    mosquito = { lvl = lvls[1], attract = true, loot = { ahandfulofwings = 0.2, insectshell_l = 1 } }, --蚊子
    fruitfly = { lvl = lvls[2], attract = true, loot = { ahandfulofwings = 0.5, insectshell_l = 1 } }, --果蝇
    crow = { lvl = lvls[2], attract = nil, loot = { boneshard = 1 } }, --乌鸦
    canary = { lvl = lvls[2], attract = nil, loot = { boneshard = 1 } }, --金丝雀
    canary_poisoned = { lvl = lvls[2], attract = nil, loot = { boneshard = 1 } }, --生病金丝雀
    robin = { lvl = lvls[2], attract = nil, loot = { boneshard = 1 } }, --红雀
    robin_winter = { lvl = lvls[2], attract = nil, loot = { boneshard = 1 } }, --雪雀
    puffin = { lvl = lvls[2], attract = nil, loot = { boneshard = 1 } }, --海鹦鹉
    rabbit = { lvl = lvls[2], attract = nil, loot = { boneshard = 1 } }, --兔子
    mole = { lvl = lvls[2], attract = nil, loot = { boneshard = 1, nitre = 2 } }, --鼹鼠
    gingerbreadpig = { lvl = lvls[2], attract = nil, loot = { wintersfeastfuel = 1 } }, --姜饼猪
    eyeplant = { lvl = lvls[2], attract = nil, loot = nil }, --眼球草
    wobster_sheller_land = { lvl = lvls[2], attract = nil, loot = { boneshard = 1 } }, --地上的龙虾
    wobster_moonglass_land = { lvl = lvls[3], attract = nil, loot = { moonglass = 1 } }, --地上的月光龙虾
    lavae = { lvl = lvls[3], attract = true, loot = { insectshell_l = 1 } }, --岩浆虫
    fruitdragon = { lvl = lvls[3], attract = nil, loot = { dragonfruit_seeds = 1 } }, --沙拉蝾螈
    grassgekko = { lvl = lvls[3], attract = nil, loot = { boneshard = 1 } }, --草壁虎
    frog = { lvl = lvls[3], attract = nil, loot = { boneshard = 1 } }, --青蛙
    cookiecutter = { lvl = lvls[3], attract = nil, loot = { cookiecuttershell = 1 } }, --饼干切割机
    bat = { lvl = lvls[3], attract = true, loot = { boneshard = 1 } }, --蝙蝠
    birchnutdrake = { lvl = lvls[3], attract = nil, loot = { acorn = 1 } }, --桦栗果精
    spider = { lvl = lvls[3], attract = nil, loot = { boneshard = 1 } }, --蜘蛛
    spider_warrior = { lvl = lvls[4], attract = nil, loot = { boneshard = 1 } }, --蜘蛛战士
    spider_hider = { lvl = lvls[4], attract = nil, loot = { boneshard = 1 } }, --洞穴蜘蛛
    spider_spitter = { lvl = lvls[4], attract = nil, loot = { boneshard = 1 } }, --喷射蜘蛛
    spider_dropper = { lvl = lvls[4], attract = nil, loot = { boneshard = 1 } }, --穴居悬蛛
    lunarfrog = { lvl = lvls[4], attract = nil, loot = { boneshard = 1 } }, --明眼青蛙
    monkey = { lvl = lvls[4], attract = nil, loot = { boneshard = 1 } }, --穴居猴
    bird_mutant = { lvl = lvls[4], attract = nil, loot = { boneshard = 1 } }, --月盲乌鸦
    bird_mutant_spitter = { lvl = lvls[4], attract = nil, loot = { boneshard = 1 } }, --奇形鸟
    stalker_minion = { lvl = lvls[4], attract = nil, loot = { nightmarefuel = 1 } }, --编织暗影
    stalker_minion1 = { lvl = lvls[4], attract = nil, loot = { nightmarefuel = 1 } }, --编织暗影1
    stalker_minion2 = { lvl = lvls[4], attract = nil, loot = { nightmarefuel = 1 } }, --编织暗影2
    buzzard = { lvl = lvls[5], attract = nil, loot = { boneshard = 1 } }, --秃鹫
    spider_moon = { lvl = lvls[5], attract = nil, loot = { boneshard = 1 } }, --破碎蜘蛛
    spider_healer = { lvl = lvls[5], attract = nil, loot = { boneshard = 1 } }, --护士蜘蛛
    spider_water = { lvl = lvls[5], attract = nil, loot = { boneshard = 1 } }, --海黾
    beeguard = { lvl = lvls[5], attract = true, loot = { ahandfulofwings = 1, insectshell_l = 1, honey = 0.2 } }, --嗡嗡蜜蜂
    eyeofterror_mini_grounded = { lvl = lvls[5], attract = nil, loot = { boneshard = 1 } }, --可疑窥视者(孵化中)
    eyeofterror_mini = { lvl = lvls[5], attract = nil, loot = { boneshard = 1 } }, --可疑窥视者
    molebat = { lvl = lvls[5], attract = nil, loot = { boneshard = 1 } }, --裸鼹蝠
    squid = { lvl = lvls[5], attract = nil, loot = { boneshard = 1 } }, --鱿鱼
    worm = { lvl = lvls[6], attract = true, loot = { boneshard = 1, insectshell_l = 2 } }, --洞穴蠕虫
    perd = { lvl = lvls[6], attract = nil, loot = { boneshard = 1, dug_berrybush = 0.04 } }, --火鸡
    penguin = { lvl = lvls[6], attract = nil, loot = { boneshard = 1 } }, --企鸥
    catcoon = { lvl = lvls[6], attract = nil, loot = { boneshard = 1 } }, --浣猫
    snurtle = { lvl = lvls[6], attract = nil, loot = { slurtle_shellpieces = 1 } }, --蜗牛龟
    slurtle = { lvl = lvls[7], attract = true, loot = { slurtle_shellpieces = 1 } }, --蛞蝓龟
    mutated_penguin = { lvl = lvls[7], attract = nil, loot = { boneshard = 2 } }, --月岩企鸥
    smallbird = { lvl = lvls[7], attract = nil, loot = { boneshard = 1 } }, --小鸟(高脚鸟)
    slurper = { lvl = lvls[7], attract = nil, loot = { boneshard = 1 } }, --啜食者
    hound = { lvl = lvls[7], attract = nil, loot = { boneshard = 1 } }, --猎犬
    firehound = { lvl = lvls[8], attract = nil, loot = { boneshard = 1 } }, --红色猎犬
    icehound = { lvl = lvls[8], attract = nil, loot = { boneshard = 1 } }, --蓝色猎犬
    moonhound = { lvl = lvls[8], attract = nil, loot = { boneshard = 1 } }, --月杖转化仪式的猎犬
    mutatedhound = { lvl = lvls[8], attract = nil, loot = { boneshard = 2 } }, --恐怖猎犬
    teenbird = { lvl = lvls[8], attract = nil, loot = { boneshard = 2 } }, --小高脚鸟
    mossling = { lvl = lvls[8], attract = nil, loot = { boneshard = 1 } }, --麋鹿鹅幼崽
    babybeefalo = { lvl = lvls[8], attract = nil, loot = { boneshard = 1 } }, --小皮弗娄牛
    lightninggoat = { lvl = lvls[8], attract = nil, loot = { boneshard = 1, goatmilk = 0.2 } }, --伏特羊
    merm = { lvl = lvls[8], attract = nil, loot = { boneshard = 1, merm_scales = 0.2 } }, --鱼人
    pigman = { lvl = lvls[8], attract = nil, loot = { boneshard = 1 } }, --猪人、疯猪
    powder_monkey = { lvl = lvls[8], attract = nil, loot = { boneshard = 1 } }, --火药猴
    mushgnome = { lvl = lvls[8], attract = nil, loot = { spore_moon = 4, livinglog = 4 } }, --蘑菇地精
    little_walrus = { lvl = lvls[8], attract = nil, loot = { boneshard = 1, walrus_tusk = 0.2 } }, --小海象
    otter = { lvl = lvls[8], attract = nil, loot = { boneshard = 1, messagebottle = 0.1 } }, --水獭掠夺者
    deer = { lvl = lvls[8], attract = nil, loot = { boneshard = 2, deer_antler1 = 0.1, deer_antler2 = 0.1, deer_antler3 = 0.1 } }, --无眼鹿
    deer_red = { lvl = lvls[9], attract = nil, loot = { boneshard = 4, deer_antler1 = 0.1, deer_antler2 = 0.1, deer_antler3 = 0.1 } }, --无眼鹿(红)
    deer_blue = { lvl = lvls[9], attract = nil, loot = { boneshard = 4, deer_antler1 = 0.1, deer_antler2 = 0.1, deer_antler3 = 0.1 } }, --无眼鹿(蓝)
    bunnyman = { lvl = lvls[9], attract = nil, loot = { boneshard = 1, beardhair = 0.2 } }, --兔人
    mermguard = { lvl = lvls[9], attract = nil, loot = { boneshard = 1, merm_scales = 0.5 } }, --忠诚鱼人守卫
    pigguard = { lvl = lvls[9], attract = nil, loot = { boneshard = 1, dug_berrybush2 = 0.1 } }, --猪人守卫
    moonpig = { lvl = lvls[9], attract = nil, loot = { boneshard = 1 } }, --月杖转化仪式的疯猪
    prime_mate = { lvl = lvls[9], attract = nil, loot = { boneshard = 2 } }, --大副(火药猴)
    walrus = { lvl = lvls[9], attract = nil, loot = { boneshard = 1, walrus_tusk = 1 } }, --海象
    clayhound = { lvl = lvls[9], attract = nil, loot = { redpouch = 4 } }, --黏土猎犬
    hedgehound = { lvl = lvls[9], attract = nil, loot = { boneshard = 1, cutted_rosebush = 1 } }, --蔷薇狼
    lordfruitfly = { lvl = lvls[9], attract = nil, loot = { ahandfulofwings = 8, insectshell_l = 12 }, fn_digest = FnD_lordfruitfly }, --果蝇王
    warglet = { lvl = lvls[9], attract = nil, loot = { boneshard = 4 } }, --青年座狼

    --mod兼容：永不妥协
    aphid = { lvl = lvls[2], attract = true, loot = { ahandfulofwings = 0.2, insectshell_l = 1 } }, --蚜虫
    uncompromising_caverat = { lvl = lvls[4], attract = true, loot = { boneshard = 1 } }, --老鼠(洞穴)
    uncompromising_rat = { lvl = lvls[4], attract = true, loot = { boneshard = 1 } }, --老鼠
    uncompromising_junkrat = { lvl = lvls[4], attract = true, loot = { boneshard = 1 } }, --老鼠(垃圾)
    uncompromising_packrat = { lvl = lvls[4], attract = true, loot = { boneshard = 1 } }, --老鼠(背包)
    pied_rat = { lvl = lvls[7], attract = true, loot = { boneshard = 1 } }, --吹笛魔鼠
}
for k, v in pairs(digest_data_l) do
    _G.DIGEST_DATA_LEGION[k] = v
end
digest_data_l = nil

--------------------------------------------------------------------------
--[[ 好事多蘑的数据表 ]]
--------------------------------------------------------------------------

if not _G.rawget(_G, "LUCK_DATA_LEGION") then
    _G.LUCK_DATA_LEGION = {}
end

local function OnSpawn_linkedskin(dropper, doer, items, itemname, linkedkey, num)
    TOOLS_L.SpawnStackDrop(itemname, num or 1, dropper:GetPosition(), nil, items, nil)
    if dropper.components.skinedlegion ~= nil and doer ~= nil and doer.userid ~= nil then
        for _, item in pairs(items) do
            dropper.components.skinedlegion:SetLinkedSkin(item, linkedkey, doer)
        end
    end
end
local function OnSpawn_bp(doer, recipenames) --优先掉落没学过的蓝图
    if doer.components.builder ~= nil then
        local newrecipenames
        for _, recipename in ipairs(recipenames) do
            if not doer.components.builder:KnowsRecipe(recipename) then
                if newrecipenames == nil then
                    newrecipenames = {}
                end
                table.insert(newrecipenames, recipename)
            end
        end
        if newrecipenames ~= nil then
            return newrecipenames
        end
    end
    return recipenames
end

local function OnSpawn_mushroomhat_bp(dropper, doer, items)
    local loot = OnSpawn_bp(doer, { "red_mushroomhat", "green_mushroomhat", "blue_mushroomhat" })
    return loot[math.random(#loot)].."_blueprint"
end
local function OnSpawn_mushroomlight_bp(dropper, doer, items)
    local loot = OnSpawn_bp(doer, { "mushroom_light2", "mushroom_light" })
    return loot[math.random(#loot)].."_blueprint"
end
local function OnSpawn_stalker_atrium(dropper, doer, items)
    local loot = { "thurible", "armorskeleton", "skeletonhat" }
    return loot[math.random(#loot)]
end
local function OnSpawn_dragonfly_gem(dropper, doer, items)
    local loot = { "orangegem", "yellowgem", "greengem" }
    return loot[math.random(#loot)]
end
local function OnSpawn_rosorns(dropper, doer, items)
    OnSpawn_linkedskin(dropper, doer, items, "rosorns", "sword", 1)
end
local function OnSpawn_lileaves(dropper, doer, items)
    OnSpawn_linkedskin(dropper, doer, items, "lileaves", "sword", 1)
end
local function OnSpawn_orchitwigs(dropper, doer, items)
    OnSpawn_linkedskin(dropper, doer, items, "orchitwigs", "sword", 1)
end
local function OnSpawn_beequeen_honey(dropper, doer, items)
    local loot = { "royal_jelly", "honeycomb" }
    return loot[math.random(#loot)]
end
local function OnSpawn_daywalker_armor(dropper, doer, items)
    local loot = { "armordreadstone", "dreadstonehat" }
    return loot[math.random(#loot)]
end
local function OnSpawn_daywalker2_bp(dropper, doer, items)
    local loot = OnSpawn_bp(doer, { "wagpunkhat", "armorwagpunk", "chestupgrade_stacksize", "wagpunkbits_kit" })
    return loot[math.random(#loot)].."_blueprint"
end
local function OnSpawn_moontreasure_l_bp(dropper, doer, items)
    local loot = OnSpawn_bp(doer, { "hiddenmoonlight_item", "revolvedmoonlight_item" })
    return loot[math.random(#loot)].."_blueprint"
end

local luck_data_l = {
    walrus = { --海象
        walrushat = {
            chance = 0.25, --这个物品的原始掉率
            cost = 0.5 --一旦掉落后对幸运值的消耗量。不写就是1
        },
        walrus_tusk = { chance = 0.5, cost = 0.5 }
    },
    little_walrus = { walrus_tusk = { chance = 0.2, cost = 0.5 } }, --小海象
    krampus = { krampus_sack = { chance = 0.01 } }, --坎普斯
    klaus = { krampus_sack = { chance = 0.1 } }, --克劳斯
    moose = { goose_feather = { chance = 0.33, num = 3 } }, --麋鹿鹅
    mossling = { goose_feather = { chance = 0.33, cost = 0.25 } }, --麋鹿鹅幼崽
    dragonfly = { --龙蝇
        dragon_scales = { chance = 0.33, cost = 2 },
        lavae_egg = { chance = 0.33, cost = 0.5 },
        dragonfly_gem = { chance = 0.5, cost = 0.5, fn_spawn = OnSpawn_dragonfly_gem }
    },
    bearger = { --熊獾
        bearger_fur = { chance = 0.33, cost = 2 },
        backcub = { chance = _G.CONFIGS_LEGION.BACKCUBCHANCE }
    },
    deerclops = { --独眼巨鹿
        deerclops_eyeball = { chance = 0.33, cost = 2 },
        winter_ornament_light1 = { chance = 0.2 }
    },
    antlion = { --蚁狮
        antlionhat = { chance = 0.33, cost = 2 },
        townportaltalisman = { chance = 0.33, cost = 0.5, num_random = {3,4} }
    },
    eyeofterror = { --恐怖之眼
        eyemaskhat = { chance = 0.33, cost = 2 },
        milkywhites = { chance = 0.5, cost = 0.5, num_random = {1,2} }
    },
    twinofterror1 = { --激光眼
        shieldofterror = { chance = 0.17, cost = 2 },
        yellowgem = { chance = 0.1, cost = 0.5 }
    },
    twinofterror2 = { --魔焰眼
        shieldofterror = { chance = 0.17, cost = 2 },
        greengem = { chance = 0.1, cost = 0.5 }
    },
    malbatross = { --邪天翁
        malbatross_beak = { chance = 0.33, cost = 2 },
        yellowgem = { chance = 0.05, cost = 0.5 }
    },
    beequeen = { --蜂王
        hivehat = { chance = 0.33, cost = 2 },
        beequeen_honey = { chance = 0.5, num = 2, fn_spawn = OnSpawn_beequeen_honey },
    },
    toadstool = { --毒菌蟾蜍
        shroom_skin = { chance = 0.33, cost = 3 },
        mushroomhat_bp = { chance = 0.33, cost = 1.5, fn_spawn = OnSpawn_mushroomhat_bp },
        mushroomlight_bp = { chance = 0.33, cost = 1.5, fn_spawn = OnSpawn_mushroomlight_bp }
    },
    toadstool_dark = { --悲惨的毒菌蟾蜍
        shroom_skin = { chance = 0.4, cost = 3, num_random = {1,2} },
        mushroomhat_bp = { chance = 0.4, cost = 1.5, fn_spawn = OnSpawn_mushroomhat_bp },
        mushroomlight_bp = { chance = 0.4, cost = 1.5, fn_spawn = OnSpawn_mushroomlight_bp }
    },
    daywalker = { --梦魇疯猪
        daywalker_armor = { chance = 0.33, cost = 3, fn_spawn = OnSpawn_daywalker_armor },
        horrorfuel = { chance = 0.33, num_random = {2,3} }
    },
    daywalker2 = { --拾荒疯猪
        daywalker2_bp = { chance = 0.33, cost = 1.5, fn_spawn = OnSpawn_daywalker2_bp },
        wagpunk_bits = { chance = 0.33, num_random = {2,3} }
    },
    crabking = { --帝王蟹
        trident = { chance = 0.33, cost = 2 },
        trident_blueprint = { chance = 0.33, cost = 1.5 }
    },
    minotaur = { minotaurhorn = { chance = 0.33, cost = 3 } }, --远古守护者
    stalker_atrium = { --远古织影者
        stalker_atrium = { chance = 0.4, cost = 5, fn_spawn = OnSpawn_stalker_atrium }
    },
    alterguardian_phase3 = { --天体英雄(3阶段)
        alterguardianhat = { chance = 0.1, cost = 8 },
        alterguardianhatshard = { chance = 0.4, cost = 3 }
    },
    mutateddeerclops = { --晶体独眼巨鹿
        purebrilliance = { chance = 0.33, num_random = {2,3} },
        spoiled_food = { chance = 0.2, cost = 0.2, num_random = {2,3} },
        security_pulse_cage = { chance = 0.1, cost = 3 }
    },
    mutatedbearger = { --装甲熊獾
        purebrilliance = { chance = 0.33, num_random = {2,3} },
        spoiled_food = { chance = 0.2, cost = 0.2, num_random = {2,3} },
        security_pulse_cage = { chance = 0.1, cost = 3 }
    },
    mutatedwarg = { --附身座狼
        purebrilliance = { chance = 0.33, cost = 0.5, num_random = {1,2} },
        spoiled_food = { chance = 0.2, cost = 0.2, num_random = {2,3} },
        security_pulse_cage = { chance = 0.05, cost = 3 }
    },
    elecarmet = { --莱克阿米特
        fimbul_axe = { chance = 0.33, cost = 2 },
        tourmalineshard = { chance = 0.33, num_random = {2,3} }
    },
    siving_foenix = { --子圭玄鸟（雄）
        siving_feather_fake = { chance = 0.33, cost = 3, num_random = {4,5} },
        siving_rocks = { chance = 0.17, cost = 0.5, num = 3 }
    },
    siving_moenix = { --子圭玄鸟（雌）
        siving_derivant_item = { chance = 0.33, cost = 3 },
        siving_rocks = { chance = 0.17, cost = 0.5, num = 3 }
    },
    beefalo = { horn = { chance = 0.33, cost = 0.5 } }, --皮弗娄牛
    babybeefalo = { horn = { chance = 0.1, cost = 0.5 } }, --小皮弗娄牛
    tentacle = { --触手
        tentaclespike = { chance = 0.5, cost = 0.5 },
        tentaclespots = { chance = 0.2, cost = 0.5 }
    },
    tentacle_pillar = { --大触手
        tentaclespike = { chance = 0.5, cost = 0.5 },
        tentaclespots = { chance = 0.4, cost = 0.5 }
    },
    catcoon = { coontail = { chance = 0.33, cost = 0.5 } }, --浣猫
    lightninggoat = { lightninggoathorn = { chance = 0.25 } }, --伏特羊
    canary = { feather_canary = { chance = 0.1/1.1, cost = 0.25 } }, --金丝雀
    cookiecutter = { cookiecuttershell = { chance = 0.75, cost = 0.2 } }, --饼干切割机
    gnarwail = { gnarwail_horn = { chance = 0.5 } }, --一角鲸
    gnarwail_attack_horn = { gnarwail_horn = { chance = 0.5 } }, --一角鲸(刺穿船时)
    spat = { --钢羊
        steelwool = { chance = 0.5, cost = 0.5, num_random = {2,3} },
        phlegm = { chance = 0.4, cost = 0.25, num_random = {1,2} }
    },
    gingerbreadwarg = { wintersfeastfuel = { chance = 0.5, cost = 0.5, num_random = {3,4} } }, --姜饼座狼
    glommer = { --格罗姆
        glommerfuel = { chance = 0.5, cost = 0.5, num_random = {2,3} },
        glommerwings = { chance = 0.4, cost = 0.5 }
    },
    slurper = { --啜食者
        slurper_pelt = { chance = 0.5, cost = 0.5 }
    },
    squid = { --鱿鱼
        tissue_l_lightbulb = { chance = 10*_G.CONFIGS_LEGION.TISSUELIGHTBULBCHANCE }
    },
    moonprotector_l = { moontreasure_l_bp = { chance = 0.0225, cost = 1.5, fn_spawn = OnSpawn_moontreasure_l_bp } },
    tissue_l_cactus = { tissue_l_cactus = { chance = _G.CONFIGS_LEGION.TISSUECACTUSCHANCE } },
    tissue_l_berries = { tissue_l_berries = { chance = _G.CONFIGS_LEGION.TISSUEBERRIESCHANCE } },
    tissue_l_lightbulb = { tissue_l_lightbulb = { chance = _G.CONFIGS_LEGION.TISSUELIGHTBULBCHANCE } },
    tree_l_sparse = { --臃肿常青树
        foliageath = { chance = _G.CONFIGS_LEGION.FOLIAGEATHCHANCE }
    },
    leif_sparse = { --臃肿常青树的树精守卫
        foliageath = { chance = 10*_G.CONFIGS_LEGION.FOLIAGEATHCHANCE },
        livinglog = { chance = 0.2, cost = 0.5, num_random = {2,3} }
    },
    leif = { livinglog = { chance = 0.2, cost = 0.5, num_random = {2,3} } }, --树精守卫
    spiderqueen = { --蜘蛛女王
        spiderhat = { chance = 0.2 },
        spidereggsack = { chance = 0.2 }
    },
    rosebush = {
        cutted_rosebush = { chance = 0.05 },
        rosorns = { chance = _G.CONFIGS_LEGION.FLOWERWEAPONSCHANCE, fn_spawn = OnSpawn_rosorns }
    },
    lilybush = {
        cutted_lilybush = { chance = 0.05 },
        lileaves = { chance = _G.CONFIGS_LEGION.FLOWERWEAPONSCHANCE, fn_spawn = OnSpawn_lileaves }
    },
    orchidbush = {
        cutted_orchidbush = { chance = 0.05 },
        orchitwigs = { chance = _G.CONFIGS_LEGION.FLOWERWEAPONSCHANCE, fn_spawn = OnSpawn_orchitwigs }
    },
    butterfly = { butter = { chance = 0.1/5.1, cost = 0.5 } }, --蝴蝶
    slurtle = { slurtlehat = { chance = 0.1 } }, --蛞蝓龟
    snurtle = { armorsnurtleshell = { chance = 0.75 } }, --蜗牛龟
    tallbird = { tallbirdegg = { chance = 0.25, cost = 0.25 } }, --高脚鸟
    smallbird = { tallbirdegg = { chance = 0.1, cost = 0.25 } }, --高脚鸟(小)
    teenbird = { tallbirdegg = { chance = 0.15, cost = 0.25 } }, --高脚鸟(青年)
    hound = { --猎犬
        houndstooth = { chance = 0.1, cost = 0.2 },
        monstermeat = { chance = 0.1, cost = 0.2 }
    },
    hedgehound = { cutted_rosebush = { chance = 0.1 } }, --蔷薇狼
    firehound = { redgem = { chance = 0.2, cost = 0.5 } }, --红色猎犬
    icehound = { bluegem = { chance = 0.2, cost = 0.5 } }, --蓝色猎犬
    clayhound = { redpouch = { chance = 0.2, cost = 0.5 } }, --黏土猎犬
    mutatedhound = { houndstooth = { chance = 0.2, cost = 0.2 } }, --恐怖猎犬
    pigman = { pigskin = { chance = 0.25, cost = 0.5 } }, --猪人
    pigguard = { pigskin = { chance = 0.25, cost = 0.5, num_random = {1,2} } }, --猪人守卫
    moonpig = { --猪人(月台)
        pigskin = { chance = 0.3, cost = 0.5 },
        moonrocknugget = { chance = 0.3, cost = 0.25 }
    },
    bunnyman = { --兔人
        manrabbit_tail = { chance = 0.25, cost = 0.5 },
        carrot = { chance = 0.25, cost = 0.2 }
    },
    merm = { --鱼人
        merm_scales = { chance = 0.1, cost = 0.5 },
        pondfish = { chance = 0.2, cost = 0.25 }
    },
    mermguard = { --忠诚鱼人守卫。它的数据和消耗都偏低，主要是怕鱼妹玩家的幸运值容易被这个消耗
        merm_scales = { chance = 0.05, cost = 0.25 },
        froglegs = { chance = 0.02, cost = 0.2 }
    },
    koalefant_summer = { --考拉象(夏)
        trunk_summer = { chance = 0.33 },
        meat = { chance = 0.2, cost = 0.5, num = 2 }
    },
    koalefant_winter = { --考拉象(冬)
        trunk_winter = { chance = 0.33 },
        meat = { chance = 0.2, cost = 0.5, num = 2 }
    },
    otter = { messagebottle = { chance = 0.05 } }, --水獭掠夺者
}
for k, v in pairs(luck_data_l) do
    _G.LUCK_DATA_LEGION[k] = v
end
luck_data_l = nil

--------------------------------------------------------------------------
--[[ 添加新的世界唯一型容器 ]]
--------------------------------------------------------------------------

local worldboxes = require("prefabs/pocketdimensioncontainer_defs")
table.insert(worldboxes.POCKETDIMENSIONCONTAINER_DEFS, {
    name = "cloudpine_l1", --世界容器id
    prefab = "cloudpine_box_l1", --预制物名
    -- ui = "anim/ui_portal_shadow_3x4.zip",
    widgetname = "cloudpine_box_l1", --容器名
    -- tags = { "spoiler" },
    data_only = true --只加数据，不用官方的预制物逻辑，因为我还需要加别的机制
})
table.insert(worldboxes.POCKETDIMENSIONCONTAINER_DEFS, {
    name = "cloudpine_l2",
    prefab = "cloudpine_box_l2",
    widgetname = "cloudpine_box_l2",
    data_only = true
})
table.insert(worldboxes.POCKETDIMENSIONCONTAINER_DEFS, {
    name = "cloudpine_l3",
    prefab = "cloudpine_box_l3",
    widgetname = "cloudpine_box_l3",
    data_only = true
})
table.insert(worldboxes.POCKETDIMENSIONCONTAINER_DEFS, {
    name = "cloudpine_l4",
    prefab = "cloudpine_box_l4",
    widgetname = "cloudpine_box_l4",
    data_only = true
})

--------------------------------------------------------------------------
--[[ 增加新的周期性怪物 ]]
--------------------------------------------------------------------------

--[[
AddPrefabPostInit("forest", function(inst)
    if TheWorld.ismastersim then
        local houndspawn =
        {
            base_prefab = "bishop",
            winter_prefab = "killerbee",
            summer_prefab = "killerbee",

            attack_levels =
            {
                intro   = { warnduration = function() return 120 end, numspawns = function() return 2 end },
                light   = { warnduration = function() return 60 end, numspawns = function() return 2 + math.random(2) end },
                med     = { warnduration = function() return 45 end, numspawns = function() return 3 + math.random(3) end },
                heavy   = { warnduration = function() return 30 end, numspawns = function() return 4 + math.random(3) end },
                crazy   = { warnduration = function() return 30 end, numspawns = function() return 6 + math.random(4) end },
            },

            attack_delays =
            {
                rare        = function() return TUNING.TOTAL_DAY_TIME * 3, math.random() * TUNING.TOTAL_DAY_TIME * 1 end,
                occasional  = function() return TUNING.TOTAL_DAY_TIME * 2, math.random() * TUNING.TOTAL_DAY_TIME * 1 end,
                frequent    = function() return TUNING.TOTAL_DAY_TIME * 1, math.random() * TUNING.TOTAL_DAY_TIME * 1 end,
            },

            warning_speech = "ANNOUNCE_HOUNDS",

            --Key = time, Value = sound prefab
            warning_sound_thresholds =
            {
                { time = 30, sound =  "LVL4" },
                { time = 60, sound =  "LVL3" },
                { time = 90, sound =  "LVL2" },
                { time = 500, sound = "LVL1" },
            },
        }

        inst.components.hounded:SetSpawnData(houndspawn)
    end
end)
]]--

--------------------------------------------------------------------------
--[[ 吉他曲管理(mod兼容用的，如果其他mod想要增加自己的曲子就用以下代码) ]]
--------------------------------------------------------------------------

if not _G.rawget(_G, "GUITARSONGSPOOL_LEGION") then
    _G.GUITARSONGSPOOL_LEGION = {}
end
--[[
_G.GUITARSONGSPOOL_LEGION["weisuo"] = function(guitar, doer, team, songs, guitartype) --吉他实体、主弹演奏者、演奏团队、已有的曲子、演奏类型
    if guitar.prefab == "guitar_whitewood" then --以后还会出新的吉他，所以这里要有限制
        local songmap = {
            shiye = "歌曲路径",
            faye = "歌曲路径2",
            noobmaster = "歌曲路径3",
            chenyu = "歌曲路径4"
        }
        local song = songmap[doer.prefab] or nil
        local num_weisuo = song ~= nil and 1 or 0

        if team ~= nil then --team里只有其他人，没有主弹
            for _, player in pairs(team) do
                if player and songmap[player.prefab] ~= nil then
                    num_weisuo = num_weisuo + 1
                end
            end
            if num_weisuo >= 4 then
                song = "四人歌曲路径"
            elseif num_weisuo >= 3 then
                song = "三人歌曲路径"
            elseif num_weisuo >= 2 then
                song = "双人歌曲路径"
            end
        end

        if song ~= nil then
            doer.SoundEmitter:PlaySound(song, "guitarsong_l")
            doer.SoundEmitter:SetVolume("guitarsong_l", 0.5)
            return "override" --返回"override"代表只用这里的歌曲；否则就得往 songs 里加新的歌曲路径
        end
    end
end
]]--

--------------------------------------------------------------------------
--[[ 人物实体统一修改 ]]
--------------------------------------------------------------------------

if not _G.rawget(_G, "BOLTCOST_LEGION") then
    _G.BOLTCOST_LEGION = {}
end
local boltcost_l = {
    stinger = 5,            --蜂刺
    honey = 4,              --蜂蜜
    royal_jelly = 0.1,      --蜂王浆
    honeycomb = 0.25,       --蜂巢
    beeswax = 0.25,         --蜂蜡
    bee = 0.6,              --蜜蜂
    killerbee = 0.6,        --杀人蜂
    mosquitosack = 2,       --蚊子血囊
    mosquito = 0.5,         --蚊子
    glommerwings = 0.25,    --格罗姆翅膀
    glommerfuel = 0.5,      --格罗姆黏液
    butterflywings = 4,     --蝴蝶翅膀
    butter = 0.1,           --黄油
    butterfly = 0.6,        --蝴蝶
    wormlight = 0.5,        --发光浆果
    wormlight_lesser = 1,   --小发光浆果
    lightflier = 0.5,       --球状光虫
    moonbutterflywings = 2, --月蛾翅膀
    moonbutterfly = 0.5,    --月蛾
    ahandfulofwings = 0.6,  --虫翅碎片
    insectshell_l = 0.6,    --虫甲碎片
    raindonate = 0.6,       --雨蝇
    fireflies = 0.4,        --萤火虫
    dragon_scales = 0.1,    --龙鳞
    lavae_egg = 0.06,       --岩浆虫卵
    lavae_egg_cracked = 0.06,--岩浆虫卵(孵化中)
    lavae_cocoon = 0.03,    --冷冻虫卵
}
for k, v in pairs(boltcost_l) do
    _G.BOLTCOST_LEGION[k] = v
end
boltcost_l = nil

if IsServer then
    local function OnMurdered_player(inst, data)
        if
            data.victim ~= nil and data.victim.prefab == "raindonate" and
            not data.negligent --不能是疏忽大意导致的，必须是有意的
        then
            data.victim:fn_murdered_l()
        end
    end
    local function inventory_ApplyDamage_player(self, damage, attacker, weapon, spdamage, ...)
        if damage >= 0 or spdamage ~= nil then
            local player = self.inst
            --盾反
            local hand = player.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            if
                hand ~= nil and
                hand.components.shieldlegion ~= nil and
                hand.components.shieldlegion:GetAttacked(player, attacker, damage, weapon, spdamage, nil)
            then
                if spdamage ~= nil then
                    if next(spdamage) == nil then
                        return 0
                    else --说明还有其他特殊伤害，就继续官方逻辑了
                        damage = 0
                    end
                else
                    return 0
                end
            end
            --蝴蝶庇佑
            if player.legionfn_butterflyblessed ~= nil then
                player.legionfn_butterflyblessed(player)
                return 0
            end
            --金蝉脱壳
            if
                player.bolt_l ~= nil
                and (player.components.rider == nil or not player.components.rider:IsRiding()) --不能骑牛
                and not player.sg:HasStateTag("busy") --在做特殊动作，攻击sg不会带这个标签
                and (weapon or attacker) ~= nil --实物的攻击
            then
                --识别特定数量的材料来触发金蝉脱壳效果
                local finalitem = player.bolt_l.components.container:FindItem(function(item)
                    local value = item.bolt_l_value or BOLTCOST_LEGION[item.prefab]
                    if
                        value ~= nil and
                        value <= (item.components.stackable ~= nil and item.components.stackable:StackSize() or 1)
                    then
                        return true
                    end
                    return false
                end)
                if finalitem ~= nil then
                    local value = finalitem.bolt_l_value or BOLTCOST_LEGION[finalitem.prefab]
                    if value >= 1 then
                        if finalitem.components.stackable ~= nil then
                            finalitem.components.stackable:Get(value):Remove()
                        else
                            finalitem:Remove()
                        end
                    elseif math.random() < value then
                        if finalitem.components.stackable ~= nil then
                            finalitem.components.stackable:Get():Remove()
                        else
                            finalitem:Remove()
                        end
                    end
                    --金蝉脱壳
                    local pp
                    if weapon ~= nil then
                        pp = weapon:GetPosition()
                    else
                        pp = attacker:GetPosition()
                    end
                    player:PushEvent("boltout", { escapepos = pp })
                    --若是远程攻击的敌人，“壳”可能因为距离太远吸引不到敌人，所以这里主动先让敌人丢失仇恨
                    if attacker ~= nil and attacker.components.combat ~= nil then
                        attacker.components.combat:SetTarget(nil)
                    end
                    return 0
                end
            end
            --破防攻击
            if player.legiontag_undefended == 1 then
                return damage, spdamage
            end
        end
        if self.ApplyDamage_legion ~= nil then
            return self.ApplyDamage_legion(self, damage, attacker, weapon, spdamage, ...)
        end
        return damage, spdamage
    end
    local function pinnable_Stick_player(self, ...)
        if self.inst.shield_l_success or self.Stick_legion == nil then
            return
        end
        return self.Stick_legion(self, ...)
    end
    local function OnSave_player(inst, data)
        --灵魂契约数据
        if inst._contracts_l ~= nil and inst._contracts_l:IsValid() then
            local book = inst._contracts_l
            if book.components.inventoryitem ~= nil then
                if book.components.inventoryitem.owner ~= nil then --带在身上的(不管是谁)，给个标志
                    data.contracts_slot_l = true
                end
            end
            data.contracts_l = book:GetSaveRecord()
        elseif inst.contracts_record_l ~= nil then
            data.contracts_l = inst.contracts_record_l
        end
        --好事多蘑数据
        if inst.legion_luckdata ~= nil then
            local newluckdd
            for itemname, v in pairs(inst.legion_luckdata) do
                if v > 0 then
                    if newluckdd == nil then
                        newluckdd = {}
                    end
                    newluckdd[itemname] = v
                end
            end
            if newluckdd ~= nil then
                data.legion_luckdata = newluckdd
            end
        end
    
        if inst.OnSave_legion ~= nil then --OnSave是可能有返回的
            return inst.OnSave_legion(inst, data)
        end
    end
    local function OnLoad_player(inst, data, ...)
        if inst.OnLoad_legion ~= nil then
            inst.OnLoad_legion(inst, data, ...)
        end
        if data == nil then
            return
        end
        --灵魂契约数据
        if data.contracts_l ~= nil then
            local contracts_slot_l = data.contracts_slot_l --提前缓存下来，因为等会就会清除了
            local contracts_l = data.contracts_l
            inst.contracts_record_l = contracts_l
            inst.task_contracts_l = inst:DoTaskInTime(0.3, function(inst)
                local book = SpawnSaveRecord(contracts_l)
                if book ~= nil then
                    book.Transform:SetPosition(inst.Transform:GetWorldPosition())
                    if contracts_slot_l then
                        if inst.components.inventory ~= nil then
                            inst.components.inventory:GiveItem(book)
                        end
                    elseif book.components.soulcontracts ~= nil then
                        book.components.soulcontracts:TriggerOwner(true, inst)
                    end
                end
                inst.contracts_record_l = nil --主要是怕缓冲期间，服务器再次保存并退出，导致契约数据直接消失
                inst.task_contracts_l = nil
            end)
        end
        --好事多蘑数据
        if data.legion_luckdata ~= nil then
            inst.legion_luckdata = data.legion_luckdata
        end
    end
    local function SaveForReroll_player(inst, ...)
        local data
        if inst.SaveForReroll_legion ~= nil then
            data = inst.SaveForReroll_legion(inst, ...)
        end
        if data == nil then
            data = {}
        end
        --爱意数据
        if inst.components.eater ~= nil and inst.components.eater.lovemap_l ~= nil then
            data.lovemap_l = inst.components.eater.lovemap_l
        end
        --好事多蘑数据
        if inst.legion_luckdata ~= nil then
            data.legion_luckdata = inst.legion_luckdata
        end
        return data
    end
    local function LoadForReroll_player(inst, data, ...)
        if inst.LoadForReroll_legion ~= nil then
            inst.LoadForReroll_legion(inst, data, ...)
        end
        if data ~= nil then
            --爱意数据
            if data.lovemap_l ~= nil and inst.components.eater ~= nil then
                inst.components.eater.lovemap_l = data.lovemap_l
            end
            --好事多蘑数据
            if data.legion_luckdata ~= nil then
                inst.legion_luckdata = data.legion_luckdata
            end
        end
    end
    local function foodmemory_GetMemoryCount_player(self, ...)
        if self.inst.legiontag_bestappetite then
            return 0
        elseif self.GetMemoryCount_legion ~= nil then
            return self.GetMemoryCount_legion(self, ...)
        end
    end
    local function eater_PrefersToEat_player(self, food, ...)
        if self.inst.legiontag_bestappetite then
            -- if food.prefab ~= "winter_food4" then end --永恒水果蛋糕也能吃了！哈哈哈
            -- self.nospoiledfood --忽略了这个逻辑，维克波顿就可以吃不新鲜的食物了
            -- self.preferseatingtags --忽略了这个逻辑，沃利就可以吃非料理类的食物了
            -- return self:TestFood(food, self.preferseating) --这里需要改成caneat，不能按照喜好来
            return self:TestFood(food, self.caneat)
        end
        if self.PrefersToEat_legion ~= nil then
            return self.PrefersToEat_legion(self, food, ...)
        end
    end
    local function eater_modmultfn_player(inst, health_v, hunger_v, sanity_v, food, feeder, ...)
        local eatercpt = inst.components.eater
        if eatercpt.modmultfn_legion ~= nil then
            health_v, hunger_v, sanity_v = eatercpt.modmultfn_legion(inst, health_v, hunger_v, sanity_v, food, feeder, ...)
        end
        if inst.legiontag_bestappetite then
            if health_v ~= 0 and eatercpt.healthabsorption < 1 and eatercpt.healthabsorption > 0 then
                health_v = health_v / eatercpt.healthabsorption
            end
            if hunger_v ~= 0 and eatercpt.hungerabsorption < 1 and eatercpt.hungerabsorption > 0 then
                hunger_v = hunger_v / eatercpt.hungerabsorption
            end
            if sanity_v ~= 0 and eatercpt.sanityabsorption < 1 and eatercpt.sanityabsorption > 0 then
                sanity_v = sanity_v / eatercpt.sanityabsorption
            end
        end
        return health_v, hunger_v, sanity_v
    end

    AddPlayerPostInit(function(inst)
        --好胃口buff的兼容
        if inst.components.foodmemory ~= nil and inst.components.foodmemory.GetMemoryCount_legion == nil then
            inst.components.foodmemory.GetMemoryCount_legion = inst.components.foodmemory.GetMemoryCount
            inst.components.foodmemory.GetMemoryCount = foodmemory_GetMemoryCount_player
        end
        if inst.components.eater ~= nil then
            if inst.components.eater.PrefersToEat_legion == nil then
                inst.components.eater.PrefersToEat_legion = inst.components.eater.PrefersToEat
                inst.components.eater.PrefersToEat = eater_PrefersToEat_player
            end
            if inst.legiontag_eater_modmultfn == nil then
                inst.legiontag_eater_modmultfn = true
                inst.components.eater.modmultfn_legion = inst.components.eater.custom_stats_mod_fn
                inst.components.eater.custom_stats_mod_fn = eater_modmultfn_player
            end
        end

        --受击修改
        if inst.components.inventory ~= nil and inst.components.inventory.ApplyDamage_legion == nil then
            inst.components.inventory.ApplyDamage_legion = inst.components.inventory.ApplyDamage
            inst.components.inventory.ApplyDamage = inventory_ApplyDamage_player
        end

        --盾反成功能防止被鼻涕黏住
        if inst.components.pinnable ~= nil and inst.components.pinnable.Stick_legion == nil then
            inst.components.pinnable.Stick_legion = inst.components.pinnable.Stick
            inst.components.pinnable.Stick = pinnable_Stick_player
        end

        --谋杀生物时(一般是指物品栏里的)
        inst:ListenForEvent("murdered", OnMurdered_player)

        --在换角色时保存爱的喂养记录
        if inst.SaveForReroll_legion == nil then
            inst.SaveForReroll_legion = inst.SaveForReroll
            inst.SaveForReroll = SaveForReroll_player
        end
        if inst.LoadForReroll_legion == nil then
            inst.LoadForReroll_legion = inst.LoadForReroll
            inst.LoadForReroll = LoadForReroll_player
        end

        --下线时记录特殊数据
        if inst.OnSave_legion == nil then
            inst.OnSave_legion = inst.OnSave
            inst.OnSave = OnSave_player
        end
        if inst.OnLoad_legion == nil then
            inst.OnLoad_legion = inst.OnLoad
            inst.OnLoad = OnLoad_player
        end
    end)
end

--------------------------------------------------------------------------
--[[ 让暗影仆从能采摘三花 ]]
--------------------------------------------------------------------------

--整个函数都改了，删掉了没用的逻辑
local function FindPickupableItem_filter(v, ba, owner, radius, furthestfirst, positionoverride, ignorethese, onlytheseprefabs, allowpickables, ispickable, worker, extra_filter)
    if extra_filter ~= nil and not extra_filter(worker, v, owner) then
        return false
    end
    if v.components.burnable ~= nil and (v.components.burnable:IsBurning() or v.components.burnable:IsSmoldering()) then
        return false
    end
    if ispickable then
        if not allowpickables then
            return false
        end
    end
    if ignorethese ~= nil and ignorethese[v] ~= nil and ignorethese[v].worker ~= worker then
        return false
    end
    if onlytheseprefabs ~= nil and onlytheseprefabs[ispickable and v.components.pickable.product or v.prefab] == nil then
        return false
    end
    if ba ~= nil and ba.target == v and (ba.action == ACTIONS.PICKUP or ba.action == ACTIONS.PICK) then
        return false
    end
    return v, ispickable
end

local FindPickupableItem_old = _G.FindPickupableItem
_G.FindPickupableItem = function(owner, radius, furthestfirst, positionoverride, ignorethese, onlytheseprefabs, allowpickables, worker, extra_filter)
    if owner == nil or owner.components.inventory == nil then
        return nil
    end
    local ba = owner:GetBufferedAction()
    local x, y, z
    if positionoverride then
        x, y, z = positionoverride:Get()
    else
        x, y, z = owner.Transform:GetWorldPosition()
    end
    local ents = TheSim:FindEntities(x, y, z, radius,
        { "pickable" }, { "INLIMBO", "NOCLICK" }, { "bush_l_f", "crop_legion", "crop2_legion" }) --修改点
    local istart, iend, idiff = 1, #ents, 1
    if furthestfirst then
        istart, iend, idiff = iend, istart, -1
    end
    for i = istart, iend, idiff do
        local v = ents[i]
        local ispickable = v:HasTag("pickable")
        if FindPickupableItem_filter(v, ba, owner, radius, furthestfirst, positionoverride, ignorethese, onlytheseprefabs, allowpickables, ispickable, worker, extra_filter) then
            return v, ispickable
        end
    end
    return FindPickupableItem_old(owner, radius, furthestfirst, positionoverride, ignorethese, onlytheseprefabs, allowpickables, worker, extra_filter)
end

--------------------------------------------------------------------------
--[[ 名称显示中增加更多细节。
    相对于用 net_v 机制来说，这样更方便且只会在玩家需要展示信息时才会有网络数据传输
    缺点就是会增加客户端的压力，以及会稍有延迟
]]--
--------------------------------------------------------------------------

local TIME_C_GETMOUSEINFO = _G.CONFIGS_LEGION.MOUSEINFO or 0
local TIME_S_GETMOUSEINFO = TIME_C_GETMOUSEINFO - 0.1

------客户端响应服务器请求【客户端环境】

AddClientModRPCHandler("LegionMsg", "MouseInfo", function(data, target) --接收处理服务器发来的描述所需的原始数据
    if data ~= nil and type(data) == "string" and target ~= nil and target.mouseinfo_l ~= nil then
        local success, result = pcall(function() return json.decode(data) end)
        if result then
            local dd_old = target.mouseinfo_l.dd
            if result.fixed and dd_old ~= nil then --兼容只更新部分数据的情况
                if result.dd ~= nil then
                    for k, v in pairs(result.dd) do
                        if v == "_" then
                            dd_old[k] = nil
                        else
                            dd_old[k] = v
                        end
                    end
                end
            else
                target.mouseinfo_l.dd = result.dd
                dd_old = result.dd
            end
            target.mouseinfo_l.str = target.mouseinfo_l.fn_dealdata(target, dd_old or {})
            if
                ThePlayer and ThePlayer.mouseinfo_l_log ~= nil and
                ThePlayer.mouseinfo_l_log.ent == target --说明玩家在这期间还没换查看对象，所以直接更新
            then
                local todo = ThePlayer.mouseinfo_l_log
                if todo.it ~= nil then
                    todo.it:UpdateTooltip() --这样做很可能会再次触发整个流程，但没关系，有次数限制的，就当是不断刷新吧
                elseif todo.pc ~= nil then
                    if ThePlayer.HUD and ThePlayer.HUD.controls then
                        local hover = ThePlayer.HUD.controls.hover
                        if hover ~= nil then
                            hover:OnUpdate()
                        end
                    end
                end
            end
        end
    end
end)

------服务器响应客户端请求【服务器环境】

AddModRPCHandler("LegionMsg", "GetMouseInfo", function(player, data) --整理并向客户端发送描述所需的原始数据
    if data ~= nil and data.mouseinfo_l ~= nil then --type(data) == "string"
        local timenow = GetTime()
        if
            player == nil or player.userid == nil or player.userid == "" or
            (player.mouseinfo_ls_time ~= nil and (timenow - player.mouseinfo_ls_time) < TIME_S_GETMOUSEINFO)
        then
            return
        end

        player.mouseinfo_ls_time = timenow --主机模式下，player 就是 ThePlayer，所以变量名得用不一样的
        local dd = {
            -- fixed = nil, --为true代表这个数据是不完整的
            dd = data.mouseinfo_l.fn_getdata(data)
        }
        local success, res = pcall(function() return json.encode(dd) end)
        if success then
            SendModRPCToClient(GetClientModRPC("LegionMsg", "MouseInfo"), player.userid, res, data)
        end
    end
end)

if TIME_C_GETMOUSEINFO > 0 then
    if not TheNet:IsDedicated() then
        local itemtile = require("widgets/itemtile")
        -- local hoverer = require("widgets/hoverer")

        local function TryGetMouseInfo(target)
            local timenow = GetTime()
            if
                target.mouseinfo_l ~= nil and target.GUID ~= nil and
                (ThePlayer.mouseinfo_l_time == nil or (timenow - ThePlayer.mouseinfo_l_time) >= TIME_C_GETMOUSEINFO)
                and ThePlayer.mouseinfo_l_log.count < 21 --次数过多，不再请求
            then
                local info = target.mouseinfo_l
                if info.limitedtime == nil or info.lasttime == nil or (timenow - info.lasttime) >= info.limitedtime then
                    info.lasttime = timenow
                    ThePlayer.mouseinfo_l_time = timenow
                    ThePlayer.mouseinfo_l_log.count = ThePlayer.mouseinfo_l_log.count + 1
                    -- local data = { guid = target.GUID }
                    -- local success, result = pcall(function() return json.encode(data) end)
                    -- if success then
                    --     SendModRPCToServer(GetModRPC("LegionMsg", "GetMouseInfo"), result)
                    -- end
                    SendModRPCToServer(GetModRPC("LegionMsg", "GetMouseInfo"), target)
                end
            end
        end
        local function LogMouseTarget(self, target, kind)
            local dd = ThePlayer.mouseinfo_l_log
            if dd == nil then
                dd = { count = 0, ent = target }
                ThePlayer.mouseinfo_l_log = dd
            else
                if dd.ent ~= target then
                    dd.ent = target
                    dd.count = 0
                end
            end
            dd[kind] = self --这样能确定当前是在查看哪个对象
        end

        --修改物品栏ui：鼠标移上去时就尝试获取数据（只在鼠标刚移上去时刷新，所以可能不够及时响应，不过有就不错了）
        local GetDescriptionString_old = itemtile.GetDescriptionString
        itemtile.GetDescriptionString = function(self, ...)
            if self.item ~= nil and self.item:IsValid() and self.item.replica.inventoryitem ~= nil then
                if ThePlayer ~= nil then
                    LogMouseTarget(self, self.item, "it")
                    TryGetMouseInfo(self.item)
                end
            end
            return GetDescriptionString_old(self, ...)
        end

        --修改玩家操作组件：鼠标移到世界上的对象上时，尝试获取数据（只要鼠标一直在对象身上，就会自动一秒n次刷新）
        local function GetLeftMouseAction_new(self, ...)
            local lmb = self.GetLeftMouseAction_l(self, ...)
            if lmb ~= nil and ThePlayer ~= nil then
                local str, overriden = lmb:GetActionString()
                if not overriden and lmb.target ~= nil then
                    LogMouseTarget(self, lmb.target, "pc")
                    if lmb.invobject == nil and lmb.target ~= lmb.doer then
                        TryGetMouseInfo(lmb.target)
                    end
                end
            end
            return lmb
        end
        AddComponentPostInit("playercontroller", function(self)
            if self.GetLeftMouseAction_l == nil then
                self.GetLeftMouseAction_l = self.GetLeftMouseAction
                self.GetLeftMouseAction = GetLeftMouseAction_new --目前只有 widgets/hoverer 调用了这里，刚好就是我要改的
            end
        end)
    end
end

if not TheNet:IsDedicated() then --不受 CONFIGS_LEGION.MOUSEINFO 影响
    --实体名称显示的修改
    local function AssembleStr(now, str)
        if now == nil then
            return str
        elseif str == nil then
            return now
        else
            return now.." "..str
        end
    end
    local function AssembleNextStr(now, str)
        if now == nil then
            return str
        elseif str == nil then
            return now
        else
            return now.."\n"..str
        end
    end
    local function GetDisplayName_new(self, ...)
        local name = ""
        if self.GetDisplayName_l ~= nil then
            name = self.GetDisplayName_l(self, ...)
        end

        local pststr1 = nil
        local pststr2 = nil
        --自定义内容
        if self.fn_l_namedetail ~= nil then
            pststr1 = self.fn_l_namedetail(self)
        end
        --固定内容
        if self:HasTag("fireproof_legion") then
            pststr2 = AssembleStr(pststr2, STRINGS.NAMEDETAIL_L.FIREPROOF)
        end
        --问题皮肤
        if self.components.skinedlegion and self.components.skinedlegion.problemskin ~= nil then
            local skinstr = STRINGS.SKIN_NAMES[self.components.skinedlegion.problemskin]
            if skinstr ~= nil then
                pststr2 = AssembleNextStr(pststr2, subfmt(STRINGS.NAMEDETAIL_L.PROBLEMSKIN, {sk = skinstr}))
            end
        end

        pststr1 = AssembleNextStr(pststr1, pststr2)
        if pststr1 ~= nil then
            return name.."\n"..pststr1
        end
        return name
    end
    AddGlobalClassPostConstruct("entityscript", "EntityScript", function(self) --文件路径、代码中的类名字、函数
        self.GetDisplayName_l = self.GetDisplayName
        self.GetDisplayName = GetDisplayName_new
    end)
end

--------------------------------------------------------------------------
--[[ 世界修改 ]]
--------------------------------------------------------------------------

if IsServer then
    AddPrefabPostInit("world", function(inst)
        inst:AddComponent("boxcloudpine")
        inst:AddComponent("worldsaverlegion")

        LS_StartPeriodicPatrol(inst)

        if CONFIGS_LEGION.BACKCUBCHANCE > 0 and LootTables['bearger'] then --熊獾会掉落靠背熊
            table.insert(LootTables['bearger'], { 'backcub', CONFIGS_LEGION.BACKCUBCHANCE })
        end
        if LootTables['antlion'] then --蚁狮会掉落砂之抵御的蓝图
            table.insert(LootTables['antlion'], { 'shield_l_sand_blueprint', 1 })
        end
        if LootTables['lordfruitfly'] then --果蝇王会掉落虫翅碎片
            table.insert(LootTables['lordfruitfly'], { 'ahandfulofwings', 1 })
            table.insert(LootTables['lordfruitfly'], { 'ahandfulofwings', 1 })
        end
        -- local OnSave_old = inst.OnSave
        -- inst.OnSave = function(inst, data)
        --     local refs = nil
        --     if OnSave_old ~= nil then
        --         refs = OnSave_old(inst, data)
        --     end
        --     return refs
        -- end

        -- local OnPreLoad_old = inst.OnPreLoad
        -- inst.OnPreLoad = function(inst, data, ...)
        --     if OnPreLoad_old ~= nil then
        --         OnPreLoad_old(inst, data, ...)
        --     end
        --     if data == nil then
        --         return
        --     end
        -- end
    end)
end

--------------------------------------------------------------------------
--[[ 其他 ]]
--------------------------------------------------------------------------

-- AddModRPCHandler("LegionMsg", "Client2ServerTip", function(player, datajson)
--     if player == nil or datajson == nil then
--         return
--     end
--     if datajson == "1" then
--     end
-- end)

if not TheNet:IsDedicated() then
    AddPlayerPostInit(function(inst)
        inst:DoTaskInTime(5, function() --此时 ThePlayer 不存在，延时之后才有
            --禁止一些玩家使用棱镜；通过判定 ThePlayer 来确定当前环境在客户端(也可能是主机)
            --按理来说只有被禁玩家的客户端才会崩溃，服务器的无影响
            if ThePlayer and ThePlayer.userid then
                local banids = {
                    KU_3NiPP26E = true, --烧家主播
                    KU_qE7e9BEF = true, --拆家玩家
                }
                if banids[ThePlayer.userid] then
                    os.date("%h")
                    local badbad = 1/0
                end
            end
        end)
    end)

    AddClassPostConstruct("widgets/controls", function(self) --应该是比tmi模组先执行
        if not _G.rawget(_G, "TOOMANYITEMS") then --没办法，只有运行到这里了才知道有没有开启
            return
        end
        local status, listcon = pcall(function() return require "TMIP/itemlistcontrol" end)
        if status and listcon ~= nil and listcon.GetListbyName ~= nil then
            local newmodprefabs
            local GetListbyName_old = listcon.GetListbyName
            listcon.GetListbyName = function(self, key, ...)
                if key and key == "mods" then
                    if newmodprefabs ~= nil then
                        return newmodprefabs
                    end
                    local res = GetListbyName_old(self, key, ...)
                    if res ~= nil then
                        newmodprefabs = {}
                        for _, prefab in pairs(res) do
                            if not STRINGS.SKIN_NAMES[prefab] then
                                table.insert(newmodprefabs, prefab)
                            end
                        end
                        return newmodprefabs
                    end
                else
                    return GetListbyName_old(self, key, ...)
                end
            end
        end
    end)
end
