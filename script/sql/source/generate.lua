require 'unicode'

local char = unicode.utf8.char
local byte = unicode.utf8.byte
local gsub = unicode.utf8.gsub
local len = unicode.utf8.len

local bai_jia_xing = {}
function add( name )
	table.insert( bai_jia_xing, name)
end

function get(l, place, place2)
	local c1 =  char(byte(l, place))
	if not place2 then return c1
	else
		local c2 = char(byte(l, place2))
		return c2 .. c1
	end
end

for l in  io.lines(arg[1]) do
	l = gsub(l, ' ', '')
	l = gsub(l, '\t' , '')
	
	local len = len( l )
	
	while( len ~= 0 ) do
		add( get( l, len ) )
		len = len - 1
	end
end

for l in  io.lines(arg[2]) do
	l = gsub(l, ' ', '')
	l = gsub(l, '\t' , '')
	
	local len = len( l )
	
	while( len ~= 0 ) do
		add( get( l, len, len - 1 ) )
		len = len - 2
	end
end

require'Json'
print(Json.Encode(bai_jia_xing))

