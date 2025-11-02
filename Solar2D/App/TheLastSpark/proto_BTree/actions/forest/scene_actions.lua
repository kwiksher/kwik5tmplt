-- Scene Actions
-- Consolidated actions for scene transitions
-- Accepts action parameter to specify which scene transition
-- Uses action_helper for common functionality

local bt = require("btree")
local actionHelper = require("utils.action_helper")

-- Create action module with helper methods
local M = actionHelper.new()

-- Override initialize since scene actions don't need scene objects
function M.initialize(objects)
    -- Scene actions don't typically need scene objects
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
    -- This would typically change the background image
    print("Changing to forest scene")
    return bt.SUCCESS
end

function M.goToFightScene()
    -- Transition to fight scene
    -- This would typically load fight scene assets and logic
    print("Going to fight scene")
    return bt.SUCCESS
end

function M.goToCalmScene()
    -- Transition to calm scene
    -- This would typically load calm scene assets and logic
    print("Going to calm scene")
    return bt.SUCCESS
end

function M.goToRetreatScene()
    -- Transition to retreat scene
    -- This would typically load retreat scene assets and logic
    print("Going to retreat scene")
    return bt.SUCCESS
end

return M