var baseUrl = window.location.pathname
baseUrl = baseUrl.replace(/^(.+)\/.*$/, '$1' + '\/')
dojo.registerModulePath('venus', baseUrl + 'jslib/venus')	

dojo.require("dojox.rpc.Service");
dojo.require("dojox.rpc.JsonRPC");
dojo.require('venus.rpc')

var a = venus.rpc.add(3, 4).addCallback(function(a) { alert(a) })


