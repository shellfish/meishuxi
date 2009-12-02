
-- these information are get from preload script, don't try to change them
LOADER.MAKE_PATH = make_path
LOADER.PATH_FILTER = path_filter
LOADER.SEPARATOR = delimiter

-- debug option
DEBUG.SHOW_STACK_TRACE = true
DEBUG.LOG_FILE = '/tmp/log.log.lua'


-- set luad_path & lua_cpath
-- you should not change this setting, unless you know what you are doing
	local external_lib = os_type == 'linux'  
		and 'external/lib/?.so' 
		or 'external/lib_win32/?.dll'

	EXTRA.LUA_CPATH = {
		external_lib
	}

	EXTRA.LUA_PATH= {
		'lua/?.lua',
		'lua/?/init.lua',
		'external/share/?.lua'
	}
-- end path define

-- database config
DATABASE.SOURCE = 'jwdb'
DATABASE.USER = 'jwuser'
DATABASE.DRIVER = 'postgres'

SESSION.FILECACHED = {
	PATH = "apps"
}

