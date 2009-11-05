AccessControl =[[
	allow( all_user )
]]

Type = "text/javascript"

Run = [==[
	
	local status, message = pcall( function()
		local action = arg.GET.action
		if action == 'login' then
			local user, passwd = arg.POST.user, arg.POST.passwd
			local ok, msg = lib.authentication:login( user, passwd )
			if not ok then
				error(msg)
			end
		elseif action == 'logout' then
			lib.authentication:logout()
		else
			error'Unknown action(must be login or logout.'
		end
	end)

	return { ok = status, msg = message }
]==]

