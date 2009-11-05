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
end



local method = {}

method.simple = function (id, passwd )
	if id == 'Admin' and passwd == 'test' then
		return true
	else
		return false
	end
end

function method.database( id, passwd )
	local cursor = assert(db_coon:execute(
		string.format("SELECT passwd FROM role WHERE userId = %s;", id)))
	local result = cursor:fetch{}
	
	local passwd_db 
	if not result then
		return false, string.format( 'No this user:%s !', id)
	end
	
	passwd_db = result[1]
	passwd = md5.sumhexa(  passwd ..  assert( global_config.AUTH_PASSWD_SALT ) )

	return passwd_db == passwd, "user & passwd is't vaild match"
end

function AUTH:setToken(id)
	local index
	repeat 
		index = md5.sumhexa( math.random(99999999999) )
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
	local _check = method[self.method]
	local ok, msg = _check( id, passwd )
	if ok then
		self:setToken(id)
		USER = id
		return true
	else
		return false, msg
	end
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
