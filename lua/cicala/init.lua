local base = require'cicala.base'
local util = require'cicala.util'
local dispatcher = require'cicala.dispatcher'
local require, globals = require, _G


module(...)

share = {
	dbc         = require'cicala.persist.database'.new( base.database ), 
	session     = require'cicala.session'.new( base.session )
}


-- init base modules
share.permmission = require'cicala.permmission'.new( base.permmission )
share.dispatcher  = require'cicala.dispatcher'.new( base.dispatcher ) 

-- 不可重入
function run(http)
	-- add http to runtime
	share.http = http

	-- now everything has ready, do custom init
	local before = base.custom and base.custom.before
	if before and type(before) == 'function' then
		before(http)
	end

	share.dispatcher( http )

	local after = base.custom and base.custom.after
	if after and type(after) == 'function' then
		after(http)
	end
end
