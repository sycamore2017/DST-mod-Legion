local DressUp = Class(function(self, inst)
    self.inst = inst
    self.itemlist =
    {
        -- body = item,
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
    }
end

function DressUp:GetDressSlot(item, data)
    if item.components.equippable ~= nil then
        return item.components.equippable.equipslot
    elseif data.dressslot ~= nil then
        return data.dressslot
    else
        return nil
    end
end

function DressUp:AddSwap(item, data) --增加幻化数据
    local buildskin = (not data.isnoskin) and item:GetSkinBuild() or nil

    if data.buildfn ~= nil then
        data.buildfn(self, item, buildskin)
    else
        local slot = self:GetDressSlot(item, data)
        if slot == EQUIPSLOTS.HANDS then
            if data.iswhip then
                self.swaplist["swap_object"] = self:GetDressData(buildskin, data.buildfile, data.buildsymbol, item.GUID, "swap")
                self.swaplist["whipline"] = self:GetDressData(buildskin, data.buildfile, "whipline", item.GUID, "swap")
            else
                self.swaplist["swap_object"] = self:GetDressData(buildskin, data.buildfile, data.buildsymbol, item.GUID, "swap")
                self.swaplist["whipline"] = self:GetDressData(nil, nil, nil, nil, "clear")
            end
            self.swaplist["lantern_overlay"] = self:GetDressData(nil, nil, nil, nil, "clear")
            --手臂的隐藏与显示不需要操作，因为需要跟随实际装备状态
        elseif slot == EQUIPSLOTS.HEAD then
            self.swaplist["swap_hat"] = self:GetDressData(buildskin, data.buildfile, data.buildsymbol, item.GUID, "swap")
            if data.isopentop then
                self.swaplist["HAT"] = self:GetDressData(nil, nil, nil, nil, "show")
                self.swaplist["HAIR_HAT"] = self:GetDressData(nil, nil, nil, nil, "hide")
                self.swaplist["HAIR_NOHAT"] = self:GetDressData(nil, nil, nil, nil, "show")
                self.swaplist["HAIR"] = self:GetDressData(nil, nil, nil, nil, "show")

                self.swaplist["HEAD"] = self:GetDressData(nil, nil, nil, nil, "show")
                self.swaplist["HEAD_HAT"] = self:GetDressData(nil, nil, nil, nil, "hide")
            else
                self.swaplist["HAT"] = self:GetDressData(nil, nil, nil, nil, "show")
                self.swaplist["HAIR_HAT"] = self:GetDressData(nil, nil, nil, nil, "show")
                self.swaplist["HAIR_NOHAT"] = self:GetDressData(nil, nil, nil, nil, "hide")
                self.swaplist["HAIR"] = self:GetDressData(nil, nil, nil, nil, "hide")

                self.swaplist["HEAD"] = self:GetDressData(nil, nil, nil, nil, "hide")
                self.swaplist["HEAD_HAT"] = self:GetDressData(nil, nil, nil, nil, "show")
            end
        elseif slot == EQUIPSLOTS.BODY or slot == EQUIPSLOTS.BACK or slot == EQUIPSLOTS.NECK then
            if data.istallbody then
                self.swaplist["swap_body_tall"] = self:GetDressData(buildskin, data.buildfile, data.buildsymbol, item.GUID, "swap")
                self.swaplist["backpack"] = self:GetDressData(nil, nil, nil, nil, "clear")
                self.swaplist["swap_body"] = self:GetDressData(nil, nil, nil, nil, "clear")
            elseif data.isbackpack then
                self.swaplist["backpack"] = self:GetDressData(buildskin, data.buildfile, "backpack", item.GUID, "swap")
                self.swaplist["swap_body"] = self:GetDressData(buildskin, data.buildfile, "swap_body", item.GUID, "swap")
                self.swaplist["swap_body_tall"] = self:GetDressData(nil, nil, nil, nil, "clear")
            else
                self.swaplist["swap_body"] = self:GetDressData(buildskin, data.buildfile, data.buildsymbol, item.GUID, "swap")
                self.swaplist["backpack"] = self:GetDressData(nil, nil, nil, nil, "clear")
                self.swaplist["swap_body_tall"] = self:GetDressData(nil, nil, nil, nil, "clear")
            end
        end
    end
end

function DressUp:RemoveSwap(item, data) --删除幻化数据
    if data.unbuildfn ~= nil then
        data.unbuildfn(self, item)
    else
        local slot = self:GetDressSlot(item, data)
        if slot == EQUIPSLOTS.HANDS then
            self.swaplist["swap_object"] = nil
            self.swaplist["whipline"] = nil
            self.swaplist["lantern_overlay"] = nil
        elseif slot == EQUIPSLOTS.HEAD then
            self.swaplist["swap_hat"] = nil
            self.swaplist["HAT"] = nil
            self.swaplist["HAIR_HAT"] = nil
            self.swaplist["HAIR_NOHAT"] = nil
            self.swaplist["HAIR"] = nil

            self.swaplist["HEAD"] = nil
            self.swaplist["HEAD_HAT"] = nil
        elseif slot == EQUIPSLOTS.BODY or slot == EQUIPSLOTS.BACK or slot == EQUIPSLOTS.NECK then
            self.swaplist["swap_body_tall"] = nil
            self.swaplist["backpack"] = nil
            self.swaplist["swap_body"] = nil
        end
    end
end

function DressUp:UpdateReal() --更新幻化的实际展示效果
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

    --归还以前的幻化装备
    self:TakeOff(slot, false)

    --增加幻化数据
    self.itemlist[slot] = item
    self:AddSwap(item, data)
    if data.equipfn ~= nil then
        data.equipfn(self.inst, item)
    end
    self:UpdateReal()

    return true
end

function DressUp:TakeOff(slot, needReal)  --去幻某个装备栏的装备
    if self.itemlist[slot] ~= nil then
        local item = self.itemlist[slot]
        self.itemlist[slot] = nil
        self.inst:RemoveChild(item)

        local data = DRESSUP_DATA_LEGION[item.prefab]
        if data ~= nil then
            self:RemoveSwap(item, data)
            if data.unequipfn ~= nil then
                data.unequipfn(self.inst, item)
            end
        end

        --归还幻化装备
        if item.components.perishable ~= nil then
            item.components.perishable:StartPerishing()
        end
        item:ReturnToScene()
        item.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
        if item.components.inventoryitem ~= nil then
            item.components.inventoryitem:OnDropped(true)
        end
        if item.brain ~= nil and item.brain.stopped then
            item.brain:Start()
        end

        if needReal then
            local tool = self.inst.components.inventory:GetEquippedItem(slot)
            if tool ~= nil then --掉落对应装备槽的装备，这样的话，就不用手动还原了
                self.inst.components.inventory:GiveItem(self.inst.components.inventory:Unequip(slot))
            else --如果没有该装备栏的装备，就只能强制全部清除了
                if slot == EQUIPSLOTS.HANDS then
                    self.inst.AnimState:ClearOverrideSymbol("swap_object")
                    self.inst.AnimState:ClearOverrideSymbol("whipline")
                    self.inst.AnimState:ClearOverrideSymbol("lantern_overlay")
                    self.inst.AnimState:Hide("LANTERN_OVERLAY")
                elseif slot == EQUIPSLOTS.HEAD then
                    self.inst.AnimState:ClearOverrideSymbol("swap_hat")
                    self.inst.AnimState:Hide("HAT")
                    self.inst.AnimState:Hide("HAIR_HAT")
                    self.inst.AnimState:Show("HAIR_NOHAT")
                    self.inst.AnimState:Show("HAIR")

                    self.inst.AnimState:Show("HEAD")
                    self.inst.AnimState:Hide("HEAD_HAT")
                elseif slot == EQUIPSLOTS.BODY or slot == EQUIPSLOTS.BACK or slot == EQUIPSLOTS.NECK then
                    self.inst.AnimState:ClearOverrideSymbol("swap_body_tall")
                    self.inst.AnimState:ClearOverrideSymbol("swap_body")
                    self.inst.AnimState:ClearOverrideSymbol("backpack")
                end
            end
        end
    end
end

function DressUp:TakeOffAll()   --清除所有幻化效果
    self.swaplist = {}
    for k,v in pairs(self.itemlist) do
        self:TakeOff(k, true)
    end
end

function DressUp:OnSave()
    local data = { items= {} }
    local refs = {}

    for k,v in pairs(self.itemlist) do
        if v ~= nil then
            data.items[k] = v:GetSaveRecord()
            table.insert(refs, v.GUID)
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
