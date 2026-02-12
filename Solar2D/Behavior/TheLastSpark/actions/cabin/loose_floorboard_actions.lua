-- Loose Floorboard Actions
-- Consolidated actions for loose floorboard object
-- Accepts action parameter to specify which floorboard action to execute
-- Uses action_helper for common functionality

local bt = require("behaivor.btree")
local actionHelper = require("behaivor.action_helper")

-- Create action module with helper methods
local M = actionHelper.createModule()

-- Register Loose Floorboard-specific actions
M.ACTIONS = {
    loose_floorboard = function()
        -- Use changeToVisible instead of showObject to properly set state
        return M.changeToVisible()
    end,

    visible = function()
        return M.changeToVisible()
    end,

    highlighted = function()
        return M.changeToHighlighted()
    end,

    open = function()
        return M.changeToOpen()
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
    print("DEBUG: Before changeState - loose_floorboard type: " .. type(M.sceneObjects.loose_floorboard))
    local result = M.changeState("loose_floorboard", "visible", DisplayBase)
    print("DEBUG: After changeState - result: " .. tostring(result))
    print("DEBUG: After changeState - loose_floorboard type: " .. type(M.sceneObjects.loose_floorboard))
    print("DEBUG: After changeState - loose_floorboard value: " .. tostring(M.sceneObjects.loose_floorboard))

    -- Automatically enable tap interaction when showing loose_floorboard
    if result == bt.SUCCESS then
        print("Loose floorboard shown, automatically enabling tap interaction...")
        M.enableTapInteraction()
    end

    return result
end

function M.changeToHighlighted()
    local DisplayBase = require("views.display_base")
    return M.changeState("loose_floorboard", "highlighted", DisplayBase)
end

function M.changeToOpen()
    local DisplayBase = require("views.display_base")
    local result = M.changeState("loose_floorboard", "open", DisplayBase)

    -- Mark as searched in modelData (persists across state changes)
    if M.sceneObjects and M.sceneObjects.loose_floorboard then
        M.sceneObjects.loose_floorboard.searched = true
        if M.sceneObjects.loose_floorboard.modelData then
            M.sceneObjects.loose_floorboard.modelData.searched = true
            print("DEBUG: Set loose_floorboard.modelData.searched = true")
        end
    end

    return result
end

-- Enable tap interaction on loose_floorboard
-- This allows the user to tap the floorboard to search it
function M.enableTapInteraction()
    if not M.sceneObjects then
        print("ERROR: enableTapInteraction - sceneObjects not initialized")
        return bt.FAILED
    end

    local floorboard = M.sceneObjects.loose_floorboard
    print("DEBUG: enableTapInteraction - floorboard type: " .. type(floorboard))
    print("DEBUG: enableTapInteraction - floorboard value: " .. tostring(floorboard))

    if not floorboard then
        print("ERROR: enableTapInteraction - loose_floorboard object not found")
        return bt.FAILED
    end

    if type(floorboard) ~= "table" then
        print("ERROR: enableTapInteraction - loose_floorboard is not a table, it's a " .. type(floorboard))
        return bt.FAILED
    end

    -- Create tap handler if it doesn't exist
    if not floorboard.tapHandler then
        floorboard.tapHandler = function(event)
            print("Loose floorboard tapped! Searching...")

            -- Call the open action to change state
            M.changeToOpen()

            -- Disable further taps to prevent double-searching
            M.disableTapInteraction()

            -- CRITICAL: Restart the behavior tree to prevent same-tick execution issues
            -- When a condition changes (floorboard searched), we need to restart the tree
            -- from the beginning to properly evaluate the new game state
            if M.sceneObjects and M.sceneObjects.restartTree then
                print("Floorboard searched - restarting behavior tree...")
                M.sceneObjects.restartTree()
            end

            return true
        end
    end

    -- Add tap listener directly to the display object
    floorboard:addEventListener("tap", floorboard.tapHandler)
    print("Tap interaction enabled for loose_floorboard")
    return bt.SUCCESS
end

-- Disable tap interaction on loose_floorboard
-- Removes the tap listener to prevent further interaction
function M.disableTapInteraction()
    if not M.sceneObjects then
        print("ERROR: disableTapInteraction - sceneObjects not initialized")
        return bt.FAILED
    end

    local floorboard = M.sceneObjects.loose_floorboard
    if not floorboard then
        print("ERROR: disableTapInteraction - loose_floorboard object not found")
        return bt.FAILED
    end

    -- Remove tap listener directly from the display object
    if floorboard.tapHandler then
        floorboard:removeEventListener("tap", floorboard.tapHandler)
        print("Tap interaction disabled for loose_floorboard")
    end

    return bt.SUCCESS
end

return M
