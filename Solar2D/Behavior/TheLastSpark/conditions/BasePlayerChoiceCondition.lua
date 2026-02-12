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
    local instance = {
        CONDITION_NAME = conditionName or M.CONDITION_NAME,
        CONDITION_TYPES = conditionTypes or M.CONDITION_TYPES
    }

    -- Copy the initialize and evaluate functions
    instance.initialize = M.initialize
    instance.evaluate = M.evaluate

    -- Create a custom generateConditions function that uses the instance's values
    instance.generateConditions = function()
        local conditionWrappers = {}

        for _, conditionType in pairs(instance.CONDITION_TYPES) do
            local fullConditionName = instance.CONDITION_NAME .. " " .. conditionType
            conditionWrappers[fullConditionName] = {
                initialize = instance.initialize,
                evaluate = function()
                    return instance.evaluate(conditionType)
                end
            }
        end

        return conditionWrappers
    end

    return instance
end

return M
