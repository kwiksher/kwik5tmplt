-- $weight=4
--
local _K = require "controller.Application"
local _M = require("components.kwik.layer_image").new()

parseValue = function(value, newValue)
	if newValue then
		if value then
			return newValue
		else
			return nil
		end
	else
		return value
	end
end

local Props = {
  blendMode = "normal",
  height    =  1360 - -80,
  width     = 2348 - -428 ,
  kind      = group,
  name      = "bg",
  type      = "png",
  x         = 2348 + (-428 -2348)/2,
  y         = -80 + (1360 - -80)/2,
  alpha     = 100/100,
}

_M.ultimate = parseValue()
_M.isComic  = parseValue()
_M.infinity = parseValue()
_M.isTmplt  = parseValue()
_M.multLayers = parseValue()
_M.layerSetName = parseValue()
--
_M.layerSet = nil
--
_M.imageWidth  = Props.width/4
_M.imageHeight = Props.height/4
_M.mX, _M.mY   = _K.getPosition(Props.x, Props.y, "")
_M.randXStart  = _K.getPosition()
_M.randXEnd    = _K.getPosition()
_M.dummy, _M.randYStart = _K.getPosition(0, 0)
_M.dummy, _M.randYEnd   = _K.getPosition(0, 0)
_M.infinityDistance = (parseValue() or 0)/4
--
_M.layerName     = Props.name
_M.oriAlpha = Props.alpha
_M.isSharedAsset = parseValue()
_M.imagePath = Props.name.."." .. Props.type
_M.imageName = "/"..Props.name.."." ..Props.type
_M.langGroupName = ""
_M.langTableName = "tab"
_M.scaleX     = parseValue()
_M.scaleY     = parseValue()
_M.rotation   = parseValue()
_M.blendMode     = Props.blendMode
_M.layerAsBg     = parseValue()
_M.infinitySpeed = parseValue()
--
function _M:init(UI)
	if not self.isSharedAsset then
    self.imagePath = UI.page ..self.imageName
  end
  if self.multLayers then
    UI[self.langTableName][self.langGroupName] = {self.imagePath, self.imageWidth, self.imageHeight, self.mX, self.mY, self.oriAlpha}
  end
end
--
function _M:create(UI)
	if not self.isSharedAsset then
    self.imagePath = UI.page ..self.imageName
  end
  local layer = self:myNewImage(UI)
  UI.layers[#UI.layers] = layer
end
--
function _M:didShow(UI)
  local sceneGroup = UI.scene.view
  if not self.multLayers then
    if self.infinity then
       -- Infinity background
       if sceneGroup[self.layerName] == nil  or sceneGroup[self.kayerName.."_2"] == nil then return end
       Runtime:addEventListener("enterFrame", sceneGroup[self.layerName])
       Runtime:addEventListener("enterFrame", sceneGroup[self.kayerName.."_2"])
    end
  end
end
--
function _M:didHide(UI)
  local sceneGroup = UI.scene.view
  if self.infinity then
    if sceneGroup[self.layerName] == nil  or sceneGroup[self.kayerName.."_2"] == nil then return end
      Runtime:removeEventListener("enterFrame", sceneGroup[self.layerName])
      Runtime:removeEventListener("enterFrame", sceneGroup[self.kayerName.."_2"])
  end
end
--
function  _M:destory()
end
--
return _M