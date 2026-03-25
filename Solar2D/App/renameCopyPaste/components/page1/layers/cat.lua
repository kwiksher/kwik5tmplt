-- $weight=7
--
local app = require "controller.Application"
local M = require("components.kwik.layer_image").new()
local infinity = require("components.kwik.layer_image_infinity")

local layerProps = {
  blendMode = "passThrough",
  height    =  994 - 470,
  width     = 1512 - 440 ,
  kind      = group,
  name      = "cat",
  type      = "png",
  x         = 1512 + (440 -1512)/2,
  y         = 470 + (994 - 470)/2,
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

  local centerX, centerY = display.contentCenterX, display.contentCenterY
  local dx, dy = obj.x - centerX, obj.y - centerY
  local dist = math.sqrt(dx * dx + dy * dy)
  print("DEBUG_CENTER", "cat", "x", obj.x, "y", obj.y, "dx", dx, "dy", dy, "dist", dist)

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