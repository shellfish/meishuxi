local  getmetatable, setmetatable, error, ipairs, type, tinsert   = 
getmetatable, setmetatable, error, ipairs, type, table.insert
local next = next
local loadstring = loadstring
local concat = table.concat
local base = require'cicala.base'


module(..., package.seeall);

-- @parma left The object to mix properties into. Also the return value.
-- @parma right	Objects whos each child will be copied into obj. If more than one of these objects contain the same value, the one specified last in the function call will "win".
function extend( left, right )
	local base = clone(left)

	-- copy value
	local i, v = next( right )
	while i do
		base[i] = v
		i, v = next( right, i )
	end

	local function parse_metatable(mt, tab)
		local index = mt.__index
		if type(index) == 'function' then
			return (function(key) return index(tab, key) end)
		elseif type(index) == 'table' then
			return (function(key) return index[key] end)
		else
			return nil
		end
	end

	-- copy metatable
	local mt
	local right_mt, left_mt = getmetatable(right), getmetatable(left)
	local left_meta_index = left_mt and parse_metatable( left_mt, left )
	if left_meta_index then
		local right_meta_index = right_mt and parse_metatable( right_mt, right )
		if right_meta_index then
			mt = {__index = function(tab, key)
				return right_meta_index(key) or left_meta_index(key)
			end}
		else
			mt = left_mt 
		end
	else
		mt = right_mt
	end

	return setmetatable(base, mt)
end

-- do deep copy, include metatable
function clone( src )
	local out = {}
	local i, v = next( src )
	while i do
		if type(v) == 'table' then
		-- sorry, I has't solve the circulating reference, 
		--	only check self-reference
			if v == src then
				out[i] = out
			else
				out[i] = clone(v)
			end
		else
			out[i] = v
		end
		i, v = next( src, i )
	end

	local mt = getmetatable( src )
	setmetatable( out, mt )

	return out	
end


-----------------------------------------------------------------------------
-- Splits a string on a delimiter. 
-- Adapted from http://lua-users.org/wiki/SplitJoin.
-- 
-- @param text           the text to be split.
-- @param delimiter      the delimiter.
-- @return               unpacked values.
-----------------------------------------------------------------------------
function split(text, delimiter)
   local list = {}
   local pos = 1
   if (""):find(delimiter, 1) then 
      error("delimiter matches empty string!")
   end
   while 1 do
      local first, last = text:find(delimiter, pos)
      if first then -- found?
	 tinsert(list, text:sub(pos, first-1))
	 pos = last+1
      else
	 tinsert(list, text:sub(pos))
	 break
      end
   end
   return list
end


local function filepath_normalizer( path )
	return base.path:translate( path )	
end

local function dirpath_normalizer( path )
	if path:byte(#path) ~=  (base.path.sep):byte() then
		path = path .. base.path.sep
	end
	return base.path:translate( path )
end

-- make a path (dir or file) normalizing
-- @parma path the path to a dir or file, 
-- @parma mode type of path:string, can be 'dir' or 'file'(default)
function path_normalizer( path, mode )
	mode = mode or 'file'
	if mode == 'file' then
		return filepath_normalizer( path )
	elseif mode == 'dir' then
		return dirpath_normalizer( path )
	else
		error(('bad argument #2:%s'):format(mode))
	end
end


function serialize(t)
	local mark={}
	local assign={}
	
	local function ser_table(tbl,parent)
		mark[tbl]=parent
		local tmp={}
		for k,v in pairs(tbl) do
			local key =  type(k)=="number" 
				and  '[' .. k ..  ']' 
				or  ('[%q]'):format(k)
			if type(v)=="table" then
				local dotkey= parent..(type(k)=="number" and key or "."..key)
				if mark[v] then
					tinsert(assign,dotkey.."="..mark[v])
				else
					tinsert(tmp, key.."="..ser_table(v,dotkey))
				end
			else
				if type(v) == 'string' then
					v = ('%q'):format(v)
				elseif type(v) == 'number' then
					v = v
				else
					error('cannot serialize type:' .. type(v))
				end
				tinsert(tmp, key.."="..v)
			end
		end
		return "{"..concat(tmp,",").."}"
	end
 
	return ser_table(t,"ret")..concat(assign," ") 
end
 
 

--- deserialize a string to Lua Table
-- @parma str the string contains a complete table
-- @return the deserializd table
function deserialize( str )
	return ( loadstring( 'return' .. str ) )()
end
