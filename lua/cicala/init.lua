----------------------------------------------------------------------------
-- @release Main module  [AT] Mon Oct  5 23:19:47 CST 2009
----------------------------------------------------------------------------

require'cicala.util'
require'cicala.database'
require'cicala.cache'
require'cicala.permmission'

local setmetatable = setmetatable

module(...)

local CICALA = {}

--- merge config
-- @parma config(is exactly the environment table in service.ws)
-- @return A instance of prototype CICALA
function new( config )
	local obj = setmetatable({}, {__index = CICALA} )
	obj.config = config
	return obj
end

---------------------------------------------------------------------------
--- load and initialize our libraroes
-- @parma request the wsapi.request object plus field request.wsapi_env 
-- @parma response the wsapi.response object
function CICALA:load_libs( request, response )

	-- push sth into self object for convinence
	self.request = request
	self.response = response
	self.wsapi_env = request.wsapi_env

	local config = self.config

	self.database = cicala.base.database.new( config.DATABASE, self )
	self.cache = cicala.base.cache.new( config.CACHE, self )
	self.permmission = cicala.permmission.new( config.PERMMISSION, self )
	self.dispatcher  = cicala.dispatcher.new( config.DISPATCHER  )
end

---------------------------------------------------------------------------
-- Do main process
-- @parma request wsapi request object
-- @parma response wsapi response object
function CICALA:handle_request( request, response )
	self:load_libs( request, response )
	self.dispatcher:run( request, response )

	-- exe finalize methods
	cicala.util.finalize()
end
