(function(_M) {
	_M = dojo.provide('lib.util')


	_M._apiList = {}       //  mapped api list	

	_M.parseApiList = function( callback )
	{
		dojo.xhrGet({
			url:lib.core.env.serviceUrl,
			content:{p:'api'},
			handleAs:'json',
			timeout:10000,
			load:function(items) {
				for (var k in items) {
					// fix base url of service
					items[k].url = lib.core.env.serviceUrl + '?' + items[k].url
				}
				
				_M._apiList = items
				callback()
			},
			error:function(res) {
				console.error(res.message)
			}
		})
	}

	// 按照名字获得缓存的api项
	_M.getApi = function( name ) {
		console.assert( _M._apiList[name], 'no such api:' + name)
		return _M._apiList[name]
	}

	_M.getResource = function( resource ) 
	{
		var base
		console.assert( base = lib.core.env.baseUrl )
		return lib.util.format(base + 'resource/%s', resource)
	}


	// it's resource for navigator
	_M.nav_list = [
		{
			label:'公共',
			items:{
				name:'系统研发',
				signal:'newtab/dev'
			}
		},
		{ 
		  	label:'学生',
		  	items:[
		  	{
				name:'查看信息',
				signal:'newtab/information'
			},
			{
				name:'提交作品',
				signal:'newtab/uploadwork'
			},
			{
				name:'查看分数',
				signal:'newtab/viewscore'
			},
			{
				name:'修改密码',
				signal:'newtab/alterpassword'
			}
		]},
		{
			label:'教师',
			items:[
			{
				name:'查看信息',
				signal:'newtab/information'
			},
			{
				name:'提交分数',
				signal:'newtab/commitscore'
			}
		]},
		{
			label:'管理员',
			items:[
			{
				name:'查看学生信息',
				signal:'viewstudent'
			},
			{
				name:'查看教师信息',
				signal:'viewteacher'
			}
		]}
	]



	/*
	*  some utilities from web
	*/

	/**
	*  Javascript sprintf
	*  http://www.webtoolkit.info/
	**/
	 
	var sprintfWrapper = {
	 
		init : function () {
	 
			if (typeof arguments == "undefined") { return null; }
			if (arguments.length < 1) { return null; }
			if (typeof arguments[0] != "string") { return null; }
			if (typeof RegExp == "undefined") { return null; }
	 
			var string = arguments[0];
			var exp = new RegExp(/(%([%]|(\-)?(\+|\x20)?(0)?(\d+)?(\.(\d)?)?([bcdfosxX])))/g);
			var matches = new Array();
			var strings = new Array();
			var convCount = 0;
			var stringPosStart = 0;
			var stringPosEnd = 0;
			var matchPosEnd = 0;
			var newString = '';
			var match = null;
	 
			while (match = exp.exec(string)) {
				if (match[9]) { convCount += 1; }
	 
				stringPosStart = matchPosEnd;
				stringPosEnd = exp.lastIndex - match[0].length;
				strings[strings.length] = string.substring(stringPosStart, stringPosEnd);
	 
				matchPosEnd = exp.lastIndex;
				matches[matches.length] = {
					match: match[0],
					left: match[3] ? true : false,
					sign: match[4] || '',
					pad: match[5] || ' ',
					min: match[6] || 0,
					precision: match[8],
					code: match[9] || '%',
					negative: parseInt(arguments[convCount]) < 0 ? true : false,
					argument: String(arguments[convCount])
				};
			}
			strings[strings.length] = string.substring(matchPosEnd);
	 
			if (matches.length == 0) { return string; }
			if ((arguments.length - 1) < convCount) { return null; }
	 
			var code = null;
			var match = null;
			var i = null;
	 
			for (i=0; i<matches.length; i++) {
	 
				if (matches[i].code == '%') { substitution = '%' }
				else if (matches[i].code == 'b') {
					matches[i].argument = String(Math.abs(parseInt(matches[i].argument)).toString(2));
					substitution = sprintfWrapper.convert(matches[i], true);
				}
				else if (matches[i].code == 'c') {
					matches[i].argument = String(String.fromCharCode(parseInt(Math.abs(parseInt(matches[i].argument)))));
					substitution = sprintfWrapper.convert(matches[i], true);
				}
				else if (matches[i].code == 'd') {
					matches[i].argument = String(Math.abs(parseInt(matches[i].argument)));
					substitution = sprintfWrapper.convert(matches[i]);
				}
				else if (matches[i].code == 'f') {
					matches[i].argument = String(Math.abs(parseFloat(matches[i].argument)).toFixed(matches[i].precision ? matches[i].precision : 6));
					substitution = sprintfWrapper.convert(matches[i]);
				}
				else if (matches[i].code == 'o') {
					matches[i].argument = String(Math.abs(parseInt(matches[i].argument)).toString(8));
					substitution = sprintfWrapper.convert(matches[i]);
				}
				else if (matches[i].code == 's') {
					matches[i].argument = matches[i].argument.substring(0, matches[i].precision ? matches[i].precision : matches[i].argument.length)
					substitution = sprintfWrapper.convert(matches[i], true);
				}
				else if (matches[i].code == 'x') {
					matches[i].argument = String(Math.abs(parseInt(matches[i].argument)).toString(16));
					substitution = sprintfWrapper.convert(matches[i]);
				}
				else if (matches[i].code == 'X') {
					matches[i].argument = String(Math.abs(parseInt(matches[i].argument)).toString(16));
					substitution = sprintfWrapper.convert(matches[i]).toUpperCase();
				}
				else {
					substitution = matches[i].match;
				}
	 
				newString += strings[i];
				newString += substitution;
	 
			}
			newString += strings[i];
	 
			return newString;
	 
		},
	 
		convert : function(match, nosign){
			if (nosign) {
				match.sign = '';
			} else {
				match.sign = match.negative ? '-' : match.sign;
			}
			var l = match.min - match.argument.length + 1 - match.sign.length;
			var pad = new Array(l < 0 ? 0 : l).join(match.pad);
			if (!match.left) {
				if (match.pad == "0" || nosign) {
					return match.sign + pad + match.argument;
				} else {
					return pad + match.sign + match.argument;
				}
			} else {
				if (match.pad == "0" || nosign) {
					return match.sign + match.argument + pad.replace(/0/g, ' ');
				} else {
					return match.sign + match.argument + pad;
				}
			}
		}
	}
	 
	var sprintf = sprintfWrapper.init;

	_M.format = _M.sprintf = sprintf



})()
