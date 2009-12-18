(function(_M) {
_M = dojo.provide('venus.dijit.Navigator')
dojo.require('dijit.layout.AccordionContainer')
dojo.require('dijit.layout.ContentPane')
dojo.require('dijit.Menu')
dojo.require('dijit.MenuItem')


dojo.declare('venus.dijit.Navigator',  dijit.layout.AccordionContainer, {
		_paneList: {},        // 空列表
		addChild:function(pane) { 
			this.inherited(arguments)	
			this._paneList[pane.title] = pane
		},

		hideChild:function( title ) {
			try {
				var pane = this._paneList[title]
				this.removeChild(pane)
			} catch(error) {
				console.debug('no such pane:' + title)
			}
		},

		// 重置所有的子panel
		// 除了exclude list中的
		resetChildren:function() {
			var children = this.getChildren()
			for ( var k in children ) {
				var child = children[k]
				this.removeChild(child)
			}
		},

		showChild:function( title ) {
			try {
				var pane = this._paneList[title]
				this.addChild( pane )
				this._showChild(pane)
			}catch(error) {
				console.debug('no title:' + title)
			}
		},

		show:function() {
			dojo.style( this.domNode, 'display', 'inline')
			this.getParent().layout()
		},

		hide:function() {
			dojo.style( this.domNode, 'display', 'none')
			this.getParent().layout()
		},

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
