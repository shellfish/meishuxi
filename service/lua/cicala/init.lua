local require = require
local setmetatable = setmetatable
local setfenv = setfenv
local assert = assert
local base = require'cicala.base'
local util = require'cicala.util'
local globals = _G

module(...)

local my_dbc = require'cicala.persist.database'.new(base.database, registry)

function new_env(http)
	local registry = setmetatable({http = http}, {__index = globals}) 

	setfenv(function()
		-- 按照顺序注册模块

		dbc = my_dbc 
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

	assert(registry.dbc:commit())
end
