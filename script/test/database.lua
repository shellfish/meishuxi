local db = require "tr.store.database"
local config = require "tr.default_config"

local coon = db.new( config )

local cursor = assert( coon:execute"SELECT version();" )
local result = cursor:fetch({})
print(result[1])

cursor = assert( coon:execute"SELECT * FROM role")
repeat 
	result = cursor:fetch{}
	if result then
		print(table.concat(result, '\t'))
	end
until not result

