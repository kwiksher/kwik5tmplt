local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps or {}
--
-- see pageX/layer/layer_text.lua
--
local M = {
  name = "name", --
  class = "dynamictext",
  properties = {
    variable = "myText",
    type     = "local",
    paddingX = 0,
    paddingY = 4,
    color    = { 0, 0, 0, 1 },
    fontSize = 24,
    font = "native.systemFont",
    align = "",
  },
}
--
M.layerProps = layerProps
--
return require("components.kwik.layer_dynamictext").new(M)
