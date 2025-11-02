-------------------------------------------------------------------------------
-- Conditions Helper - Utilities for condition controller management
-- Provides generic functions for loading, initializing, and managing conditions
-------------------------------------------------------------------------------

local M = {}

-- Load condition modules and register their generated conditions
-- modulePaths: array of module paths that have generateConditions() method
-- objects: scene objects to pass to initialize
-- Returns: table of all registered conditions
function M.loadConditionModules(modulePaths, objects)
    local conditions = {}
    local totalCount = 0

    for _, modulePath in ipairs(modulePaths) do
        local module = require(modulePath)

        -- If module has generateConditions, use it
        if module.generateConditions then
            local generatedConditions = module.generateConditions()
            for name, condition in pairs(generatedConditions) do
                conditions[name] = condition
                totalCount = totalCount + 1
            end
        -- Otherwise, register the module directly if it has evaluate
        elseif module.evaluate then
            local moduleName = modulePath:match("([^%.]+)$") -- Get last part of path
            conditions[moduleName] = module
            totalCount = totalCount + 1
        end
    end

    -- Initialize all conditions with scene objects
    for name, condition in pairs(conditions) do
        if condition.initialize then
            condition.initialize(objects)
        end
    end

    print("Loaded " .. totalCount .. " conditions")
    return conditions
end

-- Count conditions
function M.countConditions(conditions)
    local count = 0
    for _ in pairs(conditions) do
        count = count + 1
    end
    return count
end

-- Evaluate a condition by name
function M.evaluateCondition(conditions, conditionName, logPrefix)
    logPrefix = logPrefix or "Condition Controller"

    if conditions[conditionName] then
        print(logPrefix .. ": Evaluating " .. conditionName)
        return conditions[conditionName].evaluate()
    else
        print(logPrefix .. ": Unknown condition - " .. conditionName)
        return false
    end
end

-- Get condition by name
function M.getCondition(conditions, conditionName)
    return conditions[conditionName]
end

-- List all condition names
function M.listConditions(conditions)
    local conditionList = {}
    for name, _ in pairs(conditions) do
        table.insert(conditionList, name)
    end
    table.sort(conditionList)
    return conditionList
end

-- Setup complete condition controller
-- params: {
--   modulePaths = { "path.to.module", ... } (required),
--   objects = scene objects (required),
--   logPrefix = "Controller Name" (optional)
-- }
-- Returns: { conditions = table, evaluate = function, getCondition, listConditions, getConditionCount }
function M.setupConditionController(params)
    local modulePaths = params.modulePaths
    local objects = params.objects
    local logPrefix = params.logPrefix or "Condition Controller"

    -- Load all condition modules
    local conditions = M.loadConditionModules(modulePaths, objects)
    print(logPrefix .. ": Loaded " .. M.countConditions(conditions) .. " conditions")

    -- Return controller interface
    return {
        conditions = conditions,
        evaluate = function(conditionName)
            return M.evaluateCondition(conditions, conditionName, logPrefix)
        end,
        getCondition = function(conditionName)
            return M.getCondition(conditions, conditionName)
        end,
        listConditions = function()
            return M.listConditions(conditions)
        end,
        getConditionCount = function()
            return M.countConditions(conditions)
        end
    }
end

-- Create a simple condition controller from module paths
-- modulePaths: array of module paths (e.g., {"conditions.forest.player_choice"})
-- logPrefix: optional log prefix (default: "Condition Controller")
-- Returns: a controller module with initialize, evaluate, getCondition, listConditions, getConditionCount
function M.new(modulePaths, logPrefix)
    local controller

    local M_controller = {}

    function M_controller.initialize(objects)
        controller = M.setupConditionController({
            modulePaths = modulePaths,
            objects = objects,
            logPrefix = logPrefix or "Condition Controller"
        })
    end

    function M_controller.evaluate(conditionName)
        return controller and controller.evaluate(conditionName) or false
    end

    function M_controller.getCondition(conditionName)
        return controller and controller.getCondition(conditionName) or nil
    end

    function M_controller.listConditions()
        return controller and controller.listConditions() or {}
    end

    function M_controller.getConditionCount()
        return controller and controller.getConditionCount() or 0
    end

    return M_controller
end

return M
