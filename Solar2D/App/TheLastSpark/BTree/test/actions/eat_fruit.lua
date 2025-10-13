-- Eat Fruit Action
-- Makes Pacman collect bonus fruit items

local M = {}

function M.create(bt, pacman, ghost, world, statusText)
  local state = {}

  return function()
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
end

return M
