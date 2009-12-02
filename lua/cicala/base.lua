----------------------------------------------------------------------------
--- the base config arguments and auto detect tools
-- this module holds the base that other parts can refer to

local getenv, byte, loadfile, error, rawset,  setmetatable, setfenv, assert
= os.getenv, string.byte, loadfile, error, rawset,  setmetatable, setfenv, assert

module(...)

-- firstly, we must detect where we are, and what the platform is?
local is_windows = getenv('OS') and getenv('COMSPEC')
local sep = is_windows and '\\' or '/'
local other_sep = sep == '\\' and '/' or '\\'

-- so we can build some path utilities
_M.path = {sep = sep, other_sep = other_sep}
local path = _M.path 

function path.filter( path )
	return path:gsub(other_sep, sep)
end

function path.is_absolute( path )
	if is_windows then
		return path:find([[^%a:\]])
	else
		return path:byte() == byte('/')
	end
end

function path.translate( orig )
	local orig = path.filter(orig)
	if path.is_absolute( orig ) then
		return orig
	else
		return path.base_dir ..  orig
	end
end

-- next, find /etc/config.lua and load user custom options
local usr_cfg, err = loadfile(path.filter('../etc/config.lua'))
if not usr_cfg then error(err) end

-- then build the default base-config
-- 1. set a unnormal run environment 
local base_cfg_mt_expire = false
local base_cfg_mt = {__index = function(tab, key)
	if base_cfg_mt_expire then
		return nil 
	else
		local new = setmetatable({}, base_cfg_mt)
		rawset(tab, key, new)
		return new
	end
end}
local base_cfg = setmetatable({}, base_cfg_mt)

-- inject default items
base_cfg.path = path

-- run user cfg
setfenv(usr_cfg, base_cfg)()

-- strip path.base_dir
assert( path.base_dir, '你必须定义path.base_dir, 为service目录相对于你的启动脚本的路径|绝对路径')
if byte( path.base_dir, #path.base_dir ) ~= path.sep then
	path.base_dir = path.base_dir .. path.sep
end


-- erase the flag to make sure if read a not exist item wiil throw an error
base_cfg_mt_expire = true


-- export method 
_M.config = base_cfg
