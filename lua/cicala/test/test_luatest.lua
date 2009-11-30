Test_LuaUnit = {}

function Test_LuaUnit:test_always_succcess()
	assertEquals(1, 1)
	assertError(function() error'sample error' end)
end

function Test_LuaUnit:test_always_success2()
	assertEquals('hello', 'hello')
	assertError(function() return error('西陆蝉声唱，南南冠客思深。') end)
end

LuaUnit:run( 'Test_LuaUnit' )
