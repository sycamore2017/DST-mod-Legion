local prefs = {}

--------------------------------------------------------------------------
--[[ 通用函数 ]]
--------------------------------------------------------------------------

local function SetCarpetWorkable(inst)
    local bc = SpawnPrefab("beacon_work_l") --由于当前组合下没法被破坏动作识别，所以得另外生成一对象来使其能被破坏
    if bc then
        inst:AddChild(bc)
        inst._beacon = bc
        bc.components.workable:SetWorkLeft(inst._size_l)
        bc.components.workable:SetOnWorkCallback(function(bc, worker, workleft, numworks)
            if worker == nil or not worker:HasTag("player") then --非玩家无法破坏这个地毯
                bc.components.workable:SetWorkLeft(inst._size_l)
            end
        end)
        bc.components.workable:SetOnFinishCallback(function(bc, worker)
            inst.components.lootdropper:DropLoot()

            local fx = SpawnPrefab("collapse_small")
            fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
            fx:SetMaterial("wood")

            bc:Remove()
            inst:Remove()
        end)
    end
end

local function MakeCarpet(data)
    local name_base = "carpet_"..data.name
    local name_prefab = data.size == 2 and name_base.."_big" or name_base
    table.insert(prefs, Prefab(
        name_prefab,
		function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddNetwork()

            inst.AnimState:SetBank(name_base)
            inst.AnimState:SetBuild(name_base)
            inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
            inst.AnimState:SetLayer(LAYER_BACKGROUND)
            inst.AnimState:SetFinalOffset(1)

            inst:AddTag("DECOR")
            inst:AddTag("NOCLICK")
            inst:AddTag("NOBLOCK")
            inst:AddTag("carpet_l")
            if data.size == 2 then
                inst:AddTag("carpet_big")
                inst.AnimState:PlayAnimation("idle_big")
            else
                inst.AnimState:PlayAnimation("idle")
            end

            if data.fn_common ~= nil then
                data.fn_common(inst)
            end

            inst:AddComponent("skinedlegion")
            inst.components.skinedlegion:Init(name_prefab)

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst._beacon = nil
            inst._size_l = data.size

            -- inst:AddComponent("inspectable")

            inst:AddComponent("lootdropper")

            inst:AddComponent("savedrotation")

            inst:DoTaskInTime(0.1+math.random(), SetCarpetWorkable)

            if data.fn_server ~= nil then
                data.fn_server(inst)
            end

            inst.components.skinedlegion:SetOnPreLoad()

            return inst
		end,
		data.assets,
		data.prefabs
	))

    table.insert(prefs, MakePlacer(
        name_prefab.."_placer",
        name_base, name_base, data.size == 2 and "idle_big" or "idle", true,
        nil, nil, nil, 90, nil, Skined_SetBuildPlacer_legion
    ))
end

local prefabs_carpet = { "beacon_work_l" }

local function MakeCarpets(data)
    local assets = {
        Asset("ANIM", "anim/carpet_"..data.name..".zip")
    }

    MakeCarpet({ --小的
        name = data.name,
        size = 1,
        fn_common = data.fn_common1, fn_server = data.fn_server1,
        assets = assets, prefabs = data.prefabs or prefabs_carpet
    })
	MakeCarpet({ --大的
        name = data.name,
        size = 2,
        fn_common = data.fn_common2, fn_server = data.fn_server2,
        assets = assets, prefabs = data.prefabs or prefabs_carpet
    })
end

--------------------------------------------------------------------------
--[[ 信标(用来让其绑定物被摧毁) ]]
--------------------------------------------------------------------------

table.insert(prefs, Prefab(
    "beacon_work_l",
    function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddNetwork()

        inst:AddTag("NOBLOCK")

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)

        return inst
    end,
    nil,
    nil
))

--------------------------------------------------------------------------
--[[ 白木地垫、地毯 ]]
--------------------------------------------------------------------------

if TUNING.LEGION_DESERTSECRET then
    MakeCarpets({
        name = "whitewood"
    })
end

--------------------
--------------------

return unpack(prefs)
