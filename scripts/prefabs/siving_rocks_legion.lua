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

local function MakeDerivant(data)
    local realname = "siving_derivant_"..data.name
    table.insert(prefs, Prefab(
        realname,
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddSoundEmitter()
            inst.entity:AddAnimState()
            inst.entity:AddNetwork()
            inst.entity:AddMiniMapEntity()

            if data.obstacleradius ~= nil then
                MakeObstaclePhysics(inst, data.obstacleradius)
            end

            inst.AnimState:SetBank("siving_derivants")
            inst.AnimState:SetBuild("siving_derivants")
            inst.AnimState:PlayAnimation(data.name)
            MakeSnowCovered_comm_legion(inst)

            inst.MiniMapEntity:SetIcon("siving_derivant.tex")

            inst.entity:SetPristine()

            if not TheWorld.ismastersim then
                return inst
            end

            inst:AddComponent("lootdropper")

            inst:AddComponent("workable")

            if data.fn_server ~= nil then
                data.fn_server(inst)
            end

            MakeSnowCovered_serv_legion(inst, 0.1 + 0.4 * math.random(), nil)

            return inst
        end,
        {
            Asset("ANIM", "anim/hiddenmoonlight.zip"),  --提供积雪贴图
            Asset("ANIM", "anim/siving_derivants.zip"),
        },
        data.prefabs
    ))
end

MakeDerivant({  --子圭一型岩
    name = "lvl0",
    obstacleradius = nil,
    prefabs = { "siving_derivant_item", "siving_derivant_lvl1" },
    fn_server = function(inst)
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnFinishCallback(function(inst, worker)
            inst.components.lootdropper:SpawnLootPrefab("siving_derivant_item")
            inst:Remove()
        end)
    end
})
MakeDerivant({  --子圭木型岩
    name = "lvl1",
    obstacleradius = 1,
})

--------------------
--------------------

return unpack(prefs)
