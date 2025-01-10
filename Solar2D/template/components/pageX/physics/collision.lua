local name = ...
local parent, root = newModule(name)

local M = {
  name = "{{name}}",
  class="collision",
  properties = {
    {{#properties}}
    body          = "{{body}}",
    isRemoveOther = {{isRemoveOther}},
    isRemoveSelf = {{isRemoveSelf}},
    others  =  "{{others}}"
    {{/properties}}
  },
  actions = { onCollision="{{onCollision}}" },
}

return require("components.kwik.layer_physicsCollision").set(M)
