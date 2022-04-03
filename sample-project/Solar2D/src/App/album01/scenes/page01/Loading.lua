local _K = require "Application"
local _M = require("components.kwik.layer_image").new()

---------------
-- from Loading.json
---
local Props = {
  blendMode = "normal",
  height    = 234 - 290,
  width     = 386 - 583,
  kind      = text,
  name      = "Loading",
  x         = 583 + (386 -583)/2,
  y         = 234 + (290 - 234)/2,
  alpha     = 100/100,
}

_M.ultimate = parseValue()
_M.isComic  = parseValue()

------------
-- from Loading_properites.json
---
_M.infinity = parseValue()
_M.isTmplt  = parseValue()
_M.multLayers = parseValue()
_M.layerSetName = parseValue()
--
_M.layerSet = nil
--
_M.imageWidth  = Props.width/4
_M.imageHeight = Props.height/4
_M.mX, _M.mY   = _K.ultimatePosition(Props.x, Props.y, "")
_M.randXStart  = _K.ultimatePosition()
_M.randXEnd    = _K.ultimatePosition()
_M.dummy, _M.randYStart = _K.ultimatePosition(0, nil)
_M.dummy, _M.randYEnd   = _K.ultimatePosition(0, nil)
_M.infinityDistance = (parseValue() or 0)/4
--
_M.layerName     = Props.name
_M.oriAlpha = Props.alpha
_M.isSharedAsset = parseValue()
_M.imagePath = Props.name.."."
_M.imageName = "/"..Props.name.."."
_M.langGroupName = ""
_M.langTableName = "tab"
_M.scaleX     = parseValue()
_M.scaleY     = parseValue()
_M.rotation   = parseValue()
_M.blendMode     = Props.blendMode
_M.layerAsBg     = parseValue()
_M.infinitySpeed = parseValue()
--
function _M:localVars(UI)
	if not self.isSharedAsset then
    self.imagePath = "p"..UI.imagePage ..self.imageName
  end
  if self.isTmplt then
   self.mX, self.mY, self.imageWidth, self.imageHeight , self.imagePath= _K.getModel(self.layerName, self.imagePath, UI.dummy)
  end
  if self.multLayers then
    UI[self.langTableName][self.langGroupName] = {self.imagePath, self.imageWidth, self.imageHeight, self.mX, self.mY, self.oriAlpha}
  end
end
--
function _M:localPos(UI)
	if not self.isSharedAsset then
    self.imagePath = "p"..UI.imagePage ..imageName
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
function _M:toDispose(UI)
  local sceneGroup = UI.scene.view
  if self.infinity then
    if sceneGroup[self.layerName] == nil  or sceneGroup[self.kayerName.."_2"] == nil then return end
      Runtime:removeEventListener("enterFrame", sceneGroup[self.layerName])
      Runtime:removeEventListener("enterFrame", sceneGroup[self.kayerName.."_2"])
    end
  end
end
--
function  _M:toDestory()
end
--
return _M