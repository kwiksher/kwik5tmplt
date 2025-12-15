local bt = require("btree")
local fileLoader = require("utils.file_loader")
local worldModel = require("models.world")
local pacmanModel = require("models.pacman")
local ghostModel = require("models.ghost")
local itemModel = require("models.item")
local displayManager = require("views.display_manager")
local actionController = require("actions.action_controller")
local conditionController = require("conditions.condition_controller")

-- Load behavior tree
local treeText, loadErr = fileLoader.loadTree("packman.tree")
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

-- Initialize models
local world = worldModel.create()
local pacman = pacmanModel.create()
local ghost = ghostModel.create()

-- Initialize views
displayManager.createBackground()
displayManager.createPacmanDisplay(pacman)
displayManager.createGhostDisplay(ghost)
local hudText, statusText = displayManager.createHUD()

-- Setup items layout
--[[
  PowerPill
  ↑
  |
  Fruit →  👻 Ghost
  |
  ↓
  PowerPill
 --]]
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
    {x = ghost.x - 60, y = ghost.y - 80},
    {x = ghost.x + 70, y = ghost.y + 60}
  },
  fruits = {
    {x = ghost.x + 40, y = ghost.y - 40}
  }
}

-- Spawn items using item model
for i = 1, #layout.pills do
  local pill = itemModel.createPill(layout.pills[i].x, layout.pills[i].y)
  displayManager.spawnItem(world.pills, pill)
end

for i = 1, #layout.powerPills do
  local powerPill = itemModel.createPowerPill(layout.powerPills[i].x, layout.powerPills[i].y)
  displayManager.spawnItem(world.powerPills, powerPill)
end

for i = 1, #layout.fruits do
  local fruit = itemModel.createFruit(layout.fruits[i].x, layout.fruits[i].y)
  displayManager.spawnItem(world.fruits, fruit)
end

-- HUD update function
local function updateHud()
  local pillsCount = world.itemController.countActive(world.pills)
  local powerCount = world.itemController.countActive(world.powerPills)
  local fruitsCount = world.itemController.countActive(world.fruits)
  hudText.text = ("Score: %d   Lives: %d   Pills: %d   Power: %d   Fruit: %d"):format(world.score, world.lives, pillsCount, powerCount, fruitsCount)
end

updateHud()

-- Setup actions
local actions = actionController.createActions(pacman, ghost, world, statusText)

-- Setup conditions
local conditions = conditionController.createConditions(pacman, ghost, world, statusText)

local function handleActionNode(actionNode)
  local handler = actions[actionNode.name]
  if not handler then
    return bt.FAILED
  end
  return handler(pacman, ghost, world, statusText)
end

tree:onActionActivation(function(_, actionNode)
  if not actionNode:active() then
    return
  end
  if actionNode:status() ~= bt.RUNNING then
    return
  end
  local result = handleActionNode(actionNode)
  --
  -- TBI UI:dispatchEvent to kwik action
  --    actionNode.name
  --    result
  --
  tree:setActionStatus(actionNode.name, result or bt.FAILED)
end)

-- Main game loop
local lastTime = system.getTimer()

local function onEnterFrame(event)
  local now = event.time
  local dt = (now - lastTime) * 0.001
  if dt <= 0 then
    dt = 0.016
  end
  lastTime = now

  ghost.controller.update(ghost, world, dt)
  pacman.controller.update(pacman, world, dt)
  world.itemController.checkPickups(pacman, world, world.pills, updateHud, statusText, ghost)
  world.itemController.checkPickups(pacman, world, world.powerPills, updateHud, statusText, ghost)
  world.itemController.checkPickups(pacman, world, world.fruits, updateHud, statusText, ghost)
  world.collisionController.handlePacmanGhostCollision(pacman, ghost, world, updateHud, statusText)
  conditions:updateConditions(tree)
  tree:tick()
end

Runtime:addEventListener("enterFrame", onEnterFrame)
statusText.text = "Pac-Man is thinking..."
