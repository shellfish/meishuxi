local require = require
local setmetatable = setmetatable
local cicala = cicala
local pcall = pcall

module(...)

function new(config)

	local self = setmetatable({}, {__index =_M})

	self.authentication = require'cicala.permmission.authentication'.new(config)

	cicala.registry.authentication = self.authentication
	self.authorization = require'cicala.permmission.authorization'.new(config)
	cicala.registry.authorization = self.authorization
	
	return self
end

-- interface from authentication
function login(self, user, pass)
	return self.authentication:login(user, pass)
end

function logout(self)
	return  self.authentication:logout()
end

function whoami(self)
	return self.authentication:whoami()
end
