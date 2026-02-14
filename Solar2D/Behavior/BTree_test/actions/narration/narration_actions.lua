-------------------------------------------------------------------------------
-- Narration Actions
-- Uses BaseNarrationAction for shared narration display
-------------------------------------------------------------------------------
local bt = require("behaivor.btree")
local BaseNarrationAction = require("actions.base_narration_action")
local BaseWaitAction = require("actions.base_wait_action")

-- Narration text content
local narrationTexts = {
    cabin_scene = "A dusty sunbeam cuts through the broken window of a small, abandoned cabin. Dust motes dance in the light.",
    forest_quiet = "The forest is unnervingly quiet. No birdsong, no rustle of creatures.",
}

-- Create module using base class
local M = BaseNarrationAction.new(narrationTexts)
local waitAction = BaseWaitAction.new()

-- Register additional special actions
M.ACTIONS["for next"] = function()
    return waitAction.executeWaitForNext()
end

return M
