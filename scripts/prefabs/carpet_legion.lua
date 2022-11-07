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
            fx:SetMaterial(inst._material)

            bc:Remove()
            inst:Remove()
        end)
    end
end

local function MakeCarpet(data)
    table.insert(prefs, Prefab( --大的
        data.name,
		function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddNetwork()

            inst.AnimState:SetBank("carpet_"..data.basename)
            inst.AnimState:SetBuild("carpet_"..data.basename)
            inst.AnimState:PlayAnimation(data.size == 2 and "idle_big" or "idle")
            inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
            inst.AnimState:SetLayer(LAYER_BACKGROUND)
            inst.AnimState:SetFinalOffset(1)

            inst:AddTag("DECOR")
            inst:AddTag("NOCLICK")
            inst:AddTag("NOBLOCK")
            inst:AddTag("carpet_l")

            if data.fn_common ~= nil then
                data.fn_common(inst)
            end

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst._beacon = nil
            inst._size_l = data.size
            inst._material = data.material

            -- inst:AddComponent("inspectable")

            inst:AddComponent("lootdropper")

            inst:AddComponent("savedrotation")

            inst:DoTaskInTime(0.1+math.random(), SetCarpetWorkable)

            if data.fn_server ~= nil then
                data.fn_server(inst)
            end

            return inst
		end,
		data.assets,
		data.prefabs
	))
end

local function MakeCarpets(data)
    local assets = {
        Asset("ANIM", "anim/carpet_"..data.name..".zip")
    }
    local prefabs = {
        "beacon_work_l"
    }

	MakeCarpet({ --大的
        name = "carpet_big_"..data.name,
        basename = data.name,
        size = 2, material = "wood",
        assets = assets, prefabs = prefabs
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
        name = "whitewood",
        assets = {
            Asset("ANIM", "anim/shield_l_sand.zip"),
            Asset("ATLAS", "images/inventoryimages/shield_l_sand.xml"),
            Asset("IMAGE", "images/inventoryimages/shield_l_sand.tex"),
        },
        prefabs = {
            "sandspike_legion",    --对玩家友好的沙之咬
            "shield_attack_l_fx",
        },
        fn_common = function(inst)
            inst:AddComponent("skinedlegion")
            inst.components.skinedlegion:Init("shield_l_sand")
        end,
        fn_server = function(inst)
            inst.components.inventoryitem:SetSinks(true) --它是石头做的，不可漂浮

            inst.components.equippable:SetOnEquip(function(inst, owner)
                OnEquipFn(inst, owner)
                onisraining(inst)   --装备时先更新一次

                inst:ListenForEvent("blocked", OnBlocked, owner)
                inst:ListenForEvent("attacked", OnBlocked, owner)

                inst:WatchWorldState("israining", onisraining)
                inst:WatchWorldState("issummer", onisraining)

                --能在沙暴中不减速行走
                if owner.components.locomotor ~= nil then
                    if owner._runinsandstorm == nil then
                        local oldfn = owner.components.locomotor.SetExternalSpeedMultiplier
                        owner.components.locomotor.SetExternalSpeedMultiplier = function(self, source, key, m)
                            if self.inst._runinsandstorm and key == "sandstorm" then
                                self:RemoveExternalSpeedMultiplier(self.inst, "sandstorm")
                                return
                            end
                            oldfn(self, source, key, m)
                        end
                    end
                    -- owner.components.locomotor:RemoveExternalSpeedMultiplier(owner, "sandstorm") --切换装备时，下一帧会自动更新移速
                    owner._runinsandstorm = true
                end
            end)
            inst.components.equippable:SetOnUnequip(function(inst, owner)
                inst:RemoveEventCallback("blocked", OnBlocked, owner)
                inst:RemoveEventCallback("attacked", OnBlocked, owner)

                owner:RemoveEventCallback("changearea", onsandstorm)
                inst:StopWatchingWorldState("israining", onisraining)
                inst:StopWatchingWorldState("issummer", onisraining)

                if owner.components.locomotor ~= nil then
                    owner._runinsandstorm = false
                end

                OnUnequipFn(inst, owner)
            end)
            inst.components.equippable.insulated = true --设为true，就能防电

            inst.hurtsoundoverride = "dontstarve/creatures/together/antlion/sfx/break"
            inst.components.shieldlegion.armormult_success = mult_success_normal
            inst.components.shieldlegion.atkfn = function(inst, doer, attacker, data)
                OnBlocked(doer, { attacker = attacker })
                Counterattack_base(inst, doer, attacker, data, 8, 3)
            end
            inst.components.shieldlegion.atkstayingfn = function(inst, doer, attacker, data)
                inst.components.shieldlegion:Counterattack(doer, attacker, data, 8, 1.5)
            end
            -- inst.components.shieldlegion.atkfailfn = function(inst, doer, attacker, data) end

            inst.components.weapon:SetDamage(damage_normal)

            inst.components.armor:InitCondition(1050, absorb_normal) --150*10*0.7= 1050防具耐久
            SetNoBrokenArmor(inst, function(armorcpt, isbrokenbefore)
                if armorcpt.condition <= 0 then
                    inst:AddTag("repair_sand")
                    inst.components.equippable.insulated = false
                    inst.components.weapon:SetDamage(damage_broken)
                    inst.components.armor:SetAbsorption(absorb_broken)
                else
                    if armorcpt.condition >= armorcpt.maxcondition then
                        inst:RemoveTag("repair_sand")
                    else
                        inst:AddTag("repair_sand")
                    end
                    if isbrokenbefore then --说明是刚从损坏状态变成修复状态
                        inst.components.equippable.insulated = true
                        onisraining(inst)
                    end
                end
            end)

            inst.components.skinedlegion:SetOnPreLoad()
        end,
    })
end

--------------------
--------------------

return unpack(prefs)
