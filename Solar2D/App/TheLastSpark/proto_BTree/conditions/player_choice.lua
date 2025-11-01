-- Consolidated Player Choice Conditions
-- Contains all player choice conditions (calm, fight, retreat) in one file
-- These are mutually exclusive choices that happen at the same time

local M = {}

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

-- Generic evaluate function that can handle all three conditions
-- This maintains backward compatibility with the existing BTree system
function M.evaluate(conditionType)
    if conditionType == "calm" then
        return M.evaluate_calm()
    elseif conditionType == "fight" then
        return M.evaluate_fight()
    elseif conditionType == "retreat" then
        return M.evaluate_retreat()
    else
        print("Player choice condition: Unknown condition type - " .. tostring(conditionType))
        return false
    end
end

return M