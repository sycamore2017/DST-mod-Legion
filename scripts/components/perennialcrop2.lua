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

	self.cropprefab = "corn"
	self.stage_max = 2 --最大生长阶段
	self.growthmults = nil --四个季节的生长速度
	self.leveldata = nil --该植物生长有几个阶段，每个阶段的动画,以及是否处在花期
	self.maturedanim = nil --成熟后的几个动画，根据果子数量决定下标
	self.regrowstage = 1 --采摘后重新开始生长的阶段（枯萎后采摘毕竟从第一阶段开始）

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

	self.numfruit = nil --果实数量
	self.pollinated = 0 --被授粉次数
	self.infested = 0 --被骚扰次数

	self.cluster = 0 --簇栽等级
	self.cluster_max = 80 --最大簇栽等级
	self.cluster_size = { 0.6, 3 } --体型变化范围

	self.taskgrow = nil
	self.timedata = {
		start = nil, --开始进行生长的时间点
		left = nil, --剩余生长时间（不包括生长系数）
		paused = false, --是否暂停生长
		mult = nil, --当前生长时间系数
		all = nil, --到下一个阶段的全局时间（不包括缩减或增加的时间）
	}

	self.ctls = {}
	self.onctlchange = nil

	self.fn_overripe = nil --过熟时触发：fn(inst, numloot)
	self.fn_loot = nil --获取收获物时触发：fn(inst, loot)
	self.fn_stage = nil --每次设定生长阶段时额外触发的函数：fn(inst, isfull)
	self.fn_defend = nil --作物被采集/破坏时会寻求庇护的函数：fn(inst, target)
end,
nil,
{
    isflower = onflower,
	isrotten = onrotten,
	donemoisture = onmoisture,
	donenutrient = onnutrient,
	cluster = oncluster
})

local function OnPicked(inst, doer, loot)
	local crop = inst.components.perennialcrop2
	crop:GenerateLoot(doer, 1)
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

function PerennialCrop2:DebugString()
	local test = self.taskgrow == nil and "no_task,阶段" or "ye_task,阶段"
	test = test..tostring(self.stage)..",start"..tostring(self.timedata.start)..",left"..tostring(self.timedata.left)
		..",paused"..tostring(self.timedata.paused)..",mult"..tostring(self.timedata.mult)
		..",all"..tostring(self.timedata.all)
	print(test)
end

function PerennialCrop2:SetUp(cropprefab, data)
	self.cropprefab = cropprefab
	self.stage_max = #data.leveldata
	self.leveldata = data.leveldata
	self.growthmults = data.growthmults or { [1] = 1, [2] = 1, [3] = 1, [4] = 0 }
	self.regrowstage = data.regrowstage or 1
	self.maturedanim = data.maturedanim
	self.cangrowindrak = data.cangrowindrak == true
	self.fn_overripe = data.fn_overripe
	self.fn_loot = data.fn_loot
	self.fn_stage = data.fn_stage

	if data.cluster_max then
		self.cluster_max = data.cluster_max
	end
	if data.cluster_size then
		self.cluster_size = data.cluster_size
	end

	if data.getsickchance and self.getsickchance > 0 then
		self.getsickchance = data.getsickchance
	end
end

function PerennialCrop2:SetStage(stage, isrotten, skip)
	if stage == nil or stage < 1 then
		stage = 1
	elseif stage > self.stage_max then
		stage = self.stage_max
	end

	--确定当前的阶段
	local rotten = false
	local level = nil

	level = self.leveldata[stage]
	if isrotten then
		if level.deadanim == nil then --枯萎了，但是没有枯萎状态，回到第一个阶段
			level = self.leveldata[1]
			stage = 1
		else
			rotten = true
		end
	else
		if stage == self.stage_max then --成熟时
			if self.numfruit == nil or self.numfruit <= 0 then --没有果实，回到再生阶段
				stage = self.regrowstage
				level = self.leveldata[stage]
			end
		end
	end

	--修改当前阶段数据
	self.stage = stage
	self.level = level
	self.isflower = not rotten and level.bloom == true
	self.isrotten = rotten

	if skip then --如果跳过，就不设置接下来的操作
		return
	end

	--设置动画
	if rotten then
		self.inst.AnimState:PlayAnimation(level.deadanim, false)
		self.donemoisture = true --枯萎了，必定不能操作
		self.donenutrient = true
		self.donetendable = true
	elseif stage == self.stage_max and self.maturedanim ~= nil then
		local minnum = #self.maturedanim
		minnum = math.min(minnum, self.numfruit)
		self.inst.AnimState:PlayAnimation(self.maturedanim[minnum], true)
		self.inst.AnimState:SetTime(math.random() * self.inst.AnimState:GetCurrentAnimationLength())
	else
		self.inst.AnimState:PlayAnimation(level.anim, true)
		self.inst.AnimState:SetTime(math.random() * self.inst.AnimState:GetCurrentAnimationLength())
	end

	--设置是否可采摘
	if rotten or stage == self.stage_max then --腐烂、成熟阶段都是可采摘的
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
		self.fn_stage(self.inst, not rotten and stage == self.stage_max) --第二个参数为：是否成熟
	end
end

function PerennialCrop2:GetNextStage()
	local data = {
		stage = 1,
		justgrown = false,
		overripe = false,
		level = nil,
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

function PerennialCrop2:GetGrowTime(time)
	local data = {
		mult = 1,
		time = nil
	}

	if self.isrotten then --枯萎了的话，2天后重生
		data.time = time or (2*TUNING.TOTAL_DAY_TIME)
		return data
	else
		data.time = time or self.level.time
	end
	if self.stage == self.stage_max then --成熟了的话，过熟时间无法进行加成
		return data
	end

	if TheWorld.state.season == "winter" then
		data.mult = self.growthmults[4]
	elseif TheWorld.state.season == "summer" then
		data.mult = self.growthmults[2]
	elseif TheWorld.state.season == "spring" then
		data.mult = self.growthmults[1]
	else --默认为秋，其他mod的特殊季节默认都为秋季
		data.mult = self.growthmults[3]
	end
	if data.mult <= 0 then
		data.mult = 0
		return data
	end

	if self.donemoisture then
		data.mult = data.mult - 0.15
	end
	if self.donenutrient then
		data.mult = data.mult - 0.2
	end
	if self.donetendable then
		data.mult = data.mult - 0.15
	end

	if data.mult <= 0 then --如果不小心数值设置错误导致小于0，这里强制改回有效数值
		data.mult = 0.05
	end

	return data
end

function PerennialCrop2:CostFromLand() --从耕地吸取所需养料、水分
	local x, y, z = self.inst.Transform:GetWorldPosition()
	local tile = TheWorld.Map:GetTileAtPoint(x, 0, z)
	if tile == GROUND.FARMING_SOIL then
		local farmmgr = TheWorld.components.farming_manager
		local tile_x, tile_z = TheWorld.Map:GetTileCoordsAtPoint(x, y, z)
    	local _n1, _n2, _n3 = farmmgr:GetTileNutrients(tile_x, tile_z)

		--加水
		if not self.donemoisture then
			if farmmgr:IsSoilMoistAtPoint(x, y, z) then
				self.donemoisture = true
				farmmgr:AddSoilMoistureAtPoint(x, y, z, -2.5)
			end
		end

		--施肥
		if not self.donenutrient then
			if _n3 > 0 then
				_n3 = -3
				_n2 = 0
				_n1 = 0
			elseif _n2 > 0 then
				_n3 = 0
				_n2 = -3
				_n1 = 0
			elseif _n1 > 0 then
				_n3 = 0
				_n2 = 0
				_n1 = -3
			end
			if _n3 < 0 or _n2 < 0 or _n1 < 0 then
				self.donenutrient = true
				farmmgr:AddTileNutrients(tile_x, tile_z, _n1, _n2, _n3)
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
function PerennialCrop2:DoGrowth(skip)
	local data = self:GetNextStage()

	if data.justgrown or data.overripe then --生长和过熟时都会产生虫群
		if self.getsickchance > 0 and math.random() < self.getsickchance then
			local bugs = SpawnPrefab(math.random()<0.7 and "cropgnat" or "cropgnat_infester")
			if bugs ~= nil then
				bugs.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
			end
		end
	end

	if data.justgrown then
		if data.stage == self.stage_max then --如果成熟了，开始计算果子数量
			local num = self.pollinated >= self.pollinated_max and 2 or 1
			local rand = math.random()
			if rand < 0.5 then --50%几率两个果实
				num = num + 1
			elseif rand < 0.85 then --35%几率三个果实
				num = num + 2
			end
			self.numfruit = num
		end
	elseif data.stage == self.regrowstage or data.stage == 1 then --重新开始生长时，清空某些数据
		--如果过熟了，掉落果子，给周围植物、土地和子圭管理者施肥
		if data.overripe and self.numfruit ~= nil and self.numfruit > 0 then
			local numloot = 0
			local numpoop = 0
			for i = 1, self.numfruit, 1 do
				if math.random() < 0.6 then
					numpoop = numpoop + 1
				else
					numloot = numloot + 1
				end
			end

			if numpoop > 0 then
				for _,ctl in pairs(self.ctls) do
					if ctl and ctl:IsValid() and ctl.components.botanycontroller ~= nil then
						local botanyctl = ctl.components.botanycontroller
						local nutrients = {42,42,42}
						if CanAcceptNutrients(botanyctl, nutrients) then
							for i = 1, numpoop, 1 do
								botanyctl:SetValue(nil, nutrients, true)
								numpoop = numpoop - 1
								if numpoop <= 0 or not CanAcceptNutrients(botanyctl, nutrients) then
									break
								end
							end
						end

						if numpoop <= 0 then
							break
						end
					end
				end

				local x, y, z = self.inst.Transform:GetWorldPosition()
				if numpoop > 0 then
					for i = 1, numpoop, 1 do
						local hastile = false
						for k1 = -4, 4, 4 do --只影响周围半径一格的地皮，但感觉最多可涉及到3格地皮
							for k2 = -4, 4, 4 do
								local tile = TheWorld.Map:GetTileAtPoint(x+k1, 0, z+k2)
								if tile == GROUND.FARMING_SOIL then
									hastile = true
									local tile_x, tile_z = TheWorld.Map:GetTileCoordsAtPoint(x+k1, 0, z+k2)
									TheWorld.components.farming_manager:AddTileNutrients(tile_x, tile_z, 8, 8, 8)
								end
							end
						end
						if hastile then
							numpoop = numpoop - 1
							if numpoop <= 0 then
								break
							end
						else
							break
						end
					end
				end

				if numpoop > 0 then
					for i = 1, numpoop, 1 do
						local hasset = false
						local ents = TheSim:FindEntities(x, y, z, 5,
							nil,
							{ "NOCLICK", "FX", "INLIMBO" },
							{ "crop_legion", "crop2_legion", "withered", "barren" }
						)
						for _,v in pairs(ents) do
							if v:IsValid() then
								local cpt = nil
								if v.components.pickable ~= nil then
									if v.components.pickable:CanBeFertilized() then
										cpt = v.components.pickable
									end
								elseif v.components.perennialcrop ~= nil then
									cpt = v.components.perennialcrop
								elseif v.components.perennialcrop2 ~= nil then
									cpt = v.components.perennialcrop2
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
						end

						if hasset then
							numpoop = numpoop -1
							if numpoop <= 0 then
								break
							end
						else
							break
						end
					end
				end

				if numpoop > 0 then
					for i = 1, numpoop, 1 do
						self.inst.components.lootdropper:SpawnLootPrefab("spoiled_food")
					end
				end
			end

			if self.fn_overripe ~= nil then
				self.fn_overripe(self.inst, numloot)
			elseif numloot > 0 then
				for i = 1, numloot, 1 do
					self.inst.components.lootdropper:SpawnLootPrefab(self.cropprefab)
				end
			end
		end

		self.infested = 0
		self.pollinated = 0
		self.numfruit = nil
	end

	if data.stage == self.stage_max then --成熟了，必定不能操作
		self.donemoisture = true
		self.donenutrient = true
		self.donetendable = true
	else --因为是生长，必定能操作
		self.donemoisture = false
		self.donenutrient = false
		self.donetendable = false
		self:CostNutrition()
	end

	self:SetStage(data.stage, false, skip)
	self:StartGrowing(nil, skip)
end

function PerennialCrop2:StartGrowing(lefttime, skip)
	if self.taskgrow ~= nil then
		self.taskgrow:Cancel()
		self.taskgrow = nil
	end

	local data = self:GetGrowTime()
	if data.time == nil or data.time <= 0 then --永恒阶段
		self.timedata.all = nil
		self.timedata.mult = nil
		self.timedata.start = nil
		self.timedata.paused = false
		self.timedata.left = nil
		return
	else
		if data.mult <= 0 then --生长暂停
			self.timedata.mult = nil
			self.timedata.start = nil
			self.timedata.all = nil
			self.timedata.left = lefttime or data.time
			self.timedata.paused = true
			return
		else
			self.timedata.mult = data.mult
			self.timedata.start = GetTime()
			self.timedata.all = lefttime or data.time
			self.timedata.left = nil
			self.timedata.paused = false
		end
	end

	if not skip and not self.inst:IsAsleep() then
		--实际任务时间是剩余时间*生长系数
		self.taskgrow = self.inst:DoTaskInTime(self.timedata.all*data.mult, function(inst, self)
			self.timedata.all = nil
			self.timedata.mult = nil
			self.timedata.start = nil
			self.timedata.left = nil
			self:DoGrowth(false)
		end, self)
	end

	-- self:DebugString()
end

function PerennialCrop2:LongUpdate(dt, isloop, ismagic)
	if self.timedata.paused or self.timedata.mult == nil then --暂停了、生长停滞、或者是永恒阶段
		return
	end

    if self.timedata.start and self.timedata.all then
		local alltime = self.timedata.all*self.timedata.mult --将时间转化为带mult的
		if dt > alltime then --经过的时间可以让作物长到下一阶段，并且有多余的
			if ismagic and not self.isrotten and (self.stage+1) == self.stage_max then --防止魔法催熟导致过熟
				self:DoGrowth(false)
				return
			end
			self:DoGrowth(true)
			if self.timedata.mult then --生长没有停滞
				self:LongUpdate(dt - alltime, true) --经过这次成长，由于经过时间dt还没完，继续下一次判定
			else
				self:SetStage(self.stage, self.isrotten, false) --由于不再继续生长，把没有改变的动画和可采摘性补上
			end
		elseif dt == alltime then
			self:DoGrowth(false)
		else --经过的时间不足以让作物长到下一个阶段
			self:StartGrowing((alltime - dt)/self.timedata.mult, false)
			if isloop then
				self:SetStage(self.stage, self.isrotten, false) --把没有改变的动画和可采摘性补上
			end
		end
	else
		self:StartGrowing() --数据丢失的话，就只能重新开始了
	end

	-- print("longupdate---------------")
	-- self:DebugString()
end

function PerennialCrop2:OnEntitySleep()
    if self.taskgrow ~= nil then
		self.taskgrow:Cancel()
		self.taskgrow = nil
	end
end

function PerennialCrop2:OnEntityWake()
	--已经暂停的话，继续时会自己刷新的，不需要这里强制刷新
	if self.timedata.paused or self.timedata.mult == nil then --暂停了、生长停滞、或者是永恒阶段
		return
	end

    if self.timedata.start ~= nil then
		--把目前已经经过的时间归入生长中去
		local dt = GetTime() - self.timedata.start
		if dt >= 0 then
			self:OnEntitySleep()
			self:LongUpdate(dt, false)
			return
		end
	end
	self:StartGrowing() --数据丢失的话，就只能重新开始了
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
    }

	if self.timedata.paused then
		data.time_paused = true
		data.time_left = self.timedata.left
	elseif self.timedata.start ~= nil and self.timedata.all ~= nil then
		data.time_all = self.timedata.all
		data.time_mult = self.timedata.mult
		data.time_dt = GetTime() - self.timedata.start
	end

    return data
end

function PerennialCrop2:OnLoad(data)
    if data == nil then
        return
    end

	self.donemoisture = data.donemoisture ~= nil
	self.donenutrient = data.donenutrient ~= nil
	self.donetendable = data.donetendable ~= nil
	if data.stage ~= nil then
		self.stage = data.stage
	end
	self.isrotten = data.isrotten ~= nil
	self.numfruit = data.numfruit
	self.pollinated = data.pollinated or 0
	self.infested = data.infested or 0

	self:SetStage(self.stage, self.isrotten, false)
	self:OnEntitySleep() --把task取消，根据情况继续
	if data.time_paused and data.time_left ~= nil then
		self.timedata.paused = true
		self.timedata.left = data.time_left
		self.timedata.start = nil
		self.timedata.all = nil
		self.timedata.mult = nil
	elseif data.time_dt ~= nil and data.time_all ~= nil then
		self.timedata.paused = false
		self.timedata.left = nil
		self.timedata.start = GetTime()
		self.timedata.all = data.time_all
		self.timedata.mult = data.time_mult or 1
		self:LongUpdate(data.time_dt, false)
	else
		self:StartGrowing() --数据丢失的话，就只能重新开始了
	end
end

function PerennialCrop2:Pause()
	if self.timedata.paused or self.timedata.mult == nil then --暂停了、生长停滞、或者是永恒阶段
		return
	end

	self:OnEntityWake() --先更新已生长的数据
	self:OnEntitySleep()
	self.timedata.paused = true
	self.timedata.left = self.timedata.all --更新数据后，self.timedata.all就是当前剩余时间，所以不必再判断
	self.timedata.start = nil
	self.timedata.all = nil
	-- self.timedata.mult = nil
end

function PerennialCrop2:Resume()
    if not self.timedata.paused or self.timedata.left == nil then --没有暂停，或没有暂停后的必要数据
		return
	end

	self:StartGrowing(self.timedata.left)
end

function PerennialCrop2:CanGrowInDark()
	--枯萎、成熟时，在黑暗中也要计算时间了
	return self.isrotten or self.stage == self.stage_max or self.cangrowindrak
end

function PerennialCrop2:GenerateLoot(doer, gettype) --生成收获物
	local loot = {}
	local pos = self.inst:GetPosition()

	--先生成物品，然后直接开始丢弃

	if gettype == 1 and doer and doer.components.inventory ~= nil then
		for i, item in ipairs(loot) do
			if item.components.inventoryitem ~= nil then
				doer.components.inventoryitem:GiveItem(item, nil, pos)
			end
		end
	end
end

function PerennialCrop2:Pollinate(doer, value) --授粉
    if self.isrotten or self.stage == self.stage_max or self.pollinated >= self.pollinated_max then
		return
	end
	self.pollinated = self.pollinated + (value or 1)
end

function PerennialCrop2:Infest(doer, value) --侵害
	if self.isrotten then
		return false
	end

	self.infested = self.infested + (value or 1)
	if self.infested >= self.infested_max then
		self.infested = 0
		self:SetStage(self.stage, true, false)
		self:StartGrowing() --开始枯萎计时
	end

	return true
end

function PerennialCrop2:Cure(doer) --治疗
	self.infested = 0
end

function PerennialCrop2:Tendable(doer, wish) --是否能照顾
	if self.isrotten or self.stage == self.stage_max then
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

	if wish == nil or wish then --希望是照顾
		self.donetendable = true
	else --希望是取消照顾
		self.donetendable = false
	end
	if self.inst.components.farmplanttendable ~= nil then
		self.inst.components.farmplanttendable:SetTendable(not self.donetendable)
	end
	if not self.inst:IsAsleep() then
		local tended = self.donetendable --记下此时状态，因为0.5秒后状态可能已经发生改变
		self.inst:DoTaskInTime(0.5 + math.random() * 0.5, function()
			local fx = SpawnPrefab(tended and "farm_plant_happy" or "farm_plant_unhappy")
			if fx ~= nil then
				fx.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
			end
		end)
	end

	self:OnEntityWake() --更新生长时间

	return true
end

function PerennialCrop2:DoMagicGrowth(doer, dt) --催熟
	--着火时无法被催熟
	if self.inst.components.burnable ~= nil and self.inst.components.burnable:IsBurning() then
		return false
	end

	--暂停生长时无法被催熟
	if self.timedata.paused or self.timedata.mult == nil then
		return false
	end

	--成熟状态是无法被催熟的（枯萎时可以催熟）
	if not self.isrotten and self.stage == self.stage_max then
		return true
	end

	if dt == nil then
		self:DoGrowth(false)
	else
		self:OnEntitySleep()
		self:LongUpdate(dt, false, true)
	end
	return true
end

function PerennialCrop2:Fertilize(item, doer) --施肥
	if self.isrotten or self.donenutrient or self.stage == self.stage_max then
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
		self:OnEntityWake() --更新生长时间

		return true
	end

	return false
end

function PerennialCrop2:PourWater(item, doer, value) --浇水
	if self.isrotten or self.donemoisture or self.stage == self.stage_max then
		return false
	end

	self.donemoisture = true
	self:OnEntityWake() --更新生长时间

	return true
end

function PerennialCrop2:CostController()
	-- if self.isrotten or self.stage == self.stage_max then
	-- 	return
	-- end
	if self.donemoisture and self.donenutrient and self.donetendable then
		return
	end

	for _,ctl in pairs(self.ctls) do
		if ctl and ctl:IsValid() and ctl.components.botanycontroller ~= nil then
			local botanyctl = ctl.components.botanycontroller
			local change = false
			if not self.donemoisture and (botanyctl.type == 1 or botanyctl.type == 3) and botanyctl.moisture > 0 then
				botanyctl.moisture = math.max(botanyctl.moisture - 2.5, 0)
				self.donemoisture = true
				change = true
			end

			if not self.donenutrient and (botanyctl.type == 2 or botanyctl.type == 3) then
				if botanyctl.nutrients[3] > 0 then
					botanyctl.nutrients[3] = math.max(botanyctl.nutrients[3] - 3, 0)
					self.donenutrient = true
					change = true
				elseif botanyctl.nutrients[2] > 0 then
					botanyctl.nutrients[2] = math.max(botanyctl.nutrients[2] - 3, 0)
					self.donenutrient = true
					change = true
				elseif botanyctl.nutrients[1] > 0 then
					botanyctl.nutrients[1] = math.max(botanyctl.nutrients[1] - 3, 0)
					self.donenutrient = true
					change = true
				end
			end

			if not self.donetendable and botanyctl.type == 3 then
				self.donetendable = true
				-- change = true --这种不算消耗的
				if not self.inst:IsAsleep() then
					self.inst:DoTaskInTime(0.5 + math.random() * 0.5, function()
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

function PerennialCrop2:TriggerController(ctl, isadd, noupdate)
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

function PerennialCrop2:DisplayCrop(oldcrop, doer) --替换作物：把它的养料占为己有
	local oldcpt = oldcrop.components.perennialcrop2

	if oldcpt.donemoisture then
		self.donemoisture = true
	end
	if oldcpt.donenutrient then
		self.donenutrient = true
	end

	oldcrop.components.lootdropper:SpawnLootPrefab("seeds_"..oldcpt.cropprefab.."_l")
	oldcrop.components.lootdropper:DropLoot()

	if oldcpt.fn_defend ~= nil and doer then
		oldcpt.fn_defend(oldcrop, doer)
	end
	local x, y, z = oldcrop.Transform:GetWorldPosition()
	SpawnPrefab("dirt_puff").Transform:SetPosition(x, y, z)
end

return PerennialCrop2
