----------------------------------------------------------------------------
-- General utility module 
----------------------------------------------------------------------------
local ipairs, pairs, type, tostring, table = ipairs, pairs, type, tostring, table
local format = string.format
local sort, tinsert = table.sort, table.insert

local value = nil

module(..., package.seeall)

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
   return unpack(list)
end


----------------------------------------------------------------------------
-- Serializes a table.
-- @param tab Table representing the session.
-- @param outf Function used to generate the output.
-- @param ind String with indentation pattern (default = "").
-- @param pre String with indentation prefix (default = "").
----------------------------------------------------------------------------
function tabledump (tab, outf, ind, pre)
	local sep_n, sep, _n = ",\n", ", ", "\n"
	if (not ind) or (ind == "") then ind = ""; sep_n = ", "; _n = "" end
	if not pre then pre = "" end
	outf ("{")
	local p = pre..ind
	-- prepare list of keys
	local keys = { boolean = {}, number = {}, string = {} }
	local total = 0
	for key in pairs (tab) do
		total = total + 1
		local t = type(key)
		if t == "string" then
			tinsert (keys.string, key)
		else
			keys[t][key] = true
		end
	end
	local many = total > 5
	if not many then sep_n = sep; _n = " " end
	outf (_n)
	-- serialize entries with numeric keys
	if many then
		local _f,_s,_v = ipairs(tab)
		if _f(_s,_v) then outf (p) end
	end
	local num = keys.number
	local ok = false
	-- entries with automatic index
	for key, val in ipairs (tab) do
		value (val, outf, ind, p)
		outf (sep)
		num[key] = nil
		ok = true
	end
	if ok and many then outf (_n) end
	-- entries with explicit index
	for key in pairs (num) do
		if many then outf (p) end
		outf ("[")
		outf (key)
		outf ("] = ")
		value (tab[key], outf, ind, p)
		outf (sep_n)
	end
	-- serialize entries with boolean keys
	local tr = keys.boolean[true]
	if tr then
		outf (format ("%s[true] = ", many and p or ''))
		value (tab[true], outf, ind, p)
		outf (sep_n)
	end
	local fa = keys.boolean[false]
	if fa then
		outf (format ("%s[false] = ", many and p or ''))
		value (tab[false], outf, ind, p)
		outf (sep_n)
	end
	-- serialize entries with string keys
	sort (keys.string)
	for _, key in ipairs (keys.string) do
		outf (format ("%s[%q] = ", many and p or '', key))
		value (tab[key], outf, ind, p)
		outf (sep_n)
	end
	if many then outf (pre) end
	outf ("}")
end

---  Serialize tables.
-- It works only for tables without cycles and without functions or
-- userdata inside it.
-- @parma tab the table to be serialized
-- @return the string represent this table
function serialize( tab )
	local content = {}
	tabledump(tab, function(d) table.insert( content, d) end )

	return table.concat( content )
end

--- deserialize a string to Lua Table
-- @parma str the string contains a complete table
-- @return the deserializd table
function deserialize( str )
	return ( loadstring( 'return' .. str ) )()
end

--
-- Serializes a value.
--
value = function (v, outf, ind, pre)
	local t = type (v)
	if t == "string" then
		outf (format ("%q", v))
	elseif t == "number" then
		outf (tostring(v))
	elseif t == "boolean" then
		outf (tostring(v))
	elseif t == "table" then
		tabledump (v, outf, ind, pre)
	else
		outf (format ("%q", tostring(v)))
	end
end
