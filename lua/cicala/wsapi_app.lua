require'cicala'
require'wsapi.request'
require'wsapi.response'
require'coxpcall'

local cicala, wsapi, coxpcall = cicala, wsapi, coxpcall

module(...)

function new( config )
	return function( wsapi_env )
		local ok, status, header, content = coxpcall(
			function() return make_normal_app( wsapi_env ) end,
			function(e) return make_error_app( config, e)( wsapi_env ) end
		)
		return status, header, content
	end
end

function make_normal_app( wsapi_env )

	local req = wsapi.request.new(wsapi_env)
	local res = wsapi.response.new()

	local http = { 
		request = req, 
		response = res,
		servervariable = wsapi_env
	}
	-- wrap cookie manpulation
	function http:get_cookie( name )
		return req.cookies[name]
	end

	function http:set_cookie( name, value )
		return res:set_cookie( name, value )
	end

	-- single entry
	cicala.run( http )

	return res:finish()
end

function make_error_app( config, err_msg  )
	
	local function transalte( src )

		local a, b = src:find":%d+:"
		local c, d = src:find( "stack traceback:", b + 1)
		local part1 = string.sub(src, 1, a - 1)
		local part2 = string.sub(src, b + 1, c - 1)
		local part3 = string.sub(src, d + 1, #src)
		part3:gsub("<", "&lt;")
		part3:gsub(">" , "&gt;")

		return ("<p style=\"color:blue;\"><b>[Position]</b>" .. src:sub(a, b) .. part1 .. "</p>" ..
			"<p style=\"color:red; font-size:1.3em;\">" .. part2 .. "</p>" ..
			"<hr /><h4 style=\"color:silver; font-size:2em;\">stack traceback:<h4><pre>" .. part3 .. "</pre>")
	end

	local HTML_MESSAGE = [[
		<html>
		<head><title>Oops - An Error Occurs!</title></head>
		<body leftMargin="0" topMargin="0" marginheight="0" marginwidth="0">
		<center>
		<h2>%s</h2>
		<img src="/img/banner.gif" />
		<div style="background-color:#D5DFE0; margin:15px 15px; padding:15px 20px; border:1px  solid #09C;">
			%s
		</div>
		</center>
		</body>
		</html>
]]
	
	return function( wsapi_env )
		local summary = "<h1 style=\"color:pink;\">Oops, An unexpected error occurs!</h1>"
		local message = HTML_MESSAGE:format(summary, 
			config.SHOW_STACK_TRACE and  transalte( err_msg )  or "Please Contact Site admin" )

		-- #TODO log file
		-- io.open((os.getenv('TMP') or '/tmp') .. '/lua-logile', 'w'):write(tostring(err_msg))

		local response = wsapi.response.new(500, 
			{ ['Content-type'] = 'text/html' }
		)
		response:write(message)

		return response:finish()
	end
end








