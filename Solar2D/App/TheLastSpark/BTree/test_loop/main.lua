local bt = require("btree")

local function loadTree(path)
  local fullPath = system.pathForFile(path, system.ResourceDirectory)
  if not fullPath then
    return nil, ("Cannot resolve path '%s'"):format(path)
  end
  local file, err = io.open(fullPath, "r")
  if not file then
    return nil, err
  end
  local contents = file:read("*a")
  file:close()
  return contents
end

local treeText, loadErr = loadTree("packman.tree")
if not treeText then
  local message = display.newText({
    text = loadErr or "Unable to load packman.tree",
    x = display.contentCenterX,
    y = display.contentCenterY,
    font = native.systemFontBold,
    fontSize = 22
  })
  message:setFillColor(1, 0, 0)
  return
end

local tree = bt.BehaviorTree:fromText(treeText)

math.randomseed(os.time())

local background = display.newRect(display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
background:setFillColor(0.08, 0.08, 0.12)

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

local pacman = {
  x = display.contentCenterX - 80,
  y = display.contentCenterY,
  radius = 14,
  speed = 120,
  intent = nil,
  completedAction = nil,
  hitCooldown = 0
}

pacman.display = display.newCircle(pacman.x, pacman.y, pacman.radius)
pacman.display:setFillColor(1, 0.9, 0)

local ghost = {
  x = display.contentCenterX + 80,
  y = display.contentCenterY,
  radius = 16,
  baseX = display.contentCenterX + 80,
  baseY = display.contentCenterY,
  speed = 80,
  direction = {x = -1, y = 0},
  scared = false,
  scaredTimer = 0,
  changeTimer = 0
}

ghost.display = display.newCircle(ghost.x, ghost.y, ghost.radius)
ghost.display:setFillColor(1, 0.1, 0.2)

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

local function clamp(value, minValue, maxValue)
  if value < minValue then
    return minValue
  elseif value > maxValue then
    return maxValue
  end
  return value
end

local function distanceSquared(ax, ay, bx, by)
  local dx = ax - bx
  local dy = ay - by
  return dx * dx + dy * dy
end

local function distance(ax, ay, bx, by)
  return math.sqrt(distanceSquared(ax, ay, bx, by))
end

local function spawnItem(list, params)
  local radius = params.radius or 6
  local circle = display.newCircle(params.x, params.y, radius)
  circle:setFillColor(params.r or 1, params.g or 1, params.b or 1)
  local item = {
    x = params.x,
    y = params.y,
    radius = radius + (params.pickupPadding or 4),
    active = true,
    value = params.value or 10,
    display = circle,
    kind = params.kind
  }
  list[#list + 1] = item
  return item
end

local layout = {
  pills = {
    {x = pacman.x - 80, y = pacman.y - 60},
    {x = pacman.x - 20, y = pacman.y + 80},
    {x = pacman.x + 40, y = pacman.y - 90},
    {x = pacman.x + 120, y = pacman.y + 40},
    {x = display.contentCenterX, y = pacman.y + 120},
    {x = display.contentCenterX + 100, y = pacman.y - 10}
  },
  powerPills = {
    {x = world.bounds.left + 40, y = world.bounds.top + 40},
    {x = world.bounds.right - 40, y = world.bounds.bottom - 60}
  },
  fruits = {
    {x = display.contentCenterX + 30, y = display.contentCenterY + 120}
  }
}

for i = 1, #layout.pills do
  spawnItem(world.pills, {
    x = layout.pills[i].x,
    y = layout.pills[i].y,
    radius = 5,
    value = 20,
    r = 1,
    g = 0.95,
    b = 0.75,
    kind = "pill"
  })
end

for i = 1, #layout.powerPills do
  spawnItem(world.powerPills, {
    x = layout.powerPills[i].x,
    y = layout.powerPills[i].y,
    radius = 9,
    value = 50,
    r = 0.2,
    g = 0.7,
    b = 1,
    kind = "power"
  })
end

for i = 1, #layout.fruits do
  spawnItem(world.fruits, {
    x = layout.fruits[i].x,
    y = layout.fruits[i].y,
    radius = 8,
    value = 100,
    r = 1,
    g = 0.4,
    b = 0.2,
    kind = "fruit"
  })
end

local function updateHud()
  local pillsLeft, powerLeft, fruitsLeft = 0, 0, 0
  for i = 1, #world.pills do
    if world.pills[i].active then
      pillsLeft = pillsLeft + 1
    end
  end
  for i = 1, #world.powerPills do
    if world.powerPills[i].active then
      powerLeft = powerLeft + 1
    end
  end
  for i = 1, #world.fruits do
    if world.fruits[i].active then
      fruitsLeft = fruitsLeft + 1
    end
  end
  hudText.text = ("Score: %d   Lives: %d   Pills: %d   Power: %d   Fruit: %d"):format(world.score, world.lives, pillsLeft, powerLeft, fruitsLeft)
end

updateHud()

local actionState = {}

local function ensureState(name)
  if not actionState[name] then
    actionState[name] = {}
  end
  return actionState[name]
end

local function releaseControl(name)
  if pacman.intent and pacman.intent.controller == name then
    pacman.intent = nil
  end
end

local function requestMoveToItem(name, item)
  if not item then
    return
  end
  if item.active == false then
    return
  end
  if pacman.intent and pacman.intent.controller == name and pacman.intent.target == item then
    return
  end
  pacman.intent = {
    controller = name,
    target = item,
    speed = pacman.speed
  }
end

local function requestMoveToPoint(name, point)
  if pacman.intent and pacman.intent.controller == name and not pacman.intent.target then
    pacman.intent.x = point.x
    pacman.intent.y = point.y
    return
  end
  pacman.intent = {
    controller = name,
    x = point.x,
    y = point.y,
    speed = pacman.speed
  }
end

local function wasMovementCompleted(name)
  if pacman.completedAction == name then
    pacman.completedAction = nil
    return true
  end
  return false
end

local function findNearestActive(list)
  local best, bestDist
  for i = 1, #list do
    local item = list[i]
    if item.active then
      local d = distanceSquared(pacman.x, pacman.y, item.x, item.y)
      if not bestDist or d < bestDist then
        bestDist = d
        best = item
      end
    end
  end
  return best
end

local function resetGhost()
  ghost.x = ghost.baseX
  ghost.y = ghost.baseY
  ghost.direction.x = math.random(0, 1) == 0 and -1 or 1
  ghost.direction.y = math.random(-1, 1) * 0.5
  ghost.scared = false
  ghost.scaredTimer = 0
  ghost.display:setFillColor(1, 0.1, 0.2)
  ghost.display.x, ghost.display.y = ghost.x, ghost.y
end

local function scareGhost()
  ghost.scared = true
  ghost.scaredTimer = world.powerDuration
  ghost.display:setFillColor(0.3, 0.5, 1)
end

local function removeItem(item)
  if item and item.active then
    item.active = false
    if item.display then
      display.remove(item.display)
      item.display = nil
    end
    world.score = world.score + (item.value or 0)
    updateHud()
  end
end

local function completePickup(item)
  if not item or not item.kind then
    return
  end
  if item.kind == "power" then
    scareGhost()
    statusText.text = "Power pill! Ghost is scared."
  elseif item.kind == "fruit" then
    statusText.text = "Fruit collected!"
  else
    statusText.text = "Pill eaten."
  end
end

local actions = {}

actions["Eat Power Pill"] = function()
  local target = findNearestActive(world.powerPills)
  if not target then
    releaseControl("Eat Power Pill")
    return bt.FAILED
  end
  requestMoveToItem("Eat Power Pill", target)
  if not target.active then
    releaseControl("Eat Power Pill")
    return bt.SUCCESS
  end
  return bt.RUNNING
end

actions["Chase Ghost"] = function()
  requestMoveToItem("Chase Ghost", ghost)
  if ghost.scaredTimer <= 0 then
    releaseControl("Chase Ghost")
    return bt.FAILED
  end
  if wasMovementCompleted("Chase Ghost") then
    releaseControl("Chase Ghost")
    return bt.SUCCESS
  end
  return bt.RUNNING
end

actions["Avoid Ghost"] = function()
  local dx = pacman.x - ghost.x
  local dy = pacman.y - ghost.y
  local len = math.sqrt(dx * dx + dy * dy)
  if len < 0.001 then
    len = 1
    dx, dy = 1, 0
  end
  dx = dx / len
  dy = dy / len
  local target = {
    x = clamp(pacman.x + dx * 160, world.bounds.left, world.bounds.right),
    y = clamp(pacman.y + dy * 160, world.bounds.top, world.bounds.bottom)
  }
  requestMoveToPoint("Avoid Ghost", target)
  if wasMovementCompleted("Avoid Ghost") then
    statusText.text = "Escaped the ghost."
    return bt.SUCCESS
  end
  return bt.RUNNING
end

actions["Eat Pills"] = function()
  local state = ensureState("Eat Pills")
  if not state.target or not state.target.active then
    state.target = findNearestActive(world.pills)
  end
  local target = state.target
  if not target then
    releaseControl("Eat Pills")
    return bt.FAILED
  end
  requestMoveToItem("Eat Pills", target)
  if not target.active then
    state.target = nil
    releaseControl("Eat Pills")
    return bt.SUCCESS
  end
  return bt.RUNNING
end

actions["Eat Fruit"] = function()
  local state = ensureState("Eat Fruit")
  if not state.target or not state.target.active then
    state.target = findNearestActive(world.fruits)
  end
  local target = state.target
  if not target then
    releaseControl("Eat Fruit")
    return bt.FAILED
  end
  requestMoveToItem("Eat Fruit", target)
  if not target.active then
    state.target = nil
    statusText.text = "Fruit feast!"
    releaseControl("Eat Fruit")
    return bt.SUCCESS
  end
  return bt.RUNNING
end

local function handleActionNode(actionNode)
  local handler = actions[actionNode.name]
  if not handler then
    return bt.FAILED
  end
  return handler()
end

tree:onActionActivation(function(_, actionNode)
  if not actionNode:active() then
    return
  end
  if actionNode:status() ~= bt.RUNNING then
    return
  end
  local result = handleActionNode(actionNode)
  tree:setActionStatus(actionNode.name, result or bt.FAILED)
end)

local lastTime = system.getTimer()

local function updatePacman(dt)
  if pacman.hitCooldown > 0 then
    pacman.hitCooldown = pacman.hitCooldown - dt
    if pacman.hitCooldown < 0 then
      pacman.hitCooldown = 0
    end
  end
  if not pacman.intent then
    return
  end
  local targetX, targetY
  if pacman.intent.target then
    targetX, targetY = pacman.intent.target.x, pacman.intent.target.y
  else
    targetX, targetY = pacman.intent.x, pacman.intent.y
  end
  if not targetX or not targetY then
    pacman.intent = nil
    return
  end
  local dx = targetX - pacman.x
  local dy = targetY - pacman.y
  local dist = math.sqrt(dx * dx + dy * dy)
  local step = (pacman.intent.speed or pacman.speed) * dt
  if dist <= step then
    pacman.x = targetX
    pacman.y = targetY
    pacman.display.x, pacman.display.y = pacman.x, pacman.y
    pacman.completedAction = pacman.intent.controller
    pacman.intent = nil
    return
  end
  local nx, ny = dx / dist, dy / dist
  pacman.x = pacman.x + nx * step
  pacman.y = pacman.y + ny * step
  pacman.x = clamp(pacman.x, world.bounds.left, world.bounds.right)
  pacman.y = clamp(pacman.y, world.bounds.top, world.bounds.bottom)
  pacman.display.x, pacman.display.y = pacman.x, pacman.y
end

local function bounceDirection(component)
  if component > 0 then
    return -1
  else
    return 1
  end
end

local function updateGhost(dt)
  ghost.changeTimer = ghost.changeTimer - dt
  if ghost.changeTimer <= 0 then
    ghost.changeTimer = 1.4 + math.random() * 1.2
    local angle = math.random() * math.pi * 2
    ghost.direction.x = math.cos(angle)
    ghost.direction.y = math.sin(angle)
  end
  local speed = ghost.speed
  if ghost.scared then
    ghost.scaredTimer = ghost.scaredTimer - dt
    speed = speed * 0.5
    if ghost.scaredTimer <= 0 then
      ghost.scared = false
      ghost.scaredTimer = 0
      ghost.display:setFillColor(1, 0.1, 0.2)
      statusText.text = "Ghost recovered."
    end
  end
  ghost.x = ghost.x + ghost.direction.x * speed * dt
  ghost.y = ghost.y + ghost.direction.y * speed * dt
  if ghost.x - ghost.radius < world.bounds.left then
    ghost.x = world.bounds.left + ghost.radius
    ghost.direction.x = bounceDirection(ghost.direction.x)
  elseif ghost.x + ghost.radius > world.bounds.right then
    ghost.x = world.bounds.right - ghost.radius
    ghost.direction.x = bounceDirection(ghost.direction.x)
  end
  if ghost.y - ghost.radius < world.bounds.top then
    ghost.y = world.bounds.top + ghost.radius
    ghost.direction.y = bounceDirection(ghost.direction.y)
  elseif ghost.y + ghost.radius > world.bounds.bottom then
    ghost.y = world.bounds.bottom - ghost.radius
    ghost.direction.y = bounceDirection(ghost.direction.y)
  end
  ghost.display.x, ghost.display.y = ghost.x, ghost.y
end

local function handlePickups(list)
  for i = 1, #list do
    local item = list[i]
    if item.active then
      if distanceSquared(pacman.x, pacman.y, item.x, item.y) <= (pacman.radius + item.radius) ^ 2 then
        removeItem(item)
        completePickup(item)
      end
    end
  end
end

local function handleGhostCollision()
  if distanceSquared(pacman.x, pacman.y, ghost.x, ghost.y) > (pacman.radius + ghost.radius - 4) ^ 2 then
    return
  end
  if ghost.scared then
    world.score = world.score + 200
    statusText.text = "Ghost captured!"
    resetGhost()
    updateHud()
  elseif pacman.hitCooldown == 0 then
    world.lives = math.max(0, world.lives - 1)
    pacman.hitCooldown = 1.5
    world.score = math.max(0, world.score - 100)
    pacman.x = display.contentCenterX - 80
    pacman.y = display.contentCenterY
    pacman.display.x, pacman.display.y = pacman.x, pacman.y
    pacman.intent = nil
    pacman.completedAction = nil
    statusText.text = "Ouch! Ghost got you."
    updateHud()
    if world.lives == 0 then
      statusText.text = "Game over."
    end
  end
end

local function updateConditions()
  local ghostClose = distance(pacman.x, pacman.y, ghost.x, ghost.y) < 120
  tree:setConditionStatus("Ghost Close", ghostClose and bt.SUCCESS or bt.FAILED)
  tree:setConditionStatus("Ghost Scared", ghost.scared and bt.SUCCESS or bt.FAILED)
  local nearestPower = findNearestActive(world.powerPills)
  local powerClose = nearestPower and distance(pacman.x, pacman.y, nearestPower.x, nearestPower.y) < 150
  tree:setConditionStatus("Power Pill Close", powerClose and bt.SUCCESS or bt.FAILED)
end

local function onEnterFrame(event)
  local now = event.time
  local dt = (now - lastTime) * 0.001
  if dt <= 0 then
    dt = 0.016
  end
  lastTime = now

  updateGhost(dt)
  updatePacman(dt)
  handlePickups(world.pills)
  handlePickups(world.powerPills)
  handlePickups(world.fruits)
  handleGhostCollision()
  updateConditions()
  tree:tick()
end

Runtime:addEventListener("enterFrame", onEnterFrame)
statusText.text = "Pac-Man is thinking..."
