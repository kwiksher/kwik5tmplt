-- Eat Pills Action
-- Makes Pacman collect standard pills

local bt = require("btree")
local M = {}
local state = {}

function M.create(pacman, ghost, world, statusText)
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

return M
