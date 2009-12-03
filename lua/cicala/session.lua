
local base = require'cicala.base'
local  require, assert =  require, assert

module(...)

-- just a proxy
function new( config )
	config = config or base.session
	
	local module = assert( config.module, 'must specify session.module!' )
	if module == 'file' then
		return require'cicala.persist.file'.new(config)
	elseif module == 'memcached' then
		return require'cicala.persist.memcached'.new(config)
	else
		error(('wrong config option: session.module |=> %s'):format(config.module))
	end
	return _M
end
