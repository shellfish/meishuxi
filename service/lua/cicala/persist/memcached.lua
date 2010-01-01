---------------------------------------------------------------------------
-- @class module
-- Interface for Lua Memcached module
--------------------------------------------------------------------------
require'cicala.util'
require'cicala.base'

local setmetatable = setmetatable
local require, assert, select, append, unpack = require, assert, select, table.insert, unpack
local rawset, rawget = rawset, rawget
local serialize,deserialize = cicala.util.serialize,cicala.util.deserialize
local base = cicala.base

module( ... )


local function make_coon(config)

	config = config or base.session 

	local coon_meta_method = (function()

		local persist_coon = nil

		function get_coon()
			if not persist_coon then
				local Memcached = require"Memcached"
				persist_coon = assert(Memcached.Connect(
					config.host, 
					config.port,
					config.expire
				), 'Cannot connect to memcached server')
				persist_coon:set_decode( deserialize )
				persist_coon:set_encode( serialize )	

			end

			return persist_coon
		end

		return function(tab, key)
			local real_coon = get_coon()
			local real_method =  real_coon[key]

			if real_method then
				rawset(tab, key, function(...) 
					return real_method( real_coon, select(2, ...) ) 
				end)
				return rawget(tab, key)
			else
				return nil, 'Lua-Memcached doesn\'t have method:' .. key
			end
		end

	end)();

	return setmetatable({finalize = function() end}, {__index = coon_meta_method})
end


--- new a  instance 
-- @parma config 
-- @return the instance of Memcached coon object and always return the same one
function new( config )
	return make_coon(config)
end
