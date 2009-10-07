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
		"database", "memcached", 'authentication', 
	}

	local map2 = {
		'tostring', 'ipairs', 'pairs', 'string', 'table', 'math',
		"pcall", "error", 
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

	return env	
end


--- run node section and return the result table
-- @parma section statement section to be execute
-- @return the result table
function LAUNCHER:run( section  )

	local env = make_sanbox( self.tr_object )	

	local toExec = assert( loadstring( section ) )
	setfenv( toExec, env )

	return toExec()
end

--- run and convert result to Json format
function LAUNCHER:getJson( section )
	return Json.Encode( self:run( section ) )
end
