local BotanyController = Class(function(self, inst)
    self.inst = inst

    self.type = 1 --1水、2土、3水土
    self.moisture = 0
    self.nutrients = { 0, 0, 0 }

    self.moisture_max = 800
    self.nutrient_max = 800
end)

local function ComputValue(valuenow, value, valuemax, isadd, plus)
    if isadd then
        value = valuenow + value*plus
    else
        value = value*plus
    end
    if value > valuemax then
        value = valuemax
    elseif value < 0 then
        value = 0
    end
    return value
end
function BotanyController:SetValue(moisture, nutrients, isadd)
    if moisture ~= nil then --水分获取简单，无数值加成
        self.moisture = ComputValue(self.moisture, moisture, self.moisture_max, isadd, 1)
    end
    if nutrients ~= nil then --肥料提供30%数值加成
        if nutrients[1] ~= nil then
            self.nutrients[1] = ComputValue(self.nutrients[1], nutrients[1], self.nutrient_max, isadd, 1.3)
        end
        if nutrients[2] ~= nil then
            self.nutrients[2] = ComputValue(self.nutrients[2], nutrients[2], self.nutrient_max, isadd, 1.3)
        end
        if nutrients[3] ~= nil then
            self.nutrients[3] = ComputValue(self.nutrients[3], nutrients[3], self.nutrient_max, isadd, 1.3)
        end
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

return BotanyController
