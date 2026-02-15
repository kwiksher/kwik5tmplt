-- Choice Action Module
-- Handles the narrative actions after player makes a choice (fight, calm, retreat)
-- Returns RUNNING while typing, SUCCESS when complete
-- Uses BaseChoiceAction for common functionality

local BaseChoiceAction = require("Behavior.base_choice_action")

-- Choice configuration: narration, scene, and focus
local CHOICE_CONFIG = {
    fight = {
        narration = "You prepare to fight the corrupted wolf...",
        scene = "fight",
        focus = "wolf"
    },
    calm = {
        narration = "You hold out the Lumin Seed, hoping to calm the beast...",
        scene = "calm",
        focus = "elara"
    },
    retreat = {
        narration = "You slowly back away toward the cabin...",
        scene = "retreat",
        focus = "cabin"
    }
}

-- Create module using base class
return BaseChoiceAction.new(CHOICE_CONFIG)

