local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps or {}

local M = {
  name ="{{name}}",
  class = "{{class}}", -- spritesheet
  properties = {
    {{#properties}}
    target = "{{target}}",
    isBackgroud  = {{isBackground}},
    type = "{{type}}",
    {{/properties}}
  }
}
--
M.x = layerProps.x
M.y = layerProps.y
--

return require("components.kwik.layer_vector").new(M)
