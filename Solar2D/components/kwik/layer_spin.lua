local M = {}
--
local app = require "controller.Application"
local MultiTouch = require("extlib.dmc_multitouch")
--

M.spinHandler = function(self, event)
  local UI = self.UI
  local target = event.target
  if event.direction == "clockwise" then
    if self.actions.onClokwise then
          UI.scene:dispatchEvent({name=self.actions.onClokwise, event={UI=UI, event=event}  })
    end
  elseif event.direction == "counter_clockwise" then
    if self.actions.onCounterClockwise then
          UI.scene:dispatchEvent({name=self.actions.onCounterClockwise , event={UI=UI, event=event}  })
    end
  elseif self.actions.onShapeHandler then
      self.actions.onShapeHandler(event)
  end
  return true
end
---
function M:activate(obj)
  if obj == nil then return end
  --- as same as drag except activate with rotate
  local options = {}
  if self.constrainAngle then
    options.constrainAngle=self.constrainAngle
  end
  if self.bounds.xStart then
    options.xBounds ={ self.bounds.xStart, self.bounds.xEnd }
  end
  if self.bounds.yStart then
    options.yBounds ={ self.bounds.yStart, sefl.bounds.yEnd }
  end
  --
  MultiTouch.activate( obj, "rotate", "single", options)
  self.listener = function(event)
    -- self has the all the props of layer_drag, obj does not have them
    --   see setmetatable is used for the model not to object
    self:spinHandler(event)
  end
  obj:addEventListener( MultiTouch.MULTITOUCH_EVENT,self.listener)
end
--
function M:deactivate(obj)
  obj:removeEventListener( MultiTouch.MULTITOUCH_EVENT,self.listener)
  MultiTouch.deactivate( obj, "rotate", "single", options)
end
--
M.set = function(model)
  return setmetatable( model, {__index=M})
end
--
return M