----------------------------------------------------------------------------
--- Access Control second Wall: Authorization
-- with some cache support
---------------------------------------------------------------------------


module(..., package.seeall)

local AUTHORIZATION = {}

function new( tr_object )
	local obj = setmetatable({}, {__index = AUTHORIZATION} )
	obj:init( tr_object )
	return obj
end


function AUTHORIZATION:init( tr_object )
	self.authentication = tr_object.authentication
	self.database  = tr_object.database
end

function AUTHORIZATION:run( auth_statement, arg )
	return true
end

