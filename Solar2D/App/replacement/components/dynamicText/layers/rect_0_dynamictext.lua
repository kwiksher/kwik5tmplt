local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps or {}
--
-- see pageX/layer/layer_text.lua
--
local M = {
  name = "rect_0", -- rect_0
  class = "dynamictext",
  properties = {
    variable = "myVar",
    type     = "local",
    paddingX = 0,
    paddingY = 4,
    color    = { 1, 0, 0, 1 },
    fontSize = 24,
    font = NIL,
    align = "",
  },
}
--
M.layerProps = layerProps
--
return require("components.kwik.layer_dynamictext").new(M)
