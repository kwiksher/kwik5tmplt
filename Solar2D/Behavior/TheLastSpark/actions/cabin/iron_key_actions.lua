-- Iron Key Actions
-- Consolidated actions for iron key object
-- Accepts action parameter to specify which key action to execute
-- Uses action_helper for common functionality

local bt = require("behaivor.btree")
local actionHelper = require("behaivor.action_helper")

-- Create action module with helper methods
local M = actionHelper.createModule()

-- Register Iron Key-specific actions
M.ACTIONS = {
    iron_key = function()
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
    print("DEBUG: Before changeState - iron_key type: " .. type(M.sceneObjects.iron_key))
    local result = M.changeState("iron_key", "visible", DisplayBase)
    print("DEBUG: After changeState - result: " .. tostring(result))
    print("DEBUG: After changeState - iron_key type: " .. type(M.sceneObjects.iron_key))
    print("DEBUG: After changeState - iron_key value: " .. tostring(M.sceneObjects.iron_key))

    -- Automatically enable tap interaction when showing iron_key
    if result == bt.SUCCESS then
        print("Iron key shown, automatically enabling tap interaction...")
        M.enableTapInteraction()
    end

    return result
end

function M.changeToCollected()
    local DisplayBase = require("views.display_base")
    local result = M.changeState("iron_key", "collected", DisplayBase)

    -- Mark as collected in object
    if M.sceneObjects and M.sceneObjects.iron_key then
        M.sceneObjects.iron_key.collected = true
    end

    return result
end

-- Enable tap interaction on iron_key
-- This allows the user to tap the iron_key to collect it
function M.enableTapInteraction()
    if not M.sceneObjects then
        print("ERROR: enableTapInteraction - sceneObjects not initialized")
        return bt.FAILED
    end

    local ironKey = M.sceneObjects.iron_key
    print("DEBUG: enableTapInteraction - ironKey type: " .. type(ironKey))
    print("DEBUG: enableTapInteraction - ironKey value: " .. tostring(ironKey))

    if not ironKey then
        print("ERROR: enableTapInteraction - iron_key object not found")
        return bt.FAILED
    end

    if type(ironKey) ~= "table" then
        print("ERROR: enableTapInteraction - iron_key is not a table, it's a " .. type(ironKey))
        return bt.FAILED
    end

    -- Create tap handler if it doesn't exist
    if not ironKey.tapHandler then
        ironKey.tapHandler = function(event)
            print("Iron key tapped! Collecting...")

            -- Call the collected action to change state
            M.changeToCollected()

            -- Disable further taps to prevent double-collection
            M.disableTapInteraction()

            -- Clear the current wait action and continue the tree
            -- The tree will naturally proceed to the next sequence with has_iron_key = true
            if M.sceneObjects and M.sceneObjects.treeController then
                timer.performWithDelay(100, function()
                    -- First, clear the wait action to unblock the tree
                    local waitAction = require("actions.cabin.wait_action")
                    if waitAction and waitAction.clearWait then
                        waitAction.clearWait()
                        print("Iron key: Cleared wait action")
                    end

                    -- Just tick to continue - don't reset
                    -- The tree's Fallback node will move to the next branch when the current one completes
                    if M.sceneObjects.treeController then
                        M.sceneObjects.treeController:tick()
                        print("Iron key: Ticked tree")
                    end
                end)
            end

            return true
        end
    end

    -- Add tap listener directly to the display object (ironKey IS the display object)
    ironKey:addEventListener("tap", ironKey.tapHandler)
    print("Tap interaction enabled for iron_key")
    return bt.SUCCESS
end

-- Disable tap interaction on iron_key
-- Removes the tap listener to prevent further interaction
function M.disableTapInteraction()
    if not M.sceneObjects then
        print("ERROR: disableTapInteraction - sceneObjects not initialized")
        return bt.FAILED
    end

    local ironKey = M.sceneObjects.iron_key
    if not ironKey then
        print("ERROR: disableTapInteraction - iron_key object not found")
        return bt.FAILED
    end

    -- Remove tap listener directly from the display object
    if ironKey.tapHandler then
        ironKey:removeEventListener("tap", ironKey.tapHandler)
        print("Tap interaction disabled for iron_key")
    end

    return bt.SUCCESS
end

return M
