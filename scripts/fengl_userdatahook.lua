--[[
    作者:风铃
    版本:1
    需要的自提
    用于hook animstate之类的userdata
]]

--调用示例1 临时hook和取消
--[[
    --需要有一键GLOBAL
    require "UserDataHook"

	local hook1 = UserDataHook.MakeHook("AnimState","SetBank",function(x,y,z) print("hook成功1",x,y,z) end)
    local hook2 = UserDataHook.MakeHook("AnimState","SetBank",function(x,y,z) print("hook成功2",x,y,z) return true end)       -返回true提前返回
    local hook3 = UserDataHook.MakeHook("AnimState","SetBank",function(x,y,z) print("hook成功3",x,y,z) end)
    UserDataHook.Hook(ThePlayer，hook1)
    UserDataHook.Hook(ThePlayer，hook2)
    UserDataHook.Hook(ThePlayer，hook3)
    ThePlayer.AnimState:SetBank("wilson")
    UserDataHook.UnHook(ThePlayer，hook2)
    ThePlayer.AnimState:SetBank("wilson")
    UserDataHook.UnHook(ThePlayer，hook1)
    UserDataHook.UnHook(ThePlayer，hook3)
]]--

--调用示例2 hookprefab  复用hook 节约内存
--[[
    --需要有一键GLOBAL
    require "UserDataHook"

	local hook1 = UserDataHook.MakeHook("AnimState","SetBank",function(x,y,z) print("hook成功1",x,y,z) end)
    AddPlayerPostInit(function(inst)
        UserDataHook.Hook(inst,hook1)
    end)
]]--

global("UserDataHook")
local currentversion = 1
if not UserDataHook then
    UserDataHook = {}
end
--检测到更高或者同版本的自动返回高版本的
if UserDataHook.version and UserDataHook.version >= currentversion then
    print("UserDataHookFind,return v",UserDataHook.version)
    return UserDataHook
end
if UserDataHook.version and UserDataHook.version < currentversion then
    print("UserDataHookUpdate",UserDataHook.version,"to",currentversion)
else
    print("UserDataHookLoad",currentversion)
end
--如果不存在则开始覆盖
UserDataHook.version = currentversion
UserDataHook.hooks = UserDataHook.hooks or {} --用于缓存已生成的镜像函数
local U = UserDataHook --本地化 提高调用时的寻址速度
function UserDataHook.OnRemove(inst)   --卸载时清理所有hook
    if inst.userdatas then
        for k,v in pairs(inst.userdatas) do
            inst[k] = v
            inst.userdatas[k]= nil
        end
        inst.userdatas = nil
    end
    if  inst.userdatahooks then
        for k,v in pairs(inst.userdatahooks) do
            inst.userdatahooks[k]= nil
        end
        inst.userdatahooks = nil
    end
end
function UserDataHook.Init(inst)
    if not inst.userdatas then  --谁初始化 谁移除
        inst.userdatas = {}
        inst.userdatahooks = {}
        inst:ListenForEvent("onremove",U.OnRemove)
    end
end

UserDataHook.meta = {__index = function(tb,k) --找不到的默认用这个表寻找
    if tb and tb.inst and tb.name then
        if U.hooks[tb.name] and U.hooks[tb.name][k] then        --有生成好的镜像函数就拿来直接用
            rawset(tb,k,U.hooks[tb.name][k])
            return U.hooks[tb.name][k]
        end
        if _G[tb.name][k] then   --找到原来的函数了
            local tbname = tb.name
            local fn = function(t,...) 
                return _G[tbname][k](t.inst.userdatas[tbname],...)
            end
            U.hooks[tb.name][k] = fn        --缓存生成的镜像函数
            rawset(tb,k,fn)                 --缓存到实体的伪userdata里
            return fn
        end
    end
end}
function UserDataHook.MakeHook(dataname,fnname,fn)
    --hook哪个userdata的哪个函数 
    --例如 MakeHook("AnimState","SetBank",fn)
    --fn 定义 参数 inst,原参数  返回 true or false,返回值     返回true停止调用 并返回返回值 否则继续自动调用下一个
    return {
        dataname = dataname,
        fnname   = fnname,
        fn = fn
    }
end

function UserDataHook.Hook(inst,hook)
    --参数  实体  hook
    if not (hook and hook.dataname and hook.fnname and hook.fn) then return end --别乱传参数
    local dataname,fnname = hook.dataname,hook.fnname
    if not (inst[dataname] and inst[dataname][fnname] )then return end --都没有 hook啥
    U.Init(inst)
    --原有的userdata放在userdatahooks里面
    if not inst.userdatahooks[dataname] or type(inst[dataname]) ~= "table" then
        inst.userdatas[dataname] = inst[dataname]       --保存原有userdata
        inst.userdatahooks[dataname] = {}               --hook表
        inst[dataname] = {inst=inst,name = dataname}    --伪userdata
        setmetatable(inst[dataname],U.meta) --设置元表 用于自动寻找原函数
    end
    if not inst.userdatahooks[dataname][fnname] then inst.userdatahooks[dataname][fnname] = {} end  --如果没有就创建函数表
    table.insert(inst.userdatahooks[dataname][fnname],hook)     --插入新的hook
    --切换成hook调用函数
    local fn
    if U.hooks[dataname] and U.hooks[dataname][fnname.."_hook"] then        --有hook调用则直接拿来用
        fn = U.hooks[dataname][fnname.."_hook"]
    else
        fn = function(t,...)        --hook链函数           --没有就重新生成
            if t and t.name and t.inst then
                local hooks = t.inst.userdatahooks[dataname][fnname] 
                if hooks then
                    for k,v in pairs(hooks) do              --遍历hook链
                        local rettable = {v.fn(t.inst,...)}
                        if rettable and rettable[1] then table.remove(rettable,1) return unpack(rettable) end        --有返回返回true 就全部返回
                    end
                    return t.inst.userdatas[dataname][fnname](t.inst.userdatas[dataname],...)       --调用官方原版函数
                end
            end
        end 
        if not U.hooks[dataname] then U.hooks[dataname] = {} end
        U.hooks[dataname][fnname.."_hook"]  = fn        --保存函数 用来复用
    end
    rawset(inst[dataname],fnname,fn)
end


function UserDataHook.UnHook(inst,hook) --取消hook
    --参数  实体  hook
    if not (hook and hook.dataname and hook.fnname and hook.fn) then return end --别乱传参数
    local dataname,fnname = hook.dataname,hook.fnname
    if not (inst[dataname] and inst[dataname][fnname] )then return end --都没有 hook啥
    if not (inst.userdatahooks[dataname] and inst.userdatahooks[dataname][fnname]) then return end  --没人hook过 不需要取消
    for k,v in pairs(inst.userdatahooks[dataname][fnname]) do
        if v == hook then
            table.remove(inst.userdatahooks[dataname][fnname],k)        --移除
            if not next(inst.userdatahooks[dataname][fnname]) then      --如果表为空 则移除hook调用函数 下次调用的时候 自动触发元表 获取源函数
                rawset(inst[dataname],fnname,nil)
            end
            return
        end
    end
end
