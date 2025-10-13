-- Avoid Ghost Action
-- Makes Pacman flee away from the dangerous ghost

local M = {}

local function clamp(value, minValue, maxValue)
  if value < minValue then
    return minValue
  elseif value > maxValue then
    return maxValue
  end
  return value
end

function M.create(bt, pacman, ghost, world, statusText)
  return function()
    local dx = pacman.x - ghost.x
    local dy = pacman.y - ghost.y
    local len = math.sqrt(dx * dx + dy * dy)
    if len < 0.001 then
      len = 1
      dx, dy = 1, 0
    end
    dx = dx / len
    dy = dy / len
    local target = {
      x = clamp(pacman.x + dx * 160, world.bounds.left, world.bounds.right),
      y = clamp(pacman.y + dy * 160, world.bounds.top, world.bounds.bottom)
    }
    pacman.controller.moveToPoint(pacman, "Avoid Ghost", target)
    if pacman.controller.wasMovementCompleted(pacman, "Avoid Ghost") then
      statusText.text = "Escaped the ghost."
      return bt.SUCCESS
    end
    return bt.RUNNING
  end
end

return M
