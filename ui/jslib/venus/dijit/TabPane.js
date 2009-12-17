/*
*  @Module: TabPane
*  @Brief:define classes for "newtab" signal family
*  @summary: the base class lib.dijit.TabPane can promise there is always 
*    at leasyt one panel exists in the "workspace"
*/

(function(_M) {
	_M = dojo.provide('venus.dijit.TabPane')
	dojo.require('dijit.layout.ContentPane')



	dojo.declare('venus.dijit.TabPane', dijit.layout.ContentPane, {
		closable:true,       // 可关闭
		onClose:function() {
			var count = this.getParent().getChildren().length
			return (count == 1) ? false : true
		},
		postCreate:function() {

			//var img_path =	 lib.util.getResource( '/images/background.jpg' )
			// change its background
			//dojo.style( this.domNode, { 'background': 'url(' + img_path + ')' })
		}
	})


})()
