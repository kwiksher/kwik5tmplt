-------------------------------------------------------------------------------
-- Button Actions
-- Actions for creating and handling button interactions
-------------------------------------------------------------------------------
local bt = require("behaivor.btree")
local actionHelper = require("behaivor.action_helper")
local composer = require("composer")
local widget = require("widget")

-- Create action module with helper methods
local M = actionHelper.createModule()

-- Debug flag - set to false to only show debug logs
M.DEBUG_ENABLED = false

-- Register button-specific actions
M.ACTIONS = {
    -- No button-specific actions currently, only generic scene transitions
}

return M
