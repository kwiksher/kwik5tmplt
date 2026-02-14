-- UI Actions (Cabin Scene)
-- Uses base UI action

local bt = require("behaivor.btree")
local BaseUIAction = require("actions.base_ui_action")

-- Create module using base class
local M = BaseUIAction.new()

-- Helper function for show_choices
local function showChoiceButtons()
    -- Delegate to the proper show_choices_action module which handles RUNNING state
    local showChoicesModule = require("actions.cabin.show_choices_action")
    return showChoicesModule.execute()
end

-- Register UI-specific actions
M.ACTIONS = {
    show_choices = showChoiceButtons,
}

return M
