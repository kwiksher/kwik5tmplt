-- Action Controller
-- Manages all action modules for the BTree
-- Uses action_helper to create controller

local actionHelper = require("behaivor.action_helper")

-- Module paths
local modulePaths = {
    elara = "Behavior.TheLastSpark.actions.forest.elara_actions",
    wolf = "Behavior.TheLastSpark.actions.forest.wolf_actions",
    cabin = "Behavior.TheLastSpark.actions.forest.cabin_actions",
    lumin_seed = "Behavior.TheLastSpark.actions.forest.lumin_seed_actions",
    audio = "Behavior.TheLastSpark.actions.forest.audio_actions",
    scene = "Behavior.TheLastSpark.actions.forest.scene_actions",
    ui = "Behavior.TheLastSpark.actions.forest.ui_actions",
    focus = "Behavior.TheLastSpark.actions.forest.focus_actions",
    wait = "Behavior.TheLastSpark.actions.forest.wait_action",
    show_choices = "Behavior.TheLastSpark.actions.forest.show_choices_action",
    choice = "Behavior.TheLastSpark.actions.forest.choice_action",
    narration = "Behavior.TheLastSpark.actions.forest.narration_action",
}

-- Show mapping
local showMapping = {
    luminseed = "lumin_seed",
    elara = "elara",
    wolf = "wolf",
}

-- Create controller with custom initialization
local M = {}
local controller

function M.initialize(objects)
    -- Load all modules
    local actions = actionHelper.loadActionModules(modulePaths, objects)
    print("Action Controller: Loaded " .. actionHelper.countModules(actions) .. " consolidated action modules")

    -- Build complex routing for show
    local complexRouting = {}
    local showRouting = {}
    for target, moduleName in pairs(showMapping) do
        showRouting[target] = actions[moduleName]
        print("Action Controller: Show mapping: " .. target .. " -> " .. moduleName .. " (module: " .. tostring(actions[moduleName] ~= nil) .. ")")
    end
    complexRouting.show = showRouting
    print("Action Controller: Registered 'show' complex routing with " .. actionHelper.countModules(showRouting) .. " targets")

    -- Create default config with wait module in simple routing
    local config = actionHelper.createDefaultConfig({
        modules = actions,
        logPrefix = "Action Controller",
        additionalSimpleRouting = {
            wait = actions.wait,  -- Add wait to simple routing
            ui = actions.ui,  -- Add ui to simple routing
            show_choices = actions.show_choices,  -- Add show_choices to simple routing
            choice = actions.choice,  -- Add choice to simple routing (overrides default)
            narration = actions.narration  -- Add narration to simple routing
        },
        additionalComplexRouting = complexRouting
    })

    -- Create execute function
    local executeFunc = actionHelper.createExecuteFunction(config)

    controller = {
        actions = actions,
        execute = executeFunc,
        getAction = function(actionName)
            return actions[actionName]
        end,
        listActions = function()
            return actionHelper.buildActionList(actions)
        end,
        getActionCount = function()
            return actionHelper.countModules(actions)
        end
    }
end

function M.execute(actionName)
    return controller and controller.execute(actionName) or false
end

function M.getAction(actionName)
    return controller and controller.getAction(actionName) or nil
end

function M.listActions()
    return controller and controller.listActions() or {}
end

function M.getActionCount()
    return controller and controller.getActionCount() or 0
end

return M