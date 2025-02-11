local M = require("components.kwik.layer_base").new()
--
function M:create(UI)
  local sceneGroup = UI.sceneGroup
  local layerName  = self.properties.target
  local props = self.properties
  local layerProps = self.layerProps
  local width = layerProps.imageWidth
  local height = layerProps.imageHeight
  if props.width > 0 then
    width = props.width
  end
  if props.height > 0 then
    height = props.height
  end
  local obj = native.newWebView( layerProps.mX, layerProps.mY, width, height )

    if props.isLocal then
      -- Loads web pages
      obj:request( props.url, UI.props.wwwDir )
    else
      -- Loads web pages
      obj:request( props.url )
    end

    sceneGroup:insert( obj )
    sceneGroup[layerName] = obj
    self.obj = obj

end
--
function M:destroy(UI)
  if self.obj  ~= nil then
    self.obj:removeSelf()
    self.obj = nil
  end
end
--
M.new = function(instance)
  -- print(instance.x, instance.y, instance.width, instance.height)
  return setmetatable(instance, {__index = M})
--
return _M