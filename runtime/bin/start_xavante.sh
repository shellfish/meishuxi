#!/bin/sh

cpath=$(dirname $0)
export LUA_PATH="$cpath/../share/?.lua;$cpath/../share/?/init.lua"
export LUA_CPATH="$cpath/../lib_linux/?.so"
export LUA_INIT=""

exec $cpath/lua $cpath/start_xavante.lua "$cpath"
