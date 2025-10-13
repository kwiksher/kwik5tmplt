local pillDisplay = require("views.pill_display")
local powerPillDisplay = require("views.power_pill_display")
local fruitDisplay = require("views.fruit_display")
local pacmanDisplay = require("views.pacman_display")
local ghostDisplay = require("views.ghost_display")

local M = {}

function M.createBackground()
  local background = display.newRect(display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
  background:setFillColor(0.08, 0.08, 0.12)
  return background
end

function M.createPacmanDisplay(pacman)
  local displayObj = pacmanDisplay.create(pacman.x, pacman.y, {radius = pacman.radius})
  pacman.display = displayObj
  return displayObj
end

function M.createGhostDisplay(ghost)
  local displayObj = ghostDisplay.create(ghost.x, ghost.y, {radius = ghost.radius, scared = ghost.scared})
  ghost.display = displayObj
  return displayObj
end

function M.createHUD()
  display.newRoundedRect(display.contentCenterX, display.screenOriginY + display.safeScreenOriginY + 12, display.actualContentWidth - 40, 28, 12):setFillColor(0, 0, 0, 0.35)

  local hudText = display.newText({
    text = "",
    x = display.contentCenterX,
    y = display.screenOriginY + 20,
    font = native.systemFontBold,
    fontSize = 16
  })

  local statusText = display.newText({
    text = "",
    x = display.contentCenterX,
    y = display.contentHeight - 20,
    font = native.systemFont,
    fontSize = 15
  })

  return hudText, statusText
end

-- Create display object based on item kind using display classes
local function createItemDisplay(params)
  local kind = params.kind or "generic"
  local x, y = params.x, params.y
  local displayObj

  if kind == "pill" then
    displayObj = pillDisplay.create(x, y, params)

  elseif kind == "power" then
    displayObj = powerPillDisplay.create(x, y, params)

  elseif kind == "fruit" then
    displayObj = fruitDisplay.create(x, y, params)

  else
    -- Generic fallback
    displayObj = display.newCircle(x, y, params.radius or 6)
    displayObj:setFillColor(params.r or 1, params.g or 1, params.b or 1)
  end

  return displayObj
end

function M.spawnItem(list, params)
  local radius = params.radius or 6
  local displayObj = createItemDisplay(params)

  local item = {
    x = params.x,
    y = params.y,
    radius = radius + (params.pickupPadding or 4),
    active = true,
    value = params.value or 10,
    display = displayObj,
    kind = params.kind
  }
  list[#list + 1] = item
  return item
end

return M
