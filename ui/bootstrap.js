// dojo config
var djConfig = {
//	isDebug:true
};


var bootstrap =   (function() {

	/****************** our configuration **********************************/
	var config = {
		dojoroot : 'jslib/dojo-1.3.2',
		dijittheme : 'soria', 
		// tundra(冻土) soria(蓝色) a11y(辅助) nihilo(绿色)
		service_url : 'service/meishuxi.ws'
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

	var baseUrl = window.location.pathname
	baseUrl = baseUrl.replace(/^(.+)\/.*$/, '$1' + '\/')

	function load_app() {
		dojo.require("dojox.rpc.Service");
		dojo.require("dojox.rpc.JsonRPC");

		service = new dojox.rpc.Service({
			envelope:"JSON-RPC-1.0",
			transport:"POST",
			target:"../service/script/meishuxi.ws",
			services:{
				test_add:{
					parameters:[{ type:"number" }, {type:'number'}]
				},
				test_calculate:{
					parameters:[
						{type:'number', name:'参数1'},
						{type:'number', name: '参数2'},
						{type:'string', name: '操作'}
					]
				}
			}
		});

		dojo.connect(dojo.byId('tri'), 'click' , function() {
			var op1 = Number(dojo.byId('op1').value)
			var op2 = Number(dojo.byId('op2').value)
			var operator = dojo.byId('op').value

			var doit = service.test_calculate(op1, op2, operator)
			doit.addCallback(function(res) {
				alert('result = ' + res)
			})
			doit.addErrback(function(err){
				alert(err)
			})

		})

	}
	var rotated_time = 0
	var flag = setInterval(function() {
			if (typeof(dojo) !== 'undefined') {
				load_app()
				clearInterval(flag)
			}
	} , 10)
})


// is IE
if (navigator.userAgent.indexOf("MSIE")>0) {
	window.onload = bootstrap
}else {
	bootstrap()
}


