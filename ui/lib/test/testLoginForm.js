(function(_M) {
	_M = dojo.provide('lib.test.testLoginForm')
	dojo.require('lib.dijit.LoginForm')

	lib.core = {}
	_M.bindApp = lib.core.bindApp = function() {
		var root = new  lib.dijit.LoginForm({
			id:'login',
			url:'/service/meishuxi.ws?p=authentication&action=login&redirect=/ui',
			postLogin:function() { alert('success') }
		})

		root.placeAt(dojo.body())	

		root.startup()

	}
})()
