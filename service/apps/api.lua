

define { function()
--=========================================================================
	local base = cicala.base
	local util = cicala.util
	local tinert = table.insert

	-- dispatcher:load_app 取真实相对路径， 但不包含最后的.lua	

	local root_dir = nil
	
	-- dirname 必须有最后的路径
	local function load_all_api( dirname, result )	
		root_dir = root_dir or dirname -- only once init

		-- 将此完整文件路径，类似 /home/1.lua 截取为dispatcherlike的路径
		local function strip( absolute_path )
			local len = #root_dir
			local cut_front = absolute_path:sub(len+1, #absolute_path)
			local cut_back = cut_front:gsub('%.lua$', '')
			return cut_back
		end

		local function is_file( absolute_path )
			return lfs.attributes(absolute_path, 'mode') == 'file' and
				absolute_path:find('%.lua$')
		end

		local function is_dir( absolute_path )
			return lfs.attributes( absolute_path, 'mode') == 'directory'
		end

		local function is_valid( relative_path )
			return relative_path ~= '.' and relative_path ~= '..'
		end

		local function treat_file( absolute_path )
			local path = strip(absolute_path)

			local app = dispatcher:load_app(path:gsub(base.path.sep, '_'))


			if app.arglist then
				result[app.name] = app.arglist
			end
		end

		for file in lfs.dir(dirname) do
			if is_valid(file) then
				local absolute_path  = dirname .. file
				if is_file(absolute_path) then
					treat_file(absolute_path)
				elseif is_dir(absolute_path) then
					load_all_api(absolute_path .. base.path.sep, result)	
				else
					do end
				end
			end
		end
		
	end

	---------------------------------------
	--- main

	local api
	--if not base.DEBUG then
		api = session:get('api')
	--end

	if not api then
		api = {}
		load_all_api(util.path_normalizer(base.dispatcher.appdir,'dir'), api)
		--if not base.DEBUG then 
			session:set('api', api); 
		--end
	end

	local buf = {}	
	for func_name, olditem in pairs(api) do
		local newitem = { parameters = {}}

		for k, v in ipairs(olditem) do
			newitem.parameters[k] = {type = v}
		end

		buf[func_name] = newitem
	end

	return buf
--=========================================================================
end
}
