AccessControl = [[
	if type( GET.me ).student then
		allow( GET.me )
		allow( get_tutor( "123456" ) )
	end
]]


Type = "text/javascript"

Run = [[

local tab = {}
for k, v in pairs( arg.GET) do
	tab[k] = v
end

return tab 
]]





