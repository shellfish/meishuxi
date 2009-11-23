// dojo config
var djConfig = {
	//isDebug:true
};


var bootstrap =   (function() {

	/****************** our configuration **********************************/
	var config = {
		dojoroot : '/js/dojo-1.4.0b2',
		dijittheme : 'soria', 
		// tundra(冻土) soria(蓝色) a11y(辅助) nihilo(绿色)
		service_url : '/service/meishuxi.ws'
	}


	/* some util func */
	var head = document.getElementsByTagName('head')[0]

	function loadJs( path )
	{
		s = document.createElement("script");	
		s.type = 'text/javascript'
		s.src = path
		head.appendChild(s)
	}

	function loadCss( path )
	{
		s = document.createElement("link");
		s.rel = 'stylesheet'
		s.type = 'text/css'
		s.href = path

		head.appendChild(s)
	}

	// load dojo
	loadJs(config.dojoroot + '/dojo/dojo.js')

	// load source like dojo and its theme
	loadCss(config.dojoroot + '/dojo/resources/dojo.css')
	loadCss(config.dojoroot + '/dojox/grid/resources/' + config.dijittheme + 
		'Grid.css')
	loadCss(config.dojoroot + '/dijit/themes/' + config.dijittheme + '/' + config.dijittheme + '.css')
	
	// dojox - toaster
	loadCss(config.dojoroot + '/dojox/widget/Toaster/Toaster.css')



	function load_app() {

		// add theme class
		dojo.addClass(dojo.body(), config.dijittheme)


		// make a auto suitable baseUrl for index.html or sth
		var baseUrl = dojo.global.location.pathname
		baseUrl = baseUrl.replace(/^(.+)\/.*$/, '$1' + '\/')

		loadCss(baseUrl + 'resource/slice.css')     // 相对于index.html

		dojo.registerModulePath('lib', baseUrl + 'lib/')	

		dojo.require('lib.core')
		// 加入一些环境变量
		lib.core.env = {
			baseUrl:baseUrl,               // 基url
			serviceUrl:config.service_url   // 后台服务url
		}

		// dojo.require('lib.test.testNav')
		//dojo.require('lib.test.testLoginForm')
		//dojo.require('lib.test.testHeader')
		//dojo.require('lib.test.testRoot')
		//dojo.require('lib.test.testDataTable')
		//dojo.require('lib.test.testFileUpload')
		//dojo.require('lib.test.testAjax')
		//dojo.require('lib.test.testAlterPassword')
		//dojo.require('lib.test.testGrid')
		lib.core.bindApp() 
	}

	var rotated_time = 0

	var flag = setInterval(function() {
		try {
			if ( typeof(dojo) !== 'undefined') {
				load_app()
				clearInterval(flag)
			}
		} catch(e) {
		}
	}, 5)
})

// is IE
if (navigator.userAgent.indexOf("MSIE")>0) {
	window.onload = bootstrap
}else {
	bootstrap()
}


