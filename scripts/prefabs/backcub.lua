local assets =
{
    Asset("ANIM", "anim/backcub.zip"),
    Asset("ANIM", "anim/swap_backcub.zip"),
    Asset("ATLAS", "images/inventoryimages/backcub.xml"),
    Asset("IMAGE", "images/inventoryimages/backcub.tex"),
}

local prefabs =
{
    "cookedsmallmeat",
    "furtuft",
}

local function toground(inst)
    inst.AnimState:PlayAnimation("anim", true)

    if inst.SoundEmitter then
        if inst.soundtask == nil then
            inst.soundtask = inst:DoPeriodicTask(4, function()
                inst.SoundEmitter:KillSound("sleep")
                inst.SoundEmitter:PlaySound("dontstarve/creatures/monkey/sleep", "sleep")
            end, 0)
        end
    end
end

local function onequip(inst, owner)
    if owner.prefab == "webber" then
        owner.AnimState:OverrideSymbol("swap_body_tall", "swap_backcub", "swap_body")
    else
        owner.AnimState:OverrideSymbol("swap_body", "swap_backcub", "swap_body")
    end

    if inst.components.container ~= nil then
        inst.components.container:Open(owner)

        if inst.eattask == nil then
            inst.eattask = inst:DoPeriodicTask(60, function()
                if math.random() < 0.7 then
                    local finalitem = nil

                    inst.components.container:FindItem(function(item)
                        --只吃有新鲜度、食用组件的东西，防止吃掉糖豆、蜂巢、猪皮、眼球等
                        if item.components.edible ~= nil and item.components.perishable ~= nil then
                            if item:HasTag("honeyed") then --带蜂蜜标签的食物优先度更高
                                finalitem = item
                                return true
                            elseif finalitem == nil then --没有赋值过的才能赋值
                                finalitem = item
                                --这里不返回是为了在没找到蜂蜜类食物前继续找下去
                            end
                        end
                        return false
                    end)

                    if finalitem ~= nil then
                        if finalitem.components.stackable ~= nil then
                            finalitem.components.stackable:Get():Remove()
                        else
                            finalitem:Remove()
                        end
                        if inst.SoundEmitter then
                            inst.SoundEmitter:PlaySound("dontstarve/HUD/feed")
                        end

                        if math.random() < 0.15 then
                            local fur = SpawnPrefab("furtuft")
                            if fur ~= nil then
                                fur.Transform:SetPosition(owner.Transform:GetWorldPosition())
                                if fur.components.inventoryitem ~= nil then
                                    fur.components.inventoryitem:OnDropped(true)
                                end
                            end
                        end
                    end
                end
            end, 30)
        end
    end

    if inst.soundtask ~= nil then
        inst.soundtask:Cancel()
        inst.soundtask = nil
    end
    if inst.SoundEmitter then
        inst.SoundEmitter:KillSound("sleep")
    end
end

local function onunequip(inst, owner)
    if owner.prefab == "webber" then
        owner.AnimState:ClearOverrideSymbol("swap_body_tall")
    else
        owner.AnimState:ClearOverrideSymbol("swap_body")
    end

    if inst.components.container ~= nil then
        inst.components.container:Close(owner)
    end

    if inst.eattask ~= nil then
        inst.eattask:Cancel()
        inst.eattask = nil
    end
end

local function onburnt(inst)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
        inst.components.container:Close()
    end

    SpawnPrefab("cookedsmallmeat").Transform:SetPosition(inst.Transform:GetWorldPosition())

    inst:Remove()
end

local function onignite(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = false
    end
end

local function onextinguish(inst)
    if inst.components.container ~= nil then
        inst.components.container.canbeopened = true
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    -- inst.Transform:SetScale(0.5, 0.5, 0.5)   --一旦这里改变动画大小，会导致火焰燃烧特效也跟着变化

    inst.AnimState:SetBank("backcub")
    inst.AnimState:SetBuild("backcub")
    -- inst.AnimState:PlayAnimation("anim_water", true) --在海难的水里就用这个动画
    inst.AnimState:PlayAnimation("anim", true)

    inst:AddTag("backpack")

    --inst.foleysound = "dontstarve/movement/foley/backpack"

    MakeInventoryFloatable(inst, "small", 0, nil, false, -9)

    local OnLandedServer_old = inst.components.floater.OnLandedServer
    inst.components.floater.OnLandedServer = function(self) --掉进海里时使用自己的动画
        if not self.showing_effect and self:ShouldShowEffect() then
            inst.AnimState:PlayAnimation("anim_water", true)
        end
        OnLandedServer_old(self)
    end
    inst.components.floater.OnLandedClient = function(self) --取消掉进海里时生成的波纹特效
        self.showing_effect = true
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("piggyback") end     --直接用官方的slot需要主客机都申明一遍
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "backcub"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/backcub.xml"
    inst.components.inventoryitem.cangoincontainer = false

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(TUNING.INSULATION_MED_LARGE)    --介于冬帽与牛帽之间的数值

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("piggyback")

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    inst.components.burnable:SetOnBurntFn(onburnt)
    inst.components.burnable:SetOnIgniteFn(onignite)
    inst.components.burnable:SetOnExtinguishFn(onextinguish)

    inst:ListenForEvent("ondropped", toground)
    toground(inst)

    -- MakeHauntableLaunchAndDropFirstItem(inst)    --不能被作祟

    return inst
end

return Prefab("backcub", fn, assets, prefabs)
