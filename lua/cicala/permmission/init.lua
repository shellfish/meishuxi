local require = require
local setmetatable = setmetatable

module(...)

function new(config)

	local self = setmetatable({}, {__index =_M})

	self.authentication = require'cicala.permmission.authentication'.new(config)
	self.authorization = require'cicala.permmission.authorization'.new(config)
	
	return self
end

-- interface from authentication
function login(self, user, pass)
	return authorization:login(user, pass)
end

function logout(self)
	return  pcall(function() authentication:logout() end)
end

function whoami(self)
	return authentication:whoami()
end





