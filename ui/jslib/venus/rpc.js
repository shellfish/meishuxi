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
				sync:true,
				services:result
			})

			for(var k in service)
				_M[k] = service[k]


			callback(service)
		})
	}
})();
