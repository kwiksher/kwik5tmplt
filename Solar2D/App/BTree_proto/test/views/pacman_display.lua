-- Pacman Display Class
-- Handles visual representation of Pacman character

local M = {}

-- Create a Pacman display object
function M.create(x, y, params)
  params = params or {}
  local radius = params.radius or 15

  local group = display.newGroup()

  -- Main body (circle)
  local body = display.newCircle(group, 0, 0, radius)
  body:setFillColor(1, 0.9, 0)

  -- Mouth wedge (to make it look like Pac-Man)
  local mouthAngle = 45
  local mouthVertices = {0, 0}
  for i = 0, 10 do
    local angle = math.rad(-mouthAngle + (i / 10) * (mouthAngle * 2))
    mouthVertices[#mouthVertices + 1] = radius * math.cos(angle)
    mouthVertices[#mouthVertices + 1] = radius * math.sin(angle)
  end

  local mouth = display.newPolygon(group, 0, 0, mouthVertices)
  mouth:setFillColor(0.08, 0.08, 0.12) -- Background color

  -- Eye
  local eye = display.newCircle(group, 3, -5, 2)
  eye:setFillColor(0, 0, 0)

  group.x, group.y = x, y

  -- Store animation function for mouth chomping
  group.chomp = function()
    transition.to(mouth, {
      time = 150,
      xScale = 0.5,
      yScale = 0.5,
      onComplete = function()
        transition.to(mouth, {
          time = 150,
          xScale = 1,
          yScale = 1
        })
      end
    })
  end

  return group
end

return M
