----------------------------------------------------------------------------
--- extends from loader
-- provide read, write and expire method to single lua file 
-- base on operating system filesystem

require'cicala.base.loader'
local loader, setmetatable = 
	cicala.base.loader, setmetatable


module( ... )

local FILECACHED = {} 

function new( config )
	
	local prototype = loader.new(config)
	setmetatable(FILECACHED, { __index = prototype })
	local self = setmetatable({}, {__index = FILECACHED})

	self:set_search_path( config.PATH )	
	
	return self
end

function FILECACHED:get(name)
	return self:load(name)
end
