
module(...)
-------------------------------------------------------------------------------
-- Default configuration options
-- @class table
-- @name default_options
-- @field DATABASE_SOURCE now default is jwdb
-- @field DATABASE_USER jwuser
-- @field DATABASE_PORT need't point( default is 5432)
-- @field DATABASE_DRIVER default to postgres
-- @field DATABASE_INITSTAT the statement will be executed when init db
-- Like <code>SET search_path TO sth;</code>
-- <hr />
-- <h3> node loader </h3>
-- @field NODE_LOAD_PATH the path will be use <b>AS</b> Virtual Loader 
-- root dir
-- <hr /><h3> Memcached related </h3>
-- @field MEMCACHED_HOST N/A
-- @field MEMCACHED_PORT N/A
local default_options = {
	DATABASE_SOURCE = "jwdb",
	DATABASE_USER  = 'jwuser',
	DATABASE_DRIVER = 'postgres',
	DATABASE_INITSTAT = "SET search_path TO jw;",

	AUTH_TOKEN_NAME = 'userHash',

	NODE_LOAD_PATH = '/home/zhousiyv/桌面/trunk/Nodes',
}

return default_options
