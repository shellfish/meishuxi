(function() {
	dojo.registerModulePath( 'app', '/ui/lib/app' ); 
	
	dojo.require('app.core')

	dojo.addOnLoad( function() {
	app.core.bindApp('wrapper')   // 传递dom id
	})

})()
