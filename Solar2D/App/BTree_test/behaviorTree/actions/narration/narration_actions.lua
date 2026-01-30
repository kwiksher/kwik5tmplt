-------------------------------------------------------------------------------
-- Narration Actions
-- Uses BaseNarrationAction for shared narration display
-------------------------------------------------------------------------------
local bt = require("utils.btree")
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

function M.action_cabin_scene()
    return M.showNarration("cabin_scene")
end

function M.action_for_next()
    return waitAction.executeWaitForNext()
end

function M.action_forest_quiet()
    return M.showNarration("forest_quiet")
end

M.ACTIONS = {
    ["cabin_scene"] = function() return M.action_cabin_scene() end,
    ["for next"] = function() return M.action_for_next() end,
    ["forest_quiet"] = function() return M.action_forest_quiet() end,
}

function M.execute(actionName)
    local action = M.ACTIONS[actionName]
    if action then
        return action()
    else
        print("Warning: Unknown action: " .. tostring(actionName))
        return bt.FAILED
    end
end

return M
