local M = {}
--
local app = require "controller.Application"
local MultiTouch = require("extlib.dmc_multitouch")
--

M.pinchHandler = function(self, event)
  local UI = self.UI
  local target = event.target
    if event.phase == "moved" then
      {{#gtclock}}
    UI.scene:dispatchEvent({name="{{gtclock}}", pinch=event })
      {{/gtclock}}
  elseif event.phase == "ended" then
      {{#gtcounter}}
    UI.scene:dispatchEvent({name="{{gtcounter}}", pinch=event })
      {{/gtcounter}}
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
  if move then
    MultiTouch.activate( obj,  "move", {"single"})
  end
  _K.MultiTouch.activate( layer.{{glayer}}, "scale", "multi", {minScale = {{gmin}}, maxScale = {{gmax}} })

  self.listener = function(event)
    -- self has the all the props of layer_drag, obj does not have them
    --   see setmetatable is used for the model not to object
    self:pinchHandler(event)
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