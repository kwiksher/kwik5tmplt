-- Elara Actions (Cabin Scene)
-- Consolidated actions for Elara character in cabin scene
-- Accepts action parameter to specify which Elara action to execute
-- Uses action_helper for common functionality

local bt = require("utils.btree")
local actionHelper = require("utils.action_helper")

-- Create action module with helper methods
local M = actionHelper.createModule()

-- Register Elara-specific actions
M.ACTIONS = {
    elara = function()
        return M.showObject("elara")
    end,

    happy = function()
        return M.changeToHappy()
    end,

    shocked = function()
        return M.changeToShocked()
    end,

    panicking = function()
        return M.changeToPanicking()
    end,
}

function M.changeToHappy()
    local DisplayBase = require("views.display_base")
    return M.changeState("elara", "happy", DisplayBase)
end

function M.changeToShocked()
    local DisplayBase = require("views.display_base")
    return M.changeState("elara", "shocked", DisplayBase)
end

function M.changeToPanicking()
    local DisplayBase = require("views.display_base")
    return M.changeState("elara", "panicking", DisplayBase)
end

return M
