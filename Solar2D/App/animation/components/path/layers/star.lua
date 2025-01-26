-- $weight=0
--
local app = require "controller.Application"
local M = require("components.kwik.layer_image").new()
local infinity = require("components.kwik.layer_image_infinity")

local layerProps = {
  blendMode = "normal",
  height    =  702 - 487,
  width     = 613 - 387 ,
  kind      = solidColor,
  name      = "star",
  type      = "png",
  x         = 613 + (387 -613)/2,
  y         = 487 + (702 - 487)/2,
  alpha     = 100/100,
  infinity = {
  },

}

M.align       = ""
M.randXStart  = nil
M.randXEnd    = nil
M.randYStart  = nil
M.randYEnd    = nil
--
M.xScale     = nil
M.yScale     = nil
M.rotation   = nil
--
M.layerAsBg     = nil
M.isSharedAsset = nil
--
M:setProps(layerProps)
--
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

  if self.infinity then
    infinity.createInfinityImage(UI, self.obj, self.infinity)
  end
end
--
function M:didShow(UI)
  if self.infinity then
    infinity.addEventListener(self.obj)
  end
end
--
function M:didHide(UI)
  if self.infinity then
    infinity.removeEventListener(self.obj)
  end
end
--
function  M:destroy(UI)
end
--
return M