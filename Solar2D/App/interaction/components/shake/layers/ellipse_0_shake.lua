local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps
local M = {
  name="ellipse_0",
  --
  properties = {
    target = "ellipse_0",
    type  = "",
    isActive = "true",
  },
  --
  actions={
    onComplete = "shakeAction",
  },
  --
  layerProps = layerProps
}
function M:create(UI)
  self:setShake(UI)
end
function M:didShow(UI)
  self:activate(UI)
end
function M:didHide(UI)
  self:deactivate(UI)
end
return require("components.kwik.layer_shake").set(M)
