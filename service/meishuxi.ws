local env = dofile'env.lua'

require "tr.wsapi_app"

return	tr.wsapi_app.new{
	SHOW_STACK_TRACE = true,
	NODE_LOAD_PATH = env.service_root .. env.filter_path([[/meishu/Node]]),
	OS_TYPE = 'Linux',

	CUSTOM_INIT_FUNCTION = custom_init_example,
}
