pcall(require, 'uuid')
local base = require'cicala.base'
local util = require'cicala.util'
local md5 = require'md5'
local uuid = uuid
local  require, assert =  require, assert

module(...)

-- just a proxy
function new( config )
	config = config or base.session
	
	local module = assert( config.module, 'must specify session.module!' )
	if module == 'file' then
		local addon = require'cicala.persist.file'.new(config)
		return util.extend(_M, addon) 
	elseif module == 'memcached' then
		local addon = require'cicala.persist.memcached'.new(config)
		return util.extend(_M, addon) 
	else
		error(('wrong config option: session.module |=> %s'):format(config.module))
	end

	return _M
end

-- create a session
function create(self, value )
	local id     -- session id
	if base.is_windows then
		id = md5.sumhexa(util.gen_rand_string(15) .. os.time())
	else
		id =  md5.sumhexa( uuid.new() )
	end

	self:set(id, value)
	return id
end
