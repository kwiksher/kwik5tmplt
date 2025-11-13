-- Scene Actions
-- Consolidated actions for scene transitions
-- Accepts action parameter to specify which scene transition
-- Uses action_helper for common functionality

local bt = require("utils.btree")
local actionHelper = require("utils.action_helper")

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

    if sceneObjects.changeBackground then
        sceneObjects.changeBackground("images/bg_forest.png")
        return bt.SUCCESS
    else
        print("Warning: changeBackground function not available")
        return bt.FAILED
    end
end

function M.goToFightScene()
    -- Transition to fight scene
    print("Going to fight scene")

    if sceneObjects.changeBackground then
        sceneObjects.changeBackground("images/bg_fight.png")
        return bt.SUCCESS
    else
        print("Warning: changeBackground function not available")
        return bt.FAILED
    end
end

function M.goToCalmScene()
    -- Transition to calm scene
    print("Going to calm scene")

    if sceneObjects.changeBackground then
        sceneObjects.changeBackground("images/bg_calm.png")
        return bt.SUCCESS
    else
        print("Warning: changeBackground function not available")
        return bt.FAILED
    end
end

function M.goToRetreatScene()
    -- Transition to retreat scene
    print("Going to retreat scene")

    if sceneObjects.changeBackground then
        sceneObjects.changeBackground("images/bg_retreat.png")
        return bt.SUCCESS
    else
        print("Warning: changeBackground function not available")
        return bt.FAILED
    end
end

return M