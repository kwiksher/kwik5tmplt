-- controllers/condition_controller.lua
-- Controller for managing behavior tree conditions

local M = {}

-- Model table for condition modules
-- Maps condition names to their module paths
local conditionModel = {
  ["Ghost Close"] = "conditions.ghost_close",
  ["Ghost Scared"] = "conditions.ghost_scared",
  ["Power Pill Close"] = "conditions.power_pill_close"
}

-- Create condition handlers
-- Returns a table of condition name -> handler function
function M.createConditions(pacman, ghost, world, statusText)
  local conditions = {
    evaluators={},
    pacman = pacman,
    ghost = ghost,
    world = world,
    statusText = statusText}

  for name, modulePath in pairs(conditionModel) do
    local conditionModule = require(modulePath)
    -- Each condition module has a create() function
    -- Call it with world to get the handler
    conditions.evaluators[name] = conditionModule.create
  end
  -- Update all conditions and set their status in the behavior tree
  function conditions:updateConditions(tree)
    for name, evaluator in pairs(self.evaluators) do
      local result = evaluator(self.pacman, self.ghost, self.world)
      tree:setConditionStatus(name, result)
    end
  end
  return conditions
end

return M
