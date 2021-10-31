local function GetPriority(list)
    local length = 0
    for k,v in pairs(list) do
        length = length + 1
    end
    return length
end

local function UnequipItem(player, slot)
    if slot ~= nil then
        local tool = player.components.inventory:GetEquippedItem(slot)
        if tool ~= nil then
            --inventory.GiveItem自带能否放进物品栏的控制
            player.components.inventory:GiveItem(player.components.inventory:Unequip(slot))
        end
    end
end

local BODYTALL = "body_t"

local DressUp = Class(function(self, inst)
    self.inst = inst
    self.itemlist =
    {
        -- body = { item = nil, swaps = {结构与self.swaplist相同}, priority = 0 },
    }
    self.swaplist =
    {
        -- swap_object =
        -- {
        --     buildskin = nil,
        --     buildfile = nil,
        --     buildsymbol = nil,
        --     guid = nil,
        --     type = nil, --clear、swap、show、hide
        --     priority = 0,
        -- }
    }
end)



function DressUp:GetDressData(buildskin, buildfile, buildsymbol, guid, type)
    return {
        buildskin = buildskin,
        buildfile = buildfile,
        buildsymbol = buildsymbol,
        guid = guid,
        type = type,
        priority = 0, --默认最高优先度，后面才更新
    }
end

function DressUp:SetDressTop(itemswap)
    itemswap["HAT"] = self:GetDressData(nil, nil, nil, nil, "show")
    itemswap["HAIR_HAT"] = self:GetDressData(nil, nil, nil, nil, "show")
    itemswap["HAIR_NOHAT"] = self:GetDressData(nil, nil, nil, nil, "hide")
    itemswap["HAIR"] = self:GetDressData(nil, nil, nil, nil, "hide")

    itemswap["HEAD"] = self:GetDressData(nil, nil, nil, nil, "hide")
    itemswap["HEAD_HAT"] = self:GetDressData(nil, nil, nil, nil, "show")
end

function DressUp:SetDressOpenTop(itemswap)
    itemswap["HAT"] = self:GetDressData(nil, nil, nil, nil, "show")
    itemswap["HAIR_HAT"] = self:GetDressData(nil, nil, nil, nil, "hide")
    itemswap["HAIR_NOHAT"] = self:GetDressData(nil, nil, nil, nil, "show")
    itemswap["HAIR"] = self:GetDressData(nil, nil, nil, nil, "show")

    itemswap["HEAD"] = self:GetDressData(nil, nil, nil, nil, "show")
    itemswap["HEAD_HAT"] = self:GetDressData(nil, nil, nil, nil, "hide")
end

function DressUp:GetDressSlot(item, data)
    if data.dressslot ~= nil then
        return data.dressslot
    elseif data.istallbody then
        return BODYTALL
    elseif item.components.equippable ~= nil then
        return item.components.equippable.equipslot
    else
        return nil
    end
end

-----

function DressUp:InitClear(symbol) --恢复实际展示的默认效果（清除）
    if self.swaplist[symbol] ~= nil then --该通道有幻化数据的话，就不恢复
        return
    end
    self.inst.AnimState:ClearOverrideSymbol(symbol)
end

function DressUp:InitHide(symbol) --恢复实际展示的默认效果（隐藏）
    if self.swaplist[symbol] ~= nil then
        return
    end
    self.inst.AnimState:Hide(symbol)
end

function DressUp:InitShow(symbol) --恢复实际展示的默认效果（显示）
    if self.swaplist[symbol] ~= nil then
        return
    end
    self.inst.AnimState:Show(symbol)
end

-----

function DressUp:UpdateReal() --更新实际展示效果
    for k,v in pairs(self.swaplist) do
        if v ~= nil then
            if v.type == "swap" then
                if v.buildskin ~= nil then
                    self.inst.AnimState:OverrideItemSkinSymbol(k, v.buildskin, v.buildsymbol, v.guid, v.buildfile)
                else
                    self.inst.AnimState:OverrideSymbol(k, v.buildfile, v.buildsymbol)
                end
            elseif v.type == "show" then
                self.inst.AnimState:Show(k)
            elseif v.type == "hide" then
                self.inst.AnimState:Hide(k)
            elseif v.type == "clear" then
                self.inst.AnimState:ClearOverrideSymbol(k)
            end
        end
    end
end

function DressUp:UpdateSwapList() --更新幻化表
    self.swaplist = {}
    for slot,itemdata in pairs(self.itemlist) do
        if itemdata ~= nil and itemdata.swaps ~= nil then
            for k,v in pairs(itemdata.swaps) do
                if v ~= nil then
                    v.priority = itemdata.priority or 0
                    if self.swaplist[k] == nil then
                        self.swaplist[k] = v
                    else
                        local priorityold = self.swaplist[k].priority or 0
                        if v.priority >= priorityold then --保存优先级数值大的那个
                            self.swaplist[k] = v
                        end
                    end
                end
            end
        end
    end
end

function DressUp:PutOn(item) --幻化一个物品
    local data = DRESSUP_DATA_LEGION[item.prefab]
    if data == nil then
        return false
    end

    local slot = self:GetDressSlot(item, data)
    if slot == nil then
        return false
    end

    --妥善隐藏装备
    if item.brain ~= nil and not item.brain.stopped then --停掉脑子
        item.brain:Stop()
    end
    if item.components.burnable ~= nil then --灭掉火源
        if item.components.burnable:IsBurning() then
            item.components.burnable:Extinguish(true, TUNING.FIRESUPPRESSOR_EXTINGUISH_HEAT_PERCENT)
        elseif item.components.burnable:IsSmoldering() then
            item.components.burnable:Extinguish(true)
        end
    end
    if item.components.container ~= nil then --背包的话需要丢弃全部物品
        item.components.container:DropEverything()
        item.components.container:Close()
        -- item.components.container.canbeopened = false --不要管是否能打开，免得让不能打开的容器在幻化解除后能打开了
    end
    self.inst:AddChild(item)
    item.Transform:SetPosition(0,0,0)
    item:RemoveFromScene()
    if item.components.fueled ~= nil then --停止耐久消耗
        item.components.fueled:StopConsuming()
    end
    if item.components.perishable ~= nil then --停止腐烂
        item.components.perishable:StopPerishing()
    end

    --删除幻化数据
    local itemdataold = nil
    if self.itemlist[slot] ~= nil then
        itemdataold = self.itemlist[slot]
        self.itemlist[slot] = nil

        --因为有数据删了，需要将优先级再次连续起来
        for slot,itemdata in pairs(self.itemlist) do
            if itemdata.priority > itemdataold.priority then
                itemdata.priority = itemdata.priority - 1
                for k,v in pairs(itemdata.swaps) do
                    v.priority = itemdata.priority
                end
            end
        end
    end

    --增加幻化数据
    local itemswap = {}
    local buildskin = (not data.isnoskin) and item:GetSkinBuild() or nil
    if data.buildfn ~= nil then
        itemswap = data.buildfn(self, item, buildskin)
    else
        if slot == EQUIPSLOTS.HANDS then
            if data.iswhip then
                itemswap["swap_object"] = self:GetDressData(buildskin, data.buildfile, data.buildsymbol, item.GUID, "swap")
                itemswap["whipline"] = self:GetDressData(buildskin, data.buildfile, "whipline", item.GUID, "swap")
            else
                itemswap["swap_object"] = self:GetDressData(buildskin, data.buildfile, data.buildsymbol, item.GUID, "swap")
                itemswap["whipline"] = self:GetDressData(nil, nil, nil, nil, "clear")
            end
            itemswap["lantern_overlay"] = self:GetDressData(nil, nil, nil, nil, "clear")
            --手臂的隐藏与显示不需要操作，因为需要跟随实际装备状态
        elseif slot == EQUIPSLOTS.HEAD then
            itemswap["swap_hat"] = self:GetDressData(buildskin, data.buildfile, data.buildsymbol, item.GUID, "swap")
            if data.isopentop then
                self:SetDressOpenTop(itemswap)
            else
                self:SetDressTop(itemswap)
            end
        elseif slot == EQUIPSLOTS.BODY or slot == EQUIPSLOTS.BACK or slot == EQUIPSLOTS.NECK then
            if data.isbackpack then
                itemswap["backpack"] = self:GetDressData(buildskin, data.buildfile, "backpack", item.GUID, "swap")
                itemswap["swap_body"] = self:GetDressData(buildskin, data.buildfile, "swap_body", item.GUID, "swap")
            else
                itemswap["swap_body"] = self:GetDressData(buildskin, data.buildfile, data.buildsymbol, item.GUID, "swap")
                itemswap["backpack"] = self:GetDressData(nil, nil, nil, nil, "clear")
            end
        elseif slot == BODYTALL then
            itemswap["swap_body_tall"] = self:GetDressData(buildskin, data.buildfile, data.buildsymbol, item.GUID, "swap")
        end
    end

    local prioritynew = GetPriority(self.itemlist)
    self.itemlist[slot] = { item = item, swaps = itemswap or {}, priority = prioritynew }

    if data.equipfn ~= nil then
        data.equipfn(self.inst, item)
    end

    self:UpdateSwapList()
    self:TakeOff(slot, itemdataold)
    self:UpdateReal()

    return true
end

function DressUp:TakeOff(slot, itemdata)  --去幻某个装备栏的装备
    if itemdata ~= nil and itemdata.item ~= nil then
        local item = itemdata.item

        self.inst:RemoveChild(item)

        local data = DRESSUP_DATA_LEGION[item.prefab]

        --初始化贴图状态
        if data ~= nil and data.unbuildfn ~= nil then
            data.unbuildfn(self, item)
        else
            if slot == EQUIPSLOTS.HANDS then
                self:InitClear("swap_object")
                self:InitClear("whipline")
                self:InitClear("lantern_overlay")
                self:InitHide("LANTERN_OVERLAY")
            elseif slot == EQUIPSLOTS.HEAD then
                self:InitClear("swap_hat")
                self:InitHide("HAT")
                self:InitHide("HAIR_HAT")
                self:InitShow("HAIR_NOHAT")
                self:InitShow("HAIR")

                self:InitShow("HEAD")
                self:InitHide("HEAD_HAT")
            elseif slot == EQUIPSLOTS.BODY or slot == EQUIPSLOTS.BACK or slot == EQUIPSLOTS.NECK then
                self:InitClear("swap_body")
                self:InitClear("backpack")
            elseif slot == BODYTALL then
                self:InitClear("swap_body_tall")
            end
        end

        if data ~= nil and data.unequipfn ~= nil then
            data.unequipfn(self.inst, item)
        end

        --归还幻化装备
        if item.components.perishable ~= nil then
            item.components.perishable:StartPerishing()
        end
        item:ReturnToScene()
        item.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
        if item.components.inventoryitem ~= nil then
            -- item.components.inventoryitem:OnDropped(true)
            self.inst.components.inventory:GiveItem(item)
        end
        if item.brain ~= nil and item.brain.stopped then
            item.brain:Start()
        end
    end
end

function DressUp:TakeOffAll()   --清除所有幻化效果
    self.swaplist = {}
    for k,v in pairs(self.itemlist) do
        if v ~= nil then
            self:TakeOff(k, v)

            --卸下对应装备槽的装备，这样的话，就不用手动还原装备的贴图了
            if k == BODYTALL or k == EQUIPSLOTS.BODY then
                UnequipItem(self.inst, EQUIPSLOTS.BACK)
                UnequipItem(self.inst, EQUIPSLOTS.NECK)
                UnequipItem(self.inst, EQUIPSLOTS.BODY)
            else
                UnequipItem(self.inst, k)
            end
        end
    end
    self.itemlist = {}
end

function DressUp:OnSave()
    local data = { items = {} }
    local refs = {}

    for k,v in pairs(self.itemlist) do
        if v ~= nil and v.item ~= nil then
            data.items[k] = v.item:GetSaveRecord()
            table.insert(refs, v.item.GUID)
        end
    end

    return data, refs
end

function DressUp:OnLoad(data, newents)
    if data ~= nil and data.items ~= nil then
        for k, v in pairs(data.items) do
            local item = SpawnSaveRecord(v, newents)
            if item ~= nil then
                self:PutOn(item)
            end
        end
    end
end

return DressUp
