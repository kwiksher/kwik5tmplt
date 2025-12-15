# Quick Reference: Conditional Object States & Actions

## TL;DR

1. **Define condition/action registries** in scene helpers (e.g., `cabinScene_helpers.lua`)
2. **Methods live in common_helpers** - shared across all scenes
3. **Reference by name** in scene dialogue (e.g., `cabinScene.lua`)
4. **Use strings**, not functions, in scene dialogue

---

## Architecture

```
common_helpers.lua
  ├── checkCondition()      ← Generic method (all scenes)
  ├── executeAction()       ← Generic method (all scenes)
  ├── setCondition()        ← Generic method (all scenes)
  ├── getCondition()        ← Generic method (all scenes)
  └── changeEmotion()       ← Generic method (all scenes)

cabinScene_helpers.lua
  ├── env.conditions = {}   ← Scene-specific registry
  ├── env.actions = {}      ← Scene-specific registry
  └── changeObjectState()   ← Cabin-specific visual effects

forestScene_helpers.lua
  ├── env.conditions = {}   ← Scene-specific registry
  ├── env.actions = {}      ← Scene-specific registry
  └── showObject()          ← Forest-specific behavior

cabinScene.lua / forestScene.lua
  ├── { condition = "hasKey" }     ← String references
  ├── { action = "setHasKey" }     ← String references
  └── { type = "emotion", character = "elara", state = "scared" }
```

---

## Adding a New Condition (3 Steps)

## Adding a New Condition (3 Steps)

### Step 1: Define in your scene's helper file (e.g., cabinScene_helpers.lua)

```lua
-- Inside M.attach function, add to env.conditions registry:
env.conditions = {
    -- ... existing conditions ...

    myNewCondition = function()
        return _G.gameData and _G.gameData.someFlag == true
    end,
}
```

### Step 2: Set the flag somewhere

```lua
-- In scene dialogue (using string reference):
{ type = "custom", action = "setSomeFlag" },
```

### Step 3: Use in scene dialogue

```lua
-- Reference by string name:
{ type = "object_state_conditional",
  object = "door",
  state = "open",
  condition = "myNewCondition" }  -- ← String, not function!
```

---

## Adding a New Action (2 Steps)

### Step 1: Define in your scene's helper file (e.g., cabinScene_helpers.lua)

```lua
-- Inside M.attach function, add to env.actions registry:
env.actions = {
    -- ... existing actions ...

    myNewAction = function()
        _G.gameData = _G.gameData or {}
        _G.gameData.someValue = 100
        print("Action: Set someValue = 100")
    end,
}
```### Step 2: Use in scene dialogue

```lua
-- Reference by string name:
{ type = "custom", action = "myNewAction" }  -- ← String, not function!
```

---

## Quick Examples

### Execute an Action
```lua
-- Helper:
setHasKey = function()
    _G.gameData = _G.gameData or {}
    _G.gameData.hasKey = true
    print("Action: Set hasKey = true")
end,

-- Dialogue:
{ type = "custom", action = "setHasKey" }
```### Simple Flag Check
```lua
-- Helper:
hasKey = function()
    return _G.gameData and _G.gameData.hasKey == true
end,

-- Dialogue:
{ type = "object_state_conditional", object = "door", state = "open", condition = "hasKey" }
```

### Multiple Conditions
```lua
-- Helper:
canOpenVault = function()
    local g = _G.gameData
    return g and g.hasKey and g.knowsCode and g.hasFingerprint
end,

-- Dialogue:
{ type = "object_state_conditional", object = "vault", state = "open", condition = "canOpenVault" }
```

### Inverted Condition
```lua
-- Helper:
chestNotLooted = function()
    return not (_G.gameData and _G.gameData.chestLooted == true)
end,

-- Dialogue:
{ type = "object_state_conditional", object = "chest", state = "full", condition = "chestNotLooted" }
```

### Time-Based
```lua
-- Helper:
tenSecondsPassed = function()
    if not _G.gameData or not _G.gameData.startTime then
        return false
    end
    return (os.time() - _G.gameData.startTime) > 10
end,

-- Dialogue:
{ type = "object_state_conditional", object = "door", state = "open", condition = "tenSecondsPassed" }
```

### Choice-Based
```lua
-- Helper:
playerChoseOption1 = function()
    return _G.gameData and _G.gameData.playerChoice == 1
end,

-- Dialogue:
{ type = "object_state_conditional", object = "elara", state = "happy", condition = "playerChoseOption1" }
```

---

## Common Mistakes

❌ **DON'T do this in dialogue:**
```lua
// Inline function for condition - Bad!
{ type = "object_state_conditional",
  object = "door",
  state = "open",
  condition = function() return _G.gameData.hasKey end }

// Inline function for action - Bad!
{ type = "custom",
  action = function() _G.gameData.hasKey = true end }
```

✅ **DO this instead:**
```lua
// 1. Define in helper:
-- Conditions
hasKey = function()
    return _G.gameData and _G.gameData.hasKey == true
end,

-- Actions
setHasKey = function()
    _G.gameData = _G.gameData or {}
    _G.gameData.hasKey = true
end,

// 2. Reference in dialogue:
{ type = "custom", action = "setHasKey" }  -- ← String! Good!
{ type = "object_state_conditional",
  object = "door",
  state = "open",
  condition = "hasKey" }  -- ← String! Good!
```

---

## File Structure

```
cabinScene_helpers.lua     ← ALL logic here
    ↓
    local conditions = {
        hasKey = function() ... end,
        canOpenDoor = function() ... end,
    }

    local actions = {
        setHasKey = function() ... end,
        unlockDoor = function() ... end,
    }

cabinScene.lua             ← Only string references here
    ↓
    { action = "setHasKey" }
    { condition = "hasKey" }
    { condition = "canOpenDoor" }
```---

## Debugging Template

```lua
-- Add to conditions registry for debugging:
debugState = function()
    print("=== DEBUG: Game State ===")
    if _G.gameData then
        for k, v in pairs(_G.gameData) do
            print(k, "=", tostring(v))
        end
    else
        print("gameData is nil!")
    end
    return true  -- Always true, just for logging
end,

-- Use in dialogue:
{ type = "object_state_conditional",
  object = "debug_marker",
  state = "visible",
  condition = "debugState" }
```

---

## Complete Workflow Example

```lua
// 1. Define in cabinScene_helpers.lua:

local actions = {
    findKey = function()
        _G.gameData = _G.gameData or {}
        _G.gameData.hasKey = true
        print("Action: Found the key!")
    end,
}

local conditions = {
    hasKey = function()
        return _G.gameData and _G.gameData.hasKey == true
    end,
}

// 2. Use in cabinScene.lua:

local sceneDialogue = {
    { type = "narration", text = "You search the room..." },
    { type = "custom", action = "findKey" },  -- Execute action
    { type = "narration", text = "You found a key!" },

    { type = "object_state_conditional",      -- Check condition
      object = "door",
      state = "open",
      condition = "hasKey" },
}
```

---

## Benefits of This Approach

✅ **Clean dialogue** - No complex logic in scene data
✅ **Reusable** - Same condition/action used multiple times
✅ **Maintainable** - All logic in one place
✅ **Testable** - Easy to modify behavior
✅ **Readable** - String names are self-documenting
✅ **Debuggable** - Add logging in one place

---

## Remember

- Conditions = **strings** in dialogue (checked, return boolean)
- Actions = **strings** in dialogue (executed, change state)
- Logic = **functions** in helpers
- Separation = **good architecture**
