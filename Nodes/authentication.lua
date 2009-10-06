AccessControl =[[
	allow( all )
]]

Type = "text/javascript"

Run = [==[
	
	local status, message = pcall( function()
		local action = arg.GET.action
		if action == 'login' then
			local user, passwd = arg.POST.user, arg.POST.passwd
			if not lib.authentication:check( user, passwd ) then
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

