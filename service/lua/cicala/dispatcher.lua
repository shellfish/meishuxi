local setmetatable = setmetatable
local util = require'cicala.util'
local loadfile, setfenv = loadfile, setfenv
local assert, pcall = assert, pcall
local Json = require'Json'
local type = type
local error = error
local url_decode = require'wsapi.util'.url_decode
local base = require'cicala.base'
local unpack = unpack
local getfenv = getfenv
local ipairs = ipairs
local tostring = tostring
local DEBUG = base.DEBUG

module(...)


local  mt = {__index = _M}

function new( config, registry )
	return setmetatable({
		appdir = util.path_normalizer(config.appdir, 'dir'),
		registry = registry,
		http = registry.http
	}, mt)
end

function mt.__call(self)

	if DEBUG then
		assert(pcall(self.prepare_process, self))
	else
		pcall(self.prepare_process, self)
		if not self.request_data then return self:error_404() end
	end

	---------------------------------------------------
	-- take app
	local ok, app = pcall(self.load_app, self, self.request_data.method)
	if DEBUG then
		assert(ok, app)
	else
		if not ok then return self:error_404() end
	end


	-- app中的accept字段表示可接受的http 方法
	if app.accept and not app.accept[self.request_method] then
		return self:reject_access()
	end

	-- 检查权限
	if app.permmission and not self:check_permmission(app) then return self:reject_access() end

	
	-------------------------------------------------------------------
	-- 运行app
	local ok, result, method, content_type  = pcall( function()
			-- get arguments
			local arg = self.request_data.params
			arg  = type(arg) == 'table' and arg or {}

			-- change env
			setmetatable(getfenv(app.run), {__index = self.registry})
			if app.checkarg then app.checkarg(unpack(arg)) end
			return  app.run( unpack(arg))
	end)

	-- after process =========================================================================================
	-- 默认的结果后处理 
	method = method or app.method or function(x) return x end 
	content_type = content_type or app.content_type or 'text/plain' 

	---------------------------------------===============================

	self.http.response.status = 200
	self.http.response.header = {['Content-Type'] = content_type}
	if ok then
	-- 如果app运行中未发生错误
		self.http.response:write(assert(method( Json.Encode{ 
			result = result, 
			error = Json.Null,
			-- 回传
			id = self.request_data.id,
		} )))
	else
		local err_msg 
		if not DEBUG then 
			err_msg =  result:gsub('^.+lua:%d+:', '') or result or 'unknow error'
		else
		 err_msg = result or 'unknown error'
		end

		self.http.response:write( assert( method( Json.Encode {
			result = Json.Null,
			error = err_msg,
			id = self.request_data.id,
		})))
	end
end



function load_app( self, name )
	-- load file
	local filename = assert((name):gsub('_', base.path.sep))
	local trunk = assert(loadfile(self.appdir ..filename ..'.lua'))

	local box = setmetatable({
		arglist = nil, -- a table for arg types
		name =  name,    -- provide func name
	}, {__index = {assert=assert}})

	box.define = setfenv(function(def) 
		local index_run = #def; assert(index_run ~= 0, 'bad def format')
		local orig_run = def[index_run]
		arglist = def
		arglist[index_run] = nil

		function checkarg(...)
			local arg = {...}
			for k, v in ipairs(arg) do
				local expect = box.arglist[k]
				local provide = type(v)
				assert(expect == 'any' or provide == expect, ('[%s]: arg#%d expect %s, but receive %s'):format(box.name, k, expect, provide))
			end
		end

		run = orig_run
	end, box)
--[[
	-- @params def a table define 
	function box.define(def)
		local index_run = #def; assert(index_run ~= 0, 'bad def format')
		local orig_run	 = def[index_run]
		box.arglist = def; def[index_run] = nil
		
		box.checkarg = setfenv(function(...)
			-- check arg type
			local arg = {...}
			for k, v in ipairs(arg) do
				local expect = box.arglist[k]
				local provide = type(v)
				assert(expect == 'any' or provide == expect, ('[%s]: arg#%d expect %s, but receive %s'):format(box.name, k, expect, provide))
			end
		end, registry)
		box.run = orig_run
	end
]]--

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
		self.request_data =  parse( tostring(self.http.POST) )
	elseif self.request_method == 'GET' then
		self.request_data =  parse( url_decode(self.http.request.query_string) )
	else
		error(('Cannot treat HTTP method: %s'):format(request_method))
	end
end

function check_permmission(self, app)
-------------------------------------------------------------------
	-- 权限检测
	if app.permmission then
		if type(app.permmission) == 'string' then
			local authorization = self.registry.authorization
			return authorization:access_control( app.permmission )  
		else
			error'authorization statement must be string'
		end
	end
end
