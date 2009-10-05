require "Memcached"
require "tr.util.dump"

module(..., package.seeall)

local CONFIG = nil
local CONNECT = nil


local function make_connect()
	if not CONNECT then
		CONNECT = assert(Memcached.Connect(CONFIG.MEMCACHED_HOST, CONFIG.MEMCACHED_PORT))
		CONNECT:set_decode( tr.util.dump.collect )
		CONNECT:set_encode( tr.util.dump.serialize )
	end

	return CONNECT
end

function new( config )
	CONFIG = config
	return make_connect()
end



