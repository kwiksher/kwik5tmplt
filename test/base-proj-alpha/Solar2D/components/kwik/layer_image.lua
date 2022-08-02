local M = {}
--
local app = require "controller.Application"
local util = require "lib.util"

function M:setProps(layerProps)
  self.imageWidth  = layerProps.width/4
  self.imageHeight = layerProps.height/4
  self.mX, self.mY   = app.getPosition(layerProps.x, layerProps.y, self.align)
  --
  self.randXStart  = app.getPosition(self.randXStart)
  self.randXEnd    = app.getPosition(self.randXEnd)
  self.dummy, self.randYStart = app.getPosition(0, self.randYStart)
  self.dummy, self.randYEnd   = app.getPosition(0, self.randYEnd)
  --
  self.layerName = layerProps.name
  self.oriAlpha  = layerProps.alpha
  --
  self.imagePath = layerProps.name.."." .. layerProps.type
  self.imageName = "/"..layerProps.name.."." ..layerProps.type
  --
  self.blendMode = layerProps.blendMode
end

function M:createImage(UI)
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
M.new = function()
	local instance = {}
	return setmetatable(instance, {__index=M})
end

return M