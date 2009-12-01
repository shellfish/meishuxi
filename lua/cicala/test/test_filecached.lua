require'cicala.base.filecached'
require'cicala.util'


local config = ...
local mixin = cicala.util.mixin

Test_FileCached = {}

function Test_FileCached:setUp()
	self.instance = cicala.base.filecached.new(mixin( 
		config.LOADER,
		config.SESSION.FILECACHED 
	))
end

function Test_FileCached:test_simple_get()
	print(self.instance:get('test'))
end

LuaUnit:run'Test_FileCached'
