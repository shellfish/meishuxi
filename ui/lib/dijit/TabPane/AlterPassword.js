dojo.require('lib.dijit.TabPane')
dojo.require('dijit.form.Form')
dojo.require('dijit.form.ValidationTextBox')
dojo.require('dijit.form.Button')
dojo.require('dijit.layout.ContentPane')
dojo.require('dijit._Templated')
dojo.require('dijit._Widget')
dojo.require('dijit.Tooltip')

dojo.provide('lib.dijit.TabPane.AlterPassword')

dojo.declare('lib.dijit.TabPane.AlterPassword',
	[dijit._Widget, dijit._Templated] , {
//	templateString: dojo.cache('lib', 'templates/AlterPasswordForm.html'),
	templatePath:dojo.moduleUrl('lib', 'templates/AlterPasswordForm.html'),
	widgetsInTemplate:true,
	postCreate:function() {
		var self = this,
		    second = dijit.byId(this.id + '/second')

		second.attr('validator', function( value ) {
			var first = dijit.byId(self.id + '/first')
			return first.value === second.value
		})

		this.attr( '_form', dijit.byId(this.id + '/form') )

		this.attr( '_tooltip', dijit.byId(this.id + '/msg') )

		dijit.byId(this.id + '/commit').onClick = (function() {
			self.execute()
		})
	},
	// you shoule over write thie attach point
	execute:function() {
		alert('模拟提交')
	}
})
