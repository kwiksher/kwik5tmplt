-------------------------------------------------------------------------------
-- narration Action Controller
-- Auto-generated scaffold
-------------------------------------------------------------------------------
local actionHelper = require("utils.action_helper")
local bt = require("utils.btree")

-- Module paths
local modulePaths = {
    scene = "actions.scene_actions",
    narration = "actions.narration.narration_actions",
    wait = "actions.narration.wait_action",
    show = "actions.narration.show_actions",
    show_choices = "actions.narration.show_choices_action",
    choice = "actions.narration.choice_action",
}

local M = {}
local controller

function M.initialize(objects)
    -- Load all modules
    local actions = actionHelper.loadActionModules(modulePaths, objects)
    print("narration Action Controller: Loaded " .. actionHelper.countModules(actions) .. " action modules")

    local config = {
        modules = actions,
        logPrefix = "narration Action Controller",
        simpleRouting = {
            narration = actions.narration,
            wait = actions.wait,
            show = actions.show,  -- "show choices" routes to show_actions.execute("choices")
            scene = actions.scene,  -- "scene reload/next" routes to scene_actions.execute("reload/next")
            choice = actions.choice,
        }
    }

    local executeFunc = actionHelper.createExecuteFunction(config)

    controller = {
        actions = actions,
        execute = executeFunc,
    }
end

function M.execute(actionName)
    if not controller then
        print("Error: narration Action Controller not initialized!")
        return bt.FAILED
    end
    return controller.execute(actionName)
end

return M
