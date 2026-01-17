-------------------------------------------------------------------------------
-- Button Actions
-- Actions for creating and handling button interactions
-------------------------------------------------------------------------------
local bt = require("utils.btree")
local actionHelper = require("utils.action_helper")
local composer = require("composer")
local widget = require("widget")

-- Create action module with helper methods
local M = actionHelper.createModule()

-- Debug flag - set to false to only show debug logs
M.DEBUG_ENABLED = false

-- Scene objects reference
local sceneObjects = {}

-- Override initialize to store scene objects
function M.initialize(objects)
    sceneObjects = objects
    M.sceneObjects = objects
end

-- Register button-specific actions
M.ACTIONS = {
    ["goto animation scene"] = function()
        return M.gotoAnimationScene()
    end,
}

-- Go to animation scene
function M.gotoAnimationScene()
    print("[ACTION] goto animation scene")

    -- Reset button pressed flag
    sceneObjects.buttonPressed = false

    if M.DEBUG_ENABLED then
        composer.gotoScene("views.animationScene", {
            effect = "fade",
            time = 500
        })
    else
        print("DEBUG: Would transition to animation scene with fade effect")
    end

    return bt.SUCCESS
end

-- Execute function for action controller
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
