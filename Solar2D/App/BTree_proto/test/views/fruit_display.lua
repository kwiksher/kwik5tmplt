-- Fruit Display Class
-- Handles visual representation of fruits with star shape and rotation

local M = {}

-- Create a fruit display object
function M.create(x, y, params)
  params = params or {}
  local radius = params.radius or 10
  local r = params.r or 1
  local g = params.g or 0.5
  local b = params.b or 0.1

  local group = display.newGroup()

  -- Create a star/diamond shape
  local vertices = {}
  local points = 8
  for i = 0, points - 1 do
    local angle = (i / points) * 360
    local vertexRadius = (i % 2 == 0) and radius or radius * 0.6
    local rad = math.rad(angle)
    vertices[#vertices + 1] = vertexRadius * math.cos(rad)
    vertices[#vertices + 1] = vertexRadius * math.sin(rad)
  end

  local star = display.newPolygon(group, 0, 0, vertices)
  star:setFillColor(r, g, b)
  star.strokeWidth = 2
  star:setStrokeColor(1, 0.6, 0)

  -- Add sparkle effect
  local sparkle = display.newCircle(group, -2, -2, 2)
  sparkle:setFillColor(1, 1, 0, 0.9)

  group.x, group.y = x, y

  -- Rotating animation
  transition.to(group, {
    time = 2000,
    rotation = 360,
    iterations = 0,
    transition = easing.linear
  })

  -- Sparkle animation
  transition.to(sparkle, {
    time = 600,
    alpha = 0.3,
    iterations = 0,
    transition = easing.continuousLoop
  })

  return group
end

return M
