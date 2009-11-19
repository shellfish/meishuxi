AccessControl =[[
	allow( all_user )
]]

Type = "text/javascript"

Run = [==[

	local action = arg.GET.action

	if action == 'login' then
		local user, passwd  = arg.POST.user, arg.POST.passwd
		local ok, info = lib.authentication:login(user, passwd)
		
		if ok then
			return {ok = true, userInfo = info}
		else
			return {ok = false, msg = info}
		end

	elseif action == 'logout' then
		local ok, msg = pcall(function() lib.authentication:logout() end)
		return {ok = ok, msg = msg}
	else
		error(('Unknown action:%s, must be login or logout!'):format(action))
	end
	
	]==]

