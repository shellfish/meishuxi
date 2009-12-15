accept = { POST= true, GET=true }


define{
	'string',
	'any',
	'any',
	function(action, username, password) 
		assert(action == 'login' or action == 'logout',
			'invalid authentication action' .. tostring(action))

		if action == 'login' then
			assert(type(username) == 'string', 'expect username')
			assert(type(password) == 'string', 'expect username')

			assert( permmission:login(username, password) )
			return permmission:whoami()
		else -- logout
			 permmission:logout()
			return true
		end
	end
}
