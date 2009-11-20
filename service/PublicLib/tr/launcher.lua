module(..., package.seeall)

local LAUNCHER = {}

function new( tr_object )
	local obj = setmetatable({}, {__index = LAUNCHER})	
	obj.tr_object = tr_object

	return obj
end

local function make_sanbox( tr_object )
	local env = {}
	local lib = {}
	local map1 = {
		"database", 'authentication', "authorization", "config",
	}

	local map2 = {
		'tostring','ipairs', 'pairs', 'string', 'table',
		"pcall", "error", "assert",'type', 
	}

	for _, v in ipairs( map1 ) do
		lib[v] = tr_object[v]
	end

	for _, v in ipairs( map2 ) do
		env[v] = _G[v]
	end
	
	env.arg = {
		GET = tr_object.request.GET, 
		POST = tr_object.request.POST
	}
	env.lib = lib

	env.require = function( libname, load_type )

		-- all three loaders
		local loader = {}
		function loader.from_libtr(path) 

			local ok, lib_from_tr = pcall(function() 
				local target = tr_object 
				for _, v in ipairs(path) do
					target = assert(target[v])
				end

				return target
			end)

			if ok and lib_from_tr then return lib_from_tr end
		end

		-- return lib from _G(global space)
		function loader.from_global(path)
			local ok, lib_from_global = pcall(function() 
				local target = _G
				
				for _, v in ipairs(path) do
					target = assert(target[v])
				end
				return target
			end)
			if ok and lib_from_global then return lib_from_global end
		end

		-- require external lib
		function loader.from_luapath( libname )
			local ok, lib =  pcall(function() return require(libname) end)
			return ok and lib or nil
		end


		function gen_err() return 'loader fail to load lib:' .. libname end
		function gen_path(lib) return { tr.util.split(lib, '%.') } end

		-- do general load
		if not load_type then

			return loader.from_libtr(gen_path(libname)) or 
				loader.from_global(gen_path(libname)) or
				assert(loader.from_luapath(libname), gen_err())
		-- do a custom load
		else
			if load_type == 'tr' then
				return assert( loader.from_libtr(gen_path(libname)), get_err() )	
			elseif load_type == 'global' then
				return assert( loader.from_global(gen_path(libname)), gen_err())	
			elseif load_type == 'external' then
				return assert( loader.from_luapath(libname), gen_err() )
			else
				error("Invalid usage: wrong arg:" .. load_type)
			end
		end

	end -- end of env.require

	return env	
end



--- run node section and return the result table
-- @parma section statement section to be execute
-- @return the result table
function LAUNCHER:run( section  )

	local env = make_sanbox( self.tr_object )	

	local toExec
	if type(section) == 'string' then
		toExec = assert( loadstring(section), 'A Virtual Node trunk')
	elseif type(section) == 'function' then
		toExec = section
	else 
		error('Wrong node run type')
	end

	setfenv( toExec, env )

	return toExec()
end
