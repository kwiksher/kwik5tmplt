-- Consolidated Player Choice Conditions
-- Contains all player choice conditions (calm, fight, retreat) in one file
-- These are mutually exclusive choices that happen at the same time

local M = {}

M.CONDITION_NAME = "player choice"

-- Condition types
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

-- Calm condition: checks if player chose the calm option
function M.evaluate_calm()
    -- Check if player choice is calm
    if sceneObjects.playerChoice == "calm" then
        print("Player choice condition: calm - TRUE")
        return true
    else
        print("Player choice condition: calm - FALSE")
        return false
    end
end

-- Fight condition: checks if player chose the fight option
function M.evaluate_fight()
    -- Check if player choice is fight
    if sceneObjects.playerChoice == "fight" then
        print("Player choice condition: fight - TRUE")
        return true
    else
        print("Player choice condition: fight - FALSE")
        return false
    end
end

-- Retreat condition: checks if player chose the retreat option
function M.evaluate_retreat()
    -- Check if player choice is retreat
    if sceneObjects.playerChoice == "retreat" then
        print("Player choice condition: retreat - TRUE")
        return true
    else
        print("Player choice condition: retreat - FALSE")
        return false
    end
end

function M.evaluate(conditionType)
    local functionName = "evaluate_" .. conditionType
    if M[functionName] then
        return M[functionName]()
    else
        print("Player choice condition: Unknown condition type - " .. tostring(conditionType))
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

return M