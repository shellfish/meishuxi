(function(_M) {
	_M = dojo.provide('venus.base')	

	var config = dojo.require('venus.config')
	var rpc = dojo.require('venus.rpc')
	// init rpc module
	rpc.init(config.service_url, function() {
		var i = callback_wait_queue.pop()
		while (i) {
			i()
			i = callback_wait_queue.pop()
		}
		delete(callback_wait_queue)
	})

	var callback_wait_queue = []

	function register_callback( callback )
	{ 
		if (typeof(callback_wait_queue) === 'undefined') {
			callback()
		}else {
			callback_wait_queue.push(callback) 
		}
	}

	// when every needed mod has loaded, call tha callback
	// else hang it and wait
	venus.ready = function(callback) {
		register_callback(callback)
	}
})();
