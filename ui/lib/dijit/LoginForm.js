/*
* 定义用户登录框表单
*/

(function() {
dojo.provide('lib.dijit.LoginForm')
dojo.require('dijit._Templated')
dojo.require('dijit._Widget')
dojo.require('dijit.form.Form')
dojo.require('dijit.form.Form')
dojo.require('dijit.form.Button')
dojo.require('dijit.form.TextBox')
dojo.require('dijit.layout.ContentPane')

// begin class
dojo.declare('lib.dijit.LoginForm', 
	[dijit._Widget, dijit._Templated], {
		
	/******** template ***************/
	widgetsInTemplate:true,
//	templateString: dojo.cache('lib', 'templates/LoginForm.html'),
	templatePath: dojo.moduleUrl('lib', 'templates/LoginForm.html'),


	/******** util for getting inner element ******************/
	// init some properties
	postCreate: function() {
		
		// keep a reference to our form 
		this.form =  this.domNode.getElementsByTagName('form')[0]

		// keep a prompt and the connect button
		this.prompt = function() { return dojo.byId(this.id + ':prompt') }

		var self = this // keep outer this reference
		// callbacks
		dijit.byId(this.id + ':connect').onClick = function() { 
			dojo.hitch(self, 'execute')()
		}
	},

	// main process
	execute: function() {

		var self = this
		self.setPrompt('connectting')

		dojo.xhrPost({
			url: this.url,       // url (without arguments)
			form:this.form,
			handleAs:'json',
			load: function( response ) {

				if ( response.ok === true  ) {
					self.setPrompt()    // clean prompt
					self.postLogin(response) // do attach point
				}else {
					throw( response.msg )
				}
			},
			error: function(err) {
				self.setPrompt('error', err)
			},
			timeout:this.timeout
		})	
	},

	// set prompt 
	// ① connecting ② error
	setPrompt: function( type, msg ) {

		if ( !type ) {
			this.prompt().innerHTML = ''
		} else if ( type == 'connectting' ) {
			this.prompt().innerHTML = 
				'<span style="color:#C9C800;">connecting...</span>' 
		} else if (type == 'error') {
			this.prompt().innerHTML = 
				'<span style="color:red;">' + msg + '</span>' 
		} else {
			console.error('invalid argument:' + type)
		}
	},

	url:null, // form action url,
	timeout:5000, // default timeout 5s

	postLogin: function(response) {}, // attach point called after login successfully

	
	/******** tail element *************************************/
	lastElement: null
})

})() // end of module 
