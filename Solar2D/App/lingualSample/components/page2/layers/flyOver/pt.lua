-- $weight=1
--
local app = require "controller.Application"
local M = require("components.kwik.layer_image").new()

local layerProps = {
  blendMode = "passThrough",
  height    =  889 - 822,
  width     = 754 - 515 ,
  kind      = group,
  name      = "flyOver/pt",
  type      = "png",
  x         = 754 + (515 -754)/2,
  y         = 822 + (889 - 822)/2,
  alpha     = 100/100,
}

M.align       = ""
M.randXStart  = nil
M.randXEnd    = nil
M.randYStart  = nil
M.randYEnd    = nil
--
M.scaleX     = nil
M.scaleY     = nil
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
  UI.layers[#UI.layers] = self:createImage(UI)
end
--
function M:didShow(UI)
end
--
function M:didHide(UI)
end
--
function  M:destroy(UI)
end
--
return M