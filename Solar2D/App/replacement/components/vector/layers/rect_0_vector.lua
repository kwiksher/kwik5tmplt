local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps or {}
local M = {
  name ="rect_0",
  class = "vector", -- spritesheet
  properties = {
    target = "",
    isBackgroud  = false,
    type = "rectangle",
    color    = { 0.8, 0.8, 0.49803921568627, 1 },
  },
  layerProps = layerProps
}--
--
return require("components.kwik.layer_vector").set(M)
