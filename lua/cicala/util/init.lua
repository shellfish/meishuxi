require'cicala.base'

local  getmetatable, setmetatable, error, ipairs, type, append,  pcall = 
getmetatable, setmetatable, error, ipairs, type, table.insert,  pcall

local string, table, math = string, table, math

local base = cicala.base

module(...);

-- generate random string,
-- pick from http://lua-users.org/wiki/RandomStrings
(function()
    local Chars = {}
    for Loop = 0, 255 do
       Chars[Loop+1] = string.char(Loop)
    end
    local String = table.concat(Chars)

    local Built = {['.'] = Chars}

    local AddLookup = function(CharSet)
       local Substitute = string.gsub(String, '[^'..CharSet..']', '')
       local Lookup = {}
       for Loop = 1, string.len(Substitute) do
           Lookup[Loop] = string.sub(Substitute, Loop, Loop)
       end
       Built[CharSet] = Lookup

       return Lookup
    end

	 -- export 
    function _M.gen_rand_string(Length, CharSet)
       -- Length (number)
       -- CharSet (string, optional); e.g. %l%d for lower case letters and digits

       local CharSet = CharSet or '.'

       if CharSet == '' then
          return ''
       else
          local Result = {}
          local Lookup = Built[CharSet] or AddLookup(CharSet)
          local Range = table.getn(Lookup)

          for Loop = 1,Length do
             Result[Loop] = Lookup[math.random(1, Range)]
          end

          return table.concat(Result)
       end
    end
end)();
-------------------------------

-- mixin, use metatable to build a mixin table, which can be read out 
-- every from right preior to left parma tables
function mixin(...)

	local metatable = ... 

	for _, v in ipairs{...} do
		metatable = setmetatable(v, {__index = metatable})
	end

	return setmetatable({}, {__index = metatable})
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
   if string.find("", delimiter, 1) then 
      error("delimiter matches empty string!")
   end
   while 1 do
      local first, last = string.find(text, delimiter, pos)
      if first then -- found?
	 table.insert(list, string.sub(text, pos, first-1))
	 pos = last+1
      else
	 table.insert(list, string.sub(text, pos))
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

-- define a very simple hook system
(function()
	local todo_list = {}

	function _M.register( func )
		append(todo_list, func)
	end

	function _M.finalize()
		for k, v in ipairs( todo_list ) do
			v()
		end
	end
end)();
