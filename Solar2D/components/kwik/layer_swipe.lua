local M = {}
local Gesture = require("extlib.dmc_gesture")
--
M.swipeHandler = function(event)
  local target = event.target
  local props = target.swipe
  local UI = props.UI
  if event.phase == "ended" and event.direction ~= nil then
    if event.direction == "up" then
      if props.actions.onUp then
        UI.scene:dispatchEvent({name = props.actions.onUp, event = event})
      end
    elseif event.direction == "down" then
      if props.actions.onDown then
        UI.scene:dispatchEvent({name = props.actions.onDown, event = event})
      end
    elseif event.direction == "left" then
      if props.actions.onLeft then
        UI.scene:dispatchEvent({name = props.actions.onLeft, event = event})
      end
    elseif event.direction == "right" then
      if props.actions.onRight then
        UI.scene:dispatchEvent({name = props.actions.onRight, event = event})
      end
    end
  end
  return true
end

function M:setSwipe(UI)
  local sceneGroup = UI.sceneGroup
  local layerName = self.layerProps.name
  self.obj = sceneGroup[layerName]
  if self.isPage then
    self.obj = sceneGroup
  end
  self.obj.swipe = self
end

function M:activate(UI)
  local obj = self.obj
  Gesture.activate(obj, self.properties.dbounds)
  obj:addEventListener(Gesture.SWIPE_EVENT, self.swipeHandler)
end
--
function M:deactivate(UI)
  local obj = self.obj
  obj:removeEventListener(Gesture.SWIPE_EVENT, self.swipeHandler)
end
--
return M
