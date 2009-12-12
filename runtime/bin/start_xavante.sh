#!/bin/sh

export LUA_PATH="$PWD/../share/?.lua;$PWD/../share/?/init.lua"
export LUA_CPATH="$PWD/../lib_linux/?.so"
export LUA_INIT=""

exec ./lua start_xavante.lua
