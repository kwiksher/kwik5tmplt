-- Eat Fruit Action
-- Makes Pacman collect bonus fruit items

local bt = require("btree")
local M = {}
local state = {}

function M.create(pacman, ghost, world, statusText)
    if not state.target or not state.target.active then
      state.target = world.itemController.findNearest(pacman, world.fruits)
    end
    local target = state.target
    if not target then
      pacman.controller.releaseControl(pacman, "Eat Fruit")
      return bt.FAILED
    end
    pacman.controller.moveToItem(pacman, "Eat Fruit", target)
    if not target.active then
      state.target = nil
      statusText.text = "Fruit feast!"
      pacman.controller.releaseControl(pacman, "Eat Fruit")
      return bt.SUCCESS
    end
    return bt.RUNNING
end

return M
