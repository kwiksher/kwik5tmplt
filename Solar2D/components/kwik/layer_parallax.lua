
local M = {}
---------------------
M.accelerometerHandler = function(event)
    local obj = event.target
    local props = obj.parallax
    local UI = props.UI
    if props.properties.dampX then
        obj.x = props.X + (props.X * event.yGravity * props.properties.dpx);
    end
    if props..properties.dampY then
        obj.y = props.Y + (props.Y * event.yGravity * props.properties.dpy);
    end
    if event.zGravity > 0 then
       if props.actions.onBack then
          UI.scene:dispatchEvent({name=props.actions.onBack, event=event })
       end
    else
      if props.actions.onForward then
          UI.scene:dispatchEvent({name=props.actions.onForward, event=event })
      end
    end
end

function M:setParallax(UI)
  local sceneGroup = UI.sceneGroup
  local layerName  = self.properties.target
  local obj        = sceneGroup[layerName]
  if self.properties.target == "page" then
    obj = sceneGroup
  end
  obj.parallax = self
  obj.parallax.X = obj.x
  obj.parallax.Y = obj.y
  self.obj = obj
end

--
function M:activate(UI)
  self.obj:addEventListener("accelerometer", self.accelerometerHandler)
  ---
end

function M:deactivate(UI)
  self.obj:removedEventListener("accelerometer", self.accelerometerHandler)
end

M.set = function(model)
  return setmetatable(model, {__index = M})
end
--
return M
