local ghostController = require("controllers.ghost_controller")

local M = {}

function M.create()
  local ghost = {
    x = display.contentCenterX + 80,
    y = display.contentCenterY,
    radius = 16,
    baseX = display.contentCenterX + 80,
    baseY = display.contentCenterY,
    speed = 80,
    direction = {x = -1, y = 0},
    scared = false,
    scaredTimer = 0,
    changeTimer = 0
  }

  -- Attach controller
  ghost.controller = ghostController

  return ghost
end

return M
