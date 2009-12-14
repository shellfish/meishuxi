@SETLOCAL LUA_PATH=%cd%\..\share\?.lua;%cd%\..\\share\?\init.lua
@SETLOCAL LUA_CPATH=%cd%\..\lib\?.dll

@SETLOCAL LUA_PATH=%LUA_PATH%;%cd%\..\..\service\lua\?.lua;%cd%\..\..\service\lua\?\init.lua

@lua.exe start_xavante.lua
