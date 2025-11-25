-- Base Player Choice Condition
-- Generic base class for player choice conditions across all scenes
-- Supports multiple choice types (calm, fight, retreat, etc.)

local M = {}

M.CONDITION_NAME = "player choice"

-- Default condition types (can be overridden by subclasses)
M.CONDITION_TYPES = {
    CALM = "calm",
    FIGHT = "fight",
    RETREAT = "retreat"
}

-- Scene objects reference
local sceneObjects = {}

function M.initialize(objects)
    sceneObjects = objects
end

-- Generic evaluation function
-- Checks if sceneObjects.playerChoice matches the conditionType
function M.evaluate(conditionType)
    if sceneObjects.playerChoice == conditionType then
        print(M.CONDITION_NAME .. " condition: " .. conditionType .. " - TRUE")
        return true
    else
        print(M.CONDITION_NAME .. " condition: " .. conditionType .. " - FALSE")
        return false
    end
end

-- Generate condition wrappers for each condition type
-- Returns a table of conditions that can be registered in the controller
function M.generateConditions()
    local conditionWrappers = {}

    for _, conditionType in pairs(M.CONDITION_TYPES) do
        local conditionName = M.CONDITION_NAME .. " " .. conditionType
        conditionWrappers[conditionName] = {
            initialize = M.initialize,
            evaluate = function()
                return M.evaluate(conditionType)
            end
        }
    end

    return conditionWrappers
end

-- Factory function to create a customized player choice condition
-- Usage: local myChoice = BasePlayerChoiceCondition.create("custom choice", {...})
function M.create(conditionName, conditionTypes)
    local instance = {}
    for k, v in pairs(M) do
        instance[k] = v
    end

    if conditionName then
        instance.CONDITION_NAME = conditionName
    end

    if conditionTypes then
        instance.CONDITION_TYPES = conditionTypes
    end

    return instance
end

return M
