-- Chase Ghost Action
-- Makes Pacman chase the scared ghost to capture it

local M = {}

function M.create(bt, pacman, ghost, world, statusText)
  return function()
    pacman.controller.moveToItem(pacman, "Chase Ghost", ghost)
    if ghost.scaredTimer <= 0 then
      pacman.controller.releaseControl(pacman, "Chase Ghost")
      return bt.FAILED
    end
    if pacman.controller.wasMovementCompleted(pacman, "Chase Ghost") then
      pacman.controller.releaseControl(pacman, "Chase Ghost")
      return bt.SUCCESS
    end
    return bt.RUNNING
  end
end

return M
