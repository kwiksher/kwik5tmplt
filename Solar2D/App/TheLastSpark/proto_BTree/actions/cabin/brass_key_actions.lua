-- Brass Key Actions
-- Consolidated actions for brass key object
-- Accepts action parameter to specify which key action to execute
-- Uses action_helper for common functionality

local bt = require("utils.btree")
local actionHelper = require("utils.action_helper")

-- Create action module with helper methods
local M = actionHelper.createModule()

-- Register Brass Key-specific actions
M.ACTIONS = {
    brass_key = function()
        -- Use changeToVisible instead of showObject to properly set state
        return M.changeToVisible()
    end,

    visible = function()
        return M.changeToVisible()
    end,

    collected = function()
        return M.changeToCollected()
    end,

    enable_tap_interaction = function()
        return M.enableTapInteraction()
    end,

    disable_tap_interaction = function()
        return M.disableTapInteraction()
    end,
}

function M.changeToVisible()
    local DisplayBase = require("views.display_base")
    print("DEBUG: Before changeState - brass_key type: " .. type(M.sceneObjects.brass_key))
    local result = M.changeState("brass_key", "visible", DisplayBase)
    print("DEBUG: After changeState - result: " .. tostring(result))
    print("DEBUG: After changeState - brass_key type: " .. type(M.sceneObjects.brass_key))
    print("DEBUG: After changeState - brass_key value: " .. tostring(M.sceneObjects.brass_key))

    -- Automatically enable tap interaction when showing brass_key
    if result == bt.SUCCESS then
        print("Brass key shown, automatically enabling tap interaction...")
        M.enableTapInteraction()
    end

    return result
end

function M.changeToCollected()
    local DisplayBase = require("views.display_base")
    local result = M.changeState("brass_key", "collected", DisplayBase)

    -- Mark as collected in object
    if M.sceneObjects and M.sceneObjects.brass_key then
        M.sceneObjects.brass_key.collected = true
    end

    return result
end

-- Enable tap interaction on brass_key
-- This allows the user to tap the brass_key to collect it
function M.enableTapInteraction()
    if not M.sceneObjects then
        print("ERROR: enableTapInteraction - sceneObjects not initialized")
        return bt.FAILED
    end

    local brassKey = M.sceneObjects.brass_key
    print("DEBUG: enableTapInteraction - brassKey type: " .. type(brassKey))
    print("DEBUG: enableTapInteraction - brassKey value: " .. tostring(brassKey))

    if not brassKey then
        print("ERROR: enableTapInteraction - brass_key object not found")
        return bt.FAILED
    end

    if type(brassKey) ~= "table" then
        print("ERROR: enableTapInteraction - brass_key is not a table, it's a " .. type(brassKey))
        return bt.FAILED
    end

    -- Create tap handler if it doesn't exist
    if not brassKey.tapHandler then
        brassKey.tapHandler = function(event)
            print("Brass key tapped! Collecting...")

            -- Call the collected action to change state
            M.changeToCollected()

            -- Disable further taps to prevent double-collection
            M.disableTapInteraction()

            -- CRITICAL: Restart the behavior tree to prevent same-tick execution issues
            -- When a condition changes (brass key collected), we need to restart the tree
            -- from the beginning to properly evaluate the new game state
            if M.sceneObjects and M.sceneObjects.restartTree then
                print("Brass key collected - restarting behavior tree...")
                M.sceneObjects.restartTree()
            end

            return true
        end
    end

    -- Add tap listener directly to the display object (brassKey IS the display object)
    brassKey:addEventListener("tap", brassKey.tapHandler)
    print("Tap interaction enabled for brass_key")
    return bt.SUCCESS
end

-- Disable tap interaction on brass_key
-- Removes the tap listener to prevent further interaction
function M.disableTapInteraction()
    if not M.sceneObjects then
        print("ERROR: disableTapInteraction - sceneObjects not initialized")
        return bt.FAILED
    end

    local brassKey = M.sceneObjects.brass_key
    if not brassKey then
        print("ERROR: disableTapInteraction - brass_key object not found")
        return bt.FAILED
    end

    -- Remove tap listener directly from the display object
    if brassKey.tapHandler then
        brassKey:removeEventListener("tap", brassKey.tapHandler)
        print("Tap interaction disabled for brass_key")
    end

    return bt.SUCCESS
end

return M
