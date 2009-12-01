---------------------------------------------------------------------------
-- Loader for lua script
-- load the executive node, RETURN a func
---------------------------------------------------------------------------

local setmetatable = setmetatable
local assert = assert
local loadfile = loadfile
local setfenv = setfenv


module(...)

local _MODULER = "store.loader"

local LOADER ={}

--- return a new  instance of LOADER
function new( ... )
	local config, root_path = ...
	local self =  setmetatable( {}, {__index = LOADER } )

	--- begin init
	self.separator = config.SEPARATOR
	local separator = self.separator

	assert( separator, 'you should at lesat provide SEPARATOR' )

	self.make_path = config.MAKE_PATH

	if not config.PATH_FILTER then
		local anti_separator =  separator == '/' and '\\' or
			separator == '\\' and '/' or error('wrong separator format!')

		self.path_filter = function( path_orig )
			return path_orig:gsub(anti_separator, separator)	
		end
	else
		self.path_filter = config.PATH_FILTER
	end

	-- end init

	-- if provide root_path extra, so call it
	if root_path then
		self:set_root( root_path )
	end

	return self
end


--- set the path root of loader
-- should correspond the os specific path format
-- cicala can auto strip the tail deliiter
function LOADER:set_root( root_path )

	-- first, detect os_type from separator
	if self.separator == '/' then
		-- absolute path
		if root_path:find('^/') then
			self.root_path = root_path
		else
			self.root_path = self.make_path( root_path ) 
		end
	else -- ms windows
		if root_path:find('%a:\\') then
			self.root_path = root_path
		else
			self.root_path = self.make_path( root_path )
		end
	end

	--- 
	-- strip tail delimiter
	self.root_path = self.root_path:gsub( self.separator .. '$', '')
end


--- load node using name( is An error occurs, throw it)
-- @parma name the script name
-- @return table repersent node
function LOADER:load( name )
	assert( name , 'loader need a node name but receive nil' )
	assert( self.root_path, 'you must set_root before use a loader')

	local real_path =  self.root_path .. self.separator .. 
		self.path_filter( name ) .. '.lua'
	local trunk = loadfile( real_path )
	
	assert( trunk, ('cannot load trunk from path:%s'):format(real_path) ) 


	local clean_env = {}
	local ok, res =  setfenv(trunk, clean_env)()
	
	return clean_env
end

