-------------------------------------------------------------------------------
-- Animation Action Controller
-- Manages all action modules for the animation scene BTree
-------------------------------------------------------------------------------
local actionHelper = require("behaivor.action_helper")

-- Module paths
local modulePaths = {
    animation = "actions.animation_actions",
    scene = "actions.scene_actions",
}

-- Create controller
local M = {}
local controller

function M.initialize(objects)
    -- Load all modules
    local actions = actionHelper.loadActionModules(modulePaths, objects)
    print("Animation Action Controller: Loaded " .. actionHelper.countModules(actions) .. " action modules")

    -- Create default config
    local config = actionHelper.createDefaultConfig({
        modules = actions,
        logPrefix = "Animation Action Controller",
    })

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
        return require("behaivor.btree").FAILED
    end
    return controller.execute(actionName)
end

return M
