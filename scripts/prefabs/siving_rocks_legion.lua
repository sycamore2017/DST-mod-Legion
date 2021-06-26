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

    local function UpdateGrowing(inst)
        if IsTooDarkToGrow_legion(inst) then
            inst.components.timer:PauseTimer("growup")
        else
            inst.components.timer:ResumeTimer("growup")
        end
    end

    local function OnIsDark(inst)
        UpdateGrowing(inst)
        if TheWorld.state.isnight then
            if inst.nighttask == nil then
                inst.nighttask = inst:DoPeriodicTask(5, UpdateGrowing, math.random() * 5)
            end
        else
            if inst.nighttask ~= nil then
                inst.nighttask:Cancel()
                inst.nighttask = nil
            end
        end
    end

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

            inst:AddTag("siving_derivant")

            inst.entity:SetPristine()

            if not TheWorld.ismastersim then
                return inst
            end

            inst.nighttask = nil

            inst:AddComponent("inspectable")

            inst:AddComponent("lootdropper")

            inst:AddComponent("workable")

            inst:AddComponent("timer")

            if data.fn_server ~= nil then
                data.fn_server(inst)
            end

            inst:WatchWorldState("isnight", OnIsDark)
            MakeSnowCovered_serv_legion(inst, 0, OnIsDark)

            MakeHauntableWork(inst)

            return inst
        end,
        {
            Asset("ANIM", "anim/hiddenmoonlight.zip"),  --提供积雪贴图
            Asset("ANIM", "anim/siving_derivants.zip"),
        },
        data.prefabs
    ))
end

local function DropRock(inst, chance)
    if math.random() <= chance then
        inst.components.lootdropper:SpawnLootPrefab("siving_rocks")
    end
end

MakeDerivant({  --子圭一型岩
    name = "lvl0",
    obstacleradius = nil,
    prefabs = { "siving_derivant_item", "siving_derivant_lvl1" },
    fn_server = function(inst)
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetWorkLeft(3)
        inst.components.workable:SetOnFinishCallback(function(inst, worker)
            inst.components.lootdropper:SpawnLootPrefab("siving_derivant_item")
            inst:Remove()
        end)

        inst.components.timer:StartTimer("growup", TUNING.TOTAL_DAY_TIME * 6)
        inst:ListenForEvent("timerdone", function(inst, data)
            if data.name == "growup" then
                inst.SoundEmitter:PlaySound("dontstarve/common/together/marble_shrub/grow")
                SpawnPrefab("siving_derivant_lvl1").Transform:SetPosition(inst.Transform:GetWorldPosition())
                inst:Remove()
            end
        end)
    end,
})
MakeDerivant({  --子圭木型岩
    name = "lvl1",
    obstacleradius = 1,
    prefabs = { "siving_rocks", "siving_derivant_lvl0", "siving_derivant_lvl2" },
    fn_server = function(inst)
        inst.components.workable:SetWorkAction(ACTIONS.MINE)
        inst.components.workable:SetWorkLeft(6)
        inst.components.workable:SetOnWorkCallback(function(inst, worker, workleft)
            if workleft > 0 then
                DropRock(inst, 0.04)
            end
        end)
        inst.components.workable:SetOnFinishCallback(function(inst, worker)
            local x, y, z = inst.Transform:GetWorldPosition()
            SpawnPrefab("rock_break_fx").Transform:SetPosition(x, y, z)
            SpawnPrefab("collapse_small").Transform:SetPosition(x, y, z)
            SpawnPrefab("siving_derivant_lvl0").Transform:SetPosition(x, y, z)
            DropRock(inst, 0.5)

            inst:Remove()
        end)

        inst.components.timer:StartTimer("growup", TUNING.TOTAL_DAY_TIME * 7.5)
        inst:ListenForEvent("timerdone", function(inst, data)
            if data.name == "growup" then
                inst.SoundEmitter:PlaySound("dontstarve/common/together/marble_shrub/grow")
                SpawnPrefab("siving_derivant_lvl2").Transform:SetPosition(inst.Transform:GetWorldPosition())
                inst:Remove()
            end
        end)
    end,
})
MakeDerivant({  --子圭林型岩
    name = "lvl2",
    obstacleradius = 1,
    prefabs = { "siving_rocks", "siving_derivant_lvl1", "siving_derivant_lvl3" },
    fn_server = function(inst)
        inst.components.workable:SetWorkAction(ACTIONS.MINE)
        inst.components.workable:SetWorkLeft(12)
        inst.components.workable:SetOnWorkCallback(function(inst, worker, workleft)
            if workleft > 0 then
                DropRock(inst, 0.06)
            end
        end)
        inst.components.workable:SetOnFinishCallback(function(inst, worker)
            local x, y, z = inst.Transform:GetWorldPosition()
            SpawnPrefab("rock_break_fx").Transform:SetPosition(x, y, z)
            SpawnPrefab("collapse_small").Transform:SetPosition(x, y, z)
            SpawnPrefab("siving_derivant_lvl1").Transform:SetPosition(x, y, z)

            inst.components.lootdropper:SpawnLootPrefab("siving_rocks")
            DropRock(inst, 0.5)

            inst:Remove()
        end)

        inst.components.timer:StartTimer("growup", TUNING.TOTAL_DAY_TIME * 8)
        inst:ListenForEvent("timerdone", function(inst, data)
            if data.name == "growup" then
                inst.SoundEmitter:PlaySound("dontstarve/common/together/marble_shrub/grow")
                SpawnPrefab("siving_derivant_lvl3").Transform:SetPosition(inst.Transform:GetWorldPosition())
                inst:Remove()
            end
        end)
    end,
})
MakeDerivant({  --子圭森型岩
    name = "lvl3",
    obstacleradius = 1,
    prefabs = { "siving_rocks", "siving_derivant_lvl2" },
    fn_server = function(inst)
        inst.components.workable:SetWorkAction(ACTIONS.MINE)
        inst.components.workable:SetWorkLeft(12)
        inst.components.workable:SetOnWorkCallback(function(inst, worker, workleft)
            if workleft > 0 then
                DropRock(inst, 0.08)
            end
        end)
        inst.components.workable:SetOnFinishCallback(function(inst, worker)
            local x, y, z = inst.Transform:GetWorldPosition()
            SpawnPrefab("rock_break_fx").Transform:SetPosition(x, y, z)
            SpawnPrefab("collapse_small").Transform:SetPosition(x, y, z)
            SpawnPrefab("siving_derivant_lvl2").Transform:SetPosition(x, y, z)

            inst.components.lootdropper:SpawnLootPrefab("siving_rocks")
            inst.components.lootdropper:SpawnLootPrefab("siving_rocks")
            DropRock(inst, 0.5)

            inst:Remove()
        end)

        inst.components.timer:StartTimer("growup", TUNING.TOTAL_DAY_TIME * 6)
        inst:ListenForEvent("timerdone", function(inst, data)
            if data.name == "growup" then
                inst.components.timer:StartTimer("growup", TUNING.TOTAL_DAY_TIME * 6)

                local x,y,z = inst.Transform:GetWorldPosition()
                local ents = TheSim:FindEntities(x,y,z, 8)
                local numloot = 0
                for i,ent in ipairs(ents) do
                    if ent.prefab == "siving_rocks" then
                        numloot = numloot + 1
                        if numloot >= 2 then
                            return
                        end
                    end
                end
                inst.components.lootdropper:SpawnLootPrefab("siving_rocks")
            end
        end)
    end,
})

--------------------------------------------------------------------------
--[[ 子圭神木 ]]
--------------------------------------------------------------------------

local function StateChange(inst) --0休眠状态(玄鸟死亡)、1正常状态(玄鸟活着，非春季)、2活力状态(玄鸟活着，春季)
    if inst.components.timer:TimerExists("birdrebirth") then --玄鸟死亡
        inst.countWorked = 0
        inst.treeState = 0
        inst.components.bloomer:PopBloom("activetree")
        inst.Light:Enable(false)
        return
    end

    if TheWorld.state.isspring then --春季
        inst.treeState = 2
        inst.components.bloomer:PushBloom("activetree", "shaders/anim.ksh", 1)
        inst.Light:Enable(true)
    else
        inst.treeState = 1
        inst.components.bloomer:PopBloom("activetree")
        inst.Light:Enable(false)
    end
end

table.insert(prefs, Prefab(
        "siving_thetree",
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddSoundEmitter()
            inst.entity:AddAnimState()
            inst.entity:AddNetwork()
            inst.entity:AddMiniMapEntity()
            inst.entity:AddLight()

            MakeObstaclePhysics(inst, 1.8)

            inst.AnimState:SetBank("siving_thetree")
            inst.AnimState:SetBuild("siving_thetree")
            inst.AnimState:PlayAnimation("idle")

            inst.MiniMapEntity:SetIcon("siving_thetree.tex")

            inst.Light:Enable(false)
            inst.Light:SetRadius(3.5)
            inst.Light:SetFalloff(1)
            inst.Light:SetIntensity(.6)
            inst.Light:SetColour(15/255, 180/255, 132/255)

            inst:AddTag("siving_thetree")

            inst.entity:SetPristine()

            if not TheWorld.ismastersim then
                return inst
            end

            inst.countWorked = 0
            inst.treeState = 1

            inst:AddComponent("inspectable")

            inst:AddComponent("lootdropper")

            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(ACTIONS.MINE)
            inst.components.workable:SetWorkLeft(20)
            inst.components.workable:SetOnWorkCallback(function(inst, worker, workleft, numworks)
                inst.components.workable:SetWorkLeft(20)    --恢复工作量，永远都破坏不了

                if inst.treeState > 0 then
                    inst.countWorked = inst.countWorked + 1

                    if inst.countWorked >= (inst.treeState == 1 and 30 or 20) then
                        inst.countWorked = 0
                        --掉落子圭石
                    end
                end
            end)

            inst:AddComponent("bloomer")

            MakeHauntableWork(inst)

            inst:AddComponent("timer")
            inst:ListenForEvent("timerdone", function(inst, data)
                if data.name == "birdrebirth" then
                    StateChange(inst)
                end
            end)

            inst:WatchWorldState("isspring", StateChange)

            inst.OnLoad = function(inst, data)
                StateChange(inst)
            end

            return inst
        end,
        {
            Asset("ANIM", "anim/siving_thetree.zip"),
        },
        {}
    ))

--------------------
--------------------

return unpack(prefs)
