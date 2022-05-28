local GeneTrans = Class(function(self, inst)
	self.inst = inst

	self.energytime = TUNING.TOTAL_DAY_TIME*10 --当前能量时间
	self.energytime_max = self.energytime --最大能量时间

	self.seed = nil --播下的种子
	self.isdone = false --是否已经完成转化
	self.taskgrow = nil
	self.timedata = {
		start = nil, --当前task开始的时间点
		pass = nil, --已经生长的时间
		all = nil, --总体生长时间
	}

	self.fxdata = {
		prefab = "siving_turn_fruit", symbol = "shadow-1", x = 0, y = 0, z = 0
	}
	self.fx = nil

	-- self.fn_setup = nil --fn(cpt, seed, doer)

end)

local function SetSeedAnim(self)
	local percent = 1
	if self.timedata.all ~= nil and self.timedata.pass ~= nil then
		percent = math.min(1, self.timedata.pass/self.timedata.all)
	end
	self.fx.AnimState:SetPercent(self.energytime <= 0 and "fruit" or "fruit_on", percent)
end

function GeneTrans:SetUp(seed, doer)
	if self.seed ~= nil then --已经播种了
		return false, "GROWING"
	end
	if TRANS_DATA_LEGION[seed.prefab] == nil then --不能转化
		return false, "WRONGITEM"
	end
	if self.energytime <= 0 then --没能量了
		return false, "NOENERGY"
	end

	local trans = TRANS_DATA_LEGION[seed.prefab]

	--设置本体的动画
	self.inst.AnimState:PlayAnimation("idle_to_on")
	self.inst.AnimState:PushAnimation("on", true)

	--设置果实的动画
	if self.fx == nil or not self.fx:IsValid() then
		self.fx = SpawnPrefab(self.fxdata.prefab)
		self.fx.entity:SetParent(self.inst.entity)
		self.fx.entity:AddFollower()
		self.fx.Follower:FollowSymbol(
			self.inst.GUID, self.fxdata.symbol,
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
	self.seed = seed
    self.inst:AddChild(seed)
    seed:RemoveFromScene()
    seed.Transform:SetPosition(0,0,0)

	--开始基因转化
	if not self.isdone then
		self.timedata.all = trans.time or (0.5*TUNING.TOTAL_DAY_TIME)
		self:StartTransing()
	end
	SetSeedAnim(self)

    return true
end

function GeneTrans:CostEnergy(cost)
	local old = self.energytime
	self.energytime = math.max(0, old-cost)
	if self.energytime <= 0 then
		if old > 0 then
			self.inst.AnimState:PlayAnimation("on_to_idle") --undo 还需要看果实，确定是否飞起来
			self.inst.AnimState:PushAnimation("idle", true)
		else
			self.inst.AnimState:PlayAnimation("idle", true)
		end
	else
		if old <= 0 then
			self.inst.AnimState:PlayAnimation("idle_to_on")
			self.inst.AnimState:PushAnimation("on", true)
		end
	end
	
end

function GeneTrans:Done()
	self.isdone = true
	self.timedata.all = nil
	self.timedata.pass = nil
	self.timedata.start =nil

	
end

function GeneTrans:StartTransing()
	if self.taskgrow ~= nil then
		self.taskgrow:Cancel()
		self.taskgrow = nil
	end

	if self.isdone then
		return
	end

	if self.timedata.pass == nil then
		self.timedata.pass = 0
	elseif self.timedata.pass >= self.timedata.all then --还没开始就已经结束
		self:Done()
		return
	end
	self.timedata.start = GetTime()

	if not self.inst:IsAsleep() then
		self.taskgrow = self.inst:DoTaskInTime(self.timedata.all-self.timedata.pass, function(inst, self)
			self.taskgrow = nil
			self:CostEnergy(self.timedata.all-self.timedata.pass) --花费能量
			self:Done()
		end, self)
	end
end

return GeneTrans
