local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps
local M = {
  name="rect_0",
  --
  properties = {
    target = "rect_0",
    type  = "",
    isActive = true,
    swipeLength = 120/4,
    limitAngle = 30,
    useStrictBounds = false
  },
  --
  actions={
    onUp = "swipeAction",
    onDown ="swipeAction",
    onRight ="swipeAction",
    onLeft  = "swipeAction"
  },
  --
  layerProps = layerProps
}
function M:create(UI)
  self:setSwipe(UI)
end
function M:didShow(UI)
  self:activate(UI)
end
function M:didHide(UI)
  self:deactivate(UI)
end
return require("components.kwik.layer_swipe").set(M)