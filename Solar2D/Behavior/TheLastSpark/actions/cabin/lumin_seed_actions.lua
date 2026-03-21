-- Lumin Seed Actions (Cabin Scene)
-- Consolidated actions for Lumin Seed entity in cabin scene
-- Accepts action parameter to specify which Lumin Seed action to execute
-- Uses action_helper for common functionality

local bt = require("behaivor.btree")
local actionHelper = require("behaivor.action_helper")

-- Create action module with helper methods
local M = actionHelper.createModule()

-- Register Lumin Seed-specific actions
M.ACTIONS = {
    luminseed = function()
        return M.executeOnce("lumin_seed_glowing", M.changeToGlowing)
    end,

    glowing = function()
        return M.executeOnce("lumin_seed_glowing", M.changeToGlowing)
    end,

    collected = function()
        return M.executeOnce("lumin_seed_collected", M.changeToCollected)
    end,

    enable_tap_interaction = function()
        return M.executeOnce("lumin_seed_enable_tap", M.enableTapInteraction)
    end,

    disable_tap_interaction = function()
        return M.executeOnce("lumin_seed_disable_tap", M.disableTapInteraction)
    end,
}

function M.changeToGlowing()
    local DisplayBase = require("behaivor.display_base_common")
    print("DEBUG: Before changeState - lumin_seed type: " .. type(M.sceneObjects.lumin_seed))

    -- First, make sure the object is visible
    local lumin_seed = M.sceneObjects.lumin_seed
    if lumin_seed and not lumin_seed.isVisible then
        lumin_seed.isVisible = true
        lumin_seed.alpha = 1
        print("Made lumin_seed visible")
    end

    -- Then change to glowing state
    local result = M.changeState("lumin_seed", "glowing", DisplayBase)
    print("DEBUG: After changeState - result: " .. tostring(result))
    print("DEBUG: After changeState - lumin_seed type: " .. type(M.sceneObjects.lumin_seed))
    print("DEBUG: After changeState - lumin_seed value: " .. tostring(M.sceneObjects.lumin_seed))

    if result == bt.SUCCESS then
        print("Lumin seed shown, automatically enabling tap interaction...")
        M.enableTapInteraction()
    end

    return result
end

function M.changeToCollected()
    local DisplayBase = require("behaivor.display_base_common")
    local result = M.changeState("lumin_seed", "collected", DisplayBase)

    -- Mark as collected in object
    if M.sceneObjects and M.sceneObjects.lumin_seed then
        M.sceneObjects.lumin_seed.collected = true
    end

    return result
end

-- Enable tap interaction on lumin_seed
-- This allows the user to tap the lumin_seed to collect it
function M.enableTapInteraction()
    if not M.sceneObjects then
        print("ERROR: enableTapInteraction - sceneObjects not initialized")
        return bt.FAILED
    end

    local lumin_seed = M.sceneObjects.lumin_seed
    print("DEBUG: enableTapInteraction - lumin_seed type: " .. type(lumin_seed))
    print("DEBUG: enableTapInteraction - lumin_seed value: " .. tostring(lumin_seed))

    if not lumin_seed then
        print("ERROR: enableTapInteraction - lumin_seed object not found")
        return bt.FAILED
    end

    if type(lumin_seed) ~= "table" then
        print("ERROR: enableTapInteraction - lumin_seed is not a table, it's a " .. type(lumin_seed))
        return bt.FAILED
    end

    -- Create tap handler if it doesn't exist
    if not lumin_seed.tapHandler then
        lumin_seed.tapHandler = function(event)
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
    lumin_seed:addEventListener("tap", lumin_seed.tapHandler)
    print("Tap interaction enabled for lumin_seed")
    return bt.SUCCESS
end

-- Disable tap interaction on lumin_seed
-- Removes the tap listener to prevent further interaction
function M.disableTapInteraction()
    if not M.sceneObjects then
        print("ERROR: disableTapInteraction - sceneObjects not initialized")
        return bt.FAILED
    end

    local lumin_seed = M.sceneObjects.lumin_seed
    if not lumin_seed then
        print("ERROR: disableTapInteraction - lumin_seed object not found")
        return bt.FAILED
    end

    -- Remove tap listener directly from the display object
    if lumin_seed.tapHandler then
        lumin_seed:removeEventListener("tap", lumin_seed.tapHandler)
        print("Tap interaction disabled for lumin_seed")
    end

    return bt.SUCCESS
end

return M
