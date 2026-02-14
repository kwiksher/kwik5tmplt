-------------------------------------------------------------------------------
-- Button Condition Controller
-- Manages all condition modules for the button scene BTree
-------------------------------------------------------------------------------
local bt = require("behaivor.btree")

-- Module paths
local modulePaths = {
    button = "conditions.button.button_conditions",
}

-- Create controller
local M = {}
local conditions = {}

function M.initialize(objects)
    -- Load all condition modules
    for name, path in pairs(modulePaths) do
        local success, module = pcall(require, path)
        if success then
            if module.initialize then
                module.initialize(objects)
            end
            conditions[name] = module
            print("Button Condition Controller: Loaded module '" .. name .. "' from " .. path)
        else
            print("Warning: Failed to load condition module '" .. name .. "': " .. tostring(module))
        end
    end

    print("Button Condition Controller: Initialized successfully with " .. #conditions .. " modules")
end

-- Evaluate function
function M.evaluate(conditionName)
    -- Try each module until we find one that handles this condition
    for moduleName, module in pairs(conditions) do
        if module.evaluate then
            local result = module.evaluate(conditionName)
            if result ~= nil then
                return result
            end
        end
    end

    print("Warning: No module found to evaluate condition: " .. tostring(conditionName))
    return false
end

return M
