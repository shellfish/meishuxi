#!/user/bin/env lua

require"lfs"

local dir = './images/icons'
print[[
.venusIcon {
	background-repeat: no-repeat;
	 background-position: center center; 
	width: 10px;
	height: 10px;
}
]]
local print = function(...) 
	io.write(string.format(...) .. '\n')
end

function attrdir (dir)
    for file in lfs.dir(dir) do
        if file ~= "." and file ~= ".." then
			  	local classname = file:gsub('%..-$', '') .. 'Icon'
				print('.%s {background-image:url(%s);}',classname, dir..'/'..file)
        end
    end
end

attrdir(dir)
