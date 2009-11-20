---------------------------------------------------------------------------
-- @class module
-- Interface for Lua Memcached module
--------------------------------------------------------------------------
require "Memcached"

module(..., package.seeall)

local CONFIG = nil
local CONNECT = nil


local function make_connect()
	if not CONNECT then
		CONNECT = assert(Memcached.Connect(CONFIG.MEMCACHED_HOST, CONFIG.MEMCACHED_PORT))
		CONNECT:set_decode( tr.util.deserialize )
		CONNECT:set_encode( tr.util.serialize )
	end

	return CONNECT
end

--- new a  instance 
-- @parma config 
-- @return the instance of Memcached coon object and always return the same one
function new( config )
	CONFIG = config
	return make_connect()
end



