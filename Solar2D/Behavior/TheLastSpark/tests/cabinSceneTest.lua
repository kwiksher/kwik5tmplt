-------------------------------------------------------------------------------
-- Cabin Scene Automated Test - Jump to Choices
-- Sets necessary conditions, restarts the tree, and auto-presses Next
-- using touch/tap style input (matching current button implementation).
-------------------------------------------------------------------------------

local composer = require("composer")

local M = {}

local TEST_CONFIG = {
    AUTO_CLICK_DELAY = 400,
    CHECK_DELAY = 120,
    START_DELAY = 600,
    ENABLE_DEBUG_LOGS = true,
    AUTO_ADVANCE_TO_CHOICES = true,
}

local testState = {
    autoClickTimer = nil,
    checkTimer = nil,
    testComplete = false,
}

local function log(message)
    if TEST_CONFIG.ENABLE_DEBUG_LOGS then
        print("[CABIN_TEST] " .. message)
    end
end

local function getCurrentScene()
    return composer.getScene(composer.getSceneName("current"))
end

local function stopTimers()
    if testState.autoClickTimer then
        timer.cancel(testState.autoClickTimer)
        testState.autoClickTimer = nil
    end
    if testState.checkTimer then
        timer.cancel(testState.checkTimer)
        testState.checkTimer = nil
    end
end

local function dispatchTouch(target)
    if not target then
        return false
    end

    local x = target.x or display.contentCenterX
    local y = target.y or display.contentCenterY

    if target.touch then
        target:touch({ name = "touch", phase = "began", target = target, x = x, y = y })
        target:touch({ name = "touch", phase = "ended", target = target, x = x, y = y })
        return true
    end

    if target.dispatchEvent then
        target:dispatchEvent({ name = "touch", phase = "began", target = target, x = x, y = y })
        target:dispatchEvent({ name = "touch", phase = "ended", target = target, x = x, y = y })
        return true
    end

    return false
end

local function pressNextButton()
    local scene = getCurrentScene()
    if not scene or not scene.objs or not scene.objs.nextButton then
        return false
    end

    local nextButton = scene.objs.nextButton
    if not nextButton.isVisible then
        return false
    end

    if dispatchTouch(nextButton) then
        log("Pressed Next via touch event")
        return true
    end

    if nextButton._view and dispatchTouch(nextButton._view) then
        log("Pressed Next via touch event on internal view")
        return true
    end

    if nextButton.dispatchEvent then
        nextButton:dispatchEvent({ name = "tap", target = nextButton, x = nextButton.x, y = nextButton.y })
        log("Pressed Next via tap event")
        return true
    end

    if nextButton._view and nextButton._view.dispatchEvent then
        nextButton._view:dispatchEvent({ name = "tap", target = nextButton._view, x = nextButton.x, y = nextButton.y })
        log("Pressed Next via tap event on internal view")
        return true
    end

    log("WARNING: could not dispatch touch/tap to Next button")
    return false
end

local function choicesAreVisible(scene)
    if not scene or not scene.objs or not scene.objs.choiceGroup then
        return false
    end

    local group = scene.objs.choiceGroup
    if not group.numChildren or group.numChildren == 0 then
        return false
    end

    for i = 1, group.numChildren do
        local child = group[i]
        if child and child.isVisible then
            return true
        end
    end

    return false
end

local function setupChoicesConditions()
    local scene = getCurrentScene()
    if not scene or not scene.objs then
        log("ERROR: scene not ready")
        return false
    end

    log("Setting conditions to jump to [ui show_choices]...")

    local ironKey = scene.objs.iron_key
    if ironKey then
        ironKey.collected = true
        if ironKey.modelData then
            ironKey.modelData.collected = true
            ironKey.modelData.currentState = "collected"
        end
        log("✓ iron_key marked collected")
    end

    local door = scene.objs.cabin_door
    if door and door.modelData then
        door.modelData.currentState = "open"
        log("✓ cabin_door set open")
    end

    local chest = scene.objs.chest
    if chest and chest.modelData then
        chest.modelData.currentState = "open"
        log("✓ chest set open")
    end

    local floorboard = scene.objs.loose_floorboard
    if floorboard and floorboard.modelData then
        floorboard.modelData.searched = true
        log("✓ loose_floorboard marked searched")
    end

    if scene.objs.restartTree then
        scene.objs.restartTree()
        log("✓ behavior tree restarted")
    else
        log("ERROR: restartTree not available")
        return false
    end

    return true
end

local function autoClickLoop()
    if testState.testComplete then
        return
    end
    pressNextButton()
end

function M.start()
    log("\n=== Starting Cabin Choice Jump Test ===")

    testState.testComplete = false
    stopTimers()

    timer.performWithDelay(TEST_CONFIG.START_DELAY, function()
        if not setupChoicesConditions() then
            log("✗ Failed to set conditions")
            testState.testComplete = true
            return
        end

        if TEST_CONFIG.AUTO_ADVANCE_TO_CHOICES then
            testState.autoClickTimer = timer.performWithDelay(TEST_CONFIG.AUTO_CLICK_DELAY, autoClickLoop, 0)
            testState.checkTimer = timer.performWithDelay(TEST_CONFIG.CHECK_DELAY, function()
                local scene = getCurrentScene()
                if choicesAreVisible(scene) then
                    log("✓ Reached [ui show_choices]")
                    M.stop()
                end
            end, 0)
        end
    end)
end

function M.stop()
    stopTimers()
    testState.testComplete = true
    log("Test stopped")
end

return M
