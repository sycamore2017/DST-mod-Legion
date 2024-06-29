--------------------------------------------------------------------------
--[[ 编码小贴士 ]]
--------------------------------------------------------------------------

--[[ Follower组件讲解 Tip:
    ▷ inst.entity:AddFollower() 使用这个添加该组件
    ▷ inst.Follower:FollowSymbol(owner.GUID, "swap_object", nil, nil, nil, true, nil, 0, 3)
        1、参数分别为 实体ID，跟随通道名，偏移量x，偏移量y，偏移量z，是否替换贴图位置，未知，默认贴图下标，连续替换的贴图下标
        2、例子中的意思就是 inst 这个实体跟随 owner 的 swap_object 通道，并替换位置 0到3 的通道内贴图
    ▷ inst.Follower:FollowSymbol(owner.GUID, "swap_body", nil, nil, nil, true, nil, 5)
        1、例子中的意思就是 inst 这个实体跟随 owner 的 swap_body 通道，并替换位置为 5 的通道内贴图
        2、如果最后两个参数都不填写，就代表把所有位置的贴图都替换掉
    ▷ inst.Follower:StopFollowing() 让 inst 停止跟随通道
]]--

--[[ RPC使用讲解 Tip:
    !参数建议弄成数字类型或者字符类型；如果是表，可以转成json字符再发送
    !!参数是可以直接填写一个有网络组件的实体的：
        逻辑上并不会把整个实体都发送出去，而是只使用了部分数据
        一个实体在服务器与客户端的 GUID 并不一致，没法直接对应
        官方逻辑是根据 netid 自动对应客户端和服务器的实体
        需要注意，客户端收到数据时，若实体不在玩家加载范围内，则参数很可能传来的是空值

    【客户端发送请求给服务器】
        SendModRPCToServer(GetModRPC("LegionMsg", "operate"), 参数2, 参数3, ...)
    【服务器响应客户端请求】
        AddModRPCHandler("LegionMsg", "operate", function(player, 参数2, ...) --第一个参数固定为发起请求的玩家
            --做你想做的
        end)

    【服务器发送请求给客户端】
        SendModRPCToClient(GetClientModRPC("LegionMsg", "operate"), 玩家ID, 参数2, 参数3, ...)
        --若 玩家ID 为table，则服务器会向table里的全部玩家ID都发送请求
    【客户端响应服务器请求】
        AddClientModRPCHandler("LegionMsg", "operate", function(参数2, ...) --通过 ThePlayer 确定客户端玩家
            --做你想做的
        end)

    【服务器发送请求给服务器】
        SendModRPCToShard(GetShardModRPC("LegionMsg", "operate"), 服务器ID, 参数2, 参数3, ...)
        --若 服务器ID 为nil，则服务器会向所有服务器(包括发起请求的这个服务器自己)发送请求
        --若 服务器ID 为table，则服务器会向table里的全部玩家ID都发送请求
    【服务器响应服务器请求】
        --使用右边代码能获取所有的服务器信息：local connected_shards = Shard_GetConnectedShards()
        AddShardModRPCHandler("LegionMsg", "operate", function(shardid, 参数2, ...) --第一个参数为发起请求的服务器id
            --做你想做的
        end)
]]--

--[[ 关于世界 Tip：
    开了洞穴的世界(其实也算专服)：房主服务器进程(地面+洞穴)、房主客户端进程、其他人客户端进程
    不开洞穴的世界：房主地面服务器进程(也是房主客户端进程，是一体的)、其他人客户端进程
    专服(云服)的世界：专服服务器进程(地面+洞穴+或其他世界)、任何人客户端进程

    TheNet:GetIsMasterSimulation()  --暂不清楚和 TheNet:GetIsServer() 的区别
    TheNet:GetIsServer()            --是否为服务器进程(所有服务器进程，也包括 不开洞穴的房主客户端进程)
    TheNet:IsDedicated()            --是否为单纯的服务器进程(带洞穴的服务器进程+专服的服务器进程。只跑进程，不运行ui)
    TheNet:GetIsClient()            --是否为单纯的客户端进程(任何人客户端进程，不包括 不开洞穴的房主客户端进程)

    TheShard对应一个进程(世界)，多个世界就会有一个主世界，其它的世界都是副进程(从世界)
    TheShard:IsSecondary()          --是否为副进程(所以，not TheShard:IsSecondary() 就能确定是主进程了)
    TheShard:GetShardId()           --获取当前进程的ID
    --注意以上 TheShard 判定在客户端使用不能拿到正确的结果

    not TheNet:IsDedicated()    --是否为客户端或不开洞穴的房主服务器进程(因为这个进程也是房主客户端进程)
    TheWorld.ismastersim        --是否为服务器进程(可以说就是 TheNet:GetIsServer())
    TheWorld.ismastershard      --是否为服务器主进程(本质上就是 TheWorld.ismastersim and not TheShard:IsSecondary())
]]--

--[[ combat机制 Tip:
1、Combat:DoAttack(targ, weapon, projectile, stimuli, instancemult, instrangeoverride, instpos)
    ▷stimuli：可以 weapon.overridestimulifn 自定义，如果有攻击者自己有 buff_electricattack，则为 electric
    ▷攻击距离：敌人物理半径+攻击者攻击距离+武器攻击距离。玩家的 hitrange 默认为3，武器的 hitrange 默认为0
    ▷攻击带电：攻击本身是带电的(stimuli == "electric")，或者武器带电(weapon.stimuli == "electric")
    ▷攻击反伤：判定在攻击前，执行在攻击后。反伤给攻击者，由敌人以及敌人所戴装备自定义逻辑
    ▷标签系数：damagetypebonus组件 通过敌人的标签，来给攻击与特殊攻击提供额外 乘法系数
    ▷暂时系数：instancemult(默认1)，表示是这次攻击的暂时性的系数，会与 最终攻击力(普攻) 相乘
    ▷基础的特攻计算(比如位面攻击)：
        basedamage --某个对象的基础特殊攻击
        * self.externalmultipliers:Get() --兼容性乘法系数
        + self.externalbonuses:Get() --兼容性加法数值
    ▷最终攻击力(普攻)：
        basedamage --(1)如果骑行，为骑行对象的 基础攻击+鞍具的额外攻击：combat.defaultdamage+saddler:GetBonusDamage()
                   --(2)如果空手，为攻击者的 基础攻击：combat.defaultdamage
                   --(3)如果有武器，为武器的 基础攻击x标签系数(默认1)：weapon:damage*damagetypebonus:GetBonus(敌人)
        * basemultiplier --(1)如果骑行，为骑行对象的 基础攻击系数(默认1)：combat.damagemultiplier
                         --(2)其他，为攻击者的 基础攻击系数(默认1)：combat.damagemultiplier
        * externaldamagemultipliers:Get() --额外攻击系数(默认1)，内部是乘法计算。多数mod都是改的这里
        * damagetypemult --(1)如果骑行，为骑行对象的 标签系数(默认1)x鞍具提供的标签系数(默认1)：damagetypebonus:GetBonus(敌人)*damagetypebonus:GetBonus(敌人)
                         --(2)其他，为攻击者的 标签系数(默认1)：damagetypebonus:GetBonus(敌人)
        * multiplier --电系加成系数(默认1)：若攻击带电，敌人无电系防御，就为1.5，若敌人潮湿了，根据潮湿程度，最终为1.5-2.5
        * playermultiplier --若空手或骑行，敌人为玩家，则为攻击者的 对玩家系数(默认1)：self.playerdamagepercent
        * pvpmultiplier --若敌我双方都是玩家，则为攻击者的 pvp系数(默认1)：self.pvp_damagemod
        * self.customdamagemultfn() --角色系数：攻击者根据一定逻辑，提供该系数(默认1)，比如旺达和温蒂就有该逻辑
        + bonus --(1)如果骑行，为骑行对象的 叠加攻击(默认0)：combat.damagebonus
                --(2)其他，为攻击者的 叠加攻击(默认0)：combat.damagebonus
    ▷最终攻击力(特攻，比如位面攻击)：
        spdamage(是个表，非数字) --(1)如果骑行，为骑行对象的 特殊攻击+鞍具的特殊攻击：CollectSpDamage()
                                --(2)如果空手，为攻击者的 特殊攻击：CollectSpDamage()
                                --(3)如果有武器，为武器的 特殊攻击x标签系数(默认1)：CollectSpDamage()*damagetypebonus:GetBonus(敌人)
        * damagetypemult --与普攻的逻辑相同
        -- * playermultiplier --与普攻的逻辑相同(已被注释)
        * pvpmultiplier --与普攻的逻辑相同

2、Combat:GetAttacked(attacker, damage, weapon, stimuli, spdamage)
    ▷闪避：根据 attackdodger组件，一旦闪避成功，两种最终攻击力(普攻与特攻)都会被设置为0：attackdodger:Dodge()
    ▷替身：根据被攻击者的 self.redirectdamagefn() 得到替身，由替身进行伤害计算与结算，但自己依然会触发受击事件之类的逻辑。比如骑牛时，牛替玩家挡伤害
    ▷装备防御：如果被攻击者有物品栏组件，则进行以下逻辑
        --标签抵挡：若装备有 resistance组件，则在攻击者或武器有组件里的对应标签时，两种最终攻击力设为0，逻辑结束
        --护甲系数：若装备有 armor组件，则最终护甲系数为所有护甲系数中的最大值
        --标签系数：若装备有 damagetyperesist组件，则在攻击者或武器有组件里的对应标签时，提供一个系数值(所有装备系数累乘)
    ▷装备普攻损耗：根据所有具有 armor组件的装备，各自的损耗=伤害*标签系数*最大护甲系数*该装备的护甲系数/所有装备的护甲系数之和
    ▷装备普攻额外损耗：装备通过一定逻辑，可能会受到额外的损耗：armor:GetBonusDamage(attacker, weapon)。比如海狸的攻击会对木甲有额外损耗
    ▷装备特攻损耗：循环每种特殊攻击值
        1、特殊攻击力 = 特殊攻击力*所有装备的标签系数累乘
        2、特殊防御装备：获取装备栏中所有具备对应特殊防御力的装备
        3、由所有 特殊防御装备 尽可能平均地吸收 特殊攻击力，吸收多少特殊攻击力就会消耗多少耐久
    ▷基础的特防计算(比如位面防御)：
        basedefense --某个对象的基础特殊防御
        * self.externalmultipliers:Get() --兼容性乘法系数
        + self.externalbonuses:Get() --兼容性加法数值
    ▷鞍具标签系数：若骑行的鞍具具有 damagetyperesist组件，则在攻击者或武器有组件里的对应标签时，提供一个系数值
    ▷自身标签系数：若被攻击者具有 damagetyperesist组件，则在攻击者或武器有组件里的对应标签时，提供一个系数值
    ▷额外受击系数：被攻击者自身的伤害系数：self.externaldamagetakenmultipliers:Get()，内部是乘法计算。多数mod都是改的这里
    ▷额外攻击值：combat.bonusdamagefn()，攻击者根据一定逻辑，提供该数值，比如蜂后和蜜蜂就有该逻辑
    ▷最终普攻伤害值1：
        damage --传参。可能是由 Combat:DoAttack() 而来，也可能是 Combat:GetAttacked() 直接设置的数值
        * 所有装备的标签系数累乘 * (1 - 所有护甲系数中的最大值)
        * 鞍具标签系数 * 自身标签系数 * 额外受击系数
        + 额外受击系数 * 额外攻击值
    ▷最终特攻伤害值：如果最终结果不大于0，则不参与计算，代表完全防御住了
        ( ( spdamage(是个表，非数字) --传参。可能是由 Combat:DoAttack() 而来，也可能是 Combat:GetAttacked() 直接设置的数值
            * 所有装备的标签系数累乘 ) - 所有具有对应特殊防御的装备的特殊防御值之和 - 被攻击者自身对应的的特殊防御值
        ) * 鞍具标签系数 * 自身标签系数
    ▷位面生物抵抗：若被攻击者有 planarentity组件，则减免普攻伤害
        --最终普攻伤害值2 = (√(最终普攻伤害值1 * 4 + 64) - 8) *4 --公式含义：伤害越高，减免比例越高，比如10->8.8、100->54
    ▷最终伤害 = 最终普攻伤害值2 + 最终特攻伤害值 --有的对象还有生命损失减免，比如女武神，但这里只考虑战斗伤害

3、紧急提醒：不要给手部装备添加位面防御组件。
        因为官方的逻辑 Inventory:ApplyDamage() 中，将抵挡的位面伤害平摊给带有位面防御的装备时，
        splitdmg = dmg / 带有位面防御的装备的数量。当装备数量为3时(也就是玩家穿戴了3个位面防御的装备)，
        会导致 splitdmg 可能会除不尽，在代码层面，就有 N/3*3 < N 这种情况发生，
        也就导致 dmg = dmg - splitdmg*3，dmg 这个值会有永远大于0的情况
        其中的循环达成条件，while dmg > 0 and count > 0 do，在位面均摊的伤害比每个装备的位面防御都小时，就会导致
        循环条件永远达成，游戏进程就会卡在这个循环里，导致“崩溃”
        而官方没发现这个问题，是因为官方目前没有手部的位面防御装备，装备数量不会为3，也就不会有除不尽的情况。
    *如果非要手部装备能有位面防御，可以在玩家穿戴这个装备时，给玩家自身加上位面防御
]]--

--[[ 关于 LoadPostPass() 和 POPULATING 的意义 Tip：
    世界启动开始时，POPULATING = true，
    世界实体、所有实体都加载完成后，再执行 LoadPostPass() 操作，可用于实现一些对其他实体有依赖性的操作,
    世界启动完毕后，POPULATING = false。
    1、因此可以看出 POPULATING 用于判断世界当前是否处于启动状态中。
    2、inst:LoadPostPass(newents, savedata)，newents代表此次启动中所有加载好的实体，savedata代表inst的保存数据。
        由于每次重载，实体的GUID都会变化，所以可以通过在 OnSave() 时，将有关联的实体的GUID存下来，官方逻辑会把
        新加载实体在 newents 中的key自动设置对应的GUID，在 LoadPostPass() 时就可以直接确定实体是否还存在，并做自己的操作
    以上逻辑具体详看 gamelogic.lua 的 PopulateWorld()
]]--

--------------------------------------------------------------------------
--[[ 全局 ]]
--------------------------------------------------------------------------

--下行代码只代表查值时自动查global，增加global的变量或者修改global的变量时还是需要带"GLOBAL."
GLOBAL.setmetatable(env, { __index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end })

local _G = GLOBAL
-- local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()
TUNING.mod_legion_enabled = true --方便别的mod做判定。不过就算这样，也受mod加载顺序影响

PrefabFiles = {
    "bush_legion",              --棱镜灌木丛
    "items_legion",             --各种功能简单的食物、材料、道具
    "euip_head_legion",         --棱镜头戴道具
    "euip_hand_legion",         --棱镜手持道具
    "euip_body_legion",         --棱镜身穿道具
    -- "guitar_greenery",
    -- "aatest_anim",
    "fx_legion",                --特效
    "buffs_legion",             --buff
    "shield_legion",            --盾类武器
    "carpet_legion",            --地毯
    "placer_legion",            --大多数的placer
    "worldbox_legion",          --世界唯一型容器相关

    "neverfade_butterfly",      --永不凋零的蝴蝶

    "shyerries",            --颤栗树相关
    "sand_spike_legion",    --对玩家友好的沙之咬
    "whitewoods",           --白木相关

    "siving_base_legion",
    "farm_plants_legion",
    "cropgnat",
    "siving_related",
    "fishhomingtools",
    "boss_siving_phoenix",

    "fimbul_fx",                --芬布尔相关fx
    "boss_elecarmet",           --莱克阿米特
    "elecourmaline",            --电气重铸台
    "icire_rock",               --鸳鸯石
    "guitar_miguel",            --米格尔的吉他
    "legion_soul_fx",           --灵魂契约特效
    "the_gifted",               --重铸科技，针对每个角色的独有制作物
    "saddle_baggage",           --驮物牛鞍
    "hat_albicans_mushroom",    --素白蘑菇帽
    "albicansmushroomhat_fx",   --素白蘑菇帽相关fx
    "explodingfruitcake",       --爆炸水果蛋糕

    "raindonate",               --雨蝇
    "monstrain",                --雨竹
    "hat_mermbreathing",        --鱼之息
    "giantsfoot",               --巨脚背包
    "moonlight_legion",         --月之宝具
    "moon_dungeon",             --月的地下城
}
Assets = {
    Asset("ANIM", "anim/images_minisign1.zip"),  --专门为小木牌上的图画准备的文件(真是奢侈0.0)
    -- Asset("ANIM", "anim/images_minisign2.zip"),
    Asset("ANIM", "anim/images_minisign3.zip"),
    Asset("ANIM", "anim/images_minisign4.zip"),
    Asset("ANIM", "anim/images_minisign5.zip"),
    Asset("ANIM", "anim/images_minisign6.zip"),
    Asset("ANIM", "anim/snow_legion.zip"), --积雪的通用贴图
    Asset("ANIM", "anim/playguitar.zip"), --弹吉他动画模板
    Asset("SOUNDPACKAGE", "sound/legion.fev"), --吉他的声音
    Asset("SOUND", "sound/legion.fsb"),

    Asset("ANIM", "anim/ui_hiddenmoonlight_4x4.zip"),
    Asset("ANIM", "anim/ui_hiddenmoonlight_inf_4x4.zip"),
    Asset("ANIM", "anim/ui_revolvedmoonlight_4x3.zip"),
    Asset("ANIM", "anim/ui_chest_whitewood_3x4.zip"),
    Asset("ANIM", "anim/ui_chest_whitewood_inf_3x4.zip"),
    Asset("ANIM", "anim/ui_chest_whitewood_4x6.zip"),
    Asset("ANIM", "anim/ui_chest_whitewood_inf_4x6.zip"),
    Asset("ATLAS", "images/slot_bearspaw_l.xml"), --靠背熊的格子背景
    Asset("IMAGE", "images/slot_bearspaw_l.tex"),
    Asset("ATLAS", "images/slot_juice_l.xml"), --巨食草的格子背景
    Asset("IMAGE", "images/slot_juice_l.tex"),
    Asset("ATLAS", "images/station_recast.xml"), --科技栏图标
    Asset("IMAGE", "images/station_recast.tex"),
    Asset("ATLAS", "images/station_siving.xml"),
    Asset("IMAGE", "images/station_siving.tex"),
    Asset("ATLAS", "images/filter_legion.xml"),
    Asset("IMAGE", "images/filter_legion.tex"),

    --为工艺锅mod加的（此时并不明确是否启用了该mod）
    Asset("ATLAS", "images/foodtags/foodtag_gel.xml"),
    Asset("IMAGE", "images/foodtags/foodtag_gel.tex"),
    Asset("ATLAS", "images/foodtags/foodtag_petals.xml"),
    Asset("IMAGE", "images/foodtags/foodtag_petals.tex"),
    Asset("ATLAS", "images/foodtags/foodtag_mushroom.xml"),
    Asset("IMAGE", "images/foodtags/foodtag_mushroom.tex"),
    Asset("ATLAS", "images/foodtags/foodtag_tallbirdegg.xml"),
    Asset("IMAGE", "images/foodtags/foodtag_tallbirdegg.tex"),
    Asset("ATLAS", "images/foodtags/foodtag_fallfullmoon.xml"),
    Asset("IMAGE", "images/foodtags/foodtag_fallfullmoon.tex"),
    Asset("ATLAS", "images/foodtags/foodtag_winterfeast.xml"),
    Asset("IMAGE", "images/foodtags/foodtag_winterfeast.tex"),
    Asset("ATLAS", "images/foodtags/foodtag_hallowednights.xml"),
    Asset("IMAGE", "images/foodtags/foodtag_hallowednights.tex"),
    Asset("ATLAS", "images/foodtags/foodtag_newmoon.xml"),
    Asset("IMAGE", "images/foodtags/foodtag_newmoon.tex"),

    Asset("ANIM", "anim/mushroom_farm_albicans_cap_build.zip"), --竹荪的蘑菇农场贴图
    Asset("ANIM", "anim/mushroom_farm_cutlichen_build.zip"), --洞穴苔藓的蘑菇农场贴图
    Asset("ANIM", "anim/mushroom_farm_foliage1_build.zip"), --蕨叶(森林)的蘑菇农场贴图
    Asset("ANIM", "anim/mushroom_farm_foliage2_build.zip"), --蕨叶(洞穴)的蘑菇农场贴图
    Asset("ANIM", "anim/farm_plant_pineananas.zip"),
    Asset("ANIM", "anim/player_actions_roll.zip"), --脱壳之翅所需动作（来自单机版）
    Asset("ANIM", "anim/albicansspore_fx.zip"), --素白蘑菇帽技能特效相关贴图

    Asset("ANIM", "anim/crop_legion_cactus.zip"), --异种动画，让子圭育提前用的
    Asset("ANIM", "anim/crop_legion_lureplant.zip"),
    Asset("ANIM", "anim/crop_legion_berries.zip"),
    Asset("ANIM", "anim/crop_legion_pine.zip")
}

--------------------------------------------------------------------------
--[[ test ]]
--------------------------------------------------------------------------

-- TheInput:AddKeyUpHandler(KEY_V, function()
--     ThePlayer.sg:GoToState("gosg")
-- end)

--------------------------------------------------------------------------
--[[ 各项设置 ]]
--------------------------------------------------------------------------

_G.CONFIGS_LEGION = {
    ENABLEDMODS = {},
    LANGUAGES = GetModConfigData("Language") or "chinese", --语言
    AUTOSTACKEDLOOT = GetModConfigData("AutoStackedLoot"), --掉落物自动堆叠
    MOUSEINFO = GetModConfigData("MouseInfo"), --鼠标悬停展示特殊信息

    FLOWERWEAPONSCHANCE = GetModConfigData("FlowerWeaponsChance"), --花剑掉落几率
    FOLIAGEATHCHANCE = GetModConfigData("FoliageathChance"), --青枝绿叶掉落几率
    ROSEBUSHSPACING = GetModConfigData("RoseBushSpacing"), --蔷薇花丛种植距离限制半径
    LILYBUSHSPACING = GetModConfigData("LilyBushSpacing"), --蹄莲花丛种植距离限制半径
    ORCHIDBUSHSPACING = GetModConfigData("OrchidBushSpacing"), --兰草花丛种植距离限制半径

    BETTERCOOKBOOK = false, --更好的食谱界面。仅限中文
    FESTIVALRECIPES = GetModConfigData("FestivalRecipes"), --解禁节日料理

    HIDDENUPDATETIMES = GetModConfigData("HiddenUpdateTimes"), --月藏宝匣最大升级次数
    REVOLVEDUPDATETIMES = GetModConfigData("RevolvedUpdateTimes"), --月轮宝盘最大升级次数
    REFRACTEDUPDATETIMES = GetModConfigData("RefractedUpdateTimes"), --月折宝剑最大升级次数

    X_GROWTHTIME = GetModConfigData("X_growthTime"), --设置异种生长的时间倍数
    X_OVERRIPETIME = GetModConfigData("X_overripeTime"), --设置异种过熟的时间倍数
    X_PESTRISK = GetModConfigData("X_pestRisk"), --设置异种虫害几率
    PHOENIXREBIRTHCYCLE = GetModConfigData("PhoenixRebirthCycle"), --设置玄鸟重生时间
    SIVINGROOTTEX = GetModConfigData("SivingRootTex"), --设置子圭突触贴图
    PHOENIXBATTLEDIFFICULTY = GetModConfigData("PhoenixBattleDifficulty"), --设置玄鸟战斗难度
    SIVFEADAMAGE = GetModConfigData("SivFeaDamage"), --设置子圭·翰的攻击力
    SIVFEAHEALTHCOST = GetModConfigData("SivFeaHealthCost"), --设置子圭·翰的技能耗血量
    SIVFEATHROWEDNUM = GetModConfigData("SivFeaThrowedNum"), --设置羽刃分掷的最大投掷数
    DIGESTEDITEMMSG = GetModConfigData("DigestedItemMsg"), --巨食草消化提醒
    TRANSTIMECROP = GetModConfigData("TransTimeCrop"), --普通作物转成异种的时间
    TRANSTIMESPEC = GetModConfigData("TransTimeSpec"), --特殊植物转成异种的时间倍率
    SIVSOLTOMEDAL = GetModConfigData("SivSolToMedal"), --子圭·垄兼容能力勋章的作物
    TISSUECACTUSCHANCE = GetModConfigData("TissueCactusChance"), --仙人掌活性组织掉落几率
    TISSUEBERRIESCHANCE = GetModConfigData("TissueBerriesChance"), --浆果丛活性组织掉落几率
    TISSUELIGHTBULBCHANCE = GetModConfigData("TissueLightbulbChance"), --荧光花活性组织掉落几率

    TECHUNLOCK = GetModConfigData("TechUnlock"), --设置新道具的科技解锁方式 "lootdropper" "prototyper"

    DRESSUP = GetModConfigData("DressUp"), --启用幻化机制

    BACKCUBCHANCE = GetModConfigData("BackCubChance"), --靠背熊掉落几率
    SHIELDRECHARGETIME = GetModConfigData("ShieldRechargeTime"), --盾牌冷却时间
    AGRONRECHARGETIME = GetModConfigData("AgronRechargeTime"), --艾力冈的剑冷却时间
}

------台词文本
if _G.CONFIGS_LEGION.LANGUAGES == "english" then
    modimport("scripts/languages/strings_english.lua")
else
    modimport("scripts/languages/strings_chinese.lua")
    _G.CONFIGS_LEGION.BETTERCOOKBOOK = GetModConfigData("BetterCookBook")
end

--------------------------------------------------------------------------
--[[ 资源注册 ]]
--------------------------------------------------------------------------

------物品栏图标

local function RegisterInvItems(imgs)
    local url
    local atex
    for _, v in ipairs(imgs) do
        url = "images/inventoryimages/"..v..".xml"
        atex = v..".tex"
        table.insert(Assets, Asset("ATLAS", url))
        table.insert(Assets, Asset("IMAGE", "images/inventoryimages/"..atex))
        table.insert(Assets, Asset("ATLAS_BUILD", url, 256)) --生成小木牌需要的动画格式的贴图缓存
        RegisterInventoryItemAtlas(url, atex) --为了在菜谱和农谱里等需要显示材料的图片，需要注册全局的图片资源
    end
end

RegisterInvItems({
    ------花香四溢
    "petals_rose", "petals_lily", "petals_orchid", "cutted_rosebush", "cutted_lilybush",
    "rosorns", "lileaves", "orchitwigs", "neverfade", "neverfade_broken", "cutted_orchidbush",
    "sachet", "foliageath", "foliageath_rosorns", "foliageath_lileaves", "foliageath_orchitwigs",
    "foliageath_neverfade", "foliageath_hambat", "foliageath_bullkelp_root", "foliageath_foliageath",
    "foliageath_dish_tomahawksteak", "dug_rosebush", "dug_lilybush", "dug_orchidbush",
    ------美味佳肴
    ------尘世蜃楼
    "shyerry", "shyerry_cooked", "shyerrylog", "shield_l_sand", "guitar_whitewood", "mat_whitewood_item",
    "carpet_whitewood_big", "carpet_whitewood", "chest_whitewood_big", "chest_whitewood",
    "ointment_l_fireproof",
    ------丰饶传说
    "pineananas", "pineananas_cooked", "pineananas_seeds", "siving_turn", "siving_feather_fake",
    "pineananas_oversized", "pineananas_oversized_waxed", "pineananas_oversized_rotten", "carpet_plush",
    "mint_l", "siving_soil_item", "ahandfulofwings", "insectshell_l", "boltwingout", "hat_elepheetle",
    "siving_rocks", --mod之间注册相同的文件是有效的
    "siving_ctlwater_item", "siving_ctldirt_item", "siving_ctlall_item", "ointment_l_sivbloodreduce",
    "siving_mask", "siving_mask_gold", "siving_feather_real", "armor_elepheetle", "lance_carrot_l",
    "carpet_plush_big", "siving_suit", "siving_suit_gold", "tissue_l_cactus", "tissue_l_lureplant",
    "tissue_l_berries", "cattenball", "cutted_lumpyevergreen", "siving_derivant_item", "seeds_crop_l2",
    "boxopener_l", "siving_boxopener", "tissue_l_lightbulb",
    ------电闪雷鸣
    "albicans_cap", "tripleshovelaxe", "triplegoldenshovelaxe", "dualwrench", "fimbul_axe", "hat_cowboy",
    "guitar_miguel", "web_hump_item", "saddle_baggage", "hat_albicans_mushroom", "soul_contracts",
    "explodingfruitcake", "tourmalinecore", "tourmalineshard", "dug_monstrain",
    "icire_rock", "icire_rock1", "icire_rock2", "icire_rock3", "icire_rock4", "icire_rock5",
    ------祈雨祭
    "monstrain_leaf", "squamousfruit", "raindonate", "book_weather", "merm_scales", "hat_mermbreathing",
    "giantsfoot", "hiddenmoonlight_item", "revolvedmoonlight_item", "agronssword", "agronssword2",
    "fishhomingbait1", "fishhomingbait2", "fishhomingbait3", "fishhomingtool_awesome", "fishhomingtool_normal",
    "revolvedmoonlight", "revolvedmoonlight_pro", "refractedmoonlight", "refractedmoonlight2",
    ------黯涌
    "shield_l_log", "hat_lichen", "backcub",
})
RegisterInventoryItemAtlas("images/inventoryimages/siving_feather_line.xml", "siving_feather_line.tex")

------小地图图标

local function RegisterMapImages(imgs)
    local url
    for _, v in ipairs(imgs) do
        url = "images/map_icons/"..v
        table.insert(Assets, Asset("ATLAS", url..".xml"))
        table.insert(Assets, Asset("IMAGE", url..".tex"))
        AddMinimapAtlas(url..".xml")
    end
    --  接下来就需要在prefab定义里添加：
    --      inst.entity:AddMiniMapEntity()
    --      inst.MiniMapEntity:SetIcon("图片文件名.tex")
end

RegisterMapImages({
    ------花香四溢
    "rosebush", "lilybush", "orchidbush", "neverfadebush",
    ------美味佳肴
    ------尘世蜃楼
    "shyerrytree", "chest_whitewood",
    ------丰饶传说
    "siving_derivant", "siving_thetree", "siving_ctlwater", "siving_ctldirt", "siving_ctlall",
    "siving_turn", "plant_crop_l", "boltwingout", "siving_suit_gold",
    ------电闪雷鸣
    "elecourmaline", "soul_contracts",
    ------祈雨祭
    "monstrain", "agronssword", "hiddenmoonlight", "giantsfoot", "refractedmoonlight", "moondungeon",
    ------黯涌
    "backcub"
})

if _G.CONFIGS_LEGION.DRESSUP then
    table.insert(Assets, Asset("ANIM", "anim/hat_straw_perd.zip"))
    table.insert(PrefabFiles, "theemperorsnewclothes") --国王的新衣
    RegisterInvItems({
        "pinkstaff", "theemperorscrown", "theemperorsmantle", "theemperorsscepter", "theemperorspendant"
    })
end

--------------------------------------------------------------------------
--[[ 料理相关 ]]
--------------------------------------------------------------------------

local dishes_l = {}
for _, recipe in pairs(require("preparedfoods_legion")) do
    table.insert(Assets, Asset("ATLAS", "images/cookbookimages/"..recipe.name..".xml"))
    table.insert(Assets, Asset("IMAGE", "images/cookbookimages/"..recipe.name..".tex"))
    table.insert(dishes_l, recipe.name)

    AddCookerRecipe("cookpot", recipe) --将料理配方加入“烹饪锅”集合中，这样“烹饪锅”才能烹饪出该料理
    AddCookerRecipe("portablecookpot", recipe)
    AddCookerRecipe("archive_cookpot", recipe)
    if recipe.card_def ~= nil then --加入烹饪卡片
		AddRecipeCard("cookpot", recipe)
	end
end
for _, recipe in pairs(require("prepareditems_legion")) do
    table.insert(Assets, Asset("ATLAS", "images/cookbookimages/"..recipe.name..".xml"))
    table.insert(Assets, Asset("IMAGE", "images/cookbookimages/"..recipe.name..".tex"))
    table.insert(dishes_l, recipe.name)

    AddCookerRecipe("cookpot", recipe)
    AddCookerRecipe("portablecookpot", recipe)
    AddCookerRecipe("archive_cookpot", recipe)
    if recipe.card_def ~= nil then
		AddRecipeCard("cookpot", recipe)
	end
end
for _, recipe in pairs(require("preparedfoods_legion_spiced")) do
    AddCookerRecipe("portablespicer", recipe)
end
RegisterInvItems(dishes_l)
dishes_l = nil

--蝙蝠翅膀，虽然可以晾晒，但是得到的不是蝙蝠翅膀干，而是小肉干，所以candry不能填true
-- AddIngredientValues({"batwing"}, {meat=.5}, true, false)

local cooking = require("cooking")
local ingredients_l = {
    --灰烬、毛丛、树枝树种
    { {"ash", "furtuft", "twiggy_nut"}, { inedible=1 }, false, false },
    --蜗牛黏液、格罗姆黏液、钢羊黏痰
    { {"slurtleslime", "glommerfuel", "phlegm"}, { gel=1 }, false, false },
    --蕨叶
    { {"foliage"}, { decoration=1 }, false, false },
    --牛角
    { {"horn"}, { inedible=1, decoration=2 }, false, false },
    --月树花
    { {"moon_tree_blossom"}, { veggie=.5, petals_legion=1 }, false, false },
    --必忘我、仙人掌花、【神话书说】莲花、【额外物品包】向日葵、皮服玫瑰
    { {"forgetmelots", "cactus_flower", "myth_lotus_flower", "aip_veggie_sunflower",
        "pm_rose"}, { petals_legion=1 }, false, false },
    --告密的心
    { {"reviver"}, { meat=1.5, magic=1 }, false, false },
    --颤栗果
    { {"shyerry"}, { fruit=4 }, true, false },
    --素白菇
    { {"albicans_cap"}, { veggie=2 }, false, false },
    --三花
    { {"petals_rose", "petals_lily", "petals_orchid"}, { veggie=.5, petals_legion=1 }, false, false },
    --松萝
    { {"pineananas"}, { veggie=1, fruit=1 }, true, false },
    --猫薄荷
    { {"mint_l"}, { veggie=.5 }, false, false },
    --雨竹叶
    { {"monstrain_leaf"}, { monster=1, veggie=.5 }, false, false }
}
local ingredients_map = {}
for _, ing in ipairs(ingredients_l) do
    local cancook = ing[3]
    local candry = ing[4]
    for _, name in pairs(ing[1]) do
        ingredients_map[name] = true
        if cancook then
            ingredients_map[name.."_cooked"] = true
        end
        if candry then
            ingredients_map[name.."_dried"] = true
        end
    end
end

--因为有的料理只有部分香料能调，所以这里设置默认返回值，防止其他香料制作时的崩溃
local CalculateRecipe_old = cooking.CalculateRecipe
cooking.CalculateRecipe = function(cooker, names, ...)
    local product, cooktime = CalculateRecipe_old(cooker, names, ...)
    if product == nil then
        local count_name = 0
        local spice_name = nil
        for _,name in pairs(names) do
            if name then
                count_name = count_name + 1
                if spice_name == nil and string.sub(name, 1, 6) == "spice_" then
                    spice_name = name
                end
            end
        end
        if count_name == 2 then --香料站只有两格
            if spice_name and PrefabExists("wetgoop_"..spice_name) then
                product = "wetgoop_"..spice_name
            else
                product = "wetgoop_spice_chili" --实在不行，只能弄一个官方的了
            end
            cooktime = 0.12
        else --这个情况按理来说是不可能的，不过这里也完善吧
            product = "wetgoop"
            cooktime = 0.25
        end
    end
    return product, cooktime
end

--因为食材配置在 AddSimPostInit 时才会加入，所以得优化这个函数
local IsCookingIngredient_old = cooking.IsCookingIngredient
cooking.IsCookingIngredient = function(prefabname, ...)
    if ingredients_map[prefabname] then
        return true
    end
    return IsCookingIngredient_old(prefabname, ...)
end

--------------------------------------------------------------------------
--[[ 导入文件 ]]
--------------------------------------------------------------------------

------热更新机制
-- modimport("scripts/hotreload_legion.lua")
------专用数据相关
modimport("scripts/datafix_legion.lua")
------组件与预制物相关
modimport("scripts/postinit_legion.lua")
------sg、动作相关
modimport("scripts/sgactions_legoin.lua")
------新增科技与科技栏
modimport("scripts/techtrees_legion.lua")
------制作相关
modimport("scripts/recipes_legion.lua")
------容器相关
modimport("scripts/containers_legion.lua")
------幻化相关
modimport("scripts/fengl_userdatahook.lua")
if _G.CONFIGS_LEGION.DRESSUP then
    modimport("scripts/dressup_legion.lua")
end
modimport("scripts/skkii_legion.lua")

--------------------------------------------------------------------------
--[[ mod之间的兼容，以及其他 ]]
--------------------------------------------------------------------------

----------
--黑化排队论2(有好几个版本，但组件好像是相同的)
----------
AddComponentPostInit("actionqueuer", function(self)
	if self.AddAction then
		self.AddAction("leftclick", "PLANTSOIL_LEGION", true)
        self.AddAction("rightclick", "POUR_WATER_LEGION", true)
        self.AddAction("leftclick", "FERTILIZE_LEGION", true)
        self.AddAction("leftclick", "FEED_BEEF_L", true)
	end
end)

--AddSimPostInit() 会在所有预制物都初始化完成后才执行，所以就不用担心官方逻辑产生相同的预制物
--AddSimPostInit() 在所有mod加载完毕后才执行，这时能更准确判定是否启用某mod，不用考虑优先级
AddSimPostInit(function()
    ----------
    --丰饶传说
    ----------
    _G.VEGGIES.pineananas = { --新增作物收获物与种子设定（只是为了种子几率，并不会主动生成prefab）
        health = 8,
        hunger = 12,
        sanity = -10,
        perishtime = TUNING.PERISH_MED,
        -- float_settings = {"small", 0.2, 0.9},

        cooked_health = 16,
        cooked_hunger = 18.5,
        cooked_sanity = 5,
        cooked_perishtime = TUNING.PERISH_SUPERFAST,
        -- cooked_float_settings = {"small", 0.2, 1},

        seed_weight = TUNING.SEED_CHANCE_RARE, --大概只有这里起作用了
        -- dryable = nil,
        -- halloweenmoonmutable_settings = nil,
        -- secondary_foodtype = nil,
        -- lure_data = nil
    }

    ----------
    --烹饪食材属性 兼容性修改(官方逻辑没有兼容性，只能自己写个有兼容性的啦)
    ----------
    cooking = require("cooking") --不清楚别的修改会不会自动修改原有的，所以这里重新获取一遍
    local ingredients_base = cooking.ingredients
    if ingredients_base then
        for _, ing in ipairs(ingredients_l) do
            local cancook = ing[3]
            local candry = ing[4]
            for _, name in pairs(ing[1]) do
                if ingredients_base[name] == nil then
                    ingredients_base[name] = { tags={} }
                end
                if cancook then
                    if ingredients_base[name.."_cooked"] == nil then
                        ingredients_base[name.."_cooked"] = { tags={} }
                    end
                end
                if candry then
                    if ingredients_base[name.."_dried"] == nil then
                        ingredients_base[name.."_dried"] = { tags={} }
                    end
                end

                for tagname, tagval in pairs(ing[2]) do
                    ingredients_base[name].tags[tagname] = tagval
                    if cancook then
                        ingredients_base[name.."_cooked"].tags.precook = 1
                        ingredients_base[name.."_cooked"].tags[tagname] = tagval
                    end
                    if candry then
                        ingredients_base[name.."_dried"].tags.dried = 1
                        ingredients_base[name.."_dried"].tags[tagname] = tagval
                    end
                end
            end
        end
    end
    ingredients_l = nil

    ----------
    --食谱页面优化
    ----------
    if _G.CONFIGS_LEGION.BETTERCOOKBOOK then
        local cookbookui_legion = require("widgets/cookbookui_legion")
        local fooduidata_legion = require("languages/recipedesc_legion_chinese")

        local function SetNewCookBookPage(data, self, top, left)
            local root = cookbookui_legion(data, self, top, left)
            return root
        end
        for cooker, reps in pairs(cooking.recipes) do
            for repname, dd in pairs(reps) do
                if dd.custom_cookbook_details_fn == nil then --经过一类循环后，后面的数据多半是重复索引的
                    if cooking.IsModCookerFood(repname) then --是mod料理
                        if dd.recipe_count ~= nil then
                            dd.custom_cookbook_details_fn = SetNewCookBookPage
                        end
                    else
                        if fooduidata_legion[repname] ~= nil then
                            dd.cook_need = fooduidata_legion[repname].cook_need
                            dd.cook_cant = fooduidata_legion[repname].cook_cant
                            dd.recipe_count = fooduidata_legion[repname].recipe_count or 1
                            dd.custom_cookbook_details_fn = SetNewCookBookPage
                        end
                    end
                end
            end
        end
    end

    ----------
    --神话书说
    ----------
    _G.CONFIGS_LEGION.ENABLEDMODS.MythWords = TUNING.MYTH_WORDS_MOD_OPEN
    if TUNING.MYTH_WORDS_MOD_OPEN then
        if CONFIGS_LEGION.DRESSUP then
            local DRESSUP_DATA = _G.DRESSUP_DATA_LEGION

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
                    dressup:InitGroupHead()
                    dressup:InitClear("hair")
                    dressup:InitClear("swap_face")
                end
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
                end
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
                isnoskin = true, buildfile = "swap_bananafan_big", buildsymbol = "swap_fan"
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
                isnoskin = true, buildfile = "myth_iron_helmet", buildsymbol = "swap_hat"
            }
            DRESSUP_DATA["myth_iron_broadsword"] = { --铸铁大刀
                isnoskin = true, buildfile = "myth_iron_broadsword", buildsymbol = "swap_object"
            }
            DRESSUP_DATA["myth_iron_battlegear"] = { --铸铁战甲
                isnoskin = true, buildfile = "myth_iron_battlegear", buildsymbol = "swap_body"
            }
            DRESSUP_DATA["myth_food_tr"] = { --糖人
                isnoskin = true, buildfile = "swap_myth_food_tr", buildsymbol = "image"
            }
            DRESSUP_DATA["cane_peach"] = { --桃木手杖
                isnoskin = true, buildfile = "cane_peach", buildsymbol = "swap"
            }
            DRESSUP_DATA["myth_gold_staff"] = { --金击子
                isnoskin = true, buildfile = "myth_gold_staff", buildsymbol = "swap_spear"
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
                dug_monstrain = {
                    img_tex = "dug_monstrain.tex", img_atlas = "images/inventoryimages/dug_monstrain.xml",
                    buy = { value = 10, chance = chancemap[2], count_min = 1, count_max = 3, stacksize = 20, },
                    sell = { value = 5, chance = chancemap[2], count_min = 2, count_max = 4, stacksize = 20, },
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
    --额外物品包
    ----------
    if CONFIGS_LEGION.DRESSUP and _G.rawget(_G, "aipCountTable") then
        local DRESSUP_DATA = _G.DRESSUP_DATA_LEGION
        DRESSUP_DATA["aip_armor_gambler"] = { --赌徒护甲
            isnoskin = true, buildfile = "aip_armor_gambler", buildsymbol = "swap_body"
        }
        DRESSUP_DATA["aip_beehave"] = { --蜂语
            isnoskin = true, buildfile = "aip_beehave_swap", buildsymbol = "aip_beehave_swap"
        }
        DRESSUP_DATA["aip_dou_scepter"] = { --神秘权杖1
            isnoskin = true, buildfile = "aip_dou_scepter_swap", buildsymbol = "aip_dou_scepter_swap"
        }
        DRESSUP_DATA["aip_dou_empower_scepter"] = { --神秘权杖2
            isnoskin = true, buildfile = "aip_dou_empower_scepter_swap", buildsymbol = "aip_dou_empower_scepter_swap"
        }
        DRESSUP_DATA["aip_dou_huge_scepter"] = DRESSUP_DATA["aip_dou_empower_scepter"] --神秘权杖3
        DRESSUP_DATA["aip_dou_scepter_lock"] = DRESSUP_DATA["aip_dou_empower_scepter"] --神秘权杖4
        DRESSUP_DATA["aip_fish_sword"] = { --鱼刀
            isnoskin = true, buildfile = "aip_fish_sword_swap", buildsymbol = "aip_fish_sword_swap"
        }
        DRESSUP_DATA["aip_krampus_plus"] = { --守财奴的背包
            isnoskin = true, isbackpack = true,
            buildfile = "aip_krampus_plus", buildsymbol = "swap_body"
        }
        DRESSUP_DATA["aip_oar_woodead"] = { --树精木浆
            isnoskin = true, buildfile = "aip_oar_woodead_swap", buildsymbol = "aip_oar_woodead_swap"
        }
        -- DRESSUP_DATA["aip_oldone_marble_head_lock"] = { --捆绑的头颅
        --     isnoskin = true, istallbody = true,
        --     buildfile = "aip_oldone_marble_head_lock", buildsymbol = "swap_body"
        -- }
        -- DRESSUP_DATA["aip_oldone_marble_head"] = { --头颅部件
        --     isnoskin = true, istallbody = true,
        --     buildfile = "aip_oldone_marble_head", buildsymbol = "swap_body"
        -- }
        -- DRESSUP_DATA["aip_oldone_snowball"] = { --雪球（有bug不敢加了）
        --     isnoskin = true, istallbody = true,
        --     buildfile = "aip_oldone_snowball", buildsymbol = "swap_body"
        -- }
        DRESSUP_DATA["aip_suwu"] = { --子卿
            isnoskin = true, buildfile = "aip_suwu_swap", buildsymbol = "aip_suwu_swap"
        }
        DRESSUP_DATA["aip_track_tool"] = { --月轨测量仪
            isnoskin = true, buildfile = "aip_track_tool_swap", buildsymbol = "aip_track_tool_swap"
        }
        DRESSUP_DATA["aip_xinyue_hoe"] = { --心悦锄
            isnoskin = true, buildfile = "aip_xinyue_hoe_swap", buildsymbol = "aip_xinyue_hoe_swap"
        }
        DRESSUP_DATA["popcorngun"] = { --玉米枪
            isnoskin = true, buildfile = "swap_popcorn_gun", buildsymbol = "swap_popcorn_gun"
        }
        DRESSUP_DATA["aip_wizard_hat"] = { --闹鬼巫师帽
            isnoskin = true, buildfile = "aip_wizard_hat", buildsymbol = "swap_hat"
        }
        DRESSUP_DATA["aip_horse_head"] = { --马头
            isnoskin = true, isfullhead = true, buildfile = "aip_horse_head", buildsymbol = "swap_hat"
        }
        DRESSUP_DATA["aip_som"] = { --谜之声
            isnoskin = true, isfullhead = true, buildfile = "aip_som", buildsymbol = "swap_hat"
        }
        DRESSUP_DATA["aip_blue_glasses"] = { --岚色眼镜
            isnoskin = true, isopentop = true,
            buildfile = "aip_blue_glasses", buildsymbol = "swap_hat"
        }
        DRESSUP_DATA["aip_oldone_fisher"] = { --鱼仔帽
            isnoskin = true, buildfile = "aip_oldone_fisher", buildsymbol = "swap_hat"
        }
        DRESSUP_DATA["aip_joker_face"] = { --诙谐面具
            isnoskin = true, isopentop = true,
            buildfile = "aip_joker_face", buildsymbol = "swap_hat"
        }

        --各种雕像
        local pieces = {
            "aip_moon",
            "aip_doujiang",
            "aip_deer",
            "aip_mouth",
            "aip_octupus",
            "aip_fish"
        }
        local materials = {
            "marble", "stone", "moonglass",
        }
        for k,v in pairs(pieces) do
            _G.DRESSUP_DATA_LEGION["chesspiece_"..v] = {
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
                end
            }
        end
    end

    ----------
    --工艺锅（Craft Pot）
    ----------
    _G.CONFIGS_LEGION.ENABLEDMODS.CraftPot = AddFoodTag ~= nil --AddFoodTag()是该mod里的全局函数
    if CONFIGS_LEGION.ENABLEDMODS.CraftPot then
        --写这个是为了注册特殊烹饪条件(craft pot的机制)
        AddIngredientValues({"craftpot"}, {
            fallfullmoon = 1,
            winterfeast = 1,
            hallowednights = 1,
            newmoon = 1,
            mushroom_legion = 1,
            tallbirdegg_legion = 1
        }, false, false)

        if _G.CONFIGS_LEGION.LANGUAGES == "chinese" then
            STRINGS.NAMES_LEGION = {
                GEL = "黏液度",
                PETALS_LEGION = "花度",
                TALLBIRDEGG_LEGION = "(烤)高脚鸟蛋",
                MUSHROOM_LEGION = "蘑菇种类",
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
                TALLBIRDEGG_LEGION = "(Cooked)Tallbird Egg",
                MUSHROOM_LEGION = "kinds of mushrooms",
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
        AddFoodTag('mushroom_legion', {
            name = STRINGS.NAMES_LEGION.MUSHROOM_LEGION,
            tex = "foodtag_mushroom.tex",
            atlas = "images/foodtags/foodtag_mushroom.xml"
        })
        AddFoodTag('tallbirdegg_legion', {
            name = STRINGS.NAMES_LEGION.TALLBIRDEGG_LEGION,
            tex = "foodtag_tallbirdegg.tex",
            atlas = "images/foodtags/foodtag_tallbirdegg.xml"
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

    ----------
    --能力勋章
    ----------
    -- _G.CONFIGS_LEGION.ENABLEDMODS.FunctionalMedal = TUNING.FUNCTIONAL_MEDAL_IS_OPEN
    if TUNING.FUNCTIONAL_MEDAL_IS_OPEN then
        if CONFIGS_LEGION.DRESSUP then
            local DRESSUP_DATA = _G.DRESSUP_DATA_LEGION
            local function Fn_medal_staff(dressup, item, itemswap, name)
                itemswap["swap_object"] = dressup:GetDressData(
                    nil, GetMedalSkinData(item, name), "swap_"..name, item.GUID, "swap"
                )
                dressup:SetDressHand(itemswap)
            end

            DRESSUP_DATA["marbleaxe"] = { --大理石斧头
                isnoskin = true, buildfile = "swap_marbleaxe", buildsymbol = "swap_marbleaxe"
            }
            DRESSUP_DATA["marblepickaxe"] = { --大理石镐
                isnoskin = true, buildfile = "marblepickaxe", buildsymbol = "swap_marblepickaxe"
            }
            DRESSUP_DATA["medal_moonglass_shovel"] = { --月光玻璃铲
                isnoskin = true, buildfile = "swap_medal_moonglass_shovel", buildsymbol = "swap_shovel"
            }
            DRESSUP_DATA["medal_moonglass_hammer"] = { --月光玻璃锤
                isnoskin = true, buildfile = "swap_medal_moonglass_hammer", buildsymbol = "swap_hammer"
            }
            DRESSUP_DATA["medal_moonglass_bugnet"] = { --月光玻璃网
                isnoskin = true, buildfile = "swap_medal_moonglass_bugnet", buildsymbol = "swap_bugnet"
            }
            DRESSUP_DATA["lureplant_rod"] = { --食人花手杖
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}
                    Fn_medal_staff(dressup, item, itemswap, "lureplant_rod")
                    return itemswap
                end
            }
            DRESSUP_DATA["immortal_staff"] = { --不朽法杖
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}
                    Fn_medal_staff(dressup, item, itemswap, "immortal_staff")
                    return itemswap
                end
            }
            DRESSUP_DATA["devour_staff"] = { --吞噬法杖
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}
                    Fn_medal_staff(dressup, item, itemswap, "devour_staff")
                    return itemswap
                end
            }
            DRESSUP_DATA["meteor_staff"] = { --流星法杖
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}
                    Fn_medal_staff(dressup, item, itemswap, "meteor_staff")
                    return itemswap
                end
            }
            DRESSUP_DATA["medal_skin_staff"] = { --风花雪月
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}
                    Fn_medal_staff(dressup, item, itemswap, "medal_skin_staff")
                    return itemswap
                end
            }
            DRESSUP_DATA["medal_space_staff"] = { --时空法杖
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}
                    Fn_medal_staff(dressup, item, itemswap, "medal_space_staff")
                    return itemswap
                end
            }
            DRESSUP_DATA["medal_goathat"] = { --羊角帽
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}
                    itemswap["swap_hat"] = dressup:GetDressData(
                        nil, GetMedalSkinData(item, "medal_goathat"), "swap_hat", item.GUID, "swap"
                    )
                    dressup:SetDressTop(itemswap)
                    return itemswap
                end
            }
            DRESSUP_DATA["down_filled_coat"] = { --羽绒服
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}
                    itemswap["swap_body"] = dressup:GetDressData(
                        nil, GetMedalSkinData(item, "down_filled_coat"), "swap_body", item.GUID, "swap"
                    )
                    itemswap["backpack"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
                    return itemswap
                end
            }
            DRESSUP_DATA["hat_blue_crystal"] = { --蓝晶帽
                isnoskin = true, isfullhead = true, buildfile = "hat_blue_crystal", buildsymbol = "swap_hat"
            }
            DRESSUP_DATA["medal_tentaclespike"] = { --活性触手尖刺
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}
                    itemswap["swap_object"] = dressup:GetDressData(
                        nil, "medal_tentaclespike", "swap_medal_tentaclespike", item.GUID, "swap"
                    )
                    itemswap["whipline"] = dressup:GetDressData(
                        nil, "swap_whip", "whipline", item.GUID, "swap"
                    )
                    return itemswap
                end
            }
            DRESSUP_DATA["sanityrock_mace"] = { --方尖锏
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}
                    Fn_medal_staff(dressup, item, itemswap, "sanityrock_mace")
                    return itemswap
                end
            }
            DRESSUP_DATA["armor_medal_obsidian"] = { --红晶甲
                isnoskin = true, buildfile = "armor_medal_obsidian", buildsymbol = "swap_body"
            }
            DRESSUP_DATA["armor_blue_crystal"] = { --蓝晶甲
                isnoskin = true, buildfile = "armor_blue_crystal", buildsymbol = "swap_body"
            }
            DRESSUP_DATA["medal_fishingrod"] = { --玻璃钓竿
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}

                    local sbuild = GetMedalSkinData(item, "swap_medal_fishingrod")
                    itemswap["swap_object"] = dressup:GetDressData(
                        nil, sbuild, "swap_fishingrod", item.GUID, "swap"
                    )
                    itemswap["fishingline"] = dressup:GetDressData(
                        nil, sbuild, "fishingline", item.GUID, "swap"
                    )
                    itemswap["FX_fishing"] = dressup:GetDressData(
                        nil, sbuild, "FX_fishing", item.GUID, "swap"
                    )
                    dressup:SetDressHand(itemswap)

                    return itemswap
                end,
                unbuildfn = function(dressup, item)
                    dressup:InitClear("swap_object")
                    dressup:InitClear("whipline")
                    dressup:InitClear("lantern_overlay")
                    dressup:InitHide("LANTERN_OVERLAY")

                    dressup:InitClear("fishingline")
                    dressup:InitClear("FX_fishing")
                end
            }
            DRESSUP_DATA["medal_glassblock"] = { --不朽晶柱
                isnoskin = true, istallbody = true, buildfile = "swap_medal_glass_block", buildsymbol = "swap_body"
            }
        end
    end

    ----------
    --奇幻降临：永恒终焉
    ----------
    if TUNING.ABIGAIL_WILLIAMS_KEY_CALLMYWEAPON ~= nil or TUNING.AB_YZJXQ_SET ~= nil then
        if CONFIGS_LEGION.DRESSUP then
            local DRESSUP_DATA = _G.DRESSUP_DATA_LEGION

            DRESSUP_DATA["abigail_williams_moon_hat"] = { --月之皇冠(仅限该mod角色才能穿戴)
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}

                    local owner = dressup.inst
                    local skin_build = item:GetSkinBuild()
                    local ownerskin  = owner.components.skinner ~= nil and owner.components.skinner.skin_name or ""

                    if skin_build == "abigail_williams_moon_hat_summer" then --这个皮肤贴图性质只适合她自己
                        if ownerskin == "abigail_williams_summer" then
                            itemswap["headbase"] = dressup:GetDressData(
                                nil, skin_build, "headbase", item.GUID, "swap"
                            )
                            itemswap["hair"] = dressup:GetDressData(
                                nil, skin_build, "hair", item.GUID, "swap"
                            )
                        end
                        dressup:SetDressOpenTop(itemswap)
                    elseif skin_build == "abigail_williams_moon_hat_season" then
                        itemswap["swap_hat"] = dressup:GetDressData(
                            nil, skin_build, owner.prefab == "abigail_williams" and "swap_hat" or "swap_hat_other", item.GUID, "swap"
                        )
                        dressup:SetDressTop(itemswap)
                    elseif skin_build ~= nil then
                        itemswap["swap_hat"] = dressup:GetDressData(
                            nil, skin_build, "swap_hat", item.GUID, "swap"
                        )
                        dressup:SetDressTop(itemswap)
                    elseif skin_build == nil then
                        itemswap["swap_hat"] = dressup:GetDressData(
                            nil, item.prefab, "swap_hat", item.GUID, "swap"
                        )
                        dressup:SetDressOpenTop(itemswap)
                    end

                    return itemswap
                end,
                unbuildfn = function(dressup, item)
                    local owner = dressup.inst
                    local skin_build = item:GetSkinBuild()
                    local ownerskin  = owner.components.skinner ~= nil and owner.components.skinner.skin_name or ""
                    dressup:InitGroupHead()
                    if skin_build == "abigail_williams_moon_hat_summer" and ownerskin == "abigail_williams_summer" then
                        dressup:InitClear("headbase")
                        dressup:InitClear("hair")
                    end
                end
            }
            DRESSUP_DATA["ab_tianming"] = { --扭结：天命(仅限该mod角色才能穿戴)
                isnoskin = true,
                buildfn = function(dressup, item, buildskin)
                    local itemswap = {}

                    -- local owner = dressup.inst
                    local skin_build = item:GetSkinBuild()
                    -- local ownerskin  = owner.components.skinner ~= nil and owner.components.skinner.skin_name or ""

                    if skin_build == nil then --原皮没贴图
                        itemswap["backpack"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
                        itemswap["swap_body"] = dressup:GetDressData(nil, nil, nil, nil, "clear")
                    else
                        itemswap["backpack"] = dressup:GetDressData(
                            nil, skin_build, "backpack", item.GUID, "swap"
                        )
                        itemswap["swap_body"] = dressup:GetDressData(
                            nil, skin_build, "swap_body", item.GUID, "swap"
                        )
                    end

                    return itemswap
                end
            }
            DRESSUP_DATA["ab_yzjxq"] = { --月之交响曲
                isnoskin = true, buildfile = "abigail_williams_wand_full", buildsymbol = "swap_object"
            }
        end
    end
end)
