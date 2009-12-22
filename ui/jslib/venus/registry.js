(function(_M) {
	_M = dojo.provide('venus.registry')

	var registry = []

	_M.gen_signal = (function() {
		var count = 0
		return function(name)  { registry[count++] = name; return name	}
	})();

	_M.alias_signal=function(src,result){dojo.forEach( src, function(item) {
		dojo.subscribe(item,function(){dojo.publish(result)})
	})}

	_M.send = function(signal, arg) {
		var reg, str

		if (typeof(signal) == 'object' && signal instanceof RegExp)  {
			reg = signal 
		}else if (typeof(signal) == 'string') {
			str = signal
		}else {
			Throw('invalid argument')
		}

		dojo.forEach(registry, function(item) {
			if (reg && item.match(reg)) {
				console.log(item)
				dojo.publish(item, arg)
			}else{
				if (item == str) { 
					dojo.publish(item, arg)
				}
			}
		})	
	}


})()
