-- Action Controller (Cabin Scene)
-- Manages all action modules for the Cabin BTree
-- Uses action_helper to create controller

local actionHelper = require("behaivor.action_helper")

-- Module paths
local modulePaths = {
    elara = "Behavior.TheLastSpark.actions.cabin.elara_actions",
    cabin_door = "Behavior.TheLastSpark.actions.cabin.cabin_door_actions",
    chest = "Behavior.TheLastSpark.actions.cabin.chest_actions",
    iron_key = "Behavior.TheLastSpark.actions.cabin.iron_key_actions",
    brass_key = "Behavior.TheLastSpark.actions.cabin.brass_key_actions",
    loose_floorboard = "Behavior.TheLastSpark.actions.cabin.loose_floorboard_actions",
    lumin_seed = "Behavior.TheLastSpark.actions.cabin.lumin_seed_actions",
    audio = "Behavior.TheLastSpark.actions.cabin.audio_actions",
    scene = "Behavior.TheLastSpark.actions.cabin.scene_actions",
    ui = "Behavior.TheLastSpark.actions.cabin.ui_actions",
    focus = "Behavior.TheLastSpark.actions.cabin.focus_actions",
    wait = "Behavior.TheLastSpark.actions.cabin.wait_action",
    show_choices = "Behavior.TheLastSpark.actions.cabin.show_choices_action",
    choice = "Behavior.TheLastSpark.actions.cabin.choice_action",
    narration = "Behavior.TheLastSpark.actions.cabin.narration_action",
}

-- Show mapping
local showMapping = {
    luminseed = "lumin_seed",
    elara = "elara",
    cabin_door = "cabin_door",
    chest = "chest",
    iron_key = "iron_key",
    brass_key = "brass_key",
    loose_floorboard = "loose_floorboard",
}

-- Create controller with custom initialization
local M_controller = {}
local controller

function M_controller.initialize(objects)
    -- Load all modules
    local actions = actionHelper.loadActionModules(modulePaths, objects)
    print("Cabin Action Controller: Loaded " .. actionHelper.countModules(actions) .. " consolidated action modules")

    -- Build complex routing for show
    local complexRouting = {}
    local showRouting = {}
    for target, moduleName in pairs(showMapping) do
        showRouting[target] = actions[moduleName]
        print("Cabin Action Controller: Show mapping: " .. target .. " -> " .. moduleName .. " (module: " .. tostring(actions[moduleName] ~= nil) .. ")")
    end
    complexRouting.show = showRouting
    print("Cabin Action Controller: Registered 'show' complex routing with " .. actionHelper.countModules(showRouting) .. " targets")

    -- Create default config with wait module in simple routing
    local config = actionHelper.createDefaultConfig({
        modules = actions,
        logPrefix = "Cabin Action Controller",
        additionalSimpleRouting = {
            wait = actions.wait,
            ui = actions.ui,
            show_choices = actions.show_choices,
            choice = actions.choice,
            narration = actions.narration
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
        end,
        -- Reset all action completion tracking
        reset = function()
            for _, actionModule in pairs(actions) do
                if actionModule.reset then
                    actionModule.reset()
                end
            end
            print("Cabin Action Controller: Reset all action completion tracking")
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

function M_controller.reset()
    if controller and controller.reset then
        controller.reset()
    end
end

return M_controller
