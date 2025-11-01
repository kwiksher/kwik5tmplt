-- Condition Controller
-- Manages all condition modules for the BTree

local M = {}

-- Condition modules registry
local conditions = {}

-- Scene objects reference
local sceneObjects = {}

function M.initialize(objects)
    sceneObjects = objects
    M.loadAllConditions()
end

function M.loadAllConditions()
    -- Load consolidated player choice module
    local playerChoiceModule = require("conditions.player_choice")

    -- Register individual player choice conditions
    conditions.player_choice_fight = {
        initialize = playerChoiceModule.initialize,
        evaluate = function() return playerChoiceModule.evaluate("fight") end
    }
    conditions.player_choice_calm = {
        initialize = playerChoiceModule.initialize,
        evaluate = function() return playerChoiceModule.evaluate("calm") end
    }
    conditions.player_choice_retreat = {
        initialize = playerChoiceModule.initialize,
        evaluate = function() return playerChoiceModule.evaluate("retreat") end
    }

    -- Initialize all conditions with scene objects
    for name, condition in pairs(conditions) do
        if condition.initialize then
            condition.initialize(sceneObjects)
        end
    end

    print("Condition Controller: Loaded " .. M.getConditionCount() .. " conditions")
end

function M.getConditionCount()
    local count = 0
    for _ in pairs(conditions) do
        count = count + 1
    end
    return count
end

function M.evaluate(conditionName)
    if conditions[conditionName] then
        print("Condition Controller: Evaluating " .. conditionName)
        return conditions[conditionName].evaluate()
    else
        print("Condition Controller: Unknown condition - " .. conditionName)
        return false
    end
end

function M.getCondition(conditionName)
    return conditions[conditionName]
end

function M.listConditions()
    local conditionList = {}
    for name, _ in pairs(conditions) do
        table.insert(conditionList, name)
    end
    table.sort(conditionList)
    return conditionList
end

return M