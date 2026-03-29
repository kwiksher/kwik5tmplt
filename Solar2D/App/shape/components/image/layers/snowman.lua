-- $weight=
--
local app = require "controller.Application"
local M = require("components.kwik.layer_image").new()
local infinity = require("components.kwik.layer_image_infinity")
local layerProps = {
  blendMode = "",
  height    =  886 - 394,
  width     = 1162 - 758 ,
  kind      = "image",
  name      = "snowman",
  type      = "png",
  x         = 1162 + (758 -1162)/2,
  y         = 394 + (886 - 394)/2,
  -- x         = bounds.right + bounds.left - bounds.right)/2,
  -- y         = bounds.top + bounds.bottom - bounds.top)/2,
  alpha     = 100/100,
  infinity = {
    enabled = false,
    speed = 1,
    distance = 0,
    direction = "right",
  },
  -- text properties
  contents =  "",
  font =  "native.systemFont",
  fontSize =  16,
  alignment =  "",
  orientation = "",
  psdPage     = "image"
}
M.attachToEdge      = ""
M.randXStart  = nil
M.randXEnd    = nil
M.randYStart  = nil
M.randYEnd    = nil
--
M.xScale     = 1
M.yScale     = 1
M.rotation   = 0
--
M.layerAsBg     = false
--
M:setProps(layerProps)
--
-- Set isSharedAsset = true, and then set a common module. See kwikTheCatCommon.lua
--
M.isSharedAsset = false
M.imagePath   = "image/snowman.png"
function M:init(UI)
  --local sceneGroup = UI.scene.view
  if not self.isSharedAsset then
    self.imagePath = UI.page ..self.imageName
  end
end
--
function M:create(UI)
  if not self.isSharedAsset then
    self.imagePath = UI.page ..self.imageName
  end
  local obj = self:createImage(UI)
  UI.layers[#UI.layers] = obj
  self.obj = obj
  if self.infinity and self.infinity.enabled then
    infinity.createInfinityImage(UI, self.obj, self.infinity)
  end
end
--
function M:didShow(UI)
  if self.infinity and self.infinity.enabled then
    infinity.addEventListener(self.obj)
  end
end
--
function M:didHide(UI)
  if self.infinity and self.infinity.enabled then
    infinity.removeEventListener(self.obj)
  end
end
--
function  M:destroy(UI)
end
--
return M
