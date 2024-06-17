local TOOLS_L = require("tools_legion")

local function onflower(self)
    if self.isflower then
        self.inst:AddTag("flower")
    else
        self.inst:RemoveTag("flower")
    end
end
local function onsick(self)
	if self.sickness <= 0 then
		self.inst.AnimState:SetMultColour(1, 1, 1, 1)
	elseif self.sickness >= 0.3 then
		self.inst.AnimState:SetMultColour(0.6, 0.6, 0.6, 1)
	else
		local color = 1 - self.sickness/0.3 * 0.4
		self.inst.AnimState:SetMultColour(color, color, color, 1)
	end
end
local function onrotten(self)
    if self.isrotten then
        self.inst:AddTag("nognatinfest")
    else
        self.inst:RemoveTag("nognatinfest")
    end
end

local PerennialCrop = Class(function(self, inst)
	self.inst = inst

	self.moisture = 0 --当前水量
	self.nutrient = 0 --当前肥量（生长必需）
	self.nutrientgrow = 0 --当前肥量（生长加速）
	self.nutrientsick = 0 --当前肥量（预防疾病）
	self.sickness = 0 --当前病害程度
	self.stage = 1	--当前生长阶段
	self.stagedata = {} --当前阶段的数据
	self.isflower = false --当前阶段是否开花
	self.isrotten = false --当前阶段是否腐烂/枯萎
	self.ishuge = false --是否是巨型成熟
	self.tended = false --当前阶段是否已经照顾过了

	self.infested = 0 --被骚扰次数
	self.pollinated = 0 --被授粉次数
	self.num_nutrient = 0 --吸收肥料次数
	self.num_moisture = 0 --吸收水分次数
	self.num_tended = 0 --被照顾次数
	self.num_perfect = nil --成熟时结算出的：完美指数（决定果实数量或者是否巨型）

	self.ctls = {}
	self.onctlchange = nil

	self.task_grow = nil
	self.pause_reason = nil --暂停生长的原因。为 nil 代表没有暂停
	self.time_mult = nil --当前生长速度。为 nil 或 0 代表停止生长
	self.time_grow = nil --已经生长的时间
	self.time_start = nil --本次 task_grow 周期开始的时间

	self.moisture_max = 20 --最大蓄水量
	self.nutrient_max = 50 --最大蓄肥量（生长必需）
	self.nutrientgrow_max = 50 --最大蓄肥量（生长加速）
	self.nutrientsick_max = 50 --最大蓄肥量（预防疾病）
	self.stage_max = 2 --最大生长阶段
	self.pollinated_max = 3 --被授粉次数大于等于该值就能增加产量
	self.infested_max = 10 --被骚扰次数大于等于该值就会立即进入枯萎状态

	self.product = nil
	self.product_huge = nil
	self.seed = nil
	self.loot_huge_rot = nil
	self.cost_moisture = 1 --需水量
	self.cost_nutrient = 2 --需肥量(这里只需要一个量即可，不需要关注肥料类型)
	self.nosick = nil --是否不产生病虫害（原创）
	self.cangrowindrak = nil --是否能在黑暗中生长（原创）
	self.stages = nil --该植物生长有几个阶段，每个阶段的动画，以及是否处在花期（原创）
	self.stages_other = nil --巨大化阶段、巨大化枯萎、枯萎等阶段的数据
	self.regrowstage = 1 --枯萎或者采摘后重新开始生长的阶段（原创）
	self.goodseasons = {} --喜好季节：{autumn = true, winter = true, spring = true, summer = true}
	self.killjoystolerance = 0 --扫兴容忍度：一般都为0
	self.sounds = {
		grow_full = "farming/common/farm/grow_full",
		grow_rot = "farming/common/farm/rot"
	}

	self.fn_stage = nil --每次设定生长阶段时额外触发的函数：fn(inst, isfull)
	self.fn_defend = nil --作物被采集/破坏时会寻求庇护的函数：fn(inst, target)
end,
nil,
{
    isflower = onflower,
	sickness = onsick,
	isrotten = onrotten,
})

local function AddTag(inst, name)
	if not inst:HasTag(name) then
		inst:AddTag(name)
	end
end
local function RemoveTag(inst, name)
	if inst:HasTag(name) then
		inst:RemoveTag(name)
	end
end
local function TriggerNutrient(self)
	if self.nutrient >= self.nutrient_max then
		RemoveTag(self.inst, "fertable3")
	else
		AddTag(self.inst, "fertable3")
	end
	if self.nutrientgrow >= self.nutrientgrow_max then
		RemoveTag(self.inst, "fertable1")
	else
		AddTag(self.inst, "fertable1")
	end
	if self.nutrientsick >= self.nutrientsick_max then
		RemoveTag(self.inst, "fertable2")
	else
		AddTag(self.inst, "fertable2")
	end
end
local function TriggerMoisture(self)
	if self.moisture >= self.moisture_max then
		RemoveTag(self.inst, "needwater")
	else
		AddTag(self.inst, "needwater")
	end
end

local function EmptyCptFn(self, ...)
	--nothing
end
local function OnTendTo(inst, doer)
	inst.components.perennialcrop:TendTo(doer, true)
	return true
end
local function OnMoiWater(self, num, ...)
	if num > 0 then
		self.inst.components.perennialcrop:PourWater(nil, nil, num)
	end
end
local function OnIsRaining(inst)
	--不管雨始还是雨停，增加一半的蓄水量(反正一场雨结束，总共只加最大蓄水量的数值)
	inst.components.perennialcrop:PourWater(nil, nil, inst.components.perennialcrop.moisture_max/2)
end
local function DoMagicGrowth(inst, doer)
	if inst:IsValid() then
		return inst.components.perennialcrop:DoMagicGrowth(doer, 2*TUNING.TOTAL_DAY_TIME)
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
	inst.components.perennialcrop:UpdateTimeMult()
    -- if inst.components.perennialcrop.fn_season ~= nil then
	-- 	inst.components.perennialcrop:fn_season()
	-- end
end

local function OnIgnite(inst, source, doer)
	inst.components.perennialcrop:SetPauseReason("burning", true)
end
local function OnExtinguish(inst)
	inst.components.perennialcrop:SetPauseReason("burning", nil)
end
local function OnBurnt(inst)
	inst.components.perennialcrop:GenerateLoot(nil, false, true)
	inst:Remove()
end

local function UpdateGrowing(inst)
	if not inst.components.perennialcrop:CanGrowInDark() and TOOLS_L.IsTooDarkToGrow(inst) then
		inst.components.perennialcrop:SetPauseReason("indark", true)
	else
		inst.components.perennialcrop:SetPauseReason("indark", nil)
	end
end
local function OnIsDark(inst, isit)
	UpdateGrowing(inst)
	if isit then
		if inst.task_l_testgrow == nil then
			inst.task_l_testgrow = inst:DoPeriodicTask(5, UpdateGrowing, 1+5*math.random())
		end
	else
		if inst.task_l_testgrow ~= nil then
			inst.task_l_testgrow:Cancel()
			inst.task_l_testgrow = nil
		end
	end
end

function PerennialCrop:SetUp(data)
	self.product = data.product
	self.product_huge = data.product_huge
	self.seed = data.seed
	self.loot_huge_rot = data.loot_huge_rot
	self.cost_moisture = data.cost_moisture or 1
	self.cost_nutrient = data.cost_nutrient or 2
	self.nosick = data.nosick
	self.stages = data.stages
	self.stages_other = data.stages_other
	self.stage_max = #data.stages
	self.regrowstage = data.regrowstage or 1
	self.goodseasons = data.goodseasons or {}
	self.killjoystolerance = data.killjoystolerance or 0
	if data.sounds ~= nil then
		self.sounds = data.sounds
	end
	self.fn_stage = data.fn_stage
	self.fn_researchstage = data.fn_researchstage
	SetCallDefender(self, data.fn_defend)

	if not data.fireproof then
		self:TriggerBurnable(true)
	end
	if not data.nomagicgrow then
		self:TriggerGowable(true)
	end
	if data.cangrowindrak then
		self.cangrowindrak = true
	else
		self:TriggerGrowInDark(false)
	end

	local inst = self.inst

	inst:AddComponent("farmplanttendable")
	inst.components.farmplanttendable.ontendtofn = OnTendTo
	inst.components.farmplanttendable.OnSave = EmptyCptFn --照顾组件的数据不能保存下来，否则会影响 perennialcrop
	inst.components.farmplanttendable.OnLoad = EmptyCptFn

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

	--Tip：WatchWorldState("season" 触发时，不能使用 TheWorld.state.issummer 这种，因为下一帧时才会更新这个数据
	inst:WatchWorldState("season", OnSeasonChange)
	OnSeasonChange(inst)
end
function PerennialCrop:TriggerBurnable(isadd) --控制是否能燃烧
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
function PerennialCrop:TriggerGowable(isadd) --控制是否能魔法催熟
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
function PerennialCrop:TriggerGrowInDark(isadd) --控制是否能在黑暗中生长
	local inst = self.inst
	if inst.task_l_trytestgrow ~= nil then
		inst.task_l_trytestgrow:Cancel()
	end
	if isadd then
		self.cangrowindrak = true
		inst:StopWatchingWorldState("isnight", OnIsDark)
		inst.task_l_trytestgrow = inst:DoTaskInTime(math.random(), function(inst)
			inst.task_l_trytestgrow = nil
			OnIsDark(inst, false)
		end)
	else
		self.cangrowindrak = nil
		inst:WatchWorldState("isnight", OnIsDark)
		inst.task_l_trytestgrow = inst:DoTaskInTime(math.random(), function(inst)
			inst.task_l_trytestgrow = nil
			OnIsDark(inst, TheWorld.state.isnight)
		end)
	end
end
function PerennialCrop:CanGrowInDark() --是否能在黑暗中生长
	--枯萎、成熟时(要算过熟)，在黑暗中也要计算时间了
	return self.cangrowindrak or self.isrotten or self.stage == self.stage_max
end

function PerennialCrop:SetPauseReason(key, value) --更新暂停生长原因
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
function PerennialCrop:GetGrowTime() --获取当前阶段的总生长时间
	if self.stagedata ~= nil and self.stagedata.time ~= nil then
		return self.stagedata.time
	end
	return 0
end
function PerennialCrop:UpdateTimeMult() --更新生长速度
	local multnew = 1
	if self.isrotten then
		if self.goodseasons[TheWorld.state.season] then --枯萎恢复的话，在喜好季节是直接时间减半
			multnew = 2
		end
	elseif self.stage ~= self.stage_max then
		if self.goodseasons[TheWorld.state.season] then --喜好季节则快60%
			multnew = multnew + 0.6
		end
		if self.nutrientgrow >= self.cost_nutrient then --有加速肥则快40%
			multnew = multnew + 0.4
		end
	end
	-- if self.fn_timemult ~= nil then
	-- 	multnew = self.fn_timemult(self, multnew)
	-- end
	-- if multnew ~= nil and multnew <= 0 then
	-- 	multnew = nil
	-- end
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

function PerennialCrop:TryDoGrowth() --循环生长
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
		if self.inst:IsValid() then --某些阶段可能会删除自己
			if not self.isrotten and self.stage >= self.stage_max then --长到最终阶段后，停止循环判断，这样回到家，就有好果子吃啦
				self.time_grow = nil
			else
				self:TryDoGrowth() --继续循环判断
			end
		end
	end
end
function PerennialCrop:TimePassed(time, nogrow)
	if self.time_mult ~= nil and self.time_mult > 0 then
		self.time_grow = (self.time_grow or 0) + time*self.time_mult
		if not nogrow then
			self:TryDoGrowth()
		end
	end
end
function PerennialCrop:StartGrowing() --尝试生长
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
function PerennialCrop:StopGrowing() --停止生长
	if self.task_grow ~= nil then
		self.task_grow:Cancel()
		self.task_grow = nil
	end
	self.time_start = nil
	self.time_grow = nil
end
function PerennialCrop:Pause() --暂停生长
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
function PerennialCrop:Resume() --继续生长
	if self.time_start == nil then
		self:StartGrowing() --不管 time_grow 已有进度，让 task_grow 自己之后执行，反正只有几十秒
	end
end

function PerennialCrop:OnEntitySleep()
    if self.task_grow ~= nil then --只是 task_grow 暂停而已，time_start 不能清除
		self.task_grow:Cancel()
		self.task_grow = nil
	end
end
function PerennialCrop:OnEntityWake()
	if self.task_grow == nil then
		--刚加载时不处理什么，防止卡顿
		--不管 time_grow 已有进度，让 task_grow 自己之后执行，反正只有几十秒
		self:StartGrowing()
	end
end
function PerennialCrop:LongUpdate(dt)
	if self.time_start ~= nil then --没有暂停生长
		self.time_start = GetTime() --得更新标记时间
		self:TimePassed(dt, self.inst:IsAsleep()) --植株休眠时，只增加 time_grow
	end
end

local function ComputNutrient(self, nowkey, maxkey, have)
	if self[nowkey] < self[maxkey] and have > 0 then
		have = math.min(have, self[maxkey] - self[nowkey])
		self[nowkey] = self[nowkey] + have
		return -have
	end
	return 0
end
local function ComputValue(valuectl, valueneed)
	local _mo = 0
	if valuectl >= valueneed then
		_mo = valueneed
		valueneed = 0
	else
		_mo = valuectl
		valueneed = valueneed - valuectl
	end
	return valueneed, _mo
end
function PerennialCrop:CostFromLand() --从耕地吸取所需养料、水分
	local x, y, z = self.inst.Transform:GetWorldPosition()
	local tile = TheWorld.Map:GetTileAtPoint(x, 0, z)
	if tile == GROUND.FARMING_SOIL then
		local farmmgr = TheWorld.components.farming_manager
		local tile_x, tile_z = TheWorld.Map:GetTileCoordsAtPoint(x, y, z)
    	local _n1, _n2, _n3 = farmmgr:GetTileNutrients(tile_x, tile_z)

		--加水
		if self.moisture < self.moisture_max then
			if farmmgr:IsSoilMoistAtPoint(x, y, z) then
				local n = self.moisture_max - self.moisture
				self:PourWater(nil, nil, n)
				farmmgr:AddSoilMoistureAtPoint(x, y, z, -n*0.1) --地里的水只有100点，数值比不太对，所以得弄小一点，乘个0.1
			end
		end

		_n3 = ComputNutrient(self, "nutrient", "nutrient_max", _n3)
		_n2 = ComputNutrient(self, "nutrientgrow", "nutrientgrow_max", _n2)
		_n1 = ComputNutrient(self, "nutrientsick", "nutrientsick_max", _n1)
		if _n3 < 0 or _n2 < 0 or _n1 < 0 then
			farmmgr:AddTileNutrients(tile_x, tile_z, _n1, _n2, _n3)
		end
	end
end
function PerennialCrop:CostController() --从管理器拿取养料、水分、照顾
	local need_mo = math.max(0, self.moisture_max - self.moisture)
	local need_n1 = math.max(0, self.nutrientgrow_max - self.nutrientgrow)
	local need_n2 = math.max(0, self.nutrientsick_max - self.nutrientsick)
	local need_n3 = math.max(0, self.nutrient_max - self.nutrient)

	if need_mo <= 0 and need_n1 <= 0 and need_n2 <= 0 and need_n3 <= 0 and self.tended then
		return
	end

	local _mo = 0
	for _, ctl in pairs(self.ctls) do
		if ctl:IsValid() and ctl.components.botanycontroller ~= nil then
			local botanyctl = ctl.components.botanycontroller
			local change = false
			if need_mo > 0 and (botanyctl.type == 1 or botanyctl.type == 3) and botanyctl.moisture > 0 then
				need_mo, _mo = ComputValue(botanyctl.moisture, need_mo)
				botanyctl.moisture = botanyctl.moisture - _mo
				self:PourWater(nil, nil, _mo)
				change = true
			end
			if botanyctl.type == 2 or botanyctl.type == 3 then
				if need_n1 > 0 and botanyctl.nutrients[1] > 0 then
					need_n1, _mo = ComputValue(botanyctl.nutrients[1], need_n1)
					botanyctl.nutrients[1] = botanyctl.nutrients[1] - _mo
					self.nutrientgrow = self.nutrientgrow + _mo
					change = true
				end
				if need_n2 > 0 and botanyctl.nutrients[2] > 0 then
					need_n2, _mo = ComputValue(botanyctl.nutrients[2], need_n2)
					botanyctl.nutrients[2] = botanyctl.nutrients[2] - _mo
					self.nutrientsick = self.nutrientsick + _mo
					change = true
				end
				if need_n3 > 0 and botanyctl.nutrients[3] > 0 then
					need_n3, _mo = ComputValue(botanyctl.nutrients[3], need_n3)
					botanyctl.nutrients[3] = botanyctl.nutrients[3] - _mo
					self.nutrient = self.nutrient + _mo
					change = true
				end
			end
			if not self.tended and botanyctl.type == 3 then
				self:TendTo(ctl, true)
			end
			if change then
				botanyctl:SetBars()
			end
			if need_mo <= 0 and need_n1 <= 0 and need_n2 <= 0 and need_n3 <= 0 and self.tended then
				break
			end
		end
	end
end
function PerennialCrop:CostNutrition(needtag) --养料水分索取
	if TheWorld.state.israining or TheWorld.state.issnowing then --如果此时在下雨/雪
		self:PourWater(nil, nil, self.moisture_max)
	end
	self:CostController() --从管理器拿取资源
	if --还需要水分或养料，从耕地里汲取
		self.moisture_max > self.moisture or self.nutrientgrow_max > self.nutrientgrow or
		self.nutrientsick_max > self.nutrientsick or self.nutrient_max > self.nutrient
	then
		self:CostFromLand()
	end
	if needtag then
		TriggerNutrient(self)
	end
end
function PerennialCrop:TriggerController(ctl, isadd, noupdate) --管理器变动
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

function PerennialCrop:SpawnPest() --生成害虫
	if self.sickness > 0 and math.random() < (self.sickness/10) then --产生虫群（避免生成太多，这里还需要减少几率）
		local bugs = SpawnPrefab(math.random()<0.7 and "cropgnat" or "cropgnat_infester")
		if bugs ~= nil then
			bugs.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
		end
	end
end
function PerennialCrop:GetNextStage() --判定下一个阶段
	local data = {
		stage = 1,
		ishuge = false,
		isrotten = false,
		justgrown = false,
		stagedata = nil
	}
	if self.isrotten then --枯萎阶段->重生阶段
		data.stage = self.regrowstage
		data.stagedata = self.stages[data.stage]
	elseif self:GetGrowTime() <= 0 then --永恒阶段
		data.stage = self.stage
		data.stagedata = self.stages[data.stage]
		data.ishuge = self.ishuge --如果永恒的话，也得维持巨大化吧
	elseif self.stage >= self.stage_max then --成熟阶段->枯萎/巨型枯萎阶段
		if self.ishuge and self.stages_other.huge_rot ~= nil then
			data.stage = self.stage_max
			data.ishuge = true
			data.isrotten = true
			data.stagedata = self.stages_other.huge_rot
		elseif self.stages_other.rot ~= nil then
			data.stage = self.stage_max
			data.isrotten = true
			data.stagedata = self.stages_other.rot
		else --没有枯萎状态的话，只能回到重生阶段了
			data.stage = self.regrowstage
			data.stagedata = self.stages[data.stage]
		end
	else --生长阶段->下一个生长阶段（不管是否成熟）
		data.stage = self.stage + 1
		data.stagedata = self.stages[data.stage]
		data.justgrown = true
	end
	return data
end
function PerennialCrop:DoGrowth() --生长到下一阶段
	local data = self:GetNextStage()
	local soundkey = nil
	if data.isrotten then
		soundkey = "grow_rot"
	elseif data.justgrown then
		self:CostNutrition() --计算消耗之前，先补充资源
		if self.nutrient >= self.cost_nutrient then --生长必需肥料的积累
			self.nutrient = self.nutrient - self.cost_nutrient
			self.num_nutrient = self.num_nutrient + 1
			if self.infested > 0 then
				self.infested = math.max(0, self.infested-3)
			end
		end
		if self.nutrientgrow >= self.cost_nutrient then --加速生长肥料的消耗
			self.nutrientgrow = self.nutrientgrow - self.cost_nutrient
		end
		if not self.nosick then
			if self.nutrientsick >= self.cost_nutrient then --预防疾病肥料的消耗
				self.nutrientsick = self.nutrientsick - self.cost_nutrient
				if self.sickness > 0 then
					self.sickness = math.max(0, self.sickness-0.06)
				end
			else
				if self.sickness < 1 then
					self.sickness = math.min(1, self.sickness+0.02)
				end
			end
			self:SpawnPest()
		elseif self.sickness > 0 then
			self.sickness = 0
		end
		if self.moisture >= self.cost_moisture then --水分的积累
			self.moisture = self.moisture - self.cost_moisture
			self.num_moisture = self.num_moisture + 1
		end
		if data.stage == self.stage_max then --如果成熟了
			local stagegrow = self.stage_max - self.regrowstage
			local countgrow = self.killjoystolerance

			if self.num_moisture >= stagegrow then --生长必需浇水
				countgrow = countgrow + 1
			end
			if self.num_nutrient >= stagegrow then --生长必需施肥
				countgrow = countgrow + 1
			end
			if self.goodseasons[TheWorld.state.season] then --在喜好的季节
				countgrow = countgrow + 1
			end
			if self.sickness <= 0.1 then --病害程度很低
				countgrow = countgrow + 1
			end
			if self.num_tended >= 1 and self.num_tended >= (stagegrow-1) then --被照顾次数至少得是生长阶段总数的-1次
				countgrow = countgrow + 1
			end

			self.num_perfect = countgrow
			if countgrow >= 5 and self.stages_other.huge ~= nil then --判断是否巨型
				data.ishuge = true
				soundkey = "grow_oversized"
			else
				soundkey = "grow_full"
			end

			--结算完成，清空某些数据
			self.num_nutrient = 0
			self.num_moisture = 0
			self.num_tended = 0
		else
			self.tended = false
		end
	elseif data.stage == self.regrowstage or data.stage == 1 then --重新开始生长时，清空某些数据
		self.num_nutrient = 0
		self.num_moisture = 0
		self.num_tended = 0
		self.infested = 0
		self.pollinated = 0
		self.num_perfect = nil
		self.tended = false
	end
	if soundkey ~= nil and self.sounds[soundkey] ~= nil then
		self.inst.SoundEmitter:PlaySound(self.sounds[soundkey])
	end
	self:SetStage(data.stage, data.ishuge, data.isrotten)
end
local function OnPicked(inst, doer, loot)
	local crop = inst.components.perennialcrop
	if crop.fn_defend ~= nil then
		crop.fn_defend(inst, doer)
	end
	crop:GenerateLoot(doer, true, false)
	if not inst:IsValid() then --inst 在 crop:GenerateLoot() 里可能会被删除
		return
	end
	crop.num_nutrient = 0
	crop.num_moisture = 0
	crop.num_tended = 0
	crop.infested = 0
	crop.pollinated = 0
	crop.num_perfect = nil
	crop.tended = false
	crop.time_grow = nil
	crop:CostNutrition()
	crop:SetStage(crop.regrowstage, false, false)
end
function PerennialCrop:SetStage(stage, ishuge, isrotten) --设置为某阶段
	if stage == nil or stage < 1 then
		stage = 1
	elseif stage > self.stage_max then
		stage = self.stage_max
	end

	--确定当前的阶段
	local rotten = false
	local huge = false
	local stage_data = nil

	if isrotten then
		if ishuge then
			if self.stages_other.huge_rot ~= nil then --腐烂、巨型状态
				stage = self.stage_max
				stage_data = self.stages_other.huge_rot
				rotten = true
				huge = true
				self.tended = true
			end
		end
		if stage_data == nil then
			if self.stages_other.rot ~= nil then --腐烂状态
				stage_data = self.stages_other.rot
				rotten = true
				self.tended = true
			else --如果没有腐烂状态就进入重新生长的阶段
				stage = self.regrowstage
				stage_data = self.stages[stage]
			end
		end
	elseif ishuge then
		stage = self.stage_max
		if self.stages_other.huge ~= nil then --巨型状态
			stage_data = self.stages_other.huge
			huge = true
		else --如果没有巨型状态就进入成熟阶段
			stage_data = self.stages[stage]
		end
		self.tended = true
	else
		stage_data = self.stages[stage]
		if stage == self.stage_max then
			self.tended = true
		end
	end

	--修改当前阶段数据
	self.stage = stage
	self.stagedata = stage_data
	self.isflower = stage_data.isflower
	self.isrotten = rotten
	self.ishuge = huge

	--设置动画
	if POPULATING or self.inst:IsAsleep() then
		self.inst.AnimState:PlayAnimation(stage_data.anim, true)
		self.inst.AnimState:SetTime(math.random() * self.inst.AnimState:GetCurrentAnimationLength())
	else
		self.inst.AnimState:PlayAnimation(stage_data.anim_grow)
		self.inst.AnimState:PushAnimation(stage_data.anim, true)
	end

	--设置是否可采摘
	if rotten or stage == self.stage_max then --腐烂、巨型、成熟阶段都是可采摘的
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

	--设置是否可照顾
	if self.inst.components.farmplanttendable ~= nil then
		self.inst.components.farmplanttendable:SetTendable(not self.tended)
	end

	--尝试开始生长
	self:UpdateTimeMult() --更新生长速度
	if self.task_grow == nil then
		self:StartGrowing()
	end

	--额外设置
	if self.fn_stage ~= nil then
		self.fn_stage(self.inst, not self.isrotten and self.stage == self.stage_max) --第二个参数为：是否成熟/巨型成熟
	end
	if self.fn_researchstage ~= nil then
		self.fn_researchstage(self)
	end

	TriggerNutrient(self)
	TriggerMoisture(self)
end
local function AddLoot(loot, name, number)
	if loot[name] == nil then
		loot[name] = number
	else
		loot[name] = loot[name] + number
	end
end
function PerennialCrop:GenerateLoot(doer, ispicked, isburnt) --生成收获物
	local loot = {}
	local lootprefabs = {}
	local pos = self.inst:GetPosition()
	local product = self.product or "cutgrass"
	if self.ishuge then
		if self.isrotten then
			if self.loot_huge_rot ~= nil then
				for _, name in pairs(self.loot_huge_rot) do
					AddLoot(lootprefabs, name, 1)
				end
			else
				AddLoot(lootprefabs, "spoiled_food", 3)
				AddLoot(lootprefabs, "fruitfly", 2)
				AddLoot(lootprefabs, self.seed or "seeds", 1)
			end
			if self.pollinated >= self.pollinated_max then
				AddLoot(lootprefabs, "spoiled_food", 1)
			end
		else
			AddLoot(lootprefabs, self.product_huge or product, 1)
			if self.pollinated >= self.pollinated_max then --授粉成功，提高产量
				AddLoot(lootprefabs, product, 1)
			end
		end
	elseif self.stage < self.stage_max then
		if self.isrotten then
			AddLoot(lootprefabs, "spoiled_food", 1)
		else
			AddLoot(lootprefabs, math.random() < 0.5 and "cutgrass"or "twigs", 1)
			if self.isflower then
				AddLoot(lootprefabs, "petals", 1)
			end
		end
	else
		local numfruit = 1
		if self.num_perfect ~= nil then
			if self.num_perfect >= 5 then
				numfruit = 3
			elseif self.num_perfect >= 3 then
				numfruit = 2
			end
		end
		if self.pollinated >= self.pollinated_max then
			numfruit = numfruit + 1
		end
		AddLoot(lootprefabs, self.isrotten and "spoiled_food" or product, numfruit)
	end

	if not ispicked then --非采集时，多半是破坏
		local soil
		local skin = self.inst.components.skinedlegion:GetSkin()
		if skin == nil then
			soil = SpawnPrefab("siving_soil_item")
		else
			soil = SpawnPrefab("siving_soil_item", skin, nil, LS_C_UserID(self.inst, doer))
		end
		if soil ~= nil then
			soil.Transform:SetPosition(pos:Get())
			soil:PushEvent("on_loot_dropped", { dropper = self.inst })
		end
	end
	if isburnt then
		local lootprefabs2 = {}
		for name, num in pairs(lootprefabs) do
			if TUNING.BURNED_LOOT_OVERRIDES[name] ~= nil then
				AddLoot(lootprefabs2, TUNING.BURNED_LOOT_OVERRIDES[name], num)
			elseif PrefabExists(name.."_cooked") then
				AddLoot(lootprefabs2, name.."_cooked", num)
			elseif PrefabExists("cooked"..name) then
				AddLoot(lootprefabs2, "cooked"..name, num)
			else
				AddLoot(lootprefabs2, "ash", num)
			end
		end
		lootprefabs = lootprefabs2
	end

	for name, num in pairs(lootprefabs) do --生成实体并设置物理掉落
		if num > 0 then
			TOOLS_L.SpawnStackDrop(name, num, pos, nil, loot, { dropper = self.inst })
		end
	end
	if ispicked then
		-- if self.fn_pick ~= nil then
		-- 	self.fn_pick(self, doer, loot)
		-- end
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

function PerennialCrop:OnSave()
    local data = {
        moisture = self.moisture > 0 and self.moisture or nil,
        nutrient = self.nutrient > 0 and self.nutrient or nil,
		nutrientgrow = self.nutrientgrow > 0 and self.nutrientgrow or nil,
        nutrientsick = self.nutrientsick > 0 and self.nutrientsick or nil,
		sickness = self.sickness > 0 and self.sickness or nil,
		stage = self.stage ~= 1 and self.stage or nil,
		isrotten = self.isrotten or nil,
		ishuge = self.ishuge or nil,
		infested = self.infested > 0 and self.infested or nil,
		pollinated = self.pollinated > 0 and self.pollinated or nil,
		num_nutrient = self.num_nutrient > 0 and self.num_nutrient or nil,
		num_moisture = self.num_moisture > 0 and self.num_moisture or nil,
		num_tended = self.num_tended > 0 and self.num_tended or nil,
		num_perfect = self.num_perfect ~= nil and self.num_perfect or nil,
		tended = self.tended or nil,
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
function PerennialCrop:OnLoad(data)
    if data == nil then
        return
    end
	self.moisture = data.moisture or 0
	self.nutrient = data.nutrient or 0
	self.nutrientgrow = data.nutrientgrow or 0
	self.nutrientsick = data.nutrientsick or 0
	self.sickness = data.sickness or 0
	self.stage = data.stage or 1
	self.isrotten = data.isrotten and true or false
	self.ishuge = data.ishuge and true or false
	self.infested = data.infested or 0
	self.pollinated = data.pollinated or 0
	self.num_nutrient = data.num_nutrient or 0
	self.num_moisture = data.num_moisture or 0
	self.num_tended = data.num_tended or 0
	self.num_perfect = data.num_perfect or nil
	self.tended = data.tended and true or false
	self:SetStage(self.stage, self.ishuge, self.isrotten)
	if data.time_dt ~= nil and data.time_dt > 0 then
		self.time_grow = data.time_dt
	end
end

function PerennialCrop:Pollinate(doer, value) --授粉
    if self.isrotten or self.stage == self.stage_max or self.pollinated >= self.pollinated_max then
		return
	end
	self.pollinated = self.pollinated + (value or 1)
end

function PerennialCrop:Infest(doer, value) --侵扰
	if self.isrotten then
		return false
	end

	self.infested = self.infested + (value or 1)
	if self.infested >= self.infested_max then
		self.infested = 0
		self:StopGrowing() --先清除生长进度
		self:SetStage(self.stage, self.ishuge, true) --再设置枯萎
	end

	return true
end
function PerennialCrop:Cure(doer) --治疗
	self.infested = 0
	self.sickness = 0
end

function PerennialCrop:Tendable(doer, wish) --是否能照顾
	if self.isrotten or self.stage == self.stage_max then
		return false
	end

	if wish == nil or wish then --希望是照顾
		return not self.tended
	else --希望是取消照顾
		return self.tended
	end
end
function PerennialCrop:TendTo(doer, wish) --照顾
	if not self:Tendable(doer, wish) then
		return false
	end

	if wish == nil or wish then --希望是照顾
		self.num_tended = self.num_tended + 1
		self.tended = true
	else --希望是取消照顾
		self.num_tended = self.num_tended - 1
		self.tended = false
	end
	if self.inst.components.farmplanttendable ~= nil then
		self.inst.components.farmplanttendable:SetTendable(not self.tended)
	end
	if not self.inst:IsAsleep() then
		local tended = self.tended --记下此时状态，因为0.5秒后状态可能已经发生改变
		self.inst:DoTaskInTime(0.5 + math.random()*0.5, function()
			local fx = SpawnPrefab(tended and "farm_plant_happy" or "farm_plant_unhappy")
			if fx ~= nil then
				fx.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
			end
		end)
	end

	return true
end
function PerennialCrop:Fertilize(item, doer) --施肥
	if item.components.fertilizer ~= nil and item.components.fertilizer.nutrients ~= nil then
		local nutrients = item.components.fertilizer.nutrients
		local isdone = false

		--1号肥：加速生长
		if nutrients[1] ~= nil and nutrients[1] > 0 and self.nutrientgrow < self.nutrientgrow_max then
			self.nutrientgrow = math.min(self.nutrientgrow_max, self.nutrientgrow+nutrients[1])
			isdone = true
		end
		--2号肥：预防疾病
		if nutrients[2] ~= nil and nutrients[2] > 0 and self.nutrientsick < self.nutrientsick_max then
			self.nutrientsick = math.min(self.nutrientsick_max, self.nutrientsick+nutrients[2])
			isdone = true
		end
		--3号肥：生长必需
		if nutrients[3] ~= nil and nutrients[3] > 0 and self.nutrient < self.nutrient_max then
			self.nutrient = math.min(self.nutrient_max, self.nutrient+nutrients[3])
			isdone = true
		end

		if isdone then
			if self.inst.components.burnable ~= nil then --快着火时能阻止着火
				self.inst.components.burnable:StopSmoldering()
			end
			if item.components.fertilizer.fertilize_sound ~= nil then
				self.inst.SoundEmitter:PlaySound(item.components.fertilizer.fertilize_sound)
			end
			self:UpdateTimeMult()
			TriggerNutrient(self)
			return true
		end
	end
	return false
end
function PerennialCrop:PourWater(item, doer, value) --浇水
	if self.moisture < self.moisture_max then
		self.moisture = math.min(self.moisture_max, self.moisture+(value or 6))
		TriggerMoisture(self)
	end
end

function PerennialCrop:DoMagicGrowth(doer, dt) --催熟
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
		self:TimePassed(dt, self.inst:IsAsleep())
	end
	return true
end

function PerennialCrop:DisplayCrop(oldcrop, doer) --替换作物：把它的养料占为己有
	local oldcpt = oldcrop.components.perennialcrop

	self.nutrientgrow = math.min(self.nutrientgrow_max, self.nutrientgrow+oldcpt.nutrientgrow)
	self.nutrientsick = math.min(self.nutrientsick_max, self.nutrientsick+oldcpt.nutrientsick)
	self.nutrient = math.min(self.nutrient_max, self.nutrient+oldcpt.nutrient)
	TriggerNutrient(self)
	self:PourWater(nil, nil, oldcpt.moisture)

	oldcpt:GenerateLoot(nil, true, false)
	if oldcpt.fn_defend ~= nil and doer then
		oldcpt.fn_defend(oldcrop, doer)
	end

	local x, y, z = oldcrop.Transform:GetWorldPosition()
	SpawnPrefab("dirt_puff").Transform:SetPosition(x, y, z)
end

return PerennialCrop
