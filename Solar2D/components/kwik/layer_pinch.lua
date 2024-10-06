local M = {}
--
local MultiTouch = require("extlib.dmc_multitouch")
--

M.pinchHandler = function(event)
  local obj = event.target
  local props = obj.pinch
  local UI = props.UI
    if event.phase == "moved" then
      if props.actions.onMoved then
          UI.scene:dispatchEvent({name=props.actions.onMoved, event=event })
      end
  elseif event.phase == "ended" then
    if props.actions.onEnded then
        UI.scene:dispatchEvent({name=props.actions.onEnded, event=event })
    end
  end
  return true
end
---
function M:setPinch(UI)
  local sceneGroup = UI.sceneGroup
  local layerName  = self.properties.target
  self.obj        = sceneGroup[layerName]
  if self.isPage then
    self.obj = sceneGroup
  end
  self.obj.pinch = self
end

function M:activate(UI)
  local obj = self.obj
  if obj == nil then return end
  --- as same as drag except activate with rotate
  local options = {}
  if self.properties.constrainAngle then
    options.constrainAngle=self.properties.constrainAngle
  end
  if self.properties.xStart then
    options.xBounds ={ self.properties.xStart, self.properties.xEnd }
  end
  if self.properties.yStart then
    options.yBounds ={ self.properties.yStart, self.properties.yEnd }
  end
  --
  if self.properties.move then
    MultiTouch.activate( obj,  "move", {"single"})
  end
  MultiTouch.activate( obj, "scale", "multi", {minScale = props.properties.scaleMin, maxScale = props,properties.scaleMax })
  obj:addEventListener( MultiTouch.MULTITOUCH_EVENT,self.pinchHandler)
end
--
function M:deactivate(UI)
  local obj = self.obj
  obj:removeEventListener( MultiTouch.MULTITOUCH_EVENT,self.pinchHandler)
  if self.properties.move then
    MultiTouch.dactivate( obj,  "move", {"single"})
  end
  MultiTouch.deactivate( obj, "rotate", "single")
end
--
M.set = function(model)
  return setmetatable( model, {__index=M})
end
--
return M