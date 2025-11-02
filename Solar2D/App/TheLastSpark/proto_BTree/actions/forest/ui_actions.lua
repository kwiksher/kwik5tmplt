-- UI Actions
-- Consolidated actions for UI-related elements
-- Accepts action parameter to specify which UI action to execute
-- Uses action_helper for common functionality

local bt = require("btree")
local actionHelper = require("utils.action_helper")

-- Create action module with helper methods
local M = actionHelper.new()

-- Override initialize since UI actions don't need scene objects
function M.initialize(objects)
    -- UI actions don't typically need scene objects
end

-- Register UI-specific actions
M.ACTIONS = {
    cabin_scene = function()
        return M.showCabinNarration()
    end,

    forest_quiet = function()
        return M.showForestQuietNarration()
    end,

    fight = function()
        return M.presentChoiceFight()
    end,

    calm = function()
        return M.presentChoiceCalm()
    end,

    retreat = function()
        return M.presentChoiceRetreat()
    end,
}

function M.showCabinNarration()
    -- Display cabin scene narration text
    -- "A dusty sunbeam cuts through the broken window of a small, abandoned cabin. Dust motes dance in the light."
    print("Showing cabin scene narration")
    return bt.SUCCESS
end

function M.showForestQuietNarration()
    -- Display forest quiet narration text
    -- "The forest is unnervingly quiet. No birdsong, no rustle of creatures."
    print("Showing forest quiet narration")
    return bt.SUCCESS
end

function M.presentChoiceFight()
    -- Present fight choice to player
    -- This would typically show fight option UI
    print("Presenting fight choice")
    return bt.SUCCESS
end

function M.presentChoiceCalm()
    -- Present calm choice to player
    -- This would typically show calm option UI
    print("Presenting calm choice")
    return bt.SUCCESS
end

function M.presentChoiceRetreat()
    -- Present retreat choice to player
    -- This would typically show retreat option UI
    print("Presenting retreat choice")
    return bt.SUCCESS
end

return M