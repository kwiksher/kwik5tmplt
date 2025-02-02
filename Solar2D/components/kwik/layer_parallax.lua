
local M = {}
---------------------
M.accelerometerHandler = function(event)
    local obj = event.target
    local props = obj.parallax
    -- printKeys(props)
    local UI = props.UI
    if props.properties.dampX then
        obj.x = props.X + (props.X * event.yGravity * props.properties.dpx/4);
    end
    if props.properties.dampY then
        obj.y = props.Y + (props.Y * event.yGravity * props.properties.dpy/4);
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
  obj.parallax.UI = UI
  obj.parallax.X = obj.x
  obj.parallax.Y = obj.y
  self.obj = obj
end

--
function M:activate(UI)
  if self.properties.isActive then
    self.obj:addEventListener("accelerometer", self.accelerometerHandler)
  end
  ---
end

function M:deactivate(UI)
  if self.properties.isActive then
    self.obj:removeEventListener("accelerometer", self.accelerometerHandler)
  end
end

M.set = function(model)
  return setmetatable(model, {__index = M})
end
--

local function createDummyAccelerometerDispatcher(interval, _initialDirection)
  local dispatcher = {}
  local directions = {"left", "right", "up", "down"}
  local currentDirection = _initialDirection or directions[math.random(1, #directions)]
  local targetXGravity = 0
  local targetYGravity = 0
  local currentXGravity = 0
  local currentYGravity = 0
  local smoothFactor = 0.1 -- Adjust this value for smoothness (lower = smoother, higher = faster changes)


  local timer = timer.performWithDelay(interval, function()
    local event = {
      name = "accelerometer",
      xGravity =  math.random(0, 1) * smoothFactor,
      yGravity =  math.random(0, 1) * smoothFactor,
      zGravity = 0, -- zGravity can often be ignored for 2D games
      target = nil
    }

    -- Determine target gravity based on currentDirection
    if _initialDirection then -- If an initial direction is provided, stick to it
        currentDirection = _initialDirection
    else
        local newDirection = directions[math.random(1, #directions)]
        if newDirection ~= currentDirection then
            currentDirection = newDirection
        end
    end

    if currentDirection == "left" then
      event.xGravity = -1*event.xGravity
    elseif currentDirection == "right" then
    elseif currentDirection == "up" then
    elseif currentDirection == "down" then
      event.yGravity = -1*event.yGravity
    end

    if dispatcher.targets then
      for i, v in next, dispatcher.targets do
        -- printKeys(v)
        event.target = v
        M.accelerometerHandler(event)
        -- accelerometerUpdate(event) -- Assuming this function is defined elsewhere
      end
    end
  end, 0)

  dispatcher.timer = timer
  return dispatcher
end

-- Create a dummy accelerometer dispatcher with a specific direction
M.dummyDispatcher = function(targets, interval, direction)
  local dispatcher = createDummyAccelerometerDispatcher(interval, direction)  -- Dispatch every 1000ms (1 second) with "left" direction
  dispatcher.targets = targets
  return dispatcher
end

return M
