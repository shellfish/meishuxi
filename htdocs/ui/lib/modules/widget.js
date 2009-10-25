/*
* 创建标准的dojo小部件
*/

(function() {
///////////////////////////////////////////////////////////////////////////
var _M = dojo.provide('app.widget')

/* 建立 login dialog */
function createLoginDialog() {
	var login_submit_button = dijit.form.Button({
		label:"登录",
		onClick:function() {
			alert('hello')	
		}
	})
	var login_dialog = new dijit.Dialog({ title:"登录", id:"login_dialog"})
	login_dialog.addChild( login_submit_button )

	dojo.body().appendChild( login_dialog.domNode )

} // end

_M.createWidget = function() {
	createLoginDialog()
}


///////////////////////////////////////////////////////////////////////////
})()
