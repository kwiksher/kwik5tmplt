local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps or {}
local M = {
  properties = {
    target   = "rect_0",
    isLocal  = true,
    url      = "index.html",
    width    = 480,
    height   = 320
  },
  layerProps = layerProps
}
--
return require("components.kwik.layer_web").set(M)
