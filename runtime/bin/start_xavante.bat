@SET LUA_PATH=%cd%\..\share\?.lua;%cd%\..\\share\?\init.lua
@SET LUA_CPATH=%cd%\..\lib\?.dll

@SET LUA_PATH=%LUA_PATH%;%cd%\..\..\service\lua\?.lua;%cd%\..\..\service\lua\?\init.lua

@lua.exe start_xavante.lua
