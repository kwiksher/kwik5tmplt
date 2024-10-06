local M = {}
--
local app = require "controller.Application"
local MultiTouch = require("extlib.dmc_multitouch")
--

M.spinHandler = function(event)
  local target = event.target
  local props = target.spin
  local UI = props.UI
  if event.direction == "clockwise" then
    if props.actions.onClokwise then
          UI.scene:dispatchEvent({name=props.actions.onClokwise, event={UI=UI, event=event}  })
    end
  elseif event.direction == "counter_clockwise" then
    if props.actions.onCounterClockwise then
          UI.scene:dispatchEvent({name=props.actions.onCounterClockwise , event={UI=UI, event=event}  })
    end
  elseif props.actions.onShapeHandler then
      props.actions.onShapeHandler(event)
  end
  return true
end

function M:setSpin(UI)
  local sceneGroup = UI.sceneGroup
  local layerName  = self.layerProps.name
  self.obj        = sceneGroup[layerName]
  if self.isPage then
    self.obj = sceneGroup
  end
  self.obj.spin = self
end
---
function M:activate(UI)
  local obj = self.obj
  if obj == nil then return end
  --- as same as drag except activate with rotate
  local options = {}
  local props = self.properties
  if props.constrainAngle then
    options.constrainAngle=props.constrainAngle
  end
  if props.xStart then
    options.xBounds ={ props.xStart, props.xEnd }
  end
  if props.yStart then
    options.yBounds ={ props.yStart, props.yEnd }
  end
  --
  MultiTouch.activate( obj, "rotate", "single", options)
  obj:addEventListener( MultiTouch.MULTITOUCH_EVENT,self.spinHandler)
end
--
function M:deactivate(UI)
  local obj = self.obj
  obj:removeEventListener( MultiTouch.MULTITOUCH_EVENT,self.spinHandler)
  MultiTouch.deactivate( obj, "rotate", "single", options)
end
--
M.set = function(model)
  return setmetatable( model, {__index=M})
end
--
return M