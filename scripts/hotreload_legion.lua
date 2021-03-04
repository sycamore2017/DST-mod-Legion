--环境: modmain
--发布版把下一行的注释去掉
-- do return end

--预制物

local hot = {
	--k: prefab名   v: 对应的lua文件名
	hiddenmoonlight = 'hiddenmoonlight',
	hiddenmoonlight_item = 'hiddenmoonlight',
}
local old_sp = GLOBAL.SpawnPrefab
function GLOBAL.SpawnPrefab(prefab, ...)
	if hot[prefab] then
		LoadPrefabFile('prefabs/'..hot[prefab])
	end
	return old_sp(prefab, ...)
end



--类 (组件 界面 状态图 脑)

local class = {
	--路径名
	-- 'map/static_layouts/helpercemetery_zh',
	-- 'map/static_layouts/helpercemetery',
	-- 'map/rooms/forest/rooms_desertsecret',
	-- 'hotreload_legion',
}
local old_re = GLOBAL.require
function GLOBAL.require(path)
	for _, v in pairs(class)do
		if v == path then
			package.loaded[path] = nil
			break
		end
	end
	return old_re(path)
end

