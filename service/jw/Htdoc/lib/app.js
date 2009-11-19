(function() {
	dojo.registerModulePath( 'app', '/ui/jw/lib/app' ); 
	
	dojo.require('app.core')
	app.core.serviceUrl = '/service/jw.ws'

	dojo.addOnLoad( function() {
	app.core.bindApp('wrapper')   // 传递dom id
	})

})()
