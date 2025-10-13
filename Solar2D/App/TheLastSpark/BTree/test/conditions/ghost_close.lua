-- conditions/ghost_close.lua
-- Condition: Is the ghost close to Pacman?

local bt = require("btree")

local M = {}

function M.create(pacman, ghost, world)
    local distance = world.collisionController.distance(
      pacman.x, pacman.y,
      ghost.x, ghost.y
    )

    -- Ghost is considered close if within 120 pixels
    local isClose = distance < 120

    return isClose and bt.SUCCESS or bt.FAILED
end

return M
