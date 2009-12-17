(function(_M) {
	_M = dojo.provide('venus.shadow')
	dojo.require('dijit.Dialog')
	dojo.require('venus.dijit.ctl.LoginForm')

	var widgets = {}

	widgets.login_dialog = function() {
		var dialog = new dijit.Dialog({
			'class':'venusLoginDialog',
			title:'登录'
		})
		dialog.subscribe('success/login', function() { dialog.hide() })
		dialog.subscribe('ui/login', function() { dialog.show() })

		var form = new venus.dijit.ctl.LoginForm({})
		
		dialog.containerNode.appendChild(form.domNode)
		dialog.startup()

	}

	_M.init = function() {
		for (var w in widgets) {
			widgets[w]()
		}
	}

})();
