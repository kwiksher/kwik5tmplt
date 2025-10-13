-- Eat Pills Action
-- Makes Pacman collect standard pills

local M = {}

function M.create(bt, pacman, ghost, world, statusText)
  local state = {}

  return function()
    if not state.target or not state.target.active then
      state.target = world.itemController.findNearest(pacman, world.pills)
    end
    local target = state.target
    if not target then
      pacman.controller.releaseControl(pacman, "Eat Pills")
      return bt.FAILED
    end
    pacman.controller.moveToItem(pacman, "Eat Pills", target)
    if not target.active then
      state.target = nil
      pacman.controller.releaseControl(pacman, "Eat Pills")
      return bt.SUCCESS
    end
    return bt.RUNNING
  end
end

return M
