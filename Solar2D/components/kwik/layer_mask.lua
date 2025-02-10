local M = require("components.kwik.layer_base").new()
--
function M:create(UI)
  local sceneGroup = UI.sceneGroup
  local layeName = UI.properties.target
  local props = self.properties
  local layerProps = self.layerProps
    --
    local target = sceneGroup[layerName]
    local group = display.newGroup()
    group:insert(target)
    target.group = group
    sceneGroup:insert(group)

    local path = UI.props.imgDir..props.maskFile
    local mask = graphics.newMask(path, UI.props.systemDir)
    if mask then
      target.group:setMask(mask)
      target.group.maskScaleX = layerProps.scaleX
      target.group.maskScaleY = layerProps.scaleY
      target.group.maskX = layerProps.mX
      target.group.maskY = layerProps.mY
    end
end
--
M.set = function(instance)
  -- print(instance.x, instance.y, instance.width, instance.height)
  return setmetatable(instance, {__index = M})
end
return M
