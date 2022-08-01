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

_M.infinity = app.parseValue()
_M.infinitySpeed = app.parseValue()
--
_M.imageWidth  = Props.width/4
_M.imageHeight = Props.height/4
_M.mX, _M.mY   = app.getPosition(Props.x, Props.y, "")
--
_M.randXStart  = app.getPosition()
_M.randXEnd    = app.getPosition()
_M.dummy, _M.randYStart = app.getPosition(0, 0)
_M.dummy, _M.randYEnd   = app.getPosition(0, 0)
 _M.infinityDistance    = (app.parseValue() or 0)/4
--
_M.layerName     = Props.name
_M.oriAlpha      = Props.alpha

_M.isSharedAsset = app.parseValue()
_M.imagePath     = Props.name.."." .. Props.type
_M.imageName     = "/"..Props.name.."." ..Props.type
_M.scaleX        = app.parseValue()
_M.scaleY        = app.parseValue()
_M.rotation      = app.parseValue()
_M.blendMode     = Props.blendMode
_M.layerAsBg     = app.parseValue()

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