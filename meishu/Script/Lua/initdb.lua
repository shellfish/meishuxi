if arg[1] == 'help' then
	print(('use %s init to rebuild total!'):format(arg[0]))
	return false
end

local util = require"tr.util"
require"tr.store"
local config = require('tr.default_config')
local base_path = config.NODE_LOAD_PATH:match([[^(.+)/.-$]])

-- 建立连接
local coon = tr.store.database.new(config);

if arg[1] == 'init' then
	(function()
		local sqlfile = base_path .. '/Script/sql/tab.sql'
		local sql = io.open(sqlfile):read"*all"
		print(('Rebuild database schema, read from[%s]...'):format(sqlfile))
		assert(coon:execute(sql))
	end)();
end


local role_tab = (function()
	local resultSey = {}

	local rawfile = base_path .. '/Script/raw/role_info.txt'
	print('read raw text from:' .. rawfile .. '...')
	for l in io.lines(rawfile) do
		local line = {}
		line.id, line.name, line.sex, line.politics, line.year = util.split(l, '\t')

		table.insert(resultSey, line)
	end

	return resultSey
end)();


(function()
	local stat = [[
	INSERT INTO Student(id, name, sex, politics, sign_year) VALUES(
		'%s', '%s', %s, %s, 	'%s');]]
	print('Build Role info items...')
	for k, v in ipairs(role_tab) do
		assert(coon:execute( stat:format(v.id, v.name, v.sex, v.politics, v.year))	)
	end

	print('UPDATE Role.password(和用户名相同)...')
	assert(coon:execute('UPDATE Role AS orig SET password = (SELECT id FROM Role WHERE id = orig.id);'))
end)()
