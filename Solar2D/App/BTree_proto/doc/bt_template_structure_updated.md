# Behavior Tree Template Project Structure

This document describes a template project structure for a behavior tree system based on the architecture patterns identified in the Pacman BTree example.

## Directory Structure

```
bt_template/
├── main.lua
├── btree.lua
├── models/
│   ├── entity1.lua
│   └── entity2.lua
├── views/
│   ├── display_manager.lua
│   ├── entity1_display.lua
│   └── entity2_display.lua
├── actions/
│   ├── action1.lua
│   ├── action2.lua
│   └── action_controller.lua
├── conditions/
│   ├── condition1.lua
│   ├── condition2.lua
│   └── condition_controller.lua
├── controllers/
│   ├── entity1_controller.lua
│   └── entity2_controller.lua
└── utils/
    └── file_loader.lua
```

## Component Implementations

### main.lua

```lua
-- main.lua
-- Main entry point for the behavior tree system

local bt = require("btree")
local fileLoader = require("utils.file_loader")
local actionController = require("actions.action_controller")
local conditionController = require("conditions.condition_controller")
local displayManager = require("views.display_manager")

-- Load behavior tree
local treeText, loadErr = fileLoader.loadTree("behavior.tree")
if not treeText then
  print("Error loading tree:", loadErr or "Unknown error")
  return
end

local tree = bt.BehaviorTree:fromText(treeText)

-- Initialize models
-- (Implementation depends on specific entities in the tree)

-- Initialize views
displayManager.createBackground()
-- Initialize other display objects as needed

-- Setup actions
local actions = actionController.createActions()

-- Setup conditions
local conditions = conditionController.createConditions()

-- Action activation handler
tree:onActionActivation(function(_, actionNode)
  if not actionNode:active() then
    return
  end
  if actionNode:status() ~= bt.RUNNING then
    return
  end

  local handler = actions[actionNode.name]
  if not handler then
    tree:setActionStatus(actionNode.name, bt.FAILED)
    return
  end

  local result = handler()
  tree:setActionStatus(actionNode.name, result or bt.FAILED)
end)

-- Main game loop
local function onEnterFrame(event)
  -- Update conditions
  for name, evaluator in pairs(conditions) do
    local result = evaluator()
    tree:setConditionStatus(name, result)
  end

  -- Tick the behavior tree
  tree:tick()
end

Runtime:addEventListener("enterFrame", onEnterFrame)
```

### btree.lua

```lua
-- btree.lua
-- Behavior tree engine implementation

local bt = {}

bt.FAILED = 0
bt.SUCCESS = 1
bt.RUNNING = 2

-- Node base class
local Node = {}
Node.__index = Node

function Node:new(name, kind, children)
  local node = {
    name = name,
    kind = kind,
    children = children or {},
    _active = false,
    nodeStatus = bt.FAILED
  }
  setmetatable(node, Node)
  return node
end

function Node:status()
  return self.nodeStatus
end

function Node:setStatus(newStatus)
  self.nodeStatus = newStatus
end

function Node:active()
  return self._active
end

function Node:setActive(isActive)
  self._active = isActive
end

function Node:tick()
  self:setActive(true)
  return self:status()
end

function Node:deactivate()
  self:setActive(false)
  for _, child in ipairs(self.children) do
    child:deactivate()
  end
end

-- Selector node (fallback)
local Selector = {}
Selector.__index = Selector
setmetatable(Selector, Node)

function Selector:new(children)
  local selector = Node:new("Selector", "selector", children)
  setmetatable(selector, Selector)
  return selector
end

function Selector:tick()
  self:setActive(true)
  for _, child in ipairs(self.children) do
    local status = child:tick()
    self:setStatus(status)
    if status == bt.RUNNING or status == bt.SUCCESS then
      return self:status()
    end
  end
  self:setStatus(bt.FAILED)
  return self:status()
end

-- Sequence node
local Sequence = {}
Sequence.__index = Sequence
setmetatable(Sequence, Node)

function Sequence:new(children)
  local sequence = Node:new("Sequence", "sequence", children)
  setmetatable(sequence, Sequence)
  return sequence
end

function Sequence:tick()
  self:setActive(true)
  for _, child in ipairs(self.children) do
    local status = child:tick()
    self:setStatus(status)
    if status == bt.RUNNING or status == bt.FAILED then
      return self:status()
    end
  end
  self:setStatus(bt.SUCCESS)
  return self:status()
end

-- Action node
local Action = {}
Action.__index = Action
setmetatable(Action, Node)

function Action:new(name)
  local action = Node:new(name, "action")
  setmetatable(action, Action)
  return action
end

-- Condition node
local Condition = {}
Condition.__index = Condition
setmetatable(Condition, Node)

function Condition:new(name)
  local condition = Node:new(name, "condition")
  setmetatable(condition, Condition)
  return condition
end

-- BehaviorTree class
local BehaviorTree = {}
BehaviorTree.__index = BehaviorTree

function BehaviorTree:new(root)
  local tree = {
    root = root,
    actions = {},
    conditions = {}
  }
  setmetatable(tree, BehaviorTree)
  return tree
end

function BehaviorTree:tick()
  if self.root then
    self.root:tick()
  end
end

function BehaviorTree:setConditionStatus(name, status)
  -- Implementation would set status of condition nodes
end

function BehaviorTree:setActionStatus(name, status)
  -- Implementation would set status of action nodes
end

function BehaviorTree:onActionActivation(callback)
  -- Implementation would register action activation callback
end

bt.Node = Node
bt.Selector = Selector
bt.Sequence = Sequence
bt.Action = Action
bt.Condition = Condition
bt.BehaviorTree = BehaviorTree

return bt
```

### models/entity1.lua

```lua
-- models/entity1.lua
-- Model for entity1

local entity1Controller = require("controllers.entity1_controller")

local M = {}

function M.create()
  local entity = {
    x = 0,
    y = 0,
    state = "idle",
    controller = entity1Controller
  }

  return entity
end

return M
```

### views/display_manager.lua

```lua
-- views/display_manager.lua
-- Central manager for all display objects

local M = {}

function M.createBackground()
  local background = display.newRect(display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
  background:setFillColor(0.08, 0.08, 0.12)
  return background
end

function M.createEntity1Display(entity)
  -- Create visual representation of entity1
  local displayObj = display.newRect(entity.x, entity.y, 50, 50)
  displayObj:setFillColor(1, 0, 0)
  entity.display = displayObj
  return displayObj
end

function M.createEntity2Display(entity)
  -- Create visual representation of entity2
  local displayObj = display.newRect(entity.x, entity.y, 50, 50)
  displayObj:setFillColor(0, 1, 0)
  entity.display = displayObj
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

-- Create display object based on item kind
local function createItemDisplay(params)
  local kind = params.kind or "generic"
  local x, y = params.x, params.y
  local displayObj

  if kind == "item1" then
    displayObj = display.newCircle(x, y, params.radius or 6)
    displayObj:setFillColor(1, 1, 0)
  elseif kind == "item2" then
    displayObj = display.newCircle(x, y, params.radius or 8)
    displayObj:setFillColor(0, 1, 1)
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
```

### views/entity1_display.lua

```lua
-- views/entity1_display.lua
-- Display for entity1

local M = {}

function M.create(x, y, params)
  params = params or {}
  local width = params.width or 50
  local height = params.height or 50

  local displayObject = display.newRect(x, y, width, height)
  displayObject:setFillColor(1, 0, 0)

  return displayObject
end

return M
```

### actions/action1.lua

```lua
-- actions/action1.lua
-- Implementation of action1

local bt = require("btree")
local M = {}

function M.execute(params)
  -- Implementation of the action
  print("Executing action1")

  -- Modify model state, perform game logic

  -- Return status
  return bt.SUCCESS
end

return M
```

### actions/action_controller.lua

```lua
-- actions/action_controller.lua
-- Controller for managing actions

local M = {}

-- Action model table: maps action names to their module paths
local actionModel = {
  ["action1"] = "actions.action1",
  ["action2"] = "actions.action2"
}

function M.createActions()
  local actions = {}

  -- Dynamically load and create actions from model
  for actionName, modulePath in pairs(actionModel) do
    local actionModule = require(modulePath)
    actions[actionName] = actionModule.execute
  end

  return actions
end

return M
```

### conditions/condition1.lua

```lua
-- conditions/condition1.lua
-- Implementation of condition1

local bt = require("btree")
local M = {}

function M.evaluate(params)
  -- Evaluation logic
  print("Evaluating condition1")

  -- Check some condition

  -- Return status
  return bt.SUCCESS
end

return M
```

### conditions/condition_controller.lua

```lua
-- conditions/condition_controller.lua
-- Controller for managing conditions

local M = {}

-- Condition model table: maps condition names to their module paths
local conditionModel = {
  ["condition1"] = "conditions.condition1",
  ["condition2"] = "conditions.condition2"
}

function M.createConditions()
  local conditions = {}

  -- Dynamically load and create conditions from model
  for conditionName, modulePath in pairs(conditionModel) do
    local conditionModule = require(modulePath)
    conditions[conditionName] = conditionModule.evaluate
  end

  return conditions
end

return M
```

### controllers/entity1_controller.lua

```lua
-- controllers/entity1_controller.lua
-- Controller for entity1

local M = {}

function M.update(entity, world, dt)
  -- Update entity1 logic
  -- This would contain movement, AI, or other logic
end

function M.moveToItem(entity, actionName, target)
  -- Move entity toward target item
  if not target or not target.active then
    return
  end

  -- Implementation of movement logic
end

function M.releaseControl(entity, actionName)
  -- Release control from an action
end

return M
```

### utils/file_loader.lua

```lua
-- utils/file_loader.lua
-- Utility for loading files

local M = {}

function M.loadTree(path)
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

return M
```

This updated template provides a complete structure for implementing a behavior tree system with proper separation of concerns between models, views, controllers, actions, conditions, and utilities. It includes the display manager pattern observed in the Pacman example.