Run =  function()   --------------------------------------------------------
	local tonumber = require"tonumber"

	-- generate default action
	if not arg.GET.action then arg.GET.actiion = 'see' end

	---
	--
	--  default action: see
	if arg.GET.action == 'see' then

		-- 类别转换filter
		local index = {
			{'id', 'id'},
			{'name', '姓名'},
			{'sex', '性别', function(v) 
				return (v == '1') and '男' or (v == '2') and '女' or '未知'
			end},
			{'politics', '政治面貌', function(v)
				v = tonumber(v)
				if ( v == 1 ) then
					return '群众'
				elseif ( v == 2 ) then
					return '团员'
				elseif ( v == 3 ) then
					return '预备党员'
				elseif ( v == 4 ) then
					return '党员'
				else
					return '未知'
				end
			end},
			{'email', '电子邮件'},
			{'phone_number', '固定电话'},
			{'cell_number', '手机'},
			{'national_identity', '身份证号'}
		}

		local attr_list = (function() 
			local buf = {}
			for k, v in ipairs(index) do
				table.insert( buf, v[1] )
			end
			return table.concat( buf, ',' )
		end)();

		local stat = 'SELECT ' .. attr_list .. " FROM Role WHERE id = '%s';"
		local cursor = assert( lib.database:execute(
		stat:format(assert(arg.GET.id, 'GET field:id cannot be nil'))
		))

		local res = assert(cursor:fetch{}, ('no this user:%s'):format(arg.GET.id))
		---
		-- generate result set
		---
		local items = {}
		for k, v in ipairs(res) do
				local key = index[k][2]
				local value = v

				local filter = index[k][3]
				value = filter and filter(value) or value
				
				table.insert(items, {['attribute'] = key, ['value'] = value})
		end

		return {items=items}	

	--- 
	-- action: alterpassword
	-- get two field(POST): original_password  | password
	--
	elseif arg.GET.action == 'alterpassword' then
		local original = arg.POST.original_password or ''
		local password = arg.POST.password or ''
	

		-- get original password from database
		local cursor = lib.database:execute((
			[[SELECT password FROM Role WHERE id = '%s';]]):format(lib.authentication:user()))
		
		if not ((cursor:fetch{})[1] == original) then
			return { ok = false, msg = "Original password not match", '提供:%s' }
		else
			-- do change
			local ok, msg = (lib.database:execute((([[ UPDATE Role SET password = '%s' WHERE id = '%s']]):format(
				password, lib.authentication:user()))))
			return { ok = ok and true or false, msg = msg }
		end
	else
		error("Invalid action:" .. arg.GET.action)
	end

end ------------ end RUN ==================================================


AccessControl =[[
	allow( all_user )
]]


