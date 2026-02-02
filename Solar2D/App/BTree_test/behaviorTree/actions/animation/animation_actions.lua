-------------------------------------------------------------------------------
-- Animation Actions
-- Actions for the animation scene (counter, etc.)
-------------------------------------------------------------------------------
local bt = require("utils.btree")
local actionHelper = require("utils.action_helper")

-- Create action module with helper methods
local M = actionHelper.createModule()

-- Debug flag - set to false to only show debug logs
M.DEBUG_ENABLED = true

-- Scene objects reference
local sceneObjects = {}

-- Override initialize to store scene objects
function M.initialize(objects)
    sceneObjects = objects
    M.sceneObjects = objects
end

-- Register animation-specific actions
M.ACTIONS = {
    counter = function()
        return M.incrementCounter()
    end,
}

-- Increment the scene display counter
function M.incrementCounter()
    print("[ACTION] increment counter")

    -- Initialize counter if it doesn't exist
    sceneObjects.sceneDisplayCount = sceneObjects.sceneDisplayCount or 0
    sceneObjects.sceneDisplayCount = sceneObjects.sceneDisplayCount + 1

    print("Animation scene displayed " .. sceneObjects.sceneDisplayCount .. " times")

    -- Update counter text if it exists
    if sceneObjects.counterText then
        sceneObjects.counterText.text = "Scene Count: " .. sceneObjects.sceneDisplayCount
    end

    return bt.SUCCESS
end

return M
