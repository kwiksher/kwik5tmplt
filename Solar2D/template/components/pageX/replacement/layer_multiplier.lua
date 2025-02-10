local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps

local M = {
  name = "{{name}}",
  properties = {
    {{#properties}}
    {{/properties}}
  },
  layerProps = layerProps
}
--
return require("components.kwik.layer_multiplier").set(M)
