local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps
--
-- see pageX/layer/layer_text.lua
--
local M = {
  name = "{{layer}}", -- {{name}}
  class = "dynamictext",
  properties = {
    {{#properties}}
    variable = "{{variable}}",
    type     = "{{type}}",
    offsetX = {{offsetX}},
    offsetY = {{offsetY}},
    {{#color}}
    color    = { {{r}}, {{g}}, {{b}}, {{a}} },
    {{/color}}
    fontSize = {{fontSize}},
    font = {{font}},
    align = "{{align}}",
    {{/properties}}
  },
}
--
M.layerProps = layerProps
--
M.x = M.layerProps.mX
M.y = M.layerProps.mY


return require("components.kwik.layer_dynamictext").new(M)
