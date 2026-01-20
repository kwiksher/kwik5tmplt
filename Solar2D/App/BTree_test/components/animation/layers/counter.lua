-- $weight=0
--
local app = require "controller.Application"
local M = require("components.kwik.layer_image").new()
local infinity = require("components.kwik.layer_image_infinity")

local layerProps = {
  blendMode = "normal",
  height    =  170 - 130,
  width     = 1160 - 960 ,
  kind      = pixel,
  name      = "counter",
  type      = "png",
  x         = 1160 + (960 -1160)/2,
  y         = 130 + (170 - 130)/2,
  -- x         = bounds.right + bounds.left - bounds.right)/2,
  -- y         = bounds.top + bounds.bottom - bounds.top)/2,
  alpha     = 100/100,
  infinity = {
  },
  -- text properties
  contents =  "",
  font =  "",
  fontSize =  nil,
  alignment =  "",
  orientation = "",
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
--
M:setProps(layerProps)
--
-- Set isSharedAsset = true, and then set a common module. See kwikTheCatCommon.lua
--
M.isSharedAsset = nil
M.imagePath   = "animation/counter.png"

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