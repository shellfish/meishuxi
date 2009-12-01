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

-- @:string os path path_separator
LOADER.path_separator = nil 

-- @:function os specific path generator, 
-- can receive a parameter path_name, either releative or absolue
LOADER.make_path = nil

-- the search_path(:string) of loader
LOADER.search_path = nil

--- return a new  instance of LOADER
function new( config )

	local self =  setmetatable( {}, {__index = LOADER } )

	--- begin init
	self.path_separator = config.SEPARATOR
	local path_separator = self.path_separator

	assert( path_separator, 'you should at lesat provide SEPARATOR' )

	self.make_path = config.MAKE_PATH

	if not config.PATH_FILTER then
		local anti_separator =  path_separator == '/' and '\\' or
			path_separator == '\\' and '/' or error('wrong path_separator format!')

		self.path_filter = function( path_orig )
			return path_orig:gsub(anti_separator, path_separator)	
		end
	else
		self.path_filter = config.PATH_FILTER
	end

	-- end init

	return self
end


--- set/get the path root of loader
-- should correspond the os specific path format
-- cicala can auto strip the tail deliiter
function LOADER:set_search_path( new_search_path )

	-- temporary store new search path
	local search_path = new_search_path
	-- first, detect os_type from separator
	if self.path_separator == '/' then
		-- absolute path
		if search_path:find('^/') then
			search_path = search_path
		else
			search_path = self.make_path( search_path ) 
		end
	else -- ms windows
		if search_path:find('%a:\\') then
			search_path = search_path
		else
			search_path = self.make_path( search_path )
		end
	end

	--- 
	-- strip tail delimiter
	self.search_path = search_path:gsub( self.path_separator .. '$', '')
end

function LOADER:get_search_path()
	return self.search_path
end


--- load node using name( is An error occurs, throw it)
-- @parma name the script name
-- @return table repersent node
function LOADER:load( name )
	assert( name , 'loader need a node name but receive nil' )
	assert( self.search_path, 'you must set_search_path before use a loader')

	local real_path =  self.search_path .. self.path_separator .. 
		self.path_filter( name ) .. '.lua'
	local trunk = loadfile( real_path )
	
	assert( trunk, ('cannot load trunk from path:%s'):format(real_path) ) 


	local clean_env = {}
	local ok, res =  setfenv(trunk, clean_env)()
	
	return clean_env
end
