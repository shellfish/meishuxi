
---------------------------------------------------------------------------
--- 
--  Database module 
-- @release 2009年 11月 29日 星期日 22:28:41 CST
---------------------------------------------------------------------------

local setmetatable, require, assert = setmetatable, require, assert
local select = select
local print = print
local rawset = rawset

module(...)


local function make_coon( config )

	-- the meta method
	local  coon_meta_method = (function()
		local persist_luasql_env = nil
		local persist_coon = nil

		function get_coon()
			if not persist_luasql_env then
				local driver_name = config.driver 
				local luasql = require('luasql.' .. driver_name)
				persist_luasql_env = luasql[driver_name]()
			end

			if not persist_coon then
				persist_coon = assert(persist_luasql_env:connect(
					config.source,
					config.user,
					config.password,
					config.host,
					config.port
				))
			end

			if config.initstat then
				assert( persist_coon:execute(config.initstat) )
			end

			return persist_coon	
		end


		-- the real metamethod
		return function(tab, key)
			-- 从一个包装过的数据库连接中返回方法
			-- self是没用的 
			local real_coon = get_coon()
			local real_method = assert(real_coon[key], 'database coon dosn\'t has method:' .. key)

			local final_method =  function(  ... )
				-- call real method
				-- drop the first argument for compatiable the : syntax
				return real_method(real_coon, select(2, ...))
			end

			rawset(tab, key, final_method)
			return final_method
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

---
-- @class  table
-- @name config_database
-- @field source 数据库名
-- @field user 数据库连接的用户名
-- @field driver luasql驱动,默认postges default postgres
-- @field initstat initializing statement that will be execute when create coonection
-- @field password 密码
-- @field host 数据库主机(ip/domainname)
-- @field port 端口号
