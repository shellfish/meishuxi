local error, assert, pcall = error, assert, pcall
local setmetatable = setmetatable

local share = cicala.share
local session = assert(share.session)
local dbc = assert(share.dbc)
-- 凡是涉及http对象的，都放在回调里
-- 因为在初始化时，http对象还没有生成

--[[ session 里的数据大致是
 [sessionid] = {
		user = '12345', -- user login id
 }
]]--

module(...)

function new( config )
	local obj = setmetatable({}, {__index = _M})

	obj.cookie_name = assert(config.cookie_name)
	obj.cookie_path = config.cookie_path
	obj.cookie_domain = config.cookie_domain

	obj.shadow_password = config.shadow_password or function(x) return x end

	local self = obj

	-- cache current user id(not sessiond id)
	self.me = nil

	return obj
end

-- get cookie which name corespond self.cookie_name
function get_token(self)
	return share.http:get_cookie(self.cookie_name)
end

-- write sessionid back to cookie
function set_token(self, value)
	share.http:set_cookie(self.cookie_name, {
		value = value,
		domain = self.cookie_domain,
		path = self.cookie_path
	})
end

function get_guest_ip(self)
	return share.http.servervariable['REMOTE_ADDR']
end

-- 怪异的用法，没抛出错误就是验证成功
-- if pass every assert throw nothing, mean valid 
function validate(user, password)
	assert(user, 'Provide user id!')
	assert(password, 'provide password!')

	local template = nil
	local result = nil

	template = "SELECT _user_type, password, name FROM Role WHERE id = '%s';"
	local cursor = assert(dbc:execute(template:format(dbc:escape(user))))
	result = cursor:fetch({}, 'a')
	assert(result, ('No this user:%s'):format(user))
	
	assert(self.shadow_password( password ) ==  result['password'],
		'Wrong password')
end

function whoami(self)
	if not self.me then
		local sessionid = self:get_sessionid()
		if sessionid then
			local data = session:get( sessionid )
			if data and data.ip == self:get_guest_ip() then
				self.me = data.user
			end
		end
	end

	return self.me
end

function login( self, user, password )
	local ok, msg = pcall(self.validate, self, user, password)
	if ok then
		local sessionid = session:create{user = user, ip = self:get_guest_ip()}
		self:set_token( sessionid )
		return true
	else
		return false, msg
	end
end

-- throw error
function logout(self)
	local me = assert(self:whoami(), 'You cannot logout before login!')

	local sessionid = self:get_token()

	-- clear session
	session:delete( sessionid )
	-- clear cookie
	self:set_token()
	-- clear module cache
	self.me = nil	
end
