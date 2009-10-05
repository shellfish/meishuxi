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

	local path = config.NODE_LOAD_PATH
	
	local function addDirSeparator(s)
		if s:byte(#s) ~= string.byte('/') then
			return s .. '/'
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
	assert( name )

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

		local ok, func = pcall( loadstring, src )
		if not ok then
			error(_MODULER ..   string.format('Cannot compile node:%s.', name ))
		end

		return func()
	end
end

