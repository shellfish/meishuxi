(function(_M) {
	_M = dojo.provide('venus.core')
	dojo.require('dijit.layout.ContentPane')
	dojo.require('dijit.layout.BorderContainer')
	dojo.require('dojox.layout.ToggleSplitter')
	dojo.require('dijit.layout.TabContainer')

	// import venus.config & venus.rpc
	dojo.require('venus.base')
	dojo.require('venus.eventhandle')
	dojo.require('venus.shadow')

	// custom widgets
	dojo.require('venus.dijit.Header')
	dojo.require('venus.dijit.Navigator')

	function createRoot() {
		var root = new dijit.layout.BorderContainer({
			'class':'venusRoot',
			gutters:true,
			_splitterClass:'dojox.layout.ToggleSplitter'
		}, dojo.byId('wrapper'))
	

		var interval = 30
		var flag = setTimeout((function() {
			var count = 0

			var do_resize

			do_resize = function() {
				if (count == 7) {
					clearTimeout(flag)
				}else {
					root.resize()
					count++
					flag = setTimeout(do_resize, (interval *= 2))
				}
			}

			return do_resize

		})(), interval)

		var header = new venus.dijit.Header({
			region:'top'
		})
		var navigator = new venus.dijit.Navigator({
			region:'left',
			splitter:true,
			style:'width:130px !important;'
		})
		
		var workspace = new dijit.layout.TabContainer({
				id:'workspace',
				region:"center",
				useSlider:true,
				useMenu:true,
				addPane:function( child ) {
					var self = this
					child.attr('getParent', function() { return  self})
					// add scrollbar when needed
					dojo.style(child.domNode, 'overflow', 'auto')
					this.addChild( child )
					this.selectChild( child )
				}
			})

		var statusbar = new dijit.layout.ContentPane({
			'class':'customFooter',
			region:"bottom",
			content:"<center>©Copyright 2009 <a href='http://mms.cuc.edu.cn'>mms.cuc.edu.cn</a> All Rights Reserved</center>",
			'class':'venusFooter'
			})

		with(root) {
			addChild(header)
			addChild(navigator)
			addChild(workspace)
			addChild(statusbar)
		}
		xx = root
		return root
	}



	// load main app
	_M.init = function() {
		var root = createRoot()

		root.placeAt(dojo.body())
		root.startup()

		venus.shadow.init()
		// bind event handle
		venus.eventhandle.bindall()


		////////////////////////////////////////
		// init signal
		dojo.publish('ctl/update')
		dojo.publish('sys/about')
	}

})();
