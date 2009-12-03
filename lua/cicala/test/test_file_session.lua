local base = require'cicala.base'
local util = require'cicala.util'
require'cicala.session'

local dir = util.path_normalizer((function()
	if base.is_windows then
		return os.getenv('TMP')
	else
		return '/tmp'
	end
end)(), 'dir')

Test_File = {}

function Test_File:setUp()
	self.instance = cicala.session.new{ 
		module = 'file',
		path = dir
	}
end

function Test_File:test_1_simple_get()

	print(string.format( '路径是%s', self.instance.path))

	print(self.instance:get('hello'))

	print(self.instance:get'hello wor')
end

function Test_File:test_2_1set()
	print(self.instance:add('hello', 'hello world'))
	print(self.instance:add('hello world', '你好世界'))
end

function Test_File:test_2_2read_again()
	print( util.finalize() )
	-- reset mem cache copy
	local pool = self.instance.pool
	for k, v in pairs(pool) do
		pool[k] = nil
	end
		
	print(self.instance:get('hello', 'hello world'))
	print(self.instance:get('hello world', '你好世界'))
end

LuaUnit:run'Test_File'
