-- Focus Actions (Cabin Scene)
-- Consolidated actions for focus management
-- Accepts action parameter to specify which focus action
-- Uses action_helper for common functionality

local bt = require("behaivor.btree")
local actionHelper = require("behaivor.action_helper")

-- Create action module with helper methods
local M = actionHelper.createModule()

-- Register Focus-specific actions
M.ACTIONS = {
    cabin_door = function()
        return M.focusOnObject("cabin_door")
    end,

    boarded_window = function()
        return M.focusOnObject("boarded_window")
    end,

    arcane_markings = function()
        return M.focusOnObject("arcane_markings")
    end,

    chest = function()
        return M.focusOnObject("chest")
    end,

    elara = function()
        return M.focusOnObject("elara")
    end,
}

-- Helper function to focus on an object
function M.focusOnObject(objectName)
    -- Special cases for non-display objects
    if objectName == "boarded_window" or objectName == "arcane_markings" then
        print("Focusing on " .. objectName .. " (special object)")
        -- Could add camera pan/zoom effects here if needed
        return bt.SUCCESS
    end

    if not M.checkObject(objectName) then
        -- Even if object doesn't exist, we might want to focus on that area
        print("Focusing on " .. objectName .. " (area)")
        return bt.SUCCESS
    end

    -- Focus camera on object
    print("Focusing on " .. objectName)
    return bt.SUCCESS
end

return M
