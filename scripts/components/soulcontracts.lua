local function onstaying(self)
    if self.staying then
        self.inst:AddTag("bookstaying")
    else
        self.inst:RemoveTag("bookstaying")
    end
end

local SoulContracts = Class(function(self, inst)
    self.inst = inst
    self.staying = true

    self._OnOwnerReroll = function(owner) --主人重选人物时，解除联系
        self:TriggerOwner(false, owner)
    end
    self._OnOwnerRemoved = function(owner) --主人实体消失时，自己也消失
        self.inst:Remove()
    end

    -- self.inst.components.follower.OnChangedLeader = function(inst, new_leader, prev_leader)
    --     if new_leader == nil then
    --         self.staying = true
    --     else
    --         self.staying = false
    --     end
    -- end
end,
nil,
{
    staying = onstaying
})

local function SetSoulFx(book, doer)
    local fx = SpawnPrefab(book._dd and book._dd.fx or "wortox_soul_in_fx")
    fx.Transform:SetPosition(doer.Transform:GetWorldPosition())
    fx:Setup(doer)
end
-- local function FindItemWithoutContainer(inst, fn)
--     local inventory = inst.components.inventory

--     for k,v in pairs(inventory.itemslots) do
--         if v and fn(v) then
--             return v
--         end
--     end
--     if inventory.activeitem and fn(inventory.activeitem) then
--         return inventory.activeitem
--     end
-- end

function SoulContracts:ReturnSouls(doer)
    if
        doer.components.inventory ~= nil and doer.components.inventory.isopen and
        self.inst.components.finiteuses ~= nil and self.inst.components.finiteuses:GetUses() > 0
    then
        local souls = doer.components.inventory:FindItems(function(item)
            return item.prefab == "wortox_soul"
        end)
        local soulscount = 0
        for i, v in ipairs(souls) do
            soulscount = soulscount +
                (v.components.stackable ~= nil and v.components.stackable:StackSize() or 1)
        end

        if soulscount >= TUNING.WORTOX_MAX_SOULS then --携带灵魂已达到上限，直接释放这个灵魂
            if self.inst._SoulHealing ~= nil then
                self.inst._SoulHealing(doer)
                self.inst.components.finiteuses:Use(1)
            end
            SetSoulFx(self.inst, doer)
        else
            soulscount = TUNING.WORTOX_MAX_SOULS - soulscount
            soulscount = math.ceil( math.min(soulscount, self.inst.components.finiteuses:GetUses()) )
            local soul = SpawnPrefab("wortox_soul")
            if soul ~= nil then
                if soulscount > 1 and soul.components.stackable ~= nil then
                    soul.components.stackable:SetStackSize(soulscount)
                end
                doer.components.inventory:GiveItem(soul, nil, doer:GetPosition())
            end
            self.inst.components.finiteuses:Use(soulscount)
        end
    end

    return true
end

function SoulContracts:TriggerOwner(dolink, doer)
    if doer == nil or not doer:HasTag("player") then
        return false, "NORIGHT"
    end
    if
        self.inst._contractsowner ~= nil and
        self.inst._contractsowner ~= doer and self.inst._contractsowner:IsValid()
    then
        return false, "NORIGHT"
    end
    if
        doer._contracts_l ~= nil and
        doer._contracts_l ~= self.inst and doer._contracts_l:IsValid()
    then
        return false, "ONLYONE"
    end
    if dolink == nil then --自动模式
        if self.inst._contractsowner ~= nil then
            dolink = false
        else
            dolink = true
        end
    end
    if dolink then --绑定
        if self.inst._contractsowner == doer then --防止重复触发
            return true
        end
        doer._contracts_l = self.inst
        self.inst._contractsowner = doer
        self.staying = false
        self.inst.persists = false
        self.inst:ListenForEvent("ms_playerreroll", self._OnOwnerReroll, doer)
        self.inst:ListenForEvent("onremove", self._OnOwnerRemoved, doer)
        if doer.components.leader ~= nil then
            doer.components.leader:RemoveFollowersByTag("soulcontracts") --清除其他所有契约的跟随
            doer.components.leader:AddFollower(self.inst)
        else
            self.inst.components.follower:SetLeader(doer)
        end
    else --解绑
        doer._contracts_l = nil
        self.inst._contractsowner = nil
        self.staying = true
        self.inst.persists = true
        self.inst:RemoveEventCallback("ms_playerreroll", self._OnOwnerReroll, doer)
        self.inst:RemoveEventCallback("onremove", self._OnOwnerRemoved, doer)
        self.inst.components.follower:StopFollowing()
        self.inst.components.locomotor:StopMoving()
    end
    SetSoulFx(self.inst, self.inst)

    return true
end

function SoulContracts:PickUp(doer)
    if doer == nil or not doer:HasTag("player") then
        return false, "NORIGHT"
    end
    if
        self.inst._contractsowner ~= nil and
        self.inst._contractsowner ~= doer and self.inst._contractsowner:IsValid()
    then
        return false, "NORIGHT"
    end
    if
        doer._contracts_l ~= nil and
        doer._contracts_l ~= self.inst and doer._contracts_l:IsValid()
    then
        return false, "ONLYONE"
    end
    doer:PushEvent("onpickupitem", { item = self.inst })
    doer.components.inventory:GiveItem(self.inst, nil, self.inst:GetPosition())
    return true
end

function SoulContracts:GiveSoul(doer, soul)
    if self.inst.components.finiteuses ~= nil then
        local finiteuses = self.inst.components.finiteuses
        if finiteuses.current >= finiteuses.total then --已经满了，直接释放一个灵魂
            if self.inst._SoulHealing ~= nil then
                self.inst._SoulHealing(doer or self.inst)
            end
            if soul.components.stackable ~= nil then
                soul.components.stackable:Get(1):Remove()
            else
                soul:Remove()
            end
        else --没有满，尝试将耐久都补满
            local needs = math.ceil(finiteuses.total - finiteuses.current)
            if soul.components.stackable ~= nil then
                local stack = soul.components.stackable:StackSize() or 1
                if needs > stack then
                    needs = stack
                end
                soul.components.stackable:Get(needs):Remove()
            else
                needs = 1
                soul:Remove()
            end
            finiteuses:Repair(needs)
        end
    end
    SetSoulFx(self.inst, doer or self.inst)

    return true
end

return SoulContracts
