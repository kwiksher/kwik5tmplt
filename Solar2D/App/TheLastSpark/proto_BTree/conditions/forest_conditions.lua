-- Condition Controller
-- Manages all condition modules for the BTree
-- Uses conditions_helper to create controller

local conditionsHelper = require("utils.conditions_helper")

-- Create condition controller with module paths
return conditionsHelper.new({
    "conditions.forest.player_choice",
}, "Condition Controller")