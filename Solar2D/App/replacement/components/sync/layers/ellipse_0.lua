-- $weight=
--
local parent,root, M = newModule(...)
local app = require "controller.Application"
--
local _layerProps = {
  name     = "ellipse_0",
  x        = 548.5,
  y        = 272,
  width    =  67,
  height    =  67,
  xScale = 1,
  yScale = 0.955224,
  anchorX = 0.5,
  anchorY = 0.5,
  rotation = 0,
  radius   = 33.5,
  color    = { 0.8, 0.8, 0.8, 1 },
  shapedWith = "new_ellipse"
}
--
function M:init(UI)
--local sceneGroup = UI.sceneGroup
end
--
function M:create(UI)
  local layerProps = self.layerProps or _layerProps
  self.layerProps = layerProps
  local obj
  self.imagePath = layerProps.name.."." .. (layerProps.type or ".png")
  local path = UI.props.imgDir..self.imagePath
  -- local path = system.pathForFile(UI.props.imgDir..self.imagePath, system.ResourceDirectory)
  -- local x, y = app.getCenter(layerProps.x, layerProps.y)
  local x, y = app.getNormalizedPosition(layerProps.x, layerProps.y)
  local obj = display.newCircle(
    x,
    y,
    layerProps.radius)
  if obj == nil then
    obj = display.newText(layerProps)
  end
  obj.name = layerProps.name
  obj:setFillColor(unpack(layerProps.color))
  obj.shapedWith = layerProps.shapedWith
  obj.anchorX = layerProps.anchorX or 0.5
  obj.anchorY = layerProps.anchorY or 0.5
  obj.rotation = layerProps.rotation or 0
  obj.layerIndex = #UI.layers+1
  obj.xScale = layerProps.xScale
  obj.yScale = layerProps.yScale
  UI.layers[obj.layerIndex] = obj
  UI.sceneGroup:insert(obj)
  UI.sceneGroup[obj.name] = obj
end
--
function M:didShow(UI)
end
--
function M:didHide(UI)
end
--
function  M:destroy(UI)
end
--
function M:new(props)
  return self:newInstance(props, _layerProps)
end
--
return M
