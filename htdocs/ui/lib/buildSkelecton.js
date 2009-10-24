// require libs for building widget
dojo.require("dijit.MenuBar");
dojo.require("dijit.MenuBarItem");
dojo.require("dijit.PopupMenuBarItem");
dojo.require("dijit.Menu");
dojo.require("dijit.MenuItem");
dojo.require("dijit.PopupMenuItem");

dojo.require("dijit.Dialog");	
dojo.require("dijit.form.Button");

(function() {

var login_dialog
var menubar

/*
* build login dialog
*/
dojo.addOnLoad(function() {
	login_dialog = new dijit.Dialog({
		title:"登录",
		id:'login_dialog',
		style:"width:300px",
		content:'你好，请登录'
	})
})


 dojo.addOnLoad(function() {
	  menubar = new dijit.MenuBar({id:'menubar'});

	  var subMenu = new dijit.Menu({});

	  subMenu.addChild(new dijit.MenuItem({
			label: "登录",
			id: 'login'
	  }));
	  subMenu.addChild(new dijit.MenuItem({
			label: "注册",
			id: 'register'
	  }));
	  menubar.addChild(new dijit.PopupMenuBarItem({
			label: "用户",
			popup: subMenu 
		}));

	  menubar.placeAt("header", 'first');
	  menubar.startup();


 });

})()
