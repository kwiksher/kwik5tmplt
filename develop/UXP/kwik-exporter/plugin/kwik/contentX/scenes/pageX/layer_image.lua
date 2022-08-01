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

_M.align       = "{{align}}"
_M.randXStart  = {{randXStart}}
_M.randXEnd    = {{randXEnd}}
_M.randYStart  = {{randYStart}}
_M.randYEnd    = {{randYEnd}}
--
_M.scaleX     = {{scaleW}}
_M.scaleY     = {{scaleH}}
_M.rotation   = {{rotation}}
--
_M.layerAsBg     = {{layerAsBg}}
_M.isSharedAsset = {{kwk}}
--
_M:setProps(Props)
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