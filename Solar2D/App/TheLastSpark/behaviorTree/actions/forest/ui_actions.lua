-- UI Actions
-- Consolidated actions for UI-related elements
-- Accepts action parameter to specify which UI action to execute
-- Uses BaseUIAction for common functionality

local bt = require("utils.btree")
local BaseUIAction = require("actions.base_ui_action")

-- Create module using base class
local M = BaseUIAction.new()

-- Helper functions for UI actions
local function showCabinNarration()
    -- Display cabin scene narration text
    -- "A dusty sunbeam cuts through the broken window of a small, abandoned cabin. Dust motes dance in the light."
    print("Showing cabin scene narration")
    return bt.SUCCESS
end

local function showForestQuietNarration()
    -- Display forest quiet narration text
    -- "The forest is unnervingly quiet. No birdsong, no rustle of creatures."
    print("Showing forest quiet narration")
    return bt.SUCCESS
end

local function showChoiceButtons()
    -- Delegate to the proper show_choices_action module which handles RUNNING state
    local showChoicesModule = require("actions.forest.show_choices_action")
    return showChoicesModule.execute()
end

local function presentChoiceFight()
    -- Present fight choice to player
    -- This would typically show fight option UI and wait for player input
    -- For now, automatically select this choice for testing
    print("Presenting fight choice")
    if M.sceneObjects then
        M.sceneObjects.playerChoice = "fight"
        print("Auto-selected: fight")
    end
    return bt.SUCCESS
end

local function presentChoiceCalm()
    -- Present calm choice to player
    -- This would typically show calm option UI and wait for player input
    -- For now, automatically select this choice for testing
    print("Presenting calm choice")
    if M.sceneObjects then
        M.sceneObjects.playerChoice = "calm"
        print("Auto-selected: calm")
    end
    return bt.SUCCESS
end

local function presentChoiceRetreat()
    -- Present retreat choice to player
    -- This would typically show retreat option UI and wait for player input
    -- For now, automatically select this choice for testing
    print("Presenting retreat choice")
    if M.sceneObjects then
        M.sceneObjects.playerChoice = "retreat"
        print("Auto-selected: retreat")
    end
    return bt.SUCCESS
end

-- Register UI-specific actions
M.ACTIONS = {
    cabin_scene = showCabinNarration,
    forest_quiet = showForestQuietNarration,
    show_choices = showChoiceButtons,
    fight = presentChoiceFight,
    calm = presentChoiceCalm,
    retreat = presentChoiceRetreat,
}

return M