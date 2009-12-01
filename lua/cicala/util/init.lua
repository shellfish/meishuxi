local getmetatable, setmetatable, error, ipairs, type = 
getmetatable, setmetatable, error, ipairs, type

module(...)

-- @parma orig the original object to be extend, may have a metatable
-- @parma addon the addon class, its field will be prior to orig's  field and metatable, it shoule always has no metatable
function extend( orig, addon )

	local orig_meta = getmetatable( orig )
	-- 混合元表
	if orig_meta then
		setmetatable(addon, orig_meta)
	end

end


-- mixin, use metatable to build a mixin table, which can be read out 
-- every from right preior to left parma tables
function mixin(...)

	local metatable = ... 

	for _, v in ipairs{...} do
		metatable = setmetatable(v, {__index = metatable})
	end

	return setmetatable({}, {__index = metatable})
end
