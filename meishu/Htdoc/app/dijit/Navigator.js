(function() {
dojo.provide('app.dijit.Navigator')
dojo.require('dijit.layout.AccordionContainer')


dojo.declare(
	'app.dijit.Navigator', 
	dijit.layout.AccordionContainer, {
		// 主要修改了添加版块和移除版块几个函数
		paneList: {},
		addPane:function( name, pane ) {
			// 添加panel
			this.addChild(pane)
			this.paneList[name] = pane
		},

		hidePane:function( name ) {
					
		},

		showPane: function( name ) {

		}

	}
)


})()
