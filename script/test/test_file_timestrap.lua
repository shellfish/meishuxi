local config = ... 

require'ex'

Test_file_session_timestrap = {}

function Test_file_session_timestrap:setUp()
	require'cicala.persist.file'
	self.instance =  cicala.persist.file.new( require'cicala.base'.session) 
end


function Test_file_session_timestrap:test_1_simple_set_and_get()
	self.instance:set('a', 'hello world')
	print('\t => test get')
	print( '\tsuccess get ', assert( self.instance:get('a') ))
	cicala.util.finalize()
	print( '\tsuccess get(imply in one process, expire has no effect) ', assert( self.instance:get('a') ))
end

function Test_file_session_timestrap:test_2_expire_get()
	ex.sleep(1)
	local x = self.instance:get('a')
	print('the result is ', x)
	self.instance:finalize()
end


function Test_file_session_timestrap:test_table_serialize()
	self.instance:set('test', {a = { b = {{{{ 'hello world' }}} }  }})	

	print('\t success get ', 
		assert( cicala.util.serialize( self.instance:get('test') ) )
	)
end

LuaUnit:run( 'Test_file_session_timestrap' ) 
