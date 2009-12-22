(function(_M) {
	_M=dojo.provide('venus.eventhandle')
	dojo.require('venus.dijit.TabPane')
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


		/////////////////////////////////////////////////////////////////////
		// update status
		/////////////////////////////////////////////////////////////////////
		dojo.subscribe('ctl/update', function() {
		// update ui by remote status
			var service = venus.rpc.authentication('info')
			service.addCallback(function(result) {
				var items = result.items
				var buf = {}
				dojo.forEach(items, function(item) {
					buf[item.attribute] = item.value
				})

				var type_list = {'student':true, 'teacher':true, 'admin':true}
				delete(type_list[buf.type])

				for (var t in type_list) {
					var sig = new RegExp('^' + t + '/')
					venus.registry.send(sig, ['disable'])
				}

				dojo.publish('user/login', ['disable'])
				dojo.publish('user/logout', ['enable'])
			})

			// 已经登出
			service.addErrback(function(err) {
				dojo.publish('user/login', ['enable'])
				dojo.publish('user/logout', ['disable'])

				var type_list = {'student':true, 'teacher':true, 'admin':true}
				for (var t in type_list) {
					var sig = new RegExp('^' + t + '/')
					venus.registry.send(sig, ['disable'])
				}
			})
		})

	}

})()
