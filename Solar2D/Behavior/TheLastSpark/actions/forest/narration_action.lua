-- Narration Actions
-- Displays narrative text in the dialogue text area
-- Uses BaseNarrationAction for common functionality

local BaseNarrationAction = require("actions.base_narration_action")

-- Narration text content
local narrationTexts = {
    cabin_scene = "A dusty sunbeam cuts through the broken window of a small, abandoned cabin. Dust motes dance in the light.",
    forest_quiet = "The forest is unnervingly quiet. No birdsong, no rustle of creatures.",
}

-- Create module using base class
return BaseNarrationAction.new(narrationTexts)
