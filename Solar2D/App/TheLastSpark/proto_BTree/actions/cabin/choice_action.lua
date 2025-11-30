-- Choice Action Module (Cabin Scene)
-- Handles the narrative actions after player makes a choice (force_door, window, markings)
-- Returns RUNNING while typing, SUCCESS when complete
-- Uses BaseChoiceAction for common functionality

local BaseChoiceAction = require("actions.base_choice_action")

-- Choice configuration: narration, scene, and focus
local CHOICE_CONFIG = {
    force_door = {
        narration = "You try to force the cabin door open...",
        scene = "force_door",
        focus = "cabin_door"
    },
    window = {
        narration = "You examine the cabin windows for another way in...",
        scene = "window",
        focus = "cabin_door"
    },
    markings = {
        narration = "You study the strange markings around the cabin entrance...",
        scene = "markings",
        focus = "cabin_door"
    }
}

-- Create module using base class
return BaseChoiceAction.new(CHOICE_CONFIG)
