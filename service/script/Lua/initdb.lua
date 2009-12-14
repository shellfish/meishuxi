local arg = arg or ...

if arg and arg[1] == 'help' then
	print(('use %s init to rebuild total!'):format(arg[0]))
	return false
end

local base = require('cicala.base')
local util = require'cicala.util'
require'cicala.persist.database'


-- 建立连接
local coon = cicala.persist.database.new(base.database)

if arg and arg[1] == 'init' then
	(function()
		local sqlfile = util.path_normalizer'script/sql/tab.sql'
		local sql = io.open(sqlfile):read"*all"
		print(('Rebuild database schema, read from[%s]...'):format(sqlfile))
		assert(coon:execute(sql))
	end)();
end


local role_tab = (function()
	local resultSey = {}

	local rawfile = util.path_normalizer'script/raw/role_info.txt'
	print('read raw text from:' .. rawfile .. '...')
	for l in io.lines(rawfile) do
		local line = {}
		line.id, line.name, line.sex, line.politics, line.year = unpack(util.split(l, '\t'))

		table.insert(resultSey, line)
	end

	return resultSey
end)();


-- 开始会话
--assert(coon:execute('BEGIN;'));
assert(coon:setautocommit(false));

(function()
	local stat = [[
	INSERT INTO Student(id, name, sex, politics, sign_year) VALUES(
		'%s', '%s', %s, %s, 	'%s');]]
	print('Build Role info items...')
	for k, v in ipairs(role_tab) do
		assert(coon:execute( stat:format(v.id, v.name, v.sex, v.politics, v.year))	)
	end



	print'new teacher'
	assert(coon:execute([[
		INSERT INTO Teacher(id, name, sex) VALUES('teacher', '老师甲', '1');
	]]))

	print'new admin'
	assert(coon:execute([[
		INSERT INTO Admin(id, name, sex) VALUES('admin', '管理员乙', '1');
	]]))


	print'update password'
	local last_role_list = assert(coon:execute([[
		SELECT id FROM Role;
	]]))
	local role_id = (last_role_list:fetch{})
	local template = [[UPDATE Role SET password = '%s' WHERE id = '%s';]]

	while role_id do
		role_id = role_id[1]

		-- update
		assert(coon:execute(template:format(
			base.permmission.shadow_password(role_id),
			role_id
		)))

		-- another fetch
		role_id = (last_role_list:fetch{})
	end

	

	-- 更新初始密码
--	assert( coon:execute([[UPDATE Role AS orig SET password = (SELECT id FROM Role WHERE id = orig.id);]]) )
end)()

-- 提交会话
assert(coon:commit())
