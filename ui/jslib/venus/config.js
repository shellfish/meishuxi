(function(_M) {
	_M = dojo.provide('venus.config')

	_M.service_url = '/service/script/meishuxi.ws'	
	_M.theme = 'soria'

	_M.toolbar_buttons = [ 
					['ui/login' ,"登入"], 
					['ui/logout', '登出'], 
					['ui/about','关于'] 
				]
	_M.nav_list = [
		{
			label:'公共',
			items:[{
				name:'系统研发',
				signal:'newtab/dev'
			}]
		},
		{ 
		  	label:'学生',
		  	items:[
		  	{
				name:'查看信息',
				signal:'newtab/information'
			},
			{
				name:'提交作品',
				signal:'newtab/uploadwork'
			},
			{
				name:'查看分数',
				signal:'newtab/viewscore'
			},
			{
				name:'修改密码',
				signal:'newtab/alterpassword'
			}
		]},
		{
			label:'教师',
			items:[
			{
				name:'查看信息',
				signal:'newtab/information'
			},
			{
				name:'提交分数',
				signal:'newtab/commitscore'
			}
		]},
		{
			label:'管理员',
			items:[
			{
				name:'查看学生信息',
				signal:'viewstudent'
			},
			{
				name:'查看教师信息',
				signal:'viewteacher'
			}
		]}
	]

	
})();
