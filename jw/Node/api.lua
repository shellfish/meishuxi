AccessControl = [[
allow(all_user)
]]

-- client can get user info from here
-- client should be an authenticated user
Run = [[
	global.require "lfs"

	local res = {}
	for k in pairs(global.lfs) do
		table.insert( res, k )
	end
	
	return res
]]
