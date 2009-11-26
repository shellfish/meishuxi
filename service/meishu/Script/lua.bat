SETLOCAL

::SET SERVICE_ROOT=C:\Luarocks\Kepler\htdocs\service
@SET SERVICE_ROOT=Z:\home\zhousiyv\trunk\service
@SET SERVICE_MEISHU_ROOT=%SERVICE_ROOT%\meishu\Lua

@SET SERVICE_PUBLIC_LIB_ROOT=%SERVICE_ROOT%\PublicLib


@SET LUA_PATH=%LUA_PATH%;%SERVICE_MEISHU_ROOT%\?.lua;%SERVICE_MEISHU_ROOT%\?\init.lua;%SERVICE_PUBLIC_LIB_ROOT%\?.lua;%SERVICE_PUBLIC_LIB_ROOT%\?\init.lua

Lua %*

pause

