-------------------------------------------------------------------------------
-- Animation Action Controller
-- Manages all action modules for the animation scene BTree
-------------------------------------------------------------------------------
print("[CONTROLLER LOAD] Loading animation_controller.lua v2")
local actionHelper = require("utils.action_helper")

-- Module paths
local modulePaths = {
    animation = "actions.animation.animation_actions",
    scene = "actions.scene_actions",
}

-- Create controller
local M = {}
local controller

function M.initialize(objects)
    -- Load all modules
    local actions = actionHelper.loadActionModules(modulePaths, objects)
    print("Animation Action Controller: Loaded " .. actionHelper.countModules(actions) .. " action modules")


    -- Create config with routing
    local config = {
        modules = actions,
        logPrefix = "Animation Action Controller",
        simpleRouting = {
            increment = actions.animation,
            animate = actions.animation,
            goto = actions.scene,
        }
    }

    print("[DEBUG] simpleRouting configured:")
    for key, mod in pairs(config.simpleRouting) do
        print("[DEBUG]   " .. key .. " -> " .. tostring(mod))
    end

    -- Create execute function
    local executeFunc = actionHelper.createExecuteFunction(config)

    controller = {
        actions = actions,
        execute = executeFunc,
    }

    print("Animation Action Controller: Initialized successfully")
end

-- Execute function delegates to controller
function M.execute(actionName)
    if not controller then
        print("Error: Animation Action Controller not initialized!")
        return require("utils.btree").FAILED
    end
    return controller.execute(actionName)
end

return M
