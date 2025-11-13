-- UI Actions
-- Consolidated actions for UI-related elements
-- Accepts action parameter to specify which UI action to execute
-- Uses action_helper for common functionality

local bt = require("utils.btree")
local actionHelper = require("utils.action_helper")

-- Create action module with helper methods
local M = actionHelper.createModule()

-- Override initialize to capture scene objects reference
function M.initialize(objects)
    -- Store reference to scene objects so we can set playerChoice
    M.sceneObjects = objects
end

-- Override execute to add logging
function M.execute(actionName)
    print("UI Actions: Received action name = '" .. tostring(actionName) .. "'")
    print("UI Actions: Available actions = " .. table.concat(M.listActionNames(), ", "))

    if not actionName then
        print("UI Actions: Error - No action specified")
        return bt.FAILED
    end

    -- Look up action in registry
    if M.ACTIONS[actionName] then
        print("UI Actions: Found action, executing...")
        return M.ACTIONS[actionName]()
    else
        print("UI Actions: Error - Unknown action '" .. tostring(actionName) .. "'")
        return bt.FAILED
    end
end

-- Helper to list all action names
function M.listActionNames()
    local names = {}
    for name, _ in pairs(M.ACTIONS) do
        table.insert(names, name)
    end
    return names
end

-- Register UI-specific actions
M.ACTIONS = {
    cabin_scene = function()
        return M.showCabinNarration()
    end,

    forest_quiet = function()
        return M.showForestQuietNarration()
    end,

    show_choices = function()
        return M.showChoiceButtons()
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

function M.showChoiceButtons()
    -- Display the player choice buttons (Fight, Calm, Retreat)
    print("Showing player choice buttons")
    if M.sceneObjects and M.sceneObjects.showChoiceButtons then
        M.sceneObjects.showChoiceButtons()
    else
        print("Warning: showChoiceButtons function not found")
    end
    return bt.SUCCESS
end

function M.presentChoiceFight()
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

function M.presentChoiceCalm()
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

function M.presentChoiceRetreat()
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

return M