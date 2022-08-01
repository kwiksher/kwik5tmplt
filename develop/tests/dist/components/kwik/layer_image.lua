local _M = {}
--
local app = require "controller.Application"
local util = require "lib.util"

function _M:createImage(UI)
  local sceneGroup = UI.scene.view
  local layer = display.newImageRect(
    UI.props.imgDir..self.imagePath,
    UI.props.systemDir,
    self.imageWidth,
    self.imageHeight)
  if layer == nil then return nil end
  --
  layer.imagePath = self.imagePath
  layer.x         = self.mX
  layer.y         = self.mY
  layer.alpha     = self.oriAlpha
  layer.oldAlpha  = self.oriAlpha
  layer.blendMode = self.blendMode
  --
  if self.randXStart > 0 then
    layer.x = math.random( self.randXStart, self.randXEnd)
  end
  if self.randYStart > 0 then
    layer.y = math.random( self.randYStart, self.randYEnd)
  end
  if self.scaleX then
    layer.xScale = self.scaleX
  end
  if self.scaleY then
    layer.yScale = self.scaleY
  end
  if self.rotation then
    layer:rotate( self.rotation )
  end
  --
  layer.oriX = layer.x
  layer.oriY = layer.y
  layer.oriXs = layer.xScale
  layer.oriYs = layer.yScale
  layer.name = self.layerName
  layer.type = "image"
  --
  sceneGroup[self.layerName] = layer
  --
  if self.layerAsBg then
    sceneGroup:insert( 1, layer)
  else
    sceneGroup:insert( layer)
  end
  --
  return layer

end
--
_M.new = function()
	local instance = {}
	return setmetatable(instance, {__index=_M})
end

return _M