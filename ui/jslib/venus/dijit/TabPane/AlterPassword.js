dojo.require('venus.dijit.TabPane')
dojo.require('dijit.form.Form')
dojo.require('dijit.form.ValidationTextBox')
dojo.require('dijit.form.Button')
dojo.require('dijit.layout.ContentPane')
dojo.require('dijit._Templated')
dojo.require('dijit._Widget')
dojo.require('dijit.Tooltip')

dojo.provide('venus.dijit.TabPane.AlterPassword')

dojo.declare('venus.dijit.TabPane.AlterPassword',
	[dijit._Widget, dijit._Templated] , {
	templateString:dojo.cache('venus', 'dijit/templates/TabPane/AlterPasswordForm.html'),
	widgetsInTemplate:true,
	postCreate:function() {
		var self = this,
		    second = dijit.byId(this.id + '/second')

		second.attr('validator', function( value ) {
			var first = dijit.byId(self.id + '/first')
			return first.value === second.value
		})

		this._form = dijit.byId(this.id + '/form', this.domNode)

		var self = this
		this._form.attr('onSubmit', function() {	
			if (this.isValid()) {
				self.execute()
			}else {
				alert('请完整填写表单')
			}
			return false
		})
	},
	// you shoule over write thie attach point
	execute:function() {
		alert('模拟提交')
		var before_password = dijit.byId(this.id + '/before', this.domNode)
		var password = dijit.byId(this.id + '/first', this.domNode)
	}
})
