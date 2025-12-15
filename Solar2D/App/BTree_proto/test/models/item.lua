-- Item Model
-- Manages the creation and properties of collectible items (pills, power pills, fruits)

local M = {}

-- Create a standard pill (small, common collectible)
function M.createPill(x, y)
  return {
    x = x,
    y = y,
    radius = 5,
    value = 20,
    r = 1,      -- Bright yellow
    g = 0.95,
    b = 0.75,
    kind = "pill",
    active = true
  }
end

-- Create a power pill (glowing, makes ghost vulnerable)
function M.createPowerPill(x, y)
  return {
    x = x,
    y = y,
    radius = 9,
    value = 50,
    r = 0.3,    -- Bright cyan/blue
    g = 0.8,
    b = 1,
    kind = "power",
    active = true
  }
end

-- Create a fruit (bonus item, star-shaped)
function M.createFruit(x, y)
  return {
    x = x,
    y = y,
    radius = 10,
    value = 100,
    r = 1,      -- Orange/red
    g = 0.5,
    b = 0.1,
    kind = "fruit",
    active = true
  }
end

-- Generic item creator (if you need custom items)
function M.createItem(params)
  return {
    x = params.x or 0,
    y = params.y or 0,
    radius = params.radius or 5,
    value = params.value or 10,
    r = params.r or 1,
    g = params.g or 1,
    b = params.b or 1,
    kind = params.kind or "generic",
    active = params.active ~= nil and params.active or true
  }
end

return M
