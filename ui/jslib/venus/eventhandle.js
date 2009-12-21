(function(_M) {
	_M=dojo.provide('venus.eventhandle')
	dojo.require('venus.dijit.TabPane')
	// bind all event handle

	_M.bindall = function() {
		var container = dijit.byId('workspace')

		////////////////////////////////////////////////////////////////////
		// toolbar buttons
		dojo.subscribe('ui/about', function() {
			container.addPane(new venus.dijit.TabPane({
				title:'关于系统',
				href:'/'
			}))
		})


		/////////////////////////////////////////////////////////////////////
		// update status
		/////////////////////////////////////////////////////////////////////
		dojo.subscribe('status_updated', function() {
			dojo.publish('navigator/cancelall')
			dojo.publish('navigator/active' + venus.status.get('type'))
		})

	}

})()
