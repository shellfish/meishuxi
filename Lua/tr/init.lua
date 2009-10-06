----------------------------------------------------------------------------
-- @release Main module  [AT] Mon Oct  5 23:19:47 CST 2009
----------------------------------------------------------------------------

require "tr.store"
require "tr.permmission"


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
-- Do main process
-- @parma request wsapi request object
-- @parma response wsapi response object
function TR:main( request, response )
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
	response:write( "It Works!" )


	if not self.authentication.user() then
		response:write"LOG IN ..."
		self.authentication:login("Admin", "test")
	else
		response:write(self.authentication:user() .. "Has loged in!")
	end



	

end
