local md5 = _G.require'md5'

path.base_dir = '..'

-- database config
database.source = 'jwdb'
database.user = 'jwuser'
database.driver = 'postgres'
database.initstat = 'SET SEARCH_PATH=meishuxi;'

--session.expire = 10
session.path = 'var/cache'
session.module = 'file'

-- permmission
permmission.cookie_name = 'userhash'
permmission.cookie_key = 'dk023kgff.fa1/af0d6]15ab8'

permmission.shadow_password = function(x) 
	return md5.sumhexa(x .. 'wicj832jd"dksdds]w[e\hbJQAHBdsjMD23893')
end


dispatcher.appdir= 'apps'

-- debug mode
--DEBUG = true



