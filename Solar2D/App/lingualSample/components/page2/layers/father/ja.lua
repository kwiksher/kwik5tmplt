-- $weight=0
--
local app = require "controller.Application"
local M = require("components.kwik.layer_image").new()
local infinity = require("components.kwik.layer_image_infinity")

local layerProps = {
  blendMode = "normal",
  height    =  291 - 216,
  width     = 1255 - 488 ,
  kind      = text,
  name      = "father/ja",
  type      = "png",
  x         = 1255 + (488 -1255)/2,
  y         = 216 + (291 - 216)/2,
  alpha     = 100/100,
  infinity = {
  },
  -- text properties
  contents =  "%E7%A7%81%E3%81%AE %E7%88%B6%E3%81%95%E3%82%93 %E3%81%AF %E3%81%99%E3%81%A6%E3%81%8D",
  font =  "KozGoPr6N-Regular",
  fontSize =  80,
  alignment =  "left",
  color    =  { 255, 255, 255, 1 },
  orientation = "horizontal",
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