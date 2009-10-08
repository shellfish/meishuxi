function getCookie(name)//取cookies函数        
{
    var arr = document.cookie.match(new RegExp("(^| )"+name+"=([^;]*)(;|$)"));
     if(arr != null) return unescape(arr[2]); return null;

}

function parseJson( str ) 
{
	var obj = eval( '(' + str + ')' )
	return obj
}

function updateTopbar(arg)
{
	if (!arg) {
		var userHash = getCookie('userHash')
		if (userHash)
			arg = 'hasLogin'
		else
			arg = 'hasLogout'
	}
	
	if (arg == "hasLogin") {
		// 获取信息

		function getInfo(data) {
			
			data = parseJson(data)
			var userType	

			if (data.userType.student) userType = "同学"
			else if (data.userType.teacher) userType = "老师"
			else {
				alert('Unknwo user type')
			}
			// 修改文字
			$('#topbar .msg').replaceWith('<li class="msg">' + userType + 
					"<span>"	+ data.user + "</span>" + ",你好!&nbsp;</li>")

		}

		$.ajax({
			type:'GET',
			url:'/tr.ws',
			datatype:'script',
			data:"p=info",
			success:getInfo,
			error:function() {
				alert("Ajax action fall! Maybe meet a remote server error.")
			}
		})


	
		//修改按钮
		$('#login_link').hide()
		$('#logout_link').show()
	}else if (arg == "hasLogout") {
		$('#login_link').show()
		$('#logout_link').hide()
		$('#topbar .msg').replaceWith('<li class="msg">' +
			"你还未登录</li>")
	}else 
		alert("Syntax error")
}

$( function() 
{
	updateTopbar()

	// Login Link
	$('#login_link').click(function(){
		$('#login_dialog').dialog('open');
		return false;
	});
	
	$('#logout_link').click(function() {
		$.get("/tr.ws", {p:"authentication", action:"logout"})
		updateTopbar("hasLogout")
		return false;
	})

	// Login  Dialog			
	$('#login_dialog').dialog({
		autoOpen: false,
		width: 300,
		buttons: {
			"确定": function() { 
				var self = $(this)
				var userId = $('#login_dialog input[type="text"]').val()
				var passwd = $('#login_passwd').val()
				$.get("/tr.ws", { p : "authentication",
					action : "login", user : userId, passwd : passwd},
					function(data) {
						var obj = parseJson( data )
						if ( obj.ok == true ) {
							self.dialog("close")
							$('#login_dialog .msg').replaceWith('<p class="msg"></p>')
							updateTopbar("hasLogin")	
						}
						else
						{
							$('#login_dialog .msg').replaceWith('<p class="msg">' +
							(obj.msg).slice(obj.msg.search(/:/g)+1, obj.msg.length) 
							+ "</p>")
						}
					}
				)
			}, 
			"取消": function() { 
				$(this).dialog("close"); 
			} 
		}
	});

	
})    // 初始化完成

