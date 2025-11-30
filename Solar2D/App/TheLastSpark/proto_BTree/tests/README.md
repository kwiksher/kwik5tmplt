# Proto BTree Tests

Automated tests for the Behavior Tree implementation.

## Cabin Scene Test

### Overview
[`cabinScene.test.lua`](Solar2D/App/TheLastSpark/proto_BTree/tests/cabinScene.test.lua) - Automated test for iron key tap interaction.

**What it tests:**
1. ✅ Auto-progresses through the behavior tree until `[scene cabin_door]`
2. ✅ Continues auto-clicking "next" until iron_key becomes visible
3. ✅ Simulates a tap on the iron_key object
4. ✅ Verifies that `iron_key.collected = true`
5. ✅ Verifies that `has iron key` condition returns true

### How to Run

#### Method 1: From main.lua (Recommended)
Add this code to your [`main.lua`](Solar2D/App/TheLastSpark/proto_BTree/main.lua) after the cabin scene loads:

```lua
-- Load cabin scene
composer.gotoScene("views.cabin.cabinScene", { time = 300, effect = "fade" })

-- Start automated test after scene loads
timer.performWithDelay(1000, function()
    local cabinTest = require("tests.cabinScene.test")
    cabinTest.start()
end)
```

#### Method 2: From Console
If you have a console/debug panel:

```lua
local cabinTest = require("tests.cabinScene.test")
cabinTest.start()
```

#### Method 3: Keyboard Shortcut
Add a keyboard listener to start the test:

```lua
local function onKeyEvent(event)
    if event.phase == "up" and event.keyName == "t" then
        local cabinTest = require("tests.cabinScene.test")
        if cabinTest.isRunning() then
            cabinTest.stop()
        else
            cabinTest.start()
        end
    end
end
Runtime:addEventListener("key", onKeyEvent)
```

### Test Configuration

You can modify test behavior in [`cabinScene.test.lua`](Solar2D/App/TheLastSpark/proto_BTree/tests/cabinScene.test.lua):

```lua
local TEST_CONFIG = {
    AUTO_PROGRESS_DELAY = 500,  -- ms between auto-clicks (adjust for speed)
    SCENE_NAME = "views.cabin.cabinScene",
    TARGET_SCENE_ACTION = "cabin_door",  -- Scene to stop at
    ENABLE_DEBUG_LOGS = true,  -- Set false to disable verbose logging
}
```

### Expected Output

When running successfully, you should see console output like:

```
[TEST] === Starting Cabin Scene Iron Key Test ===
[TEST] Configuration:
[TEST]   - Auto-progress delay: 500ms
[TEST]   - Target scene: cabin_door
[TEST] ==========================================

[TEST] Auto-progressing to target scene...
[TEST] Current action: narration cabin_exterior
[TEST] Auto-clicking next button...
...
[TEST] ✓ Target scene reached: cabin_door
[TEST] Iron key not visible yet, continuing auto-progress...
[TEST] Auto-clicking next button...
...
[TEST] ✓ Iron key is visible
[TEST] Simulating tap on iron_key...
[TEST] ✓ Iron key tap simulated
[TEST]
[TEST] === Test Results ===
[TEST] ✓ PASS: iron_key.collected = true
[TEST] ✓ PASS: 'has iron key' condition = true
[TEST] ✓ ALL TESTS PASSED
[TEST] ===================
```

### Test Controls

```lua
local cabinTest = require("tests.cabinScene.test")

-- Start the test
cabinTest.start()

-- Stop the test (if needed)
cabinTest.stop()

-- Check if test is running
local running = cabinTest.isRunning()

-- Get test results
local results = cabinTest.getResults()
-- results = {
--     targetReached = true/false,
--     ironKeyTapped = true/false,
--     testComplete = true/false,
-- }
```

### Troubleshooting

**Test not progressing:**
- Ensure the cabin scene is fully loaded before starting
- Check that `scene.objs.nextButton` exists and is accessible
- Verify behavior tree is initialized

**Iron key not tapping:**
- Ensure `enable_tap_interaction` action is in your behavior tree before the key becomes visible
- Check that iron_key object exists in `scene.objs`
- Verify tap handler is attached (check `ironKey.tapHandler`)

**Condition not triggering:**
- Verify [`has_iron_key.lua`](Solar2D/App/TheLastSpark/proto_BTree/conditions/cabin/has_iron_key.lua) is properly initialized
- Check that `iron_key.collected` is being set to true
- Ensure condition controller is accessible from scene

### Files Tested

- **Action Module**: [`actions/cabin/iron_key_actions.lua`](Solar2D/App/TheLastSpark/proto_BTree/actions/cabin/iron_key_actions.lua)
- **Condition Module**: [`conditions/cabin/has_iron_key.lua`](Solar2D/App/TheLastSpark/proto_BTree/conditions/cabin/has_iron_key.lua)
- **Scene**: [`views/cabin/cabinScene.lua`](Solar2D/App/TheLastSpark/proto_BTree/views/cabin/cabinScene.lua)
- **Behavior Tree**: [`cabin_scene.tree`](Solar2D/App/TheLastSpark/proto_BTree/cabin_scene.tree)

## Adding More Tests

To create additional tests, follow this pattern:

1. Create a new test file in `tests/` directory
2. Implement `start()`, `stop()`, `isRunning()` functions
3. Use timer-based automation for UI interactions
4. Verify results and log pass/fail status
5. Document usage in this README