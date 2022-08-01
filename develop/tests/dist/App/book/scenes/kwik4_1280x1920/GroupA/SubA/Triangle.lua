-- $weight=0
--
local app = require "controller.Application"
local _M = require("components.kwik.layer_image").new()

local Props = {
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

-- _M.infinity = app.parseValue()
-- _M.infinitySpeed = app.parseValue()
--

_M.align       = ""
_M.randXStart  = nil
_M.randXEnd    = nil
_M.randYStart  = nil
_M.randYEnd    = nil
--
_M.scaleX     = nil
_M.scaleY     = nil
_M.rotation   = nil
--
_M.layerAsBg     = nil
_M.isSharedAsset = nil

_M:setProps(Props)
--
function _M:init(UI)
	if not self.isSharedAsset then
    self.imagePath = UI.page ..self.imageName
  end
end
--
function _M:create(UI)
	if not self.isSharedAsset then
    self.imagePath = UI.page ..self.imageName
  end
  UI.layers[#UI.layers] = self:createImage(UI)
end
--
function _M:didShow(UI)
  local sceneGroup = UI.scene.view
end
--
function _M:didHide(UI)
  local sceneGroup = UI.scene.view
end
--
function  _M:destory()
end
--
return _M