local setmetatable = setmetatable
local base = require'cicala.base'

module(...)

function new( config )
	
	local mt = {__index = _M}

	-- callback to process http
	function mt.__call(self, http)
		self.http = http

		http.response.status = 200
		http.response:write('hello你好 world')
	end
	
	return setmetatable({}, mt)
end


function parse_arg(self)

end



