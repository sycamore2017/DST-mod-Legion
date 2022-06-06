local GeneTrans = Class(function(self, inst)
	self.inst = inst

	self.energytime = TUNING.TOTAL_DAY_TIME*10 --当前能量时间
	self.energytime_max = self.energytime --最大能量时间

	self.seed = nil --播下的种子的实体
	self.fruit = nil --转化完成的prefab名
	self.taskgrow = nil
	self.timedata = {
		start = nil, --当前task开始的时间点
		pass = nil, --已经生长的时间
		all = nil, --总体生长时间
	}

	self.fxdata = {
		prefab = "siving_turn_fruit", symbol = "followed", x = 0, y = 0, z = 0
	}
	self.fx = nil
end)

local function SetSeedAnim(self)
	local percent = 1
	if self.timedata.all ~= nil and self.timedata.pass ~= nil then
		percent = math.min(1, self.timedata.pass/self.timedata.all)
	end
	if percent >= 1 then
		self.fx.AnimState:PlayAnimation(self.energytime <= 0 and "fruit_max" or "fruit_max_on", false)
	else --无语子，动画末尾的呈现状态总是不对，缺了最后一块，怎么调都不行，只能单独做个满的动画
		self.fx.AnimState:SetPercent(self.energytime <= 0 and "fruit" or "fruit_on", percent)
	end
end
local function SetLight(self, islight)
	if islight then
		self.inst.Light:Enable(true)
		self.inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
		-- if self.fx ~= nil then --太亮了，还是别弄这个
		-- 	self.fx.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
		-- end
	else
		self.inst.Light:Enable(false)
		self.inst.AnimState:ClearBloomEffectHandle()
		-- if self.fx ~= nil then
		-- 	self.fx.AnimState:ClearBloomEffectHandle()
		-- end
	end
end

function GeneTrans:SetUp(seeds, doer, isinit)
	if not isinit then --初始化时，以下条件不能做限制
		if self.fruit ~= nil then --已经转化完成
			return false, "DONE"
		end
		if self.seed ~= nil then --已经播种了
			return false, "GROWING"
		end
		if self.energytime <= 0 then --没能量了
			return false, "ENERGYOUT"
		end
		if TRANS_DATA_LEGION[seeds.prefab] == nil then --不能转化
			return false, "WRONGITEM"
		end
	end

	local trans = TRANS_DATA_LEGION[seeds.prefab]

	--设置本体的动画
	if self.energytime > 0 then
		if isinit then
			self.inst.AnimState:PlayAnimation("on", true)
		else
			self.inst.AnimState:PlayAnimation("idle_to_on")
			self.inst.AnimState:PushAnimation("on", true)
		end
	else
		self.inst.AnimState:PlayAnimation("idle", false)
	end

	--设置果实的动画
	if self.fx == nil or not self.fx:IsValid() then
		self.fx = SpawnPrefab(self.fxdata.prefab)
		self.fx.entity:SetParent(self.inst.entity)
		self.fx.entity:AddFollower()
		self.fx.Follower:FollowSymbol(
			self.inst.GUID, self.fxdata.symbol, --TIP: 跟随通道时，默认跟随通道文件夹里ID=0的
			self.fxdata.x, self.fxdata.y, self.fxdata.z
		)
	end
	self.fx.AnimState:OverrideSymbol("swap", trans.swap.build, trans.swap.file)
	if trans.swap.symboltype == "3" then
		self.fx.AnimState:Show("SWAPFRUIT-3")
		self.fx.AnimState:Hide("SWAPFRUIT-2")
		self.fx.AnimState:Hide("SWAPFRUIT-1")
	elseif trans.swap.symboltype == "2" then
		self.fx.AnimState:Hide("SWAPFRUIT-3")
		self.fx.AnimState:Show("SWAPFRUIT-2")
		self.fx.AnimState:Hide("SWAPFRUIT-1")
	else
		self.fx.AnimState:Hide("SWAPFRUIT-3")
		self.fx.AnimState:Hide("SWAPFRUIT-2")
		self.fx.AnimState:Show("SWAPFRUIT-1")
	end

	--undo 声音
	-- inst.SoundEmitter:PlaySound("dontstarve/halloween_2018/madscience_machine/idle_LP", "loop")

	--将种子保存起来
	local seed = nil
	if doer ~= nil then
		seed = doer.components.inventory:RemoveItem(seeds)
	elseif seeds.components.stackable ~= nil and seeds.components.stackable:IsStack() then
		seed = seeds.components.stackable:Get()
	else
		seed = seeds
	end
	self.seed = seed
    self.inst:AddChild(seed)
    seed:RemoveFromScene()
    seed.Transform:SetPosition(0,0,0)
	if seed.components.perishable ~= nil then --永久保鲜
        seed.components.perishable:StopPerishing()
	end

	--开始基因转化
	self.timedata.all = trans.time or (0.5*TUNING.TOTAL_DAY_TIME)
	self:StartTransing()
	SetSeedAnim(self)
	if self.energytime > 0 then
		SetLight(self, true)
	end

    return true
end

function GeneTrans:CostEnergy(cost)
	local old = self.energytime
	cost = old - cost
	if cost <= 0 then
		self.energytime = 0
		if self.taskgrow ~= nil then
			self.taskgrow:Cancel()
			self.taskgrow = nil
		end
		self.timedata.start = nil
	else
		if cost >= self.energytime_max then
			self.energytime = self.energytime_max
		else
			self.energytime = cost
		end
	end

	if self.energytime <= 0 then --没有能量
		SetLight(self, false)
		if old > 0 and (self.seed ~= nil or self.fruit ~= nil) then
			self.inst.AnimState:PlayAnimation("on_to_idle")
			self.inst.AnimState:PushAnimation("idle", false)
		elseif not self.inst.AnimState:IsCurrentAnimation("on_to_idle") then
			self.inst.AnimState:PlayAnimation("idle", false)
		end
	else
		if self.seed ~= nil or self.fruit ~= nil then
			SetLight(self, true)
			if old <= 0 then
				self.inst.AnimState:PlayAnimation("idle_to_on")
				self.inst.AnimState:PushAnimation("on", true)
			elseif not (self.inst.AnimState:IsCurrentAnimation("on") or self.inst.AnimState:IsCurrentAnimation("idle_to_on")) then
				self.inst.AnimState:PlayAnimation("on", true)
			end
		else
			SetLight(self, false)
			self.inst.AnimState:PlayAnimation("idle", false)
		end
	end
end

function GeneTrans:Done()
	if self.fruit ~= nil then
		return
	end

	local trans = TRANS_DATA_LEGION[self.seed.prefab]

	self.timedata.start = nil
	self.timedata.pass = nil
	self.timedata.all = nil
	if self.taskgrow ~= nil then
		self.taskgrow:Cancel()
		self.taskgrow = nil
	end

	self.fruit = trans.fruit or "siving_rocks"
	self.seed:Remove()
	self.seed = nil
	if self.fx ~= nil then
		SetSeedAnim(self)
	end

	self:TriggerPickable(true)
end

function GeneTrans:TriggerPickable(can)
    if can then
		if self.inst.components.pickable == nil then
			self.inst:AddComponent("pickable")
		end
		self.inst.components.pickable.onpickedfn = function(inst, doer)
			local cpt = inst.components.genetrans
			cpt:TriggerPickable(false)
			cpt.fruit = nil
			if cpt.fx ~= nil then
				cpt.fx:Remove()
				cpt.fx = nil
			end
			if cpt.energytime <= 0 then
				inst.AnimState:PlayAnimation("idle", false)
			else
				inst.AnimState:PlayAnimation("on_to_idle")
				inst.AnimState:PushAnimation("idle", false)
			end
			SetLight(cpt, false)
		end
		self.inst.components.pickable:SetUp(nil)
		self.inst.components.pickable.use_lootdropper_for_product = true
		self.inst.components.pickable.picksound = "dontstarve/common/destroy_magic"
	else
		self.inst:RemoveComponent("pickable")
	end
end

function GeneTrans:StartTransing()
	if self.taskgrow ~= nil then
		self.taskgrow:Cancel()
		self.taskgrow = nil
	end

	if self.fruit ~= nil or self.seed == nil then
		return
	end

	if self.timedata.pass == nil then
		self.timedata.pass = 0
	elseif self.timedata.pass >= self.timedata.all then --还没开始就已经结束
		self:Done()
		return
	end
	if self.energytime <= 0 then
		self.timedata.start = nil
		return
	else
		self.timedata.start = GetTime()
	end

	if not self.inst:IsAsleep() then
		self.taskgrow = self.inst:DoTaskInTime(9+math.random()*2, function(inst, self)
			self.taskgrow = nil
			self:LongUpdate(GetTime()-self.timedata.start)
		end, self)
	end
end

function GeneTrans:LongUpdate(dt)
	if self.timedata.all == nil or self.energytime <= 0 then --没能量了，不做任何操作
		return
	end

	local nofinish = self.timedata.all - self.timedata.pass
	if nofinish <= 0 then
		self:Done()
	else
		nofinish = math.min(self.energytime, nofinish)
		if dt > nofinish then
			self.timedata.pass = self.timedata.pass + nofinish
			self:CostEnergy(nofinish)
		else
			self.timedata.pass = self.timedata.pass + dt
			self:CostEnergy(dt)
		end
		if self.timedata.all <= self.timedata.pass then
			self:Done()
		else
			self:StartTransing()
			if self.fx ~= nil then
				SetSeedAnim(self)
			end
		end
	end
end

function GeneTrans:OnEntitySleep()
    if self.taskgrow ~= nil then
		self.taskgrow:Cancel()
		self.taskgrow = nil
	end
end

function GeneTrans:OnEntityWake()
	if self.timedata.start == nil or self.energytime <= 0 then
		return
	end

	self:LongUpdate(GetTime()-self.timedata.start)
end

function GeneTrans:OnSave()
    local data = {}
    local refs = nil

	if self.fruit ~= nil then
		data.fruit = self.fruit
	elseif self.seed ~= nil then
		data.seed, refs = self.seed:GetSaveRecord()
		if self.timedata.start ~= nil then
			data.time_dt = GetTime() - self.timedata.start
		end
		data.time_pass = self.timedata.pass
    end

	if self.energytime < self.energytime_max then
		data.energytime = self.energytime
	end

    return data, refs
end

function GeneTrans:OnLoad(data, newents)
	if data.energytime ~= nil then
		self.energytime = data.energytime
	end
	if data.fruit ~= nil then
		self.fruit = PrefabExists(data.fruit) and data.fruit or "siving_rocks"
		self.fx = SpawnPrefab(self.fxdata.prefab)
		self.fx.entity:SetParent(self.inst.entity)
		self.fx.entity:AddFollower()
		self.fx.Follower:FollowSymbol(
			self.inst.GUID, self.fxdata.symbol,
			self.fxdata.x, self.fxdata.y, self.fxdata.z
		)
		self:CostEnergy(0)
		SetSeedAnim(self)
		self:TriggerPickable(true)
	elseif data.seed ~= nil then
		local seed = SpawnSaveRecord(data.seed, newents)
		if seed ~= nil then
			if TRANS_DATA_LEGION[seed.prefab] == nil then
				seed:Remove()
			else
				if data.time_pass ~= nil then
					self.timedata.pass = data.time_pass
				end
				self:SetUp(seed, nil, true)
				if data.time_dt ~= nil then
					self:LongUpdate(data.time_dt)
				end
			end
		end
	end
end

function GeneTrans:Charge(items, doer)
    if self.energytime >= self.energytime_max then
		return false, "ENERGYMAX"
	end

	local needtime = self.energytime_max - self.energytime
	local itemtime = 0

	if items.components.stackable ~= nil then
		local num = items.components.stackable:StackSize() or 1
		local numused = 0
		for i = 1, num, 1 do
			numused = i
			itemtime = itemtime + TUNING.TOTAL_DAY_TIME
			if itemtime >= needtime then
				break
			end
		end
		items.components.stackable:Get(numused):Remove()
	else
		itemtime = TUNING.TOTAL_DAY_TIME
		items:Remove()
	end

	self:CostEnergy(-itemtime)
	self:StartTransing()
	if self.fx ~= nil then
		SetSeedAnim(self)
	end

	return true
end

return GeneTrans
