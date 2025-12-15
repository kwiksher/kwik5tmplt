-- Eat Power Pill Action
-- Navigates Pacman to the nearest power pill

local bt = require("btree")
local M = {}

function M.create(pacman, ghost, world, statusText)
    local target = world.itemController.findNearest(pacman, world.powerPills)
    if not target then
      pacman.controller.releaseControl(pacman, "Eat Power Pill")
      return bt.FAILED
    end
    pacman.controller.moveToItem(pacman, "Eat Power Pill", target)
    if not target.active then
      pacman.controller.releaseControl(pacman, "Eat Power Pill")
      return bt.SUCCESS
    end
    return bt.RUNNING
end

return M
