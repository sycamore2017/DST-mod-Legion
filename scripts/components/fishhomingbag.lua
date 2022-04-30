local FishHomingBag = Class(function(self, inst)
	self.inst = inst
	self.times = 1
	self.prefabs = nil
	self.details = nil
	self.type_eat = "veggie"
	self.type_shape = "dusty"
	self.type_special = nil
	self.images = {
		dusty = { img="icire_rock5", atlas="images/inventoryimages/icire_rock5.xml" },
		pasty = { img="icire_rock4", atlas="images/inventoryimages/icire_rock4.xml" },
		hardy = { img="icire_rock1", atlas="images/inventoryimages/icire_rock1.xml" }
	}
	self.onmakefn = nil
end)

function FishHomingBag:InitSelf()
	if self.details == nil then
		self.inst:RemoveTag("FH_VEGGIE")
		self.inst:RemoveTag("FH_MEAT")
		self.inst:RemoveTag("FH_MONSTER")
		self.inst:RemoveTag("FH_HARDY")
		self.inst:RemoveTag("FH_PASTY")
		self.inst:RemoveTag("FH_DUSTY")
		return
	end

	self.inst:AddTag("FH_"..self.type_eat)
	if self.type_eat == "meat" then
		self.inst:RemoveTag("FH_VEGGIE")
		self.inst:RemoveTag("FH_MONSTER")
	elseif self.type_eat == "monster" then
		self.inst:RemoveTag("FH_VEGGIE")
		self.inst:RemoveTag("FH_MEAT")
	else
		self.inst:RemoveTag("FH_MEAT")
		self.inst:RemoveTag("FH_MONSTER")
	end

	self.inst:AddTag("FH_"..self.type_shape)
	if self.type_shape == "pasty" then
		self.inst:RemoveTag("FH_HARDY")
		self.inst:RemoveTag("FH_DUSTY")
	elseif self.type_shape == "hardy" then
		self.inst:RemoveTag("FH_DUSTY")
		self.inst:RemoveTag("FH_PASTY")
	else
		self.inst:RemoveTag("FH_HARDY")
		self.inst:RemoveTag("FH_PASTY")
	end

	if self.images[self.type_shape] ~= nil then
		self.inst.components.inventoryitem.atlasname = self.images[self.type_shape].atlas
		self.inst.components.inventoryitem:ChangeImageName(self.images[self.type_shape].img)
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
	
end
function FishHomingBag:Make(container, doer)
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
		self.onmakefn(self, container, doer)
	end

	self.type_eat = FindMaxKey(details, "veggie", "meat", "monster")
	self.type_shape = FindMaxKey(details, "hardy", "pasty", "dusty")
	self.type_special = FindOtherKeys(details_other)

	self.times = math.ceil(self.times/2) --根据总数量确定释放功能的次数(最多 4格*40叠加/2=80次)
	self.details = details
	self:InitSelf()
end

function FishHomingBag:OnSave()
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

	if self.details ~= nil then
		data.details = {}
		for k,num in pairs(self.details) do
			if num ~= nil and num > 0 then
				data.details[k] = num
			end
		end
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

function FishHomingBag:OnLoad(data)
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

		if data.details ~= nil then
			self.details = {
				hardy = data.details.hardy or 0,
				pasty = data.details.pasty or 0,
				dusty = data.details.dusty or 0,
				meat = data.details.meat or 0,
				veggie = data.details.veggie or 0,
				monster = data.details.monster or 0
			}
			for k,num in pairs(data.details) do
				if num ~= nil and self.details[k] == nil then
					self.details[k] = num
				end
			end

			self.type_eat = FindMaxKey(self.details, "veggie", "meat", "monster")
			self.type_shape = FindMaxKey(self.details, "hardy", "pasty", "dusty")
		end

		self:InitSelf()

		if data.prefabs ~= nil then
			for _,name in pairs(data.prefabs) do
				self.prefabs[name] = true
			end
		end
    end
end

return FishHomingBag
