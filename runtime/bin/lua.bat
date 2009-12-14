@SET LUA_PATH=%cd%\..\share\?.lua;%cd%\..\\share\?\init.lua
@SET LUA_CPATH=%cd%\..\lib\?.dll

@SET LUA_PATH=%LUA_PATH%;%cd%\..\..\service\lua\?.lua;%cd%\..\..\service\lua\?\init.lua

if {%1} == {} @lua.exe %*
if "%1" == "test" @lua.exe -lluaunit runtest.lua
