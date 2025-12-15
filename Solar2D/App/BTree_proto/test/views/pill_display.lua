-- Pill Display Class
-- Handles visual representation of standard pills

local M = {}

-- Create a pill display object
function M.create(x, y, params)
  params = params or {}
  local radius = params.radius or 5
  local r = params.r or 1
  local g = params.g or 0.95
  local b = params.b or 0.75

  -- Simple circle with subtle stroke
  local circle = display.newCircle(x, y, radius)
  circle:setFillColor(r, g, b)
  circle.strokeWidth = 1
  circle:setStrokeColor(1, 1, 0.9, 0.8)

  return circle
end

return M
