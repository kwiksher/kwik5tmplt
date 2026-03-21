-- $weight=
--
local parent,root, M = newModule(...)
local app = require "controller.Application"
local shape = require("components.kwik.layer_shape")
--
local _layerProps = {
  name     = "ellipse_0",
  x        = 800,
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
  local obj = shape.createCircle(layerProps)
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
  return self:newInstance(props, _layerProps)
end
--
return M
