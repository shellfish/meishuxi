authorization = [[
	allow(all_user)
]]

-- 只允许客户端使用POST方法
accept = {POST = true, GET=true}


define{
	'number',
	'number',
	'string',
	function(N1, N2, op)


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
}
