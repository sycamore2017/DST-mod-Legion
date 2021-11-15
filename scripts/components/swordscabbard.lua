local SwordScabbard = Class(function(self, inst)
    self.inst = inst
    self.child = nil
end)

function SwordScabbard:Merge(sword)
    self.child = sword
    self.inst:AddChild(sword)
    sword.Transform:SetPosition(0,0,0)
    sword:RemoveFromScene()

    if sword.components.perishable ~= nil then --永久保鲜
        sword.components.perishable:StopPerishing()

        -- self.inst:AddComponent("perishable")
        -- self.inst.components.perishable:SetOnPerishFn(function(inst)
        --     inst.components.swordscabbard:BreakUp()
        -- end)
        -- self.inst.components.perishable.perishtime = sword.components.perishable.perishtime
        -- self.inst.components.perishable.perishremainingtime = sword.components.perishable.perishremainingtime
        -- self.inst.components.perishable:SetLocalMultiplier(0.1)
        -- self.inst.components.perishable:StartPerishing()
        -- self.inst:AddTag("show_spoilage")
    elseif --能恢复永不凋零的耐久
        sword.prefab == "neverfade" and sword.OnScabbardRecoveredFn ~= nil and sword.task_recover == nil and
        sword.components.finiteuses ~= nil and sword.components.finiteuses:GetPercent() < 1
    then
        sword.task_recover = sword:DoPeriodicTask(6, sword.OnScabbardRecoveredFn, 6) --大概三天多一点的时间就能完全恢复
    end

    local skindata = sword.components.skinedlegion ~= nil and sword.components.skinedlegion:GetSkinedData() or nil
    if skindata ~= nil and skindata.scabbard ~= nil then
        self.inst.components.inventoryitem.atlasname = skindata.scabbard.atlas
        self.inst.components.inventoryitem:ChangeImageName(skindata.scabbard.image)
        self.inst.AnimState:SetBank(skindata.scabbard.bank)
        self.inst.AnimState:SetBuild(skindata.scabbard.build)
        self.inst.AnimState:PlayAnimation(skindata.scabbard.anim)
    else
        self.inst.components.inventoryitem.atlasname = "images/inventoryimages/foliageath_"..sword.prefab..".xml"
        self.inst.components.inventoryitem:ChangeImageName("foliageath_"..sword.prefab)
        self.inst.AnimState:PlayAnimation(sword.prefab)
    end

    self.inst:AddTag("swordscabbardcouple")
end

function SwordScabbard:BeTogether(beforeinst, sword)
    self:Merge(sword)

    local container = beforeinst.components.inventoryitem:GetContainer()
    if container ~= nil then
        local slot = beforeinst.components.inventoryitem:GetSlotNum()
        beforeinst:Remove() --把青枝绿叶删除
        container:GiveItem(self.inst, slot)
    else
        local x, y, z = beforeinst.Transform:GetWorldPosition()
        beforeinst:Remove()
        self.inst.Transform:SetPosition(x, y, z)
    end
    self.inst.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
end

local function SetPos(inst, x, y, z)
    if inst.Physics ~= nil then
        inst.Physics:Teleport(x, y, z)
    else
        inst.Transform:SetPosition(x, y, z)
    end
end
function SwordScabbard:BreakUp(player)
    if player == nil or player.components.inventory == nil then
        return false
    end

    local sword = self.child
    self.inst:RemoveChild(self.child)
    self.child:ReturnToScene()
    self.child = nil

    if sword.components.perishable ~= nil then
        -- sword.components.perishable.perishremainingtime = self.inst.components.perishable.perishremainingtime
        sword.components.perishable:StartPerishing()
    elseif sword.prefab == "neverfade" and sword.task_recover ~= nil then
        sword.task_recover:Cancel()
        sword.task_recover = nil
    end

    local foliageath = SpawnPrefab("foliageath")
    local container = self.inst.components.inventoryitem:GetContainer()
    if container ~= nil then
        local x, y, z = player.Transform:GetWorldPosition()
        local slot = self.inst.components.inventoryitem:GetSlotNum()
        -- local player = self.inst.components.inventoryitem:GetGrandOwner()
        self.inst:Remove()
        if not container:GiveItem(foliageath, slot) and not player.components.inventory:GiveItem(foliageath) then
            SetPos(foliageath, x, y, z) --没成功就直接设置位置
        end

        --将剑直接装在手上
        if
            sword.components.equippable ~= nil and player:HasTag("player")
            -- and (self.inst.components.perishable == nil or self.inst.components.perishable.perishremainingtime > 0)
        then
            if not player.components.inventory:Equip(sword) and not player.components.inventory:GiveItem(sword) then
                SetPos(sword, x, y, z)
            end
        else
            if not container:GiveItem(sword) and not player.components.inventory:GiveItem(sword) then
                SetPos(sword, x, y, z)
            end
        end
    else
        local x, y, z = self.inst.Transform:GetWorldPosition()
        self.inst:Remove()
        SetPos(foliageath, x, y, z)

        --将剑直接装在手上
        if
            player:HasTag("player")
            -- and (self.inst.components.perishable == nil or self.inst.components.perishable.perishremainingtime > 0)
        then
            if sword.components.equippable == nil or not player.components.inventory:Equip(sword) then
                if not player.components.inventory:GiveItem(sword) then
                    SetPos(sword, x, y, z)
                end
            end
        else
            if not player.components.inventory:GiveItem(sword) then
                SetPos(sword, x, y, z)
            end
        end
    end
end

function SwordScabbard:OnSave()
    local data = {}
    local refs = {}

    if self.child ~= nil then
        data.child = self.child:GetSaveRecord()
        data.childid = self.child.GUID
        refs = { data.childid }

        -- if self.inst.components.perishable ~= nil then
        --     -- data.perishtime = self.inst.components.perishable.perishtime
        --     data.time = self.inst.components.perishable.perishremainingtime
        --     data.paused = self.inst.components.perishable.updatetask == nil or nil
        -- end
    end

    return data, refs
end

function SwordScabbard:OnLoad(data, newents)
    if data.child ~= nil then
        local child = SpawnSaveRecord(data.child, newents)
        if child ~= nil then
            -- if child.components.perishable ~= nil then
            --     child.components.perishable:OnLoad(data)
            -- end
            self:Merge(child)
            -- if self.inst.components.perishable ~= nil then
            --     self.inst.components.perishable:OnLoad(data)
            -- end
        end
    end
end

return SwordScabbard
