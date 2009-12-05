local config = ...

Test_Database =  {}

function Test_Database:setUp()
	self.database = require'cicala.persist.database'
	self.coon =  self.database.new( config.database ) 
end

--[[
function Test_Database:test_coonection()
	
end
--]]

function Test_Database:test_const()
	local cursor = self.coon:execute[[SELECT version();]]
	print('\t|',(cursor:fetch{}[1]))

	local cursor = self.coon:execute[[SELECT current_time;]]
	print('\t|',(cursor:fetch{}[1]))
	cursor:close()
end

LuaUnit:run( 'Test_Database' )
