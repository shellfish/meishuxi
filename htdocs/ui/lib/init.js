/* 
建立widget
*/

/*
* 添加模块路径并加载我们的模块
*/
(function() {

var my_lib_prefix = 'mylib' 
dojo.registerModulePath( my_lib_prefix ,'/ui/lib');

function myrequire( lib ) { dojo.require( my_lib_prefix + '.' + lib, true ) }

myrequire( "buildSkelecton" )
myrequire( "bindCallback" )

})()
