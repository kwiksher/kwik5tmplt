-- Condition Controller
-- Manages all condition modules for the Cabin BTree
-- Uses conditions_helper to create controller

local conditionsHelper = require("utils.conditions_helper")

-- Create condition controller with module paths
return conditionsHelper.new({
    "conditions.cabin.player_choice",
    "conditions.cabin.next_button",
    "conditions.cabin.has_iron_key",
    "conditions.cabin.has_brass_key",
    "conditions.cabin.key_visible_near_doorstep",
    "conditions.cabin.searched_floorboard",
    "conditions.cabin.is_door_open",
    "conditions.cabin.is_chest_open",
}, "Cabin Condition Controller")
