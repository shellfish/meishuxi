(function(_M) {
	_M = dojo.provide('lib.test.testGrid')
	dojo.require('dojox.grid.DataGrid')
	 dojo.require("dojo.data.ItemFileReadStore");

	lib.core = {}
	_M.bindApp = lib.core.bindApp = function() {
	

		var store =  new  dojo.data.ItemFileReadStore({
		url:'/service/meishuxi.ws?p=info&action=see&transport=dojo&id=D02395'
		})

		var s = {
			cells:[
				[
					{name:'属性', field:'attribute', width:'10em'},
					{name:'值', field:'value', width:'10em'}
				]
			]
		}

		var root = new dojox.grid.DataGrid({
			selectable: true,    // make it can copy
			autoWidth:true,
			store:store,
			structure:s
		})

		root.placeAt(dojo.body())
		root.startup()

			
	}

})()
