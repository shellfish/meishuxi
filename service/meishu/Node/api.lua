AccessControl = [[
allow(all_user)
]]

-- client can get user info from here
-- client should be an authenticated user
Run = function()
		
	return  	{
		["authentication/login"] = {
			['url'] = 'p=authentication&action=login',
			['summary'] = "需要两个参数username|password"
		},
		["authentication/logout"] = {
			["url"]= 'p=authentication&action=logout',
			['summary'] = '不需要参数，返回结果'
		},
		['information/see'] = {
			['url'] = 'p=information&action=see',
			['summary'] = '提供参数id'
		},
		["information/alterpassword"] = {
			['url'] = 'p=information&action=alterpassword',
			['summary'] = '提供原始密码和修改密码，original_passorwd|password'
		},
	}	


end
