---------------------------------------------------------------------------
--- 
--  Database module 
-- @release 2009年 10月 05日 星期一 21:22:24 CST
---------------------------------------------------------------------------


module(..., package.seeall)


local function make_coon( config )

	-- the meta method
	local  coon_meta_method = (function()
		local persist_luasql_env = nil
		local persist_coon = nil

		function get_coon()
			if not persist_luasql_env then
				local driver_name = config.DATABASE_DRIVER
				local luasql = require('luasql.' .. driver_name)
				persist_luasql_env = luasql[driver_name]()
			end

			if not persist_coon then
				persist_coon = assert(persist_luasql_env:connect(
					config.DATABASE_SOURCE,
					config.DATABASE_USER,
					config.DATABASE_PASSWD,
					config.DATABASE_HOST,
					config.DATABASE_PORT
				))
			end

			if config.DATABASE_INITSTAT then
				assert( persist_coon:execute(config.DATABASE_INITSTAT) )
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
