require "md5"


local config = require "tr.default_config"
local salt = assert( config.AUTH_PASSWD_SALT )

local db = require "tr.store.database"
local coon = db.new( config )

local cursor = assert( coon:execute"SELECT version();" )
local result = cursor:fetch({})
print(result[1])


local store = {}
cursor = assert( coon:execute"SELECT * FROM role;")
repeat 
	result = cursor:fetch({}, 'a')
	if result then
		table.insert(store, result.userid)
	end
until not result

print( salt )

coon:execute("BEGIN;")
for k, v in ipairs(store) do
	local s = md5.sumhexa( v .. salt )
	local exec = string.format("UPDATE  role SET passwd = '%s' WHERE userId = %s;", s, v)
	print(exec)
	assert( coon:execute(exec) )
end
coon:execute("COMMIT;")






