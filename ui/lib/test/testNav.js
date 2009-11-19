(function(_M) {
	_M = dojo.provide('lib.test.testNav')
	dojo.require('lib.dijit.Navigator')

	lib.core = {}
	_M.bindApp = lib.core.bindApp =  function() {
		var root = new  lib.dijit.Navigator({
			id:'xxx',
			style:"width:100px; height:300px;"
		})

		root.placeAt(dojo.body())	
		var content = {
				general:"公共",
				student:"学生",
				teacher:"教师",
				tutor:"班主任",
				clerk:"教学秘书"
			}

	for (var k in content)
	{
			var label = content[k]

			var tabPane = new lib.dijit.NavigatorPane({
				title:label,
			})
			root.addChild( tabPane  )
			
	}
		root.startup()
	}



})()
