(function(_M) {
	_M = dojo.provide('lib.callback')
	dojo.require('lib.dijit.TabPane')
	dojo.require('lib.dijit.DataTable')
	dojo.require('dijit.Dialog')
	dojo.require('dojox.grid.DataGrid')
	dojo.require("dojo.data.ItemFileReadStore");


	
	// 所有的回调链
	var callback_chain = _M.callback_chain =  {}



	/* ui回调
	************************************************************************
	*/ //工具栏about按钮
	callback_chain.ui_about = function()
	{
		dojo.require('lib.dijit.TabPane.AlterPassword')

		dojo.subscribe('ui/about', function() {
			var workspace = dijit.byId('workspace')
			var newPane = new lib.dijit.TabPane({
				title:'关于系统',
				href:lib.util.getResource('about.html')
			})

			workspace.addPane( newPane )
		})
	}
	
	// 工具栏登录按钮
	callback_chain.ui_login = function()
	{
		dojo.subscribe('ui/login', function() {
			var cookie =  dojo.cookie('userInfo')
			if ( !!cookie && !!dojo.fromJson(cookie)) {
				dojo.publish('msg/toaster', [{
						message:'请勿重复登录',
						type:'warning'
				}])
			} else {
				dijit.byId('login:dialog').show()
			}
		})
	}

	callback_chain.ui_logout = function()
	{

		function clean_after_logout()
		{
			// clean cookie
			dojo.cookie('userInfo', null, {path:'/ui/'})	
			// update ui
			dojo.publish('ui/adjust')

			// update tabpanes
			var workspace = dijit.byId('workspace')
			dojo.forEach(workspace.getChildren(), function(child) {
				workspace.removeChild( child )
			})
			dojo.publish('ui/about')
		}

		dojo.subscribe('ui/logout', function() {

			dojo.xhrGet({
				url:lib.util.getApi('authentication/logout').url,
				handleAs:'json',
				load:function(response) {
					if (response.ok)	 {
						// logout success
						clean_after_logout()	
						dojo.publish('msg/toaster', [{
							message:'登出成功',
							type:'message'
						}])
					} else {
						dojo.publish('msg/toaster', [{
							//message:response.msg,
							message:'无法登出，请先登录',
							type:'error'
						}])
					}
				},
				error:function() {
					console.error('cannot load authentication page')
				}
			})	

		})
	}


	// 自动侦测并调整界面样式
	callback_chain.ui_adjust_gui = function()
	{
		dojo.subscribe('ui/adjust', function() {
			// 状态:
			// ① 已登录 有cookie.userHash
			// ② 未登录 无cookie.userHash
			
			//提取userHash
			var nav = dijit.byId('navigator')

			var userInfo = dojo.fromJson( dojo.cookie('userInfo') )
			if ( !!userInfo ) {
				// 提取userType
				
				userInfo.typename = ( userInfo.type == 't' ) && '教师' 
					|| (userInfo.type == 's') && '学生' 
					|| (userInfo.type == 'a') && '管理员' || null

				/*  update ui atom   */
				// update toolbar
				dijit.byId('header').setPrompt('你好！' + userInfo.typename +
				'<a  style="color:#FF8715;" onClick="dojo.publish(\'newtab/information\'); return false">' + userInfo.name + '</a>')

				// update and show navigator
				nav.resetChildren()
				nav.showChild(userInfo.typename)
				nav.show()

			}else {
			// reset( logout )
				nav.hide()
				dijit.byId('header').setPrompt('你好！<span style="color:#FF8715;">访客</span>，你还未登录' )
			}
		})
	}

	/** action signals
	************************************************************************
	**/
	callback_chain.action_login_success = function()
	{
		dojo.subscribe('action/login_success', function(userInfo) {
			// write persisit cookie[userInfo]	
			dojo.cookie('userInfo', dojo.toJson(userInfo), {path:'/ui/'})
			dojo.publish('msg/toaster', [{
							message:'登入成功',
							type:'messge'
						}])
		
			dojo.publish('ui/adjust')
		})
	}

	/*
	* Bind Callbacks for user func
	* they all have prefix "newtab/"
	* */
	callback_chain.newtab = function()
	{
		

		// 查看用户信息
		dojo.subscribe('newtab/information', function() {
			// the model
				var s = {'cells':[[
					{name:'属性', field:'attribute', width:'10em'},
					{name:'值', field:'value', width:'10em'}
				]]}

			var id = dojo.fromJson(dojo.cookie('userInfo')).id

			var store =  new  dojo.data.ItemFileReadStore({
				url:lib.util.getApi('information/see').url + '&id=' + id
			})
		
			var grid =  new dojox.grid.DataGrid({
				selectable: true,    // make it can copy
				autoWidth:true,
				store:store,
				structure:s
			})

			var pane = new lib.dijit.TabPane({title:"查看信息"})
			pane.setContent(grid)
			dijit.byId('workspace').addPane(pane)

		})
	

	// 修改用户密码
		dojo.subscribe('newtab/alterpassword', function() {
			var workspace = dijit.byId('workspace')
			var pane = new lib.dijit.TabPane({
				title:'修改密码'
			})
			
			var body = new lib.dijit.TabPane.AlterPassword({
				execute:function() {
					var self = this
					dojo.xhrPost({
						url:lib.util.getApi("information/alterpassword").url,
						form:self._form.domNode,
						handleAs:'json',
						load:function(response) {
							if ( response.ok === true ) {
								var dialog = (new dijit.Dialog({
									title:'Success',
									content:'修改密码成功'
								}))
								dialog.startup()
								dialog.show()
							}else {
								throw(response.msg)
							}
						},
						error:function(err) {
								var dialog = (new dijit.Dialog({
									title:'Failure',
									content:'<span style="color:red;">Error</span>:' + err
								}))
								dialog.startup()
								dialog.show()
						}
					})
				}
			})

			pane.containerNode.appendChild(body.domNode)
			workspace.addPane(pane)
		})
		/* end of  newtab callbacks *****************************************
	*/}


	// the main METHOD of this modules
	_M.bind = function()
	{
		// call all callbacks
		for ( var k in callback_chain) {
			callback_chain[k]()
		}

	}


})()
