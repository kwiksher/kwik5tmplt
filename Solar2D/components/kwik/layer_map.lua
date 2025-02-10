local M = require("components.kwik.layer_base").new()
--
function M:create(UI)
  local sceneGroup = UI.sceneGroup
  local layeName = UI.properties.target
  local props = self.properties
  local layerProps = self.layerProps

  local obj = native.newMapView(layerProps.mX, layerProps.mY, layerProps.imageWidth, layerProps.imageHeight)
  obj.mapType = props.mapType
  obj:setCenter(props.latituite, props.longtitude)
  obj.isScrollEnabled = props.isScrollEnabled
  obj.isZoomEnabled = props.isZoomEnabled

  if props.marker.enabled then
    obj:addMarker(
      props.marker.latituite,
      props.marker.longtitude,
      {title = props.marker.title, subtitle = props.marker.subtitle}
    )
  end

  self:setLayerProps(obj)
  --
  obj.layerProps = layerProps
  local original = sceneGroup[layerName]
  if original then
    original:removeSelf()
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
