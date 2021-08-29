local function onflower(self)
    if self.isflower then
        self.inst:AddTag("flower")
    else
        self.inst:RemoveTag("flower")
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
	self.infested = 0 --被骚扰次数
	self.taskgrow = nil
	self.timedata = {
		start = nil, --开始进行生长的时间点
		all = nil, --到下一个阶段的全局时间（包含缩减与增加的时间）
	}
	self.pollinated = 0 --被授粉次数
	self.num_nutrient = 0 --吸收肥料次数
	self.num_moisture = 0 --吸收水分次数
	self.num_tended = 0 --被照顾次数
	self.num_perfect = nil --成熟时结算出的：完美指数（决定果实数量或者是否巨型）

	self.moisture_max = 16 --最大蓄水量
	self.nutrient_max = 16 --最大蓄肥量（生长必需）
	self.nutrientgrow_max = 16 --最大蓄肥量（生长加速）
	self.nutrientsick_max = 16 --最大蓄肥量（预防疾病）
	self.stage_max = 2 --最大生长阶段
	self.pollinated_max = 6 --被授粉次数大于等于该值就能增加产量
	self.infested_max = 10 --被骚扰次数大于等于该值就会立即进入腐烂/枯萎阶段

	self.weights = nil --重量范围
	self.sounds = {} --音效
	self.cost_moisture = 1 --需水量
	self.cost_nutrient = 1 --需肥类型(这里只需要一个量即可，不需要关注肥料类型)
	self.can_getsick = true --是否能产生病虫害（原创）
	self.stages = nil --该植物生长有几个阶段，每个阶段的动画,以及是否处在花期（原创）
	self.stages_other = nil --巨大化阶段、巨大化枯萎、枯萎等阶段的数据
	self.regrowstage = 1 --枯萎或者采摘后重新开始生长的阶段（原创）
	self.goodseasons = {} --喜好季节：{autumn = true, winter = true, spring = true, summer = true}
	self.killjoystolerance = 0 --扫兴容忍度：一般都为0
end,
nil,
{
    isflower = onflower,
})

function PerennialCrop:SetUp(data)
	self.weights = data.weights
	self.sounds = data.sounds or {}
	self.cost_moisture = data.costMoisture or 1
	self.cost_nutrient = data.costNutrient or 1
	self.can_getsick = data.canGetSick
	self.stages = data.stages
	self.stages_other = data.stages_other
	self.regrowstage = data.regrowStage or 1
	self.goodseasons = data.goodSeasons or {}
	self.killjoystolerance = data.killjoysTolerance or 0

	self.stage_max = #data.stages
end

function PerennialCrop:SetStage(stage, ishuge, isrotten, pushanim, skip)
	if stage == nil or stage < 1 then
		stage = 1
	elseif stage > self.stage_max then
		stage = self.stage_max
	end

	--确定当前的阶段
	local rotten = false
	local huge = false
	local stage_data = nil
	local soundkey = nil
	local tendable = false

	if isrotten then
		if ishuge then
			if self.stages_other.huge_rot ~= nil then --腐烂、巨型状态
				stage = self.stage_max
				stage_data = self.stages_other.huge_rot
				rotten = true
				huge = true
			end
		end

		if stage_data == nil then
			if self.stages_other.rot ~= nil then --腐烂状态
				stage_data = self.stages_other.rot
				rotten = true
			else --如果没有腐烂状态就进入重新生长的阶段
				stage = self.regrowstage
				stage_data = self.stages[stage]
				tendable = true
			end
		end
		soundkey = "grow_rot"
	elseif ishuge then
		stage = self.stage_max
		if self.stages_other.huge ~= nil then --巨型状态
			stage_data = self.stages_other.huge
			huge = true
			soundkey = "grow_oversized"
		else --如果没有巨型状态就进入成熟阶段
			stage_data = self.stages[stage]
			soundkey = "grow_full"
		end
	else
		stage_data = self.stages[stage]
		if stage == self.stage_max then
			soundkey = "grow_full"
		else
			tendable = true
		end
	end

	--修改当前阶段数据
	self.stage = stage
	self.stagedata = stage_data
	self.isflower = stage_data.isflower
	self.isrotten = rotten
	self.ishuge = huge

	if skip then --如果跳过，就不设置动画和是否可采摘
		return
	end

	--设置动画与声音
	if POPULATING or self.inst:IsAsleep() or not pushanim then
		self.inst.AnimState:PlayAnimation(stage_data.anim, true)
		self.inst.AnimState:SetTime(math.random() * self.inst.AnimState:GetCurrentAnimationLength())
	else
		self.inst.AnimState:PlayAnimation(stage_data.anim_grow)
		self.inst.AnimState:PushAnimation(stage_data.anim, true)

		if soundkey ~= nil and self.sounds[soundkey] ~= nil then
			self.inst.SoundEmitter:PlaySound(self.sounds[soundkey])
		end
	end

	--设置是否可采摘
	if rotten or stage == self.stage_max then --腐烂、巨型、成熟阶段都是可采摘的
		if self.inst.components.pickable == nil then
            self.inst:AddComponent("pickable")
            -- self.inst.components.pickable.onpickedfn = OnPicked
        end
	    self.inst.components.pickable:SetUp(nil)
		self.inst.components.pickable.use_lootdropper_for_product = true
		self.inst.components.pickable.picksound = rotten and "dontstarve/wilson/harvest_berries" or "dontstarve/wilson/pickup_plants"
	else
		self.inst:RemoveComponent("pickable")
	end

	--设置是否可照顾
	if self.inst.components.farmplanttendable ~= nil then
		self.inst.components.farmplanttendable:SetTendable(tendable)
	end
end

function PerennialCrop:GetNextStage()
	local data = {
		stage = 1,
		ishuge = false,
		isrotten = false,
		justgrown = false,
		stagedata = nil,
	}
	if self.isrotten then --枯萎阶段->重生阶段
		data.stage = self.regrowstage
		data.stagedata = self.stages[data.stage]
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

function PerennialCrop:GetGrowTime(time)
	if time == nil then
		time = self.stagedata.time or 60
	end

	return time * (
		(TheWorld.state.season == "winter" and 1.4 or 1) --冬季的减速
		- (
			self.stage ~= self.stage_max and ( --没成熟时才应用加速效果
				(self.nutrientgrow > 0 and 1/7 or 0) --肥料的加速
				+ (self.goodseasons[TheWorld.state.season] and 1/7 or 0) --季节的加速
			) or 0
		)
	)
end

function PerennialCrop:DoGrowth(skip)
	local data = self:GetNextStage()

	if data.justgrown then
		if self.nutrient >= self.cost_nutrient then --生长必需肥料的积累
			self.nutrient = self.nutrient - self.cost_nutrient
			self.num_nutrient = self.num_nutrient + 1
			self.infested = math.max(0, self.infested-4)
		end
		if self.nutrientgrow >= self.cost_nutrient then --加速生长肥料的消耗
			self.nutrientgrow = self.nutrientgrow - self.cost_nutrient
		end
		if self.can_getsick then
			if self.nutrientsick >= self.cost_nutrient then --预防疾病肥料的消耗
				self.nutrientsick = self.nutrientsick - self.cost_nutrient
				self.sickness = math.max(0, self.sickness-0.06)
			else
				self.sickness = math.min(1, self.sickness+0.02)
				if math.random() < self.sickness then
					--undo：产生虫群
				end
			end
		else
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
			end

			--结算完成，清空某些数据
			self.num_nutrient = 0
			self.num_moisture = 0
			self.num_tended = 0
		end
	elseif data.stage == self.regrowstage then --重新开始生长时，清空某些数据
		self.infested = 0
		self.pollinated = 0
		self.num_perfect = nil
	end

	if skip then
		self:SetStage(data.stage, data.ishuge, data.isrotten, false, true)
	else
		self:SetStage(data.stage, data.ishuge, data.isrotten, true, false)
		self:StartGrowing()
	end
end

function PerennialCrop:StartGrowing(time)
	self.timedata.start = GetTime()
	self.timedata.all = time or self:GetGrowTime()

	if self.taskgrow ~= nil then
		self.taskgrow:Cancel()
		self.taskgrow = nil
	end
	if not self.inst:IsAsleep() then
		self.taskgrow = self.inst:DoTaskInTime(self.timedata.all, function(inst, self)
			self.taskgrow = nil
			self.timedata.start = nil
			self.timedata.all = nil
			self:DoGrowth(false)
		end, self)
	end
end

function PerennialCrop:LongUpdate(dt, isloop)
    if self.timedata.start ~= nil and self.timedata.all ~= nil then
		if dt > self.timedata.all then --经过的时间可以让作物长到下一阶段，并且有多余的
			dt = dt - self.timedata.all
			self:DoGrowth(true)
			self.timedata.start = GetTime()
			self.timedata.all = self:GetGrowTime()
			self:LongUpdate(dt, true) --经过这次成长，由于经过时间dt还没完，继续下一次判定
		elseif dt == self.timedata.all then
			self:DoGrowth(false)
		else --经过的时间不足以让作物长到下一个阶段
			self:StartGrowing(self.timedata.all - dt)
			if isloop then
				--把没有改变的动画和可采摘性补上
				self:SetStage(self.stage, self.ishuge, self.isrotten, true, false)
			end
		end
	end
end

function PerennialCrop:OnEntitySleep()
    if self.taskgrow ~= nil then
		self.taskgrow:Cancel()
		self.taskgrow = nil
	end
end

function PerennialCrop:OnEntityWake()
    if self.timedata.start ~= nil and self.timedata.all ~= nil then
		--把目前已经经过的时间归入生长中去
		local dt = GetTime() - self.timedata.start
		if dt >= 0 then
			self:LongUpdate(dt, false)
		end
	end
end

function PerennialCrop:OnSave()
    local data =
    {
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
    }

	if self.timedata.start ~= nil and self.timedata.all ~= nil then
		data.time_all = self.timedata.all
		data.time_dt = GetTime() - self.timedata.start
	end

    return next(data) ~= nil and data or nil
end

function PerennialCrop:OnLoad(data)
    if data == nil then
        return
    end

	self.moisture = data.moisture ~= nil and data.moisture or 0
	self.nutrient = data.nutrient ~= nil and data.nutrient or 0
	self.nutrientgrow = data.nutrientgrow ~= nil and data.nutrientgrow or 0
	self.nutrientsick = data.nutrientsick ~= nil and data.nutrientsick or 0
	self.sickness = data.sickness ~= nil and data.sickness or 0
	self.stage = data.stage ~= nil and data.stage or 1
	self.isrotten = data.isrotten and true or false
	self.ishuge = data.ishuge and true or false
	self.infested = data.infested ~= nil and data.infested or 0
	self.pollinated = data.pollinated ~= nil and data.pollinated or 0
	self.num_nutrient = data.num_nutrient ~= nil and data.num_nutrient or 0
	self.num_moisture = data.num_moisture ~= nil and data.num_moisture or 0
	self.num_tended = data.num_tended ~= nil and data.num_tended or 0
	self.num_perfect = data.num_perfect ~= nil and data.num_perfect or nil

	self:SetStage(self.stage, self.ishuge, self.isrotten, false, false)
	if data.time_dt ~= nil and data.time_all ~= nil then
		self.timedata.start = GetTime()
		self.timedata.all = data.time_all
		self:LongUpdate(data.time_dt, false)
	else
		self:StartGrowing()
	end
end

function PerennialCrop:OnRemoveFromEntity()
    self.inst:RemoveTag("flower")
    if self.taskgrow ~= nil then
		self.taskgrow:Cancel()
		self.taskgrow = nil
	end
end

function PerennialCrop:Pollinate(doer)
    if self.isrotten or self.stage == self.stage_max or self.pollinated >= self.pollinated_max then
		return
	end
	self.pollinated = self.pollinated + 1
end

function PerennialCrop:TendTo(doer)
	self.num_tended = self.num_tended + 1
end

return PerennialCrop
