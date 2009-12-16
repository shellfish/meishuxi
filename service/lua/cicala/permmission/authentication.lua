local error, assert, pcall = error, assert, pcall
local setmetatable = setmetatable
local md5 = require'md5'
local setfenv = setfenv
local assert = assert 
-- 凡是涉及http对象的，都放在回调里
-- 因为在初始化时，http对象还没有生成

--[[ session 里的数据大致是
 [sessionid] = {
		user = '12345', -- user login id
 }
]]--

module(...)

function new( config, registry )
	local obj = setmetatable({}, {__index = _M})
	
	setfenv(function()
		cookie_name = assert(config.cookie_name)
		cookie_path = config.cookie_path
		cookie_domain = config.cookie_domain
		cookie_key = config.cookie_key or '2d%a1c2d_=8c(c384fa1/af0d6]15ab8'
		shadow_password = config.shadow_password or function(x) return x end

		_registry = registry
	
		_dbc = assert(registry.dbc)
		_http = registry.http
		_session = registry.session
		-- refer to user himself
		me = nil
	end, obj)();


	return obj
end

-- get cookie which name corespond self.cookie_name
function get_token(self)
	local raw_data = self._http:get_cookie(self.cookie_name)
	return raw_data and md5.decrypt(raw_data, self.cookie_key) or nil 
end

-- write sessionid back to cookie
function set_token(self, value)
	if not value then
		self._http:delete_cookie( self.cookie_name )
	else
		self._http:set_cookie(self.cookie_name, {
			value = md5.crypt( value, self.cookie_key ),
			domain = self.cookie_domain,
			path = self.cookie_path
		})
	end
end

function get_guest_ip(self)
	return self._http.servervariable['REMOTE_ADDR']
end

-- 怪异的用法，没抛出错误就是验证成功
-- if pass every assert throw nothing, mean valid 
function validate(self, user, password)
	assert(user, 'Provide user id!')
	assert(password, 'provide password!')

	local dbc = self._dbc
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
		local sessionid = self:get_token()
		if sessionid then
			local data = self._session:get( sessionid )
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
		self.me = user
		local sessionid = self._session:create{user = user, ip = self:get_guest_ip()}
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
	self._session:delete( sessionid )
	-- clear cookie
	self:set_token()
	-- clear module cache
	self.me = nil	
end
