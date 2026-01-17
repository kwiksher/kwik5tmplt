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
M.DEBUG_ENABLED = false

-- Scene objects reference
local sceneObjects = {}

-- Override initialize to store scene objects
function M.initialize(objects)
    sceneObjects = objects
    M.sceneObjects = objects
end

-- Register animation-specific actions
M.ACTIONS = {
    ["animate star"] = function()
        return M.animateStar()
    end,

    ["wait for animation"] = function()
        return M.waitForAnimation()
    end,

    ["goto button scene"] = function()
        return M.gotoButtonScene()
    end,
}

-- Animate the star with linear movement
function M.animateStar()
    print("[ACTION] animate star")

    if M.DEBUG_ENABLED then
        if sceneObjects.star then
            -- Linear animation to the right side of screen
            transition.to(sceneObjects.star, {
                x = display.contentCenterX + 200,
                time = 2000,
                onComplete = function()
                    print("Star animation completed")
                    sceneObjects.animationComplete = true
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
        sceneObjects.animationComplete = true
    end

    return bt.SUCCESS
end

-- Wait for animation to complete
function M.waitForAnimation()
    print("[ACTION] wait for animation")

    if sceneObjects.animationComplete then
        print("Animation is complete, proceeding...")
        return bt.SUCCESS
    else
        print("Waiting for animation to complete...")
        return bt.RUNNING
    end
end

-- Go to button scene
function M.gotoButtonScene()
    print("[ACTION] goto button scene")

    if M.DEBUG_ENABLED then
        composer.gotoScene("views.buttonScene", {
            effect = "fade",
            time = 500
        })
    else
        print("DEBUG: Would transition to button scene with fade effect")
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
