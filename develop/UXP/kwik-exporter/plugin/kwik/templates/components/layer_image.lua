local _K = require "Application"
local _M = require("components.kwik.layer_image").new()

local Props = {
  blendMode = "{{blendMode}}",
  height    = {{bounds.top}} - {{bounds.bottom}},
  width     = {{bounds.left}} - {{bounds.right}},
  kind      = {{kind}},
  name      = "{{name}}",
  x         = {{bounds.right}} + ({{bounds.left}} -{{bounds.right}})/2,
  y         = {{bounds.top}} + ({{bounds.bottom}} - {{bounds.top}})/2,
  alpha     = {{opacity}}/100,
}

_M.ultimate = parseValue({{ultimate}})
_M.isComic  = parseValue({{isComic}})
_M.infinity = parseValue({{infinity}})
_M.isTmplt  = parseValue({{isTmplt}})
_M.multLayers = parseValue({{multLayers}})
_M.layerSetName = parseValue({{mySet}})
--
_M.layerSet = nil
{{#isComic}}
{{#mySet}}
_M.layerSet = {
  {{#layerSet}}
    {
      myLName = "{{myLName}}",
      x         = {{bounds.right}} + ({{bounds.left}} -{{bounds.right}})/2,
      y         = {{bounds.top}} + ({{bounds.bottom}} - {{bounds.top}})/2,
      height    = {{bounds.top}} - {{bounds.bottom}},
      width     = {{bounds.left}} - {{bounds.right}},
     frameSet = {
        {{#frameSet}}
          {_
            myLName = "{{myLName}}",
            x         = {{bounds.right}} + ({{bounds.left}} -{{bounds.right}})/2,
            y         = {{bounds.top}} + ({{bounds.bottom}} - {{bounds.top}})/2,
            height    = {{bounds.top}} - {{bounds.bottom}},
            width     = {{bounds.left}} - {{bounds.right}},
          },
      {{/frameSet}}
      }
    },
  {{/layerSet}}
  }
{{/mySet}}
{{/isComic}}
--
_M.imageWidth  = Props.width/4
_M.imageHeight = Props.height/4
_M.mX, _M.mY   = _K.ultimatePosition(Props.x, Props.y, "{{align}}")
_M.randXStart  = _K.ultimatePosition({{randXStart}})
_M.randXEnd    = _K.ultimatePosition({{randXEnd}})
_M.dummy, _M.randYStart = _K.ultimatePosition(0, {{randYStart}})
_M.dummy, _M.randYEnd   = _K.ultimatePosition(0, {{randYEnd}})
_M.infinityDistance = (parseValue({{idist}}) or 0)/4
--
_M.layerName     = Props.name
_M.oriAlpha = Props.alpha
_M.isSharedAsset = parseValue({{kwk}})
_M.imagePath = Props.name..".{{fExt}}"
_M.imageName = "/"..Props.name..".{{fExt}}"
_M.langGroupName = "{{dois}}"
_M.langTableName = "tab{{um}}"
_M.scaleX     = parseValue({{scaleW}})
_M.scaleY     = parseValue({{scaleH}})
_M.rotation   = parseValue({{rotation}})
_M.blendMode     = Props.blendMode
_M.layerAsBg     = parseValue({{layerAsBg}}
_M.infinitySpeed = parseValue({{infinitySpeed}})
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