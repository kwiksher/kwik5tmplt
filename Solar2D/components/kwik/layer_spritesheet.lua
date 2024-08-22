local M = {objs = {}}
--
function M:create(UI)
  local sceneGroup  = UI.sceneGroup
  local layer       = UI.layer
  if self.sheet == nil then
    print("Error sheet is emptry")
    return
  end
  --
  self.layerProps = self.layerProps or {}
  -- for k, v in pairs( self.sequenceData) do print("", k, v) end
  --
  local obj = display.newSprite(self.sheet, self.sequenceData ) -- ff_seq is to be used in future
  if obj == nil then
    print("Error newSprite")
    return
  end
  obj.x        = self.layerProps.mX or 0
  obj.y        = self.layerProps.mY or 0
  obj.alpha    = self.layerProps.oriAlpha or 1
  obj.oldAlpha = self.layerProps.oriAlpha
  if self.layerProps.randX then
      obj.x = math.random(randXStart , randXEnd)
  end
  if self.layerProps.randY then
      obj.y = math.random( randYStart , randYEnd)
  end

  if self.layerProps.imageWidth then
    obj:scale(self.layerProps.imageWidth/obj.width, self.layerProps.imageHeight/obj.height)
  end

  if self.layerProps.scaleW then
      obj.xScale = self.layerProps.scaleW
  end
  if self.layerProps.scaleW then
    obj.yScale = self.layerProps.scaleW
  end
  if self.layerProps.rotate then
      obj:rotate( self.layerProps.rotate )
  end
  -- obj.oriX = obj.x
  obj.oriY = obj.y
  obj.oriXs = obj.xScale
  obj.oriYs = obj.yScale
  obj.name = self.layerProps.name or "_preview"
  obj.type = "sprite"

  if #self.sequenceData > 0 and self.sequenceData[1].pause and not obj.name=="_preview" then
      obj:pause()
  else
    obj:play()
  end
  if obj.name ~="_preview" then
    sceneGroup[obj.name]:removeSelf()
  end
  sceneGroup[obj.name] = obj
  sceneGroup:insert( obj)
  self.objs[#self.objs+1] = obj

end
--
function M:didShow()
end
--
function M:destroy()
  for i, v in next, self.objs do
    display.remove( v )
  end
  self.objs = {}
end

---------------------------
M.new = function(instance)
	return setmetatable(instance, {__index=M})
end
--
return M