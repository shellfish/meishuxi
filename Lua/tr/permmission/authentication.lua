---------------------------------------------------------------------------
---
-- Access Control => Authentication
----------------------------------------------------------------------------


require "md5"
require 'mime'
module(..., package.seeall)

local AUTH = {}
local USER = nil


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

	self.memcached = tr_object.memcached
	self.database = tr_object.database
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
	if _check(id, passwd) then
		self:setToken(id)
		USER = id
		return true
	else
		return false
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


--- logout action, we assume it'ill never fail
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
