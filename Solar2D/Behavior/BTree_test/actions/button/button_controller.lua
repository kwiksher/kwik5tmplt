-------------------------------------------------------------------------------
-- Button Action Controller
-- Manages all action modules for the button scene BTree
-------------------------------------------------------------------------------
local actionHelper = require("behaivor.action_helper")

-- Module paths
local modulePaths = {
    button = "Behavior.BTree_test.actions.button.button_actions",
    scene = "Behavior.BTree_test.actions.scene_actions",
}

-- Create controller using action_helper.new with custom routing
local M = actionHelper.new(
    modulePaths,
    {
        simpleRouting = {
            goto = "scene",
        }
    },
    "Button Action Controller"
)

return M
