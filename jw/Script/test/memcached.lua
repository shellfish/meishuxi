local mem = require "tr.store.memcached"

local co = mem.new({})

co:set('index1', {a = {"清水", "蓝天", '莲花'}})

for k, v in ipairs( co:get('index1').a ) do
	print( v )
end
