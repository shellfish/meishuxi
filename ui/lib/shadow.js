(function(_M) {
	_M = dojo.provide('lib.shadow')
	dojo.require('lib.dijit.LoginForm')
	dojo.require('dijit.Dialog')
	dojo.require('dojox.widget.Toaster')

	var shadow_widgets = _M.shadow_widgets = {}

	// build login dialog & place it
	// @SIGNAL: action/login_success 
	shadow_widgets.createLoginDialog = function()
	{
		var dialog = new dijit.Dialog({
			id:'login:dialog',
			style:'width:270px; height:110px;',
			title:'登录'
		})

		var form = new lib.dijit.LoginForm({
			id:'login:form',
			url:lib.util.getApi('authentication/login').url,
			postLogin:function(response) {
				dialog.hide()
				// publish topic with arg response
				dojo.publish('action/login_success', [ response.userInfo ])
			}
		})

		dialog.containerNode.appendChild(form.domNode)
		dialog.startup()
	}

	
	shadow_widgets.createSlideToaster = function() 
	{
		var toaster = new dojox.widget.Toaster({
			id:'toaster',
			messageTopic:"msg/toaster",
			positionDirection:'tr-left',
			duration:1000
		})	
		
		toaster.placeAt(dojo.body())
	}

	_M.bind = function()
	{
		// call and build all shadow widgets
		for ( var k in shadow_widgets ) {
			shadow_widgets[k]()
		}
	}




})()
