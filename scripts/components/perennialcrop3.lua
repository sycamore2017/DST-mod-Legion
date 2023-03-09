local PerennialCrop2 = Class(function(self, inst)
	self.inst = inst

	self.cropprefab = "corn" --果实名字，也是数据的key
	self.stage_max = 3 --最大生长阶段
	self.regrowstage = 1 --采摘后重新开始生长的阶段（枯萎后采摘必定从第1阶段开始）
	self.growthmults = { 1, 1, 1, 0 } --四个季节的生长速度
	self.leveldata = nil --该植物生长有几个阶段，每个阶段的动画，以及是否处在花期、是否能采集

	self.pollinated_max = 3 --被授粉次数大于等于该值就能增加产量
	self.infested_max = 10 --被骚扰次数大于等于该值就会立即进入腐烂/枯萎阶段
	self.getsickchance = CONFIGS_LEGION.X_PESTRISK or 0.007 --产生病虫害几率
	self.cangrowindrak = false --能否在黑暗中生长

	self.stage = 1 --当前生长阶段
	self.isflower = false --当前阶段是否开花
	self.isrotten = false --当前阶段是否枯萎
	self.donemoisture = false --当前阶段是否已经浇水
	self.donenutrient = false --当前阶段是否已经施肥
	self.donetendable = false --当前阶段是否已经照顾
	self.level = nil --当前阶段的数据

	self.numfruit = nil --随机果实数量
	self.pollinated = 0 --被授粉次数
	self.infested = 0 --被骚扰次数

	self.taskgrow = nil
	-- self.timedata = {
	-- 	start = nil, --开始进行生长的时间点
	-- 	left = nil, --剩余生长时间（不包括生长系数）
	-- 	paused = false, --是否暂停生长
	-- 	mult = nil, --当前生长时间系数
	-- 	all = nil, --到下一个阶段的全局时间（不包括缩减或增加的时间）
	-- }

	self.cluster_size = { 1, 1.4 } --体型变化范围
	self.cluster_max = 100 --最大簇栽等级
	-- self.cluster = 0 --簇栽等级
	self.lootothers = nil --{ { israndom=false, factor=0.02, name="log", name_rot="xxx" } } 副产物表

	self.ctls = {} --管理者
	self.onctlchange = nil
end,
nil,
{
    -- isflower = onflower,
	-- isrotten = onrotten,
	-- donemoisture = onmoisture,
	-- donenutrient = onnutrient,
	-- cluster = oncluster
})

function PerennialCrop2:SetUp(cropprefab, data)
	self.cropprefab = cropprefab
	self.stage_max = #data.leveldata
	self.leveldata = data.leveldata
	if data.growthmults then
		self.growthmults = data.growthmults
	end
	if data.regrowstage then
		self.regrowstage = data.regrowstage
	end
	if data.cangrowindrak == true then
		self.cangrowindrak = true
	end
	-- self.fn_overripe = data.fn_overripe
	-- self.fn_loot = data.fn_loot
	-- self.fn_stage = data.fn_stage

	if data.cluster_max then
		self.cluster_max = data.cluster_max
	end
	if data.cluster_size then
		self.cluster_size = data.cluster_size
	end
	self.cluster = 0 --现在才写是为了动态更新大小
	self.lootothers = data.lootothers

	if data.getsickchance and self.getsickchance > 0 then
		self.getsickchance = data.getsickchance
	end
end