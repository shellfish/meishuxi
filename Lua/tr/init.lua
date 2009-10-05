-- overload error function
local native_error = error
function error( err ) native_error("#" .. tostring(err) .. "#") end

module(..., package.seeall)

TR = {}

function new( bootstrap_config )
	local obj = setmetatable({}, {__index = TR} )
	return obj
end


function TR:main( request, response )
	response:write( "It Works!" )
	error"It works"
end
