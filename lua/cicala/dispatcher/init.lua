local setmetatable = setmetatable
local registry = assert(cicala.registry)
local util = require'cicala.util'
local loadfile, setfenv = loadfile, setfenv
local assert, pcall = assert, pcall
local http = registry.http
local Json = require'Json'
local type = type
local error = error

module(...)

local  mt = {__index = _M}
function mt.__call(self, http)
	self.http = http

	-- call : 调用的app
	-- arg : 一个序列化的json字符串参数组

	local app_name = http.GET.call
	if not app_name then return self:error_404() end

	local ok, app = pcall(self.load_app, self, app_name )
	if not ok then return self:error_404() end

	-- 一个app中，dispatcher需要的是
	--[[
		* run: 主函数， 获取其结果
			主函数返回三个值， 
			1. 结果，可以是任何类型
			2. 处理结果的方法，string | function
			3. content_type
	]]--

	-------------------------------------------------------------------
	-- 权限检测
	if app.authorization then
		if type(app.authorization) == 'string' then
			local authorization = registry.authorization
			if not authorization:access_control( app.authorization ) then
				return self:reject_access()
			end
		else
			error'authorization statement must be string'
		end
	end

	-------------------------------------------------------------------
	-- 运行app
	local ok, result, method, content_type = 
	pcall( function()
		local arg = http.GET.arg and Json.Decode(http.GET.arg) or nil
		return setfenv( app.run, registry)( arg )
	end)

	-- 默认的结果后处理 
	method = method or app.method or 'json' 
	content_type = content_type or app.content_type or 'text/plain' 

	local function process(method, value)
		if type(method) == 'string' then
			if method == 'json' then
				method = Json.Encode
			elseif method == 'text' then
				method = function(x) return x end
			else
				error('Unkwon method:' .. method)
			end
		end

		if type(method) == 'function' then
			return method(value)
		else
			error('method cannot be type:' .. type(method))
		end
	end


	---------------------------------------===============================
	if ok then
	-- 如果app运行中未发生错误
		http.response.status = 200
		http.response.header = {['Content-Type'] = content_type}

		http.response:write(process(method, { 
			result = result, 
			error = Json.Null,
			id = appid
		}))
	else
		http.response.status = 200
		http.response.header = {['Content-Type'] = content_type}
		local err_msg =  result:match('lua:%d:%s(.+)$') or 'unknow error'
		http.response:write(process(method, {
			result = Json.Null,
			error = err_msg,
			id = appid
		}))
	end
end

function new( config )
	return setmetatable({
		appdir = util.path_normalizer(config.appdir, 'dir')
	}, mt)
end

function load_app( self, name )
	local trunk = assert(loadfile(self.appdir .. name ..'.lua'))
	local box = {}
	setfenv(trunk, box)()
	return box
end

function error_404(self)
	self.http.response.status = 404
	self.http.response:write('404 NOT FOUND')
end

function reject_access(self)
	self.http.response.status = 401
	self.http.response:write('401 Access denied')
end
