(function(_M) {
	_M = dojo.provide('lib.test.testFileUpload')
	dojo.require('lib.dijit.TabPane.FileInput')

	lib.core = {}
	_M.bindApp = lib.core.bindApp =  function() {

		var root = new lib.dijit.TabPane.FileInput({})	
		dijit.byId('input').startup()
		root.placeAt(dojo.body())
	}

})()
