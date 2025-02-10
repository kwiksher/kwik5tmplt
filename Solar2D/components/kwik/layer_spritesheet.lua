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


  if self.layerProps.imageWidth then
    obj:scale(self.layerProps.imageWidth/obj.width, self.layerProps.imageHeight/obj.height)
  end

  self:setLayerProps(obj)

  obj.name = self.layerProps.name or "_preview"
  obj.type = "sprite"

  if #self.sequenceData > 0 and self.sequenceData[1].pause and not obj.name=="_preview" then
      obj:pause()
  else
    obj:play()
  end
  if obj.name ~="_preview" then
    local targetObj=sceneGroup[obj.name]
    sceneGroup:remove(targetObj)
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