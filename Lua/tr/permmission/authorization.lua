----------------------------------------------------------------------------
--- Access Control second Wall: Authorization
-- with some cache support
---------------------------------------------------------------------------


module(..., package.seeall)

local AUTHORIZATION = {}

function new( tr_object )
	local obj = setmetatable({}, {__index = AUTHORIZATION} )
	obj:init( tr_object )
	return obj
end


function AUTHORIZATION:init( tr_object )
	self.authentication = tr_object.authentication
	self.database  = tr_object.database
	self.request  = tr_object.request

	self.check_chain = {}
end


-- @return the ENV context sandbox "table"
function AUTHORIZATION:make_basic_environment()
	local ENV = { all_user = {} }
	

	function ENV.allow( user )
		group = assert( user )
		user = tostring( user )
		table.insert(
			self.check_chain, 
			function(id) 
				if  group == ENV.all_user then
					return true
				else
					id = tostring(id); 
					if id  == user then 
						return true  
					end 
				end
			end
		)
	end

	function ENV.type( user )
		user = tostring( assert( user ))

		local cursor = assert( self.database:execute(string.format(
		"SELECT userCategory FROM role WHERE userId = %s;", user )))
		local result = cursor:fetch({})[1]
		

		local roles = {}
		if result % 2 == 0 then  roles.student = true end
		if result % 3 == 0 then  roles.teacher = true end
		if result % 7 == 0 then  roles.clerk   = true end
		if result % 11 == 0 then roles.tutor   = true end

		return roles
	end


	function ENV.get_tutor( user )
		self.database:execute([[SELECT ]] )

		return "1234567"
	end

	-- just for debug
	function ENV.error( msg )
		error(msg)
	end

	
	return ENV
end

function AUTHORIZATION:make_engine( auth_statement  )
	local user = self.authentication:user()

	local basic_env = self:make_basic_environment()
	
	local environment = setmetatable(
		{ GET = self.request.GET, POST = self.request.POST}, 
		{__index = basic_env }
	)

	local stat = assert( loadstring( auth_statement ) )
	setfenv( stat, environment )()
	
	return function( user )
		for _, check in ipairs( self.check_chain ) do
			if check(user) then
				return true
			end
		end
		return false 
	end
end

