-------------------------------------------------------------------------------
-- narration Action Controller
-- Auto-generated scaffold
-------------------------------------------------------------------------------
local actionHelper = require("behaivor.action_helper")
local bt = require("behaivor.btree")

-- Module paths
local modulePaths = {
    scene = "actions.scene_actions",
    narration = "actions.narration.narration_actions",
    wait = "actions.narration.wait_action",
    show = "actions.narration.show_actions",
    show_choices = "actions.narration.show_choices_action",
    choice = "actions.narration.choice_action",
}

-- Create controller using action_helper.new with custom routing
local M = actionHelper.new(
    modulePaths,
    {
        simpleRouting = {
            narration = "narration",
            wait = "wait",
            scene = "scene",
            choice = "choice",
        },
        showMapping = {
            choices = "show",
        }
    },
    "narration Action Controller"
)

return M
