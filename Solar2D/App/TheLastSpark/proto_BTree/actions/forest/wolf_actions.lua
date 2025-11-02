-- Wolf Actions
-- Consolidated actions for Wolf character
-- Accepts action parameter to specify which Wolf action to execute
-- Uses action_helper for common functionality

local bt = require("btree")
local actionHelper = require("utils.action_helper")

-- Create action module with helper methods
local M = actionHelper.new()

-- Register Wolf-specific actions
M.ACTIONS = {
    wolf = function()
        return M.showObject("wolf")
    end,
}

return M