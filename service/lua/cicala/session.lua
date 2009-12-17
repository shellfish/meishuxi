---------------------------------------------------------------------------
-- @class module
-- @name cicala.session 

local util = require'cicala.util'
local  require, assert, math  =  require, assert, math
local socket = require'socket'
local globals = _G

module(...)


---------------------------------------------------------------------------
-- just a proxy to abstract real store interface 
-- @see session_config_table
-- @param config configuration hash 
-- @return new session instance
function new( config )
	config = config

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

---
-- create a random id marked session with value stored in it
-- @parma value what you what to store(string, number, table)
-- @return the random id string
function create(self, value )
	local id     -- session id

	if not self.digest_algorithm then
		self.digest = self.digest or 'md5'
		if self.digest == 'md5' then
			self.digest_algorithm = globals.require'md5'.sumhexa
		elseif self.digest == 'sha1' then
			self.digest_algorithm = globals.require'sha1'.digest
		else
			error('I cannot understand digest algorithm:' .. self.digest)
		end
	end

	id = self.digest_algorithm( math.random()  .. socket.gettime() )

	assert( self:add(id, value) )
	return id
end

----
-- @class table
-- @name session_config_table
-- @field module can be file|memcached 
-- @field expire expiry interval by second
-- @field path valid ONLY when set module to "file",
-- absolue path or relative path relate to %ROOT%/service 
-- @field host valud ONLY when set module to "memcached"
-- @field port valud ONLY when set module to "memcached"
