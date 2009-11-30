---------------------------------------------------------------------------
---
-- meishuxi.ws: the service dispatcher script (wsapi content-handler)
-- Place it under a dir which acn be access by the web server
-- @release meishuxi.ws 2009年 11月 29日 星期日 14:02:18 CST
---------------------------------------------------------------------------


---------------------------------------------------------------------------
--- define global var 
local config = dofile'preload.lua' 

require'cicala'
return cicala.wsapi_app.new( config )
