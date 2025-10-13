-- Collision Controller
-- Handles collision detection and response between entities

local M = {}

local function distanceSquared(ax, ay, bx, by)
  local dx = ax - bx
  local dy = ay - by
  return dx * dx + dy * dy
end

-- Calculate distance between two points
function M.distance(ax, ay, bx, by)
  return math.sqrt(distanceSquared(ax, ay, bx, by))
end

-- Check if two entities are colliding
function M.isColliding(entityA, entityB)
  local collisionDist = (entityA.radius + entityB.radius) ^ 2
  return distanceSquared(entityA.x, entityA.y, entityB.x, entityB.y) <= collisionDist
end

-- Handle collision between Pacman and Ghost
function M.handlePacmanGhostCollision(pacman, ghost, world, updateHudCallback, statusText)
  -- Check collision with slightly tighter bounds
  local collisionDist = (pacman.radius + ghost.radius - 4) ^ 2
  if distanceSquared(pacman.x, pacman.y, ghost.x, ghost.y) > collisionDist then
    return
  end

  -- Ghost is scared - Pacman wins
  if ghost.scared then
    world.score = world.score + 200
    statusText.text = "Ghost captured!"
    ghost.controller.reset(ghost)
    updateHudCallback()

  -- Ghost hits Pacman
  elseif pacman.hitCooldown == 0 then
    world.lives = math.max(0, world.lives - 1)
    pacman.hitCooldown = 1.5
    world.score = math.max(0, world.score - 100)

    pacman.controller.reset(pacman, world)
    statusText.text = "Ouch! Ghost got you."
    updateHudCallback()

    if world.lives == 0 then
      statusText.text = "Game over."
    end
  end
end

return M
