-- $weight={{weight}}
--
local app = require "controller.Application"
local _M = require("components.kwik.layer_image").new()

local Props = {
  blendMode = "{{blendMode}}",
  height    =  {{bounds.bottom}} - {{bounds.top}},
  width     = {{bounds.right}} - {{bounds.left}} ,
  kind      = {{kind}},
  name      = "{{parent}}{{name}}",
  type      = "png",
  x         = {{bounds.right}} + ({{bounds.left}} -{{bounds.right}})/2,
  y         = {{bounds.top}} + ({{bounds.bottom}} - {{bounds.top}})/2,
  alpha     = {{opacity}}/100,
}

--
_M.imageWidth  = Props.width/4
_M.imageHeight = Props.height/4
_M.mX, _M.mY   = app.getPosition(Props.x, Props.y, "{{align}}")
--
_M.randXStart  = app.getPosition({{randXStart}})
_M.randXEnd    = app.getPosition({{randXEnd}})
_M.dummy, _M.randYStart = app.getPosition(0, {{randYStart}})
_M.dummy, _M.randYEnd   = app.getPosition(0, {{randYEnd}})
--
_M.layerName     = Props.name
_M.oriAlpha = Props.alpha
--
_M.isSharedAsset = parseValue({{kwk}})
_M.imagePath = Props.name.."." .. Props.type
_M.imageName = "/"..Props.name.."." ..Props.type
_M.scaleX     = parseValue({{scaleW}})
_M.scaleY     = parseValue({{scaleH}})
_M.rotation   = parseValue({{rotation}})
_M.blendMode     = Props.blendMode
_M.layerAsBg     = parseValue({{layerAsBg}})
--
function _M:init(UI)
  --local sceneGroup = UI.scene.view
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
end
--
function _M:didHide(UI)
end
--
function  _M:destory(UI)
end
--
return _M