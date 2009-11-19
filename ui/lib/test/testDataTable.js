(function(_M) {
	_M = dojo.provide('lib.test.testDataTable')
	dojo.require('lib.dijit.DataTable')

	lib.core = {}
	_M.bindApp = lib.core.bindApp =  function() {
		var root = new  lib.dijit.DataTable({
			id:'xxx',
			rowSize:2,
			dataSource:[
			{
				key:'学号',
				value:'200704213014'
			},
			{
				key:'姓名',
				value:'费昊'
			},
			{
				key:'英文名',
				value:'Halinton'
			},
			{
				key:'身份证号',
				value:'320902198811183051'
			}
			]
		})

		root.placeAt(dojo.body())	
	}

})()
