accept = { POST= true, GET = true }

define{
	'string',
	'any',
	'any',
	function(action, username, password) 

		local util = cicala.util
		local base = cicala.base

		if action == 'login' then
			assert(type(username) == 'string' and #username ~= 0, 'expect username')
			assert(type(password) == 'string' and #username ~= 0, 'expect password')

			assert( authentication:login(username, password) )
			return authentication:whoami()
		elseif action == 'logout' then -- logout
			authentication:logout()
			return true
		elseif action == 'info' then
			local current_user = assert(authentication:whoami(), 'You has not login')

			-- 类别转换filter
			local index = {
				{'_user_type', 'type', function(t) 
					return t=='s' and 'student' or  t=='t' and 'teacher' or t=='a' and' admin' or error'Unknown type' 
				end},
				{'id', 'id'},
				{'name', '姓名'},
				{'sex', '性别', function(v) 
					return (v == '1') and '男' or (v == '2') and '女' or '未知'
				end},
				{'politics', '政治面貌', function(v)
					v = tonumber(v)
					return v == 1 and '群众' or v == 2 and '团员' or v == 3 and '预备党员' or v == 4 and '党员' or '未知'
				end},
				{'email', '电子邮件'},
				{'phone_number', '固定电话'},
				{'cell_number', '手机'},
				{'national_identity', '身份证号'}
			}

			local attr_list = table.concat( util.map(index, function(v)  return v[1] end), ',' )
			local sql_stat =  'SELECT ' .. attr_list .. " FROM Role WHERE id = '%s';"
			local cursor = assert( dbc:execute( sql_stat:format(current_user) ) )
			local result = cursor:fetch{}

			---
			-- generate result set
			---
			local items = {}
			local tinsert = table.insert
			for k, value in ipairs(result) do
					local key = index[k][2]
					local filter = index[k][3]
					value = (filter and filter(value) or value)
					tinsert(items, {['attribute'] = key, ['value'] = value})
			end

			return {items=items}
		---- END of info(action)	

		else
			error(('Unknown action:[%s]'):format(action))
		end
	end
}
