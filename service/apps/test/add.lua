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

define{
	'number',
	'number',
	function(N1, N2)
		return N1 + N2
	end
}
