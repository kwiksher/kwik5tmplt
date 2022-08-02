-- $weight=0
--
local app = require "controller.Application"
local M = require("components.kwik.layer_image").new()

local layerProps = {
  blendMode = "normal",
  height    =  967 - 847,
  width     = 1513 - 1386 ,
  kind      = solidColor,
  name      = "GroupA/SubA/Triangle",
  type      = "png",
  x         = 1513 + (1386 -1513)/2,
  y         = 847 + (967 - 847)/2,
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

M:setProps(layerProps)
--
function M:init(UI)
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
  local sceneGroup = UI.scene.view
end
--
function M:didHide(UI)
  local sceneGroup = UI.scene.view
end
--
function  M:destory()
end
--
return M