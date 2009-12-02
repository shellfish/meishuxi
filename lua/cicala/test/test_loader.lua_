local config = ...
Test_Loader = {}

function Test_Loader:setUp()
	require'cicala.base.loader'
	self.instance =  cicala.base.loader.new(config.LOADER) 
end


function Test_Loader:test_relative_load()
	self.instance:set_search_path('lua/cicala/test/resource')
	
	local tab = self.instance:load('sample')

	for k, v in pairs(tab) do
		print(('\t|%-10s = '):format(k), v)
	end
end

function Test_Loader:test_absolute_load()
	self.instance:set_search_path('/tmp')

	local tab = self.instance:load('tmp')

	for k, v in pairs(tab) do
		print(('\t|%-10s = %s'):format(k, v))
	end
end

LuaUnit:run( 'Test_Loader' )
