local prefs = {}

local function OnLandedClient(self, ...)
    if self.OnLandedClient_l_base ~= nil then
        self.OnLandedClient_l_base(self, ...)
    end
    if self.floatparam_l ~= nil then
        self.inst.AnimState:SetFloatParams(self.floatparam_l, 1, self.bob_percent)
    end
end
local function MakeFloatable(inst, float)
    if float ~= nil then
        MakeInventoryFloatable(inst, float[2], float[3], float[4])
        if float[1] ~= nil then
            local floater = inst.components.floater
            floater.OnLandedClient_l_base = floater.OnLandedClient
            floater.floatparam_l = float[1]
            floater.OnLandedClient = OnLandedClient
        end
    end
end

local function MakeOintment(data)
    table.insert(prefs, Prefab(
        data.name,
		function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddNetwork()

            MakeInventoryPhysics(inst)

            inst.AnimState:SetBank(data.name)
            inst.AnimState:SetBuild(data.name)
            inst.AnimState:PlayAnimation("idle")

            -- inst:AddTag("DECOR")

            MakeFloatable(inst, data.float)

            if data.fn_common ~= nil then
                data.fn_common(inst)
            end

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst:AddComponent("inspectable")

            inst:AddComponent("inventoryitem")
            inst.components.inventoryitem.imagename = data.name
            inst.components.inventoryitem.atlasname = "images/inventoryimages/"..data.name..".xml"

            inst:AddComponent("stackable")
            inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

            if not data.noburnable then
                MakeSmallBurnable(inst)
                MakeSmallPropagator(inst)
            end

            MakeHauntableLaunch(inst)

            if data.fn_server ~= nil then
                data.fn_server(inst)
            end

            return inst
		end,
		data.assets,
		data.prefabs
	))
end

--------------------------------------------------------------------------
--[[ 防火漆 ]]
--------------------------------------------------------------------------

MakeOintment({
    name = "ointment_l_fireproof",
    assets = {
        Asset("ANIM", "anim/ointment_l_fireproof.zip"),
        Asset("ATLAS", "images/inventoryimages/ointment_l_fireproof.xml"),
        Asset("IMAGE", "images/inventoryimages/ointment_l_fireproof.tex")
    },
    prefabs = nil,
    float = { nil, "small", 0.25, 0.8 }, noburnable = true,
    -- fn_common = function(inst)end,
    -- fn_server = function(inst)end
})

----------

return unpack(prefs)
