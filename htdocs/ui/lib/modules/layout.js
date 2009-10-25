/*
*  functions to build basic layout
*/

(function() {
/////////////////////// begin /////////////////////////////////////////////


var _M = dojo.provide('app.layout')

dojo.require('app.widget')
dojo.require('dijit.dijit')
dojo.require('dijit.layout.BorderContainer')
dojo.require('dijit.layout.ContentPane')
dojo.require('dijit.form.Button')
dojo.require('dijit.Dialog')


var COPYRIGHT_MESSAGE = new dijit.layout.ContentPane({
	content:"Copyright © 2009 app - cuc-mms Lab. All Rights Reserved.",
	id:"footer",
	style:"color:red;"
})

/*
* export func: createHeader
*/
function createHeader() {
	var statusbar = new dijit.layout.ContentPane({
		id:'statusbar',
		region: "center",
		style:"background:inherit; height:2em;",
		content:"&nbsp;&nbsp;你还未登录"
	})

	var menubar  = new dijit.layout.BorderContainer({
		region: "right",
		style:"background:inherit; height:2em; width:30%;"
	})
	
	var login_button = new dijit.form.Button({
		id:"login_button",
		label:"登录"
	})

	var logout_button = new dijit.form.Button({
		id:"logout_button",
		label:"登出"
	})

	var about_dialog = new dijit.Dialog({
		title:'关于我们',
		content:'<span style="color:red;">##TODO</span>',
		style:"width:300px; height:100px;"
	})
	dojo.body().appendChild( about_dialog.domNode)

	var about_button = new dijit.form.Button({
		id:"about_button",
		label:"about",
		onClick:function() {
			about_dialog.show()
		}
	})

	
	menubar.addChild(login_button)
	menubar.addChild(logout_button)
	menubar.addChild(about_button)
	menubar.startup()

	var logo     = new dijit.layout.ContentPane({
		id:"logo",
		region:"bottom",
		style: "height:80%; ",
	})

	var container = new dijit.layout.BorderContainer({
		style:"background-image:url('/img/banner.gif');", 
		gutters:false
	})

	container.addChild( menubar )
	container.addChild( statusbar )
	container.addChild( logo )

//	container.startup()

	return container
}

/*
*  root container
*/
_M.createRootContainer = function( domId )
{
	var bc = new dijit.layout.BorderContainer({
			  design : "headline",
			  style  : "width : 100%; height: 100%;",
			  gutters: false
			  }, dojo.byId( domId ));
	var t = new dijit.layout.ContentPane({
			  region   : "top",
			  style    : "background-color:blue;height:20%; padding:0;",
			  splitter : false,
			  content  : createHeader() 
			});
	var l = new dijit.layout.ContentPane({
			  region   : "left",
			  style    : "background-color:yellow;width:100px",
			  splitter : true,
			  minSize  : 100,
			  maxSize  : 200});
	var m = new dijit.layout.ContentPane({
			  region   : "center",
			  });
	var b = new dijit.layout.ContentPane({
	        region : "bottom",
			  style : "height:30px;",
			  content: COPYRIGHT_MESSAGE
	})

	bc.addChild(m);
	bc.addChild(t);
	bc.addChild(l);
	bc.addChild(b);

	bc.startup();

	return bc;
}

/////////////////////// end ///////////////////////////////////////////////
})()
