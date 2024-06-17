local TOOLS_L = require("tools_legion")

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

local PerennialCrop2 = Class(function(self, inst)
	self.inst = inst

	self.cropprefab = "corn" --果实名字，也是数据的key
	self.stage_max = 3 --最大生长阶段
	self.regrowstage = 1 --采摘后重新开始生长的阶段（枯萎后采摘必定从第1阶段开始）
	self.growthmults = { 1, 1, 1, 0 } --四个季节的生长速度(大于1为快，小于1为慢)
	self.leveldata = nil --该植物生长有几个阶段，每个阶段的动画，以及是否处在花期、是否能采集

	self.pollinated_max = 3 --被授粉次数大于等于该值就能增加产量
	self.infested_max = 10 --被侵扰次数大于等于该值就会立即进入枯萎阶段
	self.getsickchance = CONFIGS_LEGION.X_PESTRISK or 0.007 --产生病虫害几率
	self.cangrowindrak = nil --能否在黑暗中生长
	self.notmoisture = nil --是否不要浇水机制
	self.notnutrient = nil --是否不要施肥机制
	self.nottendable = nil --是否不要照顾机制

	self.stage = 1 --当前生长阶段
	self.isflower = false --当前阶段是否开花
	self.isrotten = false --当前阶段是否枯萎
	self.donemoisture = false --当前阶段是否已经浇水
	self.donenutrient = false --当前阶段是否已经施肥
	self.donetendable = false --当前阶段是否已经照顾
	self.level = nil --当前阶段的数据

	self.numfruit = nil --随机果实数量
	self.pollinated = 0 --被授粉次数
	self.infested = 0 --被侵扰次数

	self.task_grow = nil
	self.pause_reason = nil --暂停生长的原因。为 nil 代表没有暂停
	self.time_mult = nil --当前生长速度。为 nil 或 0 代表停止生长
	self.time_grow = nil --已经生长的时间
	self.time_start = nil --本次 task_grow 周期开始的时间

	self.cluster_size = { 1, 1.8 } --体型变化范围
	self.cluster_max = 99 --最大簇栽等级
	self.cluster = 0 --簇栽等级
	self.lootothers = nil --{ { israndom=false, factor=0.02, name="log", name_rot="xxx" } } 副产物表

	self.ctls = {} --管理者
	self.onctlchange = nil --管理器变动时触发：fn(inst, ctls)

	-- self.units = {} --插件

	self.fn_growth = nil --成长时触发：fn(self, nextstagedata)
	self.fn_overripe = nil --过熟时触发：fn(self)
	self.fn_loot = nil --计算收获物时触发：fn(self, doer, ispicked, isburnt, lootprefabs)
	self.fn_pick = nil --收获时触发：fn(self, doer, loot)
	self.fn_stage = nil --每次设定生长阶段时额外触发的函数：fn(self)
	self.fn_timemult = nil --生长速度额外修正：fn(self, multnew)

	self.fn_defend = nil --作物被采集/破坏时会寻求庇护的函数：fn(inst, target)
	self.fn_cluster = nil --簇栽等级变化时触发：fn(self, nowvalue)
	self.fn_season = nil --季节变化时触发：fn(self)
end,
nil,
{
    isflower = onflower,
	isrotten = onrotten,
	donemoisture = onmoisture,
	donenutrient = onnutrient
})

local function OnMoiWater(self, num, ...)
	if num > 0 then
		self.inst.components.perennialcrop2:PourWater(nil, nil, num)
	end
end
local function OnIsRaining(inst)
	inst.components.perennialcrop2:PourWater(nil, nil, 1)
end
local function OnTendTo(inst, doer)
	inst.components.perennialcrop2:TendTo(doer, true)
	return true
end
local function DoMagicGrowth(inst, doer)
	if inst:IsValid() then
		return inst.components.perennialcrop2:DoMagicGrowth(doer, 6*TUNING.TOTAL_DAY_TIME, false)
	end
	return false
end
local function SetCallDefender(self, fn)
	if fn == nil then
		self.fn_defend = function(inst, target)
			TOOLS_L.CallPlantDefender(inst, target)
		end
	else
		self.fn_defend = function(inst, target)
			TOOLS_L.CallPlantDefender(inst, target)
			fn(inst, target)
		end
	end
end
local function OnSeasonChange(inst, season)
	inst.components.perennialcrop2:UpdateTimeMult()
    if inst.components.perennialcrop2.fn_season ~= nil then
		inst.components.perennialcrop2:fn_season()
	end
end

local function OnIgnite(inst, source, doer)
	inst.components.perennialcrop2:SetPauseReason("burning", true)
end
local function OnExtinguish(inst)
	inst.components.perennialcrop2:SetPauseReason("burning", nil)
end
local function OnBurnt(inst)
	inst.components.perennialcrop2:GenerateLoot(nil, false, true)
	inst:Remove()
end

local function UpdateGrow_dark(inst)
	if not inst.components.perennialcrop2:CanGrowInDark() and TOOLS_L.IsTooDarkToGrow(inst) then
		inst.components.perennialcrop2:SetPauseReason("indark", true)
	else
		inst.components.perennialcrop2:SetPauseReason("indark", nil)
	end
end
local function OnIsDark(inst, isit)
	UpdateGrow_dark(inst)
	if isit then --黑暗时判定是否有光源来帮助生长
		if inst.task_l_testgrow == nil then
			inst.task_l_testgrow = inst:DoPeriodicTask(10, UpdateGrow_dark, 1+5*math.random())
		end
	else --非夜晚肯定能生长，所以取消监听
		if inst.task_l_testgrow ~= nil then
			inst.task_l_testgrow:Cancel()
			inst.task_l_testgrow = nil
		end
	end
end
local function UpdateGrow_light(inst)
	if not inst.components.perennialcrop2:CanGrowInLight() and TOOLS_L.IsTooBrightToGrow(inst) then
		inst.components.perennialcrop2:SetPauseReason("inlight", true)
	else
		inst.components.perennialcrop2:SetPauseReason("inlight", nil)
	end
end
local function OnIsDay(inst, isit)
	UpdateGrow_light(inst)
    if isit then --白天必定无法生长，所以直接取消监听
        if inst.task_l_testgrow2 ~= nil then
			inst.task_l_testgrow2:Cancel()
			inst.task_l_testgrow2 = nil
		end
    else --非白天判定是否有光源来阻碍生长
        if inst.task_l_testgrow2 == nil then
			inst.task_l_testgrow2 = inst:DoPeriodicTask(10, UpdateGrow_light, 1+5*math.random())
		end
    end
end

function PerennialCrop2:SetUp(cropprefab, data, data2)
	self.cropprefab = cropprefab
	self.stage_max = #data.leveldata
	self.leveldata = data.leveldata
	if data.growthmults then
		self.growthmults = data.growthmults
	end
	if data.regrowstage then
		self.regrowstage = data.regrowstage
	end
	self.fn_growth = data.fn_growth
	self.fn_overripe = data.fn_overripe
	self.fn_loot = data.fn_loot
	self.fn_lootset = data.fn_lootset
	self.fn_pick = data.fn_pick
	self.fn_stage = data.fn_stage
	self.fn_season = data.fn_season
	SetCallDefender(self, data.fn_defend)

	if data.cluster_max then
		self.cluster_max = data.cluster_max
	end
	if data.cluster_size then
		self.cluster_size = data.cluster_size
	end
	self:OnClusterChange() --这里写是为了动态更新大小
	self.lootothers = data.lootothers

	if data.getsickchance and self.getsickchance > 0 then
		self.getsickchance = data.getsickchance
	end

	self:TriggerMoisture(data2.moisture)
	self:TriggerNutrient(data2.nutrient)
	self:TriggerTendable(data2.tendable)
	if data2.seasonlisten then
		self:TriggerSeasonListen(true)
	end
	if not data2.nomagicgrow then
		self:TriggerGowable(true)
	end
	if not data2.fireproof then
		self:TriggerBurnable(true)
	end
	if data2.cangrowindrak then
		self.cangrowindrak = true
	end
	if data2.nogrowinlight then
		self.nogrowinlight = true
	end
	if not self.cangrowindrak or self.nogrowinlight then
		self.inst:DoTaskInTime(math.random(), function(inst)
			if not self.cangrowindrak then
				self:TriggerGrowInDark(false)
			end
			if self.nogrowinlight then
				self:TriggerGrowInLight(false)
			end
		end)
	end
end
function PerennialCrop2:TriggerMoisture(isadd) --控制浇水机制
	local inst = self.inst
	if isadd then
		self.notmoisture = nil
		self.donemoisture = false

		local function EmptyCptFn(self, ...)end

		inst:AddComponent("moisture") --浇水机制由潮湿度组件控制（能让水球、神话的玉净瓶等起作用）
		local cpt = inst.components.moisture
		cpt.OnUpdate = EmptyCptFn --取消下雨时的潮湿度增加
		cpt.LongUpdate = EmptyCptFn
		cpt.ForceDry = EmptyCptFn
		cpt.OnSave = EmptyCptFn
		cpt.OnLoad = EmptyCptFn
		cpt.DoDelta = OnMoiWater
		inst:StopUpdatingComponent(cpt) --该组件会周期刷新，不需要其逻辑，所以得停止该机制

		inst:WatchWorldState("israining", OnIsRaining) --下雨时补充水分
	else
		self.notmoisture = true
		self.donemoisture = true

		if inst.components.moisture ~= nil then
			inst:RemoveComponent("moisture")
			inst:StopWatchingWorldState("israining", OnIsRaining)
		end
	end
end
function PerennialCrop2:TriggerNutrient(isadd) --控制施肥机制
	-- local inst = self.inst
	if isadd then
		self.notnutrient = nil
		self.donenutrient = false
	else
		self.notnutrient = true
		self.donenutrient = true
	end
end
function PerennialCrop2:TriggerTendable(isadd) --控制照顾机制
	local inst = self.inst
	if isadd then
		self.nottendable = nil
		self.donetendable = false

		local function EmptyCptFn(self, ...)end

		inst:AddComponent("farmplanttendable")
		-- inst.components.farmplanttendable.TendTo = TendTo
		inst.components.farmplanttendable.ontendtofn = OnTendTo
		inst.components.farmplanttendable.OnSave = EmptyCptFn --照顾组件的数据不能保存下来，否则会影响 perennialcrop2
		inst.components.farmplanttendable.OnLoad = EmptyCptFn
		inst.components.farmplanttendable:SetTendable(true)
		inst:AddTag("tendable_farmplant")
	else
		self.nottendable = true
		self.donetendable = true

		if inst.components.farmplanttendable ~= nil then
			inst:RemoveComponent("farmplanttendable")
			inst:RemoveTag("tendable_farmplant")
		end
	end
end
function PerennialCrop2:TriggerGowable(isadd) --控制是否能魔法催熟
	local inst = self.inst
	if isadd then
		local function EmptyCptFn(self, ...)end

		inst:AddComponent("growable")
		local cpt = inst.components.growable
		cpt.stages = {}
		cpt:StopGrowing()
		cpt.magicgrowable = true --非常规造林学生效标志（其他会由组件来施行）
		cpt.domagicgrowthfn = DoMagicGrowth
		cpt.GetCurrentStageData = function(self) return { tendable = false } end
		cpt.StartGrowing = EmptyCptFn
		cpt.LongUpdate = EmptyCptFn
		cpt.OnSave = EmptyCptFn
		cpt.OnLoad = EmptyCptFn
		cpt.Resume = EmptyCptFn
		cpt.Pause = EmptyCptFn
		cpt.OnEntitySleep = EmptyCptFn
		cpt.OnEntityWake = EmptyCptFn
	else
		if inst.components.growable ~= nil then
			inst:RemoveComponent("growable")
		end
	end
end
function PerennialCrop2:TriggerBurnable(isadd) --控制是否能燃烧
	local inst = self.inst
	if isadd then
		MakeSmallBurnable(inst)
		MakeSmallPropagator(inst)
		inst.components.burnable:SetOnIgniteFn(OnIgnite)
		inst.components.burnable:SetOnExtinguishFn(OnExtinguish)
		inst.components.burnable:SetOnBurntFn(OnBurnt)
	else
		if inst.components.burnable ~= nil then
			inst:RemoveComponent("burnable")
			inst:RemoveComponent("propagator")
		end
	end
end
function PerennialCrop2:TriggerGrowInDark(isadd) --控制是否能在黑暗中生长
	local inst = self.inst
	if isadd then
		self.cangrowindrak = true
		inst:StopWatchingWorldState("isnight", OnIsDark)
		OnIsDark(inst, false)
	else
		self.cangrowindrak = nil
		inst:WatchWorldState("isnight", OnIsDark) --虽然洞穴里 isnight 必定是true，但要是哪天会改了呢，所以还是监听上
		OnIsDark(inst, TheWorld.state.isnight)
	end
end
function PerennialCrop2:TriggerGrowInLight(isadd) --控制是否能在阳光下生长
	local inst = self.inst
	if isadd then
		self.nogrowinlight = nil
		inst:StopWatchingWorldState("isday", OnIsDay)
		OnIsDay(inst, true)
	else
		self.nogrowinlight = true
		inst:WatchWorldState("isday", OnIsDay) --虽然洞穴里 isday 必定是false，但要是哪天会改了呢，所以还是监听上
		OnIsDay(inst, TheWorld.state.isday)
	end
end
function PerennialCrop2:TriggerSeasonListen(isadd) --控制是否要监听四季变化
	local inst = self.inst
	if isadd then
		--Tip：WatchWorldState("season" 触发时，不能使用 TheWorld.state.issummer 这种，因为下一帧时才会更新这个数据
		inst:WatchWorldState("season", OnSeasonChange)
		OnSeasonChange(inst)
	else
		inst:StopWatchingWorldState("season", OnSeasonChange)
		-- OnSeasonChange(inst)
	end
end
function PerennialCrop2:CanGrowInDark() --是否能在黑暗中生长
	--枯萎、成熟时(要算过熟)，在黑暗中也要计算时间了
	return self.cangrowindrak or self.isrotten or self.stage == self.stage_max
end
function PerennialCrop2:CanGrowInLight() --是否能在阳光下生长
	--枯萎、成熟时(要算过熟)，在阳光下也要计算时间了
	return not self.nogrowinlight or self.isrotten or self.stage == self.stage_max
end
function PerennialCrop2:SetNoFunction() --只是需要一些数值，而不是需要生长等机制
	local function EmptyCptFn(self, ...)end
	self.StartGrowing = EmptyCptFn
	self.StopGrowing = EmptyCptFn
	self.LongUpdate = EmptyCptFn
	self.OnEntityWake = EmptyCptFn
	self.OnEntitySleep = EmptyCptFn
	self.Pause = EmptyCptFn
	self.Resume = EmptyCptFn
	self.DoGrowth = EmptyCptFn
end

function PerennialCrop2:SetPauseReason(key, value) --更新暂停生长原因
	if value == nil then --减
		if self.pause_reason ~= nil then
			self.pause_reason[key] = nil
			for k, hasit in pairs(self.pause_reason) do
				if hasit then
					self:Pause()
					return --还有原因，就继续暂停
				end
			end
			self.pause_reason = nil
		end
		self:Resume()
	else --增
		if self.pause_reason == nil then
			self.pause_reason = {}
		end
		self.pause_reason[key] = value
		self:Pause()
	end
end
function PerennialCrop2:GetGrowTime() --获取当前阶段的总生长时间
	if self.isrotten then
		return 3*TUNING.TOTAL_DAY_TIME
	end
	if self.level ~= nil and self.level.time ~= nil then
		return self.level.time
	end
	return 0
end
function PerennialCrop2:UpdateTimeMult() --更新生长速度
	local multnew = 1
	if self.isrotten then
		if TheWorld.state.season == "winter" then
			multnew = self.growthmults[4]
		elseif TheWorld.state.season == "summer" then
			multnew = self.growthmults[2]
		elseif TheWorld.state.season == "spring" then
			multnew = self.growthmults[1]
		else --默认为秋，其他mod的特殊季节默认都为秋季
			multnew = self.growthmults[3]
		end
		if multnew > 1 and multnew < 2 then --枯萎恢复的话，在喜好季节是直接时间减半
			multnew = 2
		else --不喜好季节还是默认速度
			multnew = 1
		end
	elseif self.stage ~= self.stage_max then
		if TheWorld.state.season == "winter" then
			multnew = self.growthmults[4]
		elseif TheWorld.state.season == "summer" then
			multnew = self.growthmults[2]
		elseif TheWorld.state.season == "spring" then
			multnew = self.growthmults[1]
		else --默认为秋，其他mod的特殊季节默认都为秋季
			multnew = self.growthmults[3]
		end
		--浇水、施肥、照顾，能加快生长
		local mulmul = 1.0
		if not self.notmoisture and self.donemoisture then
			mulmul = mulmul + 0.15
		end
		if not self.notnutrient and self.donenutrient then
			mulmul = mulmul + 0.2
		end
		if not self.nottendable and self.donetendable then
			mulmul = mulmul + 0.15
		end
		multnew = multnew * mulmul
	end
	if self.fn_timemult ~= nil then
		multnew = self.fn_timemult(self, multnew)
	end
	if multnew ~= nil and multnew <= 0 then
		multnew = nil
	end
	if multnew ~= self.time_mult then
		local dt = GetTime()
		if self.time_start ~= nil and dt > self.time_start then --变化前，需要将之前的时间总结起来
			if self.task_grow ~= nil then
				self.task_grow:Cancel()
				self.task_grow = nil
			end
			dt = dt - self.time_start
			self.time_start = nil
			self:StartGrowing()
			self:TimePassed(dt, true) --只增加 time_grow，这里不管生长
		end
		self.time_mult = multnew
	end
end

function PerennialCrop2:TryDoGrowth() --循环生长
	if self.time_grow == nil then
		return
	end
	if self.time_grow <= 0 then
		self.time_grow = nil
		return
	end
	local growtime = self:GetGrowTime()
	if growtime <= 0 then
		self:StopGrowing()
		return
	end
	if self.time_grow >= growtime then
		self.time_grow = self.time_grow - growtime
		self:DoGrowth()
		if self.inst:IsValid() then --某些异种某些阶段可能会删除自己
			if self.stage >= self.stage_max then --长到最终阶段后，停止循环判断，这样回到家，就有好果子吃啦
				self.time_grow = nil
			else
				self:TryDoGrowth() --继续循环判断
			end
		end
	end
end
function PerennialCrop2:TimePassed(time, nogrow)
	if self.time_mult ~= nil and self.time_mult > 0 then
		self.time_grow = (self.time_grow or 0) + time*self.time_mult
		if not nogrow then
			self:TryDoGrowth()
		end
	end
end
function PerennialCrop2:StartGrowing() --尝试生长
	if self:GetGrowTime() <= 0 then
		self:StopGrowing()
		return
	end
	if self.pause_reason ~= nil then
		return
	end
	if self.time_start == nil then
		self.time_start = GetTime()
	end
	if self.task_grow == nil and not self.inst:IsAsleep() then
		self.task_grow = self.inst:DoPeriodicTask(15+math.random()*10, function(inst, self)
			if self.time_start ~= nil then
				local dt = GetTime() - self.time_start
				self.time_start = GetTime()
				self:TimePassed(dt)
			else --和 time_start 同步
				self.task_grow:Cancel()
				self.task_grow = nil
			end
		end, 5+math.random()*10, self)
	end
end
function PerennialCrop2:StopGrowing() --停止生长
	if self.task_grow ~= nil then
		self.task_grow:Cancel()
		self.task_grow = nil
	end
	self.time_start = nil
	self.time_grow = nil
end
function PerennialCrop2:Pause() --暂停生长
	if self.time_start ~= nil then
		if self.task_grow ~= nil then
			self.task_grow:Cancel()
			self.task_grow = nil
		end
		local dt = GetTime() - self.time_start
		self.time_start = nil --停止
		self:TimePassed(dt, true) --只增加 time_grow，这里不管生长
	end
end
function PerennialCrop2:Resume() --继续生长
	if self.time_start == nil then
		self:StartGrowing() --不管 time_grow 已有进度，让 task_grow 自己之后执行，反正只有几十秒
	end
end

function PerennialCrop2:OnEntitySleep()
    if self.task_grow ~= nil then --只是 task_grow 暂停而已，time_start 不能清除
		self.task_grow:Cancel()
		self.task_grow = nil
	end
end
function PerennialCrop2:OnEntityWake()
	if self.task_grow == nil then
		--刚加载时不处理什么，防止卡顿
		--不管 time_grow 已有进度，让 task_grow 自己之后执行，反正只有几十秒
		self:StartGrowing()
	end
end
function PerennialCrop2:LongUpdate(dt)
	if self.time_start ~= nil then --没有暂停生长
		self.time_start = GetTime() --得更新标记时间
		self:TimePassed(dt, self.inst:IsAsleep()) --植株休眠时，只增加 time_grow
	end
end

local function CanAcceptNutrients(botanyctl, test)
	if test ~= nil and (botanyctl.type == 2 or botanyctl.type == 3) then
		if test[1] ~= nil and test[1] ~= 0 and botanyctl.nutrients[1] < botanyctl.nutrient_max then
			return true
		elseif test[2] ~= nil and test[2] ~= 0 and botanyctl.nutrients[2] < botanyctl.nutrient_max then
			return true
		elseif test[3] ~= nil and test[3] ~= 0 and botanyctl.nutrients[3] < botanyctl.nutrient_max then
			return true
		else
			return false
		end
	end
	return nil
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
	elseif self:GetGrowTime() <= 0 then --永恒阶段
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
function PerennialCrop2:SpawnPest() --生成害虫
	if self.getsickchance > 0 then
		local clusterplus = math.max( math.floor(self.cluster*0.1), 1 )
		if math.random() < self.getsickchance*clusterplus then
			local bugs = SpawnPrefab(math.random()<0.7 and "cropgnat" or "cropgnat_infester")
			if bugs ~= nil then
				bugs.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
			end
		end
	end
end
function PerennialCrop2:GetAddedFruitNum() --获取额外的果实数量
	if self.pollinated >= self.pollinated_max then
		return (self.numfruit or 1) + 1
	else
		return self.numfruit or 1
	end
end
function PerennialCrop2:DoOverripe() --过熟（掉落果子，给周围植物、土地和子圭管理者施肥）
	if self.fn_overripe ~= nil then
		self.fn_overripe(self)
		return
	end

	local num = self.cluster + self:GetAddedFruitNum()
	local numpoop = math.ceil( num*(0.5 + math.random()*0.5) )
	local numloot = num - numpoop
	local pos = self.inst:GetPosition()

	if numpoop > 0 then
		local gnum = 20
		local costplus = numpoop >= gnum and gnum or numpoop

		for _,ctl in pairs(self.ctls) do
			if ctl and ctl:IsValid() and ctl.components.botanycontroller ~= nil then
				local botanyctl = ctl.components.botanycontroller
				local nutrients = { 16*costplus, 16*costplus, 16*costplus }
				if CanAcceptNutrients(botanyctl, nutrients) then
					for i = 1, 5, 1 do
						botanyctl:SetValue(nil, nutrients, true)
						numpoop = numpoop - costplus
						if numpoop <= 0 or not CanAcceptNutrients(botanyctl, nutrients) then
							break
						end
						if costplus == gnum and numpoop < gnum then
							costplus = numpoop
							nutrients = {16*costplus,16*costplus,16*costplus}
						end
					end
				end

				if numpoop <= 0 then
					break
				end
			end
		end

		local x = pos.x
		local y = pos.y
		local z = pos.z
		if numpoop > 0 then
			for i = 1, 5, 1 do
				local hastile = false
				for k1 = -4, 4, 4 do --只影响周围半径一格的地皮，但感觉最多可涉及到3格地皮
					for k2 = -4, 4, 4 do
						local tile = TheWorld.Map:GetTileAtPoint(x+k1, 0, z+k2)
						if tile == GROUND.FARMING_SOIL then
							hastile = true
							local tile_x, tile_z = TheWorld.Map:GetTileCoordsAtPoint(x+k1, 0, z+k2)
							TheWorld.components.farming_manager:AddTileNutrients(tile_x, tile_z, 4*costplus,4*costplus,4*costplus)
						end
					end
				end
				if hastile then
					numpoop = numpoop - costplus
					if numpoop <= 0 then
						break
					end
					if costplus == gnum and numpoop < gnum then
						costplus = numpoop
					end
				else
					break
				end
			end
		end

		if numpoop > 0 then
			local hasset = false
			local ents = TheSim:FindEntities(x, y, z, 5,
				nil, { "INLIMBO", "NOCLICK" }, { "crop_legion", "withered", "barren" }
			)
			for _, v in ipairs(ents) do
				local cpt = nil
				if v.components.pickable ~= nil then
					if v.components.pickable:CanBeFertilized() then
						cpt = v.components.pickable
					end
				elseif v.components.perennialcrop ~= nil then
					cpt = v.components.perennialcrop
				-- elseif v.components.perennialcrop2 ~= nil then
				-- 	cpt = v.components.perennialcrop2
				end
				if cpt ~= nil then
					local poop = SpawnPrefab("glommerfuel")
					if poop ~= nil then
						if hasset then
							cpt:Fertilize(poop, nil)
						else
							hasset = cpt:Fertilize(poop, nil)
						end
						poop:Remove()
					end
				end
			end
			if hasset then
				numpoop = numpoop - costplus
			end
		end

		if numpoop > 0 then
			TOOLS_L.SpawnStackDrop("spoiled_food", numpoop, pos, nil, nil, { dropper = self.inst })
		end
	end
	if numloot > 0 then
		TOOLS_L.SpawnStackDrop(self.cropprefab, numloot, pos, nil, nil, { dropper = self.inst })
	end
end
function PerennialCrop2:DoGrowth() --生长到下一阶段
	local data = self:GetNextStage()
	if data.justgrown or data.overripe then --生长和过熟时都会产生虫群
		self:SpawnPest()
	end
	if data.justgrown then
		if data.stage == self.stage_max or data.level.pickable == 1 then --如果能采集了，开始生成果子数量
			if self.numfruit == nil or self.numfruit <= 1 then --如果只有1个，有机会继续变多
				local num = 1
				local rand = math.random()
				if rand < 0.35 then --35%几率2果实
					num = num + 1
				elseif rand < 0.5 then --15%几率3果实
					num = num + 2
				end
				self.numfruit = num
			end
		end
	elseif data.stage == self.regrowstage or data.stage == 1 then --重新开始生长时，清空某些数据
		if data.overripe then
			self:DoOverripe()
		end
		self.infested = 0
		self.pollinated = 0
		self.numfruit = nil
	end

	if self.fn_growth ~= nil then
		self.fn_growth(self, data)
		if not self.inst:IsValid() then --某些异种某些阶段可能会删除自己
			return
		end
	end

	if data.stage ~= self.stage_max then --生长阶段，就可以三样操作
		self.donemoisture = self.notmoisture == true
		self.donenutrient = self.notnutrient == true
		self.donetendable = self.nottendable == true
		self:CostNutrition() --是生长，肯定要消耗肥料
	end
	self:SetStage(data.stage)
end
local function OnPicked(inst, doer, loot)
	local crop = inst.components.perennialcrop2
	local regrowstage = crop.isrotten and 1 or crop.regrowstage

	if crop.fn_defend ~= nil then
		crop.fn_defend(inst, doer)
	end
	crop:GenerateLoot(doer, true, false)
	if not inst:IsValid() then --inst 在 crop:GenerateLoot() 里可能会被删除
		return
	end

	crop.infested = 0
	crop.pollinated = 0
	crop.numfruit = nil
	crop.donemoisture = crop.notmoisture == true
	crop.donenutrient = crop.notnutrient == true
	crop.donetendable = crop.nottendable == true
	crop.time_grow = nil
	crop:CostNutrition()
	crop:SetStage(regrowstage, false)
end
function PerennialCrop2:SetStage(stage, isrotten) --设置为某阶段
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
	end

	--修改当前阶段数据
	self.stage = stage
	self.level = level
	self.isrotten = rotten
	self.isflower = not rotten and level.bloom == true

	--设置动画
	if rotten then
		self.inst.AnimState:PlayAnimation(level.deadanim, false)
	elseif stage == self.stage_max or level.pickable == 1 then
		if type(level.anim) == 'table' then
			local minnum = #level.anim
			minnum = math.min(minnum, self:GetAddedFruitNum())
			self.inst.AnimState:PlayAnimation(level.anim[minnum], true)
		else
			self.inst.AnimState:PlayAnimation(level.anim, true)
		end
		self.inst.AnimState:SetTime(math.random() * self.inst.AnimState:GetCurrentAnimationLength())
	else
		if type(level.anim) == 'table' then
			self.inst.AnimState:PlayAnimation(level.anim[ math.random(#level.anim) ], true)
		else
			self.inst.AnimState:PlayAnimation(level.anim, true)
		end
		self.inst.AnimState:SetTime(math.random() * self.inst.AnimState:GetCurrentAnimationLength())
	end

	--设置是否可采摘
	if
		rotten or --枯萎了，必定能采集
		level.pickable == 1 or -- 1 代表必定能采集
		(level.pickable ~= -1 and stage == self.stage_max) -- -1 代表不能采集
	then
		if self.inst.components.pickable == nil then
			self.inst:AddComponent("pickable")
		end
		self.inst.components.pickable.onpickedfn = OnPicked
		self.inst.components.pickable:SetUp(nil)
		-- self.inst.components.pickable.use_lootdropper_for_product = true
		self.inst.components.pickable.picksound = rotten and "dontstarve/wilson/harvest_berries"
													or "dontstarve/wilson/pickup_plants"
	elseif self.inst.components.pickable ~= nil then
		self.inst:RemoveComponent("pickable")
	end

	--基础三样操作
	if rotten or stage == self.stage_max then
		self.donemoisture = true
		self.donenutrient = true
		self.donetendable = true
	end
	--设置是否可照顾
	if self.inst.components.farmplanttendable ~= nil then
		self.inst.components.farmplanttendable:SetTendable(not self.donetendable)
	end

	--尝试开始生长
	self:UpdateTimeMult() --更新生长速度
	if self.task_grow == nil then
		self:StartGrowing()
	end

	--额外设置
	if self.fn_stage ~= nil then
		self.fn_stage(self)
	end
end

function PerennialCrop2:AddLoot(loot, name, number)
	if loot[name] == nil then
		loot[name] = number
	else
		loot[name] = loot[name] + number
	end
end
function PerennialCrop2:GetBaseLoot(lootprefabs, sets) --判定基础收获物
	--先算主
	local num = self.cluster + (self.numfruit or 1)
	local ispollinated = self.pollinated >= self.pollinated_max --授粉成功，提高产量
	if ispollinated then
		num = num + math.max( math.floor(self.cluster*0.1), 1 ) --保证肯定多1个
	end
	self:AddLoot(lootprefabs, self.isrotten and (sets.crop_rot or "spoiled_food") or sets.crop, num)

	--后算副
	if sets.lootothers ~= nil then
		for _, data in pairs(sets.lootothers) do
			if data.israndom then
				if ispollinated then
					num = math.random() < (data.factor+0.2) and 1 or 0
				else
					num = math.random() < data.factor and 1 or 0
				end
			else
				num = math.floor(self.cluster*data.factor)
				if ispollinated then
					num = num + math.max( math.floor(num*0.2), 1 ) --保证肯定多1个
				end
			end
			if num > 0 then
				local name
				if self.isrotten then
					name = data.name_rot or "spoiled_food"
				else
					name = data.name
				end
				self:AddLoot(lootprefabs, name, num)
			end
		end
	end
end
function PerennialCrop2:GenerateLoot(doer, ispicked, isburnt) --生成收获物
	local loot = {}
	local lootprefabs = {}
	local pos = self.inst:GetPosition()

	if self.fn_loot ~= nil then
		self.fn_loot(self, doer, ispicked, isburnt, lootprefabs)
	elseif self.stage == self.stage_max or self.level.pickable == 1 then
		self:GetBaseLoot(lootprefabs, {
			doer = doer, ispicked = ispicked, isburnt = isburnt,
			crop = self.cropprefab, crop_rot = "spoiled_food",
			lootothers = self.lootothers
		})
	end

	if not ispicked then --非采集时，多半是破坏
		if self.level.witheredprefab then
			for _, prefab in ipairs(self.level.witheredprefab) do
				self:AddLoot(lootprefabs, prefab, 1)
			end
		end
	end

	if self.isflower and not self.isrotten then
		self:AddLoot(lootprefabs, "petals", 3)
	elseif self.stage > 1 then
		local hasprefab = false
		for _, num in pairs(lootprefabs) do
			if num > 0 then
				hasprefab = true
				break
			end
		end
		if not hasprefab then
			if self.isrotten then
				self:AddLoot(lootprefabs, "spoiled_food", 1)
			else
				self:AddLoot(lootprefabs, "cutgrass", 1)
			end
		end
	end

	if isburnt then
		local lootprefabs2 = {}
		for name, num in pairs(lootprefabs) do
			if TUNING.BURNED_LOOT_OVERRIDES[name] ~= nil then
				self:AddLoot(lootprefabs2, TUNING.BURNED_LOOT_OVERRIDES[name], num)
			elseif PrefabExists(name.."_cooked") then
				self:AddLoot(lootprefabs2, name.."_cooked", num)
			elseif PrefabExists("cooked"..name) then
				self:AddLoot(lootprefabs2, "cooked"..name, num)
			else
				self:AddLoot(lootprefabs2, "ash", num)
			end
		end
		lootprefabs = lootprefabs2
	end
	if not ispicked then --异种也要完全返还，写在后面，防止变成灰烬
		self:AddLoot(lootprefabs, "seeds_"..self.cropprefab.."_l", 1+self.cluster)
	end

	for name, num in pairs(lootprefabs) do --生成实体并设置物理掉落
		if num > 0 then
			TOOLS_L.SpawnStackDrop(name, num, pos, nil, loot, { dropper = self.inst })
		end
	end
	if self.fn_lootset ~= nil then
		self.fn_lootset(self, doer, ispicked, isburnt, loot)
	end
	if ispicked then
		if self.fn_pick ~= nil then
			self.fn_pick(self, doer, loot)
		end
		if doer ~= nil then
			doer:PushEvent("picksomething", { object = self.inst, loot = loot })
			if doer.components.inventory ~= nil then --给予采摘者
				for _, item in pairs(loot) do
					if item.components.inventoryitem ~= nil then
						doer.components.inventory:GiveItem(item, nil, pos)
					end
				end
			end
		end
	end
end

function PerennialCrop2:CostFromLand() --从耕地吸取所需养料、水分
	local x, y, z = self.inst.Transform:GetWorldPosition()
	local tile = TheWorld.Map:GetTileAtPoint(x, 0, z)
	if tile == GROUND.FARMING_SOIL then
		local farmmgr = TheWorld.components.farming_manager
		local tile_x, tile_z = TheWorld.Map:GetTileCoordsAtPoint(x, y, z)
    	local _n1, _n2, _n3 = farmmgr:GetTileNutrients(tile_x, tile_z)
		local clusterplus = math.max( math.floor(self.cluster*0.5), 1 )
		--加水
		if not self.donemoisture then
			if farmmgr:IsSoilMoistAtPoint(x, y, z) then
				self.donemoisture = true
				farmmgr:AddSoilMoistureAtPoint(x, y, z, -2.5*clusterplus)
			end
		end
		--施肥
		if not self.donenutrient then
			if _n3 > 0 then
				_n3 = -3*clusterplus
				_n2 = 0
				_n1 = 0
			elseif _n2 > 0 then
				_n3 = 0
				_n2 = -3*clusterplus
				_n1 = 0
			elseif _n1 > 0 then
				_n3 = 0
				_n2 = 0
				_n1 = -3*clusterplus
			end
			if _n3 < 0 or _n2 < 0 or _n1 < 0 then
				self.donenutrient = true
				farmmgr:AddTileNutrients(tile_x, tile_z, _n1, _n2, _n3)
			end
		end
	end
end
function PerennialCrop2:CostController() --从管理器拿取养料、水分、照顾
	if self.donemoisture and self.donenutrient and self.donetendable then
		return
	end

	local clusterplus = math.max( math.floor(self.cluster*0.5), 1 )
	for _, ctl in pairs(self.ctls) do
		if ctl:IsValid() and ctl.components.botanycontroller ~= nil then
			local botanyctl = ctl.components.botanycontroller
			local change = false
			if not self.donemoisture and (botanyctl.type == 1 or botanyctl.type == 3) and botanyctl.moisture > 0 then
				botanyctl.moisture = math.max(botanyctl.moisture - 2.5*clusterplus, 0)
				self.donemoisture = true
				change = true
			end
			if not self.donenutrient and (botanyctl.type == 2 or botanyctl.type == 3) then
				if botanyctl.nutrients[3] > 0 then
					botanyctl.nutrients[3] = math.max(botanyctl.nutrients[3] - 3*clusterplus, 0)
					self.donenutrient = true
					change = true
				elseif botanyctl.nutrients[2] > 0 then
					botanyctl.nutrients[2] = math.max(botanyctl.nutrients[2] - 3*clusterplus, 0)
					self.donenutrient = true
					change = true
				elseif botanyctl.nutrients[1] > 0 then
					botanyctl.nutrients[1] = math.max(botanyctl.nutrients[1] - 3*clusterplus, 0)
					self.donenutrient = true
					change = true
				end
			end
			if not self.donetendable and botanyctl.type == 3 then
				self.donetendable = true
				-- change = true --这种不算消耗的
				if not self.inst:IsAsleep() then
					self.inst:DoTaskInTime(0.5 + math.random()*0.5, function()
						local fx = SpawnPrefab("farm_plant_happy")
						if fx ~= nil then
							fx.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
						end
					end)
				end
			end
			if change then
				botanyctl:SetBars()
			end
			if self.donemoisture and self.donenutrient and self.donetendable then
				break
			end
		end
	end
end
function PerennialCrop2:CostNutrition() --养料水分索取
	if TheWorld.state.israining or TheWorld.state.issnowing then --如果此时在下雨/雪
		self.donemoisture = true
	end
	self:CostController() --从管理器拿取资源
	if not self.donemoisture or not self.donenutrient then --还需要水分或养料，从耕地里汲取
		self:CostFromLand()
	end
end
function PerennialCrop2:TriggerController(ctl, isadd, noupdate) --管理器变动
	if ctl.GUID == nil then
		return
	end
	if isadd then
		self.ctls[ctl.GUID] = ctl
	else
		self.ctls[ctl.GUID] = nil
	end

	--更新一下已有的管理器
	if not noupdate then
		local newctls = {}
		for _,c in pairs(self.ctls) do
			if c ~= nil and c:IsValid() and c.GUID ~= nil and c.components.botanycontroller ~= nil then
				newctls[c.GUID] = c
			end
		end
		self.ctls = newctls
	end
	if self.onctlchange ~= nil then
		self.onctlchange(self.inst, self.ctls)
	end
end

function PerennialCrop2:OnSave()
    local data = {
        donemoisture = self.donemoisture == true or nil,
        donenutrient = self.donenutrient == true or nil,
		donetendable = self.donetendable == true or nil,
        stage = self.stage > 1 and self.stage or nil,
		isrotten = self.isrotten == true or nil,
		numfruit = self.numfruit ~= nil and self.numfruit or nil,
		pollinated = self.pollinated > 0 and self.pollinated or nil,
		infested = self.infested > 0 and self.infested or nil,
		cluster = self.cluster > 0 and self.cluster or nil
    }
	local dt = self.time_grow
	if self.time_start ~= nil then
		if self.time_mult ~= nil and self.time_mult > 0 then
			dt = (dt or 0) + (GetTime() - self.time_start)*self.time_mult
		end
	end
	if dt ~= nil and dt > 0 then
		data.time_dt = dt
	end
    return data
end
function PerennialCrop2:OnLoad(data)
    if data == nil then
        return
    end
	if not self.notmoisture then
		self.donemoisture = data.donemoisture ~= nil
	end
	if not self.notnutrient then
		self.donenutrient = data.donenutrient ~= nil
	end
	if not self.nottendable then
		self.donetendable = data.donetendable ~= nil
	end
	if data.stage ~= nil then
		self.stage = data.stage
	end
	self.isrotten = data.isrotten ~= nil
	self.numfruit = data.numfruit
	self.pollinated = data.pollinated or 0
	self.infested = data.infested or 0
	if data.cluster ~= nil then
		self.cluster = math.min(data.cluster, self.cluster_max)
		self:OnClusterChange()
	end
	self:SetStage(self.stage, self.isrotten)
	if data.time_dt ~= nil and data.time_dt > 0 then
		self.time_grow = data.time_dt
	end
end

function PerennialCrop2:OnClusterChange() --簇栽等级变化时
	local now = self.cluster or 0
	if self.fn_cluster ~= nil then
		self.fn_cluster(self, now)
	end
	now = Remap(now, 0, self.cluster_max, self.cluster_size[1], self.cluster_size[2])
	self.inst.AnimState:SetScale(now, now, now)
end
function PerennialCrop2:ClusteredPlant(seeds, doer) --簇栽
	local plantable = seeds.components.plantablelegion
	if plantable == nil then
		return false
	end
	if
		plantable.plant ~= self.inst.prefab and
		(plantable.plant2 == nil or plantable.plant2 ~= self.inst.prefab)
	then
		return false, "NOTMATCH_C"
	end
	if self.cluster >= self.cluster_max then
		return false, "ISMAXED_C"
	end

	--升级前，先采摘了，防止玩家骚操作
	if doer ~= nil and self.inst.components.pickable ~= nil then
        self.inst.components.pickable:Pick(doer)
		if not self.inst:IsValid() then --采摘时可能会移除实体
			return true --如果移除实体，就只能不进行接下来的操作了
		end
    end

	if seeds.components.stackable ~= nil then
		local need = self.cluster_max - self.cluster
		local num = seeds.components.stackable:StackSize()
		if need > num then
			self.cluster = self.cluster + num
		else
			self.cluster = self.cluster_max
			seeds = seeds.components.stackable:Get(need)
		end
	else
		self.cluster = self.cluster + 1
	end
	self:OnClusterChange()
	seeds:Remove()

	if doer ~= nil and doer:HasTag("player") then
		TOOLS_L.SendMouseInfoRPC(doer, self.inst, { c = self.cluster }, true, false)
	end
	if self.inst.SoundEmitter ~= nil then
		self.inst.SoundEmitter:PlaySound("dontstarve/common/plant")
	end

	return true
end
function PerennialCrop2:DoCluster(num) --单纯的簇栽升级，也可以降级
	if self.cluster >= self.cluster_max then
		return false
	end

	local newvalue = self.cluster + (num or 1)
	if newvalue > self.cluster_max then
		newvalue = self.cluster_max
	elseif newvalue < 0 then
		newvalue = 0
	else
		newvalue = math.floor(newvalue) --保证是整数
	end
	self.cluster = newvalue
	self:OnClusterChange()

	return newvalue < self.cluster_max
end

function PerennialCrop2:DoMagicGrowth(doer, dt, ignorelvl) --催熟
	--着火时无法被催熟
	if self.inst.components.burnable ~= nil and self.inst.components.burnable:IsBurning() then
		return false
	end
	--暂停生长时无法被催熟
	if self.time_mult == nil or self.time_mult <= 0 or self.time_start == nil then
		return false
	end
	--成熟状态是无法被催熟的（枯萎时可以催熟，加快重生）
	if not self.isrotten and self.stage == self.stage_max then
		return false
	end

	if dt == nil then --没有设定时间时，直接进入下一个阶段
		self:DoGrowth()
	else
		if not ignorelvl then --催熟时间会受到簇栽等级影响
			dt = dt*Remap(self.cluster, 0, self.cluster_max, 1, 1/6)
		end
		self:TimePassed(dt, self.inst:IsAsleep())
	end
	return true
end

function PerennialCrop2:Pollinate(doer, value) --授粉
    if self.isrotten or self.stage == self.stage_max or self.pollinated >= self.pollinated_max then
		return
	end
	self.pollinated = self.pollinated + (value or 1)
end

function PerennialCrop2:Infest(doer, value) --侵扰
	if self.isrotten then
		return false
	end

	self.infested = self.infested + (value or 1)
	if self.infested >= self.infested_max then
		self.infested = 0
		self:StopGrowing() --先清除生长进度
		self:SetStage(self.stage, true) --再设置枯萎
	end

	return true
end
function PerennialCrop2:Cure(doer) --治疗
	self.infested = 0
end

function PerennialCrop2:Tendable(doer, wish) --是否能照顾
	if self.nottendable or self.isrotten or self.stage == self.stage_max then
		return false
	end

	if wish == nil or wish then --希望是照顾
		return not self.donetendable
	else --希望是取消照顾
		return self.donetendable
	end
end
function PerennialCrop2:TendTo(doer, wish) --照顾
	if not self:Tendable(doer, wish) then
		return false
	end

	local tended
	if wish == nil or wish then --希望是照顾
		tended = true
	else --希望是取消照顾
		tended = false
	end
	if self.inst.components.farmplanttendable ~= nil then
		self.inst.components.farmplanttendable:SetTendable(not tended)
	end
	if not self.inst:IsAsleep() then
		-- local tended = self.donetendable --记下此时状态，因为0.5秒后状态可能已经发生改变
		self.inst:DoTaskInTime(0.5 + math.random()*0.5, function()
			local fx = SpawnPrefab(tended and "farm_plant_happy" or "farm_plant_unhappy")
			if fx ~= nil then
				fx.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
			end
		end)
	end
	self.donetendable = tended
	self:UpdateTimeMult() --更新生长速度

	return true
end
function PerennialCrop2:Fertilize(item, doer) --施肥
	if self.notnutrient or self.isrotten or self.donenutrient or self.stage == self.stage_max then
		return false
	end

	if item.components.fertilizer ~= nil and item.components.fertilizer.nutrients ~= nil then
		if self.inst.components.burnable ~= nil then --快着火时能阻止着火
			self.inst.components.burnable:StopSmoldering()
		end
		if item.components.fertilizer.fertilize_sound ~= nil then
			self.inst.SoundEmitter:PlaySound(item.components.fertilizer.fertilize_sound)
		end
		self.donenutrient = true
		self:UpdateTimeMult() --更新生长速度

		return true
	end

	return false
end
function PerennialCrop2:PourWater(item, doer, value) --浇水
	if self.notmoisture or self.isrotten or self.donemoisture or self.stage == self.stage_max then
		return false
	end

	self.donemoisture = true
	self:UpdateTimeMult() --更新生长速度

	return true
end

return PerennialCrop2
