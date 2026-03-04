-- $weight=
--
local parent,root, M = newModule(...)
local app = require "controller.Application"
--
local _layerProps = {
  name     = "text_0",
  x        = 480.5,
  y        = 299.5,
  width    =  88,
  height    =  52,
  xScale = 1,
  yScale = 1,
  anchorX = 0.5,
  anchorY = 0.5,
  rotation = 0,
  color    = { 0, 0, 0, 1 },
  text     = "Test",
  -- width    = nil, -- 88,
  font     = native.systemFont,
  fontSize = 10, -- 10
  align    = "center",  -- Alignment parameter
  shapedWith    = "new_text"
}
--
function M:init(UI)
--local sceneGroup = UI.sceneGroup
end
--
function M:create(UI)
  local layerProps = self.layerProps or _layerProps
  self.layerProps = layerProps
  layerProps.x, layerProps.y = app.getPosition(layerProps.x, layerProps.y)
  local  obj = display.newText(layerProps)
  obj.name = layerProps.name
  if layerProps.color then
    obj:setFillColor(unpack(layerProps.color))
  end
  obj.anchorX = layerProps.anchorX or 0.5
  obj.anchorY = layerProps.anchorY or 0.5
  obj.rotation = layerProps.rotation or 0
  obj.shapedWith = layerProps.shapedWith
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
