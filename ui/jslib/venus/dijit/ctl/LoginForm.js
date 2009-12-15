/*
* 定义用户登录框表单
*/


(function() {
dojo.provide('venus.dijit.ctl.LoginForm')

dojo.require('dijit._Templated')
dojo.require('dijit._Widget')
dojo.require('dijit.form.Form')
dojo.require('dijit.form.Button')
dojo.require('dijit.form.TextBox')
dojo.require('dijit.Tooltip')
dojo.require('venus.base')


// begin class
dojo.declare('venus.dijit.ctl.LoginForm', 
	[dijit._Widget, dijit._Templated], {
		
	/******** template ***************/
	widgetsInTemplate:true,
	templateString:dojo.cache('venus', 'dijit/templates/ctl/LoginForm.html'),

	get_prompt:function() {
		return dojo.byId(this.id + ':prompt')
	},

	setPrompt:function( type, msg ) {
		if ( !type ) {
			this.get_prompt().innerHTML = ''
		} else if ( type == 'connectting' ) {
			this.get_prompt().innerHTML = 
				'<span style="color:#C9C800;">connecting...</span>' 
		} else if (type == 'error') {
			this.get_prompt().innerHTML = 
				'<span style="color:red;">' + msg + '</span>' 
		} else {
			console.error('invalid argument:' + type)
		}
	},


	/******** tail element *************************************/
	lastElement: null
})

})() // end of module 
