local base = require'cicala.base'
local util = require'cicala.util'
require'cicala.session'
--[[
local dir = util.path_normalizer((function()
	if base.is_windows then
		return os.getenv('TMP')
	else
		return '/tmp'
	end
end)(), 'dir')
--]]

Test_File = {}

function Test_File:setUp()
	self.instance = cicala.session.new( require'cicala.base'.session )
end

function Test_File:test_1_simple_get()

	print(string.format( '路径是%s', self.instance.path))

	print(self.instance:get('hello'))

	print(self.instance:get'hello wor')
end

function Test_File:test_2_1set()
	print(self.instance:set('hello', 'hello world'))
	print(self.instance:set('hello world', { a = { '你好世界'} }) )
	print( util.finalize() )
end

function Test_File:test_2_2read_again()
	print(self.instance:get('hello'))
	print(self.instance:get('hello world').a[1])
end

LuaUnit:run'Test_File'
