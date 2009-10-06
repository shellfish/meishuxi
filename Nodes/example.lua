AccseeControl = [[
	allow( all )
]]

Type = "text/javascript"

Run = [[


local tab = {}
for k, v in pairs( arg.GET) do
	tab[k] = v
end

return tab 
]]





