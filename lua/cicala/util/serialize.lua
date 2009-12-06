local pairs, type, tinsert, loadstring, concat
= pairs, type, table.insert, loadstring, table.concat

cicala = cicala or {}
cicala.util = cicala.util or {}

setfenv(1, cicala.util)

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
					v = ('%q'):fomrat(v)
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

return serialize
