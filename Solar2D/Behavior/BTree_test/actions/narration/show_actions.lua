-- Show Actions
-- Consolidated actions for show-related elements
-- Inherits from BaseShowAction for shared functionality

local BaseShowAction = require("Behavior.base_show_action")
local showChoicesModule = require("actions.narration.show_choices_action")

-- Show action configuration
local SHOW_CONFIG = {
    choices = showChoicesModule.execute
}

-- Create module using base class
local M = BaseShowAction.new(SHOW_CONFIG)

return M
