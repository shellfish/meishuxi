//写cookies函数 作者：翟振凯
function setCookie(name,value)//两个参数，一个是cookie的名子，一个是值
{
    var Days = 30; //此 cookie 将被保存 30 天
    var exp  = new Date();    //new Date("December 31, 9998");
    exp.setTime(exp.getTime() + Days*24*60*60*1000);
    document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString();
}
function getCookie(name)//取cookies函数        
{
    var arr = document.cookie.match(new RegExp("(^| )"+name+"=([^;]*)(;|$)"));
     if(arr != null) return unescape(arr[2]); return null;

}
function delleteCookie(name)//删除cookie
{
    var exp = new Date();
    exp.setTime(exp.getTime() - 1);
    var cval=getCookie(name);
    if(cval!=null) document.cookie= name + "="+cval+";expires="+exp.toGMTString();
}

function parseJson( str ) 
{
	var obj = eval( '(' + str + ')' )
	return obj
}



function updateTopbar(action)
{
	var _status = getCookie('userHash')


	function logout_action() {
		$.get("/tr.ws",{p:"authentication", action:"logout"})
		delleteCookie('userHash')
		_status = null
	}
	
	
	if (action == "logout") {
		logout_action()	
	}

	
	if ( _status ) {
		var userId, userType
		$.getJSON("/tr.ws", {p : "info"}, function(data){
			var userId = data.user
			var userType = data.userType
			
			var type = userType.student && "同学" || "老师"

			$('#topbar .msg').replaceWith('<li class="msg">' + type + 
			"<span>"	+ userId + "</span>" + ",你好!&nbsp;</li>")
		})

		alert("已经login")
		$('#login_link').hide()
		$('#logout_link').show()
	} else {
		$('#logout_link').hide()
		$('#login_link').show()	
		$('#topbar .msg').replaceWith('<li class="msg">你还未</li>')
	}




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
		updateTopbar("logout")
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
							updateTopbar()					}
						else
							alert("登录失败" + obj.msg)
					}
				)
			}, 
			"取消": function() { 
				$(this).dialog("close"); 
			} 
		}
	});

	
})    // 初始化完成

