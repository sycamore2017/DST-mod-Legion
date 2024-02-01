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

            inst.dd_l_smear = { build = data.name }

            inst:AddComponent("inspectable")

            inst:AddComponent("inventoryitem")
            inst.components.inventoryitem.imagename = data.name
            inst.components.inventoryitem.atlasname = "images/inventoryimages/"..data.name..".xml"

            inst:AddComponent("stackable")
            inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

            inst:AddComponent("ointmentlegion")

            inst:AddComponent("fuel")
            inst.components.fuel.fuelvalue = TUNING.TINY_FUEL

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

local function FnCheck_fireproof(inst, doer, target)
    if target.components.burnable == nil or target:HasTag("burnt") then
        return false, "NOUSE"
    end
    if target.components.burnable.fireproof_l then
        return false, "NONEED"
    end
    if target.components.health ~= nil and target.components.health:IsDead() then
        return false, "NOUSE"
    end
    return true
end
local function FnSmear_fireproof(inst, doer, target)
    if --是可燃物
        target:HasTag("wall") or target:HasTag("structure") or target:HasTag("balloon") or
        target.components.childspawner ~= nil or
        target.components.health == nil or target.components.combat == nil
    then
        local burnable = target.components.burnable
        burnable.fireproof_l = true
        if burnable:IsBurning() or burnable:IsSmoldering() then
            burnable:Extinguish(true, -4) --涂抹完成，顺便灭火
        end
        burnable.canlight = false --官方逻辑，这样就不会出现点燃选项
    else --是生物
        target.time_l_fireproof = { add = TUNING.SEG_TIME*12, max = TUNING.SEG_TIME*30 }
        target:AddDebuff("buff_l_fireproof", "buff_l_fireproof")
    end
end

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
    fn_server = function(inst)
        inst.components.ointmentlegion.fn_check = FnCheck_fireproof
        inst.components.ointmentlegion.fn_smear = FnSmear_fireproof
    end
})

--------------------------------------------------------------------------
--[[ 弱肤药膏 ]]
--------------------------------------------------------------------------

local function FnCheck_sivbloodreduce(inst, doer, target)
    if target.prefab == "monstrain" then
        if target.lifeless_l then
            return false, "NONEED"
        else
            return true
        end
    end
    if target.components.combat == nil or target.components.health == nil or target.components.health:IsDead() then
        return false, "NOUSE"
    end
    if --具有以下标签的对象，根本不会被窃血，所以也不用加buff
        target:HasTag("wall") or target:HasTag("structure") or target:HasTag("balloon") or
        target:HasTag("shadowminion") or target:HasTag("ghost")
    then
        return false, "NOUSE"
    end
    return true
end
local function FnSmear_sivbloodreduce(inst, doer, target)
    if target.prefab == "monstrain" then
        target.lifeless_l = true
        target.components.childspawner:StopSpawning()
    else
        target.time_l_sivbloodreduce = { add = TUNING.SEG_TIME*12, max = TUNING.SEG_TIME*30 }
        target:AddDebuff("buff_l_sivbloodreduce", "buff_l_sivbloodreduce")
    end
end

MakeOintment({
    name = "ointment_l_sivbloodreduce",
    assets = {
        Asset("ANIM", "anim/ointment_l_sivbloodreduce.zip"),
        Asset("ATLAS", "images/inventoryimages/ointment_l_sivbloodreduce.xml"),
        Asset("IMAGE", "images/inventoryimages/ointment_l_sivbloodreduce.tex")
    },
    prefabs = nil,
    float = { nil, "small", 0.25, 0.8 }, --noburnable = nil,
    -- fn_common = function(inst)end,
    fn_server = function(inst)
        inst.components.ointmentlegion.fn_check = FnCheck_sivbloodreduce
        inst.components.ointmentlegion.fn_smear = FnSmear_sivbloodreduce
    end
})

----------

return unpack(prefs)
