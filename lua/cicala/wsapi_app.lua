---------------------------------------------------------------------------
-- wsapi app generator
---------------------------------------------------------------------------

require "cicala"
require "wsapi.request"
require "wsapi.response"
require "coxpcall"

local string, unpack, error = string, unpack, error

module(...)


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

		local instance = cicala.new( bootstrap_config )
		instance:handle_request( req, res )

		return { res:finish() }
	end
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
	
	return function( wsapi_env  )
		local summary = "<h1 style=\"color:pink;\">Oops, An unexpected error occurs!</h1>"
		local message = string.format( HTML_MESSAGE, summary, 
			config.DEBUG and config.DEBUG.SHOW_STACK_TRACE and  transalte( err_msg )  or "Please Contact Site admin" )

		-- if define a LOG_FILE then log the error messsage
		if config.LOG_FILE then
			require 'logging.file'
			local logger = logging.file(config.LOG_FILE, 
				config.DEBUG and config.DEBUG.LOG_FILE or "%Y-%m-%d")
			logger:error(err_msg)
		end

		local response = wsapi.response.new(500, 
			{ ['Content-type'] = 'text/html' }
		)
		response:write(message)

		return { response:finish() }
	end
end
