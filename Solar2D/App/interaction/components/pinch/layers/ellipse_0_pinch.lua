local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps
local M = {
  name="ellipse_0",
  --
  properties = {
    target = "ellipse_0",
    type  = "",
    isActive = "true",
    constrainAngle = NIL,
    xStart=NIL,
    yStart=NIL,
    yStart=NIL,
    yEnd = NIL,
    scaleMin = 0.3,
    scaleMax = 3
  },
  --
  actions={
    onEnded ="",
    onMoved=""
  },
  --
  layerProps = layerProps
}
function M:create(UI)
  self:setPinch(UI)
end
function M:didShow(UI)
  self:activate(UI)
end
function M:didHide(UI)
  self:deactivate(UI)
end
return require("components.kwik.layer_pinch").set(M)
