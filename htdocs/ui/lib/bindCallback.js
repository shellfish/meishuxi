dojo.addOnLoad(function() {

	dojo.connect(dojo.byId('login'), 'click', function() { 
		dijit.byId('login_dialog').show()
	}) 


})
