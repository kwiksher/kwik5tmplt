-- UI Actions (Cabin Scene)
-- Uses base UI action

local bt = require("behaivor.btree")
local BaseUIAction = require("Behavior.base_ui_action")

-- Create module using base class
local M = BaseUIAction.new()

-- Helper function for show_choices
local function showChoiceButtons()
    -- Delegate to the proper show_choices_action module which handles RUNNING state
    local showChoicesModule = require("Behavior.TheLastSpark.actions.cabin.show_choices_action")
    return showChoicesModule.execute()
end

-- Register UI-specific actions
M.ACTIONS = {
    show_choices = showChoiceButtons,
}

return M
