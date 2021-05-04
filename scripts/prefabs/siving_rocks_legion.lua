local prefs = {}

--------------------------------------------------------------------------
--[[ 子圭石 ]]
--------------------------------------------------------------------------

if not CONFIGS_LEGION.ENABLEDMODS.MythWords then --未开启神话书说时才注册这个prefab
    table.insert(prefs, Prefab(
        "siving_rocks",
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddNetwork()

            MakeInventoryPhysics(inst)

            inst.AnimState:SetBank("myth_siving")
            inst.AnimState:SetBuild("myth_siving")
            inst.AnimState:PlayAnimation("siving_rocks")

            inst.entity:SetPristine()

            if not TheWorld.ismastersim then
                return inst
            end

            inst:AddComponent("stackable")
            inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

            inst:AddComponent("inspectable")

            inst:AddComponent("tradable")

            inst:AddComponent("inventoryitem")
            inst.components.inventoryitem.imagename = "siving_rocks"
            inst.components.inventoryitem.atlasname = "images/inventoryimages/siving_rocks.xml"
            inst.components.inventoryitem:SetSinks(true)

            MakeHauntableLaunchAndIgnite(inst)

            return inst
        end,
        {
            Asset("ANIM", "anim/myth_siving.zip"),
            Asset("ATLAS", "images/inventoryimages/siving_rocks.xml"),
            Asset("IMAGE", "images/inventoryimages/siving_rocks.tex"),
        },
        {}
    ))
end

--------------------------------------------------------------------------
--[[ 子圭x型岩 ]]
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--------------------------------------------------------------------------

return unpack(prefs)
