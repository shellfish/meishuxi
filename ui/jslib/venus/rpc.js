(function(_M) {
	_M = dojo.provide('venus.rpc')
	dojo.require("dojox.rpc.Service");
	dojo.require("dojox.rpc.JsonRPC");

	_M.pool = {}
	_M.init = function(url, callback) 
	{
		var boot_service = new dojox.rpc.Service({
			envelope:"JSON-RPC-1.0",
			transport:"GET",
			target:url,
			services:{api:{}}
		})

		boot_service.addCallback(function( result ) {
			var service = new dojox.rpc.Service({
				envelope:"JSON-RPC-1.0",
				transport:"GET",
				target:url,
				services:result
			})

			service.addCallback(function() {
				for (var k in service) 
				{
					alert(k)
					_M[k] = service[k]
				}
				
				callback()
			}) 
		})
	}
})();
