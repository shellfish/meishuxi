---
--- @module preload.lua: the common preload script
--- @description :it do some trival work, like change lua_path, 
--- load etc/config.lua, detect os platform, etc. 
-- @release 2009年 11月 29日 星期日 22:43:52 CS

---------------------------------------------------------------------------
--- define global var 
local environment = {}    -- the environment that we begin to fill in. 

--------------------------------------------------------------------------
-- loading etc file
(function()

	-- first try, assume I'm at a unix-like platform.
	local	delimiter = '/'
	local service_root = '../'
	local etc =  loadfile( service_root .. 'etc/config.lua') 

	-- the try windows style path.
	if not etc then
		service_root = [[..\]]
		delimiter = '\\'
		etc       = loadfile(service_root .. [[etc\config.lua]])
	end

	-- validate etc file.
	assert(etc, 'cicala cannot load etc-file, crashed!')


	-- now, we known the os-delimiter 
	-- so, we build a simple path filter
	local anti_delimiter = delimiter == '/' and '\\' or '/'

	environment.delimiter = delimiter
	environment.os_type = delimiter == '/' and 'linux' or 'windows'
	environment.path_filter = function( path ) 
		return path:gsub(anti_delimiter, delimiter)	
	end

	environment.service_root = service_root

	-- generate relative path relate to service_root
	function environment.make_path( unix_like_relative_path )
		return environment.service_root ..  
			environment.path_filter(unix_like_relative_path or '')
	end

	------------------------------------------------------------------------
	---  for we need to provide user more convenience style
	--  like `bar.foo.foo1 = 12`, instead of `bar = {foo = {foo1 = 12}}
	--  so, do some extra work

	-- the flag 
	local flag_building = true 
	local function index(tab, key)
		-- we only need one level things go 
		if flag_building then
			local new = setmetatable({}, {__index = index})
			rawset(tab, key, new)
			return new
		else
			return nil
		end
	end
	setmetatable(environment, {__index = index})

	-- then run user-config script in environment sandbox
	setfenv(etc, environment)()

	-- after read config, toggle recurssion_flag
	flag_building = false
end)();


---------------------------------------------------------------------------
--- set extra LUA_PATH and LUA_CPATH 
(function()
	local make_path = environment.make_path
	local path_separator = environment.delimiter

	local function gen_path( path_tab )
		local buffer = {}
		for k, v in ipairs( path_tab ) do

			if path_separator == '/' then
				-- absolute path
				if v:find('^/') then
					v = v
				else
					v = make_path( v ) 
				end
			else -- ms windows
				if v:find('%a:\\') then
					v = v
				else
					v = self.make_path( v )
				end
			end
				
			table.insert(buffer, v)
		end

		return ';' .. table.concat(buffer, ';') 
	end

	local extra =  environment.EXTRA 
	if extra.LUA_PATH then
		package.path = package.path .. gen_path( extra.LUA_PATH ) 
	end

	if extra.LUA_CPATH then
		package.cpath = package.cpath .. gen_path( extra.LUA_CPATH ) 
	end 
end)();

return environment
