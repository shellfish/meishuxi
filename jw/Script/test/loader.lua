require "tr.store.loader"
require "tr.util"

local loader = tr.store.loader.new(require "tr.default_config")

local test = loader:load("test")
print( tr.util.serialize(test) )

