#!/bin/sh

root_path='/home/zhousiyv/桌面/trunk/service'
export LUA_PATH="$root_path/meishu/Lua/?.lua;$root_path/meishu/Lua/?/init.lua;$root_path/PublicLib/?.lua;$root_path/PublicLib/?/init.lua;$LUA_PATH"

lua $* 