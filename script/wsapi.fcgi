#!/home/zhousiyv/.kepler/bin/lua

-- 定制的fastcgi launcher

package.path = package.path .. ';../external/share/?.lua'
package.cpath = package.cpath .. ';../external/lib/?.so'

local common = require "wsapi.common"
local fastcgi = require "wsapi.fastcgi"

local function wsapi_loader(wsapi_env)
  local path, file, modname, ext, mtime = 
  	common.find_module(wsapi_env, nil, "wsapi.fcgi")
  local app = common.load_wsapi_isolated(path, file, modname, ext, mtime)
  wsapi_env.APP_PATH = path
  return app(wsapi_env)
end 

fastcgi.run(wsapi_loader)
