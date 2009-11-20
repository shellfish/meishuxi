---------------------------------------------------------------------------
-- Loader for lua script
-- load the executive node, RETURN a func
---------------------------------------------------------------------------

module(..., package.seeall)

local _MODULER = "store.loader"

local LOADER ={}

--- return a new  instance of LOADER
function new( config )
	local obj =  setmetatable( {}, {__index = LOADER } )
	obj:init( config )
	return obj
end

--- use the config table to initialize the instance 
-- @parma a path string or table, refers to LUAPATH syntax
-- @return nothing, if error occurs, throw it
function LOADER:init( config )

	local separator

	local os_type = config.OS_TYPE or (function() 
		if os.getenv('OS') then
			return 'windows'
		else
			return 'linux'
		end
	end)();

	if  os_type:lower()  == 'windows' then
		separator = [[\]]
	elseif os_type:lower() == 'linux' then
		separator = [[/]]
	else
		error(('Unknown OS Type:%s'):format(os_type))
	end

	self.separator = separator 


	local path = assert(config.NODE_LOAD_PATH, 'config error: missing NODE_LOAD_PATH')
	
	local function addDirSeparator(s)
		if s:byte(#s) ~= string.byte(separator) then
			return s ..separator
		else
			return s
		end
	end

	if type( path ) == 'string' then
		self.path = { addDirSeparator( path ) }
	elseif type( path ) == 'table' then
		for k, v in ipairs( path ) do
			path[k] = addDirSeparator(v)
		end
		self.path = path
	else
		error(_MODULER .. 'use table or string to config loader search path of loader')		
	end

end

--- load node using name( is An error occurs, throw it)
-- @parma name the script name
-- @return table repersent node
function LOADER:load( name )
	assert( name, 'loader need a node name but receive nil' )

	-- prepare process name "format"
	if self.separator == [[\]] then
		name = name:gsub([[/]], [[\]])
	end

	local file_handle
	for k, v in ipairs( self.path ) do
		file_handle =  io.open( v .. name .. '.lua' ) 
		if file_handle then break end
	end

	if not file_handle then
		error"cannot find node"
	else
		local template = " local ____g = {}; setfenv( 1, setmetatable(____g, {__index = _G})) %s return ____g "
		local src = string.format( template, file_handle:read"*all" )

		local func, msg =  loadstring( src, 'Virtual Node: ' .. name )
		if not func then
		--	error(('Compile Node:[%s] error<br /><span style="color:black;">%s</span>'):format(name, msg))
			error( msg )
		end

		return func()
	end
end

