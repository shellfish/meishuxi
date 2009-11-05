AccessControl = [[
allow(all_user)
]]

Type = "text/javascript"


-- client can get user info from here
-- client should be an authenticated user
Run = [[
	local userId = lib.authentication:user()

	return  {
		user     = userId or Json.Null,
		userType = lib.authorization:getInfo( userId, 'userType')
	}
]]
