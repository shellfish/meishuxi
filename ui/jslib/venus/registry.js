(function(_M) {
	_M = dojo.provide('venus.registry')

	var registry = []

	_M.gen_signal = (function() {
		var count = 0
		return function(name)  { registry[count++] = name; return name	}
	})();

	_M.alias_signal=function(src,result){dojo.forEach( src, function(item) {
		dojo.subscribe(item,function(arg){
			if (!arg) dojo.publish(result)
		})
	})}

	_M.send = function(signal, arg) {
		var reg, str

		if (signal instanceof RegExp)  {
			reg = signal 
		}else if (typeof(signal) == 'string') {
			str = signal
		}else {
			console.error('invalid argument', signal)
		}

		dojo.forEach(registry, function(item) {
			if (reg && item.match(reg)) {
				dojo.publish(item, arg)
			}else{
				if (item == str) { 
					dojo.publish(item, arg)
				}
			}
		})	
	}


})()
