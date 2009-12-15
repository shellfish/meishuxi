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

	/******** util for getting inner element ******************/
	// init some properties
	postCreate: function() {
	},

	/******** tail element *************************************/
	lastElement: null
})

})() // end of module 
