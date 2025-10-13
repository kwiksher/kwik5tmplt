-- Eat Power Pill Action
-- Navigates Pacman to the nearest power pill

local M = {}

function M.create(bt, pacman, ghost, world, statusText)
  return function()
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
end

return M
