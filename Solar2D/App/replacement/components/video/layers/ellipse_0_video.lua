local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps or {}
local M = {
  properties = {
    target = "ellipse_0",
    loop     = "true",
    rewind   = "true",
    isLocal  = "true",
    url      = "kwikplanet.mp4",
    autoPlay = "true",
  },
  actions = {
  },
  layerProps = layerProps
}
--
M.singleNames = {"PagePrevM", "PageNextM"}
--
M.x = layerProps.x
M.y = layerProps.y
--
return require("components.kwik.layer_video").set(M)
