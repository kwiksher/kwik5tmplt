local itemController = require("controllers.item_controller")
local collisionController = require("controllers.collision_controller")

local M = {}

function M.create()
  local world = {
    score = 0,
    lives = 3,
    powerDuration = 6,
    bounds = {
      left = display.screenOriginX + 24,
      right = display.screenOriginX + display.actualContentWidth - 24,
      top = display.screenOriginY + 24,
      bottom = display.screenOriginY + display.actualContentHeight - 24
    },
    pills = {},
    powerPills = {},
    fruits = {}
  }

  -- Attach controllers
  world.itemController = itemController
  world.collisionController = collisionController

  return world
end

return M
