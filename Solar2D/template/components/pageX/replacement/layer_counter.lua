local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps or {}

local M = {
  name = "article",
  properties = {
  },
  layerProps = layerProps
}
--
return require("components.kwik.layer_counter").set(M)
