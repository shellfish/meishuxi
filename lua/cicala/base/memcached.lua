---------------------------------------------------------------------------
-- @class module
-- Interface for Lua Memcached module
--------------------------------------------------------------------------
require'cicala.util.serialize'

local setmetatable = setmetatable
local require, assert, select = require, assert, select
local serialize,deserialize = cicala.util.serialize,cicala.util.deserialize

module( ... )


local function make_coon(config)

	config = config or {}

	local coon_meta_method = (function()

		local persist_coon = nil

		function get_coon()
			if not persist_coon then
				local Memcached = require"Memcached"
				persist_coon = assert(Memcached.Connect(
					config.HOST, 
					config.PORT
				), 'Cannot connect to memcached server')
				persist_coon:set_decode( deserialize )
				persist_coon:set_encode( serialize )	
			end

			return persist_coon
		end

		return function(tab, key)
			local real_coon = get_coon()
			local real_method =  assert(real_coon[key], 
				'Memcached-Lua doesn\'t support method: ' .. key)

			return function(...)
				return real_method(real_coon, select(2, ...))
			end
		end

	end)();

	return setmetatable({}, {__index = coon_meta_method})
end


--- new a  instance 
-- @parma config 
-- @return the instance of Memcached coon object and always return the same one
function new( config )
	return make_coon(config)
end



