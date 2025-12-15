-- Scene Actions
-- Consolidated actions for scene transitions
-- Accepts action parameter to specify which scene transition
-- Uses action_helper for common functionality

local bt = require("utils.btree")
local actionHelper = require("utils.action_helper")
local composer = require("composer")

-- Create action module with helper methods
local M = actionHelper.createModule()

-- Scene objects reference
local sceneObjects = {}

-- Override initialize to store scene objects
function M.initialize(objects)
    sceneObjects = objects
end

-- Register Scene-specific actions
M.ACTIONS = {
    forest = function()
        return M.changeToForestScene()
    end,

    fight = function()
        return M.goToFightScene()
    end,

    calm = function()
        return M.goToCalmScene()
    end,

    retreat = function()
        return M.goToRetreatScene()
    end,
}

function M.changeToForestScene()
    -- Change background to forest scene
    print("Changing to forest scene")

    -- Hide objects from previous scene (cabin interior)
    if sceneObjects.luminSeed then
        sceneObjects.luminSeed.isVisible = false
    end
    if sceneObjects.elara then
        sceneObjects.elara.isVisible = false
    end

    -- Change background
    if sceneObjects.changeBackground then
        sceneObjects.changeBackground("images/bg_forest.png")
        return bt.SUCCESS
    else
        print("Warning: changeBackground function not available")
        return bt.FAILED
    end
end

function M.goToFightScene()
    -- Transition to fight scene using composer
    print("Going to fight scene")

    composer.gotoScene("views.fight.fightScene", {
        effect = "fade",
        time = 500
    })

    return bt.SUCCESS
end

function M.goToCalmScene()
    -- Transition to calm scene using composer
    print("Going to calm scene")

    composer.gotoScene("views.calm.calmScene", {
        effect = "fade",
        time = 500
    })

    return bt.SUCCESS
end

function M.goToRetreatScene()
    -- Transition to retreat scene using composer
    print("Going to retreat scene")

    -- composer.gotoScene("views.retreat.retreatScene", {
    --     effect = "fade",
    --     time = 500
    -- })
    composer.gotoScene("views.cabin.cabinScene", {
        effect = "fade",
        time = 500
    })

    return bt.SUCCESS
end

return M