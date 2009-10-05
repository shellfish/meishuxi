-- Wrap for luaSql library

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

-- return the coonect object
-- and always return it
function new( config )
	CONFIG = config
	return make_coon()
end
