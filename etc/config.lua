path.base_dir = '../'

-- database config
database.source = 'jwdb'
database.user = 'jwuser'
database.driver = 'postgres'

--session.expire = 10
session.path = '/dev/shm/'
session.module = 'file'

-- permmission
permmission.cookie_name = 'userhash'


dispatcher.appdir = 'apps'



