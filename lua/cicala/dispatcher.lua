local setmetatable = setmetatable
local registry = assert(cicala.registry)
local util = require'cicala.util'
local loadfile, setfenv = loadfile, setfenv
local assert, pcall = assert, pcall
local http = registry.http
local Json = require'Json'
local type = type
local error = error
local url_decode = require'wsapi.util'.url_decode
local base = require'cicala.base'
local unpack = unpack
local select = select
local next = next

module(...)

local  mt = {__index = _M}
function mt.__call(self, http)
	self.http = http

	self:prepare_process()
	if not self.request_data then return self:error_404() end

	---------------------------------------------------
	-- take app
	local appname = assert(self.request_data.method):gsub('_', base.path.sep) 
	local ok, app = pcall(self.load_app, self, appname)
	if not ok then return self:error_404() end

	-- app中的accept字段表示可接受的http 方法
	if app.accept and not app.accept[self.request_method] then
		return self:reject_access()
	end

	-- 检查权限
	if app.permmission and not self:check_permmission(app) then return self:reject_access() end
	
	-------------------------------------------------------------------
	-- 运行app

	local ok, result, method, content_type = 
	pcall( function()
		local arg = self.request_data.params
		arg  = type(arg) == 'table' and arg or {}
		return setfenv( app.run, registry)( unpack(arg) )
	end)

	-- after process =========================================================================================
	-- 默认的结果后处理 
	method = method or app.method or function(x) return x end 
	content_type = content_type or app.content_type or 'text/plain' 

	---------------------------------------===============================
	if ok then
	-- 如果app运行中未发生错误
		http.response.status = 200
		http.response.header = {['Content-Type'] = content_type}

		self.http.response:write(method( Json.Encode{ 
			result = result, 
			error = Json.Null,
			-- 回传
			id = self.request_data.id,
		} ))
	else
		http.response.status = 200
		http.response.header = {['Content-Type'] = content_type}
		local err_msg =  result:match('lua:%d+:%s(.+)$') or result or 'unknow error'
		http.response:write(method( Json.Encode {
			result = Json.Null,
			error = err_msg,
			id = self.request_data.id,
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

-- detect from POST or GET
function prepare_process(self)
	local function parse(data)
		local ok, data = pcall(Json.Decode, data)
		if ok then return data else return nil end
	end

	self.request_method = self.http.servervariable['REQUEST_METHOD']
	if self.request_method == 'POST' then
		self.request_data =  parse( self.http.POST.post_data )
	elseif self.request_method == 'GET' then
		self.request_data =  parse( url_decode(self.http.request.query_string) )
	else
		error(('Cannot treat HTTP method: %s'):format(request_method))
	end
end

function check_permmission(app)
-------------------------------------------------------------------
	-- 权限检测
	if app.permmission then
		if type(app.permmission) == 'string' then
			local authorization = registry.authorization
			return authorization:access_control( app.permmission )  
		else
			error'authorization statement must be string'
		end
	end
end
