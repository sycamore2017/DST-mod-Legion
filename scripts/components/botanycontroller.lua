local BotanyController = Class(function(self, inst)
    self.inst = inst

    self.type = 1 --1水、2土、3水土
    self.moisture = 0
    self.nutrients = { 0, 0, 0 }
    self.onbarchange = nil

    self.moisture_max = 1600
    self.nutrient_max = 800
end)

local function SetBars(self)
    if self.onbarchange ~= nil then
        self.onbarchange(self)
    end
end
local function ComputValue(valuenow, value, valuemax, isadd, plus)
    if isadd then
        value = valuenow + value*plus
    else
        -- value = value*plus --替换时，不应用数值加成
    end
    value = math.clamp(value, 0, valuemax)
    return value
end
function BotanyController:SetValue(moisture, nutrients, isadd)
    if moisture ~= nil and (self.type == 1 or self.type == 3) then --水分获取简单，无数值加成
        self.moisture = ComputValue(self.moisture, moisture, self.moisture_max, isadd, 1)
        SetBars(self)
    end
    if nutrients ~= nil and (self.type == 2 or self.type == 3) then --肥料提供30%数值加成
        if nutrients[1] ~= nil then
            self.nutrients[1] = ComputValue(self.nutrients[1], nutrients[1], self.nutrient_max, isadd, 1.3)
        end
        if nutrients[2] ~= nil then
            self.nutrients[2] = ComputValue(self.nutrients[2], nutrients[2], self.nutrient_max, isadd, 1.3)
        end
        if nutrients[3] ~= nil then
            self.nutrients[3] = ComputValue(self.nutrients[3], nutrients[3], self.nutrient_max, isadd, 1.3)
        end
        SetBars(self)
    end
end

function BotanyController:TriggerPlant(isadd)
    local x, y, z = self.inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 21,
        { "crop_legion" },
        { "NOCLICK", "FX", "INLIMBO" },
        nil
    )
    for _,v in pairs(ents) do
        if v.components.perennialcrop ~= nil then
            v.components.perennialcrop:TriggerController(self.inst, isadd)
        end
    end
end

local function isEmptyNutrients(self)
    return self.nutrients[1] <= 0 and self.nutrients[2] <= 0 and self.nutrients[3] <= 0
end
local function ComputNutrient(self, idx, _n)
    _n = 100 - _n
    if _n > 0 then
        local n_now = self.nutrients[idx]
        if n_now > _n then
            self.nutrients[idx] = n_now - _n
            return _n
        else
            self.nutrients[idx] = 0
            return n_now
        end
    end
    return 0
end
local function ComputNutrients(self, x, y, z)
    local tile_x, tile_z = TheWorld.Map:GetTileCoordsAtPoint(x, y, z)
    local _n1, _n2, _n3 = TheWorld.components.farming_manager:GetTileNutrients(tile_x, tile_z)
    _n1 = ComputNutrient(self, 1, _n1)
    _n2 = ComputNutrient(self, 2, _n2)
    _n3 = ComputNutrient(self, 3, _n3)
    if _n1 > 0 or _n2 > 0 or _n3 > 0 then
        TheWorld.components.farming_manager:AddTileNutrients(tile_x, tile_z, _n1, _n2, _n3)
        return true
    end
end
local function ComputMoisture(self, x, y, z)
    if self.moisture > 0 then
        TheWorld.components.farming_manager:AddSoilMoistureAtPoint(x, y, z, 100)
        self.moisture = math.max(0, self.moisture-25)
        return true
    end
end
local function WitherComputMoisture(self, v)
    if
        v.components.witherable ~= nil and
        not v.components.witherable:IsProtected() and
        (v.components.witherable:CanWither() or v.components.witherable:CanRejuvenate()) --枯萎中或已经缺水性枯萎
    then
        v.components.witherable:Protect(TUNING.FIRESUPPRESSOR_PROTECTION_TIME)
        self.moisture = math.max(0, self.moisture-5)
        return true
    end
end
local function WitherComputNutrients(self, v)
    if
        v.components.pickable ~= nil and
        v.components.pickable:CanBeFertilized() --贫瘠或缺水枯萎
    then
        local idx = nil
        if self.nutrients[3] > 0 then
            idx = 3
        elseif self.nutrients[2] > 0 then
            idx = 2
        elseif self.nutrients[1] > 0 then
            idx = 1
        else
            return true --按理来说不应该能运行到这里
        end

        local poop = SpawnPrefab("poop")
        if poop ~= nil then
            v.components.pickable:Fertilize(poop, nil)
            poop:Remove()
            self.nutrients[idx] = math.max(0, self.nutrients[idx] - 8)
            return true
        end
    end
end
local function ComputSoils(self, fn_tile, fn_wither, fn_check)
    if fn_check(self) then
        return
    end

    local isasleep = self.inst:IsAsleep()
    local x, y, z = self.inst.Transform:GetWorldPosition()
    for k1 = -28,28,4 do
        for k2 = -28,28,4 do
            local tile = TheWorld.Map:GetTileAtPoint(x+k1, 0, z+k2)
            if tile == GROUND.FARMING_SOIL then
                if fn_tile(self, x+k1, 0, z+k2) and fn_check(self) then
                    SetBars(self)
                    if not isasleep then --睡眠状态就不释放特效
                        --特效
                    end
                    return
                end
            end
        end
    end

    --特效

    if isasleep then --睡眠状态就不查找枯萎作物
        SetBars(self)
        return
    end

    local ents = TheSim:FindEntities(x, y, z, 20,
        { "witherable" }, --不需要考虑子圭作物，因为机制已经有了
        { "NOCLICK", "FX", "INLIMBO" },
        nil
    )
    for _,v in pairs(ents) do
        if v:IsValid() then
            if fn_wither(self, v) and fn_check(self) then
                SetBars(self)
                return
            end
        end
    end
    SetBars(self)
end
function BotanyController:DoAreaFunction()
    if self.type == 1 then
        ComputSoils(self,
            ComputMoisture,
            WitherComputMoisture,
            function(self)
                return self.moisture <= 0
            end
        )
    elseif self.type == 2 then
        ComputSoils(self,
            ComputNutrients,
            WitherComputNutrients,
            isEmptyNutrients
        )
    else
        ComputSoils(self,
            function(self, x, y, z)
                local res_m = ComputMoisture(self, x, y, z)
                local res_n = ComputNutrients(self, x, y, z)
                return res_m or res_n
            end,
            function(self, v)
                local res_m = WitherComputMoisture(self, v)
                local res_n = WitherComputNutrients(self, v)
                return res_m or res_n
            end,
            function(self)
                return self.moisture <= 0 and isEmptyNutrients(self)
            end
        )
    end
end

function BotanyController:OnSave()
    local data = nil
    if self.type == 1 then
        if self.moisture > 0 then
            data = { moisture = self.moisture }
        end
    elseif self.type == 2 then
        if self.nutrients[1] > 0 or self.nutrients[2] > 0 or self.nutrients[3] > 0 then
            
        end
    else
        
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

	--恢复当前阶段的照顾情况
	self.tended = data.tended and true or false
	if self.tended and self.tendable then --若已经照顾过，且当前阶段可被照顾，则不能再被照顾
		if self.inst.components.farmplanttendable ~= nil then
			self.inst.components.farmplanttendable:SetTendable(false)
		end
	end

	self:OnEntitySleep() --把task取消，根据情况继续
	if data.time_paused then
		self.timedata.paused = true
		self.timedata.left = data.time_left
		self.timedata.start = nil
		self.timedata.all = nil
	elseif data.time_dt ~= nil and data.time_all ~= nil then
		self.timedata.paused = false
		self.timedata.left = nil
		self.timedata.start = GetTime()
		self.timedata.all = data.time_all
		self:LongUpdate(data.time_dt, false)
	else
		self:StartGrowing() --数据丢失的话，就只能重新开始了
	end
end

return BotanyController
