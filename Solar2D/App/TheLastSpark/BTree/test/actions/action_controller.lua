local M = {}

-- Action model table: maps action names to their module paths
local actionModel = {
  ["Eat Power Pill"] = "actions.eat_power_pill",
  ["Chase Ghost"] = "actions.chase_ghost",
  ["Avoid Ghost"] = "actions.avoid_ghost",
  ["Eat Pills"] = "actions.eat_pills",
  ["Eat Fruit"] = "actions.eat_fruit"
}

function M.createActions(bt, pacman, ghost, world, statusText)
  local actions = {}

  -- Dynamically load and create actions from model
  for actionName, modulePath in pairs(actionModel) do
    local actionModule = require(modulePath)
    actions[actionName] = actionModule.create(bt, pacman, ghost, world, statusText)
  end

  return actions
end

return M
