
BEGIN;

--========= 创建模式 ===============
DROP SCHEMA IF EXISTS meishuxi CASCADE;
CREATE SCHEMA meishuxi;

SET search_path TO meishuxi;

-- 性别类型T_ISOSEX: ISO 5218-Codes for the representation of human sexes
--  * 0 = not known,
--  * 1 = male,
--  * 2 = female,
--  * 9 = not applicable.like the gov or a  coo.
CREATE DOMAIN T_ISOSEX AS SMALLINT  CHECK (VALUE IN (0, 1, 2, 9)); 


/*
	DOMAIN:T_POLITICAL
	1 => 群众
	2 => 团员
	3 => 预备党员
	4 => 党员
*/
CREATE DOMAIN T_POLITICS AS INTEGER CHECK (VALUE IN (1, 2, 3, 4, 5));
CREATE DOMAIN T_YEAR AS INTEGER CHECK (VALUE BETWEEN 1000 AND 9999 );
CREATE DOMAIN T_EMAIL AS TEXT CHECK (VALUE LIKE '%@%.%');

CREATE TABLE Role (
	id                TEXT,
	name              TEXT,
	sex               T_ISOSEX,
	politics          T_POLITICS,
	photo_path        TEXT,
	national_identity CHAR(18),
	phone_number      TEXT,
	cell_number       TEXT,
	email             T_EMAIL,
	_user_type        CHAR(1) NOT NULL,

	password     TEXT NOT NULL DEFAULT '54321',       -- 加密后的密码

	PRIMARY KEY(id)
);

CREATE TABLE TestPlace (
	place_id INTEGER PRIMARY KEY,
	place_name TEXT
);

CREATE TABLE Student (
	_user_type CHAR(1) DEFAULT 's',

	id                TEXT PRIMARY KEY,
	sign_year         T_YEAR,      -- 注册年
	graduate_school   TEXT,        -- 毕业学校
	test_place        INTEGER REFERENCES   TestPlace(place_id) -- 考点
) INHERITS (Role);

CREATE TABLE Teacher (
	_user_type CHAR(1) DEFAULT 't',

	id                TEXT PRIMARY KEY,
	level TEXT      -- 职称
) INHERITS(Role);



COMMIT;


