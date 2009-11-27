local env = {
	-- 这是service部分得根目录
	-- 因为service和ui部分联系很少，所以分别配置
	-- 完全可以放在不同得文件系统中

	-- #TODO by user 用户需要修改此路径使其反映真实路径
	service_root =  '/home/zhousiyv/桌面/trunk/service/',

	--- 以下变量留空,system'll guess it
	-- 但在生产环境中，必须手动配置
}


--- @func guess_env
function guess_env( permmitive_env ) 
	local env = permmitive_env

	if not env.os_type then
		env.os_type = env.service_root:find([[/]]) and 'Linux' or 'Windows'

		env.delimiter = {
			real = env.os_type == 'Linux' and '/' or '\\',
			opposed  = env.os_type == 'Linux' and '\\' or '/'
		}
	end

	env.filter_path = function(path)
		return 	path:gsub(env.delimiter.opposed, env.delimiter.real)	
	end

	env.strip_path = function(path)
		return path:gsub(env.delimiter.real .. '$', '')
	end

	-- 对service_root进行截尾
	env.service_root = env.strip_path(env.service_root) 


	-- change lua_path
	local lua_path_structer = {
		'/meishu/Lua/?.lua', 
		'/meishu/Lua/?/init.lua',
		'/PublicLib/?.lua',
		'/PublicLib/?/init.lua',
	}

	(function() 
		local buf = {}
		for k, v in ipairs(lua_path_structer) do
			table.insert(buf, env.service_root .. env.filter_path(v))
		end

		package.path = package.path .. ';' .. table.concat(buf, ';')
	end)();

	return env
	
end


return  guess_env(env) 

