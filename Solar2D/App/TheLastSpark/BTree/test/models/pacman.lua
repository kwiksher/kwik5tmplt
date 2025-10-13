local pacmanController = require("controllers.pacman_controller")

local M = {}

function M.create()
  local pacman = {
    x = display.contentCenterX - 80,
    y = display.contentCenterY,
    radius = 14,
    speed = 120,
    intent = nil,
    completedAction = nil,
    hitCooldown = 0
  }

  -- Attach controller
  pacman.controller = pacmanController

  return pacman
end

return M
