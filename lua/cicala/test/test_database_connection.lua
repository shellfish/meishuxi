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

function Test_Database:test_version()
	local cursor = self.coon:execute[[SELECT version();]]
	print('\t|',(cursor:fetch{}[1]))
	cursor:close()
end

function Test_Database:test_current_time()
	local cursor = self.coon:execute[[SELECT current_time;]]
	print('\t|',(cursor:fetch{}[1]))
	cursor:close()
end

function Test_Database:tearDown()
	self.coon:close()
end

LuaUnit:run( 'Test_Database' )
