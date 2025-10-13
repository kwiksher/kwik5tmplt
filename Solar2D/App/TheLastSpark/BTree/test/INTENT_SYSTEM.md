# Intent System

## Overview

The intent system is a communication mechanism that allows behavior tree actions to request and coordinate Pacman's movement. It acts as a bridge between high-level AI decisions (behavior tree actions) and low-level movement control (Pacman controller).

## Purpose

**Problem**: Multiple behavior tree actions want to control Pacman's movement simultaneously.

**Solution**: The intent system ensures only one action controls movement at a time, tracks which action is in control, and provides a clean handoff mechanism.

## Intent Structure

```lua
pacman.intent = {
  action = string,    -- Name of the action controlling movement
  target = object,    -- Optional: target item/entity
  x = number,         -- Optional: target x coordinate
  y = number,         -- Optional: target y coordinate
  speed = number      -- Movement speed
}
```

### Fields Explained

- **`action`**: The name of the behavior tree action requesting movement (e.g., "Eat Pills", "Chase Ghost")
- **`target`**: Reference to a game object to move toward (items, ghost, etc.)
- **`x, y`**: Explicit coordinates when not using a target object
- **`speed`**: Movement speed in pixels per second


## How It Works

### 1. Requesting Movement

Actions use Pacman controller methods to request movement:

```lua
-- Move to a specific item
pacman.controller.moveToItem(pacman, "Eat Pills", pill)

-- Move to coordinates
pacman.controller.moveToPoint(pacman, "Avoid Ghost", {x = 200, y = 300})
```

When called, these methods create or update `pacman.intent`:

```lua
-- moveToItem creates this intent:
pacman.intent = {
  action = "Eat Pills",
  target = pill,
  speed = pacman.speed
}

-- moveToPoint creates this intent:
pacman.intent = {
  action = "Avoid Ghost",
  x = 200,
  y = 300,
  speed = pacman.speed
}
```

### 2. Movement Execution

The Pacman controller's `update()` function checks for an active intent:

```lua
function M.update(pacman, world, dt)
  if not pacman.intent then
    return  -- No active movement request
  end

  -- Calculate direction to target
  local targetX, targetY
  if pacman.intent.target then
    targetX = pacman.intent.target.x
    targetY = pacman.intent.target.y
  else
    targetX = pacman.intent.x
    targetY = pacman.intent.y
  end

  -- Move Pacman toward target
  -- When reached, set pacman.completedAction = pacman.intent.action
end
```

### 3. Checking Completion

Actions check if their movement request completed:

```lua
-- In eat_pills.lua action
if pacman.controller.wasMovementCompleted(pacman, "Eat Pills") then
  pacman.controller.releaseControl(pacman, "Eat Pills")
  return bt.SUCCESS
end
```

The `wasMovementCompleted()` function checks:

```lua
function M.wasMovementCompleted(pacman, actionName)
  return pacman.completedAction == actionName
end
```

### 4. Releasing Control

When an action finishes, it releases control:

```lua
pacman.controller.releaseControl(pacman, "Eat Pills")
```

This clears the intent:

```lua
function M.releaseControl(pacman, actionName)
  if pacman.intent and pacman.intent.action == actionName then
    pacman.intent = nil
    pacman.completedAction = nil
  end
end
```

## Intent Flow Diagram

```
┌─────────────────────────────────────┐
│         Behavior Tree               │
│  (Evaluates actions each frame)     │
└──────────────┬──────────────────────┘
               │
        ┌──────┴──────────────┐
        │                     │
   ┌────▼──────┐      ┌──────▼────┐
   │  Action   │      │  Action   │
   │"Eat Pills"│      │"Chase     │
   │           │      │ Ghost"    │
   └────┬──────┘      └──────┬────┘
        │                    │
        │ 1. Request         │ (Blocked - intent
        │    Movement        │  already active)
        │                    │
        └──────────┬─────────┘
                   │
           ┌───────▼────────┐
           │  Pacman        │
           │  Controller    │
           │                │
           │ intent = {     │
           │   action:      │ ← Only one action
           │   "Eat Pills"  │   controls at once
           │   target: pill │
           │   speed: 120   │
           │ }              │
           │                │
           │ 2. Update()    │ ← Moves Pacman
           │    each frame  │   toward target
           │                │
           │ 3. On arrival: │
           │ completedAction│ ← Signals completion
           │ = "Eat Pills"  │
           └────────────────┘
                   │
           ┌───────▼────────┐
           │  Action checks │
           │ wasCompleted() │
           │                │
           │ 4. Release     │ ← Clears intent
           │    control     │   for next action
           └────────────────┘
```

## Complete Action Examples

### Example 1: Eat Pills Action (Stateful)

```lua
-- actions/eat_pills.lua
local bt = require("behavior_tree")

-- Create stateful action
return function(world)
  -- State persists across frames
  local state = {}

  return function(pacman)
    -- Find nearest pill if no target
    if not state.target or not state.target.active then
      state.target = world.itemController.findNearest(
        pacman,
        world.items.pills
      )

      if not state.target then
        return bt.FAILED  -- No pills available
      end
    end

    -- Request movement to pill
    pacman.controller.moveToItem(pacman, "Eat Pills", state.target)

    -- Check if pill was collected
    if not state.target.active then
      pacman.controller.releaseControl(pacman, "Eat Pills")
      state.target = nil
      return bt.SUCCESS
    end

    -- Still moving toward pill
    return bt.RUNNING
  end
end
```

### Example 2: Avoid Ghost Action (Stateless)

```lua
-- actions/avoid_ghost.lua
local bt = require("behavior_tree")

return function(world)
  return function(pacman)
    local ghost = world.ghost

    -- Check if ghost is dangerous
    if ghost.scared or ghost.isRespawning then
      return bt.FAILED  -- No need to avoid
    end

    -- Calculate escape point (move away from ghost)
    local dx = pacman.x - ghost.x
    local dy = pacman.y - ghost.y
    local distance = math.sqrt(dx * dx + dy * dy)

    if distance > 150 then
      return bt.FAILED  -- Ghost too far away
    end

    -- Normalize direction and move away
    local escapeDistance = 160
    local targetX = pacman.x + (dx / distance) * escapeDistance
    local targetY = pacman.y + (dy / distance) * escapeDistance

    -- Clamp to boundaries
    targetX = math.max(50, math.min(display.contentWidth - 50, targetX))
    targetY = math.max(50, math.min(display.contentHeight - 50, targetY))

    -- Request movement to escape point
    pacman.controller.moveToPoint(
      pacman,
      "Avoid Ghost",
      {x = targetX, y = targetY}
    )

    -- Check completion
    if pacman.controller.wasMovementCompleted(pacman, "Avoid Ghost") then
      pacman.controller.releaseControl(pacman, "Avoid Ghost")
      return bt.SUCCESS
    end

    -- Still escaping
    return bt.RUNNING
  end
end
```

## Coordination Rules

### Single Control Principle

**Only one action can control movement at a time.**

```lua
-- Scenario: Two actions try to control Pacman

-- Frame 1: Eat Pills requests control
pacman.controller.moveToItem(pacman, "Eat Pills", pill)
-- ✅ Success: pacman.intent = { action: "Eat Pills", target: pill, speed: 120 }

-- Frame 1: Chase Ghost also tries
pacman.controller.moveToItem(pacman, "Chase Ghost", ghost)
-- ❌ Blocked: Intent already exists for "Eat Pills"
```

### Ownership Check

Actions can only release control if they own it:

```lua
-- Eat Pills owns the intent
pacman.intent = { action: "Eat Pills", ... }

-- Chase Ghost tries to release
pacman.controller.releaseControl(pacman, "Chase Ghost")
-- ❌ No effect: Chase Ghost doesn't own the intent

-- Eat Pills releases
pacman.controller.releaseControl(pacman, "Eat Pills")
-- ✅ Success: Intent cleared
```

### Priority Through Behavior Tree

The behavior tree determines priority through its structure:

```lua
-- Behavior tree evaluated top-to-bottom
bt.selector({
  avoid_ghost,      -- Highest priority (checked first)
  chase_ghost,      -- Medium priority
  eat_power_pill,   -- Medium priority
  eat_fruit,        -- Low priority
  eat_pills         -- Lowest priority (checked last)
})
```

When `avoid_ghost` returns `RUNNING` (controlling movement), other actions won't execute until it completes or fails.

## Key Concepts

### Terminology

- **Action** = Behavior tree action that makes decisions ("Eat Pills", "Chase Ghost")
- **Controller** = Code module providing movement functions (`pacman_controller`)
- **Intent** = Current movement request with target and speed
- **Ownership** = Which action currently controls the intent

### State Machine View

```
┌─────────┐
│  IDLE   │ ← No intent, Pacman stationary
└────┬────┘
     │ Action calls moveToItem() or moveToPoint()
     ▼
┌─────────┐
│ MOVING  │ ← Intent active, controller updates position
└────┬────┘
     │ Reaches target
     ▼
┌──────────┐
│COMPLETED │ ← completedAction set, action can check
└────┬─────┘
     │ Action calls releaseControl()
     ▼
┌─────────┐
│  IDLE   │ ← Ready for next action
└─────────┘
```

### Benefits

✅ **Prevents Conflicts**: Only one action controls movement
✅ **Clean Handoffs**: Clear ownership and release mechanism
✅ **Debugging**: Easy to see which action is in control
✅ **Decoupled**: Actions don't need to know about each other
✅ **Flexible**: Easy to add new actions without conflicts

## Debugging Tips

### Check Current Intent

```lua
-- In main game loop
if pacman.intent then
  print("Active Action: " .. pacman.intent.action)
  print("Target: ", pacman.intent.target or {x=pacman.intent.x, y=pacman.intent.y})
  print("Speed: " .. pacman.intent.speed)
else
  print("No active intent - Pacman idle")
end
```

### Track Completion

```lua
-- After movement completes
if pacman.completedAction then
  print("Completed: " .. pacman.completedAction)
end
```

### Monitor Action Execution

```lua
-- In each action
print("Action 'Eat Pills' checking...")
if pacman.intent and pacman.intent.action == "Eat Pills" then
  print("  -> We own the intent, movement in progress")
elseif pacman.intent then
  print("  -> Blocked by: " .. pacman.intent.action)
else
  print("  -> Intent available, requesting control")
end
```

---

**Last Updated**: October 13, 2025
**Status**: ✅ Documentation Complete

