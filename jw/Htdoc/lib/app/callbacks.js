(function(_M) {

	_M = dojo.provide('app.callbacks')

	// connect ui event
	// like "ui/login" (show login dialog)
	_M.bindUiHandler = function() {

		dojo.subscribe('ui/finish', function() {
			alert('ui/finish')

		})
		
		dojo.subscribe('ui/login', function() { 
			dijit.byId('login:dialog').show() })

		dojo.subscribe('ui/about', function() {	
			dijit.byId('about:dialog').show() })


		dojo.subscribe('ui/logout', function() {	
			dojo.xhrGet({
				url:'/tr.ws?p=authentication&action=logout',
				handleAs:'json',
				load:function(response) {
					   if ( response.ok ) {
						// set toolbar prompt
						dijit.byId('toolbar_prompt').setUserInfo()	

						// update navigator
						var nav = dijit.byId('navigator')
						var num = 0
						var firstChild
						dojo.forEach(nav.getChildren(), function( child ) {
							if ( num++ != 0 ) { 
								var id = child.domNode.id + '_button'
								dojo.style(id, {display:'none'})
							} else { firstChild = child }
						})
						nav.selectChild( firstChild )

					} else {
						alert('请先登录!')
					}
				}
			})
		})
	
	// end ui handler
	},

	// binf callbacks for ui's response signal
	// like "signa/login" ( login success )
	_M.bindSignalHandler = function() {

		// 用户登录成功， 更新1、状态 2、可用navigator
		dojo.subscribe('signal/login', function() {
			dojo.xhrGet({
				url:'/tr.ws?p=info',
				handleAs:'json',
				load:function(response) {
					// set toolbar prompt
					dijit.byId('toolbar_prompt').setUserInfo(response)	
					
					// update navigator
					var nav = dijit.byId('navigator')
					// active corresponding tabPane
					for ( var type in response.userType ) {
						dojo.style(type + ":navigator_button", {display:'block'})
					}
				}
			})	
	
		})

	// end signal handle
	}

	_M.init = function() 
	{
		this.bindUiHandler()	
		this.bindSignalHandler()
		
	}











})()
