local M = {
  name = "",
  properties = {
    event = "touch",
    isInitail = false,
    isImpluse = true,
    type = "pull", -- push, none
    xForce = 0,
    yForce = 0
  }
}

--
function M:didShow(UI)
  local sceneGroup = UI.scene.view
  local layer = UI.layer
  local props = self.properties
  local obj = sceneGroup[self.name]
  if obj == nil then
    return
  end
  if props.type == "" or props.type == "none" then
    if props.isImpluse then
      obj:applyLinearImpulse(props.xforce, props.yforce, obj.x, obj.y)
    else
      obj:applyForce(props.xforce, props.yforce, obj.x, obj.y)
    end
  else
    function self.listener(event)
      if event.phase == "began" then
        display.getCurrentStage():setFocus(obj)
      elseif event.phase == "ended" then
        if props.isInitail then
          if props.type == "pull" then
            if props.isImpluse then
              obj:applyLinearImpulse(event.xStart - event.x, event.yStart - event.y, obj.x, obj.y)
            else
              obj:applyForce(event.xStart - event.x, event.yStart - event.y, obj.x, obj.y)
            end
          else -- push
            if props.isImpluse then
              obj:applyLinearImpulse(event.x - event.xStart, event.y - event.yStart, obj.x, obj.y)
            else
              obj:applyForce(event.x - event.xStart, event.y - event.yStart, obj.x, obj.y)
            end
          end
        else
          local x, y = event.x, event.y
          local xForce, yForce
          if props.type == "pull" then
            xForce = (obj.x - x) * props.xforce
            yForce = (obj.y - y) * props.yforce
          else -- push
            xForce = (-1 * (obj.x - x)) * props.xforce
            yForce = (-1 * (obj.y - y)) * props.yforce
          end
          if props.isImpluse then
            obj:applyLinearImpulse(xforce, yforce, obj.x, obj.y)
          else
            obj:applyForce(xforce, yforce, obj.x, obj.y)
          end
        end
        display.getCurrentStage():setFocus(nil)
      end
      return true
    end
    obj:addEventListener(props.event, self.listener)
  end
end

function M:didHide(UI)
  local props = self.properties
  if props.type ~= "" or props.type == "none" then
    obj:removeEventListener(props.event, self.listener)
  end
end
--
M.set = function(model)
  return setmetatable(model, {__index = M})
end
