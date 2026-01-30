-- Show Choices Action Module
-- Displays the player choice buttons (Reload, Continue, etc.)
-- Returns RUNNING until user selects a choice AND the choice action completes
-- Uses BaseShowChoicesAction for common functionality

local BaseShowChoicesAction = require("actions.base_show_choices_action")

-- Create module using base class
return BaseShowChoicesAction.new()
