AccessControl =[[
	allow( all_user )
]]

Type = "text/javascript"

Run = function()

	local action = arg.GET.action

	if action == 'login' then
		local user, passwd  = arg.POST.user, arg.POST.passwd
		local ok, info = lib.authentication:login(user, passwd)

		
		if ok then
			if arg.GET.redirect  then
				local res = require"response"
				res.status = 302
				res.headers = {location =  arg.GET.redirect}
				res:set_cookie('userInfo', Json.Encode(userInfo))
			else
				return {ok = true, userInfo = info}
			end
		else
			return {ok = false, msg = info}
		end

	elseif action == 'logout' then
		local ok, msg = pcall(function() tr.authentication:logout() end)
		return {ok = ok, msg = msg}
	else
		error(('Unknown action:%s, must be login or logout!'):format(action))
	end
	
end

