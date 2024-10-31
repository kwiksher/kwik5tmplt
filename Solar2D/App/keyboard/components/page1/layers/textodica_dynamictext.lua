local name = ...
local parent,root = newModule(name)
--
-- see pageX/layer/layer_text.lua
--
local M = {
  name = "textodica", -- textodica
  class = "dynamictext",
  properties = {
    variable = "numDica",
    type     = "local",
    offset = 0,
    color    = { 0, 0, 0, 1 },
    fontSize = 24,
    font = NIL,
    align = "",
  },
}
--
M.layerProps = require(parent.."textodica")
--
M.x = M.layerProps.mX
M.y = M.layerProps.mY


return require("components.kwik.layer_dynamictext").new(M)
