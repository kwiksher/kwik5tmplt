local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps

local M = {
  name="{{name}}",
  --
  properties = {
    {{#properties}}
    target = "{{layer}}",
    isActive = "{{isActive}}",
    dampX = {{dampX}},
    dampY = {{dampY}},
    dpx = {{dpx}},
    dpy = {{dpy}},
    {{/properties}}
  },
  --
  actions={
    onBack = "{{onBack}}",
    onForward ="{{onForward}}",
  },
  --
  layerProps = layerProps
}

function M:create(UI)
  self:setParallax(UI)
end

function M:didShow(UI)
  self:activate(UI)
end

function M:didHide(UI)
  self:deactivate(UI)
end

return require("components.kwik.layer_parallax").set(M)