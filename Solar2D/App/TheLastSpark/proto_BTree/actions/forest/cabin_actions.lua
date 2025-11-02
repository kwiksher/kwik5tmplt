-- Cabin Actions
-- Consolidated actions for Cabin entity
-- Accepts action parameter to specify which Cabin action to execute
-- Uses action_helper for common functionality

local bt = require("btree")
local actionHelper = require("utils.action_helper")

-- Create action module with helper methods
local M = actionHelper.new()

-- Register Cabin-specific actions
M.ACTIONS = {
    cabin = function()
        -- Show cabin - placeholder for actual implementation
        if not M.checkObject("cabin") then
            return bt.FAILED
        end
        print("Showing cabin")
        return bt.SUCCESS
    end,
}

return M