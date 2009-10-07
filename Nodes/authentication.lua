AccessControl =[[
	allow( all_user )
]]

Type = "text/javascript"

Run = [==[
	
	local status, message = pcall( function()
		local action = arg.GET.action
		if action == 'login' then
			local user, passwd = arg.GET.user, arg.GET.passwd
			if not lib.authentication:login( user, passwd ) then
				error"user & passwd is't vaild match"
			end
		elseif action == 'logout' then
			lib.authentication:logout()
		else
			error'Unknown action(must be login or logout.'
		end
	end)

	return { ok = status, msg = message }
]==]

