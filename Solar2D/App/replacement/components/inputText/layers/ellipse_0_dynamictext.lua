local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps or {}
--
-- see pageX/layer/layer_text.lua
--
local M = {
  name = "ellipse_0", -- ellipse_0
  class = "dynamictext",
  properties = {
    variable = "",
    type     = "local",
    paddingX = 0,
    paddingY = 0,
    color    = { 0, 0, 0, 1 },
    fontSize = 24,
    font = NIL,
    align = "",
  },
}
--
M.layerProps = layerProps
--
return require("components.kwik.layer_dynamictext").new(M)
