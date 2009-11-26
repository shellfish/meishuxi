---------------------------------------------------------------------------
---
-- Access Control => Authentication
----------------------------------------------------------------------------


require "md5"
require 'mime'
module(..., package.seeall)

local AUTH = {}
local USER = nil

local db_coon = nil
local global_config = nil


local password_mapper = nil     -- 对原始密码进行转换

--- new a authentication object
-- @return AUTH instance
function new( tr_object )
	local obj = setmetatable({}, {__index = AUTH})
	obj:init( tr_object )
	return obj
end


--== DEFINE class AUTH ==========
function AUTH:init( tr_object )
	local config = tr_object.config
	global_config = config

	self.memcached = tr_object.memcached
	self.database = tr_object.database
	db_coon = self.database

	self.request = tr_object.request
	self.response = tr_object.response
	self.ip = tr_object.wsapi_env.REMOTE_ADDR
	
	self.method  = config.AUTH_METHOD or 'simple'
	self.token   = config.AUTH_TOKEN_NAME or 'userhash'
	self.timeout = config.AUTH_TIMEOUT or 600  -- default 10 mimute 

	local original_mapper = config.AUTH_PASSWORD_MAPPER
	if original_mapper then
		password_mapper = (function() return 
			function(x) return config.AUTH_PASSWORD_MAPPER(x, _G) end  
		end)(); 
	else
		password_mapper =	(function(x) return x  end)
	end
	self.password_mapper = function(self, x) return password_mapper(x) end 
end

local method = {}

method.simple = function (id, passwd )
	if id == 'Admin' and passwd == 'test' then
		return true
	else
		return false
	end
end

method.database_simple = function(id, passwd)
	assert(id, 'Provide userId!')
	assert(passwd, 'provide passwd!')

	local cursor = assert(db_coon:execute(
		("SELECT _user_type, password, name FROM Role WHERE id = '%s'"):format(id)
	))

	local result = cursor:fetch({}, 'a')
	if not result then
		return false, ('No this user:%s'):format( id )
	end

	if password_mapper( passwd ) == result['password'] then
		return true, {name = result.name, type = result._user_type, id = id} 
	else
		return false,  'Wrong password'
	end
end



function AUTH:setToken(id)
	local index
	repeat 
		index = md5.sumhexa( math.random(999999999) )
	until pcall( function()
		self.memcached:add( index,
			{ip = self.ip, user = id },
			self.timeout 
		)
	end)
	
	self.response:set_cookie( self.token, index)
end


--- check id with passwd, is correct match, then login
-- @return boolean value points if is loged now
function AUTH:login( id, passwd )
	local ok, msg = self:check(id, passwd)
	if ok then
		self:setToken(id)
		USER = id
	end

	return ok, msg
end

function AUTH:check(id, passwd)
	local _check = method[self.method]
	local ok, msg = _check( id, passwd )

	return ok, msg
end

--- get userId if the current is loged now
-- @return userId or nil
function AUTH:user()
	if not USER then
		local index = self.request.cookies[ self.token ]
		if index then
			local data = self.memcached:get(index)
			if data and data.ip == self.ip then
				USER = data.user 
			end
		end
	end

	return USER
end


--- logout action
-- if user did't login, it'll throw a error
function AUTH:logout()
	local index = USER or self.request.cookies[ self.token ]

	if not index then 
		error 'You cannot logout because you has\'t login.' 
	end

	self.memcached:delete( index )
	self.response:delete_cookie( self.token )
	USER = nil

	return true
end
