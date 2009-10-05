---------------------------------------------------------------------------
--- 
--  Database module 
-- @release 2009年 10月 05日 星期一 21:22:24 CST
---------------------------------------------------------------------------


module(..., package.seeall)

local ENV  = nil
local COON = nil
local CONFIG = nil

local function make_coon(  )
	if not ENV then
		local driver = CONFIG.DATABASE_DRIVER
		require ("luasql." .. driver)
		ENV = luasql[driver]()
	end

	if not COON then
		COON = assert(ENV:connect(
			CONFIG.DATABASE_SOURCE,
			CONFIG.DATABASE_USER,
			CONFIG.DATABASE_PASSWD,
			CONFIG.DATABASE_HOST,
			CONFIG.DATABASE_PORT
		))

		if CONFIG.DATABASE_INITSTAT then
			assert( COON:execute(CONFIG.DATABASE_INITSTAT) )
		end
	end

	return COON
end

--------------------------------------------------------------------------
--- New a instance of type "luasql connect object" by using config params
-- @parma config  a table represent 
-- @return the luasql connect object 
--------------------------------------------------------------------------
function new( config )
	CONFIG = config
	return make_coon()
end
