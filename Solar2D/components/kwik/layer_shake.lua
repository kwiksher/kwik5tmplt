local M = {}
--
M.shakeHandler = function(event)
  local UI = self.UI
  local target = event.target
  local props = event.target.shake

    if(e.isShake == true) then
          UI.scene:dispatchEvent({name=props.actions.onComplete, event=event })
    end
    return true
end
---
function M:setShake(UI)
  local sceneGroup = UI.sceneGroup
  local layerName  = self.properties.target
  self.obj        = sceneGroup[layerName]
  if self.isPage then
    self.obj = sceneGroup
  end
  self.obj.shake = self
end

function M:activate(UI)
  self.obj:addEventListener("accelerometer", self.shakeHandler)

end
--
function M:deactivate(UI)
  self.obj:removeEventListener( "accelerometer",self.shakeHandler)
end
--
M.set = function(model)
  return setmetatable( model, {__index=M})
end
--
return M