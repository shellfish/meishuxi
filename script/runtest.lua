#! /usr/bin/env lua

local action = arg[1]
local run = nil

local function main()

	while true do
		if not action then
			action = 'test'
		--	print( string.format('invalid useage, use %s to get help', arg[0]))
		else
			if action == 'help' then
				print(([[
		usage %s options
		Available options are:

			help         show this message
			test         normal test
				]]):format(arg[0]))
			elseif action == 'test' then
				run()
				os.exit()
			else
				print(string.format('invalid useage, use %s to get help', arg[0]))
			end
		end
	end
end

function run()

	dofile'preload.lua'
	require'lfs'
	require'luaunit'
	require'cicala.base'

	local path = cicala.base.path
	local config = cicala.base.config

	local test_scripts = path.translate'lua/cicala/test/'


	local count = 0
	for file in lfs.dir( test_scripts ) do	
		if file ~= '.' and file ~= '..' and file:find('%.lua$') then
			full_file = test_scripts .. file
			local trunk = assert( loadfile(full_file) )

			trunk(config)

			count = count + 1
			print('完成测试 ' .. count .. ' \n\n')
		end
	end

end

main()

