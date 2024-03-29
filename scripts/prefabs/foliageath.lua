local assets = {
    Asset("ANIM", "anim/foliageath.zip"),
    Asset("ATLAS", "images/inventoryimages/foliageath.xml"),
    Asset("IMAGE", "images/inventoryimages/foliageath.tex"),
    Asset("ATLAS_BUILD", "images/inventoryimages/foliageath.xml", 256)
}
local prefabs = {
    "foliageath_together",
    "foliageath_mylove"
}
local foliageath_data_fol = {
    image = "foliageath_foliageath", atlas = "images/inventoryimages/foliageath_foliageath.xml",
    bank = nil, build = nil, anim = "foliageath", isloop = nil,
    togethered = "foliageath_mylove", --替换合并后的预制物名。默认不需要写，因为剑鞘本身特殊才写的
    --判断是否需要恢复耐久。第二个参数是为了识别是何种原因恢复耐久
    -- fn_recovercheck = function(inst, tag)end,
    --恢复耐久。根据 dt 这个时间参数来确定恢复的程度
    -- fn_recover = function(inst, dt, player, tag)end
}

local function OnLandedClient(self, ...)
    if self.OnLandedClient_l_base ~= nil then
        self.OnLandedClient_l_base(self, ...)
    end
    if self.floatparam_l ~= nil then
        self.inst.AnimState:SetFloatParams(self.floatparam_l, 1, self.bob_percent)
    end
end
local function SetFloatable(inst, float) --漂浮组件
    MakeInventoryFloatable(inst, float[2], float[3], float[4])
    if float[1] ~= nil then
        local floater = inst.components.floater
        floater.OnLandedClient_l_base = floater.OnLandedClient
        floater.floatparam_l = float[1]
        floater.OnLandedClient = OnLandedClient
    end
end

local function Fn_test_fol(inst, doer, item, count)
    if item == nil then
        return false, "NOSWORD"
    elseif item.foliageath_data == nil then
        return false, "WRONGSWORD"
    end
    return true
end
local function Fn_do_fol(inst, doer, item, count)
    if item ~= nil then
        -- if item.prefab == "foliageath" and giver ~= nil and giver.components.talker ~= nil then
        --     giver.components.talker:Say(GetString(giver, "ANNOUNCE_HIS_LOVE_WISH"))
        -- end
        local togethered = SpawnPrefab(item.foliageath_data.togethered or "foliageath_together")
        if togethered ~= nil then
            togethered.components.swordscabbard:BeTogether(inst, item) --inst和item会在这里面被删除
        else
            item:Remove()
        end
    end
end

local function Fn()
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
    inst:AddTag("NORATCHECK") --mod兼容：永不妥协。该道具不算鼠潮分

    SetFloatable(inst, { 0.15, "small", 0.4, 0.65 })

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then return inst end

    inst.foliageath_data = foliageath_data_fol

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "foliageath"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/foliageath.xml"

    inst:AddComponent("emptyscabbardlegion")
    inst.components.emptyscabbardlegion.fn_test = Fn_test_fol
    inst.components.emptyscabbardlegion.fn_do = Fn_do_fol

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    MakeHauntableLaunch(inst)

    return inst
end

----------------------------
----------------------------

local assets_together = {
    Asset("ANIM", "anim/foliageath.zip"),
    Asset("ATLAS", "images/inventoryimages/foliageath_rosorns.xml"),
    Asset("IMAGE", "images/inventoryimages/foliageath_rosorns.tex"),
    Asset("ATLAS_BUILD", "images/inventoryimages/foliageath_rosorns.xml", 256),
    Asset("ATLAS", "images/inventoryimages/foliageath_lileaves.xml"),
    Asset("IMAGE", "images/inventoryimages/foliageath_lileaves.tex"),
    Asset("ATLAS_BUILD", "images/inventoryimages/foliageath_lileaves.xml", 256),
    Asset("ATLAS", "images/inventoryimages/foliageath_orchitwigs.xml"),
    Asset("IMAGE", "images/inventoryimages/foliageath_orchitwigs.tex"),
    Asset("ATLAS_BUILD", "images/inventoryimages/foliageath_orchitwigs.xml", 256),
    Asset("ATLAS", "images/inventoryimages/foliageath_neverfade.xml"),
    Asset("IMAGE", "images/inventoryimages/foliageath_neverfade.tex"),
    Asset("ATLAS_BUILD", "images/inventoryimages/foliageath_neverfade.xml", 256),
    Asset("ATLAS", "images/inventoryimages/foliageath_hambat.xml"),
    Asset("IMAGE", "images/inventoryimages/foliageath_hambat.tex"),
    Asset("ATLAS_BUILD", "images/inventoryimages/foliageath_hambat.xml", 256),
    Asset("ATLAS", "images/inventoryimages/foliageath_bullkelp_root.xml"),
    Asset("IMAGE", "images/inventoryimages/foliageath_bullkelp_root.tex"),
    Asset("ATLAS_BUILD", "images/inventoryimages/foliageath_bullkelp_root.xml", 256),
    Asset("ATLAS", "images/inventoryimages/foliageath_foliageath.xml"),
    Asset("IMAGE", "images/inventoryimages/foliageath_foliageath.tex"),
    Asset("ATLAS_BUILD", "images/inventoryimages/foliageath_foliageath.xml", 256),
    Asset("ATLAS", "images/inventoryimages/foliageath_dish_tomahawksteak.xml"),
    Asset("IMAGE", "images/inventoryimages/foliageath_dish_tomahawksteak.tex"),
    Asset("ATLAS_BUILD", "images/inventoryimages/foliageath_dish_tomahawksteak.xml", 256)
}
local prefabs_together = {
    "foliageath"
}

local function GetStatus_together(inst)
    return "MERGED"
end

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

        if ismylove then
            inst.AnimState:PlayAnimation("foliageath")
            inst:AddTag("feelmylove")
        else
            inst.AnimState:PlayAnimation("hambat")
            inst:SetPrefabNameOverride("foliageath")
        end
        inst:AddTag("NORATCHECK") --mod兼容：永不妥协。该道具不算鼠潮分

        SetFloatable(inst, { 0.15, "small", 0.4, 0.65 })

        inst.entity:SetPristine()
        if not TheWorld.ismastersim then return inst end

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")

        if ismylove then
            inst.components.inventoryitem.imagename = "foliageath_foliageath"
            inst.components.inventoryitem.atlasname = "images/inventoryimages/foliageath_foliageath.xml"
        else
            inst.components.inventoryitem.imagename = "foliageath_hambat" --默认是火腿棒入鞘后的贴图
            inst.components.inventoryitem.atlasname = "images/inventoryimages/foliageath_hambat.xml"
            inst.components.inspectable.getstatus = GetStatus_together
        end

        inst:AddComponent("swordscabbard")

        MakeHauntableLaunch(inst)

        return inst
    end
    return Prefab(name, fn_together, assets_together, prefabs_together)
end

----------------------------

return Prefab("foliageath", Fn, assets, prefabs),
    MakeIt("foliageath_together", false),
    MakeIt("foliageath_mylove", true)
