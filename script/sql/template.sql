/*
*   template.sql
*   导入数据库框架
*/

SET search_path TO "jw";

BEGIN;

DROP SCHEMA IF EXISTS "jw" CASCADE;
CREATE SCHEMA "jw";


--========================================================================--

/* -------------- 课程 --------------------*/

CREATE TABLE  school (
	id    integer PRIMARY KEY,
	name  text,
	clerk integer       -- @NEED ALTER TO references cherk
);

CREATE TABLE major (
	Id       integer PRIMARY KEY,
	school   integer REFERENCES school(id),
	name     text         -- 专业名
);

CREATE TABLE class (
	Id       integer PRIMARY KEY,
	major    integer REFERENCES major(id),
	joinDate date         -- 入学日期
);


/* *********************     角色      ********************           */
-- 
CREATE DOMAIN userId AS varchar(20);

CREATE TYPE userInfo AS (
	sex  boolean,          -- true => 男
	name text,
	born date,
	id   varchar(15)       -- 身份证号
);

CREATE TABLE  role (
	id         userId        PRIMARY KEY,
	category   integer[],
	Info       userInfo,
	password   text NOT NULL 
); 

CREATE TABLE  student (
	class   integer REFERENCES class(id),
	id      userId REFERENCES role(id) PRIMARY KEY
);

CREATE TABLE teacher (
	id        userId     REFERENCES role(id) PRIMARY KEY,
	lessons   integer[]
);

CREATE TABLE clerk (
	id        userId  REFERENCES role(id) PRIMARY KEY,
	school    integer REFERENCES school(id)
);

CREATE TABLE tutor (
	id        userId    REFERENCES role(id)  PRIMARY KEY,
	classId   integer   REFERENCES class(id)
);

/* ************** 实体 **********************/


CREATE TABLE  course (
	id        integer PRIMARY KEY,
	info      text
);

CREATE TABLE lesson (
	id        integer PRIMARY KEY,
	course    integer REFERENCES course(id),
	teacher   userId  REFERENCES teacher(id),
	open      date NOT NULL,        -- 开始日期
	close     date NOT NULL        -- 结课日期
);

-- 选课信息
CREATE TABLE  choose (
	studentId    userId    REFERENCES student(id),
	lessonId     integer   REFERENCES lesson(id)
);

ALTER TABLE school DROP COLUMN clerk ,ADD COLUMN clerk userId REFERENCES clerk(id);

COMMIT;

