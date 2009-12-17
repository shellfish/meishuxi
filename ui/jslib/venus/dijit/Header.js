(function(_M) {
	_M = dojo.provide('venus.dijit.Header')
	dojo.require('dijit.Toolbar')
	dojo.require('dijit.layout.ContentPane')
	dojo.require('dijit.layout.BorderContainer')
	
	dojo.require('venus.config')

	dojo.declare('venus.dijit.Header', 
		dijit.layout.BorderContainer, {
		'class':'venusHeader',
		gutters:false,

		startup:function() {

				var toolbar = new dijit.Toolbar({
					id:this.id +':toolbar',
					'class':'venusToolbar',
					region:'top'
				})

				var banner = new dijit.layout.ContentPane({
					region:'center',
					'class':'venusBanner',
					style:'margin-top:0.17em;',
					content:'<center>美术系招生系统</center>'
				})
				this.addChild(toolbar)
				this.addChild(banner)

				
				// 添加工具栏按钮
				dojo.forEach( venus.config.toolbar_buttons.reverse(), function( item ) {
					var label = item[1],
						signal = item[0]

					toolbar.addChild(new dijit.form.Button({
						label:label,
						style:'float:right;',
						onClick:function() { dojo.publish( signal) }
					})) 
				})
				this.has_startup = true

			
		},

		tailElement:null
	})

})();
