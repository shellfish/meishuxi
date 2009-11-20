local root_path = '/home/zhousiyv/桌面/trunk/service/'

--[==[
function custom_init_example(config)
	-- 1. guess the os type
	if not config.OS_TYPE then
		if os.getenv'OS' then
			config.OS_TYPE = 'Windows'
		else
			config.OS_TYPE = 'Linux'
		end
	end

	-- 2. so we get the path separator
	config.OS_PATH_SEPARATOR = config.OS_TYPE:lower() ==  'windows' and
		[[\]] or [[/]]

	config.OS_PATH_FILTER = function(path_to_convert) 
		if config.OS_PATH_SEPARATOR == [[\]] then
			return path_to_convert:gsub([[/]], [[\]])
		else
			return path_to_convert:gsub([[\]], [[/]])
		end
	end

	-- 3. then we search wsapi_env for cgi property 
	local real_script = wsapi_env['PATH_TRANSLATED']
	local real_dir    = real_script:gsub( 
		[[^(.+]] .. config.OS_PATH_SEPARATOR   .. [[).+$]], "%1" )
	
	config.REAL_DIR_PATH = real_dir
	
	-- 4. add some lua_path to package.path
	package.path = package.path .. (function() 
		local filter = config.OS_PATH_FILTER
		return ';' .. real_dir .. filter('meishu/Lua/?.lua') ..
			';' .. real_dir .. filter('meishu/Lua/?/init.lua') ..
			';' .. real_dir .. filter('PublicLib/?.lua') ..
			';' .. real_dir .. filter('PublicLib/?/init.lua') 
	end);
	

end
--]==]

package.path = package.path  ..
	';' .. root_path .. 'meishu/Lua/?.lua' ..
	';' .. root_path .. 'meishu/Lua/?/init.lua' ..
	";" .. root_path ..  'PublicLib/?.lua' ..
	';' .. root_path .. 'PublicLib/?/init.lua'

require "tr.wsapi_app"

return	tr.wsapi_app.new{
	SHOW_STACK_TRACE = true,
	NODE_LOAD_PATH = root_path .. [[meishu/Node]],
	OS_TYPE = 'Linux',

	CUSTOM_INIT_FUNCTION = custom_init_example,
}
