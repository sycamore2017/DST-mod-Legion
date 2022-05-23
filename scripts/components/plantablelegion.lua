local PlantableLegion = Class(function(self, inst)
	self.inst = inst
	self.plant = "plant_corn_l"
	self.crop = "corn"
end)

-- function PlantableLegion:SetUp(crop, plant)
-- 	self.cropprefab = crop
-- 	self.plantprefab = plant
-- end

return PlantableLegion