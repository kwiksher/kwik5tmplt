-- Power Pill Display Class
-- Handles visual representation of power pills with pulsing animation

local M = {}

-- Create a power pill display object
function M.create(x, y, params)
  params = params or {}
  local radius = params.radius or 9
  local r = params.r or 0.3
  local g = params.g or 0.8
  local b = params.b or 1

  local group = display.newGroup()

  -- Outer glow layer
  local glow = display.newCircle(group, 0, 0, radius + 3)
  glow:setFillColor(r, g, b, 0.3)

  -- Main pill body
  local pill = display.newCircle(group, 0, 0, radius)
  pill:setFillColor(r, g, b)

  -- Inner highlight for depth
  local highlight = display.newCircle(group, -2, -2, radius * 0.4)
  highlight:setFillColor(1, 1, 1, 0.6)

  group.x, group.y = x, y

  -- Pulsing animation
  transition.to(glow, {
    time = 800,
    xScale = 1.3,
    yScale = 1.3,
    alpha = 0.1,
    iterations = 0,
    transition = easing.continuousLoop
  })

  return group
end

return M
