-- Lumin Seed Actions (Cabin Scene)
-- Consolidated actions for Lumin Seed entity in cabin scene
-- Accepts action parameter to specify which Lumin Seed action to execute
-- Uses action_helper for common functionality

local bt = require("utils.btree")
local actionHelper = require("utils.action_helper")

-- Create action module with helper methods
local M = actionHelper.createModule()

-- Register Lumin Seed-specific actions
M.ACTIONS = {
    luminseed = function()
        return M.executeOnce("luminseed_glowing", M.changeToGlowing)
    end,

    glowing = function()
        return M.executeOnce("luminseed_glowing", M.changeToGlowing)
    end,

    collected = function()
        return M.executeOnce("luminseed_collected", M.changeToCollected)
    end,

    enable_tap_interaction = function()
        return M.executeOnce("luminseed_enable_tap", M.enableTapInteraction)
    end,

    disable_tap_interaction = function()
        return M.executeOnce("luminseed_disable_tap", M.disableTapInteraction)
    end,
}

function M.changeToGlowing()
    local DisplayBase = require("views.display_base")
    print("DEBUG: Before changeState - luminSeed type: " .. type(M.sceneObjects.luminSeed))

    -- First, make sure the object is visible
    local luminSeed = M.sceneObjects.luminSeed
    if luminSeed and not luminSeed.isVisible then
        luminSeed.isVisible = true
        luminSeed.alpha = 1
        print("Made luminSeed visible")
    end

    -- Then change to glowing state
    local result = M.changeState("luminSeed", "glowing", DisplayBase)
    print("DEBUG: After changeState - result: " .. tostring(result))
    print("DEBUG: After changeState - luminSeed type: " .. type(M.sceneObjects.luminSeed))
    print("DEBUG: After changeState - luminSeed value: " .. tostring(M.sceneObjects.luminSeed))

    -- Automatically enable tap interaction when showing luminSeed
    if result == bt.SUCCESS then
        print("Lumin seed shown, automatically enabling tap interaction...")
        M.enableTapInteraction()
    end

    return result
end

function M.changeToCollected()
    local DisplayBase = require("views.display_base")
    local result = M.changeState("luminSeed", "collected", DisplayBase)

    -- Mark as collected in object
    if M.sceneObjects and M.sceneObjects.luminSeed then
        M.sceneObjects.luminSeed.collected = true
    end

    return result
end

-- Enable tap interaction on luminSeed
-- This allows the user to tap the luminSeed to collect it
function M.enableTapInteraction()
    if not M.sceneObjects then
        print("ERROR: enableTapInteraction - sceneObjects not initialized")
        return bt.FAILED
    end

    local luminSeed = M.sceneObjects.luminSeed
    print("DEBUG: enableTapInteraction - luminSeed type: " .. type(luminSeed))
    print("DEBUG: enableTapInteraction - luminSeed value: " .. tostring(luminSeed))

    if not luminSeed then
        print("ERROR: enableTapInteraction - luminSeed object not found")
        return bt.FAILED
    end

    if type(luminSeed) ~= "table" then
        print("ERROR: enableTapInteraction - luminSeed is not a table, it's a " .. type(luminSeed))
        return bt.FAILED
    end

    -- Create tap handler if it doesn't exist
    if not luminSeed.tapHandler then
        luminSeed.tapHandler = function(event)
            print("Lumin seed tapped! Collecting...")

            -- Call the collected action to change state
            M.changeToCollected()

            -- Disable further taps to prevent double-collection
            M.disableTapInteraction()

            -- CRITICAL: Restart the behavior tree to prevent same-tick execution issues
            -- When a condition changes (lumin seed collected), we need to restart the tree
            -- from the beginning to properly evaluate the new game state
            if M.sceneObjects and M.sceneObjects.restartTree then
                print("Lumin seed collected - restarting behavior tree...")
                M.sceneObjects.restartTree()
            end

            return true
        end
    end

    -- Add tap listener directly to the display object
    luminSeed:addEventListener("tap", luminSeed.tapHandler)
    print("Tap interaction enabled for luminSeed")
    return bt.SUCCESS
end

-- Disable tap interaction on luminSeed
-- Removes the tap listener to prevent further interaction
function M.disableTapInteraction()
    if not M.sceneObjects then
        print("ERROR: disableTapInteraction - sceneObjects not initialized")
        return bt.FAILED
    end

    local luminSeed = M.sceneObjects.luminSeed
    if not luminSeed then
        print("ERROR: disableTapInteraction - luminSeed object not found")
        return bt.FAILED
    end

    -- Remove tap listener directly from the display object
    if luminSeed.tapHandler then
        luminSeed:removeEventListener("tap", luminSeed.tapHandler)
        print("Tap interaction disabled for luminSeed")
    end

    return bt.SUCCESS
end

return M
