(function(_M) {
	_M = dojo.provide('venus.rpc')
	dojo.require("dojox.rpc.Service");
	dojo.require("dojox.rpc.JsonRPC");

	_M.init = function(url, callback) 
	{
		callback = callback || function() {}
		var boot_service = new dojox.rpc.Service({
			envelope:"JSON-RPC-1.0",
			transport:"GET",
			target:url,
			services:{api:{}}
		})

		boot_service.api().addCallback(function( result ) {
			var service = new dojox.rpc.Service({
				envelope:"JSON-RPC-1.0",
				transport:"GET",
				target:url,
				services:result
			})

			var post_service = new dojox.rpc.Service({
				envelope:"JSON-RPC-1.0",
				transport:"POST",
				target:url,
				services:result
			})



			for(var k in service)
				_M[k] = service[k]

			_M.call = function(app, method) {
				method = method.toUpperCase()

				switch(method) {
					case 'GET':
						return service[app];
					case 'POST':
						return post_service[app];
					default:
						throw('unknown app');
				}
			
			}

			callback(service)
		})
	}
})();
