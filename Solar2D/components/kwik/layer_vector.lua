local M = require("components.kwik.layer_base").new()
--
function M:create(UI)
  local sceneGroup = UI.sceneGroup
  local layeName = UI.properties.target
  local props = self.properties
  local layerProps = self.layerProps
  local obj

  if props.type == "rect" then
    obj = display.newRect(layerProps.mX, layerProps.mY, layerProps.imageWidth, layerProps.imageHeight)
  elseif props.type == "circle" then
    obj = display.newCircle(layerProps.mX, layerProps.mY, layerProps.imageWidth / 2)
  end
  --
  --
  obj:setFillColor(unpack(props.color))
  --
  self:setLayerProps(obj)
  --
  obj.layerProps = layerProps
  --
  if props.isBackground then
    sceneGroup:insert(1, obj)
  else
    sceneGroup:insert(obj)
  end
  sceneGroup[layerName] = obj
  self.obj = obj
end
--
M.set = function(instance)
  -- print(instance.x, instance.y, instance.width, instance.height)
  return setmetatable(instance, {__index = M})
end

return M
