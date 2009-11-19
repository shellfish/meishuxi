(function(_M) {
	_M = dojo.provide('lib.test.testAjax')

	lib.core = {}
	_M.bindApp = lib.core.bindApp =  function() {

		dojo.xhrGet({
			url:'/service/meishuxi.ws?p=api',
			load:function( response ) {
				document.write( response )
			},
			error:function(res) {
			alert(res)
				alert('cannot load:' + this.url)
			},
			timeout:10000
		})

	}

})()
