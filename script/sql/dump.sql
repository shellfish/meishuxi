-- 设置默认模式
SET search_path TO "jw";

BEGIN;

--========= 创建模式 ===============
DROP SCHEMA IF EXISTS "jw" CASCADE ;
CREATE SCHEMA "jw";


--=========================================================================
--- CREATE DOMAIN
--- 创建需要的域
--- 一般，部署完毕后不会更改的东西放在域定义中
--=========================================================================
DROP DOMAIN IF EXISTS T_sex;
CREATE DOMAIN T_sex AS char(1)  CHECK (VALUE IN ('M', 'W'));

-- 角色的类型，用互质的整数标识
-- ⑴ 2 => student ||
-- ⑵ 3 => teacher | 7 => clerk | 11 => tutor ||
-- 类型用其乘积标识
DROP DOMAIN IF EXISTS T_category;
CREATE DOMAIN T_category AS integer
	CHECK (VALUE IN (2, 3, 21, 33, 231)); 

DROP DOMAIN IF EXISTS T_id;
CREATE DOMAIN T_id AS bigint CHECK ( VALUE > 0 );
	

-- 角色表， 所有的角色都在其中占有一个ID
DROP TABLE IF EXISTS "role";
CREATE TABLE "role" (
	userId    T_id, 
	userName  text,
	userCategory  T_category,      -- 用户类型: 学生/教师/教秘
	userSex       T_sex,           -- 性别: t-> male | f -> female
	userBorn      date,             -- 出生日期
	passwd        text,            -- 原始密码使用md5加salt散列

	PRIMARY KEY( userId )
);

--======= 学生信息 ===========
DROP TABLE IF EXISTS "student";
CREATE TABLE "student" (
	userId     T_id   REFERENCES "role",
	--classId    integer,
	PRIMARY KEY( userId )
);

--======= 课程信息 ===============
DROP DOMAIN IF EXISTS T_course_type;
CREATE DOMAIN T_course_type AS char(2) CHECK( VALUE IN ('必修', '选修'));

DROP TABLE IF EXISTS "course";
CREATE TABLE "course" (
	courseId          integer      PRIMARY KEY,
	hour_of_credit    smallint,    -- 学分
	type_id           T_course_type, 
	info              text,
	lastedMonth       smallint
);

--======= 排课信息 ===============
DROP TABLE IF EXISTS "lesson";
CREATE TABLE "lesson" (
	lessonId         integer PRIMARY KEY,
	courseId         integer REFERENCES "course",
	teacherId        T_id,
	roomId           integer,
	startDate        date
);

--======= 学院信息 ===============
DROP TABLE IF EXISTS "school";
CREATE TABLE "school" (
	schoolId        integer PRIMARY KEY,
	schoolName      text,
	clerkId         T_id REFERENCES "role" (userId)
);

--======== 专业信息 ==============
DROP TABLE IF EXISTS "major";
CREATE TABLE "major" (
	majorId integer PRIMARY KEY,
	majorName text,
	schoolId     integer REFERENCES school
);


DROP DOMAIN IF EXISTS T_year;
CREATE DOMAIN T_year AS smallint CHECK(VALUE BETWEEN 1900 AND 3000);      -- 年份
--========= 班级信息 ===============
DROP TABLE IF EXISTS "class";
CREATE TABLE "class" (
	classId        integer,
	majorId        integer  REFERENCES major(majorId),
	admissionYear  T_year,       -- 入学年份
	tutorId    T_id     REFERENCES role( userId ),
	PRIMARY KEY (classId)
);
ALTER TABLE student ADD  COLUMN  classId integer  REFERENCES class;


--=====================================================================================================================================================
-- 存储过程
--========================================================================
-- 添加一个tutor --
INSERT INTO "role"(userId, userName,  userCategory, userBorn, userSex) VALUES(1918, '曾海波', 33, '1970-02-02', 'M');

-- 添加clerk --
INSERT INTO "role"(userId, userName,  userCategory, userBorn, userSex) VALUES(99, '赵丹', 21, '1985-09-21', 'W');

--- 添加学院 --- 
INSERT INTO "school"(schoolId, schoolName, clerkId) VALUES( 1, '媒体管理学院',  99);


--- 添加专业  ---
INSERT INTO "major"(majorId, majorName, schoolId) VALUES(42, '信息管理和信息系统', 1);

--- 添加班级 ---
INSERT INTO "class"(classId, majorId, admissionYear, tutorId) VALUES(77, 42, 2007, 1918 );

------
--- 添加学生
------

CREATE FUNCTION addStudent( T_id, text, T_category, T_sex, date, integer)
RETURNS void AS $PROC$
	INSERT INTO "role" VALUES($1, $2, $3, $4, $5);
	INSERT INTO "student" VALUES($1, $6);
$PROC$ LANGUAGE SQL;


SELECT addStudent(200704213014, '费昊', 2, 'M', '1988-11-18', 77);
SELECT addStudent(200704213005, '尹成龙', 2, 'M', '1989-01-01', 77);
SELECT addStudent(200704213006, '王慧慧', 2, 'W', '1989-01-01', 77);




COMMIT;
