-- conditions/power_pill_close.lua
-- Condition: Is a power pill close to Pacman?

local bt = require("btree")

local M = {}

function M.create(pacman, ghost, world)
    -- Find nearest power pill
    local nearestPower = world.itemController.findNearest(
      pacman,
      world.powerPills
    )

    if not nearestPower then
      return bt.FAILED  -- No power pills available
    end

    -- Check if it's close (within 150 pixels)
    local distance = world.collisionController.distance(
      pacman.x, pacman.y,
      nearestPower.x, nearestPower.y
    )

    local isClose = distance < 150

    return isClose and bt.SUCCESS or bt.FAILED
end

return M
