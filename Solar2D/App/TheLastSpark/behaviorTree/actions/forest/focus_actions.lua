-- Focus Actions
-- Consolidated actions for focus management
-- Accepts action parameter to specify which focus action
-- Uses action_helper for common functionality

local bt = require("utils.btree")
local actionHelper = require("utils.action_helper")

-- Create action module with helper methods
local M = actionHelper.createModule()

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
    -- Special case: cabin is the background, not a display object
    if objectName == "cabin" then
        print("Focusing on cabin (background)")
        -- Could add camera pan/zoom effects here if needed
        return bt.SUCCESS
    end

    if not M.checkObject(objectName) then
        return bt.FAILED
    end

    -- Focus camera on object
    -- This would typically move camera to focus on the object
    print("Focusing on " .. objectName)
    return bt.SUCCESS
end

return M