(function(_M) {
	_M = dojo.provide('lib.test.testRoot')
	dojo.require('lib.dijit.WholePage')

	lib.core = {}
	_M.bindApp = lib.core.bindApp = function() {

			
		var root = new lib.dijit.Root({
		})
		root.placeAt(dojo.body())
		root.startup()
	}

})()
