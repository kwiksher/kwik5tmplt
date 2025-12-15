-- Ghost Display Class
-- Handles visual representation of ghost character

local M = {}

-- Create a ghost display object
function M.create(x, y, params)
  params = params or {}
  local radius = params.radius or 15
  local scared = params.scared or false

  local group = display.newGroup()

  -- Ghost body (rounded top, wavy bottom)
  local bodyVertices = {}

  -- Top arc (semicircle)
  for i = 0, 10 do
    local angle = math.rad(180 + (i / 10) * 180)
    bodyVertices[#bodyVertices + 1] = radius * math.cos(angle)
    bodyVertices[#bodyVertices + 1] = radius * math.sin(angle) - radius * 0.3
  end

  -- Bottom wavy edge
  local wavePoints = 6
  for i = wavePoints, 0, -1 do
    local t = i / wavePoints
    local waveX = -radius + (2 * radius * t)
    local waveY = radius * 0.7 + math.sin(t * math.pi * 3) * (radius * 0.2)
    bodyVertices[#bodyVertices + 1] = waveX
    bodyVertices[#bodyVertices + 1] = waveY
  end

  local body = display.newPolygon(group, 0, 0, bodyVertices)

  if scared then
    body:setFillColor(0.2, 0.2, 0.8) -- Blue when scared
  else
    body:setFillColor(1, 0.1, 0.2) -- Red normally
  end

  -- Eyes
  local leftEye = display.newCircle(group, -5, -3, 3)
  leftEye:setFillColor(1, 1, 1)

  local rightEye = display.newCircle(group, 5, -3, 3)
  rightEye:setFillColor(1, 1, 1)

  -- Pupils
  local leftPupil = display.newCircle(group, -5, -3, 1.5)
  leftPupil:setFillColor(0, 0, 0)

  local rightPupil = display.newCircle(group, 5, -3, 1.5)
  rightPupil:setFillColor(0, 0, 0)

  group.x, group.y = x, y

  -- Store reference to body for color changes
  group.body = body
  group.leftPupil = leftPupil
  group.rightPupil = rightPupil

  -- Function to change scared state
  group.setScared = function(isScared)
    if isScared then
      body:setFillColor(0.2, 0.2, 0.8)
    else
      body:setFillColor(1, 0.1, 0.2)
    end
  end

  return group
end

return M
