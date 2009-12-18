(function(_M) {
_M = dojo.provide('venus.dijit.Navigator')
dojo.require('dijit.layout.AccordionContainer')
dojo.require('dijit.layout.ContentPane')
dojo.require('dijit.Menu')
dojo.require('dijit.MenuItem')


dojo.declare('venus.dijit.Navigator',  dijit.layout.AccordionContainer, {
		_paneList: {},        // 空列表
		'class':'venusNavigator',
		postCreate:function() {

			var self = this
			dojo.forEach(venus.config.nav_list, function( item ){
			var pane = new venus.dijit.NavigatorPane({
				title:item.label,
				actionList:item.items
			})
			self.addChild( pane )
		})

		},
		tailElement:null
})

	// defined NavigatorPane
	dojo.declare('venus.dijit.NavigatorPane', dijit.layout.ContentPane, {
		actionList:[{name:"doAction", signal:'signal1'}],
		'class':'venusNavigatorPane',
		postCreate:function() {

			// use this.actionList to init this pane
			var menu = new dijit.Menu({
				'class':'venusNavigatorMenu',
			//	style:'width:100%;'
			})

			dojo.forEach(this.actionList, function( item ) {
				menu.addChild(new dijit.MenuItem({
					label: item.name,
					iconClass:'arrowIcon',
					postCreate:function() { 	dojo.addClass(this.domNode, 'venusavigatorMenuItemNormal') },
					//style:'font-size:1.4em; height:1.4em;',
					onClick:function() { dojo.publish( item.signal ) },
					onMouseOver:function() {
						dojo.addClass(this.domNode, 
							'venusNavigatorMenuItemMouseOver')
					},
					onMouseOut:function() {
						dojo.removeClass(this.domNode, 
							'venusNavigatorMenuItemMouseOver')
					}
				}))
			})
			
			this.containerNode.appendChild( menu.domNode )
		}
	})

})();
