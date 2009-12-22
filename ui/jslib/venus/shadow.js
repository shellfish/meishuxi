(function(_M) {
	_M = dojo.provide('venus.shadow')
	dojo.require('dijit.Dialog')
	dojo.require('venus.dijit.ctl.LoginForm')
	dojo.require('dojox.widget.Toaster')

	var widgets = {}

	widgets.login_dialog = function() {
		var dialog = new dijit.Dialog({
			'class':'venusLoginDialog',
			title:'登录'
		})
		dialog.subscribe('user/login', function(action) { 
			if (action == 'hide') dialog.hide() 
		})
		dialog.subscribe('user/login', function(action) { 
			if (!action) dialog.show() 
		})

		var form = new venus.dijit.ctl.LoginForm({})
		
		dialog.containerNode.appendChild(form.domNode)
		dialog.startup()
	}

	widgets.createSlideToaster = function() 
	{
		var toaster = new dojox.widget.Toaster({
			id:'toaster',
			messageTopic:"ctl/msg",
			positionDirection:'tl-right',
			duration:1000
		})	
		
		toaster.placeAt(dojo.body())
	}


	_M.init = function() {
		for (var w in widgets) {
			widgets[w]()
		}
	}

})();
