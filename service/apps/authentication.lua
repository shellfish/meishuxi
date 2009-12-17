accept = { POST= true }

define{
	'string',
	'any',
	'any',
	function(action, username, password) 
		assert(action == 'login' or action == 'logout',
			'invalid authentication action' .. tostring(action))

		if action == 'login' then
			assert(type(username) == 'string' and #username ~= 0, 'expect username')
			assert(type(password) == 'string' and #username ~= 0, 'expect password')

			assert( authentication:login(username, password) )
			return authentication:whoami()
		else -- logout
			authentication:logout()
			return true
		end
	end
}
