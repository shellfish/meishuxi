authorization = [[
	allow(all_user)
]]

run = function(arg)
	return {'hello'}, function(x) return "<textarea>" .. x .. "</textarea>" end

end
