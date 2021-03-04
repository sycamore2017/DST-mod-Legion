local levelScale =
{
    [1] = {x = 0.3, y = 0.3, z = 0.3},
    [2] = {x = 0.6, y = 0.6, z = 0.6},
    [3] = {x = 1.1, y = 1.1, z = 1.1},
}

local function OnAttacked(inst, data)   --被攻击时
    local self = inst.components.shockable
    if self:IsShocked() then
        --玩家就直接解除触电状态,其他生物则是随机解除
        if inst:HasTag("player") or math.random() < 0.05 then
            if self.unshocktask ~= nil then --先取消以前的任务
                self.unshocktask:Cancel()
                self.unshocktask = nil
            end

            self:Unshock()
        end
    end
end

local Shockable = Class(function(self, inst)
    self.inst = inst
    self.unshocktask = nil    --取消触电状态的延时任务
    self.shocktask = nil
    self.soundtask = nil
    self.isshocked = false    --是否处于触电状态
    self.fxdata = {x = 0, y = 0, z = 0, level = 1}
    self.staticfx = nil

    self.inst:ListenForEvent("attacked", OnAttacked)
    self.inst:AddTag("shockable")
end)

function Shockable:OnRemoveFromEntity()
    self.inst:RemoveEventCallback("attacked", OnAttacked)
    self.inst:RemoveTag("shockable")

    if self.unshocktask ~= nil then
        self.unshocktask:Cancel()
        self.unshocktask = nil
    end

    if self.staticfx ~= nil then
        self.staticfx:DoRemove()
        self.staticfx = nil
    end

    if self.soundtask ~= nil then
        self.soundtask:Cancel()
        self.soundtask = nil
    end
end

-- function Shockable:SpawnStaticFX() --添加触电状态的静电特效
--     for k, v in pairs(self.fxdata) do
--         local fx = SpawnPrefab(v.prefab)
--         if fx ~= nil then
--             if v.follow ~= nil then
--                 local follower = fx.entity:AddFollower()
--                 follower:FollowSymbol(self.inst.GUID, v.follow, v.x, v.y, v.z)
--             else
--                 self.inst:AddChild(fx)
--                 fx.Transform:SetPosition(v.x, v.y, v.z)
--             end
--             --table.insert(self.fxchildren, fx)
--             if fx.components.shatterfx ~= nil then
--                 fx.components.shatterfx:SetLevel(self.fxlevel)
--             end
--         end
--     end
-- end

function Shockable:InitStaticFx(followsymbol, offset, levelscale)  --初始化组件的触电特效属性
    self.fxdata = { x = offset.x, y = offset.y, z = offset.z, follow = followsymbol, level = levelscale }
end

function Shockable:IsShocked()  --判断是否处于触电状态
    return self.isshocked
end

local function SpawnStaticFX(self)   --生成触电特效
    local fx = SpawnPrefab("fimbul_static_fx")

    if fx ~= nil then
        local scale = levelScale[self.fxdata.level]
        fx.AnimState:SetScale(scale.x, scale.y, scale.z)

        if self.fxdata.follow ~= nil then
            fx.entity:AddFollower()
            fx.Follower:FollowSymbol(self.inst.GUID, self.fxdata.follow, self.fxdata.x, self.fxdata.y, self.fxdata.z)
        else
            self.inst:AddChild(fx)
            fx.Transform:SetPosition(self.fxdata.x, self.fxdata.y, self.fxdata.z)
        end
        self.staticfx = fx
    end
end

function Shockable:Shock(shocktime) --触电时的处理
    if self.inst.entity:IsVisible() and self.inst.components.health ~= nil and not self.inst.components.health:IsDead() then
        -- if self.onfreezefn ~= nil then
        --     self.onfreezefn(self.inst)
        -- end

        if self.unshocktask ~= nil then
            self.unshocktask:Cancel()
        end
        self.unshocktask = self.inst:DoTaskInTime(shocktime, function()
            self:Unshock()
        end)  --定时解除触电状态

        self.isshocked = true

        if self.inst:HasTag("player") then  --是玩家
            self.inst:PushEvent("beshocked")
        else                                --是怪物
            if self.inst.brain ~= nil then
                self.inst.brain:Stop()
            end

            if self.inst.components.combat ~= nil then
                self.inst.components.combat:SetTarget(nil)
            end

            if self.inst.components.locomotor ~= nil then
                self.inst.components.locomotor:Stop()
            end
        end

        if self.staticfx == nil then
            SpawnStaticFX(self)
        end

        if self.soundtask == nil then
            if self.inst.SoundEmitter ~= nil then
                self.soundtask = self.inst:DoPeriodicTask(1.8, function()
                    -- self.inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/shocked")
                    self.inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/lightninggoat/shocked_electric")
                end, 0)
            end
        end
    end
end

function Shockable:Unshock()
    if self.unshocktask ~= nil then
        self.unshocktask:Cancel()
    end
    self.unshocktask = nil

    if self:IsShocked() then
        self.isshocked = false

        --去除触电特效
        if self.staticfx ~= nil then
            self.staticfx:DoRemove()
            self.staticfx = nil
        end

        if self.soundtask ~= nil then
            self.soundtask:Cancel()
            self.soundtask = nil
        end

        if self.inst:HasTag("player") then  --是玩家
            if self.inst.components.health ~= nil and not self.inst.components.health:IsDead() then
                self.inst:PushEvent("unshocked")
            end
        else                                --是怪物
            if self.inst.brain ~= nil then
                self.inst.brain:Start()
            end

            --防止一解除触电状态马上就开始攻击
            if self.inst.components.combat ~= nil then
                self.inst.components.combat:BlankOutAttacks(0.3)
            end
        end
    end
end

function Shockable:OnSave()
end

function Shockable:OnLoad(data)
end

return Shockable
