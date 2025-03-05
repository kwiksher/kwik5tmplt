local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps
local M = {
  name="background1",
  --
  properties = {
    target = "background1",
    isActive = "true",
    dampX = true,
    dampY = true,
    dpx = 0.9,
    dpy = 0.9,
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
