-------------------------------------------------------------------------------
-- Animation Actions
-- Actions for creating and animating a star shape
-------------------------------------------------------------------------------
local bt = require("utils.btree")
local actionHelper = require("utils.action_helper")
local composer = require("composer")

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
    ["counter"] = function()
        return M.incrementCounter()
    end,
    ["star"] = function()
        return M.animateStar()
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

-- Animate the star with linear movement
function M.animateStar()
    print("[ACTION] animate star")

    if M.DEBUG_ENABLED then
        if sceneObjects.star then
            -- Check if animation is already in progress
            if sceneObjects.animationInProgress then
                print("Animation already in progress, returning SUCCESS")
                return bt.SUCCESS
            end

            -- Mark animation as in progress
            sceneObjects.animationInProgress = true

            -- Linear animation to the right side of screen
            transition.to(sceneObjects.star, {
                x = display.contentCenterX + 200,
                time = 2000,
                onComplete = function()
                    print("Star animation completed")
                    -- Mark animation as complete
                    sceneObjects.animationComplete = sceneObjects.animationComplete or {}
                    sceneObjects.animationComplete.star = true
                    sceneObjects.animationInProgress = false
                    -- Immediately tick the behavior tree when animation completes
                    if sceneObjects.treeController and not sceneObjects.treeController.isComplete then
                        sceneObjects.treeController:tick()
                    end
                end
            })
            print("Star animation started - moving to right side")
        else
            print("Warning: star object not found")
            return bt.FAILED
        end
    else
        print("DEBUG: Would animate star from left to right over 2 seconds")
        -- Simulate animation completion
        sceneObjects.animationComplete = sceneObjects.animationComplete or {}
        sceneObjects.animationComplete.star = true
    end

    return bt.SUCCESS
end

-- Execute function for action controller
function M.execute(actionName)
    print("[DEBUG] animation_actions.execute called with: '" .. tostring(actionName) .. "'")
    print("[DEBUG] Available actions in ACTIONS table:")
    for key, _ in pairs(M.ACTIONS) do
        print("[DEBUG]   - '" .. key .. "'")
    end

    local action = M.ACTIONS[actionName]
    if action then
        return action()
    else
        print("Warning: Unknown action: " .. tostring(actionName))
        return bt.FAILED
    end
end

return M
