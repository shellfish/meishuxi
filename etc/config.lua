
-- these information are get from preload script, don't try to change them
LOADER.MAKE_PATH = make_path
LOADER.PATH_FILTER = path_filter
LOADER.SEPARATOR = delimiter


-- begin config

EXTRA.LUA_PATH= {
	make_path'lua/?.lua',
	make_path'lua/?/init.lua',
	make_path'external/share/?.lua'
}
EXTRA.LUA_CPATH = {
	make_path'external/lib/?.so',
	make_path'external/lib_win32/?.dll'
}

DATABASE.SOURCE = 'jwdb'
DATABASE.USER = 'jwuser'
DATABASE.DRIVER = 'postgres'

DEBUG.SHOW_STACK_TRACE = true
DEBUG.LOG_FILE = '/tmp/log.log.lua'



