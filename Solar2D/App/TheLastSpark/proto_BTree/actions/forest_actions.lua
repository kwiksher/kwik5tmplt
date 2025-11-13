-- Action Controller
-- Manages all action modules for the BTree
-- Uses action_helper to create controller

local actionHelper = require("utils.action_helper")

-- Module paths
local modulePaths = {
    elara = "actions.forest.elara_actions",
    wolf = "actions.forest.wolf_actions",
    cabin = "actions.forest.cabin_actions",
    lumin_seed = "actions.forest.lumin_seed_actions",
    audio = "actions.forest.audio_actions",
    scene = "actions.forest.scene_actions",
    ui = "actions.forest.ui_actions",
    focus = "actions.forest.focus_actions",
    wait = "actions.forest.wait_action",
    show_choices = "actions.forest.show_choices_action",
    choice = "actions.forest.choice_action",
}

-- Show mapping
local showMapping = {
    luminseed = "lumin_seed",
    elara = "elara",
    wolf = "wolf",
}

-- Create controller with custom initialization
local M_controller = {}
local controller

function M_controller.initialize(objects)
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
            choice = actions.choice  -- Add choice to simple routing (overrides default)
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

function M_controller.execute(actionName)
    return controller and controller.execute(actionName) or false
end

function M_controller.getAction(actionName)
    return controller and controller.getAction(actionName) or nil
end

function M_controller.listActions()
    return controller and controller.listActions() or {}
end

function M_controller.getActionCount()
    return controller and controller.getActionCount() or 0
end

return M_controller