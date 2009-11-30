#! /bin/sh

exec lua   -e "`cat preload.lua`" $* 
