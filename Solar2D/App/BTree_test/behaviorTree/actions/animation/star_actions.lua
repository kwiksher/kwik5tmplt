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

-- Register star-specific actions
M.ACTIONS = {
    star = function()
        return M.animateStar()
    end,
}

-- Clear animation status for star
function M.clearAnimationStatus()
    print("[ACTION] clear animation status")

    -- Initialize and clear animation tables
    local objects = M.objects
    objects.animationComplete = objects.animationComplete or {}
    objects.animationComplete.star = false
    objects.animationInProgress = objects.animationInProgress or {}
    objects.animationInProgress.star = nil
end

-- Cancel star animation
function M.animateStarCancel()
    print("[ACTION] cancel star animation")

    -- Initialize tables if needed
    local objects = M.objects
    objects.animationInProgress = objects.animationInProgress or {}

    -- Cancel transition if it exists
    if objects.animationInProgress.star then
        transition.cancel(objects.animationInProgress.star)
        objects.animationInProgress.star = nil
        print("Star animation cancelled")
    end
end

-- Star animation completion callback
function M.animateStarOnComplete()
    print("Star animation completed")

    -- Initialize tables if needed
    local objects = M.objects
    objects.animationComplete = objects.animationComplete or {}
    objects.animationInProgress = objects.animationInProgress or {}

    -- Mark animation as complete
    objects.animationComplete.star = true
    objects.animationInProgress.star = nil

    -- Immediately tick the behavior tree when animation completes
    if objects.treeController and not objects.treeController.isComplete then
        objects.treeController:tick()
    end
end

-- Animate the star with linear movement
function M.animateStar()
    print("[ACTION] animate star")

    local objects = M.objects
    if M.DEBUG_ENABLED then
        if objects.star then
            -- Initialize tables if needed
            objects.animationInProgress = objects.animationInProgress or {}

            -- Check if animation is already in progress
            if objects.animationInProgress.star then
                print("Animation already in progress, returning SUCCESS")
                return bt.SUCCESS
            end

            -- Linear animation to the right side of screen
            local transitionId = transition.to(objects.star, {
                x = display.contentCenterX + 200,
                time = 2000,
                onComplete = M.animateStarOnComplete
            })

            -- Store transition ID
            objects.animationInProgress.star = transitionId
            print("Star animation started - moving to right side, transition ID:", transitionId)
        else
            print("Warning: star object not found")
            return bt.FAILED
        end
    else
        print("DEBUG: Would animate star from left to right over 2 seconds")
        -- Simulate animation completion
        objects.animationComplete = objects.animationComplete or {}
        objects.animationComplete.star = true
    end

    return bt.SUCCESS
end

return M
