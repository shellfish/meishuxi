(function(_M) {
	_M=dojo.provide('venus.eventhandle')
	dojo.require('venus.dijit.TabPane')
	dojo.require('dijit.layout.BorderContainer')

	dojo.require('venus.dijit.TabPane.AlterPassword')

	dojo.require('dojox.grid.DataGrid')
	dojo.require("dojo.data.ItemFileWriteStore");
	// bind all event handle

	_M.bindall = function() {
		var container = dijit.byId('workspace')

		////////////////////////////////////////////////////////////////////
		// toolbar buttons
		dojo.subscribe('sys/about', function() {
			container.addPane(new venus.dijit.TabPane({
				title:'关于系统',
				href:'/'
			}))
		})
		
		dojo.subscribe('user/logout', function(action) { if (!action) {
			var service = venus.rpc.call('authentication', 'post')('logout')

			service.addCallback(function() {
				dojo.publish('ctl/update')

				dojo.publish('ctl/msg', [{
					message:'登出成功',
					type:'debug'
				}])
			})

			service.addErrback(function(err) {
				
				dojo.publish('ctl/msg', [{
					message:err,
					type:'error'
				}])
			})
		}})


		dojo.subscribe('user/info', function(){
			var service = venus.rpc.authentication('info')
			// the model
			var s = {'cells':[[
				{name:'属性', field:'attribute', width:'10em', 
					formatter : function(x) {
						if (x == 'type') return '用户类型'
						if (x == 'id') return '用户名'
						return x
					}
				},
				{name:'值', field:'value', width:'10em', editable:true}
			]]}

			service.addCallback(function(result) {
				var store = new  dojo.data.ItemFileWriteStore({
					data:result
				})
				dojo.connect(store,'onSet', function(i, a, o, n) {
					console.debug(a + ' changed from ' + o + ' to ' + n)
				})

				var grid =  new dojox.grid.DataGrid({
					selectable: true,    // make it can copy
					autoWidth:true,
					store:store,
					structure:s,
					region:'left'
				})

				var container = new dijit.layout.BorderContainer({})
				container.addChild(grid)

				var alter_password = new venus.dijit.TabPane.AlterPassword({
					region:'center'
				})
				container.addChild(alter_password)

				var pane = new venus.dijit.TabPane({title:"查看信息"})
				pane.attr('content', container)
				dijit.byId('workspace').addPane(pane)
				pane.resize()
			})

			service.addErrback(function(err) {
				dojo.publish('ctl/msg', [{
					message:err,
					type:'error'
				}])
			})


		}) // end catch user/info





		/////////////////////////////////////////////////////////////////////
		// update ui by user status
		/////////////////////////////////////////////////////////////////////
		dojo.subscribe('ctl/update', function() {

			function reset()
			{
				var type_list = ['student', 'teacher', 'admin']
				dojo.forEach(type_list, function(t) {
					var sig = new RegExp('^' + t + '/')
					venus.registry.send(sig, ['disable'])
				})
			}

		// update ui by remote status
			var service = venus.rpc.authentication('info')
			service.addCallback(function(result) {
				var items = result.items
				var buf = {}
				dojo.forEach(items, function(item) {
					buf[item.attribute] = item.value
				})
				
				reset()
				var sig = new RegExp('^' + buf.type + '/')
				venus.registry.send(sig, ['enable'])

				dojo.publish('user/login', ['disable'])
				dojo.publish('user/logout', ['enable'])
			})

			// 已经登出
			service.addErrback(function(err) {
				dojo.publish('user/login', ['enable'])
				dojo.publish('user/logout', ['disable'])

				reset()	

				// 关闭已经打开的tab
				var workspace = dijit.byId('workspace')
				dojo.forEach(workspace.getChildren(), function(child) {
					workspace.removeChild( child )
				})
				dojo.publish('sys/about')
			})
		})

	}

})()
