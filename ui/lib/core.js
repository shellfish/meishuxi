(function(_M) {
	_M = dojo.provide('lib.core')
	dojo.require('lib.callback')
	dojo.require('lib.shadow')
	dojo.require('lib.util')
	dojo.require('dojo.cookie')
	dojo.require('lib.dijit.WholePage')

	_M.init = function()
	{
		// show default frontpage
		dojo.publish('ui/about')
		// show message for guest 
		dojo.publish('ui/adjust')
	}

	_M.bindApp = function( ) 
	{
		// 读取api列表
		lib.util.parseApiList(function() {
			// 绑定回调
			lib.callback.bind()	

			// 载入隐藏面板
			lib.shadow.bind()


			// 载入根节点
			var root = new lib.dijit.Root({
				//id:'root'     // 依赖此id，不要轻易修改
			})
			root.placeAt(dojo.body())
			root.startup()

			_M.init()
		})
	
	}


})()
