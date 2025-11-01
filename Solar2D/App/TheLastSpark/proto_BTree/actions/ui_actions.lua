-- UI Actions
-- Consolidated actions for UI-related elements
-- Accepts action parameter to specify which UI action to execute

local bt = require("btree")
local M = {}

-- Action constants
M.ACTIONS = {
    SHOW_FOREST_NARRATION = "show_forest_narration",
    PRESENT_CHOICE_FIGHT = "present_choice_fight",
    PRESENT_CHOICE_CALM = "present_choice_calm",
    PRESENT_CHOICE_RETREAT = "present_choice_retreat"
}

function M.initialize(objects)
    -- UI actions don't typically need scene objects
end

function M.execute(action)
    if not action then
        print("Error: No action specified for UI")
        return bt.FAILED
    end

    if action == M.ACTIONS.SHOW_FOREST_NARRATION then
        return M.showForestNarration()
    elseif action == M.ACTIONS.PRESENT_CHOICE_FIGHT then
        return M.presentChoiceFight()
    elseif action == M.ACTIONS.PRESENT_CHOICE_CALM then
        return M.presentChoiceCalm()
    elseif action == M.ACTIONS.PRESENT_CHOICE_RETREAT then
        return M.presentChoiceRetreat()
    else
        print("Error: Unknown UI action - " .. tostring(action))
        return bt.FAILED
    end
end

function M.showForestNarration()
    -- Display forest narration text
    -- This would typically show text on screen
    print("Showing forest narration")
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