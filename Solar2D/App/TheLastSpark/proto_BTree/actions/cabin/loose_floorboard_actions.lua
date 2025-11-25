-- Loose Floorboard Actions
-- Consolidated actions for loose floorboard object
-- Accepts action parameter to specify which floorboard action to execute
-- Uses action_helper for common functionality

local bt = require("utils.btree")
local actionHelper = require("utils.action_helper")

-- Create action module with helper methods
local M = actionHelper.createModule()

-- Register Loose Floorboard-specific actions
M.ACTIONS = {
    loose_floorboard = function()
        return M.showObject("loose_floorboard")
    end,

    highlighted = function()
        return M.changeToHighlighted()
    end,

    open = function()
        return M.changeToOpen()
    end,
}

function M.changeToHighlighted()
    local DisplayBase = require("views.display_base")
    return M.changeState("loose_floorboard", "highlighted", DisplayBase)
end

function M.changeToOpen()
    local DisplayBase = require("views.display_base")
    return M.changeState("loose_floorboard", "open", DisplayBase)
end

return M
