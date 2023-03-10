local function onflower(self)
    if self.isflower then
        self.inst:AddTag("flower")
    else
        self.inst:RemoveTag("flower")
    end
end
local function onrotten(self)
    if self.isrotten then
        self.inst:AddTag("nognatinfest")
    else
        self.inst:RemoveTag("nognatinfest")
    end
end
local function onmoisture(self)
    if self.donemoisture then
        self.inst:RemoveTag("needwater")
    else
        self.inst:AddTag("needwater")
    end
end
local function onnutrient(self)
    if self.donenutrient then
        self.inst:RemoveTag("fertableall")
    else
        self.inst:AddTag("fertableall")
    end
end
local function oncluster(self)
    local now = self.cluster
	now = Remap(now, 0, self.cluster_max, self.cluster_size[1], self.cluster_size[2])
	self.inst.AnimState:SetScale(now, now, now)
end

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

	self.cluster_size = { 1, 1.8 } --体型变化范围
	self.cluster_max = 100 --最大簇栽等级
	-- self.cluster = 0 --簇栽等级
	self.lootothers = nil --{ { israndom=false, factor=0.02, name="log", name_rot="xxx" } } 副产物表

	self.ctls = {} --管理者
	self.onctlchange = nil

	-- self.fn_overripe = nil --过熟时触发：fn(self, numloot)
	-- self.fn_loot = nil --获取收获物时触发：fn(self, loot)
	self.fn_stage = nil --每次设定生长阶段时额外触发的函数：fn(self)
	-- self.fn_defend = nil --作物被采集/破坏时会寻求庇护的函数：fn(inst, target)
end,
nil,
{
    isflower = onflower,
	isrotten = onrotten,
	donemoisture = onmoisture,
	donenutrient = onnutrient,
	cluster = oncluster
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
	self.fn_stage = data.fn_stage

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

function PerennialCrop2:GetNextStage() --判定下一个阶段
	local data = {
		stage = 1,
		justgrown = false, --是否是正常生长到下一阶段
		overripe = false, --是否是过熟
		level = nil
	}

	if self.isrotten then --枯萎阶段->1阶段
		data.stage = 1
	elseif self.level.time == nil or self.level.time == 0 then --永恒阶段
		data.stage = self.stage
	elseif self.stage >= self.stage_max then --成熟阶段->再生阶段（过熟）
		data.stage = self.regrowstage
		data.overripe = true
	else --生长阶段->下一个生长阶段（不管是否成熟）
		data.stage = self.stage + 1
		data.justgrown = true
	end
	data.level = self.leveldata[data.stage]

	return data
end

local function OnPicked(inst, doer, loot)
	local crop = inst.components.perennialcrop2
	crop:GenerateLoot(doer, true, false)
	local regrowstage = crop.isrotten and 1 or crop.regrowstage --枯萎之后，只能从第一阶段开始
	if crop.fn_defend ~= nil then
		crop.fn_defend(inst, doer)
	end
	crop.infested = 0
	crop.pollinated = 0
	crop.numfruit = nil
	crop.donenutrient = false
	crop.donetendable = false
	crop.donemoisture = false
	crop:CostNutrition()
	crop:SetStage(regrowstage, false, false)
	crop:StartGrowing()
end
function PerennialCrop2:SetStage(stage, isrotten, skip) --设置为某阶段
	if stage == nil or stage < 1 then
		stage = 1
	elseif stage > self.stage_max then
		stage = self.stage_max
	end

	--确定当前的阶段
	local rotten = false
	local level = self.leveldata[stage]
	if isrotten then
		if level.deadanim == nil then --枯萎了，但是没有枯萎状态，回到第一个阶段
			level = self.leveldata[1]
			stage = 1
		else
			rotten = true
		end
	-- else
		-- if stage == self.stage_max then --成熟时
		-- 	if self.numfruit == nil or self.numfruit <= 0 then --没有果实，回到再生阶段
		-- 		stage = self.regrowstage
		-- 		level = self.leveldata[stage]
		-- 	end
		-- end
	end

	--修改当前阶段数据
	self.stage = stage
	self.level = level
	self.isrotten = rotten

	if skip then --如果跳过，就不设置接下来的操作
		return
	end

	self.isflower = not rotten and level.bloom == true --花期跳过不影响流程

	--设置动画
	if rotten then
		self.inst.AnimState:PlayAnimation(level.deadanim, false)
		self.donemoisture = true --枯萎了，必定不能操作
		self.donenutrient = true
		self.donetendable = true
	elseif stage == self.stage_max then
		if type(level.anim) == 'table' then
			local minnum = #level.anim
			minnum = math.min(minnum, self.numfruit or 3)
			self.inst.AnimState:PlayAnimation(level.anim[minnum], true)
		else
			self.inst.AnimState:PlayAnimation(level.anim, true)
		end
		self.inst.AnimState:SetTime(math.random() * self.inst.AnimState:GetCurrentAnimationLength())
		self.donemoisture = true --成熟了，必定不能操作
		self.donenutrient = true
		self.donetendable = true
	else
		if type(level.anim) == 'table' then
			self.inst.AnimState:PlayAnimation(level.anim[ math.random(#level.anim) ], true)
		else
			self.inst.AnimState:PlayAnimation(level.anim, true)
		end
		self.inst.AnimState:SetTime(math.random() * self.inst.AnimState:GetCurrentAnimationLength())
	end

	--设置是否可采摘
	local pick = level.pickable or 0
	if
		rotten or --枯萎了，必定能采集
		pick == 1 or -- 1 代表必定能采集
		(pick ~= -1 and stage == self.stage_max) -- -1 代表不能采集
	then
		if self.inst.components.pickable == nil then
			self.inst:AddComponent("pickable")
		end
		self.inst.components.pickable.onpickedfn = OnPicked
		self.inst.components.pickable:SetUp(nil)
		-- self.inst.components.pickable.use_lootdropper_for_product = true
		self.inst.components.pickable.picksound = rotten and "dontstarve/wilson/harvest_berries"
																or "dontstarve/wilson/pickup_plants"
	else
		self.inst:RemoveComponent("pickable")
	end

	--设置是否可照顾
	if self.inst.components.farmplanttendable ~= nil then
		self.inst.components.farmplanttendable:SetTendable(not self.donetendable)
	end

	--额外设置
	if self.fn_stage ~= nil then
		self.fn_stage(self)
	end
end
