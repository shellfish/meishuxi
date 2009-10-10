----------------------------------------------------------------------------
-- @release Main module  [AT] Mon Oct  5 23:19:47 CST 2009
----------------------------------------------------------------------------
require "Json"

module(..., package.seeall)

TR = {}

--- merge config
-- @parma bootstrap_config
-- @return A instance of prototype TR
function new( bootstrap_config )
	local default_config = require "tr.default_config"
	local config = setmetatable(bootstrap_config, {__index = default_config})
	local obj = setmetatable({}, {__index = TR} )
	obj.config = config
	return obj
end

---------------------------------------------------------------------------
--- load and initialize our libraroes
-- @parma request the wsapi.request object plus field request.wsapi_env 
-- @parma response the wsapi.response object
function TR:load_libs( request, response )

	require "Json"

	require "tr.store"
	require "tr.permmission"
	require "tr.launcher"

	-- push sth into self object for convinence
	self.request = request
	self.response = response
	self.wsapi_env = request.wsapi_env

	-- initialize base utility
	self.database = tr.store.database.new( self.config )
	self.memcached = tr.store.memcached.new( self.config )
	self.loader   = tr.store.loader.new( self.config )

	-- initialize permmission system
	self.authentication = tr.permmission.authentication.new( self )
	self.authorization  = tr.permmission.authorization.new( self )

	self.launcher       = tr.launcher.new( self )
end



---------------------------------------------------------------------------
-- Do main process
-- @parma request wsapi request object
-- @parma response wsapi response object
function TR:handle_request( request, response )
	self:load_libs( request, response )

	-- request for page
	local destination = request.GET.p


	-- get virtual node
	local node = self.loader:load( destination or "" )	
	
	local check_engine = self.authorization:make_engine(node.AccessControl)
	if check_engine( self.authentication:user() ) then

	-- make argument
		local arguments = { GET = request.GET, POST = request.POST }
		output = self.launcher:getJson( node.Run, arguments )

		response.status = 200
		response.header = {['Content-type'] = node.Type }
		response:write( output )
	else
		response.status = 200
		response.header = {['Content-type'] = 'text/javascript' }
		response:write( Json.Encode{result = false, msg = "权限问题" })
	end
end
