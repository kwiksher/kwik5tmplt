-- Condition Controller
-- Manages all condition modules for the BTree
-- Uses conditions_helper to create controller

local conditionsHelper = require("behaivor.conditions_helper")

-- Create condition controller with module paths
return conditionsHelper.new({
    "conditions.forest.player_choice",
    "conditions.forest.next_button",
}, "Condition Controller")