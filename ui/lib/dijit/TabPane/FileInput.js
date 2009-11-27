dojo.require('dijit._Templated')
dojo.require('dijit._Widget')
dojo.require('dijit.form.Button')
dojo.require('dijit.form.TextBox')
dojo.require('dijit.form.Form')
dojo.require('dojox.form.FileInput')
dojo.require('dijit.form.SimpleTextarea');

(function() {

	dojo.provide('lib.dijit.TabPane.FileInput')

	dojo.declare('lib.dijit.TabPane.FileInput', 
		[dijit._Widget, dijit._Templated], {

		widgetsInTemplate:true,
		templatePath: dojo.moduleUrl('lib', 'templates/CustomFileInput.html'),

		postCreate:function() {

		}
	})

})()
