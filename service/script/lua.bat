@SET PATH=%cd%\..\..\runtime\bin;%PATH%
@SET LUA_PATH=%cd%\..\..\runtime\alternative\?.lua;%cd%\..\..\runtime\share\?.lua;%cd%\..\..\runtime\share\?\init.lua
@SET LUA_CPATH=%cd%\..\..\runtime\lib\?.dll
@SET LUA_PATH=%cd%\..\lua\?.lua;%cd%\..\lua\?\init.lua;%LUA_PATH%

lua.exe -lluaunit %*
