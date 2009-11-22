
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
-- @field OS_TYPE => 'WINDOWS/Linux' DEFAULT TO Linux
local default_options = {
	DATABASE_SOURCE = "jwdb",
	DATABASE_USER  = 'jwuser',
	DATABASE_DRIVER = 'postgres',
	DATABASE_INITSTAT = "SET search_path TO meishuxi;",

	AUTH_METHOD = "database_simple",
	AUTH_TOKEN_NAME = 'userHash',
	AUTH_PASSWD_SALT = "5d41402abc4b2a76b9719d911017c592", -- 影子密码加密key

	NODE_LOAD_PATH = '/home/zhousiyv/桌面/trunk/service/meishu/Node',

	-- operating system type, for perdermance
	OS_TYPE = 'Linux',
}

return default_options
