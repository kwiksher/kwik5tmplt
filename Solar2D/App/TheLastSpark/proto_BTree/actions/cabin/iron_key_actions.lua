-- Iron Key Actions
-- Consolidated actions for iron key object
-- Accepts action parameter to specify which key action to execute
-- Uses action_helper for common functionality

local bt = require("utils.btree")
local actionHelper = require("utils.action_helper")

-- Create action module with helper methods
local M = actionHelper.createModule()

-- Register Iron Key-specific actions
M.ACTIONS = {
    iron_key = function()
        return M.showObject("iron_key")
    end,

    visible = function()
        return M.changeToVisible()
    end,

    collected = function()
        return M.changeToCollected()
    end,
}

function M.changeToVisible()
    local DisplayBase = require("views.display_base")
    return M.changeState("iron_key", "visible", DisplayBase)
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

return M
