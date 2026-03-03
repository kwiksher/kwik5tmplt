-- Cabin Door Actions
-- Consolidated actions for cabin door object
-- Accepts action parameter to specify which door action to execute
-- Uses action_helper for common functionality

local bt = require("behaivor.btree")
local actionHelper = require("behaivor.action_helper")

-- Create action module with helper methods
local M = actionHelper.createModule()

-- Register Cabin Door-specific actions
M.ACTIONS = {
    cabin_door = function()
        return M.showObject("cabin_door")
    end,

    open = function()
        return M.changeToOpen()
    end,

    closed = function()
        return M.changeToClosed()
    end,

    sealed = function()
        return M.changeToSealed()
    end,
}

function M.changeToOpen()
    local DisplayBase = require("behaivor.display_base_common")
    return M.changeState("cabin_door", "open", DisplayBase)
end

function M.changeToClosed()
    local DisplayBase = require("behaivor.display_base_common")
    return M.changeState("cabin_door", "closed", DisplayBase)
end

function M.changeToSealed()
    local DisplayBase = require("behaivor.display_base_common")
    return M.changeState("cabin_door", "sealed", DisplayBase)
end

return M
