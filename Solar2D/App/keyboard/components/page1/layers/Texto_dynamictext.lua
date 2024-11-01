local name = ...
local parent,root = newModule(name)
--
-- see pageX/layer/layer_text.lua
--
local M = {
  name = "Texto", -- Texto
  class = "dynamictext",
  properties = {
    variable = "LED",
    type     = "local",
    offsetX = 0,
    offsetY = 4,
    color    = { 0,1 ,1 , 1 },
    fontSize = 24,
    font = "",
    align = "",
  },
}
--
M.layerProps = require(parent.."Texto")
--
M.x = M.layerProps.mX
M.y = M.layerProps.mY


return require("components.kwik.layer_dynamictext").new(M)
