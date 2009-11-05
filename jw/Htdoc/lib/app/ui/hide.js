// define hide layout
(function(_M) {
	_M = dojo.provide('app.ui.hide')
	dojo.require("dijit.layout.AccordionContainer")	
	dojo.require("dijit.layout.TabContainer")	
	dojo.require("dijit.layout.ContentPane")	
	dojo.require('dijit.Dialog')
	dojo.require('dijit.form.Form')
	dojo.require('dijit.form.Button')
	dojo.require('dijit.form.ValidationTextBox')
	dojo.require('app.dijit.LoginForm')



	function initLoginDialog()
	{
		var dialog = new dijit.Dialog({
				id:"login:dialog",
				style:"width:250px; height:100px;",
				title:'登录',
			})

		var form = new app.dijit.LoginForm({
				postLogin:function() { 
					dialog.hide(); 
					this.setPrompt() // clean latter prompt in form
					dojo.publish('signal/login')	
				}
		})

		dialog.containerNode.appendChild( form.domNode )
		dialog.placeAt(dojo.body())

		dialog.startup()
	}

	_M.init = function()
	{
		// login dialog
			initLoginDialog()					

		// init about dialog
			var about_container = new dijit.layout.TabContainer({
				style:"width:400px; height:200px;"
			})
			about_container.addChild(new dijit.layout.ContentPane({
				title:"about",
				content:"<ul>" + 
					"<li>绑定回调 bind_callbacks\n</li>" +
					"<li>建立完整界面\n</li>" +
					"<li>publish\"ui/finish\" signal,完成初始化，比如默认登入、登出\n</li></ul>" 
			}))
			about_container.addChild( new dijit.layout.ContentPane({
				title:"help",
				content:'<p style="color:red;">#TODO</p>'
			}))
		
			var about_dialog = new dijit.Dialog({
				id:"about:dialog",
				title:"about"
			})
			dojo.body().appendChild( about_dialog.domNode )

			about_dialog.setContent( about_container )
			about_dialog.startup()


	}



})()
