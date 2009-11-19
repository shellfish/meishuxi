local root_path = '/home/zhousiyv/桌面/trunk/'

package.path = package.path  ..
	';' .. root_path .. 'jw/Lua/?.lua' ..
	';' .. root_path .. 'jw/Lua/?/init.lua' ..
	";" .. root_path ..  'PublicLib/?.lua' ..
	';' .. root_path .. 'PublicLib/?/init.lua'


require "tr.wsapi_app"

return	tr.wsapi_app.new{
	SHOW_STACK_TRACE = true,
}
