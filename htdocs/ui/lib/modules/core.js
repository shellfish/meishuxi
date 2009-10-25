(function() {
/////////////////////// begin /////////////////////////////////////////////

var _M = dojo.provide('app.core')

// import external libs

dojo.require('app.layout')


/*
* export :	bindApp
*/
_M.bindApp = function ( domId )
{
	app.layout.createRootContainer( domId )
}


/////////////////////// end ///////////////////////////////////////////////
})()
