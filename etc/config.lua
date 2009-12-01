
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

local external_lib = os_type == 'linux'  
	and 'external/lib/?.so' 
	or 'external/lib_win32/?.dll'

EXTRA.LUA_CPATH = {
	make_path(external_lib)
}

DATABASE.SOURCE = 'jwdb'
DATABASE.USER = 'jwuser'
DATABASE.DRIVER = 'postgres'

DEBUG.SHOW_STACK_TRACE = true
DEBUG.LOG_FILE = '/tmp/log.log.lua'



