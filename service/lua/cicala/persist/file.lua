-- 关于读写锁 9read lock & write lock
-- 当使用读锁时，之后加读锁成功，加写锁失败
-- 使用写锁时，之后加任何锁都失败， 这就确保了数据一致性

require'lfs'
require'ex'
local util = require'cicala.util'

local setmetatable, getmetatable  = setmetatable, getmetatable 
local io, ipairs, pairs, lfs, os, type =  io, ipairs, pairs, lfs, os, type
local tinsert,  ex = table.insert,  ex
local loadstring = loadstring
local error, assert = error, assert

module(...)

-- new a file session instance
function new( config )

	config = config or assert( cicala.base.session ) 

	local obj = setmetatable({}, {__index = _M})
	assert( config.path,  'must provide parameter path' )

	-- normallize path
	obj.path = util.path_normalizer( config.path, 'dir' )
	obj.expire = config.expire

	-- do init
	obj.pool = {}
	obj.to_write = {}
	obj.to_remove = {}

	obj.share_locks = {}

	return obj
end

function key_to_path( self, key )
	return self.path .. key
end

function get( self, key )
	local value = (self.pool)[ key ]
	if value then
		return value
	elseif self.to_remove[key] then
		return nil, 'session has removed, maybe it has expired'
	else
		local path = self:key_to_path( key )

		local handle, err =  io.open( path ) 
		if not handle then
			return nil, err
		end

		-- check update time if set expire interval
		if self.expire then
			local last_change = lfs.attributes( path, 'change')
			if os.time() - last_change >= self.expire then
				self.to_remove[key] = true
				return nil, 'session has expired'
			end
		end

		-- try to add share lock
		local lock = nil
		while true do
			lock = lfs.lock(handle, 'r')
			if lock then break end
			ex.sleep(0.01)
		end
		
		lfs.touch( path )
		local scope, err =  loadstring( handle:read"*all" )
		if scope then
			local value = scope()
			self.pool[key] = value
			tinsert( self.share_locks, handle )
			return value
		else
			lfs.unlock(handle)
			handle:close()
			return nil, ('invalid session:%s'):format(err)
		end
	end
end

function set(self, key, value)
	self.pool[key] = value
	self.to_write[ key ] = true 
	self.to_remove[key] = nil

	return true
end

--- value(must be a table) will mixin origin value
-- means cover fields which exists originally, and add fields which not exists in pool[key] before
function mixin(self, key, value)
	local origin = self.pool[key] or {} 
	for k, v in pairs(value) do
		origin[k] = v	
	end
	self:set(key, origin)
	return true
end


-- success only if there is no key exists
function add(self, key, value)
	if self:get(key) then
		return nil, ('cannot add for already exists key:' .. key)	
	else
		self:set( key, value )	
		return true
	end
end

function replace(self, key, value)
	if not self:get(key) then
		return nil, 'cannot replace for no correspond session exists'
	else
		self:set( key, value )	
		return true 
	end
end

function remove(self, key)
	self.pool[key] = nil
	self.to_remove[ key ] = true
	return true
end

_M.delete = remove

-- to preprocess value to write

local function serialize(content)
	local t = type(content)	
	if t == 'number' then
		content = content
	elseif t == 'string' or t == 'number' then
		content = ("%q"):format( content )
	elseif t == 'table' then
		content = util.serialize( content )
	else
		error(('cannot serialize value of type(%s)'):format(t))
	end
	
	return 'return ' .. content
end

--- load all session from disk to pool
-- by the same time, we'll check expire and clear outdated ones
function loadall(self)
	for key in lfs.dir(self.path) do
		if  key ~= '.' and key ~= '..' then
			self:get(key)
		end
	end

	for k, _ in pairs( self.to_remove ) do
		ex.remove( self:key_to_path(k) )	
		self.to_remove[k] = nil
	end
end

-- * 释放读锁
-- * 写入已经修改的数据
-- should be hooked properly
function finalize(self)
	for k, v in ipairs( self.share_locks ) do 
		lfs.unlock(v)
		v:close()
		self.share_locks[k] = nil
	end

	for k, _ in pairs( self.to_write ) do

		local path = self:key_to_path(k)

		-- try to add write lock
		local handle = assert( io.open(path, 'w') )
		local lock = nil 

		while true do
			lock = lfs.lock( handle, 'w')
			if lock then break end 
			ex.sleep(0.01)
		end

		handle:write(  serialize( self.pool[k]  ) )
		lfs.unlock( handle )
		handle:close()

		self.to_write[k] = nil
	end

	for k, _ in pairs( self.to_remove ) do
		ex.remove( self:key_to_path(k) )	
		self.to_remove[k] = nil
	end
end

