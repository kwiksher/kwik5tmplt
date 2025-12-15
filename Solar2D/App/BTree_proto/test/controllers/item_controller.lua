-- Item Controller
-- Handles item collection, removal, and scoring

local M = {}

local function distanceSquared(ax, ay, bx, by)
  local dx = ax - bx
  local dy = ay - by
  return dx * dx + dy * dy
end

-- Find the nearest active item from a list
function M.findNearest(entity, itemList)
  local best, bestDist
  for i = 1, #itemList do
    local item = itemList[i]
    if item.active then
      local d = distanceSquared(entity.x, entity.y, item.x, item.y)
      if not bestDist or d < bestDist then
        bestDist = d
        best = item
      end
    end
  end
  return best
end

-- Remove an item and update score
function M.remove(world, item, updateHudCallback)
  if item and item.active then
    item.active = false
    if item.display then
      display.remove(item.display)
      item.display = nil
    end
    world.score = world.score + (item.value or 0)
    if updateHudCallback then
      updateHudCallback()
    end
  end
end

-- Handle item collection effects
function M.handleCollectionEffect(item, statusText, ghost, world)
  if not item or not item.kind then
    return
  end

  if item.kind == "power" then
    ghost.controller.scare(ghost, world)
    statusText.text = "Power pill! Ghost is scared."
  elseif item.kind == "fruit" then
    statusText.text = "Fruit collected!"
  else
    statusText.text = "Pill eaten."
  end
end

-- Check for item pickups and handle them
function M.checkPickups(pacman, world, itemList, updateHudCallback, statusText, ghost)
  for i = 1, #itemList do
    local item = itemList[i]
    if item.active then
      local collisionDist = (pacman.radius + item.radius) ^ 2
      if distanceSquared(pacman.x, pacman.y, item.x, item.y) <= collisionDist then
        M.remove(world, item, updateHudCallback)
        M.handleCollectionEffect(item, statusText, ghost, world)
      end
    end
  end
end

-- Count active items in a list
function M.countActive(itemList)
  local count = 0
  for i = 1, #itemList do
    if itemList[i].active then
      count = count + 1
    end
  end
  return count
end

return M
