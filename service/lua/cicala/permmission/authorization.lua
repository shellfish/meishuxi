local error, assert, pcall = error, assert, pcall
local setmetatable = setmetatable
local newproxy = newproxy
local type = type
local loadstring = loadstring
local setfenv = setfenv
local ipairs = ipairs
local tostring = tostring
local tinsert = table.insert

local registry = cicala.registry
local authentication = registry.authentication
local dbc = assert(registry.dbc)

module(...)

function new( config )
	local obj = setmetatable({}, {__index = _M})
	return obj
end

-- get basic use information
function getinfo(self)
	local template = [[SELECT * FROM Role WHERE id = '%s';]]
	local cursor = assert(dbc:execute(template:format(authentication:whoami())))

	local result = assert(cursor:fetch({}, 'a'))
	result.password = nil
	return result
end


function init_sandbox(self)
	
	self.check_chain = {}
	local sandbox = {
		all_user = newproxy(false),
		authenticated_user = newproxy(false)
	}
	
	function sandbox.allow( user )
		local group = assert(user)
		local user = tostring(user)

		tinsert(
			self.check_chain,
			function(id)
				if group ==  sandbox.all_user then
					return true
				elseif group == sandbox.authenticated_user then
					return true
				elseif user == id then
					return true
				else
					return false
				end
			end
		)
	end

	function sandbox.usertype( user )
		assert(user)

		local cursor  = assert( dbc:execute(
			[[SELECT _user_type FROM role WHERE userid == '%s';]],
			user
		))

		return cursor:fetch{}[1]
	end

	function sandbox.error(msg)
		error(msg)
	end

	return sandbox
end



function access_control( self, statement )
	local me = authentication:whoami()

	local basic_sandbox = self:init_sandbox()

	local stat = assert( type(statement) == 'function' and statement or
		type(statement) == 'string' and assert(loadstring(statement)) or nil )
	
	-- run
	setfenv(stat, basic_sandbox)()
	
	return (function( user )
		for _, check in ipairs(self.check_chain) do
			if check(user) then return true end
		end
	end)() or false;
end
