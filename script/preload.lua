-- auto detect lua_path and lua_cpath
(function()

	local root_dir = '..'
	local is_windows = os.getenv'OS' and os.getenv'COMSPEC'
	local sep = is_windows and '\\' or '/'
	local other_sep = sep == '/' and '\\' or '/'
	local translate = function(orig)
		return orig:gsub(other_sep, sep)
	end

	local LUA_PATH = {
		'lua/?.lua',
		'lua/?/init.lua',
		'external/share/?.lua'
	}

	local LUA_CPATH = 'external/lib/?.'

	package.path = package.path .. ';' .. (function()
		local buf = {}
		local append = table.insert
		for k, v in pairs(LUA_PATH) do
			append(buf, root_dir .. sep .. translate(v))
		end
		return table.concat(buf, ';')
	end)();

	package.cpath = package.cpath .. ';' .. (function()
		local cpath = translate'external/lib/?.'
		cpath = cpath .. (is_windows and 'dll' or 'so')
		return root_dir .. sep .. cpath
	end)();


end)();
