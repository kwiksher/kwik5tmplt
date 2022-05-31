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
  blendMode = "{{blendMode}}",
  height    = {{bounds.top}} - {{bounds.bottom}},
  width     = {{bounds.left}} - {{bounds.right}},
  kind      = {{kind}},
  name      = "{{name}}",
  type      = "png",
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
_M.mX, _M.mY   = _K.getPosition(Props.x, Props.y, "{{align}}")
_M.randXStart  = _K.getPosition({{randXStart}})
_M.randXEnd    = _K.getPosition({{randXEnd}})
_M.dummy, _M.randYStart = _K.getPosition(0, 0)
_M.dummy, _M.randYEnd   = _K.getPosition(0, 0)
_M.infinityDistance = (parseValue({{idist}}) or 0)/4
--
_M.layerName     = Props.name
_M.oriAlpha = Props.alpha
_M.isSharedAsset = parseValue({{kwk}})
_M.imagePath = Props.name.."." .. Props.type
_M.imageName = "/"..Props.name.."." ..Props.type
_M.langGroupName = "{{dois}}"
_M.langTableName = "tab{{um}}"
_M.scaleX     = parseValue({{scaleW}})
_M.scaleY     = parseValue({{scaleH}})
_M.rotation   = parseValue({{rotation}})
_M.blendMode     = Props.blendMode
_M.layerAsBg     = parseValue({{layerAsBg}})
_M.infinitySpeed = parseValue({{infinitySpeed}})
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