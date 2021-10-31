local prefs = {}

--------------------------------------------------------------------------
--[[ 通用 ]]
--------------------------------------------------------------------------

local function MakeItem(data)
    local basename = "siving_ctl"..data.name
    table.insert(prefs, Prefab(
        basename.."_item",
        function()
            local inst = CreateEntity()

            inst.entity:AddTransform()
            inst.entity:AddAnimState()
            inst.entity:AddNetwork()

            MakeInventoryPhysics(inst)

            inst.AnimState:SetBank(basename)
            inst.AnimState:SetBuild(basename)
            inst.AnimState:PlayAnimation("item")

            inst.entity:SetPristine()
            if not TheWorld.ismastersim then
                return inst
            end

            inst.siv_moisture = nil
            inst.siv_nutrients = nil

            inst:AddComponent("inspectable")

            inst:AddComponent("inventoryitem")
            inst.components.inventoryitem.imagename = basename.."_item"
            inst.components.inventoryitem.atlasname = "images/inventoryimages/"..basename.."_item.xml"
            inst.components.inventoryitem:SetSinks(true)

            inst:AddComponent("deployable")
            inst.components.deployable.ondeploy = function(inst, pt, deployer)
                local tree = SpawnPrefab(basename.."_item")
                if tree ~= nil then
                    local x, y, z = pt:Get()
                    tree.Transform:SetPosition(x, y, z)
                    if deployer ~= nil and deployer.SoundEmitter ~= nil then
                        deployer.SoundEmitter:PlaySound("dontstarve/common/place_structure_stone")
                    end

                    local ents = TheSim:FindEntities(x, y, z, 21,
                        { "crop_legion" },
                        { "NOCLICK", "FX", "INLIMBO" },
                        nil
                    )
                    for _,v in pairs(ents) do
                        if v.components.perennialcrop ~= nil then
                            v.components.perennialcrop:SetManager(tree)
                        end
                    end
                    inst:Remove()
                end
            end

            MakeHauntableLaunchAndIgnite(inst)

            inst.OnSave = function(inst, data)
                if inst.siv_moisture ~= nil then
                    data.siv_moisture = inst.siv_moisture
                end
                if inst.siv_nutrients ~= nil then
                    data.siv_nutrients = inst.siv_nutrients
                end
            end
            inst.OnLoad = function(inst, data)
                if data ~= nil then
                    if data.siv_moisture ~= nil then
                        inst.siv_moisture = data.siv_moisture
                    end
                    if data.siv_nutrients ~= nil then
                        inst.siv_nutrients = data.siv_nutrients
                    end
                end
            end

            return inst
        end,
        data.assets,
        data.prefabs
    ))
    table.insert(prefs, MakePlacer(basename.."_item_placer", basename, basename, "palcer"))
end

--------------------------------------------------------------------------
--[[ 子圭·利川 ]]
--------------------------------------------------------------------------

MakeItem({
    name = "water",
    assets = {
        Asset("ANIM", "anim/siving_ctlwater.zip"),
        Asset("ATLAS", "images/inventoryimages/siving_ctlwater_item.xml"),
        Asset("IMAGE", "images/inventoryimages/siving_ctlwater_item.tex"),
    },
    prefabs = { "siving_ctlwater" },
})

--------------------------------------------------------------------------
--[[ 子圭·益矩 ]]
--------------------------------------------------------------------------

MakeItem({
    name = "dirt",
    assets = {
        Asset("ANIM", "anim/siving_ctldirt.zip"),
        Asset("ATLAS", "images/inventoryimages/siving_ctldirt_item.xml"),
        Asset("IMAGE", "images/inventoryimages/siving_ctldirt_item.tex"),
    },
    prefabs = { "siving_ctldirt" },
})

--------------------------------------------------------------------------
--[[ 子圭·崇溟 ]]
--------------------------------------------------------------------------

--all

--------------------
--------------------

return unpack(prefs)
