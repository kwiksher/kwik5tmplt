local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps

local M = {
  name = "{{name}}",
  properties = {
    {{#properties}}
    target = "{{target}}",
    maskFile = "{{maskFile}}"
    {{/properties}}
  },
  layerProps = layerProps
}
--
return require("components.kwik.layer_map").set(M)
