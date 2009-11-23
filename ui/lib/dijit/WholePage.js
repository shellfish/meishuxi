// wrap the whole page into one widget

(function(_M) {
	dojo.provide('lib.dijit.WholePage')
	dojo.require('lib.dijit.Navigator')
	dojo.require('dijit.layout.ContentPane')
	dojo.require('dijit.layout.BorderContainer')
	dojo.require('dijit.Toolbar')
	dojo.require('dijit.form.Button')
	dojo.require('dijit.layout.TabContainer')


	function createHeader() 
	{
	
		var header =  new dijit.layout.BorderContainer({
			id:"header",
			gutters:false,
			region:'top',
			style:'height:120px;' //1.4em;'
		});



		( dojo.hitch( header ,function() {
			// build and fill header
			var toolbar = new dijit.Toolbar({
				region:'top',  style:'height:2em;'
			})
		

			this.addChild(toolbar)

			var tool_buttons = ([ 
				['login' ,"登入"], 
				['logout', '登出'], 
				['about','关于'] 
			]).reverse()

			// 添加工具栏按钮
			dojo.forEach( tool_buttons, function( item ) {
				var label = item[1],
					signal = item[0]

				toolbar.addChild(new dijit.form.Button({
					label:label,
					style:'float:right;',
					onClick:function() { dojo.publish('ui/' + signal) }
				})) 
			})

			// 添加工具栏提示
			var prompt = new dijit.layout.ContentPane({
				style:'margin:0.1em; float:left; font-size:1em; color:#29189C; padding:0 20px;',
				setPrompt:function( arg ) {
					if ( dojo.isString( arg ) ) {
						this.attr( 'content', arg )
					} else if ( dojo.isObject( arg ) ) {
						var type = arg.userType.teacher && '老师' || '同学'
						var content = 	type + '<span style="color:#BD0E19;">' + arg.user + "</span>" + '你好！'
						this.attr('content', content)
					} else {
						this.attr('content','你好！访客，请先登录')
					}
				}
			})
			toolbar.addChild(prompt)
			// 将setPrompt添加到header里
			this.setPrompt = dojo.hitch(prompt, 'setPrompt')


			// logo 图片
			
			this.addChild(new dijit.layout.ContentPane({
					region:'center',
					content:lib.util.format('<img src="%s"' + 
					' style="width:100%; height:100%;">', 
					lib.util.getResource('images/mainbanner3.jpg'))
			}))
			


		}) )();

		return header
	}


	function createNavigator()
	{
		var root = new  lib.dijit.Navigator({
			id:'navigator',
			region:'left',
			splitter:true,
			style:'width:15%;'
		})
					
		// 添加导航项目
		dojo.forEach(lib.util.nav_list, function( item ){
			var pane = new lib.dijit.NavigatorPane({
				title:item.label,
				actionList:item.items
			})
			root.addChild( pane )
		})

		root.startup()
		return root
	}

	dojo.declare('lib.dijit.Root', dijit.layout.BorderContainer, {
		style:'width:100%; height:100%;',         // 充满屏幕
		gutters:false,
		startup_has_finished:false,               // 是否完成布局
		startup:function() {
			this.inherited(arguments)

			if (! this.startup_has_finished) {

				// 所有的初始化工作
				var header = createHeader() 
				var navigator = createNavigator()

				var workspace = new dijit.layout.TabContainer({
					id:'workspace',
					region:"center",
					useSlider:true,
					useMenu:true,
					addPane:function( child ) {
						var self = this
						child.attr('getParent', function() { return  self})
						this.addChild( child )
						this.selectChild( child )
					}
				})

				var statusbar = new dijit.layout.ContentPane({
						style:"background:#BFD7F1; height:1.2em; text-align:center;",
						region:"bottom",
						content:"©Copyright 2009 <a href='http://mms.cuc.edu.cn'>mms.cuc.edu.cn</a> All Rights Reserved"
					})

				this.addChild(header)
				 this.addChild(workspace)
				 this.addChild(navigator)
				this.addChild(statusbar)

				this.startup_has_finished = true
			}
		}
	})  // end declare

})()
