-- Ghost Controller
-- Handles Ghost-specific movement, AI behavior, and state management

local M = {}

local function bounceDirection(component)
  if component > 0 then
    return -1
  else
    return 1
  end
end

-- Update Ghost's position and AI behavior
function M.update(ghost, world, dt)
  -- Update direction change timer
  ghost.changeTimer = ghost.changeTimer - dt
  if ghost.changeTimer <= 0 then
    ghost.changeTimer = 1.4 + math.random() * 1.2
    -- Random direction
    local angle = math.random() * math.pi * 2
    ghost.direction.x = math.cos(angle)
    ghost.direction.y = math.sin(angle)
  end

  -- Calculate speed (slower when scared)
  local speed = ghost.speed
  if ghost.scared then
    ghost.scaredTimer = ghost.scaredTimer - dt
    speed = speed * 0.5

    -- Check if scared timer expired
    if ghost.scaredTimer <= 0 then
      ghost.scared = false
      ghost.scaredTimer = 0
      -- Update visual if setScared method exists
      if ghost.display.setScared then
        ghost.display.setScared(false)
      else
        ghost.display:setFillColor(1, 0.1, 0.2)
      end
    end
  end

  -- Move ghost
  ghost.x = ghost.x + ghost.direction.x * speed * dt
  ghost.y = ghost.y + ghost.direction.y * speed * dt

  -- Bounce off boundaries
  if ghost.x - ghost.radius < world.bounds.left then
    ghost.x = world.bounds.left + ghost.radius
    ghost.direction.x = bounceDirection(ghost.direction.x)
  elseif ghost.x + ghost.radius > world.bounds.right then
    ghost.x = world.bounds.right - ghost.radius
    ghost.direction.x = bounceDirection(ghost.direction.x)
  end

  if ghost.y - ghost.radius < world.bounds.top then
    ghost.y = world.bounds.top + ghost.radius
    ghost.direction.y = bounceDirection(ghost.direction.y)
  elseif ghost.y + ghost.radius > world.bounds.bottom then
    ghost.y = world.bounds.bottom - ghost.radius
    ghost.direction.y = bounceDirection(ghost.direction.y)
  end

  -- Update display position
  ghost.display.x, ghost.display.y = ghost.x, ghost.y
end

-- Reset ghost to starting position
function M.reset(ghost)
  ghost.x = ghost.baseX
  ghost.y = ghost.baseY
  ghost.direction.x = math.random(0, 1) == 0 and -1 or 1
  ghost.direction.y = math.random(-1, 1) * 0.5
  ghost.scared = false
  ghost.scaredTimer = 0

  -- Update visual
  if ghost.display.setScared then
    ghost.display.setScared(false)
  else
    ghost.display:setFillColor(1, 0.1, 0.2)
  end

  ghost.display.x, ghost.display.y = ghost.x, ghost.y
end

-- Make ghost scared (vulnerable)
function M.scare(ghost, world)
  ghost.scared = true
  ghost.scaredTimer = world.powerDuration

  -- Update visual
  if ghost.display.setScared then
    ghost.display.setScared(true)
  else
    ghost.display:setFillColor(0.3, 0.5, 1)
  end
end

-- Check if ghost is scared
function M.isScared(ghost)
  return ghost.scared and ghost.scaredTimer > 0
end

return M
