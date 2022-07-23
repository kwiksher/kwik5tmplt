-- $weight=1
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
  height    =  958 - 782,
  width     = 1052 - 868 ,
  kind      = solidColor,
  name      = "star",
  type      = "png",
  x         = 1052 + (868 -1052)/2,
  y         = 782 + (958 - 782)/2,
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
  if self.isTmplt then
   self.mX, self.mY, self.imageWidth, self.imageHeight , self.imagePath= _K.getModel(self.layerName, self.imagePath, UI.dummy)
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
  if not self.multLayers then
    local layer = self:myNewImage(UI)
    if self.isComic then
      if self.layerSet then
        self:myComicImage(UI, layer)
      else
        self:myNewImage(UI)
      end
    end
  else
    if not self.isComic then
      self:myNewImage(UI)
    end
  end
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