-------------------------------------------------------------------------------
-- Cabin Scene Automated Test - Jump to Choices
-- Sets all necessary conditions to jump directly to [ui show_choices]
-------------------------------------------------------------------------------

local composer = require("composer")

local M = {}

-- Test configuration
local TEST_CONFIG = {
    AUTO_CLICK_DELAY = 500,  -- ms between auto-clicks
    ENABLE_DEBUG_LOGS = true,
    JUMP_TO_CHOICES = true,  -- Skip to the choices immediately
    AUTO_ADVANCE_TO_CHOICES = true,  -- Auto-click Next until choices appear
}

-- Test state
local testState = {
    autoClickTimer = nil,
    checkTimer = nil,
    ironKeyTapped = false,
    testComplete = false,
}

-- Debug logging
local function log(message)
    if TEST_CONFIG.ENABLE_DEBUG_LOGS then
        print("[TEST] " .. message)
    end
end

-- Check if iron_key is visible
local function isIronKeyVisible(scene)
    if not scene or not scene.objs then
        log("DEBUG: Scene or objs not found")
        return false
    end

    local ironKey = scene.objs.iron_key
    if not ironKey then
        log("DEBUG: iron_key display object not found")
        return false
    end

    -- Display objects have modelData property, not direct model properties
    local modelData = ironKey.modelData
    if not modelData then
        log("DEBUG: iron_key.modelData not found")
        return false
    end

    -- Debug: Check all properties
    log("DEBUG: iron_key.modelData.currentState = " .. tostring(modelData.currentState))
    log("DEBUG: iron_key.modelData.visible = " .. tostring(modelData.visible))
    log("DEBUG: iron_key.isVisible = " .. tostring(ironKey.isVisible))

    -- Check if state is visible and model says it's visible
    if modelData.currentState == "visible" and modelData.visible then
        log("DEBUG: Iron key modelData state is visible and visible flag is true")

        -- Also check if the display object itself is visible
        if ironKey.isVisible then
            log("DEBUG: Iron key display object isVisible = true")
            return true
        else
            log("DEBUG: Iron key display object isVisible = false")
            return false
        end
    end

    log("DEBUG: Iron key not in visible state (currentState=" .. tostring(modelData.currentState) .. ", visible=" .. tostring(modelData.visible) .. ")")
    return false
end

-- Auto-click the Next button by calling its callback
local function autoClickNext()
    local scene = composer.getScene(composer.getSceneName("current"))
    if not scene then
        return false
    end

    -- Check if next button is visible
    if scene.objs and scene.objs.nextButton and scene.objs.nextButton.isVisible then
        log("Auto-clicking Next button...")

        -- The Next button's callback was registered in initializeDialogueInterface
        -- which is in cabinScene.lua line 105-116
        -- It clears wait states and ticks the tree

        -- Clear the wait state
        local waitActionModule = require("actions.cabin.wait_action")
        if waitActionModule and waitActionModule.clearWait then
            waitActionModule.clearWait()
        end

        -- Clear choice action wait state
        local choiceActionModule = require("actions.cabin.choice_action")
        if choiceActionModule and choiceActionModule.clearWait then
            choiceActionModule.clearWait()
        end

        -- Tick the tree
        if scene.treeController and not scene.treeController.isComplete then
            scene.treeController:tick()
        end

        return true
    end

    return false
end

-- Tap the iron_key
local function tapIronKey()
    log("Attempting to tap iron_key...")

    local scene = composer.getScene(composer.getSceneName("current"))
    if not scene or not scene.objs then
        log("ERROR: Scene or objs not found")
        return false
    end

    local ironKey = scene.objs.iron_key
    if not ironKey or not ironKey.image then
        log("ERROR: iron_key object not found")
        return false
    end

    if not ironKey.tapHandler then
        log("ERROR: iron_key has no tap handler")
        return false
    end

    log("Simulating tap on iron_key...")

    -- Create and fire tap event
    local event = {
        name = "tap",
        target = ironKey.image,
        x = ironKey.image.x,
        y = ironKey.image.y,
    }

    ironKey.tapHandler(event)
    testState.ironKeyTapped = true
    log("✓ Iron key tapped")

    return true
end

-- Verify test results
local function verifyTestResults()
    log("\n=== Test Results ===")

    local scene = composer.getScene(composer.getSceneName("current"))
    if not scene or not scene.objs then
        log("✗ FAIL: Scene not accessible")
        return false
    end

    local ironKey = scene.objs.iron_key
    if not ironKey then
        log("✗ FAIL: iron_key object not found")
        return false
    end

    -- Check collection state
    if ironKey.collected == true then
        log("✓ PASS: iron_key.collected = true")
    else
        log("✗ FAIL: iron_key.collected = false")
        return false
    end

    -- Check condition
    local conditionController = scene.conditionController
    if conditionController then
        local hasIronKeyModule = require("conditions.cabin.has_iron_key")
        hasIronKeyModule.initialize(scene.objs)
        local hasKey = hasIronKeyModule.evaluate()

        if hasKey then
            log("✓ PASS: 'has iron key' condition = true")
        else
            log("✗ FAIL: 'has iron key' condition = false")
            return false
        end
    end

    log("✓ ALL TESTS PASSED")
    log("===================\n")

    return true
end

-- Main test loop - checks for iron_key visibility
local function checkForIronKey()
    log("DEBUG: checkForIronKey() called")

    if testState.testComplete or testState.ironKeyTapped then
        log("DEBUG: Skipping check - testComplete or ironKeyTapped")
        return
    end

    local scene = composer.getScene(composer.getSceneName("current"))
    if not scene then
        log("DEBUG: Scene not found")
        return
    end

    log("DEBUG: Calling isIronKeyVisible...")
    -- Check if iron_key is visible
    if isIronKeyVisible(scene) then
        log("✓ Iron key is visible!")

        -- Mark that we found it (stop checking)
        testState.ironKeyTapped = true

        -- Stop both timers
        if testState.autoClickTimer then
            timer.cancel(testState.autoClickTimer)
            testState.autoClickTimer = nil
        end

        if testState.checkTimer then
            timer.cancel(testState.checkTimer)
            testState.checkTimer = nil
        end

        -- Wait a moment, then tap
        timer.performWithDelay(300, function()
            if tapIronKey() then
                -- Verify after a delay
                timer.performWithDelay(500, function()
                    testState.testComplete = true
                    verifyTestResults()
                end)
            else
                log("✗ FAIL: Could not tap iron_key")
                testState.testComplete = true
            end
        end)
    end
end

-- Auto-click loop - clicks Next button
local function autoClickLoop()
    log("DEBUG: autoClickLoop() called")

    if testState.testComplete or testState.ironKeyTapped then
        log("DEBUG: Skipping auto-click - testComplete or ironKeyTapped")
        return
    end

    autoClickNext()
end

-- Check if choices UI is visible
local function areChoicesVisible(scene)
    if not scene or not scene.objs then
        return false
    end

    -- Check if any choice buttons are visible
    -- The choice buttons should be created by showChoiceButtons
    if scene.objs.choicesVisible then
        log("Choices are visible!")
        return true
    end

    return false
end

-- Set conditions to jump to choices
local function setupChoicesConditions()
    local scene = composer.getScene(composer.getSceneName("current"))
    if not scene or not scene.objs then
        log("ERROR: Scene not ready")
        return false
    end

    log("Setting up conditions to jump to [ui show_choices]...")

    -- Set iron_key as collected
    if scene.objs.iron_key then
        scene.objs.iron_key.modelData.collected = true
        log("✓ Set iron_key.modelData.collected = true")
    end

    -- Set door as open
    if scene.objs.cabin_door then
        scene.objs.cabin_door.modelData.currentState = "open"
        log("✓ Set cabin_door.modelData.currentState = 'open'")
    end

    -- Set chest as open
    if scene.objs.chest then
        scene.objs.chest.modelData.currentState = "open"
    log("All conditions set! Restarting behavior tree...")

    -- Restart the behavior tree to re-evaluate from the beginning
    if scene.objs.restartTree then
        scene.objs.restartTree()
        log("✓ Behavior tree restarted")
    end

    -- Start auto-clicking to advance through the sequence
    if TEST_CONFIG.AUTO_ADVANCE_TO_CHOICES then
        log("Starting auto-click to advance to choices...")
        testState.autoClickTimer = timer.performWithDelay(
            TEST_CONFIG.AUTO_CLICK_DELAY,
            autoClickLoop,
            0  -- Repeat indefinitely
        )

        testState.checkTimer = timer.performWithDelay(
            100,  -- Check every 100ms
            function()
                local currentScene = composer.getScene(composer.getSceneName("current"))
                if areChoicesVisible(currentScene) then
                    log("✓ Reached [ui show_choices]!")
                    M.stop()
                end
            end,
            0  -- Repeat indefinitely
        )
    end

    return true
end
    -- Set floorboard as searched
    if scene.objs.loose_floorboard then
        scene.objs.loose_floorboard.modelData.searched = true
        log("✓ Set loose_floorboard.modelData.searched = true")
    end

    log("All conditions set! Restarting behavior tree...")

    -- Restart the behavior tree to re-evaluate from the beginning
    if scene.objs.restartTree then
        scene.objs.restartTree()
        log("✓ Behavior tree restarted")
    end

    return true
end

-- Start the test
function M.start()
    if TEST_CONFIG.JUMP_TO_CHOICES then
        log("\n=== Starting Cabin Test - Jump to Choices ===")
        log("Will set all conditions and jump to [ui show_choices]")
        log("============================================\n")
    else
        log("\n=== Starting Iron Key Test ===")
        log("Will auto-click Next until iron_key appears")
        log("==============================\n")
    end

    -- Reset state
    testState.ironKeyTapped = false
    testState.testComplete = false

    -- If jumping to choices, set up conditions after scene is ready
    if TEST_CONFIG.JUMP_TO_CHOICES then
        timer.performWithDelay(500, function()
            if setupChoicesConditions() then
                log("\n✓ Ready for choices - behavior tree should show [ui show_choices]")
                log("Press Next button to advance through the sequence\n")
            else
                log("✗ Failed to setup conditions")
            end
        end)
        return
    end

    log("DEBUG: Starting auto-click timer...")
    -- Start auto-click loop (clicks Next button)
    testState.autoClickTimer = timer.performWithDelay(
        TEST_CONFIG.AUTO_CLICK_DELAY,
        autoClickLoop,
        0  -- Repeat indefinitely
    )
    log("DEBUG: Auto-click timer started: " .. tostring(testState.autoClickTimer))

    log("DEBUG: Starting check timer...")
    -- Start check loop (checks for iron_key) - runs more frequently
    testState.checkTimer = timer.performWithDelay(
        100,  -- Check every 100ms
        checkForIronKey,
        0  -- Repeat indefinitely
    )
    log("DEBUG: Check timer started: " .. tostring(testState.checkTimer))

    log("Test started - both timers running")
end

-- Stop the test
function M.stop()
    if testState.autoClickTimer then
        timer.cancel(testState.autoClickTimer)
        testState.autoClickTimer = nil
    end
    if testState.checkTimer then
        timer.cancel(testState.checkTimer)
        testState.checkTimer = nil
    end
    testState.testComplete = true
    log("Test stopped")
end

return M