local root_path = '/home/zhousiyv/桌面/trunk/service/'

package.path = package.path  ..
	';' .. root_path .. 'meishu/Lua/?.lua' ..
	';' .. root_path .. 'meishu/Lua/?/init.lua' ..
	";" .. root_path ..  'PublicLib/?.lua' ..
	';' .. root_path .. 'PublicLib/?/init.lua'


require "tr.wsapi_app"

return	tr.wsapi_app.new{
	SHOW_STACK_TRACE = true,
	NODE_LOAD_PATH = root_path .. [[meishu/Node]],
	OS_TYPE = 'Linux',
}
