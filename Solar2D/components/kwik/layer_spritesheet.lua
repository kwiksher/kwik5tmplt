local M = {}
--
function M:create(UI)
  local sceneGroup  = UI.sceneGroup
  local layer       = UI.layer
  if self.sheet == nil then return end
  local obj = display.newSprite(self.sheet, self.seqeunceData ) -- ff_seq is to be used in future
  if obj == nil then return end
  obj.x        = mX
  obj.y        = mY
  obj.alpha    = oriAlpha
  obj.oldAlpha = oriAlpha
  if self.layerProps.randX then
      obj.x = math.random(randXStart , randXEnd)
  end
  if self.layerProps.randY then
      obj.y = math.random( randYStart , randYEnd)
  end
  obj:scale(imageWidth/obj.width, imageHeight/obj.height)

  if self.layerProps.scaleW then
      obj.xScale = self.layerProps.scaleW
  end
  if self.layerProps.scaleW then
    obj.yScale = self.layerProps.scaleW
  end
  if self.layerProps.rotate then
      obj:rotate( self.layerProps.rotate )
  end
  obj.oriX = obj.x
  obj.oriY = obj.y
  obj.oriXs = obj.xScale
  obj.oriYs = obj.yScale
  obj.name = self.layerProps.name
  obj.type = "sprite"
  if self.classProps.paused then
      obj:pause()
  else
    obj:play()
  end
  sceneGroup[obj.name] = obj
  sceneGroup:insert( obj)
end
--
function M:didShow()
end
--
function M:destroy()
end

---------------------------
M.new = function(instance)
	return setmetatable(instance, {__index=M})
end
--
return M