
---------------------------------------------------------------------------
--- 
--  Database module 
-- @release 2009年 11月 29日 星期日 22:28:41 CST
---------------------------------------------------------------------------

local setmetatable, require, assert = setmetatable, require, assert
local select = select

module(...)


local function make_coon( config )

	-- the meta method
	local  coon_meta_method = (function()
		local persist_luasql_env = nil
		local persist_coon = nil

		function get_coon()
			if not persist_luasql_env then
				local driver_name = config.DRIVER
				local luasql = require('luasql.' .. driver_name)
				persist_luasql_env = luasql[driver_name]()
			end

			if not persist_coon then
				persist_coon = assert(persist_luasql_env:connect(
					config.SOURCE,
					config.USER,
					config.PASSWORD,
					config.HOST,
					config.PORT
				))
			end

			if config.INIT then
				assert( persist_coon:execute(config.INIT) )
			end

			return persist_coon	
		end


		-- the real metamethod
		return function(tab, key)
			-- 从一个包装过的数据库连接中返回方法
			-- self是没用的 
			local real_coon = get_coon()
			local real_method = assert(real_coon[key], 'database coon dosn\'t has method:' .. key)

			return function(  ... )
				-- call real method
				-- drop the first argument for compatiable the : syntax
				return real_method(real_coon, select(2, ...))
			end
		end

	end)();

	return setmetatable({}, {__index = coon_meta_method})
end

--------------------------------------------------------------------------
--- New a instance of type "luasql connect object" by using config params
-- @parma config  a table represent 
-- @return the luasql connect object 
--------------------------------------------------------------------------
function new( config )
	return make_coon( config )
end
