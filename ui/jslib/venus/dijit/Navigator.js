(function(_M) {
_M = dojo.provide('venus.dijit.Navigator')
dojo.require('dijit.layout.AccordionContainer')
dojo.require('dijit.layout.ContentPane')
dojo.require('dijit.Menu')
dojo.require('dijit.MenuItem')


dojo.declare('venus.dijit.Navigator',  dijit.layout.AccordionContainer, {
		'class':'venusNavigator',
		postCreate:function() {

			var self = this
			dojo.forEach(venus.config.nav_list, function( item ){
			var pane = new venus.dijit.NavigatorPane({
				title:item.label,
				actionList:item.items,
				icon:item.iconClass
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
				'class':'venusNavigatorMenu'
			})

			var self = this

			dojo.forEach(this.actionList, function( item ) {

				var menuitem = new dijit.MenuItem({
					label: item.name,
					iconClass:(item.iconClass || self.icon || '') + ' venusIcon',
					postCreate:function() { 	dojo.addClass(this.domNode, 'venusavigatorMenuItemNormal') },
					onClick:function() { dojo.publish( item.signal ) },
					onMouseOver:function() {
						dojo.addClass(this.domNode, 
							'venusNavigatorMenuItemMouseOver')
					},
					onMouseOut:function() {
						dojo.removeClass(this.domNode, 
							'venusNavigatorMenuItemMouseOver')
					}
				})

				menuitem.subscribe(item.signal, function(arg) {
					switch(arg) {
						case 'disable':
							menuitem.attr('disabled', true); break;
						case 'enable':
							menuitem.attr('disabled', false); break;
						default:
							break;
					}
				})
			
				menu.addChild(menuitem)
			})
			
			this.containerNode.appendChild( menu.domNode )
		}
	})

})();
