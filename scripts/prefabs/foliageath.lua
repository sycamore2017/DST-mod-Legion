local assets =
{
    Asset("ANIM", "anim/foliageath.zip"),
    Asset("ATLAS", "images/inventoryimages/foliageath.xml"),
    Asset("IMAGE", "images/inventoryimages/foliageath.tex"),
}

local prefabs =
{
    "foliageath_together",
    "foliageath_mylove",
}

local function ItemTradeTest(inst, item)
    local tradeableSwords = {
        rosorns = true,
        lileaves = true,
        orchitwigs = true,
        neverfade = true,
        hambat = true,
        bullkelp_root = true,
        foliageath = true,
    }
    if item == nil then
        return false
    elseif not tradeableSwords[item.prefab] then
        return false, "WRONGSWORD"
    end
    return true
end

local function OnSwordGiven(inst, giver, item)
    if item ~= nil then
        if item.prefab == "foliageath" and giver ~= nil and giver.components.talker ~= nil then
            giver.components.talker:Say(GetString(giver, "ANNOUNCE_HIS_LOVE_WISH"))
        end

        local togethered = SpawnPrefab(item.prefab == "foliageath" and "foliageath_mylove" or "foliageath_together")
        togethered.components.swordscabbard:BeTogether(inst, item)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    -- inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("foliageath")
    inst.AnimState:SetBuild("foliageath")
    inst.AnimState:PlayAnimation("lonely")

    inst:AddTag("swordscabbard")

    --trader (from trader component) added to pristine state for optimization
    inst:AddTag("trader")

    MakeInventoryFloatable(inst, "small", 0.4, 0.5)
    local OnLandedClient_old = inst.components.floater.OnLandedClient
    inst.components.floater.OnLandedClient = function(self)
        OnLandedClient_old(self)
        self.inst.AnimState:SetFloatParams(0.15, 1, 0.1)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "foliageath"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/foliageath.xml"

    inst:AddComponent("trader")
    inst.components.trader:SetAbleToAcceptTest(ItemTradeTest)
    inst.components.trader.onaccept = OnSwordGiven
    inst.components.trader.deleteitemonaccept = false --交易时不自动删除
    inst.components.trader.acceptnontradable = true --可以交易无交易组件的物品

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    MakeHauntableLaunch(inst)

    return inst
end

----------------------------
----------------------------

local assets_together =
{
    Asset("ANIM", "anim/foliageath.zip"),
    Asset("ATLAS", "images/inventoryimages/foliageath_rosorns.xml"),
    Asset("IMAGE", "images/inventoryimages/foliageath_rosorns.tex"),
    Asset("ATLAS", "images/inventoryimages/foliageath_lileaves.xml"),
    Asset("IMAGE", "images/inventoryimages/foliageath_lileaves.tex"),
    Asset("ATLAS", "images/inventoryimages/foliageath_orchitwigs.xml"),
    Asset("IMAGE", "images/inventoryimages/foliageath_orchitwigs.tex"),
    Asset("ATLAS", "images/inventoryimages/foliageath_neverfade.xml"),
    Asset("IMAGE", "images/inventoryimages/foliageath_neverfade.tex"),
    Asset("ATLAS", "images/inventoryimages/foliageath_hambat.xml"),
    Asset("IMAGE", "images/inventoryimages/foliageath_hambat.tex"),
    Asset("ATLAS", "images/inventoryimages/foliageath_bullkelp_root.xml"),
    Asset("IMAGE", "images/inventoryimages/foliageath_bullkelp_root.tex"),
    Asset("ATLAS", "images/inventoryimages/foliageath_foliageath.xml"),
    Asset("IMAGE", "images/inventoryimages/foliageath_foliageath.tex"),
}

local prefabs_together =
{
    "foliageath",
}

local function MakeIt(name, ismylove)
    local function fn_together()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("foliageath")
        inst.AnimState:SetBuild("foliageath")
        inst.AnimState:PlayAnimation("lonely")

        if ismylove then
            inst:AddTag("feelmylove")
        else
            inst:SetPrefabNameOverride("foliageath")
        end

        MakeInventoryFloatable(inst, "small", 0.4, 0.5)
        local OnLandedClient_old = inst.components.floater.OnLandedClient
        inst.components.floater.OnLandedClient = function(self)
            OnLandedClient_old(self)
            self.inst.AnimState:SetFloatParams(0.15, 1, 0.1)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")

        if not ismylove then
            inst.components.inspectable.getstatus = function(inst)
                return "MERGED"
            end
        end

        inst:AddComponent("swordscabbard")

        MakeHauntableLaunch(inst)

        return inst
    end

    return Prefab(name, fn_together, assets_together, prefabs_together)
end

----------------------------

return Prefab("foliageath", fn, assets, prefabs),
    MakeIt("foliageath_together", false),
    MakeIt("foliageath_mylove", true)
