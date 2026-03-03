-- Chest Actions
-- Consolidated actions for chest object
-- Accepts action parameter to specify which chest action to execute
-- Uses action_helper for common functionality

local bt = require("behaivor.btree")
local actionHelper = require("behaivor.action_helper")

-- Create action module with helper methods
local M = actionHelper.createModule()

-- Register Chest-specific actions
M.ACTIONS = {
    chest = function()
        return M.showObject("chest")
    end,

    open = function()
        return M.changeToOpen()
    end,

    locked = function()
        return M.changeToLocked()
    end,

    empty = function()
        return M.changeToEmpty()
    end,
}

function M.changeToOpen()
    local DisplayBase = require("behaivor.display_base_common")
    return M.changeState("chest", "open", DisplayBase)
end

function M.changeToLocked()
    local DisplayBase = require("behaivor.display_base_common")
    return M.changeState("chest", "locked", DisplayBase)
end

function M.changeToEmpty()
    local DisplayBase = require("behaivor.display_base_common")
    return M.changeState("chest", "empty", DisplayBase)
end

return M
