local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps
local M = {
  name="rect_0",
  --
  properties = {
    target = "rect_0",
    type  = "",
    isActive = "true",
    minAngle  = 0,
    maxAngle  = 0
  },
  --
  actions={
    onClokwise = "spinAction",
    onCounterClockwise ="spinAction",
    onEnded ="spinAction",
  },
  --
  layerProps = layerProps
}
function M:create(UI)
  self:setSpin(UI)
end
function M:didShow(UI)
  self:activate(UI)
end
function M:didHide(UI)
  self:deactivate(UI)
end
return require("components.kwik.layer_spin").set(M)