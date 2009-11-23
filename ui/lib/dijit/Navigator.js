(function(_M) {
	_M = dojo.provide('lib.dijit.Navigator')
	dojo.require('dijit.layout.AccordionContainer')
	dojo.require("dijit.MenuBarItem");
	dojo.require("dijit.Menu");
	dojo.require('dijit.layout.ContentPane')

	// define Navigator
	dojo.declare('lib.dijit.Navigator', dijit.layout.AccordionContainer, {
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
			dojo.style( this.domNode, 'display', 'block')
			this.getParent().layout()
		},

		hide:function() {
			dojo.style( this.domNode, 'display', 'none')
			this.getParent().layout()
		}
	})

	// defined NavigatorPane
	dojo.declare('lib.dijit.NavigatorPane', dijit.layout.ContentPane, {
		actionList:[{name:"doAction", signal:'signal1'}],
		style:'background:silver;',
		postCreate:function() {
		
			//this.addClass('custom navgator')
			dojo.addClass( this.domNode, 'customNavigator')

			// use this.actionList to init this pane
			var menu = new dijit.Menu({
				style:'width:100%; background:inherit;'
			})

			dojo.forEach(this.actionList, function( item ) {
				menu.addChild(new dijit.MenuItem({
					label: item.name,
					iconClass:'plusIcon',
					postCreate:function() { 	dojo.addClass(this.domNode, 'customNavigatorMenuItemNormal') },
					//style:'font-size:1.4em; height:1.4em;',
					onClick:function() { dojo.publish( item.signal ) },
					onMouseOver:function() {
						dojo.addClass(this.domNode, 
							'customNavigatorMenuItemMouseOver')
					},
					onMouseOut:function() {
						dojo.removeClass(this.domNode, 
							'customNavigatorMenuItemMouseOver')
					}
				}))
			})
			
			this.containerNode.appendChild( menu.domNode )
		}
	})

})()
