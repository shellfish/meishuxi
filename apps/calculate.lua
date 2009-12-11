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

run = function(N1, N2, op)
	assert(type(N1) == 'number', 'N1 is not number, but' .. type(N1))
	assert(type(N2) == 'number', 'N2 is not number, but' .. type(N2))
	
	if op == '+' then
		return N1 +N2
	elseif op == '-' then
		return N1 - N2
	elseif op == '*' then
		return N1 * N2
	elseif op == '/' then
		return N1 / N2
	elseif op == '%' then
		return N1 % N2
	else
		error('cannot handle operation ' .. op)
	end
end
