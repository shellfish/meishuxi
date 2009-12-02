-- 关于读写锁 9read lock & write lock
-- 当使用读锁时，之后加读锁成功，加写锁失败
-- 使用写锁时，之后加任何锁都失败， 这就确保了数据一致性

require'lfs'
require'ex'

-- all cached sessions
local pool = {}
local to_append = {}
local to_remove = {}

-- store read locks 
local share_locks = {}


-- load  a  already exists session 
function get( tab, key )
	local value = rawget(tab, key) 
	if value then
		return value
	else
		local handle =  open( key )
		
		-- not exists in disk
		if not handle then
			return nil, ('session %s not exists'):format(key)
		end

		-- each opened session, keep a share lock
		local lock = false
		while true do
			lock = lfs.lock(handle, 'r')
			if lock then
				break
			else
				ex.sleep(0.01)
			end
		end
		
		-- keep lock
		table.insert( share_locks, lock )
		
		local session = loadfile( key )
		rawset(tab, key, session)
		return session 
	end
end

function new(tab, key, content)
	to_append[key] = true
	rawset( tab, key, content )
end

function remove(key)
	pool[key] = nil
	to_remove[key] = true
end

setmetatable( pool, {__index = get, __newindex = new} )


-- * 释放读锁
-- * 写入已经修改的数据
function finalize()
	for k, v in ipairs( share_locks ) do 
		unlock(v)
	end

	for k, _ in pairs( to_append ) do
		-- try to add write lock
		local handle = io.open(k, 'w')
		local lock = false 

		while true do
			lock = lfs.lock( handle, 'w')
			if lock then 
				break 
			else
				ex.sleep(0.01)
			end
		end

		handle:write( pool[key] )
		lfs.unlock( lock )
	end

	for k, _ in pairs( to_remove ) do
		ex.remove( k )	
	end
end
