----------------------------------------------------------------------------
--- the base config arguments and auto detect tools
-- this module holds the base that other parts can refer to

local getenv, byte, loadfile, error, rawset,  setmetatable, setfenv, assert
= os.getenv, string.byte, loadfile, error, rawset,  setmetatable, setfenv, assert
local _G = _G

local print = print

module(...);

-- build os path utility
(function() 
	local is_windows  = getenv('OS') and getenv('COMSPEC')
	_M.is_windows = is_windows

	-- path environment table
	local path = {
		sep = is_windows and '\\' or '/',   -- os specfic path separator
		other_sep = is_windows and '/' or '\\' 
	}

	function path:filter( path )
		return path:gsub(self.other_sep, self.sep)
	end

	function path:is_absolute( path )
		if is_windows then
			return path:find([[^%a:\]])
		else
			return path:byte() == byte('/')
		end
	end

	-- transalte all relative path relate to path.base_dir
	function path:translate( path )
		path = self:filter(path)
		return self:is_absolute(path) and path or self.base_dir .. path
	end

	-- not do transalte, only try to complete the tail separator
	function path:fix_dirpath( path )
		if byte( path, #path ) ~= self.sep then
			path = path .. self.sep
		end
		return path 
	end

	-- export [path]
	_M.path = path
end)();

(function() 
	-- next, find /etc/config.lua and load user custom options
	local etc_file = _M.is_windows and [[..\etc\config.lua]] or '../etc/config.lua'

	local usr_cfg = assert(loadfile(path:filter(etc_file)))

	-- then build the default base-config
	-- 1. set a unnormal run environment 
	local base_mt
	local base_mt_expire = false
	base_mt =  {__index = function(tab, key)
		if base_mt_expire then
			return nil
		else
			local new = setmetatable({}, base_mt)
			rawset(tab, key, new)
			return new
		end
	end}

	_M._G = _G

	setmetatable(_M, base_mt)
	setfenv( usr_cfg, _M )()

	assert( _M.path.base_dir, '你必须定义path.base_dir, 为service目录相对于你的启动脚本的路径|绝对路径')

	-- erase the flag to make sure if read a not exist item wiil throw an error
	base_mt_expire = true
end)();
