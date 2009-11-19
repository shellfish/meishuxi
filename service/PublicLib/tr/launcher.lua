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
		"database", "memcached", 'authentication', "authorization", "config",
	}

	local map2 = {
		'tostring','ipairs', 'pairs', 'string', 'table', 'math',
		"pcall", "error","Json", "assert",'type', 
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

	env.global = _G

	env.require = function( lib )
		local path = {tr.util.split(assert(lib, 'lib cannot be nil'), [[%.]])}
		local target = _G
		for _, v in ipairs(path) do
			target = assert(target[v], ('cannot find lib in path:%s'):format(v))
		end
			
		return target
	end

	return env	
end


--- run node section and return the result table
-- @parma section statement section to be execute
-- @return the result table
function LAUNCHER:run( section  )

	local env = make_sanbox( self.tr_object )	

	local toExec
	if type(section) == 'string' then
		toExec = assert( loadstring(section))
	elseif type(section) == 'function' then
		toExec = section
	else 
		error('Wrong node run type')
	end

	setfenv( toExec, env )

	return toExec()
end
