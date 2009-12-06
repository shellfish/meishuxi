function serialize(t)
	local mark={}
	local assign={}
	
	local function ser_table(tbl,parent)
		mark[tbl]=parent
		local tmp={}
		for k,v in pairs(tbl) do
			local key= type(k)=="number" and "["..k.."]" or k
			if type(v)=="table" then
				local dotkey= parent..(type(k)=="number" and key or "."..key)
				if mark[v] then
					table.insert(assign,dotkey.."="..mark[v])
				else
					table.insert(tmp, key.."="..ser_table(v,dotkey))
				end
			else
				if type(v) == 'string' then
					v = string.format('%q', v)
				elseif type(v) == 'number' then
					v = tostring(v)
				else
					error('cannot serialize type:' .. type(v))
				end
				table.insert(tmp, key.."="..v)
			end
		end
		return "{"..table.concat(tmp,",").."}"
	end
 
	return "do local ret="..ser_table(t,"ret")..table.concat(assign," ").." return ret end"
end
 
t = { a = 1, b = 2, c = 'dsd中国sas;s/\\hello'}
g = { c = 3, d = 4,  t}
t.rt = g
 
print(serialize(t))


