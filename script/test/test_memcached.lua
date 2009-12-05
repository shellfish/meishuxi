local config = ... 

require'ex'

Test_memcached = {}

function Test_memcached:setUp()
	require'cicala.persist.memcached'
	self.instance =  cicala.persist.memcached.new( { expire = 1  } ) 
end


function Test_memcached:test_1_simple_set_and_get()
	self.instance:set('a', 'hello world')
	print('\t => test get')
	print( '\tsuccess get ', assert( self.instance:get('a') ))
end

function Test_memcached:test_2_expire_get()
	ex.sleep(1)
	local x = self.instance:get('a')
	print('the result is ', x)
end


function Test_memcached:test_table_serialize()
	self.instance:set('test', {a = { b = {{{{ 'hello world' }}} }  }})	

	require'cicala.util.serialize'
	print('\t success get ', 
		assert( cicala.util.serialize( self.instance:get('test') ) )
	)
end

LuaUnit:run( 'Test_memcached' ) 
