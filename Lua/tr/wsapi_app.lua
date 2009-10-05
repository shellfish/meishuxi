---------------------------------------------------------------------------
-- wsapi app generator
---------------------------------------------------------------------------

require "tr"
require "wsapi.request"
require "wsapi.response"
require "coxpcall"

module(..., package.seeall)


local make_prefered_app
local make_error_app

---------------------------------------------------------------------------
--- The only method exported by this module
-- @parma bootstrap_config a user-defined configuration table
-- @return the (waapi)app function which will be lanuched by the server
function new( bootstrap_config )
	local preferedApp = make_prefered_app( bootstrap_config )
	local errorApp    = make_error_app( bootstrap_config )
	
	return function( wsapi_env )
		local status, result = coxpcall( 
			function() return make_prefered_app( bootstrap_config )( wsapi_env ) end,
			function(e) return make_error_app( bootstrap_config, e)( wsapi_env ) end 
		)

		return unpack(result)
	end
end

--=========================================================================
-- Local Functions
--=========================================================================

function make_prefered_app( bootstrap_config )
	return function ( wsapi_env )
		local req = wsapi.request.new( wsapi_env )
		req.wsapi_env = wsapi_env

		local res = wsapi.response.new()

		local my_tr = tr.new( bootstrap_config )
		my_tr:main( req, res )

		return { res:finish() }
	end
end

function make_error_app( config, err_msg  )
	
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

	local function translate( msg )
		local  summary, msg, stack =  msg:match("^(.+)#(.-)#(.+)$")
		summary = string.format("<p style=\"color:blue;\">" .. summary .. "</p>")

		msg = string.format(	"<p style=\"color:red; font-size:2em;\">" .. msg .. "</p>")

		stack = stack:gsub("<", "&lt;")
		stack = stack:gsub(">", "&gt;")
		stack = string.format("<pre>" .. stack .. "</pre>")
		return summary .. msg .. stack
	end

	return function( wsapi_env  )
		local summary = "<h1 style=\"color:pink;\">Oops, An unexpected error occurs!</h1>"
		local message = string.format( HTML_MESSAGE, summary, 
			config.SHOW_STACK_TRACE and  translate(err_msg ) or "Please Contact Site admin" )

		io.open('/tmp/lua-logile', 'w'):write(tostring(err_msg))
		local response = wsapi.response.new(500, 
			{ ['Content-type'] = 'text/html' }
		)
		response:write(message)

		return { response:finish() }
	end
end
