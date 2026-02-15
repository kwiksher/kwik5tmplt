-------------------------------------------------------------------------------
local actionHelper = require("behaivor.action_helper")

local modulePaths = {
    scene = "actions.scene_actions",
    narration = "actions.narration.narration_actions",

}

local M = actionHelper.new(
    modulePaths,
    {
        simpleRouting = {
            print = "narration",

        }
    },
    "narration Action Controller"
)

return M
