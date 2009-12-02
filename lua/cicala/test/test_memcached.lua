local config = ... 


Test_memcached = {}

function Test_memcached:setUp()
	require'cicala.persist.memcached'
	self.instance =  cicala.persist.memcached.new(  ) 
end


function Test_memcached:test_simple_set_and_get()
	self.instance:set('a', 'hello world')
	print('\t => test get')
	print( '\tsuccess get ', assert( self.instance:get('a') ))
end

function Test_memcached:test_table_serialize()
	self.instance:replace('a', {a = { b = {{{{ 'hello world' }}} }  }})	

	require'cicala.util.serialize'
	print('\t success get ', 
		assert( cicala.util.serialize( self.instance:get('a') ) )
	)
end

LuaUnit:run( 'Test_memcached' ) 
