-- $weight=
--
local parent,root, M = newModule(...)
local app = require "controller.Application"
local shape = require("components.kwik.layer_shape")
--
local layerProps = {
  name     = "ellipse_0",
  x        = 1006,
  y        = 225,
  width    =  60,
  height    =  60,
  xScale = 2,
  yScale = 1,
  anchorX = 0,
  anchorY = 0,
  rotation = 0,
  color    = { 0, 1, 1, 1 },
  shapedWith = "new_ellipse"
}
M.layerProps = layerProps
--
function M:init(UI)
--local sceneGroup = UI.sceneGroup
end
--
function M:create(UI)
  local layerProps = self.layerProps
  local obj
  self.imagePath = layerProps.name.."." .. (layerProps.type or ".png")
  local path = UI.props.imgDir..self.imagePath
  -- local path = system.pathForFile(UI.props.imgDir..self.imagePath, system.ResourceDirectory)
  -- NOTE: layerProps.x/y are PAGE/DESIGN coords (scale-invariant).
  -- app.getPosition() is called inside shape.createCircle to convert to
  -- sceneGroup-local coords. Do NOT call it here.
  local width = tonumber(layerProps.width) or 0
  local height = tonumber(layerProps.height) or 0
  local fallbackRadius = math.min(width, height) * 0.5
  layerProps.radius = tonumber(layerProps.radius) or fallbackRadius
  --
  local obj = shape.createCircle(layerProps)
  --
  obj.layerIndex = #UI.layers+1
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
  return self:newInstance(props, layerProps)
end
--
return M
