-------------------------------------------------------------------------------
-- Star Actions
-- Actions for animating the star shape
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

-- Register star-specific actions
M.ACTIONS = {
    ["star"] = function()
        return M.animateStar()
    end,
}

-- Clear animation status for star
function M.clearAnimationStatus()
    print("[ACTION] clear animation status")

    -- Initialize and clear animation tables
    sceneObjects.animationComplete = sceneObjects.animationComplete or {}
    sceneObjects.animationComplete.star = false
    sceneObjects.animationInProgress = sceneObjects.animationInProgress or {}
    sceneObjects.animationInProgress.star = nil
end

-- Cancel star animation
function M.animateStarCancel()
    print("[ACTION] cancel star animation")

    -- Initialize tables if needed
    sceneObjects.animationInProgress = sceneObjects.animationInProgress or {}

    -- Cancel transition if it exists
    if sceneObjects.animationInProgress.star then
        transition.cancel(sceneObjects.animationInProgress.star)
        sceneObjects.animationInProgress.star = nil
        print("Star animation cancelled")
    end
end

-- Star animation completion callback
function M.animateStarOnComplete()
    print("Star animation completed")

    -- Initialize tables if needed
    sceneObjects.animationComplete = sceneObjects.animationComplete or {}
    sceneObjects.animationInProgress = sceneObjects.animationInProgress or {}

    -- Mark animation as complete
    sceneObjects.animationComplete.star = true
    sceneObjects.animationInProgress.star = nil

    -- Immediately tick the behavior tree when animation completes
    if sceneObjects.treeController and not sceneObjects.treeController.isComplete then
        sceneObjects.treeController:tick()
    end
end

-- Animate the star with linear movement
function M.animateStar()
    print("[ACTION] animate star")

    if M.DEBUG_ENABLED then
        if sceneObjects.star then
            -- Initialize tables if needed
            sceneObjects.animationInProgress = sceneObjects.animationInProgress or {}

            -- Check if animation is already in progress
            if sceneObjects.animationInProgress.star then
                print("Animation already in progress, returning SUCCESS")
                return bt.SUCCESS
            end

            -- Linear animation to the right side of screen
            local transitionId = transition.to(sceneObjects.star, {
                x = display.contentCenterX + 200,
                time = 2000,
                onComplete = M.animateStarOnComplete
            })

            -- Store transition ID
            sceneObjects.animationInProgress.star = transitionId
            print("Star animation started - moving to right side, transition ID:", transitionId)
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
    local action = M.ACTIONS[actionName]
    if action then
        return action()
    else
        print("Warning: Unknown action: " .. tostring(actionName))
        return bt.FAILED
    end
end

return M
