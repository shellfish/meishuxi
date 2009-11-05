/*
  建立可视的布局
*/
(function(_M) {
	_M = dojo.provide('app.ui.visual')
	dojo.require('dijit.layout.BorderContainer')
	dojo.require('dijit.layout.ContentPane')
	dojo.require("dijit.Toolbar");
	dojo.require("dijit.ToolbarSeparator");
	dojo.require("dijit.form.Button");
	dojo.require('dijit.layout.AccordionContainer')


	// 建立header
	function buildHeader()
	{

		// 加入工具栏
		var toolbar = new dijit.Toolbar({ style:"height:2em;", region:'top'})

		dojo.forEach([ ['login' ,"登入"], ['logout', '登出'], ['about','关于'] ].reverse(), function( item ) {
			var label = item[1],
				 signal = item[0]
			// new button
			var button = new dijit.form.Button({
				id:signal + ':button',
				label:label,
				showLable:true,
				style:'float:right;',
				onClick:function() { dojo.publish('ui/' + signal);  }
			})		
			toolbar.addChild(button)
		})
		var toolbar_prompt = new dijit.layout.ContentPane({
			id:"toolbar_prompt",
			style:" float:right; font-size:1.3em; color:#29189C;",
			setUserInfo:function( arg ) {
				if ( dojo.isString( arg ) ) {
					this.setContent( arg )
				} else if ( dojo.isObject( arg ) ) {
					var type = arg.userType.teacher && '老师' || '同学'
					var content = 	type + '<span style="color:#BD0E19;">'
						+ arg.user + "</span>" + '你好！'
					this.setContent(content)
				} else {
					this.setContent('你还未登录')
				}
			}
		})

		toolbar_prompt.setUserInfo()
		toolbar.addChild( toolbar_prompt )
		


		
		// logo
		var logo =	new dijit.layout.ContentPane({
				region:'center',
				content:'<img src="/img/banner.jpg" style="width:100%; height:100%;">'
			}) 

		var container = new dijit.layout.BorderContainer({
			style:'height:100px; background:green;',
			region:'top',
			gutters:false
		})
		container.addChild(toolbar)
		container.addChild(logo)

		return container
	}


	/*
	* 建立导航试图
	*/
	function createNavigator()
	{
		var container = new dijit.layout.AccordionContainer({
			id:'navigator',
			style:"width:15%;",
			region:"left",
			splitter:"true"
		})	

		var content = {
			general:"公共",
			student:"学生",
			teacher:"教师",
			tutor:"班主任",
			clerk:"教学秘书"
		}
		for (var k in content)
		{
			var label = content[k]
			var tabPane = new dijit.layout.ContentPane({
				id: k + ":navigator",
				content:label + "功能#TODO",
				title:label,
			})
			container.addChild(tabPane)
		}
		
		return container
	}

	/*
	*  返回新建的布局对象container
	*/
	_M.init = function( wrapper_id ) 
	{
		var header = buildHeader()
		/*var navigator = new dijit.layout.ContentPane({
				style:"width:15%; background:blue;",
				splitter:true,
				region:"left"
			})*/

		var navigator = createNavigator()
		var workspace = new dijit.layout.ContentPane({
				style:"background:black;",
				region:"center"
			})
		var statusbar = new dijit.layout.ContentPane({
				style:"background:pink; height:1em;",
				region:"bottom"
			})


		var container = new dijit.layout.BorderContainer({
				style:"width:100%; height:100%;"
			}, dojo.byId(wrapper_id) )

		container.addChild( header )
		container.addChild( navigator )
		container.addChild( workspace )
		container.addChild( statusbar )

		container.startup()
	}



})()
