# Condition Architecture

## Overview

The condition system provides a modular approach to defining behavior tree conditions. Each condition is implemented as a separate file, and the condition controller manages their registration and evaluation.

## Structure

```
conditions/
├── ghost_close.lua           # Is ghost near Pacman?
├── ghost_scared.lua          # Is ghost vulnerable?
├── power_pill_close.lua      # Is power pill nearby?
└── condition_controller.lua  # Manages all conditions
```

## Condition Module Pattern

Each condition follows this pattern:

```lua
-- conditions/example_condition.lua
local bt = require("btree")

local M = {}

function M.create(world)
  -- Factory function receives world context
  -- Can access world.ghost, world.itemController, etc.

  return function(pacman)
    -- Handler function receives pacman
    -- Called each frame to evaluate condition

    -- Perform checks...
    local conditionMet = -- some logic

    return conditionMet and bt.SUCCESS or bt.FAILED
  end
end

return M
```## Existing Conditions

### 1. Ghost Close

**File**: `conditions/ghost_close.lua`

**Purpose**: Checks if the ghost is dangerously close to Pacman.

**Logic**:
```lua
distance = sqrt((pacman.x - ghost.x)² + (pacman.y - ghost.y)²)
isClose = distance < 120 pixels
```

**Returns**:
- `bt.SUCCESS` if ghost is within 120 pixels
- `bt.FAILED` if ghost is farther away

**Used For**: Triggering "Avoid Ghost" action

---

### 2. Ghost Scared

**File**: `conditions/ghost_scared.lua`

**Purpose**: Checks if the ghost is in vulnerable (scared) state.

**Logic**:
```lua
isScared = ghost.scared == true
```

**Returns**:
- `bt.SUCCESS` if ghost is scared (blue, vulnerable)
- `bt.FAILED` if ghost is normal (red, dangerous)

**Used For**: Triggering "Chase Ghost" action for bonus points

---

### 3. Power Pill Close

**File**: `conditions/power_pill_close.lua`

**Purpose**: Checks if a power pill is nearby and worth pursuing.

**Logic**:
```lua
nearestPower = findNearest(pacman, powerPills)
if nearestPower exists:
  distance = sqrt((pacman.x - nearestPower.x)² + (pacman.y - nearestPower.y)²)
  isClose = distance < 150 pixels
```

**Returns**:
- `bt.SUCCESS` if power pill exists and is within 150 pixels
- `bt.FAILED` if no power pills or all are too far

**Used For**: Deciding whether to pursue power pill or collect regular pills

## Condition Controller

**File**: `conditions/condition_controller.lua`

### Model Table Approach

Uses a model table for dynamic condition loading:

```lua
local conditionModel = {
  ["Ghost Close"] = "conditions.ghost_close",
  ["Ghost Scared"] = "conditions.ghost_scared",
  ["Power Pill Close"] = "conditions.power_pill_close"
}
```

### Key Functions

#### createConditions(bt, pacman, world)

Creates all condition handlers from the model table.

```lua
local conditions = conditionController.createConditions(bt, pacman, world)

-- Returns:
-- {
--   ["Ghost Close"] = handler function,
--   ["Ghost Scared"] = handler function,
--   ["Power Pill Close"] = handler function
-- }
```

#### updateConditions(tree, conditions, pacman, ghost)

Evaluates all conditions and updates the behavior tree.

```lua
conditionController.updateConditions(tree, conditions, pacman, ghost)

-- For each condition:
--   1. Calls handler(pacman, ghost)
--   2. Gets result (SUCCESS or FAILED)
--   3. Updates tree status: tree:setConditionStatus(name, result)
```

## Integration with Main Loop

### Setup Phase

```lua
-- In main.lua initialization
local conditionController = require("conditions.condition_controller")

-- Create condition handlers once
local conditions = conditionController.createConditions(bt, pacman, world)
```

### Game Loop

```lua
local function onEnterFrame(event)
  -- ... update entities ...

  -- Update all conditions
  conditionController.updateConditions(tree, conditions, pacman, ghost)

  -- Behavior tree uses updated condition statuses
  tree:tick()
end
```## Benefits

### 1. Modular Design

Each condition is self-contained in its own file:

```
✅ Easy to find: conditions/ghost_close.lua
✅ Easy to test: Require and test individually
✅ Easy to modify: Change logic in one place
```

### 2. Declarative Registration

Add new conditions by updating the model table:

```lua
-- Add to conditionModel in condition_controller.lua
local conditionModel = {
  -- ... existing conditions ...
  ["Fruit Available"] = "conditions.fruit_available",  -- New!
}
```

Then create `conditions/fruit_available.lua`:

```lua
local bt = require("btree")

return function(world)
  return function(pacman)
    local hasFruit = world.itemController.countActive(world.fruits) > 0
    return hasFruit and bt.SUCCESS or bt.FAILED
  end
end
```

### 3. Consistent Pattern

All conditions follow the same structure:
- Factory function receives `world`
- Handler function receives `pacman`
- Returns `bt.SUCCESS` or `bt.FAILED`

### 4. Centralized Management

Single controller handles all condition operations:
- Creation
- Evaluation
- Tree status updates

## Adding New Conditions

### Step 1: Create Condition File

```lua
-- conditions/my_condition.lua
local bt = require("btree")

local M = {}

function M.create(world)
  return function(pacman)
    -- Your condition logic here
    local result = -- some check

    return result and bt.SUCCESS or bt.FAILED
  end
end

return M
```### Step 2: Register in Model Table

```lua
-- conditions/condition_controller.lua
local conditionModel = {
  -- ... existing ...
  ["My Condition"] = "conditions.my_condition"
}
```

### Step 3: Use in Behavior Tree

```
// packman.tree
sequence
  condition "My Condition"
  action "My Action"
end
```

That's it! The condition system will automatically:
- Load your condition module
- Create the handler
- Evaluate it each frame
- Update the tree status

## Example: Full Condition Lifecycle

```lua
-- 1. DEFINITION (conditions/ghost_close.lua)
local M = {}

function M.create(world)
  return function(pacman, ghost)
    local distance = world.collisionController.distance(
      pacman.x, pacman.y,
      ghost.x, ghost.y
    )
    return distance < 120 and bt.SUCCESS or bt.FAILED
  end
end

return M

-- 2. REGISTRATION (conditions/condition_controller.lua)
conditionModel = {
  ["Ghost Close"] = "conditions.ghost_close"
}

-- 3. INITIALIZATION (main.lua - once at startup)
local conditions = conditionController.createConditions(bt, pacman, world)
-- conditions["Ghost Close"] = handler function

-- 4. EVALUATION (main.lua - each frame)
conditionController.updateConditions(tree, conditions, pacman, ghost)
-- Calls handler(pacman, ghost), gets result, updates tree

-- 5. USAGE (behavior tree)
-- Tree checks condition status before running actions
selector
  sequence
    condition "Ghost Close"  ← Checks updated status
    action "Avoid Ghost"     ← Runs if condition is SUCCESS
  end
  -- ... other actions ...
end
```## Condition vs Action

| Aspect | Condition | Action |
|--------|-----------|--------|
| **Purpose** | Check game state | Change game state |
| **Returns** | SUCCESS/FAILED immediately | SUCCESS/FAILED/RUNNING |
| **Examples** | "Ghost Close", "Ghost Scared" | "Eat Pills", "Chase Ghost" |
| **Duration** | Instant evaluation | Can span multiple frames |
| **Side Effects** | None (read-only) | Yes (moves Pacman, etc.) |
| **Frequency** | Evaluated every frame | Only when active in tree |

## Debugging Conditions

### Print Condition Status

```lua
-- In main.lua game loop
local function onEnterFrame(event)
  -- ... updates ...

  conditionController.updateConditions(tree, conditions, pacman, ghost)

  -- Debug: Print condition results
  for name, handler in pairs(conditions) do
    local result = handler(pacman, ghost)
    print(name .. ": " .. (result == bt.SUCCESS and "✓" or "✗"))
  end

  tree:tick()
end
```### Test Individual Condition

```lua
-- test_ghost_close.lua
local ghostClose = require("conditions.ghost_close")
local bt = require("btree")

local mockWorld = {
  collisionController = {
    distance = function(x1, y1, x2, y2)
      return math.sqrt((x2-x1)^2 + (y2-y1)^2)
    end
  }
}

local handler = ghostClose.create(mockWorld)
local mockPacman = { x = 100, y = 150 }
local mockGhost = { x = 100, y = 100 }  -- 50 pixels away

local result = handler(mockPacman, mockGhost)
print("Ghost Close (50 pixels):", result == bt.SUCCESS)  -- true

mockGhost.y = 300  -- 200 pixels away
result = handler(mockPacman, mockGhost)
print("Ghost Close (200 pixels):", result == bt.SUCCESS)  -- false
```

---

**Last Updated**: October 13, 2025
**Status**: ✅ Condition System Complete
