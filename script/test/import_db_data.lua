require "md5"
require"unicode"

local _CONFIG = require "tr.default_config"
local _SALT = assert( _CONFIG.AUTH_PASSWD_SALT )

local coon = (require "tr.store.database").new( _CONFIG )

local g_stats = {}
function addStat(stat)
	table.insert(g_stats, stat)
end

local generateName = (function() 
		local bai_jia_xin = dofile('./source/百家姓.lua')
		local len = #bai_jia_xin

		function make_family_name() return bai_jia_xin[ math.random(len) ] end
		function make_last_name() 
			function gen() return unicode.utf8.char(math.random(23567, 38463))  end
			if math.random(1, 2) == 1 then
				return gen() 
			else
				return (gen() .. gen()) 
			end
		end
	
		return (function() return  make_family_name() .. make_last_name() end)
	end)(); -- end of make name

function generateSex() return math.random(1,2) == 1 and 'M' or 'W' end


local _ENV = {}
_ENV.teacher_list = {} -- 所有教师的列表
function _ENV:generateTeacher()
	local x
	repeat 
		x = math.random(1000, 9999)
	until (not self.teacher_list[x])
	self.teacher_list[x] = true
	return tostring(x)
end

-- 添加学院
-- 学院表为school，我们可以事先确定一组学院名字，id可以随机或顺序生成
_ENV.school_list =   (function()
	local schools = {'媒体管理', '新闻传播', '理', '工', '文', '播音', '影视艺术', '外国语'}

	for k, v in ipairs(schools) do

		local clerkId = _ENV:generateTeacher()
		local addClerk = [[INSERT INTO role(userId, userName,  userCategory, userBorn, userSex) VALUES(%s, '%s', 21, '1985-09-21', '%s'); ]]
		addStat(addClerk:format( clerkId, generateName(), generateSex() ))

		local stat = "INSERT INTO school(schoolId, schoolName, clerkId) VALUES(%s, '%s学院', %s);"
		addStat(stat:format(k, v, clerkId))	

	end

	return schools
end)();


local major_num = (function()
	local majors = {
		[1] = {'信息管理与信息系统', '文化产业管理', '市场营销'},
		[2] = {'新闻学', '传播学'},
		[3] = {'数学', '物理学', '信息科学'},
		[4] = {'广播电视工程', '数字媒体技术'},
		[5] = {'古代汉语', '对外汉语'},
		[6] = {'播音学'},
		[7] = {'西洋美术', '音乐学'},
		[8] = {'英语','西班牙语'}
	}

	addStat('DELETE FROM major WHERE true;')
	local count = 1
	for k, v in ipairs(majors) do
		for num, name in ipairs(v) do
			local stat = 'INSERT INTO major(majorId, majorName, schoolId)' .. 
				"VALUES(%s, '%s', %s);"

			addStat( stat:format(count , name, k) )

			count = count + 1
		end
	end
	
	return count - 1
end)();

-- generate class for every major
local class_list = (function()
	local count = 1
	local list = {}

	for m = 1, major_num do
		for y = 2004, 2010 do
			local tutorId = _ENV:generateTeacher()
			local addTutor = [[INSERT INTO "role"(userId, userName,  userCategory, userBorn, userSex) VALUES(%s, '%s', 33, '1970-02-02', '%s');]]
			addStat(addTutor:format(tutorId, generateName(), generateSex()))

			local stat = 'INSERT INTO class(classId, majorId, admissionYear, tutorId)'..
				'VALUES(%s, %s, %s, %s);'
			addStat(stat:format(count, m, y, tutorId))
			
			table.insert( list, count, y )  -- 每个classId为key, year为value
			count = count + 1
		end
	end

	return list
end)();

-- add sudent
(function()
	
	local generateClass = (function()
		local class_hash = {}
		return  (function() 
			local num 
			repeat 
				num = math.random(1, 9999)
			until not class_hash[num]

			class_hash[num] = true; 
			num = tostring(num)
			return #num == 4 and num or string.rep('0', 4 - #num) .. num end)
		end)()


	for classId, year in ipairs( class_list ) do
		local total = math.random(27, 59)     -- 班级人数
		local classNum = generateClass()       -- 班级num:string

		for i = 1, total do
			local studentInclass = tostring(i) == 2 and tostring(i) or '0' .. i  --班级内第几个学生

			-- 学号, 姓名， 性别， 出生，班级号
			local stat = "SELECT addStudent(%s, '%s', 2, '%s', '%s', %s);"
			local run = stat:format(year .. classNum .. studentInclass,
				generateName(),
				generateSex(),
				year -  19 + math.random(-1, 2)  .. 
					'-' .. math.random(1,12) .. 
					'-' .. math.random(1, 28),
				classId
			)
			addStat(run)
		end
	end
	
end)();

-- run sql
(function()  

	if arg[1] == 'rebuild' then os.execute('psql < ../sql/dump.sql') end
	local sql = table.concat(g_stats)
	assert(coon:execute("BEGIN;" ..
	sql .. 'COMMIT'))
end)()


