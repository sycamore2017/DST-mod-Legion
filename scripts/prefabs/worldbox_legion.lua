local prefs = {}
-- local TOOLS_L = require("tools_legion")

--------------------------------------------------------------------------
--[[ 世界容器-云青松容器 ]]
--------------------------------------------------------------------------

local function OnAnyOpenStorage(inst, data)
	if inst.components.container.opencount > 1 then
		--multiple users, make it global to all players now
		inst.Network:SetClassifiedTarget(nil)
	else
		--just one user, only network to that player
		inst.Network:SetClassifiedTarget(data.doer)
	end
end
local function OnAnyCloseStorage(inst, data)
	local opencount = inst.components.container.opencount
	if opencount == 0 then
		--all closed, disable networking
		inst.Network:SetClassifiedTarget(inst)
	elseif opencount == 1 then
		--only one user remaining, only network to that player
		local opener = next(inst.components.container.openlist)
		inst.Network:SetClassifiedTarget(opener)
	end
end
local function MakeWorldBox(data) --这些内容和官方差不多一样的，具体请查看 \prefabs\pocketdimensioncontainers.lua
    table.insert(prefs, Prefab(data.name, function()
        local inst = CreateEntity()

        if TheWorld.ismastersim then
            inst.entity:AddTransform() --按官方说法，有这个才能实行保存机制
        end
        inst.entity:AddNetwork()
        inst.entity:AddServerNonSleepable()
        inst.entity:SetCanSleep(false)
        inst.entity:Hide()
        inst:AddTag("CLASSIFIED")
        inst:AddTag("pocketdimension_container")
        inst:AddTag("irreplaceable")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        inst.Network:SetClassifiedTarget(inst)

        inst:AddComponent("container")
        inst.components.container:WidgetSetup(data.name)
        inst.components.container.skipclosesnd = true
        inst.components.container.skipopensnd = true
        inst.components.container.skipautoclose = true
        inst.components.container.onanyopenfn = OnAnyOpenStorage
        inst.components.container.onanyclosefn = OnAnyCloseStorage

        TheWorld:SetPocketDimensionContainer(data.boxkey, inst)

        if data.fn_server ~= nil then
            data.fn_server(inst)
        end

        return inst
    end, data.assets, data.prefabs))
end

local function SetPerishRate_pine(inst, item)
    if item ~= nil and item.foliageath_data ~= nil then --能入鞘的才能保鲜
        return 0
    end
    return inst.perishrate_l or 1 --要是别的mod想改，可以改这个变量
end
local function FnServer_pine(inst)
    inst:AddComponent("preserver")
    inst.components.preserver:SetPerishRateMultiplier(SetPerishRate_pine)
end

MakeWorldBox({
    name = "cloudpine_box_l1", boxkey = "cloudpine_l1",
    assets = {
        Asset("ANIM", "anim/ui_bookstation_4x5.zip"),
        Asset("ANIM", "anim/ui_cloudpine_box_4x1.zip")
    },
    fn_server = FnServer_pine
})
MakeWorldBox({
    name = "cloudpine_box_l2", boxkey = "cloudpine_l2",
    assets = {
        Asset("ANIM", "anim/ui_bookstation_4x5.zip"),
        Asset("ANIM", "anim/ui_cloudpine_box_4x3.zip")
    },
    fn_server = FnServer_pine
})
MakeWorldBox({
    name = "cloudpine_box_l3", boxkey = "cloudpine_l3",
    assets = {
        Asset("ANIM", "anim/ui_bookstation_4x5.zip"),
        Asset("ANIM", "anim/ui_cloudpine_box_4x6.zip")
    },
    fn_server = FnServer_pine
})

--------------------
--------------------

return unpack(prefs)
