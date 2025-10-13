-- Pacman Controller
-- Handles Pacman-specific movement, control, and state management

local M = {}

local function clamp(value, minValue, maxValue)
  if value < minValue then
    return minValue
  elseif value > maxValue then
    return maxValue
  end
  return value
end

-- Release movement control from a specific action
function M.releaseControl(pacman, actionName)
  if pacman.intent and pacman.intent.action == actionName then
    pacman.intent = nil
  end
end

-- Request Pacman to move to an item
function M.moveToItem(pacman, actionName, item)
  if not item or item.active == false then
    return
  end
  if pacman.intent and pacman.intent.action == actionName and pacman.intent.target == item then
    return
  end
  pacman.intent = {
    action = actionName,
    target = item,
    speed = pacman.speed
  }
end

-- Request Pacman to move to a specific point
function M.moveToPoint(pacman, actionName, point)
  if pacman.intent and pacman.intent.action == actionName and not pacman.intent.target then
    pacman.intent.x = point.x
    pacman.intent.y = point.y
    return
  end
  pacman.intent = {
    action = actionName,
    x = point.x,
    y = point.y,
    speed = pacman.speed
  }
end

-- Check if movement was completed by a specific action
function M.wasMovementCompleted(pacman, actionName)
  if pacman.completedAction == actionName then
    pacman.completedAction = nil
    return true
  end
  return false
end

-- Update Pacman's position and state
function M.update(pacman, world, dt)
  -- Update hit cooldown
  if pacman.hitCooldown > 0 then
    pacman.hitCooldown = pacman.hitCooldown - dt
    if pacman.hitCooldown < 0 then
      pacman.hitCooldown = 0
    end
  end

  -- No movement if no intent
  if not pacman.intent then
    return
  end

  -- Determine target position
  local targetX, targetY
  if pacman.intent.target then
    targetX, targetY = pacman.intent.target.x, pacman.intent.target.y
  else
    targetX, targetY = pacman.intent.x, pacman.intent.y
  end

  if not targetX or not targetY then
    pacman.intent = nil
    return
  end

  -- Calculate movement
  local dx = targetX - pacman.x
  local dy = targetY - pacman.y
  local dist = math.sqrt(dx * dx + dy * dy)
  local step = (pacman.intent.speed or pacman.speed) * dt

  -- Check if reached target
  if dist <= step then
    pacman.x = targetX
    pacman.y = targetY
    pacman.display.x, pacman.display.y = pacman.x, pacman.y
    pacman.completedAction = pacman.intent.action
    pacman.intent = nil
    return
  end

  -- Move towards target
  local nx, ny = dx / dist, dy / dist
  pacman.x = pacman.x + nx * step
  pacman.y = pacman.y + ny * step

  -- Keep within bounds
  pacman.x = clamp(pacman.x, world.bounds.left, world.bounds.right)
  pacman.y = clamp(pacman.y, world.bounds.top, world.bounds.bottom)

  -- Update display
  pacman.display.x, pacman.display.y = pacman.x, pacman.y
end

-- Reset Pacman to starting position after hit
function M.reset(pacman, world)
  pacman.x = display.contentCenterX - 80
  pacman.y = display.contentCenterY
  pacman.display.x, pacman.display.y = pacman.x, pacman.y
  pacman.intent = nil
  pacman.completedAction = nil
end

return M
