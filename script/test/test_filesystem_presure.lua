require'cicala.util'
require'cicala.session'
require'ex'
local base = require'cicala.base'
local sleep = os.sleep

Test_pressure = {}

local buf = {}

function Test_pressure:setUp()
	self.instance = cicala.session.new( base.session )
end

function Test_pressure:test_1()
	print'step 1, 写入1000 items'
	for k = 1,1000 do 
		local id = self.instance:create(k)
		buf[k] = id 
	end

	cicala.util.finalize()
end

function Test_pressure:test_2()
	print'step 2, 读取1000 item'
	for k, v in ipairs(buf) do
		print(self.instance:get(v))
	end

	cicala.util.finalize()
end


function Test_pressure:test_3()
	print'step 3, 读取1000 itemfter 1s'
	
	for k, v in ipairs(buf) do
	--	sleep(0.05)
		print(self.instance:get(v))
	end

	cicala.util.finalize()
end

function Test_pressure:tearDown()
	cicala.util.finalize()
end

LuaUnit:run()
