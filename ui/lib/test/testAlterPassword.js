(function(_M) {
	_M = dojo.provide('lib.test.testAlterPassword')
	dojo.require('lib.dijit.TabPane.AlterPassword', true)

	lib.core = {}
	_M.bindApp = lib.core.bindApp =  function() {
		var root = new  lib.dijit.TabPane.AlterPassword({
		id:'root'})
		root.placeAt(dojo.body())
	}

})()
