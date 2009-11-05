(function( _M ) {

	_M = dojo.provide('app.core')
	dojo.require('app.ui.visual')
	dojo.require('app.ui.hide')
	dojo.require('app.callbacks')
	dojo.require('dijit.layout.BorderContainer')
	dojo.require('dijit.layout.ContentPane')
 
	_M.bindApp = function( wrapper_id ) 
	{
		// 建立流式布局
		app.ui.visual.init( wrapper_id )
		// 填充独立部件
		app.ui.hide.init()
		// 绑定和触发初始事件

		app.callbacks.init()


		dojo.publish('all_finish')
			

	}






})()
