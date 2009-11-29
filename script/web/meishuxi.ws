---------------------------------------------------------------------------
---
-- meishuxi.ws: the service dispatcher script (wsapi content-handler)
-- Place it under a dir which acn be access by the web server
-- @release meishuxi.ws 2009年 11月 29日 星期日 14:02:18 CST
---------------------------------------------------------------------------


---------------------------------------------------------------------------
--- define global var 
local environment = {}    -- the environment that we begin to fill in. 

--------------------------------------------------------------------------
-- loading etc file
(function()

	-- first try, assume I'm at a unix-like platform.
	local	delimiter = '/'
	local service_root = '../../'
	local etc = loadfile( service_root .. 'src/config.lua')

	-- the try windows style path.
	if not etc_tab then
		service_root = [[..\..\]]
		delimiter = '\\'
		etc       = loadfile(service_root .. [[src\config.lua]])
	end

	-- validate etc file.
	assert(etc, 'cicala cannot load etc-file, crashed!')


	-- now, we known the os-delimiter 
	-- so, we build a simple path filter
	local anti_delimiter = delimiter == '/' and '\\' or '/'

	environment.path_filter = function( path ) 
		return path:gsub(anti_delimiter, delimiter)	
	end

	environment.service_root = service_root

	-- generate relative path relate to service_root
	function environment.gen_path( unix_like_relative_path )
		return environment.service_root ..  
			environment.path_filter(unix_like_relative_path)
	end

	-- now, run etc-file
	setfenv(etc, environment)()
end)();


---------------------------------------------------------------------------
--- prepare work for load cicala
local function gen_path( path_tab )
	local buffer = {}
	for k, v in ipairs( path_tab ) do
		table.insert(buffer, v)
	end

	return ';' .. table.concat(buffer, ';') 
end

if environment.MORE_LUA_PATH then
	package.path = package.path .. gen_path(environment.MORE_LUA_PATH) 
end

if environment.MORE_LUA_CPATH then
	package.cpath = package.cpath .. gen_path(environment.MORE_LUA_CPATH) 
end

require'cicala'
return cicala.wsapi_app.new( environment )
