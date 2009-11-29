-- make_path is helper to make relative path

MORE_LUA_PATH = {
	gen_path('src/lua/?.lua'),
	gen_path('src/lua/?/init.lua'),
	gen_path('src/external//lua/?/init.lua'),
}

MORE_LUA_CPATH = {
	gen_path('src/external/lib/?.so'),
	gen_path('src/external/lib/?.dll'),
}

-- postgres db config
PG_DATABASE = 'jwdb'
PG_USER = 'jwuser'
PG_PORT = nil --  '5432',
PG_HOST = nil --  '127.0.0.1'

-- session config
SESSION_MODULE = 'memcached'


-- APP DIR PATH
APPLET_ROOT_PATH = gen_path('/src/applet')

