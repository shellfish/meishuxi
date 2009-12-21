// 此模块在内部维持用户状态表
// 在调用update时， 向服务器读取更新信息 

(function(_M) {
_M = dojo.provide('venus.status')
dojo.require('venus.base')

_M.cache = {}

_M.cache = null
_M.list = null

_M.update = function(callback) {
	var call = venus.rpc.authentication('info')	
	call.addCallback(function(result) {
		_M.cache = result	
		_M.list = (function() {
			var buf = {}
			dojo.forEach(result.items, function(v) {
				buf[v.attribute] = v.value
			})
			return buf
		})()

		if (!callback) {
			dojo.publish('status_updated')
		}else {
			callback()
		}
	})
	call.addErrback(function(err) {
		console.debug(err)
	})
}

_M.get = function(key) {
	return _M.cache && _M.list[key]
}

})()
