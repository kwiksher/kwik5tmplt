# Conditional Object States - Usage Examples

This document explains how to use `object_state_conditional` in your cabin scene (or any scene) to create dynamic, branching narratives based on player choices and game state.

## Overview

The `changeObjectStateConditional` method allows you to change an object's state only when a condition is met. If the condition is false, the object can revert to a default state.

**IMPORTANT**: Both conditions and actions are defined as **strings** in the scene dialogue, and the actual logic is implemented in the scene's helper file (`cabinScene_helpers.lua`). This keeps dialogue clean and logic centralized.

## Architecture

The system is now split into three layers:

1. **`common_helpers.lua`** - Generic methods shared across ALL scenes:
   - `checkCondition(condition)` - Evaluates conditions
   - `executeAction(action)` - Executes actions
   - `setCondition(key, value)` - Sets game state flags
   - `getCondition(key)` - Gets game state flags
   - `changeEmotion(character, state)` - Changes character emotions using objects registry

2. **Scene helpers** (e.g., `cabinScene_helpers.lua`) - Scene-specific registries and overrides:
   - `env.conditions = {}` - Condition functions for this scene
   - `env.actions = {}` - Action functions for this scene
   - `env.objects = {}` - Object state definitions (passed from scene)
   - Scene-specific method overrides (e.g., `changeObjectState` with visual effects)

3. **Scene files** (e.g., `cabinScene.lua`) - Data only:
   - String references to conditions: `condition = "hasKey"`
   - String references to actions: `action = "setHasKey"`
   - Object definitions with states: `self._objects = { elara = { states = {...} } }`

## How It Works

1. **Scene Helpers**: Define condition and action registries in `env.conditions` and `env.actions`
2. **Common Methods**: Generic `checkCondition()` and `executeAction()` look up functions in registries
3. **Scene Dialogue**: Reference conditions/actions by string name
4. **Runtime**: System looks up and executes the functions

## Defining Conditions in cabinScene_helpers.lua

All condition logic lives in the `env.conditions` registry within your scene's helper file:

```lua
-- In cabinScene_helpers.lua, inside M.attach function:
function M.attach(scene, env)
    env.state = env.state or { currentDialogueIndex = 1, isChoiceActive = false, choiceGroup = nil }

    -- Define scene-specific conditions
    env.conditions = {
        hasKey = function()
            return _G.gameData and _G.gameData.hasKey == true
        end,

        hasMagicKey = function()
            return _G.gameData and _G.gameData.hasMagicKey == true
        end,

        chestNotLooted = function()
            return not (_G.gameData and _G.gameData.chestLooted == true)
        end,

        canOpenMagicDoor = function()
            local g = _G.gameData
            return g and g.hasKey and g.hasMagicKey and g.inspectedChest
        end,
    }

    -- ... rest of attach function
end
```

## Defining Actions in cabinScene_helpers.lua

All custom action logic lives in the `env.actions` registry within your scene's helper file:

```lua
-- In cabinScene_helpers.lua, inside M.attach function:
function M.attach(scene, env)
    env.state = env.state or { currentDialogueIndex = 1, isChoiceActive = false, choiceGroup = nil }

    -- Define scene-specific actions
    env.actions = {
        setHasKey = function()
            _G.gameData = _G.gameData or {}
            _G.gameData.hasKey = true
            print("Action: Set hasKey = true")
        end,

        unlockDoor = function()
            _G.gameData = _G.gameData or {}
            _G.gameData.doorUnlocked = true
            print("Action: Door unlocked")
        end,

        givePlayerReward = function()
            _G.gameData = _G.gameData or {}
            _G.gameData.gold = (_G.gameData.gold or 0) + 100
            print("Action: Player received 100 gold")
        end,
    }

    -- ... rest of attach function
end
```

**Note**: The generic methods (`checkCondition`, `executeAction`, `setCondition`, `getCondition`) are defined in `common_helpers.lua` and are automatically available to all scenes via the metatable.

## Using Conditions and Actions in Scene Dialogue

Reference conditions by their string name in `cabinScene.lua`:## Using Conditions in Scene Dialogue

## Using Conditions and Actions in Scene Dialogue

Reference both conditions and actions by their string names in `cabinScene.lua`:

```lua
local sceneDialogue = {
    -- Execute an action (string reference)
    { type = "custom", action = "setHasKey" },

    -- Check a condition (string reference)
    { type = "object_state_conditional",
      object = "cabin_door",
      state = "open",
      condition = "hasKey" },

    -- Multiple actions in sequence
    { type = "custom", action = "unlockDoor" },
    { type = "custom", action = "markChestInspected" },

    -- Action followed by conditional check
    { type = "custom", action = "setHasMagicKey" },
    { type = "object_state_conditional",
      object = "magic_door",
      state = "open",
      condition = "canOpenMagicDoor" },
}
```## Complete Example

## Complete Example

### Step 1: Define Conditions and Actions in cabinScene_helpers.lua

```lua
-- In cabinScene_helpers.lua, inside M.attach function:

-- Conditions registry
local conditions = {
    hasKey = function()
        return _G.gameData and _G.gameData.hasKey == true
    end,

    chestNotLooted = function()
        return not (_G.gameData and _G.gameData.chestLooted == true)
    end,

    doorUnlocked = function()
        return _G.gameData and _G.gameData.doorUnlocked == true
    end,
}

-- Actions registry
local actions = {
    setHasKey = function()
        _G.gameData = _G.gameData or {}
        _G.gameData.hasKey = true
        print("Action: Set hasKey = true")
    end,

    markChestLooted = function()
        _G.gameData = _G.gameData or {}
        _G.gameData.chestLooted = true
        print("Action: Chest marked as looted")
    end,

    unlockDoor = function()
        _G.gameData = _G.gameData or {}
        _G.gameData.doorUnlocked = true
        print("Action: Door unlocked")
    end,
}
```

### Step 2: Use String References in cabinScene.lua```lua
-- Initialize game data
_G.gameData = _G.gameData or {}
_G.gameData.hasKey = false
_G.gameData.chestLooted = false
_G.gameData.doorUnlocked = false

local sceneDialogue = {
local sceneDialogue = {
    -- Setup
    { type = "narration", text = "You stand before an old cabin in the woods." },
    { type = "show", what = "cabin_door" },
    { type = "object_state", object = "cabin_door", state = "closed" },

    -- Try opening without key
    { type = "narration", text = "The door is firmly locked." },

    -- Door only opens if player has key (string reference!)
    { type = "object_state_conditional",
      object = "cabin_door",
      state = "open",
      condition = "hasKey" },

    { type = "sfx", sound = "door_creak" },

    -- Search for key
    { type = "narration", text = "You search around and find a rusty key!" },
    { type = "custom", action = function() _G.gameData.hasKey = true end },
    { type = "sfx", sound = "key_pickup" },

    -- Now try door again with condition
    { type = "narration", text = "You try the key in the lock..." },
    { type = "object_state_conditional",
      object = "cabin_door",
      state = "open",
      condition = "hasKey" },

    -- Enter cabin
    { type = "narration", text = "The door opens! You step inside." },

    -- Chest with conditional states
    { type = "narration", text = "An old chest sits in the corner." },
    { type = "show", what = "chest" },

    -- Chest unlocks only if door is unlocked
    { type = "object_state_conditional",
      object = "chest",
      state = "unlocked",
      condition = "doorUnlocked" },

    -- Chest opens only if not already looted
    { type = "object_state_conditional",
      object = "chest",
      state = "open",
      condition = "chestNotLooted" },    -- Player choice with consequences
    { type = "choice", options = {
        "Force the chest open",
        "Look for another key",
        "Leave it alone"
    }}
}
```

## Setting Default States

You can define a `defaultState` in your object registry that will be used when a conditional check fails:

```lua
self._objects = {
    cabin_door = {
        image = nil,
        states = {
            open = "images/door_open.png",
            closed = "images/door_closed.png",
            broken = "images/door_broken.png",
        },
        defaultState = "closed",  -- Used when condition is false
        x = 900, y = 380, width = 220, height = 320
    },
}
```

## Adding New Conditions

To add a new condition:

1. **Add to the conditions registry in `cabinScene_helpers.lua`:**

```lua
local conditions = {
    -- ... existing conditions ...

    playerLevel5OrHigher = function()
        return _G.gameData and _G.gameData.playerLevel >= 5
    end,

    hasAllThreeKeys = function()
        local g = _G.gameData
        return g and g.hasRedKey and g.hasBlueKey and g.hasGreenKey
    end,
}
```

2. **Reference by name in your scene dialogue:**

```lua
{ type = "object_state_conditional",
  object = "special_door",
  state = "open",
  condition = "playerLevel5OrHigher" }
```

## Advanced Examples

### Time-Based Conditions

```lua
-- In cabinScene_helpers.lua conditions registry:
thirtySecondsPassed = function()
    if not _G.gameData or not _G.gameData.startTime then
        return false
    end
    return (os.time() - _G.gameData.startTime) > 30
end,

-- In scene dialogue:
{ type = "object_state_conditional",
  object = "cabin_door",
  state = "open",
  condition = "thirtySecondsPassed" }
```

### Multiple Prerequisites

```lua
-- In cabinScene_helpers.lua:
canOpenVault = function()
    local g = _G.gameData
    return g and g.hasKey and g.knowsCode and g.hasFingerprint
end,

-- In scene dialogue:
{ type = "object_state_conditional",
  object = "vault",
  state = "open",
  condition = "canOpenVault" }
```

### Choice-Based Conditions

```lua
-- In cabinScene_helpers.lua:
choseToHelp = function()
    return _G.gameData and _G.gameData.playerChoice == 1
end,

-- In scene dialogue:
{ type = "object_state_conditional",
  object = "elara",
  state = "happy",
  condition = "choseToHelp" }
```## Debugging Conditions

Add logging to understand condition evaluation:

```lua
## Debugging Conditions

Add logging to understand condition evaluation:

```lua
-- In cabinScene_helpers.lua, modify a condition:
hasKey = function()
    local result = _G.gameData and _G.gameData.hasKey == true
    print("Condition 'hasKey' evaluated to:", result)
    return result
end,

-- Or add a debug function in the conditions registry:
debugGameState = function()
    print("=== Game State Debug ===")
    if _G.gameData then
        for k, v in pairs(_G.gameData) do
            print(k, "=", tostring(v))
        end
    else
        print("gameData is nil")
    end
    return true  -- Always returns true, just for debugging
end,
```

## Best Practices

1. **Name conditions descriptively** - `hasRedKey` is better than `condition1`
2. **Centralize logic** - All condition functions in helpers file
3. **Initialize gameData early** - Set up flags at scene start
4. **Document conditions** - Comment complex condition logic
5. **Test both paths** - Verify true and false condition outcomes
6. **Set defaults** - Define `defaultState` in object registry
7. **Use string references** - Keep dialogue clean with string conditions

## Common Patterns

### Pattern 1: Progressive Discovery
```lua
-- In cabinScene_helpers.lua:
foundMap = function()
    return _G.gameData and _G.gameData.foundMap == true
end,

-- In scene dialogue:
{ type = "object_state_conditional",
  object = "secret_door",
  state = "visible",
  condition = "foundMap" }
```

### Pattern 2: Binary State Toggle
```lua
-- In cabinScene_helpers.lua:
leverUp = function()
    return _G.gameData and _G.gameData.leverPulled == true
end,

leverDown = function()
    return not (_G.gameData and _G.gameData.leverPulled == true)
end,

-- In scene dialogue:
{ type = "object_state_conditional",
  object = "lever",
  state = "up",
  condition = "leverUp" }

{ type = "object_state_conditional",
  object = "lever",
  state = "down",
  condition = "leverDown" }
```

### Pattern 3: Complex Prerequisites
```lua
-- In cabinScene_helpers.lua:
canCastSpell = function()
    local g = _G.gameData
    return g and
           g.hasStaff and
           g.hasSpell and
           g.manaPoints >= 50 and
           g.moonPhase == "full"
end,

-- In scene dialogue:
{ type = "object_state_conditional",
  object = "magic_door",
  state = "open",
  condition = "canCastSpell" }
```

## Summary

**The key principle**:
- **Scene Dialogue** = Data (what to show, when to show it)
- **Helper File** = Logic (condition functions, scene-specific behavior)

This separation makes your scenes easier to:
- Read and understand
- Modify and maintain
- Debug and test
- Reuse across different projects
```

## Best Practices

1. **Initialize gameData early** - Set up all flags at the start of your scene
2. **Use meaningful names** - `hasRedKey` is better than `flag1`
3. **Document conditions** - Comment what each condition checks
4. **Provide feedback** - Show narration when conditions fail
5. **Test both paths** - Verify both true and false condition paths work
6. **Set defaults** - Always define `defaultState` in object registry

## Common Patterns

### Pattern 1: Progressive Discovery
```lua
-- Step 1: Object is hidden
-- Step 2: Object becomes visible after condition
-- Step 3: Object changes state based on interaction

{ type = "object_state_conditional",
  object = "secret_door",
  state = "visible",
  condition = function() return _G.gameData.foundMap end }
```

### Pattern 2: Binary State Toggle
```lua
-- Toggle between two states based on player action
{ type = "object_state_conditional",
  object = "lever",
  state = "up",
  condition = function() return _G.gameData.leverPulled end }

{ type = "object_state_conditional",
  object = "lever",
  state = "down",
  condition = function() return not _G.gameData.leverPulled end }
```

### Pattern 3: Multiple Prerequisites
```lua
-- Requires all conditions to be true
{ type = "object_state_conditional",
  object = "magic_door",
  state = "open",
  condition = function()
    local g = _G.gameData
    return g.hasStaff and g.hasSpell and g.moonPhase == "full"
  end }
```
