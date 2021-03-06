// 我们需要等待
// ① DOM树加载完成
//  注意body, 否则dojo.ready
// ② rpc函数注册完成
//  等待回调信号

// venus.ready等待以上两者完成

//因为一共存在两个需要等待的资源，所以利用异步加载工具

(function(_M) {
	venus = dojo.provide('venus')
	_M = dojo.provide('venus.base')
	dojo.require('venus.config')
	dojo.require('venus.rpc')


	var config = venus.config
	var rpc = venus.rpc

	///////////////////////////////////////////////////////////////////////
	// init rpc module and wait until success
	waiting_queue = []
	var finish = (function() {
		var counter = 2

		function action() {
			var i = waiting_queue.pop()
			while (i) {
				i()
				i = waiting_queue.pop()
			}
			delete(waiting_queue)
		}
		return function() {
			if (--counter == 0) { 
				action()
			}
		}
	})();

	rpc.init(config.service_url, function() { finish() })
	dojo.ready(finish)

	venus.ready = function(callback) {
		if (typeof(waiting_queue) === 'undefined') {
			callback()
		}else {
			waiting_queue.push(callback)
		}
	}

	var raw_asyncLoad = (function() {
 
		var registry = {}
 
		function load(url, callback) {
			callback = callback || function() {}
		  if (url in registry) {
				callback()
		  }else {
				loadSource(url, callback)
		  }
		}

    function loadSource(url, callback){
			url = String(url)

        registry[url] = true
        var node = null
        if (url.match(/.+\.css/)) {
            node = document.createElement("link")
            node.rel = 'stylesheet'
            node.type = 'text/css'
            node.href = url
        }else if (url.match(/.+\.js/)) {
            node = document.createElement("script")
            node.type = 'text/javascript'
            node.src = url
        }else {
            throw('bad type')
        }

	  		/*	
         if (node.readyState){  //IE
              node.onreadystatechange = function(){
                    if (node.readyState == "loaded" ||
                              node.readyState == "complete"){
                         node.onreadystatechange = null;
                         callback();
                    }
              };
         } else {  //Others: Firefox, Safari, Chrome, and Opera
              node.onload = function(){
                    callback();
              };
         }
			*/
		  dojo.connect(node, 'load', callback)
		 
		  if (typeof(dojo.head) == 'undefined') {
				dojo.head = (function() { 
					var head_tag = dojo.query('head')[0]
					return function() { return head_tag }
				})();
			}
		  dojo.head().appendChild(node)
 
    }
    return load
	})();

	venus.asyncLoad = function(url, callback) {
		dojo.ready(function() { raw_asyncLoad(url, callback) })
	}

	venus.asyncLoad(dojo.moduleUrl('dojo', 'resources/dojo.css'))
	venus.asyncLoad(dojo.moduleUrl('dijit', 'themes/' + config.theme 	+ 	'/' + config.theme + '.css'))
	venus.asyncLoad(dojo.moduleUrl('dojox', 'grid/resources/' +
		config.theme + 'Grid.css'))
	venus.asyncLoad(dojo.moduleUrl('dojox', 'widget/Toaster/Toaster.css'))

	venus.asyncLoad(dojo.moduleUrl('venus', 'css/app.css'))

	// add default theme
	dojo.ready(function() {
		dojo.addClass(dojo.body(), config.theme)
	})

})();
