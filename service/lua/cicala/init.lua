local require = require
local setmetatable = setmetatable
local setfenv = setfenv
local base = require'cicala.base'
local util = require'cicala.util'
local globals = _G

module(...)


function new_env(http)
	local registry = setmetatable({http = http}, {__index = globals}) 

	setfenv(function()
		-- 按照顺序注册模块

		dbc = require'cicala.persist.database'.new(base.database, registry)
		session = require'cicala.session'.new(base.session, registry)
		authentication = require'cicala.permmission.authentication'.new(base.permmission, registry)
		authorization = require'cicala.permmission.authorization'.new(base.permmission, registry)
		dispatcher = require'cicala.dispatcher'.new(base.dispatcher, registry)
	end, registry)();

	return registry
end


-- 不可重入
function run(http)
	-- add http to runtime
	local registry = new_env(http)
	registry.cicala = _M

	registry.dispatcher( registry )
	registry.session:finalize()
end
