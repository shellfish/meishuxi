local base = require'cicala.base'
local util = require'cicala.util'
local require, globals = require, _G
local setmetatable = setmetatable

module(...)

_M.registry = setmetatable({}, {__index = globals})

-- 不可重入
function run(http)
	-- add http to runtime
	registry.http = http

	registry.dbc        = require'cicala.persist.database'.new( base.database )
	registry.session     = require'cicala.session'.new( base.session )

	-- init base modules
	registry.permmission = require'cicala.permmission'.new( base.permmission )
	registry.dispatcher  = require'cicala.dispatcher'.new( base.dispatcher ) 


	-- now everything has ready, do custom init
	local before = base.custom and base.custom.before
	if before and type(before) == 'function' then
		before(http)
	end

	registry.dispatcher( http )

	local after = base.custom and base.custom.after
	if after and type(after) == 'function' then
		after(http)
	end

	registry.session:finalize()
end
