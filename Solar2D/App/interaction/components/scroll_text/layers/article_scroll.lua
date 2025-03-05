local parent,root, M = newModule(...)
local layerProps = require(M.layerMod).layerProps
local M = {
  name="article",
  --
  properties = {
    target = "article",
    contents  = "article",
    type  = "paragraph",
    isActive = "true",
    area = "layer",
    hideBackGround = true,
    horizontalScrollDisabled = true,
    verticalScrollDisabled = false,
    positionX = NIL,
    positionY = NIL,
    width = 316.5/4,
    height   = 268/4,
  },
  --
  actions={},
  --
  layerProps = layerProps
}
function M:create(UI)
end
function M:didShow(UI)
  self:setScroll(UI)
end
function M:didHide(UI)
end
return require("components.kwik.layer_scroll").set(M)
