----------------------------------------------------------------------------
-- @release Main module  [AT] Mon Oct  5 23:19:47 CST 2009
----------------------------------------------------------------------------

-- overload error function
local native_error = error
function error( err ) native_error("#" .. tostring(err) .. "#") end

module(..., package.seeall)

TR = {}

--- merge config
-- @parma bootstrap_config
-- @return A instance of prototype TR
function new( bootstrap_config )
	local obj = setmetatable({}, {__index = TR} )
	return obj
end

---------------------------------------------------------------------------
-- Do main process
-- @parma request wsapi request object
-- @parma response wsapi response object
function TR:main( request, response )
	response:write( "It Works!" )
	error"It works"
end
