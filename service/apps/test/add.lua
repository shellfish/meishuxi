authorization = [[
	allow(all_user)
]]

api = {['json-rpc'] = {
	parameters = 
	{
		{ type ='number', name = '加数'},
		{ type ='number', name = '被加数' }
	}
}}

run = function(N1, N2)
	assert(type(N1) == 'number', 'N1 is not number, but' .. type(N1))
	assert(type(N2) == 'number', 'N2 is not number, but' .. type(N2))

	return N1 + N2
end
