-------------------------------------------------------------------------------
-- Animation Action Controller
-- Manages all action modules for the animation scene BTree
-------------------------------------------------------------------------------
print("[CONTROLLER LOAD] Loading animation_controller.lua v2")
local actionHelper = require("behaivor.action_helper")

-- Module paths
local modulePaths = {
    animation = "Behavior.BTree_test.actions.animation.animation_actions",
    star = "Behavior.BTree_test.actions.animation.star_actions",
    scene = "Behavior.BTree_test.actions.scene_actions",
}

-- Create controller using action_helper.new with custom routing
local M = actionHelper.new(
    modulePaths,
    {
        simpleRouting = {
            increment = "animation",
            animate = "star",
            goto = "scene",
        }
    },
    "Animation Action Controller"
)

return M
