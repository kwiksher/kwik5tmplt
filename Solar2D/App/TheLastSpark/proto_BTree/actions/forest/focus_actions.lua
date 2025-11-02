-- Focus Actions
-- Consolidated actions for focus management
-- Accepts action parameter to specify which focus action
-- Uses action_helper for common functionality

local bt = require("btree")
local actionHelper = require("utils.action_helper")

-- Create action module with helper methods
local M = actionHelper.new()

-- Register Focus-specific actions
M.ACTIONS = {
    wolf = function()
        return M.focusOnObject("wolf")
    end,

    elara = function()
        return M.focusOnObject("elara")
    end,

    cabin = function()
        return M.focusOnObject("cabin")
    end,
}

-- Helper function to focus on an object
function M.focusOnObject(objectName)
    if not M.checkObject(objectName) then
        return bt.FAILED
    end

    -- Focus camera on object
    -- This would typically move camera to focus on the object
    print("Focusing on " .. objectName)
    return bt.SUCCESS
end

return M