local M = {}
--
local app = require "controller.Application"
local MultiTouch = require("extlib.dmc_multitouch")
--

M.shakeHandler = function(self, event)
  local UI = self.UI
  local target = event.target

    if(e.isShake == true) then
          UI.scene:dispatchEvent({name="action_{{gcomplete}}", shake=e })
    end
    return true
end
---
function M:activate(obj)
  if obj == nil then return end
  --- as same as drag except activate with rotate
  local options = {}

  Runtime:addEventListener("accelerometer", self.listener)

end
--
function M:deactivate(obj)
  Runtime:removeEventListener( "accelerometer",self.listener)
end
--
M.set = function(model)
  return setmetatable( model, {__index=M})
end
--
return M