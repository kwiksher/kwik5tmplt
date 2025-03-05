local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps
local M = {
  name="background2",
  --
  properties = {
    target = "background2",
    isActive = "true",
    dampX = true,
    dampY = true,
    dpx = 1,
    dpy = 1,
  },
  --
  actions={
    onBack = "",
    onForward ="",
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
