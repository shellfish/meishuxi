(function(_M) {
	_M = dojo.provide('venus.config')
	// 信号注册表
	var registry = dojo.require('venus.registry')

	var sig = registry.gen_signal
	var alias_sig = registry.alias_signal

	////////////////////////////////////////////////////////////////////////
	// BEGIN config
	///////////////////////////////////////////////////////////////////////
	alias_sig(['student/info', 'teacher/info'],'user/info')

		_M.service_url = '/service/script/meishuxi.ws'	
		_M.theme = 'soria'

		_M.toolbar_buttons = [ 
						{	
							signal:sig('user/login') ,
							label:"登入", 
							iconClass:'plusIcon'
						}, 
						{
							signal:sig('user/logout'), 
							label:'登出', 
							iconClass:'arrowIcon'
						}, 
						{
							signal:sig('sys/about'), 
							label:'关于'
						} 
					]
		_M.nav_list = [
			{
				label:'公共',
				iconClass:'AddIcon',
				items:[{
					name:'系统研发',
					signal:sig('sys/devinfo')
				}]
			},
			{ 
				label:'学生',
				iconClass:'arrowIcon',
				items:[
				{
					name:'查看信息',
					signal:sig('student/info')
				},
				{
					name:'查看分数',
					signal:sig('student/score')
				},
				{
					name:'修改密码',
					signal:sig('student/alterpassword')
				},
				{
					name:'提交作品',
					signal:sig('student/uploadwork'),
					iconClass:'plusIcon'
				}
			]},
			{
				label:'教师',
				iconClass:'AddIcon',
				items:[
				{
					name:'查看信息',
					signal:sig('teacher/info')
				},
				{
					name:'提交分数',
					signal:sig('teacher/commit'),
					iconClass:'plusIcon'
				}
			]},
			{
				label:'管理员',
				iconClass:'AddIcon',
				items:[
				{
					name:'查看学生信息',
					signal:sig('admin/student')
				},
				{
					name:'查看教师信息',
					signal:sig('admin/teacher')
				}
			]}
		]
})();
