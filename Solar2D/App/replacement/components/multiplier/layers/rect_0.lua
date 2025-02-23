-- $weight=
--
local parent,root, M = newModule(...)
local util = require("lib.util")
local app = require "controller.Application"
local shape = require("components.kwik.layer_shape")
--
local layerProps = {
  name     = "rect_0",
  x        = 424,
  y        = 272.5,
  width    =  62,
  height    =  59,
  xScale = 1,
  yScale = 1,
  anchorX = 0.5,
  anchorY = 0.5,
  rotation = 0,
  color    = { 0.8, 0.8, 0.8, 1 },
  shapedWith = "new_rectangle",
  imageFile = "",
  imageFolder = ""
}
M.layerProps = layerProps
--
function M:init(UI)
--local sceneGroup = UI.sceneGroup
end
--
function M:create(UI)
  local layerProps = self.layerProps or layerProps
  self.layerProps = layerProps
  local obj = shape.createRectangle(layerProps)
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
