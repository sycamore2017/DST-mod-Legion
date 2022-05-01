local FishHomingBait = Class(function(self, inst)
	self.inst = inst
	self.times = 1
	self.prefabs = nil
	self.type_eat = "veggie"
	self.type_shape = "dusty"
	self.type_special = nil
	self.isbaiting = false

	self.onmakefn = nil
	self.oninitfn = nil

	self.task_baiting = nil
end)

function FishHomingBait:InitSelf()
	if self.oninitfn ~= nil then
		self.oninitfn(self.inst)
	end

	if self.isbaiting then
		return
	end

	for k,_ in pairs(STRINGS.FISHHOMING2_LEGION) do
		if self.type_eat == string.lower(k) then
			self.inst:AddTag("FH_"..k)
		else
			self.inst:RemoveTag("FH_"..k)
		end
	end

	for k,_ in pairs(STRINGS.FISHHOMING1_LEGION) do
		if self.type_shape == string.lower(k) then
			self.inst:AddTag("FH_"..k)
		else
			self.inst:RemoveTag("FH_"..k)
		end
	end

	if self.type_special == nil then
		for k,_ in pairs(STRINGS.FISHHOMING3_LEGION) do
			self.inst:RemoveTag("FH_"..k)
		end
	else
		for k,_ in pairs(STRINGS.FISHHOMING3_LEGION) do
			if self.type_special[string.lower(k)] then
				self.inst:AddTag("FH_"..k)
			else
				self.inst:RemoveTag("FH_"..k)
			end
		end
	end
end

local function FindMaxKey(details, k1, k2, k3)
	if details[k1] > details[k2] then
		if details[k1] > details[k3] then
			return k1
		elseif details[k1] == details[k3] then
			return math.random() > 0.5 and k1 or k2
		else
			return k3
		end
	elseif details[k1] == details[k2] then
		if details[k1] > details[k3] then
			return math.random() > 0.5 and k1 or k2
		elseif details[k1] == details[k3] then
			local rand = math.random()
			if rand <= 0.33 then
				return k1
			elseif rand <= 0.66 then
				return k2
			else
				return k3
			end
		else
			return k3
		end
	else
		if details[k2] > details[k3] then
			return k2
		elseif details[k2] == details[k3] then
			return math.random() > 0.5 and k2 or k3
		else
			return k3
		end
	end
end
local function FindOtherKeys(other)
	local key_max = {}
	local num_max = 0
	local key_max2 = {}
	local num_max2 = 0

	--找出最大值
	for k,num in pairs(other) do
		if num then
			if num > num_max then
				num_max = num
				key_max = {}
				table.insert(key_max, k)
			elseif num == num_max then
				table.insert(key_max, k)
			end
		end
	end

	--找出第二最大值
	for k,num in pairs(other) do
		if num and num < num_max then
			if num > num_max2 then
				num_max2 = num
				key_max2 = {}
				table.insert(key_max2, k)
			elseif num == num_max2 then
				table.insert(key_max2, k)
			end
		end
	end

	if num_max <= 0 and num_max2 <= 0 then
		return nil
	end

	local res = {}
	if num_max > 0 then
		res[ key_max[math.random(#key_max)] ] = true
	end
	if num_max2 > 0 then
		res[ key_max2[math.random(#key_max2)] ] = true
	end
	print("zehshi:"..tostring(key_max[1]).."-"..tostring(key_max2[1]))
	return res
end
function FishHomingBait:Make(container, doer)
	local details = {
		hardy = 0, pasty = 0, dusty = 0,
		meat = 0, veggie = 0, monster = 0
	}
	local details_other = {}
	self.times = 0
	self.prefabs = {}

	for i = 1, container:GetNumSlots() do
		local item = container:GetItemInSlot(i)
		if item ~= nil then
			local mult = item.components.stackable ~= nil and item.components.stackable:StackSize() or 1

			if FISHHOMING_INGREDIENTS_L[item.prefab] ~= nil then
				local idata = FISHHOMING_INGREDIENTS_L[item.prefab]
				for k,num in pairs(idata) do
					if num then
						if details[k] == nil then
							if details_other[k] == nil then
								details_other[k] = num*mult
							else
								details_other[k] = details_other[k] + num*mult
							end
						else
							details[k] = details[k] + num*mult
						end
					end
				end
			elseif item.components.edible ~= nil then
				if item.components.edible.foodtype == FOODTYPE.MEAT then
					details.meat = details.meat + mult
				elseif item.components.edible.foodtype == FOODTYPE.VEGGIE then
					details.veggie = details.veggie + mult
				elseif item.components.edible.foodtype == FOODTYPE.MONSTER then
					details.monster = details.monster + mult
				end
			end

			self.times = self.times + mult
			self.prefabs[item.prefab] = true

			item:Remove()
		end
	end

	if self.onmakefn ~= nil then
		self.onmakefn(self, container, doer, details, details_other)
	end

	self.type_eat = FindMaxKey(details, "veggie", "meat", "monster")
	self.type_shape = FindMaxKey(details, "hardy", "pasty", "dusty")
	self.type_special = FindOtherKeys(details_other)

	self.times = math.ceil(self.times/2) --根据总数量确定释放功能的次数(最多 4格*40叠加/2=80次)

	self:InitSelf()
end

function FishHomingBait:OnSave()
    local data = {}

	if self.times > 1 then
		data.times = self.times
	end

	if self.type_special ~= nil then
		data.type_special = {}
		for name,bo in pairs(self.type_special) do
			if bo then
				table.insert(data.type_special, name)
			end
		end
	end

	if self.type_eat ~= "veggie" then
		data.type_eat = self.type_eat
	end
	if self.type_shape ~= "dusty" then
		data.type_shape = self.type_shape
	end

    if self.prefabs ~= nil then
		data.prefabs = {}
		for name,bo in pairs(self.prefabs) do
			if bo then
				table.insert(data.prefabs, name)
			end
		end
	end

    return data
end

function FishHomingBait:OnLoad(data)
    if data ~= nil then
        if data.times ~= nil then
			self.times = data.times
		end

		if data.type_special ~= nil then
			self.type_special = {}
			for _,name in pairs(data.type_special) do
				self.type_special[name] = true
			end
		end

		if data.type_eat ~= nil then
			self.type_eat = data.type_eat
		end
		if data.type_shape ~= nil then
			self.type_shape = data.type_shape
		end

		if data.prefabs ~= nil then
			self.prefabs = {}
			for _,name in pairs(data.prefabs) do
				self.prefabs[name] = true
			end
		end

		self:InitSelf()
    end
end

function FishHomingBait:Handover(baiting)
    local baitcpt = baiting.components.fishhomingbait
	baitcpt.times = self.times
	baitcpt.prefabs = self.prefabs
	baitcpt.type_eat = self.type_eat
	baitcpt.type_shape = self.type_shape
	baitcpt.type_special = self.type_special
end

function FishHomingBait:Baiting()
    local periodtime = 9
	if self.type_shape == "hardy" then
		periodtime = 24
	elseif self.type_shape == "pasty" then
		periodtime = 15
	end
end

return FishHomingBait
