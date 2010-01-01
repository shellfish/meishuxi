
path.base_dir = '..'

-- database config
database.source = 'jwdb'
database.user = 'jwuser'
database.driver = 'postgres'
database.initstat = 'SET SEARCH_PATH=meishuxi;'

--session.expire = 10
session.path = 'var/cache'
session.module = 'file'
session.expire = 600
session.digest = 'sha1'

-- permmission
permmission.cookie_name = 'userhash'
permmission.cookie_key = 'dk023kgff.fa1/af0d6]15ab8'

local digest = require'sha1'.digest
permmission.shadow_password = function(x) 
	return digest(x .. 'wicj832jd"dksdds]w[e\hbJQAHBdsjMD23893')
end

dispatcher.appdir= 'apps'

-- debug mode
--DEBUG = true



