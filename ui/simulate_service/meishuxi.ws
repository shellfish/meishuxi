package.path = package.path .. ';/mnt/libtree/Linux/lua/share/?.lua'
require "wsapi.response"
require "wsapi.request"
require "Json"

local API = [[
	{
		"authentication/login":{
			'url':'p=authentication&action=login',
			'summary':"需要两个参数username|password"
		},
		"authentication/logout":{
			"url":'p=authentication&action=logout',
			'summary':'不需要参数，返回结果'
		}
	}	
]]

return  
function (wsapi_env)
	local req = wsapi.request.new( wsapi_env )
 	local res = wsapi.response.new()
    res.headers = { ["Content-type"] = "text/plain" }
    res.status = 200

	-- 打印api列表
	if req.GET.p == 'api' then
		res:write( API )
	elseif req.GET.p == 'authentication' and req.GET.action == 'login' then

		function map( tab )
			local map_list = {
				{user = 'student', passwd = 'student'},
				{user = 'teacher', passwd = 'teacher'},
				{user = 'admin', passwd = 'admin'}
			}

			for _,item in ipairs(map_list) do
				if tab.user == item.user and tab.passwd == item.passwd then
					return true
				end
			end

			return false
		end
	
		local result = {
			ok = map(req.POST),
			userInfo = {
				type = req.POST.user,
				name = '我是谁'
			}
		}
		if result.ok then res:set_cookie('userHash', 'hello') end

		res:write(Json.Encode(result))

	else	
		res:write('userHash=' .. req.cookies['userHash'])
	end

   return res:finish()
end

